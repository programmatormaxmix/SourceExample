unit SocketStreamJSON;

{$I EntitySystemOpt.inc}

interface

uses

  Windows,
  SysUtils,
  Classes,
  EntityChannelUnit,
  SuperObject;

type

  TCRC64Array = array [Byte] of Int64;

  TSocketStreamJSONRPC = class (TSocketStreamFullDuplex)
  private
    FHeader: TStringList;
    FMaxContentLength: Cardinal;
    FStream: TMemoryStream;
    FRequest: AnsiString;
    FResponce: AnsiString;
    FJSONRequest: ISuperObject;
    FJSONResponce: ISuperObject;
  protected
    function GetHttpHeader(Socket: TChannel; Header: TStrings): Boolean;
    function GetHttpStream(Socket: TChannel; Header: TStrings; Stream: TMemoryStream; var Content: AnsiString): Boolean;
    function SetHttpError(Socket: TChannel; Header: TStrings; Error: Cardinal; Desc: AnsiString): Boolean;
  protected
    function DoInitializeSocket(var Error: Integer): Boolean; override;
    function DoDeinitializeSocket(var Error: Integer): Boolean; override;
    function DoActivateSocket(var Error: Integer): Boolean; override;
    procedure OnConnectSocket(Socket: TChannel); override;
    procedure OnDisconnectSocket(Socket: TChannel); override;
    procedure OnSelectSocket(Socket: TChannel); override;
  protected
    function RemoteProcedureCall(Request: ISuperObject; Responce: ISuperObject): Boolean;
  end;

procedure CRC64Init(var CRC64Array: TCRC64Array; Polynom: UInt64);
function CRC64Calc(const Data; const Count: Cardinal; var CRC64Array: TCRC64Array): Int64;

implementation

//42F0E1EBA9EA3693 (ECMA DLT)
//42F0E1EBA9EA3693 (ECMA DLT).
//000000000000001B (ISO 3309)
procedure CRC64Init(var CRC64Array: TCRC64Array; Polynom: UInt64);
var I,J: Byte;
    D: Int64;
begin
  for I:=0 to 255 do
  begin
    D:=I;
    for J:= 1 to 8 do
    begin
      if Odd(D)=True then D:=D shr 1 xor Polynom else D:=D shr 1;
    end;
    CRC64Array[I]:=D;
  end;
end;

procedure CRC64Append(const Data; const Count: Cardinal; var CRC64Array: TCRC64Array; var CRC64: Int64);
var MyCRC64: Int64; I: Cardinal; PData: ^Byte;
begin
  PData:=@Data;
  MyCRC64:=CRC64;
  for I:= 1 to Count do
  begin
    MyCRC64 := MyCRC64 shr 8 xor CRC64Array[Cardinal(MyCRC64) and $FF xor PData^];
    Inc(PData);
  end;
  CRC64:=MyCRC64;
end;

function CRC64Calc(const Data; const Count: Cardinal; var CRC64Array: TCRC64Array): Int64;
begin
  Result:=not 0;
  CRC64Append(Data,Count,CRC64Array,Result);
end;

//Принять заголовок Http
function TSocketStreamJSONRPC.GetHttpHeader(Socket: TChannel; Header: TStrings): Boolean;
var Str: AnsiString;
    Sym: AnsiChar;
    CR: Cardinal;
    LF: Cardinal;
    Res: Integer;
begin
  Result:=False;
  if (Assigned(Socket)=True) and (Assigned(Header)=True) then
  begin
    Res:=Socket.RecvBuf(@Sym,1);
    if Res>0 then
    begin
      Str:='';
      CR:=0;
      LF:=0;
      Header.Clear;
      Header.NameValueSeparator:=':';
      while Res>0 do
      begin
        if (Sym<>#13) and (Sym<>#10) then
        begin
          Str:=Str+Sym;
          CR:=0;
          LF:=0;
        end
        else
        begin
          if (Sym=#$0D) then CR:=CR+1;
          if (Sym=#$0A) then LF:=LF+1;
          if Length(Str)>0 then
          begin
            Header.Add(Str);
            Str:='';
          end;
          if ((CR>=2) and (LF>=2)) or ((CR>=2) and (LF=0)) or ((CR=0) and (LF>=2)) then
          begin
            Result:=True;
            Exit;
          end;
        end;
        Res:=Socket.RecvBuf(@Sym,1,5000,2500,1);
      end;
    end;
  end;
end;

//Принять вложение Http
function TSocketStreamJSONRPC.GetHttpStream(Socket: TChannel; Header: TStrings; Stream: TMemoryStream; var Content: AnsiString): Boolean;
var Len: Integer;
begin
  Result:=False;
  if (Assigned(Socket)=True) and (Assigned(Header)=True) then
  begin
    if Header.IndexOfName('Content-Length')<>-1 then
    begin
      Len:=StrToInt(Trim(Header.Values['Content-Length']));
      if Stream<>nil then
      begin
        Stream.SetSize(Len);
        Stream.Position:=0;
        if Socket.RecvBuf(Stream.Memory,Len,5000,2500,1)=Len then Result:=True;
      end
      else
      begin
        Content:='';
        SetLength(Content,StrToInt(Trim(Header.Values['Content-Length'])));
        if Socket.RecvBuf(@Content[1],Len,5000,2500,1)=Len then Result:=True;
      end;
    end;
  end;
end;

//Отправить сообщение об ошибке
function TSocketStreamJSONRPC.SetHttpError(Socket: TChannel; Header: TStrings; Error: Cardinal; Desc: AnsiString): Boolean;
var Html: AnsiString;
    Caption: AnsiString;
begin
  Result:=False;
  if (Assigned(Socket)=True) and (Assigned(Header)=True) and (Header.Count>0) then
  begin
    case Error of
      200: Caption:='OK';
      202: Caption:='Accepted';
      204: Caption:='No Content';
      205: Caption:='Reset Content';
      206: Caption:='Partial Content';
      301: Caption:='Moved Permanently';
      303: Caption:='See Other';
      304: Caption:='Not Modified';
      400: Caption:='Bad Request';
      401: Caption:='Unauthorized';
      403: Caption:='Forbidden';
      405: Caption:='Method Not Allowed';
      409: Caption:='Conflict';
      501: Caption:='Not Implemented';
      503: Caption:='Service Unavailable';
    else
      Caption:='Unknown error';
    end;
    if Desc<>'' then
    begin
      Html:='<html><head><title>Error '+IntToStr(Error)+'</title></head><body bgcolor="white"><center><h1>'+Trim(Desc)+'</h1></center><hr><center>'+ClassName+'</center></body></html>';
    end
    else
    begin
      Html:='<html><head><title>Error '+IntToStr(Error)+'</title></head><body bgcolor="white"><center><h1>'+Trim(Caption)+'</h1></center><hr><center>'+ClassName+'</center></body></html>';
    end;
    if pos('HTTP/1.1',Header.Strings[0])>0 then
    begin
      Socket.SendCmd('HTTP/1.1 '+IntToStr(Error)+' '+Trim(Caption));
      Socket.SendCmd('Server: '+ClassName);
      Socket.SendCmd('Content-Length: '+IntToStr(Length(Html)));
      Socket.SendCmd('Content-Language: ru');
      Socket.SendCmd('Content-Type: text/html');
      if FHeader.IndexOfName('Connection')<>-1 then
      begin
        Socket.SendCmd('Connection: '+Trim(FHeader.Values['Connection'])+#13#10);
        if Socket.SendStr(Html,5000,2500,1)=Length(Html) then Result:=True;
        if LowerCase(Trim(FHeader.Values['Connection']))='close' then Socket.Shutdown(0);
      end
      else
      begin
        Socket.SendCmd(''#13#10);
        if Socket.SendStr(Html,5000,2500,1)=Length(Html) then Result:=True;
      end;
    end
    else
    begin
      if pos('HTTP/1.0',Header.Strings[0])>0 then
      begin
        Socket.SendCmd('HTTP/1.0 '+IntToStr(Error)+' '+Trim(Caption));
        Socket.SendCmd('Server: '+ClassName);
        Socket.SendCmd('Content-Length: '+IntToStr(Length(Html)));
        Socket.SendCmd('Content-Language: ru');
        Socket.SendCmd('Content-Type: text/html');
        if FHeader.IndexOfName('Connection')<>-1 then
        begin
          Socket.SendCmd('Connection: '+Trim(FHeader.Values['Connection'])+#13#10);
          if Socket.SendStr(Html,5000,2500,1)=Length(Html) then Result:=True;
          if LowerCase(Trim(FHeader.Values['Connection']))='close' then Socket.Shutdown(0);
        end
        else
        begin
          Socket.SendCmd('Connection: close'+#13#10);
          if Socket.SendStr(Html,5000,2500,1)=Length(Html) then Result:=True;
          Socket.Shutdown(0);
        end;
      end
      else
      begin
        Socket.SendCmd('HTTP/1.0 '+IntToStr(Error)+' '+Trim(Caption));
        Socket.SendCmd('Server: '+ClassName);
        Socket.SendCmd('Content-Length: '+IntToStr(Length(Html)));
        Socket.SendCmd('Content-Language: ru');
        Socket.SendCmd('Content-Type: text/html');
        Socket.SendCmd('Connection: close'+#13#10);
        if Socket.SendStr(Html,5000,2500,1)=Length(Html) then Result:=True;
        Socket.Shutdown(0);
      end;
    end;
  end;
end;

//Инициализация сокета
function TSocketStreamJSONRPC.DoInitializeSocket(var Error: Integer): Boolean;
begin
  FMaxContentLength:=65536;
  FRequest:='';
  FResponce:='';
  FHeader:=TStringList.Create;
  FStream:=TMemoryStream.Create;
  FJSONRequest:=nil;
  FJSONResponce:=nil;
  Result:=inherited DoInitializeSocket(Error);
end;

//Деинициализация сокета
function TSocketStreamJSONRPC.DoDeinitializeSocket(var Error: Integer): Boolean;
begin
  FJSONRequest:=nil;
  FJSONResponce:=nil;
  FHeader.Destroy;
  FHeader:=nil;
  FStream.Destroy;
  FStream:=nil;
  Result:=inherited DoDeinitializeSocket(Error);
end;

//Активация сокета
function TSocketStreamJSONRPC.DoActivateSocket(var Error: Integer): Boolean;
begin
  if FMaxContentLength>0 then
  begin
    Result:=inherited DoActivateSocket(Error);
  end
  else
  begin
    Result:=False;
  end;
end;

procedure TSocketStreamJSONRPC.OnConnectSocket(Socket: TChannel);
begin
  writeln('connect: '+Socket.Peer);
end;

procedure TSocketStreamJSONRPC.OnDisconnectSocket(Socket: TChannel);
begin
  writeln('disconnect: '+Socket.Peer);
end;

procedure TSocketStreamJSONRPC.OnSelectSocket(Socket: TChannel);
begin
  if GetHttpHeader(Socket,FHeader)=True then
  begin
    if FHeader.IndexOfName('Content-Type')<>-1 then
    begin
      if FHeader.IndexOfName('Content-Length')<>-1 then
      begin
        if pos('application/json',LowerCase(Trim(FHeader.Values['Content-Type'])))>0 then
        begin
          if StrToInt(Trim(FHeader.Values['Content-Length']))>0 then
          begin
            if StrToInt(Trim(FHeader.Values['Content-Length']))<FMaxContentLength then
            begin
              if GetHttpStream(Socket,FHeader,nil,FRequest)=True then
              begin
                if FRequest<>'' then
                begin
                  try
                    FJSONRequest:=TSuperObject.ParseString(@WideString(FRequest)[1],False);
                    FJSONResponce:=TSuperObject.ParseString('{}',False);
                    try
                      if RemoteProcedureCall(FJSONRequest, FJSONResponce)=True then
                      begin
                        Socket.SendCmd('HTTP/1.1 200 OK');
                        Socket.SendCmd('Server: '+ClassName);
                        Socket.SendCmd('Content-Length: '+IntToStr(Length(FJSONResponce.AsJSon)));
                        Socket.SendCmd('Content-Type: application/json');
                        Socket.SendCmd('Connection: Keep-Alive'#13#10);
                        Socket.SendStr(FJSONResponce.AsJSon,5000,2500,1);
                      end
                      else
                      begin
                        SetHttpError(Socket,FHeader,503,'No response');
                      end;
                    except
                      SetHttpError(Socket,FHeader,503,'Invalid JSON responce');
                    end;
                  except
                    SetHttpError(Socket,FHeader,503,'Invalid JSON request');
                  end;
                end
                else
                begin
                  SetHttpError(Socket,FHeader,503,'No request');
                end;
              end
              else
              begin
                SetHttpError(Socket,FHeader,400,'Content not sent by client');
              end;
            end
            else
            begin
              SetHttpError(Socket,FHeader,400,'Content too big');
            end;
          end
          else
          begin
            SetHttpError(Socket,FHeader,400,'Invalid content length');
          end;
        end
        else
        begin
          SetHttpError(Socket,FHeader,400,'Content ['+Trim(FHeader.Values['Content-Type'])+'] not supported you need to use content [application/json]');
        end;
      end
      else
      begin
        SetHttpError(Socket,FHeader,400,'Parameter [Content-Length] not found');
      end;
    end
    else
    begin
      SetHttpError(Socket,FHeader,400,'Parameter [Content-Type] not found');
    end;
  end;
end;

//Здесь удаленные процедуры
function TSocketStreamJSONRPC.RemoteProcedureCall(Request: ISuperObject; Responce: ISuperObject): Boolean;
begin
  Responce.S['name']:='Hello';
  Result:=True;
end;

initialization

  Classes.RegisterClass(TSocketStreamJSONRPC);

end.

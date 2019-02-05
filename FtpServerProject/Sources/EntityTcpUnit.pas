unit EntityTcpUnit;

interface

{$I EntitySystemOpt.inc}

uses

  SysUtils,
  Classes,
  EntitySocketApi,
  EntityChannelUnit;

type

  TChannelTcpStreamFullDuplex = class (TChannelStreamFullDuplex)
  private
    FhSocket: Integer;
    FHost: AnsiString;
    FPort: Word;
    FSockAddrIn: TSockAddrIn;
    procedure SetHost(Val: AnsiString);
    procedure SetPort(Val: Word);
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoActivateChannel(var Error: Integer): Boolean; override;
    function DoDeactivateChannel(var Error: Integer): Boolean; override;
    function DoPeerChannel(var Peer: AnsiString): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  public
    property Host: AnsiString read FHost write SetHost;
    property Port: Word read FPort write SetPort;
  end;

  TMultilinkTcpChild = class (TChannelStreamFullDuplex)
  private
    FhSocket: Integer;
    procedure SetSocketHandle(Val: Integer);
    function GetLocalAddress: string;
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoActivateChannel(var Error: Integer): Boolean; override;
    function DoDeactivateChannel(var Error: Integer): Boolean; override;
    function DoPeerChannel(var Peer: AnsiString): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  public
    property hSocket: Integer read FhSocket write SetSocketHandle;
    property LocalAddress: AnsiString read GetLocalAddress;
  end;

  TMultilinkTcpStreamFullDuplex = class (TMultilink)
  private
    FPort: Word;
    FhSocket: Integer;
    FhAcceptSocket: Integer;
    FSockAddrIn: TSockAddrIn;
    FSockAddrInA: TSockAddrIn;
    FError: Integer;
    FChild: TMultilinkTcpChild;
    procedure SetPort(Port: Word);
  protected
    function DoInitializeMultilink(var Error: Integer): Boolean; override;
    function DoActivateMultilink(var Error: Integer): Boolean; override;
    function DoDeactivateMultilink(var Error: Integer): Boolean; override;
    procedure OnSelectMultilink(Socket: TChannel); override;
  public
    property Port: Word read FPort write SetPort;
  end;

implementation

//------------------------------------------------------------------------------
// {TChannelTcpStreamFullDuplex}
//------------------------------------------------------------------------------

//Инициализация
function TChannelTcpStreamFullDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  FhSocket:=0;
  FHost:='';
  FPort:=0;
  FillChar(FSockAddrIn,SizeOf(TSockAddrIn),0);
  Result:=inherited DoInitializeChannel(Error);
end;

//Активировать канал
function TChannelTcpStreamFullDuplex.DoActivateChannel(var Error: Integer): Boolean;
begin
  Result:=False;
  if (Length(FHost)>0) and (FPort>0) and (ESASocketAddrFill(FSockAddrIn,FHost,FPort)=True) and (ESASocketCreate(FhSocket,Error)=True) then
  begin
    if ESASocketConnect(FhSocket,FSockAddrIn,Error)=True then
    begin
      if ESASocketUnblocking(FhSocket,Error)=True then
      begin
        Result:=True;
        Exit;
      end;
      ESASocketShutdown(FhSocket,Error);
    end;
    ESASocketClose(FhSocket,Error);
  end;
end;

//Деактивация канала
function TChannelTcpStreamFullDuplex.DoDeactivateChannel(var Error: Integer): Boolean;
begin
  if (ESASocketBlocking(FhSocket,Error)=True) and (ESASocketShutdown(FhSocket,Error)=True) and (ESASocketClose(FhSocket,Error)=True) then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Получить имя канала
function TChannelTcpStreamFullDuplex.DoPeerChannel(var Peer: AnsiString): Boolean;
begin
  Peer:=ESASocketInfo(FSockAddrIn);
  Result:=True;
end;

//Отправка данных
function TChannelTcpStreamFullDuplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=ESASocketSend(FhSocket,Buf,Len,Error);
end;

//Прием данных
function TChannelTcpStreamFullDuplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=ESASocketRecv(FhSocket,Buf,Len,Error);
end;

//Установить адрес
procedure TChannelTcpStreamFullDuplex.SetHost(Val: AnsiString);
begin
  if Active=False then FHost:=Trim(Val);
end;

//Принять установить порт
procedure TChannelTcpStreamFullDuplex.SetPort(Val: Word);
begin
  if Active=False then FPort:=Val;
end;

//------------------------------------------------------------------------------
// {TMultilinkTcpChild}
//------------------------------------------------------------------------------

//Инициализация
function TMultilinkTcpChild.DoInitializeChannel(var Error: Integer): Boolean;
begin
  FhSocket:=0;
  Result:=inherited DoInitializeChannel(Error);
end;

//Активация
function TMultilinkTcpChild.DoActivateChannel(var Error: Integer): Boolean;
var n: Integer;
begin
  Result:=False;
  if FhSocket<>0 then
  begin
    if ESASocketUnblocking(FhSocket,Error)=True then
    begin
      Result:=True;
      Exit;
    end
    else
    begin
      ESASocketBlocking(FhSocket,Error);
      ESASocketShutdown(FhSocket,Error);
      ESASocketClose(FhSocket,Error);
    end;
  end;
end;

//Деактивация
function TMultilinkTcpChild.DoDeactivateChannel(var Error: Integer): Boolean;
begin
  if (ESASocketBlocking(FhSocket,Error)=True) and (ESASocketShutdown(FhSocket,Error)=True) and (ESASocketClose(FhSocket,Error)=True) then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Получить идентификатор
function TMultilinkTcpChild.DoPeerChannel(var Peer: AnsiString): Boolean;
var FSockAddrIn: TSockAddrIn;
    FError: Integer;
begin
  if ESASocketGetPeerName(FhSocket,FSockAddrIn,FError)=True then
  begin
    Peer:=ESASocketInfo(FSockAddrIn);
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Отправка данных
function TMultilinkTcpChild.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=ESASocketSend(FhSocket,Buf,Len,Error);
end;

//Прием данных
function TMultilinkTcpChild.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=ESASocketRecv(FhSocket,Buf,Len,Error);
end;

//Принять установить порт
procedure TMultilinkTcpChild.SetSocketHandle(Val: Integer);
begin
  if Active=False then FhSocket:=Val;
end;

//Получить локальный адрес
function TMultilinkTcpChild.GetLocalAddress: AnsiString;
begin
  Result:=ESASocketGetLocalIP(FhSocket);
end;

//------------------------------------------------------------------------------
// {TMultilinkTcpStreamFullDuplex}
//------------------------------------------------------------------------------

//Установить порт
procedure TMultilinkTcpStreamFullDuplex.SetPort(Port: Word);
begin
  if Active=False then FPort:=Port;
end;

//Инициализация сервера
function TMultilinkTcpStreamFullDuplex.DoInitializeMultilink(var Error: Integer): Boolean;
begin
  FPort:=0;
  FhSocket:=0;
  FhAcceptSocket:=0;
  FillChar(FSockAddrIn,SizeOf(TSockAddrIn),0);
  FillChar(FSockAddrInA,SizeOf(TSockAddrIn),0);
  FError:=0;
  FChild:=nil;
  Result:=True;
end;

//Активация
function TMultilinkTcpStreamFullDuplex.DoActivateMultilink(var Error: Integer): Boolean;
begin
  Result:=False;
  if (FPort>0) and (ESASocketAddrFill(FSockAddrIn,'',FPort)=True) then
  begin
    if ESASocketCreate(FhSocket,Error)=True then
    begin
      if ESASocketBind(FhSocket,FSockAddrIn,Error)=True then
      begin
        if ESASocketListen(FhSocket,Error)=True then
        begin
          if ESASocketUnblocking(FhSocket,Error)=True then
          begin
            Result:=True;
            Exit;
          end;
        end;
      end;
      ESASocketClose(FhSocket,Error);
    end;
  end;
end;

//Деактивация
function TMultilinkTcpStreamFullDuplex.DoDeactivateMultilink(var Error: Integer): Boolean;
begin
  if (ESASocketBlocking(FhSocket,Error)=True) and (ESASocketClose(FhSocket,Error)=True) then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Создание новых каналов
procedure TMultilinkTcpStreamFullDuplex.OnSelectMultilink(Socket: TChannel);
begin
  while ESASocketAccept(FhSocket,FSockAddrInA,FhAcceptSocket,FError)=True do
  begin
    FChild:=TMultilinkTcpChild.Create(Self);
    FChild.KeepAliveTimeOut:=KeepAliveChild;
    FChild.hSocket:=FhAcceptSocket;
    FChild.Active:=True;
    if ApiRegisterChild(Socket,FChild)=False then
    begin
      if FChild.Active=True then
      begin
        FChild.Destroy;
        FChild:=nil;
      end
      else
      begin
        FChild.Destroy;
        FChild:=nil;
        ESASocketBlocking(FhAcceptSocket,FError);
        ESASocketShutdown(FhAcceptSocket,FError);
        ESASocketClose(FhAcceptSocket,FError);
      end;
    end;
  end;
end;

initialization

  Classes.RegisterClass(TChannelTcpStreamFullDuplex);
  Classes.RegisterClass(TMultilinkTcpChild);
  Classes.RegisterClass(TMultilinkTcpStreamFullDuplex);

end.

unit SocketFtpStreamFullDuplex;

{$i EntitySystemOpt.inc}

interface

{
1. В команде LIST полный путь до директории не поддерживается  + al (возможно сделал)
2. Подержка UTF8 не работает
3. Поработать над STOR и RETR стабильность от креша
4. Файлы больше 4 гигабайт не принимает
}

uses

  Windows,
  SysUtils,
  Classes,
  EntityChannelUnit,
  EntityTcpUnit;

type

//------------------------------------------------------------------------------
// {TSocketFtpStreamFullDuplex}
//------------------------------------------------------------------------------

  TSocketFtpStreamFullDuplex = class (TSocketStreamFullDuplex)
  private
    FSession: array of Byte;
    FMultilink: TMultilinkTcpStreamFullDuplex;
    FFtpClient: TChannel;
    FCommand: AnsiString;
    FStrings: TStrings;
    FLen: Integer;
    FBuffer: array [0..8192] of Byte;
    function GetCmd(var Cmd: AnsiString; Strings: TStrings): Boolean;
 protected
    procedure OnConnectSocket(Socket: TChannel); override;
    procedure OnDisconnectSocket(Socket: TChannel); override;
    procedure OnSelectSocket(Socket: TChannel); override;
 protected
    function DoWelcome: AnsiString; virtual;
    function DoUser(User: AnsiString): Boolean; virtual;
    function DoPass(Password: AnsiString): Boolean; virtual;
    function DoSyst(var Syst: AnsiString): Boolean; virtual;
    function DoPwd(var Pwd: AnsiString): Boolean; virtual;
    function DoCwd(Cwd: AnsiString): Boolean; virtual;
    function DoType(Val: AnsiString): Boolean; virtual;
    function DoMkd(Val: AnsiString): Boolean; virtual;
    function DoRmd(Val: AnsiString): Boolean; virtual;
    function DoList(var Val: AnsiString): Boolean; virtual;
    function DoStorStartup(FileName: AnsiString): Boolean; virtual;
    function DoStorProcess(Buf: Pointer; Len: Cardinal): Cardinal; virtual;
    function DoStorCleanup: Boolean; virtual;
    function DoRetrStartup(FileName: AnsiString): Boolean; virtual;
    function DoRetrProcess(Buf: Pointer; Len: Cardinal): Cardinal; virtual;
    function DoRetrCleanup: Boolean; virtual;
    function DoDele(FileName: AnsiString): Boolean; virtual;
    function DoSize(FileName: AnsiString; var sSize: AnsiString): Boolean; virtual;
    function DoRnfr(FileName: AnsiString): Boolean; virtual;
    function DoRnto(FileName: AnsiString): Boolean; virtual;
    function DoOpts(Val: AnsiString): Boolean; virtual;
  end;

//------------------------------------------------------------------------------
// {TFtpStreamFullDuplex}
//------------------------------------------------------------------------------

  TFtpStreamFullDuplex = class (TSocketFtpStreamFullDuplex)
  private
    FUser: AnsiString;
    FStream: TFileStream;
    FPassword: AnsiString;
    FRNFRDir: Boolean;
    FRNFRFile: AnsiString;
    FRNTOFile: AnsiString;
    FRoot: AnsiString;
    FDir: AnsiString;
    function FileTimeToUnixString(FileTime: Integer): AnsiString;
  protected
    function DoUser(User: AnsiString): Boolean; override;
    function DoPass(Password: AnsiString): Boolean; override;
    function DoPwd(var Pwd: AnsiString): Boolean; override;
    function DoCwd(Cwd: AnsiString): Boolean; override;
    function DoList(var Val: AnsiString): Boolean; override;
    function DoMkd(Val: AnsiString): Boolean; override;
    function DoRmd(Val: AnsiString): Boolean; override;
    function DoStorStartup(FileName: AnsiString): Boolean; override;
    function DoStorProcess(Buf: Pointer; Len: Cardinal): Cardinal; override;
    function DoStorCleanup: Boolean; override;
    function DoRetrStartup(FileName: AnsiString): Boolean; override;
    function DoRetrProcess(Buf: Pointer; Len: Cardinal): Cardinal; override;
    function DoRetrCleanup: Boolean; override;
    function DoDele(FileName: AnsiString): Boolean; override;
    function DoSize(FileName: AnsiString; var sSize: AnsiString): Boolean; override;
    function DoRnfr(FileName: AnsiString): Boolean; override;
    function DoRnto(FileName: AnsiString): Boolean; override;
    function DoOpts(Val: AnsiString): Boolean; override;
  end;

implementation

//------------------------------------------------------------------------------
// {TSocketFtpStreamFullDuplex}
//------------------------------------------------------------------------------

//Получить индекс значения
function TSocketFtpStreamFullDuplex.GetCmd(var Cmd: AnsiString; Strings: TStrings): Boolean;
var n: Integer;
    Val: AnsiString;
    Del: AnsiChar;
begin
  Result:=False;
  if (Cmd<>'') and (Strings<>nil) then
  begin
    Del:=' ';
    Val:='';
    Strings.Clear;
    for n:=1 to Length(Cmd) do
    begin
      if Cmd[n]<>Del then
      begin
        Val:=Val+Cmd[n];
      end
      else
      begin
        if Val<>'' then
        begin
          Strings.Add(Trim(Val));
          Val:='';
          Del:=#0;
        end;
      end;
    end;
    if Val<>'' then
    begin
      Strings.Add(Trim(Val));
      Val:='';
    end;
    if Strings.Count>0 then Result:=True;
  end;
end;

//Строка приветствия
function TSocketFtpStreamFullDuplex.DoWelcome: AnsiString;
begin
  Result:='Welcome to ftp server';
end;

//Проверка наличия пользователя
function TSocketFtpStreamFullDuplex.DoUser(User: AnsiString): Boolean;
begin
  Result:=True;
end;

//Проверка наличия пароля
function TSocketFtpStreamFullDuplex.DoPass(Password: AnsiString): Boolean;
begin
  Result:=True;
end;

//Запрос операционной системы
function TSocketFtpStreamFullDuplex.DoSyst(var Syst: AnsiString): Boolean;
begin
  Syst:='UNIX emulated by MaxMix';
  Result:=True;
end;

//Получить текушую директорию
function TSocketFtpStreamFullDuplex.DoPwd(var Pwd: AnsiString): Boolean;
begin
  Pwd:='/';
  Result:=True;
end;

//Установить текущую директорию
function TSocketFtpStreamFullDuplex.DoCwd(Cwd: AnsiString): Boolean;
begin
  Result:=True;
end;

//Установить тип
function TSocketFtpStreamFullDuplex.DoType(Val: AnsiString): Boolean;
begin
  Result:=True;
end;

//Создать директорию
function TSocketFtpStreamFullDuplex.DoMkd(Val: AnsiString): Boolean;
begin
  Result:=True;
end;

//Удалить директорию
function TSocketFtpStreamFullDuplex.DoRmd(Val: AnsiString): Boolean;
begin
  Result:=True;
end;

//Список
function TSocketFtpStreamFullDuplex.DoList(var Val: AnsiString): Boolean;
begin
  Val:='';
  Result:=True;
end;

function TSocketFtpStreamFullDuplex.DoStorStartup(FileName: AnsiString): Boolean;
begin
  Result:=False;
end;

function TSocketFtpStreamFullDuplex.DoStorProcess(Buf: Pointer; Len: Cardinal): Cardinal;
begin
  Result:=0;
end;

function TSocketFtpStreamFullDuplex.DoStorCleanup: Boolean;
begin
  Result:=False;
end;

function TSocketFtpStreamFullDuplex.DoRetrStartup(FileName: AnsiString): Boolean;
begin
  Result:=False;
end;

function TSocketFtpStreamFullDuplex.DoRetrProcess(Buf: Pointer; Len: Cardinal): Cardinal;
begin
  Result:=0;
end;

function TSocketFtpStreamFullDuplex.DoRetrCleanup: Boolean;
begin
  Result:=False;
end;

//Удаление файлов
function TSocketFtpStreamFullDuplex.DoDele(FileName: AnsiString): Boolean;
begin
  Result:=False;
end;

function TSocketFtpStreamFullDuplex.DoSize(FileName: AnsiString; var sSize: AnsiString): Boolean;
begin
  Result:=False;
end;

function TSocketFtpStreamFullDuplex.DoRnfr(FileName: AnsiString): Boolean;
begin
  Result:=False;
end;

function TSocketFtpStreamFullDuplex.DoRnto(FileName: AnsiString): Boolean;
begin
  Result:=False;
end;

function TSocketFtpStreamFullDuplex.DoOpts(Val: AnsiString): Boolean;
begin
  Result:=False;
end;

//Подключение клиента
procedure TSocketFtpStreamFullDuplex.OnConnectSocket(Socket: TChannel);
begin
  Socket.SendCmd('220 '+DoWelcome);
  FMultilink:=TMultilinkTcpStreamFullDuplex.Create(nil);
  FFtpClient:=nil;
  FStrings:=TStringList.Create;
  writeln('Connect: '+Socket.Peer);
end;

//Отключение клиента
procedure TSocketFtpStreamFullDuplex.OnDisconnectSocket(Socket: TChannel);
begin
  writeln('Disconnect: '+Socket.Peer);
  FStrings.Destroy;
  FStrings:=nil;
  if FFtpClient<>nil then
  begin
    FFtpClient.Shutdown(0);
    FFtpClient.Destroy;
    FFtpClient:=nil;
  end;
  if FMultilink<>nil then
  begin
    FMultilink.Destroy;
    FMultilink:=nil;
  end;
end;

//Обработка запросов от клиента
procedure TSocketFtpStreamFullDuplex.OnSelectSocket(Socket: TChannel);
begin
  if (Socket.RecvCmd(FCommand)>0) and (GetCmd(FCommand,FStrings)=True) then
  begin
    writeln(FCommand);

    if UpperCase(FStrings.Strings[0])='USER' then
    begin
      if (FStrings.Count=2) and (DoUser(FStrings.Strings[1])=True) then
      begin
        Socket.SendCmd('331 Password requied');
        Exit;
      end
      else
      begin
        Socket.SendCmd('530 Login incorrect');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='PASS' then
    begin
      if (FStrings.Count=2) and (DoPass(FStrings.Strings[1])=True) then
      begin
        Socket.SendCmd('230 Logging on');
        Exit;
      end
      else
      begin
        Socket.SendCmd('530 Password incorrect');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='SYST' then
    begin
      if FStrings.Count=1 then
      begin
        if DoSyst(FCommand)=True then Socket.SendCmd('215 '+FCommand) else Socket.SendCmd('500 Invalid command');
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='OPTS' then
    begin
      if FStrings.Count=2 then
      begin
        if DoOpts(FStrings.Strings[1])=True then
        begin
          Socket.SendCmd('200 Option changed');
        end
        else
        begin
          Socket.SendCmd('500 Unknow options "'+FStrings.Strings[1]+'"');
        end;
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='NOOP' then
    begin
      Socket.SendCmd('200 OK');
      Exit;
    end;

    if UpperCase(FStrings.Strings[0])='PWD' then
    begin
      if FStrings.Count=1 then
      begin
        if DoPwd(FCommand)=True then Socket.SendCmd('257 "'+FCommand+'" is current directory') else Socket.SendCmd('500 Invalid command');
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='CWD' then
    begin
      if FStrings.Count=2 then
      begin
        if DoCwd(FStrings.Strings[1])=True then Socket.SendCmd('250 CWD successful. "'+FStrings.Strings[1]+'" is current directory.') else Socket.SendCmd('550 Invalid directory "'+FStrings.Strings[1]+'"');
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='CDUP' then
    begin
      if FStrings.Count=1 then
      begin
        if DoCwd('..')=True then Socket.SendCmd('250 command successful') else Socket.SendCmd('550 Invalid directory');
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='HELP' then
    begin
      if FStrings.Count=1 then
      begin
        Socket.SendCmd('214-The following commands are recognized (*unimplemented):');
        Socket.SendCmd('CWD     XCWD*   CDUP    XCUP*   SMNT*   QUIT    PORT*   PASV');
        Socket.SendCmd('EPRT*   EPSV*   ALLO*   RNFR    RNTO    DELE    MDTM*   RMD');
        Socket.SendCmd('XRMD*   MKD     XMKD*   PWD     XPWD*   SIZE    SYST    HELP');
        Socket.SendCmd('NOOP    FEAT    OPTS    AUTH    CCC*    CONF*   ENC*    MIC*');
        Socket.SendCmd('PBSZ*   PROT*   TYPE    STRU*   MODE*   RETR    STOR    STOU*');
        Socket.SendCmd('APPE*   REST*   ABOR*   USER    PASS    ACCT*   REIN*   LIST');
        Socket.SendCmd('NLST*   STAT*   SITE*   MLSD*   MLST*');
        Socket.SendCmd('214 have a nice day');
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='FEAT' then
    begin
      Socket.SendCmd('211-Features:');
      Socket.SendCmd('SIZE');
      Socket.SendCmd('211 End');
      Exit;
    end;

    if UpperCase(FStrings.Strings[0])='TYPE' then
    begin
      if FStrings.Count=2 then
      begin
        if DoType(FStrings.Strings[1])=True then Socket.SendCmd('200 Type set to '+FStrings.Strings[1]) else Socket.SendCmd('501 Invalid type');
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='PASV' then
    begin
      if FStrings.Count=1 then
      begin
        Randomize;
        FMultilink.Active:=False;
        FMultilink.Port:=50000+Random(10000);
        FMultilink.Active:=True;
        if FMultilink.Active=True then
        begin
          Socket.SendCmd('227 Entering Passive Mode ('+StringReplace(TMultilinkTcpChild(Socket).LocalAddress,'.',',',[rfReplaceAll])+','+IntToStr(Trunc(FMultilink.Port/256))+','+IntToStr(FMultilink.Port-(Trunc(FMultilink.Port/256)*256))+')');
          Exit;
        end;
        Socket.SendCmd('500 Invalid port server');
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='MKD' then
    begin
      if FStrings.Count=2 then
      begin
        if DoMkd(FStrings.Strings[1])=True then
        begin
          Socket.SendCmd('257 "'+FStrings.Strings[1]+'" created successfully');
        end
        else
        begin
          Socket.SendCmd('550 Directory name not valid');
        end;
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='RMD' then
    begin
      if FStrings.Count=2 then
      begin
        if DoRmd(FStrings.Strings[1])=True then
        begin
          Socket.SendCmd('250 Directory deleted successfully');
        end
        else
        begin
          Socket.SendCmd('550 Directory name not valid');
        end;
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='LIST' then
    begin
      if FStrings.Count>=1 then
      begin
        while FMultilink.Accept(FFtpClient)=False do
        begin
          Sleep(1);
        end;
        Socket.SendCmd('150 Opening data channel for directory listing of "/"');
        if DoList(FCommand)=True then FFtpClient.SendStr(FCommand);
        Socket.SendCmd('226 Success transfered "/"');
        FFtpClient.Shutdown(0);
        FFtpClient.Destroy;
        FFtpClient:=nil;
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='STOR' then
    begin
      if FStrings.Count=2 then
      begin
        while FMultilink.Accept(FFtpClient)=False do
        begin
          Sleep(1);
        end;
        Socket.SendCmd('150 Opening data to transfer');
        DoStorStartup(FStrings.Strings[1]);
        FLen:=FFtpClient.RecvBuf(@FBuffer[0],8192,7000,1000,1);
        while FLen>0 do
        begin
          DoStorProcess(@FBuffer[0],FLen);
          FLen:=FFtpClient.RecvBuf(@FBuffer[0],8192,7000,1000,1);
        end;
        DoStorCleanup;
        Socket.SendCmd('226 Success transfered "/"');
        FFtpClient.Shutdown(0);
        FFtpClient.Destroy;
        FFtpClient:=nil;
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='RETR' then
    begin
      if FStrings.Count=2 then
      begin
        while FMultilink.Accept(FFtpClient)=False do
        begin
          Sleep(1);
        end;
        Socket.SendCmd('150 Opening data to transfer');
        DoRetrStartup(FStrings.Strings[1]);
        FLen:=DoRetrProcess(@FBuffer[0],8192);
        while FLen>0 do
        begin
          FFtpClient.SendBuf(@FBuffer[0],FLen,7000,1000,1);
          FLen:=DoRetrProcess(@FBuffer[0],8192);
        end;
        DoRetrCleanup;
        Socket.SendCmd('226 Success transfered "/"');
        FFtpClient.Shutdown(0);
        FFtpClient.Destroy;
        FFtpClient:=nil;
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='QUIT' then
    begin
      if FStrings.Count=1 then
      begin
        Socket.SendCmd('221 Goodbye');
        Sleep(1000);
        Socket.Shutdown(0);
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='DELE' then
    begin
      if FStrings.Count=2 then
      begin
        if DoDele(FStrings.Strings[1])=True then
        begin
          Socket.SendCmd('250 File deleted successfully');
        end
        else
        begin
          Socket.SendCmd('550 File name not valid');
        end;
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='SIZE' then
    begin
      if FStrings.Count=2 then
      begin
        if DoSize(FStrings.Strings[1],FCommand)=True then
        begin
          Socket.SendCmd('213 '+FCommand);
        end
        else
        begin
          Socket.SendCmd('550 File not found');
        end;
        Exit;
      end
      else
      begin
        Socket.SendCmd('501 syntax error');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='RNFR' then
    begin
      if FStrings.Count=2 then
      begin
        if DoRnfr(FStrings.Strings[1])=True then
        begin
          Socket.SendCmd('350 Exists and ready');
        end
        else
        begin
          Socket.SendCmd('550 Not found');
        end;
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    if UpperCase(FStrings.Strings[0])='RNTO' then
    begin
      if FStrings.Count=2 then
      begin
        if DoRnto(FStrings.Strings[1])=True then
        begin
          Socket.SendCmd('250 Renamed');
        end
        else
        begin
          Socket.SendCmd('450 Rename fault');
        end;
        Exit;
      end
      else
      begin
        Socket.SendCmd('500 Invalid command');
        Exit;
      end;
    end;

    Socket.SendCmd('500 Invalid command');

  end;
end;

//------------------------------------------------------------------------------
// {TFtpStreamFullDuplex}
//------------------------------------------------------------------------------

function TFtpStreamFullDuplex.FileTimeToUnixString(FileTime: Integer): AnsiString;
const
  Month: array [1..12] of AnsiString = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
var
  SysTime: _SYSTEMTIME;
begin
  DateTimeToSystemTime(FileDateToDateTime(FileTime),SysTime);
  Result:=Month[SysTime.wMonth]+' '+IntToStr(SysTime.wDay)+' '+format('%.2d',[SysTime.wHour])+':'+format('%.2d',[SysTime.wMinute]);
end;

function TFtpStreamFullDuplex.DoUser(User: AnsiString): Boolean;
begin
  FUser:=User;
  Result:=True;
end;

function TFtpStreamFullDuplex.DoPass(Password: AnsiString): Boolean;
begin
  FPassword:=Password;
  FDir:='';
  FRoot:=ExtractFilePath(paramstr(0))+'FtpRoot\'+FUser;
  FRNFRDir:=False;
  FRNFRFile:='';
  FRNTOFile:='';
  ForceDirectories(FRoot);
  Result:=True;
end;

function TFtpStreamFullDuplex.DoPwd(var Pwd: AnsiString): Boolean;
begin
  if FDir='' then
  begin
    Pwd:='/';
  end
  else
  begin
    Pwd:=StringReplace(FDir,'\','/',[rfReplaceAll]);
  end;
  Result:=True;
end;

function TFtpStreamFullDuplex.DoCwd(Cwd: AnsiString): Boolean;
var p: Integer;
begin
  Result:=False;
  if Cwd='..' then
  begin
    if FDir<>'' then
    begin
      p:=Pos('\',FDir);
      if p>0 then
      begin
        while Length(FDir)>0 do
        begin
          if FDir[Length(FDir)]<>'\' then Delete(FDir,Length(FDir),1) else Break;
        end;
        if (Length(FDir)>0) and (FDir[Length(FDir)]='\') then
        begin
          Delete(FDir,Length(FDir),1);
          Result:=True;
        end;
      end;
    end
    else
    begin
      FDir:='';
      Result:=True;
    end;
  end
  else
  begin
    if Cwd='.' then
    begin
      FDir:='';
      Result:=True;
    end
    else
    begin
      if Cwd='/' then
      begin
        FDir:='';
        Result:=True;
      end
      else
      begin
        if Pos('/',Cwd)=0 then
        begin
          if DirectoryExists(FRoot+FDir+'\'+Cwd)=True then
          begin
            FDir:=FDir+'\'+Cwd;
            Result:=True;
          end;
        end
        else
        begin
          if Cwd[1]='/' then
          begin
            if Cwd[Length(Cwd)]='/' then Delete(Cwd,Length(Cwd),1);
            if DirectoryExists(FRoot+StringReplace(Cwd,'/','\',[rfReplaceAll]))=True then
            begin
              FDir:=StringReplace(Cwd,'/','\',[rfReplaceAll]);
              Result:=True;
            end;
          end
          else
          begin
            if Cwd[Length(Cwd)]='/' then Delete(Cwd,Length(Cwd),1);
            if DirectoryExists(FRoot+FDir+StringReplace(Cwd,'/','\',[rfReplaceAll]))=True then
            begin
              FDir:=FDir+StringReplace(Cwd,'/','\',[rfReplaceAll]);
              Result:=True;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TFtpStreamFullDuplex.DoList(var Val: AnsiString): Boolean;
var F: TSearchRec;
begin
  Result:=False;
  Val:='';
  Val:=Val+'drwxr-xr-x 1 ftp ftp'+#$09+' 0 Jul 24 15:00 .'#13#10;
  Val:=Val+'drwxr-xr-x 1 ftp ftp'+#$09+' 0 Jul 24 15:00 ..'#13#10;
  if FindFirst(FRoot+FDir+'\*',faDirectory,F) = 0 then
  begin
    repeat
      if (F.attr and faDirectory) = faDirectory then
      begin
        Val:=Val+'drwxr-xr-x 1 ftp ftp'+#$09+' 0 '+FileTimeToUnixString(F.Time)+' '+F.Name+#13#10;
      end;
    until FindNext(F) <> 0;
  end;
  FindClose(F);
  if FindFirst(FRoot+FDir+'\*.*',faAnyFile,F) = 0 then
  begin
    repeat
      if (F.attr and faDirectory) <> faDirectory then
      begin
        Val:=Val+'-rwxr-xr-x 1 ftp ftp '+#$09+IntToStr(F.Size)+' '+FileTimeToUnixString(F.Time)+' '+F.Name+#13#10;
      end;
    until FindNext(F) <> 0;
  end;
  FindClose(F);
  Result:=True;
end;

function TFtpStreamFullDuplex.DoMkd(Val: AnsiString): Boolean;
begin
  if Pos('/',Val)>0 then
  begin
    if Val[1]='/' then Delete(Val,1,1);
    if (Length(Val)>0) and (Val[Length(Val)]='/') then Delete(Val,Length(Val),1);
    if DirectoryExists(FRoot+'\'+StringReplace(Val,'/','\',[rfReplaceAll]))=True then
    begin
      Result:=False;
    end
    else
    begin
      Result:=ForceDirectories(FRoot+'\'+StringReplace(Val,'/','\',[rfReplaceAll]));
    end;
  end
  else
  begin
    if DirectoryExists(FRoot+FDir+'\'+Val)=True then
    begin
      Result:=False;
    end
    else
    begin
      Result:=CreateDir(FRoot+FDir+'\'+Val);
    end;
  end;
end;

function TFtpStreamFullDuplex.DoRmd(Val: AnsiString): Boolean;
begin
  Result:=False;
  if Pos('/',Val)>0 then
  begin
    if Val[1]='/' then Delete(Val,1,1);
    if (Length(Val)>0) and (Val[Length(Val)]='/') then Delete(Val,Length(Val),1);
    if DirectoryExists(FRoot+'\'+StringReplace(Val,'/','\',[rfReplaceAll]))=False then
    begin
      Result:=False;
    end
    else
    begin
      Result:=RemoveDir(FRoot+'\'+StringReplace(Val,'/','\',[rfReplaceAll]));
    end;
  end
  else
  begin
    if DirectoryExists(FRoot+FDir+'\'+Val)=False then
    begin
      Result:=False;
    end
    else
    begin
      Result:=RemoveDir(FRoot+FDir+'\'+Val);
    end;
  end;
end;

function TFtpStreamFullDuplex.DoStorStartup(FileName: AnsiString): Boolean;
begin
  Result:=False;
  if Pos('/',FileName)>0 then
  begin
    if FileName[1]='/' then Delete(FileName,1,1);
    if (Length(FileName)>0) and (FileName[Length(FileName)]='/') then Delete(FileName,Length(FileName),1);
    if DirectoryExists(ExtractFilePath(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll])))=True then
    begin
      DeleteFile(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]));
      FStream:=TFileStream.Create(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]),fmCreate);
      Result:=True;
    end;
  end
  else
  begin
    if DirectoryExists(FRoot+FDir)=True then
    begin
      DeleteFile(FRoot+FDir+'\'+FileName);
      FStream:=TFileStream.Create(FRoot+FDir+'\'+FileName,fmCreate);
      Result:=True;
    end;
  end;
end;

function TFtpStreamFullDuplex.DoStorProcess(Buf: Pointer; Len: Cardinal): Cardinal;
begin
  Result:=FStream.Write(Buf^,Len);
end;

function TFtpStreamFullDuplex.DoStorCleanup: Boolean;
begin
  if FStream<>nil then
  begin
    FStream.Destroy;
    FStream:=nil;
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

function TFtpStreamFullDuplex.DoRetrStartup(FileName: AnsiString): Boolean;
begin
  Result:=False;
  if Pos('/',FileName)>0 then
  begin
    if FileName[1]='/' then Delete(FileName,1,1);
    if (Length(FileName)>0) and (FileName[Length(FileName)]='/') then Delete(FileName,Length(FileName),1);
    if FileExists(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]))=True then
    begin
      FStream:=TFileStream.Create(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]),fmOpenRead);
      FStream.Position:=0;
      Result:=True;
    end;
  end
  else
  begin
    if FileExists(FRoot+FDir+'\'+FileName)=True then
    begin
      FStream:=TFileStream.Create(FRoot+FDir+'\'+FileName,fmOpenRead);
      FStream.Position:=0;
      Result:=True;
    end;
  end;
end;

function TFtpStreamFullDuplex.DoRetrProcess(Buf: Pointer; Len: Cardinal): Cardinal;
begin
  Result:=FStream.Read(Buf^,Len);
end;

function TFtpStreamFullDuplex.DoRetrCleanup: Boolean;
begin
  if FStream<>nil then
  begin
    FStream.Destroy;
    FStream:=nil;
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

function TFtpStreamFullDuplex.DoDele(FileName: AnsiString): Boolean;
begin
  Result:=False;
  if Pos('/',FileName)>0 then
  begin
    if FileName[1]='/' then Delete(FileName,1,1);
    if (Length(FileName)>0) and (FileName[Length(FileName)]='/') then Delete(FileName,Length(FileName),1);
    if FileExists(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]))=False then
    begin
      Result:=False;
    end
    else
    begin
      Result:=DeleteFile(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]));
    end;
  end
  else
  begin
    if FileExists(FRoot+FDir+'\'+FileName)=False then
    begin
      Result:=False;
    end
    else
    begin
      Result:=DeleteFile(FRoot+FDir+'\'+FileName);
    end;
  end;
end;

function TFtpStreamFullDuplex.DoSize(FileName: AnsiString; var sSize: AnsiString): Boolean;
  function FtpFileSize(FileName: AnsiString): UInt64;
  var F: TMemoryStream;
  begin
    Result:=0;
    try
      F:=TMemoryStream.Create;
      F.LoadFromFile(FileName);
      Result:=F.Size;
    finally
      F.Free;
    end;
  end;
begin
  Result:=False;
  if Pos('/',FileName)>0 then
  begin
    if FileName[1]='/' then Delete(FileName,1,1);
    if (Length(FileName)>0) and (FileName[Length(FileName)]='/') then Delete(FileName,Length(FileName),1);
    if FileExists(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]))=False then
    begin
      Result:=False;
    end
    else
    begin
      sSize:=IntToStr(FtpFileSize(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll])));
      Result:=True;
    end;
  end
  else
  begin
    if FileExists(FRoot+FDir+'\'+FileName)=False then
    begin
      Result:=False;
    end
    else
    begin
      sSize:=IntToStr(FtpFileSize(FRoot+FDir+'\'+FileName));
      Result:=True;
    end;
  end;
end;

function TFtpStreamFullDuplex.DoRnfr(FileName: AnsiString): Boolean;
begin
  Result:=False;
  if Pos('/',FileName)>0 then
  begin
    if FileName[1]='/' then Delete(FileName,1,1);
    if (Length(FileName)>0) and (FileName[Length(FileName)]='/') then Delete(FileName,Length(FileName),1);
    if FileExists(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]))=True then
    begin
      FRNFRDir:=False;
      FRNFRFile:=FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]);
      Result:=True;
    end
    else
    begin
      if DirectoryExists(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]))=True then
      begin
        FRNFRDir:=True;
        FRNFRFile:=FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]);
        Result:=True;
      end;
    end;
  end
  else
  begin
    if FileExists(FRoot+FDir+'\'+FileName)=True then
    begin
      FRNFRDir:=False;
      FRNFRFile:=FRoot+FDir+'\'+FileName;
      Result:=True;
    end
    else
    begin
      if DirectoryExists(FRoot+FDir+'\'+FileName)=True then
      begin
        FRNFRDir:=True;
        FRNFRFile:=FRoot+FDir+'\'+FileName;
        Result:=True;
      end;
    end;
  end;
end;

function TFtpStreamFullDuplex.DoRnto(FileName: AnsiString): Boolean;
begin
  Result:=False;
  if Pos('/',FileName)>0 then
  begin
    if FileName[1]='/' then Delete(FileName,1,1);
    if (Length(FileName)>0) and (FileName[Length(FileName)]='/') then Delete(FileName,Length(FileName),1);
    if FRNFRDir=True then
    begin
      if DirectoryExists(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]))=False then
      begin
        FRNTOFile:=FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]);
        Result:=MoveFile(PAnsiChar(FRNFRFile),PAnsiChar(FRNTOFile));
        FRNFRDir:=False;
        FRNFRFile:='';
        FRNTOFile:='';
      end;
    end
    else
    begin
      if FileExists(FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]))=False then
      begin
        FRNTOFile:=FRoot+'\'+StringReplace(FileName,'/','\',[rfReplaceAll]);
        Result:=RenameFile(FRNFRFile,FRNTOFile);
        FRNFRDir:=False;
        FRNFRFile:='';
        FRNTOFile:='';
      end;
    end;
  end
  else
  begin
    if FRNFRDir=True then
    begin
      if DirectoryExists(FRoot+FDir+'\'+FileName)=False then
      begin
        FRNTOFile:=FRoot+FDir+'\'+FileName;
        Result:=MoveFile(PAnsiChar(FRNFRFile),PAnsiChar(FRNTOFile));
        FRNFRDir:=False;
        FRNFRFile:='';
        FRNTOFile:='';
      end;
    end
    else
    begin
      if FileExists(FRoot+FDir+'\'+FileName)=False then
      begin
        FRNTOFile:=FRoot+FDir+'\'+FileName;
        Result:=RenameFile(FRNFRFile,FRNTOFile);
        FRNFRDir:=False;
        FRNFRFile:='';
        FRNTOFile:='';
      end;
    end;
  end;
end;

function TFtpStreamFullDuplex.DoOpts(Val: AnsiString): Boolean;
begin
  writeln('DETECT: '+Val);
  Result:=False;
end;


initialization

  Classes.RegisterClass(TFtpStreamFullDuplex);

end.

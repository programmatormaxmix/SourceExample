program FTPServer;

{$APPTYPE CONSOLE}

uses

  SysUtils, EntityChannelUnit, SocketFtpStreamFullDuplex, EntityTcpUnit;

type

  TFTPServer = class (TServer)
  protected
    function CreateMultilink(var Multilink: TMultilink): Boolean; override;
    function CreateSocket(var Socket: TSocket): Boolean; override;
  end;


function TFTPServer.CreateMultilink(var Multilink: TMultilink): Boolean;
begin
  Multilink:=TMultilinkTcpStreamFullDuplex.Create(nil);
  TMultilinkTcpStreamFullDuplex(Multilink).Port:=21;
  TMultilinkTcpStreamFullDuplex(Multilink).KeepAliveChild:=60000;
  Result:=True;
end;

function TFTPServer.CreateSocket(var Socket: TSocket): Boolean;
begin
  Socket:=TFtpStreamFullDuplex.Create(nil);
  Result:=True;
end;

var
  FtpServer1: TFtpServer;

begin
  writeln ('[ OK] Ftp server initialize');
  FtpServer1:=TFtpServer.Create;
  FtpServer1.Active:=True;
  if FtpServer1.Active=True then
  begin
    writeln ('[ OK ] Ftp activated');
    FtpServer1.Enable:=True;
    if FtpServer1.Enable=True then
    begin
      writeln ('[ OK ] Ftp enabled');
      readln;
    end
    else
    begin
      writeln ('[ OK ] Ftp fault');
    end;
  end
  else
  begin
    writeln ('[ ER ] Ftp fault');
  end;
  FtpServer1.Destroy;
  FtpServer1:=nil;
end.

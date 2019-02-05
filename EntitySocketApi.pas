unit EntitySocketApi;

interface

{$I EntitySystemOpt.inc}

uses

  SysUtils,
  Classes,
{$ifdef fpc}
  {$ifdef mswindows}
  WinSock2,
  {$else}
  BaseUnix,
  TermIO,
  Sockets,
  {$endif}
{$else}
  WinSock,
{$endif}
  EntityChannelConst;

const
{$ifdef linux}
  INVALID_SOCKET = -1;
  SOCKET_ERROR = -1;
  WSAEWOULDBLOCK = EsockEWOULDBLOCK;
{$else}
  INVALID_SOCKET = SOCKET_ERROR;
{$endif}


type

{$ifdef fpc}
  {$ifdef mswindows}
  TSockAddrIn = WinSock2.TSockAddrIn;
  {$else}
  TSockAddrIn = Sockets.TSockAddr;
  {$endif}
{$else}
  TSockAddrIn = WinSock.TSockAddrIn;
{$endif}

function ESASocketError(hSocket: Integer): Integer;
function ESASocketUnblocking(hSocket: Integer; var Error: Integer): Boolean;
function ESASocketBlocking(hSocket: Integer; var Error: Integer): Boolean;
function ESASocketShutdown(hSocket: Integer; var Error: Integer): Boolean;
function ESASocketCreate(var hSocket: Integer; var Error: Integer): Boolean;
function ESASocketConnect(hSocket: Integer; var SockAddrIn: TSockAddrIn; var Error: Integer): Boolean;
function ESASocketClose(hSocket: Integer; var Error: Integer): Boolean;
function ESASocketSend(hSocket: Integer; Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
function ESASocketRecv(hSocket: Integer; Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
function ESASocketListen(hSocket: Integer; var Error: Integer): Boolean;
function ESASocketBind(hSocket: Integer; var SockAddrIn: TSockAddrIn; var Error: Integer): Boolean;
function ESASocketAccept(hSocket: Integer; var SockAddrIn: TSockAddrIn;  var hChildSocket: Integer; var Error: Integer): Boolean;
function ESASocketGetPeerName(hSocket: Integer; var Peer: TSockAddrIn; var Error: Integer): Boolean;
function ESASocketGetSockName(hSocket: Integer; var Sock: TSockAddrIn; var Error: Integer): Boolean;
function ESASocketInetNtoa(Addr: TInAddr): AnsiString;
function ESASocketInetAddr(Val: AnsiString): Cardinal;
function ESASocketInetHost(Val: AnsiString): AnsiString;
function ESASocketAddrFill(var SockAddrIn: TSockAddrIn; Host: AnsiString; Port: Word): Boolean;
function ESASocketInfo(var SockAddrIn: TSockAddrIn): AnsiString;
function ESASocketGetLocalIP(hSocket: Integer): AnsiString;
function ESASocketGetLocalPort(hSocket: Integer): Word;
function ESASocketGetRemoteIP(hSocket: Integer): AnsiString;
function ESASocketGetRemotePort(hSocket: Integer): Word;
function ESASocketGetSockOpt(hSocket: Integer; Level: LongInt; OptName: LongInt; Opt: Pointer; var OptLen: LongInt): Boolean;
function ESASocketSetSockOpt(hSocket: Integer; Level: LongInt; OptName: LongInt; Opt: Pointer; OptLen: LongInt): Boolean;
function ESASocketOpt(hSocket: Integer; Level: LongInt; OptName: LongInt; OptRW: Boolean; Opt: Pointer; var OptLen: LongInt): Boolean;
function ESASocketOptNODELAY(hSocket: Integer; OptRW: Boolean; var Val: LongInt): Boolean;
function ESASocketOptSNDBUF(hSocket: Integer; OptRW: Boolean; var Val: LongInt): Boolean;
function ESASocketOptRCVBUF(hSocket: Integer; OptRW: Boolean; var Val: LongInt): Boolean;

implementation

{$ifdef mswindows}
var
  FWSAData: TWSAData;
{$endif}

//------------------------------------------------------------------------------
// Socket Api
//------------------------------------------------------------------------------

//Получить ошибку сокета
function ESASocketError(hSocket: Integer): Integer;
begin
{$ifdef mswindows}
  Result:=WSAGetLastError;
{$else}
  Result:=socketerror;
{$endif}
end;

//Установить блокируйщий режим для сокета
function ESASocketUnblocking(hSocket: Integer; var Error: Integer): Boolean;
var
{$ifdef fpc}
  {$ifdef mswindows}
  Block:  u_long;
  {$else}
  Block: Dword;
  {$endif}
{$else}
  Block: Integer;
{$endif}
begin
  Block:=1;
{$ifdef linux}
  if fpioctl(hSocket,FIONBIO,@Block)=0 then
{$else}
  if ioctlsocket(hSocket,FIONBIO,Block)=0 then
{$endif}
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Установить блокируйщий режим для сокета
function ESASocketBlocking(hSocket: Integer; var Error: Integer): Boolean;
var
{$ifdef fpc}
  {$ifdef mswindows}
  Block:  u_long;
  {$else}
  Block: Dword;
  {$endif}
{$else}
  Block: Integer;
{$endif}
begin
  Block:=0;
{$ifdef linux}
  if fpioctl(hSocket,FIONBIO,@Block)=0 then
{$else}
  if ioctlsocket(hSocket,FIONBIO,Block)=0 then
{$endif}
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Завершение передачи
function ESASocketShutdown(hSocket: Integer; var Error: Integer): Boolean;
begin
{$ifdef mswindows}
  if shutdown(hSocket,SD_BOTH)=0 then
{$else}
  if fpshutdown(hSocket,2)=0 then
{$endif}
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Создать сокет
function ESASocketCreate(var hSocket: Integer; var Error: Integer): Boolean;
begin
{$ifdef mswindows}
  hSocket:=socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
{$else}
  hSocket:=fpsocket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
{$endif}
  if hSocket<>INVALID_SOCKET then
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Подключиться
function ESASocketConnect(hSocket: Integer; var SockAddrIn: TSockAddrIn; var Error: Integer): Boolean;
begin
{$ifdef mswindows}
  if Connect(hSocket,SockAddrIn,SizeOf(TSockAddrIn))=0 then
{$else}
  if fpConnect(hSocket,@SockAddrIn,SizeOf(TSockAddrIn))=0 then
{$endif}
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Закрыть сокет
function ESASocketClose(hSocket: Integer; var Error: Integer): Boolean;
begin
  if closesocket(hSocket)=0 then
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Отправка данных
function ESASocketSend(hSocket: Integer; Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
var Err: Integer;
begin
{$ifdef mswindows}
  Result:=send(hSocket,Buf^,Len,0);
{$else}
  Result:=fpsend(hSocket,Buf,Len,0);
{$endif}
  if Result=CHANNEL_ERROR_NONE then
  begin
    Result:=CHANNEL_ERROR_LINK;
  end
  else
  begin
    if Result=SOCKET_ERROR then
    begin
      Err:=ESASocketError(hSocket);
      if Err=WSAEWOULDBLOCK then
      begin
        Result:=CHANNEL_ERROR_NONE;
      end
      else
      begin
        Error:=Err;
        Result:=CHANNEL_ERROR_LINK;
      end;
    end;
  end;
end;

//Получение данных
function ESASocketRecv(hSocket: Integer; Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
var Err: Integer;
begin
{$ifdef mswindows}
  Result:=recv(hSocket,Buf^,Len,0);
{$else}
  Result:=fprecv(hSocket,Buf,Len,0);
{$endif}
  if Result=CHANNEL_ERROR_NONE then
  begin
    Result:=CHANNEL_ERROR_LINK;
  end
  else
  begin
    if Result=SOCKET_ERROR then
    begin
      Err:=ESASocketError(hSocket);
      if Err=WSAEWOULDBLOCK then
      begin
        Result:=CHANNEL_ERROR_NONE;
      end
      else
      begin
        Error:=Err;
        Result:=CHANNEL_ERROR_LINK;
      end;
    end;
  end;
end;

//Слушать
function ESASocketListen(hSocket: Integer; var Error: Integer): Boolean;
begin
{$ifdef mswindows}
  if listen(hSocket,SOMAXCONN)=0 then
{$else}
  if fplisten(hSocket,SOMAXCONN)=0 then
{$endif}
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Настроить сокет
function ESASocketBind(hSocket: Integer; var SockAddrIn: TSockAddrIn; var Error: Integer): Boolean;
begin
{$ifdef mswindows}
  if bind(hSocket,SockAddrIn,SizeOf(TSockAddrIn))=0 then
{$else}
  if fpbind(hSocket,@SockAddrIn,SizeOf(TSockAddrIn))=0 then
{$endif}
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Ожидать сокет
function ESASocketAccept(hSocket: Integer; var SockAddrIn: TSockAddrIn;  var hChildSocket: Integer; var Error: Integer): Boolean;
var dwSize: Integer;
begin
  dwSize:=SizeOf(TSockAddrIn);
{$ifdef mswindows}
  hChildSocket:=accept(hSocket,@SockAddrIn,@dwSize);
{$else}
  hChildSocket:=fpaccept(hSocket,@SockAddrIn,@dwSize);
{$endif}
  if hChildSocket<>INVALID_SOCKET then
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Получить данные о клиенте
function ESASocketGetPeerName(hSocket: Integer; var Peer: TSockAddrIn; var Error: Integer): Boolean;
var
  FPeerLen: Integer;
begin
  FPeerLen:=SizeOf(TSockAddrIn);
{$ifdef mswindows}
  if getpeername(hSocket,Peer,FPeerLen)=0 then
{$else}
  if fpgetpeername(hSocket,@Peer,@FPeerLen)=0 then
{$endif}
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Получить локальные данные
function ESASocketGetSockName(hSocket: Integer; var Sock: TSockAddrIn; var Error: Integer): Boolean;
var
  SockLen: Integer;
  Len: integer;
begin
  SockLen:=SizeOf(TSockAddrIn);
{$ifdef mswindows}
  if getsockname(hSocket, Sock, SockLen) = 0 then
{$else}
  if fpgetpeername(hSocket,@Peer,@FPeerLen)=0 then
{$endif}
  begin
    Result:=True;
  end
  else
  begin
    Error:=ESASocketError(hSocket);
    Result:=False;
  end;
end;

//Получить из сетевого адреса в виде строки
function ESASocketInetNtoa(Addr: TInAddr): AnsiString;
begin
{$ifdef mswindows}
  Result:=inet_ntoa(Addr);
{$else}
  Result:=NetAddrToStr(Addr);
{$endif}
end;

//Преобразовать в сетевой адрес
function ESASocketInetAddr(Val: AnsiString): Cardinal;
begin
{$ifdef mswindows}
  Result:=inet_addr(PAnsiChar(Val));
{$else}
  Result:=StrToNetAddr(Val).s_addr;
{$endif}
end;

//Получить адрес IP из имени
function ESASocketInetHost(Val: AnsiString): AnsiString;
var n: Integer;
    m: Integer;
    //HostEnt: PHostEnt;
begin
  m:=0;
  Result:='127.0.0.1';
  if Length(Val)>0 then
  begin
    for n:=1 to Length(Val) do
    begin
      if Val[n]='.' then m:=m+1;
    end;
    if m=3 then
    begin
      Result:=Trim(Val);
    end
    else
    begin
      //HostEnt:=GetHostByName(PChar(Val));
      //if HostEnt<>nil then Result:=SocketInetNtoa(PInAddr(HostEnt^.h_addr_list^)^);
    end;
  end;
end;

//Заполнить структуру SockAddr
function ESASocketAddrFill(var SockAddrIn: TSockAddrIn; Host: AnsiString; Port: Word): Boolean;
begin
  FillChar(SockAddrIn,SizeOf(TSockAddrIn),0);
  SockAddrIn.sin_family:=AF_INET;
  SockAddrIn.sin_port:=htons(Port);
  if Host<>'' then
  begin
    SockAddrIn.sin_addr.S_addr:=ESASocketInetAddr(ESASocketInetHost(Host));
  end
  else
  begin
    SockAddrIn.sin_addr.S_addr:=INADDR_ANY;
  end;
  Result:=True;
end;

//Получить информацию
function ESASocketInfo(var SockAddrIn: TSockAddrIn): AnsiString;
begin
  if (ntohl(SockAddrIn.sin_addr.S_addr)>=ntohl(ESASocketInetAddr('127.0.0.1'))) and (ntohl(SockAddrIn.sin_addr.S_addr)<=ntohl(ESASocketInetAddr('127.0.0.254'))) then
  begin
    Result:='local';
  end
  else
  begin
    if (ntohl(SockAddrIn.sin_addr.S_addr)>=ntohl(ESASocketInetAddr('192.168.0.1'))) and (ntohl(SockAddrIn.sin_addr.S_addr)<=ntohl(ESASocketInetAddr('192.168.254.254'))) then
    begin
      Result:='network';
    end
    else
    begin
      if (ntohl(SockAddrIn.sin_addr.S_addr)>=ntohl(ESASocketInetAddr('10.0.0.1'))) and (ntohl(SockAddrIn.sin_addr.S_addr)<=ntohl(ESASocketInetAddr('10.254.254.254'))) then
      begin
        Result:='network';
      end
      else
      begin
        Result:='internet';
      end;
    end;
  end;
  Result:=Result+'.'+ESASocketInetNtoa(SockAddrIn.sin_addr)+'.'+IntToStr(ntohs(SockAddrIn.sin_port));
end;

//Получить локальный адрес
function ESASocketGetLocalIP(hSocket: Integer): AnsiString;
var Sock: TSockAddrIn;
    Error: Integer;
begin
  if ESASocketGetSockName(hSocket,Sock,Error)=True then
  begin
    Result:=ESASocketInetNtoa(Sock.sin_addr);
  end
  else
  begin
    Result:='127.0.0.1';
  end;
end;

//Получить локальный порт
function ESASocketGetLocalPort(hSocket: Integer): Word;
var Sock: TSockAddrIn;
    Error: Integer;
begin
  if ESASocketGetSockName(hSocket,Sock,Error)=True then
  begin
    Result:=ntohs(Sock.sin_port);
  end
  else
  begin
    Result:=0;
  end;
end;

//Получить удаленный адрес
function ESASocketGetRemoteIP(hSocket: Integer): AnsiString;
var Sock: TSockAddrIn;
    Error: Integer;
begin
  if ESASocketGetPeerName(hSocket,Sock,Error)=True then
  begin
    Result:=ESASocketInetNtoa(Sock.sin_addr);
  end
  else
  begin
    Result:='127.0.0.1';
  end;
end;

//Получить удаленный порт
function ESASocketGetRemotePort(hSocket: Integer): Word;
var Sock: TSockAddrIn;
    Error: Integer;
begin
  if ESASocketGetPeerName(hSocket,Sock,Error)=True then
  begin
    Result:=ntohs(Sock.sin_port);
  end
  else
  begin
    Result:=0;
  end;
end;

//Получить опцию сокета
function ESASocketGetSockOpt(hSocket: Integer; Level: LongInt; OptName: LongInt; Opt: Pointer; var OptLen: LongInt): Boolean;
begin
  if GetSockOpt(hSocket,Level,OptName,Opt,OptLen)=0 then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Установить опцию сокета
function ESASocketSetSockOpt(hSocket: Integer; Level: LongInt; OptName: LongInt; Opt: Pointer; OptLen: LongInt): Boolean;
begin
  if SetSockOpt(hSocket,Level,OptName,Opt,OptLen)=0 then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Получить или установить опцию
function ESASocketOpt(hSocket: Integer; Level: LongInt; OptName: LongInt; OptRW: Boolean; Opt: Pointer; var OptLen: LongInt): Boolean;
begin
  if OptRW=True then
  begin
    Result:=ESASocketGetSockOpt(hSocket,Level,OptName,Opt,OptLen);
  end
  else
  begin
    Result:=ESASocketSetSockOpt(hSocket,Level,OptName,Opt,OptLen);
  end;
end;

//Опция TCP_NODELAY
function ESASocketOptNODELAY(hSocket: Integer; OptRW: Boolean; var Val: LongInt): Boolean;
var OptLen: LongInt;
begin
  Val:=0;
  OptLen:=SizeOf(LongInt);
  Result:=ESASocketOpt(hSocket,IPPROTO_TCP,TCP_NODELAY,OptRW,@Val,OptLen);
end;

//Опция SO_SNDBUF
function ESASocketOptSNDBUF(hSocket: Integer; OptRW: Boolean; var Val: LongInt): Boolean;
var OptLen: LongInt;
begin
  Val:=0;
  OptLen:=SizeOf(LongInt);
  Result:=ESASocketOpt(hSocket,SOL_SOCKET,SO_SNDBUF,OptRW,@Val,OptLen);
end;

//Опция SO_RCVBUF
function ESASocketOptRCVBUF(hSocket: Integer; OptRW: Boolean; var Val: LongInt): Boolean;
var OptLen: LongInt;
begin
  Val:=0;
  OptLen:=SizeOf(LongInt);
  Result:=ESASocketOpt(hSocket,SOL_SOCKET,SO_RCVBUF,OptRW,@Val,OptLen);
end;

{$ifdef mswindows}
initialization
  WSAStartup($0202,FWSAData);

finalization
  WSACleanup;
{$endif}

end.

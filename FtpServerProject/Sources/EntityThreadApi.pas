unit EntityThreadApi;

interface

{$I EntitySystemOpt.inc}

uses

{$ifdef mswindows}
  Windows,
{$endif}
  SysUtils,
  Classes;

type

{$ifndef fpc}
  TThreadID = Cardinal;
{$endif}

  TMillisecond = type UInt64;

  //TUnixTime = type UInt64;

function ETACreateThread(Fun: Pointer; Par: Pointer; var hThread: TThreadID): Boolean;
function ETADestroyThread(hThread: TThreadID; TimeOut: Cardinal; ExitCode: Cardinal): Boolean;
function ETAGetTickCount: TMillisecond;

implementation

//Получить количество миллисекунд
function ETAGetTickCount: TMillisecond;
begin
{$ifdef fpc}
  Result:=GetTickCount64;
{$else}
  Result:=GetTickCount;
{$endif}
end;

//Создать поток
function ETACreateThread(Fun: Pointer; Par: Pointer; var hThread: TThreadID): Boolean;
begin
{$ifdef fpc}
  hThread:=BeginThread(Fun,Par,hThread);
{$else}
  hThread:=BeginThread(nil,0,Fun,Par,0,hThread);
{$endif}
  if hThread<>0 then Result:=True else Result:=False;
end;

//Уничтожить поток
function ETADestroyThread(hThread: TThreadID; TimeOut: Cardinal; ExitCode: Cardinal): Boolean;
{$ifdef linux}
const
   WAIT_OBJECT_0 = 0;
{$endif}
var Err: Integer;
begin
  Result:=False;
{$ifdef linux}
  Err:=WaitForThreadTerminate(hThread,TimeOut);
{$else}
  Err:=WaitForSingleObject(hThread,TimeOut);
{$endif}
  if Err=WAIT_OBJECT_0 then
  begin
{$ifdef linux}
    CloseThread(hThread);
{$else}
    CloseHandle(hThread);
{$endif}
    Result:=True;
  end
  else
  begin
{$ifdef linux}
    KillThread(hThread);
    CloseThread(hThread);
{$else}
    TerminateThread(hThread,ExitCode);
    CloseHandle(hThread);
{$endif}
  end;
end;

end.

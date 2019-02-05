unit EntityChannelUnit;

interface

{$I EntitySystemOpt.inc}

uses

  SysUtils,
  Classes,
  SyncObjs,
  EntityThreadApi,
  EntityChannelConst;

type

  TChannel = class (TPersistent)
  private
    FInitialize: Boolean;
    FActive: Boolean;
    FSocket: Boolean;
    FSource: TChannel;
    FDest: TChannel;
    FFifo: TChannel;
    FThread: Boolean;
    FhThreading: Boolean;
    FhThread: TThreadID;
    FFrequncy: TMillisecond;
    FTerminateTimeOut: TMillisecond;
    FControl: Boolean;
    FMultilink: TPersistent;
    FCritical: TCriticalSection;
    FKeepAliveTimeOut: TMillisecond;
    FKeepAliveLive: TMillisecond;
    FTuning: Byte;
    FDefaultErrorCode: Integer;
    FSystemErrorCode: Integer;
    FSendTimeWait: TMillisecond;
    FRecvTimeWait: TMillisecond;
    FSendTimeOut: TMillisecond;
    FRecvTimeOut: TMillisecond;
    FSendTryOut: TMillisecond;
    FRecvTryOut: TMillisecond;
    FTotalRecvBytes: TBytes;
    FTotalSentBytes: TBytes;
    FTempBufferSize: TBytes;
    FPeer: AnsiString;
    FCommandLine: AnsiString;
    FTelNetEchoEnable: Boolean;
    FArray: array of AnsiChar;
    procedure Reset;
    procedure SocketThreadControl;
    function GetPeerName: AnsiString;
    function GetDescError: AnsiString;
    function GetActive: Boolean;
    procedure SetActive(Act: Boolean);
    procedure SetSocket(Act: Boolean);
    procedure SetThread(Act: Boolean);
    procedure SetTuning(Val: Byte);
    procedure SetChannel(Val: TChannel);
    procedure SetTempBufferSize(Val: TBytes);
    procedure SetKeepAliveTimeOut(Value: TMillisecond);
    function Sync: Boolean;
  protected
    property Tuning: Byte read FTuning write SetTuning;
    property Socket: Boolean read FSocket write SetSocket;
    property Thread: Boolean read FThread write SetThread;
    function DoInitializeChannel(var Error: Integer): Boolean; virtual;
    function DoDeinitializeChannel(var Error: Integer): Boolean; virtual;
    function DoActivateChannel(var Error: Integer): Boolean; virtual;
    function DoDeactivateChannel(var Error: Integer): Boolean; virtual;
    function DoPeerChannel(var Peer: AnsiString): Boolean; virtual;
    function DoExistsChannel(var Error: Integer): Boolean; virtual;
    function DoFlushChannel(var Error: Integer): Boolean; virtual;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; virtual;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; virtual;
    function DoPumpChannel(Buf: Pointer; Len: Cardinal; Delivery: Boolean; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond; var Error: Integer): Integer;
    procedure OnConnectChannel(Socket: TChannel); virtual;
    procedure OnDisconnectChannel(Socket: TChannel); virtual;
    procedure OnSelectChannel(Socket: TChannel); virtual;
  public
    property Active: Boolean read GetActive write SetActive;
    property Peer: AnsiString read GetPeerName;
    property TotalRecvBytes: TBytes read FTotalRecvBytes;
    property TotalSentBytes: TBytes read FTotalSentBytes;
    property DefaultErrorCode: Integer read FDefaultErrorCode;
    property SystemErrorCode: Integer read FSystemErrorCode;
    property DescErrorCode: AnsiString read GetDescError;
    property Channel: TChannel read FFifo write SetChannel;
    property SendTimeWait: TMillisecond read FSendTimeWait write FSendTimeWait;
    property SendTimeOut: TMillisecond read FSendTimeOut write FSendTimeOut;
    property SendTryOut: TMillisecond read FSendTryOut write FSendTryOut;
    property RecvTimeWait: TMillisecond read FRecvTimeWait write FRecvTimeWait;
    property RecvTimeOut: TMillisecond read FRecvTimeOut write FRecvTimeOut;
    property RecvTryOut: TMillisecond read FRecvTryOut write FRecvTryOut;
    property KeepAliveTimeOut: TMillisecond read FKeepAliveTimeOut write SetKeepAliveTimeOut;
    property TelNetEchoEnable: Boolean read FTelNetEchoEnable write FTelNetEchoEnable;
    property TempBufferSize: TBytes read FTempBufferSize write SetTempBufferSize;
    function SendBuf(Buf: Pointer; Len: Cardinal): Integer; overload;
    function RecvBuf(Buf: Pointer; Len: Cardinal): Integer; overload;
    function SendBuf(Buf: Pointer; Len: Cardinal; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer; overload;
    function RecvBuf(Buf: Pointer; Len: Cardinal; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer; overload;
    function SendStr(Str: AnsiString): Integer; overload;
    function RecvStr(var Str: AnsiString): Integer; overload;
    function SendStr(Str: AnsiString; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer; overload;
    function RecvStr(var Str: AnsiString; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer; overload;
    function SendCmd(Str: AnsiString): Integer;
    function RecvCmd(var Str: AnsiString): Integer;
    function TranCmd(Str: AnsiString; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer;
    function WaitCmd(var Str: AnsiString; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer;
    function Flush: Boolean;
    function Shutdown(Error: Integer): Boolean;
    constructor Create(Multilink: TPersistent);
    destructor Destroy; override;
  end;

  TChannelRef = class of TChannel;

  TChannelStreamFullDuplex = class (TChannel)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  end;

  TChannelStreamHalfDuplex = class (TChannel)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  end;

  TChannelStreamRecvSimplex = class (TChannel)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  end;

  TChannelStreamSendSimplex = class (TChannel)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  end;

  TChannelPacketFullDuplex = class (TChannel)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  end;

  TChannelPacketHalfDuplex = class (TChannel)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  end;

  TChannelPacketRecvSimplex = class (TChannel)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  end;

  TChannelPacketSendSimplex = class (TChannel)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  end;

  TChannelCompositeAutotune = class (TChannel)
  private
    FSource: TChannel;
    FDest: TChannel;
    procedure SetSource(Val: TChannel);
    procedure SetDest(Val: TChannel);
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoActivateChannel(var Error: Integer): Boolean; override;
    function DoExistsChannel(var Error: Integer): Boolean; override;
    function DoFlushChannel(var Error: Integer): Boolean; override;
    function DoPeerChannel(var Peer: AnsiString): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  public
    property Source: TChannel read FSource write SetSource;
    property Dest: TChannel read FDest write SetDest;
  end;

  TFifoStreamHalfDuplex = class (TChannelStreamHalfDuplex)
  private
    FQueneTotalSize: Cardinal;
    FQueneBaseBuf: array of Byte;
    FQueneFreeSize: Cardinal;
    FQueneBusySize: Cardinal;
    FQuenePutIndex: Cardinal;
    FQueneGetIndex: Cardinal;
    FQueneAuto: Boolean;
    procedure SetQueneAuto(Value: Boolean);
    procedure SetQueneTotalSize(Value: Cardinal);
    function PutQueneByte(Val: Byte): Integer;
    function GetQueneByte(var Val: Byte): Integer;
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoActivateChannel(var Error: Integer): Boolean; override;
    function DoDeactivateChannel(var Error: Integer): Boolean; override;
    function DoPeerChannel(var Peer: AnsiString): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  public
    property Auto: Boolean read FQueneAuto write SetQueneAuto;
    property Size: Cardinal read FQueneTotalSize write SetQueneTotalSize;
    property Busy: Cardinal read FQueneBusySize;
    property Free: Cardinal read FQueneFreeSize;
  end;

  TFifoPacketHalfDuplex = class (TChannelPacketHalfDuplex)
  private
    FQueneTotalSize: Cardinal;
    FQueneBaseBuf: array of Byte;
    FQueneFreeSize: Cardinal;
    FQueneBusySize: Cardinal;
    FQuenePutIndex: Cardinal;
    FQueneGetIndex: Cardinal;
    FQuenePackCount: Cardinal;
    FQueneAuto: Boolean;
    procedure SetQueneAuto(Value: Boolean);
    procedure SetQueneTotalSize(Value: Cardinal);
    function PutQueneByte(Val: Byte): Integer;
    function GetQueneByte(var Val: Byte): Integer;
    function RstQueneByte(Val: Byte): Integer;
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoActivateChannel(var Error: Integer): Boolean; override;
    function DoDeactivateChannel(var Error: Integer): Boolean; override;
    function DoPeerChannel(var Peer: AnsiString): Boolean; override;
    function DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
    function DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer; override;
  public
    property Auto: Boolean read FQueneAuto write SetQueneAuto;
    property Size: Cardinal read FQueneTotalSize write SetQueneTotalSize;
    property Busy: Cardinal read FQueneBusySize;
    property Free: Cardinal read FQueneFreeSize;
    property Pack: Cardinal read FQuenePackCount;
  end;

  TSocket = class (TChannel)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoDeinitializeChannel(var Error: Integer): Boolean; override;
    function DoActivateChannel(var Error: Integer): Boolean; override;
    function DoDeactivateChannel(var Error: Integer): Boolean; override;
    function DoPeerChannel(var Peer: AnsiString): Boolean; override;
    function DoExistsChannel(var Error: Integer): Boolean; override;
    function DoFlushChannel(var Error: Integer): Boolean; override;
    procedure OnConnectChannel(Socket: TChannel); override;
    procedure OnDisconnectChannel(Socket: TChannel); override;
    procedure OnSelectChannel(Socket: TChannel); override;
  protected
    function DoInitializeSocket(var Error: Integer): Boolean; virtual;
    function DoDeinitializeSocket(var Error: Integer): Boolean; virtual;
    function DoActivateSocket(var Error: Integer): Boolean; virtual;
    function DoDeactivateSocket(var Error: Integer): Boolean; virtual;
    function DoPeerSocket(var Peer: AnsiString): Boolean; virtual;
    procedure OnConnectSocket(Socket: TChannel); virtual;
    procedure OnDisconnectSocket(Socket: TChannel); virtual;
    procedure OnSelectSocket(Socket: TChannel); virtual;
  end;

  TSocketStreamFullDuplex = class (TSocket)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
  end;

  TSocketStreamHalfDuplex = class (TSocket)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
  end;

  TSocketStreamRecvSimplex = class (TSocket)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
  end;

  TSocketStreamSendSimplex = class (TSocket)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
  end;

  TSocketPacketFullDuplex = class (TSocket)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
  end;

  TSocketPacketHalfDuplex = class (TSocket)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
  end;

  TSocketPacketRecvSimplex = class (TSocket)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
  end;

  TSocketPacketSendSimplex = class (TSocket)
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
  end;

  TMultilink = class (TChannel)
  private
    FKeepAliveChild: TMillisecond;
    procedure SetKeepAliveChild(Val: TMillisecond);
  protected
    function DoInitializeChannel(var Error: Integer): Boolean; override;
    function DoDeinitializeChannel(var Error: Integer): Boolean; override;
    function DoActivateChannel(var Error: Integer): Boolean; override;
    function DoDeactivateChannel(var Error: Integer): Boolean; override;
    procedure OnConnectChannel(Socket: TChannel); override;
    procedure OnDisconnectChannel(Socket: TChannel); override;
    procedure OnSelectChannel(Socket: TChannel); override;
  protected
    function ApiRegisterChild(Socket: TChannel; Child: TChannel): Boolean;
    function DoInitializeMultilink(var Error: Integer): Boolean; virtual;
    function DoDeinitializeMultilink(var Error: Integer): Boolean; virtual;
    function DoActivateMultilink(var Error: Integer): Boolean; virtual;
    function DoDeactivateMultilink(var Error: Integer): Boolean; virtual;
    procedure OnConnectMultilink(Socket: TChannel); virtual;
    procedure OnDisconnectMultilink(Socket: TChannel); virtual;
    procedure OnSelectMultilink(Socket: TChannel); virtual;
  public
    property KeepAliveChild: TMillisecond read FKeepAliveChild write SetKeepAliveChild;
    function Accept(var Channel: TChannel): Boolean;
    function Return(var Channel: TChannel): Boolean; virtual;
  end;

  TMultilinkRef = class of TMultilink;

  TServer = class (TPersistent)
  private
    FActive: Boolean;
    FEnable: Boolean;
    FCritical: TCriticalSection;
    FMaxChargeLevel: Cardinal;
    FMaxSocketCount: Cardinal;
    FMaxThreadCount: Cardinal;
    FMaxChargeCount: Cardinal;
    FTerminateTimeOut: Cardinal;
    FIndex: Cardinal;
    FBusy: array of Boolean;
    FSocket: array of TSocket;
    FMultilink: TMultilink;
    FThread: array of TThreadID;
    FhThreading: Boolean;
    FFrequncy: TMillisecond;
    procedure Reset;
    procedure SetActive(Act: Boolean);
    procedure SetEnable(Act: Boolean);
    procedure SetMaxChargeLevel(Val: Cardinal);
    procedure SetMaxSocketCount(Val: Cardinal);
    procedure SetMaxThreadCount(Val: Cardinal);
    procedure SetMaxChargeCount(Val: Cardinal);
    function OpenSocket(var Index: Cardinal): Boolean;
    procedure ReleaseSocket(Index: Cardinal);
    function ThreadSocket: Boolean;
  protected
    function CreateMultilink(var Multilink: TMultilink): Boolean; virtual;
    function CreateSocket(var Socket: TSocket): Boolean; virtual;
  public
    property Active: Boolean read FActive write SetActive;
    property Enable: Boolean read FEnable write SetEnable;
    property MaxChargeLevel: Cardinal read FMaxChargeLevel write SetMaxChargeLevel;
    property MaxSocketCount: Cardinal read FMaxSocketCount;
    property MaxThreadCount: Cardinal read FMaxThreadCount;
    property MaxChargeCount: Cardinal read FMaxChargeCount;
    function Invoke(Name: AnsiString; var Channel: TChannel): Boolean;
    function Revoke(Channel: TChannel): Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  TServerRef = class of TServer;

implementation

//------------------------------------------------------------------------------
// {TChannel}
//------------------------------------------------------------------------------

//Поток
function ChannelThreadControl(Self: TChannel): Integer;
begin
  Result:=0;
  Self.SocketThreadControl;
  EndThread(0);
end;

//Создать канал
constructor TChannel.Create(Multilink: TPersistent);
begin
  inherited Create;
  Reset;
  FMultilink:=Multilink;
  FCritical:=TCriticalSection.Create;
  if FInitialize=False then
  begin
    if DoInitializeChannel(FSystemErrorCode)=True then
    begin
      FInitialize:=True;
    end
    else
    begin
      FDefaultErrorCode:=CHANNEL_ERROR_FAILURE;
    end;
  end;
end;

//Уничтожить канал
destructor TChannel.Destroy;
begin
  if Assigned(FMultilink)=True then TMultilink(FMultilink).Return(Self);
  Active:=False;
  if FInitialize=True then
  begin
    if DoDeinitializeChannel(FSystemErrorCode)=True then
    begin
      FInitialize:=False;
    end
    else
    begin
      FDefaultErrorCode:=CHANNEL_ERROR_FAILURE;
    end;
  end;
  FCritical.Destroy;
  FCritical:=nil;
  Reset;
  inherited Destroy;
end;

//Сброс
procedure TChannel.Reset;
begin
  FInitialize:=False;
  FActive:=False;
  FSocket:=False;
  FSource:=nil;
  FDest:=nil;
  FFifo:=nil;
  FThread:=False;
  FhThreading:=False;
  FhThread:=0;
  FFrequncy:=1;
  FTerminateTimeOut:=7000;
  FControl:=False;
  FMultilink:=nil;
  FTuning:=0;
  FSendTimeWait:=0;
  FSendTimeOut:=0;
  FSendTryOut:=0;
  FRecvTimeWait:=0;
  FRecvTimeOut:=0;
  FRecvTryOut:=0;
  FKeepAliveTimeOut:=0;
  FKeepAliveLive:=0;
  FTotalRecvBytes:=0;
  FTotalSentBytes:=0;
  FTempBufferSize:=1024;
  FDefaultErrorCode:=0;
  FSystemErrorCode:=0;
  FArray:=nil;
  FPeer:='';
  FCommandLine:='';
  FTelNetEchoEnable:=False;
end;

//Поток контролирующий канал в режиме сокет
procedure TChannel.SocketThreadControl;
begin
  OnConnectChannel(FFifo);
  while (FhThreading=True) and (FFifo.Active=True) do
  begin
    OnSelectChannel(FFifo);
    Sleep(FFrequncy);
  end;
  if FhThreading=False then
  begin
    if FFifo.Active=True then FFifo.Active:=False;
  end
  else
  begin
    FhThreading:=False;
  end;
  OnDisconnectChannel(FFifo);
  FDefaultErrorCode:=FFifo.DefaultErrorCode;
  FSystemErrorCode:=FFifo.SystemErrorCode;
  Socket:=False;
end;

//Получить информацию о парнере
function TChannel.GetPeerName: AnsiString;
begin
  if FPeer='' then
  begin
    if ((FTuning and CHANNEL_RECEIVER_STREAM)=CHANNEL_RECEIVER_STREAM) and ((FTuning and CHANNEL_TRANSMITTER_STREAM)=CHANNEL_TRANSMITTER_STREAM) then
    begin
      Result:='stream.';
    end
    else
    begin
      if ((FTuning and CHANNEL_RECEIVER_STREAM)<>CHANNEL_RECEIVER_STREAM) and ((FTuning and CHANNEL_TRANSMITTER_STREAM)<>CHANNEL_TRANSMITTER_STREAM) then
      begin
        Result:='packet.';
      end
      else
      begin
        Result:='composite.';
      end;
    end;
    if (FTuning and CHANNEL_CONTROL_HALFDUPLEX)=CHANNEL_CONTROL_HALFDUPLEX then
    begin
      Result:=Result+'halfduplex.';
    end
    else
    begin
      Result:=Result+'fullduplex.';
    end;
    Result:=Result+LowerCase(Copy(ClassName,2,Length(ClassName)-1));
    if (GetActive=True) and (DoPeerChannel(FPeer)=True) then Result:=Result+'.'+LowerCase(FPeer);
    FPeer:=Result;
  end
  else
  begin
    Result:=FPeer;
  end;
end;

//Получить описание ошибки
function TChannel.GetDescError: AnsiString;
begin
  case FDefaultErrorCode of
    CHANNEL_ERROR_NONE: Result:='CHANNEL_ERROR_NONE';
    CHANNEL_ERROR_LINK: Result:='CHANNEL_ERROR_LINK';
    CHANNEL_ERROR_LOST: Result:='CHANNEL_ERROR_LOST';
    CHANNEL_ERROR_KEEPALIVE: Result:='CHANNEL_ERROR_KEEPALIVE';
    CHANNEL_ERROR_SHUTDOWN: Result:='CHANNEL_ERROR_SHUTDOWN';
    CHANNEL_ERROR_OVERLOAD: Result:='CHANNEL_ERROR_OVERLOAD';
    CHANNEL_ERROR_UNDERLOAD: Result:='CHANNEL_ERROR_UNDERLOAD';
    CHANNEL_ERROR_EXCHANGE: Result:='CHANNEL_ERROR_EXCHANGE';
    CHANNEL_ERROR_FAILURE: Result:='CHANNEL_ERROR_FAILURE';
  else
    Result:='CHANNEL_ERROR_UNKNOWN ('+IntToStr(FDefaultErrorCode)+')';
  end;
  Result:=Result+' ('+IntToStr(FSystemErrorCode)+')';
end;

//Активировать канал связи
procedure TChannel.SetActive(Act: Boolean);
begin
  FCritical.Enter;
  if FInitialize=True then
  begin
    if (FActive=False) and (Act=True) then
    begin
      if DoActivateChannel(FSystemErrorCode)=True then
      begin
        Socket:=True;
        FTotalRecvBytes:=0;
        FTotalSentBytes:=0;
        FDefaultErrorCode:=CHANNEL_ERROR_NONE;
        FSystemErrorCode:=CHANNEL_ERROR_NONE;
        FPeer:='';
        FCommandLine:='';
        FKeepAliveLive:=ETAGetTickCount;
        FActive:=True;
        Thread:=True;
      end
      else
      begin
        FDefaultErrorCode:=CHANNEL_ERROR_FAILURE;
      end;
    end;
    if (FActive=True) and (Act=False) then
    begin
      Thread:=False;
      Socket:=False;
      if DoDeactivateChannel(FSystemErrorCode)=True then
      begin
        FActive:=False;
      end
      else
      begin
        FDefaultErrorCode:=CHANNEL_ERROR_FAILURE;
      end;
    end;
  end;
  FCritical.Leave;
end;

//Проверка статуса канала связи
function TChannel.GetActive: Boolean;
begin
  FCritical.Enter;
  if FActive=True then
  begin
    if DoExistsChannel(FSystemErrorCode)=True then
    begin
      if FKeepAliveTimeOut>0 then
      begin
        if ETAGetTickCount-FKeepAliveLive>=FKeepAliveTimeOut then
        begin
          if DoDeactivateChannel(FSystemErrorCode)=True then
          begin
            FDefaultErrorCode:=CHANNEL_ERROR_KEEPALIVE;
            FActive:=False;
          end
          else
          begin
            FDefaultErrorCode:=CHANNEL_ERROR_FAILURE;
            FActive:=False;
          end;
        end;
      end;
    end
    else
    begin
      if DoDeactivateChannel(FSystemErrorCode)=True then
      begin
        FDefaultErrorCode:=CHANNEL_ERROR_LINK;
        FActive:=False;
      end
      else
      begin
        FDefaultErrorCode:=CHANNEL_ERROR_FAILURE;
        FActive:=False;
      end;
    end;
  end;
  Result:=FActive;
  FCritical.Leave;
end;

//Включить сокет
procedure TChannel.SetSocket(Act: Boolean);
begin
  if (Assigned(FFifo)=False) and
     (FSocket=False) and
     (Act=True) and
     ((FTuning and CHANNEL_CONTROL_CHANNEL)<>CHANNEL_CONTROL_CHANNEL) then
  begin
    if ((FTuning and CHANNEL_RECEIVER_STREAM)=CHANNEL_RECEIVER_STREAM) then
    begin
      FSource:=TFifoStreamHalfDuplex.Create(nil);
      TFifoStreamHalfDuplex(FSource).Auto:=True;
      TFifoStreamHalfDuplex(FSource).Size:=65536;
    end
    else
    begin
      FSource:=TFifoPacketHalfDuplex.Create(nil);
      TFifoPacketHalfDuplex(FSource).Auto:=True;
      TFifoPacketHalfDuplex(FSource).Size:=65536;
    end;
    FSource.Active:=True;

    if ((FTuning and CHANNEL_TRANSMITTER_STREAM)=CHANNEL_TRANSMITTER_STREAM) then
    begin
      FDest:=TFifoStreamHalfDuplex.Create(nil);
      TFifoStreamHalfDuplex(FDest).Auto:=True;
      TFifoStreamHalfDuplex(FDest).Size:=65536;
    end
    else
    begin
      FDest:=TFifoPacketHalfDuplex.Create(nil);
      TFifoPacketHalfDuplex(FDest).Auto:=True;
      TFifoPacketHalfDuplex(FDest).Size:=65536;
    end;
    FDest.Active:=True;


    FFifo:=TChannelCompositeAutotune.Create(nil);
    TChannelCompositeAutotune(FFifo).Source:=FDest;
    TChannelCompositeAutotune(FFifo).Dest:=FSource;
    FFifo.Active:=True;
    if FFifo.Active=True then
    begin
      FControl:=True;
      FSocket:=True;
    end
    else
    begin
      FFifo.Destroy;
      FFifo:=nil;
      FSource.Destroy;
      FSource:=nil;
      FDest.Destroy;
      FDest:=nil;
    end;

  end;


  if (Assigned(FFifo)=True) and
     (FSocket=True) and
     (Act=False) and
     ((FTuning and CHANNEL_CONTROL_CHANNEL)<>CHANNEL_CONTROL_CHANNEL) then
  begin
    FFifo.Destroy;
    FFifo:=nil;
    if FControl=True then
    begin
      FSource.Destroy;
      FSource:=nil;
      FDest.Destroy;
      FDest:=nil;
    end;
    FControl:=False;
    FSocket:=False;
  end;
end;

//Включить поток
procedure TChannel.SetThread(Act: Boolean);
begin
  if (Assigned(FFifo)=True) and
     (FThread=False) and
     (Act=True) and
     ((FTuning and CHANNEL_CONTROL_CHANNEL)<>CHANNEL_CONTROL_CHANNEL) then
  begin
    if FFifo.Active=True then
    begin
      if FControl=True then
      begin
        FhThreading:=True;
        if ETACreateThread(@ChannelThreadControl,Self,FhThread)=True then
        begin
          FThread:=True;
          Exit;
        end;
        FhThreading:=False;
      end
      else
      begin
        OnConnectChannel(FFifo);
        if FFifo.Active=True then
        begin
          FThread:=True;
          Exit;
        end;
        OnDisconnectChannel(FFifo);
      end;
    end;
  end;
  if (Assigned(FFifo)=True) and
     (FThread=True) and
     (Act=False) and
     ((FTuning and CHANNEL_CONTROL_CHANNEL)<>CHANNEL_CONTROL_CHANNEL) then
  begin
    if FControl=True then
    begin
      FhThreading:=False;
      ETADestroyThread(FhThread,FTerminateTimeOut,0);
    end
    else
    begin
      if FFifo.Active=True then FFifo.Active:=False;
      OnDisconnectChannel(FFifo);
    end;
    FThread:=False;
  end;
end;

//Регулирова связи
procedure TChannel.SetTuning(Val: Byte);
begin
  if FActive=False then FTuning:=Val;
end;

//Установить внешний канал режим пассивный
procedure TChannel.SetChannel(Val: TChannel);
begin
  if FActive=False then
  begin
    if Assigned(Val)=True then
    begin
      FFifo:=Val;
      FControl:=False;
      FSocket:=True;
    end
    else
    begin
      FFifo:=nil;
      FControl:=True;
      FSocket:=False;
    end;
  end;
end;

//Установить длинну временного буфера
procedure TChannel.SetTempBufferSize(Val: TBytes);
begin
  if FActive=False then
  begin
    FTempBufferSize:=Val;
    SetLength(FArray,Val);
  end;
end;

//Время жизни канала при его неактивности
procedure TChannel.SetKeepAliveTimeOut(Value: TMillisecond);
begin
  if FActive=False then FKeepAliveTimeOut:=Value;
end;

//Отправить данные
function TChannel.SendBuf(Buf: Pointer; Len: Cardinal): Integer;
begin
  Result:=DoPumpChannel(Buf,Len,True,FSendTimeWait,FSendTimeOut,FSendTryOut,FSystemErrorCode);
end;

//Принять данные
function TChannel.RecvBuf(Buf: Pointer; Len: Cardinal): Integer;
begin
  Result:=DoPumpChannel(Buf,Len,False,FRecvTimeWait,FRecvTimeOut,FRecvTryOut,FSystemErrorCode);
end;

//Передать данные
function TChannel.SendBuf(Buf: Pointer; Len: Cardinal; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer;
begin
  Result:=DoPumpChannel(Buf,Len,True,TimeWait,TimeOut,TryOut,FSystemErrorCode);
end;

//Принять данные
function TChannel.RecvBuf(Buf: Pointer; Len: Cardinal; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer;
begin
  Result:=DoPumpChannel(Buf,Len,False,TimeWait,TimeOut,TryOut,FSystemErrorCode);
end;

//Отправка текста
function TChannel.SendStr(Str: AnsiString): Integer;
begin
  Result:=DoPumpChannel(PAnsiChar(Str),Length(Str),True,FSendTimeWait,FSendTimeOut,FSendTryOut,FSystemErrorCode);
end;

//Прием текста
function TChannel.RecvStr(var Str: AnsiString): Integer;
begin
  if ((FTuning and CHANNEL_RECEIVER_STREAM)=CHANNEL_RECEIVER_STREAM) then
  begin
    Str:='';
    Result:=DoPumpChannel(FArray,FTempBufferSize,False,FRecvTimeWait,FRecvTimeOut,FRecvTryOut,FSystemErrorCode);
    if Result>CHANNEL_ERROR_NONE then
    begin
      FArray[Result]:=#0;
      Str:=Str+PAnsiChar(FArray);
      while Result>0 do
      begin
        Result:=DoPumpChannel(FArray,FTempBufferSize,False,FRecvTimeWait,FRecvTimeOut,FRecvTryOut,FSystemErrorCode);
        if Result>CHANNEL_ERROR_NONE then
        begin
          FArray[Result]:=#0;
          Str:=Str+PAnsiChar(FArray);
        end;
      end;
    end;
    if Length(Str)>0 then Result:=Length(Str);
  end
  else
  begin
    Str:='';
    Result:=DoPumpChannel(FArray,FTempBufferSize,False,FRecvTimeWait,FRecvTimeOut,FRecvTryOut,FSystemErrorCode);
    if Result>CHANNEL_ERROR_NONE then
    begin
      FArray[Result]:=#0;
      Str:=Str+PAnsiChar(FArray);
    end;
    if Length(Str)>0 then Result:=Length(Str);
  end;
end;

//Отправка текста
function TChannel.SendStr(Str: AnsiString; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer;
begin
  Result:=DoPumpChannel(PAnsiChar(Str),Length(Str),True,TimeWait,TimeOut,TryOut,FSystemErrorCode);
end;

//Ожидание текста
function TChannel.RecvStr(var Str: AnsiString; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer;
begin
  if ((FTuning and CHANNEL_RECEIVER_STREAM)=CHANNEL_RECEIVER_STREAM) then
  begin
    Str:='';
    Result:=DoPumpChannel(FArray,FTempBufferSize,False,TimeWait,TimeOut,TryOut,FSystemErrorCode);
    if Result>0 then
    begin
      FArray[Result]:=#0;
      Str:=Str+PAnsiChar(FArray);
      while Result>0 do
      begin
        Result:=DoPumpChannel(FArray,FTempBufferSize,False,TimeWait,TimeOut,TryOut,FSystemErrorCode);
        if Result>0 then
        begin
          FArray[Result]:=#0;
          Str:=Str+PAnsiChar(FArray);
        end;
      end;
    end;
    if Length(Str)>0 then Result:=Length(Str);
  end
  else
  begin
    Str:='';
    Result:=DoPumpChannel(FArray,FTempBufferSize,False,TimeWait,TimeOut,TryOut,FSystemErrorCode);
    if Result>0 then
    begin
      FArray[Result]:=#0;
      Str:=Str+PAnsiChar(FArray);
    end;
    if Length(Str)>0 then Result:=Length(Str);
  end;
end;

//Отправка команды
function TChannel.SendCmd(Str: AnsiString): Integer;
begin
  Result:=SendBuf(PAnsiChar(Str+#13#10),Length(Str)+2);
end;

//Прием команды
function TChannel.RecvCmd(var Str: AnsiString): Integer;
var Sym: AnsiChar;
begin
  if ((FTuning and CHANNEL_RECEIVER_STREAM)=CHANNEL_RECEIVER_STREAM) then
  begin
    Result:=RecvBuf(@Sym,1);
    while Result>CHANNEL_ERROR_NONE do
    begin
      if FTelNetEchoEnable=True then Result:=SendBuf(@Sym,1);
      if (Byte(Sym)=$0D) or (Byte(Sym)=$0A) or (Byte(Sym)=$00) then
      begin
        if Length(FCommandLine)>0 then
        begin
          Str:=Trim(FCommandLine);
          FCommandLine:='';
          Result:=RecvBuf(@Sym,1);
          while Result>CHANNEL_ERROR_NONE do
          begin
            if FTelNetEchoEnable=True then Result:=SendBuf(@Sym,1);
            if (Byte(Sym)=$0D) or (Byte(Sym)=$0A) or (Byte(Sym)=$00) then
            begin
              Sleep(0);
            end
            else
            begin
              if Byte(Sym)=$08 then
              begin
                if Length(FCommandLine)>0 then Delete(FCommandLine,Length(FCommandLine),1);
              end
              else
              begin
                FCommandLine:=FCommandLine+Sym;
                Result:=Length(Str);
                Exit;
              end;
            end;
            Result:=RecvBuf(@Sym,1);
          end;
          Result:=Length(Str);
          Exit;
        end;
      end
      else
      begin
        if Byte(Sym)=$08 then
        begin
          if Length(FCommandLine)>0 then Delete(FCommandLine,Length(FCommandLine),1);
        end
        else
        begin
          FCommandLine:=FCommandLine+Sym;
        end;
      end;
      Result:=RecvBuf(@Sym,1);
    end;
    if (Result=CHANNEL_ERROR_LINK) and (Length(FCommandLine)>0) then
    begin
      Str:=Trim(FCommandLine);
      Result:=Length(FCommandLine);
      FCommandLine:='';
    end;
  end
  else
  begin
    Result:=RecvBuf(FArray,FTempBufferSize);
    if Result>CHANNEL_ERROR_NONE then
    begin
      FArray[Result]:=#0;
      Str:=Trim(PAnsiChar(FArray));
      Result:=Length(Str);
    end;
  end;
end;

//Отправка команды
function TChannel.TranCmd(Str: AnsiString; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer;
begin
  Result:=SendBuf(PAnsiChar(Str+#13#10),Length(Str)+2,TimeWait,TimeOut,TryOut);
end;

//Ожидание текста
function TChannel.WaitCmd(var Str: AnsiString; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond): Integer;
var Sym: AnsiChar;
begin
  if ((FTuning and CHANNEL_RECEIVER_STREAM)=CHANNEL_RECEIVER_STREAM) then
  begin
    Result:=RecvBuf(@Sym,1,TimeWait,TimeOut,TryOut);
    while Result>CHANNEL_ERROR_NONE do
    begin
      Result:=CHANNEL_ERROR_NONE;
      if (Byte(Sym)=$0D) or (Byte(Sym)=$0A) then
      begin
        if Length(FCommandLine)>0 then
        begin
          Str:=Trim(FCommandLine);
          Result:=Length(FCommandLine);
          FCommandLine:='';
          Exit;
        end;
      end
      else
      begin
        if Byte(Sym)=$08 then
        begin
          if Length(FCommandLine)>0 then Delete(FCommandLine,Length(FCommandLine),1);
        end
        else
        begin
          FCommandLine:=FCommandLine+Sym;
        end;
      end;
      Result:=RecvBuf(@Sym,1,TimeWait,TimeOut,TryOut);
    end;
    if (Result=CHANNEL_ERROR_LINK) and (Length(FCommandLine)>0) then
    begin
      Str:=Trim(FCommandLine);
      Result:=Length(FCommandLine);
      FCommandLine:='';
    end;
  end
  else
  begin
    Result:=RecvBuf(FArray,FTempBufferSize,TimeWait,TimeOut,TryOut);
    if Result>CHANNEL_ERROR_NONE then
    begin
      FArray[Result]:=#0;
      Str:=Trim(PAnsiChar(FArray));
      Result:=Length(Str);
    end;
  end;
end;

//Ожидание отправки данных из буфера передатчика
//Отчистка буфера приемника
function TChannel.Flush: Boolean;
begin
  FCritical.Enter;
  if FActive=True then
  begin
    if FSocket=True then
    begin
      Result:=FFifo.Flush;
    end
    else
    begin
      Result:=DoFlushChannel(FSystemErrorCode);
    end;
  end
  else
  begin
    Result:=False;
  end;
  FCritical.Leave;
end;

//Завершение работы с каналом
function TChannel.Shutdown(Error: Integer): Boolean;
begin
  Result:=False;
  FCritical.Enter;
  if (FInitialize=True) and (FActive=True) then
  begin
    Thread:=False;
    Socket:=False;
    if DoFlushChannel(FSystemErrorCode)=True then
    begin
      if DoDeactivateChannel(FSystemErrorCode)=True then
      begin
        FDefaultErrorCode:=CHANNEL_ERROR_SHUTDOWN;
        FSystemErrorCode:=Error;
        FActive:=False;
        Result:=True;
      end
      else
      begin
        FDefaultErrorCode:=CHANNEL_ERROR_FAILURE;
      end;
    end
    else
    begin
      if DoDeactivateChannel(FSystemErrorCode)=True then
      begin
        FDefaultErrorCode:=CHANNEL_ERROR_FAILURE;
        FSystemErrorCode:=Error;
        FActive:=False;
        Result:=True;
      end
      else
      begin
        FDefaultErrorCode:=CHANNEL_ERROR_FAILURE;
      end;
    end;
  end;
  FCritical.Leave;
end;

//Синхронизация в режиме сокет
function TChannel.Sync: Boolean;
begin
  Result:=False;
  if (FInitialize=True) and
     (FActive=True) and
     (FControl=False) and
     (Assigned(FFifo)=True) and
     (FFifo.Active=True) then
  begin
    OnSelectChannel(FFifo);
    Result:=FFifo.Active;
  end;
end;

//Системная функция транспортировки данных
function TChannel.DoPumpChannel(Buf: Pointer; Len: Cardinal; Delivery: Boolean; TimeWait: TMillisecond; TimeOut: TMillisecond; TryOut: TMillisecond; var Error: Integer): Integer;
var RLen: Cardinal;
    FTickTime: TMillisecond;
begin
  if GetActive=True then
  begin
    if (Assigned(Buf)=True) and (Len>0) then
    begin
      if (FTuning and CHANNEL_CONTROL_HALFDUPLEX)=CHANNEL_CONTROL_HALFDUPLEX then FCritical.Enter;
      RLen:=0;
      if TimeWait>0 then
      begin
        Result:=CHANNEL_ERROR_NONE;
        FTickTime:=ETAGetTickCount;
        while (Result=CHANNEL_ERROR_NONE) and ((ETAGetTickCount-FTickTime)<TimeWait) do
        begin
          if DoExistsChannel(Error)=True then
          begin
            if Delivery=True then
            begin
              if Assigned(FDest)=True then
              begin
                Result:=FDest.DoPumpChannel(Buf,Len,Delivery,0,0,0,Error);
              end
              else
              begin
                Result:=DoSendChannel(Buf,Len,Error);
              end;
            end
            else
            begin
              if Assigned(FSource)=True then
              begin
                Result:=FSource.DoPumpChannel(Buf,Len,Delivery,0,0,0,Error);
              end
              else
              begin
                Result:=DoRecvChannel(Buf,Len,Error);
              end;
            end;
            if Result=0 then Sleep(TryOut);
          end
          else
          begin
            Result:=CHANNEL_ERROR_LINK;
          end;
        end;
      end
      else
      begin
        if DoExistsChannel(Error)=True then
        begin
          if Delivery=True then
          begin
            if Assigned(FDest)=True then
            begin
              Result:=FDest.DoPumpChannel(Buf,Len,Delivery,0,0,0,Error);
            end
            else
            begin
              Result:=DoSendChannel(Buf,Len,Error);
            end;
          end
          else
          begin
            if Assigned(FSource)=True then
            begin
              Result:=FSource.DoPumpChannel(Buf,Len,Delivery,0,0,0,Error);
            end
            else
            begin
              Result:=DoRecvChannel(Buf,Len,Error);
            end;
          end;
        end
        else
        begin
          Result:=CHANNEL_ERROR_LINK;
        end;
      end;
      if Result=CHANNEL_ERROR_LINK then FDefaultErrorCode:=CHANNEL_ERROR_LOST;
      if (Result>0) and ((FTuning and CHANNEL_RECEIVER_STREAM)<>CHANNEL_RECEIVER_STREAM) then Len:=Result;
      if (Result>0) and (Result<Len) then
      begin
        RLen:=RLen+Result;
        Len:=Len-Result;
        Buf:=Pointer(Cardinal(Buf)+Result);
        if TimeOut>0 then
        begin
          FTickTime:=ETAGetTickCount;
          while (Result<>CHANNEL_ERROR_LINK) and (Len>0) and ((ETAGetTickCount-FTickTime)<TimeOut) do
          begin
            if DoExistsChannel(Error)=True then
            begin
              if Delivery=True then
              begin
                if Assigned(FDest)=True then
                begin
                  Result:=FDest.DoPumpChannel(Buf,Len,Delivery,0,0,0,Error);
                end
                else
                begin
                  Result:=DoSendChannel(Buf,Len,Error);
                end;
              end
              else
              begin
                if Assigned(FSource)=True then
                begin
                  Result:=FSource.DoPumpChannel(Buf,Len,Delivery,0,0,0,Error);
                end
                else
                begin
                  Result:=DoRecvChannel(Buf,Len,Error);
                end;
              end;
              if Result=0 then Sleep(TryOut);
            end
            else
            begin
              Result:=CHANNEL_ERROR_LINK;
            end;
            if Result=CHANNEL_ERROR_LINK then FDefaultErrorCode:=CHANNEL_ERROR_LOST;
            if (Result>0) and ((FTuning and CHANNEL_RECEIVER_STREAM)<>CHANNEL_RECEIVER_STREAM) then Len:=Result;
            if Result>0 then
            begin
              RLen:=RLen+Result;
              Len:=Len-Result;
              Buf:=Pointer(Cardinal(Buf)+Result);
              FTickTime:=ETAGetTickCount;
            end;
          end;
        end
        else
        begin
          while (Result>CHANNEL_ERROR_NONE) and (Len>0) do
          begin
            if DoExistsChannel(Error)=True then
            begin
              if Delivery=True then
              begin
                if Assigned(FDest)=True then
                begin
                  Result:=FDest.DoPumpChannel(Buf,Len,Delivery,0,0,0,Error);
                end
                else
                begin
                  Result:=DoSendChannel(Buf,Len,Error);
                end;
              end
              else
              begin
                if Assigned(FSource)=True then
                begin
                  Result:=FSource.DoPumpChannel(Buf,Len,Delivery,0,0,0,Error);
                end
                else
                begin
                  Result:=DoRecvChannel(Buf,Len,Error);
                end;
              end;
            end
            else
            begin
              Result:=CHANNEL_ERROR_LINK;
            end;
            if Result=CHANNEL_ERROR_LINK then FDefaultErrorCode:=CHANNEL_ERROR_LOST;
            if (Result>0) and ((FTuning and CHANNEL_RECEIVER_STREAM)<>CHANNEL_RECEIVER_STREAM) then Len:=Result;
            if Result>0 then
            begin
              RLen:=RLen+Result;
              Len:=Len-Result;
              Buf:=Pointer(Cardinal(Buf)+Result);
            end;
          end;
        end;
        if Result=CHANNEL_ERROR_LINK then
        begin
          if RLen>0 then Result:=RLen;
        end
        else
        begin
          Result:=RLen;
        end;
      end;
      if Result>CHANNEL_ERROR_NONE then
      begin
        FKeepAliveLive:=ETAGetTickCount;
        if Delivery=True then FTotalSentBytes:=FTotalSentBytes+Result else FTotalRecvBytes:=FTotalRecvBytes+Result;
        if ((FTuning and CHANNEL_CONTROL_OVERLOAD)=CHANNEL_CONTROL_OVERLOAD) and (Result>Len) then
        begin
          FDefaultErrorCode:=CHANNEL_ERROR_OVERLOAD;
          Error:=CHANNEL_ERROR_NONE;
          Result:=CHANNEL_ERROR_LINK;
        end;
        if ((FTuning and CHANNEL_CONTROL_UNDERLOAD)=CHANNEL_CONTROL_UNDERLOAD) and (Result<Len) then
        begin
          FDefaultErrorCode:=CHANNEL_ERROR_UNDERLOAD;
          Error:=CHANNEL_ERROR_NONE;
          Result:=CHANNEL_ERROR_LINK;
        end;
      end
      else
      begin
        if (Result=CHANNEL_ERROR_NONE) and ((FTuning and CHANNEL_CONTROL_EXCHANGE)=CHANNEL_CONTROL_EXCHANGE) then
        begin
          FDefaultErrorCode:=CHANNEL_ERROR_EXCHANGE;
          Error:=CHANNEL_ERROR_NONE;
          Result:=CHANNEL_ERROR_LINK;
        end;
      end;
      if (FTuning and CHANNEL_CONTROL_HALFDUPLEX)=CHANNEL_CONTROL_HALFDUPLEX then FCritical.Leave;
      if Result=CHANNEL_ERROR_LINK then SetActive(False);
    end
    else
    begin
      Result:=CHANNEL_ERROR_NONE;
    end;
  end
  else
  begin
    Result:=CHANNEL_ERROR_LINK;
  end;
end;

//Инициализация канала
function TChannel.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Деинициализация канала
function TChannel.DoDeinitializeChannel(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Активация канала
function TChannel.DoActivateChannel(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Деактивация канала
function TChannel.DoDeactivateChannel(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Имя партнера
function TChannel.DoPeerChannel(var Peer: AnsiString): Boolean;
begin
  Result:=False;
end;

//Канал существует
function TChannel.DoExistsChannel(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Сбросить буферы канала
function TChannel.DoFlushChannel(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Отправить данные
function TChannel.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=CHANNEL_ERROR_NONE;
end;

//Принять данные
function TChannel.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=CHANNEL_ERROR_NONE;
end;

//Подлючение канала к сокету
procedure TChannel.OnConnectChannel(Socket: TChannel);
begin
  //
end;

//Отключение канала от сокета
procedure TChannel.OnDisconnectChannel(Socket: TChannel);
begin
  //
end;

//Выборка
procedure TChannel.OnSelectChannel(Socket: TChannel);
begin
  //
end;

//------------------------------------------------------------------------------
// {TChannelStreamFullDuplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TChannelStreamFullDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=CHANNEL_STREAM_FULLDUPLEX;
  Result:=True;
end;

//Передать данные
function TChannelStreamFullDuplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//Принять данные
function TChannelStreamFullDuplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//------------------------------------------------------------------------------
// {TChannelStreamHalfDuplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TChannelStreamHalfDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=CHANNEL_STREAM_HALFDUPLEX;
  Result:=True;
end;

//Передать данные
function TChannelStreamHalfDuplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//Принять данные
function TChannelStreamHalfDuplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//------------------------------------------------------------------------------
// {TChannelStreamRecvSimplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TChannelStreamRecvSimplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=CHANNEL_STREAM_RECVSIMPLEX;
  Result:=True;
end;

//Передать данные
function TChannelStreamRecvSimplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=CHANNEL_ERROR_NONE;
end;

//Получить данные
function TChannelStreamRecvSimplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//------------------------------------------------------------------------------
// {TChannelStreamSendSimplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TChannelStreamSendSimplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=CHANNEL_STREAM_SENDSIMPLEX;
  Result:=True;
end;

//Передать данные
function TChannelStreamSendSimplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//Получить данные
function TChannelStreamSendSimplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=CHANNEL_ERROR_NONE;
end;

//------------------------------------------------------------------------------
// {TChannelPacketFullDuplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TChannelPacketFullDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=CHANNEL_PACKET_FULLDUPLEX;
  Result:=True;
end;

//Отправить данные
function TChannelPacketFullDuplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//Принять данные
function TChannelPacketFullDuplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//------------------------------------------------------------------------------
// {TChannelPacketHalfDuplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TChannelPacketHalfDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=CHANNEL_PACKET_HALFDUPLEX;
  Result:=True;
end;

//Отправить данные
function TChannelPacketHalfDuplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//Отправить данные
function TChannelPacketHalfDuplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//------------------------------------------------------------------------------
// {TChannelPacketRecvSimplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TChannelPacketRecvSimplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=CHANNEL_PACKET_RECVSIMPLEX;
  Result:=True;
end;

//Отправить данные
function TChannelPacketRecvSimplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=CHANNEL_ERROR_NONE;
end;

//Принять данные
function TChannelPacketRecvSimplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//------------------------------------------------------------------------------
// {TChannelPacketSendSimplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TChannelPacketSendSimplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=CHANNEL_PACKET_SENDSIMPLEX;
  Result:=True;
end;

//Отправить данные
function TChannelPacketSendSimplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=Len;
end;

//Принять данные
function TChannelPacketSendSimplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=CHANNEL_ERROR_NONE;
end;

//------------------------------------------------------------------------------
// {TChannelCompositeAutotune}
//------------------------------------------------------------------------------

//Инициализация канала
function TChannelCompositeAutotune.DoInitializeChannel(var Error: Integer): Boolean;
begin
  FSource:=nil;
  FDest:=nil;
  Result:=True;
end;

//Активация канала
function TChannelCompositeAutotune.DoActivateChannel(var Error: Integer): Boolean;
begin
  Result:=False;
  if (Assigned(FSource)=True) and (Assigned(FDest)=True) then
  begin
    Tuning:=CHANNEL_CONTROL_FULLDUPLEX + CHANNEL_CONTROL_CHANNEL;
    if ((FSource.Tuning and CHANNEL_RECEIVER_STREAM)=CHANNEL_RECEIVER_STREAM) then Tuning:=Tuning+CHANNEL_RECEIVER_STREAM else Tuning:=Tuning+CHANNEL_RECEIVER_PACKET;
    if ((FDest.Tuning and CHANNEL_TRANSMITTER_STREAM)=CHANNEL_TRANSMITTER_STREAM) then Tuning:=Tuning+CHANNEL_TRANSMITTER_STREAM else Tuning:=Tuning+CHANNEL_TRANSMITTER_PACKET;
    if ((Tuning and CHANNEL_RECEIVER_STREAM)=CHANNEL_RECEIVER_STREAM) and ((Tuning and CHANNEL_TRANSMITTER_STREAM)=CHANNEL_TRANSMITTER_STREAM) then
    begin
      TempBufferSize:=1024;
    end
    else
    begin
      TempBufferSize:=65536;
    end;
    if FSource.Active=True then
    begin
      if FDest.Active=True then
      begin
        Result:=True;
      end
      else
      begin
        Error:=FDest.SystemErrorCode;
      end;
    end
    else
    begin
      Error:=FSource.SystemErrorCode;
    end;
  end;
end;

//Проверка канала
function TChannelCompositeAutotune.DoExistsChannel(var Error: Integer): Boolean;
begin
  Result:=False;
  if FSource.Active=True then
  begin
    if FDest.Active=True then
    begin
      Result:=True;
    end
    else
    begin
      Error:=FDest.SystemErrorCode;
    end;
  end
  else
  begin
    Error:=FSource.SystemErrorCode;
  end;
end;

//Отчистка буферов канала
function TChannelCompositeAutotune.DoFlushChannel(var Error: Integer): Boolean;
begin
  Result:=FSource.Flush and FDest.Flush;
end;

//Композитный канал
function TChannelCompositeAutotune.DoPeerChannel(var Peer: AnsiString): Boolean;
begin
  Peer:='composite(['+FSource.Peer+'].['+FDest.Peer+'])';
  Result:=True;
end;

//Отправить данные
function TChannelCompositeAutotune.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=FDest.SendBuf(Buf,Len);
end;

function TChannelCompositeAutotune.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=FSource.RecvBuf(Buf,Len);
end;

//Установить канал
procedure TChannelCompositeAutotune.SetSource(Val: TChannel);
begin
  if Active=False then FSource:=Val;
end;

//Установить канал
procedure TChannelCompositeAutotune.SetDest(Val: TChannel);
begin
  if Active=False then FDest:=Val;
end;

//------------------------------------------------------------------------------
// {TFifoStreamHalfDuplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TFifoStreamHalfDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  FQueneTotalSize:=65536;
  FQueneBaseBuf:=nil;
  FQueneFreeSize:=0;
  FQueneBusySize:=0;
  FQuenePutIndex:=0;
  FQueneGetIndex:=0;
  FQueneAuto:=False;
  Result:=inherited DoInitializeChannel(Error);
end;

//Активация канала
function TFifoStreamHalfDuplex.DoActivateChannel(var Error: Integer): Boolean;
begin
  Result:=False;
  if FQueneTotalSize>0 then
  begin
    SetLength(FQueneBaseBuf,FQueneTotalSize);
    if Assigned(FQueneBaseBuf)=True then
    begin
      FQueneFreeSize:=FQueneTotalSize;
      FQueneBusySize:=0;
      FQuenePutIndex:=0;
      FQueneGetIndex:=0;
      Result:=True;
    end;
  end;
end;

//Деактивация канала
function TFifoStreamHalfDuplex.DoDeactivateChannel(var Error: Integer): Boolean;
begin
  if Assigned(FQueneBaseBuf)=True then
  begin
    FQueneBaseBuf:=nil;
    FQueneFreeSize:=0;
    FQueneBusySize:=0;
    FQuenePutIndex:=0;
    FQueneGetIndex:=0;
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Имя канала
function TFifoStreamHalfDuplex.DoPeerChannel(var Peer: AnsiString): Boolean;
begin
  Peer:='fifo.'+IntToStr(FQueneTotalSize);
  Result:=True;
end;

//Отправка данных в очередь
function TFifoStreamHalfDuplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=CHANNEL_ERROR_NONE;
  if FQueneAuto=True then
  begin
    if FQueneFreeSize>=Len then
    begin
      for Result:=0 to Len-1 do
      begin
        if PutQueneByte(PByteArray(Buf)[Result])=CHANNEL_ERROR_NONE then Exit;
      end;
    end
    else
    begin
      SetLength(FQueneBaseBuf,(Len-FQueneFreeSize)+FQueneTotalSize);
      FQueneTotalSize:=FQueneTotalSize+(Len-FQueneFreeSize);
      FQueneFreeSize:=FQueneFreeSize+(Len-FQueneFreeSize);
      for Result:=0 to Len-1 do
      begin
        if PutQueneByte(PByteArray(Buf)[Result])=CHANNEL_ERROR_NONE then Exit;
      end;
    end;
  end
  else
  begin
    for Result:=0 to Len-1 do
    begin
      if PutQueneByte(PByteArray(Buf)[Result])=CHANNEL_ERROR_NONE then Exit;
    end;
  end;
end;

//Прием данных из очереди
function TFifoStreamHalfDuplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=CHANNEL_ERROR_NONE;
  for Result:=0 to Len-1 do
  begin
    if GetQueneByte(PByteArray(Buf)[Result])=CHANNEL_ERROR_NONE then Exit;
  end;
end;

//Установить автоматический контроль буфера
procedure TFifoStreamHalfDuplex.SetQueneAuto(Value: Boolean);
begin
  if Active=False then FQueneAuto:=Value;
end;

//Установить размер очереди
procedure TFifoStreamHalfDuplex.SetQueneTotalSize(Value: Cardinal);
begin
  if Active=False then FQueneTotalSize:=Value;
end;

//Положить байт в конец очередь
function TFifoStreamHalfDuplex.PutQueneByte(Val: Byte): Integer;
begin
  if (FQueneFreeSize>=1) then
  begin
    if FQuenePutIndex>=FQueneTotalSize then FQuenePutIndex:=0;
    FQueneBaseBuf[FQuenePutIndex]:=Val;
    FQuenePutIndex:=FQuenePutIndex+1;
    FQueneFreeSize:=FQueneFreeSize-1;
    FQueneBusySize:=FQueneBusySize+1;
    Result:=1;
  end
  else
  begin
    Result:=CHANNEL_ERROR_NONE;
  end;
end;

//Получить байт из начала очереди
function TFifoStreamHalfDuplex.GetQueneByte(var Val: Byte): Integer;
begin
  if (FQueneBusySize>=1) then
  begin
    if FQueneGetIndex>=FQueneTotalSize then FQueneGetIndex:=0;
    Val:=FQueneBaseBuf[FQueneGetIndex];
    FQueneGetIndex:=FQueneGetIndex+1;
    FQueneFreeSize:=FQueneFreeSize+1;
    FQueneBusySize:=FQueneBusySize-1;
    Result:=1;
  end
  else
  begin
    Result:=CHANNEL_ERROR_NONE;
  end;
end;

//------------------------------------------------------------------------------
// {TFifoPacketHalfDuplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TFifoPacketHalfDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  FQueneTotalSize:=65536;
  FQueneBaseBuf:=nil;
  FQueneFreeSize:=0;
  FQueneBusySize:=0;
  FQuenePutIndex:=0;
  FQueneGetIndex:=0;
  FQuenePackCount:=0;
  FQueneAuto:=False;
  Result:=inherited DoInitializeChannel(Error);
end;

//Активация канала
function TFifoPacketHalfDuplex.DoActivateChannel(var Error: Integer): Boolean;
begin
  Result:=False;
  if FQueneTotalSize>0 then
  begin
    SetLength(FQueneBaseBuf,FQueneTotalSize);
    if Assigned(FQueneBaseBuf)=True then
    begin
      FQueneFreeSize:=FQueneTotalSize;
      FQueneBusySize:=0;
      FQuenePutIndex:=0;
      FQueneGetIndex:=0;
      FQuenePackCount:=0;
      Result:=True;
    end;
  end;
end;

//Деактивация канала
function TFifoPacketHalfDuplex.DoDeactivateChannel(var Error: Integer): Boolean;
begin
  if Assigned(FQueneBaseBuf)=True then
  begin
    FQueneBaseBuf:=nil;
    FQueneFreeSize:=0;
    FQueneBusySize:=0;
    FQuenePutIndex:=0;
    FQueneGetIndex:=0;
    FQuenePackCount:=0;
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Владелец канала
function TFifoPacketHalfDuplex.DoPeerChannel(var Peer: AnsiString): Boolean;
begin
  Peer:='fifo.'+IntToStr(FQueneTotalSize);
  Result:=True;
end;

//Отправка данных в очередь
function TFifoPacketHalfDuplex.DoSendChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
begin
  Result:=CHANNEL_ERROR_NONE;
  if FQueneAuto=True then
  begin
    if FQueneFreeSize>=Len+5 then
    begin
      if PutQueneByte($FF)=1 then
      begin
        if (PutQueneByte(PByteArray(@Len)[0])=1) and (PutQueneByte(PByteArray(@Len)[1])=1) then
        begin
          if (PutQueneByte(PByteArray(@Len)[2])=1) and (PutQueneByte(PByteArray(@Len)[3])=1) then
          begin
            while Len>0 do
            begin
              if PutQueneByte(PByteArray(Buf)[Result])=CHANNEL_ERROR_NONE then
              begin
                FQuenePackCount:=FQuenePackCount+1;
                Exit;
              end;
              Result:=Result+1;
              Len:=Len-1;
            end;
            FQuenePackCount:=FQuenePackCount+1;
          end;
        end;
      end;
    end
    else
    begin
      SetLength(FQueneBaseBuf,((Len+5)-FQueneFreeSize)+FQueneTotalSize);
      FQueneTotalSize:=FQueneTotalSize+((Len+5)-FQueneFreeSize);
      FQueneFreeSize:=FQueneFreeSize+((Len+5)-FQueneFreeSize);
      if PutQueneByte($FF)=1 then
      begin
        if (PutQueneByte(PByteArray(@Len)[0])=1) and (PutQueneByte(PByteArray(@Len)[1])=1) then
        begin
          if (PutQueneByte(PByteArray(@Len)[2])=1) and (PutQueneByte(PByteArray(@Len)[3])=1) then
          begin
            while Len>0 do
            begin
              if PutQueneByte(PByteArray(Buf)[Result])=CHANNEL_ERROR_NONE then
              begin
                FQuenePackCount:=FQuenePackCount+1;
                Exit;
              end;
              Result:=Result+1;
              Len:=Len-1;
            end;
            FQuenePackCount:=FQuenePackCount+1;
          end;
        end;
      end;
    end;
  end
  else
  begin
    if FQueneFreeSize>=Len+5 then
    begin
      if PutQueneByte($FF)=1 then
      begin
        if (PutQueneByte(PByteArray(@Len)[0])=1) and (PutQueneByte(PByteArray(@Len)[1])=1) then
        begin
          if (PutQueneByte(PByteArray(@Len)[2])=1) and (PutQueneByte(PByteArray(@Len)[3])=1) then
          begin
            while Len>0 do
            begin
              if PutQueneByte(PByteArray(Buf)[Result])=CHANNEL_ERROR_NONE then
              begin
                FQuenePackCount:=FQuenePackCount+1;
                Exit;
              end;
              Result:=Result+1;
              Len:=Len-1;
            end;
            FQuenePackCount:=FQuenePackCount+1;
          end;
        end;
      end;
    end;
  end;
end;

//Прием данных из очереди
function TFifoPacketHalfDuplex.DoRecvChannel(Buf: Pointer; Len: Cardinal; var Error: Integer): Integer;
var Val: Byte;
    Lng: Cardinal;
begin
  Result:=CHANNEL_ERROR_NONE;
  if (GetQueneByte(Val)=1) and (Val=$FF) then
  begin
    if (GetQueneByte(PByteArray(@Lng)[0])=1) and (GetQueneByte(PByteArray(@Lng)[1])=1) then
    begin
      if (GetQueneByte(PByteArray(@Lng)[2])=1) and (GetQueneByte(PByteArray(@Lng)[3])=1) then
      begin
        if Lng<=Len then
        begin
          while Lng>0 do
          begin
            if GetQueneByte(PByteArray(Buf)[Result])=CHANNEL_ERROR_NONE then
            begin
              FQuenePackCount:=FQuenePackCount-1;
              Exit;
            end;
            Result:=Result+1;
            Lng:=Lng-1;
          end;
          FQuenePackCount:=FQuenePackCount-1;
        end
        else
        begin
          if (RstQueneByte(PByteArray(Lng)[3])=1) and (RstQueneByte(PByteArray(Lng)[2])=1) then
          begin
            if (RstQueneByte(PByteArray(Lng)[1])=1) and (RstQueneByte(PByteArray(Lng)[0])=1) then
            begin
              if RstQueneByte($FF)<>CHANNEL_ERROR_NONE then Exit;
            end;
          end;
        end;
      end;
    end;
  end;
end;

//Установить автоматический контроль буфера
procedure TFifoPacketHalfDuplex.SetQueneAuto(Value: Boolean);
begin
  if Active=False then FQueneAuto:=Value;
end;

//Установить размер очереди
procedure TFifoPacketHalfDuplex.SetQueneTotalSize(Value: Cardinal);
begin
  if Active=False then FQueneTotalSize:=Value;
end;

//Положить байт в конец очередь
function TFifoPacketHalfDuplex.PutQueneByte(Val: Byte): Integer;
begin
  if (FQueneFreeSize>=1) then
  begin
    if FQuenePutIndex>=FQueneTotalSize then FQuenePutIndex:=0;
    FQueneBaseBuf[FQuenePutIndex]:=Val;
    FQuenePutIndex:=FQuenePutIndex+1;
    FQueneFreeSize:=FQueneFreeSize-1;
    FQueneBusySize:=FQueneBusySize+1;
    Result:=1;
  end
  else
  begin
    Result:=CHANNEL_ERROR_NONE;
  end;
end;

//Получить байт из начала очереди
function TFifoPacketHalfDuplex.GetQueneByte(var Val: Byte): Integer;
begin
  if (FQueneBusySize>=1) then
  begin
    if FQueneGetIndex>=FQueneTotalSize then FQueneGetIndex:=0;
    Val:=FQueneBaseBuf[FQueneGetIndex];
    FQueneGetIndex:=FQueneGetIndex+1;
    FQueneFreeSize:=FQueneFreeSize+1;
    FQueneBusySize:=FQueneBusySize-1;
    Result:=1;
  end
  else
  begin
    Result:=CHANNEL_ERROR_NONE;
  end;
end;

//Положить байт в начало очедери (РЕАЛИЗОВАТЬ!!!!)
function TFifoPacketHalfDuplex.RstQueneByte(Val: Byte): Integer;
begin
  Result:=CHANNEL_ERROR_LINK;
end;

//------------------------------------------------------------------------------
// {TSocket}
//------------------------------------------------------------------------------

//Инициализация канала
function TSocket.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Result:=DoInitializeSocket(Error);
end;

//Деинициализация канала
function TSocket.DoDeinitializeChannel(var Error: Integer): Boolean;
begin
  Result:=DoDeinitializeSocket(Error);
end;

//Активация канала
function TSocket.DoActivateChannel(var Error: Integer): Boolean;
begin
  Result:=DoActivateSocket(Error);
end;

//Деактивация канала
function TSocket.DoDeactivateChannel(var Error: Integer): Boolean;
begin
  Result:=DoDeactivateSocket(Error);
end;

//Назначить имя Peer канала
function TSocket.DoPeerChannel(var Peer: AnsiString): Boolean;
begin
  Result:=DoPeerSocket(Peer);
end;

//Проверка связи с каналом
function TSocket.DoExistsChannel(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Отчистка буфера канала
function TSocket.DoFlushChannel(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Подключение канала
procedure TSocket.OnConnectChannel(Socket: TChannel);
begin
  OnConnectSocket(Socket);
end;

//Отключение канала
procedure TSocket.OnDisconnectChannel(Socket: TChannel);
begin
  OnDisconnectSocket(Socket);
end;

//Обработка события подключения канала
procedure TSocket.OnSelectChannel(Socket: TChannel);
begin
  OnSelectSocket(Socket);
end;

//Инициализация сокета
function TSocket.DoInitializeSocket(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Инициализация сокета
function TSocket.DoDeinitializeSocket(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Активация
function TSocket.DoActivateSocket(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Деактивация
function TSocket.DoDeactivateSocket(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Имя сокета
function TSocket.DoPeerSocket(var Peer: AnsiString): Boolean;
begin
  Result:=False;
end;

//Обработка события подключения канала к сокету
procedure TSocket.OnConnectSocket(Socket: TChannel);
begin
  //Тут реализация
end;

//Обработка события отключения канала от сокета
procedure TSocket.OnDisconnectSocket(Socket: TChannel);
begin
  //Тут реализация
end;

//Обработка события синхронизации с каналом
procedure TSocket.OnSelectSocket(Socket: TChannel);
begin
  //Тут реализация
end;

//------------------------------------------------------------------------------
// {TSocketStreamFullDuplex}
//------------------------------------------------------------------------------

//Инициализация канала
function TSocketStreamFullDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=SOCKET_STREAM_FULLDUPLEX;
  Result:=inherited DoInitializeChannel(Error);
end;

//------------------------------------------------------------------------------
// {TSocketStreamHalfDuplex}
//------------------------------------------------------------------------------

function TSocketStreamHalfDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=SOCKET_STREAM_HALFDUPLEX;
  Result:=inherited DoInitializeChannel(Error);
end;

//------------------------------------------------------------------------------
// {TSocketStreamRecvSimplex)
//------------------------------------------------------------------------------

function TSocketStreamRecvSimplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=SOCKET_STREAM_RECVSIMPLEX;
  Result:=inherited DoInitializeChannel(Error);
end;

//------------------------------------------------------------------------------
// {TSocketStreamSendSimplex)
//------------------------------------------------------------------------------

function TSocketStreamSendSimplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=SOCKET_STREAM_SENDSIMPLEX;
  Result:=inherited DoInitializeChannel(Error);
end;

//------------------------------------------------------------------------------
// {TSocketPacketFullDuplex)
//------------------------------------------------------------------------------

function TSocketPacketFullDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=SOCKET_PACKET_FULLDUPLEX;
  Result:=inherited DoInitializeChannel(Error);
end;

//------------------------------------------------------------------------------
// {TSocketPacketHalfDuplex)
//------------------------------------------------------------------------------

function TSocketPacketHalfDuplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=SOCKET_PACKET_HALFDUPLEX;
  Result:=inherited DoInitializeChannel(Error);
end;

//------------------------------------------------------------------------------
// {TSocketPacketRecvSimplex)
//------------------------------------------------------------------------------

function TSocketPacketRecvSimplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=SOCKET_PACKET_RECVSIMPLEX;
  Result:=inherited DoInitializeChannel(Error);
end;

//------------------------------------------------------------------------------
// {TSocketPacketSendSimplex)
//------------------------------------------------------------------------------

function TSocketPacketSendSimplex.DoInitializeChannel(var Error: Integer): Boolean;
begin
  Tuning:=SOCKET_PACKET_RECVSIMPLEX;
  Result:=inherited DoInitializeChannel(Error);
end;

//------------------------------------------------------------------------------
// {TMultilink}
//------------------------------------------------------------------------------

//Время жизни канала при тишине в канале
procedure TMultilink.SetKeepAliveChild(Val: TMillisecond);
begin
  if Active=False then FKeepAliveChild:=Val;
end;

//Инициализация канала
function TMultilink.DoInitializeChannel(var Error: Integer): Boolean;
begin
  FKeepAliveChild:=0;
  Tuning:=SOCKET_PACKET_RECVSIMPLEX;
  Result:=DoInitializeMultilink(Error);
end;

//Деинициализация канала
function TMultilink.DoDeinitializeChannel(var Error: Integer): Boolean;
begin
  Result:=DoDeinitializeMultilink(Error);
end;

//Активация канала
function TMultilink.DoActivateChannel(var Error: Integer): Boolean;
begin
  Result:=DoActivateMultilink(Error);
end;

//Деактивация канала
function TMultilink.DoDeactivateChannel(var Error: Integer): Boolean;
begin
  Result:=DoDeactivateMultilink(Error);
end;

//Подключение канала
procedure TMultilink.OnConnectChannel(Socket: TChannel);
begin
  OnConnectMultilink(Socket);
end;

//Отключение канала
procedure TMultilink.OnDisconnectChannel(Socket: TChannel);
begin
  OnDisconnectMultilink(Socket);
end;

//Выборка
procedure TMultilink.OnSelectChannel(Socket: TChannel);
begin
  OnSelectMultilink(Socket);
end;

//Зарегистрировать канал
function TMultilink.ApiRegisterChild(Socket: TChannel; Child: TChannel): Boolean;
begin
  if (Assigned(Socket)=True) and
     (Assigned(Child)=True) and
     (Child.Active=True) and
     (Socket.SendBuf(@Child,SizeOf(TChannel))=SizeOf(TChannel)) then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Инициализация мультилинка
function TMultilink.DoInitializeMultilink(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Деинициализация мультилинка
function TMultilink.DoDeinitializeMultilink(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Активация мультилинка
function TMultilink.DoActivateMultilink(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Деактивация мультилинка
function TMultilink.DoDeactivateMultilink(var Error: Integer): Boolean;
begin
  Result:=True;
end;

//Подкличение раздающего канала к мультилинку
procedure TMultilink.OnConnectMultilink(Socket: TChannel);
begin

end;

//Отключение раздающего канала от мультилинка
procedure TMultilink.OnDisconnectMultilink(Socket: TChannel);
begin

end;

//Обработка данных
procedure TMultilink.OnSelectMultilink(Socket: TChannel);
begin

end;

//Принять канал из мультиканала
function TMultilink.Accept(var Channel: TChannel): Boolean;
begin
  if RecvBuf(@Channel,SizeOf(TChannel))=SizeOf(TChannel) then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

//Вернуть канал мультиканалу
function TMultilink.Return(var Channel: TChannel): Boolean;
begin
  Result:=True;
end;

//------------------------------------------------------------------------------
// {TServer}
//------------------------------------------------------------------------------

//Потоки
function ServerSocketThread(Self: TServer): Integer;
var n: Integer;
begin
  while Self.ThreadSocket=True do
  begin
    Sleep(Self.FFrequncy);
  end;
  EndThread(0);
end;

//Создать класс
constructor TServer.Create;
begin
  inherited Create;
  Reset;
  FCritical:=TCriticalSection.Create;
end;

//Уничтожить класс
destructor TServer.Destroy;
begin
  Enable:=False;
  Active:=False;
  FCritical.Destroy;
  FCritical:=nil;
  Reset;
  inherited Destroy;
end;

//Сброс
procedure TServer.Reset;
begin
  FActive:=False;
  FEnable:=False;
  FMaxChargeLevel:=0;
  FMaxSocketCount:=128;
  FMaxThreadCount:=2;
  FMaxChargeCount:=32;
  FTerminateTimeOut:=10000;
  FFrequncy:=1;
  FIndex:=0;
  FSocket:=nil;
  FMultilink:=nil;
  FThread:=nil;
  FhThreading:=False;
end;

//Открыть сокет
function TServer.OpenSocket(var Index: Cardinal): Boolean;
begin
  FCritical.Enter;
  if FIndex<FMaxSocketCount then
  begin
    if FBusy[FIndex]=True then
    begin
      FIndex:=FIndex+1;
      Result:=False;
    end
    else
    begin
      FBusy[FIndex]:=True;
      Index:=FIndex;
      FIndex:=FIndex+1;
      Result:=True;
    end;
  end
  else
  begin
    FIndex:=0;
    if FBusy[FIndex]=True then
    begin
      FIndex:=FIndex+1;
      Result:=False;
    end
    else
    begin
      FBusy[FIndex]:=True;
      Index:=FIndex;
      FIndex:=FIndex+1;
      Result:=True;
    end;
  end;
  FCritical.Leave;
end;

//Освободить сокет
procedure TServer.ReleaseSocket(Index: Cardinal);
var Channel: TChannel;
begin
  if (Assigned(FSocket[Index])=True) and (FBusy[Index]=True) then
  begin
    if FSocket[Index].Active=True then
    begin
      if FSocket[Index].Sync=False then FSocket[Index].Active:=False;
    end
    else
    begin
      if FMultilink.Accept(Channel)=True then
      begin
        FSocket[Index].Channel:=Channel;
        FSocket[Index].Active:=True;
        if FSocket[Index].Active=True then
        begin
          if FSocket[Index].Sync=False then FSocket[Index].Active:=False;
        end;
      end;
    end;
    FBusy[Index]:=False;
  end;
end;

//Опросить сокет
function TServer.ThreadSocket: Boolean;
var  n: Integer;
     Index: Cardinal;
begin
  Result:=False;
  if FhThreading=True then
  begin
    for n:=0 to FMaxChargeCount do
    begin
      if FhThreading=True then
      begin
        if OpenSocket(Index)=True then ReleaseSocket(Index);
      end
      else
      begin
        Exit;
      end;
    end;
    Result:=True;
  end;
end;

//Установить уровень нагрузки на процессор
procedure TServer.SetMaxChargeLevel(Val: Cardinal);
begin
  if FActive=False then
  begin
    FMaxChargeLevel:=Val;
    if FMaxChargeLevel>0 then
    begin
      FMaxSocketCount:=FMaxChargeLevel*256;
      FMaxThreadCount:=FMaxChargeLevel*4;
      FMaxChargeCount:=FMaxChargeLevel*64;
    end
    else
    begin
      FMaxSocketCount:=128;
      FMaxThreadCount:=2;
      FMaxChargeCount:=32;
    end;
  end;
end;

//Установить максимальное количество сокетов
procedure TServer.SetMaxSocketCount(Val: Cardinal);
begin
  if FActive=False then FMaxSocketCount:=Val;
end;

//Установить максимальное количество потоков
procedure TServer.SetMaxThreadCount(Val: Cardinal);
begin
  if FActive=False then FMaxThreadCount:=Val;
end;

//Установить максимальное нагрузку на поток
procedure TServer.SetMaxChargeCount(Val: Cardinal);
begin
  if FActive=False then FMaxChargeCount:=Val;
end;

//Активация
procedure TServer.SetActive(Act: Boolean);
var n: Integer;
    FPersistent: TPersistentClass;
begin
  FCritical.Enter;
  if (FActive=False) and (Act=True) and (FEnable=False) then
  begin
    if CreateMultilink(FMultilink)=True then
    begin
      FMultilink.Active:=True;
      if FMultilink.Active=True then
      begin
        SetLength(FSocket,FMaxSocketCount);
        SetLength(FBusy,FMaxSocketCount);
        SetLength(FThread,FMaxThreadCount);
        if (Assigned(FSocket)=True) and (Assigned(FBusy)=True) and (Assigned(FThread)=True) then
        begin
          for n:=0 to FMaxSocketCount-1 do
          begin
            FBusy[n]:=False;
            if CreateSocket(FSocket[n])=False then FSocket[n]:=nil;
          end;
          FIndex:=0;
          FActive:=True;
          FCritical.Leave;
          Exit;
        end;
        FSocket:=nil;
        FBusy:=nil;
        FThread:=nil;
      end;
      FMultilink.Destroy;
      FMultilink:=nil;
    end;
  end;
  if (FActive=True) and (Act=False) and (FEnable=False) then
  begin
    for n:=0 to FMaxSocketCount-1 do
    begin
      FBusy[n]:=False;
      if Assigned(FSocket[n])=True then
      begin
        FSocket[n].Destroy;
        FSocket[n]:=nil;
      end;
    end;
    FSocket:=nil;
    FBusy:=nil;
    FThread:=nil;
    FMultilink.Destroy;
    FMultilink:=nil;
    FActive:=False;
  end;
  FCritical.Leave;
end;

//Включение
procedure TServer.SetEnable(Act: Boolean);
var n: Integer;
begin
  FCritical.Enter;
  if (FActive=True) and (FEnable=False) and (Act=True) then
  begin
    FhThreading:=True;
    for n:=0 to FMaxThreadCount-1 do
    begin
      if ETACreateThread(@ServerSocketThread,Self,FThread[n])=True then
      begin
        //FStorage.LogSetDesc(Self,'Starting success server thread '+IntToStr(n));
      end
      else
      begin
        //FStorage.LogSetDesc(Self,'Starting fault server thread '+IntToStr(n));
      end;
    end;
    FEnable:=True;
  end;
  if (FActive=True) and (FEnable=True) and (Act=False) then
  begin
    FhThreading:=False;
    for n:=0 to FMaxThreadCount-1 do
    begin
      if ETADestroyThread(FThread[n],FTerminateTimeOut,0)=True then
      begin
        //FStorage.LogSetDesc(Self,'Stopping success server thread '+IntToStr(n));
      end
      else
      begin
        //FStorage.LogSetDesc(Self,'Stopping fault server thread '+IntToStr(n));
      end;
    end;
    FEnable:=False;
  end;
  FCritical.Leave;
end;

//Отдать канал обратно в сокет
function TServer.Revoke(Channel: TChannel): Boolean;
var n: Integer;
begin
  Result:=False;
  FCritical.Enter;
  if (FActive=True) and (Assigned(Channel)=True) then
  begin
    for n:=0 to FMaxSocketCount-1 do
    begin
      if (FBusy[n]=True) and (Assigned(FSocket[n])=True) and (FSocket[n].Channel=Channel) then
      begin
        FBusy[n]:=False;
        Result:=True;
        Break;
      end;
    end;
  end;
  FCritical.Leave;
end;

//Получить канал из сокета во временное пользование
function TServer.Invoke(Name: AnsiString; var Channel: TChannel): Boolean;
var n: Integer;
begin
  Result:=False;
  Channel:=nil;
  FCritical.Enter;
  if (FActive=True) and (Length(Name)>0) then
  begin
    for n:=0 to FMaxSocketCount-1 do
    begin
      if (Assigned(FSocket[n])=True) and (FSocket[n].Active=True) and (Pos(LowerCase(Name),LowerCase(FSocket[n].Channel.Peer))>0) then
      begin
        while FBusy[n]=True do
        begin
          Sleep(FFrequncy);
        end;
        Channel:=FSocket[n].Channel;
        FBusy[n]:=True;
        Result:=True;
        Break;
      end;
    end;
  end;
  FCritical.Leave;
end;

//Создание мультилинка
function TServer.CreateMultilink(var Multilink: TMultilink): Boolean;
begin
  Result:=False;
end;

//Создание сокета
function TServer.CreateSocket(var Socket: TSocket): Boolean;
begin
  Result:=False;
end;

initialization

  Classes.RegisterClass(TChannel);
  Classes.RegisterClass(TChannelStreamFullDuplex);
  Classes.RegisterClass(TChannelStreamHalfDuplex);
  Classes.RegisterClass(TChannelStreamRecvSimplex);
  Classes.RegisterClass(TChannelStreamSendSimplex);
  Classes.RegisterClass(TChannelPacketFullDuplex);
  Classes.RegisterClass(TChannelPacketHalfDuplex);
  Classes.RegisterClass(TChannelPacketRecvSimplex);
  Classes.RegisterClass(TChannelPacketSendSimplex);
  Classes.RegisterClass(TChannelCompositeAutotune);
  Classes.RegisterClass(TFifoStreamHalfDuplex);
  Classes.RegisterClass(TFifoPacketHalfDuplex);
  Classes.RegisterClass(TSocketStreamFullDuplex);
  Classes.RegisterClass(TSocketStreamHalfDuplex);
  Classes.RegisterClass(TSocketStreamRecvSimplex);
  Classes.RegisterClass(TSocketStreamSendSimplex);
  Classes.RegisterClass(TSocketPacketFullDuplex);
  Classes.RegisterClass(TSocketPacketHalfDuplex);
  Classes.RegisterClass(TSocketPacketRecvSimplex);
  Classes.RegisterClass(TSocketPacketSendSimplex);
  Classes.RegisterClass(TMultilink);
  Classes.RegisterClass(TServer);
end.

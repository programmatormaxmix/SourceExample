unit WinsCard;

interface

uses Windows, Messages, SysUtils, Classes;

const

  //Сообщение окну
  WM_CARD_INSERTED                = WM_USER + 1000;
  WM_CARD_EJECTED                 = WM_USER + 1001;

  //Системные параметры
  CR_ICODE_DEFAULT                = $54534554534F4341;
  CR_ICODE_NEW                    = $2348909890834589;
  CR_PINCODE_DEFAULT              = $0000000000000000;
  CR_PINCODE_ID                   = $0F53C334FF28AB0A;

  //Настройка файловой системы
  FILESYSTEM_SIZE              = 16384; //Максимальный размер файловой системы на карте.
  FILESYSTEM_COUNT             = 16;    //Максимальное кол-во файлов на карте.
  FILESYSTEM_FILESIZE          = 16384; //Максимальный размер файла на карте.
  FILESYSTEM_SECTORCOUNT       = 128;   //Максимальное количество секторов в файле.
  FILESYSTEM_SECTORSIZE        = 128;   //Максимальный размер сектора в файле.

  //Сообщение от картридера
  READER_OK                       = 0;
  READER_ACTIVATION_FAULT         = 100;
  READER_DEACTIVATION_FAUL        = 101;
  READER_EJECT_FAUL               = 102;
  READER_CARD_NOTPRESENT          = 103;

 //Сообщения от карты
  CARD_OK                         = 0;
  CARD_ACCESS_DENIED              = 200;
  CARD_LOCKED                     = 201;
  CARD_PERSONALIZATION_LOCK       = 203;
  CARD_NOTHING_TODO               = 204;
  CARD_PERSONALIZATION_ERROR      = 205;

 //Сообщение от файловой системы  
  FILE_OK                         = 0;
  FILE_DESCR_ERROR                = 300;
  FILE_ALLREADY_FOUND             = 301;
  FILE_MEMORY_FULL                = 302;
  FILE_DESCR_LENGTHERROR          = 303;
  FILE_NOTFOUND                   = 304;
  FILE_USERID_FAULT               = 305;
  FILE_SERIALNUMBER_FAULT         = 306;
  FILE_PERSONALIZATION_FAULT      = 307;

  //Сообщения от контекста устройств
  CONTEXT_OK                      = 0;
  CONTEXT_ERROR                   = 400;

  //Идентификаторы файлов
  FILE_MASTER                     = $003F;
  FILE_PROTECT                    = $013F;
  FILE_MCUID                      = $00FF;
  FILE_MANUFACTURER               = $01FF;
  FILE_PERSONALIZATION            = $02FF;
  FILE_SECURITY                   = $03FF;
  FILE_USER_MANAGMENT             = $04FF;
  FILE_ACCOUNT                    = $05FF;
  FILE_ACCOUNT_SECURITY           = $06FF;
  FILE_ATR                        = $07FF;
  FILE_USERID                     = $0100;
  FILE_USERID_SIZE                = $10;
  FILE_USERID_SECTORSIZE          = $10;
  FILE_USERID_RESERVED            = $00;


  //Сообщение API
  SCARD_S_SUCCESS                 = $00000000;
  SCARD_E_CANCELLED               = $80100002;
  SCARD_E_CANT_DISPOSE            = $8010000E;
  SCARD_E_INSUFFICIENT_BUFFER     = $80100008;
  SCARD_E_INVALID_ATR             = $80100015;
  SCARD_E_INVALID_HANDLE          = $80100003;
  SCARD_E_INVALID_PARAMETER       = $80100004;
  SCARD_E_INVALID_TARGET          = $80100005;
  SCARD_E_INVALID_VALUE           = $80100011;
  SCARD_E_NO_MEMORY               = $80100006;
  SCARD_F_COMM_ERROR              = $80100013;
  SCARD_F_INTERNAL_ERROR          = $80100001;
  SCARD_F_UNKNOWN_ERROR           = $80100014;
  SCARD_F_WAITED_TOO_LONG         = $80100007;
  SCARD_E_UNKNOWN_READER          = $80100009;
  SCARD_E_TIMEOUT                 = $8010000A;
  SCARD_E_SHARING_VIOLATION       = $8010000B;
  SCARD_E_NO_SMARTCARD            = $8010000C;
  SCARD_E_UNKNOWN_CARD            = $8010000D;
  SCARD_E_PROTO_MISMATCH          = $8010000F;
  SCARD_E_NOT_READY               = $80100010;
  SCARD_E_SYSTEM_CANCELLED        = $80100012;
  SCARD_E_NOT_TRANSACTED          = $80100016;
  SCARD_E_READER_UNAVAILABLE      = $80100017;
  SCARD_W_UNSUPPORTED_CARD        = $80100065;
  SCARD_W_UNRESPONSIVE_CARD       = $80100066;
  SCARD_W_UNPOWERED_CARD          = $80100067;
  SCARD_W_RESET_CARD              = $80100068;
  SCARD_W_REMOVED_CARD            = $80100069;
  SCARD_E_PCI_TOO_SMALL           = $80100019;
  SCARD_E_READER_UNSUPPORTED      = $8010001A;
  SCARD_E_DUPLICATE_READER        = $8010001B;
  SCARD_E_CARD_UNSUPPORTED        = $8010001C;
  SCARD_E_NO_SERVICE              = $8010001D;
  SCARD_E_SERVICE_STOPPED         = $8010001E;
  SCARD_SCOPE_USER                = $0000;
  SCARD_SCOPE_TERMINAL            = $0001;
  SCARD_SCOPE_SYSTEM              = $0002;
  SCARD_PROTOCOL_UNDEFINED        = $00000000;
  SCARD_PROTOCOL_T0               = $00000001;
  SCARD_PROTOCOL_T1               = $00000002;
  SCARD_PROTOCOL_RAW              = $00010000;
  SCARD_SHARE_EXCLUSIVE           = $0001;
  SCARD_SHARE_SHARED              = $0002;
  SCARD_SHARE_DIRECT              = $0003;
  SCARD_LEAVE_CARD                = $0000;
  SCARD_RESET_CARD                = $0001;
  SCARD_UNPOWER_CARD              = $0002;
  SCARD_EJECT_CARD                = $0003;
  SCARD_UNKNOWN                   = $0001;
  SCARD_ABSENT                    = $0002;
  SCARD_PRESENT                   = $0004;
  SCARD_SWALLOWED                 = $0008;
  SCARD_POWERED                   = $0010;
  SCARD_NEGOTIABLE                = $0020;
  SCARD_SPECIFIC                  = $0040;
  SCARD_STATE_UNAWARE		  = $0000;
  SCARD_STATE_IGNORE              = $0001;
  SCARD_STATE_CHANGED             = $0002;
  SCARD_STATE_UNKNOWN		  = $0004;
  SCARD_STATE_UNAVAILABLE         = $0008;
  SCARD_STATE_EMPTY	          = $0010;
  SCARD_STATE_PRESENT		  = $0020;
  SCARD_STATE_ATRMATCH         	  = $0040;
  SCARD_STATE_EXCLUSIVE      	  = $0080;
  SCARD_STATE_INUSE               = $0100;
  SCARD_STATE_MUTE                = $0200;
  SCARD_W_INSERTED_CARD           = $8010006A;
  SCARD_E_UNSUPPORTED_FEATURE     = $8010001F;
  SCARD_SCOPE_GLOBAL		  = $0003;
  SCARD_PROTOCOL_ANY		  = $1000;
  SCARD_RESET			  = $0001;
  SCARD_INSERTED		  = $0002;
  SCARD_REMOVED		          = $0004;
  BLOCK_STATUS_RESUME             = $00FF;
  BLOCK_STATUS_BLOCKING           = $00FA;
  MAX_ATR_SIZE		          = 36;
  MAX_READERNAME		  = 52;
  MAX_LIBNAME			  = 100;
  SCARD_ATR_LENGTH	          = MAX_ATR_SIZE;
  MAX_BUFFER_SIZE                 = 264;
  APDU_REQUEST_SIZE               = 256;

type
  _SCARD_IO_REQUEST = record
     dwProtocol: Cardinal;
    dwPciLength: Cardinal;
end;

type
  _SCARD_READERSTATE = record
      szReader: PChar;
      pvUserData: Pointer;
      dwCurrentState: Cardinal;
      dwEventState: Cardinal;
      cbAtr: Cardinal;
      rgbAtr: array [0..MAX_ATR_SIZE] of Byte;
      end;

type
   TApduSend = record
         CLA: Byte;
         INS: Byte;
          P1: Byte;
          P2: Byte;
          Lc: Byte;
         Buf: array [0..APDU_REQUEST_SIZE-1] of Byte;
         end;

type
   TApduRecv = record
         SW1: Byte;
         SW2: Byte;
          Lc: Byte;
         Buf: array [0..APDU_REQUEST_SIZE-1] of Byte;
         end;

type
   TApduSendEx = record
         CLA: Byte;
         INS: Byte;
          P1: Byte;
          P2: Byte;
          Lc: Byte;
          Le: Byte;
         Buf: array [0..APDU_REQUEST_SIZE-1] of Byte;
         end;

type
   TUserID=array [0..FILE_USERID_SECTORSIZE-1] of Byte;
   TFileArray=array [0..127,0..127] of Byte;
   TByteArray=array of Byte;

type
   TCardFileDescription = record
                 FileId: Word;
               FileSize: Word;
             SectorSize: Word;
               Reserved: Word;
                          end;

type
   TCardFileSys = record
          FileId: Word;
        FileSize: Word;
      SectorSize: Word;
     SectorCount: Word;
        Reserved: Word;
            hMem: TFileArray;
                  end;

type
   TPesonalizationInfo = record
              Personal: Bool;
            PinChecked: Bool;
                  Lock: Bool;
                ICCode: Int64;
               PinCode: Int64;
                 Count: Cardinal;
                 Items: array [0..FILESYSTEM_COUNT-1] of TCardFileSys;
                         end;

type
   TPesonalRecord = record
        OptionRegister: Byte;
SecurityOptionRegister: Byte;
               NofFile: Byte;
                  PBit: Byte;
                    end;

type
    TEventReader = procedure(Self:Pointer);
    TEventObject = Pointer;

type
   TUSBCardReader = class
   private
     FActive: Boolean;
     FCardInserted: Boolean;
     FhSC: Cardinal;
     Fcch: Cardinal;
     FhWnd: Integer;
     FhThread: Cardinal;
     FhThreadId: Cardinal;
     FhThreadWork: Boolean;
     FhThreadStop: Boolean;
     FhThreadActive: Boolean;
     FActiveConnect:Boolean;
     FdwAP: Cardinal;
     FProto: Cardinal;
     FhCard: Cardinal;
     FOnInserted: TEventReader;
     FOnEjected: TEventReader;
     FOnObject: TEventObject;
     FItems: TStringList;
     FReaderName: String;
     FTag: Integer;
     FString: array [0..256] of Char;
     FSysString: array [0..256] of Char;
     procedure SetActive(Act:Boolean);
     procedure SetConnect(Act:Boolean);
     procedure SetActiveThread(Act:Boolean);
     procedure UpdateCardReaderItems;
     function FindCurrentCardReader: Boolean;
   protected
     property ActiveConnect: Boolean read FActiveConnect write SetConnect;
     property ActiveThread: Boolean read FhThreadActive write SetActiveThread;
     property OnInsertEvent: TEventReader read FOnInserted write FOnInserted;
     property OnEjectEvent: TEventReader read FOnEjected write FOnEjected;
     property ObjectEvent: TEventObject read FOnObject write FOnObject;
     property InsertedStatus: Boolean read FCardInserted;
   public
     property Active: Boolean read FActive write SetActive;
     property ReaderName: String read FReaderName write FReaderName;
     property hWnd: Integer read FhWnd write FhWnd;
     function Reset: Boolean;
     function Eject: Boolean;
     property Items: TStringList read FItems write FItems;
     function RequApdu(ApduSend: TApduSend; var ApduRecv: TApduRecv; Header:Boolean):Boolean;
     property Tag: Integer read FTag;
     constructor Create(IdTag: Integer);
     destructor Destroy;
   end;

type
   TACOSInteface=class(TUSBCardReader)
   private
     FApduSend: TApduSend;
     FApduRecv: TApduRecv;
   protected
     property LastApduSend: TApduSend read FApduSend;
     property LastApduRecv: TApduRecv read FApduRecv;
     function GetMemoryCardState: Boolean;
   public
     property MemoryCard: Boolean read GetMemoryCardState;
     function SelectFile(hFile:Word):Boolean;
     function ReadRecord(nRecord:Byte;Length:Byte; var Buf):Boolean;
     function WriteRecord(nRecord:Byte;Length:Byte; var Buf):Boolean;
     function ReadManufacturerFile(nRecord:Byte;var Value:Int64):Boolean;
     function WriteManufacturerFile(nRecord:Byte;Value:Int64):Boolean;
     function ReadPersonalizationFile(nRecord:Byte;var OptionRegister,SecurityOptionRegister,NOfFile,P:Byte):Boolean;
     function WritePersonalizationFile(nRecord:Byte;OptionRegister,SecurityOptionRegister,NOfFile,P:Byte):Boolean;
     function ReadUserManagmentFile(nRecord:Byte;var LenRec,NumRec,RSA,WSA:Byte;var FileId:Word):Boolean;
     function WriteUserManagmentFile(nRecord:Byte;LenRec,NumRec,RSA,WSA:Byte;FileId:Word):Boolean;
     function ReadRecordAsString(nRecord:Byte;Length:Byte;var Str:String):Boolean;
     function WriteRecordAsString(nRecord:Byte;Str:String):Boolean;
     function ReadRecordAsInt64(nRecord:Byte;var Value:Int64):Boolean;
     function WriteRecordAsInt64(nRecord:Byte;Value:Int64):Boolean;
     function EnterICode(IC:Int64):Boolean;
     function EnterICodeString(IC:String):Boolean;
     function EnterPinCode(Pin:Int64):Boolean;
     function EnterPinCodeString(Pin:String):Boolean;
     function ChangeICode(IC:Int64):Boolean;
     function ChangeICodeString(IC:String):Boolean;
     function ChangePinCode(Pin:Int64):Boolean;
     function ChangePinCodeString(Pin:String):Boolean;
     function ClearCard:Boolean;
     function MCSelectFile(hFile: Word): Boolean;
     function MCSelectDataMemoryFile: Boolean;
     function MCSelectProtectFile: Boolean;
     function MCReadData(Addr:Byte;Leng:Byte;var Buf): Boolean;
     function MCWriteData(Addr:Byte;Leng:Byte;var Buf): Boolean;
     function MCReadAsInt64(Addr:Byte;var Value:Int64):Boolean;
     function MCWriteAsInt64(Addr:Byte;Value:Int64):Boolean;
     function MCReadAsString(Addr:Byte;Length:Byte;var Str:String):Boolean;
     function MCWriteAsString(Addr:Byte;Str:String):Boolean;
     function MCEnterRealPinCode(Pin:Int64): Boolean;
     function MCEnterRealPinCodeString(Pin: String):Boolean;
     function MCPersonalization(Pin: Int64; var Buf): Boolean;
     function MCSerialReanimation: Boolean;
     constructor Create(IdTag: Integer);
     destructor Destroy;
   end;

type
    TACOSSmartCard=class(TACOSInteface)
    private
      FPersonal: TPesonalizationInfo;
    protected
      procedure PersonalClear;
      function GetPersonalSize:Integer;
      function GetIndexFile(FileId:Word):Integer;
      function GetFileDescCount(wFileId:Word;var FileDesc:array of TCardFileDescription;Length:Integer):Integer;
      function FormatCardSize(var FileDesc:array of TCardFileDescription;Length:Integer):Integer;
      function ErrorFormatCard(var FileDesc:array of TCardFileDescription;Length:Integer):Integer;
    public
      function cr_GetReadersList(List:PAnsiChar): Integer;
      function cr_InitReaderEx(ReaderName:String;hWindow:Integer;iPort:Integer):Integer;
      function cr_UninitReader:Integer;
      function cr_CardInside:Bool;
      function cr_GetSerialNumber(var iNumber:Int64):Integer;
      function cr_GetUserId(var UserID: TUserID):Integer;
      function cr_CardPersonalized(var bResult:Bool):Integer;
      function cr_CheckIC(dqICCode:Int64):Integer;
      function cr_CheckPin(dqPinCode:Int64):Integer;
      function cr_GetErrorString(iErrorCode:Integer):String;
      function cr_ReleaseCard:Integer;
      function cr_SetICCode(dqICCode:Int64):Integer;
      function cr_SetPinCode(dqPinCode:Int64):Integer;
      function cr_FormatCard(var FileDesc:array of TCardFileDescription;Length:Integer):Integer;
      function cr_ReadCardFile(wFileID:Word;pBuffer:TByteArray):Integer;
      function cr_WriteCardFile(wFileId:Word;pBuffer:TByteArray):Integer;
      function cr_LockCard:Integer;
      function cr_ResetCard:Integer;
      constructor Create(IdTag: Integer);
      destructor Destroy;
    end;

function SCardEstablishContext(dwScope,pvReserved1,pvReserved2:Cardinal; var phContext:Cardinal):Cardinal;stdcall;external 'winscard.dll';
function SCardListReadersA(hContext:Cardinal;mszGroup,mszReaders:PChar;var pcchReaders:Cardinal):Cardinal;stdcall;external 'winscard.dll';
function SCardConnectA(hContext:Cardinal;szReader:PChar;dwShareMode,dwPreferredProtocols:Cardinal; var hCard,dwAP:Cardinal):Cardinal;stdcall;external 'winscard.dll';
function SCardTransmit(hCard:Cardinal;var pioSendPci:_SCARD_IO_REQUEST;SendBuffer:PAnsiChar;SendLength,pioRecvPci:Cardinal;RecvBuff:Pointer; var RecvLength:Cardinal):Cardinal;stdcall;external 'winscard.dll';
function SCardDisconnect(hCard,dwDisposition:Cardinal):Cardinal;stdcall;external 'winscard.dll';
function SCardReleaseContext(phContext:Cardinal):Cardinal;stdcall;external 'winscard.dll';
function SCardBeginTransaction(hCard:Cardinal):Cardinal;stdcall;external 'winscard.dll';
function SCardEndTransaction(hCard,dwDisposition:Cardinal):Cardinal;stdcall;external 'winscard.dll';
function SCardGetStatusChangeA(hContext:Cardinal;dwTimeout:Cardinal;var rgReaderStates:_SCARD_READERSTATE;cReaders:Cardinal):Cardinal;stdcall;external 'winscard.dll';
function SCardSendAPDU(hCard:Cardinal; ApduSend: TApduSend;var ApduRecv: TApduRecv;Header:Boolean;Protocol:Cardinal):Boolean;stdcall;

function ShowBuffer(Buf: array of Byte;Len:Cardinal): String;
function GetErrorString(iErrorCode:Integer):String;
function CreateUniqueValue: Int64;

implementation

//Системное сообщение
procedure ErrorMessage(Text:String);
begin
  MessageBoxA(0,PChar(Text),'Error',MB_ICONERROR+MB_TASKMODAL);
end;

//Показать буфер
function ShowBuffer(Buf: array of Byte; Len:Cardinal): String;
var n: Integer;
begin
  Result:='';
  for n:=0 to Len-1 do
  begin
    Result:=Result+'$'+IntToHex(Buf[n],2)+',';
  end;
end;

//Создать уникальный номер
function CreateUniqueValue: Int64;
var d: _SYSTEMTIME;
    Value: array [0..7] of Byte;
begin
  Randomize;
  Sleep(Random(100));
  GetSystemTime(d);
  Value[0]:=(d.wYear-2000);
  Value[1]:=d.wMonth;
  Value[2]:=d.wDay;
  Value[3]:=d.wHour;
  Value[4]:=d.wMinute;
  Value[5]:=d.wSecond;
  Value[6]:=d.wMilliseconds;
  Value[7]:=Random(100);
  Move(Value,Result,8);
end;

//Отправка APDU команды для USB
function SCardSendAPDU(hCard:Cardinal; ApduSend: TApduSend; var ApduRecv: TApduRecv;Header:Boolean;Protocol:Cardinal):Boolean;stdcall;
var P: _SCARD_IO_REQUEST;
   Lr: Cardinal;
begin
  Result:=False;
  Lr:=APDU_REQUEST_SIZE;
  P.dwProtocol:=Protocol;
  P.dwPciLength:=8;
  if (Header=False) and (SCardTransmit(hCard,P,@ApduSend.CLA,ApduSend.Lc+5,0,@ApduRecv.Buf,Lr)=SCARD_S_SUCCESS) then
  begin
    ApduRecv.SW1:=ApduRecv.Buf[Lr-2];
    ApduRecv.SW2:=ApduRecv.Buf[Lr-1];
    ApduRecv.Lc:=Lr-2;
    ApduRecv.Buf[Lr-2]:=0;
    ApduRecv.Buf[Lr-1]:=0;
    Result:=True;
    Exit;
  end;
  if (Header=True) and (SCardTransmit(hCard,P,@ApduSend.CLA,5,0,@ApduRecv.Buf,Lr)=SCARD_S_SUCCESS) then
  begin
    ApduRecv.SW1:=ApduRecv.Buf[Lr-2];
    ApduRecv.SW2:=ApduRecv.Buf[Lr-1];
    ApduRecv.Lc:=Lr-2;
    ApduRecv.Buf[Lr-2]:=0;
    ApduRecv.Buf[Lr-1]:=0;
    Result:=True;
    Exit;
  end;
end;

//Проверка состояния бита в байте
function CheckBit(Num:Byte;NBit:Byte):Boolean;
begin
  Result:=((Num and NBit)= NBit);
end;

//------------------------------------------------------------------------------
//                        Доступ к картридеру через USB
//------------------------------------------------------------------------------

//Создание класса
constructor TUSBCardReader.Create(IdTag: Integer);
begin
  inherited Create;
  FItems:=TStringList.Create;
  FActive:=False;
  FCardInserted:=False;
  FhSC:=0;
  Fcch:=0;
  FhWnd:=0;
  FhThread:=0;
  FhThreadId:=0;
  FhThreadWork:=False;
  FhThreadStop:=False;
  FhThreadActive:=False;
  FActiveConnect:=False;
  FdwAP:=0;
  FProto:=0;
  FhCard:=0;
  FOnInserted:=nil;
  FOnEjected:=nil;
  FOnObject:=nil;
  ZeroMemory(@FString,256);
  FReaderName:='';
  FTag:=IdTag;
  Self.UpdateCardReaderItems;
end;

//Уничтожение класса
destructor TUSBCardReader.Destroy;
begin
  Self.Active:=False;
  FItems.Clear;
  FItems.Destroy;
  inherited Destroy;
end;

//Обновить список картридеров
procedure TUSBCardReader.UpdateCardReaderItems;
var SysFhSC: Cardinal;
    SysFcch: Cardinal;
          n: Integer;
     SysStr: String;
begin
  if FActive=False then
  begin
    SysFhSC:=0;
    SysFcch:=256;
    SysStr:='';
    n:=0;
    ZeroMemory(@FSysString,256);
    FItems.Clear;
    if SCardEstablishContext(SCARD_SCOPE_USER,0,0,SysFhSC)=SCARD_S_SUCCESS then
    begin
      if SCardListReadersA(SysFhSC,nil,@FSysString,SysFcch)=SCARD_S_SUCCESS then
      begin
        for n:=0 to 255 do
        begin
          if FSysString[n]<>#0 then SysStr:=SysStr+FSysString[n];
          if (FSysString[n]=#0) and (FSysString[n+1]<>#0) then
          begin
            FItems.Add(SysStr);
            SysStr:='';
          end;
          if (FSysString[n]=#0) and (FSysString[n+1]=#0) then
          begin
            FItems.Add(SysStr);
            SysStr:='';
            SCardReleaseContext(SysFhSC);
            Exit;
          end;
        end;
      end;
     SCardReleaseContext(SysFhSC);
    end;
  end;
end;

//Класс отбработки подключения к карте
function ThreadCardReaderProc(Self: TUSBCardReader):Cardinal;stdcall;
var ReaderState: _SCARD_READERSTATE;
begin
  Self.FhThreadWork:=True;
  ReaderState.szReader:=Self.FString;
  ReaderState.pvUserData:=nil;
  ReaderState.dwCurrentState:=SCARD_STATE_UNAWARE;
  ReaderState.dwEventState:=0;
  ReaderState.cbAtr:=0;
  while Self.FhThreadWork=True do
  begin
    if SCardGetStatusChangeA(Self.FhSC,1,ReaderState,1)=SCARD_S_SUCCESS then
    begin
      if (CheckBit(ReaderState.dwEventState,32)=True) and (Self.FActiveConnect=False) then
      begin
        //Self.FCardInserted:=True;
        Self.ActiveConnect:=True;
      end;
      if (CheckBit(ReaderState.dwEventState,32)=False) and (Self.FActiveConnect=True) then Self.ActiveConnect:=False;
    end;
    Sleep(50);
  end;
  Self.FhThreadStop:=True;
  Result:=0;
end;

//Поиск объьявленного картридера
function TUSBCardReader.FindCurrentCardReader: Boolean;
var n: Integer;
begin
  Result:=False;
  if Length(FReaderName)<>0 then
  begin
    for n:=0 to FItems.Count-1 do
    begin
      if ReaderName=FItems.Strings[n] then Result:=True;
    end;
  end
  else
  begin
    Result:=True;
  end;
end;

//Активировать кардридер
procedure TUSBCardReader.SetActive(Act:Boolean);
begin
  if (FActive=False) and (Act=True) and (SCardEstablishContext(SCARD_SCOPE_USER,0,0,FhSC)=SCARD_S_SUCCESS) then
  begin
    Fcch:=256;
    if FindCurrentCardReader=True then
    begin
      if SCardListReadersA(FhSC,nil,@FString,Fcch)=SCARD_S_SUCCESS then
      begin
        if Length(FReaderName)<>0 then
        begin
          ZeroMemory(@FString,256);
          lstrcpy(FString,PChar(FReaderName));
        end;
        Self.ActiveThread:=True;
        if Self.ActiveThread=True then FActive:=True else SCardReleaseContext(FhSC);
        Exit;
      end;
    end;
    SCardReleaseContext(FhSC);
    Exit;
  end;
  if (FActive=True) and (Act=False) then
  begin
    Self.ActiveThread:=False;
    Self.ActiveConnect:=False;
    SCardReleaseContext(FhSC);
    FActive:=False;
    Exit;
  end;
end;

//Подключение к ридеру
procedure TUSBCardReader.SetConnect(Act:Boolean);
begin
  if (FActive=True) and (FActiveConnect=False) and (Act=True) then
  begin

    FProto:=SCARD_PROTOCOL_T0;
    if SCardConnectA(FhSC,FString,SCARD_SHARE_SHARED,FProto,FhCard,FdwAP)=SCARD_S_SUCCESS then
    begin
      FCardInserted:=True;
      FActiveConnect:=True;
      if (Assigned(FOnInserted)=True) and (Assigned(FOnObject)=True) then OnInsertEvent(ObjectEvent);
      PostMessage(Self.hWnd,WM_CARD_INSERTED,FTag,0);
      Exit;
    end;

    FProto:=SCARD_PROTOCOL_T1;
    if SCardConnectA(FhSC,FString,SCARD_SHARE_SHARED,FProto,FhCard,FdwAP)=SCARD_S_SUCCESS then
    begin
      FCardInserted:=True;
      FActiveConnect:=True;
      if (Assigned(FOnInserted)=True) and (Assigned(FOnObject)=True) then OnInsertEvent(ObjectEvent);
      PostMessage(Self.hWnd,WM_CARD_INSERTED,FTag,0);
      Exit;
    end;

    FProto:=SCARD_PROTOCOL_RAW;
    if SCardConnectA(FhSC,FString,SCARD_SHARE_SHARED,FProto,FhCard,FdwAP)=SCARD_S_SUCCESS then
    begin
      FCardInserted:=True;
      FActiveConnect:=True;
      if (Assigned(FOnInserted)=True) and (Assigned(FOnObject)=True) then OnInsertEvent(ObjectEvent);
      PostMessage(Self.hWnd,WM_CARD_INSERTED,FTag,0);
      Exit;
    end;

  FCardInserted:=False;

end;

   if (FActive=True) and (FActiveConnect=True) and (Act=False) then
   begin
     SCardDisconnect(FhCard,SCARD_EJECT_CARD);
     SCardDisconnect(FhCard,SCARD_LEAVE_CARD);
     FActiveConnect:=False;
     if FCardInserted=True then
     begin
       if (Assigned(FOnEjected)=True) and (Assigned(FOnObject)=True) then OnEjectEvent(ObjectEvent);
       if Self.FhWnd<>0 then PostMessage(Self.hWnd,WM_CARD_EJECTED,FTag,0);
     end;
     FCardInserted:=False;
     Exit;
   end;

end;

//Активация потока
procedure TUSBCardReader.SetActiveThread(Act:Boolean);
begin

  if (FhThreadActive=False) and (Act=True) then
  begin
    FhThread:=CreateThread(nil,0,@ThreadCardReaderProc,Pointer(Self),CREATE_SUSPENDED,FhThreadId);
    if FhThread<>0 then
    begin
      ResumeThread(FhThread);
      Sleep(500);
      if FhThreadWork=True then FhThreadActive:=True else TerminateThread(FhThread,0);
    end;
    Exit;
  end;

  if (FhThreadActive=True) and (Act=False) then
  begin
    FhThreadWork:=False;
    Sleep(500);
    if FhThreadStop=True then
    begin
      FhThreadStop:=False;
      FhThreadActive:=False;
    end
    else
    begin
      TerminateThread(FhThread,0);
      FhThreadStop:=False;
      FhThreadActive:=False;
    end;
   Exit;
  end;

end;

//Сбросить карту
function TUSBCardReader.Reset:Boolean;
begin
  Result:=False;
  if (FActive=True) and (FActiveConnect=True) then
  begin
    SCardDisconnect(FhCard,SCARD_RESET_CARD);
    SCardConnectA(FhSC,FString,SCARD_SHARE_SHARED,FProto,FhCard,FdwAP);
    Result:=True;
  end;
end;

//Выплюнуть карту
function TUSBCardReader.Eject:Boolean;
begin
  Result:=False;
  if (FActive=True) and (FActiveConnect=True) and (FCardInserted=True) then
  begin
    SCardDisconnect(FhCard,SCARD_EJECT_CARD);
    SCardDisconnect(FhCard,SCARD_LEAVE_CARD);
    FCardInserted:=False;
    if (Assigned(FOnEjected)=True) and (Assigned(FOnObject)=True) then OnEjectEvent(ObjectEvent);
    if FhWnd<>0 then PostMessage(Self.hWnd,WM_CARD_EJECTED,FTag,0);
    Result:=True;
  end;
end;

//Запрос APDU
function TUSBCardReader.RequApdu(ApduSend: TApduSend; var ApduRecv: TApduRecv;Header:Boolean):Boolean;
begin
  Result:=False;
  if (FActive=True) and (FActiveConnect=True) and (FCardInserted=True) then Result:=SCardSendAPDU(FhCard,ApduSend,ApduRecv,Header,FProto);
end;

//------------------------------------------------------------------------------
//                Базовый интерфейс работы со смарт картами ACOS
//------------------------------------------------------------------------------

//Создание класса
constructor TACOSInteface.Create(IdTag: Integer);
begin
  inherited Create(IdTag);
end;

//Уничтожение класса
destructor TACOSInteface.Destroy;
begin
  inherited Destroy;
end;

//Получить статус карты
function TACOSInteface.GetMemoryCardState: Boolean;
begin
  Result:=False;
  if Self.FProto=SCARD_PROTOCOL_RAW then Result:=True;
end;

//Выбор файла
function TACOSInteface.SelectFile(hFile:Word):Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$80;
    FApduSend.INS:=$A4;
    FApduSend.P1:=$00;
    FApduSend.P2:=$00;
    FApduSend.Lc:=$02;
    Move(hFile,FApduSend.Buf[0],2);
    if Self.RequApdu(FApduSend,FApduRecv,False)=True then
    begin
      if (FApduRecv.SW1=$90) or (FApduRecv.SW1=$91) then Result:=True;
    end;
  end;
end;

//Выбор файла файла (карты памяти)
function TACOSInteface.MCSelectFile(hFile: Word): Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$00;
    FApduSend.INS:=$A4;
    FApduSend.P1:=$00;
    FApduSend.P2:=$00;
    FApduSend.Lc:=$02;
    Move(hFile,FApduSend.Buf[0],2);
    if (Self.RequApdu(FApduSend,FApduRecv,False)=True) and (FApduRecv.SW1=$90) and (FApduRecv.SW2=$00) then Result:=True;
  end;
end;

//Выбор файла данных
function TACOSInteface.MCSelectDataMemoryFile: Boolean;
begin
  Result:=Self.MCSelectFile(FILE_MASTER);
end;

//Выбор файла защиты информации
function TACOSInteface.MCSelectProtectFile: Boolean;
begin
  Result:=Self.MCSelectFile(FILE_PROTECT);
end;

//Считать данные файла
function TACOSInteface.MCReadData(Addr:Byte;Leng:Byte;var Buf): Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$00;
    FApduSend.INS:=$B0;
    FApduSend.P1:=$00;
    FApduSend.P2:=Addr;
    FApduSend.Lc:=Leng;
    if (Self.RequApdu(FApduSend,FApduRecv,True)=True) and (FApduRecv.SW1=$90) and (FApduRecv.SW2=$00) then
    begin
      Move(FApduRecv.Buf,Buf,FApduRecv.Lc);
      Result:=True;
    end;
  end;
end;

//Считать данные файла
function TACOSInteface.MCWriteData(Addr:Byte;Leng:Byte;var Buf): Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$00;
    FApduSend.INS:=$D6;
    FApduSend.P1:=$00;
    FApduSend.P2:=Addr;
    FApduSend.Lc:=Leng;
    Move(Buf,FApduSend.Buf,Leng);
    if (Self.RequApdu(FApduSend,FApduRecv,False)=True) and (FApduRecv.SW1=$90) and (FApduRecv.SW2=$00) then Result:=True;
  end;
end;

//Считать данные как INT64
function TACOSInteface.MCReadAsInt64(Addr:Byte;var Value:Int64): Boolean;
begin
  Value:=0;
  Result:=Self.MCReadData(Addr,8,Value);
end;

//Сохранить данные как INT64
function TACOSInteface.MCWriteAsInt64(Addr:Byte;Value:Int64): Boolean;
begin
  Result:=Self.MCWriteData(Addr,8,Value);
end;

//Считать данные как String
function TACOSInteface.MCReadAsString(Addr:Byte;Length:Byte;var Str:String): Boolean;
var Buffer: array [0..255] of Char;
begin
  Result:=False;
  if (Length<=128) and (Self.MCReadData(Addr,Length,Buffer)=True) then
  begin
    SetString(Str,Buffer,Length);
    Result:=True;
  end;
end;

//Сохранить данные как String
function TACOSInteface.MCWriteAsString(Addr:Byte;Str:String): Boolean;
var Buffer: array [0..255] of Char;
begin
  Result:=False;
  if Length(Str)<=128 then
  begin
    Move(Pointer(Str)^,Buffer,Length(Str));
    if Self.MCWriteData(Addr,Length(Str),Buffer)=True then Result:=True;
  end;
end;

//Ввод пин кода
function TACOSInteface.MCEnterRealPinCode(Pin:Int64): Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$00;
    FApduSend.INS:=$20;
    FApduSend.P1:=$00;
    FApduSend.P2:=$00;
    FApduSend.Lc:=$03;
    Move(Pin,FApduSend.Buf[0],3);
    if (Self.RequApdu(FApduSend,FApduRecv,False)=True) and (FApduRecv.SW1=$90) and (FApduRecv.SW2=$00) then Result:=True;
  end;
end;

//Ввод пин кода
function TACOSInteface.MCEnterRealPinCodeString(Pin:String):Boolean;
var ICode: Int64;
begin
  Result:=False;
  if (Length(Pin)>=1) and (Length(Pin)<=8) then
  begin
    ICode:=0;
    Move(Pointer(Pin)^,ICode,Length(Pin));
    Result:=Self.MCEnterRealPinCode(ICode);
  end
  else
  begin
    ICode:=0;
    Result:=Self.MCEnterRealPinCode(ICode);
  end;
end;

//Проверка пин кода
function TACOSInteface.MCPersonalization(Pin: Int64; var Buf): Boolean;
var iSerial: Int64;
begin
  Result:=False;
  if (MCEnterRealPinCode($FFFFFFFFFFFFFFFF)=True) and (MCSelectDataMemoryFile=True) and (MCReadAsInt64($A0,iSerial)=True) then
  begin
    if (iSerial<>0) or (iSerial<>$FFFFFFFFFFFFFFFF) then
    begin
      if (MCWriteAsInt64($A8,Pin)=True) and (MCWriteData($B0,16,Buf)=True) then Result:=True;
    end;
  end;
end;

//Реанимация карты памяти
function TACOSInteface.MCSerialReanimation: Boolean;
var iSerial: Int64;
begin
  Result:=False;
  iSerial:=0;
  if (MCEnterRealPinCode($FFFFFFFFFFFFFFFF)=True) and (MCSelectDataMemoryFile=True) and (MCReadAsInt64($A0,iSerial)=True) then
  begin
    if (iSerial=0) or (iSerial=$FFFFFFFFFFFFFFFF) then
    begin
      if MCWriteAsInt64($A0,CreateUniqueValue)=True then Result:=True;
    end;
  end;
end;

//Смена технического кода
function TACOSInteface.ChangeICode(IC:Int64):Boolean;
begin
  Result:=False;
  if (Self.InsertedStatus=True) and (Self.SelectFile(FILE_SECURITY)=True) and (Self.WriteRecordAsInt64(0,IC)=True) then Result:=True;
end;

//Смена технического кода на строковый
function TACOSInteface.ChangeICodeString(IC:String):Boolean;
var ICode: Int64;
begin
  Result:=False;
  if (Length(IC)>=1) and (Length(IC)<=8) then
  begin
    ICode:=0;
    Move(Pointer(IC)^,ICode,Length(IC));
    Result:=Self.ChangeICode(ICode);
  end
  else
  begin
    ICode:=0;
    Result:=Self.ChangeICode(ICode);
  end;
end;

//Смена пинкода
function TACOSInteface.ChangePinCode(Pin:Int64): Boolean;
begin
  Result:=False;
  if (Self.InsertedStatus=True) and (Self.SelectFile(FILE_SECURITY)=True) and (Self.WriteRecordAsInt64(1,Pin)=True) then Result:=True;
end;

//Смена пин кода на строковый
function TACOSInteface.ChangePinCodeString(Pin:String):Boolean;
var ICode: Int64;
begin
  Result:=False;
  if (Length(Pin)>=1) and (Length(Pin)<=8) then
  begin
    ICode:=0;
    Move(Pointer(Pin)^,ICode,Length(Pin));
    Result:=Self.ChangePinCode(ICode);
  end
  else
  begin
    ICode:=0;
    Result:=Self.ChangePinCode(ICode);
  end;
end;

//Стирание карты
function TACOSInteface.ClearCard:Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$80;
    FApduSend.INS:=$30;
    FApduSend.P1:=$00;
    FApduSend.P2:=$00;
    FApduSend.Lc:=$00;
    if (Self.RequApdu(FApduSend,FApduRecv,False)=True) and (FApduRecv.SW1=$90) and (FApduRecv.SW2=$00) then Result:=True;
  end;
end;

//Ввод технологического кода
function TACOSInteface.EnterICode(IC:Int64):Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$80;
    FApduSend.INS:=$20;
    FApduSend.P1:=$07;
    FApduSend.P2:=$00;
    FApduSend.Lc:=$08;
    Move(IC,FApduSend.Buf[0],8);
    if (Self.RequApdu(FApduSend,FApduRecv,False)=True) and (FApduRecv.SW1=$90) and (FApduRecv.SW2=$00) then Result:=True;
  end;
end;

//Ввод пин кода
function TACOSInteface.EnterPinCode(Pin:Int64):Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$80;
    FApduSend.INS:=$20;
    FApduSend.P1:=$06;
    FApduSend.P2:=$00;
    FApduSend.Lc:=$08;
    Move(Pin,FApduSend.Buf[0],8);
    if (Self.RequApdu(FApduSend,FApduRecv,False)=True) and (FApduRecv.SW1=$90) and (FApduRecv.SW2=$00) then Result:=True;
  end;
end;

//Ввод технологического когда в виде строки
function TACOSInteface.EnterICodeString(IC:String):Boolean;
var ICode: Int64;
begin
  Result:=False;
  if (Length(IC)>=1) and (Length(IC)<=8) then
  begin
    ICode:=0;
    Move(Pointer(IC)^,ICode,Length(IC));
    Result:=Self.EnterICode(ICode);
  end
  else
  begin
    ICode:=0;
    Result:=Self.EnterICode(ICode);
  end;
end;

//Ввод PIN когда в виде строки
function TACOSInteface.EnterPinCodeString(Pin:String):Boolean;
var ICode: Int64;
begin
  Result:=False;
  if (Length(Pin)>=1) and (Length(Pin)<=8) then
  begin
    ICode:=0;
    Move(Pointer(Pin)^,ICode,Length(Pin));
    Result:=Self.EnterPinCode(ICode);
  end
  else
  begin
    ICode:=0;
    Result:=Self.EnterPinCode(ICode);
  end;
end;

//Прочитать запись из файла
function TACOSInteface.ReadRecord(nRecord:Byte;Length:Byte; var Buf):Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$80;
    FApduSend.INS:=$B2;
    FApduSend.P1:=nRecord;
    FApduSend.P2:=$00;
    FApduSend.Lc:=Length;
    if (Self.RequApdu(FApduSend,FApduRecv,True)=True) and (FApduRecv.SW1=$90) and (FApduRecv.SW2=$00) then
    begin
      Move(FApduRecv.Buf,Buf,FApduRecv.Lc);
      Result:=True;
    end;
  end;
end;

//Сохранить запись в файле
function TACOSInteface.WriteRecord(nRecord:Byte;Length:Byte; var Buf):Boolean;
begin
  Result:=False;
  if Self.InsertedStatus=True then
  begin
    FApduSend.CLA:=$80;
    FApduSend.INS:=$D2;
    FApduSend.P1:=nRecord;
    FApduSend.P2:=$00;
    FApduSend.Lc:=Length;
    Move(Buf,FApduSend.Buf,Length);
    if (Self.RequApdu(FApduSend,FApduRecv,False)=True) and (FApduRecv.SW1=$90) and (FApduRecv.SW2=$00) then Result:=True;
  end;
end;

//Считать запись из файла как Int64
function TACOSInteface.ReadRecordAsInt64(nRecord:Byte;var Value:Int64):Boolean;
begin
  Value:=0;
  Result:=Self.ReadRecord(nRecord,8,Value);
end;

//Сохранить запись в файл как Int64
function TACOSInteface.WriteRecordAsInt64(nRecord:Byte;Value:Int64):Boolean;
begin
  Result:=Self.WriteRecord(nRecord,8,Value);
end;

//Прочитать запись как строку
function TACOSInteface.ReadRecordAsString(nRecord:Byte;Length:Byte;var Str:String):Boolean;
var Buffer: array [0..255] of Char;
begin
  Result:=False;
  if (Length<=128) and (Self.ReadRecord(nRecord,Length,Buffer)=True) then
  begin
    SetString(Str,Buffer,Length);
    Result:=True;
  end;
end;

//Сохранить запись как строку
function TACOSInteface.WriteRecordAsString(nRecord:Byte;Str:String):Boolean;
var Buffer: array [0..255] of Char;
begin
  Result:=False;
  if Length(Str)<=128 then
  begin
    Move(Pointer(Str)^,Buffer,Length(Str));
    if Self.WriteRecord(nRecord,Length(Str),Buffer)=True then Result:=True;
  end;
end;

//Чтение из файла Manufacturer
function TACOSInteface.ReadManufacturerFile(nRecord:Byte;var Value:Int64):Boolean;
begin
  Result:=False;
  if (Self.SelectFile(FILE_MANUFACTURER)=True) and (Self.ReadRecordAsInt64(nRecord,Value)=True) then Result:=True;
end;

//Запись в файл Manufacturer
function TACOSInteface.WriteManufacturerFile(nRecord:Byte;Value:Int64):Boolean;
begin
  Result:=False;
  if (Self.SelectFile(FILE_MANUFACTURER)=True) and (Self.WriteRecordAsInt64(nRecord,Value)=True) then Result:=True;
end;

//Считать данные из файла
function TACOSInteface.ReadPersonalizationFile(nRecord:Byte;var OptionRegister,SecurityOptionRegister,NOfFile,P:Byte):Boolean;
var Buffer: array [0..3] of Byte;
begin
  Result:=False;
  OptionRegister:=0;
  SecurityOptionRegister:=0;
  NOfFile:=0;
  P:=0;
  if (Self.SelectFile(FILE_PERSONALIZATION)=True) and (Self.ReadRecord(nRecord,4,Buffer)=True) then
  begin
    OptionRegister:=Buffer[0];
    SecurityOptionRegister:=Buffer[1];
    NOfFile:=Buffer[2];
    P:=Buffer[3];
    Result:=True;
  end;
end;

//Сохранить данные из файла
function TACOSInteface.WritePersonalizationFile(nRecord:Byte;OptionRegister,SecurityOptionRegister,NOfFile,P:Byte):Boolean;
var Buffer: array [0..3] of Byte;
begin
  Result:=False;
  if Self.SelectFile(FILE_PERSONALIZATION)=True then
  begin
    Buffer[0]:=OptionRegister;
    Buffer[1]:=SecurityOptionRegister;
    Buffer[2]:=NOfFile;
    Buffer[3]:=P;
    if Self.WriteRecord(nRecord,4,Buffer)=True then Result:=True;
  end;
end;

//Считать данные о файле
function TACOSInteface.ReadUserManagmentFile(nRecord:Byte;var LenRec,NumRec,RSA,WSA:Byte;var FileId:Word):Boolean;
var Buffer: array [0..6] of Byte;
begin
  Result:=False;
  LenRec:=0;
  NumRec:=0;
  RSA:=0;
  WSA:=0;
  FileId:=0;
  if Self.SelectFile(FILE_USER_MANAGMENT)=True then
  begin
    if (Self.ReadRecord(nRecord,7,Buffer)=True) or (Self.ReadRecord(nRecord,6,Buffer)=True) then
    begin
      LenRec:=Buffer[0];
      NumRec:=Buffer[1];
      RSA:=Buffer[2];
      WSA:=Buffer[3];
      Move(Buffer[4],FileId,2);
      Result:=True;
    end;
  end;
end;

//Считать данные о файле
function TACOSInteface.WriteUserManagmentFile(nRecord:Byte;LenRec,NumRec,RSA,WSA:Byte;FileId:Word):Boolean;
var Buffer: array [0..6] of Byte;
begin
  Result:=False;
  if Self.SelectFile(FILE_USER_MANAGMENT)=True then
  begin
    Buffer[0]:=LenRec;
    Buffer[1]:=NumRec;
    Buffer[2]:=RSA;
    Buffer[3]:=WSA;
    Move(FileId,Buffer[4],2);
    Buffer[6]:=0;
    if (Self.WriteRecord(nRecord,7,Buffer)=True) or (Self.WriteRecord(nRecord,6,Buffer)=True) then Result:=True;
  end;
end;

//------------------------------------------------------------------------------
//           Пользовательский интерфейс работы со смарт картами ACOS
//------------------------------------------------------------------------------

//Карта вставлена
procedure OnInserted(Self: TACOSSmartCard);
begin
  Self.PersonalClear;
  if Self.MemoryCard=True then Self.MCSerialReanimation;
  Self.cr_CardPersonalized(Self.FPersonal.Personal);
end;

//Карта вынута
procedure OnEjected(Self: TACOSSmartCard);
begin
  Self.PersonalClear;
end;

//Создание класса
constructor TACOSSmartCard.Create(IdTag: Integer);
var n,m,q: Integer;
begin
  inherited Create(IdTag);
  FPersonal.Personal:=False;
  FPersonal.PinChecked:=False;
  FPersonal.Lock:=False;
  FPersonal.ICCode:=0;
  FPersonal.PinCode:=0;
  FPersonal.Count:=0;
  for n:=0 to FILESYSTEM_COUNT-1 do
  begin
    FPersonal.Items[n].FileId:=0;
    FPersonal.Items[n].FileSize:=0;
    FPersonal.Items[n].SectorSize:=0;
    FPersonal.Items[n].SectorCount:=0;
    FPersonal.Items[n].Reserved:=0;
    for m:=0 to FILESYSTEM_SECTORCOUNT-1 do
    begin
      for q:=0 to FILESYSTEM_SECTORSIZE-1 do
      begin
        FPersonal.Items[n].hMem[m,q]:=0;
      end;
    end;
  end;
  Self.FOnObject:=Pointer(Self);
  Self.FOnInserted:=@OnInserted;
  Self.FOnEjected:=@OnEjected;
end;

//Уничтожение класса
destructor TACOSSmartCard.Destroy;
begin
  Self.PersonalClear;
  inherited Destroy;
end;

//Отчитка структуры
procedure TACOSSmartCard.PersonalClear;
var n,m,q: Integer;
begin
  FPersonal.Personal:=False;
  FPersonal.PinChecked:=False;
  FPersonal.Lock:=False;
  FPersonal.ICCode:=0;
  FPersonal.PinCode:=0;
  FPersonal.Count:=0;
  for n:=0 to FILESYSTEM_COUNT-1 do
  begin
    FPersonal.Items[n].FileId:=0;
    FPersonal.Items[n].FileSize:=0;
    FPersonal.Items[n].SectorSize:=0;
    FPersonal.Items[n].SectorCount:=0;
    FPersonal.Items[n].Reserved:=0;
    for m:=0 to FILESYSTEM_SECTORCOUNT-1 do
    begin
      for q:=0 to FILESYSTEM_SECTORSIZE-1 do
      begin
        FPersonal.Items[n].hMem[m,q]:=0;
      end;
    end;
  end;
end;

//Получить общий размер файла для записи
function TACOSSmartCard.GetPersonalSize:Integer;
var n: Integer;
begin
  Result:=0;
  for n:=0 to FILESYSTEM_COUNT-1 do
  begin
    Result:=Result+FPersonal.Items[n].FileSize;
  end;
end;

//Поиск псевдофайла
function TACOSSmartCard.GetIndexFile(FileId:Word):Integer;
var n: Integer;
begin
  Result:=-1;
  if FPersonal.Count>0 then
  begin
    for n:=0 to FPersonal.Count-1 do
    begin
      if FPersonal.Items[n].FileId=FileId then
      begin
        Result:=n;
        Exit;
      end;
    end;
  end;
end;

//Поиск псевдофайла в структуре
function TACOSSmartCard.GetFileDescCount(wFileId:Word; var FileDesc:array of TCardFileDescription;Length:Integer):Integer;
var n: Integer;
begin
  Result:=0;
  if Length>0 then
  begin
    for n:=0 to Length-1 do
    begin
      if FileDesc[n].FileId=wFileId then Result:=Result+1;
    end;
  end;
end;

//Получить список картридеров имеющихся в системе
function TACOSSmartCard.cr_GetReadersList(List: PAnsiChar): Integer;
begin
  if Items.Count=-1 then Result:=0 else Result:=Items.Count;
  if (List<>nil) and (Result<>0) then lstrcpy(List,Items.GetText);
end;

//Инициализация картридера
function TACOSSmartCard.cr_InitReaderEx(ReaderName:String;hWindow:Integer;iPort:Integer):Integer;
var n: Integer;
begin
  Result:=READER_ACTIVATION_FAULT;
  if (Self.Active=False) and (iPort=0) then
  begin
    Self.hWnd:=hWindow;
    Self.ReaderName:=ReaderName;
    Self.Active:=True;
    if Self.Active=True then Result:=READER_OK;
  end;
end;

//Деинициализация картридера
function TACOSSmartCard.cr_UninitReader:Integer;
begin
  Result:=READER_DEACTIVATION_FAUL;
  if Self.Active=True then
  begin
    Self.Active:=False;
    if Self.Active=False then Result:=READER_OK ;
  end;
end;

//Информация наличии карты в картридере
function TACOSSmartCard.cr_CardInside:Bool;
var n: Integer;
begin
  Result:=False;
  if (Self.Active=True) and (Self.InsertedStatus=True) then
  begin
    Result:=True;
    Exit;
  end
  else
  begin
    n:=0;
    while (Result=False) and (n<=3) do
    begin
      if (Self.Active=True) and (Self.InsertedStatus=True) then Result:=True;
      if Result=False then Sleep(1000);
      n:=n+1;
      Exit;
    end;
  end;
end;

//Получить серийный номер карты
function TACOSSmartCard.cr_GetSerialNumber(var iNumber:Int64):Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  INumber:=0;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_PERSONALIZATION_LOCK;
    if FPersonal.Lock=True then Exit;
    if Self.MemoryCard=True then
    begin
      if Self.MCReadAsInt64($A0,INumber)=True then
      begin
        Result:=FILE_OK;
        Exit;
      end;
    end
    else
    begin
      if (Self.SelectFile(FILE_MCUID)=True) and (Self.ReadRecord(0,8,INumber)=True) then
      begin
        Result:=FILE_OK;
        Exit;
      end;
    end;
    Result:=FILE_SERIALNUMBER_FAULT;
  end;
end;

//Получение уникального номера
function TACOSSmartCard.cr_GetUserId(var UserID: TUserID):Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_PERSONALIZATION_LOCK;
    if FPersonal.Lock=True then Exit;
    if Self.MemoryCard=True then
    begin
      if (Self.FPersonal.PinChecked=True) and (Self.MCReadData($B0,16,UserId)=True) then
      begin
        Result:=FILE_OK;
        Exit;
      end
      else
      begin
        Result:=FILE_USERID_FAULT;
        ZeroMemory(@UserID,FILE_USERID_SECTORSIZE);
        Exit;
      end;
    end
    else
    begin
      if (Self.SelectFile(FILE_USERID)=True) and (Self.ReadRecord(0,FILE_USERID_SECTORSIZE,UserID)=True) then
      begin
        Result:=FILE_OK;
        Exit;
      end
      else
      begin
        Result:=FILE_USERID_FAULT;
        ZeroMemory(@UserID,FILE_USERID_SECTORSIZE);
        Exit;
      end;
    end;
   Result:=FILE_USERID_FAULT;
  end;
end;

//Ввод ICCode
function TACOSSmartCard.cr_CheckIC(dqICCode:Int64):Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_PERSONALIZATION_LOCK;
    if FPersonal.Lock=True then Exit;
    if Self.MemoryCard=True then
    begin
      Result:=CARD_OK;
      Exit;
    end
    else
    begin
      if Self.EnterICode(CR_PINCODE_ID xor dqICCode)=True then
      begin
        Result:=CARD_OK;
        Exit;
      end;
      if (Self.LastApduRecv.SW1=$69) and (Self.LastApduRecv.SW2=$83) then
      begin
        Result:=CARD_LOCKED;
        Exit;
      end;
    end;
   Result:=CARD_ACCESS_DENIED;
  end;
end;

//Ввод PIN кода
function TACOSSmartCard.cr_CheckPin(dqPinCode:Int64):Integer;
var SysPin: Int64;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_PERSONALIZATION_LOCK;
    if FPersonal.Lock=True then Exit;
    if Self.MemoryCard=True then
    begin
      SysPin:=0;
      if (Self.MCReadAsInt64($A8,SysPin)=True) and (SysPin=(CR_PINCODE_ID xor dqPinCode)) then
      begin
        FPersonal.PinChecked:=True;
        Result:=CARD_OK;
        Exit;
      end;
    end
    else
    begin
      if Self.EnterPinCode(CR_PINCODE_ID xor dqPinCode)=True then
      begin
        Result:=CARD_OK;
        Exit;
      end;
      if (Self.LastApduRecv.SW1=$69) and (Self.LastApduRecv.SW2=$83) then
      begin
        Result:=CARD_LOCKED;
        Exit;
      end;
    end;
   Result:=CARD_ACCESS_DENIED;
  end;
end;

//Выплюнуть карту
function TACOSSmartCard.cr_ReleaseCard:Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    if Self.Eject=True then Result:=READER_OK else Result:=READER_EJECT_FAUL;
  end;
end;

//Проверка персонализации карты
function TACOSSmartCard.cr_CardPersonalized(var bResult:Bool):Integer;
var PInt: Int64;
begin
  Result:=READER_CARD_NOTPRESENT;
  bResult:=False;
  PInt:=0;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_PERSONALIZATION_LOCK;
    if FPersonal.Lock=True then Exit;
    if Self.MemoryCard=True then
    begin
      if (Self.MCReadAsInt64($A8,PInt)=True) and (PInt<>$FFFFFFFFFFFFFFFF) and (PInt<>$00) then
      begin
        bResult:=True;
        Result:=CARD_OK;
        Exit;
      end
      else
      begin
        bResult:=False;
        Result:=CARD_OK;
        Exit;
      end;
    end
  else
  begin
    if (Self.SelectFile(FILE_MANUFACTURER)=True) and (Self.ReadRecord(0,8,PInt)=True) then
    begin
      if PInt=$80 then
      begin
        bResult:=True;
        Result:=CARD_OK;
        Exit;
      end;
      bResult:=False;
      Result:=CARD_OK;
      Exit;
    end;
  end;
  bResult:=False;
  Result:=FILE_PERSONALIZATION_FAULT;
  Exit;
  end;
end;

//Проверка размера описателя файлов
function TACOSSmartCard.FormatCardSize(var FileDesc:array of TCardFileDescription;Length:Integer):Integer;
var n: Integer;
begin
  Result:=0;
  for n:=0 to Length-1 do
  begin
    Result:=Result+FileDesc[n].FileSize;
  end;
end;

//Проверка на ошибки
function TACOSSmartCard.ErrorFormatCard(var FileDesc:array of TCardFileDescription;Length:Integer):Integer;
var n: Integer;
begin
  Result:=FILE_DESCR_LENGTHERROR;
  if Length>0 then
  begin
    for n:=0 to Length-1 do
    begin
      if Self.GetIndexFile(FileDesc[n].FileId)<>-1 then
      begin
        Result:=FILE_ALLREADY_FOUND;
        Exit;
      end;
      if (FileDesc[n].FileSize=0) or (FileDesc[n].SectorSize=0) or (FileDesc[n].Reserved<>0) or (FileDesc[n].SectorSize>FILESYSTEM_SECTORSIZE) or (FileDesc[n].FileSize>FILESYSTEM_FILESIZE) or (FileDesc[n].FileSize<FileDesc[n].SectorSize) or (round(FileDesc[n].FileSize/FileDesc[n].SectorSize)>FILESYSTEM_SECTORCOUNT) or (GetFileDescCount(FileDesc[n].FileId,FileDesc,Length)>1) then
      begin
        Result:=FILE_DESCR_ERROR;
        Exit;
      end;
      if (Self.GetPersonalSize+FormatCardSize(FileDesc,Length)>FILESYSTEM_SIZE) or (FPersonal.Count+Length>FILESYSTEM_COUNT) then
      begin
        Result:=FILE_MEMORY_FULL;
        Exit;
      end;
    end;
   Result:=0;
  end;
end;

//Псевдосоздание файла
function TACOSSmartCard.cr_FormatCard(var FileDesc:array of TCardFileDescription;Length:Integer):Integer;
var n: Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  n:=0;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_PERSONALIZATION_LOCK;
    if (FPersonal.Personal=False) and (FPersonal.Lock=False) then
    begin
      Result:=Self.ErrorFormatCard(FileDesc,Length);
      if Result<>0 then Exit;
      if Result=0 then
      begin
        for n:=0 to Length-1 do
        begin
          FPersonal.Items[FPersonal.Count].FileId:=FileDesc[n].FileId;
          FPersonal.Items[FPersonal.Count].FileSize:=FileDesc[n].FileSize;
          FPersonal.Items[FPersonal.Count].SectorSize:=FileDesc[n].SectorSize;
          FPersonal.Items[FPersonal.Count].SectorCount:=round(FileDesc[n].FileSize/FileDesc[n].SectorSize);
          FPersonal.Items[FPersonal.Count].Reserved:=FileDesc[n].Reserved;
          FPersonal.Count:=FPersonal.Count+1;
        end;
      end;
    end;
  end;
end;

//Считать данные из файла карты
function TACOSSmartCard.cr_ReadCardFile(wFileId:Word;pBuffer:TByteArray):Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    Result:=FILE_NOTFOUND;
    if Self.SelectFile(wFileId)=True then
    begin
      Result:=0;
    end;
  end;
end;

//Сохранить данные в псевдофайле карты
function TACOSSmartCard.cr_WriteCardFile(wFileId:Word;pBuffer:TByteArray):Integer;
var   n: Integer;
    m,q: Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_PERSONALIZATION_LOCK;
    if (FPersonal.Personal=False) and (FPersonal.Lock=False) then
    begin
      Result:=FILE_NOTFOUND;
      n:=Self.GetIndexFile(wFileId);
      if n<>-1 then
      begin
        for m:=0 to FPersonal.Items[n].SectorCount-1 do
        begin
          for q:=0 to FPersonal.Items[n].SectorSize-1 do
          begin
            if ((m*FPersonal.Items[n].SectorSize)+q+1)<=FPersonal.Items[n].FileSize then
            begin
              FPersonal.Items[n].hMem[m,q]:=pBuffer[(m*FPersonal.Items[n].SectorSize)+q];
            end;
          end;
        end;
      Result:=0;
    end;
  end;
 end;
end;

//Ввод IC кода
function TACOSSmartCard.cr_SetICCode(dqICCode:Int64):Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_PERSONALIZATION_LOCK;
    if (FPersonal.Personal=False) and (FPersonal.Lock=False) then
    begin
      FPersonal.ICCode:=CR_PINCODE_ID xor dqICCode;
      Result:=CARD_OK;
    end;
  end;
end;

//Новый пин код карты
function TACOSSmartCard.cr_SetPinCode(dqPinCode:Int64):Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_PERSONALIZATION_LOCK;
    if (FPersonal.Personal=False) and (FPersonal.Lock=False) then
    begin
      FPersonal.PinCode:=CR_PINCODE_ID xor dqPinCode;
      Result:=CARD_OK;
    end;
  end;
end;

//Закрыть карту для персонализации
function TACOSSmartCard.cr_LockCard:Integer;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_NOTHING_TODO;
    if FPersonal.Count=0 then Exit;
    Result:=CARD_PERSONALIZATION_LOCK;
    if (FPersonal.Personal=False) and (FPersonal.Lock=False) then
    begin
      FPersonal.Lock:=True;
      Result:=CARD_OK;
    end;
  end;
end;

//Персонализация карты
function TACOSSmartCard.cr_ResetCard:Integer;
var n,m,q: Integer;
   Buffer: array [0..256] of Byte;
        OptionRegister: Byte;
SecurityOptionRegister: Byte;
               NOfFile: Byte;
                     P: Byte;
                LenRec: Byte;
                NumRec: Byte;
                   RSA: Byte;
                   WSA: Byte;
                FileId: Word;
begin
  Result:=READER_CARD_NOTPRESENT;
  if Self.InsertedStatus=True then
  begin
    Result:=CARD_NOTHING_TODO;
    if FPersonal.Count=0 then Exit;
    Result:=CARD_PERSONALIZATION_LOCK;
    if (FPersonal.Lock=True) and (FPersonal.Personal=False) then
    begin
      Result:=CARD_NOTHING_TODO;
      if FPersonal.Count=0 then Exit;
      Result:=CARD_PERSONALIZATION_ERROR;
      if Self.Reset=False then Exit;
      if Self.MemoryCard=True then
      begin
        for n:=0 to FPersonal.Count-1 do
        begin
          if (FPersonal.Items[n].FileId=FILE_USERID) and (FPersonal.Items[n].FileSize=FILE_USERID_SIZE) then
          begin
            for m:=0 to FPersonal.Items[n].SectorCount-1 do
            begin
              for q:=0 to FPersonal.Items[n].SectorSize-1 do
              begin
                Buffer[q]:=FPersonal.Items[n].hMem[m,q];
              end;
              if Self.MCPersonalization(FPersonal.PinCode,Buffer)=True then
              begin
                if Self.Reset=False then Exit;
                Self.PersonalClear;
                Self.FPersonal.Personal:=True;
                Result:=CARD_OK;
                Exit;
              end
              else
              begin
                Exit;
              end;
            end;
          end;
        end;
      end
      else
      begin
        if Self.EnterICode(CR_ICODE_DEFAULT)=False then Exit;
//Здесь возможно изменение счетчика доступа по пин коду
        if Self.WriteManufacturerFile($00,$80)=False then Exit;
        if Self.ReadPersonalizationFile($00,OptionRegister,SecurityOptionRegister,NOfFile,P)=False then Exit;
        if Self.WritePersonalizationFile($00,OptionRegister,SecurityOptionRegister,FPersonal.Count,P)=False then Exit;
        if Self.Reset=False then Exit;
        if Self.EnterICode(CR_ICODE_DEFAULT)=False then Exit;
        for n:=0 to FPersonal.Count-1 do
        begin
          if Self.ReadUserManagmentFile(n,LenRec,NumRec,RSA,WSA,FileId)=False then Exit;
          if Self.WriteUserManagmentFile(n,FPersonal.Items[n].SectorSize,FPersonal.Items[n].SectorCount,RSA,WSA,FPersonal.Items[n].FileId)=False then Exit;
        end;
        for n:=0 to FPersonal.Count-1 do
        begin
          if Self.SelectFile(FPersonal.Items[n].FileId)=False then Exit;
          for m:=0 to FPersonal.Items[n].SectorCount-1 do
          begin
            for q:=0 to FPersonal.Items[n].SectorSize-1 do
            begin
              Buffer[q]:=FPersonal.Items[n].hMem[m,q];
            end;
            if Self.WriteRecord(m,FPersonal.Items[n].SectorSize,Buffer)=False then Exit;
          end;
        end;
        for n:=0 to FPersonal.Count-1 do
        begin
          if Self.ReadUserManagmentFile(n,LenRec,NumRec,RSA,WSA,FileId)=False then Exit;
//Здесь идет установка прав доступа к файлу - ($40,$80)
          if Self.WriteUserManagmentFile(n,FPersonal.Items[n].SectorSize,FPersonal.Items[n].SectorCount,$40,$80,FPersonal.Items[n].FileId)=False then Exit;
        end;
        if Self.ChangeICode(FPersonal.ICCode)=False then Exit;
        if Self.ChangePinCode(FPersonal.PinCode)=False then Exit;
        if Self.ReadPersonalizationFile($00,OptionRegister,SecurityOptionRegister,NOfFile,P)=False then Exit;
        OptionRegister:=$04;
        SecurityOptionRegister:=$00;
        P:=$FF;
        if Self.WritePersonalizationFile($00,OptionRegister,SecurityOptionRegister,FPersonal.Count,P)=False then Exit;
        if Self.Reset=False then Exit;
        if Self.EnterICode(FPersonal.ICCode)=False then Exit;
        if Self.EnterPinCode(FPersonal.PinCode)=False then Exit;
        for n:=0 to FPersonal.Count-1 do
        begin
          if Self.SelectFile(FPersonal.Items[n].FileId)=False then Exit;
          if Self.ReadRecord(0,Self.FPersonal.Items[N].SectorSize,Buffer)=False then Exit;
          if FPersonal.Items[n].FileId=FILE_USERID then
          begin
            for q:=0 to FPersonal.Items[n].SectorSize-1 do
            begin
              if Buffer[q]<>FPersonal.Items[n].hMem[0,q] then Exit;
            end;
          end;
        end;
        if Self.Reset=False then Exit;
        Self.PersonalClear;
        Self.FPersonal.Personal:=True;
        Result:=CARD_OK;
        Exit;
      end;
      Exit;
    end;
  end;
end;

//Расшифровка кодов ошибок
function TACOSSmartCard.cr_GetErrorString(iErrorCode:Integer):String;
begin
  Result:='Неизвестная ошибка '+IntToStr(iErrorCode);
  if iErrorCode=0 then Result:='Команда выполнена успешно';
  if iErrorCode=READER_ACTIVATION_FAULT then Result:='Неудается активировать картридер';
  if iErrorCode=READER_DEACTIVATION_FAUL then Result:='Неудается деактивировать картридер.';
  if iErrorCode=READER_EJECT_FAUL then Result:='Невозможно выплюнуть карту из картридера.';
  if iErrorCode=READER_CARD_NOTPRESENT then Result:='Отстутствует карта в картридере.';
  if iErrorCode=CARD_ACCESS_DENIED then Result:='Нет доступа к данным карты. Пин код введен не верно.';
  if iErrorCode=CARD_LOCKED then Result:='Карта заблокирована, так как лимит набора пин кодов был исчерпан.';
  if iErrorCode=CARD_PERSONALIZATION_LOCK then Result:='Карта уже персонализирована либо заблокирована для персонализации.';
  if iErrorCode=CARD_NOTHING_TODO then Result:='Нет данных для персонализации';
  if iErrorCode=CARD_PERSONALIZATION_ERROR then Result:='Ошибка при персонализации карты';
  if iErrorCode=FILE_DESCR_ERROR then Result:='Ошибка в описании структуры файловой системы';
  if iErrorCode=FILE_ALLREADY_FOUND then Result:='Идентификатор файла который вы хотите создать уже существует.';
  if iErrorCode=FILE_MEMORY_FULL then Result:='Нет свободного места для создания файлов.';
  if iErrorCode=FILE_DESCR_LENGTHERROR then Result:='Ошибка при указании длинны структуры';
  if iErrorCode=FILE_NOTFOUND then Result:='Файл не найден';
  if iErrorCode=FILE_SERIALNUMBER_FAULT then Result:='Возникла ошибка при получении серийного номера карты.';
  if iErrorCode=FILE_USERID_FAULT then Result:='Возникла ошибка при получении уникального номера пользователя.';
  if iErrorCode=FILE_PERSONALIZATION_FAULT then Result:='Ошибка при получении статуса персонализации.';
end;

//Расшифровка кодов ошибок
function GetErrorString(iErrorCode:Integer):String;
begin
  Result:='Неизвестная ошибка '+IntToStr(iErrorCode);
  if iErrorCode=0 then Result:='Команда выполнена успешно';
  if iErrorCode=READER_ACTIVATION_FAULT then Result:='Неудается активировать картридер';
  if iErrorCode=READER_DEACTIVATION_FAUL then Result:='Неудается деактивировать картридер.';
  if iErrorCode=READER_EJECT_FAUL then Result:='Невозможно выплюнуть карту из картридера.';
  if iErrorCode=READER_CARD_NOTPRESENT then Result:='Отстутствует карта в картридере.';
  if iErrorCode=CARD_ACCESS_DENIED then Result:='Нет доступа к данным карты. Пин код введен не верно.';
  if iErrorCode=CARD_LOCKED then Result:='Карта заблокирована, так как лимит набора пин кодов был исчерпан.';
  if iErrorCode=CARD_PERSONALIZATION_LOCK then Result:='Карта уже персонализирована либо заблокирована для персонализации.';
  if iErrorCode=CARD_NOTHING_TODO then Result:='Нет данных для персонализации';
  if iErrorCode=CARD_PERSONALIZATION_ERROR then Result:='Ошибка при персонализации карты';
  if iErrorCode=FILE_DESCR_ERROR then Result:='Ошибка в описании структуры файловой системы';
  if iErrorCode=FILE_ALLREADY_FOUND then Result:='Идентификатор файла который вы хотите создать уже существует.';
  if iErrorCode=FILE_MEMORY_FULL then Result:='Нет свободного места для создания файлов.';
  if iErrorCode=FILE_DESCR_LENGTHERROR then Result:='Ошибка при указании длинны структуры';
  if iErrorCode=FILE_NOTFOUND then Result:='Файл не найден';
  if iErrorCode=FILE_SERIALNUMBER_FAULT then Result:='Возникла ошибка при получении серийного номера карты.';
  if iErrorCode=FILE_USERID_FAULT then Result:='Возникла ошибка при получении уникального номера пользователя.';
  if iErrorCode=FILE_PERSONALIZATION_FAULT then Result:='Ошибка при получении статуса персонализации.';
end;

end.

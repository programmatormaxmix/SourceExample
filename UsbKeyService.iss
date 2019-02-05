; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=MITRA System Files
AppVerName=MITRA System Files 4.2.2 build ({code:GetServiceVersion})
DefaultDirName={pf}\RMC\MitraSystemFiles
DefaultGroupName=RMC
AllowNoIcons=false
OutputDir=D:\Sources\Release
OutputBaseFilename=MitraSystemFiles
Compression=lzma
SolidCompression=true
WizardImageFile=D:\sources\common\picture\Wizard2.bmp
AppID={{FB1D1927-CCF0-4586-A1DD-8893B6502FEB}}
ShowLanguageDialog=no
WizardImageStretch=false
DisableProgramGroupPage=true
VersionInfoTextVersion=4.2.2
VersionInfoVersion=4.2.2
VersionInfoCompany=RMC
VersionInfoCopyright=RMC
VersionInfoDescription=MITRA System Files
DisableWelcomePage=no

[Languages]
Name: russian; MessagesFile: compiler:Languages\Russian.isl

;[Tasks]
;Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked

[Files]

; �������� ����� ���������
Source: D:\sources\builds\Windows_NT.x86\decgate.dll; DestDir: {sys}; Flags: promptifolder;
Source: D:\sources\builds\Windows_NT.x86\gost.dll; DestDir: {sys}; Flags: promptifolder;
Source: D:\sources\common\usbkeyservice\DecoderInfo32.bat; DestDir: {app}; DestName: "DecoderInfo.bat";  Flags: ignoreversion; Check: IsWindows32;
Source: D:\sources\common\usbkeyservice\DecoderInfo64.bat; DestDir: {app}; DestName: "DecoderInfo.bat"; Flags: ignoreversion; Check: IsWindows64;
Source: D:\sources\builds\Windows_NT.x86\UsbKeyService.exe; DestDir: {app}; Flags: ignoreversion;
Source: D:\sources\common\usbkeyservice\UsbKeyService0.ini; DestName: "UsbKeyService.ini"; DestDir: {app}; Flags: onlyifdoesntexist; Check: CheckFirmwareMode;
Source: D:\sources\common\usbkeyservice\UsbKeyService1.ini; DestName: "UsbKeyService.ini"; DestDir: {app}; Flags: onlyifdoesntexist; Check: CheckUserMode;  
Source: D:\sources\common\usbkeyservice\UsbKeyService.dblite; DestDir: {app}\UsbKeyService; Flags: ignoreversion;
Source: D:\sources\common\usbkeyservice\UsbKeyService.xml; DestDir: {app}\UsbKeyService; Flags: ignoreversion;

; ��������� ���������
Source: D:\sources\builds\Windows_NT.x86\ServiceUtil.dll; DestDir: {app}; Flags: ignoreversion;
Source: D:\sources\common\guardantdrv\GrdDriver32.msi; DestName: "GrdDriverInstall.msi"; DestDir: {app}; Flags: ignoreversion; Check: IsWindows32;
Source: D:\sources\common\guardantdrv\GrdDriver64.msi; DestName: "GrdDriverInstall.msi"; DestDir: {app}; Flags: ignoreversion; Check: IsWindows64;
Source: D:\sources\builds\Windows_NT.x86\Diagnostic.exe; DestDir: {app}; Flags: ignoreversion;

; ���������� ��������(Xml Server)
Source: D:\sources\builds\Windows_NT.x86\XMLTools.bpl; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\SQLITE.bpl; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\Shared.bpl; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\Message.bpl; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\Logging.bpl; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\Language.bpl; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\HTTP.bpl; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\Entity.bpl; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\Associate.bpl; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\QueryEngine.dll; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\MurmurHash.dll; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\pcrelib.dll; DestDir: {app}; Flags: ignoreversion
Source: D:\sources\builds\Windows_NT.x86\LoggingEngine.dll; DestDir: {app}; Flags: ignoreversion

; ����� ������� � ���� sqlite
Source: D:\sources\builds\Windows_NT.x86\sqlite3.dll; DestDir: {sys}; Flags: promptifolder
Source: D:\sources\builds\Windows_NT.x86\sqlite3u.dll; DestDir: {sys}; Flags: promptifolder

; ��������� ���������� Delphi 10
Source: D:\sources\common\bplfiles\vcl100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\rtl100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\soaprtl100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\tee7100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\teedb7100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\teeui7100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vclactnband100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vcldb100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vcldbx100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vclib100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vclie100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vclimg100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vcljpg100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vclshlctrls100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vclsmp100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\vclx100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\webdsnap100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\websnap100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\xmlrtl100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\Intraweb_90_100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\IntrawebDB_90_100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\adortl100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\bdertl100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\dbexpress4100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\dbrtl100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\dbxcds4100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\DbxCommonDriver100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\dsnap100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\dsnapcon100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\dsnapent100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\ibevnt100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\ibxpress100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\inet100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\inetdb100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\inetdbbde100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\inetdbxpress4100.bpl; DestDir: {sys}; Flags: onlyifdoesntexist
Source: D:\sources\common\bplfiles\midas.dll; DestDir: {sys}; Flags: onlyifdoesntexist allowunsafefiles

[Icons]
Name: {group}\MITRA System Files\���������� � �������; Filename: {app}\DecoderInfo.bat; WorkingDir: {app}; IconIndex: 0; IconFilename: {app}\DecoderInfo.bat; Flags: createonlyiffileexists
Name: {group}\MITRA System Files\��������� ������; Filename: "net.exe"; Parameters: "start {code:GetServiceName}"; WorkingDir: "{app}"; Flags: createonlyiffileexists
Name: {group}\MITRA System Files\���������� ������; Filename: "net.exe"; Parameters: "stop {code:GetServiceName}"; WorkingDir: "{app}"; Flags: createonlyiffileexists

[Run]
Filename: {src}\SystemFiles.reg; Description: {cm:LaunchProgram, SystemFilesReg}; Flags: skipifdoesntexist shellexec; Components: ; Tasks: ; Languages:
Filename: msiexec.exe; Parameters: "/package ""{app}\GrdDriverInstall.msi"; StatusMsg: "��������� ��������� Guardant..."; Flags: skipifdoesntexist;
Filename: {app}\UsbKeyService.exe; Parameters: "/install /silent"; StatusMsg: "��������� �������..."; Flags: runhidden
Filename: net.exe; Parameters: "start {code:GetServiceName}"; StatusMsg: "������ �������..."; Flags: runhidden
                     
[Registry]
Root: HKCU; SubKey: Software\RMC\SystemFiles; Flags: uninsdeletekey
Root: HKLM; Subkey: Software\RMC\SystemFiles\Install; ValueType: string; ValueName: Dir; ValueData: {app}; Flags: uninsdeletevalue
Root: HKLM; Subkey: Software\RMC\SystemFiles\Install; ValueType: string; ValueName: Ver; ValueData: {code:GetServiceVersion}; Flags: uninsdeletevalue
Root: HKLM; Subkey: Software\RMC\SystemFiles\Install; ValueType: string; ValueName: Dll; ValueData: {code:GetDllVersion}; Flags: uninsdeletevalue

[Code]

function StopAndDeleteSetup(ServiceName: PChar): boolean;
  external 'StopAndDelete@files:ServiceUtil.dll stdcall setuponly';

function StopAndDeleteUnistall(ServiceName: PChar): boolean;
  external 'StopAndDelete@{app}\ServiceUtil.dll stdcall uninstallonly';

var
  UninstServiceProgressPage: TOutputProgressWizardPage;

//�������� ��� �������
function GetServiceName(Src: String): String;
begin
  Result:='Service1';
end;

//�������� ������ �������
function GetServiceVersion(Src: String): String;
begin
  Result:='1.0.0.384';
end;

//�������� ������ DLL
function GetDllVersion(Src: String): String;
begin
  Result:='1.0.0.1159';
end;

//����������� � ������ ����������������
function CheckFirmwareMode: Boolean;
begin
  if (Pos('/FIRMWARE',UpperCase(GetCmdTail))>0) or (Pos('-FIRMWARE',UpperCase(GetCmdTail))>0) then Result:=True else Result:=False;
end;

//����������� � ������ ������������
function CheckUserMode: Boolean;
begin
  if (Pos('/FIRMWARE',UpperCase(GetCmdTail))>0) or (Pos('-FIRMWARE',UpperCase(GetCmdTail))>0) then Result:=False else Result:=True;
end;

function IsWindows32: Boolean;
begin
  if IsWin64=False then Result:=True else Result:=False;
end;

function IsWindows64: Boolean;
begin
  Result:=IsWin64;
end;

function InitializeSetup(): Boolean;
begin
  Result:=IsAdminLoggedOn;
  if Result=False then MsgBox('������������ ���� ��� ������� ���������',mbInformation,MB_OK);
  if CheckFirmwareMode=True then MsgBox('����������� ������� � ������ ���������������� �����',mbInformation,MB_OK);
end;

procedure InitializeWizard;
begin 
  UninstServiceProgressPage:=CreateOutputProgressPage('���������� ��������', '��������� � �������� �������');
end;

function NextButtonClick(CurPage: Integer): Boolean;
begin
  Result := True;
  if CurPage = wpReady then
  begin
    UninstServiceProgressPage.Show;
    try
      UninstServiceProgressPage.SetText('�������� ������ ������ �������', '');
      if not StopAndDeleteSetup(GetServiceName('')) then
      begin
        MsgBox('������ ��� ������� ���������� � ������� ���������� ������ ������� ' + GetServiceName(''), mbError, MB_OK)
        Result := False;
      end;
    finally
      UninstServiceProgressPage.Hide;
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    if not StopAndDeleteUnistall(GetServiceName('')) then
    begin
      MsgBox('������ ��� ������� ���������� � ������� ������ ' + GetServiceName(''), mbError, MB_OK)
    end;
    UnloadDLL(ExpandConstant('{app}\ServiceUtil.dll'));
  end;
end;


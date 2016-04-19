
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           version 3.4 for Delphi 3,4,5                }
{                                                       }
{       Copyright (C) 1997,2000 MichaL MutL             }
{                                                       }
{*******************************************************}
unit OBSysInfo;

interface

uses
  SysUtils, Windows, Classes,Registry, MMSystem, WinSock, Printers, DesignIntf;

const
  cAbout = 'MiTeC System Info 3.4 - Copyright © 1997-2000 MichaL MutL';

  cSystem = 0;
  cGDI = 1;
  cUSER = 2;

type
  {$IFDEF VER150}
    {$DEFINE D4PLUS}
  {$ENDIF}
  {$IFDEF VER140}
    {$DEFINE D4PLUS}
  {$ENDIF}
  {$IFDEF VER130}
    {$DEFINE D4PLUS}
  {$ENDIF}
  {$IFDEF VER120}
    {$DEFINE D4PLUS}
  {$ENDIF}

  {$IFDEF D4PLUS}
     TLargInt = _LARGE_INTEGER;
  {$ELSE}
     TLargInt = TLargeInteger;
     Int64 = TLargeInteger;
     LongWord = DWORD;
  {$ENDIF}

  TStrBuf = array[0..11] of char;

  TPlatFormType = (os9x,osNT4,os2K);

  TCPUFeatures = class(TPersistent)
  private
    FSYSENTERExt: boolean;
    FMTRR: boolean;
    FModSpecReg: boolean;
    FPageSizeExt: boolean;
    FTimeStampCnt: boolean;
    FMachineChkExc: boolean;
    FMMX: boolean;
    FPageAttrTable: boolean;
    FPhysAddrExt: boolean;
    FFXInstr: boolean;
    FVirtModExt: boolean;
    FPageGlobalExt: boolean;
    FCMOVccOpcode: boolean;
    FFPU: boolean;
    FCMPXCHG8B: boolean;
    FMachineCheck: boolean;
    FAPIC: boolean;
    FDebugExt: boolean;
    FPageSizeExt36bit: boolean;
  public
    procedure GetFeaturesStr(AClear :boolean; AFeatures :TStringList);
  published
    property FXInstr :Boolean read FFXInstr write FFxInstr stored false;
    property MMX :Boolean read FMMX write FMMX stored false;
    property PageSizeExt36bit :Boolean read FPageSizeExt36bit write FPageSizeExt36bit stored false;
    property PageAttrTable :Boolean read FPageAttrTable write FPageAttrTable stored false;
    property CMOVccOpcode :Boolean read FCMOVccOpcode write FCMOVccOpcode stored false;
    property MachineCheck :Boolean read FMachineCheck write FMachineCheck stored false;
    property PageGloablExt :Boolean read FPageGlobalExt write FPageGlobalExt stored false;
    property MTRR :Boolean read FMTRR write FMTRR stored false;
    property SYSENTERExt :Boolean read FSYSENTERExt write FSYSENTERExt stored false;
    property APIC :Boolean read FAPIC write FAPIC stored false;
    property CMPXCHG8B :Boolean read FCMPXCHG8B write FCMPXCHG8B stored false;
    property MachineChkExc :Boolean read FMachineChkExc write FMachineChkExc stored false;
    property PhysAddrExt :Boolean read FPhysAddrExt write FPhysAddrExt stored false;
    property ModSpecReg :Boolean read FModSpecReg write FModSpecReg stored false;
    property TimeStampCnt :Boolean read FTimeStampCnt write FTimeStampCnt stored false;
    property PageSizeExt :Boolean read FPageSizeExt write FPageSizeExt stored false;
    property DebugExt :Boolean read FDebugExt write FDebugExt stored false;
    property VirtModExt :Boolean read FVirtModExt write FVirtModExt stored false;
    property FPU :Boolean read FFPU write FFPU stored false;
  end;

  TCPU = class(TPersistent)
  private
    FVendorID,
    FVendor,
    FSubModel: string;
    FModel,
    FCount,
    FArchitecture,
    FLevel,
    FStepping,
    FFamily,
    FTyp,
    FVendorNo,
    FFreq :integer;
    FCPUID :boolean;
    FFeatures: TCPUFeatures;
    function CPUIDExists: boolean;
    procedure GetCPUID;
    function GetCPUIDLevel :integer;
    function GetCPUType :integer;
    function GetCPUVendor :string;
    function GetCPUVendorID :string;
    function GetCPUFreqEx :extended;
    function GetSubModel :string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property CPUID :Boolean read FCPUID write FCPUID stored false;
    property Architecture :integer read FArchitecture write FArchitecture stored false;
    property Level :integer read FLevel write FLevel stored false;
    property Count :integer read FCount write FCount stored false;
    property Vendor :string read FVendor write FVendor stored false;
    property VendorID :string read FVendorID write FVendorID stored false;
    property Freq :integer read FFreq write FFreq stored false;
    property Family :integer read FFamily write FFamily stored false;
    property Stepping :integer read FStepping write FStepping stored false;
    property Model :integer read FModel write FModel stored false;
    property Typ :integer read FTyp write FTyp stored false;
    property Features :TCPUFeatures read FFeatures write FFeatures;
    property SubModel :string read FSubModel write FSubModel stored false;
  end;

  TMemory = class(TPersistent)
  private
    FMaxAppAddress: integer;
    FVirtualTotal: integer;
    FPageFileFree: integer;
    FVirtualFree: integer;
    FPhysicalFree: integer;
    FAllocGranularity: integer;
    FMinAppAddress: integer;
    FMemoryLoad: integer;
    FPhysicalTotal: integer;
    FPageFileTotal: integer;
    FPageSize: integer;
  public
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property PhysicalTotal :integer read FPhysicalTotal write FPhysicalTotal stored false;
    property PhysicalFree :integer read FPhysicalFree write FPhysicalFree stored false;
    property VirtualTotal :integer read FVirtualTotal write FVirtualTotal stored false;
    property VirtualFree :integer read FVirtualFree write FVirtualFree stored false;
    property PageFileTotal :integer read FPageFileTotal write FPageFileTotal stored false;
    property PageFileFree :integer read FPageFileFree write FPageFileFree stored false;
    property MemoryLoad :integer read FMemoryLoad write FMemoryLoad stored false;
    property AllocGranularity :integer read FAllocGranularity write FAllocGranularity stored false;
    property MaxAppAddress :integer read FMaxAppAddress write FMaxAppAddress stored false;
    property MinAppAddress :integer read FMinAppAddress write FMinAppAddress stored false;
    property PageSize :integer read FPageSize write FPageSize stored false;
  end;

  PWindow = ^TWindow;
  TWindow = record
    ClassName,
    Text :string;
    Handle,
    Process,
    Thread :longword;
    ParentWin,
    WndProc,
    Instance,
    ID,
    UserData,
    Style,
    ExStyle :longint;
    Rect,
    ClientRect :TRect;
    Atom,
    ClassBytes,
    WinBytes,
    ClassWndProc,
    ClassInstance,
    Background,
    Cursor,
    Icon,
    ClassStyle :longword;
    Styles,
    ExStyles,
    ClassStyles :tstringlist;
    Visible :boolean;
  end;

  TOperatingSystem = class(TPersistent)
  private
    FBuildNumber: integer;
    FMajorVersion: integer;
    FMinorVersion: integer;
    FPlatform: string;
    FCSD: string;
    FVersion: string;
    FRegUser: string;
    FSerialNumber: string;
    FRegOrg: string;
    FTimeZone: string;
    FEnv: TStrings;
    FTempDir: string;
    FWinDir: string;
    FSysDir: string;

    function GetSystemRes: Byte;
    function GetGDIRes: Byte;
    function GetUSERRes: Byte;

    procedure GetEnvironment;
  protected
    procedure SetNone(Value: Byte);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property MajorVersion :integer read FMajorVersion write FMajorVersion stored false;
    property MinorVersion :integer read FMinorVersion write FMinorVersion stored false;
    property BuildNumber :integer read FBuildNumber write FBuildNumber stored false;
    property Platform :string read FPlatform write FPlatform stored false;
    property Version :string read FVersion write FVersion stored false;
    property CSD :string read FCSD write FCSD stored false;
    property SerialNumber :string read FSerialNumber write FSerialNumber stored false;
    property RegisteredUser :string read FRegUser write FRegUser stored false;
    property RegisteredOrg :string read FRegOrg write FRegOrg stored false;
    property TimeZone :string read FTimeZone write FTimeZone stored false;
    property Environment :TStrings read FEnv write FEnv stored false;
    property WinDir :string read FWinDir write FWinDir stored false;
    property SysDir :string read FSysDir write FSysDir stored false;
    property TempDir :string read FTempDir write FTempDir stored false;
//    property SystemRes: Byte read GetSystemRes write SetNone;
//    property GDIRes: Byte read GetGDIRes write SetNone;
//    property UserRes: Byte read GetUserRes write SetNone;
  end;

  TFileFlag = (fsCaseIsPreserved, fsCaseSensitive, fsUnicodeStoredOnDisk,
               fsPersistentAcls, fsFileCompression, fsVolumeIsCompressed,
               fsLongFileNames,
               // following flags are valid only for Windows2000
               fsEncryptedFileSystemSupport, fsObjectIDsSupport, fsReparsePointsSupport,
               fsSparseFilesSupport, fsDiskQuotasSupport);
  TFileFlags = set of TFileFlag;

  TDriveType = (dtUnknown, dtNotExists, dtRemovable, dtFixed, dtRemote, dtCDROM, dtRAMDisk);

  TDiskSign = string[2];

  TDisk = class(TPersistent)
  private
    FDisk: TDiskSign;
    FMediaPresent: Boolean;
    FDriveType: TDriveType;
    FSectorsPerCluster: DWORD;
    FBytesPerSector: DWORD;
    FFreeClusters: DWORD;
    FTotalClusters: DWORD;
    FFileFlags: TFileFlags;
    FVolumeLabel: string;
    FSerialNumber: string;
    FFileSystem: string;
    FFreeSpace: int64;
    FCapacity: int64;
    FAvailDisks: string;
    FSerial: dword;
    FModel: string;
    function GetMediaPresent: Boolean;
  protected
    procedure SetDisk(const Value: TDiskSign);
  public
    procedure GetInfo;
    function GetDriveTypeStr(dt :TDriveType) :string;
    procedure GetFileFlagsStr(AClear :boolean; var AFileFlags :TStringList);
    procedure Report(var sl :TStringList);
    function GetCD :byte;
    property Serial :dword read FSerial write FSerial stored false;
  published
    property Drive :TDiskSign read FDisk write SetDisk stored false;
    property AvailableDisks :string read FAvailDisks write FAvailDisks stored false;
    property MediaPresent :Boolean read GetMediaPresent write FMediaPresent stored false;
    property DriveType :TDriveType read FDriveType write FDriveType stored false;
    property FileFlags :TFileFlags read FFileFlags write FFileFlags stored false;
    property FileSystem :string read FFileSystem write FFileSystem stored false;
    property FreeClusters :DWORD read FFreeClusters write FFreeClusters stored false;
    property TotalClusters :DWORD read FTotalClusters write FTotalClusters stored false;
    // FreeSpace and Capacity returns good results for Win95 OSR2, Win98, NT and 2000
    // for Win95 there can be bad sizes for drives over 2GB
    property FreeSpace :int64 read FFreeSpace write FFreeSpace stored false;
    property Capacity :int64 read FCapacity write FCapacity stored false;
    property SerialNumber :string read FSerialNumber write FSerialNumber stored false;
    property VolumeLabel :string read FVolumeLabel write FVolumeLabel stored false;
    property SectorsPerCluster :DWORD read FSectorsPerCluster write FSectorsPerCluster stored false;
    property BytesPerSector :DWORD read FBytesPerSector write FBytesPerSector stored false;
    property Model: string read FModel write FModel stored False;
  end;

  TWorkstation = class(TPersistent)
  private
    FName: string;
    FLastBoot: TDatetime;
    FUser: string;
    FSystemUpTime: Extended;
    FBIOSExtendedInfo: string;
    FBIOSCopyright: string;
    FBIOSName: string;
    FBIOSDate: string;
    FScrollLock: Boolean;
    FNumLock: Boolean;
    FCapsLock: Boolean;
    function GetSystemUpTime: Extended;
  public
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property Name :string read FName write FName stored false;
    property User :string read FUser write FUser stored false;
    property SystemUpTime :Extended read FSystemUpTime write FSystemUpTime stored false;
    property LastBoot :TDatetime read FLastBoot write FLastBoot stored false;
    property BIOSCopyright :string read FBIOSCopyright write FBIOSCopyright stored false;
    property BIOSDate :string read FBIOSDate write FBIOSDate stored false;
    property BIOSExtendedInfo :string read FBIOSExtendedInfo write FBIOSExtendedInfo stored false;
    property BIOSName :string read FBIOSName write FBIOSName stored false;
    property CapsLock: Boolean read FCapsLock write FCapsLock stored false;
    property NumLock: Boolean read FNumLock write FNumLock stored false;
    property ScrollLock: Boolean read FScrollLock write FScrollLock stored false;
  end;

  TWinsock = class(TPersistent)
  private
    FDesc: string;
    FStat: string;
    FMajVer: word;
    FMinVer: word;
  public
    procedure GetInfo;
  published
    property Description: string read FDesc write FDesc stored False;
    property MajorVersion: word read FMajVer write FMajVer stored False;
    property MinorVersion: word read FMinVer write FMinVer stored False;
    property Status: string read FStat write FStat stored False;
  end;

  TNetwork = class(TPersistent)
  private
    FIPAddress: string;
    FAdapter: TStrings;
    FWinsock: TWinsock;
    function GetLocalIP :string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property IPAddress :string read FIPAddress write FIPAddress stored false;
    property Adapter :TStrings read FAdapter write FAdapter stored false;
    property WinSock: TWinsock read FWinsock write FWinsock;
  end;

  TCurveCap = (ccCircles,ccPieWedges,ccChords,ccEllipses,ccWideBorders,ccStyledBorders,
               ccWideStyledBorders,ccInteriors,ccRoundedRects);
  TLineCap = (lcPolylines,lcMarkers,lcMultipleMarkers,lcWideLines,lcStyledLines,
               lcWideStyledLines,lcInteriors);
  TPolygonCap = (pcAltFillPolygons,pcRectangles,pcWindingFillPolygons,pcSingleScanlines,
                 pcWideBorders,pcStyledBorders,pcWideStyledBorders,pcInteriors);
  TRasterCap = (rcRequiresBanding,rcTranserBitmaps,rcBitmaps64K,rcSetGetDIBits,
                rcSetDIBitsToDevice,rcFloodfills,rcWindows2xFeatures,rcPaletteBased,
                rcScaling,rcStretchBlt,rcStretchDIBits);
  TTextCap = (tcCharOutPrec,tcStrokeOutPrec,tcStrokeClipPrec,tcCharRotation90,
              tcCharRotationAny,tcScaleIndependent,tcDoubledCharScaling,tcIntMultiScaling,
              tcAnyMultiExactScaling,tcDoubleWeightChars,tcItalics,tcUnderlines,
              tcStrikeouts,tcRasterFonts,tcVectorFonts,tcNoScrollUsingBlts);

  TCurveCaps = set of TCurveCap;
  TLineCaps = set of TLineCap;
  TPolygonCaps = set of TPolygonCap;
  TRasterCaps = set of TRasterCap;
  TTextCaps = set of TTextCap;

  TVideo = class(TPersistent)
  private
    FVertRes: integer;
    FColorDepth: integer;
    FHorzRes: integer;
    FBIOSDate: string;
    FBIOSVersion: string;
    FPixelDiagonal: integer;
    FPixelHeight: integer;
    FVertSize: integer;
    FPixelWidth: integer;
    FHorzSize: integer;
    FTechnology: string;
    FCurveCaps: TCurveCaps;
    FLineCaps: TLineCaps;
    FPolygonCaps: TPolygonCaps;
    FRasterCaps: TRasterCaps;
    FTextCaps: TTextCaps;
    FMemory: TStrings;
    FChipset: TStrings;
    FAdapter: TStrings;
    FDAC: TStrings;
    FAcc: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure GetCurveCapsStr(AClear :boolean; ACaps :TStringList);
    procedure GetLineCapsStr(AClear :boolean; ACaps :TStringList);
    procedure GetPolygonCapsStr(AClear :boolean; ACaps :TStringList);
    procedure GetRasterCapsStr(AClear :boolean; ACaps :TStringList);
    procedure GetTextCapsStr(AClear :boolean; ACaps :TStringList);
    procedure Report(var sl :TStringList);
  published
    property Adapter :TStrings read FAdapter write FAdapter stored false;
    property Accelerator :TStrings read FAcc write FAcc stored false;
    property DAC :TStrings read FDAC write FDAC stored false;
    property Chipset :TStrings read FChipset write FChipset stored false;
    property Memory :TStrings read FMemory write FMemory stored false;
    property HorzRes :integer read FHorzRes write FHorzRes stored false;
    property VertRes :integer read FVertRes write FVertRes stored false;
    property ColorDepth :integer read FColorDepth write FColorDepth stored false;
    // BIOS info is available only under NT
    property BIOSVersion :string read FBIOSVersion write FBIOSVersion stored false;
    property BIOSDate :string read FBIOSDate write FBIOSDate stored false;
    property Technology :string read FTechnology write FTechnology stored false;
//    property HorzSize :integer read FHorzSize write FHorzSize stored false;
//    property VertSize :integer read FVertSize write FVertSize stored false;
    property PixelWidth :integer read FPixelWidth write FPixelWidth stored false;
    property PixelHeight :integer read FPixelHeight write FPixelHeight stored false;
    property PixelDiagonal :integer read FPixelDiagonal write FPixelDiagonal stored false;
    property RasterCaps :TRasterCaps read FRasterCaps write FRasterCaps stored false;
    property CurveCaps :TCurveCaps read FCurveCaps write FCurveCaps stored false;
    property LineCaps :TLineCaps read FLineCaps write FLineCaps stored false;
    property PolygonCaps :TPolygonCaps read FPolygonCaps write FPolygonCaps stored false;
    property TextCaps :TTextCaps read FTextCaps write FTextCaps stored false;
  end;

  TMedia = class(TPersistent)
  private
    FDevice: TStrings;
    FAUX: string;
    FMIDIIn: string;
    FMixer: string;
    FWAVEOut: string;
    FWAVEIn: string;
    FMIDIOut: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property Device :TStrings read FDevice write FDevice stored false;
    property WAVEIn :string read FWAVEIn write FWAVEIn stored false;
    property WAVEOut :string read FWAVEOut write FWAVEOut stored false;
    property MIDIIn :string read FMIDIIn write FMIDIIn stored false;
    property MIDIOut :string read FMIDIOut write FMIDIOut stored false;
    property AUX :string read FAUX write FAUX stored false;
    property Mixer :string read FMixer write FMixer stored false;
  end;

  TDevices = class(TPersistent)
  private
    FKeyboard: string;
    FMouse: string;
    FSD: TStrings;
    FSCSI: TStrings;
    FUSB: TStrings;
    FModem: TStrings;
    FMonitor: TStrings;
    FPrinter: TStrings;
    FPort: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property Monitor :TStrings read FMonitor write FMonitor stored false;
    property Printer :TStrings read FPrinter write FPrinter stored false;
    property Keyboard :string read FKeyboard write FKeyboard stored false;
    property Mouse :string read FMouse write FMouse stored false;
    property SystemDevice :TStrings read FSD write FSD stored false;
    property USB :TStrings read FUSB write FUSB stored false;
    property SCSI :TStrings read FSCSI write FSCSI stored false;
    property Modem :TStrings read FModem write FModem stored false;
    property Port :TStrings read FPort write FPort stored false;
  end;

  TEngines = class(TPersistent)
  private
    FBDE: string;
    FODBC: string;
  public
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property ODBC :string read FODBC write FODBC stored false;
    property BDE :string read FBDE write FBDE stored false;
  end;

  TAPM = class(TPersistent)
  private
    FBatteryLifePercent: Byte;
    FBatteryLifeFullTime: DWORD;
    FBatteryLifeTime: DWORD;
    FACPowerStatus: string;
    FBatteryChargeStatus: string;
  public
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property ACPowerStatus :string read FACPowerStatus write FACPowerStatus stored false;
    property BatteryChargeStatus :string read FBatteryChargeStatus write FBatteryChargeStatus stored false;
    property BatteryLifePercent :Byte read FBatteryLifePercent write FBatteryLifePercent stored false;
    property BatteryLifeTime :DWORD read FBatteryLifeTime write FBatteryLifeTime stored false;
    property BatteryLifeFullTime :DWORD read FBatteryLifeFullTime write FBatteryLifeFullTime stored false;
  end;

  TDirectX = class(TPersistent)
  private
    FVersion: string;
    FDirect3D: TStrings;
    FDirectPlay: TStrings;
    FDirectMusic: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property Version :string read FVersion write FVersion stored false;
    property Direct3D :TStrings read FDirect3D write FDirect3D stored false;
    property DirectPlay :TStrings read FDirectPlay write FDirectPlay stored false;
    property DirectMusic :TStrings read FDirectMusic write FDirectMusic stored false;
  end;

  TMSystemInfo = class(TComponent)
  private
    FCPU: TCPU;
    FMemory: TMemory;
    FOS :TOperatingSystem;
    FDisk :TDisk;
    FWorkstation: TWorkstation;
    FNetwork: TNetwork;
    FVideo: TVideo;
    FEngines: TEngines;
    FDevices: TDevices;
    FAPM :TAPM;
    FAbout: string;
    FDirectX: TDirectX;
    FMedia: TMedia;
    procedure SetAbout(const Value: string);
  public
    constructor Create(AOwner :TComponent); override;
    destructor Destroy; override;
    procedure Refresh;
    procedure Report(var sl :TStringList);
  published
    property About :string read FAbout write SetAbout;
    property CPU :TCPU read FCPU write FCPU;
    property Memory :TMemory read FMemory write FMemory;
    property OS :TOperatingSystem read FOS write FOS;
    property Disk :TDisk read FDisk write FDisk;
    property Workstation :TWorkstation read FWorkstation write FWorkstation;
    property Network :TNetwork read FNetwork write FNetwork;
    property Video :TVideo read FVideo write FVideo;
    property Media :TMedia read FMedia write FMedia;
    property Devices :TDevices read FDevices write FDevices;
    property Engines :TEngines read FEngines write FEngines;
    property APM :TAPM read FAPM write FAPM;
    property DirectX :TDirectX read FDirectX write FDirectX;
  end;

  TOBSysInfo = class(TMSystemInfo)
  published
  end;


  function FormatSeconds(TotalSeconds :comp; WholeSecondsOnly,
                         DisplayAll, DTFormat :Boolean) :String;
  function ReadVerInfo(const fn :string; var Desc :string) :string;
  function ReadRegInfo(ARoot :hkey; AKey, AValue :string) :string;
  function GetTimeStamp :TLargInt;
  function GetTicksPerSecond(Iterations :Word) :Comp;
  function GetWindowInfo(wh: hwnd): PWindow;
  function GetFreeSysRes(SysRes: Word): Word;
  procedure GetEnvironment(EnvList :tstringlist);
  function GetWinSysDir: string;

  

  procedure Register;

const
  ID_Bit = $200000;    // EFLAGS ID bit

  CPUVendorIDs :array[0..5] of string = ('GenuineIntel',
                                         'UMC UMC UMC',
                                         'AuthenticAMD',
                                         'CyrixInstead',
                                         'NexGenDriven',
                                         'CentaurHauls');

  CPUVendors :array[0..5] of string = ('Intel',
                                       'UMC',
                                       'AMD',
                                       'Cyrix',
                                       'NexGen',
                                       'CentaurHauls');

  {
  FILE_SUPPORTS_ENCRYPTION =
  FILE_SUPPORTS_OBJECT_IDS =
  FILE_SUPPORTS_REPARSE_POINTS =
  FILE_SUPPORTS_SPARSE_FILES =
  FILE_VOLUME_QUOTAS =
  }

var
  IsNT,IS95,Is98,Is2000,IsOSR2: Boolean;
  WindowsUser, MachineName: string;
  Platform: TPlatformType;

implementation

type
  TLoadLibrary16 = function (LibraryName: PChar): THandle; stdcall;
  TFreeLibrary16 = procedure (HInstance: THandle); stdcall;
  TGetProcAddress16 = function (Hinstance: THandle; ProcName: PChar): Pointer; stdcall;
  TQT_Thunk = procedure; cdecl;

var
  VLevel, VFamily, VModel, VStepping, VTyp :Byte;
  VFeatures :LongInt;

  _LoadLibrary16 :TLoadLibrary16;
  _FreeLibrary16 :TFreeLibrary16;
  _GetProcAddress16 :TGetProcAddress16;
  _QT_Thunk :TQT_Thunk;
  hInst16: THandle;
  SR: Pointer;
  HKernel :Thandle;
  idxLoadLibrary16,
  idxFreeLibrary16,
  idxGetProcAddress16 :dword;

procedure LoadKernel16;
begin
  HKernel:=GetModuleHandle('kernel32.dll');
  idxLoadLibrary16:=35;
  idxFreeLibrary16:=36;
  idxGetProcAddress16:=37;
  if HKernel<>0 then begin
    @_LoadLibrary16:=getprocaddress(HKernel,@idxLoadLibrary16);
    @_FreeLibrary16:=getprocaddress(HKernel,@idxFreeLibrary16);
    @_GetProcAddress16:=getprocaddress(HKernel,@idxGetProcAddress16);
    @_QT_Thunk:=getprocaddress(HKernel,pchar('QT_Thunk'));
  end;
end;

procedure FreeLibrary16(HInstance: THandle);
begin
  if assigned(_FreeLibrary16) then
    _FreeLibrary16(HInstance);
end;


function GetProcAddress16(HInstance: THandle;
  ProcName: PChar): Pointer;
begin
  if assigned(_GetProcAddress16) then
    result:=_GetProcAddress16(HInstance,ProcName)
  else
    result:=nil;
end;

function LoadLibrary16(LibraryName: PChar): THandle;
begin
  if assigned(_LoadLibrary16) then
    result:=_LoadLibrary16(LibraryName)
  else
    result:=0;
end;

procedure QT_Thunk;
begin
  if assigned(_QT_Thunk) then
    _QT_Thunk;
end;

function GetFreeSysRes(SysRes: Word): Word;
var
  Thunks: Array[0..$20] of Word;
begin
  result:=0;
  if HKernel=0 then
    LoadKernel16;
  Thunks[0]:=hInst16;
  hInst16:=LoadLibrary16('user.exe');
  if hInst16>32 then begin
    FreeLibrary16(hInst16);
    SR:=GetProcAddress16(hInst16,'GetFreeSystemResources');
    if assigned(SR) then
      asm
        push SysRes       // push arguments
        mov edx, SR       // load 16-bit procedure pointer
        call QT_Thunk     // call thunk
        mov Result, ax    // save the result
      end
    else
      //raise Exception.Create('Can''t get address of GetFreeSystemResources!');
  end else
    //raise Exception.Create('Can''t load USER.EXE!');
end;

procedure GetEnvironment(EnvList :tstringlist);
var
  c,i :dword;
  b :pchar;
  s :string;
begin
  EnvList.Clear;
  c:=1024;
  b:=GetEnvironmentStrings;
  i:=0;
  s:='';
  while i<c do begin
    if b[i]<>#0 then
      s:=s+b[i]
    else begin
      if s='' then
        break;
      EnvList.Add(s);
      s:='';
    end;
    inc(i);
  end;
  FreeEnvironmentStrings(b);
end;

function GetWinSysDir: string;
var
  n: integer;
  p: PChar;
begin
  n:=MAX_PATH;
  p:=stralloc(n);
  getwindowsdirectory(p,n);
  result:=strpas(p)+';';
  getsystemdirectory(p,n);
  Result:=Result+strpas(p)+';';
end;

procedure Register;
begin
//  RegisterComponents('MiTeC',[TMSystemInfo]);
end;

function GetCPUIDFlags: DWORD; assembler; register;
asm
	PUSH    EBX	   	//Save registers
	PUSH    EDI
	MOV     EAX,1 	        //Set up for CPUID
	DW      $A20F 	        //CPUID OpCode
	MOV @Result,EDX	        //Put the flag array into a DWord
	POP     EDI	       	//Restore registers
	POP     EBX
end;

function GetTimeStampHi: DWORD; assembler; register;
asm
        DW      $310F        //RDTSC Command
        MOV @Result, EDX;
end;

function GetTimeStampLo: DWORD; assembler; register;
asm
	DW      $310F       //RDTSC Command
	MOV @Result, EAX;
end;

function GetTimeStamp :TLargInt;
begin
  result.QuadPart:=0;
  if (GetCPUIDFlags and 16) <> 16 then
    exit;
  result.HighPart:=DWORD(GetTimeStampHi);
  result.LowPart:=GetTimeStampLo;
end;

function GetTicksPerSecond(Iterations :Word) :Comp;
var
  Freq ,PerfCount,Target :int64;
  StartTime, EndTime, Elapsed :TLargInt;

  procedure StartTimer;
  begin
    StartTime:=GetTimeStamp;
    EndTime.QuadPart:=0;
    Elapsed.QuadPart:=0;
  end;

  procedure StopTimer;
  begin
    EndTime:=GetTimeStamp;
    Elapsed.QuadPart:=(EndTime.QuadPart-StartTime.QuadPart);
  end;

begin
  Result:=0;
  if not QueryPerformanceFrequency(Freq) then
    exit;
  QueryPerformanceCounter(PerfCount);
  {$IFDEF D4PLUS}
  Target:=PerfCount+(Freq*Iterations);
  {$ELSE}
  Target.QuadPart:=PerfCount.QuadPart+(Freq.QuadPart*Iterations);
  {$ENDIF}
  StartTimer;
  repeat
    QueryPerformanceCounter(PerfCount);
  {$IFDEF D4PLUS}
  until (PerfCount>=Target);
  {$ELSE}
  until (PerfCount.QuadPart>=Target.QuadPart);
  {$ENDIF}
  StopTimer;
  Result:=(Elapsed.QuadPart/Iterations);
end;

function GetStrFromBuf(Buffer :pchar) :string;
var
  i,j :integer;
begin
  result:='';
  j:=0;
  i:=0;
  repeat
    if buffer[i]<>#0 then begin
      result:=result+buffer[i];
      j:=0;
    end else
      inc(j);
    inc(i);
  until j>1;
end;

function GetKey(StartKey, Value, Data :string) :string;
var
  vn,kn :tstringlist;
  regbase :tregistry;

  procedure EnumKeys(aregbase :tregistry; aroot: string; akn :tstringlist);
  var
    kn :tstringlist;
    i :integer;
  begin
    for i:=0 to akn.count-1 do
      with aregbase do begin
        closekey;
        if openkey(aroot+'\'+akn[i],false) then begin
          getvaluenames(vn);
          if vn.indexof(value)>-1 then begin
            if readstring(value)=data then begin
              result:=aroot+'\'+akn[i];
              break;
            end;
          end else
            if hassubkeys then begin
              kn:=tstringlist.create;
              getkeynames(kn);
              enumkeys(aregbase,aroot+'\'+akn[i],kn);
              if result<>'' then
                break;
              kn.free;
            end;
        end;
      end;
  end;

begin
  result:='';
  regbase:=tregistry.create;
  with regbase do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    vn:=tstringlist.create;
    kn:=tstringlist.create;
    if openkey(startkey,false) then begin
      getkeynames(kn);
      enumkeys(regbase,startkey,kn);
      closekey;
    end;
    vn.free;
    kn.free;
    free;
  end;
end;

function GetWindowInfo(wh: hwnd): PWindow;
var
  cn,wn :pchar;
  n, wpid,tid :longword;
begin
  n:=255;
  wn:=stralloc(n);
  cn:=stralloc(n);
  tid:=GetWindowThreadProcessId(wh,@wpid);
  getclassname(wh,cn,n);
  getwindowtext(wh,wn,n);
  new(result);
  result^.ClassName:=strpas(cn);
  result^.Text:=strpas(wn);
  result^.Handle:=wh;
  result^.Process:=wpid;
  result^.Thread:=tid;
  result^.ParentWin:=getwindowlong(wh,GWL_HWNDPARENT);
  result^.WndProc:=getwindowlong(wh,GWL_WNDPROC);
  result^.Instance:=getwindowlong(wh,GWL_HINSTANCE);
  result^.ID:=getwindowlong(wh,GWL_ID);
  result^.UserData:=getwindowlong(wh,GWL_USERDATA);
  result^.Style:=getwindowlong(wh,GWL_STYLE);
  result^.ExStyle:=getwindowlong(wh,GWL_EXSTYLE);
  getwindowrect(wh,result^.Rect);
  getclientrect(wh,result^.ClientRect);
  result^.Atom:=getclasslong(wh,GCW_ATOM);
  result^.ClassBytes:=getclasslong(wh,GCL_CBCLSEXTRA);
  result^.WinBytes:=getclasslong(wh,GCL_CBWNDEXTRA);
  result^.ClassWndProc:=getclasslong(wh,GCL_WNDPROC);
  result^.ClassInstance:=getclasslong(wh,GCL_HMODULE);
  result^.Background:=getclasslong(wh,GCL_HBRBACKGROUND);
  result^.Cursor:=getclasslong(wh,GCL_HCURSOR);
  result^.Icon:=getclasslong(wh,GCL_HICON);
  result^.ClassStyle:=getclasslong(wh,GCL_STYLE);
  result^.Styles:=tstringlist.create;
  result^.visible:=iswindowvisible(wh);
  if not(result^.ExStyle and WS_BORDER=0) then
    result^.Styles.add('WS_BORDER');
  if not(result^.Style and WS_CHILD=0) then
    result^.Styles.add('WS_CHILD');
  if not(result^.Style and WS_CLIPCHILDREN=0) then
    result^.Styles.add('WS_CLIPCHILDREN');
  if not(result^.Style and WS_CLIPSIBLINGS=0) then
    result^.Styles.add('WS_CLIPSIBLINGS');
  if not(result^.Style and WS_DISABLED=0) then
    result^.Styles.add('WS_DISABLED');
  if not(result^.Style and WS_DLGFRAME=0) then
    result^.Styles.add('WS_DLGFRAME');
  if not(result^.Style and WS_GROUP=0) then
    result^.Styles.add('WS_GROUP');
  if not(result^.Style and WS_HSCROLL=0) then
    result^.Styles.add('WS_HSCROLL');
  if not(result^.Style and WS_MAXIMIZE=0) then
    result^.Styles.add('WS_MAXIMIZE');
  if not(result^.Style and WS_MAXIMIZEBOX=0) then
    result^.Styles.add('WS_MAXIMIZEBOX');
  if not(result^.Style and WS_MINIMIZE=0) then
    result^.Styles.add('WS_MINIMIZE');
  if not(result^.Style and WS_MINIMIZEBOX=0) then
    result^.Styles.add('WS_MINIMIZEBOX');
  if not(result^.Style and WS_OVERLAPPED=0) then
    result^.Styles.add('WS_OVERLAPPED');
  if not(result^.Style and WS_POPUP=0) then
    result^.Styles.add('WS_POPUP');
  if not(result^.Style and WS_SYSMENU=0) then
    result^.Styles.add('WS_SYSMENU');
  if not(result^.Style and WS_TABSTOP=0) then
    result^.Styles.add('WS_TABSTOP');
  if not(result^.Style and WS_THICKFRAME=0) then
    result^.Styles.add('WS_THICKFRAME');
  if not(result^.Style and WS_VISIBLE=0) then
    result^.Styles.add('WS_VISIBLE');
  if not(result^.Style and WS_VSCROLL=0) then
    result^.Styles.add('WS_VSCROLL');
  result^.ExStyles:=tstringlist.create;
  if not(result^.ExStyle and WS_EX_ACCEPTFILES=0) then
    result^.ExStyles.add('WS_EX_ACCEPTFILES');
  if not(result^.ExStyle and WS_EX_DLGMODALFRAME=0) then
    result^.ExStyles.add('WS_EX_DLGMODALFRAME');
  if not(result^.ExStyle and WS_EX_NOPARENTNOTIFY=0) then
    result^.ExStyles.add('WS_EX_NOPARENTNOTIFY');
  if not(result^.ExStyle and WS_EX_TOPMOST=0) then
    result^.ExStyles.add('WS_EX_TOPMOST');
  if not(result^.ExStyle and WS_EX_TRANSPARENT=0) then
    result^.ExStyles.add('WS_EX_TRANSPARENT');
  if not(result^.ExStyle and WS_EX_MDICHILD=0) then
    result^.ExStyles.add('WS_EX_MDICHILD');
  if not(result^.ExStyle and WS_EX_TOOLWINDOW=0) then
    result^.ExStyles.add('WS_EX_TOOLWINDOW');
  if not(result^.ExStyle and WS_EX_WINDOWEDGE=0) then
    result^.ExStyles.add('WS_EX_WINDOWEDGE');
  if not(result^.ExStyle and WS_EX_CLIENTEDGE =0) then
    result^.ExStyles.add('WS_EX_CLIENTEDGE');
  if not(result^.ExStyle and WS_EX_CONTEXTHELP=0) then
    result^.ExStyles.add('WS_EX_CONTEXTHELP');
  if not(result^.ExStyle and WS_EX_RIGHT=0) then
    result^.ExStyles.add('WS_EX_RIGHT')
  else
    result^.ExStyles.add('WS_EX_LEFT');
  if not(result^.ExStyle and WS_EX_RTLREADING=0) then
    result^.ExStyles.add('WS_EX_RTLREADING')
  else
    result^.ExStyles.add('WS_EX_LTRREADING');
  if not(result^.ExStyle and WS_EX_LEFTSCROLLBAR=0) then
    result^.ExStyles.add('WS_EX_LEFTSCROLLBAR')
  else
    result^.ExStyles.add('WS_EX_RIGHTSCROLLBAR');
  if not(result^.ExStyle and WS_EX_CONTROLPARENT=0) then
    result^.ExStyles.add('WS_EX_CONTROLPARENT');
  if not(result^.ExStyle and WS_EX_STATICEDGE =0) then
    result^.ExStyles.add('WS_EX_STATICEDGE');
  if not(result^.ExStyle and WS_EX_APPWINDOW=0) then
    result^.ExStyles.add('WS_EX_APPWINDOW');
  result^.ClassStyles:=tstringlist.create;
  if not(result^.ClassStyle and CS_BYTEALIGNCLIENT=0) then
    result^.ClassStyles.add('CS_BYTEALIGNCLIENT');
  if not(result^.ClassStyle and CS_VREDRAW=0) then
    result^.ClassStyles.add('CS_VREDRAW');
  if not(result^.ClassStyle and CS_HREDRAW=0) then
    result^.ClassStyles.add('CS_HREDRAW');
  if not(result^.ClassStyle and CS_KEYCVTWINDOW=0) then
    result^.ClassStyles.add('CS_KEYCVTWINDOW');
  if not(result^.ClassStyle and CS_DBLCLKS=0) then
    result^.ClassStyles.add('CS_DBLCLKS');
  if not(result^.ClassStyle and CS_OWNDC=0) then
    result^.ClassStyles.add('CS_OWNDC');
  if not(result^.ClassStyle and CS_CLASSDC=0) then
    result^.ClassStyles.add('CS_CLASSDC');
  if not(result^.ClassStyle and CS_PARENTDC=0) then
    result^.ClassStyles.add('CS_PARENTDC');
  if not(result^.ClassStyle and CS_NOKEYCVT=0) then
    result^.ClassStyles.add('CS_NOKEYCVT');
  if not(result^.ClassStyle and CS_NOCLOSE=0) then
    result^.ClassStyles.add('CS_NOCLOSE');
  if not(result^.ClassStyle and CS_SAVEBITS=0) then
    result^.ClassStyles.add('CS_SAVEBITS');
  if not(result^.ClassStyle and CS_BYTEALIGNWINDOW=0) then
    result^.ClassStyles.add('CS_BYTEALIGNWINDOW');
  if not(result^.ClassStyle and CS_GLOBALCLASS=0) then
    result^.ClassStyles.add('CS_GLOBALCLASS');
  strdispose(wn);
  strdispose(cn);
end;

function Bool2YN(b :boolean) :string;
begin
  if b then
    result:='Yes'
  else
    result:='No';
end;

function GetClassDevice(AClass, AProp :string) :string;
var
  i,j :integer;
  sl :tstringlist;
  s,rk,rvclass,rclass :string;
const
  rv = 'DriverDesc';
begin
  result:='';
  if isNT then begin
    rk:='System\CurrentControlSet\Control\Class';
    rvclass:='Class';
  end else begin
    rk:='System\CurrentControlSet\Services\Class';
    rvclass:='';
  end;
  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if openkey(rk,false) then begin
      sl:=tstringlist.create;
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if openkey(rk+'\'+sl[i],false) then begin
          if valueexists(rvclass) then begin
            rclass:=readstring(rvclass);
            if rclass=aclass then begin
              s:=sl[i];
              getkeynames(sl);
              closekey;
              for j:=0 to sl.count-1 do
                if openkey(rk+'\'+s+'\'+sl[j],false) then begin
                  if (aprop='') or valueexists(aprop) then
                    result:=rk+'\'+s+'\'+sl[j];
                  closekey;
                end;
                break;
            end;
            closekey;
          end;
        end;
      sl.free;
    end;
    free;
  end;
end;

function GetClassDevices(AClass :string; var AResult :TStrings) :string;
var
  i,j :integer;
  sl :tstringlist;
  rk,s,rvclass,rclass :string;
const
  rv = 'DriverDesc';
begin
  result:='';
  aresult.clear;
  if isNT then begin
    rk:='System\CurrentControlSet\Control\Class';
    rvclass:='Class';
  end else begin
    rk:='System\CurrentControlSet\Services\Class';
    rvclass:='';
  end;
  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if openkey(rk,false) then begin
      sl:=tstringlist.create;
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if openkey(rk+'\'+sl[i],false) then begin
          if valueexists(rvclass) then begin
            rclass:=readstring(rvclass);
            if rclass=aclass then begin
              s:=sl[i];
              result:=rk+'\'+s;
              getkeynames(sl);
              closekey;
              for j:=0 to sl.count-1 do
                if openkey(rk+'\'+s+'\'+sl[j],false) then begin
                  if valueexists(rv) then
                    Aresult.Add(readstring(rv));
                  closekey;
                end;
                break;
            end;
            closekey;
          end;
        end;
      sl.free;
    end;
    free;
  end;
end;

function IsOSNT :boolean;
var
  OS :TOSVersionInfo;
begin
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  GetVersionEx(OS);
  result:=OS.dwPlatformId=VER_PLATFORM_WIN32_NT;
end;

function IsOS95 :boolean;
var
  OS :TOSVersionInfo;
begin
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  GetVersionEx(OS);
  result:=(OS.dwMajorVersion>=4) and (OS.dwMinorVersion=0) and (OS.dwPlatformId=VER_PLATFORM_WIN32_WINDOWS);
end;

function IsOS98 :boolean;
var
  OS :TOSVersionInfo;
begin
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  GetVersionEx(OS);
  result:=(OS.dwMajorVersion>=4) and (OS.dwMinorVersion>0) and (OS.dwPlatformId=VER_PLATFORM_WIN32_WINDOWS);
end;

function IsOSOSR2 :boolean;
var
  OS :TOSVersionInfo;
begin
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  GetVersionEx(OS);
  result:=(OS.dwMajorVersion>=4) and (OS.dwMinorVersion=0) and (lo(OS.dwBuildNumber)>1000) and (OS.dwPlatformId=VER_PLATFORM_WIN32_WINDOWS);
end;

function IsOS2000 :boolean;
var
  OS :TOSVersionInfo;
begin
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  GetVersionEx(OS);
  result:=(OS.dwMajorVersion>=5) and (OS.dwPlatformId=VER_PLATFORM_WIN32_NT);
end;

function GetPlatform: TPlatformType;
begin
  Result:=os9x;
  if isNT then begin
    if is2000 then
      Result:=os2K
    else
      Result:=osNT4;
  end;
end;

function FormatSeconds(TotalSeconds :comp; WholeSecondsOnly, DisplayAll, DTFormat :Boolean) :String;
var
 lcenturies,lyears,lmonths,lminutes,lhours,ldays,lweeks :word;
 lSecs :double;
 s :array[1..8] of string;
 SecondsPerCentury :comp;
 FS :string;
begin
  if WholeSecondsOnly then
    FS:='%.0f'
  else
    FS:='%.2f';
  SecondsPerCentury:=36550 * 24;
  SecondsPerCentury:= SecondsPerCentury * 3600;
  lcenturies:=Trunc(TotalSeconds / SecondsPerCentury);
  TotalSeconds:=TotalSeconds-(lcenturies * SecondsPerCentury);
  lyears:=Trunc(TotalSeconds / (365.5 * 24 * 3600));
  TotalSeconds:=TotalSeconds-(lyears * (365.5 * 24 * 3600));
  lmonths:=Trunc(TotalSeconds / (31 * 24 * 3600));
  TotalSeconds:=TotalSeconds-(lmonths * (31 * 24 * 3600));
  lweeks:=Trunc(TotalSeconds / (7 * 24 * 3600));
  TotalSeconds:=TotalSeconds-(lweeks * (7 * 24 * 3600));
  ldays:=Trunc(TotalSeconds / (24 * 3600));
  TotalSeconds:=TotalSeconds-(ldays * (24 * 3600));
  lhours:=Trunc(TotalSeconds / 3600);
  TotalSeconds:=TotalSeconds-(lhours * 3600);
  lminutes:=Trunc(TotalSeconds / 60);
  TotalSeconds:=TotalSeconds-(lminutes * 60);
  If WholeSecondsOnly then
    lsecs:=Trunc(TotalSeconds)
  else
    lsecs:=TotalSeconds;
  if lCenturies=1 then
    s[1]:=' Century, '
  else
    s[1]:=' Centuries, ';
  if lyears=1 then
    s[2]:=' Year, '
  else
    s[2]:=' Years, ';
  if lmonths=1 then
    s[3]:=' Month, '
  else
    s[3]:=' Months, ';
  if lweeks=1 then
    s[4]:=' Week, '
  else
    s[4]:=' Weeks, ';
  if ldays=1 then
    s[5]:=' Day, '
  else
    s[5]:=' Days, ';
  if lhours=1 then
    s[6]:=' Hour, '
  else
    s[6]:=' Hours, ';
  if lminutes=1 then
    s[7]:=' Minute, '
  else
    s[7]:=' Minutes, ';
  if lsecs=1 then
    s[8]:=' Second.'
  else
    s[8]:=' Seconds.';
  If DisplayAll then begin
    if dtformat then
      result:=Format('%2.2d.%2.2d.%2.2d %2.2d:%2.2d:%2.2d',
                     [lyears,lmonths,ldays+lweeks*7,lhours,lminutes,round(lSecs)])
    else
      Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                     [lcenturies,s[1],lyears,s[2],lmonths,s[3],lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lSecs,s[8]]);

  end else begin
    if dtformat then
      result:=Format('%2.2d:%2.2d:%2.2d',
                     [lhours,lminutes,round(lSecs)])
    else begin
      if lCenturies>=1 then
        Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                        [lcenturies,s[1],lyears,s[2],lmonths,s[3],lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
      else
        if lyears>=1 then
          Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                          [lyears,s[2],lmonths,s[3],lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
      else
       if lmonths>=1 then
         Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                         [lmonths,s[3],lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
       else
         if lweeks>=1 then
           Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',
                           [lweeks,s[4],ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
         else
           if ldays>=1 then
             Result:= Format('%.0d%s%.0d%s%.0d%s' + FS + '%s',
                             [ldays,s[5],lhours,s[6],lminutes,s[7],lsecs,s[8]])
           else
             if lhours>=1 then
               Result:= Format('%.0d%s%.0d%s' + FS + '%s',
                               [lhours,s[6],lminutes,s[7],lsecs,s[8]])
             else
               if lminutes>=1 then
                 Result:= Format('%.0d%s' + FS + '%s',[lminutes,s[7],lsecs,s[8]])
               else
                 Result:= Format(FS + '%s',[lsecs,s[8]]);
    end;
  end;
end;

function ReadRegInfo(ARoot :hkey; AKey, AValue :string) :string;
begin
  with tregistry.create do begin
    result:='';
    rootkey:=aroot;
    if keyexists(akey) then begin
      openkey(akey,false);
      if valueexists(avalue) then begin
        case getdatatype(avalue) of
          rdstring: result:=readstring(avalue);
          rdinteger: result:=inttostr(readinteger(avalue));
        end;
      end;
      closekey;
    end;
    free;
  end;
end;

function ReadVerInfo(const fn :string; var Desc :string) :string;
var
  VersionHandle,VersionSize :dword;
  PItem,PVersionInfo :pointer;
  FixedFileInfo :PVSFixedFileInfo;
  il :uint;
  version :string;
  p :array [0..MAX_PATH - 1] of char;
begin
  version:='';
  desc:='';
  result:='';
  if fn<>'' then begin
    strpcopy(p,fn);
    versionsize:=getfileversioninfosize(p,versionhandle);
    if versionsize=0 then
      exit;
    getMem(pversioninfo,versionsize);
    try
      if getfileversioninfo(p,versionhandle,versionsize,pversioninfo) then begin
        if verqueryvalue(pversioninfo,'\',pointer(fixedfileinfo),il) then
          version:=inttostr(hiword(fixedfileinfo^.dwfileversionms))+
                   '.'+inttostr(loword(fixedfileinfo^.dwfileversionms))+
                   '.'+inttostr(hiword(fixedfileinfo^.dwfileversionls))+
                   '.'+inttostr(loword(fixedfileinfo^.dwfileversionls));
          if verqueryvalue(pversioninfo,pchar('\StringFileInfo\040904E4\FileDescription'),pitem,il) then
            desc:=pchar(pitem);
      end;
    finally
      freeMem(pversioninfo,versionsize);
      result:=version;
    end;
  end;
end;

function GetMachine :string;
var
  n :dword;
  buf :pchar;
const
  rkMachine = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName';
    rvMachine = 'ComputerName';
begin
  n:=255;
  buf:=stralloc(n);
  GetComputerName(buf,n);
  result:=strpas(buf);
  strdispose(buf);
  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if openkey(rkMachine,false) then begin
      if valueexists(rvMachine) then
        result:=readstring(rvMachine);
      closekey;
    end;
    free;
  end;
end;

function GetUser :string;
var
  n :dword;
  buf :pchar;
begin
  n:=255;
  buf:=stralloc(n);
  GetUserName(buf,n);
  result:=strpas(buf);
  strdispose(buf);
end;

{ TCPUFeatures }

procedure TCPUFeatures.GetFeaturesStr(AClear :boolean; AFeatures :TStringList);
begin
  if AClear then
    AFeatures.clear;
  AFeatures.Add('FXSAVE/FXRSTOR instruction: '+bool2yn(FXInstr));
  AFeatures.Add('MMX extension: '+bool2yn(MMX));
  AFeatures.Add('36bit Page Size Extension: '+bool2yn(PageSizeExt36bit));
  AFeatures.Add('Page Attribute Table: '+bool2yn(PageAttrTable));
  AFeatures.Add('CMOVcc (+FCMOVcc/F(U)COMI(P) opcodes: '+bool2yn(CMOVccOpcode));
  AFeatures.Add('Machine Check Architecture: '+bool2yn(MachineCheck));
  AFeatures.Add('Page Global Extension: '+bool2yn(PageGloablExt));
  AFeatures.Add('Memory Type Range Registers: '+bool2yn(MTRR));
  AFeatures.Add('SYSENTER/SYSEXIT extension: '+bool2yn(SYSENTERExt));
  AFeatures.Add('Processor contains an enabled APIC: '+bool2yn(APIC));
  AFeatures.Add('CMPXCHG8B instruction: '+bool2yn(CMPXCHG8B));
  AFeatures.Add('Machine Check Exception: '+bool2yn(MachineChkExc));
  AFeatures.Add('Physical Address Extension: '+bool2yn(PhysAddrExt));
  AFeatures.Add('Model Specific Registers: '+bool2yn(ModSpecReg));
  AFeatures.Add('Time Stamp Counter: '+bool2yn(TimeStampCnt));
  AFeatures.Add('Page Size Extension: '+bool2yn(PageSizeExt));
  AFeatures.Add('Debugging Extension: '+bool2yn(DebugExt));
  AFeatures.Add('Virtual Mode Extension: '+bool2yn(VirtModExt));
  AFeatures.Add('Built-In FPU: '+bool2yn(FPU));
end;

{ TCPU }

constructor TCPU.Create;
begin
  inherited;
  FFeatures:=TCPUFeatures.Create;
end;

destructor TCPU.Destroy;
begin
  FFeatures.Free;
  inherited;
end;

function TCPU.CPUIDExists: boolean; register;
asm
	PUSHFD			 //direct access to flags no possible, only via stack
	POP     EAX		 //flags to EAX
	MOV     EDX,EAX		 //save current flags
	XOR     EAX,ID_BIT	 //not ID bit
	PUSH    EAX		 //onto stack
	POPFD			 //from stack to flags, with not ID bit
	PUSHFD			 //back to stack
	POP     EAX		 //get back to EAX
	XOR     EAX,EDX		 //check if ID bit affected
	JZ      @exit		 //no, CPUID not availavle
	MOV     AL,True		 //Result=True
@exit:
end;

procedure TCPU.GetCPUID; assembler;
asm
	PUSH    EAX               //Save reg.
	PUSH    EBX
	PUSH    EDX
	PUSH    ECX
	MOV     EAX,1
	DW      $A20F             //CPUID Command Execute
	PUSH    eax
	MOV     VStepping,al      //Store Stepping
	AND     VStepping,0fh     //Stepping mask
	AND     al,0f0h           //Model mask
	SHR     al,4              //Model shift
	MOV     VModel,al         //Store Model
	AND     ax,0f00h          //Family mask
	SHR     ax,8              //Family shift
	MOV     VFamily,al        //Store Family
	AND     al,0f0h;          //Type mask
	SHR     al,4              //type shift
	MOV     VTyp,al           //Store Type
	POP     eax
	MOV     VFeatures,edx     //Store features
	POP     ECX
	POP     EDX
	POP     EBX
	POP     EAX               //Restore Reg.
end;

function TCPU.GetCPUIDLevel: integer;
begin
  VLevel:=0;
  asm
	MOV eax, 0	//  Get Level
	DB 0Fh,0a2h     //  CPUID opcode
	MOV VLevel,al
	//RET
  end;
  result:=VLevel;
End;

function TCPU.GetCPUType: integer; assembler
asm
	PUSH ebx
	PUSH ecx
	PUSH edx

	MOV ebx,esp
	AND esp,0FFFFFFFCh  //align down to nearest dword
	PUSHFD              //save original flags

// i386 CPU check
// The AC bit, bit #18, is a new bit introduced in the EFLAGS
// register on the i486 DX CPU to generate alignment faults.
// This bit can not be set on the i386 CPU.

	PUSHFD
	POP eax
	MOV ecx,eax
	XOR eax,40000h   	//toggle AC bit
	PUSH eax
	POPFD
	PUSHFD
	POP eax
	XOR eax,ecx
	MOV eax,3          //assume 80386
	JE @@end_CPUTyp   //it's a 386

// i486 DX CPU / i487 SX MCP and i486 SX CPU checking
// Checking for ability to set/clear ID flag (Bit 21) in EFLAGS
// which indicates the presence of a processor
// with the ability to use the CPUID instruction.

	PUSHFD
	POP eax
	MOV ecx,eax
	XOR eax,200000h   //toggle ID bit
	PUSH eax
	POPFD
	PUSHFD
	POP eax
	XOR eax, ecx
	MOV eax,4
	JE @@end_CPUTyp   //it's a 486 w/o support for CPUID

// Execute CPUID instruction to determine vendor, family,
// model and stepping.  The use of the CPUID instruction used
// in this program can be used for B0 and later steppings
// of the P5 processor.

	PUSH ebx        // CPUID modifies EBX  !!!
	MOV eax, 1     	// Level
	DB 0Fh,0a2h     // CPUID opcode
	MOV al,ah
	AND eax, 0FH
	POP ebx

@@end_CPUTyp:
	POPFD            // restore original flags
	MOV esp,ebx      // restore original ESP
	POP edx
	POP ecx
	POP ebx
end;

function TCPU.GetCPUVendor :string;
var
  i :integer;
  s :TStrBuf;

  function _GetCPUVendor :TStrBuf; assembler; register;
  asm
  	PUSH    ebx	       	//Save regs
	PUSH    edi
	MOV     edi,eax		//@Result (TStrBuf)
	MOV     eax,0
	DW      $A20F		//CPUID Command
	MOV     eax,ebx
	XCHG	ebx,ecx         //save ECX result
	MOV	ecx,4
  @1:
	STOSB            	//save first 4 byte
	SHR     eax,8
	LOOP    @1
	MOV     eax,edx
	MOV	ecx,4
  @2:
	STOSB            	//save middle 4 byte
	SHR     eax,8
	LOOP    @2
	MOV     eax,ebx
	MOV	ecx,4
  @3:            			//save last 4 byte
	STOSB
	SHR     eax,8
	LOOP    @3
	POP     edi		//Restore regs
	POP     ebx
  end;

begin
  i:=0;
  result:='';
  s:=_GetCPUVendor;
  repeat
    result:=result+s[i];
    inc(i);
  until i>11;
  FVendorNo:=-1;
  for i:=0 to high(CPUVendorIDs) do
    if result=CPUVendorIDs[i] then begin
      result:=CPUVendors[i];
      FVendorNo:=i;
      break;
    end;
end;

function TCPU.GetCPUVendorID :string;
begin
  case Family of
     4 :case FVendorNo Of
          0 :case Model of
               0 :result:='i80486DX-25/33';
               1 :result:='i80486DX-50';
               2 :result:='i80486SX';
               3 :result:='i80486DX2';
               4 :result:='i80486SL';
               5 :result:='i80486SX2';
               7 :result:='i80486DX2WB';
               8 :result:='i80486DX4';
	              9 :result:='i80486DX4WB';
             end;
          1 :case Model of
               1 :result:='U5D(486DX)';
	              2 :result:='U5S(486SX)';
             end;
          2 :case Model of
               3 :result:='80486DX2WT';
               7 :result:='80486DX2WB';
               8 :result:='80486DX4';
               9 :result:='80486DX4WB';
              14 :result:='5x86';
              15 :result:='5x86WB';
             end;
          3 :case Model of
               4 :result:='Cyrix Media GX';
               9 :result:='Cyrix 5x86';
             end;
        end;
     5 :case FVendorNo of
          0 :case Model of
               0 :result:='P5 A-step';
               1 :result:='P5';
               2 :result:='P54C';
               3 :result:='P24T OverDrive';
               4 :result:='P55C';
               5 :result:='DX4 OverDrive?';
               6 :result:='P5 OverDrive?';
	              7 :result:='P54C';
               8 :result:='P55C(0,25µm)MMX';
             end;
          2 :case Model of
	              0 :result:='SSA5';
               1 :result:='5k86';
               2 :result:='5k86';
               3 :result:='5k86';
               6 :result:='K6';
               7 :result:='K6';
               8 :result:='K6-3D';
	              9 :result:='K6PLUS-3D';
             end;
          3 :case Model of
               0 :result:='Pentium Cx6X86 GXm';
               2 :result:='Std. Cx6x86';
               4 :result:='Cx6x86 GXm';
             end;
          else
             if FVendorNo=4 then
               result:='Nx586';
             if FVendorNo=5 then
               result:='IDT C6 (WinChip)';
	end;
     6 :case FVendorNo of
          0 :case Model of
               0 :result:='PentiumPro A-step';
               1 :result:='Pentium Pro';
               3 :result:='Pentium II';
               4 :result:='P55CT (P54 overdrive)';
               5 :result:='Pentium II 0,25µm';
             end;
	  2 :case Model of
               6 :result:='K6';
               7 :result:='K6';
               8 :result:='K6-3D';
       	       9 :result:='K6PLUS-3D';
             end;
          3 :if Model=0 then
               result:='Cx6x86 MX/MII';
        end;
  end;
end;

function TCPU.GetCPUFreqEx: extended;
var
  c :comp;
begin
  c:=GetTicksPerSecond(1);
  Result:=c/1E6;
end;

function TCPU.GetSubModel :string;
begin
  case VTyp of
    3 :result:='Reserved';
    2 :result:='Secondary';
    1 :result:='OverDrive';
    0 :result:='Primary';
    else
      result:='Not Detected!';
  end;
end;

procedure TCPU.GetInfo;
var
  SI :TSystemInfo;
begin
  ZeroMemory(@SI,SizeOf(SI));
  GetSystemInfo(SI);
  Count:=SI.dwNumberOfProcessors;
  Family:=SI.dwProcessorType;
//  Vendor:=
//  VendorID:=
  CPUID:=CPUIDExists;
  if CPUID then begin
    Level:=GetCPUIDLevel;
    Freq:=Round(GetCPUFreqEx);
    Typ:=GetCPUType;
    GetCPUID;
    Typ:=VTyp;
    Family:=VFamily;
    Model:=VModel;
    Stepping:=VStepping;
    Vendor:=GetCPUVendor;
    VendorID:=GetCPUVendorID;
    SubModel:=GetSubModel;
    Features.FXInstr:=(VFeatures and $1000000)=$1000000;
    Features.MMX:=(VFeatures and $800000)=$800000;
    Features.PageSizeExt36bit:=(VFeatures and $20000)=$20000;
    Features.PageAttrTable:=(VFeatures and $10000)=$10000;
    Features.CMOVccOpcode:=(VFeatures and $8000)=$8000;
    Features.MachineCheck:=(VFeatures and $4000)=$4000;
    Features.PageGloablExt:=(VFeatures and $2000)=$2000;
    Features.MTRR:=(VFeatures and $1000)=$1000;
    Features.SYSENTERExt:=(VFeatures and $800)=$800;
    Features.APIC:=(VFeatures and $200)=$200;
    Features.CMPXCHG8B:=(VFeatures and $100)=$100;
    Features.MachineChkExc:=(VFeatures and $80)=$80;
    Features.PhysAddrExt:=(VFeatures and $40)=$40;
    Features.ModSpecReg:=(VFeatures and $20)=$20;
    Features.TimeStampCnt:=(VFeatures and $10)=$10;
    Features.PageSizeExt:=(VFeatures and 8)=8;
    Features.DebugExt:=(VFeatures and 4)=4;
    Features.VirtModExt:=(VFeatures and 2)=2;
    Features.FPU:=(VFeatures and 1)=1;
  end;
end;

procedure TCPU.Report(var sl: TStringList);
begin
  with sl do begin
    add(format('CPU: %d x %s %s - %d MHz',[self.Count,Vendor,VendorID,Freq]));
    add(format('Submodel: %s',[Submodel]));
    add(format('Model ID: Family %d  Model %d  Stepping %d  Level %d',[Family,Model,Stepping,Level]));
    add('');
    add('CPU Features:');
    Features.GetFeaturesStr(false,sl);
  end;
end;

{ TMemory }

procedure TMemory.GetInfo;
var
  SI :TSystemInfo;
  MS :TMemoryStatus;
begin
  ZeroMemory(@MS,SizeOf(MS));
  MS.dwLength:=SizeOf(MS);
  GlobalMemoryStatus(MS);
  MemoryLoad:=MS.dwMemoryLoad;
  PhysicalTotal:=MS.dwTotalPhys;
  PhysicalFree:=MS.dwAvailPhys;
  VirtualTotal:=MS.dwTotalVirtual;
  VirtualFree:=MS.dwAvailVirtual;
  PageFileTotal:=MS.dwTotalPageFile;
  PageFileFree:=MS.dwAvailPageFile;
  ZeroMemory(@SI,SizeOf(SI));
  GetSystemInfo(SI);
  AllocGranularity:=SI.dwAllocationGranularity;
  MaxAppAddress:=DWORD(SI.lpMaximumApplicationAddress);
  MinAppAddress:=DWORD(SI.lpMinimumApplicationAddress);
  PageSize:=DWORD(SI.dwPageSize);
end;

procedure TMemory.Report(var sl: TStringList);
begin
  with sl do begin
    add(formatfloat('Physical Memory Total: #,## B',PhysicalTotal));
    add(formatfloat('Physical Memory Free: #,## B',PhysicalFree));
    add(formatfloat('Page File Total: #,## B',PageFileTotal));
    add(formatfloat('Page File Free: #,## B',PageFileFree));
    add(formatfloat('Virtual Memory Total: #,## B',VirtualTotal));
    add(formatfloat('Virtual Memory Free: #,## B',VirtualFree));
    add('');
    add(formatfloat('Allocation Granularity: #,## B',AllocGranularity));
    add(format('Application Addres Range: %s - %s',[inttohex(MinAppAddress,8),inttohex(MaxAppAddress,8)]));
    add(formatfloat('Page Size: #,## B',PageSize));
  end;
end;

{ TOperatingSystem }

constructor TOperatingSystem.Create;
begin
  inherited;
  FEnv:=TStringList.Create;
end;

destructor TOperatingSystem.Destroy;
begin
  FEnv.Free;
  inherited;
end;


procedure TOperatingSystem.GetEnvironment;
var
  c,i :dword;
  b :pchar;
  s :string;
begin
  FEnv.Clear;
  c:=1024;
  b:=GetEnvironmentStrings;
  i:=0;
  s:='';
  while i<c do begin
    if b[i]<>#0 then
      s:=s+b[i]
    else begin
      if s='' then
        break;
      FEnv.Add(s);
      s:='';
    end;
    inc(i);
  end;
  FreeEnvironmentStrings(b);
end;

procedure TOperatingSystem.GetInfo;
var
  OS :TOSVersionInfo;
  p :pchar;
  n :DWORD;
const
  rkTimeZone = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Control\TimeZoneInformation';
  rvTimeZone = 'StandardName';
  rkOSInfo95 = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows\CurrentVersion';
  rkOSInfoNT = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion';
  rvVersionName95 = 'Version';
  rvVersionNameNT = 'CurrentType';
  rvRegOrg = 'RegisteredOrganization';
  rvRegOwn = 'RegisteredOwner';
  rvProductID = 'ProductID';
begin
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  GetVersionEx(OS);
  MajorVersion:=OS.dwMajorVersion;
  MinorVersion:=OS.dwMinorVersion;
  BuildNumber:=word(OS.dwBuildNumber);
  case OS.dwPlatformId of
    VER_PLATFORM_WIN32s        :Platform:='Windows 3.1x';
    VER_PLATFORM_WIN32_WINDOWS :Platform:='Windows 95';
    VER_PLATFORM_WIN32_NT      :Platform:='Windows NT';
  end;
  if MajorVersion>4 then
    Platform:='Windows 2000';
  CSD:=strpas(OS.szCSDVersion);
  TimeZone:='';
  Version:='';
  RegisteredUser:='';
  RegisteredOrg:='';
  SerialNumber:='';
  with tregistry.create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if openkey(rkTimeZone,false) then begin
      if valueexists(rvTimeZone) then
        TimeZone:=readstring(rvTimeZone);
      closekey;
    end;
    if isnt then begin
      if openkey(rkOSInfoNT,false) then begin
        if valueexists(rvVersionNameNT) then
          Version:=readstring(rvVersionNameNT);
        if valueexists(rvRegOrg) then
          RegisteredOrg:=readstring(rvRegOrg);
        if valueexists(rvRegOwn) then
          RegisteredUser:=readstring(rvRegOwn);
        if valueexists(rvProductID) then
          SerialNumber:=readstring(rvProductID);
        closekey;
      end;
    end else begin
      if openkey(rkOSInfo95,false) then begin
        if valueexists(rvVersionName95) then
          Version:=readstring(rvVersionName95);
        if valueexists(rvRegOrg) then
          RegisteredOrg:=readstring(rvRegOrg);
        if valueexists(rvRegOwn) then
          RegisteredUser:=readstring(rvRegOwn);
        if valueexists(rvProductID) then
          SerialNumber:=readstring(rvProductID);
        closekey;
      end;
    end;
  end;
  GetEnvironment;
  n:=MAX_PATH;
  p:=stralloc(n);
  getwindowsdirectory(p,n);
  windir:=strpas(p);
  getsystemdirectory(p,n);
  sysdir:=strpas(p);
  gettemppath(n,p);
  tempdir:=strpas(p);
  strdispose(p);
end;

function TOperatingSystem.GetGDIRes: Byte;
begin
  if not isNT then
    result:=GetFreeSysRes(cGDI)
  else
    result:=0;
end;

function TOperatingSystem.GetSystemRes: Byte;
begin
  if not isNT then
    result:=GetFreeSysRes(cSystem)
  else
    result:=0;
end;

function TOperatingSystem.GetUSERRes: Byte;
begin
  if not isNT then
    result:=GetFreeSysRes(cUser)
  else
    result:=0;
end;

procedure TOperatingSystem.Report(var sl: TStringList);
begin
  with sl do begin
    add('Platform: '+Platform);
    add(format('Version: %s %d.%d.%d',[Version,MajorVersion,MinorVersion,BuildNumber]));
    add('CSD: '+CSD);
    add('Serial Number: '+SerialNumber);
    add('Registered User: '+RegisteredUser);
    add('Registered Organization: '+RegisteredOrg);
    add('Time Zone: '+TimeZone);
    add('');
    add('Windows Folder: '+WinDir);
    add('System Folder: '+SysDir);
    add('Temp Folder: '+TempDir);
    add('');
    add('Environment:');
    addstrings(Environment);
  end;
end;

procedure TOperatingSystem.SetNone(Value: Byte);
begin

end;

{ TDisk }

function TDisk.GetCD: byte;
var
  i :integer;
  root :pchar;
begin
  result:=0;
  root:=stralloc(255);
  for i:=1 to length(FAvailDisks) do begin
    strpcopy(root,copy(FAvailDisks,i,1)+':\');
    if getdrivetype(root)=drive_cdrom then begin
      result:=i;
      break;
    end;
  end;
  strdispose(root);
end;

function TDisk.GetDriveTypeStr(dt: TDriveType) :string;
begin
  case dt of
    dtUnknown     :result:='Unknown';
    dtNotExists   :result:='Not Exists';
    dtRemovable   :result:='Removable';
    dtFixed       :result:='Fixed';
    dtRemote      :result:='Remote';
    dtCDROM       :result:='CDROM';
    dtRAMDisk     :result:='RAMDisk';
  end;
end;

procedure TDisk.GetFileFlagsStr(AClear :boolean; var AFileFlags: TStringList);
begin
  if AClear then
    AFileFlags.Clear;
  AFileFlags.Add('Case Is Preserved: '+bool2yn(fsCaseIsPreserved in FileFlags));
  AFileFlags.Add('Case Sensitive: '+bool2yn(fsCaseSensitive in FileFlags));
  AFileFlags.Add('Unicode Stored On Disk: '+bool2yn(fsUnicodeStoredOnDisk in FileFlags));
  AFileFlags.Add('Persistent Acls: '+bool2yn(fsPersistentAcls in FileFlags));
  AFileFlags.Add('File Compression: '+bool2yn(fsFileCompression in FileFlags));
  AFileFlags.Add('Volume Is Compressed: '+bool2yn(fsVolumeIsCompressed in FileFlags));
  AFileFlags.Add('Long Filenames: '+bool2yn(fsLongFileNames in FileFlags));
  AFileFlags.Add('Encrypted File System Support: '+bool2yn(fsEncryptedFileSystemSupport in FileFlags));
  AFileFlags.Add('Object IDs Support: '+bool2yn(fsObjectIDsSupport in FileFlags));
  AFileFlags.Add('Reparse Points Support: '+bool2yn(fsReparsePointsSupport in FileFlags));
  AFileFlags.Add('Sparse Files Support: '+bool2yn(fsSparseFilesSupport in FileFlags));
  AFileFlags.Add('Disk Quotas Support: '+bool2yn(fsDiskQuotasSupport in FileFlags));
end;

procedure TDisk.GetInfo;
var
  i,n :integer;
  buf :pchar;
begin
  buf:=stralloc(255);
  n:=GetLogicalDriveStrings(255,buf);
  FAvailDisks:='';
  for i:=0 to n do
    if buf[i]<>#0 then begin
      if (ord(buf[i]) in [$41..$5a]) or (ord(buf[i]) in [$61..$7a]) then
        FAvailDisks:=FAvailDisks+upcase(buf[i])
    end else
      if buf[i+1]=#0 then
        break;
  strdispose(buf);
end;


function TDisk.GetMediaPresent :Boolean;
var
  ErrorMode: Word;
  bufRoot :pchar;
  a,b,c,d :dword;
begin
  bufRoot:=stralloc(255);
  strpcopy(bufRoot,FDisk+'\');
  ErrorMode:=SetErrorMode(SEM_FailCriticalErrors);
  try
    try
      result:=GetDiskFreeSpace(bufRoot,a,b,c,d);
    except
      result:=False;
    end;
  finally
    strdispose(bufroot);
    SetErrorMode(ErrorMode);
  end;
end;

procedure TDisk.Report(var sl: TStringList);
var
  i :integer;
begin
  for i:=1 to length(AvailableDisks) do begin
    sl.add('');
    Drive:=copy(AvailableDisks,i,1)+':';
    sl.add(format('%s [%s] - %s',[Drive,VolumeLabel,GetDriveTypeStr(DriveType)]));
    sl.add('UNC: '+expanduncfilename(Drive));
    sl.add('Serial Number: '+SerialNumber);
    {$IFDEF D4PLUS}
    sl.add(formatfloat('Capacity: 0,## bytes',Capacity));
    sl.add(formatfloat('Free space: 0,## bytes',FreeSpace));
    {$ELSE}
    sl.add(formatfloat('Capacity: 0,## bytes',Capacity.QuadPart));
    sl.add(formatfloat('Free space: 0,## bytes',FreeSpace.QuadPart));
    {$ENDIF}
    sl.add(formatfloat('Bytes/sector: 0',BytesPerSector));
    sl.add(formatfloat('Sector/cluster: 0',SectorsPerCluster));
    sl.add(formatfloat('Free clusters: 0,##',FreeClusters));
    sl.add(formatfloat('Total clusters: 0,##',TotalClusters));
    sl.add('  File Flags:');
    GetFileFlagsStr(false,sl);
  end;
end;

procedure TDisk.SetDisk(const Value: TDiskSign);
var
  BPS,TC,FC,SPC :integer;
  T,F :TLargeInteger;
  TF :PLargeInteger;
  bufRoot, bufVolumeLabel, bufFileSystem :pchar;
  MCL,Size,Flags :DWORD;
  s :string;
  {$IFNDEF D4PLUS}
  h :THandle;
  GetDiskFreeSpaceEx :function (lpDirectoryName: PChar;
                                var lpFreeBytesAvailableToCaller,
                                    lpTotalNumberOfBytes;
                                lpTotalNumberOfFreeBytes: PLargeInteger): BOOL; stdcall;
  {$ENDIF}

const
  rk2KModel = '';
begin
  FDisk:=Value;
  Size:=255;
  bufRoot:=stralloc(Size);
  strpcopy(bufRoot,FDisk+'\');
  case GetDriveType(bufRoot) of
    DRIVE_UNKNOWN     :FDriveType:=dtUnknown;
    DRIVE_NO_ROOT_DIR :FDriveType:=dtNotExists;
    DRIVE_REMOVABLE   :FDriveType:=dtRemovable;
    DRIVE_FIXED       :FDriveType:=dtFixed;
    DRIVE_REMOTE      :FDriveType:=dtRemote;
    DRIVE_CDROM       :FDriveType:=dtCDROM;
    DRIVE_RAMDISK     :FDriveType:=dtRAMDisk;
  end;
  FFileFlags:=[];
  if MediaPresent then begin
    GetDiskFreeSpace(bufRoot,FSectorsPerCluster,FBytesPerSector,FFreeClusters,FTotalClusters);
    try
      new(TF);
      {$IFDEF D4PLUS}
      SysUtils.GetDiskFreeSpaceEx(bufRoot,F,T,TF);
      FCapacity:=T;
      FFreeSpace:=F;
      {$ELSE}
      GetDiskFreeSpaceEx:=nil;
      h:=LoadLibrary('KERNEL32.DLL');
      if h>0 then
        GetDiskFreeSpaceEx:=GetProcAddress(h,'GetDiskFreeSpaceExA');
      if assigned(GetDiskFreeSpaceEx) then
        GetDiskFreeSpaceEx(bufRoot,F,T,TF);
      FCapacity:=T;
      FFreeSpace:=F;
      FreeLibrary(h);
      {$ENDIF}
      dispose(TF);
    except
      BPS:=FBytesPerSector;
      TC:=FTotalClusters;
      FC:=FFreeClusters;
      SPC:=FSectorsPerCluster;
      {$IFDEF D4PLUS}
      FCapacity:=TC*SPC*BPS;
      FFreeSpace:=FC*SPC*BPS;
      {$ELSE}
      FCapacity.QuadPart:=TC*SPC*BPS;
      FFreeSpace.QuadPart:=FC*SPC*BPS;
      {$ENDIF}
    end;
    bufVolumeLabel:=stralloc(Size);
    bufFileSystem:=stralloc(Size);
    if GetVolumeInformation(bufRoot,bufVolumeLabel,Size,@FSerial,MCL,Flags,bufFileSystem,Size) then begin;
      FVolumeLabel:=strpas(bufVolumeLabel);
      FFileSystem:=strpas(bufFileSystem);
      s:=inttohex(FSerial,8);
      FSerialNumber:=copy(s,1,4)+'-'+copy(s,5,4);
      StrDispose(bufVolumeLabel);
      StrDispose(bufFileSystem);
      StrDispose(bufRoot);
      if Flags and FS_CASE_SENSITIVE=FS_CASE_SENSITIVE then
        FFileFlags:=FFileFlags+[fsCaseSensitive];
      if Flags and FS_CASE_IS_PRESERVED=FS_CASE_IS_PRESERVED then
        FFileFlags:=FFileFlags+[fsCaseIsPreserved];
      if Flags and FS_UNICODE_STORED_ON_DISK=FS_UNICODE_STORED_ON_DISK then
        FFileFlags:=FFileFlags+[fsUnicodeStoredOnDisk];
      if Flags and FS_PERSISTENT_ACLS=FS_PERSISTENT_ACLS then
        FFileFlags:=FFileFlags+[fsPersistentAcls];
      if Flags and FS_VOL_IS_COMPRESSED=FS_VOL_IS_COMPRESSED then
        FFileFlags:=FFileFlags+[fsVolumeIsCompressed];
      if Flags and FS_FILE_COMPRESSION=FS_FILE_COMPRESSION then
        FFileFlags:=FFileFlags+[fsFileCompression];
      if MCL=255 then
        FFileFlags:=FFileFlags+[fsLongFileNames];
      {if Flags and FILE_SUPPORTS_ENCRYPTION=FILE_SUPPORTS_ENCRYPTION then
        FFileFlags:=FFileFlags+[fsEncryptedFileSystemSupport];
      if Flags and FILE_SUPPORTS_OBJECT_IDS=FILE_SUPPORTS_OBJECT_IDS then
        FFileFlags:=FFileFlags+[fsObjectIDsSupport];
      if Flags and FILE_SUPPORTS_REPARSE_POINTS=FILE_SUPPORTS_REPARSE_POINTS then
        FFileFlags:=FFileFlags+[fsReparsePointsSupport];
      if Flags and FILE_SUPPORTS_SPARSE_FILES=FILE_SUPPORTS_SPARSE_FILES then
        FFileFlags:=FFileFlags+[fsSparseFilesSupport];
      if Flags and FILE_VOLUME_QUOTAS=FILE_VOLUME_QUOTAS then
        FFileFlags:=FFileFlags+[fsDiskQuotasSupport]; }
    end;
  end else begin
    FSectorsPerCluster:=0;
    FBytesPerSector:=0;
    FFreeClusters:=0;
    FTotalClusters:=0;
    {$IFDEF D4PLUS}
    FCapacity:=0;
    FFreeSpace:=0;
    {$ELSE}
    FCapacity.QuadPart:=0;
    FFreeSpace.QuadPart:=0;
    {$ENDIF}
    FVolumeLabel:='';
    FSerialNumber:='';
    FFileSystem:='';
    FSerial:=0;
  end;
end;

{ TWorkstation }


function TWorkstation.GetSystemUpTime: Extended;
begin
  try
    FSystemUpTime:=GetTimeStamp.QuadPart/GetTicksPerSecond(1);
  except
    FSystemUpTime:=0;
  end;
  result:=FSystemUpTime;
end;

procedure TWorkstation.GetInfo;
var
  bdata :pchar;
  KeyState : TKeyBoardState;
const
  cBIOSName = $FE061;
  cBIOSDate = $FFFF5;
  cBIOSExtInfo = $FEC71;
  cBIOSCopyright = $FE091;

  rkBIOS = {HKEY_LOCAL_MACHINE\}'HARDWARE\DESCRIPTION\System';
    rvBiosDate = 'SystemBiosDate';
    rvBiosID = 'Identifier';
    rvBiosVersion = 'SystemBiosVersion';

begin
  try
    FLastBoot:=Now-(GetTimeStamp.QuadPart/GetTicksPerSecond(1))/(24*3600);
  except
    FLastBoot:=0;
  end;
  FSystemUpTime:=GetSystemUpTime;
  FName:=GetMachine;
  FUser:=GetUser;
  if isNT then begin
    with TRegistry.Create do begin
      rootkey:=HKEY_LOCAL_MACHINE;
      if openkey(rkBIOS,false) then begin
        if valueexists(rvBIOSID) then
          FBiosName:=readstring(rvBIOSID);
        if valueexists(rvBIOSVersion) then begin
          bdata:=stralloc(255);
          try
            readbinarydata(rvBIOSVersion,bdata^,255);
            FBIOSCopyright:=strpas(pchar(bdata));
          except
          end;
        end;
        if valueexists(rvBIOSDate) then
          FBIOSDate:=readstring(rvBIOSDate);
        closekey;
      end;
      free;
    end;
  end else begin
    FBIOSName:=string(pchar(ptr(cBIOSName)));
    FBIOSDate:=string(pchar(ptr(cBIOSDate)));
    FBIOSCopyright:=string(pchar(ptr(cBIOSCopyright)));
    FBIOSExtendedInfo:=string(pchar(ptr(cBIOSExtInfo)));
  end;
  GetKeyboardState(KeyState);
  FCapsLock:=KeyState[VK_CAPITAL]=1;
  FNumLock:=KeyState[VK_NUMLOCK]=1;
  FScrollLock:=KeyState[VK_SCROLL]=1;
end;


procedure TWorkstation.Report(var sl: TStringList);
begin
  with sl do begin
    add('Name: '+Name);
    add('User: '+User);
    add('BIOS name: '+BIOSName);
    add('BIOS Copyright: '+BIOSCopyright);
    add('BIOS Date: '+BIOSDate);
    add('BIOS Extended info: '+BIOSExtendedInfo);
    add('Last Boot: '+datetimetostr(LastBoot));
    add('System Up Time: '+formatseconds(SystemUpTime,true,false,false));
  end;
end;

{ TWinsock }

procedure TWinsock.GetInfo;
var
  GInitData :TWSADATA;
begin
  if wsastartup($101,GInitData)=0 then begin
    FDesc:=GInitData.szDescription;
    FStat:=GInitData.szSystemStatus;
    FMajVer:=Hi(GInitData.wHighVersion);
    FMinVer:=Lo(GInitData.wHighVersion);
    wsacleanup;
  end else
    FStat:='Winsock cannot be initialized.';
end;


{ TNetwork }

function TNetwork.GetLocalIP: string;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe  :PHostEnt;
  pptr :PaPInAddr;
  Buffer :array [0..63] of char;
  i :integer;
  GInitData :TWSADATA;
begin
  wsastartup($101,GInitData);
  result:='';
  GetHostName(Buffer,SizeOf(Buffer));
  phe:=GetHostByName(buffer);
  if not assigned(phe) then
    exit;
  pptr:=PaPInAddr(Phe^.h_addr_list);
  i:=0;
  while pptr^[I]<>nil do begin
    result:=StrPas(inet_ntoa(pptr^[I]^));
    inc(i);
  end;
  wsacleanup;
end;

procedure TNetwork.GetInfo;
const
  rkNetworkNT = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards\1';
    rvNetworkNT = 'Description';

  rvNet95Class = 'Network adapters';
  rvNet2000Class = 'Net';
begin
  FWinSock.GetInfo;
  FIPAddress:=GetLocalIP;
  FAdapter.Clear;
  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if isNT then begin
      if is2000 then begin
        getclassdevices(rvNet2000Class,FAdapter);
      end else
        if openkey(rkNetworkNT,false) then begin
          if valueexists(rvNetworkNT) then
            FAdapter.Add(readstring(rvNetworkNT));
          closekey;
        end
    end else begin
      getclassdevices(rvNet95Class,FAdapter);
    end;
    free;
  end;
end;

constructor TNetwork.Create;
begin
  inherited;
  FWinsock:=TWinsock.Create;
  FAdapter:=TStringList.Create;
end;

destructor TNetwork.Destroy;
begin
  FWinsock.Free;
  FAdapter.Free;
  inherited;
end;

procedure TNetwork.Report(var sl: TStringList);
begin
  with sl do begin
    add('Adapters:');
    addstrings(Adapter);
    add('');
    add('IP Address: '+IPAddress);
    Add('');
    Add(Format('%s (%d.%d): %s',[Winsock.Description,
                                 Hi(Winsock.MajorVersion),
                                 Lo(Winsock.MinorVersion),
                                 Winsock.Status]));
  end;
end;


{ TVideo }

procedure TVideo.GetInfo;
var
  rk :string;
  idata,bdata :pchar;
  sl :tstringlist;
  i :integer;
const
  rkVideoNT = {HKEY_LOCAL_MACHINE\}'HARDWARE\DEVICEMAP\VIDEO';
  rvVideoNTKey = '\Device\Video0';
  rvHardwareNT = 'HardwareInformation';
    rvVideoNT = 'AdapterString';
    rvDACNT = 'DacType';
    rvChipNT = 'ChipType';

  rvVideoNTClass = 'Display';
  rvVideo95Class = 'Display adapters';

    rkInfo = 'INFO';
    rv = 'DriverDesc';
    rvDAC = 'DACType';
    rvChip = 'ChipType';
    rvMem = 'VideoMemory';
    rvMemNT = 'MemorySize';
    rvRev = 'Revision';

  rv3D95Class = '3D Accelerators';
  rv3DNTClass = '3D Accelerators';

  rkBIOS = {HKEY_LOCAL_MACHINE\}'HARDWARE\DESCRIPTION\System';
    rvVideoBiosDate = 'VideoBiosDate';
    rvVideoBiosVersion = 'VideoBiosVersion';
begin
  FHorzRes:=GetDeviceCaps(GetDC(0),windows.HORZRES);
  FVertRes:=GetDeviceCaps(GetDC(0),windows.VERTRES);
  FColorDepth:=GetDeviceCaps(GetDC(0),BITSPIXEL);
  case GetDeviceCaps(GetDC(0),windows.TECHNOLOGY) of
    DT_PLOTTER:    FTechnology:='Vector Plotter';
    DT_RASDISPLAY: FTechnology:='Raster Display';
    DT_RASPRINTER: FTechnology:='Raster Printer';
    DT_RASCAMERA:  FTechnology:='Raster Camera';
    DT_CHARSTREAM: FTechnology:='Character Stream';
    DT_METAFILE:   FTechnology:='Metafile';
    DT_DISPFILE:   FTechnology:='Display File';
  end;
  FHorzSize:=GetDeviceCaps(GetDC(0),HORZSIZE);
  FVertSize:=GetDeviceCaps(GetDC(0),VERTSIZE);
  FPixelWidth:=GetDeviceCaps(GetDC(0),ASPECTX);
  FPixelHeight:=GetDeviceCaps(GetDC(0),ASPECTY);
  FPixelDiagonal:=GetDeviceCaps(GetDC(0),ASPECTXY);
  FCurveCaps:=[];
  if GetDeviceCaps(GetDC(0),windows.CURVECAPS)<>CC_NONE then begin
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_CIRCLES)=CC_CIRCLES then
      FCurveCaps:=FCurveCaps+[ccCircles];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_PIE)=CC_PIE then
      FCurveCaps:=FCurveCaps+[ccPieWedges];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_CHORD)=CC_CHORD then
      FCurveCaps:=FCurveCaps+[ccChords];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_ELLIPSES)=CC_ELLIPSES then
      FCurveCaps:=FCurveCaps+[ccEllipses];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_WIDE)=CC_WIDE then
      FCurveCaps:=FCurveCaps+[ccWideBorders];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_STYLED)=CC_STYLED then
      FCurveCaps:=FCurveCaps+[ccStyledBorders];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_WIDESTYLED)=CC_WIDESTYLED then
      FCurveCaps:=FCurveCaps+[ccWideStyledBorders];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_INTERIORS)=CC_INTERIORS then
      FCurveCaps:=FCurveCaps+[ccInteriors];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_ROUNDRECT)=CC_ROUNDRECT then
      FCurveCaps:=FCurveCaps+[ccRoundedRects];
  end;
  FLineCaps:=[];
  if GetDeviceCaps(GetDC(0),windows.LINECAPS)<>LC_NONE then begin
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_POLYLINE)=LC_POLYLINE then
      FLineCaps:=FLineCaps+[lcPolylines];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_MARKER)=LC_MARKER then
      FLineCaps:=FLineCaps+[lcMarkers];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_POLYMARKER)=LC_POLYMARKER then
      FLineCaps:=FLineCaps+[lcMultipleMarkers];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_WIDE)=LC_WIDE then
      FLineCaps:=FLineCaps+[lcWideLines];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_STYLED)=LC_STYLED then
      FLineCaps:=FLineCaps+[lcStyledLines];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_WIDESTYLED)=LC_WIDESTYLED then
      FLineCaps:=FLineCaps+[lcWideStyledLines];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_INTERIORS)=LC_INTERIORS then
      FLineCaps:=FLineCaps+[lcInteriors];
  end;
  FPolygonCaps:=[];
  if GetDeviceCaps(GetDC(0),POLYGONALCAPS)<>PC_NONE then begin
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_POLYGON)=PC_POLYGON then
      FPolygonCaps:=FPolygonCaps+[pcAltFillPolygons];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_RECTANGLE)=PC_RECTANGLE then
      FPolygonCaps:=FPolygonCaps+[pcRectangles];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_WINDPOLYGON)=PC_WINDPOLYGON then
      FPolygonCaps:=FPolygonCaps+[pcWindingFillPolygons];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_SCANLINE)=PC_SCANLINE then
      FPolygonCaps:=FPolygonCaps+[pcSingleScanlines];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_WIDE)=PC_WIDE then
      FPolygonCaps:=FPolygonCaps+[pcWideBorders];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_STYLED)=PC_STYLED then
      FPolygonCaps:=FPolygonCaps+[pcStyledBorders];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_WIDESTYLED)=PC_WIDESTYLED then
      FPolygonCaps:=FPolygonCaps+[pcWideStyledBorders];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_INTERIORS)=PC_INTERIORS then
      FPolygonCaps:=FPolygonCaps+[pcInteriors];
  end;
  FRasterCaps:=[];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_BANDING)=RC_BANDING then
    FRasterCaps:=FRasterCaps+[rcRequiresBanding];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_BITBLT)=RC_BITBLT then
    FRasterCaps:=FRasterCaps+[rcTranserBitmaps];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_BITMAP64)=RC_BITMAP64 then
    FRasterCaps:=FRasterCaps+[rcBitmaps64K];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_DI_BITMAP)=RC_DI_BITMAP then
    FRasterCaps:=FRasterCaps+[rcSetGetDIBits];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_DIBTODEV)=RC_DIBTODEV then
    FRasterCaps:=FRasterCaps+[rcSetDIBitsToDevice];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_FLOODFILL)=RC_FLOODFILL then
    FRasterCaps:=FRasterCaps+[rcFloodfills];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_GDI20_OUTPUT)=RC_GDI20_OUTPUT then
    FRasterCaps:=FRasterCaps+[rcWindows2xFeatures];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_PALETTE)=RC_PALETTE then
    FRasterCaps:=FRasterCaps+[rcPaletteBased];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_SCALING)=RC_SCALING then
    FRasterCaps:=FRasterCaps+[rcScaling];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_STRETCHBLT)=RC_STRETCHBLT then
    FRasterCaps:=FRasterCaps+[rcStretchBlt];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_STRETCHDIB)=RC_STRETCHDIB then
    FRasterCaps:=FRasterCaps+[rcStretchDIBits];
  FTextCaps:=[];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_OP_CHARACTER)=TC_OP_CHARACTER then
    FTextCaps:=FTextCaps+[tcCharOutPrec];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_OP_STROKE)=TC_OP_STROKE then
    FTextCaps:=FTextCaps+[tcStrokeOutPrec];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_CP_STROKE)=TC_CP_STROKE then
    FTextCaps:=FTextCaps+[tcStrokeClipPrec];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_CR_90)=TC_CR_90 then
    FTextCaps:=FTextCaps+[tcCharRotation90];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_CR_ANY)=TC_CR_ANY then
    FTextCaps:=FTextCaps+[tcCharRotationAny];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SF_X_YINDEP)=TC_SF_X_YINDEP then
    FTextCaps:=FTextCaps+[tcScaleIndependent];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SA_DOUBLE)=TC_SA_DOUBLE then
    FTextCaps:=FTextCaps+[tcDoubledCharScaling];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SA_INTEGER)=TC_SA_INTEGER then
    FTextCaps:=FTextCaps+[tcIntMultiScaling];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SA_CONTIN)=TC_SA_CONTIN then
    FTextCaps:=FTextCaps+[tcAnyMultiExactScaling];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_EA_DOUBLE)=TC_EA_DOUBLE then
    FTextCaps:=FTextCaps+[tcDoubleWeightChars];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_IA_ABLE)=TC_IA_ABLE then
    FTextCaps:=FTextCaps+[tcItalics];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_UA_ABLE)=TC_UA_ABLE then
    FTextCaps:=FTextCaps+[tcUnderlines];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and  TC_SO_ABLE)=TC_SO_ABLE then
    FTextCaps:=FTextCaps+[tcStrikeouts];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_RA_ABLE)=TC_RA_ABLE then
    FTextCaps:=FTextCaps+[tcRasterFonts];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_VA_ABLE)=TC_VA_ABLE then
    FTextCaps:=FTextCaps+[tcVectorFonts];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SCROLLBLT)=TC_SCROLLBLT then
    FTextCaps:=FTextCaps+[tcNoScrollUsingBlts];
  sl:=tstringlist.create;
  FAdapter.Clear;
  FDAC.Clear;
  FChipset.Clear;
  FMemory.Clear;
  bdata:=stralloc(255);
  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if isNT then begin
      if is2000 then begin
        rk:=getclassdevices(rvVideoNTClass,FAdapter);
        if openkey(rk,false) then begin
          getkeynames(sl);
          closekey;
          for i:=0 to sl.count-1 do
            if openkey(rk+'\'+sl[i]+'\'+rkinfo,false) then begin
              if valueexists(rvDAC) then
                FDAC.Add(readstring(rvDAC));
              if valueexists(rvChip) then
                FChipset.Add(readstring(rvChip));
              if valueexists(rvRev) then
                FChipset[FChipset.Count-1]:=FChipset[FChipset.Count-1]+' Rev '+readstring(rvRev);
              if valueexists(rvMem) then
                FMemory.Add(inttostr(readinteger(rvMem)));
              closekey;
            end;
        end;
      end else begin
        if openkey(rkVideoNT,false) then begin
          if valueexists(rvVideoNTKey) then
            rk:=readstring(rvVideoNTKey)
          else
            rk:='';
          closekey;
          if rk<>'' then begin
            rk:=copy(rk,pos('Machine\',rk)+8,255);
            if openkey(rk,false) then begin
              if valueexists(rvHardwareNT+'.'+rvVideoNT) then
                try
                  readbinarydata(rvHardwareNT+'.'+rvVideoNT,bdata^,255);
                  FAdapter.Add(getstrfrombuf(pchar(bdata)));
                except
                end;
              if valueexists(rvHardwareNT+'.'+rvDACNT) then
                try
                  readbinarydata(rvHardwareNT+'.'+rvDACNT,bdata^,255);
                  FDAC.Add(getstrfrombuf(pchar(bdata)));
                except
                end;
              if valueexists(rvHardwareNT+'.'+rvChipNT) then
                try
                  readbinarydata(rvHardwareNT+'.'+rvChipNT,bdata^,255);
                  FChipset.Add(getstrfrombuf(pchar(bdata)));
                except
                end;
              if valueexists(rvHardwareNT+'.'+rvmemNT) then
                try
                  idata:=stralloc(255);
                  readbinarydata(rvHardwareNT+'.'+rvMemNT,idata,4);
                  FMemory.Add(inttostr(integer(idata)));
                  strdispose(idata);
                except
                end;
              closekey;
            end;
          end;
        end;
      end;
      if openkey(rkBIOS,false) then begin
        if valueexists(rvVideoBIOSVersion) then begin
          try
            readbinarydata(rvVideoBIOSVersion,bdata^,151);
            FBIOSVersion:=strpas(pchar(bdata));
          except
          end;
        end;
        if valueexists(rvVideoBIOSDate) then
          FBIOSDate:=readstring(rvVideoBIOSDate);
        closekey;
      end;
    end else begin
      rk:=getclassdevices(rvVideo95Class,FAdapter);
      if openkey(rk,false) then begin
        getkeynames(sl);
        closekey;
        for i:=0 to sl.count-1 do
          if openkey(rk+'\'+sl[i]+'\'+rkinfo,false) then begin
            if valueexists(rvDAC) then
              FDAC.Add(readstring(rvDAC));
            if valueexists(rvChip) then
              FChipset.Add(readstring(rvChip));
            if valueexists(rvRev) then
              FChipset[FChipset.Count-1]:=FChipset[FChipset.Count-1]+' Rev '+readstring(rvRev);
            if valueexists(rvMem) then
              FMemory.Add(inttostr(readinteger(rvMem)));
            closekey;
          end;
      end;
    end;
    free;
  end;
  FAcc.Clear;
  getclassdevices(rv3D95Class,FAcc);
  strdispose(bdata);
  sl.free;
end;

procedure TVideo.GetCurveCapsStr(AClear :boolean; ACaps: TStringList);
begin
  if AClear then
    ACaps.Clear;
  ACaps.Add('Circles: '+bool2yn(ccCircles in CurveCaps));
  ACaps.Add('Pie Wedges: '+bool2yn(ccPieWedges in CurveCaps));
  ACaps.Add('Chords: '+bool2yn(ccChords in CurveCaps));
  ACaps.Add('Ellipses: '+bool2yn(ccEllipses in CurveCaps));
  ACaps.Add('Wide Borders: '+bool2yn(ccWideBorders in CurveCaps));
  ACaps.Add('Styled Borders: '+bool2yn(ccStyledBorders in CurveCaps));
  ACaps.Add('Wide and Styled Borders: '+bool2yn(ccWideStyledBorders in CurveCaps));
  ACaps.Add('Interiors: '+bool2yn(ccInteriors in CurveCaps));
  ACaps.Add('Rounded Rectangles: '+bool2yn(ccRoundedRects in CurveCaps));
end;

procedure TVideo.GetLineCapsStr(AClear :boolean; ACaps: TStringList);
begin
  if AClear then
    ACaps.Clear;
  ACaps.Add('Polylines: '+bool2yn(lcPolylines in LineCaps));
  ACaps.Add('Markers: '+bool2yn(lcMarkers in LineCaps));
  ACaps.Add('Multiple Markers: '+bool2yn(lcMultipleMarkers in LineCaps));
  ACaps.Add('Wide Lines: '+bool2yn(lcWideLines in LineCaps));
  ACaps.Add('Styled Lines: '+bool2yn(lcStyledLines in LineCaps));
  ACaps.Add('Wide and Styled Lines: '+bool2yn(lcWideStyledLines in LineCaps));
  ACaps.Add('Interiors: '+bool2yn(lcInteriors in LineCaps));
end;

procedure TVideo.GetPolygonCapsStr(AClear :boolean; ACaps: TStringList);
begin
  if AClear then
    ACaps.Clear;
  ACaps.Add('Alternate Fill Polygons: '+bool2yn(pcAltFillPolygons in PolygonCaps));
  ACaps.Add('Rectangles: '+bool2yn(pcRectangles in PolygonCaps));
  ACaps.Add('Winding Fill Polygons: '+bool2yn(pcWindingFillPolygons in PolygonCaps));
  ACaps.Add('Single Scanlines: '+bool2yn(pcSingleScanlines in PolygonCaps));
  ACaps.Add('Wide Borders: '+bool2yn(pcWideBorders in PolygonCaps));
  ACaps.Add('Styled Borders: '+bool2yn(pcStyledBorders in PolygonCaps));
  ACaps.Add('Wide and Styled Borders: '+bool2yn(pcWideStyledBorders in PolygonCaps));
  ACaps.Add('Interiors: '+bool2yn(pcInteriors in PolygonCaps));
end;

procedure TVideo.GetRasterCapsStr(AClear :boolean; ACaps: TStringList);
begin
  if AClear then
    ACaps.Clear;
  ACaps.Add('Requires Banding: '+bool2yn(rcRequiresBanding in RasterCaps));
  ACaps.Add('Can Transer Bitmaps: '+bool2yn(rcTranserBitmaps in RasterCaps));
  ACaps.Add('Supports Bitmaps > 64K: '+bool2yn(rcBitmaps64K in RasterCaps));
  ACaps.Add('Supports SetDIBits and GetDIBits: '+bool2yn(rcSetGetDIBits in RasterCaps));
  ACaps.Add('Supports SetDIBitsToDevice: '+bool2yn(rcSetDIBitsToDevice in RasterCaps));
  ACaps.Add('Can Perform Floodfills: '+bool2yn(rcFloodfills in RasterCaps));
  ACaps.Add('Supports Windows 2.0 Features: '+bool2yn(rcWindows2xFeatures in RasterCaps));
  ACaps.Add('Palette Based: '+bool2yn(rcPaletteBased in RasterCaps));
  ACaps.Add('Scaling: '+bool2yn(rcScaling in RasterCaps));
  ACaps.Add('Supports StretchBlt: '+bool2yn(rcStretchBlt in RasterCaps));
  ACaps.Add('Supports StretchDIBits: '+bool2yn(rcStretchDIBits in RasterCaps));
end;

procedure TVideo.GetTextCapsStr(AClear :boolean; ACaps: TStringList);
begin
  if AClear then
    ACaps.Clear;
  ACaps.Add('Capable of Character Output Precision: '+bool2yn(tcCharOutPrec in TextCaps));
  ACaps.Add('Capable of Stroke Output Precision: '+bool2yn(tcStrokeOutPrec in TextCaps));
  ACaps.Add('Capable of Stroke Clip Precision: '+bool2yn(tcStrokeClipPrec in TextCaps));
  ACaps.Add('Supports 90 Degree Character Rotation: '+bool2yn(tcCharRotation90 in TextCaps));
  ACaps.Add('Supports Character Rotation to Any Angle: '+bool2yn(tcCharRotationAny in TextCaps));
  ACaps.Add('X And Y Scale Independent: '+bool2yn(tcScaleIndependent in TextCaps));
  ACaps.Add('Supports Doubled Character Scaling: '+bool2yn(tcDoubledCharScaling in TextCaps));
  ACaps.Add('Supports Integer Multiples Only When Scaling: '+bool2yn(tcIntMultiScaling in TextCaps));
  ACaps.Add('Supports Any Multiples For Exact Character Scaling: '+bool2yn(tcAnyMultiExactScaling in TextCaps));
  ACaps.Add('Supports Double Weight Characters: '+bool2yn(tcDoubleWeightChars in TextCaps));
  ACaps.Add('Supports Italics: '+bool2yn(tcItalics in TextCaps));
  ACaps.Add('Supports Underlines: '+bool2yn(tcUnderlines in TextCaps));
  ACaps.Add('Supports Strikeouts: '+bool2yn(tcStrikeouts in TextCaps));
  ACaps.Add('Supports Raster Fonts: '+bool2yn(tcRasterFonts in TextCaps));
  ACaps.Add('Supports Vector Fonts: '+bool2yn(tcVectorFonts in TextCaps));
  ACaps.Add('Cannot Scroll Using Blts: '+bool2yn(tcNoScrollUsingBlts in TextCaps));
end;

constructor TVideo.Create;
begin
  inherited;
  FAdapter:=TStringList.Create;
  FAcc:=TStringList.Create;
  FDAc:=TStringList.Create;
  FChipset:=TStringList.Create;
  FMemory:=TStringList.Create;
end;

destructor TVideo.Destroy;
begin
  FAdapter.Free;
  FDAc.Free;
  FChipset.Free;
  FMemory.Free;
  FAcc.Free;
  inherited;
end;

procedure TVideo.Report(var sl: TStringList);
var
  i :integer;
begin
  with sl do begin
    for i:=0 to Adapter.count-1 do begin
       add(format('[%d] %s',[i+1,Adapter[i]]));
       if Chipset.count-1>=i then
         add('    Chipset: '+Chipset[i]);
        if DAC.count-1>=i then
          add('    DAC: '+DAC[i]);
        if Memory.count-1>=i then
          add('    Memory: '+Memory[i]+' B');
    end;
    add('');
    add(format('BIOS: %s (%s)',[BIOSVersion,BIOSDate]));
    add('Technology: '+Technology);
    add(format('Metrics: %d x %d - %d bit',[HorzRes,VertRes,ColorDepth]));
    add(format('Pixel Width: %d',[PixelWidth]));
    add(format('Pixel Height: %d',[PixelHeight]));
    add(format('Pixel Diagonal: %d',[PixelDiagonal]));
    add('');
    add('Curve Capabilities:');
    GetCurveCapsStr(false,sl);
    add('');
    add('Line Capabilities:');
    GetLineCapsStr(false,sl);
    add('');
    add('Polygonal Capabilities:');
    GetPolygonCapsStr(false,sl);
    add('');
    add('Raster Capabilities:');
    GetRasterCapsStr(false,sl);
    add('');
    add('Text Capabilities:');
    GetTextCapsStr(false,sl);
  end;
end;

{ TMedia }

constructor TMedia.Create;
begin
  inherited;
  FDevice:=TStringList.Create;
end;

destructor TMedia.Destroy;
begin
  FDevice.Free;
  inherited;
end;

procedure TMedia.GetInfo;
var
  WOC :PWAVEOutCaps;
  WIC :PWAVEInCaps;
  MOC :PMIDIOutCaps;
  MIC :PMIDIInCaps;
  AXC :PAUXCaps;
  MXC :PMixerCaps;
const
  rv = 'DriverDesc';
  rvMediaNTClass = 'MEDIA';
  rvMedia95Class = 'Sound, video and game controllers';
begin
  FDevice.Clear;
  if isNT then
    getclassdevices(rvMediaNTClass,FDevice)
  else
    getclassdevices(rvMedia95Class,FDevice);
  new(WOC);
  if WAVEOutGetDevCaps(0,WOC,SizeOf(TWAVEOutCaps))=MMSYSERR_NOERROR then
    FWAVEOut:=strpas(WOC^.szPname)+' v'+inttostr(hi(WOC^.vDriverVersion))+'.'+inttostr(hi(WOC^.vDriverVersion));
  dispose(WOC);
  new(WIC);
  if WAVEinGetDevCaps(0,WIC,SizeOf(TWAVEInCaps))=MMSYSERR_NOERROR then
    FWAVEIn:=strpas(WIC^.szPname)+' v'+inttostr(hi(WIC^.vDriverVersion))+'.'+inttostr(hi(WIC^.vDriverVersion));
  dispose(WIC);
  new(MOC);
  if MIDIoutGetDevCaps(0,MOC,SizeOf(TMIDIOutCaps))=MMSYSERR_NOERROR then
    FMIDIout:=strpas(MOC^.szPname)+' v'+inttostr(hi(MOC^.vDriverVersion))+'.'+inttostr(hi(MOC^.vDriverVersion));
  dispose(MOC);
  new(MIC);
  if MIDIinGetDevCaps(0,MIC,SizeOf(TMIDIInCaps))=MMSYSERR_NOERROR then
    FMIDIin:=strpas(MIC^.szPname)+' v'+inttostr(hi(MIC^.vDriverVersion))+'.'+inttostr(hi(MIC^.vDriverVersion));
  dispose(MIC);
  new(AXC);
  if AUXGetDevCaps(0,AXC,SizeOf(TAUXCaps))=MMSYSERR_NOERROR then
    FAUX:=strpas(AXC^.szPname)+' v'+inttostr(hi(AXC^.vDriverVersion))+'.'+inttostr(hi(AXC^.vDriverVersion));
  dispose(AXC);
  new(MXC);
  if MixerGetDevCaps(0,MXC,SizeOf(TMixerCaps))=MMSYSERR_NOERROR then
    FMixer:=strpas(MXC^.szPname)+' v'+inttostr(hi(MXC^.vDriverVersion))+'.'+inttostr(hi(MXC^.vDriverVersion));
  dispose(MXC);
end;

procedure TMedia.Report(var sl: TStringList);
begin
  with sl do begin
    add('Devices:');
    addstrings(Device);
    add('');
    add('Sound devices:');
    add(WaveIn);
    add(WaveOut);
    add(MIDIIn);
    add(MIDIOut);
    add(AUX);
    add(Mixer);
  end;
end;

{ TDevices }

constructor TDevices.Create;
begin
  inherited;
  FSD:=TStringList.Create;
  FUSB:=TStringList.Create;
  FPrinter:=TStringList.Create;
  FMonitor:=TStringList.Create;
  FPort:=TStringList.Create;
  FSCSI:=TStringList.Create;
  FModem:=TStringList.Create;
end;

destructor TDevices.Destroy;
begin
  FSD.Free;
  FUSB.Free;
  FPrinter.Free;
  FMonitor.Free;
  FPort.Free;
  FModem.Free;
  FSCSI.Free;
  inherited;
end;

procedure TDevices.GetInfo;
var
  i :integer;
  rk :string;
const
  rv = 'DriverDesc';

  rvMonitorNTClass = 'Monitor';
  rvMonitor95Class = 'Monitors';
  rvKeyboardClass = 'Keyboard';
  rvMouseClass = 'Mouse';

  rvSD95Class = 'System devices';
  rvSDNTClass = 'System';

  rvSCSI95Class = 'SCSI controllers';
  rvSCSINTClass = 'SCSIAdapter';

  rvUSB95Class = 'Universal serial bus controller';
  rvUSBNTClass = 'USB';

  rvModemClass = 'Modem';

  rvPortNTClass = 'Ports';
  rvPort95Class = 'Ports (COM & LPT)';
begin
  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    FMonitor.Clear;
    if isNT then
      getclassdevices(rvMonitorNTClass,FMonitor)
    else
      getclassdevices(rvMonitor95Class,FMonitor);
    FPort.Clear;
    if isNT then
      getclassdevices(rvPortNTClass,FPort)
    else
      getclassdevices(rvPort95Class,FPort);
    rk:=getclassdevice(rvMouseClass,'');
    if openkey(rk,false) then begin
      FMouse:=readstring(rv);
      closekey;
    end;
    FModem.Clear;
    getclassdevices(rvModemClass,FModem);
    rk:=getclassdevice(rvKeyboardClass,'');
    if openkey(rk,false) then begin
      FKeyboard:=readstring(rv);
      closekey;
    end;
    FSCSI.Clear;
    if isNT then
      getclassdevices(rvSCSINTClass,FSCSI)
    else
      getclassdevices(rvSCSI95Class,FSCSI);
    free;
  end;
  FPrinter.Clear;
  for i:=0 to Printers.Printer.Printers.count-1 do begin
    FPrinter.Add(Printers.printer.printers[i]);
    if i=Printers.printer.printerindex then
      FPrinter[i]:=FPrinter[i]+' (Default)';
  end;
  FSD.clear;
  if isNT then
    getclassdevices(rvSDNTClass,FSD)
  else
    getclassdevices(rvSD95Class,FSD);
  FUSB.clear;
  if isNT then
    getclassdevices(rvUSBNTClass,FUSB)
  else
    getclassdevices(rvUSB95Class,FUSB);
end;

procedure TDevices.Report(var sl: TStringList);
begin
  with sl do begin
    add('Monitors:');
    addstrings(Monitor);
    add('');
    add('Keyboard: '+Keyboard);
    add('');
    add('Mouse: '+Mouse);
    add('');
    add('');
    add('Printers:');
    addstrings(Printer);
    add('');
    add('Modems:');
    addstrings(Modem);
    add('');
    add('Ports:');
    addstrings(Port);
    add('');
    add('SCSI adapters:');
    addstrings(SCSI);
    add('');
    add('System devices:');
    addstrings(SystemDevice);
    add('');
    add('USB:');
    addstrings(USB);
  end;
end;

{ TEngines }

procedure TEngines.GetInfo;
var
  s,s1 :string;
const
  rkBDESettings = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Borland\Database Engine';
    rvBDEDLLPath = 'DLLPATH';
    fnBDEDLL = 'IDAPI32.DLL';
  rkODBCSettings = {HKEY_LOCAL_MACHINE\}'SOFTWARE\ODBC\ODBCINST.INI\ODBC Core\FileList';
    rvODBCCoreDLL = 'ODBC32.DLL';
begin
  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if openkey(rkBDESettings,false) then begin
      if valueexists(rvBDEDLLPath) then begin
        s:=readstring(rvBDEDLLPath);
        FBDE:=readverinfo(s+'\'+fnBDEDLL,s1);
      end;
      closekey;
    end;
    if openkey(rkODBCSettings,false) then begin
      if valueexists(rvODBCCoreDLL) then begin
        s:=readstring(rvODBCCoreDLL);
        FODBC:=readverinfo(s,s1);
      end;
      closekey;
    end;
    free;
  end;
end;

procedure TEngines.Report(var sl: TStringList);
begin
  with sl do begin
    if ODBC<>'' then
      add('Open Database Connectivity '+ODBC)
    else
      add('Open Database Connectivity not found');
    if BDE<>'' then
      add('Borland Database Engine '+BDE)
    else
      add('Borland Database Engine not found');
  end;
end;

{ TAPM }

procedure TAPM.GetInfo;
var
  PS :TSystemPowerStatus;
begin
  FACPowerStatus:='Unknown';
  FBatteryChargeStatus:='Unknown';
  if GetSystemPowerStatus(PS) then begin
    case PS.ACLineStatus Of
      0 : FACPowerStatus:='OffLine';
      1 : FACPowerStatus:='OnLine';
      else FACPowerStatus:='Unknown';
    end;
    if (PS.BatteryFlag or 1)=1 then
      FBatteryChargeStatus := 'High'
    else
      if (PS.BatteryFlag or 2)=2 then
        FBatteryChargeStatus:='Low'
      else
        if (PS.BatteryFlag or 4)=4 then
          FBatteryChargeStatus:='Critical'
        else
          if (PS.BatteryFlag or 8)=8 then
            FBatteryChargeStatus:='Charging'
          else
            if (PS.BatteryFlag or 128)=128 then
              FBatteryChargeStatus:='No Battery'
            else
              FBatteryChargeStatus:='Unknown';
    FBatteryLifePercent:=PS.BatteryLifePercent;
    FBatteryLifeTime:=PS.BatteryLifeTime;
    FBatteryLifeFullTime:=PS.BatteryFullLifeTime;
  end;
end;

procedure TAPM.Report(var sl: TStringList);
begin
  with sl do begin
    add('AC Power Status: '+ACPowerStatus);
    add('Battrey Charge Status: '+BatteryChargeStatus);
    if BatteryLifePercent<=100 then begin
      add('Battrey Life Full Time: '+formatseconds(BatteryLifeFullTime,true,false,false));
      add('Battery Life Time: '+formatseconds(BatteryLifeTime,true,false,false));
    end;
  end;
end;

{ TDirectX }

constructor TDirectX.Create;
begin
  inherited;
  FDirect3D:=TStringlist.Create;
  FDirectPlay:=TStringlist.Create;
  FDirectMusic:=TStringlist.Create;
end;

destructor TDirectX.Destroy;
begin
  FDirect3D.Free;
  FDirectPlay.Free;
  FDirectMusic.Free;
  inherited;
end;

procedure TDirectX.GetInfo;
var
  bdata :pchar;
  sl :tstringlist;
  i :integer;
const
  rkDirectX = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\DirectX';
    rvDXVersionNT = 'InstalledVersion';
    rvDXVersion95 = 'Version';
  rkDirect3D = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Direct3D\Drivers';
  rkDirectPlay = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\DirectPlay\Services';
  rkDirectMusic = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\DirectMusic\SoftwareSynths';
    rvDesc = 'Description';
begin
  with TRegistry.Create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if openkey(rkDirectX,false) then begin
      bdata:=stralloc(255);
      if valueexists(rvDXVersion95) then
        FVersion:=readstring(rvDXVersion95);
      if FVersion='' then
        if valueexists(rvDXVersionNT) then
          try
            readbinarydata(rvDXVersionNT,bdata^,4);
            FVersion:=inttostr(lo(integer(bdata^)))+'.'+inttostr(hi(integer(bdata^)));
          except
            {$IFDEF D4PLUS}
            try
              readbinarydata(rvDXVersionNT,bdata^,8);
              FVersion:=inttostr(lo(integer(bdata^)))+'.'+inttostr(hi(integer(bdata^)));
            except
            end;
            {$ENDIF}
          end;
      closekey;
      strdispose(bdata);
    end;
    FDirect3D.Clear;
    FDirectPlay.Clear;
    FDirectMusic.Clear;
    sl:=tstringlist.create;
    if openkey(rkDirect3D,false) then begin
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if openkey(rkDirect3D+'\'+sl[i],false) then begin
          if valueexists(rvDesc) then
            FDirect3D.Add(readstring(rvDesc));
          closekey;
        end;
    end;
    if openkey(rkDirectPlay,false) then begin
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if openkey(rkDirectPlay+'\'+sl[i],false) then begin
          if valueexists(rvDesc) then
            FDirectPlay.Add(readstring(rvDesc));
          closekey;
        end;
    end;
    if openkey(rkDirectMusic,false) then begin
      getkeynames(sl);
      closekey;
      for i:=0 to sl.count-1 do
        if openkey(rkDirectMusic+'\'+sl[i],false) then begin
          if valueexists(rvDesc) then
            FDirectMusic.Add(readstring(rvDesc));
          closekey;
        end;
    end;
    sl.free;
    free;
  end;
end;


procedure TDirectX.Report(var sl: TStringList);
begin
  with sl do begin
    if Version<>'' then begin
      add('Installed version: '+Version);
      add('');
      add('Direct3D:');
      addstrings(Direct3D);
      add('');
      add('DirectPlay:');
      addstrings(DirectPlay);
      add('');
      add('DirectMusic:');
      addstrings(DirectMusic);
    end else
      add('Not installed.');
  end;   
end;

{ TMSystemInfo }

constructor TMSystemInfo.Create(AOwner: TComponent);
begin
  inherited;
  FAbout:=cAbout;
  FCPU:=TCPU.Create;
  FMemory:=TMemory.Create;
  FOS:=TOperatingSystem.Create;
  FDisk:=TDisk.Create;
  FWorkstation:=TWorkstation.Create;
  FNetwork:=TNetwork.Create;
  FVideo:=TVideo.Create;
  FMedia:=TMedia.Create;
  FDevices:=TDevices.Create;
  FEngines:=TEngines.Create;
  FAPM:=TAPM.Create;
  FDirectX:=TDirectX.Create;
  Refresh;
end;

destructor TMSystemInfo.Destroy;
begin
  FCPU.Free;
  FMemory.Free;
  FOS.Free;
  FDisk.Free;
  FWorkstation.Free;
  FNetwork.Free;
  FVideo.Free;
  FMedia.Free;
  FDevices.Free;
  FEngines.Free;
  FAPM.Free;
  FDirectX.Free;
  inherited;
end;

procedure TMSystemInfo.Refresh;
begin
  CPU.GetInfo;
  Memory.GetInfo;
  OS.GetInfo;
  Disk.GetInfo;
  Disk.Drive:=copy(OS.WinDir,1,2);
  FWorkstation.GetInfo;
  FNetwork.GetInfo;
  FVideo.GetInfo;
  FMedia.GetInfo;
  FDevices.GetInfo;
  FEngines.GetInfo;
  FAPM.GetInfo;
  FDirectX.GetInfo;
end;

procedure TMSystemInfo.Report(var sl: TStringList);
begin
  sl.add(About);
  sl.add('');
  sl.add('Workstation');
  sl.add('-----------');
  Workstation.Report(sl);
  sl.add('');
  sl.add('Operating System');
  sl.add('----------------');
  OS.Report(sl);
  sl.add('');
  sl.add('CPU');
  sl.add('---');
  CPU.Report(sl);
  sl.add('');
  sl.add('Memory');
  sl.add('------');
  Memory.Report(sl);
  sl.add('');
  sl.add('Display');
  sl.add('-------');
  Video.Report(sl);
  sl.add('');
  sl.add('Advanced Power Management');
  sl.add('-------------------------');
  APM.Report(sl);
  sl.add('');
  sl.add('Media');
  sl.add('-----');
  Media.Report(sl);
  sl.add('');
  sl.add('Network');
  sl.add('-------');
  Network.Report(sl);
  sl.add('');
  sl.add('Devices');
  sl.add('-------');
  Devices.Report(sl);
  sl.add('');
  sl.add('Engines');
  sl.add('-------');
  Engines.Report(sl);
  sl.add('');
  sl.add('DirectX');
  sl.add('-------');
  DirectX.Report(sl);
  sl.add('');
  sl.add('Drives');
  sl.add('------');
  Disk.Report(sl);
end;

procedure TMSystemInfo.SetAbout(const Value: string);
begin
end;

initialization
  IsNT:=IsOSNT;
  IS95:=IsOS95;
  Is98:=IsOS98;
  Is2000:=IsOS2000;
  IsOSR2:=IsOSOSR2;
  WindowsUser:=GetUser;
  MachineName:=GetMachine;
  Platform:=GetPlatform;
end.


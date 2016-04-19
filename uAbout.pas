unit uAbout;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ExtCtrls, Dialogs, Jpeg, Registry;

const
  KeyPath   = 'SOFTWARE\Microsoft\Windows\CurrentVersion';
  User      = 'RegisteredOwner';
  Company   = 'RegisteredOrganization';
  NTKeyPath = 'SOFTWARE\Microsoft\windows NT\CurrentVersion';
  Ver       = '个人版';
type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    BitBtn1: TBitBtn;
    Bevel1: TBevel;
    lbl_Os: TLabel;
    lbl_Memory: TLabel;
    Panel2: TPanel;
    Image1: TImage;
    Others: TLabel;
    Author: TLabel;
    Bevel2: TBevel;
    lbl_User: TLabel;
    lbl_Company: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  { Private declarations }
    procedure GetOSInfo;     //系统信息程序
    Procedure GetMemoryInfo; //可用资源程序
  public
  { Public declarations }
end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

Procedure TfrmAbout.GetMemoryInfo ;//可用资源
var
  MS: TMemoryStatus;
begin
  MS.dwLength := SizeOf(TMemoryStatus);
  GlobalMemoryStatus(MS);
  lbl_Memory.Caption := lbl_Memory.Caption + FormatFloat('#,###" KB"',MS.dwTotalPhys div 1024);
end;

procedure TfrmAbout.GetOSInfo; //获取系统信息
var
  platInfo: string;
  BuildNumber: Integer;
begin
  case Win32Platform of
  VER_PLATFORM_WIN32_WINDOWS:
    begin
      platInfo := 'Windows 95';
      BuildNumber := Win32BuildNumber and $0000FFFF;
    end;

  VER_PLATFORM_WIN32_NT:
    begin
      platInfo := 'Windows NT';
      BuildNumber := Win32BuildNumber;
    end;
    else
    begin
      platInfo := 'Windows';
      BuildNumber := 0;
    end;
  end;

  if(Win32Platform = VER_PLATFORM_WIN32_WINDOWS)
    or(Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    if Win32CSDVersion = '' then
      lbl_OS.Caption := lbl_OS.Caption + Format('%s%s          %d.%d (Build %d)', [platInfo, #13, Win32MajorVersion, Win32MinorVersion, BuildNumber])
    else
      lbl_OS.Caption := lbl_OS.Caption + Format('%s%s          %d.%d (Build %d: %s)', [platInfo, #13, Win32MajorVersion, Win32MinorVersion, BuildNumber, Win32CSDVersion]);
  end
  else
    lbl_OS.Caption := lbl_OS.Caption + Format('%s%s          %d.%d', [platInfo, #13, Win32MajorVersion, Win32MinorVersion])
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  try
    Caption := '关于' + Application.Title;
    ProgramIcon.Picture.Icon := Application.Icon;
    ProductName.Caption := ProductName.Caption + Application.Title;
    Version.Caption   := Version.Caption + Ver;
    Copyright.Caption := Copyright.Caption + '刀剑如梦软件创作室';
    Author.Caption := Author.Caption + '刀剑如梦';
    Others.Caption := '警告：未经允许，任何个人、单位可以以任何方式非法拷贝、盗用！'+
                      '但是，系统在运行过程中出现的任何问题作者将不负任何连带责任！'+#13+#13+
                      '程序运行于WinAny！';
    //初始化---------------------------
    GetMemoryInfo;
    GetOsinfo;
  except
    MessageBox(Handle,'无法取得某些信息','提示',MB_OK);
  end;
end;

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmAbout.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure  GetUserInfo(var UserName, CompanyName: string);
var
  MyReg: TRegistry;
begin
  MyReg := TRegistry.Create;
  MyReg.RootKey := HKEY_LOCAL_MACHINE;
  MyReg.OpenKey(KeyPath,False);
  if not MyReg.ValueExists(User) or not MyReg.ValueExists(Company) then begin
    MyReg.CloseKey;
    MyReg.OpenKey(NTKeyPath, False);
  end;
  UserName    := MyReg.ReadString(User);
  CompanyName := MyReg.ReadString(Company);
  MyReg.CloseKey;
  MyReg.Free;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
var
  UserName, CompanyName: string;
begin
  GetUserInfo(UserName,CompanyName);
  lbl_User.Caption    := UserName;
  lbl_Company.Caption := CompanyName;
end;

end.


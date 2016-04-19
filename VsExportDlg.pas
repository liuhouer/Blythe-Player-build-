{*****************************************************}
{                                                     }
{     Varian Skin Factory                             }
{                                                     }
{     Varian Software NL (c) 1996-2001                }
{     All Rights Reserved                             }
{                                                     }
{ ****************************************************}

unit VsExportDlg;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IniFiles, VsSkin, VsConst;

type
  TVsExportDialog = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    btnOpen: TButton;
    RadioGroup1: TRadioGroup;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure btnSaveClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FFileName: string;
    procedure ReadIni;
    procedure WriteIni;
  public
    Skin: TVsSkin;
  end;

var
  VsExportDialog: TVsExportDialog;

implementation

uses
  ShlObj, ActiveX;

{$R *.DFM}


procedure TVsExportDialog.FormCreate(Sender: TObject);
begin
  ReadIni;
end;

procedure TVsExportDialog.FormDestroy(Sender: TObject);
begin
  WriteIni;
end;

procedure TVsExportDialog.btnSaveClick(Sender: TObject);
begin
  SaveDialog.InitialDir := ExtractFilePath(FFileName);
  SaveDialog.FileName := ExtractFileName(FFileName);
  if SaveDialog.Execute then
  begin
    FFileName := SaveDialog.FileName;
    Skin.WriteSkin(FFileName, RadioGroup1.ItemIndex);
    Close;
  end;
end;

procedure TVsExportDialog.btnOpenClick(Sender: TObject);
begin
  OpenDialog.InitialDir := ExtractFilePath(FFileName);
  OpenDialog.FileName := ExtractFileName(FFileName);
  if OpenDialog.Execute then
  begin
    FFileName := OpenDialog.FileName;
    Skin.ReadSkin(FFileName);
    Close;
  end;
end;

procedure TVsExportDialog.ReadIni;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(VsLibIni);
  try
    FFileName := Ini.ReadString('Default', 'Export', '');
    RadioGroup1.ItemIndex := Ini.ReadInteger('Default', 'WriteMode', 0);
  finally
    Ini.Free;
  end;
end;

procedure TVsExportDialog.WriteIni;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(VsLibIni);
  try
    Ini.WriteString('Default', 'Export', FFileName);
    Ini.WriteInteger('Default', 'WriteMode', RadioGroup1.ItemIndex);
  finally
    Ini.Free;
  end;
end;

end.

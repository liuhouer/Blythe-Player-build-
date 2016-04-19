{*****************************************************}
{                                                     }
{     Varian Skin Factory                             }
{                                                     }
{     Varian Software NL (c) 1996-2001                }
{     All Rights Reserved                             }
{                                                     }
{ ****************************************************}

unit VsEditDlg;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VsGraphics, VsSysUtils, VsConst;

type
  TVsEditDialog = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    btnExecute: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ReadIni;
    procedure WriteIni;
  public
    Graphic: TVsGraphic;
    FileName: string;
    function Execute: Boolean;
  end;

var
  VsEditDialog: TVsEditDialog;

implementation

uses
  ShellAPI, IniFiles;

{$R *.DFM}

procedure TVsEditDialog.FormCreate(Sender: TObject);
begin
  ReadIni;
end;

procedure TVsEditDialog.ReadIni;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(VsLibIni);
  try
    Edit1.Text := Ini.ReadString('Default', 'Edit', 'C:\Program Files\Accessories\MSPAINT.EXE');
    Edit2.Text := Ini.ReadString('Default', 'Param', '%s');
    Edit1.Text := '"' + Edit1.Text + '"';
    Edit2.Text := '"' + Edit2.Text + '"';
  finally
    Ini.Free;
  end;
end;

procedure TVsEditDialog.WriteIni;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(VsLibIni);
  try
    Ini.WriteString('Default', 'Edit', Edit1.Text);
    Ini.WriteString('Default', 'Param', Edit2.Text);
  finally
    Ini.Free;
  end;
end;

function TVsEditDialog.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

procedure TVsEditDialog.btnExecuteClick(Sender: TObject);
var
  Cmd: string;
begin
  FileName := AddPathSlash(GetCurrentDir) + 'vsfe~.bmp';
  Graphic.Bitmap.SaveToFile(FileName);
  Cmd := Format(Edit2.Text, [FileName]);
  ShellExecute(0,'open', PChar(Edit1.Text), PChar(Cmd), nil, SW_SHOWNORMAL);
end;

procedure TVsEditDialog.btnOKClick(Sender: TObject);
begin
  Graphic.Bitmap.LoadFromFile(FileName);
end;

procedure TVsEditDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  WriteIni;
  DeleteFile(FileName);
end;


end.

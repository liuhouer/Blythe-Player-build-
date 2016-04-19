{*****************************************************}
{                                                     }
{     Varian Skin Factory                             }
{                                                     }
{     Varian Software NL (c) 1996-2001                }
{     All Rights Reserved                             }
{                                                     }
{ ****************************************************}

unit VsImageClipDlg;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ExtDlgs, Clipbrd;

type
  TVsImageClipDialog = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    Image: TImage;
    Button1: TButton;
    Button2: TButton;
    SavePictureDialog: TSavePictureDialog;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VsImageClipDialog: TVsImageClipDialog;

implementation

{$R *.DFM}

procedure TVsImageClipDialog.Button1Click(Sender: TObject);
begin
  if SavePictureDialog.Execute then
    Image.Picture.Bitmap.SaveToFile(SavePictureDialog.FileName);
end;

procedure TVsImageClipDialog.Button3Click(Sender: TObject);
var
  MyFormat: Word;
  Bitmap: TBitmap;
  AData: THandle;
  APalette: HPalette;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Assign(Image.Picture.Bitmap);
    Bitmap.SaveToClipBoardFormat(MyFormat, AData, APalette);
    ClipBoard.SetAsHandle(MyFormat, AData);
  finally
    Bitmap.Free;
  end;
end;


end.

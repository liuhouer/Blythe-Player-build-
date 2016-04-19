{*****************************************************}
{                                                     }
{     Varian Skin Factory                             }
{                                                     }
{     Varian Software NL (c) 1996-2001                }
{     All Rights Reserved                             }
{                                                     }
{ ****************************************************}

unit VsGraphicsDlg;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, ExtDlgs, VsGraphics,
  VsSysUtils;

type
  TVsGraphicsDialog = class(TForm)
    Panel1: TPanel;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    OpenPictureDialog: TOpenPictureDialog;
    btnAdd: TButton;
    btnDelete: TButton;
    btnClear: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    ListBox: TListBox;
    btnReplace: TButton;
    btnEdit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonMoveUpClick(Sender: TObject);
    procedure ButtonMoveDownClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure VrShadowButton9Click(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
  private
    procedure GraphicsChanged(Sender: TObject);
  public
    Graphics: TVsGraphics;
  end;


implementation

uses
  VsEditDlg, VsGraphicViewDlg;

const
  pfString: array[TPixelFormat] of string[15] =
    ('Device', '1bit', '4bit', '8bit', '15bit', '16bit',
     '24bit', '32bit', 'Custom');


{$R *.DFM}


procedure TVsGraphicsDialog.FormCreate(Sender: TObject);
begin
  Graphics := TVsGraphics.Create;
  Graphics.OnChange := GraphicsChanged;
end;

procedure TVsGraphicsDialog.FormDestroy(Sender: TObject);
begin
  Graphics.Free;
end;

procedure TVsGraphicsDialog.ButtonAddClick(Sender: TObject);
var
  Index: Integer;
  Graphic: TVsGraphic;
begin
  if OpenPictureDialog.Execute then
  begin
    Graphic := TVsGraphic.Create;
    try
      Graphic.Name := ExtractFileName(OpenPictureDialog.FileName);
      Graphic.Bitmap.LoadFromFile(OpenPictureDialog.FileName);
      Index := Graphics.Add(Graphic);
      ListBox.ItemIndex := Index;
    finally
      Graphic.Free;
    end;
    ListBox.Invalidate;
  end;
end;

procedure TVsGraphicsDialog.btnReplaceClick(Sender: TObject);
var
  Index: Integer;
  Graphic: TVsGraphic;
begin
  Index := ListBox.ItemIndex;
  if Index <> -1 then
    if OpenPictureDialog.Execute then
    begin
      Graphic := TVsGraphic.Create;
      try
        Graphic.Name := ExtractFileName(OpenPictureDialog.FileName);
        Graphic.Bitmap.LoadFromFile(OpenPictureDialog.FileName);
        Graphics[Index].Assign(Graphic);
      finally
        Graphic.Free;
      end;
      ListBox.Invalidate;
    end;
end;


procedure TVsGraphicsDialog.ListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  ImgRect: TRect;
  W, H, MidY: Integer;
  S: string;
  Image: TBitmap;
begin
  with TListBox(Control) do
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect);

    Image := Graphics[Index].Bitmap;
    W := MinInteger(62, Image.Width);
    H := MinInteger(62, Image.Height);
    ImgRect := Bounds(Rect.Left, Rect.Top + ((62 - H) div 2), W, H);
    Canvas.StretchDraw(ImgRect, Image);

    S := Format('%s - %d x %d (%s)', [Graphics[Index].Name,
                                      Graphics[Index].Bitmap.Width,
                                      Graphics[Index].Bitmap.Height,
                                      pfString[Graphics[Index].Bitmap.PixelFormat]]);
    MidY := ((Rect.Bottom - Rect.Top) - Canvas.TextHeight(S)) div 2;
    Canvas.TextOut(82, Rect.Top + MidY, S);
  end;
end;

procedure TVsGraphicsDialog.ButtonDeleteClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ListBox.ItemIndex;
  if Index <> -1 then
  begin
    Graphics.Delete(Index);
    ListBox.ItemIndex := IMax(0, Index-1);
  end;
  ListBox.Invalidate;
end;

procedure TVsGraphicsDialog.ButtonClearClick(Sender: TObject);
begin
  if MessageDlg('Clear list?', mtConfirmation,
    [mbOk, mbCancel], 0) = mrOk then Graphics.Clear;
end;

procedure TVsGraphicsDialog.ButtonMoveUpClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ListBox.ItemIndex;
  if Index - 1 >= 0 then
  begin
    Graphics.Move(Index, Index - 1);
    ListBox.ItemIndex := Index - 1;
  end;
end;

procedure TVsGraphicsDialog.ButtonMoveDownClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ListBox.ItemIndex;
  if (Index <> -1) and (Index + 1 < ListBox.Items.Count) then
  begin
    Graphics.Move(Index, Index + 1);
    ListBox.ItemIndex := Index + 1;
  end;
end;

procedure TVsGraphicsDialog.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TVsGraphicsDialog.GraphicsChanged(Sender: TObject);
var
  I: Integer;
begin
  ListBox.Items.BeginUpdate;
  try
    ListBox.Items.Clear;
    for I := 0 to Graphics.Count - 1 do
      ListBox.Items.Add('XXX');
  finally
    ListBox.Items.EndUpdate;
  end;
end;

procedure TVsGraphicsDialog.VrShadowButton9Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TVsGraphicsDialog.btnEditClick(Sender: TObject);
var
  Index: Integer;
  Graphic: TVsGraphic;
  EditDlg: TVsEditDialog;
begin
  Index := ListBox.ItemIndex;
  if Index = -1 then Exit;
  EditDlg := TVsEditDialog.Create(nil);
  try
    Graphic := TVsGraphic.Create;
    try
      Graphic.Assign(Graphics[Index]);
      EditDlg.Graphic := Graphic;
      if EditDlg.Execute then
      begin
        Graphics[Index].Assign(Graphic);
        ListBox.Refresh;
      end;
    finally
      Graphic.Free;
    end;
  finally
    EditDlg.Free;
  end;
  ListBox.Invalidate;
end;

procedure TVsGraphicsDialog.ListBoxDblClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ListBox.ItemIndex;
  if Index = -1 then Exit;
  VsGraphicViewDialog := TVsGraphicViewDialog.Create(nil);
  try
    VsGraphicViewDialog.Image1.Picture.Assign(Graphics[Index].Bitmap);
    VsGraphicViewDialog.ShowModal;
  finally
    VsGraphicViewDialog.Free;
  end;
end;

end.

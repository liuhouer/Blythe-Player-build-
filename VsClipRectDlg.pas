unit VsClipRectDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, VsClasses;

type
  TVsClipRectDialog = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    Image1: TImage;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    Button3: TButton;
    Button4: TButton;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    Bitmap: TBitmap;
    Drawing: Boolean;
    Origin, MovePt: TPoint;
    ClipRect: TVsClipRect;
    procedure DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
  public
    procedure SetBitmap(Value: TBitmap);
    procedure SetClipRect(Value: TVsClipRect);
  end;

var
  VsClipRectDialog: TVsClipRectDialog;

implementation

{$R *.DFM}


procedure TVsClipRectDialog.FormCreate(Sender: TObject);
begin
  Bitmap := TBitmap.Create;
end;

procedure TVsClipRectDialog.FormDestroy(Sender: TObject);
begin
  Bitmap.Free;
end;

procedure TVsClipRectDialog.DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
begin
  with Image1.Canvas do
  begin
    Pen.Mode := AMode;
    Pen.Color := clRed;
    Brush.Style := bsClear;
    Image1.Canvas.Rectangle(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y);
  end;
end;

procedure TVsClipRectDialog.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TVsClipRectDialog.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1.Picture.Bitmap.Assign(Bitmap);
  Drawing := True;
  Image1.Canvas.MoveTo(X, Y);
  Origin := Point(X, Y);
  MovePt := Origin;
end;

procedure TVsClipRectDialog.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Drawing then
  begin
    Image1.Picture.Bitmap.Assign(Bitmap);
    MovePt := Point(X, Y);
    DrawShape(Origin, MovePt, pmCOPY);
  end;
end;

procedure TVsClipRectDialog.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  if Drawing then
  begin
    MovePt := Point(X, Y);

    if (X < Origin.X) or (Y < Origin.Y) then
    begin
      P := MovePt;
      MovePt := Origin;
      Origin := P;
    end;

    Image1.Picture.Bitmap.Assign(Bitmap);
    DrawShape(Origin, MovePt, pmCOPY);

    UpDown1.Position := Origin.X;
    UpDown2.Position := Origin.Y;
    UpDown3.Position := MovePt.X - Origin.X;
    UpDown4.Position := MovePt.Y - Origin.Y;

    Drawing := False;
  end;
end;

procedure TVsClipRectDialog.Edit1Change(Sender: TObject);
begin
  if Drawing then Exit;
  Image1.Picture.Bitmap.Assign(Bitmap);
  Origin.X := UpDown1.Position;
  Origin.Y := UpDown2.Position;
  MovePt.X := Origin.X + UpDown3.Position;
  MovePt.Y := Origin.Y + UpDown4.Position;
  DrawShape(Origin, MovePt, pmCOPY);
end;

procedure TVsClipRectDialog.SetClipRect(Value: TVsClipRect);
begin
  ClipRect := Value;
  UpDown1.Position := ClipRect.Left;
  UpDown2.Position := ClipRect.Top;
  UpDown3.Position := ClipRect.Width;
  UpDown4.Position := ClipRect.Height;
  Edit1Change(Edit1);
end;

procedure TVsClipRectDialog.SetBitmap(Value: TBitmap);
begin
  Bitmap.Assign(Value);
end;

procedure TVsClipRectDialog.Button1Click(Sender: TObject);
begin
  ClipRect.Left := UpDown1.Position;
  ClipRect.Top := UpDown2.Position;
  ClipRect.Width := UpDown3.Position;
  ClipRect.Height := UpDown4.Position;
end;

procedure TVsClipRectDialog.Button3Click(Sender: TObject);
begin
  SetClipRect(ClipRect);
end;

procedure TVsClipRectDialog.Button4Click(Sender: TObject);
begin
  UpDown1.Position := 0;
  UpDown2.Position := 0;
  UpDown3.Position := Bitmap.Width;
  UpDown4.Position := Bitmap.Height;
end;

end.

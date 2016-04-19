unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,untWaterEffect, OBMagnet;

type
  TForm4 = class(TForm)
    Img1: TImage;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Button1: TButton;
    tmr1: TTimer;
    OBFormMagnet1: TOBFormMagnet;
    procedure tmr1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Img1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     Water: TWaterEffect;  Bmp: TBitmap;

 //   procedure WMWINDOWPOSCHANGING(Var Msg: TWMWINDOWPOSCHANGING);message WM_WINDOWPOSCHANGING;
    ///////////////磁性窗体

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  x:integer;
implementation

uses Unit3, Unit1;

{$R *.dfm}
//------------------------实现磁性窗体--------------------------------------
{procedure TForm4.WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING);
var
WorkDound: TRect;
remove : Word;
begin
remove :=80; //可随意设置，是磁性的范围大小。
WorkDound.Left:=form1.left;
WorkDound.Top:=form1.Top;
WorkDound.Right:=form1.left+form1.Width;
WorkDound.Bottom:=form1.Top+form1.Height;
with Msg.WindowPos^ do
begin
    if (x+cx<WorkDound.Left+remove) then    //左方具有磁性
      if (x+cx>WorkDound.Left-remove)or((x+cx>WorkDound.Left) and (x+cx<WorkDound.Left+remove)) then
        begin
          x:=WorkDound.Left-cx;
        end;
    if (x>WorkDound.Right-remove) then   //右方具有磁性
      if (x<WorkDound.Right+remove)or((x<WorkDound.Right) and (x>WorkDound.Right-remove)) then
        begin
          x:=WorkDound.Right;
        end;
    if (y+cy<WorkDound.Top+remove) then    //上方具有磁性
      if (y+cy>WorkDound.Top-remove)or((y+cy>WorkDound.Top) and (y+cy<WorkDound.Top+remove)) then
        begin
          y:= WorkDound.Top-cy;
        end;
    if (y>WorkDound.Bottom-remove) then   //下方具有磁性
      if (y<WorkDound.Bottom+remove)or((y<WorkDound.Bottom) and (y>WorkDound.Bottom-remove)) then
        begin
          y:= WorkDound.Bottom;
        end;
end;
inherited;
end;   }
//---------------------------------实现磁性窗体-------------------------------------------------

procedure TForm4.tmr1Timer(Sender: TObject);
begin
   if Random(8)= 1 then
    Water.Blob(-1,-1,Random(1)+1,Random(500)+50);
  Water.Render(Bmp,img1.Picture.Bitmap);



  with img1.Canvas do
    begin
      Brush.Style:=bsClear;
      font.size:=50;
//      Font.Style:=[fsBold];
//      Font.Name := '隶书';
      font.color:=$FFFFFF;
      TextOut((Bmp.Width - TextWidth(''))div 2+2,
        10,'');
    end;
end;

procedure TForm4.FormDestroy(Sender: TObject);
begin
  Bmp.Free;
  Water.Free;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
//self.ScreenSnap:=True;
//self.SnapBuffer:=30;//窗体吸附效果
   Bmp := TBitmap.Create;
  Bmp.Assign(img1.Picture.Graphic);
  img1.Picture.Graphic := nil;
  img1.Picture.Bitmap.Height := Bmp.Height;
  img1.Picture.Bitmap.Width := Bmp.Width;
  Water := TWaterEffect.Create;
  Water.SetSize(Bmp.Width,Bmp.Height);

  x:=img1.Height;
end;

procedure TForm4.Img1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
Water.Blob(x,y,5,10000);
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
close;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
 form4.Left:=Form1.Left+form1.Width;
  Form4.Top:=Form1.Top+form3.Height ;
AnimateWindow(Form4.Handle,800,AW_BLEND);
end;

end.

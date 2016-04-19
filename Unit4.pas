unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,untWaterEffect, OBMagnet, jpeg;

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
self.ScreenSnap:=True;
self.SnapBuffer:=30;//窗体吸附效果
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
 form4.Left:=mainplay.Left+mainplay.Width;
  Form4.Top:=mainplay.Top;
AnimateWindow(Form4.Handle,800,AW_BLEND);
end;

end.

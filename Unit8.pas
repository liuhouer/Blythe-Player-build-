unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  Tminilrc = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2Timer(Sender: TObject);
  private
  bmp:TBitmap;
    nPerent:Integer;
    { Private declarations }
  public
  procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    { Public declarations }
  end;

var
  minilrc: Tminilrc;

implementation

{$R *.dfm}

procedure Tminilrc.Timer1Timer(Sender: TObject);
var
  str: string;
  tmpWidth:Integer;
begin
  str := label1.Caption;


  ClientWidth := Canvas.TextWidth(str);
  ClientHeight := Canvas.TextHeight(str);
 
  bmp.Width := ClientWidth;
  bmp.Height := ClientHeight;
  bmp.Canvas.Lock;
  bmp.Canvas.Brush.Color := clblack;
  bmp.Canvas.FillRect(ClientRect);
  bmp.Canvas.Brush.Style := bsClear;
//  bmp.Canvas.Font.Color := clRed;
//  bmp.Canvas.TextOut(1, 1, str);
  bmp.Canvas.Font.Color := clYellow;
  bmp.Canvas.TextOut(0, 0, str);
  bmp.Canvas.Unlock;

 Canvas.Lock;

  Canvas.Brush.Color := clblack;
  Canvas.FillRect(ClientRect);
  Canvas.Brush.Style := bsClear;
//  Canvas.Font.Color := clYellow;
//  Canvas.TextOut(1, 1, str);
  Canvas.Font.Color := clgreen;
  Canvas.TextOut(0, 0, str);
  Canvas.Brush.Style := bsSolid;
  tmpWidth:=Round(ClientWidth / 100 * nPerent);
  Canvas.CopyRect(Rect(0,0,tmpWidth,ClientHeight),bmp.Canvas,Rect(0,0,tmpWidth,ClientHeight));
  Canvas.Unlock;

  Inc(nPerent);
  if nPerent = 101 then nPerent := 0;

end;

procedure Tminilrc.FormCreate(Sender: TObject);
begin
minilrc.Left:=round((screen.Width-ClientWidth)/2);
minilrc.Top:=screen.Height-Clientheight-6;
FormStyle := fsStayOnTop;
  BorderStyle := bsNone;
  TransparentColor := True;
  TransparentColorValue := Color;

  Font.Size := 20;
  Font.Name := 'Arial Black';
  nPerent:=0;

  bmp := TBitmap.Create;
  bmp.Canvas.Font.Assign(Font);
end;

procedure Tminilrc.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key = Chr(27) then Close;
end;

procedure Tminilrc.WMNCHitTest(var Message: TWMNCHitTest);
begin
Message.Result := HTCAPTION;
end;
procedure Tminilrc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
bmp.Free;
end;

procedure Tminilrc.Timer2Timer(Sender: TObject);
begin
if length(label1.Caption)=0 then
begin
label1.Caption:='music......'  ;
end;

end;

end.

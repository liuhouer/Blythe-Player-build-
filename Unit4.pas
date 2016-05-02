unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, OBMagnet, jpeg;

type
  Tabout = class(TForm)
    Img1: TImage;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    tmr1: TTimer;
    OBFormMagnet1: TOBFormMagnet;
    procedure tmr1Timer(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Img1Click(Sender: TObject);
  private



    { Private declarations }
  public
    { Public declarations }
  end;

var
  about: Tabout;
  x:integer;
implementation

uses Unit3, Unit1;

{$R *.dfm}

procedure Tabout.tmr1Timer(Sender: TObject);
begin

    label3.Top:=label3.Top-1;
    if label3.Top<=-label3.Height then
    begin
     label3.Top:=about.Height-40;
    end;
end;



procedure Tabout.FormCreate(Sender: TObject);
begin
self.ScreenSnap:=True;
self.SnapBuffer:=30;//´°ÌåÎü¸½Ð§¹û

  label3.Top:=about.Height-label3.Height;
end;



procedure Tabout.Button1Click(Sender: TObject);
begin
close;
end;

procedure Tabout.FormShow(Sender: TObject);
begin
 about.Left:=mainplay.Left+mainplay.Width;
  about.Top:=mainplay.Top;
AnimateWindow(about.Handle,800,AW_BLEND);
end;

procedure Tabout.Img1Click(Sender: TObject);
begin
close;
end;

end.

unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VsControls, VsSkin, VsHotSpot, VsComposer, RzTray,MPlayer,
  ExtCtrls, SkyAudioMeter;

type
  Tminiplay = class(TForm)
    VsComposer1: TVsComposer;
    VsSkin1: TVsSkin;
    vsleft: TVsHotSpot;
    vsplay: TVsHotSpot;
    vsright: TVsHotSpot;
    vsmin: TVsHotSpot;
    am1: TSkyAudioMeter;
    wave: TTimer;
    vsback: TVsHotSpot;
    vsclose: TVsHotSpot;
    procedure vsleftClick(Sender: TObject);
    procedure vsbackClick(Sender: TObject);
    procedure vscloseClick(Sender: TObject);
    procedure vsplayClick(Sender: TObject);
    procedure vsrightClick(Sender: TObject);
    procedure vsminClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  
    procedure FormShow(Sender: TObject);
    procedure waveTimer(Sender: TObject);
    procedure am1Click(Sender: TObject);
    procedure VsSkin1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  miniplay: Tminiplay;

implementation

uses Unit1, Unit2, Unit3;

{$R *.dfm}

procedure Tminiplay.vsleftClick(Sender: TObject);
begin
 mainplay.btn4Click(sender);

end;

procedure Tminiplay.vsbackClick(Sender: TObject);
begin
miniplay.close;
mainplay.Left:=(screen.Width-mainplay.Width) div 2;
playlist.left:= (screen.Width-mainplay.Width) div 2;
mainplay.show;
playlist.show;
end;

procedure Tminiplay.vscloseClick(Sender: TObject);
begin
 am1.Close;
 am1.Free;
 mainplay.rztray.Destroy;
  mainplay.rztray.Free;
 mainplay.SkyAudioMeter1.Close;
 mainplay.SkyAudioMeter1.free;
 Application.Terminate;
 mainplay.Close;


end;

procedure Tminiplay.vsplayClick(Sender: TObject);
begin

if vsplay.GraphicName ='play.bmp' then
begin
mainplay.btn1Click(sender);   //当主form不可视时不能应用 sender  2012.4.2--小布


vsplay.GraphicName:='pause.bmp';
end
else
begin
mainplay.btn2Click(sender);
vsplay.GraphicName:='play.bmp';
end;
end;

procedure Tminiplay.vsrightClick(Sender: TObject);
begin
mainplay.btn5Click(sender); 
end;

procedure Tminiplay.vsminClick(Sender: TObject);
begin
mainplay.VsHotSpot1click(sender);
end;

procedure Tminiplay.FormCreate(Sender: TObject);
begin

self.ScreenSnap:=True;
self.SnapBuffer:=30;//窗体吸附效果

end;



procedure Tminiplay.FormShow(Sender: TObject);
begin
wave.Enabled:=true;
end;

procedure Tminiplay.waveTimer(Sender: TObject);
begin
if mainplay.MediaPlayer1.Mode in [mpplaying] then
begin
am1.Active:=true  ;
am1.FreqWidth:=1 div 10
end else
am1.Active:=false;

end;

procedure Tminiplay.am1Click(Sender: TObject);
begin
if am1.AMStyle =smsOscillograph then
am1.AMStyle:=smsSpectrum     //(频谱)
else
am1.AMStyle:=smsOscillograph;
end;

procedure Tminiplay.VsSkin1DblClick(Sender: TObject);
begin
vsbackclick(sender);
end;

end.

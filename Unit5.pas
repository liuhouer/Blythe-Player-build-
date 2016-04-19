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
    vsback: TVsHotSpot;
    vsclose: TVsHotSpot;
    yhcpu: TTimer;
    am1: TSkyAudioMeter;
    wave: TTimer;
    procedure vsleftClick(Sender: TObject);
    procedure vsbackClick(Sender: TObject);
    procedure vscloseClick(Sender: TObject);
    procedure vsplayClick(Sender: TObject);
    procedure vsrightClick(Sender: TObject);
    procedure vsminClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure yhcpuTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure waveTimer(Sender: TObject);
    procedure am1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  miniplay: Tminiplay;

implementation

uses Unit1;

{$R *.dfm}

procedure Tminiplay.vsleftClick(Sender: TObject);
begin
form1.btn4click(sender);
end;

procedure Tminiplay.vsbackClick(Sender: TObject);
begin
miniplay.close;
form1.AlphaBlendValue:=255;
end;

procedure Tminiplay.vscloseClick(Sender: TObject);
begin
 Application.Terminate;

end;

procedure Tminiplay.vsplayClick(Sender: TObject);
begin

if vsplay.GraphicName ='mplay.bmp' then
begin
form1.btn1Click(sender);
vsplay.GraphicName:='mpause.bmp';
end
else
begin
form1.btn2Click(sender);
vsplay.GraphicName:='mplay.bmp';
end;
end;

procedure Tminiplay.vsrightClick(Sender: TObject);
begin
form1.btn5click(sender);
end;

procedure Tminiplay.vsminClick(Sender: TObject);
begin
windowstate:=wsminimized;
end;

procedure Tminiplay.FormCreate(Sender: TObject);
begin

self.ScreenSnap:=True;
self.SnapBuffer:=30;//窗体吸附效果

end;

procedure Tminiplay.yhcpuTimer(Sender: TObject);
begin


    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    //释放物理内存
    Application.ProcessMessages;

end;

procedure Tminiplay.FormShow(Sender: TObject);
begin
wave.Enabled:=true;
end;

procedure Tminiplay.waveTimer(Sender: TObject);
begin
if form1.MediaPlayer1.Mode in [mpplaying] then
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

end.

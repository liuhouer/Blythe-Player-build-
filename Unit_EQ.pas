unit Unit_EQ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, slider, Bass, StdCtrls;

type
  TFrm_EQ = class(TForm)
    Slider1: TSlider;
    Slider2: TSlider;
    Slider3: TSlider;
    Slider4: TSlider;
    Slider5: TSlider;
    Slider6: TSlider;
    Slider7: TSlider;
    Slider8: TSlider;
    Slider9: TSlider;
    Slider10: TSlider;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure EQSliderChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    function SetAEQGain(BandNum : integer; EQGain : single) : boolean;
  public
    { Public declarations }
    procedure ResetEQ;
  end;

var
  Frm_EQ: TFrm_EQ;

var
  p: BASS_FXPARAMEQ;
  pR: BASS_FXREVERB;
  fx: array[1..10] of integer;

implementation

uses Unit_Main;

{$R *.dfm}

function TFrm_EQ.SetAEQGain(BandNum: integer; EQGain: single): boolean;
begin

end;

procedure TFrm_EQ.EQSliderChange(Sender: TObject);
begin
    BASS_FXGetParameters(fx[(Sender as TSlider).Tag], @p);
    p.fgain := (Sender as TSlider).Value-15;
    BASS_FXSetParameters(fx[(Sender as TSlider).Tag], @p);
end;

procedure TFrm_EQ.FormCreate(Sender: TObject);
begin
//  BASS_SetConfig(BASS_CONFIG_BUFFER,1000);
end;

procedure TFrm_EQ.ResetEQ;
begin
  fx[1] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);
  fx[2] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);
  fx[3] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);
  fx[4] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);
  fx[5] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);
  fx[6] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);
  fx[7] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);
  fx[8] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);
  fx[9] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);
  fx[10] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_PARAMEQ, 1);


 // fx[4] := BASS_ChannelSetFX(Frm_Player.strs[0], BASS_FX_REVERB, 1);
    p.fGain := 0;
    p.fBandwidth := 18;
    p.fCenter := 31;
    BASS_FXSetParameters(fx[1], @p);
    p.fCenter := 62;
    BASS_FXSetParameters(fx[2], @p);
    p.fCenter := 125;
    BASS_FXSetParameters(fx[3], @p);
    p.fCenter := 250;
    BASS_FXSetParameters(fx[4], @p);
    p.fCenter := 500;
    BASS_FXSetParameters(fx[5], @p);
    p.fCenter := 1000;
    BASS_FXSetParameters(fx[6], @p);
    p.fCenter := 2000;
    BASS_FXSetParameters(fx[7], @p);
    p.fCenter := 4000;
    BASS_FXSetParameters(fx[8], @p);
    p.fCenter := 8000;
    BASS_FXSetParameters(fx[9], @p);
    p.fCenter := 16000;
    BASS_FXSetParameters(fx[10], @p);
    //ASS_FXGetParameters(fx[4], @pR);
    //pR.fReverbMix := -96;
    //pR.fReverbTime := 1200;
    //pR.fHighFreqRTRatio := 0.1;
    //BASS_FXSetParameters(fx[4], @pR);
    // play both MOD and stream, it must be one of them! :)
    BASS_ChannelPlay(Frm_Player.strs[0], False);
end;

procedure TFrm_EQ.Button2Click(Sender: TObject);
var
  i:integer;
begin
  for i:=1 to 10 do
  begin
    BASS_FXGetParameters(fx[i], @p);
    p.fgain := 0;
    BASS_FXSetParameters(fx[i], @p);

  end;
end;

procedure TFrm_EQ.Button1Click(Sender: TObject);
begin
    BASS_FXGetParameters(fx[1], @p);
    p.fgain := Slider1.Value-15;
    BASS_FXSetParameters(fx[1], @p);
    BASS_FXGetParameters(fx[2], @p);
    p.fgain := Slider2.Value-15;
    BASS_FXSetParameters(fx[2], @p);
    BASS_FXGetParameters(fx[3], @p);
    p.fgain := Slider3.Value-15;
    BASS_FXSetParameters(fx[3], @p);
    BASS_FXGetParameters(fx[4], @p);
    p.fgain := Slider4.Value-15;
    BASS_FXSetParameters(fx[4], @p);
    BASS_FXGetParameters(fx[5], @p);
    p.fgain := Slider5.Value-15;
    BASS_FXSetParameters(fx[5], @p);
    BASS_FXGetParameters(fx[6], @p);
    p.fgain := Slider6.Value-15;
    BASS_FXSetParameters(fx[6], @p);
    BASS_FXGetParameters(fx[7], @p);
    p.fgain := Slider7.Value-15;
    BASS_FXSetParameters(fx[7], @p);
    BASS_FXGetParameters(fx[8], @p);
    p.fgain := Slider8.Value-15;
    BASS_FXSetParameters(fx[8], @p);
    BASS_FXGetParameters(fx[9], @p);
    p.fgain := Slider9.Value-15;
    BASS_FXSetParameters(fx[9], @p);
    BASS_FXGetParameters(fx[10], @p);
    p.fgain := Slider10.Value-15;
    BASS_FXSetParameters(fx[10], @p);
end;

procedure TFrm_EQ.Button3Click(Sender: TObject);
var
  i:integer;
begin
  for i:=1 to 10 do
  begin
    BASS_FXGetParameters(fx[i], @p);
    p.fgain := 0;
    caption:=booltostr(BASS_FXSetParameters(fx[i], @p),True);

  end;
  Slider1.Value:=15;
  Slider2.Value:=15;
  Slider3.Value:=15;
  Slider4.Value:=15;
  Slider5.Value:=15;
  Slider6.Value:=15;
  Slider7.Value:=15;
  Slider8.Value:=15;
  Slider9.Value:=15;
  Slider10.Value:=15;
end;

end.

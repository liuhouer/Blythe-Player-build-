unit config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AudioObject, DrawUtils, ComCtrls, ExtCtrls, OBMagnet;

type
  TFormConfig = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    ComboDevice: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    BuffComboBox: TComboBox;
    ComboFreq: TComboBox;
    PriorityComboBox: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    BtnClose: TButton;
    InvTimeCheckBox: TCheckBox;
    NumPLCheckBox: TCheckBox;
    NoneDrawCheck: TRadioButton;
    WaveDrawCheck: TRadioButton;
    FpsBar: TTrackBar;
    LabelFrames: TLabel;
    FFTDrawCheck: TRadioButton;
    PLClearCheck: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    MoveCheck: TCheckBox;
    OBFormMagnet1: TOBFormMagnet;
    procedure BtnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboFreqChange(Sender: TObject);
    procedure ComboDeviceChange(Sender: TObject);
    procedure BuffComboBoxChange(Sender: TObject);
    procedure PriorityComboBoxChange(Sender: TObject);
    procedure NumPLCheckBoxClick(Sender: TObject);
    procedure FpsBarChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConfig: TFormConfig;

implementation

uses main, playlist;

{$R *.dfm}

procedure TFormConfig.BtnCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TFormConfig.FormCreate(Sender: TObject);
begin
  ComboDevice.Items.Assign(AudioObjectPlayer.AudioDevices);
  ComboDevice.Items.Insert(0, 'Default');
  ComboDevice.ItemIndex := 0;
  ComboFreq.ItemIndex := 2;
  PriorityComboBox.ItemIndex := 2;
  BuffComboBox.ItemIndex := 6;
end;

procedure TFormConfig.ComboFreqChange(Sender: TObject);
begin
 case ComboFreq.ItemIndex of
  0 : AudioObjectPlayer.OutFrequency := 96000;
  1 : AudioObjectPlayer.OutFrequency := 48000;
  2 : AudioObjectPlayer.OutFrequency := 44100;
  3 : AudioObjectPlayer.OutFrequency := 22050;
  4 : AudioObjectPlayer.OutFrequency := 11025;
 end;
end;

procedure TFormConfig.ComboDeviceChange(Sender: TObject);
begin
 AudioObjectPlayer.InitDevice(ComboDevice.ItemIndex - 1);
end;

procedure TFormConfig.BuffComboBoxChange(Sender: TObject);
begin
 case BuffComboBox.ItemIndex  of
  0 : AudioObjectPlayer.SetOutBufferLen(150);
  1 : AudioObjectPlayer.SetOutBufferLen(300);
  2 : AudioObjectPlayer.SetOutBufferLen(500);
  3 : AudioObjectPlayer.SetOutBufferLen(750);
  4 : AudioObjectPlayer.SetOutBufferLen(1000);
  5 : AudioObjectPlayer.SetOutBufferLen(1500);
  6 : AudioObjectPlayer.SetOutBufferLen(2000);
 end;
end;

procedure TFormConfig.PriorityComboBoxChange(Sender: TObject);
 var Val : Integer;
begin
 case PriorityComboBox.ItemIndex of
   0: Val := THREAD_PRIORITY_HIGHEST;
   1: Val := THREAD_PRIORITY_IDLE;
   2: Val := THREAD_PRIORITY_NORMAL;
   3: Val := THREAD_PRIORITY_TIME_CRITICAL;
 end;
   SetPriorityClass(GetCurrentProcess, Val);
   SetPriorityClass(Application.Handle, Val);
   SetPriorityClass(FormPlayer.Handle, Val);
   SetThreadPriority(GetCurrentThread, Val);
   SetThreadPriority(Application.Handle, Val);
   SetThreadPriority(FormPlayer.Handle, Val);
end;

procedure TFormConfig.NumPLCheckBoxClick(Sender: TObject);
begin
 DrawPlayList (100 - FormPlaylist.ListSlider.Position);
end;

procedure TFormConfig.FpsBarChange(Sender: TObject);
begin
 case FpsBar.Position of
  4 : begin
       FormPlayer.TimerRender.Interval := 15;
       LabelFrames.Caption := 'Frame per second (70 fps)';
      end;

  3 : begin
       FormPlayer.TimerRender.Interval := 25;
       LabelFrames.Caption := 'Frame per second (40 fps)';
      end;

  2 : begin
       FormPlayer.TimerRender.Interval := 33;
       LabelFrames.Caption := 'Frame per second (30 fps)';
      end;

  1 : begin
       FormPlayer.TimerRender.Interval := 50;
       LabelFrames.Caption := 'Frame per second (20 fps)';
      end;

  0 : begin
       FormPlayer.TimerRender.Interval := 100;
       LabelFrames.Caption := 'Frame per second (10 fps)';
      end;
 end;
end;

end.

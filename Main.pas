unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CommonTypes,
  VsControls, VsSkin, VsButtons, VsProgressBar, VsLed, VsLabel, AudioObject,
  VsSlider, ExtCtrls, VsComposer, VsImageClip, VsCheckBox, VsImageText,
  VsImage, DrawUtils, Menus, WinSkinData, OBMagnet, OBXPBarMenu, RzTray;

type
  TFormPlayer = class(TForm)
    mainSkin: TVsSkin;
    VsButton1: TVsButton;
    VsButton2: TVsButton;
    BtnPrev: TVsButton;
    BtnPlay: TVsButton;
    BtnPause: TVsButton;
    BtnStop: TVsButton;
    BtnNext: TVsButton;
    BtnOpen: TVsButton;
    VsComposer: TVsComposer;
    RptCheck: TVsCheckBox;
    ShfCheck: TVsCheckBox;
    VolTrack: TVsSlider;
    BalTrack: TVsSlider;
    OpenDialog: TOpenDialog;
    TimerDisplay: TTimer;
    TimerRender: TTimer;
    TimePosText: TVsImageText;
    PosTrackBar: TVsSlider;
    TitleText: TVsImageText;
    StateText: TVsImageText;
    VsCheckBox1: TVsCheckBox;
    EQCheck: TVsCheckBox;
    PLCheck: TVsCheckBox;
    PopupMenu: TPopupMenu;
    Config: TMenuItem;
    WavePaint: TImage;
    FreqText: TVsImageText;
    BpsText: TVsImageText;
    PLIndexText: TVsImageText;
    StartupTimer: TTimer;
    Playlist: TMenuItem;
    Equalyzer: TMenuItem;
    AudioPlayer: TMenuItem;
    Play: TMenuItem;
    Pause: TMenuItem;
    Stop: TMenuItem;
    N1: TMenuItem;
    Next: TMenuItem;
    Previous1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    Open: TMenuItem;
    TimerMove: TTimer;
    SkinData1: TSkinData;
    OBFormMagnet1: TOBFormMagnet;
    RzTrayIcon1: TRzTrayIcon;
    procedure VsButton1Click(Sender: TObject);
    procedure VsButton2Click(Sender: TObject);
    procedure RptCheckClick(Sender: TObject);
    procedure ShfCheckClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnPlayClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure BtnPauseClick(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure BtnPrevClick(Sender: TObject);
    procedure VolTrackChange(Sender: TObject);
    procedure BalTrackChange(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure TimerRenderTimer(Sender: TObject);
    procedure PosTrackBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PLCheckClick(Sender: TObject);
    procedure ConfigClick(Sender: TObject);
    procedure EQCheckClick(Sender: TObject);
    procedure StartupTimerTimer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure PlaylistClick(Sender: TObject);
    procedure EqualyzerClick(Sender: TObject);
    procedure TimePosTextClick(Sender: TObject);
    procedure mainSkinMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mainSkinMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerMoveTimer(Sender: TObject);
    procedure TimePosTextContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
   ScrollText, LastText : String;
   EQOffX, EQOffY : Integer;
   PLOffX, PLOffY : Integer;
  public
    { Public declarations }
  end;

var
  FormPlayer: TFormPlayer;

implementation

uses playlist, config, equalyzer;

{$R *.DFM}

procedure TFormPlayer.VsButton1Click(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TFormPlayer.VsButton2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormPlayer.RptCheckClick(Sender: TObject);
begin
  AudioObjectPlayer.Shf := RptCheck.Checked;
end;

procedure TFormPlayer.ShfCheckClick(Sender: TObject);
begin
  AudioObjectPlayer.Rpt := ShfCheck.Checked;
end;

procedure TFormPlayer.FormCreate(Sender: TObject);
begin
 AudioObjectPlayer := TAudioObject.Create(Application.Handle);
 DrawInit;
end;

procedure TFormPlayer.BtnOpenClick(Sender: TObject);
begin
OpenDialog.Title := '打开音频';
OpenDialog.Filter := AudioObjectPlayer.GetDialogFilter + '|所有格式 (*.*)|*.*';
 if not OpenDialog.Execute then exit;
 if FormConfig.PLClearCheck.Checked then AudioObjectPlayer.Clear;
 AudioObjectPlayer.OpenFiles(OpenDialog.Files);
 Selected := AudioObjectPlayer.ItemIndex;
 AudioObjectPlayer.SetLegth(Selected, AudioObjectPlayer.GetSongLen);
 ListTotal := AudioObjectPlayer.GetTotLegth;
 DrawPlayList (100 - FormPlaylist.ListSlider.Position);
end;

procedure TFormPlayer.BtnPlayClick(Sender: TObject);
begin
 if AudioObjectPlayer.EngineState = ENGINE_PAUSE then
   AudioObjectPlayer.UnPause
  else
   AudioObjectPlayer.Play(AudioObjectPlayer.GetCurSong);
  AudioObjectPlayer.SetLegth(Selected, AudioObjectPlayer.GetSongLen);   
end;

procedure TFormPlayer.BtnStopClick(Sender: TObject);
begin
 AudioObjectPlayer.Stop;
end;

procedure TFormPlayer.BtnPauseClick(Sender: TObject);
begin
 AudioObjectPlayer.Pause;
end;

procedure TFormPlayer.BtnNextClick(Sender: TObject);
begin
 AudioObjectPlayer.NextSong;
 Selected := AudioObjectPlayer.ItemIndex;
 AudioObjectPlayer.SetLegth(Selected, AudioObjectPlayer.GetSongLen);
 DrawPlayList (100 - FormPlaylist.ListSlider.Position);
end;

procedure TFormPlayer.BtnPrevClick(Sender: TObject);
begin
 AudioObjectPlayer.PrevSong;
 Selected := AudioObjectPlayer.ItemIndex;
 DrawPlayList (100 - FormPlaylist.ListSlider.Position);
 AudioObjectPlayer.SetLegth(Selected, AudioObjectPlayer.GetSongLen); 
end;

procedure TFormPlayer.VolTrackChange(Sender: TObject);
begin
 AudioObjectPlayer.SetMainVolume(VolTrack.Position);
end;

procedure TFormPlayer.BalTrackChange(Sender: TObject);
begin
 AudioObjectPlayer.SetPanning(BalTrack.Position);
end;

procedure TFormPlayer.TimerDisplayTimer(Sender: TObject);
 var fLen, fPos : Integer; Tmp : String;
begin
 fPos := AudioObjectPlayer.GetSongPos div 1000;
 fLen := AudioObjectPlayer.GetSongLen div 1000;

 PosTrackBar.Position := Trunc((fPos / fLen) * 100);
 if FormConfig.InvTimeCheckBox.Checked then
   TimePosText.Text := ShortTime (fLen - fPos)
 else
   TimePosText.Text := ShortTime (fPos);

 Tmp := (AudioObjectPlayer.GetSongTitle(AudioObjectPlayer.GetCurSong));
 if (Tmp) <> '' then
  begin
    Tmp := (Tmp) + ' (' + ShortTime (AudioObjectPlayer.GetSongLen div 1000) + ') *** ';
    if LastText <> Tmp then
      begin
       ScrollText := Tmp;
       LastText := Tmp;
      end
     else ScrollText := Copy(ScrollText, 2, Length(ScrollText)) + ScrollText[1];
  end
   else
    begin
      LastText := '小步静听';
      ScrollText := '小步静听';
     end;

  if Length(TMP) > 26 then TitleText.Text := ScrollText else TitleText.Text := LastText;


 {Playlkyst and Player Infos}
  Application.Title := LastText + ' - 小步静听';
  FormPlaylist.InfoText.Text := 'Totals ' + IntToStr(Selected + 1) + '/' + IntToStr(AudioObjectPlayer.Count) + '   ' +
                               ShortTime (ListTotal div 1000);
  PLIndexText.Text := IntToStr(Selected + 1) + '/' + IntToStr(AudioObjectPlayer.Count);
  FreqText.Text    := IntToStr(AudioObjectPlayer.OutFrequency div 1000) + 'khz';
  BpsText.Text     := IntToStr(AudioObjectPlayer.GetBitrate) + 'kBs';
   case AudioObjectPlayer.EngineState of
    ENGINE_PLAY  : StateText.Text := 'P';
    ENGINE_PAUSE : StateText.Text := 'U';
    ENGINE_STOP  : StateText.Text := 'S';
    ENGINE_SONG_END :
     begin
       if AudioObjectPlayer.Rpt or AudioObjectPlayer.Shf then
              BtnNext.OnClick(Nil);
     end;
   end;
end;

procedure TFormPlayer.TimerRenderTimer(Sender: TObject);
 var LCH, RCH : Integer;
begin
 if not TimerMove.Enabled then
  begin
   EQOffX := FormPlayer.Left - FormEq.Left;
   EQOffY := FormPlayer.Top - FormEq.Top;
   PLOffX := FormPlayer.Left - FormPlaylist.Left;
   PLOffY := FormPlayer.Top - FormPlaylist.Top;
  end;
  
 if FormConfig.NoneDrawCheck.Checked then Exit;
 if FormConfig.WaveDrawCheck.Checked then DrawWave(WavePaint.Canvas.Handle);
 if FormConfig.FFTDrawCheck.Checked then DrawFFT;
end;

procedure TFormPlayer.PosTrackBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
 var fLen : LongInt;
begin
 if Button <> mbLeft then Exit;
   fLen := AudioObjectPlayer.GetSongLen;
   AudioObjectPlayer.SetSongPos(Trunc(fLen * X / PosTrackBar.Width));
end;

procedure TFormPlayer.PLCheckClick(Sender: TObject);
begin
 if PLCheck.Checked then FormPlaylist.Show
     else FormPlaylist.Close;
end;

procedure TFormPlayer.ConfigClick(Sender: TObject);
begin
 FormConfig.SHow;
 formconfig.Left:=formplayer.left+formplayer.Width;
 formconfig.Top:=formplayer.Top-25
end;

procedure TFormPlayer.EQCheckClick(Sender: TObject);
begin
 if EQCheck.Checked then FormEQ.Show
     else FormEQ.Close;
end;

procedure TFormPlayer.StartupTimerTimer(Sender: TObject);
begin
   StartupTimer.Enabled := False;

   {Set Initial Parameters}
    ScrollText := '小步静听';
    LastText := ScrollText;
    AudioObjectPlayer.SetMainVolume(12);
    AudioObjectPlayer.SetOutBufferLen(2000);
    
   {Forms Positions and refresh}
    FormPlayer.Height := mainSkin.Height;
    FormPlayer.Width := mainSkin.Width;
    FormPlayer.Top := (Screen.Height - FormPlayer.Height - FormEQ.Height - FormPlaylist.Height ) div 2;
    FormPlayer.Left := (Screen.Width - FormPlayer.Width ) div 2;
    FormPlaylist.Top  := FormPlayer.Top + FormPlayer.Height;
    FormPlaylist.Left := FormPlayer.Left;
    FormEQ.Top  := FormPlayer.Top - FormEQ.Height;
    FormEQ.Left := FormPlayer.Left;
    EQCheck.Checked := True;
    PLCheck.Checked := True;
    FormEQ.Show;
    FormPlaylist.Show;
end;

procedure TFormPlayer.Exit1Click(Sender: TObject);
begin
 Close;
end;

procedure TFormPlayer.PlaylistClick(Sender: TObject);
begin
  PLCheck.Checked := not PLCheck.Checked;
  PLCheckClick(Nil);
end;

procedure TFormPlayer.EqualyzerClick(Sender: TObject);
begin
  EQCheck.Checked := not EQCheck.Checked;
  EQCheckClick(Nil);
end;

procedure TFormPlayer.TimePosTextClick(Sender: TObject);
begin
  FormConfig.InvTimeCheckBox.Checked := not FormConfig.InvTimeCheckBox.Checked;
end;

procedure TFormPlayer.mainSkinMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if Button <> mbLeft then Exit;
  TimerMove.Enabled := True;
end;

procedure TFormPlayer.mainSkinMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TimerMove.Enabled := False;
end;

procedure TFormPlayer.TimerMoveTimer(Sender: TObject);
begin
 if FormConfig.MoveCheck.Checked then
  begin
    FormEq.Left := FormPlayer.Left - EQOffX;
    FormEq.Top := FormPlayer.Top - EQOffY;
    FormPlaylist.Left := FormPlayer.Left - PLOffX;
    FormPlaylist.Top := FormPlayer.Top - PLOffY;
  end;
end;

procedure TFormPlayer.TimePosTextContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
 TimePosTextClick(Nil);
end;

end.


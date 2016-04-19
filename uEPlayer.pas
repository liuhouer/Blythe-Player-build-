unit uEPlayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, CheckLst, ExtCtrls, Buttons, Menus, MPlayer,
  MMSystem, ActnList;

type
  TfrmEPlayer = class(TForm)
    SpeedBtn_Open: TSpeedButton;
    SpeedBtn_Pause: TSpeedButton;
    SpeedBtn_Up: TSpeedButton;
    SpeedBtn_Play: TSpeedButton;
    SpeedBtn_Stop: TSpeedButton;
    SpeedBtn_Down: TSpeedButton;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    MediaPlayer: TMediaPlayer;
    pm_Right: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N25: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N11: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    OpenDlg_Files: TOpenDialog;
    SaveDlg_Files: TSaveDialog;
    TrackBar1: TTrackBar;
    Timer_Play: TTimer;
    TrackBar_Play: TTrackBar;
    btn_ShowPlayList: TButton;
    lbSoundLR: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label_Title: TLabel;
    lbl_TotalTime: TLabel;
    lbl_PlayTime: TLabel;
    procedure SpeedBtn_OpenClick(Sender: TObject);
    procedure SpeedBtn_PauseClick(Sender: TObject);
    procedure SpeedBtn_StopClick(Sender: TObject);
    procedure SpeedBtn_UpClick(Sender: TObject);
    procedure SpeedBtn_DownClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CDROM1Click(Sender: TObject);
    procedure CDROM2Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Timer_PlayTimer(Sender: TObject);
    procedure SpeedBtn_PlayClick(Sender: TObject);
    procedure btn_ShowPlayListClick(Sender: TObject);
    procedure TrackBar_PlayChange(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    function ZeroFill(Size: Integer; s: string): string;
    //procedure GetVolume(var wLeft, wRight: Word);
    //procedure SetVolume(nLeft, nRight: Word);
    { Private declarations }
  public
    procedure SetAudioType(Value: Byte);     // 设置声音的类型
    procedure SetWaveLeft(Volume: Integer);  // 设置声音为左声道(Integer 1~13)
    procedure SetWaveRight(Volume: Integer); // 设置声音为右声道(Integer 1~13)
    procedure SetWaveBoth(Volume: Integer);  // 设置声音为双声道(Integer 1~13)
    //procedure SetWave;
    { Public declarations }
  end;

var
  frmEPlayer: TfrmEPlayer;
  PositionChange: Boolean;

implementation

uses uPlayList, uMovie, uAbout;

{$R *.dfm}
//==============================================================================
// 自定义函数
function TfrmEPlayer.ZeroFill(Size: Integer; s: string): string;
var
  a,b: Integer;
  t: string;
begin
  SetLength(t, Size);
  for a := 1 to Size do
    t[a] := '0';
    b := Size;
    for a := Length(s) downto 1 do
    begin
      t[b] := s[a];
      Dec(b);
    end;
    ZeroFill := t;
end;
//==============================================================================

//==============================================================================
procedure TfrmEPlayer.SetAudioType(Value: Byte);
var
  SetAs: string;
begin
  case Value of
    1: begin
         mciSendString('set all audio all on', nil, 0, Handle);
         SetAs:='stereo';
         lbSoundLR.Caption := '立体声';
       end;
    2: begin
         mciSendString('set all audio all on', nil, 0, Handle);
         SetAs := 'left' ;
         lbSoundLR.Caption := '左声道';
       end;
    3: begin
         mciSendString('set all audio all on', nil, 0, Handle);
         SetAs := 'right';
         lbSoundLR.Caption := '右声道';
       end ;
    4: begin
         mciSendString('set all audio all on', nil, 0, Handle);
         SetAs := 'average';
         lbSoundLR.Caption := '平均';
       end;
    5: begin
         lbSoundLR.Caption :='静音';
         mciSendString('set all audio all off', nil, 0, Handle);
       end;
  end;
  //RetStr := AudioSource(MediaAliasName, SetAs);
end;
//==============================================================================
procedure TfrmEPlayer.SetWaveLeft(Volume: Integer);
var
  Wave: string;
begin
  try
    Wave := '$' + IntToHex(0, 4) + IntToHex(Volume*5000, 4);
    MMSystem.waveOutSetVolume(0, StrToInt(Wave));
  except
  end;
end;

procedure TfrmEPlayer.SetWaveRight(Volume: Integer);
var
  Wave: string;
begin
  try
    Wave := '$' + IntToHex(Volume*5000, 4) + IntToHex(0, 4);
    MMSystem.waveOutSetVolume(0, StrToInt(Wave));
  except
  end;
end;

procedure TfrmEPlayer.SetWaveBoth(Volume: Integer);
var
  Wave: string;
begin
  try
    Wave := '$' + IntToHex(Volume*5000, 4) + IntToHex(Volume*5000, 4);
    MMSystem.waveOutSetVolume(0, StrToInt(Wave));
  except
  end;
end;
//==============================================================================

procedure TfrmEPlayer.SpeedBtn_OpenClick(Sender: TObject);
begin
  frmPlayList.AddPlayFile;
end;

procedure TfrmEPlayer.SpeedBtn_PauseClick(Sender: TObject);
begin
  if frmPlayList.ListBox_PlayFiles.ItemIndex < 0 then
      MessageBox(Handle, '此时没有任何播放文件!', PChar('警告'), MB_OK+MB_ICONWARNING)
  else
  begin
    case MediaPlayer.Mode of
      MpPlaying:
      begin
        MediaPlayer.Pause;
        SpeedBtn_Pause.Caption := '继续';
      end;
      MpPaused:
      begin
        MediaPlayer.Resume;
        SpeedBtn_Pause.Caption := '暂停';
      end;
    end;
  end;
end;

procedure TfrmEPlayer.SpeedBtn_StopClick(Sender: TObject);
begin
 if frmPlayList.ListBox_PlayFiles.ItemIndex < 0 then
    MessageBox(Handle, '此时没有任何播放文件!', PChar('警告'), MB_OK+MB_ICONWARNING)
 else
   begin
     MediaPlayer.Stop;
     MediaPlayer.Rewind;
     TrackBar_Play.Position := 0;
   end;
end;

procedure TfrmEPlayer.SpeedBtn_UpClick(Sender: TObject);
begin
  if frmPlayList.ListBox_PlayFiles.ItemIndex = 0 then Exit;
  if frmPlayList.ListBox_PlayFiles.ItemIndex < 0 then
    MessageBox(Handle, '此时没有任何播放文件!', PChar('警告'), MB_OK+MB_ICONWARNING)
  else
    begin
      MediaPlayer.Stop;
      frmPlayList.ListBox_PlayFiles.ItemIndex := frmPlayList.ListBox_PlayFiles.ItemIndex - 1;
      MediaPlayer.FileName := frmPlayList.ListBox_PlayFiles.Items[frmPlayList.ListBox_PlayFiles.ItemIndex];
      MediaPlayer.Open;
      MediaPlayer.Play;
    end;
end;

procedure TfrmEPlayer.SpeedBtn_DownClick(Sender: TObject);
begin
  if frmPlayList.ListBox_PlayFiles.ItemIndex < 0 then
    MessageBox(Handle,'此时没有任何播放文件!',PChar('警告'),MB_OK+MB_ICONWARNING)
  else
    begin
      MediaPlayer.Stop;
      frmPlayList.ListBox_PlayFiles.ItemIndex := frmPlayList.ListBox_PlayFiles.ItemIndex + 1;
      MediaPlayer.FileName := frmPlayList.ListBox_PlayFiles.Items[frmPlayList.ListBox_PlayFiles.ItemIndex];
      MediaPlayer.Open;
      MediaPlayer.Play;
    end;
end;

procedure TfrmEPlayer.N2Click(Sender: TObject);
begin
  OpenDlg_Files.Options := [ofHideReadOnly,ofAllowMultiSelect,ofEnableSizing];
  try
    if OpenDlg_Files.Execute then
    begin
      frmPlayList.ListBox_PlayFiles.Items.AddStrings(OpenDlg_Files.Files);
      frmPlayList.ListBox_PlayFiles.ItemIndex := 0;
    end;
  finally
    SpeedBtn_Play.Enabled := True;
  end;
end;

procedure TfrmEPlayer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if MessageBox(Handle, '确认关闭程序吗?', '警告', MB_OKCANCEL+MB_ICONWARNING) = IDOK then
  begin
    if frmPlayList <> nil then
    frmPlayList.Free;
    Application.Terminate;
  end
  else
    Action := caNone;
end;

procedure TfrmEPlayer.FormCreate(Sender: TObject);
var
  StopTime: DWord;
begin
  StopTime := GetTickCount div 1000;
  while ((GetTickCount div 1000) < (StopTime + 1)) do
  Sleep(1);
  PositionChange := False;
end;
// 打开CD-ROM
procedure TfrmEPlayer.CDROM1Click(Sender: TObject);
begin
  MCISendString('set cdaudio door open wait', nil, 0, Handle);
end;
// 关上CD-ROM
procedure TfrmEPlayer.CDROM2Click(Sender: TObject);
begin
  MCISendString('set cdaudio door closed wait', nil, 0, Handle);
end;

procedure TfrmEPlayer.TrackBar1Change(Sender: TObject);
var
  t, v: Longint;
begin
  t := TrackBar1.Position;
  v := (t shl 8)or(t shl 24);
  waveOutSetVolume(0, v);
end;

procedure TfrmEPlayer.Timer_PlayTimer(Sender: TObject);
begin
  with MediaPlayer do
  begin
    if Mode in [mpPlaying] then
    begin
      if frmPlayList.IsFileChange then
      begin
        TrackBar_Play.Max := MediaPlayer.Length div 1000;
        TrackBar_Play.Position := 0;
        lbl_TotalTime.Caption := '总时间: ' + ZeroFill(2, IntToStr(TrackBar_Play.max div 60))
                                 +':' + ZeroFill(2, IntToStr(TrackBar_play.max mod 60))+'    ';
        frmPlayList.IsFileChange := False;
      end;

      TrackBar_Play.Position := Position div 1000;
      lbl_PlayTime.Caption := '播放时间: ' + ZeroFill(2, IntToStr(TrackBar_Play.Position div 60))
                              + ':' + ZeroFill(2, IntToStr(TrackBar_Play.Position mod 60)) + '    ';
      //Label_Title.Caption := '当前曲目：' + '[' + ExtractFileName(frmPlayList.ListBox_PlayFiles.Items.Strings[frmPlayList.ListBox_PlayFiles.ItemIndex]) + ']';
      Label_Title.Caption := '当前曲目：' + ExtractFileName(frmPlayList.ListBox_PlayFiles.Items.Strings[frmPlayList.ListBox_PlayFiles.ItemIndex]);
    end;
  end;
end;

procedure TfrmEPlayer.SpeedBtn_PlayClick(Sender: TObject);
var
  I: Integer;
begin
  if frmPlayList.ListBox_PlayFiles.ItemIndex < 0 then
    MessageBox(Handle,'此时没有任何播放文件!',PChar('警告'),MB_OK+MB_ICONWARNING)
  else
  for I := 0 to frmPlayList.ListBox_PlayFiles.ItemIndex do
    MediaPlayer.FileName := frmPlayList.ListBox_PlayFiles.Items.Strings[I];
    MediaPlayer.Open;
    MediaPlayer.Play;
end;

procedure TfrmEPlayer.btn_ShowPlayListClick(Sender: TObject);
begin
  frmPlayList := TfrmPlayList.Create(Self);
  frmPlayList.Show;
end;

procedure TfrmEPlayer.TrackBar_PlayChange(Sender: TObject);
begin
  if (TrackBar_Play.Position <> (Mediaplayer.Position div 1000)) then PositionChange := True
  else PositionChange := False;
    if PositionChange then
    with Mediaplayer do
    begin
      if Mode in [mpOpen, mpPlaying] then
      begin
        Pause;
        Position := TrackBar_Play.Position * 1000;
        Play;
      end
      else if mode in [mpOpen, mpPaused, mpStopped] then
        begin
          Position :=  TrackBar_play.Position * 1000;
        end;
    end;
end;

procedure TfrmEPlayer.Panel1Click(Sender: TObject);
begin
  with TfrmAbout.Create(Application) do
  begin
    try
      frmAbout.ShowModal;
    finally
      Free;
    end;
  end;
end;

end.

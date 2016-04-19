unit Unit_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Bass, ExtCtrls, spectrum_vis,circle_vis, osc_vis, CommonTypes, ComCtrls,
  XPMan, slider, bassflac, basswma;
type
  TFrm_Player = class(TForm)
    Btn_Open: TButton;
    Btn_Play: TButton;
    Memo1: TMemo;
    Btn_Pause: TButton;
    Btn_Stop: TButton;
    OpenDialog: TOpenDialog;
    Label1: TLabel;
    TimerReader: TTimer;
    TrackX: TTrackBar;
    TrackY: TTrackBar;
    XPManifest1: TXPManifest;
    PosSlider: TSlider;
    Slider1: TSlider;
    Label2: TLabel;
    Label3: TLabel;
    PaintFrame: TPaintBox;
    Shape1: TShape;
    Label4: TLabel;

    procedure Btn_OpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_PlayClick(Sender: TObject);
    procedure Btn_PauseClick(Sender: TObject);
    procedure Btn_StopClick(Sender: TObject);
    procedure TimerReaderTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PosSliderStopTracking(Sender: TObject);
    procedure PosSliderStartTracking(Sender: TObject);
    procedure Slider1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    mods: array[0..128] of HMUSIC;
    modc: Integer;
    sams: array[0..128] of HSAMPLE;
    samc: Integer;
    strc: Integer;
    NowTracking:Boolean;
    function GetSongLength : DWord;
    function GetSongPosition : DWord;
    procedure Error(msg: string);
    function OpenFile(s:string):boolean;


  public
    { Public declarations }
    strs: array[0..128] of HSTREAM;

    procedure   Mymessage(var   t:TWmCopyData);message   WM_COPYDATA;   

  end;

var
  Frm_Player: TFrm_Player;

implementation

uses Unit_EQ, Unit_Lyric;



procedure DllEnterPoint(dwReason: DWORD);far;stdcall;External'MusicInfo.dll'
function OpenMusicFile(FileName: String):Boolean;stdcall;External'MusicInfo.dll';
function GetMusic_Title:Pchar;stdcall;External'MusicInfo.dll';
function GetMusic_Duration:integer;stdcall;External'MusicInfo.dll';
function GetMusic_Artist: Pchar;stdcall;External'MusicInfo.dll';
function GetMusic_Album:Pchar;stdcall;External'MusicInfo.dll';
function GetMusic_Track:Pchar;stdcall;External'MusicInfo.dll';
function GetMusic_BitRate:integer;stdcall;External'MusicInfo.dll';
function GetMusic_SampleRate:integer;stdcall;External'MusicInfo.dll';
function GetMusic_Channels:integer;stdcall;External'MusicInfo.dll';


function SaveMusicFile(FileName: String):Boolean;stdcall;External'MusicInfo.dll';
function SetMusic_Title(Titile: String):Boolean;stdcall;External'MusicInfo.dll';
function SetMusic_Album(Album: String):Boolean;stdcall;External'MusicInfo.dll';
function SetMusic_Artist(Artist: String):Boolean;stdcall;External'MusicInfo.dll';
function SetMusic_Track(Track: String):Boolean;stdcall;External'MusicInfo.dll';

{$R *.dfm}

procedure TFrm_Player.Btn_OpenClick(Sender: TObject);
begin
  if not OpenDialog.Execute then Exit;
  OpenFile(OpenDialog.FileName);
end;

procedure TFrm_Player.Error(msg: string);

var
	s: string;
begin
	s := msg + #13#10 + '(Error code: ' + IntToStr(BASS_ErrorGetCode) + ')';
	MessageBox(Handle, PChar(s), 0, 0);
end;

procedure TFrm_Player.FormCreate(Sender: TObject);
var i:integer;
begin

  DllEnterPoint(DLL_PROCESS_ATTACH);
	modc := 0;		// music module count
	samc := 0;		// sample count
	strc := 0;		// stream count

	// check the correct BASS was loaded
	if (HIWORD(BASS_GetVersion) <> BASSVERSION) then
	begin
		MessageBox(0,'An incorrect version of BASS.DLL was loaded',0,MB_ICONERROR);
		Halt;
	end;

	// Initialize audio - default device, 44100hz, stereo, 16 bits
	if not BASS_Init(-1, 44100, 0, Handle, nil) then
		Error('Error initializing audio!');

  Spectrum:= TSpectrum.Create(PaintFrame.Width, PaintFrame.Height);
  Slider1.Value:=BASS_GetVolume;

  for i:=0 to ParamCount-1 do
  begin
   memo1.Lines.Add(ParamStr(i))
  end;
  if ParamCount>=1 then
  begin
    OpenFile(ParamStr(1));
    Btn_Play.Click;
  end;
end;

procedure TFrm_Player.Btn_PlayClick(Sender: TObject);
begin
  if Label1.Caption<>'' then
  begin
  if not BASS_ChannelPlay(strs[0], False) then
    //Error('Error playing stream!');
    MessageBox(Handle, '播放列表空...', 0, 0);
  end;
  Spectrum.Mode:=1;
  Frm_EQ.ResetEQ;
end;

procedure TFrm_Player.Btn_PauseClick(Sender: TObject);
begin
  BASS_ChannelPause(strs[0]);
end;

procedure TFrm_Player.Btn_StopClick(Sender: TObject);
begin
  //BASS_ChannelPause(strs[0]);
  BASS_ChannelStop(strs[0]);
  BASS_ChannelSetPosition(strs[0],0);
  Frm_Lyric.SeekLyric(0);
  PaintFrame.Canvas.FillRect(PaintFrame.Canvas.ClipRect);
  PosSlider.Value:=0;
  //Frm_Lyric.LyricFile:='';
end;

procedure TFrm_Player.TimerReaderTimer(Sender: TObject);
var
  FFTFata : TFFTData; WaveData  : TWaveData;
begin
 if BASS_ChannelIsActive(strs[0]) <> BASS_ACTIVE_PLAYING then Exit;
 BASS_ChannelGetData(strs[0], @FFTFata, BASS_DATA_FFT1024);
 Spectrum.Draw(PaintFrame.Canvas.Handle, FFTFata,  TrackX.Position - 40, TrackY.Position - 60);
 //PosSlider.Value:=BASS_ChannelGetPosition(strs[0])
 if not NowTracking then
   begin
   PosSlider.Value := (GetSongPosition * PosSlider.MaxValue) div GetSongLength;
   Frm_Lyric.SeekLyric(GetSongPosition);
   //caption:=inttostr(PosSlider.Value);
   Label3.caption:= FormatDateTime ('nn:ss', GetSongPosition / (1000 * 24 * 60 * 60));
   end
 else
   begin
   Label3.caption:= FormatDateTime ('nn:ss', (PosSlider.Value * GetSongLength) div PosSlider.MaxValue / (1000 * 24 * 60 * 60));
   end;
 end;

procedure TFrm_Player.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DllEnterPoint(DLL_PROCESS_DETACH);
  Bass_Free;
  Spectrum.Free;
end;

procedure TFrm_Player.PosSliderStopTracking(Sender: TObject);
var
   SongPos : DWORD;
   Seekable: Boolean;
   Position:DWORD;
begin
  Seekable:=True;
   if Seekable then
   begin
      SongPos := Trunc(PosSlider.Value * GetSongLength / PosSlider.MaxValue);
      SongPos := SongPos div 1000;
      Position:=BASS_ChannelSeconds2Bytes(strs[0],SongPos);
      BASS_ChannelSetPosition(strs[0],Position);
      //VolummePos := Slider1.Value;
      //BASS_SetVolume(VolummePos);
   end;

   NowTracking := false;
end;

procedure TFrm_Player.PosSliderStartTracking(Sender: TObject);
begin
  NowTracking := True;
end;

function TFrm_Player.GetSongLength: DWord;
var
   SongLength : int64;
   FloatLen : FLOAT;
begin
   result := 0;
   SongLength := BASS_ChannelGetLength(strs[0]);

   FloatLen := BASS_ChannelBytes2Seconds(strs[0], SongLength);
   result := round(1000 * FloatLen);   // sec -> milli sec
end;

function TFrm_Player.GetSongPosition: DWord;
var
   SongLength : int64;
   FloatLen : FLOAT;
begin
   result := 0;
   SongLength := BASS_ChannelGetPosition(strs[0]);

   FloatLen := BASS_ChannelBytes2Seconds(strs[0], SongLength);
   result := round(1000 * FloatLen);   // sec -> milli sec
end;
procedure TFrm_Player.Slider1Change(Sender: TObject);
begin
  BASS_SetVolume(Slider1.Value);
end;

procedure TFrm_Player.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Frm_Lyric.stopLyric;
end;

function TFrm_Player.OpenFile(s: string): boolean;
var
	f: PChar;
  lyricfile: string;
begin

  if strs[0]<>0 then
  begin
    BASS_StreamFree(strs[0]);
    Frm_Lyric.stopLyric;
    PosSlider.Value:=0;
  end;
	f := PChar(S);
	strs[0] := BASS_StreamCreateFile(False, f, 0, 0, 0);

	if strs[0] = 0 then
  begin
    strs[0] := BASS_WMA_StreamCreateFile(False, f, 0, 0, 0);
    if strs[0] = 0 then
    begin
      strs[0] := BASS_FLAC_StreamCreateFile(False, f, 0, 0, 0);
      if strs[0] = 0 then
        Error('Error creating stream!');
    end;

  end;

	if strs[0] <> 0 then
	begin
    Label2.caption:= FormatDateTime ('nn:ss', GetSongLength / (1000 * 24 * 60 * 60));
  //---------读取歌曲tags--------------------------------

    OpenMusicFile(s);

    Memo1.Clear;
    Memo1.Lines.Add('歌曲标题：'+GetMusic_Title);
    Frm_Lyric.LyricTitle:=GetMusic_Title;
    Memo1.Lines.Add('歌曲长度：'+IntToStr(GetMusic_Duration));
    Memo1.Lines.Add('艺术家：'+GetMusic_Artist);
    Frm_Lyric.LyricArtist:=GetMusic_Artist;
    Memo1.Lines.Add('唱片：'+GetMusic_Album);
    //Edit5.Text:=GetMusic_Track;
    Memo1.Lines.Add('比特率：'+inttostr(GetMusic_BitRate)+' bps');
    Memo1.Lines.Add('采样率：'+inttostr(GetMusic_SampleRate)+' Hz');
    Memo1.Lines.Add('声道数：'+inttostr(GetMusic_Channels)+' 个');
    Label1.Caption:=s;
  //-----------------------------------------------------

   //-------------显示歌词文件--------------------------
    lyricfile:=ChangeFileExt(s,'.lrc');
    Frm_Lyric.LyricFile:=lyricfile;
    if FileExists(lyricfile) then
      Frm_Lyric.ShowLyric(lyricfile)
    else
      Frm_Lyric.ShowNoLyric;
   //----------------------------------------------------
	end
end;

procedure TFrm_Player.Mymessage(var t: TWmCopyData);
var
  s:string;
begin

  //show;
  s:=StrPas(t.CopyDataStruct^.lpData);//接受数据并显示。
  OpenFile(s);
  Btn_Play.Click;
  application.BringToFront;
end;

end.

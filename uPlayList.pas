unit uPlayList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, MPlayer, ExtCtrls, MMSystem;

type
  TfrmPlayList = class(TForm)
    ListBox_PlayFiles: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    OpenDlg_PlayList: TOpenDialog;
    SaveDlg_PlayList: TSaveDialog;
    AutoPlayTimer: TTimer;
    procedure ListBox_PlayFilesDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AutoPlayTimerTimer(Sender: TObject);
  private
    procedure Init;
    { Private declarations }
  public
    FileIndex: Integer;          // 播放文件的索引
    FileCount: Integer;          // 列表中文件总数
    IsFileChange: Boolean;       // 通知主窗口播放歌曲已改
    FileLength: Longint;         // 文件长度
    FilePosition: Longint;       // 当前播放的帧数
    Drive: char;                 // 光驱盘符
    IsCDOpen: Boolean;           // 光驱是否打开
    FileListName: TIniFile;      // 列表文件关联名
    IsPlayingPause: Boolean;     // 暂停控制
    procedure PlayMedia;         // 播放音频文件
    procedure PlayPause;         // 暂停当前播放文件
    procedure PlayStop;          // 停止当前播放文件
    procedure PlayBack;          // 倒退当前播放文件
    procedure PlayStep;          // 快进当前播放文件
    procedure PlayPrev;          // 播放上一曲目
    procedure PlayNext;          // 播放下一曲目
    procedure AddPlayFile;       // 添加播放列表文件
    procedure DelPlayFile;       // 删除播放列表文件
    procedure ClearPlayFile;     // 清空播放列表文件
    procedure CDControl;         // 控制CDROM开关
    { Public declarations }
  end;

var
  frmPlayList: TfrmPlayList;

implementation

uses uEPlayer, uMovie;

{$R *.dfm}

procedure TfrmPlayList.ListBox_PlayFilesDblClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := ListBox_PlayFiles.ItemIndex;
  if Index < 0 then Exit;
  if Index = FileIndex then Exit;
  frmEPlayer.MediaPlayer.Close;
  FileIndex := Index;
  FileListName.WriteInteger('播放文件', '文件号', FileIndex);
  PlayMedia;
end;

procedure TfrmPlayList.Button1Click(Sender: TObject);
begin
  AddPlayFile;
end;

procedure TfrmPlayList.Button3Click(Sender: TObject);
begin
  ClearPlayFile;
end;

procedure TfrmPlayList.Button2Click(Sender: TObject);
begin
  DelPlayFile;
end;

procedure TfrmPlayList.Button5Click(Sender: TObject);
begin
  //SavePlayList;
end;

procedure TfrmPlayList.PlayMedia;
var
  ExtName: string;
begin
  with frmEPlayer.MediaPlayer do
  begin
    if Mode = mpOpen then Close;    //如果正在播放，则关闭
    FileName := FileListName.ReadString('文件列表', 'No.[' + IntToStr(FileIndex) + ']','');
    try
      Open;
      ExtName := ExtractFileExt(FileName);
      if (StrIComp(PChar(ExtName), '.mpg') = 0) or
         (StrIComp(PChar(ExtName), '.dat') = 0) or
         (StrIComp(PChar(ExtName), '.avi') = 0) or
         (StrIComp(PChar(ExtName), '.asf') = 0) then
      begin
        //frmEPlayer.MediaPlayer.Display := frmMovie.Panel_DisPlay;
        //frmEPlayer.MediaPlayer.DisplayRect := frmMovie.Panel_DisPlay.ClientRect;
        //frmMovie.Visible := True;
      end
      else
        begin
          //frmEPlayer.MediaPlayer.Display := nil;
          //frmMovie.Visible := False;
        end;
        TimeFormat := tfMilliseconds;
        Position := 0;
        IsFileChange := True;
        Play;
        //PlayingPause := False;
    except
      MessageDlg('无法打开或者播放此文件！',mtError,[mbOK],0);
    end;
  end;
end;
// 播放下一曲目
procedure TfrmPlayList.PlayNext;
begin
  if FileIndex >= FileCount - 1 then Exit;
  FileIndex := FileIndex + 1;
  ListBox_PlayFiles.ItemIndex := FileIndex;
  FileListName.WriteInteger ('播放文件', '文件号', FileIndex);
  PlayMedia;
end;
// 添加播放列表文件
procedure TfrmPlayList.AddPlayFile;
var
  I: Integer;
begin
  OpenDlg_PlayList.Filter := '音频文件(*.WAV,*.MP3,*.WMA,*.MID,*.RMI,*.CDA)|*.WAV;*.MP3;*.WMA;*.MID;*.RMI;*.CDA|视频文件(*.MPG,*.AVI,*.DAT,*.ASF,*,MPEG)|*.MPG;*.AVI;*.DAT;*.ASF;*.MPEG|所有文件(*.*)|*.*';
  if OpenDlg_PlayList.Execute then
  begin
    with OpenDlg_PlayList.Files do
      for I := 0 to Count - 1 do
      begin
        ListBox_PlayFiles.Items.Add(Strings[I]);
        FileListName.WriteString('文件列表', 'No.[' + IntToStr(FileCount + I) + ']', Strings[I]);
      end;
      FileIndex := FileCount;
      ListBox_PlayFiles.ItemIndex := FileIndex;
      //ListBoxScrollar(Sender);
      FileCount := FileCount + OpenDlg_PlayList.Files.Count;
      FileListName.WriteInteger('播放文件', '文件号', FileIndex);
      FileListName.WriteInteger('播放文件', '文件数', FileCount);
      PlayMedia;
  end;
end;
// 删除播放列表文件
procedure TfrmPlayList.DelPlayFile;
var
  Index : Integer;
begin
  if FileCount <= 0 then Exit;      // 如果列表中为空则退出
  Index := ListBox_PlayFiles.ItemIndex;
  if Index < 0 then Exit;           // 如果没有选择则退出
  // 如果被删除的是当前正在播放的音乐，则关闭音乐
  if frmEPlayer.MediaPlayer.FileName = ListBox_PlayFiles.Items.Strings[Index] then
  begin
    frmEPlayer.MediaPlayer.Close;
    FileIndex := -1;
    FileListName.WriteInteger('播放文件', '文件号', FileIndex);
  end;
  // 从列表中删除
  ListBox_PlayFiles.Items.Delete(Index);
  // 列表文件总数减一
  FileCount := FileCount - 1;
  if FileCount = 0 then
  begin
    FileIndex := -1;
    FileListName.WriteInteger('播放文件', '文件号', FileIndex);
  end;
  if Index = FileCount then
    ListBox_PlayFiles.ItemIndex := 0
  else
    ListBox_PlayFiles.ItemIndex := Index;

  FileListName.WriteInteger('播放文件', '文件数', FileCount);
  for Index := Index to FileCount - 1 do
  begin
    FileListName.WriteString ('文件列表', 'No.[' + IntToStr(Index) + ']',
    ListBox_PlayFiles.Items.Strings[Index]);
  end;
  //ListBoxScrollar(Sender);
  FileListName.DeleteKey('文件列表', 'No.[' + IntToStr(FileCount) + ']');
end;

procedure TfrmPlayList.Init;
var
  I: Integer;
  TmpName: string;
begin
  FileListName := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'EPlayer.ini');
  // 建立列表文件关联
  FileCount := FileListName.ReadInteger('播放文件', '文件数', 0);
  for I := 0 to FileCount - 1 do
  begin
    TmpName := FileListName.ReadString('文件列表', 'No.[' + IntToStr(I) + ']', '');
    ListBox_PlayFiles.Items.Add (TmpName);
  end;
  FileIndex :=FileListName.ReadInteger('播放文件', '文件号', -1);
  ListBox_PlayFiles.ItemIndex := FileIndex;
  //ListBoxScrollar(Sender);
  {for I := Ord('A') to Ord('Z') do
  begin
    Drive := Chr(I);
    if GetDriveType(PChar(Drive + ':\' + #0)) = DRIVE_CDROM  then
      Break;
  end;}
end;
// 清空播放列表文件
procedure TfrmPlayList.ClearPlayFile;
begin
  if FileCount <= 0 then exit; //如果列表中为空则退出
    frmEPlayer.MediaPlayer.Close;
    FileCount := 0;
    FileIndex := -1;
    FileListName.WriteInteger('播放文件', '文件数', FileCount);
    FileListName.WriteInteger('播放文件', '文件号', FileIndex);
    FileListName.EraseSection('文件列表');
    ListBox_PlayFiles.Items.Clear;
end;


procedure TfrmPlayList.FormCreate(Sender: TObject);
begin
  Init;
end;

procedure TfrmPlayList.AutoPlayTimerTimer(Sender: TObject);
begin
  if frmEPlayer.MediaPlayer.Mode = mpPlaying then
    if frmEPlayer.MediaPlayer.Position >= frmEPlayer.MediaPlayer.Length - 1000 then
    PlayNext;
end;
// 控制CDROM开关
procedure TfrmPlayList.CDControl;
begin
  if IsCDOpen then
  begin
    MciSendString('set cdaudio door closed', nil, 0, 0);
    IsCDOpen := False;
  end
  else
  begin
    MciSendString('set cdaudio door open', nil, 0, 0);
    IsCDOpen := True;
  end;
end;
// 倒退当前播放文件
procedure TfrmPlayList.PlayBack;
begin
  with frmEPlayer.MediaPlayer do
  begin
    if not(Mode in [mpPlaying]) then Exit;
    Pause;
    Position := Position - 6000;
    Play;
  end;
end;
// 暂停当前播放文件
procedure TfrmPlayList.PlayPause;
begin
  with frmEPlayer.MediaPlayer do
  begin
    if Mode in [mpOpen, mpPlaying] then Pause
    else if Mode in [mpOpen, mpPaused] then Resume;
  end;
end;
// 播放上一曲目
procedure TfrmPlayList.PlayPrev;
begin
  if FileIndex <= 0 then Exit;
  FileIndex := FileIndex - 1;
  ListBox_PlayFiles.ItemIndex := FileIndex;
  FileListName.WriteInteger('播放文件', '文件号', FileIndex);
  PlayMedia;
end;
// 快进当前播放文件
procedure TfrmPlayList.PlayStep;
begin
  with frmEPlayer.MediaPlayer do
  begin
    if not(Mode in [mpPlaying]) then Exit;
    Pause;
    Position := Position + 6000;
    Play;
  end;
end;
// 停止当前播放文件
procedure TfrmPlayList.PlayStop;
begin
  with frmEPlayer.MediaPlayer do
  begin
    if Mode in [mpStopped] then Exit;
    Close;
  end;
end;

end.

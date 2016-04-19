unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  ComCtrls, SkyAudioMeter,Mmsystem,FileCtrl,
   Menus,ShellAPI,AppEvnts, OBMagnet, ExtCtrls, MPlayer, StdCtrls,
   RzTray,  RzCommon,
  SUIForm, SUIButton, SUITrackBar,
  SUIImagePanel, SUIGroupBox, RzLstBox, SUIMainMenu, SUITitleBar;
 const WM_NID = WM_User + 1000;
type
  TMainPlay = class(TForm)
    MediaPlayer1: TMediaPlayer;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    yhcpu: TTimer;
    OpenDialog3: TOpenDialog;
    Timer2: TTimer;
    mainpop: TPopupMenu;
    N81: TMenuItem;
    N53: TMenuItem;
    listname: TMenuItem;
    N85: TMenuItem;
    N83: TMenuItem;
    N82: TMenuItem;
    N84: TMenuItem;
    N50: TMenuItem;
    N5: TMenuItem;
    AudioPop: TPopupMenu;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    N67: TMenuItem;
    N110: TMenuItem;
    N210: TMenuItem;
    N310: TMenuItem;
    N410: TMenuItem;
    N510: TMenuItem;
    N68: TMenuItem;
    N69: TMenuItem;
    N111: TMenuItem;
    N211: TMenuItem;
    N311: TMenuItem;
    N15: TMenuItem;
    N22: TMenuItem;
    N72: TMenuItem;
    N73: TMenuItem;
    Timer3: TTimer;
    Timer4: TTimer;
    stat1: TStatusBar;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    SinaBlog1: TMenuItem;
    Qzone1: TMenuItem;
    MSNLite1: TMenuItem;
    N14: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N32: TMenuItem;
    gd: TTimer;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    Ping1: TMenuItem;
    N48: TMenuItem;
    N49: TMenuItem;
    N51: TMenuItem;
    N52: TMenuItem;
    N54: TMenuItem;
    N55: TMenuItem;
    N56: TMenuItem;
    RzTray: TRzTrayIcon;
    jzlst: TTimer;
    N33: TMenuItem;
    N34: TMenuItem;
    suiForm1: TsuiForm;
    Label3: TLabel;
    btn4: TsuiImageButton;
    btn1: TsuiImageButton;
    btn2: TsuiImageButton;
    btn5: TsuiImageButton;
    btn3: TsuiImageButton;
    op1: TsuiImageButton;
    tmr1: TTimer;
    lv1: TListView;
    bclb: TTimer;
    list: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    x1: TMenuItem;
    x2: TMenuItem;
    x3: TMenuItem;
    MenuItem7: TMenuItem;
    x4: TMenuItem;
    x5: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    N35: TMenuItem;
    Panel1: TPanel;
    TrackBar1: TTrackBar;
    SkyAudioMeter1: TSkyAudioMeter;
    Label1: TLabel;
    gundong: TLabel;
    Label2: TLabel;
    suiMainMenu1: TsuiMainMenu;
    M1: TMenuItem;
    N36: TMenuItem;
    N57: TMenuItem;
    N58: TMenuItem;
    N59: TMenuItem;
    N60: TMenuItem;
    N61: TMenuItem;
    N62: TMenuItem;
    L1: TMenuItem;
    N63: TMenuItem;
    N64: TMenuItem;
    N65: TMenuItem;
    N66: TMenuItem;
    MusicBar1: TMenuItem;
    N71: TMenuItem;
    N74: TMenuItem;
    N75: TMenuItem;
    conui: TTimer;
    lst1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N81Click(Sender: TObject);

    procedure btn1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure N38Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure N110Click(Sender: TObject);
    procedure N210Click(Sender: TObject);
    procedure N310Click(Sender: TObject);
    procedure N410Click(Sender: TObject);
    procedure N510Click(Sender: TObject);
    procedure N68Click(Sender: TObject);
    procedure N111Click(Sender: TObject);
    procedure N211Click(Sender: TObject);
    procedure N311Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N72Click(Sender: TObject);
    procedure N73Click(Sender: TObject);
  
    procedure Timer2Timer(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);

    procedure op1Click(Sender: TObject);

    procedure MediaPlayer1Notify(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure N52Click(Sender: TObject);

    procedure N80Click(Sender: TObject);


    procedure N82Click(Sender: TObject);



    procedure VsHotSpot2Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure SinaBlog1Click(Sender: TObject);
    procedure Qzone1Click(Sender: TObject);
    procedure MSNLite1Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N28Click(Sender: TObject);

  
    procedure N32Click(Sender: TObject);
   
    procedure gdTimer(Sender: TObject);
    procedure SkyAudioMeter1Click(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N47Click(Sender: TObject);
    procedure Ping1Click(Sender: TObject);
    procedure N48Click(Sender: TObject);
    procedure N49Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure yhcpuTimer(Sender: TObject);

    procedure jzlstTimer(Sender: TObject);
    procedure SkyAudioMeter1DblClick(Sender: TObject);
    procedure N34Click(Sender: TObject);
   
    procedure miClick(Sender: TObject);

   
    procedure VsHotSpot3Click(Sender: TObject);
    procedure cicleClick(Sender: TObject);
    procedure cicletoendClick(Sender: TObject);
 
    procedure bclbTimer(Sender: TObject);
    procedure lv1DblClick(Sender: TObject);
    procedure lv1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure x1Click(Sender: TObject);
    procedure N35Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure x2Click(Sender: TObject);
    procedure x3Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure x4Click(Sender: TObject);
    procedure x5Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure loadlrc(s: string);
    procedure lv1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure N36Click(Sender: TObject);
    procedure N57Click(Sender: TObject);
    procedure N59Click(Sender: TObject);
    procedure N60Click(Sender: TObject);
    procedure N62Click(Sender: TObject);
    procedure N83Click(Sender: TObject);
    procedure conuiTimer(Sender: TObject);
    procedure N63Click(Sender: TObject);
    procedure N64Click(Sender: TObject);
    procedure N84Click(Sender: TObject);
    procedure N65Click(Sender: TObject);
    procedure MusicBar1Click(Sender: TObject);
    procedure N71Click(Sender: TObject);
    procedure N75Click(Sender: TObject);
    procedure N45Click(Sender: TObject);




  private
     procedure WMWINDOWPOSCHANGING(Var Msg: TWMWINDOWPOSCHANGING);message WM_WINDOWPOSCHANGING;
    { Private declarations }

  public
  procedure DropFiles(var Msg: TMessage); message WM_DropFILES;
  //    procedure SysCommand(var SysMsg: TMessage); message WM_SYSCOMMAND;
 //   procedure WMNID(var msg: TMessage); message WM_NID;
    { Public declarations }
  end;




var
  MainPlay: TMainPlay;
  Positionchange: boolean;
  Include_SubDir: boolean;
  s: integer;
  NotifyIcon: TNotifyIconData;
  Flnm: string;
  xlist: TListItem;
  sumtime :Integer   ;
  s1,s2,gs :string;          //s1:歌手  s2:歌曲名     gs:歌曲格式
  list : TStringlist;     //分离字符串

  fle: string;
  Lrc: TStrings;
  movelrc :string;

implementation

uses Unit6, Unit9, Unit7, Unit4;


{$R *.dfm}

procedure Tmainplay.WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING);
var
WorkDound: TRect;
remove : Word;
begin
remove :=50; //可随意设置，是磁性的范围大小。
WorkDound.Left:=mainplay.left;
WorkDound.Top:=mainplay.Top;
WorkDound.Right:=mainplay.left+mainplay.Width;
WorkDound.Bottom:=mainplay.Top+mainplay.Height;
with Msg.WindowPos^ do
begin
    if (x+cx<WorkDound.Left+remove) then    //左方具有磁性
      if (x+cx>WorkDound.Left-remove)or((x+cx>WorkDound.Left) and (x+cx<WorkDound.Left+remove)) then
        begin
          x:=WorkDound.Left-cx;
        end;
    if (x>WorkDound.Right-remove) then   //右方具有磁性
      if (x<WorkDound.Right+remove)or((x<WorkDound.Right) and (x>WorkDound.Right-remove)) then
        begin
          x:=WorkDound.Right;
        end;
    if (y+cy<WorkDound.Top+remove) then    //上方具有磁性
      if (y+cy>WorkDound.Top-remove)or((y+cy>WorkDound.Top) and (y+cy<WorkDound.Top+remove)) then
        begin
          y:= WorkDound.Top-cy;
        end;
    if (y>WorkDound.Bottom-remove) then   //下方具有磁性
      if (y<WorkDound.Bottom+remove)or((y<WorkDound.Bottom) and (y>WorkDound.Bottom-remove)) then
        begin
          y:= WorkDound.Bottom;
        end;
end;
inherited;
end;

 procedure Tmainplay.loadlrc(s: string);
var
  i: Integer;

begin
  lrc := TStringList.Create;
  if s <> '' then
  begin
    fle := ExtractFileName(s);
    SetLength(fle, Length(ExtractFileName(fle)) - Length(ExtractFileExt(fle)));



    if   FileExists(ExtractFilePath(s) + fle + '.lrc')  then  //存在则加载它
    begin
      lrc.LoadFromFile(ExtractFilePath(s) + fle + '.lrc');

      tmr1.Enabled := True;

    end  else                                              //不存在则联网搜索..
    begin

       serlrc.show;
    end;
       for i := 0 to lrc.Count - 1 do
     begin
   // Form3.lst1.Items.Add(lrc.strings[i]);
     if i>=2 then  //i > 2  是略去标题 -作者 - 专辑信息 【0-2】  2012.3.20

     lst1.Items.Add(Copy(lrc.Strings[i],11, length(lrc.Strings[i])-10));

     //实现[00:01.03]显示  [00:01.03][01:02.50]多行显示正在思考..  2012.3.26
      end;

  end;

   end;



//------------------------支持拖动模块---------------------------------------
procedure Tmainplay.DropFiles(var Msg: TMessage);
var i, Count: integer;
  buffer: array[0..1024] of Char;
begin
  inherited;
  Count := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 256); // 第一次调用得到拖放文件的个数
  for i := 0 to Count - 1 do
  begin
    buffer[0] := #0;
    DragQueryFile(Msg.WParam, i, buffer, sizeof(buffer)); // 第二次调用得到文件名称
    if (ExtractFileExt(buffer) <> '.mp3') and (ExtractFileExt(buffer) <> '.wma')and (ExtractFileExt(buffer) <> '.wav')and(ExtractFileExt(buffer) <> '.mp2') then
    begin
      Application.MessageBox('不支持播放此类文件！', '错误', MB_OK + MB_ICONSTOP + MB_TOPMOST);
      Exit;
    end;
    try
      xlist := lv1.Items.Add;
      xlist.Caption := ExtractFileName(buffer);
      xlist.SubItems.add(ExtractFilePath(buffer));
      MediaPlayer1.FileName := ExtractFilePath(buffer) + xlist.Caption;
      MediaPlayer1.Open;
      skyaudiometer1.active:=true;
      listname.caption:=extractfilename(mediaplayer1.filename);
      trackbar1.Enabled:=true;
      gd.enabled:=true;
      timer1.Enabled:=true;
      timer2.Enabled:=true;
      label1.Caption:='状态:播放' ;
      stat1.panels[0].text:=extractfilename(mediaplayer1.filename);
      MediaPlayer1.Play;
      loadlrc(MediaPlayer1.FileName); //加载歌词文件！
      btn2.Enabled := True;
      btn3.Enabled := true;
      Timer2.Enabled := True;
    except
      on EMCIDeviceError do
        Application.MessageBox('不支持播放此类文件！', '错误', MB_OK + MB_ICONSTOP + MB_TOPMOST);
    end;
  end;
end;


///------------------------------------------------------------------------------------


{procedure Tmainplay.WMNID(var msg: TMessage);
var
  mousepos: TPoint;
begin
  GetCursorPos(mousepos); //获取鼠标位置
  case msg.LParam of
    WM_LBUTTONUP: // 在托盘区点击左键后
      begin
        mainplay.Visible := not mainplay.Visible; // 显示主窗体与否

        Shell_NotifyIcon(NIM_DELETE, @NotifyIcon); // 显示主窗体后删除托盘区的图标
        SetWindowPos(Application.Handle, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW); // 在任务栏显示程序
      end;

    WM_RBUTTONUP: mainpop.Popup(mousepos.X, mousepos.Y); // 弹出菜单
  end;
end;

 }







function ZeroFill(Size: Integer; s: string): string;
var
  a, b: Integer;
  t: string;
begin
  SetLength(t, Size);
  for a := 1 to Size do
    t[a] := '0';
  b := Size;
  for a := Length(s) downto 1 do
  begin
    t[b] := s[a];
    Dec(b); //自减函数 b=b-1
  end;
  ZeroFill := t;

  end;







procedure TMainPlay.N81Click(Sender: TObject);
var
  i: Integer;
  a: Boolean;
begin
  a := False;
  if opendialog1.Execute then
  begin
    for i := 0 to Lv1.Items.Count - 1 do   //  1重for循环控制listview
    begin
      if OpenDialog1.FileName = lv1.Items[i].SubItems.Strings[0] + lv1.Items[i].Caption then
      begin
        a := True;
        MessageBox(Handle, '已存在于播放列表中！', '提示', MB_OK +
          MB_IconInformation);
        lv1.SetFocus;
        Lv1.ItemIndex := i; //选定重复的列表项
        exit;
      end;
    end;
    if a = False then
    begin
    for i:=0 to opendialog1.Files.Count-1 do   //   2重for循环控制opendialog个数
      begin
   
     // Flnm := ExtractFileName(OpenDialog1.FileName);
      xlist := lv1.Items.Add;
      xlist.Caption :=ExtractFileName(opendialog1.Files[i]);
      xlist.SubItems.add(ExtractFilePath(opendialog1.Files[i]));
      btn1.Enabled := true;
      lv1.Items[0].Selected:=true;
       end;
    end;
  end;
end;

procedure Tmainplay.MediaPlayer1Notify(Sender: TObject);
var
  i: Integer;
begin

  with mediaplayer1 do
    if mediaplayer1.Position = mediaplayer1.length then
    begin
      if N2.Checked then //如果选择了顺序播放
      begin
        for i := 0 to lv1.Items.Count do
        begin
          if MediaPlayer1.FileName = lv1.Items[i].SubItems.strings[0] + lv1.Items[i].Caption then
          begin
            lv1.ItemIndex := i;
            Break;
          end;
        end; //此循环语句用于判断当前正在播放的是哪一个列表项
        if lv1.ItemIndex = lv1.Items.Count - 1 then
        begin
          Notify := False;
          skyaudiometer1.Repaint; //重绘一次..
          vision.am2.Repaint;
         btn3Click(Sender); //如果之前播放的是最后一首音乐 则停止播放
        end
        else
        begin
          if (IsIconic(mainplay.Handle) = False) and (IsZoomed(mainplay.Handle) = false) then //此段程序的目的是在托盘状态下连续播放不会出错
          begin
            lv1.ItemIndex := lv1.ItemIndex + 1;
            trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
            skyaudiometer1.Repaint; //重绘一次..
            vision.am2.Repaint;
            btn1Click(Sender);
          end
          else
          begin
            lv1.SetFocus; //选中要播放的列表项
            lv1.ItemIndex := lv1.ItemIndex + 1;
            trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
            skyaudiometer1.Repaint; //重绘一次..
            vision.am2.Repaint;
            btn1Click(Sender);
          end;

        end;

      end;
      if N3.Checked then //如果选择单曲循环
      begin
        mediaplayer1.Position := 0;
        mediaplayer1.Play;
        Notify := true; //则循环播放同一首曲目
      end;

       if N6.Checked then //如果选择单曲播放
      begin
        mediaplayer1.Position := 0;
        mediaplayer1.Play;
        Notify :=false; //则播放完一曲后   停止循环
      end;

      if N8.Checked then //如果选择了列表循环播放
      begin
        for i := 0 to lv1.Items.Count do
        begin
          if MediaPlayer1.FileName = lv1.Items[i].SubItems.strings[0] + lv1.Items[i].Caption then
          begin
            lv1.ItemIndex := i;
            Break;
          end;
        end; //此循环语句用于判断当前正在播放的是哪一个列表项
        if lv1.ItemIndex = lv1.Items.Count - 1 then lv1.ItemIndex := -1; //判断当前播放的项是否是最后一行
        if (IsIconic(mainplay.Handle) = False) and (IsZoomed(mainplay.Handle) = false) then //此段程序的目的是在托盘状态下连续播放不会出错
        begin
          lv1.ItemIndex := lv1.ItemIndex + 1;
          trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
          skyaudiometer1.Repaint; //重绘一次..
          vision.am2.Repaint;
          btn1Click(Sender);
        end
        else
        begin
          lv1.SetFocus; //选中要播放的列表项
          lv1.ItemIndex := lv1.ItemIndex + 1;
          trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
          skyaudiometer1.Repaint; //重绘一次..
          vision.am2.Repaint;
          btn1Click(Sender);
        end;
      end;
      if N7.Checked then  //随机播放
      begin
        Randomize;
        lv1.ItemIndex := Random(lv1.Items.Count - 1); //使用随机函数生成随机的播放项目
        trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
        skyaudiometer1.Repaint; //重绘一次..
        vision.am2.Repaint;
        btn1Click(Sender);
      end;

    end;

end;




procedure TMainPlay.FormCreate(Sender: TObject);

begin
self.ScreenSnap:=True;
self.SnapBuffer:=30;//窗体吸附效果

//--------------------------------------------------------

sumtime:=0;       //标签计数器
label3.Cursor:=crHandPoint;  //鼠标形状
listname.Caption:='暂无文件播放..';
DragAcceptFiles(Handle, True);
PositionChange := False; //设置初始值；
end;

procedure TMainPlay.Timer1Timer(Sender: TObject);
var k:integer;list:Tstringlist;

begin
 with mediaplayer1 do
    if mode in [mpplaying] then //必须先判断播放器状态 否则会出错！
      begin
      Trackbar1.Max := mediaplayer1.Length div 1000; //首先取得文件的长度，并设置为滑块的最大值！
      TrackBar1.Position := MediaPlayer1.Position div 1000; //让播放器随播放进度滑动
      rztray.Hint:=stat1.Panels[0].Text + chr(13)+'  小步静听，静听精彩 !  ';    //rz托盘提示信息


      //分离出歌曲名-歌手 等 信息--------------


      k:= pos('-',stat1.Panels[0].Text);       //先用pos语句判断歌曲名里有没有'-' 否则会出错--edit by bruce 2012.4.3
      if  k>0   then
      begin
      list := TStringlist.Create;
      list.Delimiter :='-' ;
      //list.DelimitedText :=stat1.Panels[0].Text;
      list.DelimitedText :=StringReplace(stat1.Panels[0].Text,' ','',[rfReplaceAll]);//去除空格;
      s1:=list.strings[0];
      s2:= list.Strings[1];
      end else  begin
      s2:= stat1.Panels[0].Text;
      s1:='未知';
      end;
      //-------右键菜单播放控制切换-----
      n17.Caption:='暂停' ;
      n18.Caption:='停止' ;

      end
    else if mode in [mppaused] then
      begin
        //-------右键菜单播放控制切换-----
      n17.Caption:='播放' ;
      n18.Caption:='停止' ;
      end
    else if mode in [mpstopped] then
      begin
       //-------右键菜单播放控制切换-----
      n17.Caption:='播放' ;
      n18.enabled:=false;
      end;
end;




function AddFormDir(F: string): integer; //查找MP3文件的函数
var MP3: integer;
  S: TSearchRec;
  i: Integer;
  a: Boolean;
begin
  mp3 := FindFirst(F, faAnyFile, s); //查找*.mp3
  while mp3 = 0 do
  begin
    Application.ProcessMessages;
    if (S.Attr and faDirectory) = 0 then
    begin
      a := False;
     for i := 0 to mainplay.Lv1.Items.Count - 1 do
      begin
        if GetCurrentDir + '\' + s.Name = mainplay.lv1.Items[i].SubItems.Strings[0] + mainplay.lv1.items[i].Caption then a := True;
      end;
      if a = false then
      begin
        xlist := mainplay.lv1.Items.Add;
        xlist.Caption := s.name;
        xlist.SubItems.add(GetCurrentDir + '\');
        mainplay.btn1.Enabled := true;
      end;

    end;
    MP3 := FindNext(s);
  end;
  result := 1;
end;



procedure TMainPlay.btn1Click(Sender: TObject);
 var
 i:integer;
 k:integer;
 p1,p2:string;          //s1:歌手  s2:歌曲名     gs:歌曲格式
  plist : TStringlist;     //分离字符串

begin
if lv1.ItemIndex <> -1 then //首先判断列表框中是否有内容
  begin
    mediaplayer1.FileName := lv1.Selected.SubItems.Strings[0] + lv1.Selected.Caption; //
    if MediaPlayer1.Mode in [mppaused] then
    begin
      MediaPlayer1.Resume;//恢复播放状态--记忆播放位置
      label1.Caption:='状态:播放 ';
      skyaudiometer1.Open;
      skyaudiometer1.Active:=true;
      vision.am2.Active:=true;
      btn1.Enabled := False;
      btn2.Enabled := True;
    end
    else
    begin
      try
        mediaplayer1.Open;
        mediaplayer1.Play; //播放列表框中选择的文件
        label1.Caption:='状态:播放 ';
        skyaudiometer1.active:=true;

        mediaplayer1.Notify := true;
        btn1.Enabled := false; //播放按钮变为不可用
        btn2.Enabled := true;
        btn3.Enabled := true; //暂停和停止按钮变为可用
        timer1.Enabled := true;
        timer2.Enabled := true;
        gd.Enabled:=true;

        listname.Caption:=extractfilename(MediaPlayer1.FileName);
        trackbar1.Enabled := true;
        stat1.Panels[0].Text :=  ExtractFileName(mediaplayer1.FileName);
         //分离出歌曲名-歌手 等 信息--------------


      k:= pos('-',stat1.Panels[0].Text);       //先用pos语句判断歌曲名里有没有'-' 否则会出错--edit by bruce 2012.4.3
      if  k>0   then
      begin
      plist := TStringlist.Create;
      plist.Delimiter :='-' ;
      //list.DelimitedText :=stat1.Panels[0].Text;
      plist.DelimitedText :=StringReplace(stat1.Panels[0].Text,' ','',[rfReplaceAll]);//去除空格;
      p1:=plist.strings[0];
      p2:= plist.Strings[1];
      end else  begin
      p2:= stat1.Panels[0].Text;
      p1:='未知';
      end;
        rztray.ShowBalloonHint('歌手: '+p1,'    歌曲: ' + copy(p2,0,length(p2)-4),bhiinfo ,10);
        lst1.Clear;
        loadlrc(MediaPlayer1.FileName);

      except
        on EMCIDeviceError do
          MessageBox(Handle, '无法播放，请检查路径或者文件名是否正确！', '错误',
            MB_OK + MB_ICONSTOP);

      end;


    end;
  end;
end;

procedure TMainPlay.N5Click(Sender: TObject);
begin
skyaudiometer1.Close;
skyaudiometer1.Free;
rztray.Destroy;
  rztray.Free;
Shell_NotifyIcon(NIM_DELETE, @NotifyIcon); // 删除托盘图标
  Application.Terminate;
  close;
end;

procedure TMainPlay.N37Click(Sender: TObject);
begin
N38.Checked:=false;  N37.Checked:=true;
skyaudiometer1.AMStyle:=smsSpectrum; //频谱
end;

procedure TMainPlay.N38Click(Sender: TObject);
begin
 N37.Checked:=false;  N38.Checked:=true;
skyaudiometer1.AMStyle:=smsOscillograph; //示波器
end;

procedure TMainPlay.N41Click(Sender: TObject);
begin
n41.checked:=true;
n42.checked:=false;
n43.checked:=false;
skyaudiometer1.wavemode:=svmnubby;
end;

procedure TMainPlay.N42Click(Sender: TObject);
begin
n42.checked:=true;
n41.checked:=false;
n43.checked:=false;
skyaudiometer1.wavemode:=svmLine;
end;

procedure TMainPlay.N43Click(Sender: TObject);
begin
n43.checked:=true;
n42.checked:=false;
n41.checked:=false;
skyaudiometer1.wavemode:=svmdot;
end;

procedure TMainPlay.N110Click(Sender: TObject);
begin
n110.Checked:=true;n210.Checked:=false;n310.Checked:=false;n410.Checked:=false;n510.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=1;
end;

procedure TMainPlay.N210Click(Sender: TObject);
begin
n210.Checked:=true;n110.Checked:=false;n310.Checked:=false;n410.Checked:=false;n510.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=2;
end;

procedure TMainPlay.N310Click(Sender: TObject);
begin
n310.Checked:=true;n210.Checked:=false;n110.Checked:=false;n410.Checked:=false;n510.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=3;
end;

procedure TMainPlay.N410Click(Sender: TObject);
begin
n410.Checked:=true;n210.Checked:=false;n310.Checked:=false;n110.Checked:=false;n510.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=4;
end;

procedure TMainPlay.N510Click(Sender: TObject);
begin
n510.Checked:=true;n210.Checked:=false;n310.Checked:=false;n410.Checked:=false;n110.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=5;
end;

procedure TMainPlay.N68Click(Sender: TObject);
begin
n68.Checked:=true;n210.Checked:=false;n310.Checked:=false;n410.Checked:=false;n510.Checked:=false;n110.Checked:=false;
skyaudiometer1.FreqWidth:=6;
end;

procedure TMainPlay.N111Click(Sender: TObject);
begin
n111.Checked:=true;n211.Checked:=false;n311.Checked:=false;
skyaudiometer1.FreqSpace:=1;
end;

procedure TMainPlay.N211Click(Sender: TObject);
begin
n211.Checked:=true;n111.Checked:=false;n311.Checked:=false;
skyaudiometer1.FreqSpace:=2
end;

procedure TMainPlay.N311Click(Sender: TObject);
begin
 n311.Checked:=true;n211.Checked:=false;n111.Checked:=false;
skyaudiometer1.FreqSpace:=3;
end;

procedure TMainPlay.Timer3Timer(Sender: TObject);
var j:string ; k:integer;
begin

case   dayofweek(now)   of
    1:j:= '星期天 ';
    2:j:= '星期一 ';
    3:j:= '星期二 ';
    4:j:= '星期三 ';
    5:j:= '星期四 ';
    6:j := '星期五 ';
    7:j:= '星期六 ';
    end;

 label3.Caption:=formatdatetime(' yy-mm-dd  ',now)+j+formatdatetime('hh:nn:ss',now) ;
 label3.Left:=label3.Left-1;
 if label3.Left=6 then
 begin

 timer3.Enabled:=false;
 timer4.Enabled:=true;

 end;

end;


procedure TMainPlay.Label3MouseEnter(Sender: TObject);
begin
 label3.Font.Color:=clwhite;
 label3.Font.Size:=9;
label3.Font.Style:=[fsUnderline];
timer3.Enabled:=false;
timer4.Enabled:=false;
end;

procedure TMainPlay.Label3MouseLeave(Sender: TObject);
begin
label3.Font.Color:=clAqua;
 label3.Font.Size:=8;
label3.Font.Style:=[];
timer3.Enabled:=true;
end;

procedure TMainPlay.Timer4Timer(Sender: TObject);
var j:string  ;
begin
case   dayofweek(now)   of
    1:j:= '星期天 ';
    2:j:= '星期一 ';
    3:j:= '星期二 ';
    4:j:= '星期三 ';
    5:j:= '星期四 ';
    6:j := '星期五 ';
    7:j:= '星期六 ';
    end;

 label3.Caption:=formatdatetime(' yy-mm-dd  ',now)+j+formatdatetime('hh:nn:ss',now) ;
 label3.Left:=label3.Left+1;
 if label3.Left=mainplay.Width-label3.Width -6  then
 begin
  timer4.Enabled:=false;
  timer3.Enabled:=true;

 end;
end;

procedure TMainPlay.N22Click(Sender: TObject);
begin
n22.checked:=true;
n72.Checked:=false;
n73.Checked:=false;
skyaudiometer1.ForeColor:=$00A4EE9D;
end;

procedure TMainPlay.N72Click(Sender: TObject);
begin
n72.checked:=true;
n22.Checked:=false;
n73.Checked:=false;
skyaudiometer1.ForeColor:=$000080FF;
end;

procedure TMainPlay.N73Click(Sender: TObject);
begin
n73.checked:=true;
n72.Checked:=false;
n22.Checked:=false;
skyaudiometer1.ForeColor:=$00DBA7F3;
end;



procedure TMainPlay.Timer2Timer(Sender: TObject);
begin
with mediaplayer1 do
    if mode in [mpplaying] then
    begin

      TrackBar1.Max := MediaPlayer1.Length div 1000;
      stat1.Panels[2].Text :='时长:'+ ZeroFill(2, IntToStr(TrackBar1.max div 60))
        + ':' + ZeroFill(2, IntToStr(TrackBar1.max mod 60)) + '   ';

      TrackBar1.Position := Position div 1000;
      stat1.Panels[1].Text := ZeroFill(2, IntToStr(TrackBar1.Position div 60))
        + ':' + ZeroFill(2, IntToStr(TrackBar1.Position mod 60));

       label2.Caption:=ZeroFill(2, IntToStr(TrackBar1.Position div 60))
        + ':' + ZeroFill(2, IntToStr(TrackBar1.Position mod 60));

       
    end;
end;

procedure TMainPlay.btn2Click(Sender: TObject);
begin
 case mediaplayer1.Mode of
    mpplaying:
      begin
        mediaplayer1.Pause;
        label1.Caption:='状态:暂停 ';
        label2.Caption:=ZeroFill(2, IntToStr(TrackBar1.Position div 60))
        + ':' + ZeroFill(2, IntToStr(TrackBar1.Position mod 60));

        skyaudiometer1.active:=false;
        vision.am2.Active:=false;
        btn1.Enabled := True;
        btn2.Enabled := False;
      end;
  end;
end;

procedure TMainPlay.btn3Click(Sender: TObject);
begin
case mediaplayer1.Mode of
    mpplaying:
      begin
        label1.Caption:='状态:停止 ';
        label2.Caption:='00:00';

        skyaudiometer1.Repaint;// 用repaint方法实现频谱的重绘...... 2012.4.3  edit by bruce
        sleep(50);
        vision.am2.Active:=false;
        vision.am2.repaint;
        vision.am2.Repaint;
        MediaPlayer1.Stop;
        TrackBar1.Position := 0;
        btn1.Enabled := true;
        btn2.Enabled := false;
        btn3.Enabled := false;
        trackbar1.Enabled := false;
        stat1.Panels[0].Text := '停止播放';
        listname.Caption:='暂无文件播放..';
    end;
  end;
end;



procedure TMainPlay.btn4Click(Sender: TObject);
var
  i: Integer;
begin
  if lv1.ItemIndex = -1 then exit; //如果列表为空，则不执行语句
  with mediaplayer1 do //使用判断播放器状态语句，不至于直接执行Mediaplayer.stop，那样会出错！
    if mode in [mpopen, mpplaying] then
    begin
      for i := 0 to lv1.Items.Count do
      begin
        if MediaPlayer1.FileName = lv1.Items[i].SubItems.strings[0] + lv1.Items[i].Caption then //和第一列第I行比较
        begin
          lv1.ItemIndex := i;
          skyaudiometer1.active:=false;
          Break;
        end;
      end; //此循环语句用于判断当前正在播放的是哪一个列表项
      if lv1.ItemIndex > 0 then // 保证列表框中有内容，才执行下面语句，否则也会出错！
      begin
        btn3click(sender);
        lv1.SetFocus;
        lv1.ItemIndex := lv1.ItemIndex - 1;
        btn1Click(Sender);
      end;
    end
    else
    begin
      if lv1.ItemIndex > 0 then // 保证列表框中有内容，才执行下面语句，否则也会出错！
      begin
        lv1.SetFocus;
        lv1.ItemIndex := lv1.ItemIndex - 1;
      end;
    end;
end;



procedure TMainPlay.op1Click(Sender: TObject);
begin
n81click(sender);
end;


procedure TMainPlay.N2Click(Sender: TObject);
begin
n2.checked:=true;
n3.Checked:=false;
n6.Checked:=false;
n7.Checked :=false ;
n8.Checked :=false;
end;

procedure TMainPlay.N3Click(Sender: TObject);
begin
n3.checked:=true;
n2.Checked:=false;
n6.Checked:=false;
n7.Checked :=false ;
n8.Checked :=false;
end;

procedure TMainPlay.N6Click(Sender: TObject);
begin
n6.checked:=true;
n3.Checked:=false;
n2.Checked:=false;
n7.Checked :=false ;
n8.Checked :=false;
end;

procedure TMainPlay.N7Click(Sender: TObject);
begin
n7.checked:=true;
n3.Checked:=false;
n6.Checked:=false;
n2.Checked :=false;
n8.Checked :=false;
end;

procedure TMainPlay.N8Click(Sender: TObject);
begin
n8.checked:=true;
n3.Checked:=false;
n6.Checked:=false;
n7.Checked :=false ;
n2.Checked :=false;
end;

procedure TMainPlay.N9Click(Sender: TObject);
var //添加文件夹中的MP3,wma文件
  dir: string;
  S: TSearchRec;
begin
  if selectdirectory('请选择目录', '', dir) then
  begin
    ChDir(Dir); //设置当前路径为搜索目录
    AddFormDir('*.mp3');
    AddFormDir('*.wma');
    AddFormDir('*.wav');
  end;
  FindClose(s);
end;

procedure TMainPlay.btn5Click(Sender: TObject);
var
  i: Integer;
begin
  if lv1.ItemIndex = -1 then exit;
  with mediaplayer1 do
    if mode in [mpopen, mpplaying] then
    begin
      for i := 0 to lv1.Items.Count - 1 do
      begin
        if MediaPlayer1.FileName = lv1.Items[i].SubItems.strings[0] + lv1.Items[i].Caption then //此循环语句用于判断当前正在播放的是哪一个列表项
        begin
          lv1.ItemIndex := i;
          skyaudiometer1.active:=false;
          Break;
        end;
      end;
      if lv1.ItemIndex <> lv1.Items.count - 1 then //如果当前播放的不是最后一首
      begin
        btn3click(sender);
        lv1.SetFocus;
        lv1.ItemIndex := lv1.ItemIndex + 1;
        btn1Click(Sender);
      end;
    end
    else
    begin
      if lv1.ItemIndex = lv1.Items.count - 1 then Exit;
      lv1.SetFocus;
      lv1.ItemIndex := lv1.ItemIndex + 1;
    end;
end;

procedure TMainPlay.N52Click(Sender: TObject);
begin
winexec('shutdown -R -t 0',0);
end;




procedure TMainPlay.N80Click(Sender: TObject);
begin
mainplay.Left:=screen.Width;


end;




procedure TMainPlay.N82Click(Sender: TObject);
begin
serlrc.show;
end;






procedure TMainPlay.VsHotSpot2Click(Sender: TObject);
begin
n5click(sender);
end;

procedure TMainPlay.TrackBar1Change(Sender: TObject);
begin
 if trackbar1.Position <> mediaplayer1.Position div 1000 then Positionchange := true;
  if positionchange then //如果不设置此布尔型变量，则TIMER事件发生一次就触发本事件发生，会令音乐播放很卡，不连续
  begin
    with mediaplayer1 do
    begin
      if mode in [mpopen, mpplaying] then //判断播放器状态，如果为打开或者播放状态，则执行下面的语句
      begin
        timer1.Enabled := false;
        position := trackbar1.Position * 1000;
        play;
        timer1.Enabled := true;

      end;
    end;
  end;
  Positionchange := false; //恢复为FALSE，如果不这样做，拖拉一次滑块后，则会让音乐不连续
end;

procedure TMainPlay.N11Click(Sender: TObject);
begin
form4.show;
end;

procedure TMainPlay.N10Click(Sender: TObject);
begin
MessageBox(Handle, '注意歌词书写规范，否则可能加载歌词时错误！~~~~~反馈邮箱：qhdsofeware@163.com~~~~~QQ:654714226', PChar('BruceMusicBar~~ 2012~03'), MB_OK);
end;

procedure TMainPlay.SinaBlog1Click(Sender: TObject);
begin
ShellExecute(handle, 'open','http://blog.sina.com.cn/u/1843375347','SINABLOG',nil, SW_SHOWNORMAL);
end;

procedure TMainPlay.Qzone1Click(Sender: TObject);
begin
ShellExecute(handle, 'open','http://user.qzone.qq.com/654714226?ptlang=2052','Qzone',nil, SW_SHOWNORMAL);
end;

procedure TMainPlay.MSNLite1Click(Sender: TObject);
begin
ShellExecute(handle, 'open','https://skydrive.live.com/?cid=167e4f5d97555488','MSNSKY',nil, SW_SHOWNORMAL);
end;

procedure TMainPlay.N17Click(Sender: TObject);
begin
if n17.Caption='播放' then
begin
btn1click(sender);
end
else if n17.Caption='暂停' then
btn2click(sender);
end;

procedure TMainPlay.N18Click(Sender: TObject);
begin
btn3click(sender);
end;

procedure TMainPlay.N20Click(Sender: TObject);
begin
 if MediaPlayer1.Mode in [mpplaying] then
  begin
    MediaPlayer1.Position := TrackBar1.Position * 1000 + 2000;
    mediaplayer1.play;
  end;
end;

procedure TMainPlay.N21Click(Sender: TObject);
begin
 if MediaPlayer1.Mode in [mpplaying] then
  begin
    MediaPlayer1.Position := TrackBar1.Position * 1000 - 2000;
    mediaplayer1.play;
  end;
end;

procedure TMainPlay.N24Click(Sender: TObject);
begin
btn4click(sender);
end;

procedure TMainPlay.N25Click(Sender: TObject);
begin
btn5click(sender);
end;

procedure TMainPlay.N27Click(Sender: TObject);
begin
 mcisendstring('set cdaudio door open wait', nil, 0, handle);//弹出
end;

procedure TMainPlay.N28Click(Sender: TObject);
begin
 mcisendstring('set cdaudio door closed wait', nil, 0, handle); //关闭
end;



procedure TMainPlay.N32Click(Sender: TObject);
var
  v:LongInt;
begin
  case N32.Checked of
     False:
     begin
    N32.Checked:=True;
    n32.caption:='取消静音';



    v := (0 shl 8) or (0 shl 24);
    waveOutSetVolume(0, v);
     end;

      true:
    begin
    N32.Checked:=False;
    N32.Caption:='静音';
    v := (255 shl 8) or (255 shl 24);
    waveOutSetVolume(0, v);

    end;
  end;

end;




procedure TMainPlay.gdTimer(Sender: TObject);   //计时器 控制标签的切换
begin


gs:=copy(s2,length(s2)-2,length(s2)) ;     //标签文字移动--时钟控件

if sumtime mod 16 = 0 then
begin
gundong.caption:=stat1.Panels[2].Text;
end

else
if sumtime mod 16 = 4 then
begin
gundong.Caption:='歌曲:' + copy(s2,0,length(s2)-4);
end

else
if sumtime mod 16 = 8 then
begin
gundong.Caption:='歌手:' + s1;
end;

if sumtime mod 16 = 12 then
begin
gundong.Caption:='格式-' + gs +' 44Khz' +' 128Kbps';
end;
 sumtime:=sumtime + 1;
end;

procedure TMainPlay.SkyAudioMeter1Click(Sender: TObject);
begin
if skyaudiometer1.AMStyle = smsSpectrum then
  begin
  skyaudiometer1.AMStyle := smsOscillograph ;
  n38.Checked:=true;
  n37.Checked:=false ;
  end
  else begin
           skyaudiometer1.AMStyle := smsSpectrum ;
           n38.Checked:=false;
           n37.Checked:=true;
       end;
end;



procedure TMainPlay.FormClose(Sender: TObject; var Action: TCloseAction);
begin
application.Terminate;
end;

procedure TMainPlay.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
skyaudiometer1.free;
rztray.Free;
end;



procedure TMainPlay.N47Click(Sender: TObject);
begin
winexec(Pchar('notepad'),sw_Show);
end;

procedure TMainPlay.Ping1Click(Sender: TObject);
begin

 winexec(pchar('cmd   /c ipconfig >>D:\Ip.txt'),sw_show); // ipconfig 执行结果累加到 c:\2.txt 文件中
 ShellExecute(handle, 'open','D:\Ip.txt','IP',nil, SW_SHOWNORMAL);
 winexec(pchar('cmd   /c ipconfig >D:\Ip.txt'),sw_show);  //最新的一次结果保存到 c:\2.txt 文件中

end;

procedure TMainPlay.N48Click(Sender: TObject);
begin
winexec(Pchar('cmd'),sw_Show);//控制面板
end;

procedure TMainPlay.N49Click(Sender: TObject);
begin
 winexec(Pchar('RegEdit'),sw_Show);
end;

procedure TMainPlay.N51Click(Sender: TObject);
begin
winexec(pchar('cmd /c shutdown -s -t 0'),sw_shownormal);
end;

procedure TMainPlay.yhcpuTimer(Sender: TObject);
begin

if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    Application.ProcessMessages;
end;

end;



procedure TMainPlay.jzlstTimer(Sender: TObject);
 var
  buf: Tstringlist;
  i,j: Integer;
  F:   Textfile;
begin
jzlst.Enabled:=false;
//---------------------------自动加载列表---created by bruce 2012.4.4

 if FileExists(ExtractFilePath(ParamStr(0))+'bruce.m3u8')=true then
 begin
     {AssignFile(F,  ExtractFilePath(ParamStr(0))+'bruce.m3u8'); //判断是否为空文本
        Reset(F);
        if   filesize(F) > 0   then        //空文本推出---2012.4.6--by bruce

        begin }
          buf := tstringlist.create;
          buf.loadfromfile(ExtractFilePath(ParamStr(0))+'bruce.m3u8');

          for i := 0 to buf.Count - 1 do
           begin
            xlist := lv1.Items.Add;//这个得放在xlist.Caption 的上句，每使用一次增加一行
            xlist.Caption := ExtractFileName(buf.Strings[i]);
            xlist.SubItems.add(ExtractFilePath(buf.Strings[i]));
            xlist.SubItems.add(inttostr(i+1));  //3列家载序号..edited by bruce --2012.4.13

           end;
           buf.free;
         //  lv1.Items[0].Selected;
         btn1.Enabled := True;
       // btn1click(sender);
         end;

        end;
//-------------------------------自动加载列表---created by bruce 2012.4.4


procedure TMainPlay.SkyAudioMeter1DblClick(Sender: TObject);
begin
if  SkyAudioMeter1.AMStyle=smsSpectrum then
begin
 vision.am2.AMStyle:=smsSpectrum ; vision.ppfx.Checked:=true; vision.sbq.Checked:=false;
end else begin
vision.am2.AMStyle:=smsOscillograph  ;  vision.ppfx.Checked:=false; vision.sbq.Checked:=true;
end;
 vision.width:=screen.Width;
vision.height:=screen.Height;
if mediaplayer1.mode in [mpplaying] then
begin
vision.am2.active:=true;
vision.Show;
end;

end;

procedure TMainPlay.N34Click(Sender: TObject);
begin
SkyAudioMeter1dblclick(sender);
end;


procedure TMainPlay.miClick(Sender: TObject);
begin
n80click(sender);
end;




procedure TMainPlay.VsHotSpot3Click(Sender: TObject);
begin
mainpop.Popup( (screen.Width-mainplay.left),390);
end;

procedure TMainPlay.cicleClick(Sender: TObject);
begin
n8click(sender);
rztray.ShowBalloonHint('','已切换至列表循环模式',bhiInfo,10);
end;

procedure TMainPlay.cicletoendClick(Sender: TObject);
begin
n2click(sender);
rztray.ShowBalloonHint('','已切换至顺序播放模式',bhiInfo,10);
end;





procedure TMainPlay.bclbTimer(Sender: TObject);
var
  plylst: TStrings;
  i: Integer;
begin
                 //列表change时自动保存列表---created by bruce 2012.4.4---
    plylst := TStringList.Create;
    for i := 0 to lv1.Items.Count - 1 do //利用循环语句保存listview到播放列表
    begin
    plylst.Add(lv1.Items[i].SubItems.Strings[0] + lv1.Items[i].Caption);
    end;
    plylst.SaveToFile(ExtractFilePath(ParamStr(0))+'bruce.m3u8');
    plylst.Free;
end;

procedure TMainPlay.lv1DblClick(Sender: TObject);
begin
if lv1.ItemIndex <> -1 then //首先判断列表内容是否为空，不为空执行下面的语句
  begin

    mainplay.btn1Click(sender);
  end;
end;

procedure TMainPlay.lv1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
bclb.Enabled:=true;
end;

procedure TMainPlay.x1Click(Sender: TObject);
begin
mainplay.N81Click(sender);
end;

procedure TMainPlay.N35Click(Sender: TObject);
begin
mainplay.n9click(sender);
end;

procedure TMainPlay.MenuItem2Click(Sender: TObject);
begin
mainplay.N81Click(sender);
end;

procedure TMainPlay.x2Click(Sender: TObject);
begin
Lv1.DeleteSelected; //删除选中的列表项
end;

procedure TMainPlay.x3Click(Sender: TObject);
begin
if MessageBox(Handle, '确实要删除此文件吗？', PChar('确认删除'), MB_yesno + MB_ICONINFORMATION) = idyes then
  begin
    with mainplay.mediaplayer1 do
      if mode in [mpplaying] then
      begin
        mainplay.btn3Click(sender); //如果在播放状态则停止播放
        deletefile(Lv1.Selected.SubItems.Strings[0] + lv1.Selected.Caption); //删除文件
        lv1.DeleteSelected; //删除选中的列表项
      end
      else
      begin
        deletefile(Lv1.Selected.SubItems.Strings[0] + lv1.Selected.Caption); //删除文件
        lv1.DeleteSelected; //删除选中的列表项
      end;
  end;
end;

procedure TMainPlay.MenuItem7Click(Sender: TObject);
begin
 Lv1.Clear;
end;

procedure TMainPlay.x4Click(Sender: TObject);
var
  filename : string;
  sei : TShellExecuteInfo;
begin

        filename:=lv1.Selected.SubItems.Strings[0]+lv1.Selected.Caption;//获取具体路径和文件名
        FillChar(sei,SizeOf(sei),#0);
        sei.cbSize:=SizeOf(sei);
        sei.lpFile:=PChar(filename);
        sei.lpVerb:='properties';
        sei.fMask:=SEE_MASK_INVOKEIDLIST;
        ShellExecuteEx(@sei);



end;

procedure TMainPlay.x5Click(Sender: TObject);
begin
ShellExecute(Application.Handle, 'open', pChar(lv1.Selected.SubItems[0]), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TMainPlay.MenuItem11Click(Sender: TObject);
begin
lv1.viewstyle:=vsIcon;
n11.Checked:=true;
n12.Checked:=false;
n13.Checked:=false;
end;

procedure TMainPlay.MenuItem12Click(Sender: TObject);
begin
lv1.viewstyle:=vslist;
n12.Checked:=true;
n11.Checked:=false;
n13.Checked:=false;
end;

procedure TMainPlay.MenuItem13Click(Sender: TObject);
begin
lv1.viewstyle:=vsreport;
n13.Checked:=true;
n12.Checked:=false;
n11.Checked:=false;
end;

procedure TMainPlay.tmr1Timer(Sender: TObject);
var
  i: Integer;
  begin

  for i := 0 to lrc.Count - 1 do
  begin
     if (mainplay.stat1.Panels[1].Text = Copy(lrc.Strings[i], 2, 5)) then
        begin
          lst1.ItemIndex := i-2;
          lst1.TopIndex:= i-10;
         


         end;
      end;
  end;


procedure TMainPlay.lv1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if lv1.ItemIndex = -1 then //如果所在位置没有内容
  begin
    x1.Enabled := False; //则播放菜单不可用
    x2.Enabled := False; //删除菜单不可使用
    x3.Enabled := False; //删除菜单不可使用
    x4.Enabled := False;  //浏览功能不能用
    x5.Enabled:=False;   //属性信息........
  end
  else
  begin
    x1.Enabled := True;
    x2.Enabled := True;
    x3.Enabled := True;
    x4.Enabled := true;
    x5.Enabled:=True;
    ; //否则的话恢复为播放和删除菜单可用，并选中列表项
  end;
end;

procedure TMainPlay.N36Click(Sender: TObject);
begin
n81.click;
end;

procedure TMainPlay.N57Click(Sender: TObject);
begin
n9.Click;
end;

procedure TMainPlay.N59Click(Sender: TObject);
begin
lv1.Clear;
end;

procedure TMainPlay.N60Click(Sender: TObject);
begin
lv1.DeleteSelected;
end;

procedure TMainPlay.N62Click(Sender: TObject);
begin
close;
end;

procedure TMainPlay.N83Click(Sender: TObject);
begin
opendialog3.Filter:='LRC歌词文件|*.LRC'  ;
if opendialog3.Execute then

 lst1.Items.LoadFromFile(opendialog3.FileName);
lst1.Items.SaveToFile(ExtractFilePath(mainplay.MediaPlayer1.FileName)+copy(extractfilename(mainplay.MediaPlayer1.FileName),0,length(extractfilename(mainplay.MediaPlayer1.FileName))-4)+'.lrc');
loadlrc(mediaplayer1.FileName) ;
end;

procedure TMainPlay.conuiTimer(Sender: TObject);
begin
lv1.Left:=suiform1.left+4;
lv1.Width:=suiform1.Width-281-8 ;
lst1.Left:=lv1.Left+lv1.Width+1;
lst1.Width:=281 ;
lv1.Top:=168;lv1.Height:=suiform1.Height-180;
lst1.Top:=168;lst1.Height:=suiform1.Height-180;
panel1.left :=180;skyaudiometer1.Left:=203;
panel1.Width:=suiform1.Width-180-10;skyaudiometer1.Width:=panel1.Width-23-200;
trackbar1.Left:=100; trackbar1.Width:= panel1.Width-112;



end;

procedure TMainPlay.N63Click(Sender: TObject);
begin
n83.Click;
end;

procedure TMainPlay.N64Click(Sender: TObject);
begin
editlrc.Show;
end;

procedure TMainPlay.N84Click(Sender: TObject);
begin
editlrc.Show;
end;

procedure TMainPlay.N65Click(Sender: TObject);
begin
serlrc.Show;
end;

procedure TMainPlay.MusicBar1Click(Sender: TObject);
begin
form4.Show;
end;

procedure TMainPlay.N71Click(Sender: TObject);
begin
MessageBox(Handle, '刚写完千千动听，受到FooBar2000启发，重新编写成FooBar界面UI  2012.05.05 By Bruce', PChar('Bruce MusicBar  2012~05'), MB_OK);
end;

procedure TMainPlay.N75Click(Sender: TObject);
begin
ShellExecute(handle, 'open','http://user.qzone.qq.com/654714226?ptlang=2052','Qzone',nil, SW_SHOWNORMAL);
ShellExecute(handle, 'open','http://blog.sina.com.cn/u/1843375347','SINABLOG',nil, SW_SHOWNORMAL);
end;

procedure TMainPlay.N45Click(Sender: TObject);
begin
application.Minimize;

end;

end.


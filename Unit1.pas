unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, MPlayer, Registry, Mmsystem, FileCtrl,
  Menus, ShellAPI, AppEvnts, Buttons, ImgList, SkyAudioMeter, WinSkinData;
const WM_NID = WM_User + 1000;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    TrackBar1: TTrackBar;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    Timer2: TTimer;
    N3: TMenuItem;
    PopupMenu2: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    OpenDialog2: TOpenDialog;
    SaveDialog1: TSaveDialog;
    mm1: TMainMenu;
    N9: TMenuItem;
    N10: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    CDDVDROM1: TMenuItem;
    CDDVDROM2: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    btn2: TBitBtn;
    btn3: TBitBtn;
    btn4: TBitBtn;
    btn5: TBitBtn;
    N23: TMenuItem;
    btn6: TBitBtn;
    btn7: TBitBtn;
    N11: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N12: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    lbl2: TLabel;
    stat1: TStatusBar;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    il1: TImageList;
    btn1: TBitBtn;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    SkyAudioMeter1: TSkyAudioMeter;
    TrackBar2: TTrackBar;
    chk1: TCheckBox;
    SpeedButton8: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    GroupBox2: TGroupBox;
    lv1: TListView;
    PopupMenu3: TPopupMenu;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    N45: TMenuItem;
    N47: TMenuItem;
    N48: TMenuItem;
    N49: TMenuItem;
    N50: TMenuItem;
    N51: TMenuItem;
    N53: TMenuItem;
    N52: TMenuItem;
    N101: TMenuItem;
    N201: TMenuItem;
    N301: TMenuItem;
    N401: TMenuItem;
    N501: TMenuItem;
    N601: TMenuItem;
    N70701: TMenuItem;
    N801: TMenuItem;
    N901: TMenuItem;
    N54: TMenuItem;
    listname: TMenuItem;
    SkinData1: TSkinData;
    N55: TMenuItem;
    QQ1: TMenuItem;
    MSN1: TMenuItem;
    N56: TMenuItem;
    N57: TMenuItem;
    N58: TMenuItem;
    N59: TMenuItem;
    N60: TMenuItem;
    N61: TMenuItem;
    IP1: TMenuItem;
    N62: TMenuItem;
    N63: TMenuItem;
    N64: TMenuItem;
    N65: TMenuItem;
    N66: TMenuItem;
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
    N70: TMenuItem;
    N71: TMenuItem;
    Label3: TLabel;
    Timer3: TTimer;
    Timer4: TTimer;
    N15: TMenuItem;
    N22: TMenuItem;
    N72: TMenuItem;
    N73: TMenuItem;
    Itunes1: TMenuItem;
    N74: TMenuItem;
    N46: TMenuItem;
    N75: TMenuItem;
    N76: TMenuItem;
    N77: TMenuItem;
    mover: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure ClearPlaylistClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    {procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);}
    procedure N2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure MediaPlayer1Notify(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure CDDVDROM1Click(Sender: TObject);
    procedure CDDVDROM2Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure OpenDialog2Close(Sender: TObject);
    procedure SaveDialog1Close(Sender: TObject);
    procedure lv1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lv1DblClick(Sender: TObject);
    procedure OpenDialog1Close(Sender: TObject);
    procedure chk1Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N35Click(Sender: TObject);
    procedure N36Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure N38Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure N43Click(Sender: TObject);
   
    procedure N52Click(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure N201Click(Sender: TObject);
    procedure N301Click(Sender: TObject);
    procedure N401Click(Sender: TObject);
    procedure N501Click(Sender: TObject);
    procedure N601Click(Sender: TObject);
    procedure N70701Click(Sender: TObject);
    procedure N801Click(Sender: TObject);
    procedure N901Click(Sender: TObject);
    procedure QQ1Click(Sender: TObject);
    procedure N56Click(Sender: TObject);
    procedure MSN1Click(Sender: TObject);
    procedure N59Click(Sender: TObject);
    procedure N60Click(Sender: TObject);
    procedure N62Click(Sender: TObject);
    procedure IP1Click(Sender: TObject);
    procedure N61Click(Sender: TObject);
    procedure N63Click(Sender: TObject);
    procedure N110Click(Sender: TObject);
    procedure N210Click(Sender: TObject);
    procedure N310Click(Sender: TObject);
    procedure N410Click(Sender: TObject);
    procedure N510Click(Sender: TObject);
    procedure N68Click(Sender: TObject);
    procedure N111Click(Sender: TObject);
    procedure N211Click(Sender: TObject);
    procedure N311Click(Sender: TObject);
    procedure N70Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label3MouseLeave(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GroupBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GroupBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N71Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N72Click(Sender: TObject);
    procedure N73Click(Sender: TObject);
    procedure N46Click(Sender: TObject);
    procedure Itunes1Click(Sender: TObject);
    procedure N74Click(Sender: TObject);
    procedure N75Click(Sender: TObject);
    procedure N76Click(Sender: TObject);
    procedure N77Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure moverTimer(Sender: TObject);
    procedure FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
      private
    procedure DropFiles(var Msg: TMessage); message WM_DropFILES;
    procedure SysCommand(var SysMsg: TMessage); message WM_SYSCOMMAND;
    procedure WMNID(var msg: TMessage); message WM_NID;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Positionchange: boolean;
  Include_SubDir: boolean;
  s: integer;
  NotifyIcon: TNotifyIconData;
  Flnm: string;
  xlist: TListItem;
implementation

uses  Unit3, Unit4;

{$R *.dfm}

procedure TForm1.SysCommand(var SysMsg: TMessage);
begin
  case SysMsg.WParam of
    SC_CLOSE: // 当关闭时
      begin
        SetWindowPos(Application.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_HIDEWINDOW);
        Hide; // 在任务栏隐藏程序
      // 在托盘区显示图标
        with NotifyIcon do
        begin
          cbSize := SizeOf(TNotifyIconData);
          Wnd := Handle;
          uID := 1;
          uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
          uCallBackMessage := WM_NID;
          hIcon := Application.Icon.Handle;
          szTip := '小步静听~静听精彩！';
        end;

        Shell_NotifyIcon(NIM_ADD, @NotifyIcon); // 在托盘区显示图标
      end;
  else
    inherited;
  end;

end;


procedure TForm1.WMNID(var msg: TMessage);
var
  mousepos: TPoint;
begin
  GetCursorPos(mousepos); //获取鼠标位置
  case msg.LParam of
    WM_LBUTTONUP: // 在托盘区点击左键后
      begin
        Form1.Visible := not Form1.Visible; // 显示主窗体与否

        Shell_NotifyIcon(NIM_DELETE, @NotifyIcon); // 显示主窗体后删除托盘区的图标
        SetWindowPos(Application.Handle, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW); // 在任务栏显示程序
      end;

    WM_RBUTTONUP: PopupMenu2.Popup(mousepos.X, mousepos.Y); // 弹出菜单
  end;
end;

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



procedure TForm1.Timer1Timer(Sender: TObject);
begin
  with mediaplayer1 do
    if mode in [mpplaying] then //必须先判断播放器状态 否则会出错！
    begin
      Trackbar1.Max := mediaplayer1.Length div 1000; //首先取得文件的长度，并设置为滑块的最大值！
      TrackBar1.Position := MediaPlayer1.Position div 1000; //让播放器随播放进度滑动
    end;

end;

procedure TForm1.DropFiles(var Msg: TMessage);
var i, Count: integer;
  buffer: array[0..1024] of Char;
begin
  inherited;
  Count := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 256); // 第一次调用得到拖放文件的个数
  for i := 0 to Count - 1 do
  begin
    buffer[0] := #0;
    DragQueryFile(Msg.WParam, i, buffer, sizeof(buffer)); // 第二次调用得到文件名称
    if (ExtractFileExt(buffer) <> '.mp3') and (ExtractFileExt(buffer) <> '.wma')and (ExtractFileExt(buffer) <> '.wav') then
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
      timer1.Enabled:=true;
      timer2.Enabled:=true;
      label1.Caption:='状态:播放' ;
      stat1.panels[0].text:=extractfilename(mediaplayer1.filename);
      MediaPlayer1.Play;
      if chk1.Checked=True then Form3.loadlrc(MediaPlayer1.FileName); //加载歌词文件！
      btn2.Enabled := True;
      btn3.Enabled := true;
      Timer2.Enabled := True;
    except
      on EMCIDeviceError do
        Application.MessageBox('不支持播放此类文件！', '错误', MB_OK + MB_ICONSTOP + MB_TOPMOST);
    end;
  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
label3.Cursor:=crHandPoint;
listname.Caption:='暂无文件播放..';
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    Application.ProcessMessages;
  end;

  DragAcceptFiles(Handle, True);
  PositionChange := False; //设置初始值；
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @NotifyIcon); // 删除托盘图标
end;

procedure TForm1.Button8Click(Sender: TObject);
begin //关闭光驱

end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  if lv1.ItemIndex <> -1 then //首先判断列表内容是否为空，不为空执行下面的语句
  begin
    btn1Click(sender);
  end;

end;

procedure TForm1.TrackBar2Change(Sender: TObject); //音量控制(调节全部音量）
var
  t, v: Longint;
begin
  t := TrackBar2.Position;
  v := (t shl 8) or (t shl 24);
  waveOutSetVolume(0, v);
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
      for i := 0 to Form1.lv1.Items.Count - 1 do
      begin
        if GetCurrentDir + '\' + s.Name = Form1.Lv1.Items[i].SubItems.Strings[0] + form1.lv1.items[i].Caption then a := True;
      end;
      if a = false then
      begin
        xlist := Form1.lv1.Items.Add;
        xlist.Caption := s.name;
        xlist.SubItems.add(GetCurrentDir + '\');
        form1.btn1.Enabled := true;
      end;

    end;
    MP3 := FindNext(s);
  end;
  result := 1;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  case mediaplayer1.Mode of
    mpplaying:
      begin
        mediaplayer1.Pause;
        label1.Caption:='状态:暂停 ';
        label2.Caption:=ZeroFill(2, IntToStr(TrackBar1.Position div 60))
        + ':' + ZeroFill(2, IntToStr(TrackBar1.Position mod 60));
        skyaudiometer1.active:=false;
        btn1.Enabled := True;
        btn2.Enabled := False;
      end;
  end;
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
label1.Caption:='状态:停止 ';
        label2.Caption:='00:00';
  skyaudiometer1.active:=false;
  MediaPlayer1.Stop;
  TrackBar1.Position := 0;
  btn1.Enabled := true;
  btn2.Enabled := false;
  btn3.Enabled := false;
  trackbar1.Enabled := false;
  stat1.Panels[0].Text := '停止播放';
  listname.Caption:='暂无文件播放..';
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    Application.ProcessMessages;
  end;

end;

procedure TForm1.btn4Click(Sender: TObject);
var
  i: Integer;
begin
  if Lv1.ItemIndex = -1 then exit; //如果列表为空，则不执行语句
  with mediaplayer1 do //使用判断播放器状态语句，不至于直接执行Mediaplayer.stop，那样会出错！
    if mode in [mpopen, mpplaying] then
    begin
      for i := 0 to Lv1.Items.Count do
      begin
        if MediaPlayer1.FileName = lv1.Items[i].SubItems.strings[0] + Lv1.Items[i].Caption then //和第一列第I行比较
        begin
          lv1.ItemIndex := i;
          skyaudiometer1.active:=false;
          Break;
        end;
      end; //此循环语句用于判断当前正在播放的是哪一个列表项
      if lv1.ItemIndex > 0 then // 保证列表框中有内容，才执行下面语句，否则也会出错！
      begin
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
        Lv1.ItemIndex := lv1.ItemIndex - 1;
      end;
    end;
end;

procedure TForm1.btn5Click(Sender: TObject);
var
  i: Integer;
begin
  if Lv1.ItemIndex = -1 then exit;
  with mediaplayer1 do
    if mode in [mpopen, mpplaying] then
    begin
      for i := 0 to Lv1.Items.Count - 1 do
      begin
        if MediaPlayer1.FileName = lv1.Items[i].SubItems.strings[0] + Lv1.Items[i].Caption then //此循环语句用于判断当前正在播放的是哪一个列表项
        begin
          Lv1.ItemIndex := i;
          skyaudiometer1.active:=false;
          Break;
        end;
      end;
      if lv1.ItemIndex <> lv1.Items.count - 1 then //如果当前播放的不是最后一首
      begin
        lv1.SetFocus;
        Lv1.ItemIndex := lv1.ItemIndex + 1;
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


procedure TForm1.N8Click(Sender: TObject);
begin
  N7.Checked := False;
  N8.Checked := True;
  N20.Checked := False;
  N21.Checked := False;
end;

procedure TForm1.N20Click(Sender: TObject);
begin
  N7.Checked := False;
  N8.Checked := False;
  N20.Checked := True;
  N21.Checked := False;
end;

procedure TForm1.N21Click(Sender: TObject);
begin
  N7.Checked := False;
  N8.Checked := False;
  N20.Checked := False;
  N21.Checked := True;
end;



procedure TForm1.ClearPlaylistClick(Sender: TObject);
begin
  Lv1.Items.Clear; //清空播放列表
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  if Lv1.ItemIndex <> -1 then
  begin
    btn1Click(sender);

  end;
end;

{procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var                      //鼠标右键选择列表项
point:tpoint;
mouseitem:integer;
  begin
  point.X:=x;
  point.Y:=y;
  mouseitem:=Lv1.Items.ItemAtPos(point,true);//获取鼠标位置所在的列表内容
 if mouseitem=-1 then //如果鼠标所在位置没有内容
 begin
 N1.Enabled:=False;  //则播放菜单不可用
 N2.Enabled:=False;  //删除菜单不可使用
 N3.Enabled:=False;
 end
    else
    begin
    N1.Enabled:=True;
    N2.Enabled:=True;
    N3.Enabled:=True;
   ListBox1.ItemIndex:=mouseitem; //否则的话恢复为播放和删除菜单可用，并选中列表项
   end;
     end;}

procedure TForm1.N2Click(Sender: TObject);
begin
  Lv1.DeleteSelected; //删除选中的列表项
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  if MessageBox(Handle, '确实要删除此文件吗？', PChar('确认删除'), MB_yesno + MB_ICONINFORMATION) = idyes then
  begin
    with mediaplayer1 do
      if mode in [mpplaying] then
      begin
        btn3Click(sender); //如果在播放状态则停止播放
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



procedure TForm1.N4Click(Sender: TObject);
begin
  Form1.Visible := true; // 显示窗体
  SetWindowPos(Application.Handle, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW);
  Shell_NotifyIcon(NIM_DELETE, @NotifyIcon); // 删除托盘图标
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  Lv1.Clear;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
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

procedure TForm1.MediaPlayer1Notify(Sender: TObject);
var
  i: Integer;
begin
  
  with mediaplayer1 do
    if mediaplayer1.Position = mediaplayer1.length then
    begin
      if N7.Checked then //如果选择了顺序播放
      begin
        for i := 0 to lv1.Items.Count do
        begin
          if MediaPlayer1.FileName = lv1.Items[i].SubItems.strings[0] + Lv1.Items[i].Caption then
          begin
            Lv1.ItemIndex := i;
            Break;
          end;
        end; //此循环语句用于判断当前正在播放的是哪一个列表项
        if Lv1.ItemIndex = Lv1.Items.Count - 1 then
        begin
          Notify := False;
          btn3Click(Sender); //如果之前播放的是最后一首音乐 则停止播放
        end
        else
        begin
          if (IsIconic(Form1.Handle) = False) and (IsZoomed(Form1.Handle) = false) then //此段程序的目的是在托盘状态下连续播放不会出错
          begin
            Lv1.ItemIndex := lv1.ItemIndex + 1;
            trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
            btn1Click(Sender);
          end
          else
          begin
            lv1.SetFocus; //选中要播放的列表项
            Lv1.ItemIndex := lv1.ItemIndex + 1;
            trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
            btn1Click(Sender);
          end;

        end;

      end;
      if N8.Checked then //如果选择单曲循环
      begin
        mediaplayer1.Position := 0;
        mediaplayer1.Play;
        Notify := true; //则循环播放同一首曲目
      end;
      if N20.Checked then //如果选择了列表循环播放
      begin
        for i := 0 to Lv1.Items.Count do
        begin
          if MediaPlayer1.FileName = lv1.Items[i].SubItems.strings[0] + Lv1.Items[i].Caption then
          begin
            Lv1.ItemIndex := i;
            Break;
          end;
        end; //此循环语句用于判断当前正在播放的是哪一个列表项
        if lv1.ItemIndex = lv1.Items.Count - 1 then lv1.ItemIndex := -1; //判断当前播放的项是否是最后一行
        if (IsIconic(Form1.Handle) = False) and (IsZoomed(Form1.Handle) = false) then //此段程序的目的是在托盘状态下连续播放不会出错
        begin
          Lv1.ItemIndex := lv1.ItemIndex + 1;
          trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
          btn1Click(Sender);
        end
        else
        begin
          lv1.SetFocus; //选中要播放的列表项
          Lv1.ItemIndex := lv1.ItemIndex + 1;
          trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
          btn1Click(Sender);
        end;
      end;
      if N21.Checked then
      begin
        Randomize;
        Lv1.ItemIndex := Random(lv1.Items.Count - 1); //使用随机函数生成随机的播放项目
        trackbar1.Position := 0; //此处必须置0,否则遇到时间比自身短的文件会触发TrackBar1Change会自动跳过去
        btn1Click(Sender);
      end;

    end;

end;





procedure TForm1.TrackBar1Change(Sender: TObject);
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

procedure TForm1.N13Click(Sender: TObject);
var
  i: Integer;
  a: Boolean;
begin
  a := False;
  if opendialog1.Execute then
  begin
    for i := 0 to Lv1.Items.Count - 1 do
    begin
      if OpenDialog1.FileName = lv1.Items[i].SubItems.Strings[0] + lv1.Items[i].Caption then
      begin
        a := True;
        MessageBox(Handle, '已存在于播放列表中！', '提示', MB_OK +
          MB_ICONINFORMATION);
        lv1.SetFocus;
        Lv1.ItemIndex := i; //选定重复的列表项
        exit;
      end;
    end;
    if a = False then
    begin
      Flnm := ExtractFileName(OpenDialog1.FileName);
      xlist := lv1.Items.Add;
      xlist.Caption := Flnm;
      xlist.SubItems.add(ExtractFilePath(OpenDialog1.FileName));
      btn1.Enabled := true;
    end;
  end;
end;


procedure TForm1.N14Click(Sender: TObject);
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

procedure TForm1.N17Click(Sender: TObject);
begin
 form4.Show;
end;

procedure TForm1.CDDVDROM1Click(Sender: TObject);
begin
  mcisendstring('set cdaudio door open wait', nil, 0, handle);
end;

procedure TForm1.CDDVDROM2Click(Sender: TObject);
begin
  mcisendstring('set cdaudio door closed wait', nil, 0, handle);
end;

procedure TForm1.N18Click(Sender: TObject);
var
  buf: Tstrings;
  i: Integer;
  begin
  if opendialog2.Execute then
  begin
    buf := tstringlist.create;
    buf.loadfromfile(OpenDialog2.FileName);
    xlist := lv1.Items.Add;
    for i := 0 to buf.Count - 1 do
    begin
      xlist.Caption := ExtractFileName(buf.Strings[i]);
      xlist.SubItems.add(ExtractFilePath(buf.Strings[i]));
    end;
    buf.free;
    btn1.Enabled := True;
  end;
end;

procedure TForm1.N19Click(Sender: TObject);
var
  plylst: TStrings;
  i: Integer;
begin
  if savedialog1.Execute then
  begin
    plylst := TStringList.Create;
    for i := 0 to lv1.Items.Count - 1 do //利用循环语句保存listview到播放列表
    begin
      plylst.Add(lv1.Items[i].SubItems.Strings[0] + lv1.Items[i].Caption);
    end;
    plylst.SaveToFile(SaveDialog1.FileName);
    plylst.Free;
  end;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  N7.Checked := True;
  N8.Checked := False;
  N20.Checked := False;
  N21.Checked := False;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  if Lv1.ItemIndex <> -1 then //首先判断列表框中是否有内容
  begin
    mediaplayer1.FileName := Lv1.Selected.SubItems.Strings[0] + lv1.Selected.Caption; //
    if MediaPlayer1.Mode in [mppaused] then
    begin
      MediaPlayer1.Resume;//恢复播放状态--记忆播放位置
      skyaudiometer1.Active:=true;
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
        listname.Caption:=extractfilename(MediaPlayer1.FileName);
        trackbar1.Enabled := true;
        stat1.Panels[0].Text :=  ExtractFileName(mediaplayer1.FileName);
        if chk1.Checked=True then
        begin
        Form3.lst1.Clear;
        Form3.loadlrc(MediaPlayer1.FileName);
        end;
      except
        on EMCIDeviceError do
          MessageBox(Handle, '无法播放，请检查路径或者文件名是否正确！', '错误',
            MB_OK + MB_ICONSTOP);

      end;


    end;
  end;
end;

procedure TForm1.N23Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.btn7Click(Sender: TObject);
begin
  if MediaPlayer1.Mode in [mpplaying] then
  begin
    MediaPlayer1.Position := TrackBar1.Position * 1000 + 2000;
    mediaplayer1.play;
  end;
end;

procedure TForm1.btn6Click(Sender: TObject);
begin
  if MediaPlayer1.Mode in [mpplaying] then
  begin
    MediaPlayer1.Position := TrackBar1.Position * 1000 - 2000;
    mediaplayer1.play;
  end;
end;

procedure TForm1.N24Click(Sender: TObject);
begin
  if MediaPlayer1.Mode in [mpplaying] then
  begin
    MediaPlayer1.Position := TrackBar1.Position * 1000 + 2000;
    mediaplayer1.play;
  end;
end;

procedure TForm1.N25Click(Sender: TObject);
begin
  if MediaPlayer1.Mode in [mpplaying] then
  begin
    MediaPlayer1.Position := TrackBar1.Position * 1000 - 2000;
    mediaplayer1.play;
  end;
end;

procedure TForm1.OpenDialog2Close(Sender: TObject);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    Application.ProcessMessages;
  end;
end;

procedure TForm1.SaveDialog1Close(Sender: TObject);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    Application.ProcessMessages;
  end;
end;

procedure TForm1.lv1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if lv1.ItemIndex = -1 then //如果所在位置没有内容
  begin
    N1.Enabled := False; //则播放菜单不可用
    N2.Enabled := False; //删除菜单不可使用
    N3.Enabled := False;
    N11.Enabled:=False;
  end
  else
  begin
    N1.Enabled := True;
    N2.Enabled := True;
    N3.Enabled := True;
    N11.Enabled:=True;
    ; //否则的话恢复为播放和删除菜单可用，并选中列表项
  end;
end;

procedure TForm1.lv1DblClick(Sender: TObject);
begin
  btn1Click(sender);
end;

procedure TForm1.OpenDialog1Close(Sender: TObject);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    Application.ProcessMessages;
  end;
end;

procedure TForm1.chk1Click(Sender: TObject);
begin
  if chk1.Checked = True then
  begin
   form3.show;
  
    if MediaPlayer1.Mode in[mpplaying] then Form3.loadlrc(MediaPlayer1.FileName);
      end;
  if chk1.Checked = False then Form3.Close;
end;

procedure TForm1.N28Click(Sender: TObject);
begin
TrackBar2.Position:=TrackBar2.Position+60;
end;

procedure TForm1.N29Click(Sender: TObject);
begin
TrackBar2.Position:=TrackBar2.Position-60;
end;

procedure TForm1.N32Click(Sender: TObject);
var
  v:LongInt;
begin
  case N32.Checked of
     False:
     begin
    N32.Checked:=True;
    n32.caption:='取消静音';
    N28.Enabled:=False;
    N29.Enabled:=False;
    n30.Enabled:=false ;
  N31.Enabled:=false;
  N33.Enabled :=false ;
   n30.Checked:=false ;
  N31.Checked:=false;
  N33.Checked :=false ;
  TrackBar2.Enabled:=False;
    v := (0 shl 8) or (0 shl 24);
  waveOutSetVolume(0, v);
  end;
    true:
    begin
    N32.Checked:=False;
    N32.Caption:='静音';
    N28.Enabled:=True;
    N29.Enabled:=True;
    n30.Enabled:=true ;
  N31.Enabled:=true;
  N33.Enabled :=true ;
  N33.Checked:=True;
  TrackBar2.Enabled:=true;
    v := (255 shl 8) or (255 shl 24);
  waveOutSetVolume(0, v);

  end;
    end;

end;

procedure TForm1.N30Click(Sender: TObject);
begin
  N30.Checked:=True;
  N31.Checked:=False;
  N33.Checked:=False;
waveoutsetvolume(0, 255 shl 8);
end;

procedure TForm1.N31Click(Sender: TObject);
var
  rv:LongInt;
  begin
    N30.Checked:=false;
  N31.Checked:=true;
  N33.Checked:=False;
    waveoutsetvolume(0, 0 shl 8);
   waveoutgetvolume(0, @rv);
  rv := rv and $0000FFFF or (255 shl 24);
  waveoutsetvolume(0, rv);
  end;

procedure TForm1.N33Click(Sender: TObject);
var
  v:LongInt ;
begin
  N30.Checked:=false;
  N31.Checked:=False;
  N33.Checked:=true;
  v := (255 shl 8) or (255 shl 24);
  waveOutSetVolume(0, v);
end;

procedure TForm1.N11Click(Sender: TObject);  //获取文件属性的过程
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

procedure TForm1.N35Click(Sender: TObject);
begin
btn4Click(sender);
end;

procedure TForm1.N36Click(Sender: TObject);
begin
 btn5Click(sender);
end;

{procedure TForm1.N37Click(Sender: TObject);
begin
lv1.Selected.EditCaption;//重命名

end;

procedure TForm1.lv1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if   Key   =   VK_F2   then   
            Lv1.Selected.EditCaption;
end; }

procedure TForm1.tmr1Timer(Sender: TObject);
begin
Form3.Left:=Form1.Left+form1.Width;
end;

procedure TForm1.N37Click(Sender: TObject);
begin
  N38.Checked:=false;  N37.Checked:=true;
skyaudiometer1.AMStyle:=smsSpectrum; //频谱
end;

procedure TForm1.N38Click(Sender: TObject);
begin
  N37.Checked:=false;  N38.Checked:=true;
skyaudiometer1.AMStyle:=smsOscillograph; //示波器
end;

procedure TForm1.N42Click(Sender: TObject);
begin
n42.checked:=true;
n41.checked:=false;
n43.checked:=false;
skyaudiometer1.wavemode:=svmLine;
end;

procedure TForm1.N41Click(Sender: TObject);
begin
n41.checked:=true;
n42.checked:=false;
n43.checked:=false;
skyaudiometer1.wavemode:=svmnubby;
end;

procedure TForm1.N43Click(Sender: TObject);
begin
n43.checked:=true;
n42.checked:=false;
n41.checked:=false;
skyaudiometer1.wavemode:=svmdot;
end;


procedure TForm1.N52Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=255    ;
end;

procedure TForm1.N101Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=230;
end;

procedure TForm1.N201Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=205    ;
end;

procedure TForm1.N301Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=180    ;
end;

procedure TForm1.N401Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=155   ;
end;

procedure TForm1.N501Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=130    ;
end;

procedure TForm1.N601Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=105    ;
end;

procedure TForm1.N70701Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=80   ;
end;

procedure TForm1.N801Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=55    ;
end;

procedure TForm1.N901Click(Sender: TObject);
begin
Form1.AlphaBlendValue:=30    ;
end;

procedure TForm1.QQ1Click(Sender: TObject);
begin
ShellExecute(handle, 'open','http://user.qzone.qq.com/1007136434?ptlang=2052','Qzone',nil, SW_SHOWNORMAL);
end;

procedure TForm1.N56Click(Sender: TObject);
begin
 ShellExecute(handle, 'open','http://blog.sina.com.cn/u/1843375347','SINABLOG',nil, SW_SHOWNORMAL);
end;

procedure TForm1.MSN1Click(Sender: TObject);
begin
ShellExecute(handle, 'open','https://skydrive.live.com/?cid=167e4f5d97555488','MSNSKY',nil, SW_SHOWNORMAL);
end;

procedure TForm1.N59Click(Sender: TObject);
begin
winexec(Pchar('cmd'),sw_Show);//控制面板
end;

procedure TForm1.N60Click(Sender: TObject);
begin
 winexec(Pchar('RegEdit'),sw_Show);
end;

procedure TForm1.N62Click(Sender: TObject);
begin
winexec(Pchar('notepad'),sw_Show);
end;

procedure TForm1.IP1Click(Sender: TObject);
begin
// ipconfig 执行结果累加到 c:\2.txt 文件中
 winexec(pchar('cmd   /c ipconfig >>D:\Ip.txt'),sw_show);
  //最新的一次结果保存到 c:\2.txt 文件中
  winexec(pchar('cmd   /c ipconfig >D:\Ip.txt'),sw_show);
  ShellExecute(handle, 'open','D:\Ip.txt','IP',nil, SW_SHOWNORMAL);
end;

procedure TForm1.N61Click(Sender: TObject);
begin
winexec(pchar('cmd /c shutdown -s -t 60'),sw_shownormal);
end;

procedure TForm1.N63Click(Sender: TObject);
begin
winexec('shutdown -R -t 0',0);
end;

procedure TForm1.N110Click(Sender: TObject);
begin
n110.Checked:=true;n210.Checked:=false;n310.Checked:=false;n410.Checked:=false;n510.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=1;
end;

procedure TForm1.N210Click(Sender: TObject);
begin
n210.Checked:=true;n110.Checked:=false;n310.Checked:=false;n410.Checked:=false;n510.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=2;
end;

procedure TForm1.N310Click(Sender: TObject);
begin
n310.Checked:=true;n210.Checked:=false;n110.Checked:=false;n410.Checked:=false;n510.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=3;
end;

procedure TForm1.N410Click(Sender: TObject);
begin
n410.Checked:=true;n210.Checked:=false;n310.Checked:=false;n110.Checked:=false;n510.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=4;
end;

procedure TForm1.N510Click(Sender: TObject);
begin
n510.Checked:=true;n210.Checked:=false;n310.Checked:=false;n410.Checked:=false;n110.Checked:=false;n68.Checked:=false;
skyaudiometer1.FreqWidth:=5;
end;

procedure TForm1.N68Click(Sender: TObject);
begin
n68.Checked:=true;n210.Checked:=false;n310.Checked:=false;n410.Checked:=false;n510.Checked:=false;n110.Checked:=false;
skyaudiometer1.FreqWidth:=6;
end;

procedure TForm1.N111Click(Sender: TObject);
begin
n111.Checked:=true;n211.Checked:=false;n311.Checked:=false;
skyaudiometer1.FreqSpace:=1;
end;

procedure TForm1.N211Click(Sender: TObject);
begin
n211.Checked:=true;n111.Checked:=false;n311.Checked:=false;
skyaudiometer1.FreqSpace:=2;
end;

procedure TForm1.N311Click(Sender: TObject);
begin
     n311.Checked:=true;n211.Checked:=false;n111.Checked:=false;
skyaudiometer1.FreqSpace:=3;
end;

procedure TForm1.N70Click(Sender: TObject);
begin
N70.Checked:=not n70.Checked;
if n70.Checked then

form1.Height:=206

else

form1.Height:=685;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
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

 label3.Caption:=formatdatetime(' yyyy-mm-dd  ',now)+j+formatdatetime('hh:nn:ss',now) ;
 label3.Left:=label3.Left-1;
 if label3.Left=0 then
 begin

 timer3.Enabled:=false;
 timer4.Enabled:=true;

 end;

end;

procedure TForm1.Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 label3.Font.Color:=clred;
label3.Font.Style:=[fsUnderline];
timer3.Enabled:=false;
timer4.Enabled:=false;
end;

procedure TForm1.Label3MouseLeave(Sender: TObject);
begin
label3.Font.Color:=clgreen;
label3.Font.Style:=[];
timer3.Enabled:=true;

end;

procedure TForm1.Timer4Timer(Sender: TObject);
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

 label3.Caption:=formatdatetime(' yyyy-mm-dd  ',now)+j+formatdatetime('hh:nn:ss',now) ;
 label3.Left:=label3.Left+1;
 if label3.Left=form1.Width-label3.Width  then
 begin
  timer4.Enabled:=false;
  timer3.Enabled:=true;

 end;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const      //没有标题栏  照样拖动窗体的办法
    sc_dragmove   =   $f012;
begin
mover.Enabled:=true ;
if   form1.Top   <=0   then   form1.Top   :=2;
    releasecapture;
    twincontrol(application.mainform).perform(wm_syscommand,sc_dragmove,   0);

end;

procedure TForm1.GroupBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 const
    sc_dragmove   =   $f012;
begin
 if   form1.Top   <=0   then   form1.Top   :=2;
    releasecapture;
    twincontrol(application.mainform).perform(wm_syscommand,sc_dragmove,   0);
end;


procedure TForm1.GroupBox2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 const
    sc_dragmove   =   $f012;
begin
 if   form1.Top   <=0   then   form1.Top   :=2;
    releasecapture;
    twincontrol(application.mainform).perform(wm_syscommand,sc_dragmove,   0);
end;

procedure TForm1.N71Click(Sender: TObject);
begin
 MessageBox(Handle, '最好歌曲与歌词目录一致，否则可能加载歌词错误！~~~~~反馈邮箱：qhdsofeware@163.com~~~~~QQ:654714226', PChar('Powerd BY Bruce（小布）~~ 2012~03'), MB_OK);
end;

procedure TForm1.N22Click(Sender: TObject);
begin
n22.checked:=true;
n72.Checked:=false;
n73.Checked:=false;
skyaudiometer1.ForeColor:=clMenuHighlight;
end;

procedure TForm1.N72Click(Sender: TObject);
begin
n72.checked:=true;
n22.Checked:=false;
n73.Checked:=false;
skyaudiometer1.ForeColor:=clolive;
end;

procedure TForm1.N73Click(Sender: TObject);
begin
n73.checked:=true;
n72.Checked:=false;
n22.Checked:=false;
skyaudiometer1.ForeColor:=clFuchsia;
end;

procedure TForm1.N46Click(Sender: TObject);
begin


n46.Checked:=true;
itunes1.Checked:=false;
n74.Checked:=false;
n75.Checked:=false;
n76.Checked:=false;
n77.checked:=false;
skindata1.LoadFromFile(ExtractFilePath(ParamStr(0))+'绿色节拍.skn');
end;

procedure TForm1.Itunes1Click(Sender: TObject);
begin
 n46.Checked:=false;
itunes1.Checked:=true;
n74.Checked:=false;
n75.Checked:=false;
n76.Checked:=false;
n77.checked:=false;
skindata1.LoadFromFile(ExtractFilePath(ParamStr(0))+'Itunes.skn');
end;

procedure TForm1.N74Click(Sender: TObject);
begin
 n46.Checked:=false;
itunes1.Checked:=false;
n74.Checked:=true;
n75.Checked:=false;
n76.Checked:=false;
n77.checked:=false;
skindata1.LoadFromFile(ExtractFilePath(ParamStr(0))+'青青草地.skn');
end;

procedure TForm1.N75Click(Sender: TObject);
begin
 n46.Checked:=false;
itunes1.Checked:=false;
n74.Checked:=false;
n75.Checked:=true;
n76.Checked:=false;
n77.checked:=false;
skindata1.LoadFromFile(ExtractFilePath(ParamStr(0))+'橙子情结.skn');
end;

procedure TForm1.N76Click(Sender: TObject);
begin
n76.Checked:=true;
itunes1.Checked:=false;
n74.Checked:=false;
n46.Checked:=false;
n75.Checked:=false;
n77.checked:=false;
skindata1.LoadFromFile(ExtractFilePath(ParamStr(0))+'智能时代.skn');
end;

procedure TForm1.N77Click(Sender: TObject);
begin
n46.Checked:=false;
itunes1.Checked:=false;
n74.Checked:=false;
n75.Checked:=false;
n76.Checked:=false;
n77.checked:=true;
skindata1.LoadFromFile(ExtractFilePath(ParamStr(0))+'蓝色海洋.skn');
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
mover.Enabled:=false;
end;

procedure TForm1.moverTimer(Sender: TObject);
begin
form3.Left:=form1.Left+form1.Width;
form3.Top:=form1.Top;
end;

procedure TForm1.FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin
//mover.Enabled:=true ;
end;

end.



//==============================任意位置拖动窗体的办法=======================
{const      //没有标题栏  照样拖动窗体的办法
    sc_dragmove   =   $f012;
begin
if   form1.Top   <=0   then   form1.Top   :=2;
    releasecapture;
    twincontrol(application.mainform).perform(wm_syscommand,sc_dragmove,   0); }
//===========================================================================
             //                  获取应用程序路径.....
             //ExtractFilePath(ParamStr(0))-------带'\'；
             //ExtractFilePath(ParamStr(0))-----不带'\'；
     {       -----------------------------------------------------
     AnsiString __fastcall ExtractFilePath;

　　ExtractFilePath和相近函数：

　　ExtractFileDrive ：返回完整文件名中的驱动器，如"C:"

　　ExtractFilePath：返回完整文件名中的路径，最后带“/”，如"C:\test\"

　　ExtractFileDir：返回完整文件名中的路径，最后不带“/” ,如"C:\test"

　　ExtractFileName:返回完整文件名中的文件名称 (带扩展名)，如"mytest.doc"

　　ExtractFileExt 返回完整文件名中的文件扩展名（带.），如".doc"

　　extractfiledir //这个没有最后的 \

　　extractfilepath //这个最后有 \
}
////==========================================================================





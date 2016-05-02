unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VsControls,ShellAPI,AppEvnts, VsSkin, VsComposer, Menus, ComCtrls, MPlayer,
  VsHotSpot, OBMagnet,Mmsystem,FileCtrl, ExtCtrls, StdCtrls;
 const WM_NID = WM_User + 1000;
type
  TPlayList = class(TForm)
    VsComposer1: TVsComposer;
    VsSkin1: TVsSkin;
    list: TPopupMenu;
    N47: TMenuItem;
    N48: TMenuItem;
    N49: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N6: TMenuItem;
    N11: TMenuItem;
    lv1: TListView;
    OBFormMagnet1: TOBFormMagnet;
    VsHotSpot1: TVsHotSpot;
    Timer1: TTimer;
    N4: TMenuItem;
    N5: TMenuItem;
    Label3: TLabel;
    procedure lv1DblClick(Sender: TObject);
    procedure N48Click(Sender: TObject);
    procedure N49Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure lv1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure VsHotSpot1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lv1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Timer1Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure N5Click(Sender: TObject);
   

  private
  procedure DropFiles(var Msg: TMessage); message WM_DropFILES;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  PlayList: TPlayList;

implementation

uses Unit1, Unit3, Unit10;

{$R *.dfm}

//delphi判断文件是否被占用
function IsFileInUse(fName : string ) : boolean;
var
  HFileRes : HFILE;
begin
  Result := false;
  if not FileExists(fName) then
    exit;
  HFileRes := CreateFile(pchar(fName), GENERIC_READ or GENERIC_WRITE,0, nil, OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then
    CloseHandle(HFileRes);
end;



procedure Tplaylist.DropFiles(var Msg: TMessage);
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
      xlist := playlist.lv1.Items.Add;
      xlist.Caption := ExtractFileName(buffer);
      xlist.SubItems.add(ExtractFilePath(buffer));
      mainplay.MediaPlayer1.FileName := ExtractFilePath(buffer) + xlist.Caption;
      mainplay.MediaPlayer1.Open;
      mainplay.skyaudiometer1.active:=true;
      mainplay.listname.caption:=extractfilename(mainplay.mediaplayer1.filename);
      mainplay.trackbar1.Enabled:=true;
      mainplay.gd.enabled:=true;
      mainplay.timer1.Enabled:=true;
      mainplay.timer2.Enabled:=true;
      mainplay.label1.Caption:='状态:播放' ;
      mainplay.stat1.panels[0].text:=extractfilename(mainplay.mediaplayer1.filename);
      mainplay.MediaPlayer1.Play;
      if mainplay.chk1.Checked=True then lrcshow.loadlrc(mainplay.MediaPlayer1.FileName); //加载歌词文件！
      mainplay.btn2.Enabled := True;
      mainplay.btn3.Enabled := true;
      mainplay.Timer2.Enabled := True;
    except
      on EMCIDeviceError do
        Application.MessageBox('不支持播放此类文件！', '错误', MB_OK + MB_ICONSTOP + MB_TOPMOST);
    end;
  end;
end;


///------------------------------------------------------------------------------------

procedure TPlayList.lv1DblClick(Sender: TObject);
begin
 if lv1.ItemIndex <> -1 then //首先判断列表内容是否为空，不为空执行下面的语句
  begin
    mainplay.btn1Click(sender);
  end;
end;

procedure TPlayList.N48Click(Sender: TObject);
begin
mainplay.N81Click(sender);
end;

procedure TPlayList.N49Click(Sender: TObject);
begin
mainplay.n9click(sender);
end;

procedure TPlayList.N1Click(Sender: TObject);
begin
mainplay.btn1Click(sender);
end;

procedure TPlayList.N6Click(Sender: TObject);
begin
 Lv1.Clear;
end;

procedure TPlayList.lv1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
if lv1.ItemIndex = -1 then //如果所在位置没有内容
  begin
    N1.Enabled := False; //则播放菜单不可用
    N2.Enabled := False; //删除菜单不可使用
    N3.Enabled := False;
    N4.Enabled := False;
    N5.Enabled := False;
    N11.Enabled:=False;
  end
  else
  begin
    N1.Enabled := True;
    N2.Enabled := True;
    N3.Enabled := True;
    N4.Enabled := True;
    N5.Enabled := True;
    N11.Enabled:=True;
    ; //否则的话恢复为播放和删除菜单可用，并选中列表项
  end;
end;

procedure TPlayList.N2Click(Sender: TObject);
begin
 Lv1.DeleteSelected; //删除选中的列表项
end;

procedure TPlayList.N3Click(Sender: TObject);
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

procedure TPlayList.N11Click(Sender: TObject);   //获取属性
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

procedure TPlayList.VsHotSpot1Click(Sender: TObject);
begin
playlist.hide;
mainplay.n70.Checked:=true;
end;

procedure TPlayList.FormCreate(Sender: TObject);
begin

  DragAcceptFiles(Handle, True);
  PositionChange := False; //设置初始值；
end;



procedure TPlayList.lv1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
timer1.Enabled:=true;
end;

procedure TPlayList.Timer1Timer(Sender: TObject);
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
    if not IsFileInUse(ExtractFilePath(ParamStr(0))+'bruce.log') then
    begin
    plylst.SaveToFile(ExtractFilePath(ParamStr(0))+'bruce.log');
    plylst.Free  ;
    end ;


    timer1.Enabled:=false;
end;

procedure TPlayList.N4Click(Sender: TObject);
 var FilePath:String  ;
begin

FilePath:= lv1.Selected.SubItems[0]+lv1.Selected.Caption ;
ShellExecute(Handle, 'open', 'Explorer.exe', Pchar('/select,'+ FilePath ),nil, 1);
//打开文件位置,并且选中它。 ------------------------------ edit by bruce 2012/11/11

end;

procedure TPlayList.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
if (msg.CharCode=46) then
n2.click;
if(msg.CharCode=13) then
n1.Click;

end;



procedure TPlayList.N5Click(Sender: TObject);
begin
bTag.Show;
end;

end.

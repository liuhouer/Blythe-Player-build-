unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ShellCtrls, FindFile, OBMagnet;

type
  TForm2 = class(TForm)
    shltrvw1: TShellTreeView;
    fndfl1:Tfindfile;
    lbl1: TLabel;
    lbl2: TLabel;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    stat1: TStatusBar;
    lst1: TListBox;
    chk1: TCheckBox;
    chk2: TCheckBox;
    procedure btn1Click(Sender: TObject);
    procedure fndfl1FileMatch(Sender: TObject; const Folder: string;
      const FileInfo: TSearchRec);
    procedure btn2Click(Sender: TObject);
    procedure fndfl1SearchAbort(Sender: TObject);
    procedure fndfl1FolderChange(Sender: TObject; const Folder: string;
      var IgnoreFolder: TFolderIgnore);
    procedure fndfl1SearchFinish(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure lst1DblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  xlist: TListItem;

implementation

uses Unit1;

{$R *.dfm}

procedure searchmusic(Filter: string);
begin
// Sets FileFile properties
  Form2.fndfl1.Threaded := True;
  // - Name & Location
  with Form2.fndfl1.Criteria.Files do
  begin
    FileName := Filter;
    Location := Form2.shltrvw1.path;
    Subfolders := True;
  end;
  Form2.fndfl1.Execute;
  Form2.btn1.Enabled := False;
  Form2.btn2.Enabled := True;
end;


procedure TForm2.btn1Click(Sender: TObject);
begin
  if chk1.Checked then searchmusic('*.mp3'); //调用自定义过程搜索MP3
  if chk2.Checked then searchmusic('*.wma');
end;

procedure TForm2.fndfl1FileMatch(Sender: TObject; const Folder: string;
  const FileInfo: TSearchRec);
begin
  lst1.Items.Add(Folder + FileInfo.Name);
end;

procedure TForm2.btn2Click(Sender: TObject);
begin
  fndfl1.Abort;
end;

procedure TForm2.fndfl1SearchAbort(Sender: TObject);
begin
  stat1.SimpleText := '正在退出搜索，请稍候...';
  Update;
end;

procedure TForm2.fndfl1FolderChange(Sender: TObject; const Folder: string;
  var IgnoreFolder: TFolderIgnore);
begin
  stat1.SimpleText := Folder;
end;

procedure TForm2.fndfl1SearchFinish(Sender: TObject);
begin
  stat1.SimpleText := '完成搜索';
  if fndfl1.Aborted then
  begin
    stat1.SimpleText := '退出搜索 - ' + stat1.SimpleText;
  end;
  btn1.Enabled := True;
  btn2.Enabled := False;
end;

procedure TForm2.btn3Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lst1.Count - 1 do // 利用循环语句添加选择的列表项
  begin
    if lst1.Selected[i] then
    begin
      xlist := Form1.lv1.Items.Add;
      xlist.Caption := ExtractFileName(lst1.Items.Strings[i]);
      xlist.SubItems.add(ExtractFilePath(lst1.Items.Strings[i]));
    end;
  end;
  lst1.DeleteSelected; //删除选择的列表项
end;

procedure TForm2.btn4Click(Sender: TObject);
var
  i: integer;
  Empty: Boolean;
begin
  Empty := false;
  if lst1.Count = 0 then Empty := true;
  for i := 0 to lst1.Count - 1 do
  begin
    form1.Lv1.Items.Add.Caption := lst1.Items.Strings[i]; //添加所有列表项
  end;
  lst1.Clear; //清空列表
  if Empty then
  begin
    exit;
  end
  else
  begin
    form2.Close;
  end;
end;

procedure TForm2.lst1DblClick(Sender: TObject);
begin
  btn3click(sender);
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  lst1.Clear;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    Application.ProcessMessages;
  end;
end;

end.

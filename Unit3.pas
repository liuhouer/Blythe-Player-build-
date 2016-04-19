unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OBMagnet;

type
  TForm3 = class(TForm)
    lst1: TListBox;
    tmr1: TTimer;
    OBFormMagnet1: TOBFormMagnet;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmr1Timer(Sender: TObject);
    procedure loadlrc(s: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
 // procedure WMWINDOWPOSCHANGING(Var Msg: TWMWINDOWPOSCHANGING);message WM_WINDOWPOSCHANGING;
  //实现磁性窗体吸附效果---看算法-----------------------------------------------------------
    { Private declarations }
  public
    
  end;

var
  Form3: TForm3;
  fle: string;
   lrc: TStrings;
implementation

uses Unit1;

{$R *.dfm}
//------------------------实现磁性窗体--------------------------------------
{procedure TForm3.WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING);
var
WorkDound: TRect;
remove : Word;
begin
remove :=50; //可随意设置，是磁性的范围大小。
WorkDound.Left:=form1.left;
WorkDound.Top:=form1.Top;
WorkDound.Right:=form1.left+form1.Width;
WorkDound.Bottom:=form1.Top+form1.Height;
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
end;    }
//---------------------------------实现磁性窗体-------------------------------------------------

procedure TForm3.loadlrc(s: string);
var
  i: Integer;

begin
  lrc := TStringList.Create;
  if s <> '' then
  begin
    fle := ExtractFileName(s);
    SetLength(fle, Length(ExtractFileName(fle)) - Length(ExtractFileExt(fle)));
    try
      lrc.LoadFromFile(ExtractFilePath(s) + fle + '.lrc');
      Form3.tmr1.Enabled := True;
    except
      on E: Exception do
      begin
       lst1.Items.Add('找不到歌词文件,请确保歌词文件与当前播放曲目同!');
       lst1.Items.Add('并且在同一目录下');

      end;
    end;
    for i := 0 to lrc.Count - 1 do
    begin
     // Form3.lst1.Items.Add(lrc.strings[i]);
     if i>=2 then
     Form3.lst1.Items.Add( Copy(lrc.Strings[i], 11, length(lrc.Strings[i])-10));
      
      end;
  end;
  
  end;




procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tmr1.Enabled := False;
  
  lst1.Clear;
  lrc.Free;
  end;

procedure TForm3.tmr1Timer(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lrc.Count - 1 do
  begin
    if Form1.stat1.Panels[1].Text = Copy(lrc.Strings[i], 2, 5) then
    begin
      lst1.ItemIndex := i-2;
      
      Break;
    end;

  end;

end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
AnimateWindow(Form3.Handle,800,AW_HIDE or AW_BLEND);
form1.chk1.Checked:=false;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  form3.Left:=Form1.Left+form1.Width;
  Form3.Top:=Form1.Top;
AnimateWindow(Form3.Handle,800,AW_BLEND);
end;

///////打开关闭时，缓存展示......................................
////AnimateWindow(Form3.Handle,800,AW_HIDE or AW_BLEND); ////////

procedure TForm3.FormCreate(Sender: TObject);
begin
//self.ScreenSnap:=True;
//self.SnapBuffer:=30;//窗体吸附效果
end;

end.

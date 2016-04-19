unit Unit6;

interface

uses
  Windows , Controls, ComCtrls, StdCtrls,
  IdComponent, IdHTTP, XPMan, ExtCtrls,
  Messages, SysUtils, Variants, Classes, Graphics,  Forms,
  Dialogs,OleCtrls, QianQianLrc, ImgList,Mplayer, IdBaseComponent, IdTCPConnection,
  IdTCPClient;

type
  TSerLrc = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    RadioGroup1: TRadioGroup;
    ListView1: TListView;
    XPManifest1: TXPManifest;
    IdHTTP1: TIdHTTP;
    ImageList1: TImageList;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SerLrc: TSerLrc;


implementation

uses Unit3, Unit1;

{$R *.dfm}

procedure TSerLrc.Button1Click(Sender: TObject);
var
  WXml:TStringList;
  i:Integer;
  WItem:TListItem;
  Lrc,ID,Art,Tit:WideString;
begin
ListView1.Clear;
WXml:=TStringList.Create;
WXml.Text:=Utf8ToAnsi(idhttp1.Get(LrcListLink(Edit1.Text,Edit2.Text,RadioGroup1.ItemIndex)));

WXml.Delete(0);
WXml.Delete(0);
WXml.Delete(WXml.Count-1);
for i:=0 to WXml.Count-1 do
begin
  Lrc:=Trim(WXml.Strings[i]);
  ID:=Copy(Lrc,Length('<lrc id="')+1,Pos('" artist="',Lrc)-Length('<lrc id="')-1);
  Art:=Copy(Lrc,Pos('" artist="',Lrc)+Length('" artist="'),Pos('" title="',Lrc)-Pos('" artist="',Lrc)-Length('" artist="'));
  Tit:=Copy(Lrc,Pos('" title="',Lrc)+Length('" title="'),Pos('"></lrc>',Lrc)-Pos('" title="',Lrc)-Length('" title="'));
  Art:=StringReplace(Art,'&amp;','&',[rfReplaceAll,rfIgnoreCase]);
  Tit:=StringReplace(Tit,'&amp;','&',[rfReplaceAll,rfIgnoreCase]);
  WItem:=ListView1.Items.Add;
  WItem.Caption:=ID;
  WItem.SubItems.Add(Art);
  WItem.SubItems.Add(Tit);
  WItem.ImageIndex:=0;
end;
WXml.Free;
if ListView1.Items.Count=0 then
  begin
    Application.MessageBox('对不起,没有找到相关歌词！', 'Bruce 提示', MB_OK +
      MB_ICONINFORMATION);
  end;
end;

procedure TSerLrc.ListView1DblClick(Sender: TObject);
var
ID:Integer;
Art,Tit:string;
lrcfile:string;
i:integer;
begin
if ListView1.ItemIndex<>-1 then
 begin
   id:=StrToInt(ListView1.Items.Item[ListView1.ItemIndex].Caption);
   Art:=ListView1.Items.Item[ListView1.ItemIndex].SubItems.Strings[0];
   Tit:=ListView1.Items.Item[ListView1.ItemIndex].SubItems.Strings[1];
   memo1.Text:=Utf8ToAnsi(idhttp1.Get(LrcDownLoadLink(id,Art,Tit,RadioGroup1.ItemIndex)));

   memo1.Lines.SaveToFile(ExtractFilePath(mainplay.MediaPlayer1.FileName)+copy(extractfilename(mainplay.MediaPlayer1.FileName),0,length(extractfilename(mainplay.MediaPlayer1.FileName))-4)+'.lrc');
   //自动把歌词存入歌曲所在目录，哈哈哈  我是不是爆发了？！！-----by 小布 2012.4.1

   mainplay.chk1.Checked:=false;//重新加载它..
   serlrc.Close;
   sleep(50);
   mainplay.chk1.Checked:=true;

 end;
end;

procedure TSerLrc.FormShow(Sender: TObject);
var k:integer;         
var s1,s2 :string;
  list : TStringlist;
begin
serlrc.Left:=(screen.width-serlrc.width ) div 2 ;
serlrc.Top:=(screen.height-serlrc.height *2) ;

  if mainplay.MediaPlayer1.Mode in [mpplaying]then  //分离歌曲名这个字符串为2部分 2012.4.2 by-- 小布
  begin
  //分离出歌曲名-歌手 等 信息--------------
      k:= pos('-',mainplay.stat1.Panels[0].Text);       //先判断歌曲名里有没有'-' 否则会出错--edit by bruce 2012.4.3
      if  k>0   then
      begin
      list := TStringlist.Create;
      list.Delimiter :='-' ;
      list.DelimitedText :=StringReplace(mainplay.stat1.Panels[0].Text,' ','',[rfReplaceAll]);//去除空格;
      s1:=list.strings[0];
      s2:= list.Strings[1];
      end else
          begin
            s2:= mainplay.stat1.Panels[0].Text;
            s1:='';
          end;
      edit1.text:=s1;
      edit2.text:=s2;
   end;



end;

end.


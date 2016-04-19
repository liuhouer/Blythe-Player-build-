unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, VsControls, VsComposer,MPlayer, VsHotSpot, VsSkin, VsLabel,
  ExtCtrls;

type
  Tminilrc = class(TForm)
    VsSkin1: TVsSkin;
    Label1: TVsLabel;
    VsComposer1: TVsComposer;
    PopupMenu1: TPopupMenu;
    N3: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    Fdg1: TFontDialog;
    gd: TTimer;
    N1: TMenuItem;
    N5: TMenuItem;
    stayOnTop: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure cloClick(Sender: TObject);
    procedure gdTimer(Sender: TObject);
    procedure N4Click(Sender: TObject);
   
    procedure N1Click(Sender: TObject);

    procedure N5Click(Sender: TObject);
    procedure stayOnTopTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  minilrc: Tminilrc;
 
   strScroll:Widestring ;
implementation

uses Unit1, Unit3;

{$R *.dfm}

procedure Tminilrc.FormCreate(Sender: TObject);
begin
self.ScreenSnap:=True;
self.SnapBuffer:=30;//窗体吸附效果



end;

procedure Tminilrc.FormShow(Sender: TObject);
begin
minilrc.top:=(screen.height-minilrc.height *2) ;
minilrc.left:=(screen.width-minilrc.width ) div 2 ;

end;

procedure Tminilrc.N3Click(Sender: TObject);
begin
if fdg1.Execute then
 label1.Font:=fdg1.Font;

end;

procedure Tminilrc.cloClick(Sender: TObject);
begin
mainplay.n79.Checked:=false;
minilrc.close;

end;

procedure Tminilrc.gdTimer(Sender: TObject);
 var
   strTrim:Widestring; //只需把字符串定义成 WideString 即可解决半个中文的问题了。--edit by bruce 2012/10/1 0:23
  // strScroll:Widestring = 'Beyond - 海阔天空.mp3 - 小布静听';
begin

strScroll:=label1.Caption;
if length(strScroll)>=36 then
begin
label1.Alignment:=vaLeftjustify;
strTrim:= copy(strScroll,1,36); //获取第1-36个字符
Delete(strScroll,1,1);         //将第1个字符删除

strScroll:=strScroll+'------>'+strTrim;                 //长度超出后才滚动（截取）

end else
begin
 label1.Alignment:=vaCenter;
end;
 label1.Caption:= strScroll;
             //显示出来。

end;

procedure Tminilrc.N4Click(Sender: TObject);
begin
mainplay.n79.Checked:=false;
minilrc.close;

end;



procedure Tminilrc.N1Click(Sender: TObject);
begin
minilrc.Hide;
mainplay.chk1.checked:=true;
lrcshow.Show;
end;



procedure Tminilrc.N5Click(Sender: TObject);
begin
n5.Checked:=not   n5.Checked;
end;

procedure Tminilrc.stayOnTopTimer(Sender: TObject);
begin
if n5.Checked then
begin
SetWindowPos(minilrc.handle,   HWND_TOPMOST,   0,   0,

0,   0,SWP_NOMOVE+SWP_NOSIZE);
end;
end;

end.

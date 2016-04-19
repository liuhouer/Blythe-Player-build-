unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VsControls, VsSkin, VsComposer, VsLabel,
  Menus, VsButtons, VsHotSpot;

type
  TMINILRC = class(TForm)
    VsComposer1: TVsComposer;
    VsSkin1: TVsSkin;
    Label1: TVsLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    Fdg1: TFontDialog;
    VsHotSpot1: TVsHotSpot;
    VsHotSpot2: TVsHotSpot;
    N2: TMenuItem;
    N4: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure Label1MouseEnter(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure VsHotSpot1Click(Sender: TObject);
    procedure VsHotSpot2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MINILRC: TMINILRC;

implementation

uses Unit3, Unit1;

{$R *.dfm}

procedure TMINILRC.Timer1Timer(Sender: TObject);
begin
minilrc.Label1.Caption:=form3.lst1.items.strings[integer(form3.lst1.itemindex)];
end;

procedure TMINILRC.Label1MouseEnter(Sender: TObject);
begin
minilrc.AlphaBlendValue:=150;
end;

procedure TMINILRC.Label1MouseLeave(Sender: TObject);
begin
minilrc.AlphaBlendValue:=60;
end;

procedure TMINILRC.FormCreate(Sender: TObject);
begin

if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    //释放物理内存
    Application.ProcessMessages;
    end;

self.ScreenSnap:=True;
self.SnapBuffer:=30;

        
end;

procedure TMINILRC.N1Click(Sender: TObject);
begin
if vsskin1.GraphicName='purple.bmp' then
vsskin1.GraphicName:='green.bmp'
else
begin
vsskin1.GraphicName:='purple.bmp';
end;
end;

procedure TMINILRC.N3Click(Sender: TObject);
begin
if fdg1.Execute then
 label1.Font:=fdg1.Font;

end;

procedure TMINILRC.VsHotSpot1Click(Sender: TObject);
begin
minilrc.Hide;
form1.chk1.checked:=true;
form3.Show;
end;

procedure TMINILRC.VsHotSpot2Click(Sender: TObject);
begin
minilrc.close;
end;

procedure TMINILRC.N4Click(Sender: TObject);
begin
close;
end;

procedure TMINILRC.FormShow(Sender: TObject);
begin

minilrc.top:=(screen.height-minilrc.height *2) ;
minilrc.left:=(screen.width-minilrc.width ) div 2 ;
end;

end.

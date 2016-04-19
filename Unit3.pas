unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, OBMagnet, ExtCtrls, StdCtrls, RzLstBox;

type
  TLrcShow = class(TForm)
    tmr1: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    lst1: TRzEditListBox;
    procedure FormShow(Sender: TObject);

   
    procedure N3Click(Sender: TObject);
  


  private
    { Private declarations }
  public
    { Public declarations }
  end;


  var
  LrcShow: TLrcShow;
  fle: string;
  Lrc: TStrings;
  movelrc :string;
implementation

uses Unit1, Unit6,  Unit9;

{$R *.dfm}

procedure TLrcShow.FormShow(Sender: TObject);
begin
lrcshow.Left:=mainplay.Left+mainplay.Width;
  lrcshow.Top:=mainplay.Top;
AnimateWindow(lrcshow.Handle,800,AW_BLEND);
end;




procedure TLrcShow.N3Click(Sender: TObject);
begin
mainplay.n82click(sender);
end;





end.

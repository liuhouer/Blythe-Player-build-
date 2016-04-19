unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SkyAudioMeter, Menus, ExtCtrls, StdCtrls;

type
  TVision = class(TForm)
    am2: TSkyAudioMeter;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    ppfx: TMenuItem;
    sbq: TMenuItem;
    N3: TMenuItem;
    ColorDialog1: TColorDialog;
    procedure N1Click(Sender: TObject);
    procedure am2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure ppfxClick(Sender: TObject);
    procedure sbqClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Vision: TVision;

implementation

uses Unit1, Unit3;

{$R *.dfm}

procedure TVision.N1Click(Sender: TObject);
begin
vision.close;
end;

procedure TVision.am2Click(Sender: TObject);
begin
if am2.AMStyle=smsSpectrum then
begin
am2.AMStyle:=smsOscillograph;
 sbq.Checked:=true ;
 ppfx.Checked:=false;
 end else             begin
am2.AMStyle:= smsSpectrum;
 sbq.Checked:=false ;
 ppfx.Checked:=true;  end;
end;

procedure TVision.N2Click(Sender: TObject);
begin
if colordialog1.Execute then
am2.ForeColor:=colordialog1.Color
else    exit;
end;

procedure TVision.ppfxClick(Sender: TObject);
begin
ppfx.Checked:=true;
sbq.Checked:=false;
am2.AMStyle:= smsSpectrum;
end;

procedure TVision.sbqClick(Sender: TObject);
begin
ppfx.Checked:=false;
sbq.Checked:=true;
am2.AMStyle:= smsOscillograph;
end;



end.

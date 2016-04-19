unit VsGraphicViewDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TVsGraphicViewDialog = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VsGraphicViewDialog: TVsGraphicViewDialog;

implementation

{$R *.DFM}

procedure TVsGraphicViewDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;

end.

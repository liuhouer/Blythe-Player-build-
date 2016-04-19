unit Unit_List;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFrm_List = class(TForm)
    Panel1: TPanel;
    Btn_Add: TButton;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    ListView1: TListView;
    StatusBar1: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_List: TFrm_List;

implementation

{$R *.dfm}

end.

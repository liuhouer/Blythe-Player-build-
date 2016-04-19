////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   frmThemeMgr.pas
//  Creator     :   Shen Min
//  Date        :   2003-04-06
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit frmThemeMgr;

interface

{$I SUIPack.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst;

type
  TfrmMgr = class(TForm)
    List: TCheckListBox;
    btn_sel: TButton;
    btn_unsel: TButton;
    btn_ok: TButton;
    procedure btn_selClick(Sender: TObject);
    procedure btn_unselClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmMgr.btn_selClick(Sender: TObject);
var
    i : Integer;
begin
    for i := 0 to List.Items.Count - 1 do
        List.Checked[i] := true;
end;

procedure TfrmMgr.btn_unselClick(Sender: TObject);
var
    i : Integer;
begin
    for i := 0 to List.Items.Count - 1 do
        List.Checked[i] := false;
end;

end.

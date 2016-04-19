unit VsAutoSaveDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls;

type
  TVsAutoSaveDialog = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Button1: TButton;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    function Execute(Control: TWinControl; Current: TStrings): Boolean;
    procedure GetControls(Controls: TStrings);
  end;

var
  VsAutoSaveDialog: TVsAutoSaveDialog;

implementation

uses
  VsSkin, VsSysUtils;

{$R *.DFM}


function TVsAutoSaveDialog.Execute(Control: TWinControl; Current: TStrings): Boolean;
var
  I: Integer;
  ControlName: string;
begin
  ListBox1.Items.Clear;
  for I := 0 to Control.ControlCount - 1 do
  begin
    if not (Control.Controls[I] is TVsSkinGraphicControl) then
    begin
      ControlName := Control.Controls[I].Name;
      if Current.IndexOf(ControlName) = -1 then
        ListBox1.Items.Add(ControlName+' : '+Control.Controls[I].ClassName)
      else
        ListBox2.Items.Add(ControlName+' : '+Control.Controls[I].ClassName)
    end;
  end;
  Result := ShowModal = mrOk;
end;

procedure CopyListBoxItems(Source, Dest: TListBox; CopyAll: Boolean);
var
  I: Integer;
begin
  for I := Source.Items.Count - 1 downto 0 do
    if (Source.Selected[I]) or (CopyAll) then
    begin
      Dest.Items.Add(Source.Items[I]);
      Source.Items.Delete(I);
    end;
end;

procedure TVsAutoSaveDialog.SpeedButton1Click(Sender: TObject);
begin
  CopyListBoxItems(ListBox1, ListBox2, false);
end;

procedure TVsAutoSaveDialog.SpeedButton3Click(Sender: TObject);
begin
  CopyListBoxItems(ListBox2, ListBox1, false);
end;

procedure TVsAutoSaveDialog.SpeedButton2Click(Sender: TObject);
begin
  CopyListBoxItems(ListBox1, ListBox2, True);
end;

procedure TVsAutoSaveDialog.SpeedButton4Click(Sender: TObject);
begin
  CopyListBoxItems(ListBox2, ListBox1, True);
end;

procedure TVsAutoSaveDialog.ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = ListBox2;
end;

procedure TVsAutoSaveDialog.ListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = ListBox1;
end;

procedure TVsAutoSaveDialog.ListBox2DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  SpeedButton1.Click;
end;

procedure TVsAutoSaveDialog.ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  SpeedButton3.Click;
end;

procedure TVsAutoSaveDialog.GetControls(Controls: TStrings);
var
  I: Integer;
  Ref: string;
begin
  Controls.Clear;
  for I := 0 to ListBox2.Items.Count - 1 do
  begin
    Ref := ListBox2.Items[I];
    Controls.Add(Trim(GetParam(Ref, ':')));
  end;
end;



end.

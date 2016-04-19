unit uMovie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, ShellAPI;

type
  TfrmMovie = class(TForm)
    PopupMenu1: TPopupMenu;
    PopAbout: TMenuItem;
    N1: TMenuItem;
    PopExit: TMenuItem;
    PopOldView: TMenuItem;
    PopZoomIn: TMenuItem;
    PopZoomOut: TMenuItem;
    PopFullDisplay: TMenuItem;
    N6: TMenuItem;
    Panel_Display: TPanel;
    procedure PopExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PopOldViewClick(Sender: TObject);
    procedure PopZoomInClick(Sender: TObject);
    procedure PopZoomOutClick(Sender: TObject);
    procedure PopFullDisplayClick(Sender: TObject);
    procedure Panel_DisplayMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel_DisplayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    MovieWidth, MovieHeight, tmpWidth, tmpHeight : Integer; // 窗口缩放
    Old_x, Old_y : Integer;  // 用于控制移动窗口
  end;

var
  frmMovie: TfrmMovie;

implementation

uses uEPlayer;

{$R *.dfm}

procedure TfrmMovie.PopExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMovie.FormCreate(Sender: TObject);
begin
  //原始尺寸显示
  MovieWidth  := Panel_Display.Width;
  MovieHeight := Panel_Display.Height;
  tmpWidth  :=  MovieWidth;
  tmpHeight := MovieHeight;
end;

procedure TfrmMovie.PopOldViewClick(Sender: TObject);
begin
  frmMovie.BorderStyle := bsNone;
  frmMovie.ClientWidth := MovieWidth;
  frmMovie.ClientHeight := MovieHeight;
  frmEPlayer.MediaPlayer.Notify := False;
  frmEPlayer.MediaPlayer.Display := Panel_Display;
  frmEPlayer.MediaPlayer.DisplayRect := Panel_Display.ClientRect;
  frmMovie.Visible := True;
  frmMovie.Repaint;
  frmEPlayer.MediaPlayer.Notify := True;
end;

procedure TfrmMovie.PopZoomInClick(Sender: TObject);
begin
  tmpWidth := 2 * tmpWidth;
  tmpHeight := 2 * tmpHeight;
  frmMovie.BorderStyle  := bsNone;
  frmMovie.ClientWidth  := tmpWidth;
  frmMovie.ClientHeight := tmpHeight;
  frmEPlayer.MediaPlayer.Notify := False;
  frmEPlayer.MediaPlayer.Display := Panel_Display;
  frmEPlayer.MediaPlayer.DisplayRect := Panel_Display.ClientRect;
  frmMovie.Visible := True;
  Panel_Display.Repaint;
  frmEPlayer.MediaPlayer.Notify := True;
end;

procedure TfrmMovie.PopZoomOutClick(Sender: TObject);
begin
  tmpWidth  := tmpWidth div 2;
  tmpHeight := tmpHeight div 2;
  frmMovie.BorderStyle  := bsNone;
  frmMovie.ClientWidth  := tmpWidth;
  frmMovie.ClientHeight := tmpHeight;
  frmEPlayer.MediaPlayer.Notify := False;
  frmEPlayer.MediaPlayer.Display := Panel_Display;
  frmEPlayer.MediaPlayer.DisplayRect := Panel_Display.ClientRect;
  frmMovie.Visible := True;
  Panel_Display.Repaint;
  frmEPlayer.MediaPlayer.Notify := True;
end;

procedure TfrmMovie.PopFullDisplayClick(Sender: TObject);
begin
  frmMovie.BorderStyle := bsNone;
  frmMovie.WindowState := wsMaximized;
  frmEPlayer.MediaPlayer.Notify := False;
  frmEPlayer.MediaPlayer.Display := Panel_Display;
  frmEPlayer.MediaPlayer.DisplayRect := Panel_Display.ClientRect;
  frmMovie.Visible := True;
  Panel_Display.Repaint;
  frmEPlayer.MediaPlayer.Notify := True;
end;

procedure TfrmMovie.Panel_DisplayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // 记录鼠标原来的坐标值
  Old_x := X;
  Old_y := Y;
end;

procedure TfrmMovie.Panel_DisplayMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  // 按下鼠标左键拖动窗体
  if ssLeft in Shift then
  begin
    frmMovie.Left := frmMovie.Left + X - Old_x;
    frmMovie.Top  := frmMovie.Top + Y - Old_y;
  end;

end;

end.

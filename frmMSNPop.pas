////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   frmMSNPop.pas
//  Creator     :   Shen Min
//  Date        :   2003-11-25
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit frmMSNPop;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmMSNPopForm = class(TForm)
    Timer1: TTimer;
    lbl_title: TLabel;
    lbl_text: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    m_Buf : TBitmap;
    m_Start : Cardinal;
    m_QuickHide : Boolean;
  protected
    procedure Paint(); override;
    procedure CreateParams(var Param: TCreateParams); override;
    procedure WMPRINTCLIENT(var Msg : TMessage); message WM_PRINTCLIENT;
  public
    AnimateTime : Integer;
    StayTime : Integer;
    ClickHide : Boolean;
    CloseCallback : TNotifyEvent; 
  end;

var
  frmMSNPopForm: TfrmMSNPopForm;

implementation

uses SUIPublic;

{$R *.dfm}

procedure RefreshControl(Control: TControl); { Refresh Self and SubControls }
var
    i: Integer;
begin
    if Control is TWinControl then
      for i := 0 to TWinControl(Control).ControlCount - 1 do
        RefreshControl(TWinControl(Control).Controls[i]);

    Control.Invalidate;
end;

{ TfrmMSNPopForm }

procedure TfrmMSNPopForm.Paint;
var
    Buf : TBitmap;
begin
    Buf := TBitmap.Create();
    Buf.Width := ClientWidth;
    Buf.Height := ClientHeight;
    Buf.Canvas.Draw(0, 0, m_Buf);

    BitBlt(Canvas.Handle, 0, 0, Width, Height, Buf.Canvas.Handle, 0, 0, SRCCOPY);

    Buf.Free();
end;

procedure TfrmMSNPopForm.FormCreate(Sender: TObject);
begin
    m_Buf := TBitmap.Create();
    m_Buf.LoadFromResourceName(hInstance, 'MSNPOPFORM');
    m_QuickHide := false;
    Width := m_Buf.Width;
    Height := m_Buf.Height;
    Left := GetWorkAreaRect().Right - Width - 18;
    Top := GetWorkAreaRect().Bottom - Height;
    lbl_title.Left := 10;
    lbl_title.Top := 5;
    lbl_title.Width := ClientWidth - 30;
    lbl_title.Height := 18;
    lbl_text.Left := 10;
    lbl_text.Top := 40;
    lbl_text.Width := ClientWidth - 20;
    lbl_text.Height := ClientHeight - 50;
end;

procedure TfrmMSNPopForm.FormDestroy(Sender: TObject);
begin
    m_Buf.Free();
    m_Buf := nil;
end;

procedure TfrmMSNPopForm.CreateParams(var Param: TCreateParams);
begin
    inherited;
    Param.WndParent := GetDesktopWindow;
    Param.Style := WS_POPUP;
end;

procedure TfrmMSNPopForm.FormShow(Sender: TObject);
begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
    SUIAnimateWindow(Handle, AnimateTime, AW_SLIDE or AW_VER_NEGATIVE);
    RefreshControl(Self);
    m_Start := GetTickCount();
end;

procedure TfrmMSNPopForm.WMPRINTCLIENT(var Msg: TMessage);
begin
    PaintTo(HDC(Msg.WParam), 0, 0);
end;

procedure TfrmMSNPopForm.FormHide(Sender: TObject);
begin
    if not m_QuickHide then
    begin
        SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
        SUIAnimateWindow(Handle, AnimateTime, AW_SLIDE or AW_VER_POSITIVE or AW_HIDE);
        RefreshControl(Self);
    end
    else
        m_QuickHide := false;

    if Assigned(CloseCallback) then
        CloseCallback(nil);        
end;

procedure TfrmMSNPopForm.Timer1Timer(Sender: TObject);
var
    PastTime : Integer;
begin
    PastTime := GetTickCount() - m_Start;
    if (PastTime >= StayTime) or (PastTime < 0) then
    begin
        Timer1.Enabled := false;
        Hide();
    end;
end;

procedure TfrmMSNPopForm.FormClick(Sender: TObject);
begin
    if ClickHide then
    begin
        Timer1.Enabled := false;
        Hide();
    end;
end;

procedure TfrmMSNPopForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then
    begin
        if (
            (X >= 162) and
            (X <= 175) and
            (Y >= 6) and
            (Y <= 19)
        ) then
        begin
            m_QuickHide := true;
            Timer1.Enabled := false;
            Hide();
        end;
    end;
end;

end.

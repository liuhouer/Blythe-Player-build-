////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIGroupBox.pas
//  Creator     :   Shen Min
//  Date        :   2002-08-20 V1-V3
//                  2003-06-24 V4
//                  2006-06-14 V6
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIGroupBox;

interface

{$I SUIPack.inc}

uses Windows, ExtCtrls, Graphics, Controls, Classes, Forms, Messages, SysUtils,
     SUIImagePanel, SUIPublic, SUIThemes, SUIMgr, SUI2Define;

type
    TsuiCustomGroupBox = class(TsuiCustomPanel)
    private
        m_BorderColor : TColor;
        m_Caption : TCaption;
        m_FileTheme: TsuiFileTheme;
        m_UIStyle: TsuiUIStyle;

        procedure SetBorderColor(const Value: TColor);
        procedure SetCaption(const Value : TCaption);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);

        procedure CMFONTCHANGED(var Msg : TMessage); message CM_FONTCHANGED;
        procedure CMTEXTCHANGED(var Msg : TMessage); message CM_TEXTCHANGED;
        procedure WMERASEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

    protected
        procedure Paint(); override;
        function GetClient() : TRect;
        procedure AlignControls(AControl: TControl; var Rect: TRect); override;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy(); override;

        procedure UpdateUIStyle(UIStyle : TsuiUIStyle; FileTheme : TsuiFileTheme); virtual;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property Anchors;
        property BiDiMode;
        property Align;
        property Caption read m_Caption write SetCaption;
        property Color;
        property Font;
        property Enabled;
        property Transparent;
        property ParentColor;
        property ParentShowHint;
        property ParentBiDiMode;
        property ParentFont;
        property TabOrder;
        property TabStop;
        property Visible;
    end;

    TsuiGroupBox = class(TsuiCustomGroupBox)
    published
        property BorderColor;

        property OnCanResize;
        property OnClick;
        property OnConstrainedResize;
        property OnDockDrop;
        property OnDockOver;
        property OnDblClick;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDock;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
        property OnGetSiteInfo;
        property OnMouseDown;
        property OnMouseMove;
        property OnMouseUp;
        property OnResize;
        property OnStartDock;
        property OnStartDrag;
        property OnUnDock;
    end;

implementation

{ TsuiGroupBox }

procedure TsuiCustomGroupBox.AlignControls(AControl: TControl;
  var Rect: TRect);
begin
    Rect.Left := Rect.Left + 3;
    Rect.Right := Rect.Right - 3;
    Rect.Bottom := Rect.Bottom - 3;
    Rect.Top := Rect.Top + Abs(Font.Height) + 5;
    inherited AlignControls(AControl, Rect);
end;

procedure TsuiCustomGroupBox.CMFONTCHANGED(var Msg: TMessage);
begin
    self.Realign();
    Repaint();
end;

procedure TsuiCustomGroupBox.CMTEXTCHANGED(var Msg: TMessage);
begin
    Repaint();
end;

constructor TsuiCustomGroupBox.Create(AOwner: TComponent);
begin
    inherited;
    inherited Caption := ' ';

    Width := 185;
    Height := 105;
    ParentColor := true;
    Transparent := false;

    UIStyle := GetSUIFormStyle(AOwner);
end;

destructor TsuiCustomGroupBox.Destroy;
begin
    inherited;
end;

function TsuiCustomGroupBox.GetClient: TRect;
begin
    Result := Rect(
        ClientRect.Left + 3,
        ClientRect.Top + Abs(Font.Height),
        ClientRect.Right - 2,
        ClientRect.Bottom - 2
    );
end;

procedure TsuiCustomGroupBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        ContainerApplyUIStyle(self, SUI_THEME_DEFAULT, nil);
        SetUIStyle(SUI_THEME_DEFAULT);
    end;
end;

procedure TsuiCustomGroupBox.Paint;
var
    R : TRect;
    CapHeight : Integer;
begin
    CapHeight := Abs(Font.Height);

    if Transparent then
        inherited
    else
    begin
        Canvas.Brush.Color := Color;
        Canvas.FillRect(ClientRect);
    end;

    Canvas.Font := Font;

    // draw border
    R := ClientRect;
    R.Top := R.Top + CapHeight div 2 + 1;
    Canvas.Pen.Color := m_BorderColor;
    if (BidiMode = bdRightToLeft) and SysLocale.MiddleEast then
    begin
        Canvas.MoveTo(R.Right - 3, R.Top);
        Canvas.LineTo(R.Right - 1, R.Top);
        Canvas.LineTo(R.Right - 1, R.Bottom - 1);
        Canvas.LineTo(R.Left + 1, R.Bottom - 1);
        Canvas.LineTo(R.Left + 1, R.Top);
        if m_Caption <> '' then
            Canvas.LineTo(R.Right - Canvas.TextWidth(m_Caption) - 7, R.Top)
        else
            Canvas.LineTo(R.Right - 1, R.Top);
    end
    else
    begin
        Canvas.MoveTo(R.Left + 2, R.Top);
        Canvas.LineTo(R.Left, R.Top);
        Canvas.LineTo(R.Left, R.Bottom - 1);
        Canvas.LineTo(R.Right - 1, R.Bottom - 1);
        Canvas.LineTo(R.Right - 1, R.Top);
        if m_Caption <> '' then
            Canvas.LineTo(R.Left + Canvas.TextWidth(m_Caption) + 6, R.Top)
        else
            Canvas.LineTo(R.Left, R.Top);
    end;
    
    // draw caption
    Canvas.Font := Font;
    if not Enabled then
        Canvas.Font.Color := clGray;
    Canvas.Brush.Style := bsClear;
    if (BidiMode = bdRightToLeft) and SysLocale.MiddleEast then
        Canvas.TextOut(Width - 6 - Canvas.TextWidth(m_Caption), 0, m_Caption)
    else
        Canvas.TextOut(5, 0, m_Caption);
end;

procedure TsuiCustomGroupBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiCustomGroupBox.SetCaption(const Value: TCaption);
begin
    m_Caption := Value;

    Repaint();
end;

procedure TsuiCustomGroupBox.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiCustomGroupBox.SetUIStyle(const Value: TsuiUIStyle);
begin
    m_UIStyle := Value;
    UpdateUIStyle(Value, FileTheme);
end;

procedure TsuiCustomGroupBox.UpdateUIStyle(UIStyle: TsuiUIStyle; FileTheme : TsuiFileTheme);
var
    OutUIStyle : TsuiUIStyle;
begin
    ContainerApplyUIStyle(self, UIStyle, FileTheme);
    
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR);
        Font.Color := m_FileTheme.GetColor(SKIN2_CONTROLFONTCOLOR);
    end
    else
    begin
        BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);
        Font.Color := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_FONT_COLOR);
    end;
end;

procedure TsuiCustomGroupBox.WMERASEBKGND(var Msg: TMessage);
begin
    // do nothing
end;

end.

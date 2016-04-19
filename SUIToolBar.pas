////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIToolBar.pas
//  Creator     :   Shen Min
//  Date        :   2002-12-12 V3
//                  2006-06-14 V6
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIToolBar;

interface

{$I SUIPack.inc}

uses Windows, Messages, SysUtils, Classes, Controls, ToolWin, ComCtrls, Graphics,
     Forms, Imglist, SUIForm,
     SUIThemes, SUIMgr, SUI2Define;

type
    TsuiToolBar = class(TToolBar)
    private
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;
        m_ButtonColor : TColor;
        m_ButtonBorderColor : TColor;
        m_ButtonDownColor : TColor;
        m_BarColor, m_BarToColor : TColor;

        procedure DrawBar(Sender: TToolBar; const ARect: TRect; var DefaultDraw: Boolean);
        procedure DrawButton(Sender: TToolBar; Button: TToolButton; State: TCustomDrawState; var DefaultDraw: Boolean);

        procedure DrawDownButton(
            ACanvas : TCanvas;
            ARect : TRect;
            ImgLst : TCustomImageList;
            ImageIndex : Integer;
            Caption : TCaption;
            DropDown : Boolean
        );
        procedure DrawHotButton(
            ACanvas : TCanvas;
            ARect : TRect;
            ImgLst : TCustomImageList;
            ImageIndex : Integer;
            Caption : TCaption;
            DropDown : Boolean
        );

        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure SetButtonBorderColor(const Value: TColor);
        procedure SetButtonColor(const Value: TColor);
        procedure SetButtonDownColor(const Value: TColor);
        procedure SetFileTheme(const Value: TsuiFileTheme);

    protected
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;    

    public
        constructor Create(AOwner : TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property ButtonColor : TColor read m_ButtonColor write SetButtonColor;
        property ButtonBorderColor : TColor read m_ButtonBorderColor write SetButtonBorderColor;
        property ButtonDownColor : TColor read m_ButtonDownColor write SetButtonDownColor;

        property Color;
        property Transparent;

    end;

implementation

uses SUIPublic;

function ReplaceStr(const Source : String; const FindStr : String; const ReplaceStr : String) : String;
var
    p : Integer;
begin
    Result := Source;
    p := Pos(FindStr, Source);
    while p <> 0 do
    begin
        Result := Copy(Result, 1, p - 1) + ReplaceStr + Copy(Result, p + Length(FindStr), Length(Result));
        p := Pos(FindStr, Result);
    end;
end;

function RemoveHotKey(const Source : String) : String;
begin
    Result := ReplaceStr(Source, '&', '');
end;

{ TsuiToolBar }

constructor TsuiToolBar.Create(AOwner: TComponent);
begin
    inherited;

    if not (csDesigning in ComponentState) then
        OnCustomDrawButton := DrawButton;
    OnCustomDraw := DrawBar;

    Flat := true;
    Transparent := false;
    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiToolBar.DrawBar(Sender: TToolBar; const ARect: TRect; var DefaultDraw: Boolean);
begin
    if Transparent then
        DoTrans(Canvas, self)
    else
    begin
        if m_BarColor = m_BarToColor then
            Exit;
        DrawHorizontalGradient(Sender.Canvas, ARect, m_BarColor, m_BarToColor);
    end;
end;

procedure TsuiToolBar.DrawButton(
    Sender: TToolBar;
    Button: TToolButton;
    State: TCustomDrawState;
    var DefaultDraw: Boolean
);
var
    ACanvas : TCanvas;
    ARect : TRect;
    ImgLst : TCustomImageList;
    X, Y : Integer;
    DropDown : Boolean;
begin
    ACanvas := Sender.Canvas;
    ARect := Button.BoundsRect;
    DropDown := (Button.Style = tbsDropDown);

    if cdsHot in State then
    begin
        if (HotImages <> nil) then
            ImgLst := HotImages
        else
            ImgLst := Images;

        if cdsSelected in State then
            DrawDownButton(ACanvas, ARect, ImgLst, Button.ImageIndex, Button.Caption, DropDown)
        else
            DrawHotButton(ACanvas, ARect, ImgLst, Button.ImageIndex, Button.Caption, DropDown);
        if DropDown then
        begin
            ACanvas.Brush.Color := clBlack;
            ACanvas.Pen.Color := clBlack;

            X := ARect.Right - 9;
            Y := (ARect.Bottom - ARect.Top) div 2;
            ACanvas.Polygon([Point(X, Y), Point(X + 4, Y), Point(X + 2, Y + 2)]);
            X := ARect.Right - 8;
            Y := (ARect.Bottom - ARect.Top) div 2;
            ACanvas.Polygon([Point(X, Y), Point(X + 2, Y), Point(X + 1, Y + 1)]);
            ACanvas.MoveTo(ARect.Right - 14, ARect.Top);
            ACanvas.LineTo(ARect.Right - 14, ARect.Bottom);
        end;

        DefaultDraw := false;
    end
    else if (cdsSelected in State) or (cdsChecked in State) then
    begin
        if (HotImages <> nil) then
            ImgLst := HotImages
        else
            ImgLst := Images;

        DrawHotButton(ACanvas, ARect, ImgLst, Button.ImageIndex, Button.Caption, DropDown);
        DefaultDraw := false;
    end;
end;

procedure TsuiToolBar.DrawDownButton(
    ACanvas : TCanvas;
    ARect : TRect;
    ImgLst : TCustomImageList;
    ImageIndex : Integer;
    Caption : TCaption;
    DropDown : Boolean    
);
var
    nLeft : Integer;
    nWidth : Integer;
    R : TRect;
begin
    ACanvas.Brush.Color := m_ButtonDownColor;
    ACanvas.Pen.Color := m_ButtonBorderColor;
    ACanvas.Rectangle(ARect);

    if ImgLst = nil then
    begin
        if ShowCaptions then
        begin
            if not List then
            begin
                nWidth := ACanvas.TextWidth(RemoveHotKey(Caption));
                if DropDown then
                    nLeft := (ARect.Right - 14 - ARect.Left - nWidth) div 2
                else
                    nLeft := (ARect.Right - ARect.Left - nWidth) div 2;
                R := Rect(ARect.Left + nLeft, ARect.Top + 5, ARect.Right, ARect.Bottom);
                DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT);
//                ACanvas.TextOut(ARect.Left + nLeft, ARect.Top + 5, Caption);
            end
            else
            begin
                R := Rect(ARect.Left + 8, ARect.Top + 3, ARect.Right, ARect.Bottom);
                DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT);
//                ACanvas.TextOut(ARect.Left + 8, ARect.Top + 3, Caption);
            end;
        end;

        Exit;
    end;

    if not List then
    begin
        if DropDown then
            nLeft := (ARect.Right - 14 - ARect.Left - ImgLst.Width) div 2
        else
            nLeft := (ARect.Right - ARect.Left - ImgLst.Width) div 2;
        ImgLst.Draw(ACanvas, ARect.Left + nLeft, ARect.Top + 3, ImageIndex);
    end
    else
    begin
        ImgLst.Draw(ACanvas, ARect.Left + 5, ARect.Top + 3, ImageIndex);
    end;

    if ShowCaptions then
    begin
        if not List then
        begin
            nWidth := ACanvas.TextWidth(RemoveHotKey(Caption));
            if DropDown then
                nLeft := (ARect.Right - 14 - ARect.Left - nWidth) div 2
            else
                nLeft := (ARect.Right - ARect.Left - nWidth) div 2;
            R := Rect(ARect.Left + nLeft, ARect.Top + ImgLst.Height + 4, ARect.Right, ARect.Bottom);
            DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT);
//            ACanvas.TextOut(ARect.Left + nLeft, ARect.Top + ImgLst.Height + 4, Caption);
        end
        else
        begin
            R := Rect(ARect.Left + ImgLst.Width + 7, ARect.Top + 4 + (ImgLst.Height - 16) div 2, ARect.Right, ARect.Bottom);
            DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT);
//            ACanvas.TextOut(ARect.Left + ImgLst.Width + 7, ARect.Top + 4, Caption);
        end;
    end;
end;

procedure TsuiToolBar.DrawHotButton(
    ACanvas : TCanvas;
    ARect : TRect;
    ImgLst : TCustomImageList;
    ImageIndex : Integer;
    Caption : TCaption;
    DropDown : Boolean    
);
var
    nLeft : Integer;
    nWidth : Integer;
    R : TRect;
begin
    ACanvas.Brush.Color := m_ButtonColor;
    ACanvas.Pen.Color := m_ButtonBorderColor;
    ACanvas.Rectangle(ARect);

    if ImgLst = nil then
    begin
        if ShowCaptions then
        begin
            if not List then
            begin
                nWidth := ACanvas.TextWidth(RemoveHotKey(Caption));
                if DropDown then
                    nLeft := (ARect.Right - 14 - ARect.Left - nWidth) div 2
                else
                    nLeft := (ARect.Right - ARect.Left - nWidth) div 2;
                R := Rect(ARect.Left + nLeft, ARect.Top + 4, ARect.Right, ARect.Bottom);
                DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT);
//                ACanvas.TextOut(ARect.Left + nLeft, ARect.Top + 4, Caption);
            end
            else
            begin
                R := Rect(ARect.Left + 8, ARect.Top + 3, ARect.Right, ARect.Bottom);
                DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT);
//                ACanvas.TextOut(ARect.Left + 8, ARect.Top + 3, Caption);
            end;
        end;

        Exit;
    end;

    if not List then
    begin
        if DropDown then
            nLeft := (ARect.Right - 14 - ARect.Left - ImgLst.Width) div 2
        else
            nLeft := (ARect.Right - ARect.Left - ImgLst.Width) div 2;

        ImgLst.Draw(ACanvas, ARect.Left + nLeft, ARect.Top + 3, ImageIndex);
    end
    else
    begin
        ImgLst.Draw(ACanvas, ARect.Left + 5, ARect.Top + 3, ImageIndex);
    end;
    
    if ShowCaptions then
    begin
        if not List then
        begin
            nWidth := ACanvas.TextWidth(RemoveHotKey(Caption));
            if DropDown then
                nLeft := (ARect.Right - 14 - ARect.Left - nWidth) div 2
            else
                nLeft := (ARect.Right - ARect.Left - nWidth) div 2;
            R := Rect(ARect.Left + nLeft, ARect.Top + ImgLst.Height + 4, ARect.Right, ARect.Bottom);
            DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT);
//            ACanvas.TextOut(ARect.Left + nLeft, ARect.Top + ImgLst.Height + 4, Caption);
        end
        else
        begin
            R := Rect(ARect.Left + ImgLst.Width + 7, ARect.Top + 4 + (ImgLst.Height - 16) div 2, ARect.Right, ARect.Bottom);
            DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT);
//            ACanvas.TextOut(ARect.Left + ImgLst.Width + 7, ARect.Top + 4, Caption);
        end;
    end;
end;

procedure TsuiToolBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;
    
    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);
    end;
end;

procedure TsuiToolBar.SetButtonBorderColor(const Value: TColor);
begin
    m_ButtonBorderColor := Value;

    Repaint();
end;

procedure TsuiToolBar.SetButtonColor(const Value: TColor);
begin
    m_ButtonColor := Value;

    Repaint();
end;

procedure TsuiToolBar.SetButtonDownColor(const Value: TColor);
begin
    m_ButtonDownColor := Value;

    Repaint();
end;

procedure TsuiToolBar.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiToolBar.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;

    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        m_ButtonBorderColor := m_FileTheme.GetColor(SKIN2_TOOLBARBORDERCOLOR);
        m_ButtonColor := m_FileTheme.GetColor(SKIN2_TOOLBARSTARTCOLOR);
        m_ButtonDownColor := m_FileTheme.GetColor(SKIN2_TOOLBARDOWNCOLOR);
        m_BarColor := m_FileTheme.GetColor(SKIN2_TOOLBARSTARTCOLOR);
        m_BarToColor := m_FileTheme.GetColor(SKIN2_TOOLBARENDCOLOR);
        Color := m_BarColor;
    end
    else
    begin
        m_ButtonBorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_TOOLBAR_BUTTON_BORDER_COLOR);
        m_ButtonColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_TOOLBAR_BUTTON_BACKGROUND_COLOR);
        m_ButtonDownColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_TOOLBAR_BUTTON_DOWN_BACKGROUND_COLOR);
        Color := GetInsideThemeColor(OutUIStyle, SUI_THEME_FORM_BACKGROUND_COLOR);
        m_BarColor := Color;
        m_BarToColor := Color;
    end;

    if {$IFDEF RES_MACOS} (m_UIStyle = MacOS) and (Parent <> nil) and (Parent is TsuiForm) {$ELSE} false {$ENDIF} or
        {$IFDEF RES_PROTEIN} (m_UIStyle = Protein) and (Parent <> nil) and (Parent is TsuiForm) {$ELSE} false {$ENDIF} then
        Transparent := true
    else
        Transparent := false;

    EdgeInner := esNone;
    EdgeOuter := esNone;

    Repaint();
end;

end.

////////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIImagePanel.pas
//  Creater     :   Shen Min
//  Date        :   2001-10-15 V1
//                  2006-06-14 V6
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////////


unit SUIImagePanel;

interface

{$I SUIPack.inc}

uses Windows, Extctrls, Graphics, Classes, Messages, Controls, SysUtils, Forms,
     SUIPublic, SUIThemes, SUIMgr, SUI2Define;

type
    TsuiPanel = class(TCustomPanel)
    private
        m_BorderColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;
        m_TitleBitmap : TBitmap;
        m_ShowButton : Boolean;
        m_InButton : Boolean;
        m_Poped : Boolean;
        m_OnPush : TNotifyEvent;
        m_OnPop : TNotifyEvent;
        m_Height : Integer;
        m_Moving : Boolean;
        m_FromTheme : Boolean;
        m_CaptionFontColor : TColor;
        m_EraseBackground : Boolean;

        procedure WMERASEBKGND(var Msg : TMessage); message WM_ERASEBKGND;
        procedure SetBorderColor(const Value: TColor);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure SetShowButton(const Value: Boolean);
        procedure SetHeight2(const Value: Integer);
        procedure SetCaptionFontColor(const Value: TColor);
        function GetPushed: Boolean;
        procedure PaintButton();

    protected
        procedure Paint(); override;
        procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
        procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
        procedure AlignControls(AControl: TControl; var Rect: TRect); override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure Resize(); override;
        
    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy(); override;

        procedure Pop();
        procedure Push();
        property Pushed : Boolean read GetPushed;

        property EraseBackground : Boolean read m_EraseBackground write m_EraseBackground;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;
        property Font;
        property Caption;
        property ShowButton : Boolean read m_ShowButton write SetShowButton;
        property Height : Integer read m_Height write SetHeight2;
        property CaptionFontColor : TColor read m_CaptionFontColor write SetCaptionFontColor;

        property BiDiMode;
        property Anchors;
        property Align;
        property TabStop;
        property TabOrder;
        property Color;
        property Visible;
        property PopupMenu;

        property OnPush : TNotifyEvent read m_OnPush write m_OnPush;
        property OnPop : TNotifyEvent read m_OnPop write m_OnPop;

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

    TsuiDrawStyle = (suiNormal, suiStretch, suiTile);

    TsuiCustomPanel = class(TCustomPanel)
    private
        m_Picture : TPicture;
        m_Transparent : Boolean;
        m_AutoSize : Boolean;
        m_CaptionPosX: Integer;
        m_CaptionPosY: Integer;
        m_DrawStyle : TsuiDrawStyle;
        m_EraseBackground : Boolean;

        m_LastDrawCaptionRect : TRect;

        procedure ApplyAutoSize();
        procedure ApplyTransparent();
        procedure SetPicture(const Value: TPicture);
        procedure SetAutoSize(const Value: Boolean); reintroduce;
        procedure SetCaptionPosX(const Value: Integer);
        procedure SetCaptionPosY(const Value: Integer);
        procedure SetDrawStyle(const Value: TsuiDrawStyle);
        procedure CMTEXTCHANGED(var Msg : TMessage); message CM_TEXTCHANGED;
        procedure WMERASEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

    protected
        procedure Paint(); override;
        procedure ClearPanel(); virtual;
        procedure RepaintText(Rect : TRect); virtual;
        procedure PictureChanged(Sender: TObject); virtual;
        procedure SetTransparent(const Value: Boolean); virtual;
        procedure Resize(); override;

        property Picture : TPicture read m_Picture write SetPicture;
        property Transparent : Boolean Read m_Transparent Write SetTransparent default false;
        property AutoSize : Boolean Read m_AutoSize Write SetAutoSize;
        property CaptionPosX : Integer read m_CaptionPosX write SetCaptionPosX;
        property CaptionPosY : Integer read m_CaptionPosY write SetCaptionPosY;
        property DrawStyle : TsuiDrawStyle read m_DrawStyle write SetDrawStyle;

    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy(); override;

        property EraseBackground : Boolean read m_EraseBackground write m_EraseBackground;

    end;

    TsuiImagePanel = class(TsuiCustomPanel)
    published
        property BiDiMode;
        property BorderWidth;
        property Anchors;
        property Picture;
        property Transparent;
        property AutoSize;
        property Alignment;
        property Align;
        property Font;
        property TabStop;
        property TabOrder;
        property Caption;
        property Color;
        property DrawStyle;
        property Visible;
        property PopupMenu;
        
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


{ TsuiCustomPanel }

procedure TsuiCustomPanel.ApplyAutoSize;
begin
    if m_AutoSize then
    begin
        if (
            (Align <> alTop) and
            (Align <> alBottom) and
            (Align <> alClient)
        ) then
            Width := m_Picture.Width;

        if (
            (Align <> alLeft) and
            (Align <> alRight) and
            (Align <> alClient)
        ) then
            Height := m_Picture.Height;
    end;
end;

procedure TsuiCustomPanel.ApplyTransparent;
begin
    if m_Picture.Graphic.Transparent <> m_Transparent then
        m_Picture.Graphic.Transparent := m_Transparent;
end;

procedure TsuiCustomPanel.ClearPanel;
begin
    Canvas.Brush.Color := Color;

    if ParentWindow <> 0 then
        Canvas.FillRect(ClientRect);
end;

procedure TsuiCustomPanel.CMTEXTCHANGED(var Msg: TMessage);
begin
    RepaintText(m_LastDrawCaptionRect);
    Repaint();
end;

constructor TsuiCustomPanel.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    m_Picture := TPicture.Create();
    ASSERT(m_Picture <> nil);

    m_Picture.OnChange := PictureChanged;
    m_CaptionPosX := -1;
    m_CaptionPosY := -1;

    BevelInner := bvNone;
    BevelOuter := bvNone;

    m_EraseBackground := false;

    Repaint();
end;

destructor TsuiCustomPanel.Destroy;
begin
    if m_Picture <> nil then
    begin
        m_Picture.Free();
        m_Picture := nil;
    end;

    inherited;
end;

procedure TsuiCustomPanel.Paint;
var
    uDrawTextFlag : Cardinal;
    Rect : TRect;
    Buf : TBitmap;
begin
    Buf := TBitmap.Create();
    Buf.Height := Height;
    Buf.Width := Width;

    if m_Transparent then
        DoTrans(Buf.Canvas, self);

    if Assigned(m_Picture.Graphic) then
    begin
        if m_DrawStyle = suiStretch then
            Buf.Canvas.StretchDraw(ClientRect, m_Picture.Graphic)
        else if m_DrawStyle = suiTile then
            TileDraw(Buf.Canvas, m_Picture, ClientRect)
        else
            Buf.Canvas.Draw(0, 0, m_Picture.Graphic);
    end
    else if not m_Transparent then
    begin
        Buf.Canvas.Brush.Color := Color;
        Buf.Canvas.FillRect(ClientRect);
    end;

    Buf.Canvas.Brush.Style := bsClear;

    if Trim(Caption) <> '' then
    begin
        Buf.Canvas.Font := Font;

        if (m_CaptionPosX <> -1) and (m_CaptionPosY <> -1) then
        begin
            Buf.Canvas.TextOut(m_CaptionPosX, m_CaptionPosY, Caption);
            m_LastDrawCaptionRect := Classes.Rect(
                m_CaptionPosX,
                m_CaptionPosY,
                m_CaptionPosX + Buf.Canvas.TextWidth(Caption),
                m_CaptionPosY + Buf.Canvas.TextWidth(Caption)
            );
        end
        else
        begin
            Rect := ClientRect;
            uDrawTextFlag := DT_CENTER;
            if Alignment = taRightJustify then
                uDrawTextFlag := DT_RIGHT
            else if Alignment = taLeftJustify then
                uDrawTextFlag := DT_LEFT;
            DrawText(Buf.Canvas.Handle, PChar(Caption), -1, Rect, uDrawTextFlag or DT_SINGLELINE or DT_VCENTER);
            m_LastDrawCaptionRect := Rect;
        end;
    end;

    BitBlt(Canvas.Handle, 0, 0, Width, Height, Buf.Canvas.Handle, 0, 0, SRCCOPY);    
    Buf.Free();
end;

procedure TsuiCustomPanel.PictureChanged(Sender: TObject);
begin
    if m_Picture.Graphic <> nil then
    begin
        if m_AutoSize then
            ApplyAutoSize();
        ApplyTransparent();
    end;

    ClearPanel();
    RePaint();
end;

procedure TsuiCustomPanel.RepaintText(Rect: TRect);
begin
    // not implete
end;

procedure TsuiCustomPanel.Resize;
begin
    inherited;

    Repaint();
end;

procedure TsuiCustomPanel.SetAutoSize(const Value: Boolean);
begin
    m_AutoSize := Value;

    if m_Picture.Graphic <> nil then
        ApplyAutoSize();
end;

procedure TsuiCustomPanel.SetCaptionPosX(const Value: Integer);
begin
    m_CaptionPosX := Value;

    RePaint();
end;

procedure TsuiCustomPanel.SetCaptionPosY(const Value: Integer);
begin
    m_CaptionPosY := Value;

    RePaint();
end;

procedure TsuiCustomPanel.SetDrawStyle(const Value: TsuiDrawStyle);
begin
    m_DrawStyle := Value;

    ClearPanel();
    Repaint();
end;

procedure TsuiCustomPanel.SetPicture(const Value: TPicture);
begin
    m_Picture.Assign(Value);

    ClearPanel();
    Repaint();
end;

procedure TsuiCustomPanel.SetTransparent(const Value: Boolean);
begin
    m_Transparent := Value;

    if m_Picture.Graphic <> nil then
        ApplyTransparent();
    Repaint();
end;

procedure TsuiCustomPanel.WMERASEBKGND(var Msg: TMessage);
begin
    if m_EraseBackground then
        inherited;
end;

{ TsuiPanel }

procedure TsuiPanel.AlignControls(AControl: TControl; var Rect: TRect);
begin
    Rect.Left := Rect.Left + 3;
    Rect.Right := Rect.Right - 3;
    Rect.Bottom := Rect.Bottom - 3;
    Rect.Top := m_TitleBitmap.Height + 3;
    inherited AlignControls(AControl, Rect);
end;

constructor TsuiPanel.Create(AOwner: TComponent);
begin
    inherited;

    m_TitleBitmap := TBitmap.Create();
    m_ShowButton := true;
    m_InButton := false;
    m_Poped := true;
    m_Moving := false;
    Width := 100;
    Height := 100;
    m_FromTheme := false;
    m_EraseBackground := false;

    UIStyle := GetSUIFormStyle(AOwner);    
end;

destructor TsuiPanel.Destroy;
begin
    m_TitleBitmap.Free();
    
    inherited;
end;

function TsuiPanel.GetPushed: Boolean;
begin
    Result := not m_Poped;
end;

procedure TsuiPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    if (m_ShowButton) and (Y <= m_TitleBitmap.Height) then
        PaintButton();
end;

procedure TsuiPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    inherited;

    if Button <> mbLeft then
        Exit;

    if m_InButton then
    begin
        if m_Poped then
            Push()
        else
            Pop();
    end;
    Repaint();
end;

procedure TsuiPanel.Notification(AComponent: TComponent;
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

procedure TsuiPanel.Paint;
var
    Buf : TBitmap;
    R : TRect;
    Btn : TBitmap;
    MousePoint : TPoint;
    Index : Integer;    
begin
    Buf := TBitmap.Create();
    Buf.Width := inherited Width;
    Buf.Height := Height;

    Buf.Canvas.Brush.Color := Color;
    Buf.Canvas.Pen.Color := m_BorderColor;
    Buf.Canvas.Rectangle(ClientRect);

    R := Rect(1, 0, inherited Width - 1, m_TitleBitmap.Height);
    Buf.Canvas.StretchDraw(R, m_TitleBitmap);

    Buf.Canvas.Brush.Style := bsClear;
    Buf.Canvas.Font.Assign(Font);
    Buf.Canvas.Font.Color := m_CaptionFontColor;

    if (BidiMode = bdRightToLeft) and SysLocale.MiddleEast then
    begin
        Dec(R.Right, 10);
        if m_ShowButton and (Align <> alClient) and (Align <> alLeft) and (Align <> alRight) then
            Dec(R.Right, 10);
        DrawText(Buf.Canvas.Handle, PChar(Caption), -1, R, DT_VCENTER or DT_SINGLELINE or DT_RIGHT);
        R.Right := inherited Width - 1;
    end
    else
    begin
        R.Left := 10;
        DrawText(Buf.Canvas.Handle, PChar(Caption), -1, R, DT_VCENTER or DT_SINGLELINE or DT_LEFT);
    end;

    if m_ShowButton and (Align <> alClient) and (Align <> alLeft) and (Align <> alRight) then
    begin
        Btn := TBitmap.Create();
        Btn.LoadFromResourceName(hInstance, 'PANEL_BUTTON');
        R.Left := R.Right - Btn.Width div 4 - 4;
        R.Top := (R.Bottom - Btn.Height) div 2;
        R.Bottom := R.Top + Btn.Height;
        R.Right := R.Left + Btn.Width div 4;
        GetCursorPos(MousePoint);
        MousePoint := ScreenToClient(MousePoint);
        if InRect(MousePoint, R) then
        begin
            if m_Poped then
                Index := 2
            else
                Index := 4;
            m_InButton := true;
        end
        else
        begin
            if m_Poped then
                Index := 1
            else
                Index := 3;
            m_InButton := false;
        end;
        SpitBitmap(Btn, Btn, 4, Index);
        Buf.Canvas.Draw(Width - Btn.Width - 4, (R.Bottom - Btn.Height) div 2 + 2, Btn);
        Btn.Free();
    end;

    BitBlt(Canvas.Handle, 0, 0, Width, Height, Buf.Canvas.Handle, 0, 0, SRCCOPY);

    Buf.Free();
end;

procedure TsuiPanel.PaintButton;
var
    Btn : TBitmap;
    R : TRect;
    MousePoint : TPoint;
    Index : Integer;
begin
    R := Rect(1, 0, inherited Width - 1, m_TitleBitmap.Height);
    if m_ShowButton and (Align <> alClient) and (Align <> alLeft) and (Align <> alRight) then
    begin
        Btn := TBitmap.Create();
        Btn.LoadFromResourceName(hInstance, 'PANEL_BUTTON');
        R.Left := R.Right - Btn.Width div 4 - 4;
        R.Top := (R.Bottom - Btn.Height) div 2;
        R.Bottom := R.Top + Btn.Height;
        R.Right := R.Left + Btn.Width div 4;
        GetCursorPos(MousePoint);
        MousePoint := ScreenToClient(MousePoint);
        if InRect(MousePoint, R) then
        begin
            if m_Poped then
                Index := 2
            else
                Index := 4;
            m_InButton := true;
        end
        else
        begin
            if m_Poped then
                Index := 1
            else
                Index := 3;
            m_InButton := false;
        end;
        SpitBitmap(Btn, Btn, 4, Index);
        Canvas.Draw(Width - Btn.Width - 4, (R.Bottom - Btn.Height) div 2 + 2, Btn);
        Btn.Free();
    end;
end;

procedure TsuiPanel.Pop;
begin
    m_Moving := true;
    while inherited Height + 15 < m_Height do
    begin
        inherited Height := inherited Height + 15;
        Refresh();
        Application.ProcessMessages();
    end;
    inherited Height := m_Height;
    Refresh();
    m_Moving := false;
    m_Poped := true;
    Repaint();
    if Assigned (m_OnPop) then
        m_OnPop(self);        
end;

procedure TsuiPanel.Push;
var
    InnerHeight : Integer;
begin
    if (Align = alClient) or (Align = alLeft) or (Align = alRight) then
        raise Exception.Create('Can''t push when Align is alClient, alLeft or alRight.');
    InnerHeight := m_TitleBitmap.Height;
    if InnerHeight = 0 then
        InnerHeight := 20;
    m_Moving := true;
    while inherited Height - 15 > InnerHeight do
    begin
        inherited Height := inherited Height - 15;
        Refresh();
        Application.ProcessMessages();
    end;
    inherited Height := InnerHeight;
    Refresh();
    m_Moving := false;
    m_Poped := false;
    Repaint();
    if Assigned(m_OnPush) then
        m_OnPush(self);
end;

procedure TsuiPanel.Resize;
begin
    inherited;

    if (not m_Moving) and m_Poped then
    begin
        m_Height := inherited Height;
    end;
end;

procedure TsuiPanel.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiPanel.SetCaptionFontColor(const Value: TColor);
begin
    m_CaptionFontColor := Value;
    Repaint();
end;

procedure TsuiPanel.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    m_FromTheme := true;
    SetUIStyle(m_UIStyle);
    m_FromTheme := false;
end;

procedure TsuiPanel.SetHeight2(const Value: Integer);
begin
    m_Height := Value;

    if (csDesigning in ComponentState) or m_Poped then
        inherited Height := m_Height;
end;

procedure TsuiPanel.SetShowButton(const Value: Boolean);
begin
    m_ShowButton := Value;
    Repaint();
end;

procedure TsuiPanel.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
    Tmp : TBitmap;
begin
    m_UIStyle := Value;

    if m_FromTheme and (m_UIStyle <> FromThemeFile) then
        Exit; 

    Color := clWhite;
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        Tmp := m_FileTheme.GetBitmap(SKIN2_SIDECHANNELTITLE);
        if Tmp <> nil then
            m_TitleBitmap.Assign(Tmp)
        else
            GetInsideThemeBitmap(SUI_THEME_DEFAULT, SUI_THEME_SIDECHENNEL_BAR_IMAGE, m_TitleBitmap);        
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR);
        m_CaptionFontColor := m_FileTheme.GetColor(SKIN2_CONTROLFONTCOLOR);
    end
    else
    begin
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SIDECHENNEL_BAR_IMAGE, m_TitleBitmap);
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);
{$IFDEF RES_MACOS}
        if OutUIStyle = MacOS then
            m_CaptionFontColor := clBlack
        else
{$ENDIF}        
            m_CaptionFontColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_MENU_SELECTED_FONT_COLOR);
    end;

    Height := Height - 1;
    Height := Height + 1;
    Repaint();
end;

procedure TsuiPanel.WMERASEBKGND(var Msg: TMessage);
begin
    if m_EraseBackground then
        inherited;
end;

end.

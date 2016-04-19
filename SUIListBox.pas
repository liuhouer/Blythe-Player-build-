////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIListBox.pas
//  Creator     :   Shen Min
//  Date        :   2002-08-21 V1-V3
//                  2003-07-02 V4
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIListBox;

interface

{$I SUIPack.inc}

{$IFDEF SUIPACK_D6UP}{$WARN UNIT_PLATFORM OFF}{$ENDIF}
uses Windows, Messages, StdCtrls, Forms, Graphics, Classes, Controls, filectrl,
{$IFDEF SUIPACK_D6UP}{$WARN UNIT_PLATFORM ON}{$ENDIF}
     SysUtils,
     SUIScrollBar, SUIThemes, SUIMgr, SUI2Define;

type
    TsuiListBox = class(TCustomListBox)
    private
        m_BorderColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;

        // scroll bar
        m_VScrollBar : TsuiScrollBar;
        m_MouseDown : Boolean;
        m_SelfChanging : Boolean;
        procedure SetVScrollBar(const Value: TsuiScrollBar);
        procedure OnVScrollBarChange(Sender : TObject);
        procedure UpdateScrollBars();
        procedure UpdateScrollBarsPos();

        procedure CMEnabledChanged(var Msg : TMessage); message CM_ENABLEDCHANGED;
        procedure CMVisibleChanged(var Msg : TMEssage); message CM_VISIBLECHANGED;
        procedure WMSIZE(var Msg : TMessage); message WM_SIZE;
        procedure WMMOVE(var Msg : TMessage); message WM_MOVE;
        procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
        procedure WMLBUTTONDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
        procedure WMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
        procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
        procedure LBADDSTRING(var Msg : TMessage); message LB_ADDSTRING;
        procedure LBDELETESTRING(var Msg : TMessage); message LB_DELETESTRING;
        procedure LBINSERTSTRING(var Msg : TMessage); message LB_INSERTSTRING;
        procedure LBSETCOUNT(var Msg : TMessage); message LB_SETCOUNT;
        procedure LBNSELCHANGE(var Msg : TMessage); message LBN_SELCHANGE;
        procedure LBNSETFOCUS(var Msg : TMessage); message LBN_SETFOCUS;
        procedure WMDELETEITEM(var Msg : TMessage); message WM_DELETEITEM;
        procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
        procedure WMVSCROLL(var Message: TWMVScroll); message WM_VSCROLL;
        procedure WMHSCROLL(var Message: TWMHScroll); message WM_HSCROLL;

        procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

        procedure SetBorderColor(const Value: TColor);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);

    private
        FShowFocusRect: Boolean;
        FAlignment: TAlignment;
        FSelectedTextColor: TColor;
        FSelectedColor: TColor;
        FDisabledTextColor: TColor;

        procedure CNDrawItem(var Msg: TWMDrawItem); message CN_DRAWITEM;
        procedure SetAlignment(const Value: TAlignment);
        procedure SetSelectedColor(const Value: TColor);
        procedure SetSelectedTextColor(const Value: TColor);
        procedure SetShowFocusRect(const Value: Boolean);
        procedure SetDisabledTextColor(const Value: TColor);
        
    protected
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
        procedure MeasureItem(Index: Integer; var Height: Integer); override;
        procedure Loaded(); override;

    public
        constructor Create(AOwner : TComponent); override;
        function MeasureString(const S: string; WidthAvail: Integer): Integer;
        procedure DefaultDrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); virtual;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;                    
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;

        property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
        property SelectedColor: TColor read FSelectedColor write SetSelectedColor default clHighlight;
        property SelectedTextColor: TColor read FSelectedTextColor write SetSelectedTextColor default clHighlightText;
        property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
        property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect default True;

        // scroll bar
        property VScrollBar : TsuiScrollBar read m_VScrollBar write SetVScrollBar;

        property Style;
        property Align;
        property Anchors;
        property BiDiMode;
        property Color;
        property Columns;
        property Constraints;
        property Ctl3D;
        property DragCursor;
        property DragKind;
        property DragMode;
        property Enabled;
        property ExtendedSelect;
        property Font;
        property ImeMode;
        property ImeName;
        property IntegralHeight;
        property ItemHeight;
        property Items;
        property MultiSelect;
        property ParentBiDiMode;
        property ParentColor;
        property ParentCtl3D;
        property ParentFont;
        property ParentShowHint;
        property PopupMenu;
        property ShowHint;
        property Sorted;
        property TabOrder;
        property TabStop;
        property TabWidth;
        property Visible;
        property OnClick;
{$IFDEF SUIPACK_D6UP}
        property OnData;
        property OnDataFind;
        property OnDataObject;
{$ENDIF}
        property OnDblClick;
        property OnDragDrop;
        property OnDragOver;
        property OnDrawItem;
        property OnEndDock;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
        property OnKeyDown;
        property OnKeyPress;
        property OnKeyUp;
        property OnMeasureItem;
        property OnMouseDown;
        property OnMouseMove;
        property OnMouseUp;
        property OnStartDock;
        property OnStartDrag;

    end;

    TsuiDirectoryListBox = class(TDirectoryListBox)
    private
        m_BorderColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;

        // scroll bar
        m_VScrollBar : TsuiScrollBar;
        m_MouseDown : Boolean;
        m_SelfChanging : Boolean;
        procedure SetVScrollBar(const Value: TsuiScrollBar);
        procedure OnVScrollBarChange(Sender : TObject);
        procedure UpdateScrollBars();
        procedure UpdateScrollBarsPos();

        procedure CMEnabledChanged(var Msg : TMessage); message CM_ENABLEDCHANGED;
        procedure CMVisibleChanged(var Msg : TMEssage); message CM_VISIBLECHANGED;
        procedure WMSIZE(var Msg : TMessage); message WM_SIZE;
        procedure WMMOVE(var Msg : TMessage); message WM_MOVE;
        procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
        procedure WMLBUTTONDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
        procedure WMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
        procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
        procedure LBADDSTRING(var Msg : TMessage); message LB_ADDSTRING;
        procedure LBDELETESTRING(var Msg : TMessage); message LB_DELETESTRING;
        procedure LBINSERTSTRING(var Msg : TMessage); message LB_INSERTSTRING;
        procedure LBSETCOUNT(var Msg : TMessage); message LB_SETCOUNT;
        procedure LBNSELCHANGE(var Msg : TMessage); message LBN_SELCHANGE;
        procedure LBNSETFOCUS(var Msg : TMessage); message LBN_SETFOCUS;
        procedure WMDELETEITEM(var Msg : TMessage); message WM_DELETEITEM;
        procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
        procedure WMVSCROLL(var Message: TWMVScroll); message WM_VSCROLL;
        procedure WMHSCROLL(var Message: TWMHScroll); message WM_HSCROLL;

        procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

        procedure SetBorderColor(const Value: TColor);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        
    protected
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure Loaded(); override;

    public
        constructor Create(AOwner : TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;                    
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;

        // scroll bar
        property VScrollBar : TsuiScrollBar read m_VScrollBar write SetVScrollBar;

    end;

    TsuiFileListBox = class(TFileListBox)
    private
        m_BorderColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;

        // scroll bar
        m_VScrollBar : TsuiScrollBar;
        m_MouseDown : Boolean;
        m_SelfChanging : Boolean;
        procedure SetVScrollBar(const Value: TsuiScrollBar);
        procedure OnVScrollBarChange(Sender : TObject);
        procedure UpdateScrollBars();
        procedure UpdateScrollBarsPos();

        procedure CMEnabledChanged(var Msg : TMessage); message CM_ENABLEDCHANGED;
        procedure CMVisibleChanged(var Msg : TMEssage); message CM_VISIBLECHANGED;
        procedure WMSIZE(var Msg : TMessage); message WM_SIZE;
        procedure WMMOVE(var Msg : TMessage); message WM_MOVE;
        procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
        procedure WMLBUTTONDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
        procedure WMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
        procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
        procedure LBADDSTRING(var Msg : TMessage); message LB_ADDSTRING;
        procedure LBDELETESTRING(var Msg : TMessage); message LB_DELETESTRING;
        procedure LBINSERTSTRING(var Msg : TMessage); message LB_INSERTSTRING;
        procedure LBSETCOUNT(var Msg : TMessage); message LB_SETCOUNT;
        procedure LBNSELCHANGE(var Msg : TMessage); message LBN_SELCHANGE;
        procedure LBNSETFOCUS(var Msg : TMessage); message LBN_SETFOCUS;
        procedure WMDELETEITEM(var Msg : TMessage); message WM_DELETEITEM;
        procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
        procedure WMVSCROLL(var Message: TWMVScroll); message WM_VSCROLL;
        procedure WMHSCROLL(var Message: TWMHScroll); message WM_HSCROLL;

        procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

        procedure SetBorderColor(const Value: TColor);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        
    protected
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure Loaded(); override;

    public
        constructor Create(AOwner : TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;                    
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;

        // scroll bar
        property VScrollBar : TsuiScrollBar read m_VScrollBar write SetVScrollBar;

    end;

implementation

uses SUIPublic, SUIProgressBar;

const
  AlignFlags: array [TAlignment] of DWORD = (DT_LEFT, DT_RIGHT, DT_CENTER);


{ TsuiListBox }

procedure TsuiListBox.CMEnabledChanged(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.CMVisibleChanged(var Msg: TMEssage);
begin
    inherited;
    if not Visible then
    begin
        if m_VScrollBar <> nil then
            m_VScrollBar.Visible := Visible;
    end
    else
        UpdateScrollBarsPos();
end;

constructor TsuiListBox.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle + [csOpaque];
    BorderStyle := bsNone;
    BorderWidth := 2;
    m_SelfChanging := false;
    m_MouseDown := false;

    FAlignment := taLeftJustify;
    FSelectedColor := clHighlight;
    FSelectedTextColor := clHighlightText;
    FDisabledTextColor := clGrayText;
    FShowFocusRect := True;
    Style := lbOwnerDrawFixed;   

    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiListBox.LBADDSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.LBDELETESTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.LBINSERTSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.LBNSELCHANGE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.LBNSETFOCUS(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.LBSETCOUNT(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if AComponent = nil then
        Exit;

    if (
        (Operation = opRemove) and
        (AComponent = m_VScrollBar)
    )then
    begin
        m_VScrollBar := nil;
    end;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);
    end;
end;

procedure TsuiListBox.OnVScrollBarChange(Sender: TObject);
begin
    if m_SelfChanging then
        Exit;
    SendMessage(Handle, WM_VSCROLL, MakeWParam(SB_THUMBPOSITION, m_VScrollBar.Position), 0);
//    SetScrollPos(Handle, SB_VERT, m_VScrollBar.Position, true);
    UpdateScrollBars();
end;

procedure TsuiListBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiListBox.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    if m_VScrollBar <> nil then
        m_VScrollBar.FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiListBox.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;

    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR)
    else
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);

    if m_VScrollBar <> nil then
        m_VScrollBar.UIStyle := OutUIStyle;
    Repaint();
end;

procedure TsuiListBox.SetVScrollBar(const Value: TsuiScrollBar);
begin
    if m_VScrollBar = Value then
        Exit;
    if m_VScrollBar <> nil then
    begin
        m_VScrollBar.OnChange := nil;
        m_VScrollBar.LineButton := 0;
        m_VScrollBar.Max := 100;
        m_VScrollBar.Enabled := true;
    end;

    m_VScrollBar := Value;
    if m_VScrollBar = nil then
        Exit;
    m_VScrollBar.Orientation := suiVertical;
    m_VScrollBar.OnChange := OnVScrollBArChange;
    m_VScrollBar.BringToFront();

    UpdateScrollBarsPos();
end;

procedure TsuiListBox.UpdateScrollBars;
var
    info : tagScrollInfo;
    barinfo : tagScrollBarInfo;
    R : Boolean;
begin
    m_SelfChanging := true;
    if m_VScrollBar <> nil then
    begin
        barinfo.cbSize := SizeOf(barinfo);
        R := SUIGetScrollBarInfo(Handle, Integer(OBJID_VSCROLL), barinfo);
        if (barinfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) or
           (barinfo.rgstate[0] = STATE_SYSTEM_UNAVAILABLE) or
           (not R) then
        begin
            m_VScrollBar.LineButton := 0;
            m_VScrollBar.Enabled := false;
            m_VScrollBar.Visible := false;
        end
        else if not Enabled then
        begin
            m_VScrollBar.Enabled := false;
        end
        else
        begin
            m_VScrollBar.LineButton := abs(barinfo.xyThumbBottom - barinfo.xyThumbTop);
            m_VScrollBar.Enabled := true;
            m_VScrollBar.Visible := true;
        end;
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_VERT, info);
        m_VScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_VScrollBar.Min := info.nMin;
        m_VScrollBar.Position := info.nPos;
    end;
    m_SelfChanging := false;
end;

procedure TsuiListBox.UpdateScrollBarsPos;
var
    L2R : Boolean;
begin
    if m_VScrollBar <> nil then
    begin
        if m_VScrollBar.Width > Width then
            m_VScrollBar.Left := Left
        else
        begin
            L2R := ((BidiMode = bdLeftToRight) or (BidiMode = bdRightToLeftReadingOnly)) or (not SysLocale.MiddleEast);
            if L2R then
                m_VScrollBar.Left := Left + Width - m_VScrollBar.Width - 2
            else
                m_VScrollBar.Left := Left + 2;
        end;
        m_VScrollBar.Top := Top + 1;
        m_VScrollBar.Height := Height - 2;
    end;

    UpdateScrollBars();
end;

procedure TsuiListBox.WMDELETEITEM(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiListBox.WMHSCROLL(var Message: TWMHScroll);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.WMKeyDown(var Message: TWMKeyDown);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.WMLBUTTONDOWN(var Message: TMessage);
begin
    inherited;
    m_MouseDown := true;
    UpdateScrollBars();
end;

procedure TsuiListBox.WMLButtonUp(var Message: TMessage);
begin
    inherited;
    m_MouseDown := false;
end;

procedure TsuiListBox.WMMOUSEMOVE(var Message: TMessage);
begin
    inherited;
    if m_MouseDown then UpdateScrollBars();
end;

procedure TsuiListBox.WMMOUSEWHEEL(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.WMMOVE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiListBox.WMPAINT(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, COlor);
end;

procedure TsuiListBox.WMSIZE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiListBox.WMVSCROLL(var Message: TWMVScroll);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiListBox.CNDrawItem(var Msg: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Msg.DrawItemStruct^ do
  begin
    State := TOwnerDrawState(LongRec(itemState).Lo);
    Canvas.Handle := hDC;
    Canvas.Font := Font;
    Canvas.Brush := Brush;
    if Integer(itemID) >= 0 then
    begin
      if odSelected in State then
      begin
        Canvas.Brush.Color := FSelectedColor;
        Canvas.Font.Color := FSelectedTextColor;
      end;
      if (([odDisabled, odGrayed] * State) <> []) or not Enabled then
        Canvas.Font.Color := FDisabledTextColor;
    end;
    if Integer(itemID) >= 0 then
      DrawItem(itemID, rcItem, State)
    else
    begin
      Canvas.FillRect(rcItem);
      if odFocused in State then
        DrawFocusRect(hDC, rcItem);
    end;
    Canvas.Handle := 0;
  end;
end;

procedure TsuiListBox.DefaultDrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  Flags: Longint;
begin
  Canvas.FillRect(Rect);
  if Index < Items.Count then
  begin
      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or AlignFlags[FAlignment]);
    if not UseRightToLeftAlignment then
      Inc(Rect.Left, 2)
    else
      Dec(Rect.Right, 2);
    DrawText(Canvas.Handle, PChar(Items[Index]), Length(Items[Index]), Rect, Flags);
  end;
end;

procedure TsuiListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  if Assigned(OnDrawItem) then
    inherited DrawItem(Index, Rect, State)
  else
  begin
    DefaultDrawItem(Index, Rect, State);
    if FShowFocusRect and (odFocused in State) then
      Canvas.DrawFocusRect(Rect);
  end;
end;

procedure TsuiListBox.MeasureItem(Index: Integer; var Height: Integer);
begin
  if Assigned(OnMeasureItem) or (not true) or
    (Index < 0) or (Index >= items.count) then
    inherited MeasureItem(Index, Height)
  else
    Height := MeasureString(Items[index], ClientWidth);
end;

function TsuiListBox.MeasureString(const S: string;
  WidthAvail: Integer): Integer;
var
  Flags: Longint;
  R: TRect;
begin
  Canvas.Font := Font;
  Result := Canvas.TextWidth(S);
  { Note: doing the TextWidth unconditionally makes sure the font is properly
    selected into the device context. }
  if WidthAvail > 0 then
  begin
    Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_CALCRECT or AlignFlags[FAlignment]);
    R := Rect(0, 0, WidthAvail - 2, 1);
    DrawText(canvas.handle, Pchar(S), Length(S), R, Flags);
    Result := R.Bottom;
    if Result > 255 then
      Result := 255;
    { Note: item height in a listbox is limited to 255 pixels since Windows
      stores the height in a single byte.}
  end;
end;

procedure TsuiListBox.SetAlignment(const Value: TAlignment);
begin
  if (FAlignment <> Value) then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TsuiListBox.SetDisabledTextColor(const Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    Invalidate;
  end;
end;

procedure TsuiListBox.SetSelectedColor(const Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    Invalidate;
  end;
end;

procedure TsuiListBox.SetSelectedTextColor(const Value: TColor);
begin
  if FSelectedTextColor <> Value then
  begin
    FSelectedTextColor := Value;
    Invalidate;
  end;
end;

procedure TsuiListBox.SetShowFocusRect(const Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    if Focused then
      Invalidate;
  end;
end;

procedure TsuiListBox.Loaded;
begin
    inherited;

    UpdateScrollBarsPos();
end;

{ TsuiDirectoryListBox }

procedure TsuiDirectoryListBox.CMEnabledChanged(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.CMVisibleChanged(var Msg: TMEssage);
begin
    inherited;
    if not Visible then
    begin
        if m_VScrollBar <> nil then
            m_VScrollBar.Visible := Visible;
    end
    else
        UpdateScrollBarsPos();
end;

constructor TsuiDirectoryListBox.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle + [csOpaque];
    BorderStyle := bsNone;
    BorderWidth := 2;
    m_SelfChanging := false;
    m_MouseDown := false;

    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiDirectoryListBox.LBADDSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.LBDELETESTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.LBINSERTSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.LBNSELCHANGE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.LBNSETFOCUS(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.LBSETCOUNT(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.Loaded;
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDirectoryListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if AComponent = nil then
        Exit;

    if (
        (Operation = opRemove) and
        (AComponent = m_VScrollBar)
    )then
    begin
        m_VScrollBar := nil;
    end;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);          
    end;
end;

procedure TsuiDirectoryListBox.OnVScrollBarChange(Sender: TObject);
begin
    if m_SelfChanging then
        Exit;
    SendMessage(Handle, WM_VSCROLL, MakeWParam(SB_THUMBPOSITION, m_VScrollBar.Position), 0);
    Invalidate;
end;

procedure TsuiDirectoryListBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiDirectoryListBox.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    if m_VScrollBar <> nil then
        m_VScrollBar.FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiDirectoryListBox.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;

    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR)
    else
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);

    if m_VScrollBar <> nil then
        m_VScrollBar.UIStyle := OutUIStyle;
    Repaint();
end;

procedure TsuiDirectoryListBox.SetVScrollBar(const Value: TsuiScrollBar);
begin
    if m_VScrollBar = Value then
        Exit;
    if m_VScrollBar <> nil then
    begin
        m_VScrollBar.OnChange := nil;
        m_VScrollBar.LineButton := 0;
        m_VScrollBar.Max := 100;
        m_VScrollBar.Enabled := true;
    end;

    m_VScrollBar := Value;
    if m_VScrollBar = nil then
        Exit;
    m_VScrollBar.Orientation := suiVertical;
    m_VScrollBar.OnChange := OnVScrollBArChange;
    m_VScrollBar.BringToFront();

    UpdateScrollBarsPos();
end;

procedure TsuiDirectoryListBox.UpdateScrollBars;
var
    info : tagScrollInfo;
    barinfo : tagScrollBarInfo;
    R : Boolean;
begin
    m_SelfChanging := true;
    if m_VScrollBar <> nil then
    begin
        barinfo.cbSize := SizeOf(barinfo);
        R := SUIGetScrollBarInfo(Handle, Integer(OBJID_VSCROLL), barinfo);
        if (barinfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) or
           (barinfo.rgstate[0] = STATE_SYSTEM_UNAVAILABLE) or
           (not R) then
        begin
            m_VScrollBar.LineButton := 0;
            m_VScrollBar.Enabled := false;
            m_VScrollBar.Visible := false;
        end
        else if not Enabled then
            m_VScrollBar.Enabled := false
        else
        begin
            m_VScrollBar.LineButton := abs(barinfo.xyThumbBottom - barinfo.xyThumbTop);
            m_VScrollBar.Enabled := true;
            m_VScrollBar.Visible := true;
        end;
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_VERT, info);
        m_VScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_VScrollBar.Min := info.nMin;
        m_VScrollBar.Position := info.nPos;
    end;
    m_SelfChanging := false;
end;

procedure TsuiDirectoryListBox.UpdateScrollBarsPos;
var
    L2R : Boolean;
begin
    if m_VScrollBar <> nil then
    begin
        if m_VScrollBar.Width > Width then
            m_VScrollBar.Left := Left
        else
        begin
            L2R := ((BidiMode = bdLeftToRight) or (BidiMode = bdRightToLeftReadingOnly)) or (not SysLocale.MiddleEast);
            if L2R then
                m_VScrollBar.Left := Left + Width - m_VScrollBar.Width - 2
            else
                m_VScrollBar.Left := Left + 2;
        end;
        m_VScrollBar.Top := Top + 1;
        m_VScrollBar.Height := Height - 2;
    end;

    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.WMDELETEITEM(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiDirectoryListBox.WMHSCROLL(var Message: TWMHScroll);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.WMKeyDown(var Message: TWMKeyDown);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.WMLBUTTONDOWN(var Message: TMessage);
begin
    inherited;
    m_MouseDown := true;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.WMLButtonUp(var Message: TMessage);
begin
    inherited;
    m_MouseDown := false;
end;

procedure TsuiDirectoryListBox.WMMOUSEMOVE(var Message: TMessage);
begin
    inherited;
    if m_MouseDown then UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.WMMOUSEWHEEL(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDirectoryListBox.WMMOVE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDirectoryListBox.WMPAINT(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, COlor);
end;

procedure TsuiDirectoryListBox.WMSIZE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDirectoryListBox.WMVSCROLL(var Message: TWMVScroll);
begin
    inherited;
    UpdateScrollBars();
end;

{ TsuiFileListBox }

procedure TsuiFileListBox.CMEnabledChanged(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.CMVisibleChanged(var Msg: TMEssage);
begin
    inherited;
    if not Visible then
    begin
        if m_VScrollBar <> nil then
            m_VScrollBar.Visible := Visible;
    end
    else
        UpdateScrollBarsPos();
end;

constructor TsuiFileListBox.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle + [csOpaque];
    BorderStyle := bsNone;
    BorderWidth := 2;
    m_SelfChanging := false;
    m_MouseDown := false;

    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiFileListBox.LBADDSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.LBDELETESTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.LBINSERTSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.LBNSELCHANGE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.LBNSETFOCUS(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.LBSETCOUNT(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.Loaded;
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiFileListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if AComponent = nil then
        Exit;

    if (
        (Operation = opRemove) and
        (AComponent = m_VScrollBar)
    )then
    begin
        m_VScrollBar := nil;
    end;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);          
    end;
end;

procedure TsuiFileListBox.OnVScrollBarChange(Sender: TObject);
begin
    if m_SelfChanging then
        Exit;
    SendMessage(Handle, WM_VSCROLL, MakeWParam(SB_THUMBPOSITION, m_VScrollBar.Position), 0);
    Invalidate;
end;

procedure TsuiFileListBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiFileListBox.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    if m_VScrollBar <> nil then
        m_VScrollBar.FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiFileListBox.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;

    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR)
    else
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);

    if m_VScrollBar <> nil then
        m_VScrollBar.UIStyle := OutUIStyle;
    Repaint();
end;

procedure TsuiFileListBox.SetVScrollBar(const Value: TsuiScrollBar);
begin
    if m_VScrollBar = Value then
        Exit;
    if m_VScrollBar <> nil then
    begin
        m_VScrollBar.OnChange := nil;
        m_VScrollBar.LineButton := 0;
        m_VScrollBar.Max := 100;
        m_VScrollBar.Enabled := true;
    end;

    m_VScrollBar := Value;
    if m_VScrollBar = nil then
        Exit;
    m_VScrollBar.Orientation := suiVertical;
    m_VScrollBar.OnChange := OnVScrollBArChange;
    m_VScrollBar.BringToFront();

    UpdateScrollBarsPos();
end;

procedure TsuiFileListBox.UpdateScrollBars;
var
    info : tagScrollInfo;
    barinfo : tagScrollBarInfo;
    R : Boolean;
begin
    m_SelfChanging := true;
    if m_VScrollBar <> nil then
    begin
        barinfo.cbSize := SizeOf(barinfo);
        R := SUIGetScrollBarInfo(Handle, Integer(OBJID_VSCROLL), barinfo);
        if (barinfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) or
           (barinfo.rgstate[0] = STATE_SYSTEM_UNAVAILABLE) or
           (not R) then
        begin
            m_VScrollBar.LineButton := 0;
            m_VScrollBar.Enabled := false;
            m_VScrollBar.Visible := false;
        end
        else if not Enabled then
            m_VScrollBar.Enabled := false
        else
        begin
            m_VScrollBar.LineButton := abs(barinfo.xyThumbBottom - barinfo.xyThumbTop);
            m_VScrollBar.Enabled := true;
            m_VScrollBar.Visible := true;
        end;
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_VERT, info);
        m_VScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_VScrollBar.Min := info.nMin;
        m_VScrollBar.Position := info.nPos;
    end;
    m_SelfChanging := false;
end;

procedure TsuiFileListBox.UpdateScrollBarsPos;
var
    L2R : Boolean;
begin
    if m_VScrollBar <> nil then
    begin
        if m_VScrollBar.Width > Width then
            m_VScrollBar.Left := Left
        else
        begin
            L2R := ((BidiMode = bdLeftToRight) or (BidiMode = bdRightToLeftReadingOnly)) or (not SysLocale.MiddleEast);
            if L2R then
                m_VScrollBar.Left := Left + Width - m_VScrollBar.Width - 2
            else
                m_VScrollBar.Left := Left + 2;
        end;
        m_VScrollBar.Top := Top + 1;
        m_VScrollBar.Height := Height - 2;
    end;

    UpdateScrollBars();
end;

procedure TsuiFileListBox.WMDELETEITEM(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, COlor);
end;

procedure TsuiFileListBox.WMHSCROLL(var Message: TWMHScroll);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.WMKeyDown(var Message: TWMKeyDown);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.WMLBUTTONDOWN(var Message: TMessage);
begin
    inherited;
    m_MouseDown := true;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.WMLButtonUp(var Message: TMessage);
begin
    inherited;
    m_MouseDown := false;
end;

procedure TsuiFileListBox.WMMOUSEMOVE(var Message: TMessage);
begin
    inherited;
    if m_MouseDown then UpdateScrollBars();
end;

procedure TsuiFileListBox.WMMOUSEWHEEL(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiFileListBox.WMMOVE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiFileListBox.WMPAINT(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, COlor);
end;

procedure TsuiFileListBox.WMSIZE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiFileListBox.WMVSCROLL(var Message: TWMVScroll);
begin
    inherited;
    UpdateScrollBars();
end;

end.

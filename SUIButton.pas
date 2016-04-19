////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIButton.pas
//  Creator     :   Shen Min
//  Date        :   2002-05-30 V1-V3
//                  2003-06-14 V4
//                  2006-06-14 V6
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIButton;

interface

{$I SUIPack.inc}

uses Windows, Messages, Classes, Controls, ExtCtrls, Graphics, Buttons,
     StdCtrls, Math, ComCtrls, SysUtils, Forms, ActnList, 
     SUIImagePanel, SUIThemes, SUIMgr, SUI2Define;

const
    SUIPACK_MSG_CANPROCESSKEY   = WM_APP + 3000;

type
    TsuiCustomButton = class(TCustomControl)
    private
        m_AutoSize : Boolean;
        m_Caption : TCaption;
        m_Cancel : Boolean;
        m_Default : Boolean;
        m_Transparent : Boolean;
        m_ModalResult : TModalResult;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;
        m_BoldFont : Boolean;
        m_PicTransparent: Boolean;
        m_Timer : TTimer;
        m_MouseContinuouslyDownInterval : Integer;
        m_FocusedRectMargin : Integer;
        m_Active : Boolean;

        m_OnMouseEnter : TNotifyEvent;
        m_OnMouseExit : TNotifyEvent;
        m_OnMouseContinuouslyDown : TNotifyEvent;

        procedure MouseLeave(var Msg : TMessage); message CM_MOUSELEAVE;
        procedure CancelMode(var Msg : TMessage); message CM_CANCELMODE;
        procedure MouseEnter(var Msg : TMessage); message CM_MOUSEENTER;
        procedure CMFONTCHANGED(var Msg : TMessage); message CM_FONTCHANGED;
        procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
        procedure WMERASEBKGND(var Msg : TMessage); message WM_ERASEBKGND;
        procedure CMDialogChar (var Msg : TCMDialogChar); message CM_DIALOGCHAR;
        procedure WMKeyDown (var Msg : TWMKeyDown); message WM_KEYDOWN;
        procedure WMKeyUp (var Msg : TWMKeyUp); message WM_KEYUP;
        procedure WMKillFocus (var Msg : TWMKillFocus); message WM_KILLFOCUS;
        procedure WMSetFocus (var Msg: TWMSetFocus); message WM_SETFOCUS;
        procedure CMFocusChanged(var Msg: TCMFocusChanged); message CM_FOCUSCHANGED;
        procedure CMTextChanged(var Msg : TMessage); message CM_TEXTCHANGED;
        procedure SUIPACKMSGCANPROCESSKEY(var Msg : TMessage); message SUIPACK_MSG_CANPROCESSKEY;

        procedure OnTimer(Sender : TObject);

        procedure SetAutoSize2(const Value: Boolean);
        procedure SetCaption2(const Value : TCaption);
        procedure SetDefault(const Value: Boolean);
        procedure SetUIStyle(const Value : TsuiUIStyle);
        procedure SetPicTransparent(const Value: Boolean);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetTransparent(const Value: Boolean);
        function GetTabStop() : Boolean;
        procedure SetTabStop(Value : Boolean);
        procedure SetFocusedRectMargin(const Value: Integer);

    protected
        m_MouseIn : Boolean;
        m_MouseDown : Boolean;

        procedure AutoSizeChanged(); virtual;
        procedure CaptionChanged(); virtual;
        procedure FontChanged(); virtual;
        procedure TransparentChanged(); virtual;
        procedure EnableChanged(); virtual;
        procedure UIStyleChanged(); virtual;

        procedure PaintPic(ACanvas : TCanvas; Bitmap : TBitmap); virtual;
        procedure PaintText(ACanvas : TCanvas; Text : String); virtual;
        procedure PaintFocus(ACanvas : TCanvas); virtual;

        procedure PaintButtonNormal(Buf : TBitmap); virtual;
        procedure PaintButtonMouseOn(Buf : TBitmap); virtual;
        procedure PaintButtonMouseDown(Buf : TBitmap); virtual;
        procedure PaintButtonDisabled(Buf : TBitmap); virtual;

        procedure PaintButton(ThemeIndex, Count, Index : Integer; const Buf : TBitmap);

        procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
        procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
        procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
        procedure SetEnabled(Value : Boolean); override;
        procedure Paint(); override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure CreateWnd; override;

        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property Transparent : Boolean read m_Transparent write SetTransparent;
        property ModalResult : TModalResult read m_ModalResult write m_ModalResult;
        property PicTransparent : Boolean read m_PicTransparent write SetPicTransparent;
        property FocusedRectMargin : Integer read m_FocusedRectMargin write SetFocusedRectMargin;

    public
        constructor Create(AOwner : TComponent); override;
        procedure Click(); override;

        property MouseContinuouslyDownInterval : Integer read m_MouseContinuouslyDownInterval write m_MouseContinuouslyDownInterval;
        property Cancel : Boolean read m_Cancel write m_Cancel default false;
        property Default : Boolean read m_Default write SetDefault default false;

        property OnMouseEnter : TNotifyEvent read m_OnMouseEnter write m_OnMouseEnter;
        property OnMouseExit : TNotifyEvent read m_OnMouseExit write m_OnMouseExit;
        property OnMouseContinuouslyDown : TNotifyEvent read m_OnMouseContinuouslyDown write m_OnMouseContinuouslyDown;

    published
        property BiDiMode;
        property Anchors;
        property ParentColor;
        property Font;
        property PopupMenu;
        property ShowHint;
        property Caption : TCaption read m_Caption write SetCaption2 stored true;
        property AutoSize : Boolean read m_AutoSize write SetAutoSize2;
        property Visible;
        property ParentShowHint;
        property ParentBiDiMode;
        property ParentFont;
        property TabStop read GetTabStop write SetTabStop default True;

        property OnEnter;
        property OnExit;
    end;

    TsuiImageButton = class(TsuiCustomButton)
    private
        m_PicNormal : TPicture;
        m_PicMouseOn : TPicture;
        m_PicMouseDown : TPicture;
        m_PicDisabled : TPicture;
        m_Stretch: Boolean;
        m_DrawFocused : Boolean;

        procedure SetPicDisabledF(const Value: TPicture);
        procedure SetPicMouseDownF(const Value: TPicture);
        procedure SetPicMouseOnF(const Value: TPicture);
        procedure SetPicNormalF(const Value: TPicture);
        procedure SetStretch(const Value: Boolean);
        procedure SetDrawFocused(const Value: Boolean);
        function GetUIStyle2() : TsuiUIStyle;

    protected
        procedure AutoSizeChanged(); override;

        procedure PaintButtonNormal(Buf : TBitmap); override;
        procedure PaintButtonMouseOn(Buf : TBitmap); override;
        procedure PaintButtonMouseDown(Buf : TBitmap); override;
        procedure PaintButtonDisabled(Buf : TBitmap); override;
        procedure PaintFocus(ACanvas : TCanvas); override;

        procedure PaintPic(ACanvas : TCanvas; Bitmap : TBitmap); override;

    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy(); override;

    published
        property UIStyle read GetUIStyle2;
        property DrawFocused : Boolean read m_DrawFocused write SetDrawFocused;
        property FocusedRectMargin;
        property PicNormal : TPicture read m_PicNormal write SetPicNormalF;
        property PicMouseOn : TPicture read m_PicMouseOn write SetPicMouseOnF;
        property PicMouseDown : TPicture read m_PicMouseDown write SetPicMouseDownF;
        property PicDisabled : TPicture read m_PicDisabled write SetPicDisabledF;
        property Stretch : Boolean read m_Stretch write SetStretch;
        property Cancel;
        property Default;

        property MouseContinuouslyDownInterval;
        property Action;
        property Caption;
        property Font;
        property Enabled;
        property TabOrder;
        property Transparent;
        property ModalResult;
        property AutoSize;

        property OnClick;
        property OnMouseMove;
        property OnMouseDown;
        property OnMouseUp;
        property OnKeyDown;
        property OnKeyUp;
        property OnKeyPress;
        property OnMouseEnter;
        property OnMouseExit;
        property OnMouseContinuouslyDown;
    end;

    TsuiControlButton = class(TsuiCustomButton)
    private
        m_PicIndex : Integer;
        m_PicCount : Integer;
        m_ThemeID : Integer;

        procedure SetThemeID(const Value: Integer);
        procedure SetPicIndex(const Value: Integer);
        procedure SetPicCount(const Value: Integer);
        procedure WMERASEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

    protected
        procedure PaintButtonNormal(Buf : TBitmap); override;
        procedure PaintButtonMouseOn(Buf : TBitmap); override;
        procedure PaintButtonMouseDown(Buf : TBitmap); override;
        procedure PaintButtonDisabled(Buf : TBitmap); override;

        procedure PaintPic(ACanvas : TCanvas; Bitmap : TBitmap); override;

    public
        constructor Create(AOwner : TComponent); override;

    published
        property UIStyle;
        property FileTheme;
        property ThemeID : Integer read m_ThemeID write SetThemeID;
        property PicIndex : Integer read m_PicIndex write SetPicIndex;
        property PicCount : Integer read m_PicCount write SetPicCount;
        property PicTransparent;

        property MouseContinuouslyDownInterval;
        property Action;
        property Caption;
        property Font;
        property Enabled;
        property TabOrder;
        property Transparent;
        property ModalResult;
        property AutoSize;

        property OnClick;
        property OnMouseMove;
        property OnMouseDown;
        property OnMouseUp;
        property OnKeyDown;
        property OnKeyUp;
        property OnKeyPress;
        property OnMouseEnter;
        property OnMouseExit;
        property OnMouseContinuouslyDown;
    end;

    TsuiToolBarSpeedButton = class(TCustomPanel)
    private
        m_MouseIn : Boolean;
        m_Glyph : TBitmap;
        m_ToColor : TColor;        
        
        procedure MouseLeave(var Msg : TMessage); message CM_MOUSELEAVE;
        procedure MouseEnter(var Msg : TMessage); message CM_MOUSEENTER;
        procedure SetGlyph(const Value: TBitmap);
        procedure WMERASEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

    protected
        procedure Paint(); override;

    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy(); override;    

    published
        property Glyph : TBitmap read m_Glyph write SetGlyph;
        property Color;
        property ToColor : TColor read m_ToColor write m_ToColor;        
        property OnClick;
    end;

    TsuiButton = class(TsuiCustomButton)
    private
        m_Glyph : TBitmap;
        m_Layout : TButtonLayout;
        m_TextPoint : TPoint;
        m_Spacing : Integer;

        procedure SetGlyph(const Value: TBitmap);
        procedure SetLayout(const Value: TButtonLayout);
        procedure SetSpacing(const Value: Integer);
        function GetResHandle: Cardinal;
        procedure SetResHandle(const Value: THandle);        

    protected
        procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;

        procedure PaintPic(ACanvas : TCanvas; Bitmap : TBitmap); override;
        procedure PaintText(ACanvas : TCanvas; Text : String); override;
        procedure PaintFocus(ACanvas : TCanvas); override;

        procedure UIStyleChanged(); override;

    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy(); override;

    published
        property FileTheme;
        property UIStyle;
        property Cancel;
        property Default;
        property Action;
        property Caption;
        property Font;
        property Enabled;
        property TabOrder;
        property Transparent;
        property ModalResult;
        property AutoSize;
        property FocusedRectMargin;
        property Glyph : TBitmap read m_Glyph write SetGlyph;
        property Layout : TButtonLayout read m_Layout write SetLayout;
        property Spacing : Integer read m_Spacing write SetSpacing;
        property MouseContinuouslyDownInterval;

        property OnClick;
        property OnMouseMove;
        property OnMouseDown;
        property OnMouseUp;
        property OnKeyDown;
        property OnKeyUp;
        property OnKeyPress;
        property OnMouseEnter;
        property OnMouseExit;
        property OnMouseContinuouslyDown;

        // no use, keep for compatible with V3
        property ResHandle : Cardinal read GetResHandle write SetResHandle;
    end;

    // -------------- TsuiCheckBox (Button for CheckBox)-----------
    TsuiCheckBox = class(TCustomControl)
    private
        m_Checked : Boolean;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;
        m_Transparent : Boolean;
        m_AutoSize : Boolean;
        m_OnClick : TNotifyEvent;

        function GetState: TCheckBoxState;
        procedure SetState(const Value: TCheckBoxState);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure SetChecked(const Value: Boolean);
        procedure SetTransparent(const Value: Boolean);
        procedure SetAutoSize2(const Value: Boolean);
        function GetTabStop() : Boolean;
        procedure SetTabStop(Value : Boolean);

        procedure CMFONTCHANGED(var Msg : TMessage); message CM_FONTCHANGED;
        procedure WMERASEBKGND(var Msg : TMessage); message WM_ERASEBKGND;
        procedure CMDialogChar (var Msg : TCMDialogChar); message CM_DIALOGCHAR;
        procedure WMKillFocus (var Msg : TWMKillFocus); message WM_KILLFOCUS;
        procedure WMSetFocus (var Msg: TWMSetFocus); message WM_SETFOCUS;
        procedure CMFocusChanged(var Msg: TCMFocusChanged); message CM_FOCUSCHANGED;
        procedure WMKeyUp (var Msg : TWMKeyUp); message WM_KEYUP;
        procedure CMTextChanged(var Msg : TMessage); message CM_TEXTCHANGED;

    protected
        procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
        function NeedDrawFocus() : Boolean; virtual;
        procedure Paint(); override;
        function GetPicTransparent() : Boolean; virtual;
        function GetPicThemeIndex() : Integer; virtual;
        function GetPicThemeIndexOuter() : Tsk2SkinBitmapElement; virtual;

        procedure CheckStateChanged(); virtual;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        
        procedure Toggle; virtual;
        procedure DoClick(); virtual;
        function WantKeyUp() : Boolean; virtual;
        procedure SetEnabled(Value : Boolean); override;

    public
        constructor Create(AOwner : TComponent); override;
        procedure Click(); override;

    published
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;

        property BiDiMode;
        property Anchors;
        property PopupMenu;
        property ShowHint;
        property Visible;
        property ParentShowHint;
        property ParentBiDiMode;
        property ParentFont;
        property AutoSize : Boolean read m_AutoSize write SetAutoSize2;
        property Checked : Boolean read m_Checked write SetChecked;
        property Caption;
        property Enabled;
        property Font;
        property Color;
        property TabStop read GetTabStop write SetTabStop default True;
        property TabOrder;
        property ParentColor;
  
        property State : TCheckBoxState read GetState write SetState;
        property Transparent : Boolean read m_Transparent write SetTransparent;

        property OnClick read m_OnClick write m_OnClick;
        property OnDblClick;
        property OnMouseMove;
        property OnMouseDown;
        property OnMouseUp;
        property OnKeyDown;
        property OnKeyUp;
        property OnKeyPress;        
        property OnContextPopup;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDock;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
        property OnStartDock;
        property OnStartDrag;

    end;


    // -------------- TsuiRadioButton (Button for RadioButton)-----------
    TsuiRadioButton = class(TsuiCheckBox)
    private
        m_GroupIndex : Integer;

        procedure UnCheckGroup();
        procedure WMSetFocus (var Msg: TWMSetFocus); message WM_SETFOCUS;

    protected
        function WantKeyUp() : Boolean; override;
        procedure DoClick(); override;
        function GetPicTransparent() : Boolean; override;
        function GetPicThemeIndex() : Integer; override;
        function GetPicThemeIndexOuter() : Tsk2SkinBitmapElement; override;
        procedure CheckStateChanged(); override;

    public
        constructor Create(AOwner : TComponent); override;

    published
        property GroupIndex : Integer read m_GroupIndex write m_GroupIndex;

    end;

    TsuiArrowButtonType = (suiUp, suiDown);
    
    TsuiArrowButton = class(TsuiCustomButton)
    private
        m_Arrow: TsuiArrowButtonType;
        procedure SetArrow(const Value: TsuiArrowButtonType);

    protected
        procedure UIStyleChanged(); override;
        procedure PaintPic(ACanvas : TCanvas; Bitmap : TBitmap); override;
        procedure PaintText(ACanvas : TCanvas; Text : String); override;

    published
        property Arrow: TsuiArrowButtonType read m_Arrow write SetArrow;
        property FileTheme;
        property UIStyle;
        property MouseContinuouslyDownInterval;

        property OnClick;
        property OnMouseMove;
        property OnMouseDown;
        property OnMouseUp;
        property OnKeyDown;
        property OnKeyUp;
        property OnKeyPress;
        property OnMouseEnter;
        property OnMouseExit;
        property OnMouseContinuouslyDown;
    end;


implementation

uses SUIResDef, SUIToolBar, SUIPublic{$IFDEF DB}, SUIDBCtrls{$ENDIF};

{ TsuiCustomButton }

constructor TsuiCustomButton.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle - [csDoubleClicks];
    ControlStyle := ControlStyle - [csAcceptsControls];

    m_Timer := nil;
    m_MouseContinuouslyDownInterval := 100;
    m_BoldFont := false;

    inherited OnClick := nil;
    inherited Caption := '';

    m_MouseIn := false;
    m_MouseDown := false;

    ModalResult := mrNone;
    TabStop := true;
    m_AutoSize := false;
    m_FocusedRectMargin := 2;

    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiCustomButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    if Button = mbLeft then
    begin
        m_MouseDown := true;
        if m_Timer = nil then
        begin
            m_Timer := TTimer.Create(nil);
            m_Timer.OnTimer := OnTimer;
            m_Timer.Interval := Max(m_MouseContinuouslyDownInterval, 0);
            m_Timer.Enabled := true;
        end;

        if TabStop and CanFocus() and Enabled and Visible then
        try
            SetFocus();
        except end;

        Repaint();
    end;

    inherited;
end;

procedure TsuiCustomButton.MouseEnter(var Msg: TMessage);
begin
    inherited;

    if csDesigning in ComponentState then
        Exit;

    m_MouseIn := true;
    Repaint();

    if Assigned(m_OnMouseEnter) then
        m_OnMouseEnter(self);
end;

procedure TsuiCustomButton.MouseLeave(var Msg: TMessage);
begin
    inherited;

    m_MouseIn := false;
    m_MouseDown := false;
    if m_Timer <> nil then
    begin
        m_Timer.Free();
        m_Timer := nil;
    end;

    Repaint();

    if Assigned(m_OnMouseExit) then
        m_OnMouseExit(self);
end;

procedure TsuiCustomButton.Paint;
var
    Buf : TBitmap;
    BufImage : TBitmap;
begin
    Buf := TBitmap.Create();
    BufImage := TBitmap.Create();

    try
        if not Enabled then
            PaintButtonDisabled(BufImage)
        else if m_MouseDown then
            PaintButtonMouseDown(BufImage)
        else if not m_MouseIn then
            PaintButtonNormal(BufImage)
        else
            PaintButtonMouseOn(BufImage);
    except
        BufImage.Width := 74;
        BufImage.Height := 21;
    end;
    BufImage.Transparent := m_PicTransparent;

    Buf.PixelFormat := pfDevice;
    Buf.Width := Width;
    Buf.Height := Height;

    if m_Transparent then
    begin
        if Parent <> nil then
        begin
            if Parent is TTabSheet then
                DoTrans(Buf.Canvas, Parent)
{$IFDEF DB}
            else if Parent is TsuiDBNavigator then
                DoTrans(Buf.Canvas, Parent)
{$ENDIF}                
            else if (Parent is TsuiToolBar) then
                DoTrans(Buf.Canvas, Parent)
            else
                DoTrans(Buf.Canvas, self);
        end
        else
            DoTrans(Buf.Canvas, self);
    end
    else
    begin
        Buf.Canvas.Brush.Color := Color;
        Buf.Canvas.FillRect(ClientRect);
    end;

    PaintPic(Buf.Canvas, BufImage);

    BufImage.Free();

    if Focused and TabStop then
        PaintFocus(Buf.Canvas);

    Buf.Canvas.Font := Font;
    Canvas.Font := Font;
    if Trim(m_Caption) <> '' then
        PaintText(Buf.Canvas, m_Caption);

    Canvas.CopyRect(ClientRect, Buf.Canvas, ClientRect);

    Buf.Free();
end;

procedure TsuiCustomButton.SetAutoSize2(const Value: Boolean);
begin
    m_AutoSize := Value;
    AutoSizeChanged();
    RePaint();
end;

procedure TsuiCustomButton.CMDialogChar(var Msg: TCMDialogChar);
begin
    inherited;

    if IsAccel(Msg.CharCode, m_Caption) and
        ((ssAlt in KeyDataToShiftState(Msg.KeyData)) or (SendMessage(GetFocus(), SUIPACK_MSG_CANPROCESSKEY, 0, 0) = 1)) then
    begin
        if ((Parent <> nil) and (Parent.Enabled)) and Enabled and Visible then
        begin
            Click();
            Msg.Result := 1;
        end
        else
            Msg.Result := 0;
    end
    else
        Msg.Result := 0;
end;

procedure TsuiCustomButton.WMKeyDown(var Msg: TWMKeyDown);
begin
    inherited;

    if (
        ((Msg.CharCode = VK_SPACE) or (Msg.CharCode = VK_RETURN)) and
        Focused
    ) then
    begin
        if Enabled then
        begin
            m_MouseDown := true;
            Repaint();
        end;
    end;
end;

procedure TsuiCustomButton.WMKeyUp(var Msg: TWMKeyUp);
begin
    inherited;

    if (
        ((Msg.CharCode = VK_SPACE) or (Msg.CharCode = VK_RETURN)) and
        Focused and
        (m_MouseDown)
    ) then
    begin
        if Enabled then
        begin
            m_MouseDown := false;
            Repaint();
            Click();
        end;
    end;
end;

procedure TsuiCustomButton.WMKillFocus(var Msg: TWMKillFocus);
begin
    inherited;

    Repaint();
end;

procedure TsuiCustomButton.WMSetFocus(var Msg: TWMSetFocus);
begin
    inherited;

    Repaint();
end;

procedure TsuiCustomButton.SetCaption2(const Value: TCaption);
begin
    m_Caption := Value;
    inherited Caption := Value;

    CaptionChanged();
    Repaint();
end;

procedure TsuiCustomButton.SetEnabled(Value: Boolean);
begin
    inherited;

    EnableChanged();
    Repaint();
end;

procedure TsuiCustomButton.Click;
begin
    if m_MouseDown then
    begin
        if m_Timer <> nil then
        begin
            m_Timer.Free();
            m_Timer := nil;
        end;

        m_MouseDown := false;
        Repaint();
    end;

    if Parent <> nil then
        GetParentForm(self).ModalResult := m_ModalResult;
    inherited;
end;

procedure TsuiCustomButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
    inherited;

    if (
        (X < 0) or
        (Y < 0) or
        (X > Width) or
        (Y > Height)
    ) then
    begin
        m_MouseIn := false;
        m_MouseDown := false;
        Repaint();
    end;
end;

procedure TsuiCustomButton.SetTransparent(const Value: Boolean);
begin
    inherited;

    m_Transparent := Value;
    TransparentChanged();
    Repaint();
end;

procedure TsuiCustomButton.WMERASEBKGND(var Msg: TMessage);
begin
    // do nothing
end;

procedure TsuiCustomButton.CMFocusChanged(var Msg: TCMFocusChanged);
begin
    Inherited;
    with Msg do
    if Sender is TsuiButton then
      m_Active := Sender = Self
    else
      m_Active := m_Default;
    Repaint();
end;

procedure TsuiCustomButton.PaintPic(ACanvas: TCanvas; Bitmap: TBitmap);
var
    ImageList : TImageList;
    TransColor : TColor;
begin
    if (Bitmap.Width = 0) or (Bitmap.Height = 0) then
        Exit;

    TransColor := Bitmap.Canvas.Pixels[0, 0];

    ImageList := TImageList.CreateSize(Bitmap.Width, Bitmap.Height);
    try
        if PicTransparent then
            ImageList.AddMasked(Bitmap, TransColor)
        else
            ImageList.Add(Bitmap, nil);
        ImageList.Draw(ACanvas, 0, 0, 0, Enabled);
    finally
        ImageList.Free();
    end;
end;

procedure TsuiCustomButton.SetUIStyle(const Value: TsuiUIStyle);
begin
    m_UIStyle := Value;
    UIStyleChanged();
    Repaint();
end;

procedure TsuiCustomButton.PaintText(ACanvas: TCanvas; Text: String);
var
    R, RText : TRect;
    DespX, DespY : integer;
begin
    ACanvas.Brush.Style := bsClear;
    R := ClientRect;
    ACanvas.Font := Font;
    if m_BoldFont then
        ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];

    if not Enabled then
    begin
        R := Rect(R.Left + 1, R.Top + 1, R.Right + 1, R.Bottom + 1);
        ACanvas.Font.Color := clWhite;
//        DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_CENTER or DT_SINGLELINE or DT_VCENTER);
        RText := R;
        DrawText(ACanvas.Handle, PChar(Caption),Length(Caption), RText, DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK);
        DespX := ((R.Right - R.Left) - (RText.Right - RText.Left)) div 2;
        DespY := ((R.Bottom - R.Top) - (RText.Bottom - RText.Top)) div 2;
        OffsetRect(RText,DespX, DespY);
        DrawText(ACanvas.Handle, PChar(Caption), -1, RText, DT_EXPANDTABS or DT_WORDBREAK);
        
        R := ClientRect;
        ACanvas.Font.Color := clGray;
    end
    else
    begin
        if m_MouseDown then
            R := Rect(R.Left + 1, R.Top + 1, R.Right + 1, R.Bottom + 1);
    end;
//    DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_CENTER or DT_SINGLELINE or DT_VCENTER);
    RText := R;
    DrawText(ACanvas.Handle, PChar(Caption),Length(Caption), RText, DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK);
    DespX := ((R.Right - R.Left) - (RText.Right - RText.Left)) div 2;
    DespY := ((R.Bottom - R.Top) - (RText.Bottom - RText.Top)) div 2;
    OffsetRect(RText,DespX, DespY);
    DrawText(ACanvas.Handle, PChar(Caption),-1, RText, DT_EXPANDTABS or DT_WORDBREAK);

    m_BoldFont := false;
end;

procedure TsuiCustomButton.UIStyleChanged;
begin

end;

procedure TsuiCustomButton.AutoSizeChanged;
var
    Temp : TBitmap;
begin
    if m_AutoSize then
    begin
        Temp := TBitmap.Create();
        GetInsideThemeBitmap(m_UIStyle, SUI_THEME_BUTTON_IMAGE, Temp);
        if Temp.Height = 0 then
            Temp.Height := 21;
        if Temp.Width = 0 then
            Temp.Width := 74;
        Height := Temp.Height;
        Width := Temp.Width div 3;
        Temp.Free();
    end;
end;

procedure TsuiCustomButton.CaptionChanged;
begin
    // do nothing
end;

procedure TsuiCustomButton.CMFONTCHANGED(var Msg: TMessage);
begin
    FontChanged();
end;

procedure TsuiCustomButton.FontChanged;
begin
    Canvas.Font := Font;
    Repaint();
end;

procedure TsuiCustomButton.SetPicTransparent(const Value: Boolean);
begin
    m_PicTransparent := Value;
    Repaint();
end;

procedure TsuiCustomButton.TransparentChanged;
begin
    PicTransparent := Transparent;
end;

procedure TsuiCustomButton.PaintFocus(ACanvas: TCanvas);
var
    R : TRect;
begin
    R := Rect(m_FocusedRectMargin, m_FocusedRectMargin, ClientWidth - m_FocusedRectMargin, ClientHeight - m_FocusedRectMargin);
    ACanvas.Brush.Style := bsSolid;
    ACanvas.DrawFocusRect(R);
end;

procedure TsuiCustomButton.EnableChanged;
begin
    // Do nothing
end;

procedure TsuiCustomButton.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
    inherited;

    Caption := inherited Caption;
end;

procedure TsuiCustomButton.PaintButtonDisabled(Buf: TBitmap);
begin
    PaintButton(SUI_THEME_BUTTON_IMAGE, 3, 1, Buf);
end;

procedure TsuiCustomButton.PaintButtonMouseDown(Buf: TBitmap);
begin
    PaintButton(SUI_THEME_BUTTON_IMAGE, 3, 3, Buf);
end;

procedure TsuiCustomButton.PaintButtonMouseOn(Buf: TBitmap);
begin
    PaintButton(SUI_THEME_BUTTON_IMAGE, 3, 2, Buf);
end;

procedure TsuiCustomButton.PaintButtonNormal(Buf: TBitmap);
begin
    PaintButton(SUI_THEME_BUTTON_IMAGE, 3, 1, Buf);
end;

procedure TsuiCustomButton.OnTimer(Sender: TObject);
begin
    if Assigned(m_OnMouseContinuouslyDown) then
        m_OnMouseContinuouslyDown(self);
end;

procedure TsuiCustomButton.SetDefault(const Value: Boolean);
var
    Form: TCustomForm;
begin
    m_Default := Value;
    if HandleAllocated then
    begin
        Form := GetParentForm(Self);
        if Form <> nil then
            Form.Perform(CM_FOCUSCHANGED, 0, Longint(Form.ActiveControl));
  end;
end;

procedure TsuiCustomButton.CMDialogKey(var Message: TCMDialogKey);
begin
    with Message do
    if  (((CharCode = VK_RETURN) and m_Active) or
      ((CharCode = VK_ESCAPE) and m_Cancel)) and
      (KeyDataToShiftState(Message.KeyData) = []) and CanFocus then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

function TsuiCustomButton.GetTabStop: Boolean;
begin
    Result := inherited TabStop;
end;

procedure TsuiCustomButton.SetTabStop(Value: Boolean);
begin
    inherited TabStop := Value;
end;

procedure TsuiCustomButton.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiCustomButton.Notification(AComponent: TComponent;
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

procedure TsuiCustomButton.PaintButton(ThemeIndex, Count, Index : Integer; const Buf : TBitmap);
var
    OutUIStyle : TsuiUIStyle;
begin
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_FileTheme.GetBitmap2(SKIN2_BUTTON, Buf, Count, Index)
    else
        GetInsideThemeBitmap(OutUIStyle, ThemeIndex, Buf, Count, Index);
end;


procedure TsuiCustomButton.CMTextChanged(var Msg: TMessage);
begin
    Caption := inherited Caption;
end;

procedure TsuiCustomButton.SetFocusedRectMargin(const Value: Integer);
begin
    m_FocusedRectMargin := Value;
    Repaint();
end;

procedure TsuiCustomButton.CreateWnd;
begin
    inherited;
    m_Active := m_Default;
end;

procedure TsuiCustomButton.CancelMode(var Msg: TMessage);
begin
    inherited;

    m_MouseIn := false;
    m_MouseDown := false;
    if m_Timer <> nil then
    begin
        m_Timer.Free();
        m_Timer := nil;
    end;

    Repaint();
end;

procedure TsuiCustomButton.SUIPACKMSGCANPROCESSKEY(var Msg: TMessage);
begin
    Msg.Result := 1;
end;

{ TsuiButton }

procedure TsuiButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
    inherited;

    if Sender is TCustomAction then
        with TCustomAction(Sender) do
        begin
            if (
                (Glyph.Empty) and
                (ActionList <> nil) and
                (ActionList.Images <> nil) and
                (ImageIndex >= 0) and
                (ImageIndex < ActionList.Images.Count)
            ) then
            begin
                ActionList.Images.GetBitmap(ImageIndex, m_Glyph);
                Repaint();
            end;
        end;
end;

constructor TsuiButton.Create(AOwner: TComponent);
begin
    inherited;

    Height := 27;
    Width := 80;
    m_Spacing := 4;
    m_Glyph := TBitmap.Create();
end;

destructor TsuiButton.Destroy;
begin
    m_Glyph.Free();
    m_Glyph := nil;

    inherited;
end;

function TsuiButton.GetResHandle: Cardinal;
begin
    Result := 0;
end;

procedure TsuiButton.PaintFocus(ACanvas: TCanvas);
begin
    if {$IFDEF RES_MACOS} (UIStyle = MacOS) {$ELSE} false {$ENDIF} or
        {$IFDEF RES_BLUEGLASS} (UIStyle = BlueGlass) {$ELSE} false {$ENDIF} then
    begin
        m_BoldFont := true;
        Exit;
    end;

    inherited
end;

procedure TsuiButton.PaintPic(ACanvas: TCanvas; Bitmap: TBitmap);
var
    CapWidth : Integer;
    CapHeight : Integer;
    GlyphLeft : Integer;
    GlyphTop : Integer;
    GlyphWidth : Integer;
    GlyphHeight : Integer;
    ImageList : TImageList;
    IncludedDisable : Boolean;
begin
    ACanvas.Font := Font;
    SpitDraw(Bitmap, ACanvas, ClientRect, PicTransparent);

    if m_Glyph.Empty then
        Exit;

    CapWidth := ACanvas.TextWidth(Caption);
    CapHeight := ACanvas.TextHeight(Caption);

    GlyphLeft := 0;
    GlyphTop := 0;
    GlyphWidth := m_Glyph.Width;
    GlyphHeight := m_Glyph.Height;
    IncludedDisable := false;

    if GlyphWidth = GlyphHeight * 2 then
    begin
        GlyphWidth := GlyphHeight;
        IncludedDisable := true;
    end;

    case m_Layout of

    blGlyphLeft :
    begin
        GlyphLeft := (Width - (CapWidth + GlyphWidth + m_Spacing)) div 2;
        GlyphTop := (Height - GlyphHeight) div 2;
        m_TextPoint := Point(GlyphLeft + GlyphWidth + m_Spacing, (Height - CapHeight) div 2);
    end;

    blGlyphRight :
    begin
        GlyphLeft := (Width + CapWidth + m_Spacing - GlyphWidth) div 2;
                  // (Width - (CapWidth + GlyphWidth + GLYPH_TEXT)) div 2 + CapWidth + GLYPH_TEXT;
        GlyphTop := (Height - GlyphHeight) div 2;
        m_TextPoint := Point(GlyphLeft - CapWidth - m_Spacing, (Height - CapHeight) div 2);
    end;

    blGlyphTop :
    begin
        GlyphLeft := (Width - GlyphWidth) div 2;
        GlyphTop := (Height - (CapHeight + GlyphHeight + m_Spacing)) div 2;
        m_TextPoint := Point((Width - CapWidth) div 2, GlyphTop + GlyphHeight + m_Spacing);
    end;

    blGlyphBottom :
    begin
        GlyphLeft := (Width - GlyphWidth) div 2;
        GlyphTop := (Height + CapHeight + m_Spacing - GlyphHeight) div 2;
        m_TextPoint := Point((Width - CapWidth) div 2, GlyphTop - CapHeight - m_Spacing);
    end;

    end; // case

    if m_MouseDown then
    begin
        Inc(GlyphLeft);
        Inc(GlyphTop);
    end;

    ImageList := TImageList.CreateSize(GlyphWidth, GlyphHeight);

    try
        ImageList.AddMasked(m_Glyph, m_Glyph.Canvas.Pixels[0, 0]);

        if not IncludedDisable then
            ImageList.Draw(ACanvas, GlyphLeft, GlyphTop, 0, Enabled)
        else
            ImageList.Draw(ACanvas, GlyphLeft, GlyphTop, Integer(not Enabled));
    finally
        ImageList.Free();
    end;
end;

procedure TsuiButton.PaintText(ACanvas: TCanvas; Text: String);
var
    R : TRect;
begin
    if m_Glyph.Empty then
    begin
        inherited;
        Exit;
    end;

    ACanvas.Brush.Style := bsClear;
    ACanvas.Font := Font;

    if not Enabled then
    begin
        ACanvas.Font.Color := clWhite;
        R := Rect(m_TextPoint.X + 1,  m_TextPoint.Y + 1, Width, Height);
        DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_TOP or DT_SINGLELINE);
        ACanvas.Font.Color := clGray;
    end
    else
    begin
        if m_MouseDown then
        begin
            Inc(m_TextPoint.X);
            Inc(m_TextPoint.Y);
        end;
    end;

    R := Rect(m_TextPoint.X, m_TextPoint.Y, Width, Height);
    DrawText(ACanvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_TOP or DT_SINGLELINE);
end;

procedure TsuiButton.SetGlyph(const Value: TBitmap);
begin
    m_Glyph.Assign(Value);
    Repaint();
end;

procedure TsuiButton.SetLayout(const Value: TButtonLayout);
begin
    m_Layout := Value;
    Repaint();
end;

procedure TsuiButton.SetResHandle(const Value: THandle);
begin
    // do nothing
end;

procedure TsuiButton.SetSpacing(const Value: Integer);
begin
    m_Spacing := Value;
    Repaint();
end;

procedure TsuiButton.UIStyleChanged;
var
    OutUIStyle : TsuiUIStyle;
begin
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        Transparent := m_FileTheme.GetBool(SKIN2_BUTTONTRANS);
        Font.Color := m_FileTheme.GetColor(SKIN2_BUTTONFONTCOLOR);
    end
    else
    begin
        Transparent := GetInsideThemeBool(OutUIStyle, SUI_THEME_BUTTON_TRANSPARENT_BOOL);
        Font.Color := clBlack;        
    end;
end;

{ TsuiCheckBox }

procedure TsuiCheckBox.CheckStateChanged;
begin
    if csLoading in ComponentState then
        Exit;
    if Assigned(OnClick) then
        OnClick(self);
end;

procedure TsuiCheckBox.Click;
begin
    DoClick();

    inherited;
end;

procedure TsuiCheckBox.CMDialogChar(var Msg: TCMDialogChar);
begin
    inherited;

    if IsAccel(Msg.CharCode, Caption) and Enabled and Visible and ((Parent <> nil) and (Parent.Enabled)) then
    begin
        if CanFocus() then
        try
            SetFocus();
        except end;
        Click();
        Msg.Result := 1;
    end
    else
        Msg.Result := 0;
end;

procedure TsuiCheckBox.CMFocusChanged(var Msg: TCMFocusChanged);
begin
    inherited;

    Repaint();
end;

procedure TsuiCheckBox.CMFONTCHANGED(var Msg: TMessage);
begin
    Repaint();
end;

procedure TsuiCheckBox.CMTextChanged(var Msg: TMessage);
begin
    Repaint();
end;

constructor TsuiCheckBox.Create(AOwner: TComponent);
begin
    inherited;

    Checked := false;
    m_Transparent := false;
    AutoSize := true;
    Height := 17;
    Width := 93;
    ControlStyle := ControlStyle - [csDoubleClicks];
    TabStop := true;

    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiCheckBox.DoClick;
begin
    Toggle();
    Checked := not Checked;
end;

function TsuiCheckBox.GetPicThemeIndex: Integer;
begin
    Result := SUI_THEME_CHECKBOX_IMAGE;
end;

function TsuiCheckBox.GetPicThemeIndexOuter: Tsk2SkinBitmapElement;
begin
    Result := SKIN2_CHECKBOX;
end;

function TsuiCheckBox.GetPicTransparent: Boolean;
begin
    Result := false;
end;

function TsuiCheckBox.GetState: TCheckBoxState;
begin
    if Checked then
        Result := cbChecked
    else
        Result := cbUnchecked
end;

function TsuiCheckBox.GetTabStop: Boolean;
begin
    Result := inherited TabStop;
end;

procedure TsuiCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
    inherited;

    if (Button = mbLeft) and CanFocus() and Enabled and Visible then
    try
        SetFocus();
    except end;
end;

function TsuiCheckBox.NeedDrawFocus: Boolean;
begin
    Result := TabStop and Focused and Enabled and Visible;
end;

procedure TsuiCheckBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if AComponent = nil then
        Exit;
    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);
    end;
end;

procedure TsuiCheckBox.Paint;
var
    Buf, Bmp : TBitmap;
    OutUIStyle : TsuiUIStyle;
    Index : Integer;
    R : TRect;
    X, Y : Integer;
    C : Integer;
begin
    Buf := TBitmap.Create();
    Bmp := TBitmap.Create();
    Bmp.Transparent := GetPicTransparent();

    if (GetPicThemeIndex() = SUI_THEME_CHECKBOX_IMAGE) and UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        if m_Checked then
        begin
            if Enabled then
                Index := 1
            else
                Index := 4;
        end
        else
        begin
            if Enabled then
                Index := 3
            else
                Index := 6;
        end;
        C := 6;
    end
    else
    begin
        if m_Checked then
        begin
            if Enabled then
                Index := 1
            else
                Index := 3;
        end
        else
        begin
            if Enabled then
                Index := 2
            else
                Index := 4;
        end;
        C := 4;
    end;

    Buf.Canvas.Font.Assign(Font);
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_FileTheme.GetBitmap2(GetPicThemeIndexOuter(), Bmp, C, Index)
    else
        GetInsideThemeBitmap(OutUIStyle, GetPicThemeIndex(), Bmp, 4, Index);

    if m_AutoSize then
    begin
        Height := Max(Buf.Canvas.TextHeight('W') + 2, Bmp.Height) + 4;
        Width := Bmp.Width + 8 + Buf.Canvas.TextWidth(Caption);
    end;

    Buf.Height := Height;
    Buf.Width := Width;

    if Transparent then
    begin
        if Parent <> nil then
        begin
            if (Parent is TTabSheet) then
                DoTrans(Buf.Canvas, Parent)
            else
                DoTrans(Buf.Canvas, self);            
        end
        else
            DoTrans(Buf.Canvas, self);
    end
    else
    begin
        Buf.Canvas.Brush.Color := Color;
        Buf.Canvas.FillRect(ClientRect);
    end;

    Buf.Canvas.Brush.Style := bsClear;
    Y := (ClientHeight - Buf.Canvas.TextHeight('W')) div 2;
    if (BidiMode = bdRightToLeft) and SysLocale.MiddleEast then
    begin
        Buf.Canvas.Draw(Width - Bmp.Width - 1, (ClientHeight - Bmp.Height) div 2, Bmp);
        X := Bmp.Width + 4;
        R := Rect(0, Y, Width - X, Height);
        DrawText(Buf.Canvas.Handle, PChar(Caption), -1, R, DT_RIGHT or DT_TOP or DT_SINGLELINE);
    end
    else
    begin
        Buf.Canvas.Draw(1, (ClientHeight - Bmp.Height) div 2, Bmp);
        X := Bmp.Width + 4;
        R := Rect(X, Y, Width, Height);
        DrawText(Buf.Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_TOP or DT_SINGLELINE);
    end;

    if NeedDrawFocus() then
    begin
        if (BidiMode = bdRightToLeft) and SysLocale.MiddleEast then
            R := Rect(0, Y, Width - X + 2, Y + Buf.Canvas.TextHeight('W') + 2)
        else
            R := Rect(X - 1, Y, Width, Y + Buf.Canvas.TextHeight('W') + 2);
        Buf.Canvas.Brush.Style := bsSolid;
        Buf.Canvas.DrawFocusRect(R);
    end;

    Canvas.Draw(0, 0, Buf);
    Bmp.Free();
    Buf.Free();
end;

procedure TsuiCheckBox.SetAutoSize2(const Value: Boolean);
begin
    m_AutoSize := Value;
    Repaint();
end;

procedure TsuiCheckBox.SetChecked(const Value: Boolean);
begin
    if m_Checked = Value then
        Exit;
    m_Checked := Value;
    Repaint();    
    CheckStateChanged();
end;

procedure TsuiCheckBox.SetEnabled(Value: Boolean);
begin
    inherited;
    Repaint();
end;

procedure TsuiCheckBox.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiCheckBox.SetState(const Value: TCheckBoxState);
begin
    if Value = cbChecked then
        Checked := true
    else
        Checked := false;
end;

procedure TsuiCheckBox.SetTabStop(Value: Boolean);
begin
    inherited TabStop := Value;
end;

procedure TsuiCheckBox.SetTransparent(const Value: Boolean);
begin
    m_Transparent := Value;
    Repaint();
end;

procedure TsuiCheckBox.SetUIStyle(const Value: TsuiUIStyle);
begin
    m_UIStyle := Value;
    Repaint();
end;

procedure TsuiCheckBox.Toggle;
begin

end;

function TsuiCheckBox.WantKeyUp: Boolean;
begin
    Result := True;
end;

procedure TsuiCheckBox.WMERASEBKGND(var Msg: TMessage);
begin
    // do nothing
end;

procedure TsuiCheckBox.WMKeyUp(var Msg: TWMKeyUp);
begin
    inherited;

    if not WantKeyUp() then
        Exit;
    if (
        ((Msg.CharCode = VK_SPACE) or (Msg.CharCode = VK_RETURN)) and
        Focused
    ) then
    begin
        if Enabled then
        begin
            Repaint();
            Click();
        end;
    end;
end;

procedure TsuiCheckBox.WMKillFocus(var Msg: TWMKillFocus);
begin
    inherited;

    Repaint();
end;

procedure TsuiCheckBox.WMSetFocus(var Msg: TWMSetFocus);
begin
    inherited;

    Repaint();
end;

{ TsuiRadioButton }

procedure TsuiRadioButton.CheckStateChanged;
begin
    if Checked then
    begin
        UnCheckGroup();
        if csLoading in ComponentState then
            Exit;
        if Assigned(OnClick) then
            OnClick(self);
    end;
end;

constructor TsuiRadioButton.Create(AOwner: TComponent);
begin
    inherited;
    ControlStyle := ControlStyle + [csDoubleClicks];
end;

procedure TsuiRadioButton.DoClick;
begin
    if not Checked then
        Checked := true;
end;

function TsuiRadioButton.GetPicThemeIndex: Integer;
begin
    Result := SUI_THEME_RADIOBUTTON_IMAGE;
end;

function TsuiRadioButton.GetPicThemeIndexOuter: Tsk2SkinBitmapElement;
begin
    Result := SKIN2_RADIOBUTTON;
end;

function TsuiRadioButton.GetPicTransparent: Boolean;
begin
    Result := true;
end;

procedure TsuiRadioButton.UnCheckGroup;
var
    i : Integer;
begin
    if Parent = nil then
        Exit;
    for i := 0 to Parent.ControlCount - 1 do
    begin
        if not (Parent.Controls[i] is TsuiRadioButton) then
            continue;
        if (Parent.Controls[i] as TsuiRadioButton).GroupIndex <> GroupIndex then
            continue;
        if (Parent.Controls[i] = self) then
            continue;
        (Parent.Controls[i] as TsuiRadioButton).Checked := false;
    end;
end;

function TsuiRadioButton.WantKeyUp: Boolean;
begin
    Result := False;
end;

procedure TsuiRadioButton.WMSetFocus(var Msg: TWMSetFocus);
var
    Buf : array[0..MAX_PATH - 1] of Char;
begin
    inherited;
    GetClassName(Msg.FocusedWnd, Buf, MAX_PATH);
    if (Buf = 'TsuiRadioGroupButton') and (Msg.FocusedWnd <> Handle) then
        Click();
end;

{ TsuiImageButton }

procedure TsuiImageButton.AutoSizeChanged;
begin
    if Parent = nil then
        Exit;

    if not m_AutoSize then
        Exit;

    if (m_PicNormal.Graphic <> nil) then
    begin
        Height := m_PicNormal.Height;
        Width := m_PicNormal.Width;
    end;
end;

constructor TsuiImageButton.Create(AOwner: TComponent);
begin
    inherited;

    m_PicDisabled := TPicture.Create();
    m_PicNormal := TPicture.Create();
    m_PicMouseDown := TPicture.Create();
    m_PicMouseOn := TPicture.Create();

    m_Stretch := false;
    m_DrawFocused := false;
end;

destructor TsuiImageButton.Destroy;
begin
    m_PicMouseOn.Free();
    m_PicMOuseOn := nil;

    m_PicMouseDown.Free();
    m_PicMouseDown := nil;

    m_PicNormal.Free();
    m_PicMouseDown := nil;

    m_PicDisabled.Free();
    m_PicDisabled := nil;

    inherited;
end;

function TsuiImageButton.GetUIStyle2: TsuiUIStyle;
begin
    Result := FromThemeFile;
end;

procedure TsuiImageButton.PaintButtonDisabled(Buf: TBitmap);
begin
    if m_PicDisabled.Graphic <> nil then
        Buf.Assign(m_PicDisabled)
    else if m_PicNormal.Graphic <> nil then
        Buf.Assign(m_PicNormal);
end;

procedure TsuiImageButton.PaintButtonMouseDown(Buf: TBitmap);
begin
    if m_PicMouseDown.Graphic <> nil then
        Buf.Assign(m_PicMouseDown)
    else if m_PicNormal.Graphic <> nil then
        Buf.Assign(m_PicNormal);
end;

procedure TsuiImageButton.PaintButtonMouseOn(Buf: TBitmap);
begin
    if m_PicMouseOn.Graphic <> nil then
        Buf.Assign(m_PicMouseOn)
    else if m_PicNormal.Graphic <> nil then
        Buf.Assign(m_PicNormal);
end;

procedure TsuiImageButton.PaintButtonNormal(Buf: TBitmap);
begin
    if m_PicNormal.Graphic <> nil then
        Buf.Assign(m_PicNormal);
end;

procedure TsuiImageButton.PaintFocus(ACanvas: TCanvas);
begin
    if m_DrawFocused then
        inherited
end;

procedure TsuiImageButton.PaintPic(ACanvas: TCanvas; Bitmap: TBitmap);
begin
    if Bitmap = nil then
        Exit;
    if (Bitmap.Width = 0) or (Bitmap.Height = 0) then
        Exit;

    Bitmap.TransparentColor := Bitmap.Canvas.Pixels[0, 0];

    if m_Stretch then
        Acanvas.StretchDraw(rect(0, 0, Width, Height), Bitmap)
    else
        ACanvas.Draw(0, 0, Bitmap);
end;

procedure TsuiImageButton.SetDrawFocused(const Value: Boolean);
begin
    m_DrawFocused := Value;
    Repaint();
end;

procedure TsuiImageButton.SetPicDisabledF(const Value: TPicture);
begin
    m_PicDisabled.Assign(Value);
    AutoSizeChanged();
    Repaint();
end;

procedure TsuiImageButton.SetPicMouseDownF(const Value: TPicture);
begin
    m_PicMouseDown.Assign(Value);
    AutoSizeChanged();
    Repaint();
end;

procedure TsuiImageButton.SetPicMouseOnF(const Value: TPicture);
begin
    m_PicMouseOn.Assign(Value);
    AutoSizeChanged();
    Repaint();
end;

procedure TsuiImageButton.SetPicNormalF(const Value: TPicture);
begin
    m_PicNormal.Assign(Value);
    AutoSizeChanged();
    Repaint();
end;

procedure TsuiImageButton.SetStretch(const Value: Boolean);
begin
    m_Stretch := Value;

    Repaint();
end;

{ TsuiControlButton }

constructor TsuiControlButton.Create(AOwner: TComponent);
begin
    inherited;

    m_ThemeID := 0;
    m_PicIndex := 0;
    m_PicCount := 0;
    TabStop := false;
    UIStyle := SUI_THEME_DEFAULT;
    FileTheme := nil;
end;

procedure TsuiControlButton.PaintButtonDisabled(Buf: TBitmap);
var
    OutUIStyle : TsuiUIStyle;
begin
    if UsingFileTheme(FileTheme, UIStyle, OutUIStyle) then
//        m_FileTheme.GetBitmap(m_ThemeID, Buf, m_PicCount, m_PicIndex)
    else
        GetInsideThemeBitmap(OutUIStyle, m_ThemeID, Buf, m_PicCount, m_PicIndex);
end;

procedure TsuiControlButton.PaintButtonMouseDown(Buf: TBitmap);
var
    OutUIStyle : TsuiUIStyle;
begin
    if UsingFileTheme(FileTheme, UIStyle, OutUIStyle) then
//        m_FileTheme.GetBitmap(m_ThemeID, Buf, m_PicCount, m_PicIndex)
    else
        GetInsideThemeBitmap(OutUIStyle, m_ThemeID, Buf, m_PicCount, m_PicIndex);
end;

procedure TsuiControlButton.PaintButtonMouseOn(Buf: TBitmap);
var
    OutUIStyle : TsuiUIStyle;
begin
    if UsingFileTheme(FileTheme, UIStyle, OutUIStyle) then
//        m_FileTheme.GetBitmap(m_ThemeID, Buf, m_PicCount, m_PicIndex + 1)
    else
        GetInsideThemeBitmap(OutUIStyle, m_ThemeID, Buf, m_PicCount, m_PicIndex + 1);
end;

procedure TsuiControlButton.PaintButtonNormal(Buf: TBitmap);
var
    OutUIStyle : TsuiUIStyle;
begin
    if UsingFileTheme(FileTheme, UIStyle, OutUIStyle) then
//        m_FileTheme.GetBitmap(m_ThemeID, Buf, m_PicCount, m_PicIndex)
    else
        GetInsideThemeBitmap(OutUIStyle, m_ThemeID, Buf, m_PicCount, m_PicIndex);
    Height := Buf.Height;
    Width := Buf.Width;
end;

procedure TsuiControlButton.PaintPic(ACanvas: TCanvas; Bitmap: TBitmap);
begin
    if Bitmap = nil then
        Exit;
    if (Bitmap.Width = 0) or (Bitmap.Height = 0) then
        Exit;

    Bitmap.TransparentColor := Bitmap.Canvas.Pixels[0, 0];
    ACanvas.Draw(0, 0, Bitmap);
    Width := Bitmap.Width;
    Height := Bitmap.Height;
end;

procedure TsuiControlButton.SetPicCount(const Value: Integer);
begin
    m_PicCount := Value;
    Repaint();
end;

procedure TsuiControlButton.SetPicIndex(const Value: Integer);
begin
    m_PicIndex := Value;
    Repaint();
end;

procedure TsuiControlButton.SetThemeID(const Value: Integer);
begin
    m_ThemeID := Value;
    Repaint();
end;

procedure TsuiControlButton.WMERASEBKGND(var Msg: TMessage);
begin
    // Do nothing
end;

{ TsuiToolBarSpeedButton }

constructor TsuiToolBarSpeedButton.Create(AOwner: TComponent);
begin
    inherited;

    m_Glyph := TBitmap.Create();
    Height := 18;
    Width := 18;
end;

destructor TsuiToolBarSpeedButton.Destroy;
begin
    m_Glyph.Free();

    inherited;
end;

procedure TsuiToolBarSpeedButton.MouseEnter(var Msg: TMessage);
begin
    m_MouseIn := true;
    Repaint();    
end;

procedure TsuiToolBarSpeedButton.MouseLeave(var Msg: TMessage);
begin
    m_MouseIn := false;
    Repaint();
end;

procedure TsuiToolBarSpeedButton.Paint;
var
    Buf : TBitmap;
begin
    Glyph.Transparent := true;
    Buf := TBitmap.Create();
    Buf.Width := Width;
    Buf.Height := Height;
    if Color = m_ToColor then
    begin
        Buf.Canvas.Brush.Color := Color;
        Buf.Canvas.FillRect(ClientRect);
    end
    else
    begin
        DrawHorizontalGradient(Buf.Canvas, ClientRect, Color, ToColor);
    end;
    if not Glyph.Empty then
    begin
        if m_MouseIn then
        begin
            Buf.Canvas.Brush.Color := clBlack;
            Buf.Canvas.FrameRect(ClientRect);
        end;

        Buf.Canvas.Draw(1, 1, Glyph);
    end;
    Canvas.Draw(0, 0, Buf);
    Buf.Free();
end;

procedure TsuiToolBarSpeedButton.SetGlyph(const Value: TBitmap);
begin
    m_Glyph.Assign(Value);
end;

procedure TsuiToolBarSpeedButton.WMERASEBKGND(var Msg: TMessage);
begin
    // do nothing
end;

{ TsuiArrowButton }

procedure TsuiArrowButton.PaintPic(ACanvas: TCanvas; Bitmap: TBitmap);
var
    W, H: Integer;
begin
    SpitDraw(Bitmap, ACanvas, ClientRect, PicTransparent);
    ACanvas.Brush.Color := clBlack;
    ACanvas.Pen.Color := clBlack;
    W := (Width - 6) div 2;
    H := (Height - 3) div 2;
    if m_Arrow = suiUp then
        ACanvas.Polygon([Point(W, H + 3), Point(W + 3, H), Point(W + 6, H + 3)]);
    if m_Arrow = suiDown then
        ACanvas.Polygon([Point(W, H), Point(W + 3, H + 3), Point(W + 6, H)]);
end;

procedure TsuiArrowButton.PaintText(ACanvas: TCanvas; Text: String);
begin
    // do nothing
end;

procedure TsuiArrowButton.SetArrow(const Value: TsuiArrowButtonType);
begin
    m_Arrow := Value;
    Repaint();
end;

procedure TsuiArrowButton.UIStyleChanged;
var
    OutUIStyle : TsuiUIStyle;
begin
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        Transparent := m_FileTheme.GetBool(SKIN2_BUTTONTRANS)
    else
        Transparent := GetInsideThemeBool(OutUIStyle, SUI_THEME_BUTTON_TRANSPARENT_BOOL);
end;

end.

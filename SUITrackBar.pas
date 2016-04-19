////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUITrackBar.pas
//  Creator     :   Shen Min
//  Date        :   2002-11-20 V1-V3
//                  2003-06-30 V4
//                  2006-06-14 V6
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUITrackBar;

interface

{$I SUIPack.inc}

uses Windows, Messages, SysUtils, Classes, Controls, Graphics, ExtCtrls, Forms,
     Math,
     SUIImagePanel, SUIThemes, SUIProgressBar, SUIMgr, SUI2Define;

type
    TsuiTrackBar = class(TCustomPanel)
    private
        m_BarImage : TPicture;
        m_Timer : TTimer;
        m_Slider : TsuiImagePanel;
        m_Min : Integer;
        m_Max : Integer;
        m_Position : Integer;
        m_LastPos : Integer;
        m_Orientation : TsuiProgressBarOrientation;
        m_FileTheme : TsuiFileTheme;        
        m_UIStyle : TsuiUIStyle;
        m_ShowTick : Boolean;
        m_Transparent : Boolean;
        m_OnChange : TNotifyEvent;
        m_CustomPicture : Boolean;
        m_LastChange : Integer;

        m_bSlidingFlag : Boolean;
        m_MouseDownPos : Integer;
        m_Frequency : Integer;

        procedure SetBarImage(const Value: TPicture);
        procedure SetMax(const Value: Integer);
        procedure SetMin(const Value: Integer);
        procedure SetPosition(const Value: Integer);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure SetOrientation(const Value: TsuiProgressBarOrientation);
        function GetSliderImage: TPicture;
        procedure SetSliderImage(const Value: TPicture); virtual;
        procedure SetTransparent(const Value: Boolean);

        procedure UpdateControl();
        procedure UpdateSlider();
        function GetSliderPosFromPosition() : TPoint;
        function GetPositionFromFromSliderPos(X, Y : Integer) : Integer;
        procedure UpdatePositionValue(X, Y : Integer; Update : Boolean);
        procedure SetPageSize(const Value: Integer);
        procedure SetLineSize(const Value: Integer);
        procedure SetShowTick(const Value: Boolean);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetFrequency(const Value: Integer);

        procedure OnSliderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure OnSliderMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure OnTimer(Sender : TObject);
        procedure SetSize();
        procedure PaintTick(const Buf : TBitmap);

        procedure WMERASEBKGND(var Msg : TMessage); message WM_ERASEBKGND;
        procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
        procedure CMFocusChanged(var Msg: TCMFocusChanged); message CM_FOCUSCHANGED;

    protected
        m_PageSize : Integer;
        m_LineSize : Integer;

        procedure UpdatePicture(); virtual;
        function CustomPicture() : Boolean; virtual;
        function SUICanFocus() : Boolean; virtual;
        procedure Paint(); override;
        procedure Resize(); override;
        procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
        procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
        procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
        procedure KeyDown(var Key: word; Shift: TShiftState); override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;

        function SliderTransparent() : boolean; virtual;

        property LastChange : Integer read m_LastChange;

    public
        m_BarImageBuf : TBitmap;

        constructor Create(AOwner : TComponent); override;
        destructor Destroy(); override;

        property UseCustomPicture : Boolean read m_CustomPicture write m_CustomPicture;

    published
        property Orientation : TsuiProgressBarOrientation read m_Orientation write SetOrientation;
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BarImage : TPicture read m_BarImage write SetBarImage;
        property SliderImage : TPicture read GetSliderImage write SetSliderImage;
        property Max : Integer read m_Max write SetMax;
        property Min : Integer read m_Min write SetMin;
        property Position : Integer read m_Position write SetPosition;
        property PageSize : Integer read m_PageSize write SetPageSize;
        property LineSize : Integer read m_LineSize write SetLineSize;
        property ShowTick : Boolean read m_ShowTick write SetShowTick;
        property Transparent : Boolean read m_Transparent write SetTransparent;
        property Frequency : Integer read m_Frequency write SetFrequency;

        property Align;
        property Alignment;
        property BiDiMode;
        property Anchors;
        property Color;
        property DragKind;
        property DragMode;
        property Enabled;
        property ParentBiDiMode;
        property ParentFont;
        property ParentColor;
        property ParentShowHint;
        property ShowHint;
        property TabOrder;
        property TabStop;
        property Visible;

        property OnChange : TNotifyEvent read m_OnChange write m_OnChange;
        property OnCanResize;
        property OnClick;
        property OnContextPopup;
        property OnDockDrop;
        property OnDockOver;
        property OnDblClick;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDock;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
        property OnMouseDown;
        property OnMouseMove;
        property OnMouseUp;
        property OnResize;
        property OnStartDock;
        property OnStartDrag;
        property OnUnDock;
    end;

    TsuiScrollTrackBar = class(TsuiTrackBar)
    private
        function GetSliderVisible: Boolean;
        procedure SetSliderVisible(const Value: Boolean);

    protected
        function SliderTransparent() : boolean; override;
        function CustomPicture() : Boolean; override;
        function SUICanFocus() : Boolean; override;
        
    public
        constructor Create(AOwner : TComponent); override;
        procedure UpdateSliderSize();
        property SliderVisible : Boolean read GetSliderVisible write SetSliderVisible;
        property LastChange;
    end;

implementation

uses SUIPublic;

{ TsuiTrackBar }

constructor TsuiTrackBar.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle - [csAcceptsControls];
    m_BarImageBuf := TBitmap.Create();

    m_BarImage := TPicture.Create();
    
    m_Slider := TsuiImagePanel.Create(self);
    m_Slider.Parent := self;
    m_Slider.OnMouseDown := OnSliderMouseDown;
    m_Slider.OnMouseUp := OnSliderMouseUp;

    m_Timer := nil;

    Min := 0;
    Max := 10;
    Position := 0;
    m_LastPos := 0;
    Orientation := suiHorizontal;
    PageSize := 2;
    LineSize := 1;
    m_ShowTick := true;
    ParentColor := true;

    m_bSlidingFlag := false;
    TabStop := true;
    m_CustomPicture := false;
    m_Frequency := 1;
    m_LastChange := 0;

    UIStyle := GetSUIFormStyle(AOwner);
    UpdateSlider();
end;

destructor TsuiTrackBar.Destroy;
begin
    m_Slider.Free();
    m_Slider := nil;

    m_BarImage.Free();
    m_BarImage := nil;

    m_BarImageBuf.Free();
    m_BarImageBuf := nil;

    inherited;
end;

function TsuiTrackBar.GetSliderPosFromPosition: TPoint;
var
    nY : Integer;
begin
    if m_Orientation = suiHorizontal then
    begin
        nY := Height - m_Slider.Height;
        if nY < 0 then
            nY := 0;
        Result.Y := nY div 2;
        if m_Max = m_Min then
            Result.X := 0
        else
            Result.X := ((m_Position - m_Min) * (Width - m_Slider.Width)) div (m_Max - m_Min);
    end
    else
    begin
        nY := Width - m_Slider.Width;
        if nY < 0 then
            nY := 0;
        Result.X := nY div 2;
        if m_Max = m_Min then
            Result.Y := 0
        else
            Result.Y := ((m_Position - m_Min) * (Height - m_Slider.Height)) div (m_Max - m_Min);
    end;
end;

function TsuiTrackBar.GetSliderImage: TPicture;
begin
    Result := m_Slider.Picture;
end;

procedure TsuiTrackBar.Paint;
var
    Buf : TBitmap;
    nTop : Integer;
    R : TRect;
begin
    Buf := TBitmap.Create();
    Buf.Width := Width;
    Buf.Height := Height;

    if m_Transparent then
    begin
        DoTrans(Buf.Canvas, self);
    end
    else
    begin
        Buf.Canvas.Brush.Color := Color;
        Buf.Canvas.FillRect(Rect(0, 0, Buf.Width, Buf.Height));
    end;

    if m_Orientation = suiHorizontal then
    begin
        nTop := (Height - m_BarImage.Height) div 2;
        BitBlt(
            Buf.Canvas.Handle,
            0,
            nTop,
            Buf.Width,
            nTop + m_BarImage.Height,
            m_BarImageBuf.Canvas.Handle,
            0,
            0,
            SRCCOPY
        );
    end
    else
    begin
        nTop := (Width - m_BarImage.Height) div 2;
        BitBlt(
            Buf.Canvas.Handle,
            nTop,
            0,
            nTop + m_BarImage.Width,
            Height,
            m_BarImageBuf.Canvas.Handle,
            0,
            0,
            SRCCOPY
        );
    end;

    if Focused and TabStop then
    begin
        R := Rect(0, 0, Width, Height);
        Buf.Canvas.Brush.Style := bsSolid;
        Buf.Canvas.DrawFocusRect(R);
    end;
    if m_ShowTick then
        PaintTick(Buf);
    Canvas.Draw(0, 0, Buf);

    Buf.Free();
end;

procedure TsuiTrackBar.SetBarImage(const Value: TPicture);
begin
    m_BarImage.Assign(Value);

    UpdateControl();
end;

procedure TsuiTrackBar.SetMax(const Value: Integer);
begin
    if m_Max = Value then
        Exit;
    m_Max := Value;
    if m_Max < m_Min then
        m_Max := m_Min;
    if m_Max < m_Position then
        m_Position := m_Max;
    UpdateSlider();
end;

procedure TsuiTrackBar.SetMin(const Value: Integer);
begin
    if m_Min = Value then
        Exit;
    m_Min := Value;
    if m_Min > m_Max then
        m_Min := m_Max;
    if m_Min > m_Position then
        m_Position := m_Min;
    UpdateSlider();
end;

procedure TsuiTrackBar.SetOrientation(const Value: TsuiProgressBarOrientation);
begin
    if m_Orientation = Value then
        Exit;

    m_Orientation := Value;
    UpdateControl();
end;

procedure TsuiTrackBar.SetPosition(const Value: Integer);
begin
    if Value < m_Min then
        m_Position := m_Min
    else if Value > m_Max then
        m_Position := m_Max
    else
        m_Position := Value;

    UpdateSlider();
end;

procedure TsuiTrackBar.SetSliderImage(const Value: TPicture);
begin
    m_Slider.Picture.Assign(Value);
    Repaint();
end;

procedure TsuiTrackBar.SetUIStyle(const Value: TsuiUIStyle);
begin
    m_UIStyle := Value;

    UpdateControl();
{$IFDEF RES_MACOS}
    if m_UIStyle = MacOS then
        Transparent := true;
{$ENDIF}
end;

procedure TsuiTrackBar.UpdateSlider;
var
    SliderPos : TPoint;
begin
    SliderPos := GetSliderPosFromPosition();
    PlaceControl(m_Slider, SliderPos);
    Repaint();
    if m_Position <> m_LastPos then
    begin
        m_LastChange := m_Position - m_LastPos;
        m_LastPos := m_Position;
        if Assigned(m_OnChange) then
            m_OnChange(self);
    end;
end;

procedure TsuiTrackBar.Resize;
begin
    inherited;

    UpdateControl();
end;

procedure TsuiTrackBar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
    inherited;

    if not m_bSlidingFlag then
    begin
        if (X < 0) or (X > Width) or (Y < 0) or (Y > Height) then
            if m_Timer <> nil then
            begin
                m_Timer.Free();
                m_Timer := nil;
            end;

        Exit;
    end;

    UpdatePositionValue(X, Y, false);
    PlaceControl(m_Slider, GetSliderPosFromPosition());

    if m_Position <> m_LastPos then
    begin
        m_LastChange := m_Position - m_LastPos;
        if Assigned(m_OnChange) then
            m_OnChange(self);
        m_LastPos := m_Position;
    end;
end;

procedure TsuiTrackBar.OnSliderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if m_Orientation = suiHorizontal then
        m_MouseDownPos := X
    else
        m_MouseDownPos := Y;
    m_bSlidingFlag := true;
    if SUICanFocus() and CanFocus and Enabled then
        SetFocus();

    SetCapture(Handle);
    if Assigned(OnMouseDown) then
        OnMouseDown(self, Button, Shift, m_Slider.Left + X, m_Slider.Top + Y);
end;

procedure TsuiTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
    inherited;

    if Button <> mbLeft then
        Exit;

    if m_Orientation = suiHorizontal then
    begin
        if X > GetSliderPosFromPosition().X then
            Position := Math.Min(Position + m_PageSize, GetPositionFromFromSliderPos(X, Y))
        else if X < GetSliderPosFromPosition().X then
            Position := Math.Max(Position - m_PageSize, GetPositionFromFromSliderPos(X, Y))
    end
    else
    begin
        if Y > GetSliderPosFromPosition().Y then
            Position := Math.Min(Position + m_PageSize, GetPositionFromFromSliderPos(X, Y))
        else if Y < GetSliderPosFromPosition().Y then
            Position := Math.Max(Position - m_PageSize, GetPositionFromFromSliderPos(X, Y))
    end;

    if m_Timer = nil then
    begin
        m_Timer := TTimer.Create(nil);
        m_Timer.OnTimer := OnTimer;
        m_Timer.Interval := 100;
        m_Timer.Enabled := true;
    end;
    if SUICanFocus() and CanFocus() and Enabled then
        SetFocus();
end;

procedure TsuiTrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    inherited;

    if m_Timer <> nil then
    begin
        m_Timer.Free();
        m_Timer := nil;
    end;

    m_bSlidingFlag := false;
    ReleaseCapture();
end;

function TsuiTrackBar.GetPositionFromFromSliderPos(X, Y: Integer): Integer;
begin
    if m_Orientation = suiHorizontal then
    begin
        if Width = m_Slider.Width then
            Result := 0
        else
            Result := Round((X - m_MouseDownPos) * (m_Max - m_Min) / (Width - m_Slider.Width)) + m_Min
    end
    else
    begin
        if Height = m_Slider.Height then
            Result := 0
        else
            Result := Round((Y - m_MouseDownPos) * (m_Max - m_Min) / (Height - m_Slider.Height)) + m_Min;
    end;
end;

procedure TsuiTrackBar.SetSize();
begin
    if m_Orientation = suiHorizontal then
        Height := Math.Max(m_BarImage.Height, m_Slider.Height)
    else
        Width := Math.Max(m_BarImage.Height, m_Slider.Width);
    Repaint();
end;

procedure TsuiTrackBar.WMERASEBKGND(var Msg: TMessage);
begin
    // do nothing
end;

procedure TsuiTrackBar.UpdatePicture;
var
    R : TRect;
    bFileTheme : boolean;
    OutUIStyle : TsuiUIStyle;
    Tmp : TBitmap;
begin
    if CustomPicture() then
        Exit;
    bFileTheme := UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle);
    if m_Orientation = suiHorizontal then
    begin
        if bFileTheme then
        begin
            m_BarImage.Bitmap.Assign(m_FileTheme.GetBitmap(SKIN2_TRACKBAR));
            Tmp := m_FileTheme.GetBitmap(SKIN2_TRACKBARSLIDER);
            ScanColor(Tmp, m_FileTheme.GetColor(SKIN2_TRANSCOLOR), m_FileTheme.GetColor(SKIN2_FORMCOLOR));
            SliderImage.Bitmap.Assign(Tmp);
        end
        else
        begin
            GetInsideThemeBitmap(OutUIStyle, SUI_THEME_TRACKBAR_BAR, m_BarImage.Bitmap);
            GetInsideThemeBitmap(OutUIStyle, SUI_THEME_TRACKBAR_SLIDER, SliderImage.Bitmap);
        end;

        m_BarImageBuf.Width := Width;
        m_BarImageBuf.Height := m_BarImage.Height;
        R := Rect(0, 0, m_BarImageBuf.Width, m_BarImageBuf.Height);
        m_BarImageBuf.Canvas.Brush.Color := Color;
        m_BarImageBuf.Canvas.FillRect(R);
        SpitDrawHorizontal(m_BarImage.Bitmap, m_BarImageBuf.Canvas, R, false, Color);
    end
    else
    begin
        if bFileTheme then
        begin
            m_BarImage.Bitmap.Assign(m_FileTheme.GetBitmap(SKIN2_TRACKBAR));
            Tmp := m_FileTheme.GetBitmap(SKIN2_TRACKBARVSLIDER);
            ScanColor(Tmp, m_FileTheme.GetColor(SKIN2_TRANSCOLOR), m_FileTheme.GetColor(SKIN2_FORMCOLOR));
            SliderImage.Bitmap.Assign(Tmp);
        end
        else
        begin
            GetInsideThemeBitmap(OutUIStyle, SUI_THEME_TRACKBAR_BAR, m_BarImage.Bitmap);
            GetInsideThemeBitmap(OutUIStyle, SUI_THEME_TRACKBAR_SLIDER_V, SliderImage.Bitmap);
        end;

        m_BarImageBuf.Width := Height;
        m_BarImageBuf.Height := m_BarImage.Height;
        R := Rect(0, 0, m_BarImageBuf.Width, m_BarImageBuf.Height);
        m_BarImageBuf.Canvas.Brush.Color := Color;
        m_BarImageBuf.Canvas.FillRect(R);
        SpitDrawHorizontal(m_BarImage.Bitmap, m_BarImageBuf.Canvas, R, false, Color);
        RoundPicture(m_BarImageBuf);
    end;
    m_Slider.Transparent := SliderTransparent();
    m_Slider.AutoSize := true;
end;

procedure TsuiTrackBar.UpdateControl;
begin
    UpdatePicture();
    SetSize();
    UpdateSlider();
    Repaint();
end;

procedure TsuiTrackBar.UpdatePositionValue(X, Y : Integer; Update : Boolean);
var
    nPos : Integer;
begin
    nPos := GetPositionFromFromSliderPos(X, Y);

    if nPos > m_Max then
        nPos := m_Max
    else if nPos < m_Min then
        nPos := m_Min;
    if Update then
        Position := nPos
    else
        m_Position := nPos;
end;

procedure TsuiTrackBar.OnTimer(Sender: TObject);
var
    P : TPoint;
begin
    GetCursorPos(P);
    P := ScreenToClient(P);
    if m_Orientation = suiHorizontal then
    begin
        if P.X > GetSliderPosFromPosition().X then
            Position := Math.Min(Position + 3 * m_PageSize, GetPositionFromFromSliderPos(P.X, P.Y))
        else if P.X < GetSliderPosFromPosition().X then
            Position := Math.Max(Position - 3 * m_PageSize, GetPositionFromFromSliderPos(P.X, P.Y))
    end
    else
    begin
        if P.Y > GetSliderPosFromPosition().Y then
            Position := Math.Min(Position + m_PageSize, GetPositionFromFromSliderPos(P.X, P.Y))
        else if P.Y < GetSliderPosFromPosition().Y then
            Position := Math.Max(Position - m_PageSize, GetPositionFromFromSliderPos(P.X, P.Y))
    end;
end;

procedure TsuiTrackBar.SetPageSize(const Value: Integer);
begin
    if (Value < 0) or (Value > m_Max) then
        Exit;
    m_PageSize := Value;
end;

procedure TsuiTrackBar.CMFocusChanged(var Msg: TCMFocusChanged);
begin
    inherited;

    Repaint();
end;

procedure TsuiTrackBar.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiTrackBar.Notification(AComponent: TComponent;
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

procedure TsuiTrackBar.SetTransparent(const Value: Boolean);
begin
    m_Transparent := Value;
    Repaint();
end;

procedure TsuiTrackBar.KeyDown(var Key: word; Shift: TShiftState);
begin
    inherited;
    case Key of
        VK_PRIOR: Position := Position - PageSize;
        VK_NEXT: Position := Position + PageSize;
        VK_END: Position := Max;
        VK_HOME: Position := Min;
        VK_LEFT: Position := Position - LineSize;
        VK_RIGHT: Position := Position + LineSize;
        VK_UP: Position := Position - LineSize;
        VK_DOWN: Position := Position + LineSize;
    end;
end;

procedure TsuiTrackBar.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
    inherited;
    Msg.Result := DLGC_WANTARROWS;
end;

procedure TsuiTrackBar.SetLineSize(const Value: Integer);
begin
    if (Value < 0) or (Value > m_Max) then
        Exit;

    m_LineSize := Value;
end;

procedure TsuiTrackBar.PaintTick(const Buf : TBitmap);
var
    x : Integer;
    i : Integer;
    nLen : Integer;
    nStart : Integer;
    Freq : Integer;
begin
    if m_Max = m_Min then
        Exit;

    if m_Orientation = suiHorizontal then
    begin
        nLen := Width - m_Slider.Width;
        nStart := m_Slider.Width div 2;
        Freq := 0;
        for i := m_Min to m_Max do
        begin
            if i <> m_Max then
            begin
                if Freq <> m_Frequency then
                begin
                    Inc(Freq);
                    if Freq <> 1 then
                        Continue
                end
                else
                    Freq := 1;
            end;
            x := nStart + nLen * (i - m_Min) div (m_Max - m_Min);
            Buf.Canvas.MoveTo(x, Height - 3);
            Buf.Canvas.LineTo(x, Height);
        end;
    end
    else
    begin
        nLen := Height - m_Slider.Height;
        nStart := m_Slider.Height div 2;
        Freq := 0;
        for i := m_Min to m_Max do
        begin
            if i <> m_Max then
            begin
                if Freq <> m_Frequency then
                begin
                    Inc(Freq);
                    if Freq <> 1 then
                        Continue
                end
                else
                    Freq := 1;
            end;
            x := nStart + nLen * (i - m_Min) div (m_Max - m_Min);
            Buf.Canvas.MoveTo(0, x);
            Buf.Canvas.LineTo(3, x);
            Buf.Canvas.MoveTo(Width - 3, x);
            Buf.Canvas.LineTo(Width, x);
        end;
    end;
end;

procedure TsuiTrackBar.SetShowTick(const Value: Boolean);
begin
    m_ShowTick := Value;
    Repaint();
end;

function TsuiTrackBar.SliderTransparent: boolean;
begin
    if m_Orientation = suiHorizontal then
        Result := true
    else
        Result := false;
end;

function TsuiTrackBar.CustomPicture: Boolean;
begin
    Result := m_CustomPicture;
end;

procedure TsuiTrackBar.SetFrequency(const Value: Integer);
begin
    m_Frequency := Value;
    Repaint();
end;

procedure TsuiTrackBar.OnSliderMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Assigned(OnMouseUp) then
        OnMouseUp(self, Button, Shift, m_Slider.Left + X, m_Slider.Top + Y);
end;

function TsuiTrackBar.SUICanFocus: Boolean;
begin
    Result := true;
end;

{ TsuiScrollTrackBar }

constructor TsuiScrollTrackBar.Create(AOwner: TComponent);
begin
    inherited;

    TabStop := false;
    m_Slider.TabStop := false;
    m_Slider.ControlStyle := self.ControlStyle;
end;

function TsuiScrollTrackBar.CustomPicture: Boolean;
begin
    Result := true;
end;

function TsuiScrollTrackBar.GetSliderVisible: Boolean;
begin
    Result := m_Slider.Visible;
end;

procedure TsuiScrollTrackBar.SetSliderVisible(const Value: Boolean);
begin
    if m_Slider.Visible <> Value then
        m_Slider.Visible := Value;
end;

function TsuiScrollTrackBar.SliderTransparent: boolean;
begin
    Result := false;
end;

function TsuiScrollTrackBar.SUICanFocus: Boolean;
begin
    Result := false;
end;

procedure TsuiScrollTrackBar.UpdateSliderSize;
begin
    m_Slider.AutoSize := true;
end;

end.

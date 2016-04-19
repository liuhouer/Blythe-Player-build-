////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIScrollBar.pas
//  Creator     :   Shen Min
//  Date        :   2003-03-26 V1-V3
//                  2003-07-02 V4
//                  2006-06-14 V6
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIScrollBar;

interface

{$I SUIPack.inc}

uses Windows, ExtCtrls, Classes, Controls, SysUtils, Graphics, Forms, Messages,
     Math,
     SUIProgressBar, SUITrackBar, SUIButton, SUIThemes, SUIMgr, SUI2Define;

type
    TsuiScrollBar = class(TCustomPanel)
    private
        m_TrackBar : TsuiScrollTrackBar;
        m_Btn1 : TsuiImageButton;
        m_Btn2 : TsuiImageButton;
        m_SliderLeft : TBitmap;
        m_SliderCenter : TBitmap;
        m_SliderRight : TBitmap;

        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;
        m_Orientation : TsuiProgressBarOrientation;
        m_SmallChange : TScrollBarInc;
        m_LineButton: Integer;

        procedure SetOrientation(const Value: TsuiProgressBarOrientation);
        procedure SetUIStyle(const Value: TsuiUIStyle);

        procedure PlaceTrackBarAndButton();
        procedure UpdatePictures();
        procedure UpdateSliderPic();

        function GetMax: Integer;
        function GetMin: Integer;
        function GetPosition: Integer;
        procedure SetMax(const Value: Integer);
        procedure SetMin(const Value: Integer);
        procedure SetPosition(const Value: Integer);
        function GetLargeChange: TScrollBarInc;
        procedure SetLargeChange(const Value: TScrollBarInc);
        function GetPageSize: Integer;
        procedure SetPageSize(const Value: Integer);
        function GetSliderVisible: Boolean;
        procedure SetSliderVisible(const Value: Boolean);
        function GetOnChange: TNotifyEvent;
        procedure SetOnChange(const Value: TNotifyEvent);
        procedure SetFileTheme(const Value: TsuiFileTheme);

        procedure MouseContinuouslyDownDec(Sender : TObject);
        procedure MouseContinuouslyDownInc(Sender : TObject);

        procedure WMSIZE(var Msg : TMessage); message WM_SIZE;
        procedure WMERASEBKGND( var Msg : TMessage); message WM_ERASEBKGND;
        procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
        procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
        procedure SetLineButton(const Value: Integer);
        function GetLastChange: Integer;

    protected
        procedure Resize(); override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy(); override;

        property SliderVisible : Boolean read GetSliderVisible write SetSliderVisible;
        property LastChange : Integer read GetLastChange;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property LineButton : Integer read m_LineButton write SetLineButton;
        property Orientation : TsuiProgressBarOrientation read m_Orientation write SetOrientation;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property Max : Integer read GetMax write SetMax;
        property Min : Integer read GetMin write SetMin;
        property Position : Integer read GetPosition write SetPosition;
        property SmallChange : TScrollBarInc read m_SmallChange write m_SmallChange;
        property LargeChange : TScrollBarInc read GetLargeChange write SetLargeChange;
        property PageSize : Integer read GetPageSize write SetPageSize;

        property Align;
        property Anchors;
        property BiDiMode;
        property Color;
        property Constraints;
        property DragCursor;
        property DragKind;
        property DragMode;
        property Enabled;
        property ParentBiDiMode;
        property ParentColor;
        property ParentShowHint;
        property PopupMenu;
        property ShowHint;
        property Visible;

        property OnChange : TNotifyEvent read GetOnChange write SetOnChange;
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

implementation

uses SUIPublic;

{ TsuiScrollBar }

procedure TsuiScrollBar.CMColorChanged(var Message: TMessage);
begin
    if m_TrackBar <> nil then
        m_TrackBar.Color := Color;
end;

procedure TsuiScrollBar.CMVisibleChanged(var Message: TMessage);
begin
    inherited;

    m_TrackBar.Visible := Visible;
    m_Btn1.Visible := Visible;
    m_Btn2.Visible := Visible;
end;

constructor TsuiScrollBar.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle - [csAcceptsControls];
    m_SliderLeft := TBitmap.Create();
    m_SliderCenter := TBitmap.Create();
    m_SliderRight := TBitmap.Create();

    m_TrackBar := TsuiScrollTrackBar.Create(self);
    m_TrackBar.Parent := self;
    m_TrackBar.ShowTick := false;
    m_TrackBar.TabStop := false;
    m_TrackBar.Transparent := false;
    m_TrackBar.Max := 100;

    m_Btn1 := TsuiImageButton.Create(self);
    m_Btn1.Parent := self;
    m_Btn1.OnMouseContinuouslyDown := MouseContinuouslyDownInc;
    m_Btn1.MouseContinuouslyDownInterval := 100;
    m_Btn1.TabStop := false;
    m_Btn2 := TsuiImageButton.Create(self);
    m_Btn2.Parent := self;
    m_Btn2.OnMouseContinuouslyDown := MouseContinuouslyDownDec;
    m_Btn2.MouseContinuouslyDownInterval := 100;
    m_Btn2.TabStop := false;

    BevelOuter := bvNone;
    BevelInner := bvNone;

    Orientation := suiHorizontal;
    m_SmallChange := 1;
    m_LineButton := 0;
    Height := 185;

    UIStyle := GetSUIFormStyle(AOwner);
    PlaceTrackBarAndButton();
end;

destructor TsuiScrollBar.Destroy;
begin
    m_Btn2.Free();
    m_Btn1.Free();
    m_TrackBar.Free();
    m_SliderRight.Free();
    m_SliderCenter.Free();
    m_SliderLeft.Free();

    inherited;
end;

function TsuiScrollBar.GetLargeChange: TScrollBarInc;
begin
    Result := m_TrackBar.PageSize;
end;

function TsuiScrollBar.GetLastChange: Integer;
begin
    Result := m_TrackBar.LastChange;
end;

function TsuiScrollBar.GetMax: Integer;
begin
    Result := m_TrackBar.Max;
end;

function TsuiScrollBar.GetMin: Integer;
begin
    Result := m_TrackBar.Min;
end;

function TsuiScrollBar.GetOnChange: TNotifyEvent;
begin
    Result := m_TrackBar.OnChange;
end;

function TsuiScrollBar.GetPageSize: Integer;
begin
    Result := m_TrackBar.PageSize;
end;

function TsuiScrollBar.GetPosition: Integer;
begin
    Result := m_TrackBar.Position;
end;

function TsuiScrollBar.GetSliderVisible: Boolean;
begin
    Result := m_TrackBar.SliderVisible
end;

procedure TsuiScrollBar.MouseContinuouslyDownDec(Sender: TObject);
begin
    m_TrackBar.Position := m_TrackBar.Position - m_SmallChange;
end;

procedure TsuiScrollBar.MouseContinuouslyDownInc(Sender: TObject);
begin
    m_TrackBar.Position := m_TrackBar.Position + m_SmallChange;
end;

procedure TsuiScrollBar.Notification(AComponent: TComponent;
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

procedure TsuiScrollBar.PlaceTrackBarAndButton;
begin
    m_TrackBar.Orientation := m_Orientation;

    if (Height = 0) or (Width = 0) then
    begin
        Visible := False;
    end
    else
    begin
        if m_Orientation = suiVertical then
        begin
            m_Btn2.Top := 0;
            m_Btn2.Left := 0;
            m_TrackBar.Top := m_Btn2.Height;
            m_TrackBar.Height := Height - m_Btn1.Height - m_Btn2.Height;
            m_TrackBar.Left := 0;
            m_Btn1.Top := Height - m_Btn1.Height;
            m_Btn1.Left := 0;
            Width := m_Btn2.Width;
        end
        else
        begin
            m_Btn2.Left := 0;
            m_Btn2.Top := 0;
            m_TrackBar.Left := m_Btn2.Width;
            m_TrackBar.Width := Width - m_Btn1.Width - m_Btn2.Width;
            m_TrackBar.Top := 0;
            m_Btn1.Left := Width - m_Btn1.Width;
            m_Btn1.Top := 0;
            Height := m_Btn2.Height;
        end;
        UpdateSliderPic();
    end;
end;

procedure TsuiScrollBar.Resize;
begin
    inherited;

    PlaceTrackBarAndButton();
end;

procedure TsuiScrollBar.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiScrollBar.SetLargeChange(const Value: TScrollBarInc);
begin
    m_TrackBar.PageSize := Value;
end;

procedure TsuiScrollBar.SetLineButton(const Value: Integer);
begin
    if m_LineButton = Value then
        Exit;

    if m_Orientation = suiVertical then
    begin
        if Value > Height - m_Btn1.Height - m_Btn2.Height then
            Exit;
    end
    else
    begin
        if Value > Width - m_Btn1.Width - m_Btn2.Width then
            Exit;
    end;

    m_LineButton := Value;
    UpdateSliderPic();
end;

procedure TsuiScrollBar.SetMax(const Value: Integer);
begin
    m_TrackBar.Max := Value;
end;

procedure TsuiScrollBar.SetMin(const Value: Integer);
begin
    m_TrackBar.Min := Value;
end;

procedure TsuiScrollBar.SetOnChange(const Value: TNotifyEvent);
begin
    m_TrackBar.OnChange := Value;
end;

procedure TsuiScrollBar.SetOrientation(const Value: TsuiProgressBarOrientation);
begin
    if m_Orientation = Value then
        Exit;

    m_Orientation := Value;
    UpdatePictures();

    PlaceTrackBarAndButton();
end;

procedure TsuiScrollBar.SetPageSize(const Value: Integer);
begin
    m_TrackBar.PageSize := Value;
    UpdateSliderPic();
end;

procedure TsuiScrollBar.SetPosition(const Value: Integer);
begin
    if m_TrackBar.Position = Value then
        Exit;
    m_TrackBar.Position := Value;
end;

procedure TsuiScrollBar.SetSliderVisible(const Value: Boolean);
begin
    if m_TrackBar.SliderVisible <> Value then
        m_TrackBar.SliderVisible := Value;
end;

procedure TsuiScrollBar.SetUIStyle(const Value: TsuiUIStyle);
begin
    m_UIStyle := Value;

    m_TrackBar.Color := Color;
    UpdatePictures();
    PlaceTrackBarAndButton();
end;

procedure TsuiScrollBar.UpdatePictures;
var
    OutUIStyle : TsuiUIStyle;
    TempBmp : TBitmap;
begin
    m_TrackBar.BarImage := nil;
    TempBmp := TBitmap.Create();

    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        Color := m_FileTheme.GetColor(SKIN2_SCROLLBARCOLOR);
        TempBmp.Assign(m_FileTheme.GetBitmap(SKIN2_SCROLLBAR));
        RoundPicture(TempBmp);
        SpitBitmap(TempBmp, m_SliderLeft, 3, 1);
        SpitBitmap(TempBmp, m_SliderCenter, 3, 2);
        SpitBitmap(TempBmp, m_SliderRight, 3, 3);

        m_FileTheme.GetBitmap2(SKIN2_SCROLLBARUPBUTTON, TempBmp, 3, 1);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn2.PicNormal.Bitmap.Assign(TempBmp);
        m_FileTheme.GetBitmap2(SKIN2_SCROLLBARUPBUTTON, TempBmp, 3, 2);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn2.PicMouseOn.Bitmap.Assign(TempBmp);
        m_FileTheme.GetBitmap2(SKIN2_SCROLLBARUPBUTTON, TempBmp, 3, 3);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn2.PicMouseDown.Bitmap.Assign(TempBmp);
        m_FileTheme.GetBitmap2(SKIN2_SCROLLBARDOWNBUTTON, TempBmp, 3, 1);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn1.PicNormal.Bitmap.Assign(TempBmp);
        m_FileTheme.GetBitmap2(SKIN2_SCROLLBARDOWNBUTTON, TempBmp, 3, 2);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn1.PicMouseOn.Bitmap.Assign(TempBmp);
        m_FileTheme.GetBitmap2(SKIN2_SCROLLBARDOWNBUTTON, TempBmp, 3, 3);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn1.PicMouseDown.Bitmap.Assign(TempBmp);
    end
    else
    begin
        Color := GetInsideThemeColor(OutUIStyle, SUI_THEME_SCROLLBAR_BACKGROUND_COLOR);
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SCROLLBAR_SLIDER_IMAGE, m_SliderLeft, 3, 1);
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SCROLLBAR_SLIDER_IMAGE, m_SliderCenter, 3, 2);
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SCROLLBAR_SLIDER_IMAGE, m_SliderRight, 3, 3);

        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SCROLLBAR_BUTTON_IMAGE, TempBmp, 6, 1);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn2.PicNormal.Bitmap.Assign(TempBmp);
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SCROLLBAR_BUTTON_IMAGE, TempBmp, 6, 2);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn2.PicMouseOn.Bitmap.Assign(TempBmp);
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SCROLLBAR_BUTTON_IMAGE, TempBmp, 6, 3);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn2.PicMouseDown.Bitmap.Assign(TempBmp);
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SCROLLBAR_BUTTON_IMAGE, TempBmp, 6, 4);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn1.PicNormal.Bitmap.Assign(TempBmp);
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SCROLLBAR_BUTTON_IMAGE, TempBmp, 6, 5);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn1.PicMouseOn.Bitmap.Assign(TempBmp);
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_SCROLLBAR_BUTTON_IMAGE, TempBmp, 6, 6);
        if m_Orientation = suiHorizontal then
            RoundPicture(TempBmp);
        m_Btn1.PicMouseDown.Bitmap.Assign(TempBmp);
    end;

    TempBmp.Free();

    if m_Orientation = suiVertical then
    begin
        RoundPicture3(m_SliderLeft);
        RoundPicture3(m_SliderCenter);
        RoundPicture3(m_SliderRight);
    end;

    m_Btn1.AutoSize := true;
    m_Btn2.AutoSize := true;
    Repaint();
end;

procedure TsuiScrollBar.UpdateSliderPic;
var
    Buf : TBitmap;
    TempPageSize : Integer;
    R, DR, SR : TRect;
    OutUIStyle : TsuiUIStyle;
    H, L : Integer;
    B : Boolean;
begin
    B := false;
    Buf := TBitmap.Create();

    if m_Orientation = suiVertical then
        Buf.Width := m_SliderLeft.Width
    else
        Buf.Height := m_SliderLeft.Height;

    if m_LineButton <= 0 then
    begin
        TempPageSize := PageSize;
        if (TempPageSize < 10) or (TempPageSize > 100) then
            TempPageSize := 10;

        if m_Orientation = suiVertical then
        begin
            if m_TrackBar.Height > 0 then
                Buf.Height := (TempPageSize * m_TrackBar.Height div 100)
        end
        else
        begin
            if m_TrackBar.Width > 0 then
                Buf.Width := (TempPageSize * m_TrackBar.Width div 100)
        end;
    end
    else
    begin
        if m_LineButton < 16 then
            m_LineButton := 16;
        if m_Orientation = suiVertical then
            Buf.Height := m_LineButton
        else
            Buf.Width := m_LineButton;
    end;

    Buf.Canvas.Draw(0, 0, m_SliderLeft);
    if m_Orientation = suiVertical then
    begin
        if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        begin
            B := true;
            DR := Rect(0, Buf.Height - 3, Buf.Width, Buf.Height);
            SR := Rect(0, m_SliderRight.Height - 3, m_SliderRight.Width, m_SliderRight.Height);
            Buf.Canvas.CopyRect(DR, m_SliderRight.Canvas, SR);
            H := Buf.Height - 6;
            if H < m_SliderCenter.Height then
            begin
                R := Rect(0, 3, Buf.Width, Buf.Height - 3);
                ResizeImage(m_SliderCenter, Buf.Canvas, R);
            end
            else
            begin
                L := 3 + (H - m_SliderCenter.Height) div 2;
                Buf.Canvas.Draw(0, L, m_SliderCenter);
                DR := Rect(0, 3, Buf.Width, L);
                SR := Rect(0, 3, m_SliderLeft.Width, m_SliderLeft.Height);
                Buf.Canvas.CopyRect(DR, m_SliderLeft.Canvas, SR);
                DR := Rect(0, L + m_SliderCenter.Height, Buf.Width, Buf.Height - 3);
                SR := Rect(0, 0, m_SliderRight.Width, m_SliderRight.Height - 3);
                Buf.Canvas.CopyRect(DR, m_SliderRight.Canvas, SR);
            end; 
        end
        else
        begin
            R := Rect(0, m_SliderLeft.Height, Buf.Width, Buf.Height - m_SliderRight.Height);
            Buf.Canvas.Draw(0, R.Bottom, m_SliderRight);
        end;
    end
    else
    begin
        if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        begin
            B := true;
            DR := Rect(Buf.Width - 3, 0, Buf.Width, Buf.Height);
            SR := Rect(m_SliderRight.Width - 3, 0, m_SliderRight.Width, m_SliderRight.Height);
            Buf.Canvas.CopyRect(DR, m_SliderRight.Canvas, SR);
            H := Buf.Width - 6;
            if H < m_SliderCenter.Width then
            begin
                R := Rect(3, 0, Buf.Width - 3, Buf.Height);
                ResizeImage(m_SliderCenter, Buf.Canvas, R);
            end
            else
            begin
                L := 3 + (H - m_SliderCenter.Width) div 2;
                Buf.Canvas.Draw(L, 0, m_SliderCenter);
                DR := Rect(3, 0, L, Buf.Height);
                SR := Rect(3, 0, m_SliderLeft.Width, m_SliderLeft.Height);
                Buf.Canvas.CopyRect(DR, m_SliderLeft.Canvas, SR);
                DR := Rect(L + m_SliderCenter.Width, 0, Buf.Width - 3, Buf.Height);
                SR := Rect(0, 0, m_SliderRight.Width - 3, m_SliderRight.Height);
                Buf.Canvas.CopyRect(DR, m_SliderRight.Canvas, SR);
            end;
        end
        else
        begin
            R := Rect(m_SliderLeft.Width, 0, Buf.Width - m_SliderRight.Width, Buf.Height);
            Buf.Canvas.Draw(R.Right, 0, m_SliderRight);
        end;
    end;

    if not B then
        Buf.Canvas.StretchDraw(R, m_SliderCenter);

    m_TrackBar.SliderImage.Bitmap.Assign(Buf);
    m_TrackBar.UpdateSliderSize();

    Buf.Free();
end;

procedure TsuiScrollBar.WMERASEBKGND(var Msg: TMessage);
begin
    // do nothing
end;

procedure TsuiScrollBar.WMSIZE(var Msg: TMessage);
begin
    inherited;

    PlaceTrackBarAndButton();
end;

end.

////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIProgressBar.pas
//  Creator     :   Shen Min
//  Date        :   2002-05-27 V1
//                  2006-06-14 V6
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIProgressBar;

interface

{$I SUIPack.inc}

uses Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, ComCtrls,
     Graphics, Forms, Math,
     SUIPublic, SUIThemes, SUIMgr, SUI2Define;

type
    TsuiProgressBarOrientation = (suiHorizontal, suiVertical);

    TsuiProgressBar = class(TCustomPanel)
    private
        m_Max : Integer;
        m_Min : Integer;
        m_Position : Integer;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;        
        m_Orientation : TsuiProgressBarOrientation;
        m_BorderColor : TColor;
        m_Color : TColor;
        m_Picture : TPicture;
        m_ShowCaption : Boolean;
        m_CaptionColor : TColor;
        m_SmartShowCaption : Boolean;
        m_SelfChanging : Boolean;
        m_B1, m_B2, m_B3 : TBitmap;

        procedure SetMax(const Value: Integer);
        procedure SetMin(const Value: Integer);
        procedure SetPosition(const Value: Integer);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure SetOrientation(const Value: TsuiProgressBarOrientation);
        procedure SetColor(const Value: TColor);
        procedure SetBorderColor(const Value: TColor);
        procedure SetPicture(const Value: TPicture);
        procedure SetShowCaption(const Value: Boolean);
        procedure SetCaptionColor(const Value: TColor);
        procedure SetSmartShowCaption(const Value: Boolean);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        
        procedure UpdateProgress();
        procedure UpdatePicture();
        function GetWidthFromPosition(nWidth : Integer) : Integer;
        function GetPercentFromPosition() : Integer;
        procedure WMERASEBKGND(var Msg : TMessage); message WM_ERASEBKGND;
        procedure OnPicChange(Sender : TObject);

    protected
        procedure Paint(); override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;                

    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy(); override;

        procedure StepBy(Delta : Integer);
        procedure StepIt();

    published
        property Anchors;
        property BiDiMode;
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;                    
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property CaptionColor : TColor read m_CaptionColor write SetCaptionColor;
        property ShowCaption : Boolean read m_ShowCaption write SetShowCaption;
        property SmartShowCaption : Boolean read m_SmartShowCaption write SetSmartShowCaption;
        property Max : Integer read m_Max write SetMax;
        property Min : Integer read m_Min write SetMin;
        property Position : Integer read m_Position write SetPosition;
        property Orientation : TsuiProgressBarOrientation read m_Orientation write SetOrientation;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;
        property Color : TColor read m_Color write SetColor;
        property Picture : TPicture read m_Picture write SetPicture;
        property Visible;

        property OnMouseDown;
        property OnMouseMove;
        property OnMouseUp;
        
        property OnClick;

    end;

implementation

uses SUIForm;

{ TsuiProgressBar }

constructor TsuiProgressBar.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle - [csAcceptsControls];
    m_Picture := TPicture.Create();
    m_Picture.OnChange := OnPicChange;
    m_SelfChanging := false;

    m_B1 := nil;
    m_B2 := nil;
    m_B3 := nil;

    m_Min := 0;
    m_Max := 100;
    m_Position := 50;
    m_Orientation := suiHorizontal;
    m_BorderColor := clBlack;
    m_Color := clBtnFace;
    m_CaptionColor := clBlack;

    Height := 12;
    Width := 150;
    Caption := '50%';
    m_ShowCaption := true;
    Color := clBtnFace;

    UIStyle := GetSUIFormStyle(AOwner);

    UpdateProgress();
end;

destructor TsuiProgressBar.Destroy;
begin
    m_Picture.Free();
    m_Picture := nil;

    if m_B1 <> nil then
    begin
        m_B1.Free();
        m_B1 := nil;
    end;

    if m_B2 <> nil then
    begin
        m_B2.Free();
        m_B2 := nil;
    end;

    if m_B3 <> nil then
    begin
        m_B3.Free();
        m_B3 := nil;
    end;

    inherited;
end;

function TsuiProgressBar.GetPercentFromPosition: Integer;
begin
    if m_Max <> m_Min then
        Result := Trunc((m_Position - m_Min) / (m_Max - m_Min) * 100)
    else
        Result := 0;
end;

function TsuiProgressBar.GetWidthFromPosition(nWidth : Integer): Integer;
begin
    Result := 0;

    if (
        (m_Max <= m_Min) or
        (m_Position <= m_Min)
    ) then
        Exit;

    Result := nWidth;
    if m_Position > m_Max then
        Exit;

    Result := Trunc((m_Position - m_Min) / (m_Max - m_Min) * nWidth);
end;

procedure TsuiProgressBar.Notification(AComponent: TComponent;
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

procedure TsuiProgressBar.OnPicChange(Sender: TObject);
begin
    Repaint();
end;

procedure SpitDrawVertical(Source : TBitmap; ACanvas : TCanvas; ARect : TRect; BorderWidth : Integer);
var
    R, SR : TRect;
    H : Integer;
begin
    if ARect.Left < 0 then
        Exit;
    Source.PixelFormat := pf24Bit;
    if BorderWidth = 0 then
        BorderWidth := Source.Height div 3;
    H := ARect.Bottom - ARect.Top;

    SR := Rect(0, 0, Source.Width, Min(H, BorderWidth));
    R := Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Top + Min(BorderWidth, H));
    ACanvas.CopyRect(R, Source.Canvas, SR);

    SR := Rect(0, Source.Height - BorderWidth, Source.Width, Source.Height);
    R := Rect(ARect.Left, ARect.Bottom - BorderWidth, ARect.Right, ARect.Bottom);
    ACanvas.CopyRect(R, Source.Canvas, SR);

    SR := Rect(0, BorderWidth, Source.Width, Source.Height - BorderWidth);
    R := Rect(ARect.Left, ARect.Top + BorderWidth, ARect.Right, ARect.Bottom - BorderWidth);
    ACanvas.CopyRect(R, Source.Canvas, SR);
end;

procedure SpitDrawHorizontal(Source : TBitmap; ACanvas : TCanvas; ARect : TRect; BorderWidth : Integer);
var
    R, SR : TRect;
    H : Integer;
begin
    if ARect.Left < 0 then
        Exit;
    Source.PixelFormat := pf24Bit;        
    H := ARect.Right - ARect.Left;

    SR := Rect(0, 0, Min(H, BorderWidth), Source.Height);
    R := Rect(ARect.Left, ARect.Top, ARect.Left + Min(BorderWidth, H), ARect.Bottom);
    ACanvas.CopyRect(R, Source.Canvas, SR);

    SR := Rect(Source.Width - BorderWidth, 0, Source.Width, Source.Height);
    R := Rect(ARect.Right - BorderWidth, ARect.Top, ARect.Right, ARect.Bottom);
    ACanvas.CopyRect(R, Source.Canvas, SR);

    SR := Rect(BorderWidth, 0, Source.Width - BorderWidth, Source.Height);
    R := Rect(ARect.Left + BorderWidth, ARect.Top, ARect.Right - BorderWidth, ARect.Bottom);
    ACanvas.CopyRect(R, Source.Canvas, SR);
end;

procedure TsuiProgressBar.Paint;
var
    nProgressWidth : Integer;
    Buf : TBitmap;
    R : TRect;
    OutUIStyle : TsuiUIStyle;
    B : Boolean;
begin
    Buf := TBitmap.Create();
    Buf.Width := ClientWidth;
    Buf.Height := ClientHeight;

    if m_Orientation = suiHorizontal then
    begin
        if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) and (m_B1 <> nil) and (m_B2 <> nil) and (m_B3 <> nil) then
        begin
            Buf.Canvas.Brush.Color := Color;
            Buf.Canvas.FillRect(ClientRect);
            R := Rect(0, 0, Buf.Width, Buf.Height);

            Inc(R.Left, m_B1.Width);
            Dec(R.Right, m_B3.Width);
            R.Right := GetWidthFromPosition(Buf.Width - m_B1.Width - m_B3.Width) + m_B1.Width;

            SpitDrawVertical(m_B1, Buf.Canvas, Rect(0, R.Top, R.Left, R.Bottom), 2);
            SpitDrawVertical(m_Picture.Bitmap, Buf.Canvas, R, 2);
            R := Rect(R.Right, R.Top, Buf.Width - m_B3.Width, R.Bottom);
            SpitDrawVertical(m_B2, Buf.Canvas, R, 2);
            R := Rect(Buf.Width - m_B3.Width, R.Top, Buf.Width, R.Bottom);
            SpitDrawVertical(m_B3, Buf.Canvas, R, 2);
            B := true;
        end
        else
        begin
            nProgressWidth := GetWidthFromPosition(Buf.Width - 1);
            if nProgressWidth = 0 then
                Inc(nProgressWidth);

            if m_Picture.Graphic <> nil then
            begin
                R := Rect(1, 1, nProgressWidth, Buf.Height - 1);
                Buf.Canvas.StretchDraw(R, m_Picture.Graphic);
            end;

            Buf.Canvas.Brush.Color := m_Color;
            R := Rect(nProgressWidth, 1, Buf.Width - 1, Buf.Height - 1);
            Buf.Canvas.FillRect(R);
            B := false;
        end;
    end
    else
    begin
        if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) and (m_B1 <> nil) and (m_B2 <> nil) and (m_B3 <> nil) then
        begin
            Buf.Canvas.Brush.Color := Color;
            Buf.Canvas.FillRect(ClientRect);
            R := Rect(0, 0, Buf.Width, Buf.Height);

            Dec(R.Bottom, m_B1.Height);
            Inc(R.Top, m_B3.Height);
            R.Top := Buf.Height - m_B3.Height - GetWidthFromPosition(Buf.Height - m_B3.Height - m_B1.Height);

            SpitDrawHorizontal(m_B1, Buf.Canvas, Rect(0, R.Bottom, R.Right, R.Bottom + m_B1.Height), 2);
            SpitDrawHorizontal(m_Picture.Bitmap, Buf.Canvas, R, 2);
            R := Rect(R.Left, m_B3.Height, R.Right, R.Top);
            SpitDrawHorizontal(m_B2, Buf.Canvas, R, 2);
            R := Rect(R.Left, 0, R.Right, m_B3.Height);
            SpitDrawHorizontal(m_B3, Buf.Canvas, R, 2);
            B := true;
        end
        else
        begin
            nProgressWidth := Buf.Height - 1 - GetWidthFromPosition(Buf.Height - 1);
            if nProgressWidth = 0 then
                Inc(nProgressWidth);

            if m_Picture.Graphic <> nil then
            begin
                R := Rect(1, Buf.Height - 2, Buf.Width - 1, nProgressWidth - 1);
                Buf.Canvas.StretchDraw(R, m_Picture.Graphic);
            end;

            Buf.Canvas.Brush.Color := m_Color;
            R := Rect(1, nProgressWidth, Buf.Width - 1, 1);
            Buf.Canvas.FillRect(R);
            m_ShowCaption := false;
            B := false;
        end;
    end;

    if m_ShowCaption then
    begin
        Buf.Canvas.Font.Color := m_CaptionColor;
        Buf.Canvas.Brush.Style := bsClear;
        if m_SmartShowCaption and (m_Position = m_Min) then
        else
            Buf.Canvas.TextOut(((Buf.Width - Buf.Canvas.TextWidth(Caption)) div 2), (Buf.Height - Buf.Canvas.TextHeight(Caption)) div 2, Caption);
    end;

    if not B then
    begin
        Buf.Canvas.Brush.Color := m_BorderColor;
        Buf.Canvas.FrameRect(ClientRect);
    end;

    BitBlt(Canvas.Handle, 0, 0, Buf.Width, Buf.Height, Buf.Canvas.Handle, 0, 0, SRCCOPY);
    Buf.Free();
end;

procedure TsuiProgressBar.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;

    Repaint();
end;

procedure TsuiProgressBar.SetCaptionColor(const Value: TColor);
begin
    m_CaptionColor := Value;

    Repaint();
end;

procedure TsuiProgressBar.SetColor(const Value: TColor);
begin
    m_Color := Value;

    Repaint();
end;

procedure TsuiProgressBar.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiProgressBar.SetMax(const Value: Integer);
begin
    m_Max := Value;

    UpdateProgress();
end;

procedure TsuiProgressBar.SetMin(const Value: Integer);
begin
    m_Min := Value;

    UpdateProgress();
end;

procedure TsuiProgressBar.SetOrientation(
  const Value: TsuiProgressBarOrientation);
begin
    m_Orientation := Value;

    UpdatePicture();
end;

procedure TsuiProgressBar.SetPicture(const Value: TPicture);
begin
    m_Picture.Assign(Value);

    Repaint();
end;

procedure TsuiProgressBar.SetPosition(const Value: Integer);
begin
    m_Position := Value;

    UpdateProgress();
end;

procedure TsuiProgressBar.SetShowCaption(const Value: Boolean);
begin
    m_ShowCaption := Value;

    Repaint();
end;

procedure TsuiProgressBar.SetSmartShowCaption(const Value: Boolean);
begin
    m_SmartShowCaption := Value;

    Repaint();
end;

procedure TsuiProgressBar.SetUIStyle(const Value: TsuiUIStyle);
begin
    m_UIStyle := Value;

    UpdatePicture();
end;

procedure TsuiProgressBar.StepBy(Delta: Integer);
begin
    Position := Position + Delta;
end;

procedure TsuiProgressBar.StepIt;
begin
    Position := Position + 1;
end;

procedure TsuiProgressBar.UpdatePicture;
var
    OutUIStyle : TsuiUIStyle;
    TempBuf : TBitmap;
begin
    m_SelfChanging := true;
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        m_Picture.Bitmap.Assign(m_FileTheme.GetBitmap(SKIN2_PROGRESSBAR2));
        Color := m_FileTheme.GetColor(SKIN2_CONTROLCOLOR);
        BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR);
        if m_B1 <> nil then
        begin
            m_B1.Free();
            m_B1 := nil;
        end;

        if m_B2 <> nil then
        begin
            m_B2.Free();
            m_B2 := nil;
        end;

        if m_B3 <> nil then
        begin
            m_B3.Free();
            m_B3 := nil;
        end;
        m_B1 := TBitmap.Create();
        m_B1.PixelFormat := pf24Bit;
        m_B1.Assign(m_FileTheme.GetBitmap(SKIN2_PROGRESSBAR1));
        m_B2 := TBitmap.Create();
        m_B2.PixelFormat := pf24Bit;
        m_B2.Assign(m_FileTheme.GetBitmap(SKIN2_PROGRESSBAR3));
        m_B3 := TBitmap.Create();
        m_B3.PixelFormat := pf24Bit;
        m_B3.Assign(m_FileTheme.GetBitmap(SKIN2_PROGRESSBAR4));

        if Orientation = suiVertical then
        begin
            RoundPicture(m_B1);
            RoundPicture(m_B2);
            RoundPicture(m_B3);            
        end;
    end
    else
    begin
        GetInsideThemeBitmap(OutUIStyle, SUI_THEME_PROGRESSBAR_IMAGE, m_Picture.Bitmap);
        Color := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BACKGROUND_COLOR);
        BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);
    end;

    if m_Orientation = suiVertical then
    begin
        TempBuf := TBitmap.Create();
        TempBuf.Assign(m_Picture.Bitmap);
        RoundPicture(TempBuf);
        m_Picture.Bitmap.Assign(TempBuf);
        TempBuf.Free();
    end;
    m_SelfChanging := false;
    Repaint();
end;

procedure TsuiProgressBar.UpdateProgress;
begin
    Caption := IntToStr(GetPercentFromPosition()) + '%';

    Repaint();
end;

procedure TsuiProgressBar.WMERASEBKGND(var Msg: TMessage);
begin
    // Do nothing
end;

end.

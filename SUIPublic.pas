////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIPublic.pas
//  Creator     :   Shen Min
//  Date        :   2002-05-24
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIPublic;

interface

{$I SUIPack.inc}

uses Windows, Graphics, Controls, Messages, Classes, Forms, SysUtils,
     TypInfo, Math, Dialogs,
     SUIThemes, SUIMgr;

const
    SUI_ENTER = #13 + #10;
    SUI_2ENTER = SUI_ENTER + SUI_ENTER;


    procedure DoTrans(Canvas : TCanvas; Control : TWinControl);
    procedure TileDraw(const Canvas : TCanvas; const Picture : TPicture; const Rect : TRect);
    procedure SetWinControlTransparent(Control : TWinControl);
    procedure SpitBitmap(Source, Dest : TBitmap; Count, Index : Integer);
    procedure SpitDraw(Source : TBitmap; ACanvas : TCanvas; ARect : TRect; ATransparent : Boolean);
    procedure SpitDrawHorizontal(Source : TBitmap; ACanvas : TCanvas; ARect : TRect; ATransparent : Boolean; BGColor : TColor; SampleTopPt : Boolean = true);
    procedure SpitDrawHorizontal2(Source : TBitmap; ACanvas : TCanvas; ARect : TRect; ATransparent : Boolean; ATransColor : TColor);
    procedure DrawHorizontalGradient(const ACanvas : TCanvas; const ARect : TRect; const BeginColor, EndColor : TColor);
    procedure DrawVerticalGradient(const ACanvas : TCanvas; const ARect : TRect; const BeginColor, EndColor : TColor);

    procedure GetCaptionFont(const Font : TFont);
    function FormatStringWithWidth(Canvas: TCanvas; const szPath: string; nWidth: Integer): string;        

    procedure DrawControlBorder(WinControl : TWinControl; BorderColor, Color : TColor; DrawColor : Boolean = true);
    procedure RoundPicture(SrcBuf : TBitmap);
    procedure RoundPicture2(SrcBuf : TBitmap);
    procedure RoundPicture3(SrcBuf : TBitmap);

    procedure SetBitmapWindow(HandleOfWnd : HWND; const Bitmap : TBitmap; TransColor : TColor);

    function InRect(Point : TPoint; Rect : TRect) : Boolean; overload;
    function InRect(X, Y : Integer; Rect : TRect) : Boolean; overload;

    procedure PlaceControl(const Control : TControl; const Position : TPoint); overload;
    procedure PlaceControl(const Control : TControl; const Rect : TRect); overload;

    function GetWorkAreaRect() : TRect;
    function IsWinXP() : Boolean;
    function IsWinVista() : Boolean;

    function IsHasProperty(AComponent : TComponent; ApropertyName : String) : Boolean;
    function FormHasFocus(Form: TCustomForm): boolean;
    function PCharToStr(pstr : PChar) : String;

    procedure ContainerApplyUIStyle(Container : TWinControl; UIStyle : TsuiUIStyle; FileTheme : TsuiFileTheme);

    function SUIGetScrollBarInfo(Handle : THandle; idObject : Integer; var ScrollInfo : tagScrollBarInfo) : Boolean; stdcall;
    function SUIGetComboBoxInfo(hwndCombo: HWND; var pcbi: TComboBoxInfo): Boolean; stdcall;
    function SUIAnimateWindow(hWnd: HWND; dwTime: DWORD; dwFlags: DWORD): Boolean; stdcall;

    procedure ScanColor(const Bmp : TBitmap; SrcColor, TgtColor : TColor);
    procedure ResizeImage(SrcBmp : TBitmap; tgtCanvas: TCanvas; tgtRect: TRect);

    function GetLocaleButtonCaption(Button: TMsgDlgBtn): string;

var
    g_SUIPackConverting : Boolean = false;

implementation

procedure ResizeImage(SrcBmp : TBitmap; tgtCanvas: TCanvas; tgtRect: TRect);
begin
    SetStretchBltMode(tgtCanvas.Handle, HALFTONE);
    StretchBlt(tgtCanvas.Handle, tgtRect.Left, tgtRect.Top, tgtRect.Right - tgtRect.Left, tgtRect.Bottom - tgtRect.Top, SrcBmp.Canvas.Handle, 0, 0, SrcBmp.Width, SrcBmp.Height, SRCCOPY);
end;

procedure ScanColor(const Bmp : TBitmap; SrcColor, TgtColor : TColor);
var
    i, j : Integer;
begin
    Bmp.PixelFormat := pf24Bit;
    for i := 0 to Bmp.Width - 1 do
    begin
        for j := 0 to Bmp.Height - 1 do
        begin
            if Bmp.Canvas.Pixels[i, j] = SrcColor then
                Bmp.Canvas.Pixels[i, j] := TgtColor;
        end;
    end;
end;

procedure DoTrans(Canvas : TCanvas; Control : TWinControl);
var
    DC : HDC;
    SaveIndex : HDC;
    Position: TPoint;
begin
    if Control.Parent <> nil then
    begin
{$R-}
        DC := Canvas.Handle;
        SaveIndex := SaveDC(DC);
        GetViewportOrgEx(DC, Position);
        SetViewportOrgEx(DC, Position.X - Control.Left, Position.Y - Control.Top, nil);
        IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth, Control.Parent.ClientHeight);
        Control.Parent.Perform(WM_ERASEBKGND, DC, 0);
        Control.Parent.Perform(WM_PAINT, DC, 0);
        RestoreDC(DC, SaveIndex);
{$R+}
    end;
end;

procedure TileDraw(const Canvas : TCanvas; const Picture : TPicture; const Rect : TRect);
var
    i, j : Integer;
begin
    i := 0;
    While i < (Rect.Right - Rect.Left) + Picture.Width do
    begin
        j := 0;
        While j < (Rect.Bottom - Rect.Top) + Picture.Height do
        begin
            Canvas.Draw(i, j, Picture.Graphic);
            Inc(j, Picture.Height);
        end;
        Inc(i, Picture.Width);
    end;
end;

procedure SetWinControlTransparent(Control : TWinControl);
var
    WinStyle : DWORD;
begin
    Control.ControlStyle := Control.ControlStyle - [csOpaque];

    WinStyle := GetWindowLong(Control.Handle, GWL_EXSTYLE );
    WinStyle := WinStyle or WS_EX_TRANSPARENT;
    SetWindowLong(Control.Handle, GWL_EXSTYLE, WinStyle);
end;

function InRect(Point : TPoint; Rect : TRect) : Boolean;
begin
    Result := InRect(Point.X, Point.Y, Rect);
end;

function InRect(X, Y : Integer; Rect : TRect) : Boolean;
begin
    Result := false;

    if (
        (X >= Rect.Left) and
        (X <= Rect.Right) and
        (Y >= Rect.Top) and
        (Y <= Rect.Bottom)
    )then
        Result := True
end;

function GetWorkAreaRect() : TRect;
begin
{$IFDEF SUIPACK_D6UP}
    if (Application = nil) or (Application.MainForm = nil) then
{$ENDIF}
        SystemParametersInfo(SPI_GETWORKAREA, 0, @Result, 0)
{$IFDEF SUIPACK_D6UP}
    else
        Result := Screen.MonitorFromWindow(Application.MainForm.Handle).WorkAreaRect;
{$ENDIF}
end;

procedure PlaceControl(const Control : TControl; const Position : TPoint);
begin
    Control.Left := Position.X;
    Control.Top := Position.Y;
end;

procedure PlaceControl(const Control : TControl; const Rect : TRect);
begin
    Control.Left := Rect.Left;
    Control.Top := Rect.Top;
    Control.Width := Rect.Right - Rect.Left;
    Control.Height := Rect.Bottom - Rect.Top;
end;

procedure SpitDraw(Source : TBitmap; ACanvas:TCanvas; ARect:TRect; ATransparent : Boolean);
var
    ImageList : TImageList;
    SR, DR, LR1, LR2, LR3, LR4 : TRect;
    TempBmp : TBitmap;
    TransColor : TColor;
    DW, DH : Integer;
    TempInt : Integer;
begin
    TransColor := clFuchsia;//Source.Canvas.Pixels[0, 0];
    DW := ARect.Right - ARect.Left;
    DH := ARect.Bottom - ARect.Top;

    // left-top
    SR := Rect(0, 0, Source.Width div 2, Source.Height div 2);
    DR := Rect(0, 0, DW div 2, DH div 2);
    TempBmp := TBitmap.Create();
    TempInt := Min(SR.Right - SR.Left, DR.Right - DR.Left);
    if TempInt < 0 then
        TempInt := 0;
    TempBmp.Width := TempInt;
    TempInt := Min(SR.Bottom - SR.Top, DR.Bottom - DR.Top);
    if TempInt < 0 then
        TempInt := 0;
    TempBmp.Height := TempInt;

    if (TempBmp.Height <> 0) and (TempBmp.Width <> 0) then
    begin
        if TempBmp.Width < (SR.Right - SR.Left) then
            SR.Right := SR.Right - (SR.Right - SR.Left) + TempBmp.Width;

        if TempBmp.Height < (SR.Bottom - SR.Top) then
            SR.Bottom := SR.Bottom - (SR.Bottom - SR.Top) + TempBmp.Height;

        TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, SR);
        ImageList := TImageList.CreateSize(TempBmp.Width, TempBmp.Height);
        if ATransparent then
            ImageList.AddMasked(TempBmp, TransColor)
        else
            ImageList.Add(TempBmp, nil);
        ImageList.Draw(ACanvas, 0, 0, 0);
        ImageList.Free();
        LR1 := Rect(0, 0, TempBmp.Width, TempBmp.Height);
    end;
    TempBmp.Free();

    // left-bottom
    SR := Rect(0, Source.Height - (Source.Height div 2) + 1, Source.Width div 2, Source.Height);
    DR := Rect(0, DH - (DH div 2) + 1, DW div 2, DH);
    TempBmp := TBitmap.Create();
    TempInt := Min(SR.Right - SR.Left, DR.Right - DR.Left);
    if TempInt < 0 then
        TempInt := 0;
    TempBmp.Width := TempInt;
    TempInt := Min(SR.Bottom - SR.Top, DR.Bottom - DR.Top);
    if TempInt < 0 then
        TempInt := 0;
    TempBmp.Height := TempInt;

    if (TempBmp.Height <> 0) and (TempBmp.Width <> 0) then
    begin
        if TempBmp.Height < (SR.Bottom - SR.Top) then
            SR.Top := SR.Top + (SR.Bottom - SR.Top) - TempBmp.Height;

        if TempBmp.Width < (SR.Right - SR.Left) then
            SR.Right := SR.Right - (SR.Right - SR.Left) + TempBmp.Width;

        TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, SR);
        ImageList := TImageList.CreateSize(TempBmp.Width, TempBmp.Height);
        if ATransparent then
            ImageList.AddMasked(TempBmp, TransColor)
        else
            ImageList.Add(TempBmp, nil);
        ImageList.Draw(ACanvas, 0, ARect.Bottom - TempBmp.Height, 0);
        ImageList.Free();
        LR2 := Rect(0, ARect.Bottom - TempBmp.Height, TempBmp.Width, ARect.Bottom);
    end;
    TempBmp.Free();

    // left-center
    SR := Rect(0, Source.Height div 2, Source.Width div 2, Source.Height - (Source.Height div 2));
    DR := Rect(0, LR1.Bottom, LR1.Right, LR2.Top);

    TempBmp := TBitmap.Create();
    TempBmp.Width := DR.Right - DR.Left;
    TempBmp.Height := DR.Bottom - DR.Top;

    if (TempBmp.Height <> 0) and (TempBmp.Width <> 0) then
    begin
        if TempBmp.Width < (SR.Right - SR.Left) then
            SR.Right := SR.Right - (SR.Right - SR.Left) + TempBmp.Width;

        TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, SR);
        TempBmp.TransparentColor := TransColor;
        TempBmp.Transparent := true;
        ACanvas.StretchDraw(DR, TempBmp);
    end;
    TempBmp.Free();

    // right-top
    SR := Rect(Source.Width - (Source.Width div 2) + 1, 0, Source.Width, Source.Height div 2);
    DR := Rect(DW - (DW div 2) + 1, 0, DW, DH div 2);
    TempBmp := TBitmap.Create();
    TempInt := Min(SR.Right - SR.Left, DR.Right - DR.Left);
    if TempInt < 0 then
        TempInt := 0;
    TempBmp.Width := TempInt;
    TempInt := Min(SR.Bottom - SR.Top, DR.Bottom - DR.Top);
    if TempInt < 0 then
        TempInt := 0;
    TempBmp.Height := TempInt;

    if (TempBmp.Height <> 0) and (TempBmp.Width <> 0) then
    begin
        if TempBmp.Width < (SR.Right - SR.Left) then
            SR.Left := SR.Left + (SR.Right - SR.Left) - TempBmp.Width;

        if TempBmp.Height < (SR.Bottom - SR.Top) then
            SR.Bottom := SR.Bottom - (SR.Bottom - SR.Top) + TempBmp.Height;

        TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, SR);
        ImageList := TImageList.CreateSize(TempBmp.Width, TempBmp.Height);
        if ATransparent then
            ImageList.AddMasked(TempBmp, TransColor)
        else
            ImageList.Add(TempBmp, nil);
        ImageList.Draw(ACanvas, ARect.Right - TempBmp.Width, 0, 0);
        ImageList.Free();
        LR3 := Rect(ARect.Right - TempBmp.Width, 0, ARect.Right, TempBmp.Height)
    end;
    TempBmp.Free();

    // right-bottom
    SR := Rect(Source.Width - (Source.Width div 2) + 1, Source.Height - (Source.Height div 2) + 1, Source.Width, Source.Height);
    DR := Rect(DW - (DW div 2) + 1, DH - (DH div 2) + 1, DW, DH);
    TempBmp := TBitmap.Create();
    TempInt := Min(SR.Right - SR.Left, DR.Right - DR.Left);
    if TempInt < 0 then
        TempInt := 0;
    TempBmp.Width := TempInt;
    TempInt := Min(SR.Bottom - SR.Top, DR.Bottom - DR.Top);
    if TempInt < 0 then
        TempInt := 0;
    TempBmp.Height := TempInt;

    if (TempBmp.Height <> 0) and (TempBmp.Width <> 0) then
    begin
        if TempBmp.Width < (SR.Right - SR.Left) then
            SR.Left := SR.Left + (SR.Right - SR.Left) - TempBmp.Width;

        if TempBmp.Height < (SR.Bottom - SR.Top) then
            SR.Top := SR.Top + (SR.Bottom - SR.Top) - TempBmp.Height;

        TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, SR);
        ImageList := TImageList.CreateSize(TempBmp.Width, TempBmp.Height);
        if ATransparent then
            ImageList.AddMasked(TempBmp, TransColor)
        else
            ImageList.Add(TempBmp, nil);
        ImageList.Draw(ACanvas, ARect.Right - TempBmp.Width, ARect.Bottom - TempBmp.Height, 0);
        ImageList.Free();
        LR4 := Rect(ARect.Right - TempBmp.Width, ARect.Bottom - TempBmp.Height, ARect.Right, ARect.Bottom);
    end;
    TempBmp.Free();

    // right-center
    SR := Rect(Source.Width - (Source.Width div 2) + 1, Source.Height - (Source.Height div 2), Source.Width, Source.Height div 2 + 2);
    DR := Rect(LR3.Left, LR3.Bottom, LR3.Right, LR4.Top);

    TempBmp := TBitmap.Create();
    TempBmp.Width := DR.Right - DR.Left;
    TempBmp.Height := DR.Bottom - DR.Top;

    if (TempBmp.Height <> 0) and (TempBmp.Width <> 0) then
    begin
        if TempBmp.Width < (SR.Right - SR.Left) then
            SR.Left := SR.Left + (SR.Right - SR.Left) - TempBmp.Width;

        TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, SR);
        TempBmp.TransparentColor := TransColor;
        TempBmp.Transparent := true;
        ACanvas.StretchDraw(DR, TempBmp);
    end;
    TempBmp.Free();

    // center-top
    SR := Rect(Source.Width div 2, 0, Source.Width - (Source.Width div 2) + 1, Source.Height div 2);
    DR := Rect(LR1.Right, 0, LR3.Left, LR1.Bottom);
    TempBmp := TBitmap.Create();
    TempBmp.Width := DR.Right - DR.Left;
    TempBmp.Height := DR.Bottom - DR.Top;

    if (TempBmp.Height <> 0) and (TempBmp.Width <> 0) then
    begin
        if TempBmp.Height < (SR.Bottom - SR.Top) then
            SR.Bottom := SR.Bottom - (SR.Bottom - SR.Top) + TempBmp.Height;

        TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, SR);
        TempBmp.TransparentColor := TransColor;
        TempBmp.Transparent := true;
        ACanvas.StretchDraw(DR, TempBmp);
    end;
    TempBmp.Free();

    // center-center
    SR := Rect(Source.Width div 2, Source.Height div 2, Source.Width - (Source.Width div 2) + 1, Source.Height - (Source.Height div 2));
    DR := Rect(LR1.Right, LR1.Bottom, LR3.Left, LR4.Top - 1);
    TempBmp := TBitmap.Create();
    TempBmp.Width := DR.Right - DR.Left;
    TempBmp.Height := DR.Bottom - DR.Top;

    if (TempBmp.Height <> 0) and (TempBmp.Width <> 0) then
    begin
        TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, SR);
        TempBmp.TransparentColor := TransColor;
        TempBmp.Transparent := true;
        ACanvas.StretchDraw(DR, TempBmp);
    end;
    TempBmp.Free();

    // center-bottom
    SR := Rect(Source.Width div 2, Source.Height - (Source.Height div 2), Source.Width - (Source.Width div 2) + 1, Source.Height);
    DR := Rect(LR1.Right - 1, LR2.Top - 1, LR4.Left, LR4.Bottom);
    TempBmp := TBitmap.Create();
    TempBmp.Width := DR.Right - DR.Left;
    TempBmp.Height := DR.Bottom - DR.Top;

    if (TempBmp.Height <> 0) and (TempBmp.Width <> 0) then
    begin
        if TempBmp.Height < (SR.Bottom - SR.Top) then
            SR.Top := SR.Top + (SR.Bottom - SR.Top) - TempBmp.Height;

        TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, SR);
        TempBmp.TransparentColor := TransColor;
        TempBmp.Transparent := true;
        ACanvas.StretchDraw(DR, TempBmp);
    end;
    TempBmp.Free();
end;

procedure DrawControlBorder(WinControl : TWinControl; BorderColor, Color : TColor; DrawColor : Boolean = true);
var
    DC : HDC;
    Brush : HBRUSH;
    R: TRect;
begin
    DC := GetWindowDC(WinControl.Handle);

    GetWindowRect(WinControl.Handle, R);
    OffsetRect(R, -R.Left, -R.Top);

    Brush := CreateSolidBrush(ColorToRGB(BorderColor));
    FrameRect(DC, R, Brush);
    DeleteObject(Brush);

    if DrawColor then
    begin
        Brush := CreateSolidBrush(ColorToRGB(Color));
        R := Rect(R.Left + 1, R.Top + 1, R.Right - 1, R.Bottom - 1);
        FrameRect(DC, R, Brush);
        DeleteObject(Brush);
    end;

    ReleaseDC(WinControl.Handle, DC);
end;

{$WARNINGS OFF}
function PCharToStr(pstr : PChar) : String;
begin
    if StrLen(pstr) = 0 then
        Result := ''
    else
    begin
        Result := pstr;
        SetLength(Result, StrLen(pstr));
    end;
end;
{$WARNINGS ON}

procedure SetBitmapWindow(HandleOfWnd : HWND; const Bitmap : TBitmap; TransColor : TColor);
var
    i, j : Integer;
    Left, Right : Integer;
    PreWhite : Boolean;
    TempRgn : HRgn;
    Rgn : HRgn;
begin
    Rgn := CreateRectRgn(0, 0, 0, 0);

    for i := 0 to Bitmap.Height - 1 do
    begin
        Left := 0;
        Right := 0;
        PreWhite := true;

        for j := 0 to Bitmap.Width - 1 do
        begin
            if (
                (Bitmap.Canvas.Pixels[j, i] = TransColor) or
                (j = Bitmap.Width - 1)
            ) then
            begin
                if (not PreWhite) then
                begin
                    TempRgn := CreateRectRgn(Left, i, Right + 1, i + 1);
                    CombineRgn(Rgn, Rgn, TempRgn, RGN_OR);
                    DeleteObject(TempRgn);
                end;
                PreWhite := true;
            end
            else
            begin
                if PreWhite then
                begin
                    Left := j;
                    Right := j;
                end
                else
                    Inc(Right);
                PreWhite := false;
            end;
        end;
    end;

    SetWindowRgn(HandleOfWnd, Rgn, true);
    DeleteObject(Rgn);
end;

procedure SpitDrawHorizontal(Source : TBitmap; ACanvas : TCanvas; ARect : TRect; ATransparent : Boolean; BGColor : TColor; SampleTopPt : Boolean);
var
    ImageList : TImageList;
    TransColor : TColor;
    R : TRect;
    TempBuf : TBitmap;
begin
    if SampleTopPt then
        TransColor := Source.Canvas.Pixels[0, 0]
    else
        TransColor := Source.Canvas.Pixels[0, Source.Height - 1];
    ImageList := TImageList.Create(nil);
    ImageList.Height := Source.Height;
    ImageList.Width := Source.Width div 3;
    if ATransparent then
        ImageList.AddMasked(Source, TransColor)
    else
        ImageList.AddMasked(Source, clFuchsia);

    if ARect.Right - ARect.Left < ImageList.Width then
    begin
        TempBuf := TBitmap.Create();
        TempBuf.Width := ARect.Right - ARect.Left;
        ImageList.Draw(TempBuf.Canvas, 0, 0, 0);
        ACanvas.Draw(ARect.Left, ARect.Top, TempBuf);
        TempBuf.Free();
    end
    else
    begin
        ImageList.Draw(ACanvas, ARect.Left, ARect.Top, 0);
        ImageList.Draw(ACanvas, ARect.Right - ImageList.Width, ARect.Top, 2);
        R := Rect(ARect.Left + ImageList.Width, ARect.Top, ARect.Right - ImageList.Width, ARect.Bottom);
        TempBuf := TBitmap.Create();
        TempBuf.Height := Source.Height;
        TempBuf.Width := ImageList.Width;
        TempBuf.Canvas.Brush.Color := BGColor;
        TempBuf.Canvas.FillRect(Rect(0, 0, TempBuf.Width, TempBuf.Height));
        ImageList.GetBitmap(1, TempBuf);
        ACanvas.StretchDraw(R, TempBuf);
        TempBuf.Free();
    end;

    ImageList.Free();    
end;

procedure SpitDrawHorizontal2(Source : TBitmap; ACanvas : TCanvas; ARect : TRect; ATransparent : Boolean; ATransColor : TColor);
var
    ImageList : TImageList;
    R : TRect;
    TempBuf : TBitmap;
begin
    ImageList := TImageList.Create(nil);
    ImageList.Height := Source.Height;
    ImageList.Width := Source.Width div 3;
    if ATransparent then
        ImageList.AddMasked(Source, ATransColor)
    else
        ImageList.Add(Source, nil);

    TempBuf := TBitmap.Create();
    if ImageList.Width > ARect.Right - ARect.Left then
    begin
        ImageList.GetBitmap(0, TempBuf);
        TempBuf.Width := ARect.Right - ARect.Left;
        ACanvas.Draw(ARect.Left, ARect.Top, TempBuf);
    end
    else
    begin
        ImageList.Draw(ACanvas, ARect.Left, ARect.Top, 0);
        ImageList.Draw(ACanvas, ARect.Right - ImageList.Width, ARect.Top, 2);
        ImageList.GetBitmap(1, TempBuf);
        R := Rect(ARect.Left + ImageList.Width, ARect.Top, ARect.Right - ImageList.Width, ARect.Top + Source.Height);
        ACanvas.StretchDraw(R, TempBuf);
    end;
    TempBuf.Free();

    ImageList.Free();
end;

type
    TColorRec = packed record
    case Integer of
    0: (Value: Longint);
    1: (Red, Green, Blue: Byte);
    2: (R, G, B, Flag: Byte);
    {$IFDEF MSWINDOWS}
    3: (Index: Word); // GetSysColor, PaletteIndex
    {$ENDIF MSWINDOWS}
     end;

function RGBToColor(r, g, b : Byte) : TColor;
begin
    TColorRec(Result).Red := r;
    TColorRec(Result).Green := g;
    TColorRec(Result).Blue := b;
    TColorRec(Result).Flag := 0;
end;

procedure ColorToRGB(Color : TColor; out r, g, b : Byte);
var
    Temp: TColorRec;
begin
    Temp.Value := Graphics.ColorToRGB(Color);
    r := Temp.R;
    g := Temp.G;
    b := Temp.B;
end;

procedure DrawHorizontalGradient(const ACanvas : TCanvas; const ARect : TRect; const BeginColor, EndColor : TColor);
var
    i : Integer;
    cr, cg, cb : byte;
    begin_r, begin_g, begin_b : byte;
    end_r, end_g, end_b : byte;
begin
    if ARect.Bottom = ARect.Top then
        Exit;
    ColorToRGB(BeginColor, begin_r, begin_g, begin_b);
    ColorToRGB(EndColor, end_r, end_g, end_b);

    ACanvas.Pen.Color := BeginColor;
    ACanvas.MoveTo(ARect.Left, ARect.Top);
    ACanvas.LineTo(ARect.Right, ARect.Top);
    for i := ARect.Top + 1 to ARect.Bottom - 2 do
    begin
        cr := begin_r + Trunc((end_r - begin_r) / (ARect.Bottom - ARect.Top) * (i - ARect.Top - 1));
        cg := begin_g + Trunc((end_g - begin_g) / (ARect.Bottom - ARect.Top) * (i - ARect.Top - 1));
        cb := begin_b + Trunc((end_b - begin_b) / (ARect.Bottom - ARect.Top) * (i - ARect.Top - 1));
        ACanvas.Pen.Color := RGBToColor(cr, cg, cb);
        ACanvas.MoveTo(ARect.Left, i);
        ACanvas.LineTo(ARect.Right, i);
    end;

    ACanvas.Pen.Color := EndColor;
    ACanvas.MoveTo(ARect.Left, ARect.Bottom - 1);
    ACanvas.LineTo(ARect.Right, ARect.Bottom - 1);
end;

procedure DrawVerticalGradient(const ACanvas : TCanvas; const ARect : TRect; const BeginColor, EndColor : TColor);
var
    i : Integer;
    cr, cg, cb : byte;
    begin_r, begin_g, begin_b : byte;
    end_r, end_g, end_b : byte;
begin
    if ARect.Right = ARect.Left then
        Exit;
    ColorToRGB(BeginColor, begin_r, begin_g, begin_b);
    ColorToRGB(EndColor, end_r, end_g, end_b);

    ACanvas.Pen.Color := BeginColor;
    ACanvas.MoveTo(ARect.Left, ARect.Top);
    ACanvas.LineTo(ARect.Left, ARect.Bottom);
    for i := ARect.Left + 1 to ARect.Right - 2 do
    begin
        cr := begin_r + Trunc((end_r - begin_r) / (ARect.Right - ARect.Left) * (i - ARect.Left));
        cg := begin_g + Trunc((end_g - begin_g) / (ARect.Right - ARect.Left) * (i - ARect.Left));
        cb := begin_b + Trunc((end_b - begin_b) / (ARect.Right - ARect.Left) * (i - ARect.Left));
        ACanvas.Pen.Color := RGBToColor(cr, cg, cb);
        ACanvas.MoveTo(i, ARect.Top);
        ACanvas.LineTo(i, ARect.Bottom);
    end;

    ACanvas.Pen.Color := EndColor;
    ACanvas.MoveTo(ARect.Right - 1, ARect.Top);
    ACanvas.LineTo(ARect.Right - 1, ARect.Bottom);
end;

procedure RoundPicture(SrcBuf : TBitmap);
var
    Buf : TBitmap;
    i, j : Integer;
begin
    Buf := TBitmap.Create();

    Buf.Width := SrcBuf.Height;
    Buf.Height := SrcBuf.Width;

    for i := 0 to SrcBuf.Height do
        for j := 0 to SrcBuf.Width do
            Buf.Canvas.Pixels[i, (SrcBuf.Width - j - 1)] :=
                SrcBuf.Canvas.Pixels[j, i];

    SrcBuf.Height := Buf.Height;
    SrcBuf.Width := Buf.Width;
    SrcBuf.Canvas.Draw(0, 0, Buf);

    Buf.Free();
end;

procedure RoundPicture2(SrcBuf : TBitmap);
var
    Buf : TBitmap;
    i, j : Integer;
begin
    Buf := TBitmap.Create();

    Buf.Width := SrcBuf.Width;
    Buf.Height := SrcBuf.Height;

    for i := 0 to SrcBuf.Width do
        for j := 0 to SrcBuf.Height do
            Buf.Canvas.Pixels[SrcBuf.Width - 1 - i, (SrcBuf.Height - j - 1)] :=
                SrcBuf.Canvas.Pixels[i, j];

    SrcBuf.Canvas.Draw(0, 0, Buf);

    Buf.Free();
end;

procedure RoundPicture3(SrcBuf : TBitmap);
var
    Buf : TBitmap;
    i, j : Integer;
begin
    Buf := TBitmap.Create();

    Buf.Width := SrcBuf.Height;
    Buf.Height := SrcBuf.Width;

    for i := 0 to SrcBuf.Height do
        for j := 0 to SrcBuf.Width do
            Buf.Canvas.Pixels[i, j] := SrcBuf.Canvas.Pixels[j, SrcBuf.Height - i - 1];

    SrcBuf.Height := Buf.Height;
    SrcBuf.Width := Buf.Width;
    SrcBuf.Canvas.Draw(0, 0, Buf);

    Buf.Free();
end;

function IsHasProperty(AComponent : TComponent; ApropertyName : String) : Boolean;
var
    PropInfo : PPropInfo;
begin
    PropInfo := GetPropInfo(AComponent.ClassInfo, APropertyName);
    Result := PropInfo <> nil;
end;

procedure SpitBitmap(Source, Dest : TBitmap; Count, Index : Integer);
var
    TempBmp : TBitmap;
begin
    TempBmp := TBitmap.Create();
    try
        TempBmp.Height := Source.Height;
        TempBmp.Width := Source.Width div Count;
        if Count = Index then
            TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, Rect(Source.Width - TempBmp.Width, 0, Source.Width, TempBmp.Height))
        else
            TempBmp.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), Source.Canvas, Rect(TempBmp.Width * (Index - 1), 0, TempBmp.Width * Index, TempBmp.Height));
        Dest.Height := TempBmp.Height;
        Dest.Width := TempBmp.Width;
        Dest.Canvas.CopyRect(Rect(0, 0, TempBmp.Width, TempBmp.Height), TempBmp.Canvas, Rect(0, 0, TempBmp.Width, TempBmp.Height));
    finally
        TempBmp.Free();
    end;
end;

function FormHasFocus(Form: TCustomForm): boolean;
var
    hActiveChild: THandle;
begin
    Result := False;

    if Application.MainForm = nil then
    begin
        Result := Form.Active;
        Exit;
    end;

    if (
        (Application.MainForm.FormStyle = fsMDIForm) and
        (Form = Application.MainForm)
    ) then
    begin
        Result := true;
        Exit;
    end;
    if not Application.Active then
        Exit;
    if Application.MainForm = nil then
    begin
        Result := Form.Active;
        Exit;
    end;

    if (Form <> nil) and (Form <> Application.MainForm) then
    begin
        if Application.MainForm.FormStyle = fsMDIForm then
        begin
            hActiveChild := THandle(SendMessage(Application.MainForm.ClientHandle, WM_MDIGETACTIVE, 0, 0 ));
            if hActiveChild <> Form.Handle then
            begin
                if not Form.Active then
                    Exit;
            end;
        end
        else
        begin
            if not Form.Active then
                Exit;
        end;
    end;
    Result := True;
end;

var
    l_IsWinXP : Boolean = false;
    l_IsWinVista : Boolean = false;

function LocalIsWinXP() : Boolean;
var
    OS :TOSVersionInfo;
begin
    ZeroMemory(@OS,SizeOf(OS));
    OS.dwOSVersionInfoSize := SizeOf(OS);
    GetVersionEx(OS);
    Result := (
        (OS.dwMajorVersion >= 5) and
        (OS.dwMinorVersion >= 1) and
        (OS.dwPlatformId = VER_PLATFORM_WIN32_NT)
    );
end;

function LocalIsWinVista() : Boolean;
var
    OS : TOSVersionInfo;
begin
    ZeroMemory(@OS,SizeOf(OS));
    OS.dwOSVersionInfoSize := SizeOf(OS);
    GetVersionEx(OS);
    result := (
        (OS.dwMajorVersion = 6) and
        (OS.dwMinorVersion = 0) and
        (OS.dwPlatformId = VER_PLATFORM_WIN32_NT)
    );
end;

procedure ContainerApplyUIStyle(Container : TWinControl; UIStyle : TsuiUIStyle; FileTheme : TsuiFileTheme);
var
    i : Integer;
begin
    with Container do
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if (
                (IsHasProperty(Controls[i], 'FileTheme')) and
                (IsHasProperty(Controls[i], 'UIStyle'))
            ) then
            begin
                SetObjectProp(Controls[i], 'FileTheme', FileTheme);
                SetOrdProp(Controls[i], 'UIStyle', Ord(UIStyle));
            end;
//            if Controls[i] is TWinControl then
//               ContainerApplyUIStyle(Controls[i] as TWinControl, UiStyle, FileTheme);
        end;
    end; // with
end;

type
    TsuiFunc1 = function (Handle : THandle; idObject : Integer; var ScrollInfo : tagScrollBarInfo) : Boolean; stdcall;
    TsuiFunc2 = function (hwndCombo: HWND; var pcbi: TComboBoxInfo): Boolean; stdcall;
    TsuiFunc3 = function (hWnd: HWND; dwTime: DWORD; dwFlags: DWORD): Boolean; stdcall;
    
var
    l_Func1 : TsuiFunc1 = nil;
    l_Func2 : TsuiFunc2 = nil;
    l_Func3 : TsuiFunc3 = nil;
    l_Win95 : Boolean = false;
    l_Win95_2 : Boolean = false;
    l_DllUser32 : THandle = 0;

function SUIGetScrollBarInfo(Handle : THandle; idObject : Integer; var ScrollInfo : tagScrollBarInfo) : Boolean; stdcall;
begin
    Result := false;
    if l_Win95 then
        Exit;
    if (not l_Win95) and not Assigned(l_Func1) then
    begin
        if l_DllUser32 = 0 then
            l_DllUser32 := LoadLibrary('User32.dll');
        l_Func1 := GetProcAddress(l_DllUser32, 'GetScrollBarInfo');
        if not Assigned(l_Func1) then
        begin
            l_Win95 := true;
            Exit;
        end;
    end;
    if Assigned(l_Func1) then
        Result := l_Func1(Handle, idObject, ScrollInfo);
end;

function SUIGetComboBoxInfo(hwndCombo: HWND; var pcbi: TComboBoxInfo): Boolean; stdcall;
begin
    Result := false;
    if l_Win95 then
        Exit;    
    if (not l_Win95) and not Assigned(l_Func2) then
    begin
        if l_DllUser32 = 0 then
            l_DllUser32 := LoadLibrary('User32.dll');
        l_Func2 := GetProcAddress(l_DllUser32, 'GetComboBoxInfo');
        if not Assigned(l_Func2) then
        begin
            l_Win95 := true;       
            Exit;
        end;
    end;
    if Assigned(l_Func2) then
        Result := l_Func2(hwndCombo, pcbi);
end;

function SUIAnimateWindow(hWnd: HWND; dwTime: DWORD; dwFlags: DWORD): Boolean; stdcall;
begin
    Result := false;
    if l_Win95_2 then
        Exit;
    if (not l_Win95_2) and not Assigned(l_Func3) then
    begin
        if l_DllUser32 = 0 then
            l_DllUser32 := LoadLibrary('User32.dll');
        l_Func3 := GetProcAddress(l_DllUser32, 'AnimateWindow');
        if not Assigned(l_Func3) then
        begin
            l_Win95_2 := true;          
            Exit;
        end;
    end;
    if Assigned(l_Func3) then
        Result := l_Func3(hWnd, dwTime, dwFlags);
end;

function GetLocaleButtonCaption(Button: TMsgDlgBtn): string;
var
    pStr: PChar;
    uID: Integer;
begin
    Result := '';
    uID := 0;
    case Button of
    mbYes: uID := 805;
    mbNo: uID := 806;
    mbOK: uID := 800;
    mbCancel: uID := 801;
    mbAbort: uID := 802;
    mbRetry: uID := 803;
    mbIgnore: uID := 804;
    mbHelp: uID := 808;
    mbAll: Result := 'All';
    mbNoToAll: Result := 'No to All';
    mbYesToAll: Result := 'Yes to All';
    end;

    if uID > 0 then
    begin
        if l_DllUser32 = 0 then
            l_DllUser32 := LoadLibrary('User32.dll');
        if l_DllUser32 <> 0 then
        begin
            GetMem(pStr, 64);
            if LoadString(l_DllUser32, uID, pStr, 64) > 0 then
                Result := StrPas(pStr);
            FreeMem(pStr);
        end;
    end;
end;

procedure GetCaptionFont(const Font : TFont);
var
    FNonCLientMetrics : TNonCLientMetrics;
begin
    FNonCLientMetrics.cbSize := Sizeof(TNonCLientMetrics);
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @FNonCLientMetrics, 0) then
    begin
        Font.Handle := CreateFontIndirect(FNonCLientMetrics.lfCaptionFont);
    end;
end;

function FormatStringWithWidth(Canvas: TCanvas; const szPath: string; nWidth: Integer): string;
var
    nNewWidth: Integer;
    nLeftPos : Integer;
begin
    Result := szPath;
    nNewWidth := Canvas.TextWidth(Result);
    if (nNewWidth <= nWidth) then
        exit;
    nLeftPos := 1;

    while (nLeftPos < Length(szPath)) do
    begin
        Result := Copy(szPath, 1, nLeftPos) + '...';

        nNewWidth := Canvas.TextWidth(Result);
        if (nNewWidth >= nWidth) then
            exit;

        inc(nLeftPos);
    end;

    Result := szPath;
end;

function IsWinXP() : Boolean;
begin
    Result := l_IsWinXP;
end;

function IsWinVista() : Boolean;
begin
    Result := l_IsWinVista;
end;

initialization
    l_IsWinXP := LocalIsWinXP();
    l_IsWinVista := LocalIsWinVista();

finalization
    if l_DllUser32 <> 0 then
        FreeLibrary(l_DllUser32);

end.

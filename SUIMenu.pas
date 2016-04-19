////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIMenu.pas
//  Creator     :   Shen Min
//  Date        :   2002-09-01
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIMenu;

interface

{$I SUIPack.inc}

uses Windows, Graphics, Menus;


    procedure Menu_SetItemEvent(
        MenuItem : TMenuItem;
        DrawItemEvent : TMenuDrawItemEvent;
        MeasureItemEvent : TMenuMeasureItemEvent
    );

    procedure Menu_DrawBorder(ACanvas : TCanvas; ARect : TRect; Color : TColor);
    procedure Menu_DrawBackGround(ACanvas : TCanvas; ARect : TRect; Color : TColor);
    procedure Menu_DrawLineItem(
        ACanvas : TCanvas;
        ARect : TRect;
        LineColor : TColor;
        BarWidth : Integer;
        L2R : Boolean
    );

    procedure Menu_DrawWindowBorder(HandleOfWnd : HWND; BorderColor, FormColor : TColor);

    procedure Menu_DrawMacOSLineItem(ACanvas : TCanvas; ARect : TRect);
    procedure Menu_DrawMacOSSelectedItem(ACanvas : TCanvas; ARect : TRect);
    procedure Menu_DrawMacOSNonSelectedItem(ACanvas : TCanvas; ARect : TRect);

    procedure Menu_GetSystemFont(const Font : TFont);

implementation

uses SUIResDef;

procedure Menu_SetItemEvent(
    MenuItem : TMenuItem;
    DrawItemEvent : TMenuDrawItemEvent;
    MeasureItemEvent : TMenuMeasureItemEvent
);
var
    i : Integer;
begin
    MenuItem.OnDrawItem := DrawItemEvent;
    MenuItem.OnMeasureItem := MeasureItemEvent;

    for i := 0 to MenuItem.Count - 1 do
        Menu_SetItemEvent(MenuItem.Items[i], DrawItemEvent, MeasureItemEvent);
end;

procedure Menu_DrawBorder(ACanvas : TCanvas; ARect : TRect; Color : TColor);
begin
    ACanvas.Brush.Color := Color;
    ACanvas.FrameRect(ARect);
end;

procedure Menu_DrawBackGround(ACanvas : TCanvas; ARect : TRect; Color : TColor);
begin
    ACanvas.Brush.Color := Color;
    ACanvas.FillRect(ARect);
end;

procedure Menu_DrawLineItem(
    ACanvas : TCanvas;
    ARect : TRect;
    LineColor : TColor;
    BarWidth : Integer;
    L2R : Boolean
);
begin
    ACanvas.Pen.Color := LineColor;
    if L2R then
    begin
        ACanvas.MoveTo(ARect.Left + BarWidth + 4, ARect.Top + 2);
        ACanvas.LineTo(ARect.Right - 2, ARect.Top + 2);
    end
    else
    begin
        ACanvas.MoveTo(ARect.Left + 2, ARect.Top + 2);
        ACanvas.LineTo(ARect.Right - BarWidth - 4, ARect.Top + 2);
    end;
end;

procedure Menu_DrawMacOSLineItem(ACanvas : TCanvas; ARect : TRect);
var
    Bmp : TBitmap;
begin
    Bmp := TBitmap.Create();
    Bmp.LoadFromResourceName(hInstance, 'MACOS_MENU_BAR');
    Bmp.Height := 12;
    ACanvas.StretchDraw(ARect, Bmp);
    Bmp.Free();
end;

procedure Menu_DrawMacOSSelectedItem(ACanvas : TCanvas; ARect : TRect);
var
    Bmp : TBitmap;
begin
    Bmp := TBitmap.Create();
    Bmp.LoadFromResourceName(hInstance, 'MACOS_MENU_SELECT');
    Bmp.Height := 20;
    ACanvas.StretchDraw(ARect, Bmp);
    Bmp.Free();
end;

procedure Menu_DrawMacOSNonSelectedItem(ACanvas : TCanvas; ARect : TRect);
var
    Bmp : TBitmap;
begin
    Bmp := TBitmap.Create();
    Bmp.LoadFromResourceName(hInstance, 'MACOS_MENU_BAR');
    Bmp.Height := 20;
    ACanvas.StretchDraw(ARect, Bmp);
    Bmp.Free();
end;

procedure Menu_DrawWindowBorder(HandleOfWnd : HWND; BorderColor, FormColor : TColor);
var
    Canvas : TCanvas;
    R : TRect;
    WndRect : TRect;
begin
    Canvas := TCanvas.Create();
    Canvas.Handle := GetWindowDC(GetDesktopWindow());

    GetWindowRect(HandleOfWnd, WndRect);
    R := WndRect;

    Inc(R.Top);
    Dec(R.Bottom);
    Dec(R.Right);
    Canvas.Brush.Color := BorderColor;
    Canvas.FrameRect(R);

    Inc(R.Left);
    Inc(R.Top);
    Dec(R.Bottom);
    Dec(R.Right);
    Canvas.Brush.Color := clWhite;
    Canvas.FrameRect(R);

    Canvas.Pen.Color := FormColor;
    Canvas.MoveTo(WndRect.Left, WndRect.Bottom - 1);
    Canvas.LineTo(WndRect.Right - 1, WndRect.Bottom - 1);
    Canvas.LineTo(WndRect.Right - 1, WndRect.Top);
    Canvas.LineTo(WndRect.Right, WndRect.Top);
    Canvas.LineTo(WndRect.Left, WndRect.Top);

    ReleaseDC(GetDesktopWindow, Canvas.Handle);
    Canvas.Free();
end;

procedure Menu_GetSystemFont(const Font : TFont);
var
    FNonCLientMetrics : TNonCLientMetrics;
begin
    FNonCLientMetrics.cbSize := Sizeof(TNonCLientMetrics);
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @FNonCLientMetrics, 0) then
    begin
        Font.Handle := CreateFontIndirect(FNonCLientMetrics.lfMenuFont);
        Font.Color := clMenuText;
    end;
end;

end.

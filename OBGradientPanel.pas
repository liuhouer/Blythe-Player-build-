unit OBGradientPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics;

type
  TBarKind = (bkHorizontal,bkVertical);
  TOBGradientPanel = class(TCustomPanel)
  private
    function uCreateVerticalFont(lFont : TFont) : TFont;
    { Private declarations }
  protected
    FAbout : String;
    FUseTwoColor: Boolean;
    FColorStart : TColor;
    FColorEnd   : TColor;
    FSpace      : Integer;
    FKind       : TBarKind;
    { Protected declarations }
  public
    procedure SetColorStart(Value : TColor);
    procedure SetColorEnd(Value : TColor);
    procedure SetUseTC( Value : Boolean);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure WMEraseBkGnd(var message : TMessage); message WM_ERASEBKGND;
    procedure DrawGradientH(ACanvas : TCanvas ; ARect : TRect;StartColor , EndColor : TColor);
    procedure DrawGradientV(ACanvas : TCanvas ; ARect : TRect;StartColor , EndColor : TColor);
    procedure SetSpace(Value : Integer);
    procedure SetKind(Value : TBarKind);
    { Public declarations }
  published
    property About : String read FAbout write FAbout;
    property Align;
    property Anchors;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property Font;
    property Hint;
    property ShowHint;
    property OnKeyDown;
    property OnMouseDown;
    property ColorStart : TColor  read FColorStart  write SetColorStart;
    property ColorEnd   : TColor  read FColorEnd    write SetColorEnd;
    property UseTwoColor: Boolean read FUseTwoColor write SetUseTC;
    property Space      : Integer read FSpace       write SetSpace;
    property Kind       : TBarKind read FKind       write SetKind;
    { Published declarations }
  end;

implementation

uses Types;

procedure TOBGradientPanel.SetColorStart(Value : TColor);
begin
  FColorStart := Value;
  Invalidate;
end; {設置起始顏色}

procedure TOBGradientPanel.SetColorEnd(Value : TColor);
begin
  FColorEnd := Value;
  Invalidate;
end; {設置結束顏色}

procedure TOBGradientPanel.SetUseTC(Value : Boolean);
begin
  FUseTwoColor := Value;
  Invalidate;
end; {是否使用兩種顏色}

constructor TOBGradientPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption     := Name;
  FColorStart := clBtnShadow;
  FColorEnd   := clBtnShadow;
  FUseTwoColor:= False;
  Height      := 25;
  Width       := 300;
  Font.Color  := clWhite;
  Font.Style  := [fsBold];
  FSpace      := 3;
  Color       := clBtnShadow;
  ParentFont  := True;
end; {創建過程}

destructor TOBGradientPanel.Destroy;
begin
  inherited Destroy;
end; {構析過程}

procedure TOBGradientPanel.Paint;
var
  tmpRect : TRect;
  Bevel   : UInt;
begin
  tmpRect := ClientRect;
  Inc(tmpRect.Left  ,FSpace);
  Inc(tmpRect.Top   ,FSpace);
  Dec(tmpRect.Right ,FSpace);
  Dec(tmpRect.Bottom,FSpace);
  Bevel   := EDGE_RAISED;

  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(ClientRect);  
  if not FUseTwoColor then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(tmpRect);
  end
  else
    if FKind = bkHorizontal
      then DrawGradientH(Canvas , tmpRect, FColorStart , FColorEnd)
      else DrawGradientV(Canvas , tmpRect, FColorStart , FColorEnd);
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Font := Font;
    if FKind = bkVertical then
    begin
      tmpRect.Left := (tmpRect.Right - tmpRect.Top - Canvas.TextHeight('H')) div 2 + tmpRect.Left;
      Canvas.Font := uCreateVerticalFont(Canvas.Font);
      DrawText(Canvas.Handle,pChar(Caption),Length(Caption),tmpRect,DT_LEFT or DT_BOTTOM or DT_SINGLELINE);
    end
    else
      DrawText(Canvas.Handle,pChar(Caption),Length(Caption),tmpRect,DT_LEFT or DT_VCENTER or DT_SINGLELINE);
  end; {畫文字}
  if BevelOuter <> bvNone then
  begin
    tmpRect := ClientRect;
{    Dec(tmpRect.Left  ,1);
    Dec(tmpRect.Top   ,1);
    Inc(tmpRect.Right ,1);
    Inc(tmpRect.Bottom,1);}
    if BevelOuter = bvRaised  then Bevel := BDR_RAISEDINNER;
    if BevelOuter = bvLowered then Bevel := EDGE_SUNKEN;
    DrawEdge(Canvas.Handle,tmpRect,Bevel,BF_RECT);
  end; {畫內框}
  if BevelInner <> bvNone then
  begin
    if BevelInner = bvRaised  then Bevel := EDGE_RAISED;
    if BevelInner = bvLowered then Bevel := EDGE_SUNKEN;
    tmpRect := ClientRect;
    DrawEdge(Canvas.Handle,tmpRect,Bevel,BF_RECT);
  end; {畫邊框}
end; {畫界面}

procedure TOBGradientPanel.WMEraseBkGnd(var message : TMessage);
begin
  Canvas.Brush.Style := bsClear;
end; {不重畫背景}

procedure TOBGradientPanel.DrawGradientH(ACanvas : TCanvas ; ARect : TRect;StartColor , EndColor : TColor);
var
  Red , Green , Blue : Double;
  StepRed , StepGreen , StepBlue : Double;
  i : Integer;
begin
  Red   := GetRValue(ColorToRGB(StartColor));
  Green := GetGValue(ColorToRGB(StartColor));
  Blue  := GetBValue(ColorToRGB(StartColor));
  ACanvas.Brush.Style := bsSolid;
  if StartColor = EndColor then
  begin
    ACanvas.Brush.Color := RGB(Round(Red),Round(Green),Round(Blue));
    ACanvas.FillRect(ARect);
  end
  else begin
    StepRed   := (GetRValue(ColorToRGB(EndColor))-Red)  /(ARect.Right-ARect.Left);
    StepGreen := (GetGValue(ColorToRGB(EndColor))-Green)/(ARect.Right-ARect.Left);
    StepBlue  := (GetBValue(ColorToRGB(EndColor))-Blue) /(ARect.Right-ARect.Left);
    with ACanvas do
    begin
      for i := 0 to ARect.Right-ARect.Left -1 do
      begin
        Brush.Color := RGB(Round(Red),Round(Green),Round(Blue));
        FillRect(Rect(ARect.Left+i,ARect.Top,ARect.Left+i+1,ARect.Bottom));
        Red   := Red   + StepRed;
        Green := Green + StepGreen;
        Blue  := Blue  + StepBlue;
      end;
    end;
  end;
end; {畫過渡色水平}

procedure TOBGradientPanel.SetSpace(Value : Integer);
begin
  FSpace := Value;
  Invalidate;
end; {設置邊界}

procedure TOBGradientPanel.DrawGradientV(ACanvas: TCanvas; ARect: TRect;
  StartColor, EndColor: TColor);
var
  Red , Green , Blue : Double;
  StepRed , StepGreen , StepBlue : Double;
  i : Integer;
begin
  Red   := GetRValue(ColorToRGB(StartColor));
  Green := GetGValue(ColorToRGB(StartColor));
  Blue  := GetBValue(ColorToRGB(StartColor));
  ACanvas.Brush.Style := bsSolid;
  if StartColor = EndColor then
  begin
    ACanvas.Brush.Color := RGB(Round(Red),Round(Green),Round(Blue));
    ACanvas.FillRect(ARect);
  end
  else begin
    StepRed   := (GetRValue(ColorToRGB(EndColor))-Red)  /(ARect.Bottom-ARect.Top);
    StepGreen := (GetGValue(ColorToRGB(EndColor))-Green)/(ARect.Bottom-ARect.Top);
    StepBlue  := (GetBValue(ColorToRGB(EndColor))-Blue) /(ARect.Bottom-ARect.Top);
    with ACanvas do
    begin
      for i := 0 to ARect.Bottom-ARect.Top -1 do
      begin
        Brush.Color := RGB(Round(Red),Round(Green),Round(Blue));
        FillRect(Rect(ARect.Left,ARect.Top+i,ARect.Right,ARect.Top+i+1));
        Red   := Red   + StepRed;
        Green := Green + StepGreen;
        Blue  := Blue  + StepBlue;
      end;
    end;
  end;
end; {畫過渡色垂直}

procedure TOBGradientPanel.SetKind(Value: TBarKind);
begin
  if Value <> FKind then
  begin
    FKind := Value;
    if Value = bkHorizontal then
    begin
      Height := 25;
      Width  := 300;
    end
    else
    begin
      Height := 300;
      Width  := 25;
    end;
    Invalidate;
  end;
end; {設置水平/垂直}

function TOBGradientPanel.uCreateVerticalFont(lFont: TFont) : TFont;
var
  lLogFont : LOGFONT;
begin
  GetObject(lFont.Handle,sizeof(LOGFONT),@lLogFont);
  lLogFont.lfEscapement  := 900;
  lLogFont.lfOrientation := 900;
  lFont.Handle := CreateFontIndirect(lLogFont);
  Result := lFont;
end; {創建垂直字體}

end.

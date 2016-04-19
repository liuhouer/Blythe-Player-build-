unit OBHintControl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms;

type
  TOBHintControl = class;
  TOBShowHintEvent = procedure(var HintStr: string;var CanShow: Boolean; var HintInfo: THintInfo) of object;

  TOBHint = class(THintWindow)
  private
    lTimes : Integer;
    lBitmap : TBitmap;
    FHint : TOBHintControl;
    procedure DoDrawText(var Rect: TRect; lText : String; Flags: Longint);
    procedure OnWmEraseBk(var message : TMessage); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
    procedure   Paint; override;
    procedure   NCPaint(DC: HDC); override;
    function    CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
    function    FindHintComponent : TOBHintControl;
    destructor Destroy; override;
  end;

  TOBHintControl = class(TComponent)
  private
    FAbout : String;
    FActive : Boolean;
    FGlyph : TPicture;
    FFont : TFont;
    FFrameColor : TColor;
    FBackColor : TColor;
    FAlphaBlend : Boolean;
    FAlphaBlendValue : Integer;
    FOnShowHint : TOBShowHintEvent;
    procedure SetActive(Value : Boolean);
    procedure SetGlyph(Value : TPicture);
    procedure SetFont(Value : TFont);
    procedure SetAlphaBlendValue(Value : Integer);
    procedure ShowHint(var HintStr: string;var CanShow: Boolean; var HintInfo: THintInfo);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property About : String read FAbout write FAbout;
    property Active : Boolean read FActive write SetActive;
    property Glyph : TPicture read FGlyph write SetGlyph;
    property Font : TFont read FFont write SetFont;
    property FrameColor : TColor read FFrameColor write FFrameColor;
    property BackColor : TColor read FBackColor write FBackColor;
    property AlphaBlend : Boolean read FAlphaBlend write FAlphaBlend;
    property OnShowHint : TOBShowHintEvent read FOnShowHint write FOnShowHint;
    property AlphaBlendValue : Integer read FAlphaBlendValue write SetAlphaBlendValue;
  end;

procedure GetScreenImage(X, Y: Integer; B: TBitMap);

implementation

uses Types;

procedure GetScreenImage(X, Y: Integer; B: TBitMap);
var
  DC, DC1, DC2: HDC;
begin
  DC := CreateDC('DISPLAY', nil, nil, nil);
  DC1 := CreateCompatibleDC(DC);
  DC2 := CreateCompatibleBitmap(DC, B.Width, B.Height);
  SelectObject(DC1, DC2);
  BitBlt(DC1, 0, 0, B.Width, B.Height, DC, X, Y, SRCCOPY);
  StretchBlt(B.Canvas.Handle, 0, 0, B.Width, B.Height,
             DC1, 0, 0, B.Width, B.Height, SRCCOPY);
  DeleteDC(DC2);
  DeleteDC(DC1);
  DeleteDC(DC);
end;

{ TOBHint }

function TOBHint.CalcHintRect(MaxWidth: Integer; const AHint: string;
  AData: Pointer): TRect;
var
  lRect : TRect;
begin
  lRect  := ClientRect;
  Result := ClientRect;
  if FHint = nil then Exit;
  Font := FHint.Font;
  DoDrawText(lRect,AHint,DT_CALCRECT);
  Result.Right := Result.Left + lRect.Right + 10;
  Result.Bottom := Result.Top + lRect.Bottom + 5;

  if FHint.Glyph.Graphic <> nil then
  begin
     Result.Right := Result.Right + FHint.Glyph.Graphic.Width + 2;
     if Result.Bottom <  FHint.Glyph.Graphic.Height + 10 then
        Result.Bottom := FHint.Glyph.Graphic.Height + 10;
  end;
end; { 計算范圍 }

constructor TOBHint.Create(AOwner: TComponent);
begin
  inherited;
  lTimes := 0;
  FHint := FindHintComponent;
  lBitmap := TBitmap.Create;
end; { 創建 }

procedure TOBHint.NCPaint(DC: HDC);
begin

end; { 畫邊框 }

procedure TOBHint.Paint;
var
  lRect : TRect;
  li , lj : Integer;
  lTempCol: TColor;
  R1,G1,B1 : Integer;
  R2,G2,B2 : Integer;
  R3,G3,B3 : Integer;
begin
  if FHint = nil then Exit;
  if (Height < 100) and (lTimes = 1 ) then
  begin
    lTimes := 0;
    Canvas.Draw(0,0,lBitmap);
    Exit;
  end;

  if FHint.FGlyph <> nil then
  begin
    if FHint.FAlphaBlend then
    begin
      lBitmap.Width := Width;
      lBitmap.Height := Height;
      GetScreenImage(Left+1,Top+1,lBitmap);
      R1 := GetRValue(ColorToRGB(FHint.BackColor));
      G1 := GetGValue(ColorToRGB(FHint.BackColor));
      B1 := GetBValue(ColorToRGB(FHint.BackColor));
      for li := 0 to Width do
      for lj := 0 to Height do
      begin
        lTempCol := lBitmap.Canvas.Pixels[li,lj];
        R2 := GetRValue(ColorToRGB(lTempCol));
        G2 := GetGValue(ColorToRGB(lTempCol));
        B2 := GetBValue(ColorToRGB(lTempCol));
        R3 := Round(( R1 * FHint.FAlphaBlendValue + R2 * (255-FHint.FAlphaBlendValue) ) /255);
        G3 := Round(( G1 * FHint.FAlphaBlendValue + G2 * (255-FHint.FAlphaBlendValue) ) /255);
        B3 := Round(( B1 * FHint.FAlphaBlendValue + B2 * (255-FHint.FAlphaBlendValue) ) /255);
        lBitmap.Canvas.Pixels[li,lj] := RGB(R3,G3,B3);
      end;
    end
    else
    begin
      lBitmap.Canvas.Brush.Color := FHint.FBackColor;
      lBitmap.Canvas.FillRect(ClientRect);
    end;

    lBitmap.Canvas.Brush.Style := bsClear;
    if Height >= 100 then
    begin
      lBitmap.Canvas.Pen.Color := FHint.FFrameColor;
      lBitmap.Canvas.Rectangle(ClientRect);
    end;

    if FHint.FGlyph.Graphic <> nil then
    begin
      FHint.FGlyph.Graphic.Transparent := True;
      lBitmap.Canvas.Draw(5,5,FHint.FGlyph.Graphic);
    end;

    lRect := Rect(0,0,0,0);
    DoDrawText(lRect, Caption, DT_CALCRECT);
    lRect.Top := (Height - lRect.Bottom) div 2;
    lRect.Bottom := lRect.Top + Height;
    lRect.Right := ClientRect.Right;
    if FHint.FGlyph.Graphic <> nil
       then lRect.Left := FHint.FGlyph.Graphic.Width + 7
       else lRect.Left := 5;
    lBitmap.Canvas.Font := Font;
    lBitmap.Canvas.Brush.Style := bsClear;
    DrawText(lBitmap.Canvas.Handle,PChar(Caption),Length(Caption),lRect,DT_LEFT);

    Canvas.Draw(0,0,lBitmap);
  end;
  if Height < 100 then
  if lTimes = 1 then lTimes := 0 else lTimes := 1;
end; { 畫HINT }

function TOBHint.FindHintComponent : TOBHintControl;
var
  i: Integer;
begin
  if Application.MainForm <> nil then
  begin
    for i := 0 to Application.MainForm.ComponentCount -1 do
    begin
      if Application.MainForm.Components[i] is TOBHintControl then
      if TOBHintControl(Application.MainForm.Components[i]).Active then
      begin
        Result := TOBHintControl(Application.MainForm.Components[i]);
        Exit;
      end;
    end;
  end;
  Result := nil;
end; { 查找主控件 }

procedure TOBHint.DoDrawText(var Rect: TRect; lText : String; Flags: Longint);
begin
  Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  Canvas.Font := Font;
  DrawText(Canvas.Handle, PChar(lText), Length(lText), Rect, Flags);
end; { 畫文本/計算范圍 }

procedure TOBHint.OnWmEraseBk(var message: TMessage);
begin
  message.Result := 1;
end; { 刪除底色 }

destructor TOBHint.Destroy;
begin
  lBitmap.Free;
  inherited;
end;

{ TOBHintControl }

constructor TOBHintControl.Create(AOwner: TComponent);
begin
  inherited;
  FGlyph := TPicture.Create;
  FFont := TFont.Create;
  FBackColor := clInfoBk;
  FAlphaBlendValue := 200;
end; { 創建控件 }

destructor TOBHintControl.Destroy;
begin
  FFont.Free;
  FGlyph.Free;
  inherited;
  if FActive then HintWindowClass := THintWindow;
end; { 刪除控件 }

procedure TOBHintControl.SetActive(Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    if not(csDesigning in ComponentState) then
    if Active then
    begin
      HintWindowClass := TOBHint;
      Application.OnShowHint := ShowHint;
    end else
    begin
      HintWindowClass := THintWindow;
      Application.OnShowHint := nil;
    end;
  end;
end; { 設置激活狀態 }

procedure TOBHintControl.SetAlphaBlendValue(Value: Integer);
begin
  if Value <> FAlphaBlendValue then
  if Value <= 255 then
     FAlphaBlendValue := Value;
end; { 設置透明度 }

procedure TOBHintControl.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end; { 設置字體 }

procedure TOBHintControl.SetGlyph(Value: TPicture);
begin
  FGlyph.Assign(Value);
end; { 設置圖形 }

procedure TOBHintControl.ShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if Assigned(FOnShowHint) then
     FOnShowHint(HintStr,CanShow,HintInfo);  
end; { 顯示HINT事件 }

end.

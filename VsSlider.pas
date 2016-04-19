{***************************************************************************}
{ TMS Skin Factory                                                          }
{ for Delphi 4.0,5.0,6.0 & C++Builder 4.0,5.0                               }
{                                                                           }
{ Copyright 1996 - 2002 by TMS Software                                     }
{ Email : info@tmssoftware.com                                              }
{ Web : http://www.tmssoftware.com                                          }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit VsSlider;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses, VsControls, VsGraphics, VsSkin, VsSysUtils;

type
  TVsSliderDirection = (sdHorz, sdVert);
  TVsSlider = class(TVsSkinGraphicControl)
  private
    FThumbRect: TRect;
    FMinValue: Integer;
    FMaxValue: Integer;
    FPosition: Integer;
    FDragging: Boolean;
    FDirection: TVsSliderDirection;
    FHit: Integer;
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FMaskColor: TColor;
    FClipRect: TVsClipRect;
    FOnChange: TNotifyEvent;
    procedure SetMinValue(Value: Integer);
    procedure SetMaxValue(Value: Integer);
    procedure SetPosition(Value: Integer);
    procedure SetDirection(Value: TVsSliderDirection);
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetMaskColor(Value: TColor);
    procedure SetClipRect(Value: TVsClipRect);
    procedure ClipRectChanged(Sender: TObject);
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure Paint; override;
    procedure Loaded; override;
    function GlyphIndex: Integer;
    procedure UpdateGraphic(Clip: Boolean); override;
    procedure SetThumbTop(ATop: Integer);
    procedure SetThumbLeft(ALeft: Integer);
    procedure CenterThumb;
    function ViewWidth: Integer;
    function GetOffsetByValue(Value: Integer): Integer;
    function GetValueByOffset(Offset: Integer): Integer;
    function GetMinIndent(Rect: TRect): Integer;
    procedure SetThumbOffset(Value: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Changed;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetGraphicBitmap(Bitmap: TBitmap); override;
    function ThumbWidth: Integer;
    function ThumbHeight: Integer;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ReadConfig(IniFile: TVsIni); override;
    procedure WriteConfig(IniFile: TVsIni); override;
  published
    property GraphicName: TVsGraphicName read FGraphicName write SetGraphicName;
    property ClipRect: TVsClipRect read FClipRect write SetClipRect;
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property MinValue: Integer read FMinValue write SetMinValue;
    property Position: Integer read FPosition write SetPosition;
    property Direction: TVsSliderDirection read FDirection write SetDirection;
    property MaskColor: TColor read FMaskColor write SetMaskColor;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Anchors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Hint;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
{$IFDEF VER130}
    property OnContextPopup;
{$ENDIF}
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;


implementation

const
  Glyphs = 2;
  EnabledThumb = 0;
  DisabledThumb = 1;

{ TVsSlider }

constructor TVsSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  SetBounds(0, 0, 150, 20);
  FMinValue := 0;
  FMaxValue := 100;
  FPosition := 0;
  FDirection := sdHorz;
  FMaskColor := clNone;
  FClipRect := TVsClipRect.Create;
  FClipRect.OnChange := ClipRectChanged;
end;

destructor TVsSlider.Destroy;
begin
  FClipRect.Free;
  inherited Destroy;
end;

procedure TVsSlider.Loaded;
begin
  inherited Loaded;
end;

procedure TVsSlider.GetGraphicBitmap(Bitmap: TBitmap);
begin
  inherited;
  if (FGraphic <> nil) then
    Bitmap.Assign(FGraphic.Bitmap);
end;

procedure TVsSlider.SetThumbLeft(ALeft: Integer);
begin
  FThumbRect := Bounds(ALeft, FThumbRect.Top, ThumbWidth, ThumbHeight);
end;

procedure TVsSlider.SetThumbTop(ATop: Integer);
begin
  FThumbRect := Bounds(FThumbRect.Left, ATop, ThumbWidth, ThumbHeight);
end;

procedure TVsSlider.CenterThumb;
begin
  if Direction = sdVert then
    SetThumbLeft((Width - ThumbWidth) div 2)
  else SetThumbTop((Height - ThumbHeight) div 2);
end;

procedure TVsSlider.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  CenterThumb;
  RepaintControl;
end;

function TVsSlider.ThumbWidth: Integer;
begin
  Result := 0;
  if FClipRect <> nil then
    Result := FClipRect.Width div Glyphs;
end;

function TVsSlider.ThumbHeight: Integer;
begin
  Result := 0;
  if FClipRect <> nil then
    Result := FClipRect.Height;
end;

function TVsSlider.GlyphIndex: Integer;
begin
  Result := Ord(not Enabled);
end;

procedure TVsSlider.SetClipRect(Value: TVsClipRect);
begin
  FClipRect.Assign(Value);
end;

procedure TVsSlider.ClipRectChanged(Sender: TObject);
begin
  RepaintControl;
end;

procedure TVsSlider.UpdateGraphic(Clip: Boolean);
begin
  FGraphic := Skin.GetGraphic(FGraphicName);
  if (FGraphic <> nil) and Clip then
    FClipRect.BoundsRect := Bounds(0, 0, Gw(FGraphic), Gh(FGraphic));
  CenterThumb;
end;

procedure TVsSlider.Paint;
var
  Value: Integer;
  W, H: Integer;
  S: TRect;
begin
  PaintBackImage;

  Value := GetOffsetByValue(Position);
  if Direction = sdVert then
  SetThumbTop(Value) else SetThumbLeft(Value);

  if FGraphic <> nil then
  begin
    H := ClipRect.Height;
    W := ClipRect.Width div Glyphs;
    S := Bounds(ClipRect.Left + (GlyphIndex * W), ClipRect.Top, W, H);
    SetBrushStyle(BitmapCanvas.Brush, MaskColor);
    BitmapCanvas.BrushCopy(FThumbRect, FGraphic.Bitmap, S, MaskColor);
  end;
  inherited Paint;
end;

procedure TVsSlider.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TVsSlider.SetMinValue(Value: Integer);
begin
  if (Value <> FMinValue) and (Value < FMaxValue) then
  begin
    FMinValue := Value;
    if FPosition < Value then Position := Value
    else RepaintControl;
  end;
end;

procedure TVsSlider.SetMaxValue(Value: Integer);
begin
  if (Value <> FMaxValue) and (Value > FMinValue) then
  begin
    FMaxValue := Value;
    if FPosition > Value then Position := Value
    else RepaintControl;
  end;
end;

procedure TVsSlider.SetPosition(Value: Integer);
begin
  if Value < FMinValue then Value := FMinValue;
  if Value > FMaxValue then Value := FMaxValue;
  if FPosition <> Value then
  begin
    FPosition := Value;
    RepaintControl;
    Changed;
  end;
end;

procedure TVsSlider.SetDirection(Value: TVsSliderDirection);
begin
  if FDirection <> Value then
  begin
    FDirection := Value;
    CenterThumb;
    RepaintControl;
  end;
end;

procedure TVsSlider.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphic(True);
  end;
end;

procedure TVsSlider.SetMaskColor(Value: TColor);
begin
  if FMaskColor <> Value then
  begin
    FMaskColor := Value;
    RepaintControl;
  end;
end;

function TVsSlider.GetMinIndent(Rect: TRect): Integer;
begin
  if Direction = sdVert then
    Result := IMax(0, Rect.Top)
  else
    Result := IMax(0, Rect.Left);
end;

function TVsSlider.ViewWidth: Integer;
var
  R: TRect;
begin
  R := ClientRect;
  if Direction = sdVert then
  Result := HeightOf(R) - ThumbHeight
  else Result := WidthOf(R) - ThumbWidth;
end;

function TVsSlider.GetOffsetByValue(Value: Integer): Integer;
var
  Range: Double;
  R: TRect;
  MinIndent: Integer;
begin
  R := ClientRect;
  MinIndent := GetMinIndent(R);
  Range := MaxValue - MinValue;
  Result := Round((Value - MinValue) / Range * ViewWidth) + MinIndent;
  if (Direction = sdVert) then
    Result := R.Top + R.Bottom - Result - ThumbHeight;
end;

function TVsSlider.GetValueByOffset(Offset: Integer): Integer;
var
  R: TRect;
  Range: Double;
  MinIndent: Integer;
begin
  R := ClientRect;
  MinIndent := GetMinIndent(R);
  if Direction = sdVert then
    Offset := ClientHeight - Offset - ThumbHeight;
  Range := FMaxValue - FMinValue;
  Result := Round((Offset - MinIndent) * Range / ViewWidth);
  Result := IMin(FMinValue + IMax(Result, 0), FMaxValue);
end;

procedure TVsSlider.SetThumbOffset(Value: Integer);
var
  R: TRect;
  MinIndent: Integer;
begin
  R := ClientRect;
  MinIndent := GetMinIndent(R);
  Value := IMin(IMax(Value, MinIndent), MinIndent + ViewWidth);
  Position := GetValueByOffset(Value)
end;

procedure TVsSlider.CMEnabledChanged(var Message: TMessage);
begin
  RepaintControl;
  inherited;
end;

procedure TVsSlider.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  P: TPoint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and (Enabled) then
  begin
    P := Point(X, Y);
    if PtInRect(FThumbRect, P) then
    begin
      FDragging := True;
      if Direction = sdHorz then FHit := X - FThumbRect.Left
      else FHit := Y - FThumbRect.Top;
    end else
    begin
      if Direction = sdHorz then
        FHit := X - ThumbWidth div 2
      else FHit := Y - ThumbHeight div 2;
      SetThumbOffset(FHit);
    end;
  end;
end;

procedure TVsSlider.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FDragging then
  begin
    if FDirection = sdVert then
      SetThumbOffset(Y - FHit)
    else
      SetThumbOffset(X - FHit);
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TVsSlider.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDragging then
  begin
    FDragging := false;
    RepaintControl;
  end;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TVsSlider.ReadConfig(IniFile: TVsIni);
begin
  ClipRect.BoundsRect := IniFile.ReadRect(Self.Name, 'ClipRect', EmptyRect);
  MaskColor := IniFile.ReadColor(Self.Name, 'MaskColor', clNone);
  Direction := TVsSliderDirection(IniFile.ReadInteger(Self.Name, 'Direction', 0));
  inherited;
end;

procedure TVsSlider.WriteConfig(IniFile: TVsIni);
begin
  inherited;
  IniFile.WriteRect(Self.Name, 'ClipRect', ClipRect.BoundsRect);
  IniFile.WriteColor(Self.Name, 'MaskColor', MaskColor);
  IniFile.WriteInteger(Self.Name, 'Direction', Ord(Direction));
end;



end.

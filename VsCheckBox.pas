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

unit VsCheckBox;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses, VsGraphics, VsSkin, VsSysUtils;

type
  TVsCheckBoxState = (vcUnchecked, vcChecked, vcGrayed);
  TVsCheckBox = class(TVsSkinGraphicControl)
  private
    FState: TVsCheckBoxState;
    FAllowGrayed: Boolean;
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FSpacing: Integer;
    FBtnDown: Boolean;
    FMask: TBitmap;
    FMaskColor: TColor;
    FMaskRect: TRect;
    FClipRect: TVsClipRect;
    FHasMouse: Boolean;
    function GetChecked: Boolean;
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetMaskColor(Value: TColor);
    procedure SetSpacing(Value: Integer);
    procedure SetState(Value: TVsCheckBoxState);
    procedure SetChecked(Value: Boolean);
    procedure SetClipRect(Value: TVsClipRect);
    procedure ClipRectChanged(Sender: TObject);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Paint; override;
    procedure Loaded; override;
    function GlyphIndex: Integer;
    procedure UpdateGraphic(Clip: Boolean); override;
    function CheckClick(X, Y: Integer): Boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetGraphicBitmap(Bitmap: TBitmap); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Toggle;
    procedure Click; override;
    procedure ReadConfig(IniFile: TVsIni); override;
    procedure WriteConfig(IniFile: TVsIni); override;
  published
    property GraphicName: TVsGraphicName read FGraphicName write SetGraphicName;
    property ClipRect: TVsClipRect read FClipRect write SetClipRect;
    property MaskColor: TColor read FMaskColor write SetMaskColor default clNone;
    property State: TVsCheckBoxState read FState write SetState default vcUnchecked;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property Checked: Boolean read GetChecked write SetChecked;
    property Spacing: Integer read FSpacing write SetSpacing default 5;
    property CursorTracking default false;
    property Anchors;
    property Caption;
//  property Constraints;
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
  Glyphs = 6;
  EnabledUnchecked = 0;
  EnabledChecked = 1;
  EnabledGrayed = 2;
  DisabledUnchecked = 3;
  DisabledChecked = 4;
  DisabledGrayed = 5;


{ TVsCheckBox }

constructor TVsCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csSetCaption, csDoubleClicks, csReplicatable];
  SetBounds(0, 0, 100, 21);
  CursorTracking := false;
  FState := vcUnchecked;
  FSpacing := 5;
  FAllowGrayed := false;
  FMask := TBitmap.Create;
  FMask.PixelFormat := pf24Bit;
  FMaskColor := clNone;
  FClipRect := TVsClipRect.Create;
  FClipRect.OnChange := ClipRectChanged;
end;

destructor TVsCheckBox.Destroy;
begin
  FMask.Free;
  FClipRect.Free;
  inherited Destroy;
end;

procedure TVsCheckBox.GetGraphicBitmap(Bitmap: TBitmap);
begin
  inherited;
  if (FGraphic <> nil) then
    Bitmap.Assign(FGraphic.Bitmap);
end;

procedure TVsCheckBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  P: TSize;
begin
  if (FGraphic <> nil) then
  begin
    AHeight := FClipRect.Height;
    AWidth := FClipRect.Width div Glyphs;
    if Trim(Caption) <> '' then
    begin
      AWidth := AWidth + FSpacing;
      BitmapCanvas.Font := Self.Font;
      P := BitmapCanvas.TextExtent(Caption);
      AWidth := AWidth + P.cX + 4;
      AHeight := MaxInteger(AHeight, P.cY + 4);
    end;
  end;
  if FMask <> nil then
  begin
    FMask.Width := FClipRect.Width div Glyphs;
    FMask.Height := FClipRect.Height;
  end;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TVsCheckBox.Loaded;
begin
  inherited Loaded;
end;

procedure TVsCheckBox.SetClipRect(Value: TVsClipRect);
begin
  FClipRect.Assign(Value);
end;

procedure TVsCheckBox.ClipRectChanged(Sender: TObject);
begin
  UpdateBounds;
end;

procedure TVsCheckBox.UpdateGraphic(Clip: Boolean);
begin
  FGraphic := Skin.GetGraphic(FGraphicName);
  if (FGraphic <> nil) and Clip then
    FClipRect.BoundsRect := Bounds(0, 0, Gw(FGraphic), Gh(FGraphic));
  UpdateBounds;
end;

function TVsCheckBox.GlyphIndex: Integer;
var
  I: Integer;
begin
  if not Enabled then
    I := 3 else I := 0;
  case State of
    vcUnchecked: Result := 0 + I;
    vcChecked: Result := 1 + I;
    vcGrayed: Result := 2 + I;
    else Result := 0;
  end;
end;

procedure TVsCheckBox.Paint;
var
  H, W: Integer;
  S, D: TRect;
begin
  PaintBackImage;
  W := 0;
  if FGraphic <> nil then
  begin
    W := FMask.Width;
    H := FMask.Height;
    S := Bounds(ClipRect.Left + (GlyphIndex * W), ClipRect.Top, W, H);
    D := Bounds(0, 0, W, H);
    FMask.Canvas.CopyRect(D, FGraphic.Bitmap.Canvas, S);
    FMaskRect := Bounds(0, (Height - H) div 2, W, H);
    SetBrushStyle(BitmapCanvas.Brush, MaskColor);
    BitmapCanvas.BrushCopy(FMaskRect, FMask, D, MaskColor);
  end;
  BitmapCanvas.Font := Self.Font;
  BitmapCanvas.Brush.Style := bsClear;
  D := ClientRect;
  Inc(D.Left, W + Spacing);
  DrawText(BitmapCanvas.Handle, PChar(Caption), Length(Caption), D,
    DT_LEFT or DT_VCENTER or DT_SINGLELINE);
  inherited Paint;
end;

procedure TVsCheckBox.SetSpacing(Value: Integer);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    UpdateBounds;
  end;
end;

procedure TVsCheckBox.SetState(Value: TVsCheckBoxState);
begin
  if FState <> Value then
  begin
    FState := Value;
    RepaintControl;
  end;
end;

procedure TVsCheckBox.Toggle;
begin
  case State of
    vcUnchecked:
      if AllowGrayed then State := vcGrayed else State := vcChecked;
    vcChecked: State := vcUnchecked;
    vcGrayed: State := vcChecked;
  end;
end;

function TVsCheckBox.GetChecked: Boolean;
begin
  Result := State = vcChecked;
end;

procedure TVsCheckBox.SetChecked(Value: Boolean);
begin
  if Value then State := vcChecked else State := vcUnchecked;
end;

procedure TVsCheckBox.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphic(True);
  end;
end;

procedure TVsCheckBox.SetMaskColor(Value: TColor);
begin
  if FMaskColor <> Value then
  begin
    FMaskColor := Value;
    RepaintControl;
  end;
end;

procedure TVsCheckBox.CMEnabledChanged(var Message: TMessage);
begin
  RepaintControl;
  inherited;
end;

procedure TVsCheckBox.CMTextChanged(var Message: TMessage);
begin
  UpdateBounds;
  RepaintControl;
  inherited;
end;

procedure TVsCheckBox.CMFontChanged(var Message: TMessage);
begin
  RepaintControl;
  inherited;
end;

procedure TVsCheckBox.Click;
begin
end;

function TVsCheckBox.CheckClick(X, Y: Integer): Boolean;
var
  P: TPoint;
begin
  P.X := X - FMaskRect.Left;
  P.Y := Y - FMaskRect.Top;
  Result := PtInRect(FMaskRect, Point(X, Y));
  if FMaskColor <> clNone then
    Result := Result and (FMask.Canvas.Pixels[P.X, P.Y] <> FMaskColor);
end;

procedure TVsCheckBox.CMMouseLeave(var Message: TMessage);
begin
  FHasMouse := false;
  inherited;
end;

procedure TVsCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
    FBtnDown := CheckClick(X, Y);
end;

procedure TVsCheckBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if not FBtnDown then
  begin
    if not CheckClick(X, Y) then
    begin
      if FHasMouse then
      begin
        FHasMouse := false;
        UpdateCursor(crDefault);
      end;
    end else
    begin
      if not FHasMouse then
      begin
        FHasMouse := True;
        UpdateCursor(RefCursor);
      end;
    end;
  end;
end;

procedure TVsCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FBtnDown then
  begin
    FBtnDown := false;
    if CheckClick(X, Y) then
    begin
      Toggle;
      inherited Click;
    end;
  end;
end;

procedure TVsCheckBox.ReadConfig(IniFile: TVsIni);
begin
  ClipRect.BoundsRect := IniFile.ReadRect(Self.Name, 'ClipRect', EmptyRect);
  MaskColor := IniFile.ReadColor(Self.Name, 'MaskColor', clNone);
  Spacing := IniFile.ReadInteger(Self.Name, 'Spacing', 0);
  Font.Color := IniFile.ReadColor(Self.Name, 'FontColor', clBlack);
  Font := IniFile.ReadFont(Self.Name, 'Font', Font);
  inherited;
end;

procedure TVsCheckBox.WriteConfig(IniFile: TVsIni);
begin
  inherited;
  IniFile.WriteRect(Self.Name, 'ClipRect', ClipRect.BoundsRect);
  IniFile.WriteColor(Self.Name, 'MaskColor', MaskColor);
  IniFile.WriteInteger(Self.Name, 'Spacing', Spacing);
  IniFile.WriteFont(Self.Name, 'Font', Font);
  IniFile.WriteColor(Self.Name, 'FontColor', Font.Color);
end;


end.

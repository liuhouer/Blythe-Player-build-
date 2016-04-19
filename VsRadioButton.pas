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

unit VsRadioButton;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses, VsGraphics, VsSkin, VsSysUtils;

type
  TVsRadioButton = class(TVsSkinGraphicControl)
  private
    FChecked: Boolean;
    FGroupIndex: Integer;
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FSpacing: Integer;
    FBtnDown: Boolean;
    FMask: TBitmap;
    FMaskRect: TRect;
    FMaskColor: TColor;
    FClipRect: TVsClipRect;
    FHasMouse: Boolean;
    procedure SetChecked(Value: Boolean);
    procedure SetGroupIndex(Value: Integer);
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetSpacing(Value: Integer);
    procedure SetMaskColor(Value: TColor);
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
    procedure Click; override;
    procedure ReadConfig(IniFile: TVsIni); override;
    procedure WriteConfig(IniFile: TVsIni); override;
  published
    property GraphicName: TVsGraphicName read FGraphicName write SetGraphicName;
    property ClipRect: TVsClipRect read FClipRect write SetClipRect;
    property MaskColor: TColor read FMaskColor write SetMaskColor default clNone;
    property Spacing: Integer read FSpacing write SetSpacing default 5;
    property Checked: Boolean read FChecked write SetChecked;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default -1;
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
  Glyphs = 4;
  EnabledUnchecked = 0;
  EnabledChecked = 1;
  DisabledUnchecked = 2;
  DisabledChecked = 3;

{ TVsRadioButton }

constructor TVsRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csSetCaption, csReplicatable];
  SetBounds(0, 0, 100, 21);
  CursorTracking := false;
  FGroupIndex := -1;
  FChecked := false;
  FSpacing := 5;
  FMask := TBitmap.Create;
  FMask.PixelFormat := pf24Bit;
  FMaskColor := clNone;
  FClipRect := TVsClipRect.Create;
  FClipRect.OnChange := ClipRectChanged;
end;

destructor TVsRadioButton.Destroy;
begin
  FMask.Free;
  FClipRect.Free;
  inherited Destroy;
end;

procedure TVsRadioButton.GetGraphicBitmap(Bitmap: TBitmap);
begin
  inherited;
  if (FGraphic <> nil) then
    Bitmap.Assign(FGraphic.Bitmap);
end;

procedure TVsRadioButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
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

procedure TVsRadioButton.Loaded;
begin
  inherited Loaded;
end;

procedure TVsRadioButton.SetChecked(Value: Boolean);

  procedure TurnSiblingsOff;
  var
    I: Integer;
    Sibling: TControl;
  begin
    if Parent <> nil then
      with Parent do
        for I := 0 to ControlCount - 1 do
        begin
          Sibling := Controls[I];
          if (Sibling <> Self) and (Sibling is TVsRadioButton) then
            if TVsRadioButton(Sibling).GroupIndex = Self.GroupIndex then
              TVsRadioButton(Sibling).SetChecked(False);
        end;
  end;

begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if Value then
    begin
      TurnSiblingsOff;
      inherited Click;
    end;
    RepaintControl;
  end;
end;

procedure TVsRadioButton.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    RepaintControl;
  end;
end;

procedure TVsRadioButton.SetClipRect(Value: TVsClipRect);
begin
  FClipRect.Assign(Value);
end;

procedure TVsRadioButton.ClipRectChanged(Sender: TObject);
begin
  UpdateBounds;
end;

procedure TVsRadioButton.UpdateGraphic(Clip: Boolean);
begin
  FGraphic := Skin.GetGraphic(FGraphicName);
  if (FGraphic <> nil) and Clip then
    FClipRect.BoundsRect := Bounds(0, 0, Gw(FGraphic), Gh(FGraphic));
  UpdateBounds;
end;

function TVsRadioButton.GlyphIndex: Integer;
var
  I: Integer;
begin
  if not Enabled then
    I := 2 else I := 0;
  case Checked of
    False: Result := 0 + I;
    True: Result := 1 + I;
    else Result := 0;
  end;
end;

procedure TVsRadioButton.Paint;
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

procedure TVsRadioButton.CMFontChanged(var Message: TMessage);
begin
  UpdateBounds;
  inherited;
end;

procedure TVsRadioButton.CMEnabledChanged(var Message: TMessage);
begin
  RepaintControl;
  inherited;
end;

procedure TVsRadioButton.CMTextChanged(var Message: TMessage);
begin
  UpdateBounds;
  inherited;
end;

procedure TVsRadioButton.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphic(True);
  end;
end;

procedure TVsRadioButton.SetMaskColor(Value: TColor);
begin
  if FMaskColor <> Value then
  begin
    FMaskColor := Value;
    RepaintControl;
  end;
end;

procedure TVsRadioButton.SetSpacing(Value: Integer);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    UpdateBounds;
  end;
end;

procedure TVsRadioButton.Click;
begin
  //don't remove
end;

function TVsRadioButton.CheckClick(X, Y: Integer): Boolean;
var
  P: TPoint;
begin
  P.X := X - FMaskRect.Left;
  P.Y := Y - FMaskRect.Top;
  Result := PtInRect(FMaskRect, Point(X, Y));
  if FMaskColor <> clNone then
    Result := Result and (FMask.Canvas.Pixels[P.X, P.Y] <> FMaskColor);
end;

procedure TVsRadioButton.CMMouseLeave(var Message: TMessage);
begin
  FHasMouse := false;
  inherited;
end;

procedure TVsRadioButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and (Enabled) then
    FBtnDown := CheckClick(X, Y);
end;

procedure TVsRadioButton.MouseMove(Shift: TShiftState; X, Y: Integer);
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

procedure TVsRadioButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FBtnDown then
  begin
    FBtnDown := false;
    if CheckClick(X, Y) and (not Checked) then
      Checked := not FChecked;
  end;
end;

procedure TVsRadioButton.ReadConfig(IniFile: TVsIni);
begin
  ClipRect.BoundsRect := IniFile.ReadRect(Self.Name, 'ClipRect', EmptyRect);
  MaskColor := IniFile.ReadColor(Self.Name, 'MaskColor', clNone);
  Spacing := IniFile.ReadInteger(Self.Name, 'Spacing', 0);
  Font.Color := IniFile.ReadColor(Self.Name, 'FontColor', clBlack);
  Font := IniFile.ReadFont(Self.Name, 'Font', Font);
  inherited;
end;

procedure TVsRadioButton.WriteConfig(IniFile: TVsIni);
begin
  inherited;
  IniFile.WriteRect(Self.Name, 'ClipRect', ClipRect.BoundsRect);
  IniFile.WriteColor(Self.Name, 'MaskColor', MaskColor);
  IniFile.WriteInteger(Self.Name, 'Spacing', Spacing);
  IniFile.WriteFont(Self.Name, 'Font', Font);
  IniFile.WriteColor(Self.Name, 'FontColor', Font.Color);
end;



end.

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

unit VsButtons;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses, VsControls, VsGraphics, VsSkin, VsSysUtils;

type
  TVsButtonStyle = (bsButton, bsSwitch);
  TVsButton = class(TVsSkinGraphicControl)
  private
    FHasMouse: Boolean;
    FBtnDown: Boolean;
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FStyle: TVsButtonStyle;
    FDown: Boolean;
    FMask: TBitmap;
    FMaskColor: TColor;
    FClipRect: TVsClipRect;
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetDown(Value: Boolean);
    procedure SetMaskColor(Value: TColor);
    procedure SetClipRect(Value: TVsClipRect);
    procedure ClipRectChanged(Sender: TObject);
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Paint; override;
    procedure UpdateGraphic(Clip: Boolean); override;
    function GlyphIndex: Integer;
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
    property Style: TVsButtonStyle read FStyle write FStyle default bsButton;
    property Down: Boolean read FDown write SetDown default false;
    property MaskColor: TColor read FMaskColor write SetMaskColor default clNone;
    property CursorTracking default false;
    property Anchors;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Hint;
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
  Glyphs = 5;
  EnabledUp = 0;
  EnabledDown = 1;
  DisabledUp = 2;
  DisabledDown = 3;
  EnabledOver = 4;


{ TVsButton }

constructor TVsButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  SetBounds(0, 0, 100, 25);
  CursorTracking := false;
  FDown := false;
  FStyle := bsButton;
  FMask := TBitmap.Create;
  FMaskColor := clNone;
  FClipRect := TVsClipRect.Create;
  FClipRect.OnChange := ClipRectChanged;
end;

destructor TVsButton.Destroy;
begin
  FMask.Free;
  FClipRect.Free;
  inherited Destroy;
end;

procedure TVsButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (FGraphic <> nil) then
  begin
    AWidth := ClipRect.Width div Glyphs;
    AHeight := ClipRect.Height;
  end;
  if FMask <> nil then
  begin
    FMask.Width := AWidth;
    FMask.Height := AHeight;
  end;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TVsButton.GetGraphicBitmap(Bitmap: TBitmap);
begin
  inherited;
  if (FGraphic <> nil) then
    Bitmap.Assign(FGraphic.Bitmap);
end;

procedure TVsButton.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphic(True);
  end;
end;

procedure TVsButton.SetDown(Value: Boolean);
begin
  if FDown <> Value then
  begin
    FDown := Value;
    RepaintControl;
  end;
end;

procedure TVsButton.SetMaskColor(Value: TColor);
begin
  if FMaskColor <> Value then
  begin
    FMaskColor := Value;
    RepaintControl;
  end;
end;

procedure TVsButton.SetClipRect(Value: TVsClipRect);
begin
  FClipRect.Assign(Value);
end;

procedure TVsButton.ClipRectChanged(Sender: TObject);
begin
  UpdateBounds;
end;

procedure TVsButton.UpdateGraphic(Clip: Boolean);
begin
  FGraphic := Skin.GetGraphic(FGraphicName);
  if (FGraphic <> nil) and Clip then
    FClipRect.BoundsRect := Bounds(0, 0, Gw(FGraphic), Gh(FGraphic));
  UpdateBounds;
end;

function TVsButton.GlyphIndex: Integer;
begin
  if not Enabled then
  begin
    if Down then Result := DisabledDown
    else Result := DisabledUp;
    Exit;
  end;

  Result := EnabledUp;
  if Style = bsButton then
  begin
    if FBtnDown then
      Result := EnabledDown
    else
    if FHasMouse then
      Result := EnabledOver;
  end else
  begin
    if (FBtnDown) or (FDown) then
      Result := EnabledDown
    else
    if FHasMouse then
      Result := EnabledOver;
  end;
end;

procedure TVsButton.Paint;
var
  Source: TRect;
begin
  PaintBackImage;
  if (FGraphic <> nil) then
  begin
    Source := Bounds(ClipRect.Left + (GlyphIndex * Width),
      ClipRect.Top, Width, Height);
    FMask.Canvas.CopyRect(ClientRect, FGraphic.Bitmap.Canvas, Source);
  end else CopyBackImage(FMask);
  SetBrushStyle(BitmapCanvas.Brush, MaskColor);
  BitmapCanvas.BrushCopy(ClientRect, FMask, ClientRect, MaskColor);
  inherited Paint;
end;

procedure TVsButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  RepaintControl;
end;

procedure TVsButton.CMMouseLeave(var Message: TMessage);
begin
  FHasMouse := false;
  RepaintControl;
  inherited;
end;

function TVsButton.CheckClick(X, Y: Integer): Boolean;
begin
  if FMaskColor = clNone then
    Result := True
  else Result := FMask.Canvas.Pixels[X, Y] <> FMaskColor;
end;

procedure TVsButton.Click;
begin
  //do not remove
end;

procedure TVsButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Button = mbLeft) and Enabled then
    if CheckClick(X, Y) then
    begin
      FBtnDown := True;
      FDown := not FDown;
      RepaintControl;
    end;
end;

procedure TVsButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (not FBtnDown) then
  begin
    if not CheckClick(X, Y) then
    begin
      if FHasMouse then
      begin
        FHasMouse := false;
        UpdateCursor(crDefault);
        RepaintControl;
      end;
    end else
    begin
      if not FHasMouse then
      begin
        FHasMouse := True;
        UpdateCursor(RefCursor);
        RepaintControl;
      end;
    end;
  end;
end;

procedure TVsButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  DoClick: Boolean;
begin
  inherited;
  DoClick := (FHasMouse) and (FBtnDown);
  if FBtnDown then
  begin
    if (Style = bsSwitch) and (not DoClick) then
      FDown := not FDown; //undo change
    FBtnDown := false;
    RepaintControl;
  end;
  if DoClick then inherited Click;
end;

procedure TVsButton.ReadConfig(IniFile: TVsIni);
begin
  ClipRect.BoundsRect := IniFile.ReadRect(Self.Name, 'ClipRect', EmptyRect);
  MaskColor := IniFile.ReadColor(Self.Name, 'MaskColor', clNone);
  inherited;
end;

procedure TVsButton.WriteConfig(IniFile: TVsIni);
begin
  inherited;
  IniFile.WriteRect(Self.Name, 'ClipRect', ClipRect.BoundsRect);
  IniFile.WriteColor(Self.Name, 'MaskColor', MaskColor);
end;


end.

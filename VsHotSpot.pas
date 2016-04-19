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

unit VsHotSpot;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses, VsControls, VsGraphics, VsSkin, VsSysUtils;

type
  TVsHotSpot = class(TVsSkinGraphicControl)
  private
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FMask: TBitmap;
    FMaskColor: TColor;
    FClipRect: TVsClipRect;
    FBtnDown: Boolean;
    FHasMouse: Boolean;
    procedure SetMaskColor(Value: TColor);
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetClipRect(Value: TVsClipRect);
    procedure ClipRectChanged(Sender: TObject);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Paint; override;
    procedure UpdateGraphic(Clip: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function CheckClick(X, Y: Integer): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetGraphicBitmap(Bitmap: TBitmap); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Click; override;
  published
    property GraphicName: TVsGraphicName read FGraphicName write SetGraphicName;
    property ClipRect: TVsClipRect read FClipRect write SetClipRect;
    property MaskColor: TColor read FMaskColor write SetMaskColor default clNone;
    property CursorTracking default false;
    property Anchors;
//  property Constraints;
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
    property OnDblClick;
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

{ TVsHotSpot }

constructor TVsHotSpot.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csDoubleClicks];
  SetBounds(0, 0, 25, 25);
  CursorTracking := false;
  FMask := TBitmap.Create;
  FMaskColor := clNone;
  FClipRect := TVsClipRect.Create;
  FClipRect.OnChange := ClipRectChanged;
end;

destructor TVsHotSpot.Destroy;
begin
  FMask.Free;
  FClipRect.Free;
  inherited Destroy;
end;

procedure TVsHotSpot.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
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

procedure TVsHotSpot.GetGraphicBitmap(Bitmap: TBitmap);
begin
  inherited;
  if (FGraphic <> nil) then
    Bitmap.Assign(FGraphic.Bitmap);
end;

procedure TVsHotSpot.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphic(True);
  end;
end;

procedure TVsHotSpot.SetMaskColor(Value: TColor);
begin
  if FMaskColor <> Value then
  begin
    FMaskColor := Value;
    RepaintControl;
  end;
end;

procedure TVsHotSpot.SetClipRect(Value: TVsClipRect);
begin
  FClipRect.Assign(Value);
end;

procedure TVsHotSpot.ClipRectChanged(Sender: TObject);
begin
  UpdateBounds;
end;

procedure TVsHotSpot.UpdateGraphic(Clip: Boolean);
begin
  FGraphic := Skin.GetGraphic(FGraphicName);
  if (FGraphic <> nil) and Clip then
    FClipRect.BoundsRect := Bounds(0, 0, Gw(FGraphic), Gh(FGraphic));
  UpdateBounds;
end;

procedure TVsHotSpot.Paint;
var
  Index: Integer;
  Source: TRect;
begin
  PaintBackImage;
  if (FGraphic <> nil) then
  begin
    Index := Ord(FHasMouse);
    Source := Bounds(ClipRect.Left + (Index * Width),
      ClipRect.Top, Width, Height);
    FMask.Canvas.CopyRect(ClientRect, FGraphic.Bitmap.Canvas, Source);
  end else CopyBackImage(FMask);
  SetBrushStyle(BitmapCanvas.Brush, MaskColor);
  BitmapCanvas.BrushCopy(ClientRect, FMask, ClientRect, MaskColor);
  inherited Paint;
end;

procedure TVsHotSpot.CMMouseLeave(var Message: TMessage);
begin
  FHasMouse := false;
  RepaintControl;
  inherited;
end;

function TVsHotSpot.CheckClick(X, Y: Integer): Boolean;
begin
  if FMaskColor = clNone then
    Result := True
  else Result := FMask.Canvas.Pixels[X, Y] <> FMaskColor;
end;

procedure TVsHotSpot.Click;
begin
  //do not remove
end;

procedure TVsHotSpot.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Button = mbLeft) and Enabled then
    if CheckClick(X, Y) then
    begin
      FBtnDown := True;
      RepaintControl;
    end;
end;

procedure TVsHotSpot.MouseMove(Shift: TShiftState; X, Y: Integer);
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

procedure TVsHotSpot.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  DoClick: Boolean;
begin
  inherited;
  DoClick := (FHasMouse) and (FBtnDown);
  if FBtnDown then
  begin
    FBtnDown := false;
    RepaintControl;
  end;
  if DoClick then inherited Click;
end;


end.

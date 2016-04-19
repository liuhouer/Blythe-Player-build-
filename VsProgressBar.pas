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

unit VsProgressBar;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses, VsControls, VsGraphics, VsSkin, VsSysUtils;

type
  TVsOrientation = (poHorizontal, poVertical);
  TVsProgressBar = class(TVsSkinGraphicControl)
  private
    FBI: TBitmap;
    FMinValue: Integer;
    FMaxValue: Integer;
    FPosition: Integer;
    FStep: Integer;
    FOrientation: TVsOrientation;
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FClipRect: TVsClipRect;
    procedure SetMinValue(Value: Integer);
    procedure SetMaxValue(Value: Integer);
    procedure SetPosition(Value: Integer);
    procedure SetOrientation(Value: TVsOrientation);
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetClipRect(Value: TVsClipRect);
    procedure ClipRectChanged(Sender: TObject);
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure UpdateGraphic(Clip: Boolean); override;
    procedure CreateBackImage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetGraphicBitmap(Bitmap: TBitmap); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    function PercentDone: Integer;
    procedure StepIt;
    procedure StepBy(Delta: Integer);
    procedure ReadConfig(IniFile: TVsIni); override;
    procedure WriteConfig(IniFile: TVsIni); override;
  published
    property GraphicName: TVsGraphicName read FGraphicName write SetGraphicName;
    property ClipRect: TVsClipRect read FClipRect write SetClipRect;
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property MinValue: Integer read FMinValue write SetMinValue;
    property Position: Integer read FPosition write SetPosition;
    property Step: Integer read FStep write FStep;
    property Orientation: TVsOrientation read FOrientation write SetOrientation;
    property Anchors;
    property Constraints;
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


{ TVsProgressBar }

constructor TVsProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  SetBounds(0, 0, 125, 10);
  FMinValue := 0;
  FMaxValue := 100;
  FPosition := 0;
  FStep := 10;
  FOrientation := poHorizontal;
  FClipRect := TVsClipRect.Create;
  FClipRect.OnChange := ClipRectChanged;
  FBI := TBitmap.Create;
end;

destructor TVsProgressBar.Destroy;
begin
  FBI.Free;
  FClipRect.Free;
  inherited Destroy;
end;

procedure TVsProgressBar.Loaded;
begin
  inherited Loaded;
end;

procedure TVsProgressBar.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if (FBI <> nil) and (FGraphic <> nil) then
    CreateBackImage;
end;

procedure TVsProgressBar.GetGraphicBitmap(Bitmap: TBitmap);
begin
  inherited;
  if (FGraphic <> nil) then
    Bitmap.Assign(FGraphic.Bitmap);
end;

procedure TVsProgressBar.SetClipRect(Value: TVsClipRect);
begin
  FClipRect.Assign(Value);
end;

procedure TVsProgressBar.ClipRectChanged(Sender: TObject);
begin
  CreateBackImage;
  RepaintControl;
end;

procedure TVsProgressBar.UpdateGraphic(Clip: Boolean);
begin
  FGraphic := Skin.GetGraphic(FGraphicName);
  if (FGraphic <> nil) and Clip then
    FClipRect.BoundsRect := Bounds(0, 0, Gw(FGraphic), Gh(FGraphic));
  CreateBackImage;
end;

procedure TVsProgressBar.CreateBackImage;
var
  S, D: TRect;
begin
  FBI.Assign(nil);

  if FGraphic = nil then
    Exit;

  case Orientation of
    poHorizontal:
      begin
        FBI.Width := Self.Width;
        FBI.Height := ClipRect.Height;
        S := ClipRect.BoundsRect;
        D := Bounds(0, 0, ClipRect.Width, ClipRect.Height);
        while D.Right < FBI.Width + ClipRect.Width do
        begin
          FBI.Canvas.CopyRect(D, FGraphic.Bitmap.Canvas, S);
          OffsetRect(D, IMax(1, ClipRect.Width), 0);
        end;
      end;
    poVertical:
      begin
        FBI.Width := ClipRect.Width;
        FBI.Height := Self.Height;
        S := ClipRect.BoundsRect;
        D := Bounds(0, FBI.Height - ClipRect.Height, ClipRect.Width, ClipRect.Height);
        while D.Top > -ClipRect.Height do
        begin
          FBI.Canvas.CopyRect(D, FGraphic.Bitmap.Canvas, S);
          OffsetRect(D, 0, IMin(-ClipRect.Height, -1));
        end;
      end;
  end;
end;

function TVsProgressBar.PercentDone: Integer;
begin
  Result := SolveForY(FPosition - FMinValue, FMaxValue - FMinValue);
end;

procedure TVsProgressBar.Paint;
var
  R: TRect;
  X, Y, Delta: Integer;
begin
  PaintBackImage;

  if not FBI.Empty then
    case Orientation of
      poHorizontal:
        begin
          X := 0;
          Y := (Height - FBI.Height) div 2;
          Delta := SolveForX(PercentDone, Width);
          R := Bounds(X, Y, Delta, FBI.Height);
          BitmapCanvas.CopyRect(R, FBI.Canvas, Bounds(0, 0, Delta, FBI.Height));
        end;
      poVertical:
        begin
          X := (Width - FBI.Width) div 2;
          Delta := SolveForX(PercentDone, Height);
          R := Bounds(X, Height - Delta, FBI.Width, Delta);
          BitmapCanvas.CopyRect(R, FBI.Canvas, Bounds(0, FBI.Height - Delta, FBI.Width, Delta));
        end;
    end; //case}
  inherited Paint;
end;

procedure TVsProgressBar.StepIt;
begin
  Position := Position + FStep;
  RepaintControl;
end;

procedure TVsProgressBar.StepBy(Delta: Integer);
begin
  Position := Position + Delta;
  RepaintControl;
end;

procedure TVsProgressBar.SetMinValue(Value: Integer);
begin
  if (FMinValue <> Value) and (Value < FMaxValue) then
  begin
    FMinValue := Value;
    if Position < FMinValue then Position := FMinValue
    else RepaintControl;
  end;
end;

procedure TVsProgressBar.SetMaxValue(Value: Integer);
begin
  if (FMaxValue <> Value) and (Value > FMinValue) then
  begin
    FMaxValue := Value;
    if Position > FMaxValue then Position := FMaxValue
    else RepaintControl;
  end;
end;

procedure TVsProgressBar.SetPosition(Value: Integer);
begin
  if Value < FMinValue then
    Value := FMinValue;
  if Value > FMaxValue then
    Value := FMaxValue;
  if FPosition <> Value then
  begin
    FPosition := Value;
    RepaintControl;
  end;
end;

procedure TVsProgressBar.SetOrientation(Value: TVsOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    CreateBackImage;
    RepaintControl;
  end;
end;

procedure TVsProgressBar.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphic(True);
  end;
end;

procedure TVsProgressBar.ReadConfig(IniFile: TVsIni);
begin
  ClipRect.BoundsRect := IniFile.ReadRect(Self.Name, 'ClipRect', EmptyRect);
  Orientation := TVsOrientation(IniFile.ReadInteger(Self.Name, 'Orientation', 0));
  inherited;
end;

procedure TVsProgressBar.WriteConfig(IniFile: TVsIni);
begin
  inherited;
  IniFile.WriteRect(Self.Name, 'ClipRect', ClipRect.BoundsRect);
  IniFile.WriteInteger(Self.Name, 'Orientation', Ord(Orientation));
end;


end.

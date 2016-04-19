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

unit VsImageText;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses, VsControls, VsGraphics, VsSkin, VsSysUtils;

type
  TVsImageText = class(TVsSkinGraphicControl)
  private
    FLayout: string;
    FMaskColor: TColor;
    FCharWidth: Integer;
    FSpacing: Integer;
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FClipRect: TVsClipRect;
    FFormDrag: Boolean;
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetMaskColor(Value: TColor);
    procedure SetLayout(const Value: string);
    procedure SetSpacing(Value: Integer);
    procedure SetClipRect(Value: TVsClipRect);
    procedure ClipRectChanged(Sender: TObject);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure Paint; override;
    procedure PaintChar(X, Y: Integer; Ch: Char);
    procedure UpdateGraphic(Clip: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetGraphicBitmap(Bitmap: TBitmap); override;
    procedure ReadConfig(IniFile: TVsIni); override;
    procedure WriteConfig(IniFile: TVsIni); override;
  published
    property GraphicName: TVsGraphicName read FGraphicName write SetGraphicName;
    property ClipRect: TVsClipRect read FClipRect write SetClipRect;
    property MaskColor: TColor read FMaskColor write SetMaskColor;
    property Layout: string read FLayout write SetLayout;
    property Spacing: Integer read FSpacing write SetSpacing;
    property FormDrag: Boolean read FFormDrag write FFormDrag;
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
    property Text;
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


{ TVsImageText }

constructor TVsImageText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  SetBounds(0, 0, 80, 25);
  FMaskColor := clNone;
  FSpacing := 2;
  FFormDrag := True;
  FClipRect := TVsClipRect.Create;
  FClipRect.OnChange := ClipRectChanged;
end;

destructor TVsImageText.Destroy;
begin
  FClipRect.Free;
  inherited Destroy;
end;

procedure TVsImageText.GetGraphicBitmap(Bitmap: TBitmap);
begin
  inherited;
  if (FGraphic <> nil) then
    Bitmap.Assign(FGraphic.Bitmap);
end;

procedure TVsImageText.SetClipRect(Value: TVsClipRect);
begin
  FClipRect.Assign(Value);
end;

procedure TVsImageText.ClipRectChanged(Sender: TObject);
begin
  RepaintControl;
end;

procedure TVsImageText.UpdateGraphic(Clip: Boolean);
begin
  FGraphic := Skin.GetGraphic(FGraphicName);
  if (FGraphic <> nil) and Clip then
    FClipRect.BoundsRect := Bounds(0, 0, Gw(FGraphic), Gh(FGraphic));
end;

procedure TVsImageText.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphic(True);
  end;
end;

procedure TVsImageText.PaintChar(X, Y: Integer; Ch: Char);
var
  P: Integer;
  D, S: TRect;
begin
  P := Pos(Ch, Layout);
  if P > 0 then
  begin
    D := Bounds(X, Y, FCharWidth, ClipRect.Height);
    S := Bounds(ClipRect.Left + (Pred(P) * FCharWidth), ClipRect.Top,
      FCharWidth, ClipRect.Height);
    SetBrushStyle(BitmapCanvas.Brush, MaskColor);
    BitmapCanvas.BrushCopy(D, FGraphic.Bitmap, S, MaskColor);
  end;
end;

procedure TVsImageText.Paint;
var
  X, Y, I: Integer;
begin
  PaintBackImage;
  with BitmapCanvas do
  begin
    if FGraphic <> nil then
    begin
      X := 0;
      Y := (Height - FClipRect.Height) div 2;
      FCharWidth := (FClipRect.Width div IMax(1, Length(Layout)));
      for I := 1 to Length(Text) do
      begin
        PaintChar(X, Y, Text[I]);
        Inc(X, IMax(1, FCharWidth + FSpacing));
      end;
    end;
  end;
  inherited Paint;
end;

procedure TVsImageText.SetMaskColor(Value: TColor);
begin
  if FMaskColor <> Value then
  begin
    FMaskColor := Value;
    RepaintControl;
  end;
end;

procedure TVsImageText.SetLayout(const Value: string);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    RepaintControl;
  end;
end;

procedure TVsImageText.SetSpacing(Value: Integer);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    RepaintControl;
  end;
end;

procedure TVsImageText.CMTextChanged(var Message: TMessage);
begin
  inherited;
  RepaintControl;
end;

procedure TVsImageText.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbleft then
  begin
    if FFormDrag then
    begin
      ReleaseCapture;
      TWinControl(GetParentControl(Self)).Perform(WM_SYSCOMMAND, $F012, 0);
    end;
  end;
end;

procedure TVsImageText.ReadConfig(IniFile: TVsIni);
begin
  ClipRect.BoundsRect := IniFile.ReadRect(Self.Name, 'ClipRect', EmptyRect);
  MaskColor := IniFile.ReadColor(Self.Name, 'MaskColor', clNone);
  Spacing := IniFile.ReadInteger(Self.Name, 'Spacing', 0);
  inherited;
end;

procedure TVsImageText.WriteConfig(IniFile: TVsIni);
begin
  inherited;
  IniFile.WriteRect(Self.Name, 'ClipRect', ClipRect.BoundsRect);
  IniFile.WriteColor(Self.Name, 'MaskColor', MaskColor);
  IniFile.WriteInteger(Self.Name, 'Spacing', Spacing);
end;



end.

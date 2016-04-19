{*****************************************************}
{                                                     }
{     Varian Skin Factory                             }
{                                                     }
{     Varian Software NL (c) 1996-2001                }
{     All Rights Reserved                             }
{                                                     }
{ ****************************************************}

unit VsImage;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses, VsControls, VsGraphics, VsSkin, VsSysUtils;

type
  TVsImage = class(TVsSkinGraphicControl)
  private
    FAutoSize: Boolean;
    FCenter: Boolean;
    FStretch: Boolean;
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FMaskColor: TColor;
    FFormDrag: Boolean;
    FClipRect: TVsClipRect;
    procedure SetAutoSizeValue(Value: Boolean);
    procedure SetCenter(Value: Boolean);
    procedure SetStretch(Value: Boolean);
    procedure SetMaskColor(Value: TColor);
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetClipRect(Value: TVsClipRect);
    procedure ClipRectChanged(Sender: TObject);
  protected
    procedure Paint; override;
    function DestRect: TRect;
    procedure UpdateGraphic(Clip: Boolean); override;
    procedure AdjustBounds;
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
    property AutoSize: Boolean read FAutoSize write SetAutoSizeValue default false;
    property Center: Boolean read FCenter write SetCenter default True;
    property Stretch: Boolean read FStretch write SetStretch default false;
    property MaskColor: TColor read FMaskColor write SetMaskColor default clNone;
    property FormDrag: Boolean read FFormDrag write FFormDrag default True;
    property Align;
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


{ TVsImage }

constructor TVsImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  SetBounds(0, 0, 60, 60);
  FAutoSize := false;
  FCenter := True;
  FStretch := false;
  FMaskColor := clNone;
  FFormDrag := True;
  FClipRect := TVsClipRect.Create;
  FClipRect.OnChange := ClipRectChanged;
end;

destructor TVsImage.Destroy;
begin
  FClipRect.Free;
  inherited Destroy;
end;

procedure TVsImage.GetGraphicBitmap(Bitmap: TBitmap);
begin
  inherited;
  if (FGraphic <> nil) then
    Bitmap.Assign(FGraphic.Bitmap);
end;

procedure TVsImage.SetClipRect(Value: TVsClipRect);
begin
  FClipRect.Assign(Value);
end;

procedure TVsImage.ClipRectChanged(Sender: TObject);
begin
  RepaintControl;
end;

procedure TVsImage.UpdateGraphic(Clip: Boolean);
begin
  FGraphic := Skin.GetGraphic(FGraphicName);
  if (FGraphic <> nil) and Clip then
    FClipRect.BoundsRect := Bounds(0, 0, Gw(FGraphic), Gh(FGraphic));
end;

function TVsImage.DestRect: TRect;
begin
  if Stretch then
    Result := ClientRect
  else if Center then
    Result := Bounds((Width - ClipRect.Width) div 2,
      (Height - ClipRect.Height) div 2, ClipRect.Width, ClipRect.Height)
  else
    Result := Rect(0, 0, ClipRect.Width, ClipRect.Height);
end;

procedure TVsImage.AdjustBounds;
begin
  if (AutoSize) and (Align = alNone) then
    if (ClipRect.Width > 0) and (ClipRect.Height > 0) then
      SetBounds(Left, Top, ClipRect.Width, ClipRect.Height);
end;

procedure TVsImage.Paint;
begin
  PaintBackImage;
  if FGraphic <> nil then
  begin
    AdjustBounds;
    with BitmapCanvas do
    begin
      SetBrushStyle(Brush, MaskColor);
      BrushCopy(DestRect, FGraphic.Bitmap, FClipRect.BoundsRect, MaskColor);
    end;
  end;
  inherited Paint;
end;

procedure TVsImage.SetAutoSizeValue(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    RepaintControl;
  end;
end;

procedure TVsImage.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    RepaintControl;
  end;
end;

procedure TVsImage.SetStretch(Value: Boolean);
begin
  if FStretch <> Value then
  begin
    FStretch := Value;
    RepaintControl;
  end;
end;

procedure TVsImage.SetMaskColor(Value: TColor);
begin
  if FMaskColor <> Value then
  begin
    FMaskColor := Value;
    RepaintControl;
  end;
end;

procedure TVsImage.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphic(True);
  end;
end;

procedure TVsImage.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

procedure TVsImage.ReadConfig(IniFile: TVsIni);
begin
  ClipRect.BoundsRect := IniFile.ReadRect(Self.Name, 'ClipRect', EmptyRect);
  MaskColor := IniFile.ReadColor(Self.Name, 'MaskColor', clNone);
  inherited;
end;

procedure TVsImage.WriteConfig(IniFile: TVsIni);
begin
  inherited;
  IniFile.WriteRect(Self.Name, 'ClipRect', ClipRect.BoundsRect);
  IniFile.WriteColor(Self.Name, 'MaskColor', MaskColor);
end;


end.

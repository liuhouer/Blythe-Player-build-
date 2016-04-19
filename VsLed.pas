unit VsLed;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses, VsGraphics, VsControls, VsSkin, VsSysUtils;

type
  TVsLed = class(TVsSkinGraphicControl)
  private
    FActive: Boolean;
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FMaskColor: TColor;
    FFormDrag: Boolean;
    FClipRect: TVsClipRect;
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetMaskColor(Value: TColor);
    procedure SetActive(Value: Boolean);
    procedure SetClipRect(Value: TVsClipRect);
    procedure ClipRectChanged(Sender: TObject);
  protected
    function GlyphIndex: Integer;
    procedure Paint; override;
    procedure Loaded; override;
    procedure UpdateGraphic(Clip: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetGraphicBitmap(Bitmap: TBitmap); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ReadConfig(IniFile: TVsIni); override;
    procedure WriteConfig(IniFile: TVsIni); override;
  published
    property GraphicName: TVsGraphicName read FGraphicName write SetGraphicName;
    property ClipRect: TVsClipRect read FClipRect write SetClipRect;
    property MaskColor: TColor read FMaskColor write SetMaskColor default clNone;
    property Active: Boolean read FActive write SetActive default false;
    property FormDrag: Boolean read FFormDrag write FFormDrag default True;
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

const
  Glyphs = 2;
  State_Off = 0;
  State_On = 1;

{ TVsLed }

constructor TVsLed.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable, csDoubleClicks];
  SetBounds(0, 0, 25, 25);
  FMaskColor := clNone;
  FActive := false;
  FFormDrag := True;
  FClipRect := TVsClipRect.Create;
  FClipRect.OnChange := ClipRectChanged;
end;

destructor TVsLed.Destroy;
begin
  FClipRect.Free;
  inherited Destroy;
end;

procedure TVsLed.Loaded;
begin
  inherited Loaded;
end;

procedure TVsLed.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (FGraphic <> nil) then
  begin
    AWidth := ClipRect.Width div Glyphs;
    AHeight := ClipRect.Height;
  end;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TVsLed.GetGraphicBitmap(Bitmap: TBitmap);
begin
  inherited;
  if (FGraphic <> nil) then
    Bitmap.Assign(FGraphic.Bitmap);
end;

procedure TVsLed.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphic(True);
  end;
end;

procedure TVsLed.SetActive(Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    RepaintControl;
  end;
end;

procedure TVsLed.SetMaskColor(Value: TColor);
begin
  if FMaskColor <> Value then
  begin
    FMaskColor := Value;
    RepaintControl;
  end;
end;

procedure TVsLed.SetClipRect(Value: TVsClipRect);
begin
  FClipRect.Assign(Value);
end;

procedure TVsLed.ClipRectChanged(Sender: TObject);
begin
  UpdateBounds;
end;

procedure TVsLed.UpdateGraphic(Clip: Boolean);
begin
  FGraphic := Skin.GetGraphic(FGraphicName);
  if (FGraphic <> nil) and Clip then
    FClipRect.BoundsRect := Bounds(0, 0, Gw(FGraphic), Gh(FGraphic));
  UpdateBounds;
end;

function TVsLed.GlyphIndex: Integer;
begin
  Result := Ord(Active);
end;

procedure TVsLed.Paint;
var
  W, H: Integer;
  S, D: TRect;
begin
  PaintBackImage;
  if FGraphic <> nil then
  begin
    H := ClipRect.Height;
    W := ClipRect.Width div Glyphs;
    S := Bounds(ClipRect.Left + (GlyphIndex * W), ClipRect.Top, W, H);
    D := Bounds(0, 0, W, H);
    SetBrushStyle(BitmapCanvas.Brush, MaskColor);
    BitmapCanvas.BrushCopy(D, FGraphic.Bitmap, S, MaskColor);
  end;
  inherited Paint;
end;

procedure TVsLed.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

procedure TVsLed.ReadConfig(IniFile: TVsIni);
begin
  ClipRect.BoundsRect := IniFile.ReadRect(Self.Name, 'ClipRect', EmptyRect);
  MaskColor := IniFile.ReadColor(Self.Name, 'MaskColor', clNone);
  inherited;
end;

procedure TVsLed.WriteConfig(IniFile: TVsIni);
begin
  inherited;
  IniFile.WriteRect(Self.Name, 'ClipRect', ClipRect.BoundsRect);
  IniFile.WriteColor(Self.Name, 'MaskColor', MaskColor);
end;



end.

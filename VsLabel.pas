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

unit VsLabel;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsSkin, VsSysUtils;

type
  TVsTextLayout = (vlTop, vlCenter, vlBottom);
  TVsAlignment = (vaLeftJustify, vaRightJustify, vaCenter);
  TVsLabel = class(TVsSkinGraphicControl)
  private
    FAlignment: TVsAlignment;
    FAutoSize: Boolean;
    FLayout: TVsTextLayout;
    FWordWrap: Boolean;
    FFormDrag: Boolean;
    procedure SetAutoSizeValue(Value: Boolean);
    procedure SetAlignment(Value: TVsAlignment);
    procedure SetLayout(Value: TVsTextLayout);
    procedure SetWordWrap(Value: Boolean);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure AdjustBounds; dynamic;
    procedure DoDrawText(var Rect: TRect; Flags: Longint); dynamic;
    procedure Loaded; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ReadConfig(IniFile: TVsIni); override;
    procedure WriteConfig(IniFile: TVsIni); override;
  published
    property Alignment: TVsAlignment read FAlignment write SetAlignment default vaLeftJustify;
    property AutoSize: Boolean read FAutoSize write SetAutoSizeValue default True;
    property Layout: TVsTextLayout read FLayout write SetLayout default vlTop;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property FormDrag: Boolean read FFormDrag write FFormDrag default True;
    property Align;
    property Anchors;
    property Constraints;
    property Caption;
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

{ TVsLabel }

constructor TVsLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 65;
  Height := 17;
  FAlignment := vaLeftJustify;
  FAutoSize := True;
  FLayout := vlTop;
  FWordWrap := false;
  FFormDrag := True;
end;

procedure TVsLabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  Text: string;
begin
  Text := Caption;
  BitmapCanvas.Font := Font;
  if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    BitmapCanvas.Font.Color := clBtnHighlight;
    DrawText(BitmapCanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    BitmapCanvas.Font.Color := clBtnShadow;
    DrawText(BitmapCanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else
    DrawText(BitmapCanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

procedure TVsLabel.Paint;
const
  Alignments: array[TVsAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  Rect, CalcRect: TRect;
  DrawStyle: Longint;
begin
  PaintBackImage;
  with BitmapCanvas do
  begin
    Brush.Style := bsClear;
    Rect := ClientRect;
    DrawStyle := DT_EXPANDTABS or WordWraps[FWordWrap] or Alignments[FAlignment];
    if FLayout <> vlTop then
    begin
      CalcRect := Rect;
      DoDrawText(CalcRect, DrawStyle or DT_CALCRECT);
      if FLayout = vlBottom then OffsetRect(Rect, 0, Height - CalcRect.Bottom)
      else OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);
    end;
    DoDrawText(Rect, DrawStyle);
  end;
  inherited Paint;
end;

procedure TVsLabel.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;

procedure TVsLabel.AdjustBounds;
const
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  DC: HDC;
  X: Integer;
  Rect: TRect;
begin
  if not (csReading in ComponentState) and FAutoSize then
  begin
    Rect := ClientRect;
    DC := GetDC(0);
    BitmapCanvas.Handle := DC;
    DoDrawText(Rect, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[FWordWrap]);
    BitmapCanvas.Handle := 0;
    ReleaseDC(0, DC);
    X := Left;
    if Alignment = vaRightJustify then Inc(X, Width - Rect.Right);
    SetBounds(X, Top, Rect.Right, Rect.Bottom);
  end;
end;

procedure TVsLabel.SetAlignment(Value: TVsAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RepaintControl;
  end;
end;

procedure TVsLabel.SetAutoSizeValue(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    AdjustBounds;
  end;
end;

procedure TVsLabel.SetLayout(Value: TVsTextLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    RepaintControl;
  end;
end;

procedure TVsLabel.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    AdjustBounds;
    RepaintControl;
  end;
end;

procedure TVsLabel.CMTextChanged(var Message: TMessage);
begin
  AdjustBounds;
  RepaintControl;
end;

procedure TVsLabel.CMFontChanged(var Message: TMessage);
begin
  inherited;
  AdjustBounds;
end;

procedure TVsLabel.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

procedure TVsLabel.ReadConfig(IniFile: TVsIni);
begin
  Font.Color := IniFile.ReadColor(Self.Name, 'FontColor', clBlack);
  Font := IniFile.ReadFont(Self.Name, 'Font', Font);
  inherited;
end;

procedure TVsLabel.WriteConfig(IniFile: TVsIni);
begin
  inherited;
  IniFile.WriteFont(Self.Name, 'Font', Font);
  IniFile.WriteColor(Self.Name, 'FontColor', Font.Color);
end;


end.

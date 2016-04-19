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

unit VsSkin;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsControls, VsGraphics, VsComposer, VsMask, VsSysUtils;

type
  TVSkinReadWrite = procedure(Sender: TObject; Ini: TVsIni) of object;

  TVsSkin = class(TVsCustomControl)
  private
    FRgn: HRgn;
    FRgnData: TRgnData;
    FFormDrag: Boolean;
    FParentForm: TForm;
    FMaskColor: TColor;
    FGraphic: TVsGraphic;
    FGraphicName: TVsGraphicName;
    FSignature: string;
    FComposer: TVsComposer;
    FChangeLink: TVsChangeLink;
    FUpdateCount: Integer;
    FAutoSave: TStrings;
    FOnSkinRead: TVSkinReadWrite;
    FOnSkinWrite: TVSkinReadWrite;
    procedure SetMaskColor(Value: TColor);
    procedure SetGraphicName(Value: TVsGraphicName);
    procedure SetAutoSave(Value: TStrings);
    procedure SetComposer(Value: TVsComposer);
    procedure ComposerChanged(Sender: TObject);
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure UpdateRegion;
    procedure UpdateGraphic;
    procedure UpdateBounds;
    procedure DoSkinRead(Ini: TVsIni);
    procedure DoSkinWrite(Ini: TVsIni);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure UpdateGraphicControls;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure PaintBackImage(Canvas: TCanvas; Rect: TRect);
    procedure PaintGraphic(Canvas: TCanvas; Rect: TRect);
    procedure GetGraphicNames(List: TStrings);
    function GetGraphic(const Name: string): TVsGraphic;
    procedure ReadConfig(IniFile: TVsIni);
    procedure WriteConfig(IniFile: TVsIni);
    procedure ReadSkin(FileName: string);
    procedure WriteSkin(FileName: string; Mode: Integer);
  published
    property AutoSave: TStrings read FAutoSave write SetAutoSave;
    property MaskColor: TColor read FMaskColor write SetMaskColor default clNone;
    property FormDrag: Boolean read FFormDrag write FFormDrag default True;
    property GraphicName: TVsGraphicName read FGraphicName write SetGraphicName;
    property Composer: TVsComposer read FComposer write SetComposer;
    property Signature: string read FSignature write FSignature;
    property OnSkinRead: TVSkinReadWrite read FOnSkinRead write FOnSkinRead;
    property OnSkinWrite: TVSkinReadWrite read FOnSkinWrite write FOnSkinWrite;
    property Enabled;
    property Cursor;
    property DragMode;
    property DragKind;
    property DragCursor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
{$IFDEF VER130}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnDragOver;
    property OnEndDock;
    property OnDragDrop;
    property OnEndDrag;
    property OnStartDock;
    property OnStartDrag;
  end;

  TVsSkinGraphicControl = class(TVsGraphicControl)
  private
    FSkin: TVsSkin;
    FBitmap: TBitmap;
    FBackImage: TBitmap;
    FDesignColor: TColor;
    FUpdateCount: Integer;
    FRefCursor: TCursor;
    FCursorTracking: Boolean;
    function GetBitmapCanvas: TCanvas;
    procedure SetDesignColor(Value: TColor);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
  protected
    procedure Loaded; override;
    procedure SetBrushStyle(Brush: TBrush; Color: TColor);
    procedure Paint; override;
    procedure PaintBackImage;
    procedure CopyBackImage(Value: TBitmap);
    procedure UpdateGraphic(Clip: Boolean); virtual;
    procedure UpdateBounds; virtual;
    procedure RepaintControl;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure UpdateCursor(ACursor: TCursor);
    property Skin: TVsSkin read FSkin;
    property BitmapCanvas: TCanvas read GetBitmapCanvas;
    property RefCursor: TCursor read FRefCursor;
    property CursorTracking: Boolean read FCursorTracking write FCursorTracking;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure GetGraphicNames(List: TStrings);
    procedure GetGraphicBitmap(Bitmap: TBitmap); virtual;
    procedure WriteConfig(IniFile: TVsIni); virtual;
    procedure ReadConfig(IniFile: TVsIni); virtual;
  published
    property DesignColor: TColor read FDesignColor write SetDesignColor default clRed;
  end;


implementation


uses
  VsConst;

{ TVsSkin }

constructor TVsSkin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque, csAcceptsControls];
  SetBounds(0, 0, 300, 200);
  FMaskColor := clNone;
  FFormDrag := True;
  FSignature := '';
  FRgnData := TRgnData.Create;
  FAutoSave := TStringList.Create;
  FChangeLink := TVsChangeLink.Create;
  FChangeLink.OnChange := ComposerChanged;
end;

destructor TVsSkin.Destroy;
begin
  if FRgn <> 0 then
    DeleteObject(FRgn);
  FRgnData.Free;
  FChangeLink.Free;
  FAutoSave.Free;
  inherited Destroy;
end;

procedure TVsSkin.SetParent(AParent: TWinControl);
begin
  if AParent <> nil then
  begin
    if not (AParent is TForm) then
      raise Exception.Create('TVsSkin needs to be placed on a form.');
    TForm(AParent).BorderStyle := bsNone;
    FParentForm := AParent as TForm;
  end;
  inherited SetParent(AParent);
end;

procedure TVsSkin.Loaded;
begin
  inherited Loaded;
  UpdateGraphicControls;
end;

procedure TVsSkin.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
    if AComponent = Composer then Composer := nil;
end;

procedure TVsSkin.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TVsSkin.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then UpdateGraphicControls;
end;

procedure TVsSkin.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  ALeft := 0;
  ATop := 0;
  if FGraphic <> nil then
  begin
    AWidth := FGraphic.Bitmap.Width;
    AHeight := FGraphic.Bitmap.Height;
  end;
  inherited;
end;

procedure TVsSkin.UpdateBounds;
var
  R: TRect;
begin
  R := ClientRect;
  SetBounds(Left, Top, Width, Height);
  if not Designing then
    if FParentForm <> nil then
    begin
      FParentForm.ClientWidth := Width;
      FParentForm.ClientHeight := Height;
    end;
  if CompareRect(R, ClientRect) then
    Repaint;
end;

procedure TVsSkin.UpdateRegion;
begin
  if FRgn <> 0 then
  begin
    DeleteObject(FRgn);
    SetWindowRgn(Parent.Handle, 0, False);
    FRgn := 0;
  end;
  if FRgnData.Size > 0 then
  begin
    FRgn := FRgnData.CreateRegion;
    SetWindowRgn(Parent.Handle, FRgn, Parent.Visible);
  end;
end;

procedure TVsSkin.UpdateGraphic;
begin
  FGraphic := GetGraphic(GraphicName);
  if not Designing then
  begin
    FRgnData.Size := 0;
    if (FGraphic <> nil) then
    begin
      if MaskColor <> clNone then
        ExtGenerateMask(Left, Top, FGraphic.Bitmap, MaskColor, FRgnData);
    end;
    UpdateRegion;
  end;
end;

procedure TVsSkin.UpdateGraphicControls;
var
  I: Integer;
begin
  if not Loading then
  begin
    if FUpdateCount > 0 then
      Exit;
    UpdateGraphic;
    for I := 0 to ControlCount - 1 do
      if (Controls[I] is TVsSkinGraphicControl) then
        TVsSkinGraphicControl(Controls[I]).UpdateGraphic(false);
    UpdateBounds;
  end;
end;

procedure TVsSkin.Paint;
begin
  if (FGraphic = nil) then
  begin
    with inherited Canvas do
    begin
      Pen.Style := psDot;
      Brush.Color := clWindow;
      Rectangle(0, 0, Width, Height);
    end;
  end else
    Canvas.Draw(0, 0, FGraphic.Bitmap);
end;

procedure TVsSkin.SetMaskColor(Value: TColor);
begin
  if FMaskColor <> Value then
  begin
    FMaskColor := Value;
    UpdateGraphicControls;
  end;
end;

procedure TVsSkin.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbleft then
  begin
    if FFormDrag then
    begin
      ReleaseCapture;
      TWinControl(Parent).Perform(WM_SYSCOMMAND, $F012, 0);
    end;
  end;
end;

procedure TVsSkin.PaintGraphic(Canvas: TCanvas; Rect: TRect);
begin
  if FGraphic <> nil then
    BitBlt(Canvas.Handle, 0, 0, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top,
      FGraphic.Bitmap.Canvas.Handle, Rect.Left, Rect.Top, SRCCOPY)
end;

procedure TVsSkin.PaintBackImage(Canvas: TCanvas; Rect: TRect);
begin
  if FGraphic <> nil then
    BitBlt(Canvas.Handle, 0, 0, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top,
      FGraphic.Bitmap.Canvas.Handle, Rect.Left, Rect.Top, SRCCOPY)
  else
  begin
    Canvas.Brush.Color := clWindow;
    Canvas.FillRect(Bounds(0, 0, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top));
  end;
end;

procedure TVsSkin.SetComposer(Value: TVsComposer);
begin
  if FComposer <> nil then
    FComposer.RemoveLink(FChangeLink);
  FComposer := Value;
  if FComposer <> nil then
    FComposer.InsertLink(FChangeLink);
  UpdateGraphicControls;
end;

procedure TVsSkin.ComposerChanged(Sender: TObject);
begin
  UpdateGraphicControls;
end;

procedure TVsSkin.SetAutoSave(Value: TStrings);
begin
  FAutoSave.Assign(Value);
end;

procedure TVsSkin.SetGraphicName(Value: TVsGraphicName);
begin
  if FGraphicName <> Value then
  begin
    FGraphicName := Value;
    UpdateGraphicControls;
  end;
end;

procedure TVsSkin.GetGraphicNames(List: TStrings);
begin
  List.Clear;
  if Composer <> nil then
    Composer.GetGraphicNames(List);
end;

function TVsSkin.GetGraphic(const Name: string): TVsGraphic;
var
  Index: Integer;
begin
  Result := nil;
  if Composer <> nil then
  begin
    Index := Composer.Graphics.IndexByName(Name);
    if Index <> -1 then
      Result := Composer.Graphics[Index];
  end;
end;

procedure TVsSkin.ReadConfig(IniFile: TVsIni);
begin
  Hint := IniFile.ReadString(Self.Name, 'Hint', '');
  ShowHint := IniFile.ReadBool(Self.Name, 'ShowHint', false);
  MaskColor := IniFile.ReadColor(Self.Name, 'MaskColor', clNone);
end;

procedure TVsSkin.WriteConfig(IniFile: TVsIni);
begin
  IniFile.WriteDefaultString(Self.Name, 'Hint', Hint, '');
  IniFile.WriteBool(Self.Name, 'ShowHint', ShowHint);
  IniFile.WriteColor(Self.Name, 'MaskColor', MaskColor);
end;

procedure TVsSkin.DoSkinRead(Ini: TVsIni);
begin
  if Assigned(FOnSkinRead) then
    FOnSkinRead(Self, Ini);
end;

procedure TVsSkin.DoSkinWrite(Ini: TVsIni);
begin
  if Assigned(FOnSkinWrite) then
    FOnSkinWrite(Self, Ini);
end;

type
  Hack = class(TControl)
  public
    property Color;
    property Font;
  end;

procedure TVsSkin.WriteSkin(FileName: string; Mode: Integer);
var
  Ini: TVsIni;
  Path: string;
  Dest: string;
  I: Integer;
  Control: TVsSkinGraphicControl;

  procedure WriteControl(Name: string);
  var
    I: Integer;
    C: TControl;
  begin
    for I := 0 to ControlCount - 1 do
      if Controls[I].Name = Name then
      begin
        C := Controls[I];
        Ini.WriteRect(Name, 'Rect', C.BoundsRect);
        Ini.WriteColor(Name, 'Color', Hack(C).Color);
        Ini.WriteDefaultString(Name, 'Hint', C.Hint, '');
        Ini.WriteDefaultBool(Name, 'ShowHint', C.ShowHint, False);
        Ini.WriteFont(Name, 'Font', Hack(C).Font);
        Ini.WriteColor(Name, 'FontColor', Hack(C).Font.Color);
      end;
  end;

begin
  Path := ExtractFilePath(FileName);
  Dest := ChangeFileExt(FileName, '.vsf');
  Ini := TVsIni.Create(FileName);
  try
    Ini.Clear;
    Ini.WriteInteger('Defaults', 'Mode', Mode);
    Ini.WriteDefaultString('Defaults', 'Signature', Signature, '');
    WriteConfig(Ini);
    for I := 0 to ControlCount - 1 do
      if Controls[I] is TVsSkinGraphicControl then
      begin
        Control := TVsSkinGraphicControl(Controls[I]);
        Control.WriteConfig(Ini);
      end;

    for I := 0 to AutoSave.Count - 1 do
      WriteControl(AutoSave[I]);

    if Composer <> nil then
    begin
      if Mode = 0 then
        Composer.Graphics.SaveToFolder(Path)
      else Composer.Graphics.SaveToFile(Dest);
    end;
    DoSkinWrite(Ini);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

procedure TVsSkin.ReadSkin(FileName: string);
var
  Ini: TVsIni;
  Path: string;
  Dest, Ident: string;
  I, Mode: Integer;
  Control: TVsSkinGraphicControl;
  VisibleChanged: Boolean;

  procedure ReadControl(Name: string);
  var
    I: Integer;
    C: TControl;
  begin
    for I := 0 to ControlCount - 1 do
      if Controls[I].Name = Name then
      begin
        C := Controls[I];
        C.BoundsRect := Ini.ReadRect(Name, 'Rect', BoundsRect);
        Hack(C).Color := Ini.ReadColor(Name, 'Color', Hack(C).Color);
        C.Hint := Ini.ReadString(Name, 'Hint', '');
        C.ShowHint := Ini.ReadBool(Name, 'ShowHint', False);
        Hack(C).Font := Ini.ReadFont(Self.Name, 'Font', Hack(C).Font);
        Hack(C).Font.Color := Ini.ReadColor(Self.Name, 'FontColor', Hack(C).Font.Color);
      end;
  end;

begin
  VisibleChanged := false;
  if (not Designing) and (Parent.Visible) then
  begin
    Parent.Hide;
    VisibleChanged := True;
  end;

  try
    BeginUpdate;
    try
      if not FileExists(FileName) then
        raise Exception.Create('No skin description file found.');

      Path := ExtractFilePath(FileName);
      Dest := ChangeFileExt(FileName, '.vsf');

      Ini := TVsIni.Create(FileName);
      try
        Ident := Ini.ReadString('Defaults', 'Signature', '');
        if Ident <> Signature then
           raise Exception.Create('Invalid or unknown file signature.');

        ReadConfig(Ini);
        for I := 0 to ControlCount - 1 do
          if Controls[I] is TVsSkinGraphicControl then
          begin
            Control := TVsSkinGraphicControl(Controls[I]);
            Control.ReadConfig(Ini);
          end;

        for I := 0 to AutoSave.Count - 1 do
          ReadControl(AutoSave[I]);

        Mode := Ini.ReadInteger('Defaults', 'Mode', 1);
        if Composer <> nil then
        begin
          if Mode = 0 then
            Composer.Graphics.LoadFromFolder(Path)
          else Composer.Graphics.LoadFromFile(Dest);
        end;
        DoSkinRead(Ini);
      finally
        Ini.Free;
      end;
    finally
      EndUpdate;
    end;

  finally
    if VisibleChanged then
      Parent.Show;
  end;
end;

{ TVsSkinGraphicControl }

constructor TVsSkinGraphicControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csOpaque];
  FDesignColor := clRed;
  FCursorTracking := false;
  FBitmap := TBitmap.Create;
  FBackImage := TBitmap.Create;
end;

destructor TVsSkinGraphicControl.Destroy;
begin
  FBitmap.Free;
  FBackImage.Free;
  inherited Destroy;
end;

procedure TVsSkinGraphicControl.Loaded;
begin
  inherited Loaded;
  UpdateCursor(crDefault);
end;

procedure TVsSkinGraphicControl.SetParent(AParent: TWinControl);
begin
  if AParent <> nil then
  begin
    if not (AParent is TVsSkin) then
      raise Exception.Create('Control needs to be placed on a TVsSkin component.');
    FSkin := AParent as TVsSkin;
  end;
  inherited SetParent(AParent);
end;

procedure TVsSkinGraphicControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  FBitmap.Width := AWidth;
  FBitmap.Height := AHeight;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TVsSkinGraphicControl.UpdateBounds;
var
  R: TRect;
begin
  if not Loading then
  begin
    R := ClientRect;
    SetBounds(Left, Top, Width, Height);
    if CompareRect(R, ClientRect) then
      Invalidate;
  end;
end;

procedure TVsSkinGraphicControl.RepaintControl;
begin
  if FUpdateCount = 0 then
    if not Loading then
    begin
      ControlStyle := ControlStyle + [csOpaque];
      Repaint;
      ControlStyle := ControlStyle - [csOpaque];
    end;
end;

procedure TVsSkinGraphicControl.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TVsSkinGraphicControl.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then RepaintControl;
end;

procedure TVsSkinGraphicControl.UpdateGraphic;
begin
end;

function TVsSkinGraphicControl.GetBitmapCanvas: TCanvas;
begin
  Result := FBitmap.Canvas;
end;

procedure TVsSkinGraphicControl.GetGraphicNames(List: TStrings);
begin
  List.Clear;
  if Skin <> nil then
    Skin.GetGraphicNames(List);
end;

procedure TVsSkinGraphicControl.SetBrushStyle(Brush: TBrush; Color: TColor);
begin
  Brush.Color := Color;
  Brush.Style := bsSolid;
  if Color <> clNone then
    Brush.Style := bsClear;
end;

procedure TVsSkinGraphicControl.Paint;
begin
  if Designing then
    with BitmapCanvas do
    begin
      Pen.Style := psDot;
      Pen.Color := DesignColor;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;

  with inherited Canvas do
    Draw(0, 0, FBitmap);
end;

procedure TVsSkinGraphicControl.PaintBackImage;
begin
  if (not (csOpaque in ControlStyle)) then
  begin
    FBackImage.Width := Self.Width;
    FBackImage.Height := Self.Height;
    with Canvas do
      FBackImage.Canvas.CopyRect(ClipRect, Self.Canvas, ClipRect);
  end;
  FBitmap.Assign(FBackImage);
end;

procedure TVsSkinGraphicControl.CopyBackImage(Value: TBitmap);
begin
  Value.Assign(FBackImage);
end;

procedure TVsSkinGraphicControl.SetDesignColor(Value: TColor);
begin
  if FDesignColor <> Value then
  begin
    FDesignColor := Value;
    RepaintControl;
  end;
end;

procedure TVsSkinGraphicControl.GetGraphicBitmap(Bitmap: TBitmap);
begin
  Bitmap.Assign(nil);
end;

procedure TVsSkinGraphicControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  UpdateCursor(crDefault);
end;

procedure TVsSkinGraphicControl.CMCursorChanged(var Message: TMessage);
begin
  inherited;
  FRefCursor := Cursor;
end;

procedure TVsSkinGraphicControl.UpdateCursor(ACursor: TCursor);
var
  C: TCursor;
begin
  if not Designing then
    if CursorTracking then
    begin
      C := FRefCursor;
      try
        Cursor := ACursor;
      finally
        FRefCursor := C;
      end;
    end;
end;

procedure TVsSkinGraphicControl.ReadConfig(IniFile: TVsIni);
begin
  BoundsRect := IniFile.ReadRect(Self.Name, 'Rect', BoundsRect);
  Hint := IniFile.ReadString(Self.Name, 'Hint', '');
  ShowHint := IniFile.ReadBool(Self.Name, 'ShowHint', False);
end;

procedure TVsSkinGraphicControl.WriteConfig(IniFile: TVsIni);
begin
  IniFile.WriteRect(Self.Name, 'Rect', BoundsRect);
  IniFile.WriteDefaultString(Self.Name, 'Hint', Hint, '');
  IniFile.WriteDefaultBool(Self.Name, 'ShowHint', ShowHint, False);
end;



end.

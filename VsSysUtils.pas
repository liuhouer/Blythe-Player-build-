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

unit VsSysUtils;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles;


type
  TVsIni = class(TMemIniFile)
  public
    function ReadRect(const Section, Ident: string; Default: TRect): TRect;
    function ReadFont(const Section, Ident: string; Default: TFont): TFont;
    function ReadColor(const Section, Ident: string; Default: TColor): TColor;
    procedure WriteRect(const Section, Ident: string; Value: TRect);
    procedure WriteFont(const Section, Ident: string; Value: TFont);
    procedure WriteColor(const Section, Ident: string; Value: TColor);
    procedure WriteDefaultString(const Section, Ident: string; Value, Default: string);
    procedure WriteDefaultBool(const Section, Ident: string; Value, Default: Boolean);
  end;

procedure BackupFile(FileName: string);
function CompareRect(R1, R2: TRect): Boolean;
function MinInteger(N1, N2: Integer): Integer;
function MaxInteger(N1, N2: Integer): Integer;
function WidthOf(R: TRect): Integer;
function HeightOf(R: TRect): Integer;
function SolveForX(Y, Z: Longint): Longint;
function SolveForY(X, Z: Longint): Longint;
function IMin(Value1, Value2: Integer): Integer;
function IMax(Value1, Value2: Integer): Integer;
function GetParam(var S: string; SEP: Char): string;
function BitmapRect(Bitmap: TBitmap): TRect;

function RectToStr(R: TRect): string;
function RGBToStr(Color: TColor): string;
function FontToStr(Font: TFont): string;

function StrToRect(S: string): TRect;
function StrToRGB(S: string): TColor;
procedure StrToFont(Str: string; Font: TFont);

function AddPathSlash(S: string): string;

function GetParentControl(Control: TControl): TControl;

function EmptyRect: TRect;

procedure ChangeBitmapColor(Bitmap: TBitmap; FromColor, ToColor: TColor);


implementation


procedure BackupFile(FileName: string);
var
  Bak: string;
begin
  Bak := FileName;
  Bak := ChangeFileExt(Bak, '.$$$');
  if FileExists(Bak) then DeleteFile(Bak);
  RenameFile(FileName, Bak);
end;

function CompareRect(R1, R2: TRect): Boolean;
begin
  Result := (R1.Left = R2.Left) and
            (R1.Top = R2.Top) and
            (R1.Right = R2.Right) and
            (R1.Bottom = R2.Bottom);
end;

function MinInteger(N1, N2: Integer): Integer;
begin
  Result := N1;
  if Result > N2 then Result := N2;
end;

function MaxInteger(N1, N2: Integer): Integer;
begin
  Result := N2;
  if Result < N1 then Result := N1;
end;

function WidthOf(R: TRect): Integer;
begin
  Result := R.Right - R.Left;
end;

function HeightOf(R: TRect): Integer;
begin
  Result := R.Bottom - R.Top;
end;

{ This function solves for x in the equation "x is y% of z". }
function SolveForX(Y, Z: Longint): Longint;
begin
  Result := Longint(Trunc( Z * (Y * 0.01) ));
end;

{ This function solves for y in the equation "x is y% of z". }
function SolveForY(X, Z: Longint): Longint;
begin
  if Z = 0 then Result := 0
  else Result := Longint(Trunc( (X * 100.0) / Z ));
end;

function IMin(Value1, Value2: Integer): Integer;
begin
  Result := Value1;
  if Result > Value2 then Result := Value2;
end;

function IMax(Value1, Value2: Integer): Integer;
begin
  Result := Value2;
  if Result < Value1 then Result := Value1;
end;

function GetParam(var S: string; SEP: Char): string;
var
  P: Integer;
begin
  P := Pos(SEP, S);
  if P = 0 then
  begin
    Result := S;
    S := '';
  end else
  begin
    Result := Copy(S, 1, P - 1);
    Delete(S, 1, P);
  end;
end;

function BitmapRect(Bitmap: TBitmap): TRect;
begin
  Result := Rect(0, 0, Bitmap.Width, Bitmap.Height);
end;

function RectToStr(R: TRect): string;
begin
  Result :=
    IntToStr(R.Left) + ',' +
    IntToStr(R.Top) + ',' +
    IntToStr(WidthOf(R)) + ',' +
    IntToStr(HeightOf(R));
end;

function StrToRect(S: string): TRect;
begin
  Result.Left := StrToInt(GetParam(S, ','));
  Result.Top  := StrToInt(GetParam(S, ','));
  Result.Right := Result.Left + StrToInt(GetParam(S, ','));
  Result.Bottom := Result.Top + StrToInt(GetParam(S, ','));
end;

function Color2RGB(Color: TColor): Longint;
begin
  if Color < 0 then
    Result := GetSysColor(Color and $000000FF)
  else Result := Color;
end;

function RGBToStr(Color: TColor): string;
var
  C: Longint;
  R, G, B: Byte;
begin
  C := Color2RGB(Color);
  Result := IntToStr(C);
  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);
  Result := IntToStr(R) + ',' + IntToStr(G) + ',' + IntToStr(B);
end;

{ CorrectColor }
function CorrectColor(C: Real) : Integer;
begin
  Result := Round(C);
  if Result > 255 then Result := 255
  else if Result < 0 then Result := 0;
end;

{ ERGB }
function ERGB(R, G, B: Real): TColor;
begin
  Result := RGB(CorrectColor(R), CorrectColor(G), CorrectColor(B));
end;

function StrToRGB(S: string): TColor;
var
  R, G, B: Byte;
begin
  R := StrToInt(GetParam(S, ','));
  G := StrToInt(GetParam(S, ','));
  B := StrToInt(GetParam(S, ','));
  Result := ERGB(R, G, B);
end;

function FontStylesToString(Styles: TFontStyles): string;
begin
  Result := '';
  if fsBold in Styles then Result := Result + 'B';
  if fsItalic in Styles then Result := Result + 'I';
  if fsUnderline in Styles then Result := Result + 'U';
  if fsStrikeOut in Styles then Result := Result + 'S';
end;

function StringToFontStyles(const Styles: string): TFontStyles;
begin
  Result := [];
  if Pos('B', UpperCase(Styles)) > 0 then Include(Result, fsBold);
  if Pos('I', UpperCase(Styles)) > 0 then Include(Result, fsItalic);
  if Pos('U', UpperCase(Styles)) > 0 then Include(Result, fsUnderline);
  if Pos('S', UpperCase(Styles)) > 0 then Include(Result, fsStrikeOut);
end;

function FontToStr(Font: TFont): string;
begin
  with Font do
    Result := Format('%s,%d,%s,%d,%d', [Name, Size,
      FontStylesToString(Style), Ord(Pitch), Charset]);
end;

procedure StrToFont(Str: string; Font: TFont);
const
  Delims = [',', ';'];
var
  I: Byte;
  S: string;
begin
  I := 0;
  while Str <> '' do
  begin
    Inc(I);
    S := GetParam(Str, ',');
    case I of
      1: Font.Name := S;
      2: Font.Size := StrToIntDef(S, Font.Size);
      3: Font.Style := StringToFontStyles(S);
      4: Font.Pitch := TFontPitch(StrToIntDef(S, Ord(Font.Pitch)));
      5: Font.Charset := TFontCharset(StrToIntDef(S, Font.Charset));
    end;
  end;
end;

function AddPathSlash(S: string): string;
begin
  if (S <> '') and (S[Length(S)] <> '\') then
    S := S + '\';
  Result := S;
end;

function GetParentControl(Control: TControl): TControl;
var
  AParent: TControl;
begin
  Result := nil;
  AParent := Control.Parent;
  while (AParent <> nil) and (AParent is TWinControl) do
  begin
    Result := AParent;
    AParent := Result.Parent;
  end;
end;

function EmptyRect: TRect;
begin
  Result := Bounds(0, 0, 0, 0);
end;

{ ChangeBitmapColor }

procedure ChangeBitmapColor(Bitmap: TBitmap; FromColor, ToColor: TColor);
const
  ROP_DSPDxax = $00E20746;
var
  DestDC: HDC;
  DDB, MonoBmp: TBitmap;
  IWidth, IHeight: Integer;
  IRect: TRect;
begin
  IWidth := Bitmap.Width;
  IHeight := Bitmap.Height;
  IRect := Rect(0, 0, IWidth, IHeight);

  MonoBmp := TBitmap.Create;
  DDB := TBitmap.Create;
  try
    DDB.Assign(Bitmap);
    DDB.HandleType := bmDDB;

    with Bitmap.Canvas do
    begin
      MonoBmp.Width := IWidth;
      MonoBmp.Height := IHeight;
      MonoBmp.Monochrome := True;

      DDB.Canvas.Brush.Color := FromColor;
      MonoBmp.Canvas.CopyRect(IRect, DDB.Canvas, IRect);

      Brush.Color := ToColor;
      DestDC := Bitmap.Canvas.Handle;

      SetTextColor(DestDC, clBlack);
      SetBkColor(DestDC, clWhite);
      BitBlt(DestDC, 0, 0, IWidth, IHeight,
      MonoBmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
    end;
  finally
    DDB.Free;
    MonoBmp.Free;
  end;
end;

{ TVsIni }

function TVsIni.ReadRect(const Section, Ident: string; Default: TRect): TRect;
var
  Value: string;
begin
  Value := ReadString(Section, Ident, RectToStr(Default));
  Result := StrToRect(Value);
end;

function TVsIni.ReadFont(const Section, Ident: string; Default: TFont): TFont;
var
  Value: string;
begin
  Value := ReadString(Section, Ident, FontToStr(Default));
  Result := Default;
  StrToFont(Value, Result);
end;

function TVsIni.ReadColor(const Section, Ident: string; Default: TColor): TColor;
var
  Value: string;
begin
  Value := ReadString(Section, Ident, RGBToStr(ColorToRGB(Default)));
  if Value = '' then Result := clNone
  else Result := StrToRGB(Value);
end;

procedure TVsIni.WriteRect(const Section, Ident: string; Value: TRect);
begin
  WriteString(Section, Ident, RectToStr(Value));
end;

procedure TVsIni.WriteFont(const Section, Ident: string; Value: TFont);
begin
  WriteString(Section, Ident, FontToStr(Value));
end;

procedure TVsIni.WriteColor(const Section, Ident: string; Value: TColor);
var
  S: string;
begin
  S := '';
  if Value <> clNone then
    S := RGBToStr(Value);
  WriteString(Section, Ident, S);
end;

procedure TVsIni.WriteDefaultString(const Section, Ident: string; Value, Default: string);
begin
  if Value <> Default then
    WriteString(Section, Ident, Value);
end;

procedure TVsIni.WriteDefaultBool(const Section, Ident: string; Value, Default: Boolean);
begin
  if Value <> Default then
    WriteBool(Section, Ident, Value);
end;


end.

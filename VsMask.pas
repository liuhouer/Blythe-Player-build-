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

unit VsMask;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TRgnData = class(TPersistent)
  private
    FSize: Integer;
    FBuffer: PRgnData;
    procedure SetSize(Value: Integer);
  public
    destructor Destroy; override;
    procedure Clear;
    function CreateRegion: HRgn;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    property Size: Integer read FSize write SetSize;
    property Buffer: PRgnData read FBuffer write FBuffer;
  end;


procedure ExtGenerateMask(Left, Top: Integer; Bitmap: TBitmap;
  TransparentColor: TColor; RgnData: TRgnData);


implementation

{ TRgnData }

destructor TRgnData.Destroy;
begin
  SetSize(0);
  inherited Destroy;
end;

procedure TRgnData.Clear;
begin
  SetSize(0);
end;

procedure TRgnData.SetSize(Value: Integer);
begin
  if FSize <> Value then
  begin
    FSize := Value;
    ReallocMem(FBuffer, Value);
  end;
end;

procedure TRgnData.LoadFromStream(Stream: TStream);
var
  NewSize: Integer;
begin
  Stream.Read(NewSize, Sizeof(NewSize));
  SetSize(NewSize);
  Stream.Read(FBuffer^, NewSize);
end;

procedure TRgnData.SaveToStream(Stream: TStream);
begin
  Stream.Write(FSize, Sizeof(FSize));
  Stream.Write(FBuffer^, FSize);
end;

function TRgnData.CreateRegion: HRgn;
begin
  Result := ExtCreateRegion(nil, Size, Buffer^);
end;

procedure ExtGenerateMask(Left, Top: Integer; Bitmap: TBitmap;
  TransparentColor: TColor; RgnData: TRgnData);
var
  X, Y: integer;
  Rgn1: HRgn;
  Rgn2: HRgn;
  StartX, EndX: Integer;
  OldCursor: TCursor;
begin
  Rgn1 := 0;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    for Y := 0 to Bitmap.Height - 1 do
    begin
      X := 0;
      repeat
        while (Bitmap.Canvas.Pixels[X, Y] = TransparentColor) and
          (X <= Bitmap.Width - 1) do Inc(X);
        StartX := X;

        Inc(X);
        while (Bitmap.Canvas.Pixels[X, Y] <> TransparentColor) and
         (X <= Bitmap.Width - 1) do Inc(X);
        EndX := X;

        if StartX < Bitmap.Width - 1 then
        begin
          if Rgn1 = 0 then
            Rgn1 := CreateRectRgn(Left + StartX, Top + Y, Left + EndX, Top + Y + 1)
          else
          begin
            Rgn2 := CreateRectRgn(Left + StartX, Top + Y, Left + EndX, Top + Y + 1);
            if Rgn2 <> 0 then CombineRgn(Rgn1, Rgn1, Rgn2, RGN_OR);
            DeleteObject(Rgn2);
          end;
        end;
      until X >= Bitmap.Width - 1;
    end;

    if (Rgn1 <> 0) then
    begin
      RgnData.Size := GetRegionData(Rgn1, 0, nil);
      GetRegionData(Rgn1, RgnData.Size, RgnData.Buffer);
      DeleteObject(Rgn1);
    end;

  finally
    Screen.Cursor := OldCursor;
  end;
end;


end.

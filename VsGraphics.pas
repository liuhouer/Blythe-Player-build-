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

unit VsGraphics;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsClasses;

type
  TVsGraphicName = string[255];

  TVsGraphic = class(TVsPersistent)
  private
    FName: string;
    FBitmap: TBitmap;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    property Name: string read FName write FName;
    property Bitmap: TBitmap read FBitmap write FBitmap;
  end;

  TVsGraphics = class(TVsPersistent)
  private
    FItems: TList;
    function GetCount: Integer;
    function GetGraphic(Index: Integer): TVsGraphic;
    procedure SetGraphic(Index: Integer; Value: TVsGraphic);
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Source: TPersistent); override;
    function Add(Value: TVsGraphic): Integer;
    procedure Delete(Index: Integer);
    procedure Insert(Index: Integer; Value: TVsGraphic);
    procedure Exchange(Index1, Index2: Integer);
    procedure Move(CurIndex, NewIndex: Integer);
    function IndexOf(Graphic: TVsGraphic): Integer;
    function IndexByName(const Name: string): Integer;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromFile(const FileName: string); virtual;
    procedure SaveToFile(const FileName: string); virtual;
    procedure LoadFromFolder(const Folder: string);
    procedure SaveToFolder(const Folder: string);
    property Graphics[Index: Integer]: TVsGraphic read GetGraphic write SetGraphic; default;
    property Count: Integer read GetCount;
  end;

function Gw(Graphic: TVsGraphic): Integer;
function Gh(Graphic: TVsGraphic): Integer;


implementation

const
  FileId: Integer = 78839222;

function Gw(Graphic: TVsGraphic): Integer;
begin
  Result := Graphic.Bitmap.Width;
end;

function Gh(Graphic: TVsGraphic): Integer;
begin
  Result := Graphic.Bitmap.Height;
end;

procedure StrToStream(Stream: TStream; Value: string);
var
  Len: Integer;
begin
  Len := Length(Value);
  Stream.Write(Len, Sizeof(Integer));
  if Len > 0 then
    Stream.Write(Value[1], Len);
end;

procedure StrFromStream(Stream: TStream; var Value: string);
var
  Len: Integer;
begin
  Stream.Read(Len, Sizeof(Integer));
  if Len > 0 then
  begin
    SetLength(Value, Len);
    Stream.Read(Value[1], Len);
  end;
end;

{ BitmapToStream }
procedure BitmapToStream(Stream: TStream; Bitmap: TBitmap);
var
  Empty: Boolean;
begin
  Empty := Bitmap.Empty;
  Stream.Write(Empty, Sizeof(Boolean));
  if not Empty then Bitmap.SaveToStream(Stream);
end;

{ BitmapFromStream }
procedure BitmapFromStream(Stream: TStream; Bitmap: TBitmap);
var
  Empty: Boolean;
begin
  Stream.Read(Empty, Sizeof(Boolean));
  if not Empty then Bitmap.LoadFromStream(Stream)
  else Bitmap.Assign(nil);
end;

{ TVsGraphic }

constructor TVsGraphic.Create;
begin
  FBitmap := TBitmap.Create;
end;

destructor TVsGraphic.Destroy;
begin
  FBitmap.Free;
  inherited Destroy;
end;

procedure TVsGraphic.Assign(Source: TPersistent);
begin
  if Source is TVsGraphic then
  begin
    BeginUpdate;
    try
      Name := TVsGraphic(Source).Name;
      Bitmap.Assign(TVsGraphic(Source).Bitmap);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TVsGraphic.LoadFromStream(Stream: TStream);
begin
  StrFromStream(Stream, FName);
  BitmapFromStream(Stream, FBitmap);
end;

procedure TVsGraphic.SaveToStream(Stream: TStream);
begin
  StrToStream(Stream, FName);
  BitmapToStream(Stream, FBitmap);
end;

{ TVsGraphics }

constructor TVsGraphics.Create;
begin
  inherited;
  FItems := TList.Create;
end;

destructor TVsGraphics.Destroy;
begin
  OnChange := nil;
  Clear;
  FItems.Free;
  inherited Destroy;
end;

procedure TVsGraphics.Clear;
begin
  BeginUpdate;
  try
    while Count > 0 do Delete(0);
  finally
    EndUpdate;
  end;
end;

function TVsGraphics.Add(Value: TVsGraphic): Integer;
begin
  Result := FItems.Add(nil);
  FItems[Result] := TVsGraphic.Create;
  Graphics[Result].Assign(Value);
  Changed;
end;

procedure TVsGraphics.Insert(Index: Integer; Value: TVsGraphic);
begin
  FItems.Insert(Index, nil);
  FItems[Index] := TVsGraphic.Create;
  Graphics[Index].Assign(Value);
  Changed;
end;

procedure TVsGraphics.Delete(Index: Integer);
begin
  TVsGraphic(FItems[Index]).Free;
  FItems.Delete(Index);
  Changed;
end;

procedure TVsGraphics.Exchange(Index1, Index2: Integer);
begin
  FItems.Exchange(Index1, Index2);
  Changed;
end;

function TVsGraphics.IndexOf(Graphic: TVsGraphic): Integer;
begin
  Result := FItems.IndexOf(Graphic);
end;

function TVsGraphics.IndexByName(const Name: string): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if AnsiCompareText(Name, Graphics[Result].Name) = 0 then
      Exit;
  Result := -1;
end;

procedure TVsGraphics.Move(CurIndex, NewIndex: Integer);
begin
  FItems.Move(CurIndex, NewIndex);
  Changed;
end;

function TVsGraphics.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TVsGraphics.GetGraphic(Index: Integer): TVsGraphic;
begin
  Result := FItems[Index];
end;

procedure TVsGraphics.SetGraphic(Index: Integer; Value: TVsGraphic);
begin
  Graphics[Index].Assign(Value);
  Changed;
end;

procedure TVsGraphics.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source = nil then Clear
  else if Source is TVsGraphics then
  begin
    BeginUpdate;
    try
      Clear;
      for I := 0 to TVsGraphics(Source).Count - 1 do
        Add(TVsGraphics(Source).Graphics[I]);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TVsGraphics.ReadData(Stream: TStream);
begin
  BeginUpdate;
  try
    Clear;
    LoadFromStream(Stream);
  finally
    EndUpdate;
  end;
end;

procedure TVsGraphics.WriteData(Stream: TStream);
begin
  BeginUpdate;
  try
    SaveToStream(Stream);
  finally
    EndUpdate;
  end;
end;

procedure TVsGraphics.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    Result := Count > 0;
  end;

begin
  Filer.DefineBinaryProperty('Graphics', ReadData, WriteData, DoWrite);
end;

procedure TVsGraphics.LoadFromStream(Stream: TStream);
var
  Graphic: TVsGraphic;
  I, Id, Cnt: Integer;
begin
  Clear;
  Graphic := TVsGraphic.Create;
  try
    Stream.Read(Id, Sizeof(Integer));
    if FileId <> Id then raise Exception.Create('Invalid file format.');
    Stream.Read(Cnt, Sizeof(Integer));
    for I := 0 to Cnt - 1 do
    begin
      Graphic.LoadFromStream(Stream);
      Add(Graphic);
    end;
  finally
    Graphic.Free;
  end;
end;

procedure TVsGraphics.SaveToStream(Stream: TStream);
var
  I, Cnt: Integer;
begin
  Cnt := Count;
  Stream.Write(FileId, Sizeof(Integer));
  Stream.Write(Cnt, Sizeof(Integer));
  for I := 0 to Count - 1 do
    TVsGraphic(Graphics[I]).SaveToStream(Stream);
end;

procedure TVsGraphics.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    BeginUpdate;
    try
      LoadFromStream(Stream);
    finally
      EndUpdate;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TVsGraphics.SaveToFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TVsGraphics.LoadFromFolder(const Folder: string);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Count - 1 do
      with Graphics[I] do
        Bitmap.LoadFromFile(Folder + Name);
  finally
    EndUpdate;
  end;
end;

procedure TVsGraphics.SaveToFolder(const Folder: string);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    with Graphics[I] do
      Bitmap.SaveToFile(Folder + Name);
end;


end.

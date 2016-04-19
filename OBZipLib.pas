unit OBZipLib;

interface

uses
  Windows, Messages, SysUtils, Classes, Zlib, Dialogs, Forms;

type
  TOBZipEvent = procedure(Sender : TObject;lProgress : Integer) of object;

  TOBZipLib = class(TComponent)
  private
    lOldSize : Integer;
    FAbout : String;
    FCompressProgress : TOBZipEvent;
    FDeCompressProgress : TOBZipEvent;
  protected
    procedure OnProgress(Sender : TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Compress(InFile,OutFile : TFileName); overload;
    procedure Compress(InFile : TFileName;OutStream : TMemoryStream); overload;
    procedure Compress(InStream : TMemoryStream;OutFile : TFileName); overload;
    procedure Compress(InStream : TMemoryStream;OutStream : TMemoryStream); overload;
    procedure DeCompress(InFile,OutFile : TFileName); overload;
    procedure DeCompress(InFile : TFileName;OutStream : TMemoryStream); overload;
    procedure DeCompress(InStream : TMemoryStream;OutFile : TFileName); overload;
    procedure DeCompress(var InStream ,OutStream : TMemoryStream); overload;
  published
    property About : String read FAbout write FAbout;
    property CompressProgress : TOBZipEvent read FCompressProgress write FCompressProgress;
    property DeCompressProgress : TOBZipEvent read FDeCompressProgress write FDeCompressProgress;
  end;

implementation

{ TOBZipLib }

procedure TOBZipLib.Compress(InFile: TFileName; OutStream: TMemoryStream);
var
  lInStream : TMemoryStream;
begin
  if FileExists(InFile) then
  begin
    lInStream := TMemoryStream.Create;
    lInStream.LoadFromFile(InFile);
    Compress(lInStream,OutStream);
    lInStream.Free;
  end;
end; { 壓縮文件->流 }

procedure TOBZipLib.Compress(InFile, OutFile: TFileName);
var
  lInStream : TMemoryStream;
begin
  if FileExists(InFile) then
  begin
    lInStream := TMemoryStream.Create;
    lInStream.LoadFromFile(InFile);
    Compress(lInStream,OutFile);
    lInStream.Free;
  end;
end; { 壓縮文件->文件 }

procedure TOBZipLib.Compress(InStream, OutStream: TMemoryStream);
var
  lSize : Int64;
  lTempStream : TMemoryStream;
  lCompStream : TCompressionStream;
begin
  lSize := InStream.Size;
  lOldSize := lSize;
  lTempStream := TMemoryStream.Create;
  lCompStream := TCompressionStream.Create(clMax,lTempStream);
  lCompStream.OnProgress := OnProgress;
  lCompStream.CopyFrom(InStream,0);
  lCompStream.Free;

  OutStream.Clear;
  OutStream.Write(lSize,Sizeof(lSize));
  OutStream.Write(lTempStream.Memory^,lTempStream.Size);
  lTempStream.Free;
end; { 壓縮流->流 }

procedure TOBZipLib.Compress(InStream: TMemoryStream; OutFile: TFileName);
var
  lOutStream : TMemoryStream;
begin
  if Trim(OutFile) <> '' then
  begin
    lOutStream := TMemoryStream.Create;
    Compress(InStream,lOutStream);
    lOutStream.SaveToFile(OutFile);
    lOutStream.Free;
  end;
end; { 壓縮流->文件 }

constructor TOBZipLib.Create(AOwner: TComponent);
begin
  inherited;

end; { 創建控件 }

procedure TOBZipLib.DeCompress(InFile: TFileName; OutStream: TMemoryStream);
var
  lInStream : TMemoryStream;
begin
  if FileExists(InFile) then
  begin
    lInStream := TMemoryStream.Create;
    lInStream.LoadFromFile(InFile);
    DeCompress(lInStream,OutStream);
    lInStream.Free;
  end;
end; { 解壓文件->流 }

procedure TOBZipLib.DeCompress(InFile, OutFile: TFileName);
var
  lInStream : TMemoryStream;
begin
  if FileExists(InFile) then
  begin
    lInStream := TMemoryStream.Create;
    lInStream.LoadFromFile(InFile);
    DeCompress(lInStream,OutFile);
    lInStream.Free;
  end;
end; { 解壓文件->文件 }

procedure TOBZipLib.DeCompress(var InStream, OutStream: TMemoryStream);
var
  lSize : Int64;
  lTempStream : TMemoryStream;
  lCompStream : TDecompressionStream;
  lBuffer : pChar;
begin
  lOldSize := InStream.Size;
  InStream.ReadBuffer(lSize, SizeOf(lSize));
  GetMem(lBuffer,lSize);
  lTempStream := TMemoryStream.Create;
  lCompStream := TDecompressionStream.Create(InStream);
  lCompStream.OnProgress := OnProgress;
  try
    lCompStream.ReadBuffer(lBuffer^, lSize);
    lTempStream.WriteBuffer(lBuffer^, lSize);
    lTempStream.Position := 0;
    OutStream.CopyFrom(lTempStream,lSize);
  finally
    FreeMem(lBuffer);
    lTempStream.Free;
    lCompStream.Free;
  end;
end; { 解壓流->流 }

procedure TOBZipLib.DeCompress(InStream: TMemoryStream; OutFile: TFileName);
var
  lOutStream : TMemoryStream;
begin
  lOutStream := TMemoryStream.Create;
  DeCompress(InStream,lOutStream);
  lOutStream.SaveToFile(OutFile);
  lOutStream.Free;
end; { 解壓流->文件 }

destructor TOBZipLib.Destroy;
begin

  inherited;
end; { 釋放控件 }

procedure TOBZipLib.OnProgress(Sender: TObject);
var
  lPos : Integer;
  lComp : TCompressionStream;
  lDeComp : TDecompressionStream;
begin
  if Sender is TCompressionStream then
  begin
    lComp := TCompressionStream(Sender);
    lPos := Round(lComp.Position / lOldSize * 100);
    if Assigned(FCompressProgress) then FCompressProgress(Sender,lPos);
  end else
  begin
    lDeComp := TDecompressionStream(Sender);
    lPos := Round(lDeComp.Position / lOldSize * 100);
    if Assigned(FDeCompressProgress) then FDeCompressProgress(Sender,lPos);
  end;
  Application.ProcessMessages;
end; {顯示進度}

end.
 
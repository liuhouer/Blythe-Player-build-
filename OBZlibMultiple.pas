{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARN UNIT_PLATFORM OFF}

unit OBZlibMultiple;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  FileCtrl, ZLib;

type
  TFileEvent = procedure (Sender: TObject; FileName: string) of object;
  TProgressEvent = procedure (Sender: TObject; Position, Total: Integer) of object;

  TOBZlibMultiple = class(TComponent)
  private
    FOnDecompressFile: TFileEvent;
    FOnDecompressedFile: TFileEvent;
    FOnProgress: TProgressEvent;
    FOnCompressFile: TFileEvent;
    FOnCompressedFile: TFileEvent;
    FAbout: String;
  protected
    procedure AddFile(FileName, Directory, FilePath: string;
      DestStream: TStream);
  public
    function CompressFiles(Files: TStringList): TStream;overload;
    procedure CompressFiles(Files: TStringList; FileName: string);overload;
    function CompressDirectory(Directory: string; Recursive: Boolean): TStream;overload;
    procedure CompressDirectory(Directory: string; Recursive: Boolean;
      FileName: string);overload;

    procedure DecompressFile(FileName,Directory: string; Overwrite: Boolean);
    procedure DecompressStream(Stream: TStream; Directory: string;
      Overwrite: Boolean);
  published
    property About : String read FAbout write FAbout;
    property OnDecompressingFile: TFileEvent read FOnDecompressFile write FOnDecompressFile;
    property OnDecompressedFile: TFileEvent read FOnDecompressedFile write FOnDecompressedFile;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnCompressingFile: TFileEvent read FOnCompressFile write FOnCompressFile;
    property OnCompressedFile: TFileEvent read FOnCompressedFile write FOnCompressedFile;
  end;

implementation

{*******************************************************}
{  Format of the File:                                  }
{   File Header                                         }
{    1 byte    Size of the directory variable           }
{    x bytes   Directory of the file                    }
{    1 byte    Size of the filename                     }
{    x bytes   Filename                                 }
{    4 bytes   Size of the file (uncompressed)          }
{    4 bytes   Size of the file (compressed)            }
{   Data chunk                                          }
{    x bytes   the compressed chunk                     }
{*******************************************************}

function TOBZlibMultiple.CompressDirectory(Directory: string;
  Recursive: Boolean): TStream;

 procedure SearchDirectory(SDirectory: string);
 var
  SearchRec: TSearchRec;
  Res: integer;
 begin
   Res := FindFirst(Directory+SDirectory+'*.*', faAnyFile, SearchRec);
   while (Res=0) do
   begin
     if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
     begin
       if (SearchRec.Attr and faDirectory = 0) then
         AddFile(SearchRec.Name,SDirectory,Directory+SDirectory+SearchRec.Name,result)
       else
         if Recursive then
           SearchDirectory(SDirectory+SearchRec.Name+'\');
     end;
     Res := FindNext(SearchRec);
   end;
   FindClose(SearchRec);
 end;

begin
  result := TMemoryStream.Create;
  if (Length(Directory)>0) and (Directory[Length(Directory)]<>'\') then
    Directory := Directory+'\';
  SearchDirectory('');
  result.Position := 0;
end;

procedure TOBZlibMultiple.AddFile(FileName, Directory, FilePath: string;
  DestStream: TStream);
var
 Stream: TStream;
 FStream: TFileStream;
 ZStream: TCompressionStream;
 buf: array[0..1024] of byte;
 count: Integer;

 procedure WriteFileRecord(Directory, FileName: string; FileSize: Integer;
   CompressedSize: Integer);
 var
  b: byte;
  tab: array [1..256] of char;
 begin
   for b:=1 to Length(Directory) do
     tab[b] := Directory[b];
   b := Length(Directory);
   DestStream.Write(b,SizeOf(b));
   DestStream.Write(tab,b);

   for b:=1 to Length(FileName) do
     tab[b] := FileName[b];
   b := Length(FileName);
   DestStream.Write(b,SizeOf(b));
   DestStream.Write(tab,b);

   DestStream.Write(FileSize,SizeOf(FileSize));
   DestStream.Write(CompressedSize,SizeOf(CompressedSize));
 end;

begin
  Stream := TMemoryStream.Create;
  FStream := TFileStream.Create(FilePath,fmOpenRead or fmShareDenyWrite);
  ZStream := TCompressionStream.Create(clDefault,Stream);

  if Assigned(FOnCompressFile) then
    FOnCompressFile(self,FilePath);

  repeat
    count := FStream.Read(buf,SizeOf(buf));
    ZStream.Write(buf,count);
    if Assigned(FOnProgress) then
      FOnProgress(self,FStream.Position,FStream.Size);
  until count=0;
  ZStream.Free;

  if Assigned(FOnCompressedFile) then
    FOnCompressedFile(self,FilePath);

  WriteFileRecord(Directory,FileName,FStream.Size,Stream.Size);
  DestStream.CopyFrom(Stream,0);

  FStream.Free;
  Stream.Free;
end;

procedure TOBZlibMultiple.CompressDirectory(Directory: string;
  Recursive: Boolean; FileName: string);
var
 Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  Stream.CopyFrom(CompressDirectory(Directory,Recursive),0);
  Stream.Free;
end;

function TOBZlibMultiple.CompressFiles(Files: TStringList): TStream;
var
 i: Integer;
 st,st2,common: string;
begin
  result := TMemoryStream.Create;
  if Files.Count=0 then
    Exit;

  //Find the biggest common part of all files
  st := UpperCase(Files[0]);
  for i:=1 to Files.Count-1 do
  begin
    st2 := Files[i];
    while (pos(st,st2)=0) and (st<>'') do
      st := Copy(st,1,Length(st)-1);
  end;
  common := st2;

  //Add the files to the stream
  for i:=0 to Files.Count-1 do
  begin
    st := ExtractFileName(Files[i]);
    st2 := ExtractFilePath(Files[i]);
    st2 := Copy(st2,1,Length(common));
    AddFile(st,st2,Files[i],result);
  end;

  result.Position := 0;
end;

procedure TOBZlibMultiple.CompressFiles(Files: TStringList;
  FileName: string);
var
 Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  Stream.CopyFrom(CompressFiles(Files),0);
  Stream.Free;
end;

procedure TOBZlibMultiple.DecompressStream(Stream: TStream;
  Directory: string; Overwrite: Boolean);
var
 FStream: TFileStream;
 ZStream: TDecompressionStream;
 CStream: TMemoryStream;
 b: byte;
 tab: array[1..256] of char;
 st: string;
 count,fsize,i: Integer;
 buf: array[0..1024] of byte;
begin
  if (Length(Directory)>0) and (Directory[Length(Directory)]<>'\') then
    Directory := Directory+'\';

  while Stream.Position<Stream.Size do
  begin
    //Read and force the directory
    Stream.Read(b,SizeOf(b));
    Stream.Read(tab,b);
    st := '';
    for i:=1 to b do
      st := st+tab[i];
    ForceDirectories(Directory+st);
    if (Length(st)>0) and (st[Length(st)]<>'\') then
      st := st+'\';

    //Read filename
    Stream.Read(b,SizeOf(b));
    Stream.Read(tab,b);
    for i:=1 to b do
      st := st+tab[i];

    Stream.Read(fsize,SizeOf(fsize));
    Stream.Read(i,SizeOf(i));
    CStream := TMemoryStream.Create;
    CStream.CopyFrom(Stream,i);
    CStream.Position := 0;

    //Decompress the file
    st := Directory+st;
    if Overwrite or (not FileExists(st)) then
    begin
      FStream := TFileStream.Create(st,fmCreate or fmShareExclusive);
      ZStream := TDecompressionStream.Create(CStream);

      if Assigned(FOnDecompressFile) then
        FOnDecompressFile(self,st);

      repeat
        count := ZStream.Read(buf,1024);
        FStream.Write(buf,count);
        if Assigned(FOnProgress) then
          FOnProgress(self,FStream.Size,fsize);
      until count=0;

      if Assigned(FOnDecompressedFile) then
        FOnDecompressedFile(self,st);

      FStream.Free;
    end;

    CStream.Free;
  end;
end;

procedure TOBZlibMultiple.DecompressFile(FileName, Directory: string;
  Overwrite: Boolean);
var
 Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
  Stream.Position := 0;
  DecompressStream(Stream,Directory,Overwrite);
  Stream.Free;
end;

end.

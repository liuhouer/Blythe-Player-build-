////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   Skin2SkinReader.pas
//  Creator     :   Shen Min
//  Date        :   2006-02-23
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUI2SkinReader;

interface

uses Windows, Classes, SysUtils, Graphics;

type
    Tsk2SkinFileReader = class
    private
        m_BitmapList : TStrings;
        m_IntegerList : TStrings;
        m_BooleanList : TStrings;
        m_StrList : TStrings;
        m_Ready : Boolean;

        procedure Load(FileName, Password : String);

    public
        constructor Create(FileName, Password : String); reintroduce;
        destructor Destroy(); override;

        function GetBitmap(Key : String) : TBitmap;
        function GetInteger(Key : String) : Integer;
        function GetBool(Key : String) : Boolean;
        function GetStr(Key : String) : String;

        procedure SetInteger(Key : String; Value : Integer);
        procedure SetBool(Key : String; Value : Boolean);
        procedure SetBitmap(Key : String; const Buf : TBitmap);

        procedure ProcessTransparentColor(TransColor : TColor);

        property Ready : Boolean read m_Ready;

    end;


implementation

type
    Tsk2NodeType = (tbntStream, tbntInt, tbntBool, tbntStr);

    Tsk2SkinFileBaseHeader = packed record
        FileHeader : array [0..11] of AnsiChar;
        HeaderSize : Cardinal;
    end;

    Tsk2SkinFileHeader = packed record
        FileHeader : array [0..11] of AnsiChar;
        HeaderSize : Cardinal;
        FormatVer : Integer;
        FirstNode : Cardinal;
    end;

    Tsk2SkinFileNodeHeader = packed record
        NodeKey : array [0..63] of AnsiChar;
        NodeType : Tsk2NodeType;
        NodeStart : Cardinal;
        NodeSize : Cardinal;
        NextNode : Cardinal;
    end;

    TsuiUnzipResult = (suiURSucc, suiURFailed, suiURWrongPassword);

function FindTail(const Stream : TStream) : Integer;
var
    TailRec : packed record
        trSig : Integer;
        trMid : array [0..15] of BYTE;
        trLen : WORD;
    end;
begin
    Result := Stream.Seek(-sizeof(TailRec), soFromEnd);
    if Result >= 0 then
    begin
        Stream.ReadBuffer(TailRec, sizeof(TailRec));
        if (TailRec.trSig = $06054B50) and (TailRec.trLen = 0) then
            Stream.Seek(Result, soFromBeginning);
    end;
end;

type
    TFileHeader = record
        Signature : Integer;
        DiskNumber : WORD;
        StartDiskNumber : WORD;
        EntriesOnDisk : WORD;
        TotalEntries : WORD;
        DirectorySize : Integer;
        DirectoryOffset : Integer;
        ZipfileCommentLength : WORD;
    end;

    TDirFileHeader = record
        Signature : Integer;
        VersionMadeBy : WORD;
        VersionNeededToExtract : WORD;
        GeneralPurposeBitFlag : WORD;
        CompressionMethod : WORD;
        LastModFileTime : WORD;
        LastModFileDate : WORD;
        CRC32 : Integer;
        CompressedSize : Integer;
        UncompressedSize : Integer;
        FileNameLength : WORD;
        ExtraFieldLength : WORD;
        FileCommentLength : WORD;
        DiskNumberStart : WORD;
        InternalFileAttributes : WORD;
        ExternalFileAttributes : Integer;
        RelativeOffset : Integer;
    end;

    TLocalFileHeader = record
        Signature : Integer;
        VersionNeededToExtract : WORD;
        GeneralPurposeBitFlag : WORD;
        CompressionMethod : WORD;
        LastModFileTime : WORD;
        LastModFileDate : WORD;
        CRC32 : Integer;
        CompressedSize : Integer;
        UncompressedSize : Integer;
        FileNameLength : WORD;
        ExtraFieldLength : WORD;
    end;

const
    ExtractMaskArray : array [1..31] of Integer = (
        $00000001, $00000003, $00000007, $0000000F,
        $0000001F, $0000003F, $0000007F, $000000FF,
        $000001FF, $000003FF, $000007FF, $00000FFF,
        $00001FFF, $00003FFF, $00007FFF, $0000FFFF,
        $0001FFFF, $0003FFFF, $0007FFFF, $000FFFFF,
        $001FFFFF, $003FFFFF, $007FFFFF, $00FFFFFF,
        $01FFFFFF, $03FFFFFF, $07FFFFFF, $0FFFFFFF,
        $1FFFFFFF, $3FFFFFFF, $7FFFFFFF
       );
    CodeLengthIndex : array [0..18] of BYTE = (
        16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15
    );

    PowerOfTwo : array [0..15] of Integer = (
        1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768
    );

    LitExtraBits : array [0..30] of BYTE = (
        0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 16, 99, 99
    );

    DistExtraBits : array [0..31] of BYTE = (
        0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7,
        8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14
    );

    LengthBase : array [0..28] of WORD = (
        3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
        35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 3
    );

    DistanceBase : array [0..31] of WORD = (
        1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513,
        769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577, 32769, 49153
    );

    CRC32Table : array[0..255] of DWORD = (
        $00000000, $77073096, $ee0e612c, $990951ba, $076dc419, $706af48f, $e963a535,
        $9e6495a3, $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988, $09b64c2b, $7eb17cbd,
        $e7b82d07, $90bf1d91, $1db71064, $6ab020f2, $f3b97148, $84be41de, $1adad47d,
        $6ddde4eb, $f4d4b551, $83d385c7, $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec,
        $14015c4f, $63066cd9, $fa0f3d63, $8d080df5, $3b6e20c8, $4c69105e, $d56041e4,
        $a2677172, $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b, $35b5a8fa, $42b2986c,
        $dbbbc9d6, $acbcf940, $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59, $26d930ac,
        $51de003a, $c8d75180, $bfd06116, $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f,
        $2802b89e, $5f058808, $c60cd9b2, $b10be924, $2f6f7c87, $58684c11, $c1611dab,
        $b6662d3d, $76dc4190, $01db7106, $98d220bc, $efd5102a, $71b18589, $06b6b51f,
        $9fbfe4a5, $e8b8d433, $7807c9a2, $0f00f934, $9609a88e, $e10e9818, $7f6a0dbb,
        $086d3d2d, $91646c97, $e6635c01, $6b6b51f4, $1c6c6162, $856530d8, $f262004e,
        $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457, $65b0d9c6, $12b7e950, $8bbeb8ea,
        $fcb9887c, $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65, $4db26158, $3ab551ce,
        $a3bc0074, $d4bb30e2, $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb, $4369e96a,
        $346ed9fc, $ad678846, $da60b8d0, $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9,
        $5005713c, $270241aa, $be0b1010, $c90c2086, $5768b525, $206f85b3, $b966d409,
        $ce61e49f, $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4, $59b33d17, $2eb40d81,
        $b7bd5c3b, $c0ba6cad, $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a, $ead54739,
        $9dd277af, $04db2615, $73dc1683, $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8,
        $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1, $f00f9344, $8708a3d2, $1e01f268,
        $6906c2fe, $f762575d, $806567cb, $196c3671, $6e6b06e7, $fed41b76, $89d32be0,
        $10da7a5a, $67dd4acc, $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5, $d6d6a3e8,
        $a1d1937e, $38d8c2c4, $4fdff252, $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
        $d80d2bda, $af0a1b4c, $36034af6, $41047a60, $df60efc3, $a867df55, $316e8eef,
        $4669be79, $cb61b38c, $bc66831a, $256fd2a0, $5268e236, $cc0c7795, $bb0b4703,
        $220216b9, $5505262f, $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04, $c2d7ffa7,
        $b5d0cf31, $2cd99e8b, $5bdeae1d, $9b64c2b0, $ec63f226, $756aa39c, $026d930a,
        $9c0906a9, $eb0e363f, $72076785, $05005713, $95bf4a82, $e2b87a14, $7bb12bae,
        $0cb61b38, $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21, $86d3d2d4, $f1d4e242,
        $68ddb3f8, $1fda836e, $81be16cd, $f6b9265b, $6fb077e1, $18b74777, $88085ae6,
        $ff0f6a70, $66063bca, $11010b5c, $8f659eff, $f862ae69, $616bffd3, $166ccf45,
        $a00ae278, $d70dd2ee, $4e048354, $3903b3c2, $a7672661, $d06016f7, $4969474d,
        $3e6e77db, $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0, $a9bcae53, $debb9ec5,
        $47b2cf7f, $30b5ffe9, $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6, $bad03605,
        $cdd70693, $54de5729, $23d967bf, $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94,
        $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d
    );


type
    TIntegerList = array [0..MaxInt div sizeof(Integer) - 1] of Integer;
    PTIntegerList = ^TIntegerList;
    
    THuffmanTree = class
    private
        m_Decodes : PTIntegerList;
        m_DefMaxCodeLen : Integer;
        m_MaxCodeLen : Integer;
    public
        constructor Create(DefMaxCodeLen: Integer);
        destructor Destroy; override;

        procedure Build(
            const CodeLengths : array of Integer;
            StartInx : Integer;
            Count : Integer;
            const ExtraBits : array of BYTE;
            ExtraOffset : Integer
        );
        function Decode(LookupBits : Integer) : Integer;
        property MaxCodeLen : Integer read m_MaxCodeLen;
    end;

    TLenNotLen = packed record
        Len : WORD;
        NotLen : WORD;
    end;

    TEncrypetHeader = array [0..11] of BYTE;

    TLongAsBytes = packed record
        L1, L2, L3, L4 : BYTE
    end;

function FillBuffer(const Stream : TStream; var InBuf : PAnsiChar; var InBufPos : PAnsiChar; var InBufEnd : PAnsiChar) : Boolean;
var
    BytesRead : Integer;
    BytesToRead : Integer;
    i : Integer;
    Buffer : PAnsiChar;
    BufferCount : Integer;
    InFakeCount : Integer;
begin
    Buffer := InBuf;
    while (InBufPos <> InBufEnd) do
    begin
        Buffer^ := InBufPos^;
        Inc(InBufPos);
        Inc(Buffer);
    end;

    BytesToRead := 16 * 1024 - (Buffer - InBuf);
    BytesRead := Stream.Read(Buffer^, BytesToRead);

    InBufPos := InBuf;
    InBufEnd := Buffer + BytesRead;
    BufferCount := InBufEnd - InBuf;

    if (BufferCount = 0) then
        Result := false
    else
    begin
        Result := true;
        if (BytesRead = 0) and ((BufferCount mod 4) <> 0) then
        begin
            InFakeCount := 4 - (BufferCount mod 4);
            for i := 0 to InFakeCount - 1 do
            begin
                InBufEnd^ := #0;
                Inc(InBufEnd);
            end;
        end;
    end;
end;

procedure ReadBuffer(
    const Stream : TStream; var Buf; Count: Integer;
    var InBitsLeft : Integer; var InBitBuf : Integer; var InBufPos : PAnsiChar;
    var InBufEnd : PAnsiChar; var InBuf : PAnsiChar);
var
    i : integer;
    Buffer : PAnsiChar;
    BytesToRead   : integer;
    BytesInBuffer : integer;
begin
    Buffer := @Buf;

    if InBitsLeft > 0 then
    begin
        BytesToRead := InBitsLeft div 8;
        for i := 0 to BytesToRead - 1 do
        begin
            Buffer^ := AnsiChar(InBitBuf and $FF);
            Inc(Buffer);
            InBitBuf := InBitBuf shr 8;
        end;
        Dec(Count, BytesToRead);
    end;

    BytesInBuffer := InBufEnd - InBufPos;
    if Count <= BytesInBuffer then
        BytesToRead := Count
    else
        BytesToRead := BytesInBuffer;
    Move(InBufPos^, Buffer^, BytesToRead);

    Dec(Count, BytesToRead);
    Inc(InBufPos, BytesToRead);

    while Count <> 0 do
    begin
        Inc(Buffer, BytesToRead);

        if not FillBuffer(Stream, InBuf, InBufPos, InBufEnd) then
            Exit;

        BytesInBuffer := InBufEnd - InBufPos;
        if Count <= BytesInBuffer then
            BytesToRead := Count
        else
            BytesToRead := BytesInBuffer;
        Move(InBufPos^, Buffer^, BytesToRead);
        Dec(Count, BytesToRead);
        Inc(InBufPos, BytesToRead);
    end;
    InBitBuf := 0;
    InBitsLeft := 0;
end;

function PeekBits(
    const Stream : TStream; const Count : Integer; var InBitsLeft : Integer;
    var InBitBuf : Integer; var InBufPos : PAnsiChar; var InBufEnd : PAnsiChar; var InBuf : PAnsiChar) : Integer;
var
    BitsToGo : Integer;
    TempBuffer : Integer;
begin
    if Count <= InBitsLeft then
        Result := (InBitBuf and ExtractMaskArray[Count])
    else
    begin
        BitsToGo := Count - InBitsLeft;
        Result := InBitBuf;

        if (InBufEnd - InBufPos) < sizeof(Integer) then
        begin
            if not FillBuffer(Stream, InBuf, InBufPos, InBufEnd) then
                TempBuffer := 0
            else
                TempBuffer := PInteger(InBufPos)^
        end
        else
            TempBuffer := PInteger(InBufPos)^;
        Result := Result + ((TempBuffer and ExtractMaskArray[BitsToGo]) shl InBitsLeft);
    end;
end;

procedure DiscardBits(
    const Count : integer; var InBitsLeft : Integer;
    var InBitBuf : Integer; var InBufPos : PAnsiChar);
var
    BitsToGo : integer;
begin
    if (Count <= InBitsLeft) then
    begin
        InBitBuf := InBitBuf shr Count;
        Dec(InBitsLeft, Count);
    end
    else
    begin
        BitsToGo := Count - InBitsLeft;
        InBitBuf := PInteger(InBufPos)^;
        Inc(InBufPos, sizeof(Integer));
        InBitBuf := InBitBuf shr BitsToGo;
        InBitsLeft := 32 - BitsToGo;
    end;
end;

function ReadBits(
    const Count : integer; var InBitsLeft : Integer;
    var InBitBuf : Integer; var InBufPos : PAnsiChar) : Integer;
var
    BitsToGo : integer;
begin
    if (Count <= InBitsLeft) then
    begin
        Result := InBitBuf and ExtractMaskArray[Count];
        InBitBuf := InBitBuf shr Count;
        Dec(InBitsLeft, Count);
    end
    else
    begin
        BitsToGo := Count - InBitsLeft;
        Result := InBitBuf;
        InBitBuf := PInteger(InBufPos)^;
        Inc(InBufPos, sizeof(Integer));
        Result := Result + ((InBitBuf and ExtractMaskArray[BitsToGo]) shl InBitsLeft);
        InBitBuf := InBitBuf shr BitsToGo;
        InBitsLeft := 32 - BitsToGo;
    end;
end;

procedure DecodeBuffer(
    const Buf; Count : Integer; var M1 : Integer; var M2 : Integer;
    var M3: Integer; const M : Integer);
var
    i : Integer;
    Temp : Integer;
    Buffer : PAnsiChar;
begin
    Buffer := @Buf;

    for i := 0 to Count - 1 do
    begin
        Temp := (M3 and $FFFF) or 2;
        Buffer^ := AnsiChar(BYTE(Buffer^) xor ((Temp * (Temp xor 1)) shr 8));

        M1 := DWORD(CRC32Table[BYTE(M1 xor Integer(Buffer^))] xor ((M1 shr 8) and DWORD($00FFFFFF)));
        M2 := M2 + (M1 and $FF);
        M2 := (M2 * M) + 1;
        M3 := DWORD(CRC32Table[BYTE(M3 xor Integer(M2 shr 24))] xor ((M3 shr 8) and DWORD($00FFFFFF)));

        Inc(Buffer);
    end;
end;

var
    StaticLiteralTree  : THuffmanTree = nil;
    StaticDistanceTree : THuffmanTree = nil;

procedure BuildStaticTrees;
var
    i : integer;
    CodeLens : array [0..287] of integer;
begin
    for i := 0 to 143 do
        CodeLens[i] := 8;
    for i := 144 to 255 do
        CodeLens[i] := 9;
    for i := 256 to 279 do
        CodeLens[i] := 7;
    for i := 280 to 287 do
        CodeLens[i] := 8;
    StaticLiteralTree := THuffmanTree.Create(15);
    StaticLiteralTree.Build(CodeLens, 0, 288, LitExtraBits, 257);
    for i := 0 to 31 do
        CodeLens[i] := 5;
    StaticDistanceTree := THuffmanTree.Create(15);
    StaticDistanceTree.Build(CodeLens, 0, 32, DistExtraBits, 0);
end;

procedure Decode(
    const LiteralTree, DistanceTree : THuffmanTree;
    const InStream, OutStream : TStream;
    var BitCount, InBitsLeft, InBitBuf, BitBuffer, LookupValue, EncodedSymbol : Integer;
    var Symbol, SymbolCodeLen, Len, ExtraBitCount, Distance : Integer;
    var InBufPos, InBufEnd, InBuf, OutCurrent, OutWritePoint, OutBuf, FromPtr,
        FromChar, ToChar : PAnsiChar);
var
    i : Integer;
begin
    BitCount := LiteralTree.MaxCodeLen + 5;
    BitBuffer := PeekBits(InStream, BitCount, InBitsLeft, InBitBuf, InBufPos, InBufEnd, InBuf);
    LookupValue := BitBuffer and ExtractMaskArray[LiteralTree.MaxCodeLen];

    EncodedSymbol := LiteralTree.Decode(LookupValue);
    Symbol := EncodedSymbol and $FFFF;
    SymbolCodeLen := (EncodedSymbol shr 16) and $FF;

    while (Symbol <> 256) do
    begin
        if Symbol < 256 then
        begin
            OutCurrent^ := AnsiChar(Symbol);
            Inc(OutCurrent);
            if OutCurrent >= OutWritePoint then
            begin
                OutStream.WriteBuffer(OutBuf^, 32 * 1024);
                FromPtr := OutBuf + 32 * 1024;
                Move(FromPtr^, OutBuf^, OutCurrent - FromPtr);
                OutCurrent := OutCurrent - 32 * 1024;
            end;
            DiscardBits(SymbolCodeLen, InBitsLeft, InBitBuf, InBufPos);
        end
        else
        begin
            if Symbol = 285 then
            begin
                Len := 258;
                DiscardBits(SymbolCodeLen, InBitsLeft, InBitBuf, InBufPos);
            end
            else
            begin
                ExtraBitCount := EncodedSymbol shr 24;
                if (ExtraBitCount = 0) then
                begin
                    Len := LengthBase[Symbol - 257];
                    DiscardBits(SymbolCodeLen, InBitsLeft, InBitBuf, InBufPos);
                end
                else
                begin
                    Len := LengthBase[Symbol - 257] + ((BitBuffer shr SymbolCodeLen) and ExtractMaskArray[ExtraBitCount]);
                    BitCount := SymbolCodeLen + ExtraBitCount;
                    DiscardBits(BitCount, InBitsLeft, InBitBuf, InBufPos);
                end;
            end;

            BitCount := DistanceTree.MaxCodeLen + 14;
            BitBuffer := PeekBits(InStream, BitCount, InBitsLeft, InBitBuf, InBufPos, InBufEnd, InBuf);
            LookupValue := BitBuffer and ExtractMaskArray[DistanceTree.MaxCodeLen];

            EncodedSymbol := DistanceTree.Decode(LookupValue);
            Symbol := EncodedSymbol and $FFFF;
            SymbolCodeLen := (EncodedSymbol shr 16) and $FF;

            ExtraBitCount := EncodedSymbol shr 24;
            if (ExtraBitCount = 0) then
            begin
                Distance := DistanceBase[Symbol];
                DiscardBits(SymbolCodeLen, InBitsLeft, InBitBuf, InBufPos);
            end
            else
            begin
                Distance := DistanceBase[Symbol] + ((BitBuffer shr SymbolCodeLen) and ExtractMaskArray[ExtraBitCount]);
                BitCount := SymbolCodeLen + ExtraBitCount;
                DiscardBits(BitCount, InBitsLeft, InBitBuf, InBufPos);
            end;
            if (Len <= Distance) then
                Move((OutCurrent - Distance)^ , OutCurrent^, Len)
            else
            begin
                FromChar := OutCurrent - Distance;
                ToChar := OutCurrent;
                for i := 1 to Len do
                begin
                    ToChar^ := FromChar^;
                    Inc(FromChar);
                    Inc(ToChar);
                end;
            end;
            Inc(OutCurrent, Len);
            if (OutCurrent >= OutWritePoint) then
            begin
                OutStream.WriteBuffer(OutBuf^, 32 * 1024);
                FromPtr := OutBuf + 32 * 1024;
                Move(FromPtr^, OutBuf^, OutCurrent - FromPtr);
                OutCurrent := OutCurrent - 32 * 1024;
            end;
        end;

        BitCount := LiteralTree.MaxCodeLen + 5;
        BitBuffer := PeekBits(InStream, BitCount, InBitsLeft, InBitBuf, InBufPos, InBufEnd, InBuf);
        LookupValue := BitBuffer and ExtractMaskArray[LiteralTree.MaxCodeLen];
        EncodedSymbol := LiteralTree.Decode(LookupValue);
        Symbol := EncodedSymbol and $FFFF;
        SymbolCodeLen := (EncodedSymbol shr 16) and $FF;
    end;
    DiscardBits(SymbolCodeLen, InBitsLeft, InBitBuf, InBufPos);
end;

function Unzip(const ZipFileName, ExtractFile, OutputFile, Password : String) : TsuiUnzipResult;
var
    ZipStream, OutStream, DecrypedStream, InStream : TStream;
    dwFileSignature : DWORD;
    TailPos : Integer;
    Header : TFileHeader;
    DirHeader : TDirFileHeader;
    LocalHeader : TLocalFileHeader;
    InternalFile : array[0..MAX_PATH - 1] of ansichar;
    Found, LastBit : Boolean;
    InBuf, OutBuf : PAnsiChar;
    InBufPos, OutBufPos : PAnsiChar;
    InBufEnd : PAnsiChar;
    InBitBuf : Integer;
    InBitsLeft : Integer;
    OutCurrent : PAnsiChar;
    OutWritePoint : PAnsiChar;
    LitCount, DistCount, CodeLenCount : Integer;
    CodeLens : array [0..285 + 32] of Integer;
    i : Integer;
    CodeLenTree, LiteralTree, DistanceTree : THuffmanTree;
    BitsToGo : Integer;
    SymbolCount, BitCount, BitBuffer, LookupValue, EncodedSymbol, Symbol : Integer;
    SymbolCodeLen, RepeatCount, TempBuffer, Len, ExtraBitCount : Integer;
    Distance : Integer;
    FromPtr, FromChar, ToChar : PAnsiChar;
    BlockType : Integer;
    LenNotLen : TLenNotLen;
    BytesToGo, BytesToWrite, BytesToWrite2, Count : Integer;
    Buffer : Pointer;
    Buffer2 : PAnsiChar;
    M, M1, M2, M3 : Integer;
    H, EncryptedHead : TEncrypetHeader;
    Buf : array [0..1023] of AnsiChar;
    C : Integer;
begin
    Result := suiURFailed;
    ZipStream := nil;
    OutStream := nil;
    DecrypedStream := nil;
    InBuf := nil;
    OutBuf := nil;

    if not FileExists(ZipFileName) then
        Exit;

    try // finally
        try //except
            ZipStream := TFileStream.Create(ZipFileName, fmOpenRead or fmShareDenyNone);
            ZipStream.Position := 0;
            ZipStream.Read(dwFileSignature, sizeof(dwFileSignature));
            if not ((dwFileSignature and $0000FFFF) = $4B53) then
                Exit; // not a zip file
            TailPos := FindTail(ZipStream);
            if TailPos < 0 then
                Exit;

            ZipStream.Read(Header.Signature, sizeof(Header.Signature));
            ZipStream.Read(Header.DiskNumber, sizeof(Header.DiskNumber));
            ZipStream.Read(Header.StartDiskNumber, sizeof(Header.StartDiskNumber));
            ZipStream.Read(Header.EntriesOnDisk, sizeof(Header.EntriesOnDisk));
            ZipStream.Read(Header.TotalEntries, sizeof(Header.TotalEntries));
            ZipStream.Read(Header.DirectorySize, sizeof(Header.DirectorySize));
            ZipStream.Read(Header.DirectoryOffset, sizeof(Header.DirectoryOffset));
            ZipStream.Read(Header.ZipfileCommentLength, sizeof(Header.ZipfileCommentLength));
            if Header.ZipfileCommentLength > 0 then
                ZipStream.Seek(Header.ZipfileCommentLength, soFromCurrent);
            ZipStream.Seek(Header.DirectoryOffset, soFromBeginning);

            Found := false;
            while ZipStream.Position < TailPos do
            begin
                ZipStream.Read(DirHeader.Signature, sizeof(DirHeader.Signature));
                ZipStream.Read(DirHeader.VersionMadeBy, sizeof(DirHeader.VersionMadeBy));
                ZipStream.Read(DirHeader.VersionNeededToExtract, sizeof(DirHeader.VersionNeededToExtract));
                ZipStream.Read(DirHeader.GeneralPurposeBitFlag, sizeof(DirHeader.GeneralPurposeBitFlag));
                ZipStream.Read(DirHeader.CompressionMethod, sizeof(DirHeader.CompressionMethod));
                ZipStream.Read(DirHeader.LastModFileTime, sizeof(DirHeader.LastModFileTime));
                ZipStream.Read(DirHeader.LastModFileDate, sizeof(DirHeader.LastModFileDate));
                ZipStream.Read(DirHeader.CRC32, sizeof(DirHeader.CRC32));
                ZipStream.Read(DirHeader.CompressedSize, sizeof(DirHeader.CompressedSize));
                ZipStream.Read(DirHeader.UncompressedSize, sizeof(DirHeader.UncompressedSize));
                ZipStream.Read(DirHeader.FileNameLength, sizeof(DirHeader.FileNameLength));
                ZipStream.Read(DirHeader.ExtraFieldLength, sizeof(DirHeader.ExtraFieldLength));
                ZipStream.Read(DirHeader.FileCommentLength, sizeof(DirHeader.FileCommentLength));
                ZipStream.Read(DirHeader.DiskNumberStart, sizeof(DirHeader.DiskNumberStart));
                ZipStream.Read(DirHeader.InternalFileAttributes, sizeof(DirHeader.InternalFileAttributes));
                ZipStream.Read(DirHeader.ExternalFileAttributes, sizeof(DirHeader.ExternalFileAttributes));
                ZipStream.Read(DirHeader.RelativeOffset, sizeof(DirHeader.RelativeOffset));
                ZipStream.Read(InternalFile, DirHeader.FileNameLength);
                InternalFile[DirHeader.FileNameLength] := #0;
                if UpperCase(StrPas(InternalFile)) = UpperCase(ExtractFile) then
                begin
                    Found := true;
                    break;
                end;
            end;

            if not Found then
                Exit; // can't find the extract file

            OutStream := TFileStream.Create(OutputFile, fmCreate or fmShareDenyWrite);

            ZipStream.Seek(DirHeader.RelativeOffset, soFromBeginning);

            ZipStream.Read(LocalHeader.Signature, sizeof(LocalHeader.Signature));
            ZipStream.Read(LocalHeader.VersionNeededToExtract, sizeof(LocalHeader.VersionNeededToExtract));
            ZipStream.Read(LocalHeader.GeneralPurposeBitFlag, sizeof(LocalHeader.GeneralPurposeBitFlag));
            ZipStream.Read(LocalHeader.CompressionMethod, sizeof(LocalHeader.CompressionMethod));
            ZipStream.Read(LocalHeader.LastModFileTime, sizeof(LocalHeader.LastModFileTime));
            ZipStream.Read(LocalHeader.LastModFileDate, sizeof(LocalHeader.LastModFileDate));
            ZipStream.Read(LocalHeader.CRC32, sizeof(LocalHeader.CRC32));
            ZipStream.Read(LocalHeader.CompressedSize, sizeof(LocalHeader.CompressedSize));
            ZipStream.Read(LocalHeader.UncompressedSize, sizeof(LocalHeader.UncompressedSize));
            ZipStream.Read(LocalHeader.FileNameLength, sizeof(LocalHeader.FileNameLength));
            ZipStream.Read(LocalHeader.ExtraFieldLength, sizeof(LocalHeader.ExtraFieldLength));
            ZipStream.Seek(LocalHeader.FileNameLength, soFromCurrent);
            if LocalHeader.ExtraFieldLength > 0 then
                ZipStream.Seek(LocalHeader.ExtraFieldLength, soFromCurrent);

            if DirHeader.GeneralPurposeBitFlag and $0001 <> 0 then
            begin
                if Password = '' then
                begin
                    Result := suiURWrongPassword;
                    Exit;
                end;            
                M1 := 305419896;
                M2 := 591751049;
                M3 := 878082192;
                M := 134775813;
                ZipStream.ReadBuffer(H, sizeof(H));
                for i := 1 to Length(Password) do
                begin
                    M1 := DWORD(CRC32Table[BYTE(M1 xor Integer(Password[i]))] xor ((M1 shr 8) and DWORD($00FFFFFF)));
                    M2 := M2 + (M1 and $FF);
                    M2 := M2 * M + 1;
                    M3 := DWORD(CRC32Table[BYTE(M3 xor Integer(M2 shr 24))] xor ((M3 shr 8) and DWORD($00FFFFFF)));
                end;

                for i := 0 to 11 do
                begin
                    BlockType := (M3 and $FFFF) or 2;
                    EncryptedHead[i] := H[i] xor ((BlockType * (BlockType xor 1)) shr 8);

                    M1 := DWORD(CRC32Table[BYTE(M1 xor Integer(EncryptedHead[i]))] xor ((M1 shr 8) and DWORD($00FFFFFF)));
                    M2 := M2 + (M1 and $FF);
                    M2 := M2 * M + 1;
                    M3 := DWORD(CRC32Table[BYTE(M3 xor Integer(M2 shr 24))] xor ((M3 shr 8) and DWORD($00FFFFFF)));
                end;

                if (DirHeader.GeneralPurposeBitFlag and $0008) = $0008 then
                    C := DirHeader.LastModFileTime shl $10
                else
                    C := DirHeader.CRC32;

                if TLongAsBytes(C).L4 <> EncryptedHead[11] then
                begin
                    Result := suiURWrongPassword;
                    Exit;
                end;
                DecrypedStream := TMemoryStream.Create();
                FillChar(Buf, 1024, #0);
                BytesToGo := ZipStream.Read(Buf[0], 1024);
                while BytesToGo = 1024 do
                begin
                    DecodeBuffer(Buf[0], 1024, M1, M2, M3, M);
                    DecrypedStream.WriteBuffer(Buf[0], 1024);
                    BytesToGo := ZipStream.Read(Buf[0], 1024);
                end;
                DecodeBuffer(Buf[0], BytesToGo, M1, M2, M3, M);
                DecrypedStream.Write(Buf[0], BytesToGo);
                DecrypedStream.Position := 0;
                InStream := DecrypedStream;
            end
            else
                InStream := ZipStream;

            GetMem(InBuf, 1024 * 16);
            GetMem(OutBuf, 1024 * 64 + 258);
            OutCurrent := OutBuf;
            OutWritePoint := OutBuf + 64 * 1024;
            InBufPos := nil;
            InBufEnd := nil;
            InBitsLeft := 0;
            InBitBuf := 0;
            repeat
                if InBitsLeft = 0 then
                begin
                    if (InBufEnd - InBufPos) < sizeof(Integer) then
                       FillBuffer(InStream, InBuf, InBufPos, InBufEnd);
                    InBitBuf := PInteger(InBufPos)^;
                    Inc(InBufPos, sizeof(Integer));
                    InBitsLeft := 32;
                end;
                LastBit := Odd(InBitBuf);
                InBitBuf := InBitBuf shr 1;
                Dec(InBitsLeft);

                BlockType := ReadBits(2, InBitsLeft, InBitBuf, InBufPos);
                if BlockType = 0 then
                begin
                    InBitBuf := InBitBuf shr (InBitsLeft mod 8);
                    Dec(InBitsLeft, InBitsLeft mod 8);
                    ReadBuffer(InStream, LenNotLen, sizeof(LenNotLen), InBitsLeft, InBitBuf, InBufPos, InBufEnd, InBuf);
                    BytesToGo := LenNotLen.Len;
                    GetMem(Buffer, 16384);

                    while BytesToGo <> 0 do
                    begin
                        if BytesToGo > 16384 then
                            BytesToWrite := 16384
                        else
                            BytesToWrite := BytesToGo;
                        ReadBuffer(InStream, Buffer^, BytesToWrite, InBitsLeft, InBitBuf, InBufPos, InBufEnd, InBuf);
  
                        Count := BytesToWrite;
                        if OutCurrent >= OutWritePoint then
                        begin
                            OutStream.WriteBuffer(OutBuf^, 32768);
                            FromPtr := OutBuf + 32768;
                            Move(FromPtr^, OutBuf^, OutCurrent - FromPtr);
                            OutCurrent := OutCurrent - 32768;
                        end;
                        Buffer2 := Buffer;
                        BytesToWrite2 := OutWritePoint - OutCurrent;
                        if BytesToWrite2 > Count then
                            BytesToWrite2 := Count;
                        Move(Buffer2^, OutCurrent^, BytesToWrite2);
                        Inc(OutCurrent, BytesToWrite2);
                        Dec(Count, BytesToWrite2);

                        while Count > 0 do
                        begin
                            Inc(Buffer2, BytesToWrite2);

                            OutStream.WriteBuffer(OutBuf^, 32768);
                            FromPtr := OutBuf + 32768;
                            Move(FromPtr^, OutBuf^, OutCurrent - FromPtr);
                            OutCurrent := OutCurrent - 32768;

                            BytesToWrite2 := OutWritePoint - OutCurrent;
                            if BytesToWrite2 > Count then
                                BytesToWrite2 := Count;
                            Move(Buffer2^, OutCurrent^, BytesToWrite2);
                            Inc(OutCurrent, BytesToWrite2);
                            Dec(Count, BytesToWrite2);
                        end;

                        Dec(BytesToGo, BytesToWrite);
                    end;
                    FreeMem(Buffer);
                end
                else if BlockType = 2 then
                begin
                    LitCount := ReadBits(5, InBitsLeft, InBitBuf, InBufPos) + 257;
                    DistCount := ReadBits(5, InBitsLeft, InBitBuf, InBufPos) + 1;
                    CodeLenCount := ReadBits(4, InBitsLeft, InBitBuf, InBufPos) + 4;

                    if (LitCount > 286) or (DistCount > 30) then
                        Exit;

                    FillChar(CodeLens, 19 * sizeof(Integer), 0);
                    for i := 0 to CodeLenCount - 1 do
                        CodeLens[CodeLengthIndex[i]] := ReadBits(3, InBitsLeft, InBitBuf, InBufPos);

                    CodeLenTree := THuffmanTree.Create(7);
                    CodeLenTree.Build(CodeLens, 0, 19, [0], $FFFF);

                    FillChar(CodeLens, sizeof(CodeLens), 0);
                    SymbolCount := 0;

                    while SymbolCount < LitCount + DistCount do
                    begin
                        BitCount := CodeLenTree.MaxCodeLen + 7;
                        BitBuffer := PeekBits(InStream, BitCount, InBitsLeft, InBitBuf, InBufPos, InBufEnd, InBuf);

                        LookupValue := BitBuffer and ExtractMaskArray[CodeLenTree.MaxCodeLen];
                        EncodedSymbol := CodeLenTree.Decode(LookupValue);

                        Symbol := EncodedSymbol and $FFFF;
                        SymbolCodeLen := (EncodedSymbol shr 16) and $FF;

                        if Symbol <= 15 then
                        begin
                            CodeLens[SymbolCount] := Symbol;
                            Inc(SymbolCount);
                            DiscardBits(SymbolCodeLen, InBitsLeft, InBitBuf, InBufPos);
                        end
                        else if Symbol = 16 then
                        begin
                            RepeatCount := 3 + ((BitBuffer shr SymbolCodeLen) and $3);
                            Symbol := CodeLens[SymbolCount - 1];
                            for i := 0 to RepeatCount - 1 do
                                CodeLens[SymbolCount+i] := Symbol;
                            Inc(SymbolCount, RepeatCount);
                            BitCount := SymbolCodeLen + 2;
                            DiscardBits(BitCount, InBitsLeft, InBitBuf, InBufPos);
                        end
                        else if Symbol = 17 then
                        begin
                            RepeatCount := 3 + ((BitBuffer shr SymbolCodeLen) and $7);
                            Inc(SymbolCount, RepeatCount);
                            BitCount := SymbolCodeLen + 3;
                            DiscardBits(BitCount, InBitsLeft, InBitBuf, InBufPos);
                        end
                        else if Symbol = 18 then
                        begin
                            RepeatCount := 11 + ((BitBuffer shr SymbolCodeLen) and $7F);
                            Inc(SymbolCount, RepeatCount);
                            BitCount := SymbolCodeLen + 7;
                            DiscardBits(BitCount, InBitsLeft, InBitBuf, InBufPos);
                        end;
                    end;

                    LiteralTree := THuffmanTree.Create(15);
                    LiteralTree.Build(CodeLens, 0, LitCount, LitExtraBits, 257);

                    DistanceTree := THuffmanTree.Create(15);
                    DistanceTree.Build(CodeLens, LitCount, DistCount, DistExtraBits, 0);

                    Decode(
                        LiteralTree, DistanceTree, InStream, OutStream, BitCount,
                        InBitsLeft, InBitBuf, BitBuffer, LookupValue, EncodedSymbol,
                        Symbol, SymbolCodeLen, Len, ExtraBitCount, Distance, InBufPos,
                        InBufEnd, InBuf, OutCurrent, OutWritePoint, OutBuf, FromPtr,
                        FromChar, ToChar
                    );
                    CodeLenTree.Free();
                    LiteralTree.Free();
                    DistanceTree.Free();
                end // block type = 2
                else if BlockType = 1 then
                begin
                    Decode(
                        StaticLiteralTree, StaticDistanceTree, InStream, OutStream, BitCount,
                        InBitsLeft, InBitBuf, BitBuffer, LookupValue, EncodedSymbol,
                        Symbol, SymbolCodeLen, Len, ExtraBitCount, Distance, InBufPos,
                        InBufEnd, InBuf, OutCurrent, OutWritePoint, OutBuf, FromPtr,
                        FromChar, ToChar
                    );
                end;

            until LastBit;

            if OutBuf <> OutCurrent then
                OutStream.WriteBuffer(OutBuf^, OutCurrent - OutBuf);
            Result := suiURSucc;
        except
            Result := suiURFailed;
        end;
    finally
        if DecrypedStream <> nil then
            DecrypedStream.Free();
        if OutStream <> nil then
        begin
            if (OutStream.Size = 0) and (Result = suiURSucc) then
                Result := suiURFailed
            else if OutStream.Size <> DirHeader.UncompressedSize then
                Result := suiURWrongPassword;
            OutStream.Free();
        end;
        if ZipStream <> nil then
            ZipStream.Free();
        if Assigned(InBuf) then
            FreeMem(InBuf);
        if Assigned(OutBuf) then
            FreeMem(OutBuf);
        if (Result <> suiURSucc) and FileExists(OutputFile) then
            DeleteFile(OutputFile);
    end;
end;

{ THuffmanTree }

procedure THuffmanTree.Build(const CodeLengths: array of Integer; StartInx,
  Count: Integer; const ExtraBits: array of BYTE; ExtraOffset: Integer);
const
    ByteRevTable : array [0..255] of BYTE = (
        $00, $80, $40, $C0, $20, $A0, $60, $E0, $10, $90, $50, $D0,
        $30, $B0, $70, $F0, $08, $88, $48, $C8, $28, $A8, $68, $E8,
        $18, $98, $58, $D8, $38, $B8, $78, $F8, $04, $84, $44, $C4,
        $24, $A4, $64, $E4, $14, $94, $54, $D4, $34, $B4, $74, $F4,
        $0C, $8C, $4C, $CC, $2C, $AC, $6C, $EC, $1C, $9C, $5C, $DC,
        $3C, $BC, $7C, $FC, $02, $82, $42, $C2, $22, $A2, $62, $E2,
        $12, $92, $52, $D2, $32, $B2, $72, $F2, $0A, $8A, $4A, $CA,
        $2A, $AA, $6A, $EA, $1A, $9A, $5A, $DA, $3A, $BA, $7A, $FA,
        $06, $86, $46, $C6, $26, $A6, $66, $E6, $16, $96, $56, $D6,
        $36, $B6, $76, $F6, $0E, $8E, $4E, $CE, $2E, $AE, $6E, $EE,
        $1E, $9E, $5E, $DE, $3E, $BE, $7E, $FE, $01, $81, $41, $C1,
        $21, $A1, $61, $E1, $11, $91, $51, $D1, $31, $B1, $71, $F1,
        $09, $89, $49, $C9, $29, $A9, $69, $E9, $19, $99, $59, $D9,
        $39, $B9, $79, $F9, $05, $85, $45, $C5, $25, $A5, $65, $E5,
        $15, $95, $55, $D5, $35, $B5, $75, $F5, $0D, $8D, $4D, $CD,
        $2D, $AD, $6D, $ED, $1D, $9D, $5D, $DD, $3D, $BD, $7D, $FD,
        $03, $83, $43, $C3, $23, $A3, $63, $E3, $13, $93, $53, $D3,
        $33, $B3, $73, $F3, $0B, $8B, $4B, $CB, $2B, $AB, $6B, $EB,
        $1B, $9B, $5B, $DB, $3B, $BB, $7B, $FB, $07, $87, $47, $C7,
        $27, $A7, $67, $E7, $17, $97, $57, $D7, $37, $B7, $77, $F7,
        $0F, $8F, $4F, $CF, $2F, $AF, $6F, $EF, $1F, $9F, $5F, $DF,
        $3F, $BF, $7F, $FF
    );
var
    i : Integer;
    Symbol : Integer;
    LengthCount : array [0..15] of Integer;
    NextCode : array [0..15] of Integer;
    Code : Integer;
    CodeLen : Integer;
    CodeData : Integer;
    DecoderLen : Integer;
    CodeIncr : Integer;
    Decodes : PTIntegerList;
    DecodesEnd : Pointer;
    TablePtr : Pointer;
begin
    FillChar(LengthCount, sizeof(LengthCount), 0);
    m_MaxCodeLen := 0;
    for i := 0 to Count - 1 do
    begin
        CodeLen := CodeLengths[i + StartInx];
        if CodeLen > m_MaxCodeLen then
            m_MaxCodeLen := CodeLen;
        Inc(LengthCount[CodeLen]);
    end;

    DecoderLen := PowerOfTwo[m_MaxCodeLen];
    GetMem(m_Decodes, DecoderLen * sizeof(Integer));
    DecodesEnd := PAnsiChar(m_Decodes) + (DecoderLen * sizeof(Integer));
    FillChar(m_Decodes^, DecoderLen * sizeof(Integer), $FF);

    Code := 0;
    LengthCount[0] := 0;
    for i := 1 to m_DefMaxCodeLen do
    begin
        Code := (Code + LengthCount[i-1]) shl 1;
        NextCode[i] := Code;
    end;

    Decodes := m_Decodes;
    TablePtr := @ByteRevTable;

    for Symbol := 0 to Count - 1 do
    begin
        CodeLen := CodeLengths[Symbol + StartInx];

        if CodeLen <> 0 then
        begin
            Code := NextCode[CodeLen];
            asm
                push esi
                mov eax, Code
                mov esi, TablePtr
                xor ecx, ecx
                xor edx, edx
                mov cl, ah
                mov dl, al
                mov al, [esi+ecx]
                mov ah, [esi+edx]
                mov ecx, 16
                pop esi
                sub ecx, CodeLen
                shr eax, cl
                mov Code, eax
            end;

            CodeData := Symbol + (CodeLen shl 16);
            if Symbol >= ExtraOffset then
                CodeData := CodeData + (ExtraBits[Symbol - ExtraOffset] shl 24);

            CodeIncr := PowerOfTwo[CodeLen] * sizeof(Integer);
            asm
                push edi
                mov eax, Decodes
                mov edi, DecodesEnd
                mov edx, Code
                shl edx, 1
                shl edx, 1
                add eax, edx
                mov edx, CodeData
                mov ecx, CodeIncr
            @@1:
                mov [eax], edx
                add eax, ecx
                cmp eax, edi
                jl @@1
                pop edi
            end;
            Inc(NextCode[CodeLen]);
        end;
    end;
end;

constructor THuffmanTree.Create(DefMaxCodeLen: Integer);
begin
    m_DefMaxCodeLen := DefMaxCodeLen;
end;

function THuffmanTree.Decode(LookupBits: Integer): Integer;
begin
    Result := m_Decodes^[LookupBits];
end;

destructor THuffmanTree.Destroy;
begin
    if (m_Decodes <> nil) then
        FreeMem(m_Decodes);
    inherited;
end;

{ Tsk2SkinFileReader }

constructor Tsk2SkinFileReader.Create(FileName, Password : String);
begin
    m_BitmapList := TStringList.Create();
    m_IntegerList := TStringList.Create();
    m_BooleanList := TStringList.Create();
    m_StrList := TStringList.Create();

    Load(FileName, Password);
end;

destructor Tsk2SkinFileReader.Destroy;
var
    i : Integer;
begin
    for i := 0 to m_BitmapList.Count - 1 do
    begin
        m_BitmapList.Objects[i].Free();
        m_BitmapList.Objects[i] := nil;
    end;
    m_StrList.Free();
    m_BooleanList.Free();
    m_IntegerList.Free();
    m_BitmapList.Free();
end;

function Tsk2SkinFileReader.GetBool(Key: String): Boolean;
var
    StrValue : String;
begin
    Result := false;
    StrValue := m_BooleanList.Values[Key];
    if StrValue = '' then
        Exit;
    try
        Result := Boolean(StrToInt(StrValue));
    except end;
end;

function Tsk2SkinFileReader.GetBitmap(Key: String): TBitmap;
var
    nIndex : Integer;
begin
    Result := nil;
    nIndex := m_BitmapList.IndexOf(Key);
    if nIndex = -1 then
        Exit;
    Result := TBitmap(m_BitmapList.Objects[nIndex]);
end;

function Tsk2SkinFileReader.GetInteger(Key: String): Integer;
var
    StrValue : String;
begin
    Result := -1;
    StrValue := m_IntegerList.Values[Key];
    if StrValue = '' then
        Exit;
    try
        Result := StrToInt(StrValue);
    except
        Result := -1;
    end;
end;

function Tsk2SkinFileReader.GetStr(Key: String): String;
begin
    Result := m_StrList.Values[Key];
end;


{$IFDEF VER130}

{ CoFunctions for Delphi 5  --  BEGIN}

function CoCreateGuid(out guid: TGUID): HResult; stdcall; external 'ole32.dll';

function StringFromCLSID(const clsid: TGUID; out psz: PWideChar): HResult; stdcall; external 'ole32.dll' name 'StringFromCLSID';

procedure CoTaskMemFree(pv: Pointer); stdcall; external 'ole32.dll' name 'CoTaskMemFree';

function CreateGUID(out Guid: TGUID): HResult;
begin
    Result := CoCreateGuid(Guid);
end;

function GUIDToString(const GUID: TGUID): string;
var
    P: PWideChar;
begin
    if not Succeeded(StringFromCLSID(GUID, P)) then
        raise Exception.Create('ERROR');
    Result := P;
    CoTaskMemFree(P);
end;

{ CoFunctions for Delphi 5  --  END}

{$ENDIF}

procedure Tsk2SkinFileReader.Load(FileName, Password : String);
var
    FileStream : TStream;
    Stream : TStream;
    Bitmap : TBitmap;
    FileHeader : Tsk2SkinFileHeader;
    NodeHeader : Tsk2SkinFileNodeHeader;
    BaseFileHeader : Tsk2SkinFileBaseHeader;
    StrValue : String;
    IntValue : Integer;
    BoolValue : Boolean;
    TempFileName : String;
    guid : TGUID;
    r : TsuiUnzipResult;
    function GetTempPath() : String;
    var
        TempPath : array [0..MAX_PATH - 1] of Char;
    begin
        windows.GetTempPath(MAX_PATH, TempPath);
        Result := StrPas(TempPath);
        if Result[Length(Result)] <> '\' then
            Result := Result + '\';
    end;
begin
    m_Ready := false;
    CreateGUID(guid);
    TempFileName := GetTempPath() + GUIDToString(guid);
    r := Unzip(FileName, 'SKINDATA.SK2', TempFileName, Password);
    if r = suiURWrongPassword then
    begin
        Exit;
    end
    else if r = suiURFailed then
        raise Exception.Create('Failed to read skin file!');

    // read header
    FileStream := TFileStream.Create(TempFileName, fmOpenRead or fmShareDenyNone);
    FileStream.Read(BaseFileHeader, sizeof(Tsk2SkinFileBaseHeader));
    FileStream.Seek(0, soFromBeginning);
    FileStream.Read(FileHeader, BaseFileHeader.HeaderSize);

    // read nodes
    FileStream.Seek(FileHeader.FirstNode, soFromBeginning);
    FileStream.Read(NodeHeader, sizeof(NodeHeader));

    while NodeHeader.NextNode <> 0 do
    begin
        FileStream.Seek(NodeHeader.NodeStart, soFromBeginning);

        case NodeHeader.NodeType of

        tbntStream :
        begin
            Stream := TMemoryStream.Create();
            Stream.CopyFrom(FileStream, NodeHeader.NodeSize);
            Stream.Seek(0, soFromBeginning);
            Bitmap := TBitmap.Create();
            Bitmap.LoadFromStream(Stream);
            m_BitmapList.AddObject(NodeHeader.NodeKey, Bitmap);
            Stream.Free();
        end;

        tbntStr :
        begin
            SetLength(StrValue, NodeHeader.NodeSize);
            FileStream.Read(StrValue[1], NodeHeader.NodeSize);
            m_StrList.Add(NodeHeader.NodeKey + String('=') + StrValue);
        end;

        tbntInt :
        begin
            FileStream.Read(IntValue, NodeHeader.NodeSize);
            m_IntegerList.Add(NodeHeader.NodeKey + String('=') + IntToStr(IntValue));
        end;

        tbntBool :
        begin
            FileStream.Read(BoolValue, NodeHeader.NodeSize);
            m_BooleanList.Add(NodeHeader.NodeKey + String('=') + IntToStr(Ord(BoolValue)));
        end;

        end; // case

        FileStream.Seek(NodeHeader.NextNode, soFromBeginning);
        FileStream.Read(NodeHeader, sizeof(NodeHeader));
    end;

    FileStream.Free();
    DeleteFile(TempFileName);

    m_Ready := true;
end;

procedure Tsk2SkinFileReader.SetBitmap(Key: String; const Buf: TBitmap);
var
    nIndex : Integer;
    Bitmap : TBitmap;
begin
    nIndex := m_BitmapList.IndexOf(Key);
    if nIndex = -1 then
        Exit;
    Bitmap := TBitmap(m_BitmapList.Objects[nIndex]);
    Bitmap.Assign(Buf);
end;

procedure Tsk2SkinFileReader.SetBool(Key: String; Value: Boolean);
begin
    m_BooleanList.Values[Key] := IntToStr(Ord(Value));
end;

procedure Tsk2SkinFileReader.SetInteger(Key: String; Value: Integer);
begin
    m_IntegerList.Values[Key] := IntToStr(Value);
end;

procedure Tsk2SkinFileReader.ProcessTransparentColor(TransColor: TColor);
var
    i : Integer;
begin
    for i := 0 to m_BitmapList.Count - 1 do
    begin
        if m_BitmapList.Objects[i] <> nil then
        begin
            TBitmap(m_BitmapList.Objects[i]).TransparentMode := tmFixed;
            TBitmap(m_BitmapList.Objects[i]).TransparentColor := TransColor;
        end;
    end;
end;

initialization
    BuildStaticTrees();

finalization
    StaticLiteralTree.Free();
    StaticDistanceTree.Free();
    
end.

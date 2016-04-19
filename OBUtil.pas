unit OBUtil;

interface

uses
  SysUtils, Controls, Windows, StrUtils, DateUtils, Graphics, Forms, Classes,
  Variants;

{* 阿拉伯数字转为中文式样数据 *}
function OBNum2CNum(Number: double): string;
{* 公历日期转为农历日期 *}
function OBDate2CDate(DateTime : TDateTime) : string;
{* 类似FOXPRO中的IIF函数 *}
function OBIIF(IsTrue : Boolean;TrueVal, FalseVal : Variant) : Variant;
{* 除法运算 *}
function OBDiv(Val1, Val2 : Integer) : Integer; overload;
function OBDiv(Val1, Val2 : Double) : Double; overload;
{* 字符串转数字型 *}
function OBStrToInt(StrNum : string) : Integer;
function OBStrToFloat(StrNum : string) : Double;
{* 取得某月最大天数 *}
function OBDaysInMonth(DateTime : TDateTime) : Integer;
{* 取得屏幕位图 *}
function OBGetDeskTopBitmap(var Bitmap : TBitmap) : Boolean;
{* 取得Windows手形光标 *}
function OBLoadHandCursor : Boolean;
{* Variant转为流格式 *}
function OBVariantToStream (const V : olevariant;Stream : TMemoryStream) : Boolean;
{* 流格式转为Variant *}
function OBStreamToVariant (Stream : TMemoryStream; var V : OleVariant) : Boolean;
{* 显示消息对话框 *}
function OBMessageBox(Handle : THandle;MsgStr : string) : Boolean;
{* 取得用户名称 *}
function OBGetUserName : string;
{* 取得系统临时位置 *}
function OBGetTempPath : string;

implementation

uses OBUtilCon;

function OBNum2CNum(Number: double): string;
var aa,bb,cc:string;
    bbb:array[1..16]of string;
    uppna:array[0..9] of string;
    i:integer;
begin
   bbb[1]:='万';
   bbb[2]:='仟';
   bbb[3]:='佰';
   bbb[4]:='拾';
   bbb[5]:='亿';;
   bbb[6]:='仟';;
   bbb[7]:='佰';
   bbb[8]:='拾';
   bbb[9]:='万';
   bbb[10]:='仟';
   bbb[11]:='佰';
   bbb[12]:='拾';
   bbb[13]:='元';
   bbb[14]:='.';
   bbb[15]:='角';
   bbb[16]:='分';
   uppna[1]:='壹';
   uppna[2]:='贰';
   uppna[3]:='叁';
   uppna[4]:='肆';
   uppna[5]:='伍';
   uppna[6]:='陆';
   uppna[7]:='柒';
   uppna[8]:='捌';
   uppna[9]:='玖';
   Str(Number:16:2,aa);
   cc:='';
   bb:='';
   result:='';
   for i:=1 to 16 do
     begin
       cc:=aa[i];
       if cc<>' ' then
         begin
          bb:=bbb[i];
           if cc='0' then
             cc:='零'
           else
             begin
               if cc='.' then
                 begin
                   cc:='';
                   bb:='';
                 end
               else
                 begin
                   cc:=uppna[StrToInt(cc)];
                 end
             end;
           result:=result+(cc+bb)
         end;
     end;
   //result:=result+'正';
end;

function OBDate2CDate(DateTime : TDateTime) : string;
  function DaysNumberOfDate(Date: TDate): Integer;
  var
    DaysNumber: Integer;
    I: Integer;
    yyyy, mm, dd: Word;
  begin
    DecodeDate(Date, yyyy, mm, dd);
    DaysNumber := 0;
    for I := 1 to mm - 1 do
      Inc(DaysNumber, MonthDays[IsLeapYear(yyyy), I]);
    Inc(DaysNumber, dd);
    Result := DaysNumber;
  end;

  function CnDateOfDate(Date: TDate): Integer;
  var
    CnMonth, CnMonthDays: array[0..15] of Integer;
    CnBeginDay, LeapMonth: Integer;
    yyyy, mm, dd: Word;
    Bytes: array[0..3] of Byte;
    I: Integer;
    CnMonthData: Word;
    DaysCount, CnDaysCount, ResultMonth, ResultDay: Integer;
  begin
    DecodeDate(Date, yyyy, mm, dd);
    if (yyyy < 1901) or (yyyy > 2050) then
    begin
      Result := 0;
      Exit;
    end;
    Bytes[0] := CnData[(yyyy - 1901) * 4];
    Bytes[1] := CnData[(yyyy - 1901) * 4 + 1];
    Bytes[2] := CnData[(yyyy - 1901) * 4 + 2];
    Bytes[3] := CnData[(yyyy - 1901) * 4 + 3];
    if (Bytes[0] and $80) <> 0
       then CnMonth[0] := 12
       else CnMonth[0] := 11;
    CnBeginDay := (Bytes[0] and $7f);
    CnMonthData := Bytes[1];
    CnMonthData := CnMonthData shl 8;
    CnMonthData := CnMonthData or Bytes[2];
    LeapMonth := Bytes[3];
    for I := 15 downto 0 do
    begin
      CnMonthDays[15 - I] := 29;
      if ((1 shl I) and CnMonthData) <> 0 then
      Inc(CnMonthDays[15 - I]);
      if CnMonth[15 - I] = LeapMonth then
      CnMonth[15 - I + 1] := - LeapMonth
      else
      begin
        if CnMonth[15 - I] < 0 then //上月为闰月
           CnMonth[15 - I + 1] := - CnMonth[15 - I] + 1
        else CnMonth[15 - I + 1] := CnMonth[15 - I] + 1;
        if CnMonth[15 - I + 1] > 12 then CnMonth[15 - I + 1] := 1;
      end;
    end;
    DaysCount := DaysNumberOfDate(Date) - 1;
    if DaysCount <= (CnMonthDays[0] - CnBeginDay) then
    begin
      if (yyyy > 1901) and
         (CnDateOfDate(EncodeDate(yyyy - 1, 12, 31)) < 0) then
         ResultMonth := - CnMonth[0]
      else ResultMonth := CnMonth[0];
      ResultDay := CnBeginDay + DaysCount;
    end
    else
    begin
      CnDaysCount := CnMonthDays[0] - CnBeginDay;
      I := 1;
      while (CnDaysCount < DaysCount) and
        (CnDaysCount + CnMonthDays[I] < DaysCount) do
      begin
        Inc(CnDaysCount, CnMonthDays[I]);
        Inc(I);
      end;
      ResultMonth := CnMonth[I];
      ResultDay := DaysCount - CnDaysCount;
    end;
    if ResultMonth > 0 then
    Result := ResultMonth * 100 + ResultDay
    else Result := ResultMonth * 100 - ResultDay
  end;

  function CnMonthOfDate(Date: TDate): String;
  const
    CnMonthStr: array[1..12] of String = (
    '一', '二', '三', '四', '五', '六', '七', '八', '九', '十',
    '冬', '蜡');
  var
    Month: Integer;
  begin
    Month := CnDateOfDate(Date) div 100;
    if Month < 0 then Result := '闰' + CnMonthStr[-Month]
    else Result := CnMonthStr[Month] + '月';
  end;

  function CnDayOfDate(Date: TDate): String;
  const
    CnDayStr: array[1..30] of String = (
    '初一', '初二', '初三', '初四', '初五',
    '初六', '初七', '初八', '初九', '初十',
    '十一', '十二', '十三', '十四', '十五',
    '十六', '十七', '十八', '十九', '二十',
    '廿一', '廿二', '廿三', '廿四', '廿五',
    '廿六', '廿七', '廿八', '廿九', '三十');
  var
    Day: Integer;
  begin
    Day := Abs(CnDateOfDate(Date)) mod 100;
    Result := CnDayStr[Day];
  end;

begin
  Result := CnMonthOfDate(Date) + CnDayOfDate(Date);
end;

function OBIIF(IsTrue : Boolean;TrueVal, FalseVal : Variant) : Variant;
begin
  if IsTrue
     then Result := TrueVal
     else Result := FalseVal;
end;

function OBDiv(Val1, Val2 : Integer) : Integer;
begin
  if Val2 = 0
     then Result := 0
     else Result := Val1 div Val2;
end;

function OBDiv(Val1, Val2 : Double) : Double; overload;
begin
  if Val2 = 0
     then Result := 0
     else Result := Val1 / Val2;
end;

function OBStrToInt(StrNum : string) : Integer;
begin
  try
    if StrNum = ''
       then Result := 0
       else Result := StrToInt(StrNum);
  except
    Result := 0;
  end;
end;

function OBStrToFloat(StrNum : string) : Double;
begin
  try
    if StrNum = ''
       then Result := 0
       else Result := StrToFloat(StrNum);
  except
    Result := 0;
  end;
end;

function OBDaysInMonth(DateTime : TDateTime) : Integer;
begin
  Result := DaysInMonth(DateTime);
end;

function OBGetDeskTopBitmap(var Bitmap : TBitmap) : Boolean;
var
  ACanvas : TCanvas;
begin
  if Bitmap <> nil then Bitmap := TBitmap.Create;
  
  ACanvas := TCanvas.Create;
  ACanvas.Handle := GetDC(0);
  try
    Bitmap.Width := Screen.Width;
    Bitmap.Height := Screen.Height;

    BitBlt(Bitmap.Canvas.Handle,0,0,Screen.Width,Screen.Height,
      ACanvas.Handle,0,0,SRCCOPY);
  finally
    Bitmap.Free;
    ReleaseDC(0,ACanvas.Handle);
    ACanvas.Free;
  end;
  Result := True;
end;

function OBLoadHandCursor : Boolean;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0,IDC_HAND);
  Result := True;
end;

function OBVariantToStream (const V : olevariant;Stream : TMemoryStream) : Boolean;
var
  p : pointer;
begin
  Stream.Position := 0;
  Stream.Size := VarArrayHighBound (v, 1) - VarArrayLowBound(v,  1) + 1;
  p := VarArrayLock (v);
  Stream.Write (p^, Stream.Size);
  VarArrayUnlock (v);
  Stream.Position := 0;
  Result := True;
end;

function OBStreamToVariant (Stream : TMemoryStream; var V : OleVariant) : Boolean;
var
  p : pointer;
begin
  v := VarArrayCreate ([0, Stream.Size - 1], varByte);
  p := VarArrayLock (v);
  Stream.Position := 0;
  Stream.Read (p^, Stream.Size);
  VarArrayUnlock (v);
  Result := True;
end;

function OBMessageBox(Handle : THandle;MsgStr : string) : Boolean;
begin
  Result := True;
end;

function OBGetUserName :string;
var
  Buff : PChar;
  Size : Cardinal;
begin
  Buff := GetMemory(101);
  try
    GetUserName(Buff,Size);
    Result := Trim(AnsiString(Buff));
  finally
    FreeMemory(Buff);
  end;
end;

function OBGetTempPath : string;
var
  Buff : PChar;
begin
  Buff := GetMemory(201);
  try
    GetTempPath(200,Buff);
    Result := Trim(AnsiString(Buff));
    if RightStr(Result,1) <> '\' then
       Result := Result + '\'; 
  finally
    FreeMemory(Buff);
  end;
end;

end.

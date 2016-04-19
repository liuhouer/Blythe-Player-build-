{*******************************************************}
{                                                       }
{       通过千千静听歌词服务器下载歌词Delphi7版         }
{                                                       }
{       作 者  :  刘申                                  }
{                                                       }
{       电子科技大学中山学院                            }
{                                                       }
{       E-Mail:lahcs@qq.com  QQ:307643816               }
{                                                       }
{*******************************************************}

unit QianQianLrc;

interface

uses
  SysUtils;

function LrcListLink(Atrist,Title:string;Server:Integer):string;
function LrcDownLoadLink(LrcId:Integer;Atrist,Title:string;Server:Integer):string;

implementation
function GB2UniCode(GB:string):string;
var
s: string;
i, j, k: integer;
a: array [1..160] of char;
begin
s:='';
StringToWideChar(GB, @(a[1]), 500);
i:=1;
while ((a[i]<>#0) or (a[i+1]<>#0)) do begin
j:=Integer(a[i]);
k:=Integer(a[i+1]);
s:=s+Copy(Format('%X ',[j*$100+k+$10000]) ,2,4);
i:=i+2;
end;
Result:=s;
end;

function HexStr(s:string):string;
var
p:^Byte;
begin
  p := Pointer(PChar(s));
  while p^ <> 0 do
  begin
      Result := Result+IntToHex(p^,2);
      Inc(p);
  end;
end;

function  Clear(s:string):string;//清除歌手 歌曲名中的各种半角全角字符
var
  i:Integer;
  temp,BStr,QStr:string;
begin
temp:=StringReplace(s,'''','',[rfReplaceAll,rfIgnoreCase]);
BStr:=' `~!@#$%^&*()-_=+,<.>/?;:"[{]}\|�';
QStr:='　。，、；：？！…—·ˉ¨‘’“”々～‖∶＂＇｀｜〃〔〕〈〉《》「」『』．〖〗【】（）［］｛｝';
QStr:=QStr+'≈≡≠＝≤≥＜＞≮≯∷±＋－×÷／∫∮∝∞∧∨∑∏∪∩∈∵∴⊥∥∠⌒⊙≌∽√';
QStr:=QStr+'§№☆★○●◎◇◆□℃‰■△▲※→←↑↓〓¤°＃＆＠＼︿＿￣―♂♀';
QStr:=QStr+'ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫ⒈⒉⒊⒋⒌⒍⒎⒏⒐⒑⒒⒓⒔⒕⒖⒗⒘⒙⒚⒛㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩';
QStr:=QStr+'①②③④⑤⑥⑦⑧⑨⑩⑴⑵⑶⑷⑸⑹⑺⑻⑼⑽⑾⑿⒀⒁⒂⒃⒄⒅⒆⒇';
QStr:=QStr+'┌┍┎┏┐┑┒┓─┄┈└┕┖┗┘┙┚┛━┅┉├┝┞┟┠┡┢┣│┆┊┤┥┦┧┨┩┪┫┃┇┋';
QStr:=QStr+'┬┭┮┯┰┱┲┳┴┵┶┷┸┹┺┻┼┽┾┿╀╁╂╃╄╅╆╇╈╉╊╋';
for i:=1 to Length(BStr) do
 begin
   temp:=StringReplace(temp,BStr[i],'',[rfReplaceAll,rfIgnoreCase]);
 end;
for i:=1 to (Length(QStr) div 2) do
 begin
   temp:=StringReplace(temp,QStr[(i-1)*2+1]+QStr[(i-1)*2+2],'',[rfReplaceAll,rfIgnoreCase]);
 end;
Result:=temp; 
end;

function Conv(i:Integer):Integer;
var
  t:Int64;
begin
    t:= i mod $100000000;
    if (i >= 0) and (t > $80000000) then
        Dec(t, $100000000);
    if (i < 0) and (t < $80000000) then
        Inc(t, $100000000);
    Result := t;
end;

function LrcListLink(Atrist,Title:string;Server:Integer):string;
var
  Url,A,T:string;
begin
  A:=LowerCase(Clear(Atrist));
  T:=LowerCase(Clear(Title));
if Server=0 then
    begin
      Url:='http://ttlrcct.qianqian.com/dll/lyricsvr.dll';
    end
else  if Server=1 then
    begin
      Url:='http://ttlrccnc.qianqian.com/dll/lyricsvr.dll';
    end;
Result:=Url+'?sh?Artist='+GB2UniCode(A)+'&Title='+GB2UniCode(T)+'&Flags=0';
end;

function LrcDownLoadLink(LrcId:Integer;Atrist,Title:string;Server:Integer):string;
var
  UTF8Str,URL:string;
  len,i,j:Integer;
  t1,t2,t3,t4,c:Integer;
  t6,t5:Int64;
  song:array [0..1000] of Byte;
begin
  UTF8Str:=HexStr(AnsiToUtf8(Atrist+title));
  if (length(UTF8Str) mod 2)=1 then
    begin
     UTF8Str:=UTF8Str+'0';
    end;
  len:=length(UTF8Str) div 2;
  for i:=1 to len do
    begin
        song[i]:=strtoint('$'+copy(UTF8Str,i*2-1,2));
    end;
    t2 := 0;
    t1 := ((lrcId and $0000FF00) shr 8);
    if ((lrcId and $00FF0000) = 0) then
      begin
       t3 := ($000000FF and (not t1));
      end
    else
      begin
       t3 := $000000FF and ((lrcId and $00FF0000) shr 16);
      end;
    t3 := t3 or (($000000FF and lrcId) shl 8);
    t3 := t3 shl 8;
    t3 := t3 or ($000000FF and t1);
    t3 := t3 shl 8;
    if (lrcId and $FF000000) = 0 then
     begin
       t3 := t3 or ($000000FF and (not lrcId));
     end
    else
     begin
       t3 := t3 or ($000000FF and (lrcId shr 24));
     end;
    j := len;
    while j >= 1 do
      begin
        c := song[j];
        if c >= $80 then
          begin
            c:=c-$100;
          end;
        t1 := (c+t2) and $00000000FFFFFFFF;
        t2 := (t2 shl (((j-1) mod 2) + 4)) and $00000000FFFFFFFF;
        t2 := (t1 + t2) and $00000000FFFFFFFF ;
        dec(j);
      end;
    j  := 1;
    t1 := 0;
    while j <= len do
      begin
        c := song[j];
        if c >= $80 then
          begin
            c:=c-$100;
          end;
        t4 := (c + t1) and $00000000FFFFFFFF;
        t1 := (t1 shl (((j-1) mod 2) + 3)) and $00000000FFFFFFFF;
        t1 := (t1 + t4) and $00000000FFFFFFFF;
        inc(j);
      end;
    t5 := Conv(t2 xor t3);
    t5 := Conv(t5 + (t1 or lrcId));
    t5 := Conv((t5 * (t1 or t3)));
    t5 := Conv(t5 * (t2 xor lrcId));
    t6 := t5;
    if t6 > $80000000 then
      begin
        t5 := t6 - $100000000;
      end;
if Server=0 then
    begin
      Url:='http://ttlrcct.qianqian.com/dll/lyricsvr.dll';
    end
else if Server=1 then
    begin
      Url:='http://ttlrccnc.qianqian.com/dll/lyricsvr.dll';
    end;
Result:=Url+'?dl?Id='+inttostr(lrcId)+'&Code='+inttostr(t5);
end;

end.
 
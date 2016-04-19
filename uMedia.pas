unit uMedia;

interface

uses
  Windows, mmSystem, SysUtils, Dialogs;

var
  cmd: string;
  dwReturn: Longint;
  MCIReturn: array[1..128] of char;
  Ret: PChar;

//打开文件             播放无窗口文件(如mp3..)时使用
function OpenMultimedia(AliasName:String;filename:String;typeDevice:String):String;overload;
                       //播放有窗口文件(如mpg,avi,dat..)时使用
function OpenMultimedia(wnd:hwnd;AliasName: string; FileName: string; TypeDevice: string): string;overload;
//得到短文件名
function GetShortName(sLongName: string): string;
//播放全部
function PlayMultimedia(AliasName: string): string; overload;
//指定开始或结束位置播放
function PlayMultimedia(AliasName: string; form_or_to_where:String; form_bz:boolean):String;overload;
//关闭指定文件
function CloseMultimedia(AliasName: string): string;
//暂停播放
function PauseMultimedia(AliasName: string): string;
//停止播放
function StopMultimedia(AliasName: string): string;
//继续播放
function ResumeMultimedia(AliasName: string): string;
//以帧格式返回媒体长度
function GetTotalframes(AliasName: string): Longint;
//以毫秒格式返回媒体长度
function GetTotalMilliSec(AliasName:String):Longint;
//定位到指定的帧位置并等待
function MoveMultimedia(AliasName:String; to_where: Longint):String;
//改变显示窗口的大小和位置
function PutMultimedia(wnd:hwnd; AliasName:String; left:longint; top:longint; Width:longint; Height:longint):String;
//返回目的区域长度或宽度
function GetSize(AliasName:String; CxOrCy:String):longint;
//关闭所有文件
function CloseAll():String;
//设置音量
function SetVolume(AliasName:String; Volumevalue:longint):String;
//得到声音
function GetVolume(AliasName:string):longint;

function GetTimeFormat(AliasName:string):string;
//设置音频输入源的声道转换
function AudioSource(AliasName:String; Source:String):String;
//返回当前位置,单位为帧
function GetCurrentMultimediaPos(AliasName:String):longint;
//返回当前位置，单位为毫秒
function GetCurrentMultimediaPosOfMS(AliasName:String):longint;
function setWinMax(AliasName:string):string;

implementation

//打开文件
{说明:
AliasName:指定欲打开文件的别名
filename:指定欲打开文件的文件名
typeDevice:指定该文件在Windows中注册的多媒体文件名,如MPEGVideo，AVIVideo，waveaudio等,
           建议使用MPEGVideo,因为其支持大多数媒体文件格式.}
function OpenMultimedia(AliasName:String;filename:String;typeDevice:String):String;overload;
var
  ShortPathAndFile : String;
begin
  ShortPathAndfile:=GetShortName(filename);
  cmd := 'open '+ShortPathAndFile+' type '+typeDevice+' Alias '+AliasName;
  dwReturn := mciSendString(pchar(cmd), nil, 0, 0);
  If Not( dwReturn = 0) Then  //文件打开失败
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);//得到错误信息
      Result := ret;
      exit
    end;
  Result := 'ok';//文件打开成功
end;

{说明:
wnd:图像显示目标的句柄}
function OpenMultimedia(wnd:hwnd;AliasName:String;filename:String;typeDevice:String):String;overload;
var
  ShortPathAndFile : String;
  hwnds:string;
Const
  WS_CHILD = '1073741824';
begin
  ShortPathAndfile:=GetShortName(filename);
  str(wnd,hwnds);
  cmd := 'open '+ShortPathAndFile+' type '+typeDevice+' Alias '+AliasName+' parent '+hwnds+' Style '+WS_CHILD +' shareable';
  dwReturn := mciSendString(pchar(cmd), nil, 0, 0);
  If Not( dwReturn = 0) Then  //文件打开失败
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);//得到错误信息
      Result := ret;
      exit
    end;
  Result := 'ok';//文件打开成功
end;

//得到短文件名
function GetShortName( sLongName : string ): string;
var
  sShortName : string;
  nShortNameLen : integer;
begin
  SetLength( sShortName ,MAX_PATH );
  nShortNameLen :=GetShortPathName(PChar( sLongName ) ,PChar( sShortName ) ,MAX_PATH - 1 );
  if( nShortNameLen = 0)then
    begin
      Result := '错误';
      exit;
    end;
  SetLength( sShortName, nShortNameLen );
  Result :=StrLower( pchar(sShortName));
end;

//播放全部
function PlayMultimedia(AliasName:String):String;overload;
begin
  cmd := 'play ' + AliasName;
  dwReturn := mciSendString(pchar(cmd), nil, 0, 0);//播放
  If Not (dwReturn = 0) Then  //文件打开失败
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);// 得到错误信息
      Result := ret;
      Exit
    End;
  Result :='ok';//文件打开成功
end;

//指定开始或结束位置播放
function PlayMultimedia(AliasName:String; form_or_to_where:String; form_bz:boolean):String;overload;
var
  from_where : string;
  to_where : string;
begin
  if form_bz then
    begin
      from_where := form_or_to_where;
      to_where := inttostr(GetTotalframes(AliasName));
    end
  else
    begin
      from_where := '0';
      to_where := form_or_to_where;
    end;
  cmd := 'play ' + AliasName + ' from ' + from_where + ' to ' + to_where;
  dwReturn := mciSendString(pchar(cmd), nil, 0, 0);//播放
  If Not (dwReturn = 0) Then  //文件打开失败
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);// 得到错误信息
      Result := ret;
      Exit
    End;
  Result :='ok';//文件打开成功
end;

//关闭指定文件
function CloseMultimedia(AliasName:String):String;
begin
  dwReturn := mciSendString(pchar('Close ' + AliasName), nil, 0, 0);//关闭
  If Not (dwReturn = 0) Then  //文件打开失败
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);//得到错误信息
      CloseMultimedia := ret;
      Exit
    End;
  Result :='ok';
end;

//暂停播放
function PauseMultimedia(AliasName:String):String;
begin
  dwReturn := mciSendString(pchar('Pause '+AliasName), nil, 0, 0);
  If Not (dwReturn = 0) Then
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit
    End;
  Result:= 'ok';
end;

//停止播放
function StopMultimedia(AliasName:String):String;
begin
  dwReturn := mciSendString(pchar('Stop '+AliasName), nil, 0, 0);
  If Not (dwReturn = 0) Then
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit
    End;
  Result:= 'ok';
end;

//继续播放
function ResumeMultimedia(AliasName:String):String;
begin
  dwReturn := mciSendString(pchar('Resume '+AliasName), nil, 0, 0);
  If Not (dwReturn = 0) Then
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit
    End;
  Result:= 'ok';
end;

//以帧格式返回媒体长度
function GetTotalframes(AliasName:String):longint;
var
  Total: PChar;
begin
  Total:=@MCIReturn;
  //设置时间格式为帧
  dwReturn := mciSendString(pchar('set '+ AliasName +' time format frames'), Total, 128, 0);
  //以当前时间格式返回媒体长度
  dwReturn := mciSendString(pchar('status '+ AliasName +' length'), Total, 128, 0);
  If Not (dwReturn = 0) Then
    begin
      Result := -1;
      Exit
    End;
  Result := strtoint(Total);
end;
//以毫秒格式返回媒体长度
function GetTotalMilliSec(AliasName:String):longint;
var
  Total: PChar;
begin
  Total:=@MCIReturn;
  //设置时间格式为毫秒
  dwReturn := mciSendString(pchar('set '+ AliasName +' time format milliseconds'), Total, 128, 0);
  //以当前时间格式返回媒体长度
  dwReturn := mciSendString(pchar('status '+ AliasName +' length'), Total, 128, 0);
  If Not (dwReturn = 0) Then
    begin
      Result := -1;
      Exit
    End;
  Result := strtoint(Total);
end;

//定位到指定的帧位置并等待
{说明:
to_where:目标帧位置}
function MoveMultimedia(AliasName:String; to_where:longint):String;
begin
  dwReturn := mciSendString(pchar('seek ' + AliasName + ' to ' + inttostr(to_where)),  nil, 0, 0);
  If Not (dwReturn = 0) Then
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit
    End;
  Result:= 'ok';
end;

//改变显示窗口的大小和位置
function PutMultimedia(wnd:hwnd; AliasName:String; left:longint; top:longint; Width:longint; Height:longint):String;
var
  rec:trect;
begin
  If (Width = 0) Or (Height = 0) Then
    begin
   //   GetWindowRect(wnd,rec);
      GetClientRect(wnd,rec);
      Width :=rec.Right- rec.left;
      Height := rec.Bottom - rec.top;
    End;
  dwReturn := mciSendString(pchar('put ' + AliasName + ' window at ' + inttostr(left) + ' ' + inttostr(top) + ' ' + inttostr(Width) + ' ' + inttostr(Height)),nil, 0, 0);
  If Not (dwReturn = 0) Then
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit
    End;
  Result := 'ok';
end;

//返回目的区域长度或宽度
function GetSize(AliasName:String; CxOrCy:String):longint;
var
  size : pchar;
  size1:string;
  s1, s2, s3, Width, Height : Longint;
begin
  //If (Not (strlower(pchar(CxOrCy)) = 'cx')) And
  //   (Not (strlower(pchar(CxOrCy)) = 'cy')) Then
  if (lowercase(cxorcy)<>'cx') and (lowercase(cxorcy)<>'cy') then
    begin
      Result := -1;
      Exit;
    end;
  size:=@MCIReturn;
  dwReturn := mciSendString(pchar('Where ' + AliasName + ' destination'), size, 128, 0);
  If Not (dwReturn = 0) Then
    begin
      Result := -1;
      Exit;
    End;
  size1:=size;
  s1 := pos(' ',size1);Delete(size1,1,s1);
  s2 := pos(' ',size1);Delete(size1,1,s2);
  s2:=s1+s2;
  s3 := pos(' ',size1);Delete(size1,1,s3);
  s3:=s2+s3;
  Width:=strtoint(copy(size,s2+1,s3-s2-1));
  Height:=strtoint(size1);
  //If strlower(pchar(CxOrCy)) = 'cx' Then
  If lowercase(CxOrCy) = 'cx' Then
    begin
      Result := Width;
      exit;
    end;
  //If strlower(pchar(CxOrCy)) = 'cy' Then
  If lowercase(CxOrCy) = 'cy' Then
    begin
      Result := Height;
      exit;
    end;
  Result := -1;
end;

//关闭所有文件
function CloseAll():String;
begin
  ret:=@MCIReturn;
  dwReturn := mciSendString(pchar('Close All'), nil, 0, 0);
  If Not (dwReturn = 0) Then
    begin
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit;
    End;
  Result := 'ok';
end;
//设置音量
function SetVolume(AliasName:String; Volumevalue:longint):String;
var
  VolumeV : Longint;
begin
  VolumeV := Volumevalue;
  If (VolumeV < 0) Or (VolumeV > 100) Then
    begin
      Result := '音量设置超出范围';
      Exit;
    End;
  VolumeV := VolumeV * 10;
  cmd := 'setaudio ' + AliasName + ' Volume to ' + inttostr(VolumeV);
  dwReturn := mciSendString(pchar(cmd), nil, 0, 0);
  If Not (dwReturn = 0) Then
    begin
      ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit;
    End;
  Result := 'ok';
end;

//设置音频输入源的声道转换
{说明:
source:可以是left(左声道),right(右声道),average(平均),stereo(立体声)}
function AudioSource(AliasName:String; Source:String):String;
begin
  cmd := 'Setaudio ' + AliasName + ' source to ' + Source;
  dwReturn := mciSendString(pchar(cmd), nil, 0, 0);
  If Not (dwReturn = 0) Then
    begin
      ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit;
    End;
  Result := 'ok';
end;

//返回当前位置,单位为帧
function GetCurrentMultimediaPos(AliasName:String):longint;
var
  pos:PChar; //,Total
begin
  pos:=@MCIReturn;
//  Total:=@MCIReturn;
  //设置时间格式为帧
//  dwReturn := mciSendString(pchar('set '+ AliasName +' time format frames'), Total, 128, 0);

  dwReturn := mciSendString(pchar('status ' + AliasName + ' position'), pos, 128, 0);
  If Not (dwReturn = 0) Then
    begin
      Result:= -1;
      Exit;
    End;
  Result:= strtoint(pos);
end;
function GetCurrentMultimediaPosOfMS(AliasName:String):longint;
var
  pos:PChar;//,Total
begin
  pos:=@MCIReturn;
//  Total:=@MCIReturn;
  //设置时间格式为毫秒
//  dwReturn := mciSendString(pchar('set '+ AliasName +' time format milliseconds'), Total, 128, 0);

  dwReturn := mciSendString(pchar('status ' + AliasName + ' position'), pos, 128, 0);
  If Not (dwReturn = 0) Then
    begin
      Result:= -1;
      Exit;
    End;
  Result:= strtoint(pos);
end;
function GetTimeFormat(AliasName:string):string;
var
  timeformat:PChar;
begin
  timeformat:=@MCIReturn;
  dwReturn := mciSendString(pchar('status ' + AliasName + ' time format'), timeformat, 128, 0);
  If Not (dwReturn = 0) Then
    begin
      ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit;
    End;
  Result:= timeformat;
end;
function GetVolume(AliasName:string):longint;
var vol:pchar;
begin
  vol:=@MCIReturn;
  dwReturn := mciSendString(pchar('status ' + AliasName + ' volume'), vol, 128, 0);
  If Not (dwReturn = 0) Then
    begin
      Result:= -1;
      Exit;
    End;
  Result:= strtoint(vol) div 10;
end;

function setWinMax(AliasName:string):string;
begin
  dwReturn := mcisendstring(pchar('window '+AliasName+' state maximized'),nil,0,0);
  If Not (dwReturn = 0) Then
    begin
      Ret:=@MCIReturn;
      mciGetErrorString (dwReturn, ret, 128);
      Result := ret;
      Exit
    End;
  Result:= 'ok';
end;
end.

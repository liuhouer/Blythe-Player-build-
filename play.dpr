program play;

uses
  Windows,
  Forms,
  Unit1 in 'Unit1.pas' {MainPlay},
  Unit2 in 'Unit2.pas' {PlayList},
  Unit3 in 'Unit3.pas' {LrcShow},
  Unit4 in 'Unit4.pas' {about},
  Unit5 in 'Unit5.pas' {miniplay},
  Unit6 in 'Unit6.pas' {SerLrc},
  Unit7 in 'Unit7.pas' {EditLrc},
  Unit8 in 'Unit8.pas' {minilrc},
  Unit9 in 'Unit9.pas' {Vision},
  Unit10 in 'Unit10.pas' {bTag};

{$R *.res}


  var
hAppMutex: THandle;
begin
  Application.Initialize;

   //创建互斥对象
hAppMutex := CreateMutex(nil, false, PChar('OnlyOne'));
if (hAppMutex = 0) then
begin
MessageBox(0,PChar('创建互斥对象失败!'),PChar('Error'),MB_OK + MB_ICONINFORMATION);
exit;
end;
//查看是否是第一次运行程序
if ((hAppMutex <> 0) and (GetLastError() = ERROR_ALREADY_EXISTS)) then
begin
MessageBox(0,PChar('程序已经有一个实例在运行!'),PChar('OK'),MB_OK + MB_ICONINFORMATION);
//关闭互斥对象，退出程序
exit;
 end;

 
  Application.Title := '小布静听';
  Application.CreateForm(TMainPlay, MainPlay);
  Application.CreateForm(TPlayList, PlayList);
  Application.CreateForm(TLrcShow, LrcShow);
  Application.CreateForm(Tabout, about);
  Application.CreateForm(Tminiplay, miniplay);
  Application.CreateForm(TSerLrc, SerLrc);
  Application.CreateForm(TEditLrc, EditLrc);
  Application.CreateForm(Tminilrc, minilrc);
  Application.CreateForm(TVision, Vision);
  Application.CreateForm(TbTag, bTag);
  Application.Run;
end.

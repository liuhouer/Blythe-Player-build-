program Project1;

uses
  Windows,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4};

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
CloseHandle(hAppMutex);
exit;
end;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.


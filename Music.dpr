program XbPlayer;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainPlay},
  Unit4 in 'Unit4.pas' {Form4},
  Unit6 in 'Unit6.pas' {SerLrc},
  Unit7 in 'Unit7.pas' {EditLrc},
  Unit9 in 'Unit9.pas' {Vision};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainPlay, MainPlay);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TSerLrc, SerLrc);
  Application.CreateForm(TEditLrc, EditLrc);
  Application.CreateForm(TVision, Vision);
  Application.Run;
end.

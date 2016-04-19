program XbPlayer;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainPlay},
  Unit2 in 'Unit2.pas' {PlayList},
  Unit3 in 'Unit3.pas' {LrcShow},
  Unit4 in 'Unit4.pas' {Form4},
  Unit5 in 'Unit5.pas' {miniplay},
  Unit6 in 'Unit6.pas' {SerLrc},
  Unit7 in 'Unit7.pas' {EditLrc},
  Unit9 in 'Unit9.pas' {Vision},
  Unit8 in 'Unit8.pas' {minilrc};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainPlay, MainPlay);
  Application.CreateForm(TPlayList, PlayList);
  Application.CreateForm(TLrcShow, LrcShow);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(Tminiplay, miniplay);
  Application.CreateForm(TSerLrc, SerLrc);
  Application.CreateForm(TEditLrc, EditLrc);
  Application.CreateForm(TVision, Vision);
  Application.CreateForm(Tminilrc, minilrc);
  Application.Run;
end.

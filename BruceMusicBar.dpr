program XbPlayer;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainPlay},
  Unit2 in 'Unit2.pas' {PlayList};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainPlay, MainPlay);
  Application.CreateForm(TPlayList, PlayList);
  
  Application.Run;
end.

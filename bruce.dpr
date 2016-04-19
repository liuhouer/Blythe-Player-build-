program demo;

uses
  Forms,
  main in 'main.pas' {FormPlayer},
  AudioEngine in 'AOClasses\AudioEngine.pas',
  AudioObject in 'AOClasses\AudioObject.pas',
  CommonTypes in 'AOClasses\CommonTypes.pas',
  PlayListClass in 'AOClasses\PlayListClass.pas',
  Bass in 'AOClasses\Bass.pas',
  playlist in 'playlist.pas' {FormPlaylist},
  DrawUtils in 'DrawUtils.pas',
  config in 'config.pas' {FormConfig},
  equalyzer in 'equalyzer.pas' {FormEQ};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormPlayer, FormPlayer);
  Application.CreateForm(TFormPlaylist, FormPlaylist);
  Application.CreateForm(TFormConfig, FormConfig);
  Application.CreateForm(TFormEQ, FormEQ);
  Application.Run;
end.

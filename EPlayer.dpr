program EPlayer;

uses
  Forms,
  uEPlayer in 'uEPlayer.pas' {frmEPlayer},
  uSplash in 'uSplash.pas' {frmSplash},
  uPlayList in 'uPlayList.pas' {frmPlayList},
  uPublic in 'uPublic.pas',
  uAbout in 'uAbout.pas' {frmAbout};

{$R *.res}

begin
  frmSplash := TfrmSplash.Create(Application);
  frmSplash.Show;
  frmSplash.Update;
  Application.Initialize;
  Application.Title := 'MP3²¥·ÅÆ÷';
  Application.CreateForm(TfrmEPlayer, frmEPlayer);
  Application.CreateForm(TfrmPlayList, frmPlayList);
  frmSplash.Free;
  Application.Run;
end.

program Prj_Player;

uses
  Forms,
  Unit_Main in 'Unit_Main.pas' {Frm_Player},
  Unit_EQ in 'Unit_EQ.pas' {Frm_EQ},
  Unit_List in 'Unit_List.pas' {Frm_List},
  Unit_Lyric in 'Unit_Lyric.pas' {Frm_Lyric},
  Unit_LyricForm in 'Unit_LyricForm.pas' {LyricForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'MiniPlayer';
  Application.CreateForm(TFrm_Player, Frm_Player);
  Application.CreateForm(TFrm_EQ, Frm_EQ);
  Application.CreateForm(TFrm_Lyric, Frm_Lyric);
  Application.CreateForm(TLyricForm, LyricForm);
  //Application.CreateForm(TFrm_List, Frm_List);
  Frm_EQ.Show;
  //Frm_List.Show;
  Frm_Lyric.Show;
  Application.Run;
end.

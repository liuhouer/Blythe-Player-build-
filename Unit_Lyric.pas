unit Unit_Lyric;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LyricShow;

type
  TFrm_Lyric = class(TForm)
    LyricShow1: TLyricShow;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    LyricFile: string;
    LyricTitle: string;
    LyricArtist: string;
    function ShowLyric(LyricFile:string):boolean;
    procedure ShowNoLyric;
    procedure stopLyric;
    function SeekLyric(pos:integer):boolean;
    { Public declarations }
  end;

var
  Frm_Lyric: TFrm_Lyric;

implementation

uses Unit_LyricForm;

{$R *.dfm}

function TFrm_Lyric.ShowLyric(LyricFile: string): boolean;
begin
 Button1.Hide;
 LyricShow1.StopALL;
 LyricShow1.DrawCanvas:=Canvas;
 LyricShow1.LoadLyricFile(LyricFile);
 LyricShow1.StartLyric;
end;

function TFrm_Lyric.SeekLyric(pos: integer): boolean;
begin

  LyricShow1.Seek(pos);
end;

procedure TFrm_Lyric.stopLyric;
begin
   LyricShow1.StopALL;
end;

procedure TFrm_Lyric.ShowNoLyric;
begin
  self.Canvas.FillRect(canvas.ClipRect);
  Button1.Show;
end;

procedure TFrm_Lyric.Button1Click(Sender: TObject);
begin
  if LyricFile='' then exit;
 LyricForm.ClearAllLyrics;
 LyricForm.ListView1.Clear;
 LyricForm.Edit1.Text:=LyricTitle;
 LyricForm.Edit2.Text:=LyricArtist;
 LyricForm.Label5.Caption:=LyricFile;
 LyricForm.ShowModal;
 try
 ShowLyric(LyricFile);
 except
 end;
end;

end.

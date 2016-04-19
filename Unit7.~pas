unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TEditLrc = class(TForm)
    memo: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditLrc: TEditLrc;

implementation

uses Unit3, Unit1;

{$R *.dfm}

procedure TEditLrc.FormShow(Sender: TObject);
begin
if mainplay.MediaPlayer1.FileName <> ''then
memo.Lines.LoadFromFile(ExtractFilePath(mainplay.MediaPlayer1.FileName)+copy(extractfilename(mainplay.MediaPlayer1.FileName),0,length(extractfilename(mainplay.MediaPlayer1.FileName))-4)+'.lrc');

end;

procedure TEditLrc.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if memo.Modified then
if messagedlg('内容已经发生变化，是否保存它？',mtinformation,[mbyes,mbno],0)= mryes then
memo.Lines.SaveToFile(ExtractFilePath(mainplay.MediaPlayer1.FileName)+copy(extractfilename(mainplay.MediaPlayer1.FileName),0,length(extractfilename(mainplay.MediaPlayer1.FileName))-4)+'.lrc')
else
exit;
memo.modified:=false; //将判断是否变化初始化为否..
end;

end.

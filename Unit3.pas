unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OBMagnet;

type
  TForm3 = class(TForm)
    lst1: TListBox;
    tmr1: TTimer;
    OBFormMagnet1: TOBFormMagnet;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmr1Timer(Sender: TObject);
    procedure loadlrc(s: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    
  end;

var
  Form3: TForm3;
  fle: string;
   lrc: TStrings;
implementation

uses Unit1;

{$R *.dfm}

procedure TForm3.loadlrc(s: string);
var
  i: Integer;

begin
  lrc := TStringList.Create;
  if s <> '' then
  begin
    fle := ExtractFileName(s);
    SetLength(fle, Length(ExtractFileName(fle)) - Length(ExtractFileExt(fle)));
    try
      lrc.LoadFromFile(ExtractFilePath(s) + fle + '.lrc');
      Form3.tmr1.Enabled := True;
    except
      on E: Exception do
      begin
       lst1.Items.Add('找不到歌词文件,请确保歌词文件与当前播放曲目同!');
       lst1.Items.Add('名且在同一目录下');

      end;
    end;
    for i := 0 to lrc.Count - 1 do
    begin
     // Form3.lst1.Items.Add(lrc.strings[i]);
     if i>=2 then
     Form3.lst1.Items.Add( Copy(lrc.Strings[i], 11, length(lrc.Strings[i])-11));
      
      end;
  end;
  
  end;




procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tmr1.Enabled := False;
  
  lst1.Clear;
  lrc.Free;
  end;

procedure TForm3.tmr1Timer(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lrc.Count - 1 do
  begin
    if Form1.stat1.Panels[1].Text = Copy(lrc.Strings[i], 2, 5) then
    begin
      lst1.ItemIndex := i;
      
      Break;
    end;
  end;

end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
AnimateWindow(Form3.Handle,800,AW_HIDE or AW_BLEND);

end;

procedure TForm3.FormShow(Sender: TObject);
begin
  form3.Left:=Form1.Left+form1.Width;
  Form3.Top:=Form1.Top;
AnimateWindow(Form3.Handle,800,AW_BLEND);
end;



end.

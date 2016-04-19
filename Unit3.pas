unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, OBMagnet, ExtCtrls, StdCtrls;

type
  TLrcShow = class(TForm)
    lst1: TListBox;
    tmr1: TTimer;
    OBFormMagnet1: TOBFormMagnet;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
     procedure loadlrc(s: string);
    procedure tmr1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


  var
  LrcShow: TLrcShow;
  fle: string;
  Lrc: TStrings;
  movelrc :string;
implementation

uses Unit1, Unit6, Unit8;

{$R *.dfm}

procedure TLrcShow.loadlrc(s: string);
var
  i: Integer;

begin
  lrc := TStringList.Create;
  if s <> '' then
  begin
    fle := ExtractFileName(s);
    SetLength(fle, Length(ExtractFileName(fle)) - Length(ExtractFileExt(fle)));
   { try            //抛出异常算法---------------2012.2.20 edited by bruce
      lrc.LoadFromFile(ExtractFilePath(s) + fle + '.lrc');
      lrcshow.tmr1.Enabled := True;
    except
      on E: Exception do
      begin
       //lst1.Items.Add('找不到歌词文件,请确保歌词文件与当前播放曲目同!');
       //lst1.Items.Add('并且在同一目录下');
       minilrc.Label1.Caption:='小步静听，静听精彩！';  //控制MINi 歌词默认输出--by bruce 2012.3.26
       serlrc.show;

      end;
    end;  }  //try 抛出异常算法不太稳定     换成判断文件存在算法  2012.4.3  edit by bruce

    if   FileExists(ExtractFilePath(s) + fle + '.lrc')  then  //存在则加载它
    begin
      lrc.LoadFromFile(ExtractFilePath(s) + fle + '.lrc');
      lrcshow.tmr1.Enabled := True;

    end  else                                              //不存在则联网搜索..
    begin
       minilrc.Label1.Caption:='小步静听，静听精彩！';  //控制MINi 歌词默认输出--by 小布 2012.3.26
       serlrc.show;
    end;



    for i := 0 to lrc.Count - 1 do
    begin
     // Form3.lst1.Items.Add(lrc.strings[i]);
     if i>=2 then  //i > 2  是略去标题 -作者 - 专辑信息 【0-2】  2012.3.20

     lrcshow.lst1.Items.Add(Copy(lrc.Strings[i],11, length(lrc.Strings[i])-10));

     //实现[00:01.03]显示  [00:01.03][01:02.50]多行显示正在思考..  2012.3.26
      end;
  end;

  end;


procedure TLrcShow.tmr1Timer(Sender: TObject);
var
  i: Integer;
  begin
  for i := 0 to lrc.Count - 1 do
  begin

        if (mainplay.stat1.Panels[1].Text = Copy(lrc.Strings[i], 2, 5)) then

         begin

          lst1.ItemIndex := i-2;
          minilrc.Label1.Caption:=lrcshow.lst1.items.strings[integer(lrcshow.lst1.itemindex)];//控制显示一行mini歌词

         end;

      end;


  end;



procedure TLrcShow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
AnimateWindow(Lrcshow.Handle,800,AW_HIDE or AW_BLEND); //缓缓关闭..
end;

procedure TLrcShow.FormShow(Sender: TObject);
begin
lrcshow.Left:=mainplay.Left+mainplay.Width;
  lrcshow.Top:=mainplay.Top;
AnimateWindow(lrcshow.Handle,800,AW_BLEND);
end;

procedure TLrcShow.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  tmr1.Enabled := False;
  
  lst1.Clear;
  lrc.Free;
end;

procedure TLrcShow.N1Click(Sender: TObject);
begin
mainplay.n79click(sender);
end;

procedure TLrcShow.N2Click(Sender: TObject);
begin
mainplay.n83click(sender);
end;

procedure TLrcShow.N3Click(Sender: TObject);
begin
mainplay.n82click(sender);
end;

procedure TLrcShow.N4Click(Sender: TObject);
begin
mainplay.n84click(sender);
end;

end.

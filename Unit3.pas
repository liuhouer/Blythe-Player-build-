unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, OBMagnet, ExtCtrls, StdCtrls, ComCtrls, VsControls,
  VsSkin, VsComposer, RzBorder, RzLstBox, RzListVw;

type
  TLrcShow = class(TForm)
    tmr1: TTimer;
    OBFormMagnet1: TOBFormMagnet;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    VsComposer1: TVsComposer;
    VsSkin1: TVsSkin;
    lv1: TRzListView;
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

 str: WideString;
FTextList  :TStrings;



timestr:String;
content:WideString;
lastIndex:integer;
timeNum:integer;
n:integer;

nextStr: WideString;
nextContent:WideString;
nextlastIndex:integer;
 xlist: TListItem;
begin
  lrc := TStringList.Create;
  FTextList:=TStringList.create;
  if s <> '' then
  begin
    fle := ExtractFileName(s);
    SetLength(fle, Length(ExtractFileName(fle)) - Length(ExtractFileExt(fle)));
    if   FileExists(ExtractFilePath(s) + fle + '.lrc')  then  //存在则加载它
    begin

      FTextList.LoadFromFile(ExtractFilePath(s) + fle + '.lrc');
      //处理lrc开始 ------------------------------------------------------------

       for i:=0 to FTextList.count -1 do
     begin
     str := FTextList[i];

     lastIndex:=LastDelimiter(']',str);
     //showmessage(inttostr(lastIndex));
     //下面处理time标签
     timeNum:=lastIndex div 10;
     //showmessage(inttostr(timeNum));
            content :=copy(str,lastIndex+1,length(str)-lastIndex) ;

      if(i<FTextList.count -1)then begin  nextStr:=   FTextList[i+1];nextlastIndex:=LastDelimiter(']',nextStr);nextContent :=copy(nextStr,nextlastIndex+1,length(nextStr)-nextlastIndex) ;end;
     //m1.Lines.Add(content);
         if timeNum=0 then   lrc.Add(str) //空行
         else
             if (POS('ti:',trim(str))>0) or (POS('ar:',trim(str))>0)  or (POS('al:',trim(str))>0)  or (POS('BY:',trim(str))>0) or (POS('TI:',str)>0) or (POS('AR:',trim(str))>0)  or (POS('AL:',trim(str))>0)  or (POS('BY:',trim(str))>0) then   else //去除头信息
             if(timeNum=1) and (length(trim(str))=10) then  lrc.Add(str+nextContent)  else    //合并处理单个时间标签
         for n:=0 to timeNum-1 do
         begin
           timestr:=copy(str,n*10+1,10) ;
           lrc.Add(timestr+content);
         end;


      end;
      //处理lrc结束  -----------------------------------------------------------

      lrcshow.tmr1.Enabled := True;

    end  else                                              //不存在则联网搜索..
    begin
       //minilrc.Label1.Caption:='小步静听，静听精彩！';  //控制MINi 歌词默认输出--by 小布 2012.3.26
       serlrc.show;
    end;

    for i := 0 to lrc.Count - 1 do
    begin

     //lrcshow.lst1.Items.Add(Copy(lrc.Strings[i],11, length(lrc.Strings[i])-10));

     xlist := lrcshow.lv1.Items.Add;
     xlist.SubItems.add(Copy(lrc.Strings[i],11, length(lrc.Strings[i])-10));

     //居中显示
     lrcshow.lv1.Columns[1].Alignment:=taCenter ;

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

            //控制歌词数组滚动
           //lst1.ItemIndex := i;
           //lst1.TopIndex := i-round(lst1.Height/lst1.Font.size/6);


           //控制listview的滚动
            if lrcshow.Showing then      lrcshow.lv1.SetFocus;

            lrcshow.lv1.ItemIndex  :=i;
            //选中项居中
            lrcshow.lv1.Selected.MakeVisible(true);

            


           if i>0 then
            begin
              lrcshow.lv1.Scroll(lv1.Items[i-1].Position.X,lv1.Items[i-1].Position.y-100)
            end
           else
            begin
              lrcshow.lv1.Scroll(0,-100000);
            end;

           //控制显示一行mini歌词
              if(minilrc.Showing) then
                begin
                 minilrc.Label1.Caption:=lrcshow.lv1.items[i].SubItems.GetText;
                end;
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
  
  lv1.Clear;
  //lst1.Clear;
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

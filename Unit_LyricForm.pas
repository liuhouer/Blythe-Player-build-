unit Unit_LyricForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LibXmlParser,IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, ComCtrls,inifiles, ExtCtrls;

type
  LyricInfo=record
    artist: string;
    title:string;
    album:string;
    filename:string;
    linkType:string;
    link:string;
  end;
  PLyricInfo = ^LyricInfo;
  
type
  TLyricForm = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button2: TButton;
    ComboBox1: TComboBox;
    Button3: TButton;
    ListView1: TListView;
    Button4: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
      LyricInfoList:TList;
      HttpClient: TIdHttp;
    function GetLyricsCount(title,artist:string):integer;
    function GetLyricSelf(Index:integer):String;
    function ReadBackXmlString(var backxml:string):boolean;
    function GetLyricsInfo(Index:integer;var LyricInfoResult: Lyricinfo):Boolean;
    function SaveLyricSelf(Index:integer;FileName:string):boolean;
  public
    { Public declarations }
    MainFormHandle: Hwnd;
    CurrentFileName: string;
    function ClearAllLyrics:boolean;
  end;

var
  LyricForm: TLyricForm;
  SearchCode: String;

implementation

{$R *.dfm}


function TLyricForm.ClearAllLyrics:boolean;
var i :integer;
begin
  for i:=0 to LyricInfoList.Count-1 do
  begin
    Dispose(LyricInfoList[i])
  end;
  LyricInfoList.Clear;
  result:=true
end;

function TLyricForm.ReadBackXmlString(var backxml:string):boolean;
var
  XmlParser:TXmlParser;
  //Strg : STRING;
  ALyricInfo:PLyricInfo;
begin

  ClearAllLyrics;
  XmlParser:=TXmlParser.Create;
  backxml:=StringReplace(backxml,'utf-8','gb2312',[rfIgnoreCase]);
  XmlParser.LoadFromBuffer(pchar(backxml));
  XmlParser.Normalize:=True;
  XmlParser.StartScan;


    WHILE XmlParser.Scan DO BEGIN
      CASE XmlParser.CurPartType OF
        ptXmlProlog : BEGIN
                        //tmpStrList.Add('<?xml?>');
                      END;
        ptDtdc      : BEGIN
                        //tmpStrList.Add('DTD');
                      END;
        ptStartTag,
        ptEmptyTag  : BEGIN
                        //tmpStrList.Add(XmlParser.CurName);
                        IF XmlParser.CurAttr.Count > 0 THEN BEGIN
                            if XmlParser.CurName='return' then
                            begin
                              if (XmlParser.CurAttr.Value('result')='NOT_FOUND') or (XmlParser.CurAttr.Value('result')<>'OK') then
                              begin
                                result:=false;
                                Exit;
                              end;
                            end;
                            if XmlParser.CurName='fileinfo' then
                            begin
                              New(ALyricInfo);
                              ALyricInfo^.title:=XmlParser.CurAttr.Value('title');
                              ALyricInfo^.artist:=XmlParser.CurAttr.Value('artist');
                              ALyricInfo^.album:=XmlParser.CurAttr.Value('album');
                              ALyricInfo^.filename:=XmlParser.CurAttr.Value('filename');
                              ALyricInfo^.linkType:=XmlParser.CurAttr.Value('linkType');
                              ALyricInfo^.link:=XmlParser.CurAttr.Value('link');
                              LyricInfoList.Add(ALyricInfo);
                            end;

                            //tmpStrList.Add (XmlParser.CurAttr.Name(i)+':  '+XmlParser.CurAttr.Value(i));
                          //tmpStrList.Add (XmlParser.CurAttr);
                          END

                        //IF XmlParser.CurPartType = ptStartTag THEN   // Recursion
                          //ScanElement;
                      END;
        ptEndTag    : BREAK;
        ptContent,
        ptCData     : BEGIN
                        //tmpStrList.Add ( '---');  // !!!
                        //tmpStrList.add(XmlParser.CurContent);
                      END;
        ptComment   : BEGIN
                        //tmpStrList.Add ( 'Comment');
                        //SetStringSF (Strg, XmlParser.CurStart+4, XmlParser.CurFinal-3);
                        //tmpStrList.Add(TrimWs (Strg));
                      END;
        ptPI        : BEGIN
                        //tmpStrList.Add( XmlParser.CurName + ' ' + XmlParser.CurContent);
                      END;
        END;

    //tmpStrList.text:=tmpStrList.Text;

    //tmpStrList.Free;
    END;
    XmlParser.Free;
    result:=True;
      //IF Node <> NIL THEN
       // Node.SelectedIndex := Node.ImageIndex;
     // END;
end;

function TLyricForm.GetLyricsCount(title,artist:string):integer;
var
  NewCode: TStringList;
  BackCode:string;
begin
  NewCode:=TStringList.Create;


  NewCode.Text:=StringReplace(SearchCode,'范晓萱',artist, [rfReplaceall]);
  NewCode.Text:=stringreplace(NewCode.Text, '你的甜蜜', title, [rfReplaceall]);

  HttpClient.Host:='www.viewlyrics.com';
  HttpClient.port:=1212;
  HttpClient.Request.UserAgent:='MiniLyrics 3.0';
  HttpClient.Request.Referer:='';
  HttpClient.Request.Accept:='';
  HttpClient.Request.Connection:='';
  try
    BackCode:=HttpClient.Post('/searchlyrics.htm',NewCode);
  except
    //application.messagebox(#13#10'当前网络出现故障，可能的原因如下：'#13#10#13#10'      1.服务器出现异常'#13#10'      2.您的网络没有连接！','网络连接错误',MB_OK+MB_ICONASTERISK);
    Caption:='当前网络出现故障';
    Button1.Caption:='重新搜索';
    Button1.Enabled :=True;
    result:=0;
    exit;
  end;

  try
    ReadBackXmlString(backcode);
  except
    application.messagebox(#13#10'XML解析出错，请联系CockJay(gongji@qq.com)！','XML',MB_OK+MB_ICONASTERISK);
    Button1.Caption:='重新搜索';
    Button1.Enabled :=True;
    result:=0;
    exit;
  end;
  //Memo1.Lines.text:=BackCode;

  NewCode.Free;
  result:=LyricInfoList.Count;


end;

function TLyricForm.GetLyricsInfo(Index:integer;var LyricInfoResult: Lyricinfo):Boolean;
var
  ALyricInfo:PLyricInfo;
begin
  if (Index<1) or (Index>LyricInfoList.Count) then
    begin
    result:=False; exit;
    end;
  ALyricInfo:=LyricInfoList[Index-1];
  LyricInfoResult:=ALyricInfo^;
  result:=True;

end;

function TlyricForm.GetLyricSelf(Index:integer):String;
var
  ALyricInfo:PLyricInfo;
begin
  if (Index<1) or (Index>LyricInfoList.Count) then
  begin
    result:=''; exit;
  end;
  HttpClient.Host:='';
  HttpClient.Port:=0;
  HttpClient.Request.UserAgent:='迷你歌词 3.7.1815 for Winamp5';
  HttpClient.Request.Referer:='http://www.ml-search.com/';
  HttpClient.Request.Accept:='*/*';
  HttpClient.Request.Connection:='close';
  ALyricInfo:=LyricInfoList[Index-1];
  Result:=HttpClient.Get(ALyricInfo^.link);

end;

function TLyricForm.SaveLyricSelf(Index:integer;FileName:string):boolean;
var
  ALyricInfo:PLyricInfo;
  myFileStream:TFileStream;
begin
  if (Index<1) or (Index>LyricInfoList.Count) then
  begin
    result:=false; exit;
  end;
  HttpClient.Host:='';
  HttpClient.Port:=0;
  HttpClient.Request.UserAgent:='迷你歌词 3.7.1815 for Winamp5';
  HttpClient.Request.Referer:='http://www.ml-search.com/';
  HttpClient.Request.Accept:='*/*';
  HttpClient.Request.Connection:='close';
  if FileExists(filename) then
   begin
   if not DeleteFile(filename) then
     begin
     result:=false;
     exit;
     end;
    end;
  myFileStream:=TFileStream.Create(FileName,fmCreate);
  ALyricInfo:=LyricInfoList[Index-1];
  try
    HttpClient.Get(ALyricInfo^.link,myFileStream);
  except
    application.messagebox(#13#10'可能是此歌词文件已经被删除或者网络不通。'#13#10,'下载失败',MB_OK+MB_ICONASTERISK);
  end;
  result:=True;
  myFileStream.Free;
end;

procedure TLyricForm.FormCreate(Sender: TObject);
begin
  SearchCode:='<?xml version="1.0" encoding=''gb2312''?>'+sLineBreak+' <search filetype="lyrics" artist="范晓萱" title="你的甜蜜" ProtoVer="0.9" ClientVer="3.7.1815" ClientName="迷你歌词 for '+sLineBreak+'Winamp5" />';
  HttpClient:=TIdhttp.Create(self);
  HttpClient.HTTPOptions:=[hoKeepOrigProtocol];
  LyricInfoList:=TList.Create;
  
end;

procedure TLyricForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //try
    //HttpClient.Disconnect;
  //  //HttpClient.Free;
 // finally
// end;
 // LyricInfoList.Free;
 // LyricForm.Free;

end;

procedure TLyricForm.Button2Click(Sender: TObject);
var
  indexstr:string;
begin

  indexstr:=combobox1.Items[combobox1.ItemIndex];
  if combobox1.Text='0' then
   exit;
  Memo1.Lines.Text:=GetLyricSelf(strtoint(indexstr));


end;

procedure TLyricForm.Button1Click(Sender: TObject);
var
 ALyricInfo:PLyricInfo;
 i:integer;
begin
  Button1.Caption:='搜索中...';
  Button1.Enabled :=false;
  GetLyricsCount(edit1.Text,edit2.Text);
    //Memo1.Clear;
 // Combobox1.Clear;
 // Combobox1.AddItem('0',nil);
 // for i:=0 to  LyricInfoList.Count-1 do
 // begin
//    ALyricInfo:=LyricInfoList[i];
 //   Memo1.Lines.Add('序号：'+inttostr(i+1)+'     '+'歌曲名称：'+ALyricInfo^.title+'     '+'艺术家：'+ALyricInfo^.artist+'     '+'专集：'+ALyricInfo^.album);
//    Combobox1.AddItem(inttostr(i+1),nil);
//  end;

  ListView1.Clear;
  for i:=0 to  LyricInfoList.Count-1 do
  begin
    ALyricInfo:=LyricInfoList[i];
    with ListView1.Items.Add do
    begin
      Caption:=ALyricInfo^.title;
      SubItems.Add(ALyricInfo^.artist);
      SubItems.Add(ALyricInfo^.album);
    end;

    //Memo1.Lines.Add('序号：'+inttostr(i+1)+'     '+'歌曲名称：'+ALyricInfo^.title+'     '+'艺术家：'+ALyricInfo^.artist+'     '+'专集：'+ALyricInfo^.album);
    //Combobox1.AddItem(inttostr(i+1),nil);
  end;
  if LyricInfoList.Count<>0 then
    ListView1.ItemIndex:=0;
  ListView1.SetFocus;
  Button3.SetFocus;
  Button1.Caption:='重新搜索';
  Button1.Enabled :=True;


end;

procedure TLyricForm.Button3Click(Sender: TObject);

begin
  if label5.Caption='' then exit;
  if LyricInfoList.Count=0 then
  begin
   exit;
  end;
  if (Listview1.Selected.Index<0) or (Listview1.Selected.Index>LyricInfoList.Count) then
  begin
    exit;
  end;
  SaveLyricSelf(Listview1.Selected.Index+1,Label5.Caption);
  ModalResult:=mrOk;

end;

end.

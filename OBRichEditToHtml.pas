{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBRichEditToHtml;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ComCtrls, OBRgbToHtml, OBStrToHtml;

type
  TOBParaAttributes = record
        Alignment:Talignment;
        Numbering:TNumberingstyle;
  end;
  {$EXTERNALSYM TOBParaAttributes}

  TOBRichEditToHtml = class(TComponent)
  private
    FCToH:TOBRgbToHtml;
    FCharToH:TOBStrToHtml;
    FEndSection:string;
    FEndPara:string;
    function AtttoHtml(Value: Tfont): string;
    function ParaToHtml(Value: TOBParaAttributes): string;
  protected
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    procedure ConvertToHtml(Value:TRichEdit;path:string);
    function ConvertToHtmlstringList(Value:TRichEdit):TstringList;
  end;

implementation

resourcestring
   RC_Html1        =     '<HTML>';
   RC_Html3        =     '<BODY>';
   RC_Html4        =     '<BR>';
   RC_Html5        =     '</BODY>';
   RC_Html6        =     '</HTML>';
   RC_Html7        =     '<TITLE>TRichEdit converted with BuyPin Component</TITLE>';

   RC_EndFont      =     '</FONT>';
   RC_Font1        =     '<FONT COLOR=#';
   RC_Font2        =     ' SIZE=';
   RC_Font3        =     ' FACE="';
   RC_Font4        =     '">';

   RC_EndBold      =     '</B>';
   RC_Bold         =     '<B>';

   RC_EndItalic    =     '</I>';
   RC_Italic       =     '<I>';

   RC_EndStrikeOut =     '</STRIKE>';
   RC_StrikeOut    =     '<STRIKE>';

   RC_EndUnderline =     '</U>';
   RC_Underline    =     '<U>';

   RC_EndPar       =     '</P>';
   RC_LeftPara     =     '<P ALIGN="LEFT">';
   RC_RightPara    =     '<P ALIGN="RIGHT">';
   RC_CenterPara   =     '<P ALIGN="CENTER">';

   RC_LeftIndent   =     '<LI>';
   RC_EndLeftIndent=     '</LI>';

procedure TOBRichEditToHtml.ConvertToHtml(Value: TRichEdit; path: string);
begin
   ConvertToHtmlstringList(Value).SaveToFile(path);
end;

function TOBRichEditToHtml.AttToHtml(Value:tfont):string;
begin
   FEndSection:=RC_EndFont;
   FCToH.RgbColor:=Value.Color;
   result:=RC_Font1+FCtoH.HtmlColor+RC_Font2+IntToStr((Value.Size mod 8)+2)+RC_Font3;
   result:=result+Value.Name+RC_Font4;
   if (fsBold in Value.style) then
   begin
      FEndSection:=RC_EndBold+FEndSection;
      result:=result+RC_Bold;
   end;
   if (fsItalic in Value.style) then
   begin
      FEndSection:=RC_EndItalic+FEndSection;
      result:=result+RC_Italic;
   end;
   if (fsStrikeout in Value.style) then
   begin
      FEndSection:=RC_EndStrikeOut+FEndSection;
      result:=result+RC_StrikeOut;
   end;
   if (fsUnderline in Value.style) then
   begin
      FEndSection:=RC_EndUnderline+FEndSection;
      result:=result+RC_Underline;
   end;
end;

function TOBRichEditToHtml.ParaToHtml(Value:TOBParaAttributes):string;
begin
   FEndPara:=RC_EndPar;
   case Value.Alignment of
      taLeftJustify : result:=RC_LeftPara;
      taRightJustify : result:=RC_RightPara;
      taCenter : result:=RC_CenterPara;
   end;
   if Value.Numbering=nsBullet then
   begin
      result:=RC_LeftIndent+result;
      FEndPara:=FEndPara+RC_EndLeftIndent;
   end;
end;

function Diff(One,Two:tfont):boolean;
begin
   result:=(one.Color<>two.Color)or(one.style<>two.style)
        or(one.Name<>two.name)or(one.Size<>two.size);
end;

function DiffPara(One,Two:TOBParaAttributes):boolean;
begin
   result:=(one.Alignment<>two.Alignment)or(one.Numbering<>two.Numbering);
end;

function TOBRichEditToHtml.ConvertToHtmlstringList(
  Value: TRichEdit): TstringList;

var
   i,j,k:Integer;
   datt,att,currat:Tfont;
   dpara,para,currpara:TOBParaAttributes;
   st:string;
   FEnd:string;
begin
   Value.Lines.BeginUpdate;
   result:=TstringList.Create;
   result.add(RC_Html1);
   result.add(RC_Html7);
   result.add(RC_Html3);
   datt:=Tfont.Create;
   att:=Tfont.Create;
   currat:=Tfont.Create;

   dpara.Alignment:=taLeftJustify;
   dpara.Numbering:=nsNone;
   currpara.Alignment:=dpara.Alignment;
   currpara.Numbering:=dpara.Numbering;
   FendPara:='';

   datt.assign(Value.DefAttributes);
   result.add(AttToHtml(datt));
   Fend:=FEndSection;

   k:=0;
   Currat.assign(datt);
   FEndSection:='';
   for i:=0 to Value.lines.Count-1 do
   begin
      st:='';
      currpara.Numbering:=nsNone;
      if length(Value.lines[i])>0 then
      begin
         for j:=1 to length(Value.lines[i]) do
         begin
            Value.SelStart:=k+j-1;
            Value.SelLength:=1;
            att.assign(Value.SelAttributes);
            para.Alignment:=Value.Paragraph.Alignment;
            para.Numbering:=Value.Paragraph.Numbering;
            if Diff(att,currat) then
            begin
               st:=st+FEndSection;
               currat.assign(att);
               st:=st+attToHtml(att);
            end;
            if DiffPara(para,currpara) then
            begin
               st:=st+FEndPara;
               currpara.Alignment:=para.Alignment;
               currpara.Numbering:=para.Numbering;
               st:=st+ParaToHtml(para);
            end;
            st:=st+FCharToH.CharToHtml(Value.lines[i][j]);
         end;
      end;
      k:=k+length(Value.lines[i])+2;
      result.add(RC_Html4+st);
      Application.ProcessMessages;
   end;
   result.add(FendSection);
   result.add(FEndPara);

   datt.free;
   att.free;
   currat.free;

   result.add(FEnd);
   result.add(RC_Html5);
   result.add(RC_Html6);
   Value.Lines.EndUpdate;
end;

constructor TOBRichEditToHtml.Create(AOwner: TComponent);
begin
   inherited;
   FCToH:=TOBRgbToHtml.Create(self);
   FCharToH:=TOBStrToHtml.Create(self);
end;

destructor TOBRichEditToHtml.Destroy;
begin
   FCToH.free;
   FCharToH.free;
   inherited;
end;

end.


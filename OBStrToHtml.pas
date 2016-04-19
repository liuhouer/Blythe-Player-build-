{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBStrToHtml;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls;

type
  TOBHtmlCodeRec = record
    Ch : char;
    Html : string;
  end;
  {$EXTERNALSYM TOBHtmlCodeRec}

  TOBStrToHtml = class(TComponent)
  private
    FHtml: string;
    FValue: string;
    procedure SetHtml(const Value: string);
    procedure SetValue(const Value: string);
  protected
  public
    constructor Create(AOwner: TComponent);override;
  published
    property Text:string read FValue write SetValue;
    property Html:string read FHtml write SetHtml;
    function CharToHtml(ch:char):string;
    function TextToHtml(Text: string):string;
    function HtmlToText(Text: string):string;
  end;

function StringToHtml(Value: string): string;
function HtmlToString(Value: string): string;

implementation

const
  NbConversions = 79;
  Conversions : array [0..NbConversions-1] of TOBHtmlCodeRec = (
             (Ch:'"';Html:'&quot;'),
             (Ch:'à';Html:'&agrave;'),
             (Ch:'ç';Html:'&ccedil;'),
             (Ch:'é';Html:'&eacute;'),
             (Ch:'è';Html:'&egrave;'),
             (Ch:'ê';Html:'&ecirc;'),
             (Ch:'ù';Html:'&ugrave;'),
             (Ch:'ë';Html:'&euml;'),
             (Ch:'<';Html:'&lt;'),
             (Ch:'>';Html:'&gt;'),
             (Ch:'^';Html:'&#136;'),
             (Ch:'~';Html:'&#152;'),
             (Ch:'£';Html:'&#163;'),
             (Ch:'§';Html:'&#167;'),
             (Ch:'°';Html:'&#176;'),
             (Ch:'²';Html:'&#178;'),
             (Ch:'³';Html:'&#179;'),
             (Ch:'µ';Html:'&#181;'),
             (Ch:'·';Html:'&#183;'),
             (Ch:'¼';Html:'&#188;'),
             (Ch:'½';Html:'&#189;'),
             (Ch:'¿';Html:'&#191;'),
             (Ch:'À';Html:'&#192;'),
             (Ch:'Á';Html:'&#193;'),
             (Ch:'Â';Html:'&#194;'),
             (Ch:'Ã';Html:'&#195;'),
             (Ch:'Ä';Html:'&#196;'),
             (Ch:'Å';Html:'&#197;'),
             (Ch:'Æ';Html:'&#198;'),
             (Ch:'Ç';Html:'&#199;'),
             (Ch:'È';Html:'&#200;'),
             (Ch:'É';Html:'&#201;'),
             (Ch:'Ê';Html:'&#202;'),
             (Ch:'Ë';Html:'&#203;'),
             (Ch:'Ì';Html:'&#204;'),
             (Ch:'Í';Html:'&#205;'),
             (Ch:'Î';Html:'&#206;'),
             (Ch:'Ï';Html:'&#207;'),
             (Ch:'Ñ';Html:'&#209;'),
             (Ch:'Ò';Html:'&#210;'),
             (Ch:'Ó';Html:'&#211;'),
             (Ch:'Ô';Html:'&#212;'),
             (Ch:'Õ';Html:'&#213;'),
             (Ch:'Ö';Html:'&#214;'),
             (Ch:'Ù';Html:'&#217;'),
             (Ch:'Ú';Html:'&#218;'),
             (Ch:'Û';Html:'&#219;'),
             (Ch:'Ü';Html:'&#220;'),
             (Ch:'Ý';Html:'&#221;'),
             (Ch:'ß';Html:'&#223;'),
             (Ch:'à';Html:'&#224;'),
             (Ch:'á';Html:'&#225;'),
             (Ch:'â';Html:'&#226;'),
             (Ch:'ã';Html:'&#227;'),
             (Ch:'ä';Html:'&#228;'),
             (Ch:'å';Html:'&#229;'),
             (Ch:'æ';Html:'&#230;'),
             (Ch:'ç';Html:'&#231;'),
             (Ch:'è';Html:'&#232;'),
             (Ch:'é';Html:'&#233;'),
             (Ch:'ê';Html:'&#234;'),
             (Ch:'ë';Html:'&#235;'),
             (Ch:'ì';Html:'&#236;'),
             (Ch:'í';Html:'&#237;'),
             (Ch:'î';Html:'&#238;'),
             (Ch:'ï';Html:'&#239;'),
             (Ch:'ñ';Html:'&#241;'),
             (Ch:'ò';Html:'&#242;'),
             (Ch:'ó';Html:'&#243;'),
             (Ch:'ô';Html:'&#244;'),
             (Ch:'õ';Html:'&#245;'),
             (Ch:'ö';Html:'&#246;'),
             (Ch:'÷';Html:'&#247;'),
             (Ch:'ù';Html:'&#249;'),
             (Ch:'ú';Html:'&#250;'),
             (Ch:'û';Html:'&#251;'),
             (Ch:'ü';Html:'&#252;'),
             (Ch:'ý';Html:'&#253;'),
             (Ch:'ÿ';Html:'&#255;')
             );

function TOBStrToHtml.CharToHtml(ch: char): string;
var
 i:Integer;
begin
  i:=0;
  while (i<NbConversions) and (Conversions[i].Ch<>ch) do
    inc(i);
  if i<NbConversions then
    result:=Conversions[i].Html
  else
    result:=ch;
end;

constructor TOBStrToHtml.Create(AOwner: TComponent);
begin
  inherited;
  FValue:='';
  FHtml:='';
end;

function TOBStrToHtml.HtmlToText(Text: string): string;
var
 i:Integer;
begin
  result:='';
  for i:=1 to Length(Text) do
    result:=result+CharToHtml(Text[i]);
end;

procedure TOBStrToHtml.SetHtml(const Value: string);
begin
  FValue:=HtmlToText(Value);
end;

procedure TOBStrToHtml.SetValue(const Value: string);
begin
  FHtml:=TextToHtml(Value);
end;

function TOBStrToHtml.TextToHtml(Text: string): string;
var
 i:Integer;
begin
  result:=Text;
  for i:=0 to NbConversions-1 do
    result:=StringReplace(result,Conversions[i].Html,Conversions[i].Ch,
                          [rfReplaceAll,rfIgnoreCase]);
end;

function StringToHtml(Value: string): string;
begin
  with TOBStrToHtml.Create(nil) do
  begin
    result := TextToHtml(Value);
    Free;
  end;
end;

function HtmlToString(Value: string): string;
begin
  with TOBStrToHtml.Create(nil) do
  begin
    result := HtmlToText(Value);
    Free;
  end;
end;

end.


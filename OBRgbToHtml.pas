{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBRgbToHtml;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls;

type
  TOBRgbToHtml = class(TComponent)
  private
    FHtml: string;
    FColor: TColor;
    procedure SeTColor(const Value: TColor);
    procedure SetHtml(const Value: string);
  protected
  public
    constructor Create(AOwner: TComponent);override;
  published
    property RgbColor:TColor read FColor write SeTColor default clBlack;
    property HtmlColor:string read FHtml write SetHtml;
  end;

  function RgbToHtml(Value: TColor):string;

implementation

function RgbToHtml(Value: TColor):string;
begin
  with TOBRgbToHtml.Create(nil) do
  begin
    RgbColor:=Value;
    result:=HtmlColor;
    Free;
  end;
end;

constructor TOBRgbToHtml.Create(AOwner: TComponent);
begin
  inherited;
  FColor := clBlack;
  FHtml := '000000';
end;

procedure TOBRgbToHtml.SeTColor(const Value: TColor);
var
 Clr:TColor;
begin
  FColor := Value;  Clr := Value;
  if (Clr<0) then Clr:=GetSysColor(Clr and not( $80000000));
  FHtml:=IntToHex(GetRValue(Clr),2)+IntToHex(GetGValue(Clr),2)+IntToHex(GetBValue(Clr),2);
end;

procedure TOBRgbToHtml.SetHtml(const Value: string);
var
 c:TColor;
 r,g,b:byte;
begin
  try
   if length(Value)=6 then
   begin
     r:=StrToInt('$'+Copy(Value,1,2));
     g:=StrToInt('$'+Copy(Value,3,2));
     b:=StrToInt('$'+Copy(Value,5,2));
     c:=Rgb(r,g,b);
     Fcolor:=c;

     FHtml:=Value;
   end;
  except
  end;
end;

end.


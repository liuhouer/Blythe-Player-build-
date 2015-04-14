{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBAssociateExtension;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Registry;

type
  TOBAssociateExtension = class(TComponent)
  private
    FAbout: String;
  protected
    procedure RebuildIconCache;
  public
  published
    procedure Associate(IconPath,ProgramName,Path,Extension:string);
    property About : String read FAbout write FAbout;
  end;

implementation

resourcestring
   RC_DefaultIcon       =   'DefaultIcon';

{*****************************************************}
procedure TOBAssociateExtension.Associate(IconPath,ProgramName,Path,Extension:string);
begin
   with TRegistry.Create do
   begin
      rootkey:=HKEY_CLASSES_ROOT;
      OpenKey(ProgramName,true);
      WriteString('',ProgramName);
      if IconPath<>'' then
      begin
           OpenKey(RC_DefaultIcon,true);
           WriteString('',IconPath);
      end;
      CloseKey;
      OpenKey(ProgramName,true);
      OpenKey('shell',true);
      OpenKey('open',true);
      OpenKey('command',true);
      WriteString('','"'+Path+'" "%1"');
      free;
   end;
   with TRegistry.Create do
   begin
      rootkey:=HKEY_CLASSES_ROOT;
      OpenKey('.'+extension,true);
      WriteString('',ProgramName);
      free;
   end;
   RebuildIconCache;
end;

procedure TOBAssociateExtension.RebuildIconCache;
var
  bidon:Dword;
begin
   SendMessageTimeout(HWND_BROADCAST,WM_SETTINGCHANGE,SPI_SETNONCLIENTMETRICS,longint(pchar('WindowMetrics')),
     SMTO_NORMAL or SMTO_ABORTIFHUNG,10000,bidon);
end;

end.

{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBCdUtils;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, MMSystem, Forms;

type
  TOBCdUtils = class(TComponent)
  private
    FAbout: String;
  protected
  public
  published
    procedure OpenCdDrive;
    procedure CloseCdDrive;
    property About : String read FAbout write FAbout;
  end;

implementation

resourcestring
  RC_OpenCDDrive             =   'Set cdaudio door open wait';
  RC_CloseCDDrive            =   'Set cdaudio door closed wait';

procedure TOBCdUtils.OpenCdDrive;
begin
   mciSendstring(PChar(RC_OpenCDDrive), nil, 0, Application.handle);
end;

procedure TOBCdUtils.CloseCdDrive;
begin
   mciSendstring(PChar(RC_CloseCDDrive), nil, 0, Application.handle);
end;

end.

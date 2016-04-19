{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBInstances;

{$ObjExportAll On}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms;

type
  TOBInstances = class(TComponent)
  private
    ffake,ffirst:boolean;
    hmutex:Thandle;
  protected
  public
    constructor Create(AOwner: TComponent);override;
  published
    property FirstInstance:boolean read FFirst write FFake;
  end;

implementation

constructor TOBInstances.Create(AOwner: TComponent);
begin
   inherited;
   hMutex:=CreateMutex(nil,false,pchar(Application.title));
   ffirst:=(hmutex<>0) and (getlasterror<>error_already_exists);
   ReleaseMutex(hMutex);
end;

end.

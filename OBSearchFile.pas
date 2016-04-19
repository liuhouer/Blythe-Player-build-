{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARN UNIT_PLATFORM OFF}

unit OBSearchFile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  FileCtrl;

type
  TOnFound = procedure (Sender: TObject;Path:string) of object;
  TOnChangedDir = procedure (Sender: TObject;Directory:string) of object;
  TOBSearchFile = class(TComponent)
  private
    FRecursive: boolean;
    FMask: string;
    FOnFound: TOnFound;
    FOnChangedDir: TOnChangedDir;
    FOnStart: TNotifyEvent;
    FonEnd: TNotifyEvent;
    FAbout: String;
    procedure Search(StartPath: string);
  protected
  public
    constructor Create(AOwner: TComponent);override;
  published
    property About : String read FAbout write FAbout;
    procedure Execute(StartPath:string);

    property Mask:string read FMask write FMask;
    property Recursive:boolean read FRecursive write FRecursive default true;

    property OnFound:TOnFound read FOnFound write FOnFound;
    property OnChangedDir:TonChangedDir read FOnChangedDir write FOnChangedDir;
    property OnStart:TNotifyEvent read FOnStart write FOnStart;
    property OnEnded:TNotifyEvent read Fonend write FOnEnd;
  end;

implementation

constructor TOBSearchFile.Create(AOwner: TComponent);
begin
  inherited;
  FRecursive:=true;
  FMask:='*.exe';
end;

procedure TOBSearchFile.Search(StartPath:string);
var
   t:TSearchRec;
   res:Integer;
begin
  if Assigned(FOnFound) then
  begin
    if Assigned(FOnChangedDir) then
       FOnChangedDir(self,StartPath);

    res:=FindFirst(StartPath+FMask,faAnyFile,t);
    while res=0 do
    begin
      if (t.name<>'.') and (t.name<>'..') then
         FOnFound(self,StartPath+t.name);
      res:=FindNext(t);
    end;
    FindClose(t);

    if FRecursive then
    begin
      res:=FindFirst(startpath+'*.*',faAnyFile,t);
      while res=0 do
      begin
        if (t.name<>'.')and(t.name<>'..')then
          if (DirectoryExists(StartPath+t.name+'\')) then
            Search(StartPath+t.name+'\');
        res:=FindNext(t);
      end;
      FindClose(t);
    end;
  end;
end;

procedure TOBSearchFile.Execute(StartPath:string);
begin
  if Assigned(FOnStart) then
    FOnStart(self);
  if StartPath='' then
    Exit; 
  if StartPath[length(StartPath)]<>'\' then
    StartPath:=StartPath+'\';
  Search(StartPath);
  if Assigned(FOnEnd) then
    FOnEnd(self);
end;

end.

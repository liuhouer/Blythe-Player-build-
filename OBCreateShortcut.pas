{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARN UNIT_PLATFORM OFF}	

unit OBCreateShortcut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, 
  ShlObj, ActiveX, ComObj, Registry, FileCtrl;

type
  TOBCreateShortcut = class(TComponent)
  private
    FAbout: String;
  protected
  public
  published
    function CreateStartMenuShortcut(GroupName:string;FileName:string;Parameters:string;linkname:string):string;
    function CreateDesktopShortcut(FileName:string;Parameters:string;linkname:string):string;
    function CreateShortcut(FileName:string;Parameters:string;linkname:string;Directory:string):string;
    property About : String  read FAbout write FAbout;
  end;

implementation

resourcestring
   RC_ExplorerKey = 'Software\MicroSoft\Windows\CurrentVersion\Explorer';

function TOBCreateShortcut.CreateStartMenuShortcut(GroupName:string;
      FileName:string;Parameters:string;linkname:string):string;
var
   MyObject  : IUnknown;
   MySLink   : IShellLink;
   MyPFile   : IPersistFile;
   Directory : string;
   WFileName : Widestring;
   MyReg     : TRegIniFile;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  with MySLink do
  begin
     SetArguments(pchar(parameters));
     SetPath(PChar(FileName));
     SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
  end;
  MyReg := TRegIniFile.Create(RC_ExplorerKey);
  if GroupName='' then Directory := MyReg.ReadString('Shell Folders','Programs','')
  else Directory := MyReg.ReadString('Shell Folders','Programs','')+'\'+GroupName;
  ForceDirectories(Directory);
  WFileName:=Directory+'\'+linkname+'.lnk';
  MyPFile.Save(PWChar(WFileName),False);
  MyReg.Free;
  result := WFileName;
end;

function TOBCreateShortcut.CreateDesktopShortcut(FileName:string;
  Parameters:string; linkname:string):string;
var
   MyObject  : IUnknown;
   MySLink   : IShellLink;
   MyPFile   : IPersistFile;
   Directory : string;
   WFileName : Widestring;
   MyReg     : TRegIniFile;
begin
   MyObject := CreateComObject(CLSID_ShellLink);
   MySLink := MyObject as IShellLink;
   MyPFile := MyObject as IPersistFile;
   with MySLink do
   begin
      SetArguments(pchar(parameters));
      SetPath(PChar(FileName));
      SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
   end;
   MyReg := TRegIniFile.Create(RC_ExplorerKey);
   Directory := MyReg.ReadString('Shell Folders','Desktop','');
   WFileName:=Directory+'\'+linkname+'.lnk';
   MyPFile.Save(PWChar(WFileName),False);
   result := WFileName;
   MyReg.Free;
end;

function TOBCreateShortcut.CreateShortcut(FileName:string;Parameters:string;
  linkname:string;Directory:string):string;
var
   MyObject  : IUnknown;
   MySLink   : IShellLink;
   MyPFile   : IPersistFile;
   WFileName : Widestring;
begin
  if (directory<>'') and (Directory[length(directory)]<>'\') then Directory:=Directory+'\';
  ForceDirectories(Directory);
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  with MySLink do
  begin
     SetArguments(pchar(parameters));
     SetPath(PChar(FileName));
     SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
  end;
  WFileName:=Directory+linkname+'.lnk';
  result := WFileName;
  MyPFile.Save(PWChar(WFileName),False);
end;

end.

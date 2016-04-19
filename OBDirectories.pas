{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBDirectories;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Registry;

type
  TOBDirectories = class(TComponent)
  private
    FBidon : string;
    buf : array [0..250] of char;
    FAbout: String;
    function GetCurrent:string;
    function GetWd:string;
    function GetSyste:string;
    function GetTem:string;
    function GetValueAtIndex(Index: integer):string;
    function GetProgramFiles: string;
  protected
    function CheckLastChar(Value: string):string;
  public
  published
    property CurrentDirectory:string read GetCurrent write FBidon stored false;
    property WindowsDirectory:string read GetWd write FBidon stored false;
    property SystemDirectory :string read GetSyste write FBidon stored false;
    property TempPath :string read GetTem write Fbidon stored false;
    property ApplicationData:string index 0 read GetValueAtIndex write FBidon stored false;
    property Cache:string index 1 read GetValueAtIndex write FBidon stored false;
    property Cookies:string index 2 read GetValueAtIndex write FBidon stored false;
    property Desktop:string index 3 read GetValueAtIndex write FBidon stored false;
    property Favorites:string index 4 read GetValueAtIndex write FBidon stored false;
    property Fonts:string index 5 read GetValueAtIndex write FBidon stored false;
    property History:string index 6 read GetValueAtIndex write FBidon stored false;
    property NetHood:string index 7 read GetValueAtIndex write FBidon stored false;
    property Personal:string index 8 read GetValueAtIndex write FBidon stored false;
    property Programs:string index 9 read GetValueAtIndex write FBidon stored false;
    property ProgramFiles:string read GetProgramFiles write FBidon stored false;
    property Recent:string index 10 read GetValueAtIndex write FBidon stored false;
    property SendTo:string index 11 read GetValueAtIndex write FBidon stored false;
    property StartMenu:string index 12 read GetValueAtIndex write FBidon stored false;
    property Startup:string index 13 read GetValueAtIndex write FBidon stored false;
    property Templates:string index 14 read GetValueAtIndex write FBidon stored false;
    property About : String read FAbout write FAbout;
  end;

implementation

resourcestring
   RC_ShellFolders = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\';

var
 DirectoryList : array [0..14] of string = ('AppData','Cache','Cookies','Desktop',
                 'Favorites','Fonts','History','NetHood','Personal','Programs','Recent',
                 'SendTo','Start Menu','Statup','Templates');

function TOBDirectories.GetCurrent:string;
begin
  GetCurrentDirectory(250,buf);
  result:=CheckLastChar(buf);
end;

function TOBDirectories.GetWd:string;
begin
  GetWindowsDirectory(buf,250);
  result:=CheckLastChar(buf);
end;

function TOBDirectories.GetSyste:string;
begin
  GetSystemDirectory(buf,250);
  result:=CheckLastChar(buf);
end;

function TOBDirectories.GetTem:string;
begin
  GetTempPath(250,buf);
  result:=CheckLastChar(buf);
end;

function TOBDirectories.GetValueAtIndex(Index: integer): string;
begin
  try
    with TRegistry.Create do
    begin
      OpenKey(RC_ShellFolders,false);
      result:=CheckLastChar(ReadString(DirectoryList[Index]));
      Free;
    end;
  except
    result:='';
  end;
end;

function TOBDirectories.CheckLastChar(Value: string): string;
begin
  //Check if the last char is a \, and add one if necessary
  if (length(Value)>0) and (Value[length(Value)]<>'\') then
     Value:=Value+'\';
  result:=Value;
end;

function TOBDirectories.GetProgramFiles: string;
begin
  try
    with TRegistry.Create do
    begin
      RootKey:=HKEY_Local_Machine;
      OpenKey('Software\Microsoft\Windows\CurrentVersion\',false);
      result:=CheckLastChar(ReadString('ProgramFilesDir'));
      Free;
    end;
  except
    result:='';
  end;
end;

end.

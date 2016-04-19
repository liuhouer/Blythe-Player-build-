unit Winamp;

interface

uses windows, Messages, shellapi, sysutils;

type
  PwinampVisModule = ^TwinampVisModule;
  TwinampVisModule = record
    description: PChar;
    hwndParent: HWND;
    hDllInstance: HINST;
    sRate, nCh,
      latencyMs,
      delayMs,
      spectrumNch,
      waveformNch: Integer;
    spectrumData: array[0..1, 0..575] of char;
    waveformData: array[0..1, 0..575] of char;
    Config: procedure(this_mod: PwinampVisModule); cdecl;
    Init: function(this_mod: PwinampVisModule): Integer; cdecl;
    Render: function(this_mod: PwinampVisModule): Integer; cdecl;
    Quit: procedure(this_mod: PwinampVisModule); cdecl;
    userData: Pointer;
  end;

  PwinampVisHeader = ^TwinampVisHeader;
  TwinampVisHeader = record
    version: Integer;
    description: PChar;
    getModule: function(i: Integer): PwinampVisModule; cdecl;
  end;
  winampVisGetHeaderType = function: PwinampVisHeader;

  // Pointer to WinampGeneralPurposePlugin
  // the record, as declared in Winamp (see tutorial or STNDGenPlug for more details)
  PWinampGeneralPurposePlugin = ^WinampGeneralPurposePlugin;
  winampGeneralPurposePlugin = record
    version: Integer;
    description: PChar;
    init: function: Integer; cdecl;
    config: procedure; cdecl;
    quit: procedure; cdecl;
    hwndParent: HWND;
    hDLLInstance: HINST;
  end;

const
  ver = $101;
  GPPHDR_VER = $10;

  winamp_command_OPTIONS_EQ = 40036; // toggles the EQ window
  winamp_command_OPTIONS_PLEDIT = 40040; // toggles the playlist window
  winamp_command_VOLUMEUP = 40058; // turns the volume up a little
  winamp_command_VOLUMEDOWN = 40059; // turns the volume down a little
  winamp_command_FFWD5S = 40060; // fast forwards 5 seconds
  winamp_command_REW5S = 40061; // rewinds 5 seconds

  // the following are the five main control buttons, with optionally shift
  // or control pressed
  // (for the exact functions of each, just try it out)
  winamp_command_BUTTON1 = 40044;
  winamp_command_BUTTON2 = 40045;
  winamp_command_BUTTON3 = 40046;
  winamp_command_BUTTON4 = 40047;
  winamp_command_BUTTON5 = 40048;
  winamp_command_BUTTON1_SHIFT = 40145;
  winamp_command_BUTTON3_SHIFT = 40146;
  winamp_command_BUTTON4_SHIFT = 40147;
  winamp_command_BUTTON5_SHIFT = 40148;
  winamp_command_BUTTON1_CTRL = 40154;
  winamp_command_BUTTON2_CTRL = 40155;
  winamp_command_BUTTON3_CTRL = 40156;
  winamp_command_BUTTON4_CTRL = 40157;
  winamp_command_BUTTON5_CTRL = 40158;

  winamp_command_FILE_PLAY = 40029; // pops up the load file(s) box
  winamp_command_OPTIONS_PREFS = 40012; // pops up the preferences
  winamp_command_OPTIONS_AOT = 40019; // toggles always on top
  winamp_command_HELP_ABOUT = 40041; // pops up the about box :)

  winamp_message_CHDIR = 103;
  winamp_message_PLAYFILE = 100;
  winamp_message_SETEQDATA = 128;
  winamp_message_GETEQDATA = 127;
  winamp_message_GETINFO = 126;
  winamp_message_GETLISTPOS = 125;
  winamp_message_GETPLAYLISTTITLE = 212;
  winamp_message_GETPLAYLISTFILE = 211;
  winamp_message_EXECPLUG = 202;
  winamp_message_GETSKIN = 201;
  winamp_message_SETSKIN = 200;
  winamp_message_GETLISTLENGTH = 124;
  winamp_message_SETPANNING = 123;
  winamp_message_SETVOLUME = 122;
  winamp_message_SETPLAYLISTPOS = 121;
  winamp_message_WRITEPLAYLIST = 120;
  winamp_message_JUMPTOTIME = 106;
  winamp_message_GETOUTPUTTIME = 105;
  winamp_message_ISPLAYING = 104;
  winamp_message_GETVERSION = 0;
  winamp_message_DELETE = 101;
  winamp_message_STARTPLAY = 102;

function WinampMessage(todo: word; var data: integer): integer;
function WinampMessage_ex(wnd: HWnd; todo: word; var data: integer): integer;
procedure WinampCommand(todo: word);
function GetWinampHandle: integer;

// for your plugin you will mostly need these three functions
procedure WinampCommand_ex(wnd: HWnd; todo: word);
function GetAmpInt(AmpHandle: HWND; Command, Data: Integer): Integer;
function GetAmpSTr(AmpHandle: HWND; Command, Data: Integer): string;

implementation

function getwinamphandle: integer;
begin
  result := findWindow('Winamp v1.x', nil);
end;

function winampmessage(todo: word; var data: integer): integer;
begin
  result := SendMessage(getwinamphandle, wm_user, data, todo);
end;

function winampmessage_ex(wnd: HWnd; todo: word; var data: integer): integer;
begin
  result := SendMessage(wnd, wm_user, data, todo);
end;

procedure winampcommand(todo: word);
begin
  SendMessage(getwinamphandle, wm_command, todo, 0);
end;

procedure winampcommand_ex(wnd: HWnd; todo: word);
begin
  SendMessage(wnd, wm_command, todo, 0);
end;

// Send a message to Winamp and return an Integer

function GetAmpInt(AmpHandle: HWND; Command, Data: Integer): Integer;
begin
  // Handle = Plugin.HWNDParent
  Result := SendMessage(AmpHandle, wm_user, Data, Command);
end;

// Send a message to Winamp and return a String

function GetAmpSTr(AmpHandle: HWND; Command, Data: Integer): string;
var
  ch: PChar;
begin
  Ch := Pointer(SendMessage(Amphandle, wm_user, Data, Command));
  Result := strPas(ch);
end;

end.


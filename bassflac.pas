{
  BASSFLAC 2.3 Delphi API, copyright (c) 2004-2006 Ian Luck.
  Requires BASS 2.3 - available from www.un4seen.com

  See the BASSFLAC.CHM file for more complete documentation
}

unit BassFLAC;

interface

uses Windows, Bass;

const
  // BASS_CHANNELINFO type
  BASS_CTYPE_STREAM_FLAC        = $10900;
  BASS_CTYPE_STREAM_FLAC_OGG    = $10901;


const
  bassflacdll = 'bassflac.dll';

function BASS_FLAC_StreamCreateFile(mem:BOOL; f:Pointer; offset,length,flags:DWORD): HSTREAM; stdcall; external bassflacdll;
function BASS_FLAC_StreamCreateURL(URL:PChar; offset:DWORD; flags:DWORD; proc:DOWNLOADPROC; user:DWORD): HSTREAM; stdcall; external bassflacdll;
function BASS_FLAC_StreamCreateFileUser(buffered:BOOL; flags:DWORD; proc:STREAMFILEPROC; user:DWORD): HSTREAM; stdcall; external bassflacdll;

implementation

end.

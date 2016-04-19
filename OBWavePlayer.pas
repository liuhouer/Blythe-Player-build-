{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBWavePlayer;

{$ObjExportAll On}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, //JvTypes,
  MMSystem;

type
  TJvWLocation = (frFile, frResource, frRAM);
  
  TOBWavePlayer = class(TComponent)
  private
    FAsync,FLoop  : Boolean;
    FWaveName     : TFileName;
    FWavePointer  : pointer;
    FWaveLocation : TJvWLocation;
    FBeforePlay,FAfterPlay    : TNotifyEvent;
    FAbout: String;
    procedure SetAsync(Value: boolean);
    procedure SetLoop(Value: boolean);
  protected
  public
    property WavePointer: pointer read fWavePointer write fWavePointer;
    destructor Destroy;override;
  published
    property About : String read FAbout write FAbout;
    property Asynchronous: boolean read FAsync write SetAsync;
    property Loop: boolean read FLoop write SetLoop;
    property SourceType: TJvWLocation read FWaveLocation write FWaveLocation default frFile;
    property FileName: TFileName read FWaveName write FWaveName;
    property BeforePlaying: TNotifyEvent read FBeforePlay write FBeforePlay;
    property AfterPlaying: TNotifyEvent read FAfterPlay write FAfterPlay;
    function Play: boolean;
    procedure Stop;
  end;

implementation

procedure TOBWavePlayer.SetAsync(Value: boolean);
begin
   FAsync:=Value;
   if not FAsync then
     FLoop:=false;
end;

procedure TOBWavePlayer.SetLoop(Value: boolean);
begin
   if (FLoop<>Value) and FAsync then
     FLoop:=Value;
end;

function TOBWavePlayer.Play;
var
   Flags:DWORD;
begin
   if Assigned(FBeforePlay) then
     FBeforePlay(Self);
   case FWaveLocation of
      frFile     : Flags := SND_FileName;
      frResource : Flags := SND_RESOURCE;
      else         Flags := SND_MEMORY;
   end;
   if FLoop then
     Flags := Flags or SND_LOOP;
   if FAsync then
     Flags := Flags or SND_ASYNC
   else
     Flags := Flags or SND_SYNC;
   if FWaveLocation = frRAM then
     Result := PlaySound(FWavePointer, 0, Flags)
   else
     Result := PlaySound(PChar(FWaveName), 0, Flags);
   if Assigned(FAfterPlay) then
   FAfterPlay(Self);
end;

procedure TOBWavePlayer.Stop;
var
   Flags : DWORD;
begin
   case FWaveLocation of
     frFile     : Flags:=SND_FileName;
     frResource : Flags:=SND_RESOURCE;
     else         Flags:=SND_MEMORY;
   end;
   PlaySound(nil, 0, Flags);
end;

destructor TOBWavePlayer.Destroy;
begin
  Stop;
  inherited;
end;

end.

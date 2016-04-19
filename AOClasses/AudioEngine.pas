unit AudioEngine;
{ TAudioEngine by Alessandro Cappellozza
  version 0.8 02/2002
  http://digilander.iol.it/Kappe/audioobject
}

interface

uses Windows, Bass, Dialogs, Forms, Controls, StdCtrls,
     Classes, ExtCtrls, SysUtils, CommonTypes;

  Type TAudioEngine = Class(TObject)
    private
      Channel  : DWORD;
      WaveFreq : Integer;

      PlayerState : Integer;
      SongLength  : Integer;
      DeviceIDX   : Integer;

      AppHWND  : THandle;
      EqParam  : array [0..9] of HFX;
      EQBands  : array [0..9] of Integer;
      NullWave : TWaveData;
      NullFFT  : TFFTData;
      CurPreset : TEqPreset;

      UseEQ   : Boolean;
      DevList : TStringList;
      CurFileName : String;
      EventTimer  : TTimer;
      URLSaveFile : String;
      HalfBit : Boolean;
      MonoAudio : Boolean;

      procedure NotifyState (Sender : TObject);
      procedure CreateEqualyzer;
    public

     constructor Create (HWND : THandle); virtual;
     destructor Destroy;

     procedure Play (FileName : String);
     function PlayURL (FileName : String) : Boolean;
     procedure Pause;
     procedure UnPause;
     procedure Stop;

     procedure InitDevice(idx : Integer);
     procedure UpdateEq (aEqPreset : TEqPreset);
     function CheckPlayableFile (FileName : String) : Boolean;

     function GetSongPos : Integer;
     function GetSongLen : Integer;
     function GetCurSong : String;
     function GetMainVolume : Integer;
     function GetGainVolume : Integer;
     function GetPanning : Integer;
     function GetPitch : Integer;
     function GetWaveBuffer : TWaveData;
     function GetDialogFilter : String; virtual;
     function GetFFTData : TFFTData;
     function GetSongTitle (FileName : String): String;
     function GetSongLength (FileName : String): Integer;
     function GetSaveUrlFile : String;
     procedure GetICYMetaBroadcast (ServerURL : String; var Name, Genere, WebURL, Bitrate, Title, TitleURL, Comment : String);
     procedure GetVULevel(var R, L : Integer);
     function GetBitrate : Integer;
     function IsOnLine : Boolean;

     procedure SetSongPos (SongPos : Integer);
     procedure SetMainVolume (Vol : Integer);
     procedure SetGainVolume (Vol : Integer);
     procedure SetPanning (Pan : Integer);
     procedure SetPitch (Ptc : Integer);
     procedure SetOutBufferLen  (Len : Integer);
     procedure SetSaveUrlFile (FileName : String);

     property OutFrequency : Integer read WaveFreq write WaveFreq;
     procedure SetEqualizer;
     procedure ResetEqualizer;
     property AudioDevices : TStringList read DevList;
     property EngineState : Integer read PlayerState;
     property HalfBitrate : Boolean read HalfBit write HalfBit;
     property Mono : Boolean read MonoAudio write MonoAudio;
  end;


implementation

 procedure TAudioEngine.NotifyState (Sender : TObject);
   var NetFile : Boolean;
  begin
  if (Pos('HTTP://', UpperCase(GetCurSong)) > 0) or (Pos('FTP://', UpperCase(GetCurSong)) > 0) then NetFile := True else NetFile := False;
     if ((GetSongPos >= GetSongLen - 50) and not (PlayerState = ENGINE_STOP)) and Not NetFile then
     begin
       Stop;
       PlayerState := ENGINE_SONG_END;
     end;
  end;

 constructor TAudioEngine.Create (HWND : THandle);
   var i : integer; DevChar : PChar;
  begin
   WaveFreq := 44100;
   AppHWND := HWND;
   DeviceIDX := -1;
   EQBands[0] := 80;
   EQBands[1] := 170;
   EQBands[2] := 310;
   EQBands[3] := 600;
   EQBands[4] := 1000;
   EQBands[5] := 3000;
   EQBands[6] := 6000;
   EQBands[7] := 10000;
   EQBands[8] := 12000;
   EQBands[9] := 14000;
   for i := 0 to 9 do
     EqParam[i] := 0;

    { Calculating Null Arrays}
      for i := 0 to 255 do NullWave[i] := 0;
      for i := 0 to 255 do NullFFT[i] := 0;

   UseEQ := False;
   PlayerState := ENGINE_STOP;
   InitDevice(DeviceIDX);
   DevList := TStringList.Create;
    i := 0;
     while (BASS_GetDeviceDescription(i) <> nil ) do
      begin
        DevChar := BASS_GetDeviceDescription(i);
        inc(i);
        DevList.Add(DevChar);
      end;
   SetOutBufferLen(500);
   EventTimer := TTimer.Create (nil);
   EventTimer.Interval := 1;
   EventTimer.OnTimer := NotifyState;
   EventTimer.Enabled := True;
  end;

 procedure TAudioEngine.InitDevice(idx : Integer);
  begin
     Stop;
     BASS_Stop();
     BASS_Free();
     BASS_Init(idx,WaveFreq, BASS_DEVICE_NOSYNC and BASS_DEVICE_LEAVEVOL, AppHWND);
     BASS_Start();
  end;

 procedure TAudioEngine.SetEqualizer;
  begin
    UpdateEq(CurPreset);
  end;

 procedure TAudioEngine.ResetEqualizer;
   var aEqPreset : TEqPreset; i: Integer;
  begin
      for i := 0 to 9 do
        aEqPreset[i] := 0;
     UpdateEq (aEqPreset);
 end;

 procedure TAudioEngine.UpdateEq (aEqPreset : TEqPreset);
   var EqP : BASS_FXPARAMEQ; i :Integer;
  begin
   CurPreset := aEqPreset;
   for i := 0 to 9 do
   begin
     BASS_FXGetParameters(EqParam[i],@EqP);
      EqP.fGain:= aEqPreset[i];
     BASS_FXSetParameters(EqParam[i],@EqP);
   end;
  end;

 procedure TAudioEngine.Play (FileName : String);
   var SngLen : Integer; Flags : DWORD;
  begin
   CurFileName := FileName;
   if (Copy(UpperCase(FileName), 1, 7) = 'HTTP://') or (Copy(UpperCase(FileName), 1, 6) = 'FTP://') then
     begin
      PlayURL(FileName);
      exit;
     end;

   BASS_MusicFree(Channel);
   BASS_StreamFree(Channel);

   Flags := 0;
   SngLen := 0;
   if HalfBit then Flags := BASS_MP3_HALFRATE;
   if MonoAudio then Flags := Flags or BASS_SAMPLE_MONO;

   Channel := BASS_StreamCreateFile(FALSE,PChar(CurFileName), 0, 0, Flags or BASS_SAMPLE_FX);  // and Flags
      if (Channel <> 0) then SngLen := 0;
    if (Channel = 0) then Channel := BASS_MusicLoad(FALSE, PChar(CurFileName), 0, 0, BASS_MUSIC_FX);
      if (Channel <> 0) then SngLen := 0;
    if (Channel = 0) then Exit;

  {Apply Equalyzation}
   CreateEqualyzer;
   SetEqualizer;

   BASS_StreamPlay(Channel, false, 0);
   BASS_MusicPlay(Channel);
   if (SngLen = 0) then SongLength := BASS_StreamGetLength(Channel);
   if (SngLen = 1) then SongLength := BASS_MusicGetLength(Channel, True);
   PlayerState := ENGINE_PLAY;
  end;

 function TAudioEngine.PlayURL (FileName : String) : Boolean;
   var SngLen : Integer;
  begin
   CurFileName := FileName;
   BASS_MusicFree(Channel);
   BASS_StreamFree(Channel);

   Channel := BASS_StreamCreateURL(PChar(CurFileName), 0, BASS_STREAM_META, PChar(URLSaveFile));

   SngLen := 0;

  {Apply Equalyzation}
//   CreateEqualyzer;
//   SetEqualizer;
   if Channel = 0 then Result := False else Result := True;
   if not BASS_StreamPlay(Channel, false, 0) then Result := False;
    if (SngLen = 0) then SongLength := BASS_StreamGetLength(Channel);
    PlayerState := ENGINE_PLAY;

  end;

 function TAudioEngine.GetSongPos : Integer;
   var SongPos : DWORD; MilliSec : Integer; FloatPos : FLOAT;
  begin
   SongPos := BASS_ChannelGetPosition(Channel);
   FloatPos := BASS_ChannelBytes2Seconds(Channel, SongPos);
   MilliSec := Trunc(1000 * FloatPos);
   if MilliSec < 0 then MilliSec := 0;
   result := MilliSec;
  end;

 procedure TAudioEngine.SetSongPos (SongPos : Integer);
  begin
    SongPos := BASS_ChannelSeconds2Bytes(Channel, SongPos / 1000);
    BASS_ChannelSetPosition(Channel, SongPos);
  end;

 function TAudioEngine.GetSongLen : Integer;
   var MilliSec : Integer; FloatPos : FLOAT;
  begin
   FloatPos := BASS_ChannelBytes2Seconds(Channel, SongLength);
   MilliSec := Trunc(1000 * FloatPos);
   if MilliSec < 0 then MilliSec := 0;
   result := MilliSec;
  end;

 procedure TAudioEngine.Pause;
  begin
   BASS_ChannelPause(Channel);
   PlayerState := ENGINE_PAUSE;
  end;

 procedure TAudioEngine.UnPause;
  begin
   BASS_ChannelResume(Channel);
   PlayerState := ENGINE_PLAY;
  end;

 procedure TAudioEngine.Stop;
  begin
   BASS_ChannelStop(Channel);
   PlayerState := ENGINE_STOP;
  end;

 function TAudioEngine.GetCurSong : String;
  begin
    result := CurFileName;
  end;

 function TAudioEngine.GetMainVolume : Integer;
  begin
   result := BASS_GetVolume;
  end;

 function TAudioEngine.GetGainVolume : Integer;
   var MVol, SVol, STVol : DWORD;
  begin
   BASS_GetGlobalVolumes(MVol, SVol, STVol);
   result := MVol;
  end;

 procedure TAudioEngine.SetMainVolume (Vol : Integer);
  begin
    BASS_SetVolume(Vol);
  end;

 procedure TAudioEngine.SetGainVolume (Vol : Integer);
  begin
   BASS_SetGlobalVolumes(Vol, Vol, Vol);
  end;

 function TAudioEngine.GetPanning : Integer;
   var freq, volume : DWORD; Pan : Integer;
  begin
   BASS_ChannelGetAttributes(Channel, freq, volume, Pan);
    result := Pan;
  end;

 procedure TAudioEngine.SetPanning (Pan : Integer);
   var freq, volume : DWORD; Pn : Integer;
  begin
   BASS_ChannelSetAttributes(Channel, -1, -1, Pan);
  end;

 function TAudioEngine.GetPitch : Integer;
   var handle, freq, volume : DWORD; Pan : Integer;
  begin
   BASS_ChannelGetAttributes(Channel, freq, volume, Pan);
    result := Trunc((Pan / WaveFreq) * 100);
  end;

 procedure TAudioEngine.SetPitch (Ptc : Integer);
   var freq : Integer; Pn : Integer;
  begin
    freq := Trunc((Ptc/ 10) * WaveFreq);
    if freq < 100 then freq := 100;
    if freq > 100000 then freq := 100000;
   BASS_ChannelSetAttributes(Channel, freq, -1, -1);
  end;

 function TAudioEngine.GetWaveBuffer : TWaveData;
   var BuffLen : Integer; WaveData : TWaveData;
  begin
   BuffLen := 2048;
    if PlayerState <> ENGINE_PLAY then Result := NullWave
     else begin
       BASS_ChannelGetData(Channel, @WaveData, BuffLen);
       result := WaveData;
     end;
  end;

 function TAudioEngine.GetFFTData : TFFTData;
   var FFTData : TFFTData;
  begin
   if PlayerState <> ENGINE_PLAY then Result := NullFFT
    else begin
      BASS_ChannelGetData(Channel, @FFTData, BASS_DATA_FFT1024);
      result := FFTData;
    end;
  end;

 function TAudioEngine.GetDialogFilter : String;
  begin
   result := 'mp1/mp2/mp3/wav/ogg/mod/s3m/it/umx/mo3/mtm/xm|*.mp1;*.mp2;*.mp3;*.wav;*.ogg;*.mod;*.s3m;*.it;*.umx;*.mo3;*.mtm;*.xm|'
              + 'Streams (mp1/mp2/mp3/wav/ogg)|*.mp1;*.mp2;*.mp3;*.wav;*.ogg|'
              + 'Trackers (mod/s3m/it/umx/mo3/mtm/xm)|*.mod;*.s3m;*.it;*.umx;*.mo3;*.mtm;*.xm';
  end;

 procedure TAudioEngine.SetOutBufferLen  (Len : Integer);
  begin
     if Len < 150 then Len := 150;
     if Len > 2000 then len := 2000;
     BASS_SetBufferLength(Len / 1000);
  end;

 function TAudioEngine.GetSongTitle (FileName : String): String;
   var ServerUrl, Name, Genere, WebURL, Bitrate, Title, TitleURL, Comment : String;
  begin
   if (Copy(Trim(UpperCase(FileName)), 1, 5) = 'HTTP:') or
      (Copy(Trim(UpperCase(FileName)), 1, 4) = 'FTP:') then begin

          if CurFileName = FileName then ServerUrl := '' else ServerUrl := FileName;
          GetICYMetaBroadcast(ServerUrl, Name, Genere, WebURL, Bitrate, Title, TitleURL, Comment);
          if Name <> ''  then Result := Name + ' ' + WebURL +  ' - ' + Title else Result := 'Unknown Host';
        end
   else
    begin
     FileName := ExtractFileName(FileName);
     result := Copy(FileName, 1, Length(FileName) - Length(ExtractFileExt(FileName)));
    end;
  end;

 destructor TAudioEngine.Destroy;
  begin
   Stop;
   Bass_Stop;
   Bass_Free;
  end;

 function TAudioEngine.GetSongLength (FileName : String): Integer;
    Var Chn : DWORD; res, MilliSec: Integer; SongLength : DWORD; FloatPos : FLOAT;
  begin
   Chn := BASS_StreamCreateFile(FALSE,PChar(FileName), 0, 0, 0);
   if Chn <> 0 then SongLength := BASS_StreamGetLength(Chn);
   if (Chn = 0) then
    begin
      Chn := BASS_MusicLoad(FALSE, PChar(FileName), 0, 0, 0);
      SongLength := BASS_MusicGetLength(Chn, True);
    end;
   if (Chn <> 0) then
     begin
         FloatPos := BASS_ChannelBytes2Seconds(Chn, SongLength);
         MilliSec := Trunc(1000 * FloatPos);
         if MilliSec < 0 then MilliSec := 0;
         res := MilliSec;
     end else res := -1;
       BASS_StreamFree(Chn);
       BASS_MusicFree(Chn);
   result := res;
  end;

     function TAudioEngine.CheckPlayableFile (FileName : String) : Boolean;
        var Ext : String;
      begin
       Ext := UpperCase(ExtractFileExt(FileName));
        if (Ext = '.MP1') or (Ext = '.MP2') or (Ext = '.MP3') or (Ext = '.WAV') or (Ext = '.OGG') or (Ext = '.MOD') or
           (Ext = '.S3M') or (Ext = '.IT') or (Ext = '.UMX') or (Ext = '.MO3') or (Ext = '.MTM') or (Ext = '.XM') then
            Result := True
             else Result := False;
      end;

     procedure TAudioEngine.CreateEqualyzer;
       var i, cnt : integer; EqP : BASS_FXPARAMEQ;
      begin
        for i := 0 to 9 do
         begin
          EqParam[i] := BASS_ChannelSetFX(Channel, BASS_FX_PARAMEQ);
          EqP.fGain := 0;
          EqP.fBandwidth := 3;
          EqP.fCenter := EQBands[i];
          if not BASS_FXSetParameters(EqParam[i], @EqP) then begin
//            if BASS_ERROR_HANDLE = BASS_ErrorGetCode then showmessage('h');
//            if BASS_ERROR_ILLPARAM = BASS_ErrorGetCode then showmessage('ill');
//            if BASS_ERROR_UNKNOWN = BASS_ErrorGetCode then showmessage('uk');
//            showmessage(inttostr(i));
            end;
         end;
      end;

     function TAudioEngine.GetSaveUrlFile : String;
      begin
        Result := URLSaveFile;
      end;

     procedure TAudioEngine.SetSaveUrlFile (FileName : String);
     begin
      URLSaveFile := FileName;
     end;



    procedure TAudioEngine.GetICYMetaBroadcast (ServerURL : String; var Name, Genere, WebURL, Bitrate, Title, TitleURL, Comment : String);
        var i, cnt : Integer; ICY : PChar; Tmp : String; RadioICY : TStringList; SrvChan : DWORD;

        function StrIndex( StrList : TStringList; SubStr : String) : Integer;
          var i : Integer;
         begin
          Result := -1;
          for i := 0 to StrList.Count -1 do
            if Pos(UpperCase(SubStr), UpperCase(StrList[i])) > 0 then Result := i;
         end;

         function ExtractICYSubStr(aStr : String) : String;
           var i : Integer;
          begin
            Result := Copy(aStr, Pos(':', aStr) + 1, Length(aStr));
          end;

      begin
       RadioICY := TStringList.Create;
       RadioICY.Clear;


       if ServerURL <> '' then
        begin
         SrvChan := BASS_StreamCreateURL(PChar(ServerURL), 0, BASS_STREAM_META, nil);
         if SrvChan = 0 then Exit;
        end else SrvChan := Channel;

       if SrvChan = 0 then exit;

       {Radio Broadcast ICY}                        
        i := 0;
        icy := BASS_StreamGetTags(SrvChan, BASS_TAG_ICY);
         while (i < 400) do //(icy[i] + icy[i + 1] <> #0 + #0) and
          begin
           try
            if icy[i] = #0 then begin RadioICY.add(Tmp); Tmp :=''; end
            else tmp := tmp + icy[i] except end;
          Inc(i);
          end;


        {Broadcast radio ICY Tag}
         RadioICY.add(BASS_StreamGetTags(SrvChan, BASS_TAG_META));

         i := StrIndex (RadioICY, 'icy-name');
         if i > -1 then Name := ExtractICYSubStr(RadioICY[i]);

         i := StrIndex (RadioICY, 'icy-genre');
         if i > -1 then Genere := ExtractICYSubStr(RadioICY[i]);

         i := StrIndex (RadioICY, 'icy-url');
         if i > -1 then WebURL := ExtractICYSubStr(RadioICY[i]);

         i := StrIndex (RadioICY, 'icy-br');
         if i > -1 then Bitrate := ExtractICYSubStr(RadioICY[i]);

         cnt := 1;
         While StrIndex (RadioICY, 'icy-notice' + IntToStr(cnt)) > -1 do
          begin
            i := StrIndex (RadioICY, 'icy-notice' + IntToStr(cnt));
             if Pos(UpperCase('Winamp'), Uppercase(RadioICY[i])) = 0  then Comment := Comment + ExtractICYSubStr(RadioICY[i]) + ' ';
            inc(cnt);
          end;

        {Getting Meta}
             i := StrIndex (RadioICY, 'StreamTitle');
             if i > -1 then Title := Copy(RadioICY[i], Pos(#39, RadioICY[i]) + 1,
                 Pos(#39 , Copy(RadioICY[i], Pos(#39, RadioICY[i]) + 1, Length(RadioICY[i]))) - 1);

             i := StrIndex (RadioICY, 'StreamUrl');
             if i > -1 then
              begin
               RadioICY[i] := Copy(RadioICY[i], Pos('StreamUrl', RadioICY[i]), Length(RadioICY[i]) + 1);
               TitleURL := Copy(RadioICY[i], Pos(#39, RadioICY[i]) + 1,
                 Pos(#39 , Copy(RadioICY[i], Pos(#39, RadioICY[i]) + 1, Length(RadioICY[i]))) - 1);
               end;

          if ServerURL <> '' then  BASS_StreamFree(SrvChan);
      end;

     function TAudioEngine.IsOnLine : Boolean;
      begin
        if ((PlayerState = ENGINE_PLAY) or (PlayerState =ENGINE_PAUSE)) and((Copy(Trim(UpperCase(CurFileName)), 1, 5) = 'HTTP:') or
           (Copy(Trim(UpperCase(CurFileName)), 1, 4) = 'FTP:' )) then Result := True else Result := False;
      end;

     procedure TAudioEngine.GetVULevel(var R, L : Integer);
        var  VUCH : DWORD;
      begin
       VUCH := BASS_ChannelGetLevel(Channel);
        L := LOWORD(VUCH);
        R := HIWORD(VUCH);
      end;

     function TAudioEngine.GetBitrate : Integer;
        var ByteLen : DWORD;
      begin
         ByteLen := BASS_ChannelSeconds2Bytes(Channel, SongLength);
        Result := Trunc((ByteLen / (2 * 8 * GetSongLen)));
      end;

 end.





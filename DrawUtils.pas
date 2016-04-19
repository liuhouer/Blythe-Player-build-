{Draw Utility}
unit DrawUtils;

interface
 uses Windows, Classes, Graphics, SysUtils, Math, Dialogs;

 procedure DrawInit;
 procedure DrawPlayList (Offset : Integer);
 procedure DrawWave(HWND : Integer);
 procedure DrawFFT;
 function ShortTime (TimeLen : Integer) : String;

 var Selected, Clicked : Integer;
     ListTotal : LongInt;
     RenderBuff : TBitmap;
     FFTPeacks  : array [0..128] of Integer;
     FFTFallOff : array [0..128] of Integer;
implementation

uses Main, Playlist, AudioObject, CommonTypes, Config;

{Draw the play list with a offset}
 procedure DrawPlayList (Offset : Integer);
   var i, cnt, MaxIdx : Integer; BackBmp : TBitmap; Tmp, Text : String;
  begin
   with FormPlaylist.PlaylstImage do
    begin
     cnt := FormPlaylist.VsComposer.Graphics.IndexByName('main.bmp');
     BackBmp := FormPlaylist.VsComposer.Graphics[cnt].Bitmap;
      Canvas.CopyRect(Rect(0, 0, Width, Height), BackBmp.Canvas, Rect(Left, Top, Left + Width, Top + Height));
      Canvas.Brush.Style := bsClear;
      Canvas.Font.Name := 'Arial';
      cnt := Trunc((Offset / 100) * AudioObjectPlayer.Count);

      if (cnt + Height div 15) > AudioObjectPlayer.Count - 1 then MaxIdx := AudioObjectPlayer.Count - 1
       else
         MaxIdx := cnt + Height div 15;

      for i := cnt to MaxIdx do
       begin
         Tmp := ShortTime (AudioObjectPlayer.GetLegth (i) div 1000);

         if FormConfig.NumPLCheckBox.Checked then
           Text := IntToStr(i + 1) + ' ' + (AudioObjectPlayer.GetText(i))
          else
           Text := (AudioObjectPlayer.GetText(i));

         if i = Clicked then
          begin
           Canvas.Brush.Style := bsSolid;
           Canvas.Pen.Style := psClear;
           Canvas.Brush.Color := $00759B8E;
           Canvas.Rectangle(0, (i - cnt) * 15, Width, (i - cnt + 1) * 15);
          end
           else
            begin
            Canvas.Brush.Style := bsClear;
            Canvas.Pen.Style := psSolid;
            end;

         if Length(Text) > 32 then Text := Copy(Text, 1, 32) + '..';
         if Selected <> i then
           begin
            Canvas.Font.Style := [];
            Canvas.TextOut (1, (i - cnt) * 15 + 1, Text);
            Canvas.TextOut (Width - 30, (i - cnt) * 15 + 1, Tmp);
           end
          else
           begin
            Canvas.Font.Style := [fsBold];
            Canvas.TextOut (1, (i - cnt) * 15 + 1, Text);
            Canvas.TextOut (Width - 30, (i - cnt) * 15 + 1, Tmp);
           end;
       end;
    end;
  end;
{Draw buffers init}
   procedure DrawInit;
     begin
      RenderBuff := TBitmap.Create;
      RenderBuff.Width := FormPlayer.WavePaint.Width;
      RenderBuff.Height := FormPlayer.WavePaint.Height;
     end;

{Draw the wave frame}
  procedure DrawWave(HWND : Integer);
       var i, cnt : Integer; BackBmp : TBitmap; WaveY : Integer; RV, LV : SmallInt;
       Tmp, Text : String; WaveData : TWaveData;
  begin
   with RenderBuff do
    begin
     cnt := FormPlayer.VsComposer.Graphics.IndexByName('mainpl.bmp');
      BackBmp := FormPlayer.VsComposer.Graphics[cnt].Bitmap;
      Canvas.CopyRect(Rect(0, 0, Width, Height), BackBmp.Canvas, Rect(FormPlayer.WavePaint.Left, FormPlayer.WavePaint.Top, FormPlayer.WavePaint.Left + Width, FormPlayer.WavePaint.Top + Height));

      WaveData := AudioObjectPlayer.GetWaveBuffer;

      LV := LOWORD(WaveData[0]);
      RV := HIWORD(WaveData[0]);
      WaveY := FormPlayer.WavePaint.Height div 2 + Trunc(((RV + LV) /64000 ) * FormPlayer.WavePaint.Height);
      Canvas.MoveTo(0, WaveY);

      for i := 1 to FormPlayer.WavePaint.Width do
       begin
         LV := LOWORD(WaveData[i]);
         RV := HIWORD(WaveData[i]);
         WaveY := FormPlayer.WavePaint.Height div 2 + Trunc(((RV + LV) /64000 ) * FormPlayer.WavePaint.Height);
         Canvas.LineTo(i, WaveY);
       end;
     end;
      FormPlayer.WavePaint.Canvas.Draw(0,0, RenderBuff);
    end;

{Draw the fft frame}
 procedure DrawFFT;
       var i, cnt : Integer; BackBmp : TBitmap; WaveY : Integer; Val : Single;
       Tmp, Text : String; FFTData : TFFTData; pos : Integer;
  begin
   with RenderBuff do
    begin
     cnt := FormPlayer.VsComposer.Graphics.IndexByName('mainpl.bmp');
      BackBmp := FormPlayer.VsComposer.Graphics[cnt].Bitmap;
      Canvas.CopyRect(Rect(0, 0, Width, Height), BackBmp.Canvas, Rect(FormPlayer.WavePaint.Left, FormPlayer.WavePaint.Top, FormPlayer.WavePaint.Left + Width, FormPlayer.WavePaint.Top + Height));

      FFTData := AudioObjectPlayer.GetFFTData;

       for i := 0 to 12 do begin
         Val := FFTData[(i * 8) + 5];
         pos := Trunc((val) * 500);
         if pos > Height then pos := Height;

         if pos >= FFTPeacks[i] then FFTPeacks[i] := pos
           else FFTPeacks[i] := FFTPeacks[i] - 1;

         if pos >= FFTFallOff[i] then FFTFallOff[i] := pos
          else FFTFallOff[i] := FFTFallOff[i] - 3;

         if FFTPeacks[i] < 3 then FFTPeacks[i] := 3;

            Canvas.MoveTo(i * 5 + i + 1, Height - FFTPeacks[i]);
            Canvas.LineTo(i * 5 + 5 + i + 1, Height - FFTPeacks[i]);
            Canvas.Rectangle(Rect( i * 5 + i + 1, Height - 3 - FFTFallOff[i], i * 5 + 5 + i + 1, Height - 3));
       end;
     end;
      FormPlayer.WavePaint.Canvas.Draw(0, 0, RenderBuff);
    end;

 function ShortTime (TimeLen : Integer) : String;
   var Tmp : String;
  begin
     Tmp := FormatDateTime ('nn:ss', (TimeLen)/ (24 * 60 * 60));
      while Pos('.', Tmp) > 0 do
       Tmp := Copy(Tmp, 1, Pos('.', Tmp) - 1) + ':' + Copy(Tmp, Pos('.', Tmp) + 1, Length(Tmp));
    Result := Tmp;
  end;


end.

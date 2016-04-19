unit AudioObject;
{ TAudioObject by Alessandro Cappellozza
  version 0.8 02/2002
  http://digilander.iol.it/Kappe/audioobject  
}

interface
 uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ShellApi, ExtCtrls,
      Dialogs, AudioEngine, CommonTypes, StdCtrls, ComCtrls, PlayListClass;


  type TAudioObject = Class(TAudioEngine)
    private
     {Classes}
      PlayList      : TPlaylist;

    {Amp Vars}
      SongIndex  : Integer;

   public
      Volume  : Integer;
      Balance : Integer;
      Rpt     : Boolean;
      Shf     : Boolean;
      AmpSkin    : String;

      constructor Create (HWND : THandle); Override;

      procedure LoadPlaylist (FileName : String; ClearCurrent : Boolean);
      procedure Open (FileName : String);
      procedure OpenFiles (FileNames : TStrings);
      procedure SavePls (FileName : String);

     {Playlist accessors}
      procedure AddFile(FileName, Title : String);
      procedure Clear;
      function Count : Integer;

      function GetFileName( i : Integer) : String;
      function GetText( i : Integer) : String;
      function GetDialogFilter : String; Override;
      function GetLegth( i : Integer) : LongInt;
      function GetTotLegth : Longint;

      procedure SetFileaName( i : Integer; FileName : String);
      procedure SetText( i : Integer; FileName : String);
      procedure SetLegth( i : Integer; Len : LongInt);
      
      procedure DeleteItem ( i : Integer);
      procedure InsertItem ( i : Integer; FileName, Title : String);

      function SearchByTitle (Title : String) : Integer;
      function SearchByFileName (FileName : String) : Integer;

     {Indexing}
      function ItemIndex : Integer;
      procedure NextSong;
      procedure PrevSong;
      procedure JumpToSing(Index : Integer);
   end;

 var AudioObjectPlayer : TAudioObject;

implementation


 constructor TAudioObject.Create (HWND : THandle);
  begin {Create Calsses istances}
    Inherited Create (HWND);
      PlayList := TPlaylist.Create;
  end;

 procedure TAudioObject.NextSong;
   var i : Integer;
  begin
    if Playlist.Count = 0 then exit;
    i := SongIndex;
    if not Shf then Inc(SongIndex)
     else
      begin { Select a not equal to actual random number}
       while Random(PlayList.Count - 1) <> SongIndex do i := Random(PlayList.Count - 1);
       SongIndex := i;
      end;

    if SongIndex = Playlist.Count then SongIndex := 0;
    Inherited Play(PlayList.GetFileName(SongIndex));
  end;

  procedure TAudioObject.PrevSong;
   begin
     if Playlist.Count = 0 then exit;
     Dec(SongIndex);
     if SongIndex < 0 then SongIndex := Playlist.Count - 1;
     Inherited Play(PlayList.GetFileName(SongIndex));
   end;

   procedure TAudioObject.LoadPlaylist (FileName : String; ClearCurrent : Boolean);
    begin
     { Select Playlist Type}
      if UpperCase(ExtractFileExt(FileName)) = '.PLS' then PlayList.LoadPLS(FileName, ClearCurrent);
      if UpperCase(ExtractFileExt(FileName)) = '.M3U' then PlayList.LoadM3U(FileName, ClearCurrent);
    end;

   procedure TAudioObject.Open (FileName : String);
    begin
       if Inherited CheckPlayableFile(FileName) then
        begin  {Audio file}
         Inherited Play(FileName);
         SongIndex := Playlist.Count;
         Playlist.Add(FileName, Inherited GetSongTitle (FileName));
        end
         else {Playlist file}
          LoadPlayList(FileName, False);
    end;

    procedure TAudioObject.OpenFiles (FileNames : TStrings);
        var i : Integer;
     begin
       SongIndex := Playlist.Count - 1;
       {Add all files or load playlists and play the first entered}
       for i := 0 to FileNames.Count - 1 do begin
        if (Inherited CheckPlayableFile(FileNames[i])) then Playlist.Add(FileNames[i], Inherited GetSongTitle (FileNames[i]))
         else LoadPlayList(FileNames[i], False);
       end;
        NextSong;
     end;

      procedure TAudioObject.AddFile(FileName, Title : String);
       begin
         if (Copy(UpperCase(FileName), 1, 7) = 'HTTP://') or (Copy(UpperCase(FileName), 1, 6) = 'FTP://') then
                     Playlist.Add (FileName, Title)
         else if (Inherited CheckPlayableFile(FileName)) then Playlist.Add (FileName, Title)
                else LoadPlayList(FileName, False);
       end;

      procedure TAudioObject.Clear;
       begin
        Playlist.Clear;
       end;

      function TAudioObject.Count : Integer;
       begin
        Result := Playlist.Count;
       end;

      function TAudioObject.GetFileName( i : Integer) : String;
       begin
        if (Playlist.Count = 0) or (i > Playlist.Count -1) then exit;
         Result := Playlist.GetFileName(i);
       end;

      function TAudioObject.GetText( i : Integer) : String;
       begin
        if (Playlist.Count = 0) or (i > Playlist.Count -1) then exit;
         Result := Playlist.GetText(i);
       end;

      procedure TAudioObject.SetFileaName( i : Integer; FileName : String);
       begin
        if (Playlist.Count = 0) or (i > Playlist.Count -1) then exit;
         Playlist.SetFileaName(i, FileName);
       end;

      procedure TAudioObject.SetText( i : Integer; FileName : String);
       begin
        if (Playlist.Count = 0) or (i > Playlist.Count -1) then exit;
         Playlist.SetText(i, FileName);
       end;

      procedure TAudioObject.DeleteItem ( i : Integer);
       begin
         Playlist.DeleteItem(i);
       end;

      procedure TAudioObject.InsertItem ( i : Integer; FileName, Title : String);
       begin
         Playlist.InsertItem(i, FileName, Title);
       end;

      function TAudioObject.SearchByTitle (Title : String) : Integer;
       begin
        Result := Playlist.SearchByTitle(Title);
       end;

      function TAudioObject.SearchByFileName (FileName : String) : Integer;
       begin
           Result := Playlist.SearchByFileName(FileName);
       end;

      procedure TAudioObject.SavePls (FileName : String);
       begin
          Playlist.SavePLS(FileName);
       end;

      function TAudioObject.ItemIndex : Integer;
       begin
        Result := SongIndex;
       end;

      procedure TAudioObject.JumpToSing(Index : Integer);
       begin
        SongIndex := Index;
       end;

      function  TAudioObject.GetDialogFilter : String;
        var Tmp : String;
       begin
          TMP := (Inherited GetDialogFilter);
         Result :=  TMP + '|Playlist (pls/m3u)|*.pls;*.m3u';
       end;

      function TAudioObject.GetLegth( i : Integer) : LongInt;
       begin
        Result := Playlist.GetLegth(i) * 1000;
       end;

      procedure TAudioObject.SetLegth( i : Integer; Len : LongInt);
       begin
        Playlist.SetLegth(i, len div 1000);
       end;

      function TAudioObject.GetTotLegth : Longint;
         var i : Integer; Res : LongInt;
       begin
         Res := 0;
           for i := 0 to Playlist.Count - 1
            do Res := Res + Playlist.GetLegth(i) * 1000;
         Result := Res;
       end;
end.

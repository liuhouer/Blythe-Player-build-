{ Simple Playlist Class
  Delphi 2, 3, 4, 5, 6 (tested with 6 only)
    - support PLS and M3U
    - freeware if used in freeware project
  Copyright Porzillosoft Inc. All Rights Reserved
  http://digilander.iol.it/Kappe/audioobject  
 }

unit PlayListClass;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles;

 Type TPlaylist = Class(TObject)
  private                     
    FileList   : TStringList;
    FileTitle  : TStringList;
    FileLength : TStringList;
    CurPlaylist  : String;
    function ProcessPath(FileName : String) : String;
  public
    constructor Create;
    function LoadPLS(FileName : String; ClearCurrent : Boolean) : Boolean;
    function LoadM3U(FileName : String; ClearCurrent : Boolean) : Boolean;
    function SavePLS(FileName : String) : Boolean;

    procedure Add(FileName, Title : String);
    function GetFileName( i : Integer) : String;
    function GetText( i : Integer) : String;
    function GetLegth( i : Integer) : LongInt;

    procedure SetFileaName( i : Integer; FileName : String);
    procedure SetText( i : Integer; FileName : String);
    procedure SetLegth( i : Integer; Len : LongInt);

    procedure DeleteItem ( i : Integer);
    procedure InsertItem ( i : Integer; FileName, Title : String);

    function SearchByTitle (Title : String) : Integer;
    function SearchByFileName (FileName : String) : Integer;

    procedure Clear;
    function Count : Integer;
    destructor Destroy;
  end;

implementation
   constructor TPlaylist.Create;
    begin
      FileList  := TStringList.Create;
      FileTitle := TStringList.Create;
      FileLength := TStringList.Create;
    end;

   function TPlaylist.LoadPLS(FileName : String; ClearCurrent : Boolean) : Boolean;
     var i : Integer; FileINI : TIniFile; Temp : String;
    begin
      CurPlaylist := FileName;
     try
      if ClearCurrent then
       begin
        FileList.Clear;
        FileTitle.Clear;
       end;
        FileINI := TIniFile.Create(FileName);
          For i := 0 to FileINI.ReadInteger('playlist','NumberOfEntries',0) - 1 do
           begin
            Temp := FileINI.ReadString('playlist','File' + IntToStr(i + 1),'') ;
              FileList.Add(ProcessPath(Temp));
            Temp := ExtractFileName(Temp);
            Temp := Copy(Temp, 1, Length(Temp) - Length(ExtractFileExt(Temp)));
              FileTitle.Add( FileINI.ReadString('playlist','Title' + IntToStr(i + 1), Temp) );
              FileLength.Add( FileINI.ReadString('playlist','Length' + IntToStr(i + 1), '0') );
            end;
        FileINI.Free;
       result := True;
     except result := False;
       end;
    end;

    function TPlaylist.LoadM3U(FileName : String; ClearCurrent : Boolean) : Boolean;
     var i : Integer; FileINI : TStringList; Temp : String;
    begin
       CurPlaylist := FileName;
     try
      if ClearCurrent then
       begin
        FileList.Clear;
        FileTitle.Clear;
       end;
        FileINI := TStringList.Create;
        FileINI.LoadFromFile(FileName);
        i := 0;
        While (i < FileINI.Count - 1) do
         begin
           Temp := UpperCase(Trim(FileINI[i]));
             if Copy(Temp, 1, 1) <> '#' then
                FileList.Add( ProcessPath(FileINI[i]) )
             else
                if Copy(Temp, 1, 8) = '#EXTINF:' then
                   FileTitle.Add(Copy(FileINI[i], Pos(',', FileINI[i]) + 1, Length(FileINI[i])));
           FileLength.Add('0');
           Inc(i);
         end;
          FileINI.Free;
          result := True;
         except result := False;
       end;
    end;

    function TPlaylist.GetFileName( i : Integer) : String;
     begin
       result := FileList[i];
     end;

    function TPlaylist.GetText( i : Integer) : String;
     begin
       result := FileTitle[i];
     end;

    function TPlaylist.Count : Integer;
     begin
       result := FileList.Count;
     end;

    procedure TPlaylist.SetFileaName( i : Integer; FileName : String);
     begin
       FileList[i] := FileName;
     end;

    procedure TPlaylist.SetText( i : Integer; FileName : String);
     begin
       FileTitle[i] := FileName;
     end;

    procedure TPlaylist.DeleteItem ( i : Integer);
     begin
      FileList.Delete(i);
      FileTitle.Delete(i);
      FileLength.Delete(i);
     end;

    procedure TPlaylist.InsertItem ( i : Integer; FileName, Title : String);
     begin
      FileList.Insert(i, FileName);
      FileTitle.Insert(i, Title);
      FileLength.Insert (i, '0');
     end;

    procedure TPlaylist.Clear;
     begin
      FileList.Clear;
      FileTitle.Clear;
     end;

    procedure TPlaylist.Add(FileName, Title : String);
     begin
      FileList.Add(FileName);
      FileTitle.Add (Title);
      FileLength.Add('0');
     end;

    function TPlaylist.SearchByTitle (Title : String) : Integer;
     begin
      Result := FileTitle.IndexOf(Title);
     end;

    function TPlaylist.SearchByFileName (FileName : String) : Integer;
     begin
      Result := FileList.IndexOf(FileName);
     end;

   function TPlaylist.SavePLS(FileName : String) : Boolean;
     var i : Integer; FileINI : TIniFile; Temp : String;
    begin
     try
        FileINI := TIniFile.Create(FileName);
          For i := 1 to FileList.Count do
           begin
              FileINI.WriteString('playlist','File' + IntToStr(i), FileList[i - 1]);
              FileINI.WriteString('playlist','Title' + IntToStr(i), FileTitle[i -1]);
              FileINI.WriteString('playlist','Length' + IntToStr(i), FileLength[i -1]);
            end;
         FileINI.WriteInteger('playlist','NumberOfEntries', FileList.Count);
        FileINI.Free;
     except result := False;
       end;
      result := True;
    end;

 destructor TPlaylist.Destroy;
  begin
    FileList.Destroy;
    FileTitle.Destroy;
    FileLength.Destroy;
  end;

 function TPlaylist.ProcessPath(FileName : String) : String;
  begin
   FileName := Trim(FileName);
   if Not((Copy(UpperCase(FileName), 1, 7) = 'HTTP://') or (Copy(UpperCase(FileName), 1, 6) = 'FTP://')) then
   begin
     if CurPlaylist[Length(CurPlaylist)] <> '\' then CurPlaylist := CurPlaylist + '\'; // changed the next IF to protect UNCs  KWL
     if (Copy(FileName, 1, 1) = '\') and (Copy(FileName, 2, 1) <> '\') then
            FileName := Copy(CurPlaylist, 1, 2) + FileName
         else
            if Copy(FileName, 2, 2) <> ':\' then FileName := CurPlaylist + FileName;
   end;
    result := FileName;
  end;

    procedure TPlaylist.SetLegth(i, Len : LongInt);
     begin
      FileLength[i] := IntToStr(Len);
     end;

    function TPlaylist.GetLegth( i : Integer) : LongInt;
     begin
       Result := StrToInt(FileLength[i]);
     end;

end.


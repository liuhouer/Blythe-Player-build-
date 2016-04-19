unit Main;

{$I DELPHIAREA.INC}

{$IFDEF COMPILER6_UP}
  {$WARN UNIT_PLATFORM OFF}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, FindFile;

type
  TMainForm = class(TForm)
    FindButton: TButton;
    StopButton: TButton;
    FindFile: TFindFile;
    Animate: TAnimate;
    FoundFiles: TListView;
    StatusBar: TStatusBar;
    Threaded: TCheckBox;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Filename: TEdit;
    Location: TEdit;
    Subfolders: TCheckBox;
    BrowseButton: TButton;
    TabSheet2: TTabSheet;
    Attributes: TGroupBox;
    TabSheet3: TTabSheet;
    BeforeDate: TDateTimePicker;
    DateRangeChoice: TRadioGroup;
    AfterDate: TDateTimePicker;
    Label3: TLabel;
    Phrase: TEdit;
    BeforeTime: TDateTimePicker;
    AfterTime: TDateTimePicker;
    FileSize: TGroupBox;
    SizeMaxEdit: TEdit;
    Label8: TLabel;
    SizeMinEdit: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    BD: TCheckBox;
    BT: TCheckBox;
    AD: TCheckBox;
    AT: TCheckBox;
    IgnoreCase: TCheckBox;
    WholeWord: TCheckBox;
    SizeMin: TUpDown;
    SizeMax: TUpDown;
    System: TCheckBox;
    Hidden: TCheckBox;
    Readonly: TCheckBox;
    Archive: TCheckBox;
    Directory: TCheckBox;
    Compressed: TCheckBox;
    Encrypted: TCheckBox;
    Offline: TCheckBox;
    SparseFile: TCheckBox;
    ReparsePoint: TCheckBox;
    Temporary: TCheckBox;
    procedure FindButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure FindFileFolderChange(Sender: TObject; const Folder: String;
      var IgnoreFolder: TFolderIgnore);
    procedure FindFileFileMatch(Sender: TObject; const Folder: String;
      const FileInfo: TSearchRec);
    procedure BrowseButtonClick(Sender: TObject);
    procedure FoundFilesColumnClick(Sender: TObject; Column: TListColumn);
    procedure FoundFilesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FindFileSearchFinish(Sender: TObject);
    procedure FoundFilesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BDClick(Sender: TObject);
    procedure BTClick(Sender: TObject);
    procedure ADClick(Sender: TObject);
    procedure ATClick(Sender: TObject);
    procedure FindFileSearchBegin(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FindFileSearchAbort(Sender: TObject);
  private
    Folders: Integer;
    StartTime: DWord;
    SortedColumn: Integer;
    Descending: Boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses
  FileCtrl, ShellAPI;

function GetAttributeStatus(CB: TCheckBox): TFileAttributeStatus;
begin
  case CB.State of
    cbUnchecked: Result := fsUnset;
    cbChecked: Result := fsSet;
  else
    Result := fsIgnore;
  end;
end;

procedure TMainForm.FindButtonClick(Sender: TObject);
begin
  // Sets FileFile properties
  FindFile.Threaded := Threaded.Checked;
  // - Name & Location
  with FindFile.Criteria.Files do
  begin
    FileName := Self.Filename.Text;
    Location := Self.Location.Text;
    Subfolders := Self.Subfolders.Checked;
  end;
  // - Containing Text
  with FindFile.Criteria.Content do
  begin
    Phrase := Self.Phrase.Text;
    IgnoreCase := Self.IgnoreCase.Checked;
    WholeWord := Self.WholeWord.Checked;
  end;
  // - Attributes
  with FindFile.Criteria.AttributeEx do
  begin
    Archive := GetAttributeStatus(Self.Archive);
    Readonly := GetAttributeStatus(Self.Readonly);
    Hidden := GetAttributeStatus(Self.Hidden);
    System := GetAttributeStatus(Self.System);
    Directory := GetAttributeStatus(Self.Directory);
    Compressed := GetAttributeStatus(Self.Compressed);
    Encrypted := GetAttributeStatus(Self.Encrypted);
    Offline := GetAttributeStatus(Self.Offline);
    ReparsePoint := GetAttributeStatus(Self.ReparsePoint);
    SparseFile := GetAttributeStatus(Self.SparseFile);
    Temporary := GetAttributeStatus(Self.Temporary);
  end;
  // - Size ranges
  with FindFile.Criteria.Size do
  begin
    Min := SizeMin.Position * 1024; // KB -> byte
    Max := SizeMax.Position * 1024; // KB -> byte
  end;
  // - TimeStamp ranges
  with FindFile.Criteria.TimeStamp do
  begin
    AccessedBefore := 0;
    AccessedAfter := 0;
    ModifiedBefore := 0;
    ModifiedAfter := 0;
    CreatedBefore := 0;
    CreatedAfter := 0;
    case DateRangeChoice.ItemIndex of
      0: begin // Created on
           if BD.Checked then
             CreatedBefore := BeforeDate.Date;
           if BT.Checked then
             CreatedBefore := CreatedBefore + BeforeTime.Time;
           if AD.Checked then
             CreatedAfter := AfterDate.Date;
           if AT.Checked then
             CreatedAfter := CreatedAfter + AfterTime.Time;
         end;
      1: begin // Modified on
           if BD.Checked then
             ModifiedBefore := BeforeDate.Date;
           if BT.Checked then
             ModifiedBefore := ModifiedBefore + BeforeTime.Time;
           if AD.Checked then
             ModifiedAfter := AfterDate.Date;
           if AT.Checked then
             ModifiedAfter := ModifiedAfter + AfterTime.Time;
         end;
      2: begin // Last Accessed on
           if BD.Checked then
             AccessedBefore := BeforeDate.Date;
           if BT.Checked then
             AccessedBefore := AccessedBefore + BeforeTime.Time;
           if AD.Checked then
             AccessedAfter := AfterDate.Date;
           if AT.Checked then
             AccessedAfter := AccessedAfter + AfterTime.Time;
         end;
    end;
  end;
  // Begins search
  FindFile.Execute;
end;

procedure TMainForm.StopButtonClick(Sender: TObject);
begin
  FindFile.Abort;
end;

procedure TMainForm.FindFileSearchAbort(Sender: TObject);
begin
  StatusBar.SimpleText := 'Cancelling search, please wait...';
  Update;
end;

procedure TMainForm.FindFileSearchBegin(Sender: TObject);
begin
  SortedColumn := -1;
  FoundFiles.SortType := stNone;
  FoundFiles.Items.BeginUpdate;
  FoundFiles.Items.Clear;
  FoundFiles.Items.EndUpdate;
  FindButton.Enabled := False;
  StopButton.Enabled := True;
  Threaded.Enabled := False;
  Animate.Active := True;
  Folders := 0;
  StartTime := GetTickCount;
end;

procedure TMainForm.FindFileSearchFinish(Sender: TObject);
begin
  StatusBar.SimpleText := Format('%d folder(s) searched and %d file(s) found - %.3f second(s)',
    [Folders, FoundFiles.Items.Count, (GetTickCount - StartTime) / 1000]);
  if FindFile.Aborted then
    StatusBar.SimpleText := 'Search cancelled - ' + StatusBar.SimpleText;
  Animate.Active := False;
  Threaded.Enabled := True;
  StopButton.Enabled := False;
  FindButton.Enabled := True;
end;

procedure TMainForm.FindFileFolderChange(Sender: TObject; const Folder: String;
  var IgnoreFolder: TFolderIgnore);
begin
  Inc(Folders);
  StatusBar.SimpleText := Folder;
  if not FindFile.Threaded then
    Application.ProcessMessages;
end;

procedure TMainForm.FindFileFileMatch(Sender: TObject; const Folder: String;
  const FileInfo: TSearchRec);
begin
  with FoundFiles.Items.Add do
  begin
    Caption := FileInfo.Name;
    SubItems.Add(Folder);
    if (FileInfo.Attr and faDirectory) <> 0 then
      SubItems.Add('Folder')
    else
      SubItems.Add(IntToStr((FileInfo.Size + 1023) div 1024) + 'KB');
    SubItems.Add(DateTimeToStr(FileDateToDateTime(FileInfo.Time)));
  end;
  if not FindFile.Threaded then
    Application.ProcessMessages;
end;

procedure TMainForm.BrowseButtonClick(Sender: TObject);
var
  Folder: String;
begin
  if Pos(';', Location.Text) = 0 then
    Folder := Location.Text
  else
    Folder := '';
  {$IFDEF COMPILER4_UP}
  if SelectDirectory('Select folder to search:', '', Folder) then
    Location.Text := Folder;
  {$ELSE}
  if SelectDirectory(Folder, [], 0) then
    Location.Text := Folder;
  {$ENDIF}
end;

procedure TMainForm.FoundFilesColumnClick(Sender: TObject; Column: TListColumn);
begin
  if not FindFile.Busy then
  begin
    TListView(Sender).SortType := stNone;
    if Column.Index <> SortedColumn then
    begin
      SortedColumn := Column.Index;
      Descending := False;
    end
    else
      Descending := not Descending;
    TListView(Sender).SortType := stText;
  end
  else
    MessageDlg('Cannot sort the files when the search is in progress.', mtWarning, [mbOK], 0);
end;

procedure TMainForm.FoundFilesCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if SortedColumn = 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else if SortedColumn > 0 then
    Compare := CompareText(Item1.SubItems[SortedColumn-1],
                           Item2.SubItems[SortedColumn-1]);
  if Descending then Compare := -Compare;
end;

procedure TMainForm.FoundFilesDblClick(Sender: TObject);
begin
  if FoundFiles.Selected <> nil then
    with FoundFiles.Selected do
      ShellExecute(0, 'Open', PChar(Caption), nil, PChar(SubItems[0]), SW_NORMAL);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  BeforeDate.Date := Date;
  BeforeDate.Time := 0;
  AfterDate.Date := Date;
  AfterDate.Time := 0;
  BeforeTime.Time := Time;
  BeforeTime.Date := 0;
  AfterTime.Time := Time;
  AfterTime.Date := 0;
end;

procedure TMainForm.BDClick(Sender: TObject);
begin
  BeforeDate.Enabled := BD.Checked;
end;

procedure TMainForm.BTClick(Sender: TObject);
begin
  BeforeTime.Enabled := BT.Checked;
end;

procedure TMainForm.ADClick(Sender: TObject);
begin
  AfterDate.Enabled := AD.Checked;
end;

procedure TMainForm.ATClick(Sender: TObject);
begin
  AfterTime.Enabled := AT.Checked;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FindFile.Busy then FindFile.Abort;
end;

end.

unit playlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DrawUtils, AudioObject,
  Dialogs, VsControls, VsSkin, VsSlider, VsComposer, ExtCtrls, VsImage,
  VsButtons, VsImageText, Menus, OBStarfield, OBMagnet;

type
  TFormPlaylist = class(TForm)
    VsComposer: TVsComposer;
    mainSkin: TVsSkin;
    ListSlBack: TVsImage;
    ListSlider: TVsSlider;
    PlaylstImage: TImage;
    VsButton1: TVsButton;
    VsButton2: TVsButton;
    InfoText: TVsImageText;
    VsButton3: TVsButton;
    PLMenu: TPopupMenu;
    Clearlist: TMenuItem;
    AddFiles: TMenuItem;
    OpenDialog: TOpenDialog;
    Delete: TMenuItem;
    Save: TMenuItem;
    SaveDialog: TSaveDialog;
    N1: TMenuItem;
    OBFormMagnet1: TOBFormMagnet;
    procedure ListSliderChange(Sender: TObject);
    procedure PlaylstImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlaylstImageDblClick(Sender: TObject);
    procedure VsButton2Click(Sender: TObject);
    procedure VsButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VsButton3Click(Sender: TObject);
    procedure ClearlistClick(Sender: TObject);
    procedure AddFilesClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPlaylist: TFormPlaylist;

implementation

uses main;

{$R *.dfm}

procedure TFormPlaylist.ListSliderChange(Sender: TObject);
begin
 DrawPlayList (100 - ListSlider.Position);
end;

procedure TFormPlaylist.PlaylstImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
 var cnt : Integer;
begin
  cnt := Trunc(((100 - ListSlider.Position) / 100) * AudioObjectPlayer.Count);
  if (cnt + Y div 15) <= AudioObjectPlayer.Count - 1 then Clicked := cnt + Y div 15;
  DrawPlayList (100 - ListSlider.Position);
  PlaylstImage.Tag := Y;
end;

procedure TFormPlaylist.PlaylstImageDblClick(Sender: TObject);
 var cnt : Integer;
begin
  cnt := Trunc(((100 - ListSlider.Position) / 100) * AudioObjectPlayer.Count);
  if (cnt + PlaylstImage.Tag div 15) <= AudioObjectPlayer.Count - 1 then Selected := cnt + PlaylstImage.Tag div 15;
  DrawPlayList (100 - ListSlider.Position);
  AudioObjectPlayer.Play(AudioObjectPlayer.GetFileName(Selected));
  AudioObjectPlayer.SetLegth(Selected, AudioObjectPlayer.GetSongLen);
end;

procedure TFormPlaylist.VsButton2Click(Sender: TObject);
begin
 Close;
 FormPlayer.PLCheck.Checked := False;
end;

procedure TFormPlaylist.VsButton1Click(Sender: TObject);
begin
 Application.Minimize;
end;

procedure TFormPlaylist.FormCreate(Sender: TObject);
begin
 FormPlaylist.Height := mainSkin.Height;
 FormPlaylist.Width := mainSkin.Width;
end;

procedure TFormPlaylist.VsButton3Click(Sender: TObject);
 var Point : TPoint;
begin
 GetCursorPos(Point);
 PLMenu.Popup(Point.X, Point.Y);
end;

procedure TFormPlaylist.ClearlistClick(Sender: TObject);
begin
 AudioObjectPlayer.Clear;
 DrawPlayList (100 - ListSlider.Position);
 ListTotal := 0;
end;

procedure TFormPlaylist.AddFilesClick(Sender: TObject);
 var i : Integer;
begin
 OpenDialog.Title := 'Add files';
 OpenDialog.Filter := AudioObjectPlayer.GetDialogFilter + '|All files|*.*';
  if not OpenDialog.Execute then Exit;
   for i := 0 to OpenDialog.Files.Count - 1 do
     AudioObjectPlayer.AddFile (OpenDialog.Files[i], AudioObjectPlayer.GetSongTitle(OpenDialog.Files[i]));
    DrawPlayList (100 - ListSlider.Position);
    ListTotal := AudioObjectPlayer.GetTotLegth;
end;

procedure TFormPlaylist.DeleteClick(Sender: TObject);
begin
 AudioObjectPlayer.DeleteItem(Clicked);
 DrawPlayList (100 - ListSlider.Position);
 ListTotal := AudioObjectPlayer.GetTotLegth;
end;

procedure TFormPlaylist.SaveClick(Sender: TObject);
begin
 SaveDialog.Title := 'Save list';
 SaveDialog.Filter := 'Playlist (*.pls)|*.pls';
 SaveDialog.FileName := 'New playlist 1';
  if not SaveDialog.Execute then Exit;
  if UpperCase(ExtractFilePath(SaveDialog.FileName)) <> '.PLS' then SaveDialog.FileName := SaveDialog.FileName + '.pls';
   AudioObjectPlayer.SavePls (SaveDialog.FileName);
end;

end.

unit equalyzer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, VsImage, VsSlider, VsControls, VsSkin, VsButtons, VsComposer,
  VsImageText, ExtCtrls, VsCheckBox, CommonTypes, AudioObject, Menus,
  OBMagnet;

type
  TFormEQ = class(TForm)
    VsComposer: TVsComposer;
    mainSkin: TVsSkin;
    VsButton1: TVsButton;
    VsButton2: TVsButton;
    Slide1: TVsSlider;
    ListSlBack: TVsImage;
    Slide2: TVsSlider;
    VsImage1: TVsImage;
    Slide3: TVsSlider;
    VsImage2: TVsImage;
    Slide4: TVsSlider;
    VsImage3: TVsImage;
    Slide5: TVsSlider;
    VsImage4: TVsImage;
    GainSlider: TVsSlider;
    VsImage5: TVsImage;
    EqOnCheck: TVsCheckBox;
    VsButton3: TVsButton;
    PrsetMenu: TPopupMenu;
    Load: TMenuItem;
    OpenDialog: TOpenDialog;
    Save: TMenuItem;
    SaveDialog: TSaveDialog;
    N1: TMenuItem;
    Reset: TMenuItem;
    EqGraph: TImage;
    OBFormMagnet1: TOBFormMagnet;
    procedure VsButton1Click(Sender: TObject);
    procedure VsButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GainSliderChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EqOnCheckClick(Sender: TObject);
    procedure VsButton3Click(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure ResetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEQ: TFormEQ;

implementation

uses main;

{$R *.dfm}

procedure TFormEQ.VsButton1Click(Sender: TObject);
begin
 Application.Minimize;
end;

procedure TFormEQ.VsButton2Click(Sender: TObject);
begin
 Close;
 FormPlayer.EQCheck.Checked := False;
end;

procedure TFormEQ.FormCreate(Sender: TObject);
begin
 FormEQ.Height := mainSkin.Height;
 FormEQ.Width := mainSkin.Width;
 FormEq.GainSliderChange(Nil);
end;

procedure TFormEQ.GainSliderChange(Sender: TObject);
 var cnt : Integer; EqParam : TEqPreset;
begin
{Drawing preset}
 cnt := VsComposer.Graphics.IndexByName('eqmain.bmp');
 with EqGraph do begin
  Canvas.Pen.Color := clBlack;
   Canvas.CopyRect(Rect(0, 0, Width, Height), VsComposer.Graphics[cnt].Bitmap.Canvas, Rect(Left, Top, Left + Width, Top + Height));
   Canvas.MoveTo(0, Height div 2);
   Canvas.LineTo(15, Height div 2 - Slide1.Position);
   Canvas.LineTo(30, Height div 2 - Slide2.Position);
   Canvas.LineTo(45, Height div 2 - Slide3.Position);
   Canvas.LineTo(60, Height div 2 - Slide4.Position);
   Canvas.LineTo(72, Height div 2 - Slide5.Position);
    cnt := Trunc((GainSlider.Position * 30/100) - 15);
    Canvas.Pen.Color := clSilver;
    Canvas.MoveTo(0, Height div 2 + cnt);
    Canvas.LineTo (Width, Height div 2 + cnt);
    Application.ProcessMessages;
  end;

  {Eq Values Update}
   EqParam[0] := Slide1.Position;
   EqParam[1] := Slide1.Position;
   EqParam[2] := Slide2.Position;
   EqParam[3] := Slide3.Position;
   EqParam[4] := Slide3.Position;
   EqParam[5] := Slide4.Position;
   EqParam[6] := Slide4.Position;
   EqParam[7] := Slide5.Position;
   EqParam[8] := Slide5.Position;
   EqParam[9] := Slide5.Position;
     AudioObjectPlayer.UpdateEq(EqParam);
     AudioObjectPlayer.SetGainVolume(GainSlider.Position);
end;

procedure TFormEQ.FormActivate(Sender: TObject);
begin
  GainSliderChange(Nil);
end;

procedure TFormEQ.EqOnCheckClick(Sender: TObject);
begin
 if EqOnCheck.Checked then
   AudioObjectPlayer.SetEqualizer
 else
   AudioObjectPlayer.ResetEqualizer;
end;

procedure TFormEQ.VsButton3Click(Sender: TObject);
 var Point : TPoint;
begin
 GetCursorPos(Point);
 PrsetMenu.Popup(Point.X, Point.Y);
end;

procedure TFormEQ.LoadClick(Sender: TObject);
  var cnt : Integer; EqParam : TEqPreset;
      PrstIni : TINIFile;
begin
 OpenDialog.Title := 'Load preset';
 OpenDialog.Filter := 'Preser (*.eq)|*.eq';
 if not OpenDialog.Execute then Exit;
   PrstIni := TINIFile.Create (OpenDialog.FileName);
      Slide1.Position := PrstIni.ReadInteger('Preset', 'Slider1', 0);
      Slide2.Position := PrstIni.ReadInteger('Preset', 'Slider2', 0);
      Slide3.Position := PrstIni.ReadInteger('Preset', 'Slider3', 0);
      Slide4.Position := PrstIni.ReadInteger('Preset', 'Slider4', 0);
      Slide5.Position := PrstIni.ReadInteger('Preset', 'Slider5', 0);
     GainSliderChange(Nil);
   PrstIni.Free;
end;

procedure TFormEQ.SaveClick(Sender: TObject);
  var cnt : Integer; EqParam : TEqPreset;
      PrstIni : TINIFile;
begin
 SaveDialog.Title := 'Save preset';
 SaveDialog.Filter := 'Preser (*.eq)|*.eq';
 if not SaveDialog.Execute then Exit;
  if UpperCase(ExtractFilePath(SaveDialog.FileName)) <> '.EQ' then SaveDialog.FileName := SaveDialog.FileName + '.eq';
   PrstIni := TINIFile.Create (SaveDialog.FileName);
       PrstIni.WriteInteger('Preset', 'Slider1', Slide1.Position);
       PrstIni.WriteInteger('Preset', 'Slider2', Slide2.Position);
       PrstIni.WriteInteger('Preset', 'Slider3', Slide3.Position);
       PrstIni.WriteInteger('Preset', 'Slider4', Slide4.Position);
       PrstIni.WriteInteger('Preset', 'Slider5', Slide5.Position);
   PrstIni.Free;
end;

procedure TFormEQ.ResetClick(Sender: TObject);
begin
  Slide1.Position := 0;
  Slide2.Position := 0;
  Slide3.Position := 0;
  Slide4.Position := 0;
  Slide5.Position := 0;
  GainSlider.Position := 0;
  GainSliderChange(Nil);
end;

end.

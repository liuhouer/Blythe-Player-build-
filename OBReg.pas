unit OBReg;

interface

uses
  Classes, DesignIntf, DesignEditors, Forms, Dialogs;

procedure Register;

implementation

uses OBCdUtils, OBCreateShortcut, OBDirectories, OBGammaPanel, OBMagnet,
     OBStarfield, OBThread, OBZoom, OBZlibMultiple, OBSearchFile,
     OBDragDrop, OBAssociateExtension, OBXPBarMenu, OBIQShine, OBWavePlayer,
     OBTimeLimit, OBAutoSizeCompo, OBInstances, OBFileStore, OBPictureStore,
     uAboutForm, OBSysInfo, OBFormButton;

type

  TAboutEditor = class(TStringProperty)
  public
    procedure Edit; override;
    function GetValue: String; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;
begin
  RegisterComponents('OBControl', [TOBXPBarMenu,TOBCdUtils, TOBCreateShortcut,
      TOBDirectories, TOBGammaPanel, TOBFormMagnet, TOBStarfield, TOBThread,
      TOBZoom, TOBZlibMultiple, TOBSearchFile, TOBDragDrop, TOBAssociateExtension,
      TOBIQShine, TOBWavePlayer, TOBTimeLimit, TOBAutoSizeCompo, TOBInstances,
      TOBFileStore, TOBPictureStore, TOBSysInfo, TOBFormButton]);

  RegisterPropertyEditor(TypeInfo(String),TOBFileStore,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBPictureStore,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBWavePlayer,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBAssociateExtension,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBAutoSizeCompo,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBCdUtils,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBCreateShortcut,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBDirectories,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBDragDrop,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBSearchFile,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBStarfield,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBThread,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBTimeLimit,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBWavePlayer,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBXPBarMenu,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBZlibMultiple,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBZoom,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBSysInfo,'About',TAboutEditor);
  RegisterPropertyEditor(TypeInfo(String),TOBFormButton,'About',TAboutEditor);
end;

{ TAboutEditor }

procedure TAboutEditor.Edit;
begin
  inherited;
  fAboutForm := TfAboutForm.Create(nil);
  try
    fAboutForm.ShowModal;
  finally
    fAboutForm.Free;
    fAboutForm := nil;
  end;
end;

function TAboutEditor.GetAttributes: TPropertyAttributes;
begin
  Result := Result + [paReadOnly, paDialog];
end;
                                          
function TAboutEditor.GetValue: String;
begin
  Result := '[About]';
end;

end.

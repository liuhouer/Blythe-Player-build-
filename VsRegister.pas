{***************************************************************************}
{ TMS Skin Factory                                                          }
{ for Delphi 4.0,5.0,6.0 & C++Builder 4.0,5.0                               }
{                                                                           }
{ Copyright 1996 - 2002 by TMS Software                                     }
{ Email : info@tmssoftware.com                                              }
{ Web : http://www.tmssoftware.com                                          }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit VsRegister;

{$I VSLIB.INC}

interface

uses
  Classes, VsClasses, VsPropEdit, VsComposer, VsGraphics,
  {$IFDEF VER140} DesignIntf, {$ELSE} DsgnIntf, {$ENDIF}
  VsGraphicsDlg, VsSkin, VsButtons, VsLabel, VsCheckBox, VsRadioButton,
  VsSlider, VsImage, VsProgressBar, VsLed, VsImageClip, VsImageText,
  VsClipRectDlg, VsHotSpot, VsAutoSaveDlg;

procedure Register;

implementation

{$R VSLIB.RES}

procedure Register;
begin
  RegisterComponents('TMS Skin Factory', [TVsComposer, TVsSkin,
    TVsImageClip, TVsButton, TVsLabel, TVsCheckBox, TVsRadioButton,
    TVsSlider, TVsImage, TVsProgressBar, TVsLed, TVsImageText,
    TVsHotSpot]);
  RegisterComponentEditor(TVsSkin, TVsSkinEditor);
  RegisterComponentEditor(TVsComposer, TVsComposerEditor);
  RegisterComponentEditor(TVsImageClip, TVsImageClipEditor);
  RegisterPropertyEditor(TypeInfo(TVsGraphics), TVsComposer, 'Graphics', TVsGraphicsProperty);
  RegisterPropertyEditor(TypeInfo(TVsGraphicName), nil, '', TVsFileNameProperty);
  RegisterPropertyEditor(TypeInfo(TVsClipRect), nil, '', TVsClipRectProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), TVsSkin, 'AutoSave', TVsAutoSaveProperty);
end;



end.

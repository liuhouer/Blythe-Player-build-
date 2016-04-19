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

unit VsPropEdit;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {$IFDEF VER140} DesignIntf,  DesignEditors; {$ELSE} DsgnIntf; {$ENDIF}

type
  TVsStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TVsFileNameProperty = class(TVsStringProperty)
  public
    procedure GetValueList(AList: TStrings); override;
  end;

  TVsClipRectProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TVsSkinEditor = class(TDefaultEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TVsImageClipEditor = class(TDefaultEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TVsGraphicsProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TVsComposerEditor = class(TDefaultEditor)
  protected
{$IFDEF VER140}
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
{$ELSE}
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
{$ENDIF}
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TVsAutoSaveProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;




implementation

uses
  VsClasses, VsSkin, VsImageClip, VsImageClipDlg, VsExportDlg, VsClipRectDlg,
  VsGraphics, VsGraphicsDlg, VsAutoSaveDlg;


{ TVsStringProperty }

function TVsStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TVsStringProperty.GetValueList(List: TStrings);
begin
end;

procedure TVsStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

procedure TVsFileNameProperty.GetValueList(AList: TStrings);
begin
  AList.Clear;
  if GetComponent(0) <> nil then
  begin
    if GetComponent(0) is TVsSkin then
    begin
      with GetComponent(0) as TVsSkin do
        GetGraphicNames(AList);
    end else
    if GetComponent(0) is TVsSkinGraphicControl then
      with GetComponent(0) as TVsSkinGraphicControl do
        GetGraphicNames(AList);
  end;
end;

{ TVsClipRectProperty }

procedure TVsClipRectProperty.Edit;
var
  ClipRect: TVsClipRect;
  Bitmap: TBitmap;
  Editor: TVsClipRectDialog;
  Res: TModalResult;
begin
  ClipRect := TVsClipRect(GetOrdValue);
  Bitmap := TBitmap.Create;
  try
    Editor := TVsClipRectDialog.Create(nil);
    try
      if GetComponent(0) <> nil then
        TVsSkinGraphicControl(GetComponent(0)).GetGraphicBitmap(Bitmap);
      Editor.SetClipRect(ClipRect);
      Editor.SetBitmap(Bitmap);
      Res := Editor.ShowModal;
      if Res = mrOk then
        Designer.Modified;
    finally
      Editor.Free;
    end;
  finally
    Bitmap.Free;
  end;
end;

function TVsClipRectProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paSubProperties];
end;


{ TVsSkinEditor }

procedure TVsSkinEditor.Edit;
var
  F: TVsExportDialog;
begin
  F := TVsExportDialog.Create(nil);
  try
    F.Skin := TVsSkin(Component);
    F.ShowModal;
    Designer.Modified;
  finally
    F.Free;
  end;
end;

function TVsSkinEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TVsSkinEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Open/Save Skin!'
  else Result := '';
end;

procedure TVsSkinEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;

{TVsImageClipEditor}

procedure TVsImageClipEditor.Edit;
var
  Dialog: TVsImageClipDialog;
  Comp: TVsImageClip;
begin
  Dialog := TVsImageClipDialog.Create(nil);
  try
    Comp := TVsImageClip(Component);
    Dialog.Image.Picture.Bitmap.Assign(Comp.Clip);
    Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

function TVsImageClipEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TVsImageClipEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Copy Image...'
  else Result := '';
end;

procedure TVsImageClipEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;

{ TVsGraphicsProperty }

function TVsGraphicsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog] - [paSubProperties];
end;

procedure TVsGraphicsProperty.Edit;
var
  List: TVsGraphics;
  ListEditor: TVsGraphicsDialog;
  Res: TModalResult;
begin
  List := TVsGraphics(GetOrdValue);
  ListEditor := TVsGraphicsDialog.Create(nil);
  try
    ListEditor.Graphics.Assign(List);
    Res := ListEditor.ShowModal;
    if Res = mrOk then
    begin
      List.Assign(ListEditor.Graphics);
      Designer.Modified;
    end;
  finally
    ListEditor.Free;
  end;
end;

{ TVsComposerEditor }

{$IFDEF VER140}
procedure TVsComposerEditor.EditProperty(const Prop: IProperty;
  var Continue: Boolean);
var
  PropName: string;
begin
  PropName := Prop.GetName;
  if (CompareText(PropName, 'Graphics') = 0) then
  begin
    Prop.Edit;
    Continue := False;
  end;
end;
{$ELSE}
procedure TVsComposerEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue, FreeEditor: Boolean);
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'Graphics') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;
{$ENDIF}

function TVsComposerEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TVsComposerEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Edit Graphics'
  else Result := '';
end;

procedure TVsComposerEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;

{ TVsAutoSaveProperty }

procedure TVsAutoSaveProperty.Edit;
var
  Strings: TStrings;
  Editor: TVsAutoSaveDialog;
begin
  Strings := TStrings(GetOrdValue);
  Editor := TVsAutoSaveDialog.Create(nil);
  try
    if Editor.Execute(TWinControl(GetComponent(0)), Strings) then
    begin
      Editor.GetControls(Strings);
      Designer.Modified;
    end;
  finally
    Editor.Free;
  end;
end;

function TVsAutoSaveProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;


end.

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

unit VsComposer;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsControls, VsGraphics;

type
  TVsComposer = class(TVsSharedComponent)
  private
    FGraphics: TVsGraphics;
    procedure SetGraphics(Value: TVsGraphics);
    procedure GraphicsChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetGraphicNames(List: TStrings);
    function GetGraphic(const Name: string): TVsGraphic;
  published
    property Graphics: TVsGraphics read FGraphics write SetGraphics;
  end;


implementation


{ TVsComposer }

constructor TVsComposer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGraphics := TVsGraphics.Create;
  FGraphics.OnChange := GraphicsChanged;
end;

destructor TVsComposer.Destroy;
begin
  FGraphics.Free;
  inherited Destroy;
end;

procedure TVsComposer.SetGraphics(Value: TVsGraphics);
begin
  FGraphics.Assign(Value);
end;

function TVsComposer.GetGraphic(const Name: string): TVsGraphic;
var
  Index: Integer;
begin
  Result := nil;
  Index := Graphics.IndexByName(Name);
  if Index <> -1 then Result := Graphics[Index];
end;

procedure TVsComposer.GetGraphicNames(List: TStrings);
var
  I: Integer;
begin
  List.Clear;
  for I := 0 to Graphics.Count - 1 do
    List.Add(Graphics[I].Name);
end;

procedure TVsComposer.GraphicsChanged(Sender: TObject);
begin
  NotifyClients;
end;



end.

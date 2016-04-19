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

unit VsControls;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsGraphics;

type
  TVsComponent = class(TComponent);

  TVsCustomControl = class(TCustomControl)
  protected
    function Designing: Boolean;
    function Loading: Boolean;
  end;

  TVsGraphicControl = class(TGraphicControl)
  protected
    function Designing: Boolean;
    function Loading: Boolean;
  end;

  TVsChangeLink = class;

  TVsSharedComponent = class(TVsComponent)
  private
    FClients: TList;
  protected
    procedure NotifyClients;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InsertLink(Value: TVsChangeLink);
    procedure RemoveLink(Value: TVsChangeLink);
  end;

  TVsChangeLink = class(TObject)
  private
    FSender: TVsSharedComponent;
    FOnChange: TNotifyEvent;
  public
    destructor Destroy; override;
    procedure Change; dynamic;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Sender: TVsSharedComponent read FSender write FSender;
  end;

  TVsPersistent = class(TPersistent)
  private
    FUpdateCount: Integer;
    FOnChange: TNotifyEvent;
  protected
    procedure Changed;
  public
    procedure BeginUpdate;
    procedure EndUpdate;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;



implementation


{ TVsCustomControl }

function TVsCustomControl.Designing: Boolean;
begin
  Result := (csDesigning in ComponentState);
end;

function TVsCustomControl.Loading: Boolean;
begin
  Result := (csLoading in ComponentState);
end;

{ TVsGraphicControl }

function TVsGraphicControl.Designing: Boolean;
begin
  Result := (csDesigning in ComponentState);
end;

function TVsGraphicControl.Loading: Boolean;
begin
  Result := (csLoading in ComponentState);
end;

{ TVsSharedComponent }

constructor TVsSharedComponent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClients := TList.Create;
end;

destructor TVsSharedComponent.Destroy;
begin
  while FClients.Count > 0 do
    RemoveLink(TVsChangeLink(FClients.Last));
  FClients.Free;
  inherited Destroy;
end;

procedure TVsSharedComponent.NotifyClients;
var
  I: Integer;
begin
  for I := 0 to FClients.Count - 1 do
    TVsChangeLink(FClients[I]).Change;
end;

procedure TVsSharedComponent.InsertLink(Value: TVsChangeLink);
begin
  Value.Sender := Self;
  FClients.Add(Value);
end;

procedure TVsSharedComponent.RemoveLink(Value: TVsChangeLink);
var
  I: Integer;
begin
  I := FClients.IndexOf(Value);
  if I <> -1 then
  begin
    Value.Sender := nil;
    FClients.Delete(I);
  end;
end;

{ TVsChangeLink }

destructor TVsChangeLink.Destroy;
begin
  if Sender <> nil then
    Sender.RemoveLink(Self);
  inherited Destroy;
end;

procedure TVsChangeLink.Change;
begin
  if Assigned(FOnChange) then FOnChange(Sender);
end;

{ TVsPersistent }

procedure TVsPersistent.Changed;
begin
  if FUpdateCount = 0 then
    if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TVsPersistent.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TVsPersistent.EndUpdate;
begin
  if FUpdateCount > 0 then Dec(FUpdateCount);
  Changed;
end;



end.

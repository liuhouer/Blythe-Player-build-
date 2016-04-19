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

unit VsImageClip;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VsControls, VsGraphics, VsSkin, VsSysUtils;

type
  TVsImageClip = class(TVsSkinGraphicControl)
  private
    FClip: TBitmap;
  protected
    procedure Paint; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property Clip: TBitmap read FClip;
  end;


implementation


{ TVsImageClip }

constructor TVsImageClip.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 50, 50);
  FClip := TBitmap.Create;
  FClip.PixelFormat := pf24bit;
end;

destructor TVsImageClip.Destroy;
begin
  FClip.Free;
  inherited Destroy;
end;

procedure TVsImageClip.Loaded;
begin
  inherited Loaded;
  Visible := Designing;
end;

procedure TVsImageClip.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if FClip <> nil then
  begin
    FClip.Width := AWidth;
    FClip.Height := AHeight;
  end;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TVsImageClip.Paint;
begin
  PaintBackImage;
  Skin.PaintGraphic(FClip.Canvas, BoundsRect);
  inherited Paint;
end;


end.

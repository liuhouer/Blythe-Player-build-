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

unit VsClasses;

{$I VSLIB.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;


type
  TVsGlyphInt = 1..99;

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

  TVsClipRect = class(TVsPersistent)
  private
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    function GetBoundsRect: TRect;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
    procedure SetBoundsRect(const Rect: TRect);
    procedure SetLeft(Value: Integer);
    procedure SetTop(Value: Integer);
    procedure SetWidth(Value: Integer);
    procedure SetHeight(Value: Integer);
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    property BoundsRect: TRect read GetBoundsRect write SetBoundsRect;
  published
    property Left: Integer read FLeft write SetLeft default 0;
    property Top: Integer read FTop write SetTop default 0;
    property Width: Integer read FWidth write SetWidth default 0;
    property Height: Integer read FHeight write SetHeight default 0;
  end;

  TVsOutlineRect = class(TVsPersistent)
  private
    FLeftWidth: Integer;
    FTopHeight: Integer;
    FRightWidth: Integer;
    FBottomHeight: Integer;
    procedure SetLeftWidth(Value: Integer);
    procedure SetTopHeight(Value: Integer);
    procedure SetRightWidth(Value: Integer);
    procedure SetBottomHeight(Value: Integer);
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property LeftWidth: Integer read FLeftWidth write SetLeftWidth default 1;
    property TopHeight: Integer read FTopHeight write SetTopHeight default 1;
    property RightWidth: Integer read FRightWidth write SetRightWidth default 1;
    property BottomHeight: Integer read FBottomHeight write SetBottomHeight default 1;
  end;


implementation

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

{ TVsClipRect }

constructor TVsClipRect.Create;
begin
  FLeft := 0;
  FTop := 0;
  FWidth := 0;
  FHeight := 0;
end;

procedure TVsClipRect.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (FLeft <> ALeft) or (FTop <> ATop) or
     (FWidth <> AWidth) or (FHeight <> AHeight) then
  begin
    FLeft := ALeft;
    FTop := ATop;
    FWidth := AWidth;
    FHeight := AHeight;
    Changed;
  end;
end;

procedure TVsClipRect.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TVsClipRect) then
  begin
    BeginUpdate;
    try
      Left := (Source as TVsClipRect).Left;
      Top := (Source as TVsClipRect).Top;
      Width := (Source as TVsClipRect).Width;
      Height := (Source as TVsClipRect).Height;
    finally
      EndUpdate;
    end;
  end;
  inherited Assign(Source);
end;

procedure TVsClipRect.SetLeft(Value: Integer);
begin
  SetBounds(Value, FTop, FWidth, FHeight);
end;

procedure TVsClipRect.SetTop(Value: Integer);
begin
  SetBounds(FLeft, Value, FWidth, FHeight);
end;

procedure TVsClipRect.SetWidth(Value: Integer);
begin
  SetBounds(FLeft, FTop, Value, FHeight);
end;

procedure TVsClipRect.SetHeight(Value: Integer);
begin
  SetBounds(FLeft, FTop, FWidth, Value);
end;

function TVsClipRect.GetBoundsRect: TRect;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Left + Width;
  Result.Bottom := Top + Height;
end;

procedure TVsClipRect.SetBoundsRect(const Rect: TRect);
begin
  with Rect do SetBounds(Left, Top, Right - Left, Bottom - Top);
end;

{ TVsOutlineRect }

constructor TVsOutlineRect.Create;
begin
  FLeftWidth := 1;
  FTopHeight := 1;
  FRightWidth := 1;
  FBottomHeight := 1;
end;

procedure TVsOutlineRect.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TVsClipRect) then
  begin
    BeginUpdate;
    try
      LeftWidth := (Source as TVsOutlineRect).LeftWidth;
      TopHeight := (Source as TVsOutlineRect).TopHeight;
      RightWidth := (Source as TVsOutlineRect).RightWidth;
      BottomHeight := (Source as TVsOutlineRect).BottomHeight;
    finally
      EndUpdate;
    end;
  end;
  inherited Assign(Source);
end;

procedure TVsOutlineRect.SetLeftWidth(Value: Integer);
begin
  if FLeftWidth <> Value then
  begin
    FLeftWidth := Value;
    Changed;
  end;
end;

procedure TVsOutlineRect.SetTopHeight(Value: Integer);
begin
  if FTopHeight <> Value then
  begin
    FTopHeight := Value;
    Changed;
  end;
end;

procedure TVsOutlineRect.SetRightWidth(Value: Integer);
begin
  if FRightWidth <> Value then
  begin
    FRightWidth := Value;
    Changed;
  end;
end;

procedure TVsOutlineRect.SetBottomHeight(Value: Integer);
begin
  if FBottomHeight <> Value then
  begin
    FBottomHeight := Value;
    Changed;
  end;
end;



end.

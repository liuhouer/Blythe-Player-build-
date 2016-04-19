{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBZoom;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, extctrls;

type
  TOBZoom = class(TWinControl)
  private
    FTimer:TTimer;
    FActive: boolean;
    FZoom: Integer;
    FDelay: cardinal;
    FZCanvas:TControlCanvas;
    FCanvas:TCanvas;
    Flastpoint:tpoint;
    FAbout: String;
    procedure PaintMe(Sender: TObject);
    procedure SetActive(const Value: boolean);
    procedure SetDelay(const Value: cardinal);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    property About : String read FAbout write FAbout;
    property Active:boolean read FActive write SetActive default true;
    property ZoomLevel:Integer read FZoom write FZoom default 100;
    property Delay:cardinal read FDelay write SetDelay default 100;
    property OnMouseDown;
    property OnClick;
    property OnDblClick;
    property OnMouseUp;
    property OnResize;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;
    property OnMouseWheel;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
  end;

implementation

constructor TOBZoom.Create(AOwner: TComponent);
begin
   inherited;
   self.height:=100;
   self.width:=100;
   FDelay:=100;
   FZoom:=100;
   FActive:=true;

   //Create canvas to write to the control
   FZCanvas:=TControlCanvas.Create;
   FZCanvas.Control:=self;

   //Create the canvas to retrieve informations
   FCanvas:=TCanvas.Create;
   FCanvas.Handle:=GetDC(0);

   Ftimer:=TTimer.Create(self);
   FTimer.OnTimer:=PaintMe;
   FTimer.Interval:=100;

   //Assign the parent, or it's impossible to draw on it
   self.parent:=TWinControl(AOwner);

   FTimer.enabled:=true;
end;

destructor TOBZoom.Destroy;
begin
   ReleaseDc(0,FCanvas.handle);
   FCanvas.free;
   FZCanvas.free;
   inherited;
end;

procedure TOBZoom.PaintMe(Sender: TObject);
var
  p:Tpoint;
  x,y:Integer;
  t:Trect;
begin
   GetCursorPos(p);
   //Only draw if on a different position
   if (p.x<>FLastPoint.x)or(p.y<>FLastPoint.y) then
   begin
      //if it's the first time, get the DC of the control to be able
      //to draw on it.
      if FTimer.tag=0 then
      begin
         try
            FZCanvas.Handle:=GetDc(self.handle);
         except
            exit;
         end;
         FTimer.tag:=1;
      end;

      //Analyse the point
      FLastPoint:=p;
      //Create the area to Copy
      x:=(self.width div 2)*Fzoom div 100;
      y:=(self.height div 2)*FZoom div 100;
      if p.x<x then p.x:=x
      else if p.x+x>screen.width then p.x:=screen.width-x;
      if p.y<y then p.y:=y
      else if p.y+y>screen.height then p.y:=screen.height-y;
      t.Left:=p.x-x;
      t.Top:=p.y-y;
      t.Right:=p.x+x;
      t.bottom:=p.y+y;

      //Draw the area around the mouse
      FZCanvas.CopyRect(rect(0,0,self.width,self.height),Fcanvas,t);
   end;
end;

procedure TOBZoom.SetActive(const Value: boolean);
begin
   FActive := Value;
   FTimer.Enabled:=Value;
end;

procedure TOBZoom.SetDelay(const Value: cardinal);
begin
   FDelay := Value;
   Ftimer.Interval:=Value;
end;

procedure TOBZoom.WMSize(var Message: TWMSize);
begin
   //On resize, refresh it
   inherited;
   PaintMe(self);
end;

end.


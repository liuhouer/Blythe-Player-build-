{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBStarfield;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls;

type
  TStars = record
       X,Y:Integer;
       Color:TColor;
       Speed:Integer;
  end;
  
  TOBStarfieldThread = class(TThread)
  private
    FTag: Integer;
  protected
    procedure Draw;
    procedure Execute; override;
  public
    FDelay:cardinal;
    FOnDraw:TNotifyEvent;
    property Tag:Integer read FTag write FTag;
  end;

  TOBStarfield = class(TGraphicControl)
  private
    FStarfield : array of TStars;
    Ftimer:TOBStarfieldThread;
    FActive: boolean;
    FDelay: cardinal;
    FStars: word;
    FMaxSpeed: byte;
    FBmp:TBitmap;
    FAbout: String;
    procedure Refresh(Sender: TObject);
    procedure SetActive(const Value: boolean);
    procedure SetDelay(const Value: cardinal);
    procedure SetStars(const Value: word);
  protected
  public
    procedure Resize;override;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    property About : String read FAbout write FAbout;
    property Align;
    property Delay:cardinal read FDelay write SetDelay default 50;
    property Active:boolean read FActive write SetActive default false;
    property Stars:word read FStars write SetStars default 100;
    property MaxSpeed:byte read FMaxSpeed write FMaxSpeed default 10;
    property OnMouseDown;
  end;

implementation

constructor TOBStarfield.Create(AOwner: TComponent);
begin
   inherited;
   Randomize;

   FDelay:=50;
   FActive:=false;
   FBmp:=TBitmap.Create;

   FTimer:=TOBStarfieldThread.Create(true);
   FTimer.FreeOnTerminate:=true;
   FTimer.FDelay:=50;
   FTimer.FOnDraw:=Refresh;
   self.width:=100;
   self.height:=100;
   FMaxSpeed:=10;

   SetStars(100);
end;

procedure TOBStarfield.Resize;
begin
   inherited;
   FBmp.Width:=self.width;
   FBmp.Height:=self.height;
   SetStars(FStars);
end;

procedure TOBStarfield.SetStars(const Value: word);
var
  i,j:Integer;
begin
   FStars := Value;

   SetLength(FStarfield,Value);
   for i:=0 to FStars-1 do
   begin
      FStarfield[i].X:=random(self.width div 2)+self.width;
      FStarfield[i].Y:=random(self.height);
      FStarfield[i].Speed:=random(FMaxSpeed)+1;
      j:=random(120)+120;
      FStarfield[i].Color:=RGB(j,j,j);
   end;
end;

destructor TOBStarfield.Destroy;
begin
   SetLength(FStarfield,0);
   FTimer.Terminate;
   FBmp.free;
   inherited;
end;

procedure TOBStarfield.Refresh(Sender: TObject);
var
   i,j:Integer;
begin
   if (FBmp.Height<>self.Height) or (FBmp.Width<>self.Width) then
      Resize
   else
   begin
      FBmp.canvas.brush.Color:=clblack;
      FBmp.canvas.brush.style:=bsSolid;
      FBmp.canvas.FillRect(Rect(0,0,width,height));
      for i:=0 to FStars-1 do
      begin
         if FStarfield[i].x<self.width then
           FBmp.canvas.Pixels[Fstarfield[i].x,FStarfield[i].y]:=FStarfield[i].Color;
         FStarfield[i].X:=FStarfield[i].X-FStarfield[i].Speed;
         if FStarfield[i].x<0 then
         begin
            FStarfield[i].x:=width;
            FStarfield[i].y:=random(height);
            FStarfield[i].speed:=random(FMaxSpeed)+1;
            j:=random(120)+120;
            FStarfield[i].Color:=RGB(j,j,j);
         end;
      end;
      self.canvas.Draw(0,0,FBmp)
   end;
end;

procedure TOBStarfield.SetActive(const Value: boolean);
begin
   FActive := Value;
   if not(csDesigning in ComponentState) then
      if FActive then
         FTimer.Resume
      else
         FTimer.Suspend;
end;

procedure TOBStarfield.SetDelay(const Value: cardinal);
begin
   FDelay := Value;
   FTimer.FDelay:=Value;
end;

///////////////////////////////////////////////////////////
// TOBStarfieldThread
///////////////////////////////////////////////////////////

procedure TOBStarfieldThread.Draw;
begin
   if Assigned(FonDraw) then
      FOnDraw(self);
end;

procedure TOBStarfieldThread.Execute;
begin
   while not(terminated) do
   begin
      Synchronize(Draw);
      Sleep(FDelay);
   end;
end;

end.

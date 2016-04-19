unit OBIQShine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  ExtCtrls, Forms; 

type
  TShinePos = (spLeftTop, spLeftBottom, spRightTop, spRightBottom);

  TOBIQShine = class(TComponent)
  private
    { Private declarations }
    AnimTimer : TTimer;
    FrameNR   : integer;
    tmpBmp    : TBitmap;
    FControl  : TControl;
    SaveBmp   : TBitmap;
    FPos      : TShinePos;
    DC        : hDC;
    LPoint    : Tpoint;
    FActive   : Boolean;
    procedure TakeImageBitmap;
    procedure SetActive(Value : boolean);
    function  GetActive : boolean;
  protected
    { Protected declarations }
    procedure TimerTick(Sender : TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetControl(aValue : TControl);
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure   Execute;
  published
    { Published declarations }
    property Control : TControl read FControl write SetControl;
    property Position : TShinePos read FPos write FPos;
    property Active : boolean read GetActive write SetActive stored false;
  end;

implementation

{$R OBIQSPLASH.RES}

constructor TOBIQShine.Create(AOwner : TComponent);
begin
 inherited;
 AnimTimer:=TTimer.Create(Self);
 AnimTimer.Interval:=200;
 AnimTimer.OnTimer:=TimerTick;
 AnimTimer.Enabled:=False;
 FrameNr := 0;
 SaveBmp := TBitMap.Create;
 SaveBmp.Width := 20;
 SaveBmp.Height:= 28;
 FActive := False;
end;

destructor TOBIQShine.Destroy;
begin
 AnimTimer.Free;
 SaveBmp.Free;
 inherited;
end;

procedure TOBIQShine.SetActive(Value : boolean);
begin
  FActive := Value;
  Execute;
end;

function TOBIQShine.GetActive : boolean;
begin
  Result := AnimTimer.Enabled; 
end;

procedure TOBIQShine.Execute;
begin
  if AnimTimer.Enabled then
  begin
    Exit;
  end;
  if Assigned(FControl) then
  begin
    TakeImageBitmap;
    AnimTimer.Enabled := true;
  end;
end;

procedure TOBIQShine.TimerTick(Sender : TObject);
begin
  inc(FrameNr);
  DC := GetDC(0);
  BitBlt(DC,LPoint.X - 10, LPoint.Y - 14, 20,28,SaveBmp.Canvas.Handle,0,0,SrcCopy);
  ReleaseDC(0, DC);
  if FrameNr = 9 then
  begin
    FrameNr := 0;
    if not FActive then AnimTimer.Enabled := False;
    Exit;
  end;
  tmpBmp := TBitMap.Create;
  tmpBmp.Transparent := true;
  tmpBmp.Width := 20;
  tmpBmp.Height:= 28;
  tmpBmp.Handle := LoadBitmap(hInstance, PChar('SPARK_'+IntToStr(FrameNr)) );
  DC := GetDC(0);
  BitBlt(DC,LPoint.X - 10, LPoint.Y - 14, 20,28,tmpBmp.Canvas.Handle,0,0,SrcPAINT);
  ReleaseDC(0, DC);
  tmpBmp.Free;
end;

procedure TOBIQShine.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FControl) then
    FControl := nil;
end;

procedure TOBIQShine.SetControl(aValue : TControl);
begin
  if FControl <> aValue then
  begin
    if aValue <> nil then aValue.FreeNotification(Self);
    FControl := aValue;
  end;
end;

procedure TOBIQShine.TakeImageBitmap;
begin
  DC := GetDC(0);
  case FPos of
    spLeftTop     : LPoint := FControl.ClientToScreen(point(0,0));
    spLeftBottom  : LPoint := FControl.ClientToScreen(point(0,FControl.Height));
    spRightTop    : LPoint := FControl.ClientToScreen(point(FControl.Width,0));
    spRightBottom : LPoint := FControl.ClientToScreen(point(FControl.Width,FControl.Height));
  end;

  BitBlt(SaveBmp.Canvas.Handle, 0, 0,
         20, 28, DC, LPoint.X - 10, LPoint.Y - 14, SrcCopy);
  ReleaseDC(0, DC);
end;

end.

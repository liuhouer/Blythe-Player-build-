{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBFormButton;

{$ObjExportAll On}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, 
  Menus;

type
  TSystemGlyph = (sgNone, sgBtnCorners, sgBtSize, sgCheck, sgCheckBoxes, sgClose,
                  sgCombo, sgDnArrow, sgDnArrowD, sgDnArrowI, sgLfArrow, sgLfArrowD,
                  sgLfArrowI, sgMnArrow, sgOldClose, sgOldDnArrow, sgOldLfArrow, sgOldReduce,
                  sgOldRestore, sgOldRgArrow, sgOldUpArrow, sgOldZoom, sgReduce, sgReduced,
                  sgRestore, sgRestored, sgRgArrow, sgRgArrowD, sgRgArrowI, sgSize, sgUpArrow,
                  sgUpArrowD, sgUpArrowI, sgZoom, sgZommD);

  TOBFormButton = class(TComponent)
  private
    FAbout : String;
    FGlyph: TBitmap;
    FOnClick: TNotifyEvent;
    FForm: TCustomForm;
    FOldWndProc: Pointer;
    FRect: TRect;
    FDown,FButtonDown,FVisible: boolean;
    FRight: cardinal;
    FDownMenu: TPopupMenu;
    FPopup: TPopupMenu;
    FSystemGlyph: TSystemGlyph;
    FLastPosition: TRect;
    procedure SetGlyph(const Value: TBitmap);
    procedure SetVisible(const Value: boolean);
    procedure NewWndProc(var message:TMessage);
    procedure PaintIt(Pushed:boolean);
    procedure SetRight(const Value: cardinal);
    procedure SetSystemGlyph(const Value: TSystemGlyph);
  protected
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    property About : String read FAbout write FAbout;
    property Glyph:TBitmap read FGlyph write SetGlyph;
    property Visible:boolean read FVisible write SetVisible default false;
    property RightMargin:cardinal read FRight write SetRight default 100;
    property PopupMenu:TPopupMenu read FPopup write FPopup;
    property DropDownMenu:TPopupMenu read FDownMenu write FDownMenu;
    property SystemGlyph:TSystemGlyph read FSystemGlyph write SetSystemGlyph default sgNone;
    property OnClick:TNotifyEvent read FOnClick write FOnClick;
  end;

implementation

type
  TSystGlyphOBM = record
    SystemGlyph: TSystemGlyph;
    SystemValue: Integer;
  end;

const
  Jv_PUSHED = 666;

  Glyphs: array[0..33] of TSystGlyphOBM = (
      (SystemGlyph:sgCheckBoxes ;SystemValue:OBM_CHECKBOXES),
      (SystemGlyph:sgClose      ;SystemValue:OBM_CLOSE),
      (SystemGlyph:sgCombo      ;SystemValue:OBM_COMBO),
      (SystemGlyph:sgDnArrow    ;SystemValue:OBM_DNARROW),
      (SystemGlyph:sgDnArrowD   ;SystemValue:OBM_DNARROWD),
      (SystemGlyph:sgDnArrowI   ;SystemValue:OBM_DNARROWI),
      (SystemGlyph:sgLfArrow    ;SystemValue:OBM_LFARROW),
      (SystemGlyph:sgLfArrowD   ;SystemValue:OBM_LFARROWD),
      (SystemGlyph:sgLfArrowI   ;SystemValue:OBM_LFARROWI),
      (SystemGlyph:sgMnArrow    ;SystemValue:OBM_MNARROW),
      (SystemGlyph:sgOldClose   ;SystemValue:OBM_OLD_CLOSE),
      (SystemGlyph:sgOldDnArrow ;SystemValue:OBM_OLD_DNARROW),
      (SystemGlyph:sgOldLfArrow ;SystemValue:OBM_OLD_LFARROW),
      (SystemGlyph:sgOldReduce  ;SystemValue:OBM_OLD_REDUCE),
      (SystemGlyph:sgOldZoom    ;SystemValue:OBM_OLD_ZOOM),
      (SystemGlyph:sgReduce     ;SystemValue:OBM_REDUCE),
      (SystemGlyph:sgReduced    ;SystemValue:OBM_REDUCED),
      (SystemGlyph:sgRestore    ;SystemValue:OBM_RESTORE),
      (SystemGlyph:sgRestored   ;SystemValue:OBM_RESTORED),
      (SystemGlyph:sgRgArrow    ;SystemValue:OBM_RGARROW),
      (SystemGlyph:sgRgArrowD   ;SystemValue:OBM_RGARROWD),
      (SystemGlyph:sgRgArrowI   ;SystemValue:OBM_RGARROWI),
      (SystemGlyph:sgSize       ;SystemValue:OBM_SIZE),
      (SystemGlyph:sgUpArrow    ;SystemValue:OBM_UPARROW),
      (SystemGlyph:sgUpArrowD   ;SystemValue:OBM_UPARROWD),
      (SystemGlyph:sgUpArrowI   ;SystemValue:OBM_UPARROWI),
      (SystemGlyph:sgZoom       ;SystemValue:OBM_ZOOM),
      (SystemGlyph:sgZommD      ;SystemValue:OBM_ZOOMD),
      (SystemGlyph:sgBtnCorners ;SystemValue:OBM_BTNCORNERS),
      (SystemGlyph:sgBtSize     ;SystemValue:OBM_BTSIZE),
      (SystemGlyph:sgCheck      ;SystemValue:OBM_CHECK),
      (SystemGlyph:sgOldRestore ;SystemValue:OBM_OLD_RESTORE),
      (SystemGlyph:sgOldRgArrow ;SystemValue:OBM_OLD_RGARROW),
      (SystemGlyph:sgOldUpArrow ;SystemValue:OBM_OLD_UPARROW));

constructor TOBFormButton.Create(AOwner: TComponent);
var
 ptr: pointer;
begin
  inherited;
  FForm := GetParentForm(TControl(AOwner));
  FGlyph := TBitmap.Create;
  FVisible := false;
  FRight := 100;
  FButtonDown := false;
  FDown := false;
  FSystemGlyph := sgNone;

  FOldWndProc := Pointer(GetWindowLong(FForm.Handle,GWL_WNDPROC));
  ptr := MakeObjectInstance(NewWndProc);
  SetWindowLong(FForm.Handle, GWL_WNDPROC, Longint(ptr));
end;

destructor TOBFormButton.Destroy;
begin
  if not (csDestroying in FForm.ComponentState) then
  begin
    SetVisible(false);
    SetWindowLong(FForm.Handle, GWL_WNDPROC, LongInt(FOldWndProc));
  end;
  FGlyph.Free;
  inherited;
end;

procedure TOBFormButton.NewWndProc(var message: TMessage);
var
 p: TPoint;

 function HitButton(Point: TPoint): Boolean;
 begin
   Point.x := Point.x-FForm.Left;
   Point.y := Point.y-FForm.Top;
   result := (Point.x>=FLastPosition.Left) and (Point.x<=FLastPosition.Right) and
     (Point.y>=FLastPosition.Top) and (Point.y<=FLastPosition.Bottom);
 end;

begin
  with message do
  begin
    if FVisible then
    begin
       case Msg of
          WM_NCPAINT , WM_NCACTIVATE  :
            begin
              Result := CallWindowProc(FOldWndProc,FForm.Handle,Msg,WParam,LParam);
              PaintIt(False);
            end;
          WM_NCHITTEST:
            begin
              Result := CallWindowProc(FOldWndProc,FForm.Handle,Msg,WParam,LParam);
              if Result=HTCAPTION then
              begin
                p.x := LoWord(LParam);
                ScreenToClient(FForm.Handle,p);
                if (p.x>=FRect.Left)and(p.x<=FRect.Right) then
                begin
                  if not(FDown) then
                    PaintIt(FButtonDown);
                  result := Jv_PUSHED;
                end
                else
                  if not(FDOwn) then
                    PaintIt(false);
              end
              else
                if not(FDown) then
                  PaintIt(False);
           end;
          WM_NCLBUTTONDOWN,WM_NCLBUTTONDBLCLK:
            begin
              Result := CallWindowProc(FOldWndProc,FForm.Handle,Msg,WParam,LParam);
              if not HitButton(Point((TWMNCLButtonDown(message)).XCursor,
                 (TWMNCLButtonDown(message)).YCursor)) then
                Exit;
              FDown := true;
              if WParam=Jv_PUSHED then
              begin
                PaintIt(True);
                if not(FButtonDown) then
                begin
                  if FDownMenu<>nil then
                  begin
                    p.x := FForm.Left+FRect.Left;
                    p.y := FForm.Top+FRect.Bottom;
                    FDownMenu.Popup(p.x+5,p.y+6);
                  end
                  else
                  begin
                    FButtonDown := true;
                    SetCapture(FForm.Handle);
                  end;
                end;
              end
              else
              begin
                PaintIt(false);
                if (FButtonDown) then
                begin
                  FButtonDown := False;
                  ReleaseCapture;
                end;
              end;
              FDown := false;
            end;
          WM_NCRBUTTONDOWN,WM_NCRBUTTONDBLCLK:
            begin
              if WParam=Jv_PUSHED then
              begin
                if FPopup<>nil then
                begin
                  p.x := FForm.Left+FRect.Left;
                  p.y := FForm.Top+FRect.Bottom;
                  FPopup.Popup(p.x+5,p.y+6);
                end;
              end
              else
                Result := CallWindowProc(FOldWndProc,FForm.Handle,Msg,WParam,LParam);
            end;
          WM_NCLBUTTONUP,WM_LBUTTONUP :
            begin
              Result := CallWindowProc(FOldWndProc,FForm.Handle,Msg,WParam,LParam);
              if FButtonDown then
              begin
                FButtonDown := false;
                ReleaseCapture;
                if Assigned(FOnClick) then
                   FOnClick(self);
              end;
              PaintIt(False);
            end;
          else
            Result := CallWindowProc(FOldWndProc,FForm.Handle,Msg,WParam,LParam);
       end;
    end
    else
      Result := CallWindowProc(FOldWndProc,FForm.Handle,Msg,WParam,LParam);
  end;
end;

procedure TOBFormButton.PaintIt(Pushed: boolean);
var
 r: TRect;
 x,y,x2,y2: Integer;
 FDec: byte;
begin
  if not(FVisible) then
    Exit;
  with TCanvas.Create do
    try
      Handle := GetWindowDC(FForm.Handle);
      GetWindowRect(FForm.Handle,r);
      R.Right := R.Right-R.Left;

      case FForm.Borderstyle of
        bsSingle      : y2 := GetSystemMetrics(SM_CYFRAME)+1;
        bsDialog      : y2 := GetSystemMetrics(SM_CYBORDER)+4;
        bsSizeToolWin : y2 := GetSystemMetrics(SM_CYSIZEFRAME)+2;
        bsToolWindow  : y2 := GetSystemMetrics(SM_CYBORDER)+4;
        else            y2 := GetSystemMetrics(SM_CYFRAME)+2;
      end;
      x2 := R.Right-integer(RightMargin)-y2;

      if (FForm.Borderstyle in [bsSizeToolWin,bsToolWindow]) then
      begin
        x := GetSystemMetrics(SM_CXSMSIZE)-5;
        y := GetSystemMetrics(SM_CYSMCAPTION)-8;
      end
      else
      begin
        x := GetSystemMetrics(SM_CXSIZE)-5;
        y := GetSystemMetrics(SM_CYCAPTION)-8;
      end;

      with FRect do
      begin
        Left := x2-y2;
        Top := y2;
        Right := Left+x+3;
        Bottom := y+2;
      end;

      if FButtonDown then
        Pen.Color := clBlack
      else
        Pen.Color := clBtnHighLight;
      MoveTo(x2,y2+y+1);
      LineTo(x2,y2);
      LineTo(x2+x+3,y2);
      if FButtonDown then
        Pen.Color := clBtnHighlight
      else
        Pen.Color := clBlack;
      MoveTo(x2, y2 + y + 2);
      LineTo(x2+x+2,y2+y+2);
      LineTo(x2+x+2,y2-1);
      Pen.Color := clGray;
      if FButtonDown then
      begin
        MoveTo(x2 + x, y2 + 1);
        LineTo(x2 + 1, y2 + 1);
        LineTo(x2 + 1, y2 + y + 1);
        Pen.Color := clSilver;
        MoveTo(x2 + x + 1, y2 + 1);
        LineTo(x2 + x + 1, y2 + y + 1);
        LineTo(x2, y2 + y + 1);
        FDec := 2;
      end
      else
      begin
        MoveTo(x2 + x + 1, y2 + 1);
        LineTo(x2 + x + 1, y2 + y + 1);
        LineTo(x2, y2 + y + 1);
        FDec := 1;
      end;

      FLastPosition.Left := X2+FDec;
      FLastPosition.Right := FLastPosition.Left + x;
      FLastPosition.Top := y2+FDec;
      FLastPosition.Bottom := FLastPosition.Top + y;

      StretchBlt(Handle,X2+FDec,y2+FDec,x,y,FGlyph.Canvas.Handle,0,0,FGlyph.Width,
        FGlyph.Height,srcCopy);
      ReleaseDC(FForm.Handle,Handle);
    finally
      Free;
    end;
end;

procedure TOBFormButton.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  SendMessage(FForm.Handle,WM_NCACTIVATE,0,0);
end;

procedure TOBFormButton.SetRight(const Value: cardinal);
begin
  FRight := Value;
  SendMessage(FForm.Handle,WM_NCACTIVATE,0,0);
end;

procedure TOBFormButton.SetSystemGlyph(const Value: TSystemGlyph);
var
 i: Integer;
begin
  FSystemGlyph := Value;
  for i:=0 to 30 do
    if Glyphs[i].SystemGlyph = Value then
    begin
      Glyph.Handle := LoadBitmap(0,PChar(Glyphs[i].SystemValue));
      Exit;
    end;
  SendMessage(FForm.Handle,WM_NCACTIVATE,0,0);
end;

procedure TOBFormButton.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  SendMessage(FForm.Handle,WM_NCACTIVATE,0,0);
end;

end.

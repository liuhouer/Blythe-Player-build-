{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBMagnet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TOBFormMagnet = class(TComponent)
  private
    FForm:TForm;
    FOldWndProc:Pointer;
    FActive: boolean;
    FScreen: boolean;
    FGlue: boolean;
    FArea: cardinal;
    FFormMagnet: boolean;
    FLastRightDock, FLastLeftDock, FLastTopDock, FLastBottomDock: TDateTime;
    procedure NewWndProc(Var Msg:TMessage);
    procedure MagnetScreen(OldRect:TRect;var FormRect:TRect;ScreenRect:TRect);
    procedure GlueForms(var FormRect:TRect);
    procedure MagnetToMain(OldRect: TRect; var FormRect: TRect;
      MainRect: TRect);
  protected
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    property Active:boolean read FActive write FActive default false;
    property ScreenMagnet:boolean read FScreen write FScreen default true;
    property Area:cardinal read FArea write FArea default 15;
    property FormGlue:boolean read FGlue write FGlue default true;
    property MainFormMagnet:boolean read FFormMagnet write FFormMagnet default false;
  end;


implementation

constructor TOBFormMagnet.Create(AOwner: TComponent);
var
 ptr:pointer;
begin
  inherited;
  FActive := false;
  FScreen := true;
  FArea := 15;
  FGlue := true;
  FFormMagnet := false;

  FLastRightDock := 0.0;
  FLastLeftDock := 0.0;
  FLastTopDock := 0.0;
  FLastBottomDock := 0.0;

  FForm := TForm(GetParentForm(TControl(AOwner)));
  if not(csDesigning in ComponentState) then
  begin
    FOldWndProc := Pointer(GetWindowLong(FForm.Handle,GWL_WNDPROC));
    ptr := MakeObjectInstance(NewWndProc);
    SetWindowLong(FForm.Handle, GWL_WNDPROC, Longint(ptr));
  end;
end;

destructor TOBFormMagnet.Destroy;
begin
  if not(csDesigning in ComponentState) then
    if not(csDestroying in FForm.ComponentState) then
      SetWindowLong(FForm.Handle, GWL_WNDPROC, LongInt(FOldWndProc));
  inherited;
end;

procedure TOBFormMagnet.MagnetScreen(OldRect:TRect;var FormRect:TRect;ScreenRect:TRect);
var
 FormWidth,FormHeight: Integer;

 function MovingToLeft:boolean;
 begin
   result := OldRect.Left>FormRect.Left;
 end;

 function MovingToRight:boolean;
 begin
    result:=OldRect.Left<FormRect.Left;
 end;

 function MovingToTop:boolean;
 begin
    result:=OldRect.Top>FormRect.Top;
 end;

 function MovingToBottom:boolean;
 begin
    result:=OldRect.Top<FormRect.Top;
 end;

 function OkeyForAll(var Value:TDateTime):boolean;
 begin
    if abs(Value-Now)>EncodeTime(0,0,0,250) then
       result:=true
    else
       result:=false;
 end;

 function OkeyForRight:boolean;
 begin
    result:=OkeyForall(FLastRightDock);
 end;

 function OkeyForLeft:boolean;
 begin
    result:=OkeyForall(FLastLeftDock);
 end;

 function OkeyForTop:boolean;
 begin
    result:=OkeyForall(FLastTopDock);
 end;

 function OkeyForBottom:boolean;
 begin
    result:=OkeyForall(FLastBottomDock);
 end;

 procedure DockOnLeft;
 begin
    FormRect.Left:=ScreenRect.Left;
    FormRect.Right:=FormRect.Left+FormWidth;
    FLastLeftDock:=now;
 end;

 procedure UndockOnLeftOutside;
 begin
    FormRect.Left:=ScreenRect.Left-integer(FArea);
    FormRect.Right:=FormRect.Left+FormWidth;
    FLastLeftDock:=now;
 end;

 procedure UndockOnLeftInside;
 begin
    FormRect.Left:=ScreenRect.Left+integer(FArea);
    FormRect.Right:=FormRect.Left+FormWidth;
    FLastLeftDock:=now;
 end;

 procedure DockOnRight;
 begin
    FormRect.Left:=ScreenRect.Right-FormWidth;
    FormRect.Right:=ScreenRect.Right;
    FLastRightDock:=now;
 end;

 procedure UndockOnRightOutside;
 begin
    FormRect.Left:=ScreenRect.Right-FormWidth+integer(FArea);
    FormRect.Right:=ScreenRect.Right+integer(FArea);
    FLastRightDock:=now;
 end;

 procedure UndockOnRightInside;
 begin
    FormRect.Left:=ScreenRect.Right-FormWidth-integer(FArea);
    FormRect.Right:=ScreenRect.Right-integer(FArea);
    FLastRightDock:=now;
 end;

 procedure DockOnTop;
 begin
    FormRect.Top:=ScreenRect.Top;
    FormRect.Bottom:=FormRect.Top+FormHeight;
    FLastTopDock:=now;
 end;

 procedure UndockOnTopOutside;
 begin
    FormRect.Top:=ScreenRect.Top-integer(FArea);
    FormRect.Bottom:=FormRect.Top+FormHeight;
    FLastTopDock:=now;
 end;

 procedure UndockOnTopInside;
 begin
    FormRect.Top:=ScreenRect.Top+integer(FArea);
    FormRect.Bottom:=FormRect.Top+FormHeight;
    FLastTopDock:=now;
 end;

 procedure DockOnBottom;
 begin
    FormRect.Top:=ScreenRect.Bottom-FormHeight;
    FormRect.Bottom:=ScreenRect.Bottom;
    FLastBottomDock:=now;
 end;

 procedure UndockOnBottomInside;
 begin
    FormRect.Top:=ScreenRect.Bottom-FormHeight-integer(FArea);
    FormRect.Bottom:=ScreenRect.Bottom-integer(FArea);
    FLastBottomDock:=now;
 end;

 procedure UndockOnBottomOutside;
 begin
    FormRect.Top:=ScreenRect.Bottom-FormHeight+integer(FArea);
    FormRect.Bottom:=ScreenRect.Bottom+integer(FArea);
    FLastBottomDock:=now;
 end;

begin
  FormWidth:=FormRect.Right-FormRect.Left;
  FormHeight:=FormRect.Bottom-FormRect.Top;

  //Magnet/UnMagnet Lleft, Magnet/UnMagnet Right
  if (MovingToLeft) then
     if (OkeyForLeft) then
     begin
        if (((FormRect.Left-ScreenRect.Left) in [2..FArea]))or
           (((abs(FormRect.Left-ScreenRect.Left))=1)) then
           DockOnLeft
        else if ((abs(FormRect.Left-ScreenRect.Left)) in [2..FArea]) then
           UndockOnLeftOutside
        else if ((ScreenRect.Right-FormRect.Right) in [2..FArea]) then
           UndockOnRightInside
        else if (abs(ScreenRect.Right-FormRect.Right) in [1..FArea]) then
           DockOnRight;
     end
     else
       if ((abs(FormRect.Left-ScreenRect.Left))<integer(FArea)) then
           DockOnLeft
       else if (abs(ScreenRect.Right-FormRect.Right)<integer(FArea)) then
           DockOnRight;

  //Magnet/UnMagnet Lleft, Magnet/UnMagnet Right
  if (MovingToRight) then
     if (OkeyForRight) then
     begin
        if (((ScreenRect.Right-FormRect.Right) in [2..FArea])) or
           (((abs(ScreenRect.Right-FormRect.Right))=1)) then
           DockOnRight
        else if ((abs(ScreenRect.Right-FormRect.Right)) in [2..FArea]) then
           UndockOnRightOutside
        else if ((ScreenRect.Left-FormRect.Left) in [2..FArea]) then
           DockOnLeft
        else if (abs(ScreenRect.Left-FormRect.Left) in [1..FArea]) then
           UndockOnLeftInside;
     end
     else
       if ((abs(ScreenRect.Right-FormRect.Right))<integer(FArea)) then
           DockOnRight
       else  if (abs(ScreenRect.Left-FormRect.Left)<integer(FArea)) then
           DockOnLeft;

  //Magnet/UnMagnet Bottom, Magnet/UnMagnet Top
  if (MovingToTop) then
     if (OkeyForTop) then
     begin
        if (((FormRect.Top-ScreenRect.Top) in [2..FArea])) or
           ((abs(FormRect.Top-ScreenRect.Top))=1) then
           DockOnTop
        else if ((abs(FormRect.Top-ScreenRect.Top)) in [2..FArea]) then
           UndockOnTopOutside
        else if ((ScreenRect.Bottom-FormRect.Bottom) in [2..FArea]) then
           UndockOnBottomInside
        else if ((abs(ScreenRect.Bottom-FormRect.Bottom)) in [1..FArea]) then
           DockOnBottom;
     end
     else
       if ((abs(FormRect.Top-ScreenRect.Top))<integer(FArea)) then
          DockOnTop
       else if ((abs(ScreenRect.Bottom-FormRect.Bottom))<integer(FArea)) then
           DockOnBottom;

  //Magnet/UnMagnet Bottom, Magnet/UnMagnet Top
  if (MovingToBottom) then
     if (OkeyForBottom) then
     begin
        if ((FormRect.Top-ScreenRect.Top) in [2..FArea]) then
           UndockOnTopInside
        else if ((abs(FormRect.Top-ScreenRect.Top))<integer(FArea)) then
           DockOnTop
        else if ((ScreenRect.Bottom-FormRect.Bottom) in [2..FArea]) then
           DockOnBottom
        else if ((abs(ScreenRect.Bottom-FormRect.Bottom)) in [1..FArea]) then
           UndockOnBottomOutside;
     end
     else
       if ((abs(FormRect.Top-ScreenRect.Top))<integer(FArea)) then
          DockOnTop
       else if ((abs(ScreenRect.Bottom-FormRect.Bottom))<integer(FArea)) then
          UndockOnBottomOutside;
end;

procedure TOBFormMagnet.GlueForms(var FormRect:TRect);
var
  i:Integer;
begin
   for i:=0 to Application.ComponentCount-1 do
      if Application.Components[i] is TForm then
         with Application.Components[i] as TForm do
            if (Left=FForm.left+FForm.Width) or
               (Top=FForm.Top+FForm.Height) or
               (Left+Width=FForm.Left) or
               (Top+Height=FForm.Top) then
            begin
               Left:=Left+(FormRect.Left-FForm.Left);
               Top:=Top+(FormRect.top-FForm.Top);
            end;
end;

procedure TOBFormMagnet.MagnetToMain(OldRect:TRect;var FormRect:TRect;MainRect:TRect);
var
  FormWidth,FormHeight: Integer;

  function OkeyForAll(var Value:TDateTime):boolean;
  begin
     if abs(Value-Now)>EncodeTime(0,0,0,250) then
        result:=true
     else
        result:=false;
  end;

  function OkeyForRight:boolean;
  begin
     result:=OkeyForall(FLastRightDock);
  end;

  function OkeyForTop:boolean;
  begin
     result:=OkeyForall(FLastTopDock);
  end;

  function MovingToLeft:boolean;
  begin
     result:=OldRect.Left>FormRect.Left;
  end;

  function MovingToRight:boolean;
  begin
     result:=OldRect.Left<FormRect.Left;
  end;

  function MovingToTop:boolean;
  begin
     result:=OldRect.Top>FormRect.Top;
  end;

  function MovingToBottom:boolean;
  begin
     result:=OldRect.Top<FormRect.Top;
  end;

  function InWidth:boolean;
  begin
     result:= ((FormRect.Left>MainRect.Left)and(FormRect.Left<MainRect.Right)) or
              ((FormRect.Left<MainRect.Left)and(FormRect.Right>MainRect.Left));
  end;

  function InHeight:boolean;
  begin
     result:= ((FormRect.Top>MainRect.Top)and(FormRect.Top<MainRect.Bottom)) or
              ((FormRect.Top<MainRect.Top)and(FormRect.Bottom>MainRect.Top));
  end;

  procedure DockOnBottom;
  begin
     FormRect.Top:=MainRect.Bottom;
     FormRect.Bottom:=FormRect.Top+FormHeight;
     FLastTopDock:=Now;
  end;

  procedure UndockOnBottomInside;
  begin
     FormRect.Top:=MainRect.Bottom-integer(FArea);
     FormRect.Bottom:=FormRect.Top+FormHeight;
     FLastTopDock:=Now;
  end;

  procedure UndockOnBottomOutside;
  begin
     FormRect.Top:=MainRect.Bottom+integer(FArea);
     FormRect.Bottom:=FormRect.Top+FormHeight;
     FLastTopDock:=Now;
  end;

  procedure DockOnTop;
  begin
     FormRect.Top:=MainRect.Top-FormHeight;
     FormRect.Bottom:=MainRect.Top;
     FLastTopDock:=Now;
  end;

  procedure UndockOnTopOutside;
  begin
     FormRect.Top:=MainRect.Top-FormHeight-integer(FArea);
     FormRect.Bottom:=MainRect.Top-integer(FArea);
     FLastTopDock:=Now;
  end;

  procedure UndockOnTopInside;
  begin
     FormRect.Top:=MainRect.Top-FormHeight+integer(FArea);
     FormRect.Bottom:=MainRect.Top+integer(FArea);
     FLastTopDock:=Now;
  end;

  procedure DockOnRight;
  begin
     FormRect.Left:=MainRect.Right;
     FormRect.Right:=FormRect.Left+FormWidth;
     FLastRightDock:=now;
  end;

  procedure UndockOnRightInside;
  begin
     FormRect.Left:=MainRect.Right-integer(FArea);
     FormRect.Right:=FormRect.Left+FormWidth;
     FLastRightDock:=now;
  end;

  procedure UndockOnRightOutside;
  begin
     FormRect.Left:=MainRect.Right+integer(FArea);
     FormRect.Right:=FormRect.Left+FormWidth;
     FLastRightDock:=now;
  end;

  procedure DockOnLeft;
  begin
     FormRect.Left:=MainRect.Left-FormWidth;
     FormRect.Right:=MainRect.Left;
     FLastRightDock:=now;
  end;

  procedure UndockOnLeftInside;
  begin
     FormRect.Left:=MainRect.Left-FormWidth+integer(FArea);
     FormRect.Right:=MainRect.Left+integer(FArea);
     FLastRightDock:=now;
  end;

  procedure UndockOnLeftOutside;
  begin
     FormRect.Left:=MainRect.Left-FormWidth-integer(FArea);
     FormRect.Right:=MainRect.Left-integer(FArea);
     FLastRightDock:=now;
  end;

begin
   FormWidth:=FormRect.Right-FormRect.Left;
   FormHeight:=FormRect.Bottom-FormRect.Top;

   //Magnet/UnMagnet Bottom, Magnet/UnMagnet Top
   if (MovingToTop)and(InWidth) then
      if (OkeyForTop) then
      begin
         if ((FormRect.Top-MainRect.Bottom) in [2..FArea]) then
           DockOnBottom
         else if ((-(FormRect.Top-MainRect.Bottom))in [2..FArea]) then
           UndockOnBottomInside
         else if ((FormRect.Bottom-MainRect.Top) in [2..FArea]) then
           DockOnTop
         else if ((-(FormRect.Bottom-MainRect.Top)) in [2..FArea]) then
           UndockOnTopOutside;
      end
      else
         if ((abs(FormRect.Top-MainRect.Bottom))<integer(FArea)) then
           DockOnBottom
         else if (abs(FormRect.Bottom-MainRect.Top)<integer(FArea)) then
           DockOnTop;

   if (MovingToBottom) and (InWidth) then
     if (OkeyForTop) then
     begin
        if ((FormRect.Top-MainRect.Bottom) in [2..FArea]) then
           UndockOnBottomOutside
        else if ((-(FormRect.Top-MainRect.Bottom)) in [2..FArea]) then
           DockOnBottom
        else if ((FormRect.Bottom-MainRect.Top) in [1..FArea]) then
           DockOnTop
        else if ((abs(FormRect.Bottom-MainRect.Top)) in [2..FArea]) then
           UndockOnTopInside;
     end
     else
        if ((abs(FormRect.Top-MainRect.Bottom))<integer(FArea)) then
           DockOnBottom
        else if ((FormRect.Bottom-MainRect.Top)<integer(FArea)) then
           DockOnTop;

   if (MovingToLeft) and (InHeight) then
     if (OkeyForRight) then
     begin
        if ((FormRect.Left-MainRect.Right) in [2..FArea]) then
           DockOnRight
        else if ((abs(FormRect.Left-MainRect.Right)) in [2..FArea]) then
           UndockOnRightInside
        else if ((FormRect.Right-MainRect.Left) in [2..FArea]) then
           DockOnLeft
        else if ((abs(FormRect.Right-MainRect.Left)) in [2..FArea]) then
           UndockOnLeftOutside;
     end
     else
        if (abs(FormRect.Left-MainRect.Right)<integer(FArea)) then
           DockOnRight
        else if (abs(FormRect.Right-MainRect.Left)<integer(FArea)) then
           DockOnLeft;

   if (MovingToRight) and (InHeight) then
     if (OkeyForRight) then
     begin
        if ((MainRect.Left-FormRect.Right) in [2..FArea]) then
           DockOnLeft
        else if ((abs(MainRect.Left-FormRect.Right)) in [2..FArea]) then
           UndockOnLeftInside
        else if ((MainRect.Right-FormRect.Left) in [2..FArea]) then
           DockOnRight
        else if ((abs(MainRect.Right-FormRect.Left)) in [2..FArea]) then
           UndockOnRightOutside;
     end
     else
        if ((abs(MainRect.Left-FormRect.Right))<integer(FArea)) then
           DockOnLeft
        else if (abs(MainRect.Right-FormRect.Left)<integer(FArea)) then
           DockOnRight
end;

procedure TOBFormMagnet.NewWndProc(var Msg: TMessage);
var
  r,r2,r3:TRect;
begin
   with Msg do
   begin
      if FActive then
      begin
         case Msg of
            WM_MOVING  :
               begin
                  r:=TRect(PRect(lParam)^);

                  r3.Left:=FForm.Left;
                  r3.Top:=FForm.Top;
                  r3.Right:=r3.Left+FForm.Width;
                  r3.Bottom:=r3.Top+FForm.Height;

                  //Move to an extremity of the desktop ?
                  if FScreen then
                  begin
                     SystemParametersInfo(SPI_GETWORKAREA,0,@r2,0);
                     MagnetScreen(r3,r,r2);
                  end;

                  //Move another form too ?
                  if FGlue then
                     GlueForms(r);

                  //Magnet to main form ?
                  if (FFormMagnet)and(Application.MainForm<>nil) then
                  begin
                     r2.Left:=Application.MainForm.Left;
                     r2.Top:=Application.MainForm.Top;
                     r2.Right:=Application.MainForm.Left+Application.MainForm.Width;
                     r2.Bottom:=Application.MainForm.Top+Application.MainForm.Height;
                     MagnetToMain(r3,r,r2);
                  end;
                  PRect(lparam)^:=r;
               end;
         end;
      end;
      result:=CallWindowProc(FOldWndProc,FForm.Handle,Msg,WParam,LParam);
   end;
end;

end.

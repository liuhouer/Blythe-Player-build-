{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBGammaPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  extctrls, StdCtrls;

type
  TOnChangeColor = procedure (Sender: TObject;Foreground,Background:TColor) of object;

Type
  TOBGammaPanel = class(TWinControl)
  private
    Fcol1,FCol2:TColor;
    LastCol:TColor;
    FPanel,FPanel2,Fpanel3,FPanel4:TPanel;
    FRLabel,FGLabel,FBLabel,FXLabel:TLabel;
    FGamma,FChoosed,FColor1,FColor2:TImage;
    FOnChangeCol: TOnChangeColor;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure ChangeColor(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure ColorSeek(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure Exchange(Sender: TObject);
    procedure SetCol1(const Value: TColor);
    procedure Setcol2(const Value: TColor);
    procedure Color1Click(Sender: TObject);
    procedure Color2Click(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    property Align;
    property Autosize;
    property OnChangeColor:TOnChangeColor read FOnChangeCol write FOnChangeCol;
    property ForegroundColor:TColor read FCol1 write SetCol1 default clBlack;
    property BackgroundColor:TColor read FCol2 write Setcol2 default clWhite;
  end;

implementation

{$R RES_Gamma.res}

resourcestring
  RC_RedFormat          =       'R : %3D';
  RC_GreenFormat        =       'G : %3D';
  RC_BlueFormat         =       'B : %3D';

  RC_Hint1              =       '背景颜色';
  RC_Hint2              =       '前景颜色';
  RC_LabelCaption       =       'X';
  RC_LabelHint          =       '交换背景色与前景色';

  RC_DefaultB           =       'B : ---';
  RC_DefaultG           =       'G : ---';
  RC_DefaultR           =       'R : ---';

procedure TOBGammaPanel.ChangeColor(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
   if Button=mbLeft then
   begin
      FCol1:=LastCol;
      FColor1.Canvas.brush.Color:=Fcol1;
      FColor1.Canvas.brush.style:=bsSolid;
      FColor1.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));
      if Assigned(FOnChangeCol) then
         FOnChangeCol(self,FCol1,FCol2);
   end
   else if Button=mbRight then
   begin
      FCol2:=LastCol;
      FColor2.Canvas.brush.Color:=Fcol2;
      FColor2.Canvas.brush.style:=bsSolid;
      FColor2.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));
      if Assigned(FOnChangeCol) then
         FOnChangeCol(self,FCol1,FCol2);
   end;
end;

procedure TOBGammaPanel.Color1Click(Sender: TObject);
begin
   with TColorDialog.Create(self) do
   begin
      if execute then
         SetCol1(Color);
      free;
   end;
end;

procedure TOBGammaPanel.Color2Click(Sender: TObject);
begin
   with TColorDialog.Create(self) do
   begin
      if execute then
           SetCol2(Color);
      free;
   end;
end;

procedure TOBGammaPanel.ColorSeek(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
   col:TColor;
begin
   col:=FGamma.Picture.Bitmap.Canvas.Pixels[x,y];
   LastCol:=Col;
   FRLabel.Caption:=format(RC_RedFormat,[GetRValue(col)]);
   FGLabel.Caption:=format(RC_GreenFormat,[GetGValue(col)]);
   FBLabel.Caption:=format(RC_BlueFormat,[GetBValue(col)]);
   FChoosed.Canvas.brush.Color:=col;
   FChoosed.Canvas.brush.style:=bsSolid;
   FChoosed.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));
end;

constructor TOBGammaPanel.Create(AOwner: TComponent);
begin
   inherited;
   self.Width:=65;
   self.height:=250;
   FCOl1:=clBlack;
   FCol2:=clwhite;

   FPanel:=TPanel.Create(self);
   FPanel.parent:=self;
   FPanel.width:=65;
   FPanel.height:=250;
   FPanel.align:=alClient;
   FPanel.BevelInner:=bvLowered;
   FPanel.BevelOuter:=bvRaised;
   FPanel.visible:=true;

   FPanel2:=TPanel.Create(FPanel);
   FPanel2.parent:=FPanel;
   FPanel2.Left:=5;
   FPanel2.top:=5;
   FPanel2.width:=55;
   FPanel2.height:=105;
   FPanel2.BevelInner:=bvLowered;
   FPanel2.BevelOuter:=bvRaised;
   FPanel2.visible:=true;

   FPanel3:=TPanel.Create(FPanel);
   FPanel3.parent:=FPanel;
   FPanel3.Left:=5;
   FPanel3.top:=115;
   FPanel3.width:=55;
   FPanel3.height:=50;
   FPanel3.BevelInner:=bvLowered;
   FPanel3.BevelOuter:=bvRaised;
   FPanel3.visible:=true;

   FPanel4:=TPanel.Create(FPanel);
   FPanel4.parent:=FPanel;
   FPanel4.Left:=5;
   FPanel4.top:=170;
   FPanel4.width:=55;
   FPanel4.height:=75;
   FPanel4.BevelInner:=bvLowered;
   FPanel4.BevelOuter:=bvRaised;
   FPanel4.visible:=true;

   FRLabel:=TLabel.Create(FPanel4);
   FRLabel.top:=2;
   FRlabel.left:=5;
   FRlabel.Font.Size:=8;
   FRLabel.AutoSize:=true;
   FRLabel.font.Name:='arial';
   FRlabel.caption:=RC_DefaultR;
   FRlabel.transparent:=true;
   FRLabel.parent:=FPanel4;

   FGLabel:=TLabel.Create(FPanel4);
   FGLabel.top:=14;
   FGLabel.left:=5;
   FGLabel.AutoSize:=true;
   FGLabel.font.Name:='arial';
   FGLabel.Font.Size:=8;
   FGLabel.caption:=RC_DefaultG;
   FGLabel.transparent:=true;
   FGLabel.parent:=FPanel4;

   FBLabel:=TLabel.Create(FPanel4);
   FBLabel.top:=26;
   FBLabel.left:=5;
   FBLabel.Font.Size:=8;
   FBLabel.font.Name:='arial';
   FBLabel.AutoSize:=true;
   FBLabel.caption:=RC_DefaultB;
   FBLabel.transparent:=true;
   FBLabel.parent:=FPanel4;

   FGamma:=TImage.Create(FPanel2);
   FGamma.Parent:=FPanel2;
   FGamma.Stretch:=false;
   FGamma.Center:=true;
   FGamma.AutoSize:=true;
   FGamma.Picture.Bitmap.PixelFormat:=pf24bit;
   FGamma.width:=55;
   FGamma.height:=105;
   FGamma.OnMouseDown:=ChangeColor;
   FGamma.OnMouseMove:=ColorSeek;
   FGamma.Align:=alClient;
   FGamma.Picture.Bitmap.LoadFromResourceName(HInstance,'COLORS');
   FGamma.Cursor:=crCross;

   FChoosed:=TImage.Create(FPanel4);
   FChoosed.Top:=40;
   FChoosed.Left:=12;
   FChoosed.width:=30;
   FChoosed.height:=30;
   FChoosed.parent:=FPanel4;
   FChoosed.visible:=true;
   FChoosed.Stretch:=false;
   FChoosed.Align:=alNone;
   FChoosed.picture.bitmap:=TBItmap.Create;
   FChoosed.picture.bitmap.width:=FChoosed.width;
   FChoosed.picture.bitmap.height:=FChoosed.height;
   FChoosed.Canvas.brush.Color:=clBlack;
   FChoosed.Canvas.brush.style:=bsSolid;
   FChoosed.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));

   FColor1:=TImage.Create(FPanel3);
   FColor2:=TImage.Create(FPanel3);
   FColor1.Left:=5;
   FColor1.Top:=5;
   FColor1.width:=25;
   FColor1.height:=25;

   FColor2.left:=25;
   FColor2.top:=20;
   FColor2.Height:=25;
   FColor2.width:=25;
   FColor2.visible:=true;
   FColor1.visible:=true;
   FColor1.parent:=FPanel3;
   FColor2.parent:=FPanel3;

   FColor2.picture.bitmap:=TBItmap.Create;
   FColor2.picture.bitmap.width:=FChoosed.width;
   FColor2.picture.bitmap.height:=FChoosed.height;
   FColor2.Canvas.brush.Color:=clWhite;
   FColor2.Canvas.brush.style:=bsSolid;
   FColor2.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));
   FCOlor2.hint:=RC_Hint1;
   FColor2.showhint:=true;
   FColor2.OnClick:=Color2Click;

   FColor1.picture.bitmap:=TBItmap.Create;
   FColor1.picture.bitmap.width:=FChoosed.width;
   FColor1.picture.bitmap.height:=FChoosed.height;
   FColor1.Canvas.brush.Color:=clBlack;
   FColor1.Canvas.brush.style:=bsSolid;
   FColor1.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));
   FCOlor1.hint:=RC_Hint2;
   FColor1.showhint:=true;
   FColor1.OnClick:=Color1Click;


   FXlabel:=TLabel.Create(FPanel3);
   FXLabel.left:=7;
   FXLabel.top:=32;
   FXLabel.AutoSize:=true;
   FXLabel.caption:=RC_LabelCaption;
   FXLabel.hint:=RC_LabelHint;
   FXLabel.OnClick:=Exchange;
   FXLabel.ShowHint:=true;
   FXLabel.visible:=true;
   FXLabel.parent:=FPanel3;
end;

destructor TOBGammaPanel.Destroy;
begin
   FXLabel.free;
   FColor2.free;
   FColor1.free;
   FGamma.free;
   FChoosed.free;
   FRLabel.free;
   FGLabel.free;
   FBLabel.free;
   FPanel2.free;
   FPanel3.free;
   FPanel4.free;
   FPanel.free;
   inherited;
end;

procedure TOBGammaPanel.Exchange(Sender: TObject);
var
   t:TColor;
begin
   //exchange colors
   t:=FCol1;
   FCol1:=FCol2;
   FCol2:=t;

   FColor1.Canvas.brush.Color:=Fcol1;
   FColor1.Canvas.brush.style:=bsSolid;
   FColor1.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));

   FColor2.Canvas.brush.Color:=Fcol2;
   FColor2.Canvas.brush.style:=bsSolid;
   FColor2.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));

   if Assigned(FOnChangeCol) then
      FOnChangeCol(self,FCol1,FCol2);
end;

procedure TOBGammaPanel.SetCol1(const Value: TColor);
begin
   FCol1 := Value;
   FColor1.Canvas.brush.Color:=Fcol1;
   FColor1.Canvas.brush.style:=bsSolid;
   FColor1.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));
   if Assigned(FOnChangeCol) then
     FOnChangeCol(self,FCol1,FCol2);
end;

procedure TOBGammaPanel.Setcol2(const Value: TColor);
begin
   FCol2 := Value;
   FColor2.Canvas.brush.Color:=Fcol2;
   FColor2.Canvas.brush.style:=bsSolid;
   FColor2.Canvas.FillRect(Rect(0,0,Fchoosed.width,FChoosed.height));
   if Assigned(FOnChangeCol) then
      FOnChangeCol(self,FCol1,FCol2);
end;

procedure TOBGammaPanel.WMSize(var Message: TWMSize);
begin
   self.Width:=65;
   self.height:=250;
   self.FColor1.bringtofront;
end;

end.

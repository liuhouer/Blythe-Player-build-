{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBAutoSizeCompo;

{$ObjExportAll On}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls;

type
  TOBAutoSizeCompo = class(TComponent)
  private
    FForm: TForm;
    FActive: boolean;
    FResize: TNotifyEvent;
    OldWidth,OldHeight: Integer;
    FAbout: String;
    procedure Resize(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    property Active: Boolean read FActive write FActive default true;
    property About : String read FAbout write FAbout;
  end;

implementation

constructor TOBAutoSizeCompo.Create(AOwner: TComponent);
begin
  inherited;
  FActive := true;
  FForm := TForm(GetParentForm(TControl(AOwner)));
  Oldwidth := FForm.Width;
  OldHeight := FForm.Height;
  Fresize := FForm.OnResize;
  FForm.OnResize := Resize;
end;

destructor TOBAutoSizeCompo.Destroy;
begin
  if FForm<>nil then
    FForm.OnResize:=nil;
  inherited;
end;

procedure TOBAutoSizeCompo.Resize(Sender: TObject);
var
  widthRatio, heightRatio: double;
  compIndex: Integer;
begin
  if FActive then
  begin
    if (OldWidth<>0) and (OldHeight<>0) then
    begin
      WidthRatio := FForm.Width / oldWidth;
      HeightRatio := FForm.Height / oldHeight;
      for compIndex := 0 to (FForm.ComponentCount - 1) do
      begin
        if FForm.Components[compIndex] is TControl then
        begin
          with FForm.Components[compIndex] as TControl do
          begin
            if not(FForm.Components[compIndex] is TButton) then
            begin
              Width := round(Width*WidthRatio);
              Height := round(Height*HeightRatio);
            end;
            Left := round(Left*WidthRatio);
            Top := round(top*HeightRatio);
          end;
        end;
      end;
    end;
    OldWidth := FForm.Width;
    OldHeight := FForm.Height;
  end;
  if Assigned(FResize) then
    FResize(Sender);
end;

end.

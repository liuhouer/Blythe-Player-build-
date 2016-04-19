{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

unit OBDragDrop;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ShellApi,
  Forms;

type
  TDropEvent = procedure(Sender: TObject;Pos:TPoint;Value:TstringList)of object;
  TOBDragDrop = class(TComponent)
  private
    FAccept:boolean;
    FHandle:THandle;
    FFiles:TstringList;
    FOnDrop:TDropEvent;
    FDefProc: Pointer;
    FWndProcInstance: Pointer;
    FAbout: String;
    procedure DropFiles(Handle:HDrop);
    procedure SetAccept(Value:Boolean );
    procedure WndProc( var Msg:TMessage);
  protected
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    property Files:TstringList read FFiles;
  published
    property AcceptDrag:boolean read FAccept write SetAccept default true;
    property OnDrop:TDropEvent read FOnDrop write FOnDrop;
    property About : String read FAbout write FAbout;
  end;

implementation

constructor TOBDragDrop.Create(AOwner: TComponent);
var
   WinCtl:TWinControl;
begin
   FAccept:=true;
   inherited;
   FFiles:=TstringList.Create;
   FHandle:=0;
   if Owner is TWinControl then
   begin
      WinCtl:=TWinControl(Owner);
      FHandle:=WinCtl.Handle;
      FWndProcInstance:=MakeObjectInstance(WndProc);
      FDefProc:=Pointer(GetWindowLong(FHandle,GWL_WNDPROC));
      SetWindowLong(FHandle,GWL_WNDPROC,Longint(FWndProcInstance));
   end
   else
     FAccept:=false;
   SetAccept(FAccept);
end;

destructor TOBDragDrop.Destroy;
begin
   FFiles.free;
   if FHandle <> 0 then
   begin
      SetWindowLong( FHandle, GWL_WNDPROC, Longint( FDefProc ));
      FreeObjectInstance(FWndProcInstance);
   end;
   inherited;
end;

procedure TOBDragDrop.SetAccept(Value:Boolean );
begin
   FAccept:=Value;
   DragAcceptFiles(FHandle,Value);
end;

procedure TOBDragDrop.WndProc(var Msg:TMessage);
begin
   if Msg.Msg=WM_DROPFILES then
     DropFiles(HDrop(Msg.wParam))
   else
     Msg.Result:=CallWindowProc(FDefProc,FHandle,Msg.Msg,Msg.WParam,Msg.LParam);
end;

procedure TOBDragDrop.DropFiles(Handle:HDrop);
var
  pszFileWithPath, pszFile: PChar;
  iFile, iStrLen, iTempLen: Integer;
  MousePt: TPoint;
  count:Integer;
begin
   FFiles.Clear;
   iStrLen:=128;
   pszFileWithPath:=StrAlloc(iStrLen);
   pszFile:=StrAlloc(iStrLen);
   count:=DragQueryFile(Handle,$FFFFFFFF,pszFile,iStrLen);
   iFile:=0;
   while (iFile<count) do
   begin
      iTempLen:=DragQueryFile(Handle,iFile,nil,0)+1;
      if (iTempLen>iStrLen) then
      begin
         iStrLen:=iTempLen;
         StrDispose(pszFileWithPath);
         pszFileWithPath:=StrAlloc(iStrLen);
      end;
      DragQueryFile(Handle,iFile,pszFileWithPath,iStrLen);
      FFiles.Add(StrPas(pszFileWithPath));
      Inc(iFile);
   end;
   StrDispose(pszFileWithPath);
   if Assigned(FOnDrop) then
   begin
      DragQueryPoint(Handle, MousePt);
      FOnDrop(Self, MousePt,FFIles);
   end;
   DragFinish(Handle);
end;

end.

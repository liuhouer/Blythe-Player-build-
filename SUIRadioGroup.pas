////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIRadioGroup.pas
//  Creator     :   Shen Min
//  Date        :   2002-09-22 V1-V3
//                  2003-06-24 V4
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIRadioGroup;

interface

{$I SUIPack.inc}

uses Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Forms, Graphics,
     SUIImagePanel, SUIGroupBox, SUIButton, SUIThemes, SUIMgr;

type
    TsuiCheckGroup = class(TsuiCustomGroupBox)
    private
        m_Items : TStrings;
        m_Buttons : TList;
        m_Columns : Integer;
        m_TopMargin : Integer;
        m_Cursor : TCursor;

        m_OnClick : TNotifyEvent;

        procedure ItemChanged(Sender : TObject);
        procedure SetItems(const Value: TStrings);

        function UpdateButtons() : Boolean;
        procedure ArrangeButtons();
        procedure SetColumns(const Value: Integer);
        procedure SetTopMargin(const Value: Integer);
        function GetChecked(Index: Integer): Boolean;
        procedure SetChecked(Index: Integer; const Value: Boolean);
        function GetItemEnabled(Index: Integer): Boolean;
        procedure SetItemEnabled(Index: Integer; const Value: Boolean);
        function GetFontColor: TColor;
        procedure SetFontColor(const Value: TColor);
        procedure SetCursor2(const Value : TCursor);
        procedure CMFONTCHANGED(var Msg : TMessage); message CM_FONTCHANGED;
        procedure WMSetFocus (var Msg: TWMSetFocus); message WM_SETFOCUS;

        procedure DoClick(Sender : TObject);

    protected
        procedure NewClick; virtual;
        function CreateAButton() : TsuiCheckBox; virtual;
        procedure Resize(); override;

        procedure SetTransparent(const Value: Boolean); override;
        procedure FocusUpdate(); virtual;

    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy(); override;

        procedure UpdateUIStyle(UIStyle : TsuiUIStyle; FileTheme : TsuiFileTheme); override;

        property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
        property ItemEnabled[Index : Integer]: Boolean read GetItemEnabled write SetItemEnabled;

    published
        property Items : TStrings read m_Items write SetItems;
        property Columns : Integer read m_Columns write SetColumns;
        property TopMargin : Integer read m_TopMargin write SetTopMargin;
        property FontColor : TColor read GetFontColor write SetFontColor;
        property BorderColor;
        property Cursor read m_Cursor write SetCursor2;

        property OnClick : TNotifyEvent read m_OnClick write m_OnClick;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDock;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
        property OnStartDock;
        property OnStartDrag;

    end;

    TsuiRadioGroup = class(TsuiCheckGroup)
    private
        procedure SetItemIndex(const Value: Integer);
        function GetItemIndex: Integer;

    protected
        function CreateAButton() : TsuiCheckBox; override;
        procedure FocusUpdate(); override;
        function CanModify: Boolean; virtual;
        
    published
        property ItemIndex : Integer read GetItemIndex write SetItemIndex;

    end;

    TsuiCheckGroupButton = class(TsuiCheckBox)
    private
        m_CheckGroup : TsuiCheckGroup;
    protected
        function NeedDrawFocus() : Boolean; override;
    public
        constructor Create(AOwner : TComponent; CheckGroup : TsuiCheckGroup); reintroduce;
    end;

    TsuiRadioGroupButton = class(TsuiRadioButton)
    private
        m_RadioGroup : TsuiRadioGroup;
    protected
        function NeedDrawFocus() : Boolean; override;
        procedure DoClick(); override;
    public
        constructor Create(AOwner : TComponent; RadioGroup : TsuiRadioGroup); reintroduce;
    end;

implementation

uses SUIPublic;

{ TsuiCheckGroup }

procedure TsuiCheckGroup.ArrangeButtons;
var
    R : TRect;
    nHeight : Integer;
    i : Integer;
    ButtonsPerCol : Integer;
    ButtonWidth : Integer;
    ButtonHeight : Integer;
    TopMargin : Integer;
begin
    if m_Buttons.Count = 0 then
        Exit;

    R := GetClient();
    R.Top := R.Top + m_TopMargin;

    nHeight := R.Bottom - R.Top;

    ButtonsPerCol := (m_Buttons.Count + m_Columns - 1) div m_Columns;
    ButtonWidth := (Width - 10) div m_Columns;
    ButtonHeight := nHeight div ButtonsPerCol;
    TopMargin := R.Top + (nHeight mod ButtonsPerCol) div 2;

    for i := 0 to m_Buttons.Count - 1 do
    begin
        if BidiMode <> bdRightToLeft then
            TsuiCheckBox(m_Buttons[i]).Left := (i div ButtonsPerCol) * ButtonWidth + 8
        else
            TsuiCheckBox(m_Buttons[i]).Left := Width - (i div ButtonsPerCol) * ButtonWidth - 8 - TsuiCheckBox(m_Buttons[i]).Width;
        TsuiCheckBox(m_Buttons[i]).Top := (I mod ButtonsPerCol) * ButtonHeight + TopMargin;
    end;
end;

constructor TsuiCheckGroup.Create(AOwner: TComponent);
begin
    inherited;

    m_Items := TStringList.Create();
    (m_Items as TStringList).OnChange := ItemChanged;

    m_Buttons := TList.Create();

    m_Columns := 1;
    m_TopMargin := 8;
    UIStyle := GetSUIFormStyle(AOwner);
    Transparent := false;
    ParentColor := true;
    TabStop := true;

    inherited OnClick := DoClick;
end;

function TsuiCheckGroup.CreateAButton: TsuiCheckBox;
begin
    Result := TsuiCheckGroupButton.Create(self, self);
end;

destructor TsuiCheckGroup.Destroy;
begin
    m_Buttons.Free();
    m_Buttons := nil;

    m_Items.Free();
    m_Items := nil;

    inherited;
end;

procedure TsuiCheckGroup.ItemChanged(Sender: TObject);
var
    bRepaint : Boolean;
begin
    bRepaint := UpdateButtons();
    ArrangeButtons();

    if bRepaint then
    begin
        Transparent := not Transparent;
        Transparent := not Transparent;
    end;
end;

procedure TsuiCheckGroup.SetItems(const Value: TStrings);
begin
    m_Items.Assign(Value);
end;

procedure TsuiCheckGroup.ReSize;
begin
    inherited;

    ArrangeButtons();
end;

function TsuiCheckGroup.UpdateButtons() : Boolean;
var
    i : Integer;
    nItems : Integer;
    AButton : TsuiCheckBox;
begin
    Result := false;
    nItems := m_Items.Count - m_Buttons.Count;
    if nItems > 0 then
    begin
        for i := 1 to nItems do
        begin
            AButton := CreateAButton();
            AButton.Parent := self;
            AButton.Font := Font;
            AButton.AutoSize := true;
            AButton.FileTheme := FileTheme;
            AButton.UIStyle := UIStyle;
            AButton.Transparent := Transparent;
            AButton.ParentColor := true;
            AButton.TabStop := false;
            AButton.OnClick := DoClick;
            AButton.Cursor := m_Cursor;
            m_Buttons.Add(AButton);
            Result := true;
        end;
    end
    else if nItems < 0 then
    begin
        for i := 1 to Abs(nItems) do
        begin
            TsuiCheckBox(m_Buttons[m_Buttons.Count - 1]).Free();
            m_Buttons.Delete(m_Buttons.Count - 1);
        end;
    end;

    for i := 0 to m_Buttons.Count - 1 do
    begin
        TsuiCheckBox(m_Buttons[i]).Caption := m_Items[i];
        TsuiCheckBox(m_Buttons[i]).AutoSize := true;
    end;
end;

procedure TsuiCheckGroup.SetColumns(const Value: Integer);
begin
    if Value < 0 then
        Exit;
    m_Columns := Value;

    ArrangeButtons();
end;

function TsuiCheckGroup.GetChecked(Index: Integer): Boolean;
begin
    Result := false;
    if (
        (Index > m_Buttons.Count - 1) or
        (Index < 0)
    ) then
        Exit;
    Result := TsuiCheckBox(m_Buttons[Index]).Checked;
end;

procedure TsuiCheckGroup.SetChecked(Index: Integer; const Value: Boolean);
begin
    TsuiCheckBox(m_Buttons[Index]).Checked := Value;
end;

procedure TsuiCheckGroup.UpdateUIStyle(UIStyle: TsuiUIStyle; FileTheme : TsuiFileTheme);
var
    i : Integer;
begin
    inherited;
    
    if m_Buttons = nil then
        Exit;
    for i := 0 to m_Buttons.Count - 1 do
    begin
        TsuiCheckBox(m_Buttons[i]).FileTheme := FileTheme;
        TsuiCheckBox(m_Buttons[i]).UIStyle := UIStyle;
        TsuiCheckBox(m_Buttons[i]).Color := Color;
    end;
end;

procedure TsuiCheckGroup.SetTransparent(const Value: Boolean);
var
    i : Integer;
begin
    inherited;

    if m_Buttons = nil then
        Exit;

    for i := 0 to m_Buttons.Count - 1 do
        TsuiCheckBox(m_Buttons[i]).Transparent := Value;
end;

procedure TsuiCheckGroup.DoClick(Sender: TObject);
begin
    NewClick();
    if csLoading in ComponentState then
        Exit;
    if Assigned(m_OnClick) then
        m_OnClick(self);
end;

procedure TsuiCheckGroup.SetTopMargin(const Value: Integer);
begin
    if Value < 0 then
        Exit;
    m_TopMargin := Value;

    ArrangeButtons();
end;

procedure TsuiCheckGroup.NewClick;
begin

end;

procedure TsuiCheckGroup.CMFONTCHANGED(var Msg: TMessage);
var
    i : Integer;
begin
    inherited;

    if m_Buttons = nil then
        Exit;

    for i := 0 to m_Buttons.Count - 1 do
        TsuiCheckBox(m_Buttons[i]).Font.Assign(Font);
end;

function TsuiCheckGroup.GetFontColor: TColor;
begin
    Result := Font.Color;
end;

procedure TsuiCheckGroup.SetFontColor(const Value: TColor);
begin
    Font.Color := Value;
end;

function TsuiCheckGroup.GetItemEnabled(Index: Integer): Boolean;
begin
    Result := false;
    if (
        (Index > m_Buttons.Count - 1) or
        (Index < 0)
    ) then
        Exit;
    Result := TsuiCheckBox(m_Buttons[Index]).Enabled;
end;

procedure TsuiCheckGroup.SetItemEnabled(Index: Integer;
  const Value: Boolean);
begin
    TsuiCheckBox(m_Buttons[Index]).Enabled := Value;
end;

procedure TsuiCheckGroup.WMSetFocus(var Msg: TWMSetFocus);
begin
    inherited;
    FocusUpdate();
end;

procedure TsuiCheckGroup.FocusUpdate;
begin
    if Items.Count = 0 then
        Exit;
    if TsuiCheckBox(m_Buttons[0]).CanFocus() then
        TsuiCheckBox(m_Buttons[0]).SetFocus();
end;

procedure TsuiCheckGroup.SetCursor2(const Value: TCursor);
var
    i : Integer;
begin
    for i := 0 to m_Buttons.Count - 1 do
        TsuiCheckBox(m_Buttons[i]).Cursor := Value;
    m_Cursor := Value;
end;

{ TsuiRadioGroup }

function TsuiRadioGroup.CanModify: Boolean;
begin
    Result := true;
end;

function TsuiRadioGroup.CreateAButton: TsuiCheckBox;
begin
    Result := TsuiRadioGroupButton.Create(self, self);
end;

procedure TsuiRadioGroup.FocusUpdate;
begin
    if (ItemIndex < 0) or (ItemIndex >= Items.Count) then
        Exit;
    TsuiCheckBox(m_Buttons[ItemIndex]).SetFocus;
end;

function TsuiRadioGroup.GetItemIndex: Integer;
var
    i : Integer;
begin
    Result := -1;

    for i := 0 to m_Buttons.Count - 1 do
    begin
        if TsuiRadioButton(m_Buttons[i]).Checked then
        begin
            Result := i;
            break;
        end;
    end;
end;

procedure TsuiRadioGroup.SetItemIndex(const Value: Integer);
var
    i : Integer;
begin
    if Value > m_Items.Count - 1 then
        Exit;
    if Value < -1 then
        Exit;

    if Value >= 0 then
        TsuiRadioButton(m_Buttons[Value]).Checked := true
    else // -1
    begin
        for i := 0 to m_Buttons.Count - 1 do
            TsuiRadioButton(m_Buttons[i]).Checked := false;
    end;
end;

{ TsuiRadioGroupButton }

constructor TsuiRadioGroupButton.Create(AOwner : TComponent; RadioGroup: TsuiRadioGroup);
begin
    inherited Create(AOwner);
    m_RadioGroup := RadioGroup;
end;

procedure TsuiRadioGroupButton.DoClick;
begin
    if (Parent as TsuiRadioGroup).CanModify then
        inherited;
end;

function TsuiRadioGroupButton.NeedDrawFocus: Boolean;
begin
    Result := (m_RadioGroup.Focused or Focused) and Checked;
end;

{ TsuiCheckGroupButton }

constructor TsuiCheckGroupButton.Create(AOwner: TComponent;
  CheckGroup: TsuiCheckGroup);
begin
    inherited Create(AOwner);
    m_CheckGroup := CheckGroup;
end;

function TsuiCheckGroupButton.NeedDrawFocus: Boolean;
begin
    Result := Focused;
end;

end.

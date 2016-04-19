////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIDBCtrls.pas
//  Creator     :   Shen Min
//  Date        :   2003-01-19 V1-V3
//                  2003-07-15 V4
//                  2006-06-16 V6
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIDBCtrls;

interface

{$I SUIPack.inc}

uses Windows, Messages, Classes, DBCtrls, Graphics, Controls, Forms, DB,
     Mask, SysUtils, StdCtrls, Clipbrd, Menus, ExtCtrls, Math, Dialogs,
     DBGrids, Grids,
{$IFDEF SUIPACK_D6UP}
     Types, Variants,
{$ENDIF}
     SUIThemes, SUIButton, SUIRadioGroup, SUIScrollBar, SUIMgr, SUI2Define;

resourcestring
{$IFDEF LANG_CHS}
    SFirstRecord = '第一条记录';
    SPriorRecord = '前一条记录';
    SNextRecord = '下一条记录';
    SLastRecord = '最后一条记录';
    SInsertRecord = '插入记录';
    SDeleteRecord = '删除记录';
    SEditRecord = '修改记录';
    SPostEdit = '提交修改';
    SCancelEdit = '取消修改';
    SConfirmCaption = '确认';
    SRefreshRecord = '刷新数据';
    SDeleteRecordQuestion = '删除记录？';
    SDeleteMultipleRecordsQuestion = '删除所有选中的记录？';
    SDataSourceFixed = 'DBCtrlGrid不允许执行该操作';
    SNotReplicatable = '该控件不能在DBCtrlGridControl中使用';
    SPropDefByLookup = '该属性已经在查找字段中被定义';
    STooManyColumns = 'Grid被要求显示超过256列';
{$ELSE}
    SFirstRecord = 'First record';
    SPriorRecord = 'Prior record';
    SNextRecord = 'Next record';
    SLastRecord = 'Last record';
    SInsertRecord = 'Insert record';
    SDeleteRecord = 'Delete record';
    SEditRecord = 'Edit record';
    SPostEdit = 'Post edit';
    SCancelEdit = 'Cancel edit';
    SConfirmCaption = 'Confirm';
    SRefreshRecord = 'Refresh data';
    SDeleteRecordQuestion = 'Delete record?';
    SDeleteMultipleRecordsQuestion = 'Delete all selected records?';
    SDataSourceFixed = 'Operation not allowed in a DBCtrlGrid';
    SNotReplicatable = 'Control cannot be used in a DBCtrlGrid';
    SPropDefByLookup = 'Property already defined by lookup field';
    STooManyColumns = 'Grid requested to display more than 256 columns';
{$ENDIF}

type
{$IFDEF SUIPACK_D10}
    TButtonSet = TNavButtonSet;
{$ENDIF}
    TsuiDBEdit = class(TDBEdit)
    private
        m_BorderColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;
        
        procedure SetBorderColor(const Value: TColor);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;
        procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

    protected
        procedure Notification(AComponent: TComponent;
          Operation: TOperation); override;

    public
        constructor Create(AOwner: TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;

    end;

    TsuiDBMemo = class(TDBMemo)
    private
        m_BorderColor : TColor;
        m_MouseDown : Boolean;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;
        
        // scroll bar
        m_VScrollBar : TsuiScrollBar;
        m_HScrollBar : TsuiScrollBar;
        m_SelfChanging : Boolean;
        m_UserChanging : Boolean;
        
        procedure SetHScrollBar(const Value: TsuiScrollBar);
        procedure SetVScrollBar(const Value: TsuiScrollBar);
        procedure OnHScrollBarChange(Sender : TObject);
        procedure OnVScrollBarChange(Sender : TObject);
        procedure UpdateScrollBars();
        procedure UpdateScrollBarsPos();
        procedure UpdateInnerScrollBars();

        procedure CMEnabledChanged(var Msg : TMessage); message CM_ENABLEDCHANGED;
        procedure CMVisibleChanged(var Msg : TMessage); message CM_VISIBLECHANGED;
        procedure WMSIZE(var Msg : TMessage); message WM_SIZE;
        procedure WMMOVE(var Msg : TMessage); message WM_MOVE;
        procedure WMCut(var Message: TMessage); message WM_Cut;
        procedure WMPaste(var Message: TMessage); message WM_PASTE;
        procedure WMClear(var Message: TMessage); message WM_CLEAR;
        procedure WMUndo(var Message: TMessage); message WM_UNDO;
        procedure WMLBUTTONDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
        procedure WMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
        procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
        procedure WMSetText(var Message:TWMSetText); message WM_SETTEXT;
        procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
        procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
        procedure WMVSCROLL(var Message: TWMVScroll); message WM_VSCROLL;
        procedure WMHSCROLL(var Message: TWMHScroll); message WM_HSCROLL;

        procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

        procedure SetBorderColor(const Value: TColor);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        
    protected
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure Loaded(); override;

    public
        constructor Create(AOwner: TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;                    
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;

        // scroll bar
        property VScrollBar : TsuiScrollBar read m_VScrollBar write SetVScrollBar;
        property HScrollBar : TsuiScrollBar read m_HScrollBar write SetHScrollBar;

    end;

    TsuiDBImage = class(TDBImage)
    private
        m_BorderColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;

        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);

        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;
        procedure SetBorderColor(const Value: TColor);
        procedure WMPAINT(var Msg : TMessage); message WM_PAINT;

    protected
        procedure Notification(AComponent: TComponent;
          Operation: TOperation); override;

    public
        constructor Create(AOwner: TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;

    end;

    TsuiDBListBox = class(TDBListBox)
    private
        m_BorderColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;

        // scroll bar
        m_VScrollBar : TsuiScrollBar;
        m_MouseDown : Boolean;
        m_SelfChanging : Boolean;
        procedure SetVScrollBar(const Value: TsuiScrollBar);
        procedure OnVScrollBarChange(Sender : TObject);
        procedure UpdateScrollBars();
        procedure UpdateScrollBarsPos();

        procedure CMEnabledChanged(var Msg : TMessage); message CM_ENABLEDCHANGED;
        procedure CMVisibleChanged(var Msg : TMEssage); message CM_VISIBLECHANGED;
        procedure WMSIZE(var Msg : TMessage); message WM_SIZE;
        procedure WMMOVE(var Msg : TMessage); message WM_MOVE;
        procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
        procedure WMLBUTTONDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
        procedure WMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
        procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
        procedure LBADDSTRING(var Msg : TMessage); message LB_ADDSTRING;
        procedure LBDELETESTRING(var Msg : TMessage); message LB_DELETESTRING;
        procedure LBINSERTSTRING(var Msg : TMessage); message LB_INSERTSTRING;
        procedure LBSETCOUNT(var Msg : TMessage); message LB_SETCOUNT;
        procedure LBNSELCHANGE(var Msg : TMessage); message LBN_SELCHANGE;
        procedure LBNSETFOCUS(var Msg : TMessage); message LBN_SETFOCUS;
        procedure WMDELETEITEM(var Msg : TMessage); message WM_DELETEITEM;
        procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
        procedure WMVSCROLL(var Message: TWMVScroll); message WM_VSCROLL;
        procedure WMHSCROLL(var Message: TWMHScroll); message WM_HSCROLL;

        procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

        procedure SetBorderColor(const Value: TColor);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        
    protected
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure Loaded(); override;

    public
        constructor Create(AOwner : TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;                    
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;

        // scroll bar
        property VScrollBar : TsuiScrollBar read m_VScrollBar write SetVScrollBar;

    end;

    TsuiDBComboBox = class(TDBComboBox)
    private
        m_BorderColor : TColor;
        m_ButtonColor : TColor;
        m_ArrowColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;

        procedure SetBorderColor(const Value: TColor);
        procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;
{$IFDEF SUIPACK_D5}
        procedure CBNCloseUp(var Msg : TWMCommand); message CN_COMMAND;
{$ENDIF}
        procedure DrawButton();
        procedure DrawArrow(const ACanvas : TCanvas;X, Y : Integer);

        procedure SetArrowColor(const Value: TColor);
        procedure SetButtonColor(const Value: TColor);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure SetFileTheme(const Value: TsuiFileTheme);

    protected
        procedure SetEnabled(Value: Boolean); override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;        
{$IFDEF SUIPACK_D5}
        procedure CloseUp(); virtual;
{$ENDIF}

    public
        constructor Create(AOwner : TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;
        property ArrowColor : TColor read m_ArrowColor write SetArrowColor;
        property ButtonColor : TColor read m_ButtonColor write SetButtonColor;
    end;

    TsuiDBCheckBox = class(TsuiCheckBox)
    private
        FDataLink: TFieldDataLink;
        FValueCheck: string;
        FValueUncheck: string;
        FPaintControl: TPaintControl;
        procedure DataChange(Sender: TObject);
        function GetDataField: string;
        function GetDataSource: TDataSource;
        function GetField: TField;
        function GetFieldState: TCheckBoxState;
        function GetReadOnly: Boolean;
        procedure SetDataField(const Value: string);
        procedure SetDataSource(Value: TDataSource);
        procedure SetReadOnly(Value: Boolean);
        procedure SetValueCheck(const Value: string);
        procedure SetValueUncheck(const Value: string);
        procedure UpdateData(Sender: TObject);
        function ValueMatch(const ValueList, Value: string): Boolean;
        procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
        procedure CMExit(var Message: TCMExit); message CM_EXIT;
        procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;

    protected
        procedure Toggle; override;
        procedure KeyPress(var Key: Char); override;
        procedure Notification(AComponent: TComponent;
          Operation: TOperation); override;
        procedure WndProc(var Message: TMessage); override;

    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        function ExecuteAction(Action: TBasicAction): Boolean; override;
        function UpdateAction(Action: TBasicAction): Boolean; override;
        function UseRightToLeftAlignment: Boolean; override;
        property Checked;
        property Field: TField read GetField;
        property State;

    published
        property DataField: string read GetDataField write SetDataField;
        property DataSource: TDataSource read GetDataSource write SetDataSource;
        property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
        property ValueChecked: string read FValueCheck write SetValueCheck;
        property ValueUnchecked: string read FValueUncheck write SetValueUncheck;

    end;

    TsuiDBRadioGroup = class(TsuiRadioGroup)
    private
        FDataLink: TFieldDataLink;
        FValue: string;
        FValues: TStrings;
        FInSetValue: Boolean;
        FOnChange: TNotifyEvent;

        procedure DataChange(Sender: TObject);
        procedure UpdateData(Sender: TObject);
        function GetDataField: string;
        function GetDataSource: TDataSource;
        function GetField: TField;
        function GetReadOnly: Boolean;
        function GetButtonValue(Index: Integer): string;
        procedure SetDataField(const Value: string);
        procedure SetDataSource(Value: TDataSource);
        procedure SetReadOnly(Value: Boolean);
        procedure SetValue(const Value: string);
        procedure SetItems(Value: TStrings);
        procedure SetValues(Value: TStrings);
        procedure CMExit(var Message: TCMExit); message CM_EXIT;
        procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;

    protected
        procedure Change; dynamic;        
        procedure NewClick; override;
        procedure KeyPress(var Key: Char); override;
        function CanModify: Boolean; override;
        procedure Notification(AComponent: TComponent;
          Operation: TOperation); override;
        property DataLink: TFieldDataLink read FDataLink;

      public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        function ExecuteAction(Action: TBasicAction): Boolean; override;
        function UpdateAction(Action: TBasicAction): Boolean; override;
        function UseRightToLeftAlignment: Boolean; override;
        property Field: TField read GetField;
        property ItemIndex;
        property Value: string read FValue write SetValue;

      published
        property DataField: string read GetDataField write SetDataField;
        property DataSource: TDataSource read GetDataSource write SetDataSource;
        property Items write SetItems;
        property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
        property Values: TStrings read FValues write SetValues;

        property OnChange: TNotifyEvent read FOnChange write FOnChange;
        property TabStop;
        property TabOrder;

    end;

    TsuiDBLookupListBox = class(TDBLookupListBox)
    private
        m_BorderColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;

        // scroll bar
        m_VScrollBar : TsuiScrollBar;
        m_MouseDown : Boolean;
        m_SelfChanging : Boolean;
        procedure SetVScrollBar(const Value: TsuiScrollBar);
        procedure OnVScrollBarChange(Sender : TObject);
        procedure UpdateScrollBars();
        procedure UpdateScrollBarsPos();

        procedure CMEnabledChanged(var Msg : TMessage); message CM_ENABLEDCHANGED;
        procedure WMSIZE(var Msg : TMessage); message WM_SIZE;
        procedure WMMOVE(var Msg : TMessage); message WM_MOVE;
        procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
        procedure WMLBUTTONDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
        procedure WMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
        procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
        procedure LBADDSTRING(var Msg : TMessage); message LB_ADDSTRING;
        procedure LBDELETESTRING(var Msg : TMessage); message LB_DELETESTRING;
        procedure LBINSERTSTRING(var Msg : TMessage); message LB_INSERTSTRING;
        procedure LBSETCOUNT(var Msg : TMessage); message LB_SETCOUNT;
        procedure LBNSELCHANGE(var Msg : TMessage); message LBN_SELCHANGE;
        procedure LBNSETFOCUS(var Msg : TMessage); message LBN_SETFOCUS;
        procedure WMDELETEITEM(var Msg : TMessage); message WM_DELETEITEM;
        procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
        procedure WMVSCROLL(var Message: TWMVScroll); message WM_VSCROLL;
        procedure WMHSCROLL(var Message: TWMHScroll); message WM_HSCROLL;

        procedure WMPAINT(var Msg : TMessage); message WM_PAINT;
        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;

        procedure SetBorderColor(const Value: TColor);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        
    protected
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure Loaded(); override;

    public
        constructor Create(AOwner : TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;                    
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;

        // scroll bar
        property VScrollBar : TsuiScrollBar read m_VScrollBar write SetVScrollBar;

    end;

    TsuiDBLookupComboBox = class(TDBLookupComboBox)
    private
        m_BorderColor : TColor;
        m_ButtonColor : TColor;
        m_ArrowColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;

        procedure SetBorderColor(const Value: TColor);
        procedure DrawButton();
        procedure DrawArrow(const ACanvas : TCanvas;X, Y : Integer);

        procedure SetArrowColor(const Value: TColor);
        procedure SetButtonColor(const Value: TColor);
        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure SetFileTheme(const Value: TsuiFileTheme);

    protected
        procedure SetEnabled(Value: Boolean); override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure Paint(); override;        

    public
        constructor Create(AOwner : TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;
        property ArrowColor : TColor read m_ArrowColor write SetArrowColor;
        property ButtonColor : TColor read m_ButtonColor write SetButtonColor;

    end;

const
    InitRepeatPause = 400;  { pause before repeat timer (ms) }
    RepeatPause     = 100;  { pause before hint window displays (ms)}
    SpaceSize       =  5;   { size of space between special buttons }

type
    TsuiNavButton = class;
    TsuiNavDataLink = class;

    ENavClick = procedure (Sender: TObject; Button: TNavigateBtn) of object;

{ TsuiDBNavigator }

    TsuiDBNavigator = class (TCustomPanel)
    private
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;
        m_Cursor : TCursor;

        FDataLink: TsuiNavDataLink;
        FVisibleButtons: TButtonSet;
        FHints: TStrings;
        FDefHints: TStrings;
        ButtonWidth: Integer;
        MinBtnSize: TPoint;
        FOnNavClick: ENavClick;
        FBeforeAction: ENavClick;
        FocusedButton: TNavigateBtn;
        FConfirmDelete: Boolean;
        procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
        procedure ClickHandler(Sender: TObject);
        function GetDataSource: TDataSource;
        function GetHints: TStrings;
        procedure HintsChanged(Sender: TObject);
        procedure InitButtons;
        procedure InitHints;
        procedure SetDataSource(Value: TDataSource);
        procedure SetHints(Value: TStrings);
        procedure SetSize(var W: Integer; var H: Integer);
        procedure SetVisible(Value: TButtonSet);
        procedure WMSize(var Message: TWMSize);  message WM_SIZE;
        procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
        procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
        procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
        procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
        procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetCursor(const Value: TCursor);
    protected
        Buttons: array[TNavigateBtn] of TsuiNavButton;
        procedure DataChanged;
        procedure EditingChanged;
        procedure ActiveChanged;
        procedure Loaded; override;
        procedure KeyDown(var Key: Word; Shift: TShiftState); override;
        procedure Notification(AComponent: TComponent;
          Operation: TOperation); override;
        procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
        procedure CalcMinSize(var W, H: Integer);

    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
        procedure BtnClick(Index: TNavigateBtn); virtual;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;

        property DataSource: TDataSource read GetDataSource write SetDataSource;
        property VisibleButtons: TButtonSet read FVisibleButtons write SetVisible
          default [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete,
            nbEdit, nbPost, nbCancel, nbRefresh];
        property Cursor : TCursor read m_Cursor write SetCursor;
        property Align;
        property Anchors;
        property Constraints;
        property DragCursor;
        property DragKind;
        property DragMode;
        property Enabled;
        property Hints: TStrings read GetHints write SetHints;
        property ParentCtl3D;
        property ParentShowHint;
        property PopupMenu;
        property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
        property ShowHint;
        property TabOrder;
        property TabStop;
        property Visible;
        property BeforeAction: ENavClick read FBeforeAction write FBeforeAction;
        property OnClick: ENavClick read FOnNavClick write FOnNavClick;
        property OnContextPopup;
        property OnDblClick;
        property OnDragDrop;
        property OnDragOver;
        property OnEndDock;
        property OnEndDrag;
        property OnEnter;
        property OnExit;
        property OnResize;
        property OnStartDock;
        property OnStartDrag;
    end;

{ TsuiNavButton }

    TsuiNavButton = class(TsuiButton)
    private
        FIndex: TNavigateBtn;
        FNavStyle: TNavButtonStyle;
        FRepeatTimer: TTimer;
        procedure TimerExpired(Sender: TObject);

    protected
        procedure Paint; override;
        procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
          X, Y: Integer); override;
        procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
          X, Y: Integer); override;
    public
        constructor Create(AOwner : TComponent); override;
        destructor Destroy; override;
        property NavStyle: TNavButtonStyle read FNavStyle write FNavStyle;
        property Index : TNavigateBtn read FIndex write FIndex;
    end;

{ TsuiNavDataLink }

    TsuiNavDataLink = class(TDataLink)
    private
        FNavigator: TsuiDBNavigator;
    protected
        procedure EditingChanged; override;
        procedure DataSetChanged; override;
        procedure ActiveChanged; override;
    public
        constructor Create(ANav: TsuiDBNavigator);
        destructor Destroy; override;
    end;

    TsuiDBGrid = class(TDBGrid)
    private
        m_BorderColor : TColor;
        m_FocusedColor : TColor;
        m_SelectedColor : TColor;
        m_UIStyle : TsuiUIStyle;
        m_FileTheme : TsuiFileTheme;
        m_MouseDown : Boolean;
        
        // scroll bar
        m_VScrollBar : TsuiScrollBar;
        m_HScrollBar : TsuiScrollBar;
        m_SelfChanging : Boolean;
        m_UserChanging : Boolean;

        procedure SetHScrollBar(const Value: TsuiScrollBar);
        procedure SetVScrollBar(const Value: TsuiScrollBar);
        procedure OnHScrollBarChange(Sender : TObject);
        procedure OnVScrollBarChange(Sender : TObject);
        procedure UpdateScrollBars();
        procedure UpdateScrollBarsPos();

        procedure CMEnabledChanged(var Msg : TMessage); message CM_ENABLEDCHANGED;
        procedure CMVisibleChanged(var Msg : TMEssage); message CM_VISIBLECHANGED;
        procedure CMBIDIMODECHANGED(var Msg : TMessage); message CM_BIDIMODECHANGED;
        procedure WMSIZE(var Msg : TMessage); message WM_SIZE;
        procedure WMMOVE(var Msg : TMessage); message WM_MOVE;
        procedure WMCut(var Message: TMessage); message WM_Cut;
        procedure WMPaste(var Message: TMessage); message WM_PASTE;
        procedure WMClear(var Message: TMessage); message WM_CLEAR;
        procedure WMUndo(var Message: TMessage); message WM_UNDO;
        procedure WMLBUTTONDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
        procedure WMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
        procedure WMMOUSEWHEEL(var Message: TMessage); message WM_MOUSEWHEEL;
        procedure WMSetText(var Message:TWMSetText); message WM_SETTEXT;
        procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
        procedure WMMOUSEMOVE(var Message: TMessage); message WM_MOUSEMOVE;
        procedure WMVSCROLL(var Message: TWMVScroll); message WM_VSCROLL;
        procedure WMHSCROLL(var Message: TWMHScroll); message WM_HSCROLL;

        procedure SetBorderColor(const Value: TColor);
        procedure WMEARSEBKGND(var Msg : TMessage); message WM_ERASEBKGND;
        procedure SetUIStyle(const Value: TsuiUIStyle);
        procedure SetFileTheme(const Value: TsuiFileTheme);
        procedure SetFocusedColor(const Value: TColor);
        procedure SetSelectedColor(const Value: TColor);
        function GetFontColor: TColor;
        procedure SetFontColor(const Value: TColor);
        function GetTitleFontColor: TColor;
        procedure SetTitleFontColor(const Value: TColor);
        function GetFixedBGColor: TColor;
        procedure SetFixedBGColor(const Value: TColor);
        function GetBGColor: TColor;
        procedure SetBGColor(const Value: TColor);

    protected
        procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
        procedure DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState); override;

        procedure Paint(); override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure Loaded(); override;

    public
        constructor Create (AOwner: TComponent); override;

    published
        property FileTheme : TsuiFileTheme read m_FileTheme write SetFileTheme;
        property UIStyle : TsuiUIStyle read m_UIStyle write SetUIStyle;
        property BorderColor : TColor read m_BorderColor write SetBorderColor;
        property FocusedColor : TColor read m_FocusedColor write SetFocusedColor;
        property SelectedColor : TColor read m_SelectedColor write SetSelectedColor;
        property FontColor : TColor read GetFontColor write SetFontColor;
        property TitleFontColor : TColor read GetTitleFontColor write SetTitleFontColor;
        property FixedBGColor : TColor read GetFixedBGColor write SetFixedBGColor;
        property BGColor : TColor read GetBGColor write SetBGColor;
        // scroll bar
        property VScrollBar : TsuiScrollBar read m_VScrollBar write SetVScrollBar;
        property HScrollBar : TsuiScrollBar read m_HScrollBar write SetHScrollBar;

    end;

implementation

uses SUIPublic, SUIProgressBar;

{ TsuiDBEdit }

constructor TsuiDBEdit.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    ControlStyle := ControlStyle + [csOpaque];
    BorderStyle := bsNone;
    BorderWidth := 2;

    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiDBEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited Notification(AComponent, Operation);
    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);
    end;
end;

procedure TsuiDBEdit.WMPaint(var Message: TWMPaint);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiDBEdit.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiDBEdit.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiDBEdit.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR)
    else
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);
    Repaint();
end;

procedure TsuiDBEdit.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

{ TsuiDBMemo }

constructor TsuiDBMemo.Create(AOwner: TComponent);
begin
    inherited;
    
    ControlStyle := ControlStyle + [csOpaque];
    BorderStyle := bsNone;
    BorderWidth := 2;
    m_SelfChanging := false;
    m_UserChanging := false;
    m_MouseDown := false;
    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiDBMemo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if AComponent = nil then
        Exit;

    if (
        (Operation = opRemove) and
        (AComponent = m_HScrollBar)
    )then
    begin
        m_HScrollBar := nil;
        UpdateInnerScrollBars();
    end;

    if (
        (Operation = opRemove) and
        (AComponent = m_VScrollBar)
    )then
    begin
        m_VScrollBar := nil;
        UpdateInnerScrollBars();
    end;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);          
    end;
end;

procedure TsuiDBMemo.WMCut(var Message: TMessage);
begin
  inherited;
  UpdateScrollBars();
end;

procedure TsuiDBMemo.WMUndo(var Message: TMessage);
begin
  inherited;
  UpdateScrollBars();
end;

procedure TsuiDBMemo.WMPaste(var Message: TMessage);
begin
  inherited;
  UpdateScrollBars();
end;

procedure TsuiDBMemo.WMPaint(var Msg : TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiDBMemo.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiDBMemo.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiDBMemo.CMEnabledChanged(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBMemo.OnHScrollBarChange(Sender: TObject);
begin
    if m_SelfChanging then
        Exit;
    m_UserChanging := true;
    SendMessage(Handle, WM_HSCROLL, MakeWParam(SB_THUMBPOSITION, m_HScrollBar.Position), 0);
    Invalidate;
    m_UserChanging := false;
end;

procedure TsuiDBMemo.OnVScrollBarChange(Sender: TObject);
begin
    if m_SelfChanging then
        Exit;
    m_UserChanging := true;
    SendMessage(Handle, WM_VSCROLL, MakeWParam(SB_THUMBPOSITION, m_VScrollBar.Position), 0);
    Invalidate;
    m_UserChanging := false;
end;

procedure TsuiDBMemo.SetHScrollBar(const Value: TsuiScrollBar);
begin
    if m_HScrollBar = Value then
        Exit;
    if m_HScrollBar <> nil then
    begin
        m_HScrollBar.OnChange := nil;
        m_HScrollBar.LineButton := 0;
        m_HScrollBar.Max := 100;
        m_HScrollBar.Enabled := true;
    end;

    m_HScrollBar := Value;
    if m_HScrollBar = nil then
    begin
        UpdateInnerScrollBars();
        Exit;
    end;
    m_HScrollBar.Orientation := suiHorizontal;
    m_HScrollBar.OnChange := OnHScrollBarChange;
    m_HScrollBar.BringToFront();
    UpdateInnerScrollBars();

    UpdateScrollBarsPos();
end;

procedure TsuiDBMemo.SetVScrollBar(const Value: TsuiScrollBar);
begin
    if m_VScrollBar = Value then
        Exit;
    if m_VScrollBar <> nil then
    begin
        m_VScrollBar.OnChange := nil;
        m_VScrollBar.LineButton := 0;
        m_VScrollBar.Max := 100;
        m_VScrollBar.Enabled := true;
    end;

    m_VScrollBar := Value;
    if m_VScrollBar = nil then
    begin
        UpdateInnerScrollBars();
        Exit;
    end;
    m_VScrollBar.Orientation := suiVertical;
    m_VScrollBar.OnChange := OnVScrollBArChange;
    m_VScrollBar.BringToFront();
    UpdateInnerScrollBars();

    UpdateScrollBarsPos();
end;

procedure TsuiDBMemo.UpdateInnerScrollBars;
begin
    if (m_VScrollBar <> nil) and (m_HScrollBar <> nil) then
        ScrollBars := ssBoth
    else if (m_VScrollBar <> nil) and (m_HScrollBar = nil) then
        ScrollBars := ssVertical
    else if (m_HScrollBar <> nil) and (m_VScrollBar = nil) then
        ScrollBars := ssHorizontal
    else
        ScrollBars := ssNone;
end;

procedure TsuiDBMemo.UpdateScrollBars;
var
    info : tagScrollInfo;
    barinfo : tagScrollBarInfo;
begin
    if m_UserChanging then
        Exit;
    m_SelfChanging := true;
    if m_HScrollBar <> nil then
    begin
        barinfo.cbSize := SizeOf(barinfo);
        if not SUIGetScrollBarInfo(Handle, Integer(OBJID_HSCROLL), barinfo) then
        begin
            m_HScrollBar.Visible := false;
        end
        else if (barinfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) or
           (barinfo.rgstate[0] = STATE_SYSTEM_UNAVAILABLE) or
           (not Enabled) then
        begin
            m_HScrollBar.LineButton := 0;
            m_HScrollBar.Enabled := false;
            m_HScrollBar.SliderVisible := false;
        end
        else
        begin
            m_HScrollBar.LineButton := abs(barinfo.xyThumbBottom - barinfo.xyThumbTop);
            m_HScrollBar.SmallChange := 3 * m_HScrollBar.PageSize;
            m_HScrollBar.Enabled := true;
            m_HScrollBar.SliderVisible := true;
        end;
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_HORZ, info);
        m_HScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_HScrollBar.Min := info.nMin;
        m_HScrollBar.Position := info.nPos;
    end;

    if m_VScrollBar <> nil then
    begin
        barinfo.cbSize := SizeOf(barinfo);
        if not SUIGetScrollBarInfo(Handle, Integer(OBJID_VSCROLL), barinfo) then
        begin
            m_VScrollBar.Visible := false;
        end
        else if (barinfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) or
           (barinfo.rgstate[0] = STATE_SYSTEM_UNAVAILABLE) or
           (not Enabled) then
        begin
            m_VScrollBar.LineButton := 0;
            m_VScrollBar.Enabled := false;
            m_VScrollBar.SliderVisible := false;
        end
        else
        begin
            m_VScrollBar.LineButton := abs(barinfo.xyThumbBottom - barinfo.xyThumbTop);
            m_VScrollBar.Enabled := true;
            m_VScrollBar.SliderVisible := true;
        end;
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_VERT, info);
        m_VScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_VScrollBar.Min := info.nMin;
        m_VScrollBar.Position := info.nPos;
    end;
    m_SelfChanging := false;
end;

procedure TsuiDBMemo.UpdateScrollBarsPos;
var
    L2R : Boolean;
begin
    L2R := ((BidiMode = bdLeftToRight) or (BidiMode = bdRightToLeftReadingOnly)) or (not SysLocale.MiddleEast);

    if m_HScrollBar <> nil then
    begin
        if L2R then
        begin
            m_HScrollBar.Left := Left + 1;
            m_HScrollBar.Top := Top + Height - m_HScrollBar.Height - 2;
            if m_VScrollBar <> nil then
                m_HScrollBar.Width := Width - 2 - m_VScrollBar.Width
            else
                m_HScrollBar.Width := Width - 2
        end
        else
        begin
            m_HScrollBar.Top := Top + Height - m_HScrollBar.Height - 2;
            if m_VScrollBar <> nil then
            begin
                m_HScrollBar.Left := Left + m_VScrollBar.Width + 1;
                m_HScrollBar.Width := Width - 2 - m_VScrollBar.Width
            end
            else
            begin
                m_HScrollBar.Left := Left + 1;
                m_HScrollBar.Width := Width - 2;
            end;
        end;
    end;

    if m_VScrollBar <> nil then
    begin
        if L2R then
        begin
            m_VScrollBar.Left := Left + Width - m_VScrollBar.Width - 2;
            m_VScrollBar.Top := Top + 1;
            if m_HScrollBar <> nil then
                m_VScrollBar.Height := Height - 2 - m_HScrollBar.Height
            else
                m_VScrollBar.Height := Height - 2;
        end
        else
        begin
            m_VScrollBar.Left := Left + 2;
            m_VScrollBar.Top := Top + 1;
            if m_HScrollBar <> nil then
                m_VScrollBar.Height := Height - 2 - m_HScrollBar.Height
            else
                m_VScrollBar.Height := Height - 2;
        end;
    end;

    UpdateScrollBars();    
end;

procedure TsuiDBMemo.WMClear(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBMemo.WMKeyDown(var Message: TWMKeyDown);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBMemo.WMLBUTTONDOWN(var Message: TMessage);
begin
    inherited;
    m_MouseDown := true;
    UpdateScrollBars();
end;

procedure TsuiDBMemo.WMMOUSEWHEEL(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBMemo.WMMOVE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBMemo.WMSetText(var Message: TWMSetText);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBMemo.WMSIZE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBMemo.WMHSCROLL(var Message: TWMHScroll);
begin
    inherited;
    if m_UserChanging then
        Exit;

    UpdateScrollBars();
end;

procedure TsuiDBMemo.WMLButtonUp(var Message: TMessage);
begin
    inherited;
    m_MouseDown := false;
end;

procedure TsuiDBMemo.WMMOUSEMOVE(var Message: TMessage);
begin
    inherited;
    if m_MouseDown then UpdateScrollBars();
end;

procedure TsuiDBMemo.WMVSCROLL(var Message: TWMVScroll);
begin
    inherited;
    if m_UserChanging then
        Exit;

    UpdateScrollBars();
end;

procedure TsuiDBMemo.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    if m_VScrollBar <> nil then
        m_VScrollBar.FileTheme := Value;
    if m_HScrollBar <> nil then
        m_HScrollBar.FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiDBMemo.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;

    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR)
    else
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);

    if m_VScrollBar <> nil then
        m_VScrollBar.UIStyle := OutUIStyle;
    if m_HScrollBar <> nil then
        m_HScrollBar.UIStyle := OutUIStyle;    
    Repaint();
end;

procedure TsuiDBMemo.CMVisibleChanged(var Msg: TMessage);
begin
    inherited;

    if not Visible then
    begin
        if m_VScrollBar <> nil then
            m_VScrollBar.Visible := Visible;
        if m_HScrollBar <> nil then
            m_HScrollBar.Visible := Visible;
    end
    else
        UpdateScrollBarsPos();
end;

procedure TsuiDBMemo.Loaded;
begin
    inherited;
    UpdateScrollBarsPos();
end;

{ TsuiDBImage }

constructor TsuiDBImage.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    BorderWidth := 2;

    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiDBImage.Notification(AComponent: TComponent;  Operation: TOperation);
begin
    inherited;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);          
    end;
end;

procedure TsuiDBImage.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiDBImage.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiDBImage.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR)
    else
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);
    Repaint();
end;

procedure TsuiDBImage.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiDBImage.WMPAINT(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

{ TsuiDBListBox }

constructor TsuiDBListBox.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle + [csOpaque];
    BorderStyle := bsNone;
    BorderWidth := 2;
    m_SelfChanging := false;
    m_MouseDown := false;

    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiDBListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if AComponent = nil then
        Exit;

    if (
        (Operation = opRemove) and
        (AComponent = m_VScrollBar)
    )then
    begin
        m_VScrollBar := nil;
    end;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);          
    end;
end;

procedure TsuiDBListBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiDBListBox.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiDBListBox.WMPAINT(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, COlor);
end;

procedure TsuiDBListBox.CMEnabledChanged(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.LBADDSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.LBDELETESTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.LBINSERTSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.LBNSELCHANGE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.LBNSETFOCUS(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.LBSETCOUNT(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.OnVScrollBarChange(Sender: TObject);
begin
    if m_SelfChanging then
        Exit;
    SendMessage(Handle, WM_VSCROLL, MakeWParam(SB_THUMBPOSITION, m_VScrollBar.Position), 0);
    Invalidate;
end;

procedure TsuiDBListBox.SetVScrollBar(const Value: TsuiScrollBar);
begin
    if m_VScrollBar = Value then
        Exit;
    if m_VScrollBar <> nil then
    begin
        m_VScrollBar.OnChange := nil;
        m_VScrollBar.LineButton := 0;
        m_VScrollBar.Max := 100;
        m_VScrollBar.Enabled := true;
    end;

    m_VScrollBar := Value;
    if m_VScrollBar = nil then
        Exit;
    m_VScrollBar.Orientation := suiVertical;
    m_VScrollBar.OnChange := OnVScrollBArChange;
    m_VScrollBar.BringToFront();

    UpdateScrollBarsPos();
end;

procedure TsuiDBListBox.UpdateScrollBars;
var
    info : tagScrollInfo;
    barinfo : tagScrollBarInfo;
    R : Boolean;
begin
    m_SelfChanging := true;
    if m_VScrollBar <> nil then
    begin
        barinfo.cbSize := SizeOf(barinfo);
        R := SUIGetScrollBarInfo(Handle, Integer(OBJID_VSCROLL), barinfo);
        if (barinfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) or
           (barinfo.rgstate[0] = STATE_SYSTEM_UNAVAILABLE) or
           (not R) then
        begin
            m_VScrollBar.LineButton := 0;
            m_VScrollBar.Enabled := false;
            m_VScrollBar.Visible := false;
        end
        else if not Enabled then
            m_VScrollBar.Enabled := false
        else
        begin
            m_VScrollBar.LineButton := abs(barinfo.xyThumbBottom - barinfo.xyThumbTop);
            m_VScrollBar.Enabled := true;
            m_VScrollBar.Visible := true;
        end;
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_VERT, info);
        m_VScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_VScrollBar.Min := info.nMin;
        m_VScrollBar.Position := info.nPos;
    end;
    m_SelfChanging := false;
end;

procedure TsuiDBListBox.UpdateScrollBarsPos;
var
    L2R : Boolean;
begin
    if m_VScrollBar <> nil then
    begin
        L2R := ((BidiMode = bdLeftToRight) or (BidiMode = bdRightToLeftReadingOnly)) or (not SysLocale.MiddleEast);
        if L2R then
            m_VScrollBar.Left := Left + Width - m_VScrollBar.Width - 2
        else
            m_VScrollBar.Left := Left + 2;
        m_VScrollBar.Top := Top + 1;
        m_VScrollBar.Height := Height - 2;
    end;

    UpdateScrollBars();
end;

procedure TsuiDBListBox.WMDELETEITEM(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.WMKeyDown(var Message: TWMKeyDown);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.WMMOUSEWHEEL(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.WMMOVE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBListBox.WMSIZE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBListBox.WMHSCROLL(var Message: TWMHScroll);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.WMMOUSEMOVE(var Message: TMessage);
begin
    inherited;
    if m_MouseDown then UpdateScrollBars();
end;

procedure TsuiDBListBox.WMVSCROLL(var Message: TWMVScroll);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.WMLButtonUp(var Message: TMessage);
begin
    inherited;
    m_MouseDown := false;
end;

procedure TsuiDBListBox.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    if m_VScrollBar <> nil then
        m_VScrollBar.FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiDBListBox.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;

    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR)
    else
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);

    if m_VScrollBar <> nil then
        m_VScrollBar.UIStyle := OutUIStyle;
    Repaint();
end;

procedure TsuiDBListBox.WMLBUTTONDOWN(var Message: TMessage);
begin
    inherited;
    m_MouseDown := true;
    UpdateScrollBars();
end;

procedure TsuiDBListBox.CMVisibleChanged(var Msg: TMEssage);
begin
    inherited;
    if not Visible then
    begin
        if m_VScrollBar <> nil then
            m_VScrollBar.Visible := Visible;
    end
    else
        UpdateScrollBarsPos();
end;

procedure TsuiDBListBox.Loaded;
begin
    inherited;
    UpdateScrollBarsPos();
end;

{ TsuiDBComboBox }

constructor TsuiDBComboBox.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    ControlStyle := ControlStyle + [csOpaque];
    BorderWidth := 0;

    UIStyle := GetSUIFormStyle(AOwner);

end;

procedure TsuiDBComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);          
    end;
end;

procedure TsuiDBComboBox.WMPaint(var Msg: TMessage);
begin
    inherited;

    DrawButton();
end;

procedure TsuiDBComboBox.DrawArrow(const ACanvas: TCanvas; X, Y: Integer);
begin
    if not Enabled then
    begin
        ACanvas.Brush.Color := clWhite;
        ACanvas.Pen.Color := clWhite;
        ACanvas.Polygon([Point(X + 1, Y + 1), Point(X + 7, Y + 1), Point(X + 4, Y + 4)]);
        ACanvas.Brush.Color := clGray;
        ACanvas.Pen.Color := clGray;
    end
    else
    begin
        ACanvas.Brush.Color := m_ArrowColor;
        ACanvas.Pen.Color := m_ArrowColor;
    end;

    ACanvas.Polygon([Point(X, Y), Point(X + 6, Y), Point(X + 3, Y + 3)]);
end;

procedure TsuiDBComboBox.DrawButton;
var
    R, ListRect : TRect;
    X, Y : Integer;
    Btn : graphics.TBitmap;
    pcbi : tagCOMBOBOXINFO;
    C: TControlCanvas;
    DesktopCanvas : TCanvas;
begin
    pcbi.cbSize := SizeOf(pcbi);
    if not SUIGetComboBoxInfo(Handle, pcbi) then
        Exit;

    // draw border
    C := TControlCanvas.Create;

    C.Control := Self;
    with C do
    begin
        C.Brush.Color := m_BorderColor;
        R := ClientRect;
        FrameRect(R);
        C.Brush.Color := Color;
        InflateRect(R, -1, -1);
        FrameRect(R);
        GetWindowRect(pcbi.hwndList, ListRect);
        if DroppedDown then
        begin
            DesktopCanvas := TCanvas.Create();
            DesktopCanvas.Handle := GetWindowDC(0);
            DesktopCanvas.Brush.Color := m_BorderColor;
            DesktopCanvas.FrameRect(ListRect);
            ReleaseDC(0, DesktopCanvas.Handle);
            DesktopCanvas.Free();
        end
    end;

    // Draw button
    R := pcbi.rcButton;
    if {$IFDEF RES_MACOS} (m_UIStyle = MacOS) {$ELSE} false {$ENDIF} or
        {$IFDEF RES_WINXP} (m_UIStyle = WinXP){$ELSE} false {$ENDIF} then
    begin
        Btn := graphics.TBitmap.Create();
{$IFDEF RES_MACOS}
        if m_UIStyle = MacOS then
            Btn.LoadFromResourceName(hInstance, 'MACOS_COMBOBOX_BUTTON')
        else
{$ENDIF}
            Btn.LoadFromResourceName(hInstance, 'WINXP_COMBOBOX_BUTTON');
        C.StretchDraw(R, Btn);
        Btn.Free();
    end
    else
    begin
        C.Brush.Color := m_ButtonColor;
        C.FillRect(R);
        C.Pen.Color := m_BorderColor;
        if (BidiMode = bdRightToLeft) and SysLocale.MiddleEast then
        begin
            C.MoveTo(R.Right, R.Top - 1);
            C.LineTo(R.Right, R.Bottom + 1);
        end
        else
        begin
            C.MoveTo(R.Left, R.Top - 1);
            C.LineTo(R.Left, R.Bottom + 1);
        end;
    end;

    X := (R.Right - R.Left) div 2 + R.Left - 3;
    Y := (R.Bottom - R.Top) div 2;
    if {$IFDEF RES_WINXP}m_UIStyle <> WinXP{$ELSE} True {$ENDIF}  then
        DrawArrow(C, X, Y);

    C.Free;
end;

procedure TsuiDBComboBox.SetArrowColor(const Value: TColor);
begin
    m_ArrowColor := Value;
    Repaint();
end;

procedure TsuiDBComboBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiDBComboBox.SetButtonColor(const Value: TColor);
begin
    m_ButtonColor := Value;
    Repaint();
end;

procedure TsuiDBComboBox.SetEnabled(Value: Boolean);
begin
    inherited;
    Repaint();
end;

procedure TsuiDBComboBox.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;

    m_ArrowColor := clBlack;
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR);
        m_ButtonColor := m_FileTheme.GetColor(SKIN2_FORMCOLOR);
    end
    else
    begin
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);
        m_ButtonColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_FORM_BACKGROUND_COLOR);
    end;

    Repaint();
end;

procedure TsuiDBComboBox.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawButton();
end;
{$IFDEF SUIPACK_D5}
procedure TsuiDBComboBox.CBNCloseUp(var Msg: TWMCommand);
begin
    if Msg.NotifyCode = CBN_CLOSEUP then
        CloseUp()
    else
        inherited;
end;

procedure TsuiDBComboBox.CloseUp;
begin

end;
{$ENDIF}

procedure TsuiDBComboBox.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

{ TsuiDBLookupListBox }

procedure TsuiDBLookupListBox.CMEnabledChanged(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

constructor TsuiDBLookupListBox.Create(AOwner: TComponent);
begin
    inherited;
    
    ControlStyle := ControlStyle + [csOpaque];
    BorderStyle := bsNone;
    BorderWidth := 2;
    m_SelfChanging := false;
    m_MouseDown := false;

    UIStyle := GetSUIFormStyle(AOwner);
end;


procedure TsuiDBLookupListBox.LBADDSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.LBDELETESTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.LBINSERTSTRING(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.LBNSELCHANGE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.LBNSETFOCUS(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.LBSETCOUNT(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.Loaded;
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBLookupListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;
    
    if AComponent = nil then
        Exit;

    if (
        (Operation = opRemove) and
        (AComponent = m_VScrollBar)
    )then
    begin
        m_VScrollBar := nil;
    end;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);          
    end;
end;

procedure TsuiDBLookupListBox.OnVScrollBarChange(Sender: TObject);
begin
    if m_SelfChanging then
        Exit;
    SendMessage(Handle, WM_VSCROLL, MakeWParam(SB_THUMBPOSITION, m_VScrollBar.Position), 0);
    Invalidate;
end;

procedure TsuiDBLookupListBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiDBLookupListBox.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    if m_VScrollBar <> nil then
        m_VScrollBar.FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiDBLookupListBox.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;

    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR)
    else
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);

    if m_VScrollBar <> nil then
        m_VScrollBar.UIStyle := OutUIStyle;
    Repaint();
end;

procedure TsuiDBLookupListBox.SetVScrollBar(const Value: TsuiScrollBar);
begin
    if m_VScrollBar = Value then
        Exit;
    if m_VScrollBar <> nil then
    begin
        m_VScrollBar.OnChange := nil;
        m_VScrollBar.LineButton := 0;
        m_VScrollBar.Max := 100;
        m_VScrollBar.Enabled := true;
    end;

    m_VScrollBar := Value;
    if m_VScrollBar = nil then
        Exit;
    m_VScrollBar.Orientation := suiVertical;
    m_VScrollBar.OnChange := OnVScrollBArChange;
    m_VScrollBar.BringToFront();

    UpdateScrollBarsPos();
end;

procedure TsuiDBLookupListBox.UpdateScrollBars;
var
    info : tagScrollInfo;
    barinfo : tagScrollBarInfo;
    R : Boolean;
begin
    m_SelfChanging := true;
    if m_VScrollBar <> nil then
    begin
        barinfo.cbSize := SizeOf(barinfo);
        R := SUIGetScrollBarInfo(Handle, Integer(OBJID_VSCROLL), barinfo);
        if (barinfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) or
           (barinfo.rgstate[0] = STATE_SYSTEM_UNAVAILABLE) or
           (not R) then
        begin
            m_VScrollBar.LineButton := 0;
            m_VScrollBar.Enabled := false;
            m_VScrollBar.Visible := false;
        end
        else
        begin
            m_VScrollBar.LineButton := abs(barinfo.xyThumbBottom - barinfo.xyThumbTop);
            m_VScrollBar.Enabled := true;
            m_VScrollBar.Visible := true;
        end;
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_VERT, info);
        m_VScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_VScrollBar.Min := info.nMin;
        m_VScrollBar.Position := info.nPos;
    end;
    m_SelfChanging := false;
end;

procedure TsuiDBLookupListBox.UpdateScrollBarsPos;
var
    L2R : Boolean;
begin
    if m_VScrollBar <> nil then
    begin
        L2R := ((BidiMode = bdLeftToRight) or (BidiMode = bdRightToLeftReadingOnly)) or (not SysLocale.MiddleEast);
        if L2R then
            m_VScrollBar.Left := Left + Width - m_VScrollBar.Width - 2
        else
            m_VScrollBar.Left := Left + 2;
        m_VScrollBar.Top := Top + 1;
        m_VScrollBar.Height := Height - 2;
    end;

    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.WMDELETEITEM(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.WMEARSEBKGND(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiDBLookupListBox.WMHSCROLL(var Message: TWMHScroll);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.WMKeyDown(var Message: TWMKeyDown);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.WMLBUTTONDOWN(var Message: TMessage);
begin
    inherited;
    m_MouseDown := true;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.WMLButtonUp(var Message: TMessage);
begin
    inherited;
    m_MouseDown := false;
end;

procedure TsuiDBLookupListBox.WMMOUSEMOVE(var Message: TMessage);
begin
    inherited;
    if m_MouseDown then UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.WMMOUSEWHEEL(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBLookupListBox.WMMOVE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBLookupListBox.WMPAINT(var Msg: TMessage);
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, COlor);
end;

procedure TsuiDBLookupListBox.WMSIZE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBLookupListBox.WMVSCROLL(var Message: TWMVScroll);
begin
    inherited;
    UpdateScrollBars();
end;

{ TsuiDBCheckBox }

constructor TsuiDBCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  State := cbUnchecked;
  FValueCheck := 'True';
  FValueUncheck := 'False';
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FPaintControl := TPaintControl.Create(Self, 'BUTTON');
  FPaintControl.Ctl3DButton := True;
end;

destructor TsuiDBCheckBox.Destroy;
begin
  FPaintControl.Free;
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TsuiDBCheckBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TsuiDBCheckBox.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

function TsuiDBCheckBox.GetFieldState: TCheckBoxState;
var
  Text: string;
begin
  if FDatalink.Field <> nil then
    if FDataLink.Field.IsNull then
      Result := cbUnChecked
    else if FDataLink.Field.DataType = ftBoolean then
      if FDataLink.Field.AsBoolean then
        Result := cbChecked
      else
        Result := cbUnchecked
    else
    begin
      Result := cbUnChecked;
      Text := FDataLink.Field.Text;
      if ValueMatch(FValueCheck, Text) then Result := cbChecked else
        if ValueMatch(FValueUncheck, Text) then Result := cbUnchecked;
    end
  else
    Result := cbUnchecked;
end;

procedure TsuiDBCheckBox.DataChange(Sender: TObject);
var
    AState : TCheckBoxState;
begin
    AState := GetFieldState();
    State := AState;
end;

procedure TsuiDBCheckBox.UpdateData(Sender: TObject);
var
  Pos: Integer;
  S: string;
begin
  if State = cbGrayed then
    FDataLink.Field.Clear
  else
    if FDataLink.Field.DataType = ftBoolean then
      FDataLink.Field.AsBoolean := Checked
    else
    begin
      if Checked then S := FValueCheck else S := FValueUncheck;
      Pos := 1;
      FDataLink.Field.Text := ExtractFieldName(S, Pos);
    end;
end;

function TsuiDBCheckBox.ValueMatch(const ValueList, Value: string): Boolean;
var
  Pos: Integer;
begin
  Result := False;
  Pos := 1;
  while Pos <= Length(ValueList) do
    if AnsiCompareText(ExtractFieldName(ValueList, Pos), Value) = 0 then
    begin
      Result := True;
      Break;
    end;
end;

procedure TsuiDBCheckBox.Toggle;
begin
  if FDataLink.Edit then
  begin
    inherited Toggle;
    FDataLink.Modified;
  end;
end;

function TsuiDBCheckBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TsuiDBCheckBox.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TsuiDBCheckBox.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TsuiDBCheckBox.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TsuiDBCheckBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TsuiDBCheckBox.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TsuiDBCheckBox.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TsuiDBCheckBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  case Key of
    #8, ' ':
      FDataLink.Edit;
    #27:
      FDataLink.Reset;
  end;
end;

procedure TsuiDBCheckBox.SetValueCheck(const Value: string);
begin
  FValueCheck := Value;
  DataChange(Self);
end;

procedure TsuiDBCheckBox.SetValueUncheck(const Value: string);
begin
  FValueUncheck := Value;
  DataChange(Self);
end;

procedure TsuiDBCheckBox.WndProc(var Message: TMessage);
begin
  with Message do
    if (Msg = WM_CREATE) or (Msg = WM_WINDOWPOSCHANGED) or
      (Msg = CM_TEXTCHANGED) or (Msg = CM_FONTCHANGED) then
      FPaintControl.DestroyHandle;
  inherited;
end;

procedure TsuiDBCheckBox.WMPaint(var Message: TWMPaint);
begin
  if not (csPaintCopy in ControlState) then inherited else
  begin
    SendMessage(FPaintControl.Handle, BM_SETCHECK, Ord(GetFieldState), 0);
    SendMessage(FPaintControl.Handle, WM_PAINT, Message.DC, 0);
  end;
end;

procedure TsuiDBCheckBox.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TsuiDBCheckBox.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TsuiDBCheckBox.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TsuiDBCheckBox.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{ TsuiDBRadioGroup }

constructor TsuiDBRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FValues := TStringList.Create;
end;

destructor TsuiDBRadioGroup.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FValues.Free;
  inherited Destroy;
end;

procedure TsuiDBRadioGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TsuiDBRadioGroup.UseRightToLeftAlignment: Boolean;
begin
  Result := inherited UseRightToLeftAlignment;
end;

procedure TsuiDBRadioGroup.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then
    Value := FDataLink.Field.Text else
    Value := '';
end;

procedure TsuiDBRadioGroup.UpdateData(Sender: TObject);
begin
  if FDataLink.Field <> nil then FDataLink.Field.Text := Value;
end;

function TsuiDBRadioGroup.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TsuiDBRadioGroup.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TsuiDBRadioGroup.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TsuiDBRadioGroup.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TsuiDBRadioGroup.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TsuiDBRadioGroup.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

function TsuiDBRadioGroup.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TsuiDBRadioGroup.GetButtonValue(Index: Integer): string;
begin
  if (Index < FValues.Count) and (FValues[Index] <> '') then
    Result := FValues[Index]
  else if Index < Items.Count then
    Result := Items[Index]
  else
    Result := '';
end;

procedure TsuiDBRadioGroup.SetValue(const Value: string);
var
  I, Index: Integer;
begin
  if FValue <> Value then
  begin
    FInSetValue := True;
    try
      Index := -1;
      for I := 0 to Items.Count - 1 do
        if Value = GetButtonValue(I) then
        begin
          Index := I;
          Break;
        end;
      ItemIndex := Index;
    finally
      FInSetValue := False;
    end;
    FValue := Value;
    Change;
  end;
end;

procedure TsuiDBRadioGroup.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    if ItemIndex >= 0 then
      TRadioButton(Controls[ItemIndex]).SetFocus else
      TRadioButton(Controls[0]).SetFocus;
    raise;
  end;
  inherited;
end;

procedure TsuiDBRadioGroup.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

procedure TsuiDBRadioGroup.NewClick;
begin
  if not FInSetValue then
  begin
    if ItemIndex >= 0 then Value := GetButtonValue(ItemIndex);
    if FDataLink.Editing then FDataLink.Modified;
  end;
end;

procedure TsuiDBRadioGroup.SetItems(Value: TStrings);
begin
  Items.Assign(Value);
  DataChange(Self);
end;

procedure TsuiDBRadioGroup.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
  DataChange(Self);
end;

procedure TsuiDBRadioGroup.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TsuiDBRadioGroup.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  case Key of
    #8, ' ': FDataLink.Edit;
    #27: FDataLink.Reset;
  end;
end;

function TsuiDBRadioGroup.CanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;

function TsuiDBRadioGroup.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (DataLink <> nil) and
    DataLink.ExecuteAction(Action);
end;

function TsuiDBRadioGroup.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (DataLink <> nil) and
    DataLink.UpdateAction(Action);
end;

{ TsuiDBNavigator }

var
  BtnTypeName: array[TNavigateBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
    'LAST', 'INSERT', 'DELETE', 'EDIT', 'POST', 'CANCEL', 'REFRESH');
  BtnHintId: array[TNavigateBtn] of Pointer = (@SFirstRecord, @SPriorRecord,
    @SNextRecord, @SLastRecord, @SInsertRecord, @SDeleteRecord, @SEditRecord,
    @SPostEdit, @SCancelEdit, @SRefreshRecord);

constructor TsuiDBNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  FDataLink := TsuiNavDataLink.Create(Self);
  FVisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbInsert,
    nbDelete, nbEdit, nbPost, nbCancel, nbRefresh];
  FHints := TStringList.Create;
  TStringList(FHints).OnChange := HintsChanged;
  InitButtons;
  InitHints;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  Width := 250;
  Height := 30;
  ButtonWidth := 0;
  FocusedButton := nbFirst;
  FConfirmDelete := True;
  FullRepaint := False;

    UIStyle := GetSUIFormStyle(AOwner);
end;

destructor TsuiDBNavigator.Destroy;
begin
  FDefHints.Free;
  FDataLink.Free;
  FHints.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TsuiDBNavigator.InitButtons;
var
  I: TNavigateBtn;
  Btn: TsuiNavButton;
  X: Integer;
  TmpBmp : TBitmap;
begin
  MinBtnSize := Point(20, 18);
  X := 0;
  TmpBmp := TBitmap.Create();
  TmpBmp.LoadFromResourceName(hInstance, 'DBNAV_BUTTON');
  for I := Low(Buttons) to High(Buttons) do
  begin
    Btn := TsuiNavButton.Create(Self);
    Btn.Spacing := -1;
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    SpitBitmap(TmpBmp, Btn.Glyph, 10, ord(i) + 1);
    Btn.Enabled := False;
    Btn.Enabled := True;
    Btn.OnClick := ClickHandler;
    Btn.OnMouseDown := BtnMouseDown;
    Btn.Parent := Self;
    Buttons[I] := Btn;
    X := X + MinBtnSize.X;
  end;
  TmpBmp.Free();
  Buttons[nbPrior].NavStyle := Buttons[nbPrior].NavStyle + [nsAllowTimer];
  Buttons[nbNext].NavStyle  := Buttons[nbNext].NavStyle + [nsAllowTimer];
end;

procedure TsuiDBNavigator.InitHints;
var
  I: Integer;
  J: TNavigateBtn;
begin
  if not Assigned(FDefHints) then
  begin
    FDefHints := TStringList.Create;
    for J := Low(Buttons) to High(Buttons) do
      FDefHints.Add(LoadResString(BtnHintId[J]));
  end;
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].Hint := FDefHints[Ord(J)];
  J := Low(Buttons);
  for I := 0 to (FHints.Count - 1) do
  begin
    if FHints.Strings[I] <> '' then Buttons[J].Hint := FHints.Strings[I];
    if J = High(Buttons) then Exit;
    Inc(J);
  end;
end;

procedure TsuiDBNavigator.HintsChanged(Sender: TObject);
begin
  InitHints;
end;

procedure TsuiDBNavigator.SetHints(Value: TStrings);
begin
  if Value.Text = FDefHints.Text then
    FHints.Clear else
    FHints.Assign(Value);
end;

function TsuiDBNavigator.GetHints: TStrings;
begin
  if (csDesigning in ComponentState) and not (csWriting in ComponentState) and
     not (csReading in ComponentState) and (FHints.Count = 0) then
    Result := FDefHints else
    Result := FHints;
end;

procedure TsuiDBNavigator.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TsuiDBNavigator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);          
    end;
end;

procedure TsuiDBNavigator.SetVisible(Value: TButtonSet);
var
  I: TNavigateBtn;
  W, H: Integer;
begin
  W := Width;
  H := Height;
  FVisibleButtons := Value;
  for I := Low(Buttons) to High(Buttons) do
    Buttons[I].Visible := I in FVisibleButtons;
  SetSize(W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  Invalidate;
end;

procedure TsuiDBNavigator.CalcMinSize(var W, H: Integer);
var
  Count: Integer;
  I: TNavigateBtn;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  W := Max(W, Count * MinBtnSize.X);
  H := Max(H, MinBtnSize.Y);

  if Align = alNone then W := (W div Count) * Count;
end;

procedure TsuiDBNavigator.SetSize(var W: Integer; var H: Integer);
var
  Count: Integer;
  I: TNavigateBtn;
  Space, Temp, Remain: Integer;
  X: Integer;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  CalcMinSize(W, H);

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  ButtonWidth := W div Count;
  Temp := Count * ButtonWidth;
  if Align = alNone then W := Temp;

  X := 0;
  Remain := W - Temp;
  Temp := Count div 2;
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      Space := 0;
      if Remain <> 0 then
      begin
        Dec(Temp, Remain);
        if Temp < 0 then
        begin
          Inc(Temp, Count);
          Space := 1;
        end;
      end;
      Buttons[I].SetBounds(X, 0, ButtonWidth + Space, Height);
      Inc(X, ButtonWidth + Space);
    end
    else
      Buttons[I].SetBounds (Width + 1, 0, ButtonWidth, Height);
  end;
end;

procedure TsuiDBNavigator.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  if not HandleAllocated then SetSize(W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TsuiDBNavigator.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  W := Width;
  H := Height;
  SetSize(W, H);
end;

procedure TsuiDBNavigator.WMWindowPosChanging(var Message: TWMWindowPosChanging);
begin
  inherited;
  if (SWP_NOSIZE and Message.WindowPos.Flags) = 0 then
    CalcMinSize(Message.WindowPos.cx, Message.WindowPos.cy);
end;

procedure TsuiDBNavigator.ClickHandler(Sender: TObject);
begin
  BtnClick (TsuiNavButton (Sender).Index);
end;

procedure TsuiDBNavigator.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: TNavigateBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := TsuiNavButton (Sender).Index;
  if TabStop and (GetFocus <> Handle) and CanFocus then
  begin
    SetFocus;
    if (GetFocus <> Handle) then
      Exit;
  end
  else if TabStop and (GetFocus = Handle) and (OldFocus <> FocusedButton) then
  begin
    Buttons[OldFocus].Invalidate;
    Buttons[FocusedButton].Invalidate;
  end;
end;

procedure TsuiDBNavigator.BtnClick(Index: TNavigateBtn);
begin
  if (DataSource <> nil) and (DataSource.State <> dsInactive) then
  begin
    if not (csDesigning in ComponentState) and Assigned(FBeforeAction) then
      FBeforeAction(Self, Index);
    with DataSource.DataSet do
    begin
      case Index of
        nbPrior: Prior;
        nbNext: Next;
        nbFirst: First;
        nbLast: Last;
        nbInsert: Insert;
        nbEdit: Edit;
        nbCancel: Cancel;
        nbPost: Post;
        nbRefresh: Refresh;
        nbDelete:
          if not FConfirmDelete or
            (MessageDlg(SDeleteRecordQuestion, mtConfirmation,
            mbOKCancel, 0) <> idCancel) then Delete;
      end;
    end;
  end;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
end;

procedure TsuiDBNavigator.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TsuiDBNavigator.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TsuiDBNavigator.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: TNavigateBtn;
  OldFocus: TNavigateBtn;
begin
  OldFocus := FocusedButton;
  case Key of
    VK_RIGHT:
      begin
        if OldFocus < High(Buttons) then
        begin
          NewFocus := OldFocus;
          repeat
            NewFocus := Succ(NewFocus);
          until (NewFocus = High(Buttons)) or (Buttons[NewFocus].Visible);
          if Buttons[NewFocus].Visible then
          begin
            FocusedButton := NewFocus;
            Buttons[OldFocus].Invalidate;
            Buttons[NewFocus].Invalidate;
          end;
        end;
      end;
    VK_LEFT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus > Low(Buttons) then
            NewFocus := Pred(NewFocus);
        until (NewFocus = Low(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_SPACE:
      begin
        if Buttons[FocusedButton].Enabled then
          Buttons[FocusedButton].Click;
      end;
  end;
end;

procedure TsuiDBNavigator.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TsuiDBNavigator.DataChanged;
var
  UpEnable, DnEnable: Boolean;
begin
  UpEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.BOF;
  DnEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.EOF;
  Buttons[nbFirst].Enabled := UpEnable;
  Buttons[nbPrior].Enabled := UpEnable;
  Buttons[nbNext].Enabled := DnEnable;
  Buttons[nbLast].Enabled := DnEnable;
  Buttons[nbDelete].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF);
end;

procedure TsuiDBNavigator.EditingChanged;
var
  CanModify: Boolean;
begin
  CanModify := Enabled and FDataLink.Active and FDataLink.DataSet.CanModify;
  Buttons[nbInsert].Enabled := CanModify;
  Buttons[nbEdit].Enabled := CanModify and not FDataLink.Editing;
  Buttons[nbPost].Enabled := CanModify and FDataLink.Editing;
  Buttons[nbCancel].Enabled := CanModify and FDataLink.Editing;
  Buttons[nbRefresh].Enabled := CanModify;
end;

procedure TsuiDBNavigator.ActiveChanged;
var
  I: TNavigateBtn;
begin
  if not (Enabled and FDataLink.Active) then
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Enabled := False
  else
  begin
    DataChanged;
    EditingChanged;
  end;
end;

procedure TsuiDBNavigator.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    ActiveChanged;
end;

procedure TsuiDBNavigator.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if not (csLoading in ComponentState) then
    ActiveChanged;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TsuiDBNavigator.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TsuiDBNavigator.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  SetSize(W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  InitHints;
  ActiveChanged;
end;

procedure TsuiDBNavigator.SetUIStyle(const Value: TsuiUIStyle);
var
    i: TNavigateBtn;
begin
    m_UIStyle := Value;

    for i := Low(Buttons) to High(Buttons) do
    begin
        Buttons[i].FileTheme := m_FileTheme;
        Buttons[i].UIStyle := m_UIStyle;
    end;

    Repaint();
end;

procedure TsuiDBNavigator.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiDBNavigator.SetCursor(const Value: TCursor);
var
    i: TNavigateBtn;
begin
    m_Cursor := Value;
    inherited Cursor := Value;
    for i := Low(Buttons) to High(Buttons) do
        Buttons[i].Cursor := Value;
end;

{TsuiNavButton}

destructor TsuiNavButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TsuiNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if nsAllowTimer in FNavStyle then
  begin
    if FRepeatTimer = nil then
      FRepeatTimer := TTimer.Create(Self);

    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
end;

procedure TsuiNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure TsuiNavButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if m_MouseDown and MouseCapture then
  begin
    try
      TsuiDBNavigator(Parent).ClickHandler(self);
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

procedure TsuiNavButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if (GetFocus = Parent.Handle) and
     (FIndex = TsuiDBNavigator (Parent).FocusedButton) then
  begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if m_MouseDown then
      OffsetRect(R, 1, 1);
    Canvas.Brush.Style := bsSolid;
    Font.Color := clBtnShadow;
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

constructor TsuiNavButton.Create(AOwner: TComponent);
begin
    inherited;

    TabStop := false;
end;

{ TsuiNavDataLink }

constructor TsuiNavDataLink.Create(ANav: TsuiDBNavigator);
begin
  inherited Create;
  FNavigator := ANav;
  VisualControl := True;
end;

destructor TsuiNavDataLink.Destroy;
begin
  FNavigator := nil;
  inherited Destroy;
end;

procedure TsuiNavDataLink.EditingChanged;
begin
  if FNavigator <> nil then FNavigator.EditingChanged;
end;

procedure TsuiNavDataLink.DataSetChanged;
begin
  if FNavigator <> nil then FNavigator.DataChanged;
end;

procedure TsuiNavDataLink.ActiveChanged;
begin
  if FNavigator <> nil then FNavigator.ActiveChanged;
end;

{ TsuiDBGrid }

procedure TsuiDBGrid.CMBIDIMODECHANGED(var Msg: TMessage);
var
    L2R : Boolean;
    info : tagScrollInfo;    
begin
    inherited;
    
    L2R := ((BidiMode = bdLeftToRight) or (BidiMode = bdRightToLeftReadingOnly)) or (not SysLocale.MiddleEast);
    if (not L2R) and (m_HScrollBar <> nil) then
    begin
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_HORZ, info);
        m_HScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_HScrollBar.Min := info.nMin;
        m_HScrollBar.Position := m_HScrollBar.Max - info.nPos
    end;
end;

procedure TsuiDBGrid.CMEnabledChanged(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.CMVisibleChanged(var Msg: TMEssage);
begin
    inherited;

    if not Visible then
    begin
        if m_VScrollBar <> nil then
            m_VScrollBar.Visible := Visible;
        if m_HScrollBar <> nil then
            m_HScrollBar.Visible := Visible;
    end
    else
        UpdateScrollBarsPos();
end;

constructor TsuiDBGrid.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle + [csOpaque];
    m_MouseDown := false;
    BorderStyle := bsNone;
    BorderWidth := 1;
    UIStyle := GetSUIFormStyle(AOwner);
    FocusedColor := clGreen;
    SelectedColor := clYellow;
end;

procedure TsuiDBGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
    R : TRect;
begin
    R := ARect;

    if (ACol = -1) or (ARow = -1) then
        Exit;

    try
        if gdFixed in AState then
            Exit;

        if gdSelected in AState then
        begin
            Canvas.Brush.Color := m_SelectedColor;
        end;

        if gdFocused in AState then
        begin
            Canvas.Brush.Color := m_FocusedColor;
        end;

        if AState = [] then
            Canvas.Brush.Color := Color;

        Canvas.FillRect(R);
    finally
        inherited;
    end;
end;

procedure TsuiDBGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
    if gdSelected in State then
    begin
        Canvas.Font.Color := Font.Color;
        Canvas.Brush.Color := m_SelectedColor;
        DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;

    inherited;
end;

function TsuiDBGrid.GetBGColor: TColor;
begin
    Result := Color;
end;

function TsuiDBGrid.GetFixedBGColor: TColor;
begin
    Result := FixedColor;
end;

function TsuiDBGrid.GetFontColor: TColor;
begin
    Result := Font.Color;
end;

function TsuiDBGrid.GetTitleFontColor: TColor;
begin
    Result := TitleFont.Color;
end;

procedure TsuiDBGrid.Loaded;
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if (
        (Operation = opRemove) and
        (AComponent = m_HScrollBar)
    )then
    begin
        m_HScrollBar := nil;
    end;

    if (
        (Operation = opRemove) and
        (AComponent = m_VScrollBar)
    )then
    begin
        m_VScrollBar := nil;
    end;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);
    end;
end;

procedure TsuiDBGrid.OnHScrollBarChange(Sender: TObject);
begin
    if m_SelfChanging then
        Exit;
    m_UserChanging := true;
    SendMessage(Handle, WM_HSCROLL, MakeWParam(SB_THUMBPOSITION, m_HScrollBar.Position), 0);
    Invalidate;
    m_UserChanging := false;
end;

procedure TsuiDBGrid.OnVScrollBarChange(Sender: TObject);
begin
    if m_SelfChanging then
        Exit;
    m_UserChanging := true;
    if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    begin
        if m_VScrollBar.Position <= 1 then
            DataSource.DataSet.First()
        else if m_VScrollBar.Position >= DataSource.DataSet.RecordCount then
            DataSource.DataSet.Last()
        else
            DataSource.DataSet.RecNo := m_VScrollBar.Position
    end
    else
        SendMessage(Handle, WM_VSCROLL, MakeWParam(SB_THUMBPOSITION, m_VScrollBar.Position), 0);
    Invalidate;
    m_UserChanging := false;
end;

procedure TsuiDBGrid.Paint;
begin
    inherited;

    DrawControlBorder(self, m_BorderColor, Color);
end;

procedure TsuiDBGrid.SetBGColor(const Value: TColor);
begin
    Color := Value;
end;

procedure TsuiDBGrid.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiDBGrid.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiDBGrid.SetFixedBGColor(const Value: TColor);
begin
    FixedColor := Value;
end;

procedure TsuiDBGrid.SetFocusedColor(const Value: TColor);
begin
    m_FocusedColor := Value;
    Repaint();
end;

procedure TsuiDBGrid.SetFontColor(const Value: TColor);
begin
    Font.Color := Value;
end;

procedure TsuiDBGrid.SetHScrollBar(const Value: TsuiScrollBar);
begin
    if m_HScrollBar = Value then
        Exit;
    if m_HScrollBar <> nil then
    begin
        m_HScrollBar.OnChange := nil;
        m_HScrollBar.LineButton := 0;
        m_HScrollBar.Max := 100;
        m_HScrollBar.Enabled := true;
    end;

    m_HScrollBar := Value;
    if m_HScrollBar = nil then
        Exit;
    m_HScrollBar.Orientation := suiHorizontal;
    m_HScrollBar.OnChange := OnHScrollBarChange;
    m_HScrollBar.BringToFront();

    UpdateScrollBarsPos();
end;

procedure TsuiDBGrid.SetSelectedColor(const Value: TColor);
begin
    m_SelectedColor := Value;
    Repaint();
end;

procedure TsuiDBGrid.SetTitleFontColor(const Value: TColor);
begin
    TitleFont.Color := Value;
end;

procedure TsuiDBGrid.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR);
        FixedColor := m_FileTheme.GetColor(SKIN2_SELECTEDMENUCOLOR);
        Color := m_FileTheme.GetColor(SKIN2_CONTROLCOLOR);
        Font.Color := m_FileTheme.GetColor(SKIN2_CONTROLFONTCOLOR);
        TitleFontColor := m_FileTheme.GetColor(SKIN2_SELECTEDMENUFONTCOLOR);
    end
    else
    begin
        BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);
        FixedColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_MENU_SELECTED_BACKGROUND_COLOR);
        Color := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BACKGROUND_COLOR);
        TitleFontColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_MENU_SELECTED_FONT_COLOR);
        Font.Color := GetInsideThemeColor(OutUIStyle, SUI_THEME_MENU_FONT_COLOR);
        if Font.Color = clWhite then
            Font.Color := clBlack;
    end;
    if m_VScrollBar <> nil then
        m_VScrollBar.UIStyle := OutUIStyle;
    if m_HScrollBar <> nil then
        m_HScrollBar.UIStyle := OutUIStyle;    
end;

procedure TsuiDBGrid.SetVScrollBar(const Value: TsuiScrollBar);
begin
    if m_VScrollBar = Value then
        Exit;
    if m_VScrollBar <> nil then
    begin
        m_VScrollBar.OnChange := nil;
        m_VScrollBar.LineButton := 0;
        m_VScrollBar.Max := 100;
        m_VScrollBar.Enabled := true;
    end;

    m_VScrollBar := Value;
    if m_VScrollBar = nil then
        Exit;
    m_VScrollBar.Orientation := suiVertical;
    m_VScrollBar.OnChange := OnVScrollBArChange;
    m_VScrollBar.BringToFront();

    UpdateScrollBarsPos();
end;

procedure TsuiDBGrid.UpdateScrollBars;
var
    info : tagScrollInfo;
    barinfo : tagScrollBarInfo;
    R : Boolean;
begin
    if csLoading in ComponentState then
        Exit;
    m_SelfChanging := true;   
    if m_VScrollBar <> nil then
    begin
        barinfo.cbSize := SizeOf(barinfo);
        R := SUIGetScrollBarInfo(Handle, Integer(OBJID_VSCROLL), barinfo);
        if (barinfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) or
           (barinfo.rgstate[0] = STATE_SYSTEM_UNAVAILABLE) or
           (not R) then
        begin
            m_VScrollBar.LineButton := 0;
            m_VScrollBar.Enabled := false;
            m_VScrollBar.Visible := false;
        end
        else if not Enabled then
            m_VScrollBar.Enabled := false
        else
        begin
            m_VScrollBar.LineButton := abs(barinfo.xyThumbBottom - barinfo.xyThumbTop);
            m_VScrollBar.Enabled := true;
            m_VScrollBar.Visible := true;
        end;
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_VERT, info);
        m_VScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_VScrollBar.Min := info.nMin;
        m_VScrollBar.Position := info.nPos;
    end;

    if m_HScrollBar <> nil then
    begin
        barinfo.cbSize := SizeOf(barinfo);
        R := SUIGetScrollBarInfo(Handle, Integer(OBJID_HSCROLL), barinfo);
        if (barinfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) or
           (barinfo.rgstate[0] = STATE_SYSTEM_UNAVAILABLE) or
           (not R) then
        begin
            m_HScrollBar.LineButton := 0;
            m_HScrollBar.Enabled := false;
            m_HScrollBar.Visible := false;
        end
        else if not Enabled then
            m_HScrollBar.Enabled := false
        else
        begin
            m_HScrollBar.LineButton := abs(barinfo.xyThumbBottom - barinfo.xyThumbTop);
            m_HScrollBar.Enabled := true;
            m_HScrollBar.Visible := true;
        end;
        info.cbSize := SizeOf(info);
        info.fMask := SIF_ALL;
        GetScrollInfo(Handle, SB_HORZ, info);
        m_HScrollBar.Max := info.nMax - Integer(info.nPage) + 1;
        m_HScrollBar.Min := info.nMin;
        m_HScrollBar.Position := info.nPos
    end;

    m_SelfChanging := false;
end;

procedure TsuiDBGrid.UpdateScrollBarsPos;
var
    L2R : Boolean;
begin
    inherited;
    if csLoading in ComponentState then
        Exit;
    L2R := ((BidiMode = bdLeftToRight) or (BidiMode = bdRightToLeftReadingOnly)) or (not SysLocale.MiddleEast);
    UpdateScrollBars();
    if m_HScrollBar <> nil then
    begin
        if m_HScrollBar.Height > Height then
            m_HScrollBar.Top := Top
        else
        begin
            if L2R then
            begin
                m_HScrollBar.Left := Left + 1;
                m_HScrollBar.Top := Top + Height - m_HScrollBar.Height - 1;
                if (m_VScrollBar <> nil) and m_VScrollBar.Visible then
                    m_HScrollBar.Width := Width - 1 - m_VScrollBar.Width
                else
                    m_HScrollBar.Width := Width - 2
            end
            else
            begin
                m_HScrollBar.Top := Top + Height - m_HScrollBar.Height - 1;
                if (m_VScrollBar <> nil) and m_VScrollBar.Visible then
                begin
                    m_HScrollBar.Left := Left + m_VScrollBar.Width + 1;
                    m_HScrollBar.Width := Width - 1 - m_VScrollBar.Width
                end
                else
                begin
                    m_HScrollBar.Left := Left + 1;
                    m_HScrollBar.Width := Width - 1;
                end;
            end;

//            m_HScrollBar.Left := Left + 1;
//            m_HScrollBar.Top := Top + Height - m_HScrollBar.Height - 1;
//            if m_VScrollBar <> nil then
//            begin
//                if m_VScrollBar.Visible then
//                    m_HScrollBar.Width := Width - 1 - m_VScrollBar.Width
//                else
//                    m_HScrollBar.Width := Width - 1
//            end
//            else
//                m_HScrollBar.Width := Width - 1
        end;
    end;

    if m_VScrollBar <> nil then
    begin
        if m_VScrollBar.Width > Width then
            m_VScrollBar.Left := Left
        else
        begin
            if L2R then
            begin
                m_VScrollBar.Left := Left + Width - m_VScrollBar.Width - 1;
                m_VScrollBar.Top := Top + 1;
                if (m_HScrollBar <> nil) and m_HScrollBar.Visible then
                    m_VScrollBar.Height := Height - 1 - m_HScrollBar.Height
                else
                    m_VScrollBar.Height := Height - 1;
            end
            else
            begin
                m_VScrollBar.Left := Left + 1;
                m_VScrollBar.Top := Top + 1;
                if (m_HScrollBar <> nil) and m_HScrollBar.Visible then
                    m_VScrollBar.Height := Height - 1 - m_HScrollBar.Height
                else
                    m_VScrollBar.Height := Height - 1;
            end;

//            m_VScrollBar.Left := Left + Width - m_VScrollBar.Width - 1;
//            m_VScrollBar.Top := Top + 1;
//            if m_HScrollBar <> nil then
//            begin
//                if m_HScrollBar.Visible then
//                    m_VScrollBar.Height := Height - 1 - m_HScrollBar.Height
//                else
//                    m_VScrollBar.Height := Height - 1;
//            end
//            else
//                m_VScrollBar.Height := Height - 1;
        end;
    end;
end;

procedure TsuiDBGrid.WMClear(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.WMCut(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.WMEARSEBKGND(var Msg: TMessage);
begin
    RePaint();
end;

procedure TsuiDBGrid.WMHSCROLL(var Message: TWMHScroll);
begin
    inherited;
    if m_UserChanging then
        Exit;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.WMKeyDown(var Message: TWMKeyDown);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.WMLBUTTONDOWN(var Message: TMessage);
begin
    inherited;
    m_MouseDown := true;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.WMLButtonUp(var Message: TMessage);
begin
    inherited;
    m_MouseDown := false;
end;

procedure TsuiDBGrid.WMMOUSEMOVE(var Message: TMessage);
begin
    inherited;
    if m_MouseDown then UpdateScrollBars();
end;

procedure TsuiDBGrid.WMMOUSEWHEEL(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.WMMOVE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBGrid.WMPaste(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.WMSetText(var Message: TWMSetText);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.WMSIZE(var Msg: TMessage);
begin
    inherited;
    UpdateScrollBarsPos();
end;

procedure TsuiDBGrid.WMUndo(var Message: TMessage);
begin
    inherited;
    UpdateScrollBars();
end;

procedure TsuiDBGrid.WMVSCROLL(var Message: TWMVScroll);
begin
    inherited;
    if m_UserChanging then
        Exit;
    UpdateScrollBars();
end;

{ TsuiDBLookupComboBox }

constructor TsuiDBLookupComboBox.Create(AOwner: TComponent);
begin
    inherited;

    ControlStyle := ControlStyle + [csOpaque];
    BorderWidth := 0;
    UIStyle := GetSUIFormStyle(AOwner);
end;

procedure TsuiDBLookupComboBox.DrawArrow(const ACanvas: TCanvas; X,
  Y: Integer);
begin
    if not Enabled then
    begin
        ACanvas.Brush.Color := clWhite;
        ACanvas.Pen.Color := clWhite;
        ACanvas.Polygon([Point(X + 1, Y + 1), Point(X + 7, Y + 1), Point(X + 4, Y + 4)]);
        ACanvas.Brush.Color := clGray;
        ACanvas.Pen.Color := clGray;
    end
    else
    begin
        ACanvas.Brush.Color := m_ArrowColor;
        ACanvas.Pen.Color := m_ArrowColor;
    end;

    ACanvas.Polygon([Point(X, Y), Point(X + 6, Y), Point(X + 3, Y + 3)]);
end;

procedure TsuiDBLookupComboBox.DrawButton;
var
    ButtonWidth : Integer;
    R : TRect;
    C: TControlCanvas;
    Btn : graphics.TBitmap;
    X, Y : Integer;    
begin
    ButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
    if (BidiMode = bdRightToLeft) and SysLocale.MiddleEast then
        R := Rect(0, 0, ButtonWidth, ClientHeight)
    else
        R := Rect(ClientWidth - ButtonWidth, 0, ClientWidth, ClientHeight);

    C := TControlCanvas.Create;
    C.Control := Self;

    if {$IFDEF RES_MACOS} (m_UIStyle = MacOS) {$ELSE} false {$ENDIF} or
        {$IFDEF RES_WINXP} (m_UIStyle = WinXP) {$ELSE} false {$ENDIF} then
    begin
        Btn := graphics.TBitmap.Create();
{$IFDEF RES_MACOS}
        if m_UIStyle = MacOS then
            Btn.LoadFromResourceName(hInstance, 'MACOS_COMBOBOX_BUTTON')
        else
{$ENDIF}
            Btn.LoadFromResourceName(hInstance, 'WINXP_COMBOBOX_BUTTON');
        C.StretchDraw(R, Btn);
        Btn.Free();
    end
    else
    begin
        C.Brush.Color := m_ButtonColor;
        C.FillRect(R);
        C.Pen.Color := m_BorderColor;
        if (BidiMode = bdRightToLeft) and SysLocale.MiddleEast then
        begin
            C.MoveTo(R.Right, R.Top - 1);
            C.LineTo(R.Right, R.Bottom + 1);
        end
        else
        begin
            C.MoveTo(R.Left, R.Top - 1);
            C.LineTo(R.Left, R.Bottom + 1);
        end;
    end;

    X := (R.Right - R.Left) div 2 + R.Left - 3;
    Y := (R.Bottom - R.Top) div 2 - 2;
    if {$IFDEF RES_WINXP}m_UIStyle <> WinXP{$ELSE} True {$ENDIF}  then
        DrawArrow(C, X, Y);

    C.Free;
end;

procedure TsuiDBLookupComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
    inherited;

    if (
        (Operation = opRemove) and
        (AComponent = m_FileTheme)
    )then
    begin
        m_FileTheme := nil;
        SetUIStyle(SUI_THEME_DEFAULT);
    end;
end;

procedure TsuiDBLookupComboBox.Paint;
begin
    inherited;
    DrawControlBorder(self, m_BorderColor, Color);
    DrawButton();
end;

procedure TsuiDBLookupComboBox.SetArrowColor(const Value: TColor);
begin
    m_ArrowColor := Value;
    Repaint();
end;

procedure TsuiDBLookupComboBox.SetBorderColor(const Value: TColor);
begin
    m_BorderColor := Value;
    Repaint();
end;

procedure TsuiDBLookupComboBox.SetButtonColor(const Value: TColor);
begin
    m_ButtonColor := Value;
    Repaint();
end;

procedure TsuiDBLookupComboBox.SetEnabled(Value: Boolean);
begin
    inherited;

    Repaint();
end;

procedure TsuiDBLookupComboBox.SetFileTheme(const Value: TsuiFileTheme);
begin
    m_FileTheme := Value;
    SetUIStyle(m_UIStyle);
end;

procedure TsuiDBLookupComboBox.SetUIStyle(const Value: TsuiUIStyle);
var
    OutUIStyle : TsuiUIStyle;
begin
    m_UIStyle := Value;

    m_ArrowColor := clBlack;
    if UsingFileTheme(m_FileTheme, m_UIStyle, OutUIStyle) then
    begin
        m_BorderColor := m_FileTheme.GetColor(SKIN2_CONTROLBORDERCOLOR);
        m_ButtonColor := m_FileTheme.GetColor(SKIN2_FORMCOLOR);
    end
    else
    begin
        m_BorderColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_CONTROL_BORDER_COLOR);
        m_ButtonColor := GetInsideThemeColor(OutUIStyle, SUI_THEME_FORM_BACKGROUND_COLOR);
    end;

    Repaint();
end;

end.

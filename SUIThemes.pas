////////////////////////////////////////////////////////////////////////////////
//
//
//  FileName    :   SUIThemes.pas
//  Creator     :   Shen Min
//  Date        :   2002-08-30 V1-V3
//                  2003-07-11 V4
//                  2006-06-18 V6
//  Comment     :
//
//  Copyright (c) 2002-2006 Sunisoft
//  http://www.sunisoft.com
//  Email: support@sunisoft.com
//
////////////////////////////////////////////////////////////////////////////////

unit SUIThemes;

interface

{$I SUIPack.inc}

uses Graphics, Forms, Controls, SysUtils, Classes,
     SUI2SkinReader, SUI2Define;

type
    TsuiUIStyle = (
        FromThemeFile
{$IFDEF RES_MACOS}
        , MacOS
{$ENDIF}

{$IFDEF RES_WINXP}
        , WinXP
{$ENDIF}
{$IFDEF RES_DEEPBLUE}
        , DeepBlue
{$ENDIF}
{$IFDEF RES_PROTEIN}
        , Protein
{$ENDIF}
{$IFDEF RES_BLUEGLASS}
        , BlueGlass
{$ENDIF}
    );

const
    SUI_THEME_DEFAULT   =
{$IFDEF RES_ALL}
        DeepBlue;
{$ELSE}
    {$IFDEF RES_DEEPBLUE}
            DeepBlue;
    {$ELSE}
        {$IFDEF RES_PROTEIN}
                Protein;
        {$ELSE}
            {$IFDEF RES_BLUEGLASS}
                    BlueGlass;
            {$ELSE}
                {$IFDEF RES_MACOS}
                        MacOS;
                {$ELSE}
                    {$IFDEF RES_WINXP}
                            WinXP;
                    {$ENDIF}
                {$ENDIF}
            {$ENDIF}
        {$ENDIF}
    {$ENDIF}
{$ENDIF}

    SUI_THEME_BUTTON_IMAGE                          = 1;
    SUI_THEME_BUTTON_TRANSPARENT_BOOL               = 2;
    SUI_THEME_CHECKBOX_IMAGE                        = 3;
    SUI_THEME_RADIOBUTTON_IMAGE                     = 4;
    SUI_THEME_TITLEBAR_BUTTON_IMAGE                 = 5;
    SUI_THEME_TITLEBAR_BUTTON_TRANSPARENT_BOOL      = 6;
    SUI_THEME_TITLEBAR_BUTTON_LEFTOFFSET_INT        = 7;
    SUI_THEME_TITLEBAR_BUTTON_RIGHTOFFSET_INT       = 8;
    SUI_THEME_TITLEBAR_BUTTON_TOP_INT               = 9;
    SUI_THEME_TITLEBAR_LEFT_IMAGE                   = 10;
    SUI_THEME_TITLEBAR_CLIENT_IMAGE                 = 11;
    SUI_THEME_TITLEBAR_RIGHT_IMAGE                  = 12;
    SUI_THEME_FORM_MINWIDTH_INT                     = 13;
    SUI_THEME_FORM_ROUNDCORNER_INT                  = 14;
    SUI_THEME_FORM_BACKGROUND_COLOR                 = 15;
    SUI_THEME_FORM_BORDER_COLOR                     = 16;
    SUI_THEME_FORM_BORDERWIDTH_INT                  = 17;
    SUI_THEME_MENU_SELECTED_BORDER_COLOR            = 18;
    SUI_THEME_MENU_SELECTED_BACKGROUND_COLOR        = 19;
    SUI_THEME_MENU_SELECTED_FONT_COLOR              = 20;
    SUI_THEME_MENU_BACKGROUND_COLOR                 = 21;
    SUI_THEME_MENU_FONT_COLOR                       = 22;
    SUI_THEME_MENU_LEFTBAR_COLOR                    = 23;
    SUI_THEME_PROGRESSBAR_IMAGE                     = 24;
    SUI_THEME_CONTROL_BORDER_COLOR                  = 25;
    SUI_THEME_CONTROL_BACKGROUND_COLOR              = 26;
    SUI_THEME_CONTROL_FONT_COLOR                    = 27;
    SUI_THEME_TRACKBAR_BAR                          = 28;
    SUI_THEME_TRACKBAR_SLIDER                       = 29;
    SUI_THEME_TRACKBAR_SLIDER_V                     = 30;
    SUI_THEME_SCROLLBAR_BACKGROUND_COLOR            = 31;
    SUI_THEME_SCROLLBAR_BUTTON_IMAGE                = 32;
    SUI_THEME_SCROLLBAR_SLIDER_IMAGE                = 33;
    SUI_THEME_CHECKLISTBOX_IMAGE                    = 34;
    SUI_THEME_TOOLBAR_BUTTON_BORDER_COLOR           = 35;
    SUI_THEME_TOOLBAR_BUTTON_BACKGROUND_COLOR       = 36;
    SUI_THEME_TOOLBAR_BUTTON_DOWN_BACKGROUND_COLOR  = 37;
    SUI_THEME_SCROLLBUTTON_IMAGE                    = 38;
    SUI_THEME_TABCONTROL_TAB_IMAGE                  = 39;
    SUI_THEME_TABCONTROL_BAR_IMAGE                  = 40;
    SUI_THEME_SIDECHENNEL_HANDLE_IMAGE              = 41;
    SUI_THEME_SIDECHENNEL_BAR_IMAGE                 = 42;

    SUI_THEME_TITLEBAR_MINIMIZED_IMAGE              = 43;
    SUI_THEME_TITLEBAR_FONT_COLOR                   = 44;
    SUI_THEME_FORM_LEFTBORDER_IMAGE                 = 45;
    SUI_THEME_FORM_BOTTOMBORDER_IMAGE               = 46;
    SUI_THEME_FORM_BOTTOMROUNDCORNOR_INT            = 47;
    SUI_THEME_MENU_MENUBAR_COLOR                    = 48;

    SUI_THEME_ITEM_COUNT                            = 48;

type
    TsuiType = (
        Int,
        Color,
        Str,
        Bool
    );

    TsuiThemeItem = record
        case Integer of
            0: (Int : Integer);
            1: (Color : TColor);
            2: (Str : PChar);
            3: (Bool : Boolean);
    end;

    TsuiThemeItemType = array [1 .. SUI_THEME_ITEM_COUNT] of TsuiType;
    TsuiThemeDef = array [1 .. SUI_THEME_ITEM_COUNT] of TsuiThemeItem;
    PTsuiThemeDef = ^TsuiThemeDef;    

const
    SUI_ITEM_TYPE : TsuiThemeItemType = (
        Str,
        Bool,
        Str,
        Str,
        Str,
        Bool,
        Int,
        Int,
        Int,
        Str,
        Str,
        Str,
        Int,
        Int,
        Color,
        Color,
        Int,
        Color,
        Color,
        Color,
        Color,
        Color,
        Color,
        Str,
        Color,
        Color,
        Color,
        Str,
        Str,
        Str,
        Color,
        Str,
        Str,
        Str,
        Color,
        Color,
        Color,
        Str,
        Str,
        Str,
        Str,
        Str,
        Str,
        Color,
        Str,
        Str,
        Int,
        Color
    );

type
    // --------- ThemeMgr ---------------
    TsuiFileThemeMgr = class
    private
        m_FileReader : Tsk2SkinFileReader;

    public
        constructor Create();
        destructor Destroy(); override;

        function LoadFromFile(FileName, Password : String) : Boolean;

        function GetBitmap(const Index : Tsk2SkinBitmapElement) : TBitmap;
        function GetInt(const Index : Tsk2IntElement) : Integer;
        function GetColor(const Index : Tsk2SkinColorElement) : TColor;
        function GetBool(const Index : Tsk2BoolElement) : Boolean;
    end;

    procedure GetInsideThemeBitmap(Theme : TsuiUIStyle; const Index : Integer; const Buf : TBitmap; SpitCount : Integer = 0; SpitIndex : Integer = 0);
    function GetInsideThemeInt(Theme : TsuiUIStyle; const Index : Integer) : Integer;
    function GetInsideThemeColor(Theme : TsuiUIStyle; const Index : Integer) : TColor;
    function GetInsideThemeBool(Theme : TsuiUIStyle; const Index : Integer) : Boolean;

    // ---------- ThemeInfo --------------
    function GetSUIFormStyle(Owner : TComponent) : TsuiUIStyle;

implementation

uses SUIPublic, SUIForm;

const
    SUI_MACOS_THEME : TsuiThemeDef = (
        (Str : 'MACOS_BUTTON'),
        (Bool : true),
        (Str : 'MACOS_CHECKBOX'),
        (Str : 'MACOS_RADIOBUTTON'),
        (Str : 'MACOS_TITLEBTN'),
        (Bool : false),
        (Int : 3),
        (Int : -2),
        (Int : 4),
        (Str : 'MACOS_TITLE_LEFT'),
        (Str : 'MACOS_TITLE_CLIENT'),
        (Str : 'MACOS_TITLE_RIGHT'),
        (Int : 130),
        (Int : 0),
        (Color : $00E7E7E7),
        (Color : $007F7F7F),
        (Int : 1),
        (Color : $00C47339),
        (Color : $00C47339),
        (Color : clWhite),
        (Color : 0),
        (Color : clBlack),
        (Color : 0),
        (Str : 'MACOS_PROGRESSBAR'),
        (Color : $007F7F7F),
        (Color : $00E7E7E7),
        (Color : clBlack),
        (Str : 'MACOS_TRACKBAR_BAR'),
        (Str : 'MACOS_TRACKBAR_SLIDER'),
        (Str : 'MACOS_TRACKBAR_SLIDER_V'),
        (Color : $00C9C9C9),
        (Str : 'MACOS_SCROLLBAR_BUTTON'),
        (Str : 'MACOS_SCROLLBAR_TRACK'),
        (Str : 'MACOS_CHECKLIST'),
        (Color : $00474747),
        (Color : $00EFEFEF),
        (Color : $00D8D8D8),
        (Str : 'MACOS_SCROLLBUTTON'),
        (Str : 'MACOS_TAB'),
        (Str : 'MACOS_TAB_LINE'),
        (Str : 'MACOS_SIDECHENNEL_HANDLE'),
        (Str : 'MACOS_SIDECHENNEL_BAR'),
        (Str : ''),
        (Color : clBlack),
        (Str : ''),
        (Str : ''),
        (Int : 0),
        (Color : $00E7E7E7)
    );

    SUI_WINXP_THEME : TsuiThemeDef = (
        (Str : 'WINXP_BUTTON'),
        (Bool : false),
        (Str : 'WINXP_CHECKBOX'),
        (Str : 'WINXP_RADIOBUTTON'),
        (Str : 'WINXP_TITLEBTN'),
        (Bool : false),
        (Int : 2),
        (Int : -2),
        (Int : 5),
        (Str : 'WINXP_TITLE_LEFT'),
        (Str : 'WINXP_TITLE_CLIENT'),
        (Str : 'WINXP_TITLE_RIGHT'),
        (Int : 150),
        (Int : 13),
        (Color : $00DEEBEF),
        (Color : $00C82C00),
        (Int : 3),
        (Color : $00C66931),
        (Color : $00EFD3C6),
        (Color : clBlack),
        (Color : clWhite),
        (Color : clBlack),
        (Color : $00CED3D6),
        (Str : 'WINXP_PROGRESSBAR'),
        (Color : $00686868),
        (Color : $00DEEBEF),
        (Color : $00CF4602),
        (Str : 'WINXP_TRACKBAR_BAR'),
        (Str : 'WINXP_TRACKBAR_SLIDER'),
        (Str : 'WINXP_TRACKBAR_SLIDER_V'),
        (Color : $00F9F9F9),
        (Str : 'WINXP_SCROLLBAR_BUTTON'),
        (Str : 'WINXP_SCROLLBAR_TRACK'),
        (Str : 'WINXP_CHECKLIST'),
        (Color : $00C66931),
        (Color : $00EFD3C6),
        (Color : $00E1AC93),
        (Str : 'WINXP_SCROLLBUTTON'),
        (Str : 'WINXP_TAB'),
        (Str : 'WINXP_TAB_LINE'),
        (Str : 'WINXP_SIDECHENNEL_HANDLE'),
        (Str : 'WINXP_SIDECHENNEL_BAR'),
        (Str : ''),
        (Color : clWhite),
        (Str : ''),
        (Str : ''),
        (Int : 0),
        (Color : $00DEEBEF)        
    );

    SUI_DEEPBLUE_THEME : TsuiThemeDef = (
        (Str : 'DEEPBLUE_BUTTON'),
        (Bool : false),
        (Str : 'DEEPBLUE_CHECKBOX'),
        (Str : 'DEEPBLUE_RADIOBUTTON'),
        (Str : 'DEEPBLUE_TITLEBTN'),
        (Bool : false),
        (Int : 0),
        (Int : 0),
        (Int : 2),
        (Str : 'DEEPBLUE_TITLE_LEFT'),
        (Str : 'DEEPBLUE_TITLE_CLIENT'),
        (Str : 'DEEPBLUE_TITLE_RIGHT'),
        (Int : 130),
        (Int : 0),
        (Color : $00E8E8E8),
        (Color : clBlack),
        (Int : 1),
        (Color : $00A04A44),
        (Color : $00A04A44),
        (Color : clWhite),
        (Color : clWhite),
        (Color : clBlack),
        (Color : $00CED3D6),
        (Str : 'DEEPBLUE_PROGRESSBAR'),
        (Color : clBlack),
        (Color : $00E8E8E8),
        (Color : clBlack),
        (Str : 'DEEPBLUE_TRACKBAR_BAR'),
        (Str : 'DEEPBLUE_TRACKBAR_SLIDER'),
        (Str : 'DEEPBLUE_TRACKBAR_SLIDER_V'),
        (Color : $00F5F5F5),
        (Str : 'DEEPBLUE_SCROLLBAR_BUTTON'),
        (Str : 'DEEPBLUE_SCROLLBAR_TRACK'),
        (Str : 'DEEPBLUE_CHECKLIST'),
        (Color : $00474747),
        (Color : $00EFEFEF),
        (Color : $00D8D8D8),
        (Str : 'MORE_SCROLLBUTTON'),
        (Str : 'DEEPBLUE_TAB'),
        (Str : 'DEEPBLUE_TAB_LINE'),
        (Str : 'DEEPBLUE_SIDECHENNEL_HANDLE'),
        (Str : 'DEEPBLUE_SIDECHENNEL_BAR'),
        (Str : ''),
        (Color : clWhite),
        (Str : ''),
        (Str : ''),
        (Int : 0),
        (Color : $00E8E8E8)        
    );

    SUI_PROTEIN_THEME : TsuiThemeDef = (
        (Str : 'PROTEIN_BUTTON'),
        (Bool : false),
        (Str : 'PROTEIN_CHECKBOX'),
        (Str : 'PROTEIN_RADIOBUTTON'),
        (Str : 'PROTEIN_TITLEBTN'),
        (Bool : true),
        (Int : 0),
        (Int : 0),
        (Int : 2),
        (Str : 'PROTEIN_TITLE_LEFT'),
        (Str : 'PROTEIN_TITLE_CLIENT'),
        (Str : 'PROTEIN_TITLE_RIGHT'),
        (Int : 130),
        (Int : 0),
        (Color : $00FBFBFB),
        (Color : clBlack),
        (Int : 1),
        (Color : $00C4302D),
        (Color : $00C4302D),
        (Color : clWhite),
        (Color : clWhite),
        (Color : clBlack),
        (Color : $00CED3D6),
        (Str : 'PROTEIN_PROGRESSBAR'),
        (Color : clBlack),
        (Color : $00FBFBFB),
        (Color : clBlack),
        (Str : 'PROTEIN_TRACKBAR_BAR'),
        (Str : 'PROTEIN_TRACKBAR_SLIDER'),
        (Str : 'PROTEIN_TRACKBAR_SLIDER_V'),
        (Color : $00F5F5F5),
        (Str : 'PROTEIN_SCROLLBAR_BUTTON'),
        (Str : 'PROTEIN_SCROLLBAR_TRACK'),
        (Str : 'PROTEIN_CHECKLIST'),
        (Color : $00474747),
        (Color : $00EFEFEF),
        (Color : $00D8D8D8),
        (Str : 'MORE_SCROLLBUTTON'),
        (Str : 'PROTEIN_TAB'),
        (Str : 'PROTEIN_TAB_LINE'),
        (Str : 'PROTEIN_SIDECHENNEL_HANDLE'),
        (Str : 'PROTEIN_SIDECHENNEL_BAR'),
        (Str : ''),
        (Color : clWhite),
        (Str : ''),
        (Str : ''),
        (Int : 0),
        (Color : $00FBFBFB)
    );

    SUI_BLUEGLASS_THEME : TsuiThemeDef = (
        (Str : 'BLUEGLASS_BUTTON'),
        (Bool : true),
        (Str : 'BLUEGLASS_CHECKBOX'),
        (Str : 'BLUEGLASS_RADIOBUTTON'),
        (Str : 'BLUEGLASS_TITLEBTN'),
        (Bool : true),
        (Int : 4),
        (Int : -3),
        (Int : 6),
        (Str : 'BLUEGLASS_TITLE_LEFT'),
        (Str : 'BLUEGLASS_TITLE_CLIENT'),
        (Str : 'BLUEGLASS_TITLE_RIGHT'),
        (Int : 270),
        (Int : 11),
        (Color : $00E7E7E7),
        (Color : clBlack),
        (Int : 1),
        (Color : $00EC5E5E),
        (Color : $00EC5E5E),
        (Color : clWhite),
        (Color : $00E7E7E7),
        (Color : clBlack),
        (Color : $00CED3D6),
        (Str : 'BLUEGLASS_PROGRESSBAR'),
        (Color : clBlack),
        (Color : $00E7E7E7),
        (Color : clBlack),
        (Str : 'BLUEGLASS_TRACKBAR_BAR'),
        (Str : 'BLUEGLASS_TRACKBAR_SLIDER'),
        (Str : 'BLUEGLASS_TRACKBAR_SLIDER_V'),
        (Color : $00F4F4F4),
        (Str : 'BLUEGLASS_SCROLLBAR_BUTTON'),
        (Str : 'BLUEGLASS_SCROLLBAR_TRACK'),
        (Str : 'BLUEGLASS_CHECKLIST'),
        (Color : $00474747),
        (Color : $00EFEFEF),
        (Color : $00D8D8D8),
        (Str : 'MORE_SCROLLBUTTON'),
        (Str : 'BLUEGLASS_TAB'),
        (Str : 'BLUEGLASS_TAB_LINE'),
        (Str : 'BLUEGLASS_SIDECHENNEL_HANDLE'),
        (Str : 'BLUEGLASS_SIDECHENNEL_BAR'),
        (Str : ''),
        (Color : clWhite),
        (Str : ''),
        (Str : ''),
        (Int : 0),
        (Color : $00E7E7E7)        
    );


function GetSUIFormStyle(Owner : TComponent) : TsuiUIStyle;
var
    i : Integer;
    Form : TCustomForm;
begin
    Result := SUI_THEME_DEFAULT;

    if Owner = nil then
        Exit;
    if not (Owner is TCustomForm) then
        Exit;

    Form := Owner as TCustomForm;
    for i := 0 to Form.ControlCount - 1 do
    begin
        if Form.Controls[i] is TsuiForm then
        begin
            Result := (Form.Controls[i] as TsuiForm).UIStyle;
            break;
        end;
    end;
end;

// ----------- ThemeMgr ---------------
function GetInsideThemeItem(Theme : TsuiUIStyle; Index : Integer; var ReturnType : TsuiType) : Integer;
var
    pTheme : PTsuiThemeDef;
begin
    case Theme of

{$IFDEF RES_MACOS}
    MacOS     : pTheme := @SUI_MACOS_THEME;
{$ENDIF}
{$IFDEF RES_WINXP}
    WinXP     : pTheme := @SUI_WINXP_THEME;
{$ENDIF}
{$IFDEF RES_DEEPBLUE}
    DeepBlue  : pTheme := @SUI_DEEPBLUE_THEME;
{$ENDIF}
{$IFDEF RES_PROTEIN}
    Protein   : pTheme := @SUI_PROTEIN_THEME;
{$ENDIF}
{$IFDEF RES_BLUEGLASS}
    BlueGlass : pTheme := @SUI_BLUEGLASS_THEME;
{$ENDIF}

    else
    begin
        ReturnType := Int;
        Result := -1;
        Exit;
    end;

    end; // case

    ReturnType := SUI_ITEM_TYPE[Index];
    Result := Integer(pTheme^[Index]);
end;

procedure GetInsideThemeBitmap(Theme : TsuiUIStyle; const Index : Integer; const Buf : TBitmap; SpitCount : Integer = 0; SpitIndex : Integer = 0);

    procedure InternalGetInsideThemeBitmap(Theme : TsuiUIStyle; const Index: Integer; const Buf: TBitmap);
    var
        ReturnType : TsuiType;
        nResult : Integer;
    begin
        if Buf = nil then
            Exit;

        nResult := GetInsideThemeItem(Theme, Index, ReturnType);
        if ReturnType = Str then
            Buf.LoadFromResourceName(hInstance,PCharToStr(PChar(nResult)));
    end;
var
    TempBmp : TBitmap;
begin
    if Buf = nil then
        Exit;
    if SpitCount = 0 then
    begin
        InternalGetInsideThemeBitmap(Theme, Index, Buf);
        Exit;
    end;
    TempBmp := TBitmap.Create();
    InternalGetInsideThemeBitmap(Theme, Index, TempBmp);
    SpitBitmap(TempBmp, Buf, SpitCount, SpitIndex);
    TempBmp.Free();
end;

function GetInsideThemeBool(Theme : TsuiUIStyle; const Index: Integer): Boolean;
var
    ReturnType : TsuiType;
    nResult : Integer;
begin
    Result := false;

    nResult := GetInsideThemeItem(Theme, Index, ReturnType);
    if ReturnType = Bool then
        Result := Boolean(nResult);
end;

function GetInsideThemeColor(Theme : TsuiUIStyle; const Index: Integer): TColor;
var
    ReturnType : TsuiType;
    nResult : Integer;
begin
    Result := clBlack;

    nResult := GetInsideThemeItem(Theme, Index, ReturnType);
    if ReturnType = Color then
        Result := nResult;
end;

function GetInsideThemeInt(Theme : TsuiUIStyle; const Index: Integer): Integer;
var
    ReturnType : TsuiType;
    nResult : Integer;
begin
    Result := -1;

    nResult := GetInsideThemeItem(Theme, Index, ReturnType);
    if ReturnType = Int then
        Result := nResult
end;

{ TsuiFileThemeMgr }

constructor TsuiFileThemeMgr.Create;
begin
    m_FileReader := nil;
end;

destructor TsuiFileThemeMgr.Destroy;
begin
    if m_FileReader <> nil then
    begin
        m_FileReader.Free();
        m_FileReader := nil;
    end;
end;

function TsuiFileThemeMgr.LoadFromFile(FileName, Password: String) : Boolean;
begin
    Result := false;
    if not FileExists(FileName) then
        Exit;
    if m_FileReader <> nil then
    begin
        m_FileReader.Free();
        m_FileReader := nil;
    end;

    try
        m_FileReader := Tsk2SkinFileReader.Create(FileName, Password);
        Result := m_FileReader.Ready;

        if not Result then
        begin
            m_FileReader.Free();
            m_FileReader := nil;
        end;
    except
        m_FileReader := nil;
    end;
end;

function TsuiFileThemeMgr.GetBitmap(const Index: Tsk2SkinBitmapElement): TBitmap;
begin
    Result := nil;
    if m_FileReader = nil then
        Exit;
    Result := m_FileReader.GetBitmap(SKIN2_SKINFILE_KEYNAME[Ord(Index) + SKIN2_BITMAPELEMENT_OFFSET]);
end;

function TsuiFileThemeMgr.GetBool(const Index: Tsk2BoolElement): Boolean;
begin
    Result := false;
    if m_FileReader = nil then
        Exit;
    Result := m_FileReader.GetBool(SKIN2_SKINFILE_KEYNAME[Ord(Index) + SKIN2_BOOLELEMENT_OFFSET]);
end;

function TsuiFileThemeMgr.GetColor(const Index: Tsk2SkinColorElement): TColor;
begin
    Result := clBlack;
    if m_FileReader = nil then
        Exit;
    Result := m_FileReader.GetInteger(SKIN2_SKINFILE_KEYNAME[ord(Index) + SKIN2_COLORELEMENT_OFFSET]);
end;

function TsuiFileThemeMgr.GetInt(const Index: Tsk2IntElement): Integer;
begin
    Result := 0;
    if m_FileReader = nil then
        Exit;
    Result := m_FileReader.GetInteger(SKIN2_SKINFILE_KEYNAME[Ord(Index) + SKIN2_INTELEMENT_OFFSET]);
end;

end.

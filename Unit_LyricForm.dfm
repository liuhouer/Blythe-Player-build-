object LyricForm: TLyricForm
  Left = 255
  Top = 139
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #27468#35789#33258#21160#19979#36733
  ClientHeight = 366
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 192
    Height = 33
    Caption = #27468#35789#26597#35810#31995#32479
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 88
    Width = 60
    Height = 13
    Caption = #27468#26354#26631#39064#65306
    FocusControl = Edit1
  end
  object Label3: TLabel
    Left = 36
    Top = 116
    Width = 48
    Height = 13
    Caption = #33402#26415#23478#65306
    FocusControl = Edit2
  end
  object Label5: TLabel
    Left = 72
    Top = 288
    Width = 369
    Height = 13
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 16
    Top = 288
    Width = 52
    Height = 13
    Caption = #20445#23384#21040#65306
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 8
    Top = 304
    Width = 425
    Height = 3
  end
  object Bevel2: TBevel
    Left = 0
    Top = 64
    Width = 433
    Height = 3
  end
  object Button1: TButton
    Left = 296
    Top = 80
    Width = 113
    Height = 49
    Caption = #25628#32034#27468#35789
    TabOrder = 4
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 136
    Width = 609
    Height = 97
    ScrollBars = ssBoth
    TabOrder = 3
    Visible = False
    WordWrap = False
  end
  object Edit1: TEdit
    Left = 88
    Top = 80
    Width = 169
    Height = 21
    TabOrder = 1
    Text = #24525#32773
  end
  object Edit2: TEdit
    Left = 88
    Top = 112
    Width = 169
    Height = 21
    TabOrder = 2
    Text = 'Edit2'
  end
  object Button2: TButton
    Left = 256
    Top = 16
    Width = 113
    Height = 49
    Caption = #19979#36733#27468#35789
    TabOrder = 6
    Visible = False
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 432
    Top = 64
    Width = 57
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'ComboBox1'
    Visible = False
  end
  object Button3: TButton
    Left = 264
    Top = 312
    Width = 161
    Height = 41
    Cancel = True
    Caption = #20445#23384#27468#35789
    TabOrder = 0
    OnClick = Button3Click
  end
  object ListView1: TListView
    Left = 32
    Top = 144
    Width = 369
    Height = 129
    Columns = <
      item
        AutoSize = True
        Caption = #27468#26354#21517#31216
      end
      item
        AutoSize = True
        Caption = #33402#26415#23478
      end
      item
        AutoSize = True
        Caption = #19987#38598
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    GridLines = True
    HideSelection = False
    RowSelect = True
    ParentFont = False
    TabOrder = 8
    ViewStyle = vsReport
  end
  object Button4: TButton
    Left = 184
    Top = 312
    Width = 75
    Height = 41
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 5
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'MiniLyrics 3.0'
    HTTPOptions = [hoKeepOrigProtocol]
    Left = 224
    Top = 32
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 32
    Top = 32
  end
end

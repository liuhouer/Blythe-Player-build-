object Form3: TForm3
  Left = 621
  Top = 138
  Width = 361
  Height = 183
  AlphaBlend = True
  AlphaBlendValue = 30
  BorderIcons = [biSystemMenu]
  Caption = #27468#35789#31168
  Color = clMoneyGreen
  TransparentColor = True
  TransparentColorValue = clMoneyGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clOlive
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lst1: TListBox
    Left = 0
    Top = 0
    Width = 345
    Height = 145
    Align = alClient
    BevelInner = bvSpace
    BevelKind = bkFlat
    BevelOuter = bvSpace
    BorderStyle = bsNone
    Color = clGradientInactiveCaption
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Segoe Script'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    ItemHeight = 20
    ParentFont = False
    TabOrder = 0
  end
  object tmr1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmr1Timer
    Left = 240
    Top = 80
  end
  object OBFormMagnet1: TOBFormMagnet
    Active = True
    FormGlue = False
    MainFormMagnet = True
    Left = 152
    Top = 72
  end
end

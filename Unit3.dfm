object LrcShow: TLrcShow
  Left = 695
  Top = 243
  Width = 246
  Height = 393
  Caption = #27468#35789#31168
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
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
    Width = 230
    Height = 355
    Align = alClient
    BevelInner = bvSpace
    BevelKind = bkFlat
    BevelOuter = bvSpace
    BorderStyle = bsNone
    Color = 10982031
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Segoe Script'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    ItemHeight = 20
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 0
  end
  object tmr1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmr1Timer
    Left = 152
    Top = 128
  end
  object OBFormMagnet1: TOBFormMagnet
    Active = True
    FormGlue = False
    MainFormMagnet = True
    Left = 152
    Top = 72
  end
  object PopupMenu1: TPopupMenu
    Left = 152
    Top = 32
    object N1: TMenuItem
      Caption = #26700#38754#27468#35789
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #21152#36733#27468#35789
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #25628#32034#27468#35789
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #32534#36753#27468#35789
      OnClick = N4Click
    end
  end
end

object LrcShow: TLrcShow
  Left = 504
  Top = 285
  Width = 326
  Height = 385
  AlphaBlendValue = 80
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #27468#35789#31168
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lst1: TRzEditListBox
    Left = 0
    Top = 0
    Width = 318
    Height = 351
    Align = alClient
    Color = 10920603
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    FrameColor = 12615808
    FrameHotColor = 10920603
    FrameHotStyle = fsNone
    FrameVisible = True
    GroupFont.Charset = DEFAULT_CHARSET
    GroupFont.Color = clGreen
    GroupFont.Height = -13
    GroupFont.Name = 'MS Sans Serif'
    GroupFont.Style = [fsBold]
    ImeName = #25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 18
    ParentFont = False
    PopupMenu = PopupMenu1
    ShowGroups = True
    Style = lbOwnerDrawFixed
    TabOrder = 0
  end
  object tmr1: TTimer
    Enabled = False
    Interval = 50
    Left = 136
    Top = 104
  end
  object PopupMenu1: TPopupMenu
    Left = 152
    Top = 32
    object N1: TMenuItem
      Caption = #26700#38754#27468#35789
    end
    object N2: TMenuItem
      Caption = #21152#36733#27468#35789
    end
    object N3: TMenuItem
      Caption = #25628#32034#27468#35789
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #32534#36753#27468#35789
    end
  end
end

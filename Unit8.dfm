object minilrc: Tminilrc
  Left = 239
  Top = 695
  Width = 908
  Height = 141
  Caption = 'minilrc'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 408
    Top = 32
    Width = 321
    Height = 41
    AutoSize = False
    Caption = #23567#27493#38745#21548#65292#38745#21548#31934#24425#65281
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object tmr: TTimer
    OnTimer = tmrTimer
    Left = 288
    Top = 40
  end
  object pm1: TPopupMenu
    Left = 192
    Top = 24
    object mni_topMost: TMenuItem
      AutoCheck = True
      Caption = #24635#22312#26368#21069
      OnClick = mni_topMostClick
    end
    object mni_transparent: TMenuItem
      AutoCheck = True
      Caption = #38145#23450#27468#35789
      OnClick = mni_transparentClick
    end
    object mni_exit: TMenuItem
      AutoCheck = True
      Caption = #36864#20986
      OnClick = mni_exitClick
    end
  end
  object OBFormMagnet1: TOBFormMagnet
    Active = True
    Left = 336
    Top = 32
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 240
    Top = 40
  end
end

object minilrc: Tminilrc
  Left = 379
  Top = 752
  Width = 605
  Height = 109
  AlphaBlend = True
  AlphaBlendValue = 200
  Caption = 'minilrc'
  Color = clBlack
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 144
    Top = 32
    Width = 169
    Height = 21
    AutoSize = False
    Caption = #23567#27493#38745#21548#65292#38745#21548#31934#24425#65281
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clYellow
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 344
    Top = 24
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 416
    Top = 32
  end
end

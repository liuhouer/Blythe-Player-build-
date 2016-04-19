object Form3: TForm3
  Left = 907
  Top = 182
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #27468#35789#31168
  ClientHeight = 459
  ClientWidth = 297
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
    Width = 297
    Height = 457
    Color = clMoneyGreen
    Font.Charset = GB2312_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = #24188#22278
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    ItemHeight = 13
    ParentFont = False
    TabOrder = 0
  end
  object tmr1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmr1Timer
    Left = 256
    Top = 128
  end
  object OBFormMagnet1: TOBFormMagnet
    Active = True
    FormGlue = False
    Left = 120
    Top = 104
  end
end

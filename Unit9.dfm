object Vision: TVision
  Left = 395
  Top = 219
  Align = alClient
  BorderStyle = bsNone
  Caption = 'Vision'
  ClientHeight = 447
  ClientWidth = 657
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  ScreenSnap = True
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object am2: TSkyAudioMeter
    Left = 0
    Top = 0
    Width = 657
    Height = 447
    Hint = #21333#26426#20999#25442#25928#26524
    ForeColor = 10808989
    DataScale = 32768
    WaveMode = svmNubby
    Redial = True
    FreqWidth = 15
    Align = alClient
    PopupMenu = PopupMenu1
    ShowHint = True
    OnClick = am2Click
  end
  object PopupMenu1: TPopupMenu
    Left = 544
    Top = 120
    object ppfx: TMenuItem
      Caption = #39057#35889#20998#26512
      OnClick = ppfxClick
    end
    object sbq: TMenuItem
      Caption = #31034#27874#27719#28857
      OnClick = sbqClick
    end
    object N2: TMenuItem
      Caption = #37197#33394
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Caption = #36864#20986#20840#23631
      OnClick = N1Click
    end
  end
  object ColorDialog1: TColorDialog
    Left = 544
    Top = 176
  end
end

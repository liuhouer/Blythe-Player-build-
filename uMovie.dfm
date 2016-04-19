object frmMovie: TfrmMovie
  Left = 238
  Top = 114
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 219
  ClientWidth = 356
  Color = clBlack
  DragMode = dmAutomatic
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel_Display: TPanel
    Left = 0
    Top = 0
    Width = 356
    Height = 219
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Color = clBlack
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnMouseDown = Panel_DisplayMouseDown
    OnMouseMove = Panel_DisplayMouseMove
  end
  object PopupMenu1: TPopupMenu
    Left = 224
    Top = 56
    object PopAbout: TMenuItem
      Caption = #20851#20110'(&A)...'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object PopOldView: TMenuItem
      Caption = #21407#22987#22823#23567'(&S)'
      OnClick = PopOldViewClick
    end
    object PopZoomIn: TMenuItem
      Caption = #25918#22823#26174#31034'(&I)'
      OnClick = PopZoomInClick
    end
    object PopZoomOut: TMenuItem
      Caption = #32553#23567#26174#31034'(&O)'
      OnClick = PopZoomOutClick
    end
    object PopFullDisplay: TMenuItem
      Caption = #20840#23631#26174#31034'(&F)'
      OnClick = PopFullDisplayClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object PopExit: TMenuItem
      Caption = #20851#38381#31383#21475'(&X)'
      OnClick = PopExitClick
    end
  end
end

object Form2: TForm2
  Left = 726
  Top = 308
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = #25628#32034#26412#22320#38899#20048
  ClientHeight = 370
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 0
    Top = 8
    Width = 75
    Height = 13
    Caption = '   '#25628#32034#30446#24405'      '
  end
  object lbl2: TLabel
    Left = -8
    Top = 168
    Width = 105
    Height = 13
    Caption = '     '#25628#32034#21040#30340#25991#20214'      '
  end
  object shltrvw1: TShellTreeView
    Left = 8
    Top = 24
    Width = 257
    Height = 137
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 0
  end
  object btn1: TButton
    Left = 272
    Top = 40
    Width = 121
    Height = 25
    Caption = #24320#22987#25628#32034
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 272
    Top = 72
    Width = 121
    Height = 25
    Caption = #20572#27490#25628#32034
    Enabled = False
    TabOrder = 2
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 272
    Top = 104
    Width = 121
    Height = 25
    Caption = #28155#21152#36873#20013
    TabOrder = 3
    OnClick = btn3Click
  end
  object btn4: TButton
    Left = 272
    Top = 136
    Width = 121
    Height = 25
    Caption = #28155#21152#25152#26377
    TabOrder = 4
    OnClick = btn4Click
  end
  object stat1: TStatusBar
    Left = 0
    Top = 351
    Width = 401
    Height = 19
    Panels = <>
  end
  object lst1: TListBox
    Left = 8
    Top = 184
    Width = 385
    Height = 161
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 6
    OnDblClick = lst1DblClick
  end
  object chk1: TCheckBox
    Left = 272
    Top = 24
    Width = 49
    Height = 17
    Caption = 'MP3'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object chk2: TCheckBox
    Left = 344
    Top = 24
    Width = 49
    Height = 17
    Caption = 'WMA'
    TabOrder = 8
  end
end

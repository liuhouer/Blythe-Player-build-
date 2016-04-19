object frmPlayList: TfrmPlayList
  Left = 227
  Top = 213
  Width = 345
  Height = 331
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'frmPlayList'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox_PlayFiles: TListBox
    Left = 8
    Top = 8
    Width = 225
    Height = 281
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = ListBox_PlayFilesDblClick
  end
  object Button1: TButton
    Left = 248
    Top = 64
    Width = 75
    Height = 25
    Caption = #28155#21152#25991#20214
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 248
    Top = 96
    Width = 75
    Height = 25
    Caption = #21024#38500#25991#20214
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 248
    Top = 128
    Width = 75
    Height = 25
    Caption = #28165#31354#21015#34920
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 248
    Top = 160
    Width = 75
    Height = 25
    Caption = #36733#20837#21015#34920
    TabOrder = 4
  end
  object Button5: TButton
    Left = 248
    Top = 192
    Width = 75
    Height = 25
    Caption = #20445#23384#21015#34920
    TabOrder = 5
    OnClick = Button5Click
  end
  object OpenDlg_PlayList: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 240
    Top = 24
  end
  object SaveDlg_PlayList: TSaveDialog
    Left = 272
    Top = 24
  end
  object AutoPlayTimer: TTimer
    OnTimer = AutoPlayTimerTimer
    Left = 256
    Top = 232
  end
end

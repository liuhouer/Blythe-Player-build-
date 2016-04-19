object frmMgr: TfrmMgr
  Left = 378
  Top = 192
  BorderStyle = bsDialog
  Caption = 'Theme Manager - SUIPack'
  ClientHeight = 301
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object List: TCheckListBox
    Left = 16
    Top = 16
    Width = 201
    Height = 185
    ItemHeight = 13
    TabOrder = 0
  end
  object btn_sel: TButton
    Left = 120
    Top = 208
    Width = 97
    Height = 25
    Caption = '&Select all'
    TabOrder = 1
    OnClick = btn_selClick
  end
  object btn_unsel: TButton
    Left = 16
    Top = 208
    Width = 97
    Height = 25
    Caption = '&Unselect all'
    TabOrder = 2
    OnClick = btn_unselClick
  end
  object btn_ok: TButton
    Left = 72
    Top = 264
    Width = 89
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
end

object Frm_List: TFrm_List
  Left = 659
  Top = 241
  Width = 351
  Height = 206
  Caption = 'Frm_List'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 105
    Top = 41
    Height = 112
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 343
    Height = 41
    Align = alTop
    TabOrder = 0
    object Btn_Add: TButton
      Left = 16
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Btn_Add'
      TabOrder = 0
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 41
    Width = 105
    Height = 112
    Align = alLeft
    Indent = 19
    TabOrder = 1
  end
  object ListView1: TListView
    Left = 108
    Top = 41
    Width = 235
    Height = 112
    Align = alClient
    Columns = <>
    TabOrder = 2
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 153
    Width = 343
    Height = 19
    Panels = <>
  end
end

object bTag: TbTag
  Left = 295
  Top = 335
  Width = 381
  Height = 308
  Caption = 'tag-id3v1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LTitle: TLabel
    Left = 3
    Top = 13
    Width = 48
    Height = 12
    Alignment = taRightJustify
    Caption = #33402#26415#23478#65306
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object LArtist: TLabel
    Left = 21
    Top = 43
    Width = 30
    Height = 12
    Alignment = taRightJustify
    Caption = #27468#26354':'
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object LAlbum: TLabel
    Left = 21
    Top = 76
    Width = 30
    Height = 12
    Alignment = taRightJustify
    Caption = #19987#36753':'
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object LYear: TLabel
    Left = 21
    Top = 110
    Width = 30
    Height = 12
    Alignment = taRightJustify
    Caption = #24180#20195':'
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object LComment: TLabel
    Left = 21
    Top = 142
    Width = 30
    Height = 12
    Alignment = taRightJustify
    Caption = #27880#37322':'
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object LTrack: TLabel
    Left = 21
    Top = 173
    Width = 30
    Height = 12
    Alignment = taRightJustify
    Caption = #38899#36712':'
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object LGenre: TLabel
    Left = 164
    Top = 173
    Width = 30
    Height = 12
    Alignment = taRightJustify
    Caption = #27969#27966':'
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object LFilePath: TLabel
    Left = 21
    Top = 205
    Width = 30
    Height = 12
    Caption = #36335#24452':'
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 56
    Top = 8
    Width = 249
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 56
    Top = 40
    Width = 249
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 56
    Top = 72
    Width = 249
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 2
  end
  object Edit4: TEdit
    Left = 56
    Top = 104
    Width = 249
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 3
  end
  object Edit5: TEdit
    Left = 56
    Top = 136
    Width = 249
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 4
  end
  object Edit6: TEdit
    Left = 56
    Top = 168
    Width = 97
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 5
  end
  object Button1: TButton
    Left = 56
    Top = 232
    Width = 41
    Height = 25
    Caption = #25171#24320
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 200
    Top = 168
    Width = 105
    Height = 21
    Style = csDropDownList
    Enabled = False
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 13
    TabOrder = 7
  end
  object Edit7: TEdit
    Left = 56
    Top = 200
    Width = 249
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 8
  end
  object Button2: TButton
    Left = 164
    Top = 232
    Width = 65
    Height = 25
    Caption = #35835#21462'(&L)'
    Enabled = False
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 232
    Top = 232
    Width = 75
    Height = 25
    Caption = #28165#31354
    Enabled = False
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 104
    Top = 232
    Width = 57
    Height = 25
    Caption = #20445#23384'(&S)'
    Enabled = False
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Filter = #38899#39057#23646#24615'MP3|*.MP3|'#38899#39057#23646#24615'wav|*.wav|'#38899#39057#23646#24615'wma|*.wma'
    Left = 320
    Top = 40
  end
end

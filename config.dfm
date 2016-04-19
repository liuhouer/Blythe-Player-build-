object FormConfig: TFormConfig
  Left = 959
  Top = 233
  BorderStyle = bsSingle
  Caption = #35774#32622
  ClientHeight = 306
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 329
    Height = 105
    Caption = #37197#32622
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 31
      Height = 13
      Caption = #36755#20986
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 29
      Height = 13
      Caption = #32531#20914
    end
    object Label3: TLabel
      Left = 200
      Top = 56
      Width = 44
      Height = 13
      Caption = #20248#20808#32423
    end
    object Label4: TLabel
      Left = 104
      Top = 56
      Width = 29
      Height = 13
      Caption = #39057#29575
    end
    object ComboDevice: TComboBox
      Left = 8
      Top = 32
      Width = 305
      Height = 21
      Style = csDropDownList
      ImeName = #25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboDeviceChange
    end
    object BuffComboBox: TComboBox
      Left = 8
      Top = 72
      Width = 89
      Height = 21
      Style = csDropDownList
      ImeName = #25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 1
      OnChange = BuffComboBoxChange
      Items.Strings = (
        '150 ms'
        '300 ms'
        '500 ms'
        '750 ms'
        '1 s'
        '1,5 s'
        '2 s')
    end
    object ComboFreq: TComboBox
      Left = 104
      Top = 72
      Width = 89
      Height = 21
      Style = csDropDownList
      ImeName = #25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 2
      OnChange = ComboFreqChange
      Items.Strings = (
        '96kHz'
        '48kHz'
        '44.1kHz'
        '22.05kHz'
        '11.025kHz')
    end
    object PriorityComboBox: TComboBox
      Left = 200
      Top = 72
      Width = 113
      Height = 21
      Style = csDropDownList
      ImeName = #25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 3
      OnChange = PriorityComboBoxChange
      Items.Strings = (
        #26368#39640
        #38386#32622
        #27491#24120
        #20020#30028)
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 120
    Width = 329
    Height = 89
    Caption = #24120#35268
    TabOrder = 1
    object InvTimeCheckBox: TCheckBox
      Left = 16
      Top = 16
      Width = 121
      Height = 17
      Caption = #26102#38388#26684#24335#36716#25442
      TabOrder = 0
    end
    object NumPLCheckBox: TCheckBox
      Left = 16
      Top = 40
      Width = 137
      Height = 17
      Caption = #25773#25918#32534#21495
      TabOrder = 1
      OnClick = NumPLCheckBoxClick
    end
    object PLClearCheck: TCheckBox
      Left = 16
      Top = 64
      Width = 153
      Height = 17
      Caption = #24320#21551#26102#28165#31354#21015#34920
      TabOrder = 2
    end
    object MoveCheck: TCheckBox
      Left = 176
      Top = 16
      Width = 97
      Height = 17
      Caption = #31227#21160#25152#26377
      TabOrder = 3
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 216
    Width = 257
    Height = 81
    Caption = #21487#35270#21270#37197#32622
    TabOrder = 2
    object Bevel1: TBevel
      Left = 80
      Top = 12
      Width = 169
      Height = 62
      Shape = bsFrame
    end
    object LabelFrames: TLabel
      Left = 92
      Top = 16
      Width = 115
      Height = 13
      Caption = #27599#31186#25773#25918#24103' (30 fps)'
    end
    object Label5: TLabel
      Left = 96
      Top = 56
      Width = 12
      Height = 13
      Caption = #32531
    end
    object Label6: TLabel
      Left = 216
      Top = 56
      Width = 12
      Height = 13
      Caption = #24555
    end
    object NoneDrawCheck: TRadioButton
      Left = 16
      Top = 16
      Width = 57
      Height = 17
      Caption = #26080
      TabOrder = 0
    end
    object WaveDrawCheck: TRadioButton
      Left = 16
      Top = 36
      Width = 57
      Height = 17
      Caption = #27874#28010
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object FpsBar: TTrackBar
      Left = 88
      Top = 32
      Width = 153
      Height = 25
      Max = 4
      Position = 2
      TabOrder = 2
      ThumbLength = 10
      OnChange = FpsBarChange
    end
    object FFTDrawCheck: TRadioButton
      Left = 16
      Top = 56
      Width = 57
      Height = 17
      Caption = #39057#35889
      TabOrder = 3
    end
  end
  object BtnClose: TButton
    Left = 272
    Top = 224
    Width = 67
    Height = 25
    Caption = #20851#38381
    TabOrder = 3
    OnClick = BtnCloseClick
  end
  object OBFormMagnet1: TOBFormMagnet
    Active = True
    FormGlue = False
    MainFormMagnet = True
    Left = 296
    Top = 264
  end
end

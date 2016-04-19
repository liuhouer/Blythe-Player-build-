object frmEPlayer: TfrmEPlayer
  Left = 209
  Top = 33
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = '== EPlayer'#25773#25918#22120' =='
  ClientHeight = 151
  ClientWidth = 379
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedBtn_Open: TSpeedButton
    Left = 24
    Top = 69
    Width = 50
    Height = 22
    Caption = #25171#24320
    OnClick = SpeedBtn_OpenClick
  end
  object SpeedBtn_Pause: TSpeedButton
    Left = 73
    Top = 69
    Width = 50
    Height = 22
    Caption = #26242#20572
    OnClick = SpeedBtn_PauseClick
  end
  object SpeedBtn_Up: TSpeedButton
    Left = 122
    Top = 69
    Width = 50
    Height = 22
    Caption = #21521#21069
    OnClick = SpeedBtn_UpClick
  end
  object SpeedBtn_Play: TSpeedButton
    Left = 24
    Top = 91
    Width = 50
    Height = 22
    Caption = #25773#25918
    OnClick = SpeedBtn_PlayClick
  end
  object SpeedBtn_Stop: TSpeedButton
    Left = 73
    Top = 91
    Width = 50
    Height = 22
    Caption = #20572#27490
    OnClick = SpeedBtn_StopClick
  end
  object SpeedBtn_Down: TSpeedButton
    Left = 122
    Top = 91
    Width = 50
    Height = 22
    Caption = #21521#21518
    OnClick = SpeedBtn_DownClick
  end
  object lbSoundLR: TLabel
    Left = 123
    Top = 164
    Width = 53
    Height = 13
    Caption = 'lbSoundLR'
  end
  object Panel1: TPanel
    Left = 1
    Top = 1
    Width = 199
    Height = 65
    BevelOuter = bvLowered
    Caption = 'MP3'#25773#25918#22120
    Font.Charset = GB2312_CHARSET
    Font.Color = clNavy
    Font.Height = -37
    Font.Name = #38582#20070
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Panel1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 132
    Width = 379
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object MediaPlayer: TMediaPlayer
    Left = 24
    Top = 155
    Width = 253
    Height = 20
    TabOrder = 2
  end
  object TrackBar1: TTrackBar
    Left = 213
    Top = 90
    Width = 150
    Height = 22
    Max = 255
    Orientation = trHorizontal
    Frequency = 1
    Position = 255
    SelEnd = 0
    SelStart = 0
    TabOrder = 3
    TickMarks = tmBoth
    TickStyle = tsNone
    OnChange = TrackBar1Change
  end
  object TrackBar_Play: TTrackBar
    Left = 4
    Top = 112
    Width = 372
    Height = 22
    Max = 100
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 4
    TickMarks = tmBoth
    TickStyle = tsNone
    OnChange = TrackBar_PlayChange
  end
  object btn_ShowPlayList: TButton
    Left = 221
    Top = 66
    Width = 137
    Height = 25
    Caption = #26174#31034#25773#25918#21015#34920
    TabOrder = 5
    OnClick = btn_ShowPlayListClick
  end
  object Panel2: TPanel
    Left = 203
    Top = 0
    Width = 175
    Height = 22
    BevelOuter = bvLowered
    Color = clBtnText
    TabOrder = 6
    object Label_Title: TLabel
      Left = 2
      Top = 4
      Width = 70
      Height = 14
      Caption = #24403#21069#26354#30446#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel3: TPanel
    Left = 203
    Top = 20
    Width = 175
    Height = 22
    BevelOuter = bvLowered
    Color = clBtnText
    TabOrder = 7
    DesignSize = (
      175
      22)
    object lbl_TotalTime: TLabel
      Left = 15
      Top = 4
      Width = 105
      Height = 14
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight, akBottom]
      BiDiMode = bdRightToLeft
      Caption = #24635#26102#38388':00:00:00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      Transparent = True
    end
  end
  object Panel4: TPanel
    Left = 203
    Top = 40
    Width = 175
    Height = 22
    BevelOuter = bvLowered
    Color = clBtnText
    TabOrder = 8
    DesignSize = (
      175
      22)
    object lbl_PlayTime: TLabel
      Left = 2
      Top = 4
      Width = 119
      Height = 14
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight, akBottom]
      BiDiMode = bdRightToLeft
      Caption = #25773#25918#26102#38388':00:00:00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      Transparent = True
    end
  end
  object pm_Right: TPopupMenu
    AutoHotkeys = maManual
    Left = 72
    Top = 8
    object N1: TMenuItem
      Caption = #25171#24320#21333#20010#25991#20214
    end
    object N2: TMenuItem
      Caption = #25171#24320#22810#20010#25991#20214
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #24433#35270#25991#20214#27427#36175
    end
    object N5: TMenuItem
      Caption = #25773#25918#29366#24577
      object N34: TMenuItem
        Caption = #21333#27425#25773#25918
      end
      object N35: TMenuItem
        Caption = #24490#29615#25773#25918
      end
      object N36: TMenuItem
        Caption = '-'
      end
      object N37: TMenuItem
        Caption = #32487#32493#25773#25918
        Enabled = False
      end
      object N38: TMenuItem
        Caption = #26242#20572#25773#25918
      end
      object N39: TMenuItem
        Caption = '-'
      end
      object N40: TMenuItem
        Caption = #38543#26426#25773#25918
      end
      object N41: TMenuItem
        Caption = #39034#24207#25773#25918
      end
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N7: TMenuItem
      Caption = #19978#19968#39318#27468#26354
    end
    object N8: TMenuItem
      Caption = #19979#19968#39318#27468#26354
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Caption = #31383#21475#31649#29702#25511#21046
      object N26: TMenuItem
        Caption = #21551#21160#27468#26354#30446#24405
      end
      object N27: TMenuItem
        Caption = #20851#38381#27468#26354#30446#24405
        Enabled = False
      end
      object N25: TMenuItem
        Caption = '-'
      end
      object N23: TMenuItem
        Caption = #21551#21160#20316#32773#20449#24687
      end
      object N24: TMenuItem
        Caption = #20851#38381#20316#32773#20449#24687
        Enabled = False
      end
      object N28: TMenuItem
        Caption = '-'
      end
      object N29: TMenuItem
        Caption = #31383#21475#27491#24120#21270
      end
      object N30: TMenuItem
        Caption = #31383#21475#26368#23567#21270
      end
      object N31: TMenuItem
        Caption = #31383#21475#22312#26368#19978#26041
      end
      object N32: TMenuItem
        Caption = '-'
      end
      object N33: TMenuItem
        Caption = #21551#21160#24110#21161#20449#24687
      end
    end
    object N11: TMenuItem
      Caption = #38899#37327#25511#21046#21488
      object N14: TMenuItem
        Caption = #24038#22768#36947
      end
      object N15: TMenuItem
        Caption = #21491#22768#36947
      end
      object N16: TMenuItem
        Caption = #31435#20307#22768
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object N18: TMenuItem
        Caption = #38899#37327#22686#21152
      end
      object N19: TMenuItem
        Caption = #38899#37327#20943#23567
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object N21: TMenuItem
        Caption = #24494#36719#25511#21046#21488
      end
      object N22: TMenuItem
        Caption = #38745#38899'/'#24674#22797
      end
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object N13: TMenuItem
      Caption = #20851#38381#31243#24207
    end
  end
  object OpenDlg_Files: TOpenDialog
    Left = 8
    Top = 8
  end
  object SaveDlg_Files: TSaveDialog
    Left = 40
    Top = 8
  end
  object Timer_Play: TTimer
    OnTimer = Timer_PlayTimer
    Left = 104
    Top = 8
  end
end

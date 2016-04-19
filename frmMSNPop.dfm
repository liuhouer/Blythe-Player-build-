object frmMSNPopForm: TfrmMSNPopForm
  Left = 337
  Top = 244
  BorderStyle = bsToolWindow
  Caption = 'frmMSNPopForm'
  ClientHeight = 120
  ClientWidth = 195
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Scaled = False
  OnClick = FormClick
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_title: TLabel
    Left = 8
    Top = 8
    Width = 105
    Height = 13
    AutoSize = False
    Caption = 'l'
    Color = clNavy
    ParentColor = False
    Transparent = True
  end
  object lbl_text: TLabel
    Left = 11
    Top = 32
    Width = 133
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 't'
    Color = clNavy
    ParentColor = False
    Transparent = True
    WordWrap = True
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 168
    Top = 88
  end
end

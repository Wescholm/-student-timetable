object Form2: TForm2
  Left = 521
  Top = 356
  Width = 621
  Height = 301
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 16
    Top = 48
    Width = 585
    Height = 209
    RowCount = 8
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 0
    OnSelectCell = StringGrid1SelectCell
    ColWidths = (
      64
      168
      146
      107
      64)
  end
  object ComboBox1: TComboBox
    Left = 264
    Top = 16
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
    OnCloseUp = ComboBox1CloseUp
    OnExit = ComboBox1Exit
  end
  object ComboBox2: TComboBox
    Left = 16
    Top = 16
    Width = 145
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
    Text = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
    OnChange = ComboBox2Change
    Items.Strings = (
      #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
      #1042#1090#1086#1088#1085#1080#1082
      #1057#1088#1077#1076#1072
      #1063#1077#1090#1074#1077#1088#1075
      #1055#1103#1090#1085#1080#1094#1072)
  end
  object Button1: TButton
    Left = 168
    Top = 16
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
end

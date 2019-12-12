object Form1: TForm1
  Left = 625
  Top = 162
  Width = 626
  Height = 480
  Caption = #1056#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1079#1072#1085#1103#1090#1080#1081
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
  object DateTimePicker1: TDateTimePicker
    Left = 16
    Top = 16
    Width = 186
    Height = 21
    Date = 43621.772227268520000000
    Time = 43621.772227268520000000
    TabOrder = 0
    OnChange = DateTimePicker1Change
  end
  object StringGrid1: TStringGrid
    Left = 16
    Top = 48
    Width = 585
    Height = 209
    RowCount = 8
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 1
    ColWidths = (
      64
      168
      146
      107
      64)
  end
  object Button1: TButton
    Left = 216
    Top = 16
    Width = 105
    Height = 25
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 296
    Width = 585
    Height = 121
    TabOrder = 3
  end
  object Button2: TButton
    Left = 16
    Top = 264
    Width = 249
    Height = 25
    Caption = #1057#1087#1080#1089#1086#1082' '#1087#1088#1077#1076#1084#1077#1090#1086#1074', '#1074#1093#1086#1076#1103#1097#1080#1093' '#1074' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 272
    Top = 264
    Width = 233
    Height = 25
    Caption = #1056#1072#1089#1087#1080#1089#1072#1085#1080#1077' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1087#1088#1077#1076#1084#1077#1090#1072
    TabOrder = 5
    OnClick = Button3Click
  end
  object SaveDialog1: TSaveDialog
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt'
    Left = 560
    Top = 264
  end
end

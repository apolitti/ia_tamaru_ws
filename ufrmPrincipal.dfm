object frmPrincipal: TfrmPrincipal
  Left = 271
  Top = 114
  BorderStyle = bsSingle
  Caption = 'INFORMACTION'
  ClientHeight = 193
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 48
    Width = 26
    Height = 13
    Caption = 'Porta'
  end
  object Lb_Banco: TLabel
    Left = 134
    Top = 150
    Width = 33
    Height = 13
    Caption = 'Banco:'
  end
  object Lb_Banco1: TLabel
    Left = 173
    Top = 150
    Width = 12
    Height = 13
    Caption = '...'
  end
  object Label2: TLabel
    Left = 19
    Top = 8
    Width = 402
    Height = 25
    Caption = 'Web Service - Apontamento Eletr'#244'nico'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ButtonStart: TButton
    Left = 138
    Top = 65
    Width = 75
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 219
    Top = 65
    Width = 75
    Height = 25
    Caption = 'Parar'
    TabOrder = 1
    OnClick = ButtonStopClick
  end
  object EditPort: TEdit
    Left = 12
    Top = 67
    Width = 120
    Height = 21
    TabOrder = 2
    Text = '12395'
  end
  object ButtonOpenBrowser: TButton
    Left = 12
    Top = 101
    Width = 120
    Height = 25
    Caption = 'Open Browser'
    TabOrder = 3
    OnClick = ButtonOpenBrowserClick
  end
  object Bo_Banco: TButton
    Left = 12
    Top = 143
    Width = 120
    Height = 25
    Caption = 'Conectar Banco'
    TabOrder = 4
    OnClick = Bo_BancoClick
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 152
    Top = 96
  end
end

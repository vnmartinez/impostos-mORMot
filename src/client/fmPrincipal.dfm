object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'Projeto teste'
  ClientHeight = 558
  ClientWidth = 1034
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnFundo: TPanel
    Left = 0
    Top = 0
    Width = 1034
    Height = 558
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    ExplicitWidth = 1030
    ExplicitHeight = 557
    object splt: TSplitter
      Left = 241
      Top = 1
      Height = 556
      ExplicitLeft = 424
      ExplicitTop = 200
      ExplicitHeight = 100
    end
    object lbTabelas: TListBox
      Left = 1
      Top = 1
      Width = 240
      Height = 556
      Align = alLeft
      ItemHeight = 15
      TabOrder = 0
      OnClick = LbTabelasClick
      ExplicitHeight = 555
    end
    object pcTabelas: TPageControl
      Left = 244
      Top = 1
      Width = 789
      Height = 556
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 785
      ExplicitHeight = 555
    end
  end
end

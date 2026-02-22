object frameVCLGrid: TframeVCLGrid
  Left = 0
  Top = 0
  Width = 961
  Height = 478
  TabOrder = 0
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 961
    Height = 440
    Align = alClient
    DataSource = ds
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object pnRodape: TPanel
    Left = 0
    Top = 440
    Width = 961
    Height = 38
    Align = alBottom
    TabOrder = 1
    object btnExportarExcel: TButton
      Left = 8
      Top = 6
      Width = 129
      Height = 25
      Caption = 'Exportar para excel'
      TabOrder = 0
    end
    object btnAdicionar: TButton
      Left = 143
      Top = 6
      Width = 90
      Height = 25
      Caption = 'Adicionar'
      TabOrder = 1
    end
    object btnEditar: TButton
      Left = 239
      Top = 6
      Width = 90
      Height = 25
      Caption = 'Editar'
      TabOrder = 2
    end
  end
  object ds: TDataSource
    Left = 48
    Top = 48
  end
end

object APICovid: TAPICovid
  Left = 0
  Top = 0
  Caption = 'APICovid'
  ClientHeight = 441
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 884
    Height = 137
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 767
    object Label1: TLabel
      Left = 16
      Top = 2
      Width = 163
      Height = 17
      Caption = 'Pesquisa por Nome do Pa'#237's'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object edtPais: TEdit
      Left = 16
      Top = 25
      Width = 241
      Height = 23
      TabOrder = 0
    end
    object rgOrdem: TRadioGroup
      Left = 336
      Top = 3
      Width = 329
      Height = 105
      Caption = 'Ordena'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Items.Strings = (
        'N'#250'mero de Casos Confirmados'
        'N'#250'mero de Mortes'
        'N'#250'mero de Recuperados')
      ParentFont = False
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 137
    Width = 884
    Height = 304
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 120
    ExplicitTop = 264
    ExplicitWidth = 185
    ExplicitHeight = 41
    object gridAPI: TDBGrid
      Left = 1
      Top = 1
      Width = 882
      Height = 302
      Align = alClient
      DataSource = dsAPI
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object cdsAPI: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 104
    Top = 232
  end
  object httpClientAPI: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 152
    Top = 232
  end
  object dsAPI: TDataSource
    DataSet = cdsAPI
    Left = 344
    Top = 249
  end
end

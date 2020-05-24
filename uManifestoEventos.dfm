object frmManifestoEventos: TfrmManifestoEventos
  Left = 0
  Top = 0
  Caption = 'Eventos'
  ClientHeight = 355
  ClientWidth = 1027
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1027
    Height = 355
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 128
    ExplicitTop = 80
    ExplicitWidth = 185
    ExplicitHeight = 41
    object SMDBGrid1: TSMDBGrid
      Left = 1
      Top = 1
      Width = 1025
      Height = 353
      Align = alClient
      DataSource = DMManifesto.dsManifestoEventos
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Flat = False
      BandsFont.Charset = DEFAULT_CHARSET
      BandsFont.Color = clWindowText
      BandsFont.Height = -11
      BandsFont.Name = 'Tahoma'
      BandsFont.Style = []
      Groupings = <>
      GridStyle.Style = gsNormal
      GridStyle.OddColor = clWindow
      GridStyle.EvenColor = clWindow
      TitleHeight.PixelCount = 24
      FooterColor = clBtnFace
      ExOptions = [eoENTERlikeTAB, eoKeepSelection, eoStandardPopup, eoBLOBEditor, eoTitleWordWrap, eoFilterAutoApply]
      RegistryKey = 'Software\Scalabium'
      RegistrySection = 'SMDBGrid'
      WidthOfIndicator = 11
      DefaultRowHeight = 17
      ScrollBars = ssHorizontal
      Columns = <
        item
          Expanded = False
          FieldName = 'ID'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CHAVE_ACESSO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TIPO_EVENTO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ORGAO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SEQ_EVENTO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DTEVENTO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRICAO_EVENTO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COD_EVENTO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FILIAL'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSU'
          Visible = True
        end>
    end
  end
end

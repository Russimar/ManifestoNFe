object DMManifesto: TDMManifesto
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 308
  Width = 433
  object sqlManifesto: TFDQuery
    OnCalcFields = sqlManifestoCalcFields
    Connection = DMConection.FDConnection
    SQL.Strings = (
      'select *'
      'from MANIFESTO_AN MA'
      
        'where (MA.CHAVE_ACESSO = :CHAVEACESSO or cast(:CHAVEACESSO as va' +
        'rchar(44)) = '#39#39')   '
      'order by NSU Desc')
    Left = 24
    Top = 32
    ParamData = <
      item
        Name = 'CHAVEACESSO'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
    object sqlManifestoID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object sqlManifestoCHAVE_ACESSO: TStringField
      DisplayLabel = 'Chave Acesso'
      FieldName = 'CHAVE_ACESSO'
      Origin = 'CHAVE_ACESSO'
      Size = 44
    end
    object sqlManifestoCNPJ: TStringField
      FieldName = 'CNPJ'
      Origin = 'CNPJ'
      EditMask = '99.999.999/9999-99;0'
      Size = 18
    end
    object sqlManifestoINSC_ESTADUAL: TStringField
      DisplayLabel = 'Insc Estadual'
      FieldName = 'INSC_ESTADUAL'
      Origin = 'INSC_ESTADUAL'
    end
    object sqlManifestoDTEMISSAO: TStringField
      DisplayLabel = 'Dt Emiss'#227'o'
      FieldName = 'DTEMISSAO'
      Origin = 'DTEMISSAO'
      Size = 30
    end
    object sqlManifestoNOME: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 70
    end
    object sqlManifestoNUM_NOTA: TLargeintField
      DisplayLabel = 'N'#186' Nota'
      FieldName = 'NUM_NOTA'
      Origin = 'NUM_NOTA'
    end
    object sqlManifestoVLR_NOTA: TFloatField
      DisplayLabel = 'Vlr Nota'
      FieldName = 'VLR_NOTA'
      Origin = 'VLR_NOTA'
      DisplayFormat = '#,##0.00'
    end
    object sqlManifestoNUM_PROTOCOLO: TStringField
      DisplayLabel = 'N'#186' Protocolo'
      FieldName = 'NUM_PROTOCOLO'
      Origin = 'NUM_PROTOCOLO'
      Size = 25
    end
    object sqlManifestoDOWNLOAD: TStringField
      DisplayLabel = 'Download'
      FieldName = 'DOWNLOAD'
      Origin = 'DOWNLOAD'
      FixedChar = True
      Size = 1
    end
    object sqlManifestoGRAVADA_NOTA: TStringField
      DisplayLabel = 'Gravada Nota'
      FieldName = 'GRAVADA_NOTA'
      Origin = 'GRAVADA_NOTA'
      FixedChar = True
      Size = 1
    end
    object sqlManifestoTIPO_EVE: TStringField
      DisplayLabel = 'Tipo Evento'
      FieldName = 'TIPO_EVE'
      Origin = 'TIPO_EVE'
    end
    object sqlManifestoCNPJ_FILIAL: TStringField
      DisplayLabel = 'CNPJ Filial'
      FieldName = 'CNPJ_FILIAL'
      Origin = 'CNPJ_FILIAL'
      Size = 18
    end
    object sqlManifestoFILIAL: TIntegerField
      DisplayLabel = 'Filial'
      FieldName = 'FILIAL'
      Origin = 'FILIAL'
    end
    object sqlManifestoNOTA_PROPRIA: TStringField
      DisplayLabel = 'Nota Pr'#243'pria'
      FieldName = 'NOTA_PROPRIA'
      Origin = 'NOTA_PROPRIA'
      FixedChar = True
      Size = 1
    end
    object sqlManifestoSERIE: TStringField
      DisplayLabel = 'S'#233'rie'
      FieldName = 'SERIE'
      Origin = 'SERIE'
      Size = 3
    end
    object sqlManifestoNSU: TStringField
      FieldName = 'NSU'
      Origin = 'NSU'
      Size = 15
    end
    object sqlManifestoDTEMISSAO2: TDateField
      DisplayLabel = 'Dt Emiss'#227'o 2'
      FieldName = 'DTEMISSAO2'
      Origin = 'DTEMISSAO2'
    end
    object sqlManifestoPOSSUI_CCE: TStringField
      DisplayLabel = 'CCE'
      FieldName = 'POSSUI_CCE'
      Origin = 'POSSUI_CCE'
      Size = 1
    end
    object sqlManifestoOCULTAR: TStringField
      DisplayLabel = 'Ocultar'
      FieldName = 'OCULTAR'
      Origin = 'OCULTAR'
      Size = 1
    end
    object sqlManifestoDTRECEBIMENTO: TDateField
      FieldName = 'DTRECEBIMENTO'
      Origin = 'DTRECEBIMENTO'
    end
    object sqlManifestoSITUACAO_MANIF: TStringField
      FieldName = 'SITUACAO_MANIF'
      Origin = 'SITUACAO_MANIF'
      FixedChar = True
      Size = 1
    end
    object sqlManifestoSITUACAO_NFE: TStringField
      FieldName = 'SITUACAO_NFE'
      Origin = 'SITUACAO_NFE'
      FixedChar = True
      Size = 1
    end
    object sqlManifestoBaixado: TStringField
      FieldKind = fkCalculated
      FieldName = 'Baixado'
      Size = 3
      Calculated = True
    end
    object sqlManifestoDescSituacao_Manif: TStringField
      FieldKind = fkCalculated
      FieldName = 'DescSituacao_Manif'
      Size = 25
      Calculated = True
    end
  end
  object sqlFilial: TFDQuery
    Connection = DMConection.FDConnection
    SQL.Strings = (
      'SELECT ID, NOME, NOME_INTERNO, UF, CNPJ_CPF FROM FILIAL')
    Left = 176
    Top = 40
    object sqlFilialID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object sqlFilialNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 60
    end
    object sqlFilialNOME_INTERNO: TStringField
      FieldName = 'NOME_INTERNO'
      Origin = 'NOME_INTERNO'
      Size = 30
    end
    object sqlFilialUF: TStringField
      FieldName = 'UF'
      Origin = 'UF'
      Size = 2
    end
    object sqlFilialCNPJ_CPF: TStringField
      FieldName = 'CNPJ_CPF'
      Origin = 'CNPJ_CPF'
      Size = 18
    end
  end
  object dsFilial: TDataSource
    DataSet = sqlFilial
    Left = 216
    Top = 40
  end
  object ACBrNFe: TACBrNFe
    Configuracoes.Geral.SSLLib = libWinCrypt
    Configuracoes.Geral.SSLCryptLib = cryWinCrypt
    Configuracoes.Geral.SSLHttpLib = httpWinHttp
    Configuracoes.Geral.SSLXmlSignLib = xsLibXml2
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Geral.VersaoQRCode = veqr000
    Configuracoes.Arquivos.AdicionarLiteral = True
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.Arquivos.EmissaoPathNFe = True
    Configuracoes.WebServices.UF = 'RS'
    Configuracoes.WebServices.Ambiente = taProducao
    Configuracoes.WebServices.AguardarConsultaRet = 15000
    Configuracoes.WebServices.AjustaAguardaConsultaRet = True
    Configuracoes.WebServices.TimeOut = 15000
    Configuracoes.WebServices.QuebradeLinha = '|'
    Configuracoes.RespTec.IdCSRT = 0
    Left = 176
    Top = 104
  end
  object sqlConsulta: TFDQuery
    Connection = DMConection.FDConnection
    SQL.Strings = (
      'select AN.*'
      'FROM manifesto_AN AN'
      'WHERE AN.filial = :FILIAL')
    Left = 48
    Top = 192
    ParamData = <
      item
        Name = 'FILIAL'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsManifesto: TDataSource
    DataSet = sqlManifesto
    Left = 72
    Top = 32
  end
  object sqlManifesto_Eve: TFDQuery
    Connection = DMConection.FDConnection
    SQL.Strings = (
      'select *'
      'from MANIFESTO_EVE'
      'where CHAVE_ACESSO = :CHAVEACESSO and'
      
        '      (TIPO_EVENTO = :TIPOEVENTO or cast(:TIPOEVENTO AS VARCHAR(' +
        '20)) = '#39#39')')
    Left = 32
    Top = 88
    ParamData = <
      item
        Name = 'CHAVEACESSO'
        DataType = ftString
        ParamType = ptInput
        Size = 44
        Value = Null
      end
      item
        Name = 'TIPOEVENTO'
        DataType = ftString
        ParamType = ptInput
        Size = 20
      end>
    object sqlManifesto_EveID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object sqlManifesto_EveCHAVE_ACESSO: TStringField
      DisplayLabel = 'Chave Acesso'
      FieldName = 'CHAVE_ACESSO'
      Origin = 'CHAVE_ACESSO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 44
    end
    object sqlManifesto_EveTIPO_EVENTO: TStringField
      DisplayLabel = 'Tipo Evento'
      FieldName = 'TIPO_EVENTO'
      Origin = 'TIPO_EVENTO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object sqlManifesto_EveSCHEMA: TStringField
      FieldName = 'SCHEMA'
      Origin = '"SCHEMA"'
      Size = 50
    end
    object sqlManifesto_EveXML: TMemoField
      FieldName = 'XML'
      Origin = 'XML'
      BlobType = ftMemo
    end
    object sqlManifesto_EveORGAO: TStringField
      DisplayLabel = 'Org'#227'o'
      FieldName = 'ORGAO'
      Origin = 'ORGAO'
      Size = 5
    end
    object sqlManifesto_EveSEQ_EVENTO: TIntegerField
      DisplayLabel = 'Seq.Evento'
      FieldName = 'SEQ_EVENTO'
      Origin = 'SEQ_EVENTO'
    end
    object sqlManifesto_EveDTEVENTO: TDateField
      DisplayLabel = 'Dt Evento'
      FieldName = 'DTEVENTO'
      Origin = 'DTEVENTO'
    end
    object sqlManifesto_EveDESCRICAO_EVENTO: TStringField
      DisplayLabel = 'Descri'#231#227'o Evento'
      FieldName = 'DESCRICAO_EVENTO'
      Origin = 'DESCRICAO_EVENTO'
      Size = 60
    end
    object sqlManifesto_EveCOD_EVENTO: TStringField
      DisplayLabel = 'C'#243'd.Evento'
      FieldName = 'COD_EVENTO'
      Origin = 'COD_EVENTO'
      Size = 10
    end
    object sqlManifesto_EveFILIAL: TIntegerField
      DisplayLabel = 'Filial'
      FieldName = 'FILIAL'
      Origin = 'FILIAL'
    end
    object sqlManifesto_EveNOTA_PROPRIA: TStringField
      FieldName = 'NOTA_PROPRIA'
      Origin = 'NOTA_PROPRIA'
      FixedChar = True
      Size = 1
    end
    object sqlManifesto_EveNUM_NOTA: TIntegerField
      FieldName = 'NUM_NOTA'
      Origin = 'NUM_NOTA'
    end
    object sqlManifesto_EveSERIE: TStringField
      FieldName = 'SERIE'
      Origin = 'SERIE'
      Size = 3
    end
    object sqlManifesto_EveNSU: TStringField
      FieldName = 'NSU'
      Origin = 'NSU'
      Size = 15
    end
  end
  object dsManifestoEventos: TDataSource
    DataSet = sqlManifesto_Eve
    Left = 80
    Top = 88
  end
end

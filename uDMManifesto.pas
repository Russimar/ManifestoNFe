unit uDMManifesto;

interface

uses
  System.SysUtils, System.Classes, DmdConnection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, ACBrBase, ACBrDFe, ACBrNFe,
  uUtilPadrao, Datasnap.DBClient, pcnConversao;

type
  TDMManifesto = class(TDataModule)
    sqlManifesto: TFDQuery;
    sqlFilial: TFDQuery;
    dsFilial: TDataSource;
    sqlFilialID: TIntegerField;
    sqlFilialNOME: TStringField;
    sqlFilialNOME_INTERNO: TStringField;
    ACBrNFe: TACBrNFe;
    sqlConsulta: TFDQuery;
    sqlFilialUF: TStringField;
    sqlFilialCNPJ_CPF: TStringField;
    dsManifesto: TDataSource;
    sqlManifestoID: TIntegerField;
    sqlManifestoCHAVE_ACESSO: TStringField;
    sqlManifestoCNPJ: TStringField;
    sqlManifestoINSC_ESTADUAL: TStringField;
    sqlManifestoDTEMISSAO: TStringField;
    sqlManifestoNOME: TStringField;
    sqlManifestoNUM_NOTA: TLargeintField;
    sqlManifestoVLR_NOTA: TFloatField;
    sqlManifestoNUM_PROTOCOLO: TStringField;
    sqlManifestoDOWNLOAD: TStringField;
    sqlManifestoGRAVADA_NOTA: TStringField;
    sqlManifestoTIPO_EVE: TStringField;
    sqlManifestoCNPJ_FILIAL: TStringField;
    sqlManifestoFILIAL: TIntegerField;
    sqlManifestoNOTA_PROPRIA: TStringField;
    sqlManifestoSERIE: TStringField;
    sqlManifestoNSU: TStringField;
    sqlManifestoDTEMISSAO2: TDateField;
    sqlManifestoPOSSUI_CCE: TStringField;
    sqlManifestoOCULTAR: TStringField;
    sqlManifestoDTRECEBIMENTO: TDateField;
    sqlManifestoSITUACAO_MANIF: TStringField;
    sqlManifestoSITUACAO_NFE: TStringField;
    sqlManifestoBaixado: TStringField;
    sqlManifestoDescSituacao_Manif: TStringField;
    sqlManifesto_Eve: TFDQuery;
    sqlManifesto_EveID: TIntegerField;
    sqlManifesto_EveCHAVE_ACESSO: TStringField;
    sqlManifesto_EveTIPO_EVENTO: TStringField;
    sqlManifesto_EveSCHEMA: TStringField;
    sqlManifesto_EveXML: TMemoField;
    sqlManifesto_EveORGAO: TStringField;
    sqlManifesto_EveSEQ_EVENTO: TIntegerField;
    sqlManifesto_EveDTEVENTO: TDateField;
    sqlManifesto_EveDESCRICAO_EVENTO: TStringField;
    sqlManifesto_EveCOD_EVENTO: TStringField;
    sqlManifesto_EveFILIAL: TIntegerField;
    sqlManifesto_EveNOTA_PROPRIA: TStringField;
    sqlManifesto_EveNUM_NOTA: TIntegerField;
    sqlManifesto_EveSERIE: TStringField;
    sqlManifesto_EveNSU: TStringField;
    dsManifestoEventos: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure sqlManifestoCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    ctConsulta : String;
    procedure Inicia_NFe;
    procedure prc_Localizar(ID : Integer);
    procedure EnviarEvento(pTipo : TpcnTpEvento);
    function ultimo_nsu(ID_Filial : Integer) : Integer;
  end;

var
  DMManifesto: TDMManifesto;

implementation

uses
  Vcl.Dialogs;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMManifesto }

procedure TDMManifesto.DataModuleCreate(Sender: TObject);
begin
  ctConsulta := sqlConsulta.SQL.Text;
end;

procedure TDMManifesto.EnviarEvento(pTipo: TpcnTpEvento);
var
  sCNPJ, lMsg, vSIT_EVENTO  : String;
begin
  ACBrNFe.NotasFiscais.Clear;
  Inicia_NFe;

  sCNPJ    := Monta_Numero(sqlFilialCNPJ_CPF.AsString,14);

  ACBrNFe.EventoNFe.Evento.Clear;
  with ACBrNFe.EventoNFe.Evento.New do
  begin
      InfEvento.cOrgao       := 91;
      InfEvento.chNFe        := Trim(sqlManifestoCHAVE_ACESSO.AsString);
      InfEvento.CNPJ         := sCNPJ;
      InfEvento.dhEvento     := Now;
      InfEvento.tpEvento     := pTipo;
      InfEvento.versaoEvento := '1.00';
  end;

  if (pTipo = teManifDestCiencia) then
    vSIT_EVENTO := '1'
  else
  if (pTipo = teManifDestConfirmacao) then
    vSIT_EVENTO := '2'
  else
  if (pTipo = teManifDestDesconhecimento) then
    vSIT_EVENTO := '3'
  else
  if (pTipo = teManifDestOperNaoRealizada) then
    vSIT_EVENTO := '4';
  ACBrNFe.EnviarEvento(StrToInt(vSIT_EVENTO));

  if (ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat = 128)or
     (ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat = 135) then
  begin
    sqlManifesto.Edit;
    sqlManifestoSITUACAO_MANIF.AsString := vSIT_EVENTO;
    sqlManifesto.Post;
  end
  else
  if ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.cStat = 573 then
  begin
     ShowMessage('Duplicidade de Evento!');
     sqlManifesto.Edit;
     sqlManifestoSITUACAO_MANIF.AsString := vSIT_EVENTO;
     sqlManifesto.Post;
  end
  else
  if ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.xMotivo <> '135' then
  begin
      with ACBrNFe.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento do
      begin
          lMsg:=
          'Id: '+Id+#13+
          'tpAmb: '+TpAmbToStr(tpAmb)+#13+
          'verAplic: '+verAplic+#13+
          'cOrgao: '+IntToStr(cOrgao)+#13+
          'cStat: '+IntToStr(cStat)+#13+
          'xMotivo: '+xMotivo+#13+
          'chNFe: '+chNFe+#13+
          'tpEvento: '+TpEventoToStr(tpEvento)+#13+
          'xEvento: '+xEvento+#13+
          'nSeqEvento: '+IntToStr(nSeqEvento)+#13+
          'CNPJDest: '+CNPJDest+#13+
          'emailDest: '+emailDest+#13+
          'dhRegEvento: '+DateTimeToStr(dhRegEvento)+#13+
          'nProt: '+nProt;
      end;
      ShowMessage(lMsg);
  end;

end;

procedure TDMManifesto.Inicia_NFe;
begin
  {$IFDEF ACBrNFeOpenSSL}
    ACBrNFe.Configuracoes.Certificados.Certificado  := SQLLocate('FILIAL_CERTIFICADOS','ID','NUMERO_SERIE',sqlFilialID.AsString);
    ACBrNFe.Configuracoes.Certificados.Senha        := SQLLocate('FILIAL_CERTIFICADOS','ID','SENHA_WEB',sqlFilialID.AsString);
  {$ELSE}
    ACBrNFe.Configuracoes.Certificados.NumeroSerie  := SQLLocate('FILIAL_CERTIFICADOS','ID','NUMERO_SERIE',sqlFilialID.AsString);
  {$ENDIF}

end;

procedure TDMManifesto.prc_Localizar(ID: Integer);
begin
  sqlManifesto.Close;
  sqlManifesto.ParamByName('ID').AsInteger := ID;
  sqlManifesto.Open;
end;

procedure TDMManifesto.sqlManifestoCalcFields(DataSet: TDataSet);
begin
  if sqlManifestoSITUACAO_MANIF.AsString = '1' then
    sqlManifestoDescSituacao_Manif.AsString := 'Ciencia Operação';
  if sqlManifestoSITUACAO_MANIF.AsString = '2' then
    sqlManifestoDescSituacao_Manif.AsString := 'Confirmada Operação';
  if sqlManifestoSITUACAO_MANIF.AsString = '3' then
    sqlManifestoDescSituacao_Manif.AsString := 'Desconhece Operação';
  if sqlManifestoSITUACAO_MANIF.AsString = '4' then
    sqlManifestoDescSituacao_Manif.AsString := 'Operação não Realizada';

  if sqlManifestoDOWNLOAD.AsString = 'S' then
    sqlManifestoBaixado.AsString := 'SIM'
  else
    sqlManifestoBaixado.AsString := 'NÃO';
end;

function TDMManifesto.ultimo_nsu(ID_Filial: Integer): Integer;
var
  i : Integer;
  xSql : String;
  FDconn : TDMConection;
begin
  FDconn := TDMConection.Create(nil);
  try
    xSql := 'select coalesce(max(NSU), 0) NSU from MANIFESTO_AN where FILIAL = ' + IntToStr(ID_Filial);
    i :=  FDconn.FDConnection.ExecSQLScalar(xSql);
    Result := i;
  finally
    FDconn.Free;
  end;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;
end.

unit uManifesto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.DBCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, SMDBGrid,
  Vcl.Buttons, uDMManifesto, pcnConversao, System.ImageList, Vcl.ImgList,
  Vcl.ExtDlgs, uManifestoEventos;
type
  TEnumOpcoes = (tpTodas, tpTodaSocultas, tpNaoManifestadas, tpNaoDownload);
  TEnumManifesto = (tpConfirmacao, tpCiencia, tpDesconhecimento, tpNaoRealizada);

type
  TfrmManifesto = class(TForm)
    pnlTop: TPanel;
    pnlPrincipal: TPanel;
    pnlBotton: TPanel;
    comboFilial: TDBLookupComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    pnlProgresso: TPanel;
    comboOpcoes: TComboBox;
    dataInicial: TDateTimePicker;
    GroupBox1: TGroupBox;
    edtNSUFinal: TEdit;
    edtNSUMaximo: TEdit;
    edtQtdeNota: TEdit;
    edtQtdeEventos: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ProgressBar1: TProgressBar;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edtCaminhoSalvar: TEdit;
    edtJustificativa: TEdit;
    comboEvento: TComboBox;
    btnManifesto: TBitBtn;
    btnDownload: TBitBtn;
    gridDados: TSMDBGrid;
    OpenTextFileDialog1: TOpenTextFileDialog;
    btnDiretorio: TBitBtn;
    ImageList1: TImageList;
    pnlRight: TPanel;
    edtNSU: TEdit;
    pnlNSU: TPanel;
    pnlMensagem: TPanel;
    btnConsultar: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDiretorioClick(Sender: TObject);
    procedure btnManifestoClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure gridDadosDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  fDMManifesto : TDMManifesto;
  procedure Le_Consulta;
    procedure BuscaNFe;
    procedure Inicializar_Variaveis(var iLote: Integer; var vTotal: Integer; var NumNotasNovas: Integer; var NumEveNovos: Integer);
    procedure DownloadNFe;
    procedure ManifestarNFe;
    procedure AtualizaMensangem(msg : string);
  public
    { Public declarations }
  end;

var
  frmManifesto: TfrmManifesto;

implementation

uses
  uUtilPadrao, FileCtrl;

{$R *.dfm}

procedure TfrmManifesto.btnConsultarClick(Sender: TObject);
begin
  BuscaNFe;
end;

procedure TfrmManifesto.btnDiretorioClick(Sender: TObject);
const
  SELDIRHELP = 1000;
var
  Dir : String;
begin
  Dir := edtCaminhoSalvar.Text;
  if FileCtrl.SelectDirectory(Dir,[sdAllowCreate, sdPerformCreate, sdPrompt], SELDIRHELP) then
    edtCaminhoSalvar.Text := Dir;

end;

procedure TfrmManifesto.btnDownloadClick(Sender: TObject);
begin
  with fDMManifesto do
  begin
    sqlManifesto.DisableControls;
    try
      sqlManifesto.First;
      while not sqlManifesto.eof do
      begin
        if gridDados.SelectedRows.CurrentRowSelected then
        begin
          DownloadNFe;
        end;
        sqlManifesto.Next
      end;
    finally
      sqlManifesto.EnableControls;
    end;
  end;
end;

procedure TfrmManifesto.btnManifestoClick(Sender: TObject);
begin
  ManifestarNFe;
end;

procedure TfrmManifesto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(fDMManifesto);
  Action := caFree;
end;

procedure TfrmManifesto.FormCreate(Sender: TObject);
begin
  fDMManifesto := TDMManifesto.Create(nil);
end;

procedure TfrmManifesto.FormShow(Sender: TObject);
begin
  fDMManifesto.sqlFilial.Close;
  fDMManifesto.sqlFilial.Open;
  if fDMManifesto.sqlFilial.RecordCount = 1 then
    comboFilial.KeyValue := fDMManifesto.sqlFilialID.AsInteger;
  edtCaminhoSalvar.Text    := SQLLocate('PARAMETROS','ID','ENDXML_NOTAENTRADA','1');
  fDMManifesto.sqlManifesto.Close;
  fDMManifesto.sqlManifesto.ParamByName('CHAVEACESSO').Value := '';
  fDMManifesto.sqlManifesto.Open;
end;

procedure TfrmManifesto.gridDadosDblClick(Sender: TObject);
var
  frmManifestoEvento : TfrmManifestoEventos;
begin
  frmManifestoEvento := TfrmManifestoEventos.Create(nil);
  frmManifestoEvento.fDMManifesto := fDMManifesto;
  with fDMManifesto do
  begin
    sqlManifesto_Eve.Close;
    sqlManifesto_Eve.ParamByName('CHAVEACESSO').AsString := sqlManifestoCHAVE_ACESSO.AsString;
    sqlManifesto_Eve.ParamByName('TIPOEVENTO').AsString := '';
    sqlManifesto_Eve.Open;
    if sqlManifesto_Eve.IsEmpty then
    begin
      ShowMessage('Nota não possui eventos');
      exit;
    end;
  end;
  frmManifestoEvento.ShowModal;
end;

procedure TfrmManifesto.Le_Consulta;
var
  xSql : string;
begin
  xSql := '';
  fDMManifesto.sqlConsulta.Close;
  fDMManifesto.sqlConsulta.SQL.Clear;
  fDMManifesto.sqlConsulta.SQL.Add(fDMManifesto.ctConsulta);
  case TEnumOpcoes(comboOpcoes.ItemIndex) of
    tpTodaSocultas :
      xSql := ' AND ((AN.GRAVADA_NOTA = ' + QuotedStr('N') + ') AND (AN.SITUACAO_NFE <> 3) AND (COALESCE(AN.OCULTAR,' + QuotedStr('') + ') <> ' + QuotedStr('S')+'))';
    tpNaoManifestadas :
      xSql := ' AND (AN.SITUACAO_MANIF = -1)';
    tpNaoDownload :
      xSql := ' AND (AN.DOWNLOAD = ' + QuotedStr('N') + ')';
  end;
  if dataInicial.Date > 10 then
    xSql := xSql + ' AND AN.DTEMISSAO2 >= ' + QuotedStr(FormatDateTime('MM/DD/YYYY',dataInicial.date));
  fDMManifesto.sqlConsulta.ParamByName('FILIAL').AsInteger := fDMManifesto.sqlFilialID.AsInteger;
  fDMManifesto.sqlConsulta.SQL.Add(xSql);
  fDMManifesto.sqlConsulta.Open;
  fDMManifesto.sqlConsulta.FetchAll;
  ProgressBar1.Max := fDMManifesto.sqlConsulta.RecordCount;

  fDMManifesto.sqlConsulta.First;
end;

procedure TfrmManifesto.BuscaNFe;
var
 CNPJ, Impresso, sChave, sEmissao, sCNPJ, sNome, sNumero, sSerie, sStat, sMotivo,
 sTemMais, sIEst, sNSU, sTipoNFe, MaxNSUAmbienteNacional, sTipo, sProt, sSituacao,
 sEvento, xEvento: String;
 Valor: Double;
 i, iLote, sSequenciaEvento : integer;
 vTotal, NSUMax, NSUFinal, NumNotasNovas, NumEveNovos : Integer;
 xDocumento, sOrgao : String;
begin
  if comboFilial.KeyValue = null then
  begin
    MessageDlg('Informe a Filial',mtInformation,[mbOK],0);
    comboFilial.SetFocus;
    exit;
  end;

  xDocumento := Monta_Numero(fDMManifesto.sqlFilialCNPJ_CPF.AsString,14);
  fDMManifesto.Inicia_NFe;
  Inicializar_Variaveis(iLote, vTotal, NumNotasNovas, NumEveNovos);
  fDMManifesto.sqlManifesto.DisableControls;
  try
    repeat
      inc(iLote);
      try
        AtualizaMensangem('Aguarde...Buscando Notas Sefaz');
        Sleep(2000);
        sNSU := IntToStr(fDMManifesto.ultimo_nsu(comboFilial.KeyValue));
        edtNSU.Text := sNSU;
        edtNSU.Update;
        fDMManifesto.ACBrNFe.DistribuicaoDFe(UFtoCUF(fDMManifesto.sqlFilialUF.AsString) , xDocumento, sNSU , '');
      except on e : exception do
        begin
          ShowMessage('Erro: ' + e.Message);
          ShowMessage('Consulta no Sefaz sem Resultado, tente novamente mais tarde! ');
          fDMManifesto.sqlManifesto.Close;
          fDMManifesto.sqlManifesto.ParamByName('CHAVEACESSO').AsString := '';
          fDMManifesto.sqlManifesto.Open;
          ProgressBar1.Position := 0;
          ProgressBar1.Update;
          Exit;
        end;
      end;
      sStat   := IntToStr(fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.cStat);
      sMotivo := fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.xMotivo;
      edtNSUFinal.Text := RemoverZeros(fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.ultNSU);
      edtNSUMaximo.Text := RemoverZeros(fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.maxNSU);
      NSUFinal := StrToIntDef(fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.ultNSU,0);
      NSUMax := StrToIntDef(fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.maxNSU,0);
      edtNSUFinal.Refresh;
      edtNSUMaximo.Refresh;
      if (ProgressBar1.Max = 0) and (NSUMax > 0) then
      begin
        if sNSU <> '0' then
          vTotal := NSUMax - StrToIntDef(sNSU,0)
        else
          vTotal := NSUMax - NSUFinal - 50;
        if vTotal < 0 then
          vTotal := 0;
        ProgressBar1.Max :=  vTotal;
      end;

      if fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.cStat = 138 then
        sTemMais := 'S'
      else
        sTemMais := 'N';
      if fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.cStat = 138 then
      begin
        edtQtdeNota.Text := fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count.ToString;
        edtQtdeNota.Update;
        NumNotasNovas := NumNotasNovas + fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count;
        edtQtdeNota.Text := NumNotasNovas.ToString;
        for i := 0 to fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count -1 do
        begin
          ProgressBar1.Position := ProgressBar1.Position + 1;
          ProgressBar1.Update;
          sSerie    := '';
          sNumero   := '';
          sCNPJ     := '';
          sNome     := '';
          sIEst     := '';
          sNSU      := '';
          sEmissao  := '';
          sTipoNFe  := '';
          Valor     := 0.0;
          Impresso  := '';
          sProt     := '';
          sSituacao := '';

          if fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.chDFe <> '' then
          begin
            // Conjunto de informações resumo da NF-e localizadas.
            // Este conjunto de informação será gerado quando a NF-e for autorizada ou denegada.
            sChave := fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.chDFe;
            sSerie  := Copy(sChave, 23, 3);
            sNumero := Copy(sChave, 26, 9);
            sCNPJ := fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.CNPJCPF;
            sNome := fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.xNome;
            sIEst := fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.IE;
            sProt := fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.nProt;
            AtualizaMensangem('Aguarde...Gravando Notas');

            case fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.tpNF of
              tnEntrada: sTipoNFe := 'E';
              tnSaida:   sTipoNFe := 'S';
            end;
            case fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].schema of
              schresNFe : sTipo := 'Resumo de Nota';
              schprocNFe: sTipo := 'Nota Completa';
              schresEvento: sTipo := 'Resumo do Evento';
              schprocEventoNFe: sTipo := 'Evento Completo';
            end;
            sNSU       := fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].NSU;
            edtNSU.Text := RemoverZeros(sNSU);
            edtNSU.Update;
            sEmissao   := DateToStr(fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.dhEmi);
            Valor      := fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.vNF;

            case fDMManifesto.ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resDFe.cSitDFe of
              snAutorizado: sSituacao := 'A';
              snDenegado:   sSituacao := 'D';
              snCancelado:  sSituacao := 'C';
            end;

  //        Registra no Banco de Dados as Notas Retornadas pela Consulta
            with fDMManifesto do
            begin
              sqlManifesto.Close;
              sqlManifesto.ParamByName('CHAVEACESSO').Value := sChave;
              sqlManifesto.Open;
              if sqlManifesto.IsEmpty then
                sqlManifesto.append
              else
                sqlManifesto.edit;
              sqlManifestoCHAVE_ACESSO.Value    := sChave;
              sqlManifestoSERIE.AsString        := sSerie;
              sqlManifestoNUM_NOTA.AsString     := sNumero;
              sqlManifestoDTEMISSAO2.Value      := StrToDate(sEmissao);
              sqlManifestoDTRECEBIMENTO.Value   := now;
              sqlManifestoCNPJ.Value            := sCNPJ;
              sqlManifestoINSC_ESTADUAL.Value   := sIEst;
              sqlManifestoNOME.Value            := UpperCase(sNome);
              sqlManifestoSITUACAO_NFE.Value    := sSituacao; {A=AUTORIZADO D=DENEGADO C=CANCELADO}
              sqlManifestoTIPO_EVE.Value        := sTipo; {schresNFe Resumo de Nota, schprocNFe Nota Completa, schresEvento Resumo de Evento e schprocEventoNFe Evento Completo}
              sqlManifestoVLR_NOTA.Value        := Valor;
              sqlManifestoNUM_PROTOCOLO.Value   := sProt;
              sqlManifestoNSU.AsString          := sNSU;
              sqlManifestoFILIAL.AsInteger      := sqlFilialID.AsInteger;
              sqlManifestoCNPJ_FILIAL.AsString  := sqlFilialCNPJ_CPF.AsString;
              sqlManifesto.Post;
            end;
          end;

          //Grava os eventos
          with fDMManifesto do
          begin
            if ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resEvento.chDFe <> EmptyStr then
            begin
              Inc(NumEveNovos);
              edtQtdeEventos.Text := NumEveNovos.ToString;
              edtQtdeEventos.Update;
              sEvento          := TpEventoToStr(ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resEvento.tpEvento);
              sChave           := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resEvento.chDFe;
              xEvento          := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resEvento.xEvento;
              sSequenciaEvento := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resEvento.nSeqEvento;
              sCNPJ            := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resEvento.CNPJCPF;
              sProt            := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resEvento.nProt;
              sOrgao           := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resEvento.cOrgao.ToString;
              sNSU             := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].NSU;
              sEmissao         := DateToStr(ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[i].resEvento.dhEvento);
              sqlManifesto_Eve.Close;
              sqlManifesto_Eve.ParamByName('CHAVEACESSO').Value := sChave;
              sqlManifesto_Eve.ParamByName('TIPOEVENTO').Value := sEvento;
              sqlManifesto_Eve.Open;
              if sqlManifesto_Eve.IsEmpty then
                sqlManifesto_Eve.append
              else
                sqlManifesto_Eve.edit;
              sqlManifesto_EveCHAVE_ACESSO.Value        := sChave;
              sqlManifesto_EveDTEVENTO.Value            := StrToDate(sEmissao);
              sqlManifesto_EveTIPO_EVENTO.Value         := sEvento; {schresNFe Resumo de Nota, schprocNFe Nota Completa, schresEvento Resumo de Evento e schprocEventoNFe Evento Completo}
              sqlManifesto_EveDESCRICAO_EVENTO.AsString := xEvento;
              sqlManifesto_EveNSU.AsString              := sNSU;
              sqlManifesto_EveSEQ_EVENTO.AsInteger      := sSequenciaEvento;
              sqlManifesto_EveORGAO.AsString            := sOrgao;
              sqlManifesto_EveFILIAL.AsInteger          := sqlFilialID.AsInteger;
              sqlManifesto_Eve.Post;

              //Grava ultimo nsu na tabela manifesto an
              sqlManifesto.Close;
              sqlManifesto.ParamByName('CHAVEACESSO').Value := sChave;
              sqlManifesto.Open;
              if not sqlManifesto.IsEmpty then
              begin
                sqlManifesto.edit;
                sqlManifestoNSU.AsString := sNSU;
                sqlManifesto.Post;
              end;
            end;
          end;
          Application.ProcessMessages;
        end; // Fim do For
      end;

    until sTemMais = 'N' ;
  finally
      fDMManifesto.sqlManifesto.EnableControls;
  end;
  fDMManifesto.sqlManifesto.Close;
  fDMManifesto.sqlManifesto.ParamByName('CHAVEACESSO').Value := '';
  fDMManifesto.sqlManifesto.Open;
  ProgressBar1.Position := 0;
  ProgressBar1.Update;
  ShowMessage('Processo Finalizado');
  AtualizaMensangem('Aguardando nova consulta');
end;

procedure TfrmManifesto.Inicializar_Variaveis(var iLote: Integer; var vTotal: Integer; var NumNotasNovas: Integer; var NumEveNovos: Integer);
begin
  iLote := 0;
  vTotal := 0;
  ProgressBar1.Max := 0;
  NumNotasNovas := 0;
  NumEveNovos := 0;
  edtQtdeEventos.Text := '0';
  edtQtdeNota.Text := '0';
end;

procedure TfrmManifesto.DownloadNFe;
var
  xDocumneto: string;
  xDados: TStringList;
begin
  with fDMManifesto do
  begin
    if sqlManifestoSITUACAO_MANIF.AsString = EmptyStr then
    begin
      if MessageDlg('Nota ainda não manifestada, deseja dar ciência da operação?', mtConfirmation,[mbYes,mbNo],0) = mrNo then
        Exit;
      AtualizaMensangem('Aguarde...Enviando dados');
      EnviarEvento(teManifDestCiencia);
      Sleep(3000);
    end;

    AtualizaMensangem('Aguarde...Efetuando download');
    Inicia_NFe;
    xDocumneto := Monta_Numero(sqlFilialCNPJ_CPF.AsString, 14);
    ACBrNFe.DistribuicaoDFePorChaveNFe(UFtoCUF(fDMManifesto.sqlFilialUF.AsString), xDocumneto, sqlManifestoCHAVE_ACESSO.Value);
    if ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count > 0 then
    begin
      xDados := TStringList.Create;
      try
        try
          xDados.Text := ACBrNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[0].XML;
          xDados.SaveToFile(edtCaminhoSalvar.Text + '\' + sqlManifestoCHAVE_ACESSO.Value + '.xml');
          AtualizaMensangem('Download do xml efetuado!');
          ShowMessage('Download do xml efetuado!');
          sqlManifesto.Edit;
          sqlManifestoDOWNLOAD.AsString := 'S';
          sqlManifesto.Post;
        except
          application.ProcessMessages;
        end;
      finally
        xDados.Free;
      end;
    end
    else
      AtualizaMensangem('Xml não encontrado, verifique mais tarde!');
  end;
end;

procedure TfrmManifesto.ManifestarNFe;
begin
  with fDMManifesto do
  begin
    case TEnumManifesto(comboEvento.ItemIndex) of
      tpConfirmacao:
        EnviarEvento(teManifDestConfirmacao);
      tpCiencia:
        EnviarEvento(teManifDestCiencia);
      tpDesconhecimento:
        EnviarEvento(teManifDestDesconhecimento);
      tpNaoRealizada:
        EnviarEvento(teManifDestOperNaoRealizada);
    end;
  end;
end;

procedure TfrmManifesto.AtualizaMensangem(msg : String);
begin
  pnlMensagem.Caption := msg;
  pnlMensagem.Update;
end;

end.

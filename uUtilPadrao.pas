unit uUtilPadrao;

interface

uses
 Classes,   FireDAC.Comp.Client, DmdConnection, Vcl.Printers, Datasnap.DBClient;

  function  SQLLocate(Tabela, CampoProcura, CampoRetorno, ValorFind: string): string ;
  function GetDefaultPrinterName: string;
  function Monta_Numero(Campo: String; Tamanho: Integer): String;
  function RemoverZeros(S: string): string;
  procedure CopiarDataSet(Origem, Destino : TClientDataSet);
  function ProximaSequencia(NomeTabela: string; Filial: Integer; SerieCupom: String): Integer;

var
 vCaminhoBanco: String;

implementation

uses
  System.SysUtils, Winapi.CommDlg;


function SQLLocate(Tabela, CampoProcura, CampoRetorno, ValorFind: string): string ;
var
  MyQuery: TFDQuery;
  FConn : TDMConection;
begin
  if ValorFind <> '' then
  begin
    FConn := TDMConection.Create(nil);
    MyQuery := TFDQuery.Create(DMConection);
    MyQuery.Connection := FConn.FDConnection;
    MyQuery.Close;
    MyQuery.SQL.Clear ;
    MyQuery.SQL.Add('select ' + CampoRetorno + ' from ' + Tabela) ;
    MyQuery.SQL.Add('where  ' + CampoProcura + ' = ' + QuotedStr(ValorFind));
    MyQuery.Open ;
    if not MyQuery.EOF then
      SQLLocate := MyQuery.FieldByName(CampoRetorno).AsString
    else
      SQLLocate := '' ;
    MyQuery.Free;
    FConn.Free;
  end
  else
    ValorFind := '' ;
end;

function GetDefaultPrinterName: string;
begin
  if (Printer.PrinterIndex >= 0) then
  begin
    Result := Printer.Printers[Printer.PrinterIndex];
  end
  else
  begin
    Result := 'Nenhuma impressora padrão foi detectada.';
  end;
end;

procedure CopiarDataSet(Origem, Destino : TClientDataSet);
begin
  Destino.Data := Origem.Data;
end;

function Monta_Numero(Campo: String; Tamanho: Integer): String;
var
  texto2: String;
  i: Integer;
begin
  texto2 := '';
  for i := 1 to Length(Campo) do
    if Campo[i] in ['0','1','2','3','4','5','6','7','8','9'] then
      Texto2 := Texto2 + Copy(Campo,i,1);
  for i := 1 to Tamanho - Length(texto2) do
    texto2 := '0' + texto2;
  Result := texto2;
end;

function RemoverZeros(S: string): string;
var
  I, J : Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do
  begin
    Dec(I);
  end;
  J := 1;
  while (J < I) and ((S[J] <= ' ') or (S[J] = '0')) do
  begin
    Inc(J);
  end;
  Result := Copy(S, J, (I-J)+1);
end;

function ProximaSequencia(NomeTabela: string; Filial: Integer;
  SerieCupom: String): Integer;
var
  xSql : String;
  Fconn : TDMConection;
begin
  Result := 0;
  Fconn := TDMConection.Create(nil);
  try
    xSql := 'EXECUTE PROCEDURE PRC_BUSCAR_SEQUENCIAL(' + QuotedStr(NomeTabela) + ', ' + IntToStr(Filial) + ', ' + QuotedStr(SerieCupom) + ')';
    Result := Fconn.FDConnection.ExecSQLScalar(xSql);
  finally
    Fconn.Free;
  end;
end;


end.

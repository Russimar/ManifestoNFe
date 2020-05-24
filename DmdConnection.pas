unit DmdConnection;

interface

uses
  System.SysUtils, System.Classes, IdCoderMIME, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, Data.SqlExpr;

type
  TDMConection = class(TDataModule)
    FDConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMConection: TDMConection;

implementation

uses
  System.IniFiles, Vcl.Forms, Vcl.Dialogs, uUtilPadrao;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDMConection.DataModuleCreate(Sender: TObject);
var
  ArquivoIni, BancoDados, DriverName, UserName, PassWord : String;
  LocalServer : Integer;
  Configuracoes : TIniFile;
  Decoder64: TIdDecoderMIME;
  Encoder64: TIdEncoderMIME;
begin
  Decoder64 := TIdDecoderMIME.Create(nil);
  ArquivoIni := ExtractFilePath(Application.ExeName) + '\Config.ini';
  if not FileExists(ArquivoIni) then
  begin
    MessageDlg('Arquivo config.ini não encontrado!', mtInformation,[mbOK],0);
    Exit;
  end;

  Configuracoes := TIniFile.Create(ArquivoINI);
  try
     BancoDados := Configuracoes.ReadString('SSFacil', 'DATABASE', DriverName);
     DriverName := Configuracoes.ReadString('SSFacil', 'DriverName', DriverName);
     UserName   := Configuracoes.ReadString('SSFacil', 'UserName',   UserName);
     PassWord   := Decoder64.DecodeString(Configuracoes.ReadString('SSFacil', 'PASSWORD', ''));
  finally
    Configuracoes.Free;
    Decoder64.Free;
  end;

  try
    FDConnection.Connected := False;
    FDConnection.Params.Clear;
    FDConnection.DriverName := 'FB';
    FDConnection.Params.Values['DriveId'] := 'FB';
    FDConnection.Params.Values['DataBase'] := BancoDados;
    FDConnection.Params.Values['User_Name'] := UserName;
    FDConnection.Params.Values['Password'] := PassWord;
    FDConnection.Connected := True;
    uUtilPadrao.vCaminhoBanco := BancoDados;
  except
    on E : Exception do
    begin
      raise Exception.Create('Erro ao conectar o Banco de dados ' + #13 +
                             'Mensagem: ' + e.Message + #13 +
                             'Classe: ' + e.ClassName + #13 +
                             'Banco de Dados: ' + BancoDados + #13 +
                             'Usuário: ' + UserName);
    end;
  end;
end;

end.

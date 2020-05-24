unit uManifestoEventos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  SMDBGrid, Vcl.ExtCtrls, uDMManifesto;

type
  TfrmManifestoEventos = class(TForm)
    Panel1: TPanel;
    SMDBGrid1: TSMDBGrid;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  fDMManifesto : TDMManifesto;
  end;

var
  frmManifestoEventos: TfrmManifestoEventos;

implementation

{$R *.dfm}

procedure TfrmManifestoEventos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.

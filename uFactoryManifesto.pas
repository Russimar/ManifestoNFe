unit uFactoryManifesto;

interface

uses DmdConnection, uManifesto;

type
 IManifesto = Interface(IInterface)
   ['{932DC18E-83E8-4FB2-8F22-EC35AE8F3FCE}']
   function AbreFormulario : IManifesto;
 end;

 TManifesto = class(TInterfacedObject, IManifesto)
   private
     FCon : TDMConection;
     FfrmManifesto : TfrmManifesto;
   public
     constructor create;
     destructor destroy; override;
     class function New : IManifesto;
     function AbreFormulario : IManifesto;
 end;

implementation

{ TManifesto }

function TManifesto.AbreFormulario: IManifesto;
begin
  FCon := TDMConection.Create(nil);
  try
    FfrmManifesto := TfrmManifesto.Create(nil);
    try
      FfrmManifesto.ShowModal;
    finally
      FfrmManifesto.Free;
    end;
  finally
    FCon.Free;
  end;
end;

constructor TManifesto.create;
begin

end;

destructor TManifesto.destroy;
begin
  inherited;
end;

class function TManifesto.New: IManifesto;
begin
  Result := Self.Create;
end;

end.

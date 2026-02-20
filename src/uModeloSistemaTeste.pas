unit uModeloSistemaTeste;

interface

uses
  mORMOt, SynCommons, uAtributos;


type
  TImposto = class(TSQLRecord)
  private
    fAliquotaModal: Currency;
    fNome: String;
  published
    property nome : String read fNome write fNome;
    property aliquotaModal : Currency read fAliquotaModal write fAliquotaModal;
  end;

  [TNomeAmigavel('Impostos federais')]
  TImpostoFederal = class(TImposto)
  public
    class procedure InitializeTable(Server: TSQLRestServer; const FieldName: RawUTF8; Options: TSQLInitializeTableOptions); override;
  published

  end;

  [TNomeAmigavel('Impostos estaduais')]
  TImpostoEstadual = class(TImposto)
  private
    fUf: String;
  published
    property uf : String read fUf write fUf;
  end;

  function PegarModeloTeste : TSQLModel; forward;


implementation

function PegarModeloTeste : TSQLModel;
begin
  result := TSQLModel.Create([TImpostoFederal, TImpostoEstadual], 'impostos');
end;


{ TImpostoFederal }

class procedure TImpostoFederal.InitializeTable(Server: TSQLRestServer;
  const FieldName: RawUTF8; Options: TSQLInitializeTableOptions);
begin
  inherited;
  if FieldName = '' then
  begin

    var i := TImpostoFederal.Create;
    try
      i.nome := 'PIS';
      i.aliquotaModal := 1.65;
      Server.Add(i, true);
      i.nome := 'Cofins';
      i.aliquotaModal := 7.6;
      Server.Add(i, true);
      i.nome := 'CBS';
      i.aliquotaModal := 0;
      Server.Add(i, true);
      i.nome := 'IBS';
      i.aliquotaModal := 0;
      Server.Add(i, true);
    finally
      i.Free;
    end;


  end;
end;

end.

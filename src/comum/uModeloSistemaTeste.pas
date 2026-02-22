unit uModeloSistemaTeste;

interface

uses
  mORMOt, SynCommons, uAtributos, SysUtils;

type
  TImposto = class(TSQLRecord)
  private
    FAliquotaModal: Currency;
    FNome: String;
  published
    property nome : String read FNome write FNome;
    property aliquotaModal : Currency read FAliquotaModal write FAliquotaModal;
  end;

  [TNomeAmigavel('Impostos federais')]
  TImpostoFederal = class(TImposto)
  private
    FDataFim: TDateTime;
    FDataInicio: TDateTime;
  public
    class procedure InitializeTable(Server: TSQLRestServer; const FieldName: RawUTF8; Options: TSQLInitializeTableOptions); override;
  published
    property dataInicio: TDateTime read FDataInicio write FDataInicio;
    property dataFim: TDateTime read FDataFim write FDataFim;
  end;

  [TNomeAmigavel('Impostos estaduais')]
  TImpostoEstadual = class(TImposto)
  private
    FUf: String;
  published
    property uf : String read FUf write FUf;
  end;

  [TNomeAmigavel('CFOP')]
  TCFOP = class(TSQLRecord)
  private
    FCfop: String;
    FDescricao: String;
  published
    property cfop: String read FCfop write FCfop;
    property descricao: String read FDescricao write FDescricao;
  end;

  [TNomeAmigavel('NCM')]
  TNCM = class(TSQLRecord)
  private
    FCodigo: String;
    FDataFim: TDateTime;
    FDataInicio: TDateTime;
    FDescricao: String;
  published
    property codigo: String read FCodigo write FCodigo;
    property descricao: String read FDescricao write FDescricao;
    property dataInicio: TDateTime read FDataInicio write FDataInicio;
    property dataFim: TDateTime read FDataFim write FDataFim;
  end;

  TVersao = class(TSQLRecord)
  private
    FData: TDateTime;
    FNumero: Integer;
  public
    class procedure InitializeTable(Server: TSQLRestServer; const FieldName: RawUTF8; Options: TSQLInitializeTableOptions); override;
  published
    property numero: Integer read FNumero write FNumero;
    property data: TDateTime read FData write FData;
  end;
  function PegarModeloTeste : TSQLModel;
  function PegarModeloAuxiliar : TSQLModel;

implementation

function PegarModeloTeste : TSQLModel;
begin
  Result := TSQLModel.Create([TImpostoFederal, TImpostoEstadual, TCFOP, TNCM], 'impostos');
end;

function PegarModeloAuxiliar: TSQLModel;
begin
  Result := TSQLModel.Create([TVersao], 'dados_auxiliares');
end;

class procedure TImpostoFederal.InitializeTable(Server: TSQLRestServer;
  const FieldName: RawUTF8; Options: TSQLInitializeTableOptions);
begin
  inherited;
  if FieldName = '' then
  begin
    var lImpostoFederal := TImpostoFederal.Create;
    try
      lImpostoFederal.nome := 'PIS';
      lImpostoFederal.aliquotaModal := 1.65;
      lImpostoFederal.dataInicio := 0;
      lImpostoFederal.dataFim := 0;
      Server.Add(lImpostoFederal, true);

      lImpostoFederal.nome := 'Cofins';
      lImpostoFederal.aliquotaModal := 7.6;
      lImpostoFederal.dataInicio := 0;
      lImpostoFederal.dataFim := 0;
      Server.Add(lImpostoFederal, true);

      lImpostoFederal.nome := 'CBS';
      lImpostoFederal.aliquotaModal := 0;
      lImpostoFederal.dataInicio := 0;
      lImpostoFederal.dataFim := 0;
      Server.Add(lImpostoFederal, true);

      lImpostoFederal.nome := 'IBS';
      lImpostoFederal.aliquotaModal := 0;
      lImpostoFederal.dataInicio := 0;
      lImpostoFederal.dataFim := 0;
      Server.Add(lImpostoFederal, true);
    finally
      lImpostoFederal.Free;
    end;


  end;
end;
class procedure TVersao.InitializeTable(Server: TSQLRestServer;
  const FieldName: RawUTF8; Options: TSQLInitializeTableOptions);
begin
  inherited;
  if FieldName = '' then
  begin
    var lVersao := TVersao.Create;
    try
      lVersao.numero := 1;
      lVersao.data := Date;
      Server.Add(lVersao, true);
    finally
      lVersao.Free;
    end;
  end;
end;
end.


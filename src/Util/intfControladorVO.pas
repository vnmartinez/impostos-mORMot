unit intfControladorVO;

interface

uses
  SynCommons, mORMOt, uEventos;

type
  IControlador = interface
    ['{C320A0F7-A51B-41E9-8D66-95CF69C35830}']
    procedure CarregarDados;
    procedure AtualizarDados;

    function GetOnDoubleClickNaLinha : TOnDoubleClickNaLinha;
    property OnDoubleClickNaLinha : TOnDoubleClickNaLinha read GetOnDoubleClickNaLinha;

    function GetOnClicouBotaoAcaoNoGrid : TOnClicouBotaoAcaoNoGrid;
    property OnClicouBotaoAcaoNoGrid : TOnClicouBotaoAcaoNoGrid read GetOnClicouBotaoAcaoNoGrid;

    function GetOnSelecionouLinha : TOnSelecionouLinha;
    property OnSelecionouLinha : TOnSelecionouLinha read GetOnSelecionouLinha;

    function GetDescricaoControlador : String;
    property descricaoControlador : String read GetDescricaoControlador;
  end;

  IControladorComData = interface(IControlador)
    ['{74D6EC83-F3B4-4726-82E7-58D9746CE219}']

    procedure SetDataIni(const data : TDateTime);
    procedure SetDataFim(const data : TDateTime);

    function GetDataIni : TDateTime;
    function GetDataFim : TDateTime;

    property dataIni : TDateTime read GetDataIni write SetDataIni;
    property dataFim : TDateTime read GetDataFim write SetDataFim;
  end;

  IPossuiIdentificadorDeLinha = interface
  ['{920108B9-E748-4C63-9E6E-4C1F5160FEDC}']
    function PegarIdentificadorDaLinha(aLinha : Integer) : Integer;
  end;

  TControladorVO = class(TInterfacedObject, IControlador)
  private
    function GetOnDoubleClickNaLinha: TOnDoubleClickNaLinha;
    function GetOnClicouBotaoAcaoNoGrid: TOnClicouBotaoAcaoNoGrid;
    function GetOnSelecionouLinha : TOnSelecionouLinha;

  protected
    procedure DoubleClickNaLinha(linha, coluna : Integer); virtual;
    procedure SelecionouLinhaNoGrid(linha : Integer); virtual;
    function ClicouBotaoAcaoNoGrid(linha, coluna: Integer) : Boolean; virtual;

    function GetDescricaoControlador : String; virtual;
  public
    procedure AtualizarDados; virtual;
    procedure CarregarDados; virtual; abstract;

    property OnDoubleClickNaLinha : TOnDoubleClickNaLinha read GetOnDoubleClickNaLinha;
    property OnSelecionouLinha : TOnSelecionouLinha read GetOnSelecionouLinha;

    property OnClicouBotaoAcaoNoGrid : TOnClicouBotaoAcaoNoGrid read GetOnClicouBotaoAcaoNoGrid;
    property descricaoControlador : String read GetDescricaoControlador;
  end;

  TControladorVOComData = class(TControladorVO, IControladorComData)
  private
    procedure SetDataFim(const Value: TDateTime);
    procedure SetDataIni(const Value: TDateTime);

    function GetDataIni : TDateTime;
    function GetDataFim : TDateTime;
  protected
    fDataIni : TDateTime;
    fDataFim : TDateTime;
  public
    property dataIni : TDateTime read GetDataIni write SetDataIni;
    property dataFim : TDateTime read GetDataFim write SetDataFim;
  end;

implementation


{ TControladorVO }

function TControladorVO.ClicouBotaoAcaoNoGrid(linha, coluna: Integer) : Boolean;
begin
  result := false;
end;

procedure TControladorVO.DoubleClickNaLinha(linha, coluna: Integer);
begin
  //
end;

function TControladorVO.GetDescricaoControlador: String;
begin
  result := '';
end;

function TControladorVO.GetOnClicouBotaoAcaoNoGrid: TOnClicouBotaoAcaoNoGrid;
begin
  result := ClicouBotaoAcaoNoGrid;
end;

function TControladorVO.GetOnDoubleClickNaLinha: TOnDoubleClickNaLinha;
begin
  result := DoubleClickNaLinha;
end;

function TControladorVO.GetOnSelecionouLinha: TOnSelecionouLinha;
begin
  result := SelecionouLinhaNoGrid
end;

procedure TControladorVO.SelecionouLinhaNoGrid(linha: Integer);
begin
  //
end;

procedure TControladorVO.AtualizarDados;
begin
  CarregarDados;
end;

{ TControladorVOComData }

function TControladorVOComData.GetDataFim: TDateTime;
begin
  result := fDataFim;
end;

function TControladorVOComData.GetDataIni: TDateTime;
begin
  result := fDataIni;
end;

procedure TControladorVOComData.SetDataFim(const Value: TDateTime);
begin
  fDataFim := Value;
end;

procedure TControladorVOComData.SetDataIni(const Value: TDateTime);
begin
  fDataIni := Value;
end;

end.

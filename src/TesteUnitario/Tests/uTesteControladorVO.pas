unit uTesteControladorVO;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  intfControladorVO;

type
  TControladorStub = class(TControladorVOComData)
  public
    CarregarDadosChamadas: Integer;
    UltimaLinhaDoubleClick: Integer;
    UltimaColunaDoubleClick: Integer;
    UltimaLinhaSelecionada: Integer;
    UltimaLinhaAcao: Integer;
    UltimaColunaAcao: Integer;
    ResultadoAcao: Boolean;
    procedure CarregarDados; override;
  protected
    procedure DoubleClickNaLinha(linha, coluna: Integer); override;
    procedure SelecionouLinhaNoGrid(linha: Integer); override;
    function ClicouBotaoAcaoNoGrid(linha, coluna: Integer): Boolean; override;
    function GetDescricaoControlador: String; override;
  end;

  [TestFixture]
  TTestesControladorVO = class
  private
    FSut: TControladorStub;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure AtualizarDados_DeveDelegarParaCarregarDados;
    [Test]
    procedure OnDoubleClickNaLinha_DeveInvocarMetodoProtegido;
    [Test]
    procedure OnSelecionouLinha_DeveInvocarMetodoProtegido;
    [Test]
    procedure OnClicouBotaoAcaoNoGrid_DeveRetornarValorDoMetodo;
    [Test]
    procedure PropriedadesDeData_DevemPersistirValores;
    [Test]
    procedure DescricaoControlador_DeveVirDoOverride;
  end;

implementation


function TControladorStub.ClicouBotaoAcaoNoGrid(linha, coluna: Integer): Boolean;
begin
  UltimaLinhaAcao := linha;
  UltimaColunaAcao := coluna;
  Result := ResultadoAcao;
end;

procedure TControladorStub.CarregarDados;
begin
  Inc(CarregarDadosChamadas);
end;

procedure TControladorStub.DoubleClickNaLinha(linha, coluna: Integer);
begin
  UltimaLinhaDoubleClick := linha;
  UltimaColunaDoubleClick := coluna;
end;

function TControladorStub.GetDescricaoControlador: String;
begin
  Result := 'ControladorStub';
end;

procedure TControladorStub.SelecionouLinhaNoGrid(linha: Integer);
begin
  UltimaLinhaSelecionada := linha;
end;


procedure TTestesControladorVO.AtualizarDados_DeveDelegarParaCarregarDados;
begin
  FSut.AtualizarDados;
  Assert.AreEqual(1, FSut.CarregarDadosChamadas);
end;

procedure TTestesControladorVO.DescricaoControlador_DeveVirDoOverride;
begin
  Assert.AreEqual('ControladorStub', FSut.descricaoControlador);
end;

procedure TTestesControladorVO.OnClicouBotaoAcaoNoGrid_DeveRetornarValorDoMetodo;
begin
  FSut.ResultadoAcao := True;
  var LResultado := FSut.OnClicouBotaoAcaoNoGrid(8, 6);
  Assert.IsTrue(LResultado);
  Assert.AreEqual(8, FSut.UltimaLinhaAcao);
  Assert.AreEqual(6, FSut.UltimaColunaAcao);
end;

procedure TTestesControladorVO.OnDoubleClickNaLinha_DeveInvocarMetodoProtegido;
begin
  FSut.OnDoubleClickNaLinha(2, 4);
  Assert.AreEqual(2, FSut.UltimaLinhaDoubleClick);
  Assert.AreEqual(4, FSut.UltimaColunaDoubleClick);
end;

procedure TTestesControladorVO.OnSelecionouLinha_DeveInvocarMetodoProtegido;
begin
  FSut.OnSelecionouLinha(11);
  Assert.AreEqual(11, FSut.UltimaLinhaSelecionada);
end;

procedure TTestesControladorVO.PropriedadesDeData_DevemPersistirValores;
begin
  var LDataIni := EncodeDate(2026, 1, 1);
  var LDataFim := EncodeDate(2026, 12, 31);

  FSut.dataIni := LDataIni;
  FSut.dataFim := LDataFim;

  Assert.AreEqual<TDateTime>(LDataIni, FSut.dataIni);
  Assert.AreEqual<TDateTime>(LDataFim, FSut.dataFim);
end;

procedure TTestesControladorVO.Setup;
begin
  FSut := TControladorStub.Create;
end;

procedure TTestesControladorVO.TearDown;
begin
  FSut.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestesControladorVO);

end.


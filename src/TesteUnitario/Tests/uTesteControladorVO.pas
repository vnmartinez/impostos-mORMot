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
    procedure AtualizarDadosDeveDelegarParaCarregarDados;
    [Test]
    procedure OnDoubleClickNaLinhaDeveRegistrarLinha;
    [Test]
    procedure OnDoubleClickNaLinhaDeveRegistrarColuna;
    [Test]
    procedure OnSelecionouLinhaDeveRegistrarLinha;
    [Test]
    procedure OnClicouBotaoAcaoNoGridDeveRetornarTrueQuandoConfigurado;
    [Test]
    procedure OnClicouBotaoAcaoNoGridDeveRetornarFalseQuandoConfigurado;
    [Test]
    procedure OnClicouBotaoAcaoNoGridDeveRegistrarLinha;
    [Test]
    procedure OnClicouBotaoAcaoNoGridDeveRegistrarColuna;
    [Test]
    procedure PropriedadeDataIniDevePersistirValor;
    [Test]
    procedure PropriedadeDataFimDevePersistirValor;
    [Test]
    procedure DescricaoControladorDeveVirDoOverride;
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


procedure TTestesControladorVO.AtualizarDadosDeveDelegarParaCarregarDados;
begin
  FSut.AtualizarDados;
  Assert.AreEqual(1, FSut.CarregarDadosChamadas);
end;

procedure TTestesControladorVO.DescricaoControladorDeveVirDoOverride;
begin
  Assert.AreEqual('ControladorStub', FSut.descricaoControlador);
end;

procedure TTestesControladorVO.OnClicouBotaoAcaoNoGridDeveRegistrarColuna;
begin
  FSut.ResultadoAcao := True;
  FSut.OnClicouBotaoAcaoNoGrid(8, 6);
  Assert.AreEqual(6, FSut.UltimaColunaAcao);
end;

procedure TTestesControladorVO.OnClicouBotaoAcaoNoGridDeveRegistrarLinha;
begin
  FSut.ResultadoAcao := True;
  FSut.OnClicouBotaoAcaoNoGrid(8, 6);
  Assert.AreEqual(8, FSut.UltimaLinhaAcao);
end;

procedure TTestesControladorVO.OnClicouBotaoAcaoNoGridDeveRetornarFalseQuandoConfigurado;
begin
  FSut.ResultadoAcao := False;
  var LResultado := FSut.OnClicouBotaoAcaoNoGrid(8, 6);
  Assert.IsFalse(LResultado);
end;

procedure TTestesControladorVO.OnClicouBotaoAcaoNoGridDeveRetornarTrueQuandoConfigurado;
begin
  FSut.ResultadoAcao := True;
  var LResultado := FSut.OnClicouBotaoAcaoNoGrid(8, 6);
  Assert.IsTrue(LResultado);
end;

procedure TTestesControladorVO.OnDoubleClickNaLinhaDeveRegistrarColuna;
begin
  FSut.OnDoubleClickNaLinha(2, 4);
  Assert.AreEqual(4, FSut.UltimaColunaDoubleClick);
end;

procedure TTestesControladorVO.OnDoubleClickNaLinhaDeveRegistrarLinha;
begin
  FSut.OnDoubleClickNaLinha(2, 4);
  Assert.AreEqual(2, FSut.UltimaLinhaDoubleClick);
end;

procedure TTestesControladorVO.OnSelecionouLinhaDeveRegistrarLinha;
begin
  FSut.OnSelecionouLinha(11);
  Assert.AreEqual(11, FSut.UltimaLinhaSelecionada);
end;

procedure TTestesControladorVO.PropriedadeDataFimDevePersistirValor;
begin
  var LDataFim := EncodeDate(2026, 12, 31);
  FSut.dataFim := LDataFim;
  Assert.AreEqual<TDateTime>(LDataFim, FSut.dataFim);
end;

procedure TTestesControladorVO.PropriedadeDataIniDevePersistirValor;
begin
  var LDataIni := EncodeDate(2026, 1, 1);
  FSut.dataIni := LDataIni;
  Assert.AreEqual<TDateTime>(LDataIni, FSut.dataIni);
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


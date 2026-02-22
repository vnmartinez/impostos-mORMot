unit uTesteModeloSistema;

interface

uses
  DUnitX.TestFramework,
  mORMOt,
  uModeloSistemaTeste,
  uAtributos;

type
  [TestFixture]
  TTestesModeloSistema = class
  public
    [Test]
    procedure PegarModeloTesteDeveConterQuatroTabelas;
    [Test]
    procedure PegarModeloAuxiliarDeveConterUmaTabela;
    [Test]
    procedure PegarModeloAuxiliarTabelaZeroDeveSerVersao;
    [Test]
    procedure PegarModeloTesteTabelaZeroDeveSerImpostoFederal;
    [Test]
    procedure PegarModeloTesteTabelaUmDeveSerImpostoEstadual;
    [Test]
    procedure PegarModeloTesteTabelaDoisDeveSerCfop;
    [Test]
    procedure PegarModeloTesteTabelaTresDeveSerNcm;
    [Test]
    procedure NomeAmigavelImpostoFederalDeveSerImpostosFederais;
    [Test]
    procedure NomeAmigavelImpostoEstadualDeveSerImpostosEstaduais;
    [Test]
    procedure NomeAmigavelCfopDeveSerCfop;
    [Test]
    procedure NomeAmigavelNcmDeveSerNcm;
  end;

implementation

function ClasseTabelaOuNil(AModelo: TSQLModel; AIndex: Integer): TSQLRecordClass;
begin
  Result := nil;
  if (AModelo = nil) or (AIndex < 0) or (AIndex >= Length(AModelo.Tables)) then
  begin
    Exit;
  end;
  Result := AModelo.Tables[AIndex];
end;

function NomeAmigavelOuVazio(AClasse: TClass): string;
begin
  Result := '';
  var LAttr := TPegarAtributo.PegarDaClasse<TNomeAmigavel>(AClasse);
  if LAttr <> nil then
  begin
    Result := LAttr.nome;
  end;
end;

procedure TTestesModeloSistema.NomeAmigavelCfopDeveSerCfop;
begin
  Assert.AreEqual('CFOP', NomeAmigavelOuVazio(TCFOP));
end;

procedure TTestesModeloSistema.NomeAmigavelImpostoEstadualDeveSerImpostosEstaduais;
begin
  Assert.AreEqual('Impostos estaduais', NomeAmigavelOuVazio(TImpostoEstadual));
end;

procedure TTestesModeloSistema.NomeAmigavelImpostoFederalDeveSerImpostosFederais;
begin
  Assert.AreEqual('Impostos federais', NomeAmigavelOuVazio(TImpostoFederal));
end;

procedure TTestesModeloSistema.NomeAmigavelNcmDeveSerNcm;
begin
  Assert.AreEqual('NCM', NomeAmigavelOuVazio(TNCM));
end;

procedure TTestesModeloSistema.PegarModeloAuxiliarDeveConterUmaTabela;
begin
  var LModelo := PegarModeloAuxiliar;
  try
    Assert.AreEqual<NativeInt>(1, Length(LModelo.Tables));
  finally
    LModelo.Free;
  end;
end;

procedure TTestesModeloSistema.PegarModeloAuxiliarTabelaZeroDeveSerVersao;
begin
  var LModelo := PegarModeloAuxiliar;
  try
    Assert.IsTrue(ClasseTabelaOuNil(LModelo, 0) = TVersao);
  finally
    LModelo.Free;
  end;
end;

procedure TTestesModeloSistema.PegarModeloTesteDeveConterQuatroTabelas;
begin
  var LModelo := PegarModeloTeste;
  try
    Assert.AreEqual<NativeInt>(4, Length(LModelo.Tables));
  finally
    LModelo.Free;
  end;
end;

procedure TTestesModeloSistema.PegarModeloTesteTabelaDoisDeveSerCfop;
begin
  var LModelo := PegarModeloTeste;
  try
    Assert.IsTrue(ClasseTabelaOuNil(LModelo, 2) = TCFOP);
  finally
    LModelo.Free;
  end;
end;

procedure TTestesModeloSistema.PegarModeloTesteTabelaTresDeveSerNcm;
begin
  var LModelo := PegarModeloTeste;
  try
    Assert.IsTrue(ClasseTabelaOuNil(LModelo, 3) = TNCM);
  finally
    LModelo.Free;
  end;
end;

procedure TTestesModeloSistema.PegarModeloTesteTabelaUmDeveSerImpostoEstadual;
begin
  var LModelo := PegarModeloTeste;
  try
    Assert.IsTrue(ClasseTabelaOuNil(LModelo, 1) = TImpostoEstadual);
  finally
    LModelo.Free;
  end;
end;

procedure TTestesModeloSistema.PegarModeloTesteTabelaZeroDeveSerImpostoFederal;
begin
  var LModelo := PegarModeloTeste;
  try
    Assert.IsTrue(ClasseTabelaOuNil(LModelo, 0) = TImpostoFederal);
  finally
    LModelo.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestesModeloSistema);

end.

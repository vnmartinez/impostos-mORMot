unit uTesteModeloSistema;

interface

uses
  DUnitX.TestFramework,
  uModeloSistemaTeste,
  uAtributos;

type
  [TestFixture]
  TTestesModeloSistema = class
  public
    [Test]
    procedure PegarModeloTeste_DeveConterTabelasEsperadas;
    [Test]
    procedure PegarModeloAuxiliar_DeveConterSomenteVersao;
    [Test]
    procedure TabelasComNomeAmigavel_DevemTerAtributo;
  end;

implementation

procedure TTestesModeloSistema.PegarModeloAuxiliar_DeveConterSomenteVersao;
begin
  var LModelo := PegarModeloAuxiliar;
  try
    Assert.AreEqual(1, Length(LModelo.Tables));
    Assert.IsTrue(LModelo.Tables[0] = TVersao);
  finally
    LModelo.Free;
  end;
end;

procedure TTestesModeloSistema.PegarModeloTeste_DeveConterTabelasEsperadas;
begin
  var LModelo := PegarModeloTeste;
  try
    Assert.AreEqual(4, Length(LModelo.Tables));
    Assert.IsTrue(LModelo.Tables[0] = TImpostoFederal);
    Assert.IsTrue(LModelo.Tables[1] = TImpostoEstadual);
    Assert.IsTrue(LModelo.Tables[2] = TCFOP);
    Assert.IsTrue(LModelo.Tables[3] = TNCM);
  finally
    LModelo.Free;
  end;
end;

procedure TTestesModeloSistema.TabelasComNomeAmigavel_DevemTerAtributo;
begin
  var LFederal := TPegarAtributo.PegarDaClasse<TNomeAmigavel>(TImpostoFederal);
  Assert.IsNotNull(LFederal);
  Assert.AreEqual('Impostos federais', LFederal.nome);

  var LEstadual := TPegarAtributo.PegarDaClasse<TNomeAmigavel>(TImpostoEstadual);
  Assert.IsNotNull(LEstadual);
  Assert.AreEqual('Impostos estaduais', LEstadual.nome);

  var LCfop := TPegarAtributo.PegarDaClasse<TNomeAmigavel>(TCFOP);
  Assert.IsNotNull(LCfop);
  Assert.AreEqual('CFOP', LCfop.nome);

  var LNcm := TPegarAtributo.PegarDaClasse<TNomeAmigavel>(TNCM);
  Assert.IsNotNull(LNcm);
  Assert.AreEqual('NCM', LNcm.nome);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestesModeloSistema);

end.

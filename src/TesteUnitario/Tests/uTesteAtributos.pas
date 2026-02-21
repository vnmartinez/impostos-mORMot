unit uTesteAtributos;

interface

uses
  DUnitX.TestFramework,
  System.Rtti,
  System.Generics.Collections,
  uAtributos;

type
  TTesteTag = class(TCustomAttribute)
  private
    FValor: string;
  public
    constructor Create(const AValor: string);
    property Valor: string read FValor;
  end;

  [TNomeAmigavel('ClasseTeste')]
  [TTesteTag('ClasseTag')]
  TClasseComAtributos = class
  private
    FCodigo: string;
  published
    [TNomeAmigavel('CodigoAmigavel')]
    [TTesteTag('PropTag')]
    property Codigo: string read FCodigo write FCodigo;
  end;

  [TestFixture]
  TTestesAtributos = class
  public
    [Test]
    procedure PegarDaClasse_DeveRetornarNomeAmigavel;
    [Test]
    procedure PegarListaDaClasse_DeveRetornarAtributosDoTipo;
    [Test]
    procedure PegarDaProp_DeveRetornarAtributoDaPropriedade;
    [Test]
    procedure PegarDaProp_ComNil_DeveRetornarNil;
    [Test]
    procedure PegarListaDaProp_ComNil_DeveRetornarListaVazia;
  end;

implementation


constructor TTesteTag.Create(const AValor: string);
begin
  inherited Create;
  FValor := AValor;
end;


procedure TTestesAtributos.PegarDaClasse_DeveRetornarNomeAmigavel;
begin
  var LAttr := TPegarAtributo.PegarDaClasse<TNomeAmigavel>(TClasseComAtributos);
  Assert.IsNotNull(LAttr);
  Assert.AreEqual('ClasseTeste', LAttr.nome);
end;

procedure TTestesAtributos.PegarDaProp_ComNil_DeveRetornarNil;
begin
  var LAttr := TPegarAtributo.PegarDaProp<TNomeAmigavel>(nil);
  Assert.IsNull(LAttr);
end;

procedure TTestesAtributos.PegarDaProp_DeveRetornarAtributoDaPropriedade;
begin
  var LCtx := TRttiContext.Create;
  try
    var LProp := LCtx.GetType(TClasseComAtributos).GetProperty('Codigo');
    Assert.IsNotNull(LProp);

    var LAttr := TPegarAtributo.PegarDaProp<TNomeAmigavel>(LProp);
    Assert.IsNotNull(LAttr);
    Assert.AreEqual('CodigoAmigavel', LAttr.nome);
  finally
    LCtx.Free;
  end;
end;

procedure TTestesAtributos.PegarListaDaClasse_DeveRetornarAtributosDoTipo;
begin
  var LLista := TPegarAtributo.PegarListaDaClasse<TTesteTag>(TClasseComAtributos);
  try
    Assert.AreEqual(1, LLista.Count);
    Assert.AreEqual('ClasseTag', LLista[0].Valor);
  finally
    LLista.Free;
  end;
end;

procedure TTestesAtributos.PegarListaDaProp_ComNil_DeveRetornarListaVazia;
begin
  var LLista := TPegarAtributo.PegarListaDaProp<TNomeAmigavel>(nil);
  try
    Assert.AreEqual(0, LLista.Count);
  finally
    LLista.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestesAtributos);

end.


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
    procedure PegarDaClasseDeveRetornarAtributo;
    [Test]
    procedure PegarDaClasseDeveRetornarNomeAmigavel;
    [Test]
    procedure PegarListaDaClasseDeveConterUmItem;
    [Test]
    procedure PegarListaDaClasseDeveRetornarValorCorreto;
    [Test]
    procedure PegarDaPropDeveEncontrarPropriedadeCodigo;
    [Test]
    procedure PegarDaPropDeveRetornarAtributoDaPropriedade;
    [Test]
    procedure PegarDaPropDeveRetornarNomeDaPropriedade;
    [Test]
    procedure PegarDaPropComNilDeveRetornarNil;
    [Test]
    procedure PegarListaDaPropComNilDeveRetornarListaVazia;
  end;

implementation

function ObterPropriedadeCodigo(var ACtx: TRttiContext): TRttiProperty;
begin
  Result := ACtx.GetType(TClasseComAtributos).GetProperty('Codigo');
end;

function ObterNomeAmigavelDaClasse: TNomeAmigavel;
begin
  Result := TPegarAtributo.PegarDaClasse<TNomeAmigavel>(TClasseComAtributos);
end;

function ObterNomeAmigavelDaPropCodigo: TNomeAmigavel;
var
  LCtx: TRttiContext;
  LProp: TRttiProperty;
begin
  LCtx := TRttiContext.Create;
  try
    LProp := ObterPropriedadeCodigo(LCtx);
    Result := TPegarAtributo.PegarDaProp<TNomeAmigavel>(LProp);
  finally
    LCtx.Free;
  end;
end;


constructor TTesteTag.Create(const AValor: string);
begin
  inherited Create;
  FValor := AValor;
end;


procedure TTestesAtributos.PegarDaClasseDeveRetornarAtributo;
begin
  var LAttr := ObterNomeAmigavelDaClasse;
  Assert.IsNotNull(LAttr);
end;

procedure TTestesAtributos.PegarDaClasseDeveRetornarNomeAmigavel;
begin
  var LAttr := ObterNomeAmigavelDaClasse;
  var LNome := '';
  if LAttr <> nil then
  begin
    LNome := LAttr.nome;
  end;
  Assert.AreEqual('ClasseTeste', LNome);
end;

procedure TTestesAtributos.PegarDaPropComNilDeveRetornarNil;
begin
  var LAttr := TPegarAtributo.PegarDaProp<TNomeAmigavel>(nil);
  Assert.IsNull(LAttr);
end;

procedure TTestesAtributos.PegarDaPropDeveEncontrarPropriedadeCodigo;
begin
  var LCtx := TRttiContext.Create;
  try
    var LProp := ObterPropriedadeCodigo(LCtx);
    Assert.IsNotNull(LProp);
  finally
    LCtx.Free;
  end;
end;

procedure TTestesAtributos.PegarDaPropDeveRetornarAtributoDaPropriedade;
begin
  var LAttr := ObterNomeAmigavelDaPropCodigo;
  Assert.IsNotNull(LAttr);
end;

procedure TTestesAtributos.PegarDaPropDeveRetornarNomeDaPropriedade;
begin
  var LAttr := ObterNomeAmigavelDaPropCodigo;
  var LNome := '';
  if LAttr <> nil then
  begin
    LNome := LAttr.nome;
  end;
  Assert.AreEqual('CodigoAmigavel', LNome);
end;

procedure TTestesAtributos.PegarListaDaClasseDeveConterUmItem;
begin
  var LLista := TPegarAtributo.PegarListaDaClasse<TTesteTag>(TClasseComAtributos);
  try
    Assert.AreEqual(1, LLista.Count);
  finally
    LLista.Free;
  end;
end;

procedure TTestesAtributos.PegarListaDaClasseDeveRetornarValorCorreto;
begin
  var LLista := TPegarAtributo.PegarListaDaClasse<TTesteTag>(TClasseComAtributos);
  try
    var LValor := '';
    if LLista.Count > 0 then
    begin
      LValor := LLista[0].Valor;
    end;
    Assert.AreEqual('ClasseTag', LValor);
  finally
    LLista.Free;
  end;
end;

procedure TTestesAtributos.PegarListaDaPropComNilDeveRetornarListaVazia;
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


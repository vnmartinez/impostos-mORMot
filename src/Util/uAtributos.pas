unit uAtributos;

interface

uses
  System.RTTI, cxEdit, SynCommons, Generics.Collections, mORMOt, SysUtils;

type
  TPegarAtributo = class
  public
    class function PegarDaClasse<T : TCustomAttribute>(aClasse : TClass) : T;
    class function PegarListaDaClasse<T : TCustomAttribute>(aClasse : TClass) : TList<T>;
    class function PegarDaProp<T : TCustomAttribute>(aProp : TRttiProperty) : T;
    class function PegarListaDaProp<T : TCustomAttribute>(aProp : TRttiProperty) : TList<T>;
  end;

  TNomeAmigavel = class(TCustomAttribute)
  private
    fNome: String;
  public
    constructor Create(const aNome : String);
    property nome : String read fNome write fNome;
  end;


implementation

var
  _ctx : TRttiContext;

{ TPegarAtributo }

class function TPegarAtributo.PegarDaClasse<T>(aClasse: TClass): T;
var
  ctx : TRttiContext;
  typ: TRttiType;
  a : TCustomAttribute;
begin
  result := nil;
  ctx := TRttiContext.Create;
  try
    typ := ctx.GetType(aClasse);
    for a in typ.GetAttributes do
    begin
      if a is T then
        exit(T(a));
    end;
  finally
    ctx.Free;
  end;
end;

class function TPegarAtributo.PegarDaProp<T>(aProp: TRttiProperty): T;
var
  attr : TCustomAttribute;
begin
  result := nil;
  if aProp = nil then
    exit;
  for attr in aProp.GetAttributes do
  begin
    if attr is T then
    begin
      result := T(attr);
      exit;
    end;
  end;

end;

class function TPegarAtributo.PegarListaDaClasse<T>(aClasse: TClass): TList<T>;
var
  ctx : TRttiContext;
  typ: TRttiType;
  a : TCustomAttribute;
begin
  result := TList<T>.Create;
  ctx := TRttiContext.Create;
  try
    typ := ctx.GetType(aClasse);

    for a in typ.GetAttributes do
    begin
      if a is T then
        result.Add(T(a));
    end;
  finally
    ctx.Free;
  end;
end;

class function TPegarAtributo.PegarListaDaProp<T>(
  aProp: TRttiProperty): TList<T>;
var
  attr : TCustomAttribute;
begin
  result := TList<T>.Create;
  if aProp = nil then
    exit;
  for attr in aProp.GetAttributes do
  begin
    if attr is T then
      result.Add(T(attr));
  end;
end;

{ TNomeAmigavel }

constructor TNomeAmigavel.Create(const aNome: String);
begin
  fNome := aNome;
end;


initialization
  _ctx := TRttiContext.Create;
finalization
  _ctx.Free;

end.

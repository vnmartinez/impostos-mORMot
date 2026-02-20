unit uGerenciadorServidores;

interface

uses
  uServidorTeste, mORMot, SynCommons;

type
  TGerenciadorServidores = class
  private class var
    fServidorTeste : TServidorSistemaTeste;
  public
    class property servidorTeste : TServidorSistemaTeste read fServidorTeste;
  end;

implementation

initialization
  TGerenciadorServidores.fServidorTeste := TServidorSistemaTeste.Create;

finalization
  TGerenciadorServidores.fServidorTeste.Free;


end.

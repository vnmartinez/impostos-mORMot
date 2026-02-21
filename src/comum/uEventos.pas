unit uEventos;


interface

uses
  System.RTTI;

type
  TEventoProgressoImportacao = procedure(const aPosicao, aMaximo : Integer) of object;
  TEventoInformacaoImportacao = procedure(const texto : String) of object;

  TEventoProgresso = procedure(const info : String; const aPos, aMax : Integer) of object;

  TOnDoubleClickNaLinha = procedure(linha, coluna : Integer) of object;
  TOnSelecionouLinha = procedure(linha : Integer) of object;

  TOnClicouBotaoAcaoNoGrid = function(linha, coluna : Integer) : Boolean of object;

  TOnAlterouPropriedade = procedure(prop : TRttiProperty) of object;

  TOnRecebeuMensagem = procedure(const usuario, msg : String) of object;

implementation

end.


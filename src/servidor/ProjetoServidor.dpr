program ProjetoServidor;

{$APPTYPE CONSOLE}
{$WARN DUPLICATE_CTOR_DTOR OFF}

uses
  SysUtils,
  SynSQLite3Static,
  uServidorTeste in 'uServidorTeste.pas',
  uServidorBase in 'uServidorBase.pas',
  uAtributos in '..\comum\uAtributos.pas',
  uModeloSistemaTeste in '..\comum\uModeloSistemaTeste.pas';

var
  lServidor: TServidorSistemaTeste;
begin
  lServidor := TServidorSistemaTeste.Create('8888');
  try
    Writeln('Servidor ativo em http://127.0.0.1:8888/impostos');
    Writeln('Banco principal: dados_teste.db');
    Writeln('Banco auxiliar: dados_auxiliares.db');
    Writeln('Pressione ENTER para encerrar.');
    Readln;
  finally
    Writeln('Encerrando servidor...');
    lServidor.Free;
    Writeln('Servidor encerrado.');
  end;
end.

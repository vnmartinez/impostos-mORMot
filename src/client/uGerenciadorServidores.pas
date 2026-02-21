unit uGerenciadorServidores;

interface

uses
  mORMot, SynCommons, mORMotHttpClient, uModeloSistemaTeste, SysUtils;

type
  TGerenciadorServidores = class
  private class var
    FModelo: TSQLModel;
    FServidorTeste: TSQLHttpClient;
  public
    class function TestarConexao: Boolean;
    class property ServidorTeste: TSQLHttpClient read FServidorTeste;
  end;

implementation

const
  HostServidorTeste = '127.0.0.1';
  PortaServidorTeste = '8888';


class function TGerenciadorServidores.TestarConexao: Boolean;
begin
  try
    Result := FServidorTeste.ServerTimestampSynchronize;
  except
    Result := False;
  end;
end;

initialization
  TGerenciadorServidores.FModelo := PegarModeloTeste;
  TGerenciadorServidores.FServidorTeste := TSQLHttpClient.Create(
    HostServidorTeste, PortaServidorTeste, TGerenciadorServidores.FModelo
  );
  TGerenciadorServidores.FServidorTeste.ConnectRetrySeconds := 2;

finalization
  TGerenciadorServidores.FServidorTeste.Free;
  TGerenciadorServidores.FModelo.Free;


end.


unit uServidorTeste;

interface

uses
  mORMot, SynCommons, uServidorBase, mORMotSQLite3, mORMotHttpClient, mORMotHttpServer, StrUtils, SysUtils,
  SynLog, mORMotWrappers, uModeloSistemaTeste;

type
  TServidorSistemaTeste = class(TServidor)
  protected
    procedure PreencherListaServices; override;

    procedure CriarModelo; override;
    procedure CriarRestServer; override;
  end;

implementation

{ TServidorSistemaTeste }

procedure TServidorSistemaTeste.CriarModelo;
begin
  inherited;
  fModel := PegarModeloTeste;
end;

procedure TServidorSistemaTeste.CriarRestServer;
begin
  inherited;

  fRestServer := TSQLRestServerDB.Create(fModel,
    ExeVersion.ProgramFilePath+'dados_teste.db', False);
  fRestServer.CreateMissingTables;
end;



procedure TServidorSistemaTeste.PreencherListaServices;
begin
  inherited;

end;

end.


program ProjetoTeste;

{$WARN DUPLICATE_CTOR_DTOR OFF}

uses
  SynSQLite3Static,
  Vcl.Forms,
  fmPrincipal in 'fmPrincipal.pas' {FormPrincipal},
  intfControladorVO in 'Util\intfControladorVO.pas',
  uAtributos in 'Util\uAtributos.pas',
  uEventos in 'Util\uEventos.pas',
  uModeloSistemaTeste in 'uModeloSistemaTeste.pas',
  uServidorTeste in 'Util\uServidorTeste.pas',
  uServidorBase in 'Util\uServidorBase.pas',
  uGerenciadorServidores in 'uGerenciadorServidores.pas',
  frVCLGrid in 'Util\UI\frVCLGrid.pas' {frameVCLGrid: TFrame};

{$R *.res}

begin

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.

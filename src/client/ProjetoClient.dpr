program ProjetoClient;

{$WARN DUPLICATE_CTOR_DTOR OFF}

uses
  Vcl.Forms,
  fmPrincipal in 'fmPrincipal.pas',
  intfControladorVO in '..\comum\intfControladorVO.pas',
  uAtributos in '..\comum\uAtributos.pas',
  uEventos in '..\comum\uEventos.pas',
  uModeloSistemaTeste in '..\comum\uModeloSistemaTeste.pas',
  uGerenciadorServidores in 'uGerenciadorServidores.pas',
  frVCLGrid in 'UI\frVCLGrid.pas';

{$R *.res}

begin

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.


unit uServidorTeste;
interface
uses
  mORMot, SynCommons, uServidorBase, mORMotSQLite3, SysUtils,
  uModeloSistemaTeste;
type
  TServidorSistemaTeste = class(TServidorHTTP)
  private
    procedure AtualizarRegistrosImpostoFederal;
    procedure GarantirBancoAuxiliar;
  protected
    procedure PreencherListaServices; override;
    procedure CriarModelo; override;
    procedure CriarRestServer; override;
  public
    constructor Create; reintroduce; overload;
    constructor Create(const APorta: String); reintroduce; overload;
  end;
implementation
constructor TServidorSistemaTeste.Create;
begin
  inherited Create('8888');
end;
constructor TServidorSistemaTeste.Create(const APorta: String);
begin
  inherited Create(APorta);
end;
procedure TServidorSistemaTeste.AtualizarRegistrosImpostoFederal;
const
  AliquotaNovaCbs: Currency = 0.1;
var
  lImpostoFederal: TImpostoFederal;
  lPossuiCbsNova: Boolean;
  lDataAtual: TDateTime;
  lDataFimCbsAntiga: TDateTime;
  lDataInicioCbsNova: TDateTime;
begin
  lDataAtual := Date;
  lDataInicioCbsNova := EncodeDate(2026, 1, 1);
  lDataFimCbsAntiga := EncodeDate(2025, 12, 31);
  lPossuiCbsNova := False;
  lImpostoFederal := TImpostoFederal.CreateAndFillPrepare(fRestServer, '');
  try
    while lImpostoFederal.FillOne do
    begin
      var lAlterou := False;
      var lCbsNova := False;
      if (lImpostoFederal.dataFim <= 0) and (lImpostoFederal.dataInicio <= 0) then
      begin
        lImpostoFederal.dataFim := lDataAtual;
        lAlterou := True;
      end;
      if SameText(lImpostoFederal.nome, 'CBS') then
      begin
        lCbsNova := (Trunc(lImpostoFederal.dataInicio) = Trunc(lDataInicioCbsNova)) and
          (lImpostoFederal.aliquotaModal = AliquotaNovaCbs);
        if lCbsNova then
        begin
          lPossuiCbsNova := True;
          if lImpostoFederal.dataFim > 0 then
          begin
            lImpostoFederal.dataFim := 0;
            lAlterou := True;
          end;
        end
        else if Trunc(lImpostoFederal.dataFim) <> Trunc(lDataFimCbsAntiga) then
        begin
          lImpostoFederal.dataFim := lDataFimCbsAntiga;
          lAlterou := True;
        end;
      end;
      if lAlterou then
      begin
        fRestServer.Update(lImpostoFederal);
      end;
    end;
  finally
    lImpostoFederal.Free;
  end;
  if not lPossuiCbsNova then
  begin
    lImpostoFederal := TImpostoFederal.Create;
    try
      lImpostoFederal.nome := 'CBS';
      lImpostoFederal.aliquotaModal := AliquotaNovaCbs;
      lImpostoFederal.dataInicio := lDataInicioCbsNova;
      lImpostoFederal.dataFim := 0;
      fRestServer.Add(lImpostoFederal, True);
    finally
      lImpostoFederal.Free;
    end;
  end;
end;
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
  AtualizarRegistrosImpostoFederal;
  GarantirBancoAuxiliar;
end;
procedure TServidorSistemaTeste.GarantirBancoAuxiliar;
begin
  var lModeloAuxiliar := PegarModeloAuxiliar;
  try
    var lServidorAuxiliar := TSQLRestServerDB.Create(
      lModeloAuxiliar, ExeVersion.ProgramFilePath + 'dados_auxiliares.db', False
    );
    try
      lServidorAuxiliar.CreateMissingTables;
    finally
      lServidorAuxiliar.Free;
    end;
  finally
    lModeloAuxiliar.Free;
  end;
end;

procedure TServidorSistemaTeste.PreencherListaServices;
begin
  inherited;

end;

end.



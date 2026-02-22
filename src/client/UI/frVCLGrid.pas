unit frVCLGrid;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids,
  Vcl.DBGrids, mORMOt, SynCommons, mORMotVCL, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.DateUtils;
type
  TframeVCLGrid = class(TFrame)
    DBGrid: TDBGrid;
    pnRodape: TPanel;
    btnExportarExcel: TButton;
    btnAdicionar: TButton;
    btnEditar: TButton;
    ds: TDataSource;
  private
    fTabela: TSQLRecordClass;
    procedure AplicarMascaraCamposData;
    procedure BtnExportarExcelClick(Sender: TObject);
    procedure BtnAdicionarClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    function CampoEhSomenteData(const ANomeCampo: String; ADataType: TFieldType): Boolean;
    function ConverterTextoParaCampo(const ANomeCampo, ATexto: String;
      ADataType: TFieldType; out AValor: Variant): Boolean;
    function FormatarValorParaEntrada(const ANomeCampo: String; ADataType: TFieldType;
      const AValorAtual: Variant): String;
    function SolicitarValorCampo(const ANomeCampo: String; ADataType: TFieldType;
      const AValorAtual: Variant; out AValorNovo: Variant): Boolean;
    procedure ExportarDataSetParaCsv(const AArquivo: String);
    function EscaparValorCsv(const AValor: String): String;
    function PegarIdRegistroSelecionado(out AId: TID): Boolean;
    function SalvarRegistro(ANovo: Boolean): Boolean;
    procedure RecarregarDados;
  protected
  public
    procedure Inicializar(ADataSet: TSynSQLTableDataSet; ATabela: TSQLRecordClass);
    procedure BeforeDestruction; override;
  end;
implementation
uses
  uGerenciadorServidores;
{$R *.dfm}


procedure TframeVCLGrid.BeforeDestruction;
begin
  ds.DataSet := nil;
  inherited;
end;
procedure TframeVCLGrid.AplicarMascaraCamposData;
begin
  if ds.DataSet = nil then
  begin
    Exit;
  end;
  for var lCampo in ds.DataSet.Fields do
  begin
    if CampoEhSomenteData(lCampo.FieldName, lCampo.DataType) and (lCampo is TDateTimeField) then
    begin
      TDateTimeField(lCampo).DisplayFormat := 'dd/mm/yyyy';
      TDateTimeField(lCampo).EditMask := '!99/99/0000;1;_';
    end;
  end;
end;
procedure TframeVCLGrid.BtnAdicionarClick(Sender: TObject);
begin
  SalvarRegistro(True);
end;
procedure TframeVCLGrid.BtnEditarClick(Sender: TObject);
begin
  SalvarRegistro(False);
end;

function TframeVCLGrid.EscaparValorCsv(const AValor: String): String;
begin
  Result := AValor.Replace('"', '""');
  if (Pos(';', Result) > 0) or (Pos('"', Result) > 0) or
    (Pos(#13, Result) > 0) or (Pos(#10, Result) > 0) then
  begin
    Result := '"' + Result + '"';
  end;
end;

procedure TframeVCLGrid.ExportarDataSetParaCsv(const AArquivo: String);
begin
  var lDataSet := ds.DataSet;
  if (lDataSet = nil) or (not lDataSet.Active) then
  begin
    Exit;
  end;

  var lLinhas := TStringList.Create;
  try
    var lLinhaCabecalho := '';
    for var lIndex := 0 to lDataSet.FieldCount - 1 do
    begin
      if lLinhaCabecalho <> '' then
      begin
        lLinhaCabecalho := lLinhaCabecalho + ';';
      end;
      lLinhaCabecalho := lLinhaCabecalho + EscaparValorCsv(lDataSet.Fields[lIndex].DisplayName);
    end;
    lLinhas.Add(lLinhaCabecalho);

    var lBookmark := lDataSet.GetBookmark;
    lDataSet.DisableControls;
    try
      lDataSet.First;
      while not lDataSet.Eof do
      begin
        var lLinha := '';
        for var lIndex := 0 to lDataSet.FieldCount - 1 do
        begin
          if lLinha <> '' then
          begin
            lLinha := lLinha + ';';
          end;
          lLinha := lLinha + EscaparValorCsv(lDataSet.Fields[lIndex].AsString);
        end;
        lLinhas.Add(lLinha);
        lDataSet.Next;
      end;

      if (lBookmark <> nil) and lDataSet.BookmarkValid(lBookmark) then
      begin
        lDataSet.GotoBookmark(lBookmark);
      end;
    finally
      if lBookmark <> nil then
      begin
        lDataSet.FreeBookmark(lBookmark);
      end;
      lDataSet.EnableControls;
    end;

    lLinhas.SaveToFile(AArquivo, TEncoding.UTF8);
  finally
    lLinhas.Free;
  end;
end;

procedure TframeVCLGrid.BtnExportarExcelClick(Sender: TObject);
begin
  if (ds.DataSet = nil) or (not ds.DataSet.Active) then
  begin
    ShowMessage('Nao ha dados para exportar.');
    Exit;
  end;

  var lSaveDialog := TSaveDialog.Create(Self);
  try
    lSaveDialog.DefaultExt := 'csv';
    lSaveDialog.Filter := 'Arquivo CSV (*.csv)|*.csv';
    lSaveDialog.FileName := 'exportacao.csv';
    if not lSaveDialog.Execute then
    begin
      Exit;
    end;

    ExportarDataSetParaCsv(lSaveDialog.FileName);
    ShowMessage('Arquivo exportado com sucesso.');
  finally
    lSaveDialog.Free;
  end;
end;

function TframeVCLGrid.CampoEhSomenteData(const ANomeCampo: String;
  ADataType: TFieldType): Boolean;
var
  lNome: String;
begin
  if ADataType = ftDate then
  begin
    Exit(True);
  end;
  lNome := System.SysUtils.LowerCase(ANomeCampo);
  Result := (lNome = 'datainicio') or (lNome = 'datafim');
end;

function TframeVCLGrid.ConverterTextoParaCampo(const ANomeCampo,
  ATexto: String; ADataType: TFieldType; out AValor: Variant): Boolean;
var
  lInt: Int64;
  lFloat: Double;
  lDataHora: TDateTime;
  lFormat: TFormatSettings;
  lNormalizado: String;
begin
  if ATexto.Trim = '' then
  begin
    AValor := Null;
    Exit(True);
  end;
  lFormat := TFormatSettings.Create;
  case ADataType of
    ftSmallint, ftInteger, ftWord, ftLongWord, ftShortint, ftByte, ftLargeint:
      begin
        Result := TryStrToInt64(ATexto, lInt);
        if Result then
        begin
          AValor := lInt;
        end;
      end;
    ftFloat, ftCurrency, ftBCD, ftFMTBcd:
      begin
        Result := TryStrToFloat(ATexto, lFloat, lFormat);
        if not Result then
        begin
          lNormalizado := ATexto.Replace(',', lFormat.DecimalSeparator).Replace('.', lFormat.DecimalSeparator);
          Result := TryStrToFloat(lNormalizado, lFloat, lFormat);
        end;
        if Result then
        begin
          AValor := lFloat;
        end;
      end;
    ftBoolean:
      begin
        lNormalizado := System.SysUtils.LowerCase(ATexto.Trim);
        if (lNormalizado = '1') or (lNormalizado = 'true') or (lNormalizado = 'sim') or
           (lNormalizado = 's') or (lNormalizado = 'yes') or (lNormalizado = 'y') then
        begin
          AValor := True;
          Result := True;
        end
        else if (lNormalizado = '0') or (lNormalizado = 'false') or (lNormalizado = 'nao') or
                (lNormalizado = 'n') or (lNormalizado = 'no') then
        begin
          AValor := False;
          Result := True;
        end
        else
        begin
          Result := False;
        end;
      end;
    ftDate, ftTime, ftDateTime, ftTimeStamp, ftTimeStampOffset:
      begin
        if CampoEhSomenteData(ANomeCampo, ADataType) then
        begin
          Result := TryStrToDate(ATexto, lDataHora, lFormat);

          if not Result then
          begin
            Result := TryStrToDateTime(ATexto, lDataHora, lFormat);
          end;

          if Result then
          begin
            AValor := DateOf(lDataHora);
          end;
          Exit;
        end;
        Result := TryStrToDateTime(ATexto, lDataHora, lFormat);
        if not Result and ((ADataType = ftDate) or (ADataType = ftDateTime) or
          (ADataType = ftTimeStamp) or (ADataType = ftTimeStampOffset)) then

        begin
          Result := TryStrToDate(ATexto, lDataHora, lFormat);
        end;

        if not Result and (ADataType = ftTime) then
        begin
          Result := TryStrToTime(ATexto, lDataHora, lFormat);
        end;

        if Result then
        begin
          AValor := lDataHora;
        end;
      end;
  else
    AValor := ATexto;
    Result := True;
  end;
end;

function TframeVCLGrid.FormatarValorParaEntrada(const ANomeCampo: String;
  ADataType: TFieldType; const AValorAtual: Variant): String;
var
  lDataHora: TDateTime;
begin
  if VarIsNull(AValorAtual) or VarIsEmpty(AValorAtual) then
  begin
    Exit('');
  end;
  if CampoEhSomenteData(ANomeCampo, ADataType) and VarIsType(AValorAtual, varDate) then
  begin
    lDataHora := VarToDateTime(AValorAtual);
    Exit(FormatDateTime('dd/mm/yyyy', lDataHora));
  end;
  Result := VarToStr(AValorAtual);
end;

procedure TframeVCLGrid.Inicializar(ADataSet: TSynSQLTableDataSet;
  ATabela: TSQLRecordClass);
begin
  fTabela := ATabela;
  ds.DataSet := ADataSet;
  AplicarMascaraCamposData;
  btnExportarExcel.OnClick := BtnExportarExcelClick;
  btnAdicionar.OnClick := BtnAdicionarClick;
  btnEditar.OnClick := BtnEditarClick;
end;

function TframeVCLGrid.PegarIdRegistroSelecionado(out AId: TID): Boolean;
var
  lCampoId: TField;
begin
  Result := False;
  AId := 0;

  if (ds.DataSet = nil) or (not ds.DataSet.Active) or ds.DataSet.IsEmpty then
  begin
    Exit;
  end;

  lCampoId := ds.DataSet.FindField('ID');

  if lCampoId = nil then
  begin
    lCampoId := ds.DataSet.FindField('RowID');
  end;

  if (lCampoId = nil) or lCampoId.IsNull then
  begin
    Exit;
  end;

  AId := lCampoId.AsLargeInt;
  Result := AId > 0;
end;

procedure TframeVCLGrid.RecarregarDados;
var
  lAnterior: TDataSet;
  lJson: RawUTF8;
  lNovoDataSet: TSynSQLTableDataSet;
begin
  if fTabela = nil then
  begin
    Exit;
  end;
  lJson := TGerenciadorServidores.ServidorTeste.RetrieveListJSON(fTabela, '', []);
  lNovoDataSet := JSONTableToDataSet(Self, lJson, [fTabela]);
  lAnterior := ds.DataSet;
  ds.DataSet := lNovoDataSet;
  AplicarMascaraCamposData;

  if lAnterior <> nil then
  begin
    lAnterior.Free;
  end;
end;

function TframeVCLGrid.SalvarRegistro(ANovo: Boolean): Boolean;
var
  lRegistro: TSQLRecord;
  lCampo: TField;
  lValorAtual: Variant;
  lValorNovo: Variant;
  lId: TID;
  lNovoId: TID;
begin
  Result := False;

  if fTabela = nil then
  begin
    ShowMessage('Tabela nao informada.');
    Exit;
  end;

  if (ds.DataSet = nil) or (not ds.DataSet.Active) then
  begin
    ShowMessage('Nao ha dados carregados.');
    Exit;
  end;

  lRegistro := fTabela.Create;
  try
    if not ANovo then
    begin
      if not PegarIdRegistroSelecionado(lId) then
      begin
        ShowMessage('Selecione um registro para editar.');
        Exit;
      end;

      if not TGerenciadorServidores.ServidorTeste.Retrieve(lId, lRegistro) then
      begin
        ShowMessage('Nao foi possivel carregar o registro selecionado.');
        Exit;
      end;

    end;
    for lCampo in ds.DataSet.Fields do
    begin
      if SameText(lCampo.FieldName, 'ID') or SameText(lCampo.FieldName, 'RowID') then
      begin
        Continue;
      end;

      lValorAtual := lRegistro.GetFieldVariant(lCampo.FieldName);

      if not SolicitarValorCampo(lCampo.FieldName, lCampo.DataType, lValorAtual, lValorNovo) then
      begin
        Exit;
      end;

      lRegistro.SetFieldVariant(lCampo.FieldName, lValorNovo);
    end;
    if ANovo then
    begin

      lNovoId := TGerenciadorServidores.ServidorTeste.Add(lRegistro, True);

      if lNovoId = 0 then
      begin
        ShowMessage('Falha ao adicionar registro.');
        Exit;
      end;

      ShowMessage('Registro adicionado com sucesso.');
    end
    else
    begin
      if not TGerenciadorServidores.ServidorTeste.Update(lRegistro) then
      begin
        ShowMessage('Falha ao atualizar registro.');
        Exit;
      end;

      ShowMessage('Registro atualizado com sucesso.');
    end;
    RecarregarDados;
    Result := True;
  finally
    lRegistro.Free;
  end;
end;

function TframeVCLGrid.SolicitarValorCampo(const ANomeCampo: String;
  ADataType: TFieldType; const AValorAtual: Variant; out AValorNovo: Variant): Boolean;
var
  lTexto: String;
begin
  lTexto := FormatarValorParaEntrada(ANomeCampo, ADataType, AValorAtual);
  while True do
  begin
    Result := InputQuery('Editar Registro', ANomeCampo, lTexto);

    if not Result then
    begin
      Exit(False);
    end;

    if ConverterTextoParaCampo(ANomeCampo, lTexto, ADataType, AValorNovo) then
    begin
      Exit(True);
    end;

    ShowMessage('Valor invalido para o campo "' + ANomeCampo + '".');
  end;
end;
end.


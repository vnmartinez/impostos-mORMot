unit frVCLGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids,
  Vcl.DBGrids, mORMOt, SynCommons, mORMotVCL, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TframeVCLGrid = class(TFrame)
    DBGrid: TDBGrid;
    pnRodape: TPanel;
    btnExportarExcel: TButton;
    ds: TDataSource;
  private
    procedure BtnExportarExcelClick(Sender: TObject);
    procedure ExportarDataSetParaCsv(const AArquivo: String);
    function EscaparValorCsv(const AValor: String): String;
  protected

  public
    procedure Inicializar(ADataSet : TSynSQLTableDataSet);
    procedure BeforeDestruction; override;
  end;

implementation

{$R *.dfm}


procedure TframeVCLGrid.BeforeDestruction;
begin
  ds.DataSet := nil;
  inherited;
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

procedure TframeVCLGrid.Inicializar(ADataSet : TSynSQLTableDataSet);
begin
  ds.DataSet := ADataSet;
  btnExportarExcel.OnClick := BtnExportarExcelClick;
end;

end.


unit fmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, mORMOtVCL,
  mORMOt, SynCommons;

type
  TFormPrincipal = class(TForm)
    pnFundo: TPanel;
    lbTabelas: TListBox;
    splt: TSplitter;
    pcTabelas: TPageControl;
    procedure FormCreate(Sender: TObject);
    procedure LbTabelasClick(Sender: TObject);
  private
    procedure AbrirTabela(ATabela: TSQLRecordClass; const ATitulo: String);
    function PegarTabelaSelecionada: TSQLRecordClass;
    procedure PreencherListBox;
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation
uses
  uGerenciadorServidores, uAtributos, frVCLGrid;

{$R *.dfm}


procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  PreencherListBox;
  if not TGerenciadorServidores.TestarConexao then
  begin
    ShowMessage('Servidor externo nao encontrado em 127.0.0.1:8888. Inicie o ServidorSistemaTesteConsole.');
  end;
end;

procedure TFormPrincipal.LbTabelasClick(Sender: TObject);
begin
  if lbTabelas.ItemIndex < 0 then
  begin
    Exit;
  end;
  if not TGerenciadorServidores.TestarConexao then
  begin
    ShowMessage('Servidor externo indisponivel. Inicie o ServidorSistemaTesteConsole.');
    Exit;
  end;
  AbrirTabela(PegarTabelaSelecionada, lbTabelas.Items[lbTabelas.ItemIndex]);
end;

procedure TFormPrincipal.PreencherListBox;
begin
  var lRestServer := TGerenciadorServidores.ServidorTeste;
  lbTabelas.Items.BeginUpdate;
  try
    lbTabelas.Clear;
    for var lTable in lRestServer.Model.Tables do
    begin
      var lNomeAmigavel := TPegarAtributo.PegarDaClasse<TNomeAmigavel>(lTable);
      if lNomeAmigavel <> nil then
      begin
        lbTabelas.Items.AddObject(lNomeAmigavel.nome, TObject(lTable))
      end
      else
      begin
        lbTabelas.Items.AddObject(UTF8ToString(lTable.RecordProps.SQLTableName), TObject(lTable));
      end;
    end;
  finally
    lbTabelas.Items.EndUpdate;
  end;
end;

function TFormPrincipal.PegarTabelaSelecionada: TSQLRecordClass;
begin
  Result := nil;
  if lbTabelas.ItemIndex < 0 then
  begin
    Exit;
  end;
  Result := TSQLRecordClass(lbTabelas.Items.Objects[lbTabelas.ItemIndex]);
end;

procedure TFormPrincipal.AbrirTabela(ATabela: TSQLRecordClass;
  const ATitulo: String);
begin
  if ATabela = nil then
  begin
    Exit;
  end;
  var lTabSheet := TTabSheet.Create(pcTabelas);
  lTabSheet.PageControl := pcTabelas;
  lTabSheet.Caption := 'Tabela ' + ATitulo;
  pcTabelas.ActivePage := lTabSheet;
  var lDados := ATabela.CreateAndFillPrepare(TGerenciadorServidores.ServidorTeste, '');
  try
    var lFrame := TframeVCLGrid.Create(lTabSheet);
    lFrame.Name := 'FrameTabela' + IntToStr(pcTabelas.PageCount);
    lFrame.Parent := lTabSheet;
    lFrame.Inicializar(TSynSQLTableDataSet.Create(lFrame, lDados.FillTable));
    lFrame.Align := alClient;
  finally
    lDados.Free;
  end;
end;

end.


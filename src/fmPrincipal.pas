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
    procedure lbTabelasClick(Sender: TObject);
  private



    procedure PreencherListBox;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  uGerenciadorServidores, uAtributos, frVCLGrid,
  uModeloSistemaTeste;

{$R *.dfm}

{ TFormPrincipal }

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  PreencherListBox;
end;

procedure TFormPrincipal.lbTabelasClick(Sender: TObject);
begin

  //if pcTabelas.PageCount = 0 then
  begin
    var ts := TTabSheet.Create(pcTabelas);
    ts.PageControl := pcTabelas;
    ts.Caption := 'Tabela TImpostoFederal';
    pcTabelas.ActivePageIndex := pcTabelas.PageCount-1;

    var dados := TImpostoFederal.CreateAndFillPrepare(
      TGerenciadorServidores.servidorTeste.RestServer, ''
    );
    try


      var frame := TframeVCLGrid.Create(Self);
      frame.name := UTF8ToString(FormatUTF8('FrameTabela%', [pcTabelas.ActivePageIndex]));
      frame.Parent := ts;
      frame.Inicializar(
        TSynSQLTableDataSet.Create(Self, dados.FillTable)
      );
      frame.Align := alClient;


    finally
      dados.Free;
    end;


  end;




end;

procedure TFormPrincipal.PreencherListBox;
begin

  var restServer := TGerenciadorServidores.servidorTeste;
  for var table in restServer.Model.Tables do
  begin
    var a := TPegarAtributo.PegarDaClasse<TNomeAmigavel>(table);
    if a <> nil then
      lbTabelas.Items.AddObject(a.nome, nil);
  end;

end;

end.

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
    { Private declarations }
  protected

  public
    procedure Inicializar(aDS : TSynSQLTableDataSet);
    procedure BeforeDestruction; override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TframeVCLGrid }

procedure TframeVCLGrid.BeforeDestruction;
begin
  inherited;

end;

procedure TframeVCLGrid.Inicializar(aDS : TSynSQLTableDataSet);
begin
  ds.DataSet := aDS;



end;

end.

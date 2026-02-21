unit uServidorBase;

interface

uses
  mORMot, SynCommons, mORMotSQLite3, mORMotHttpServer, StrUtils,
  SysUtils, SynLog, Generics.Collections, Windows;

type
  TServiceInfo = class
  public
    ServiceInterfaces : array of TGUID;
    ServiceInstanceImplementation : TServiceInstanceImplementation;
    ServiceImplementationClass : TInterfacedClass;
    Options : TServiceMethodOptions;

    constructor Create;
    destructor Destroy; override;
  end;

  TServidor = class
  protected
    fRestServer : TSQLRestServer;
    fModel : TSQLModel;
    fListaServices : TObjectList<TServiceInfo>;

    procedure IniciarInterfaces; virtual;
    procedure IniciarProcessosDeBackground; virtual;
    procedure OnServiceCreateInstance(Sender: TServiceFactoryServer; Instance: TInterfacedObject); virtual;

    procedure PreencherListaServices; virtual; abstract;
    procedure CriarModelo; virtual; abstract;
    procedure CriarRestServer; virtual; abstract;
  public
    Constructor Create;
    destructor Destroy; override;

    property RestServer : TSQLRestServer read fRestServer;
    property Model : TSQLModel read fModel;
  end;

  TServidorHTTP = class(TServidor)
  protected
    fPorta : String;
    fHttpServer : TSQLHttpServer;

    function GetServerPoolCount : Integer; virtual;
    procedure IniciarInterfaces; override;
  public
    constructor Create(APorta : String);
    destructor Destroy; override;

    property Porta : String read fPorta;
  end;

  TServidorPipe = class(TServidor)
  private
    fPipeName : String;
  protected
    procedure IniciarInterfaces; override;
  public
    constructor Create(APipeName : String);
  end;

implementation


constructor TServidor.Create;
begin
  CriarModelo;

  fListaServices := TObjectList<TServiceInfo>.Create;
  PreencherListaServices;


  with TSynLog.Family do begin

    Level := LOG_STACKTRACE;
    EchoToConsole := LOG_STACKTRACE;
    PerThreadLog := ptIdentifiedInOnFile;
  end;

  CriarRestServer;
  fRestServer.OnServiceCreateInstance := Self.OnServiceCreateInstance;

  IniciarInterfaces;
  IniciarProcessosDeBackground;
end;

destructor TServidor.Destroy;
begin
  fListaServices.Free;

  fModel.Free;
  fRestServer.Free;

  inherited;
end;

procedure TServidor.IniciarInterfaces;
var
  serviceInfo : TServiceInfo;
begin
  for serviceInfo in fListaServices do
  begin
    var sd := fRestServer.ServiceDefine(
      serviceInfo.ServiceImplementationClass, serviceInfo.ServiceInterfaces, serviceInfo.ServiceInstanceImplementation
    );


    sd.ResultAsJSONObjectWithoutResult := True;
    if serviceInfo.Options <> [] then
    begin
      sd.SetOptions([], serviceInfo.Options);
      sd.ByPassAuthentication := true;
    end;
  end;
end;

procedure TServidor.IniciarProcessosDeBackground;
begin

end;

procedure TServidor.OnServiceCreateInstance(Sender: TServiceFactoryServer;
  Instance: TInterfacedObject);
begin
end;


constructor TServidorHTTP.Create(APorta: String);
begin
  fPorta := APorta;
  inherited Create;
end;

destructor TServidorHTTP.Destroy;
begin
  if Assigned(fHttpServer) then
  begin
    try
      fHttpServer.Shutdown(True);
    except
    end;
    FreeAndNil(fHttpServer);
  end;

  inherited;
end;

function TServidorHTTP.GetServerPoolCount: Integer;
begin
  result := 4;
end;

procedure TServidorHTTP.IniciarInterfaces;
begin
  inherited;

  fHttpServer := TSQLHttpServer.Create(
    AnsiString(fPorta), [fRestServer], '+', HTTP_DEFAULT_MODE, GetServerPoolCount
  );
  fHttpServer.AccessControlAllowOrigin := '*';

end;


constructor TServidorPipe.Create(APipeName: String);
begin
  fPipeName := APipeName;
  inherited Create;
end;


procedure TServidorPipe.IniciarInterfaces;
begin
  inherited;
  fRestServer.ExportServerNamedPipe(fPipeName);
end;


constructor TServiceInfo.Create;
begin
  Options := [];
end;

destructor TServiceInfo.Destroy;
begin

  inherited;
end;

end.



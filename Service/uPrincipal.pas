unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  IdHTTPWebBrokerBridge, Web.HTTPApp, IniFiles, Vcl.Forms;

type
  TsrvIA_WSAPTSRV = class(TService)
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
    FServer: TIdHTTPWebBrokerBridge;
    procedure TerminateThreads;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  srvIA_WSAPTSRV: TsrvIA_WSAPTSRV;
  iPORTA        : Integer;

implementation

{$R *.dfm}

uses
  Datasnap.DSSession;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  srvIA_WSAPTSRV.Controller(CtrlCode);
end;

function TsrvIA_WSAPTSRV.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TsrvIA_WSAPTSRV.ServiceCreate(Sender: TObject);
var
  sArqIni   : string;
  ServerIni : TIniFile;
begin

  FServer := TIdHTTPWebBrokerBridge.Create(Self);

  sArqIni   := ChangeFileExt(Application.exename,'.INI');
  ServerIni := TIniFile.Create(sArqIni);
  iPORTA    := ServerIni.ReadInteger('APT','PORTA',0);

end;

procedure TsrvIA_WSAPTSRV.ServiceExecute(Sender: TService);
begin
  while not Terminated do
  begin
    Sleep(1000);
    ServiceThread.ProcessRequests(False);
  end;
end;

procedure TsrvIA_WSAPTSRV.ServiceStart(Sender: TService; var Started: Boolean);
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := iPORTA; //12395;
    FServer.Active := True;
  end;
end;

procedure TsrvIA_WSAPTSRV.ServiceStop(Sender: TService; var Stopped: Boolean);
begin

  TerminateThreads;

  FServer.Active := False;
  FServer.Bindings.Clear;

  ServiceThread.Terminate;

end;

procedure TsrvIA_WSAPTSRV.TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

end.

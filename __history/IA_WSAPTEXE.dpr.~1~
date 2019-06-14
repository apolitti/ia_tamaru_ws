program IA_WSAPTEXE;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPrincipal},
  ServerContainerUnit1 in 'ServerContainerUnit1.pas' {ServerContainer1: TDataModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  uAptServer in 'uAptServer.pas' {DSAptServer: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TDSAptServer, DSAptServer);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

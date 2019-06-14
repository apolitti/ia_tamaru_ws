program IA_WSAPTSRV;

uses
  Vcl.SvcMgr,
  uPrincipal in 'uPrincipal.pas' {srvIA_WSAPTSRV: TService},
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  ServerContainerUnit1 in '..\ServerContainerUnit1.pas' {ServerContainer1: TDataModule},
  WebModuleUnit1 in '..\WebModuleUnit1.pas' {WebModule1: TWebModule},
  uAptServer in '..\uAptServer.pas' {DSAptServer: TDataModule};

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //

  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;

  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;

  //Application.CreateForm(TService1, Service1);
  Application.CreateForm(TsrvIA_WSAPTSRV, srvIA_WSAPTSRV);
  Application.Run;

end.

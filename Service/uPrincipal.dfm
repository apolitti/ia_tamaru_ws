object srvIA_WSAPTSRV: TsrvIA_WSAPTSRV
  OldCreateOrder = False
  OnCreate = ServiceCreate
  DisplayName = 'IA_WSAPTSRV'
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
end

unit uAptServer;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Json, Data.DBXPlatform, IniFiles, Vcl.Forms,
  Datasnap.DBClient, FireDAC.Stan.StorageXML;

{$METHODINFO ON}
type
  TDSAptServer = class(TDataModule)
    FDConnection: TFDConnection;
    EmployeeTable: TFDQuery;
    EmployeeTableEMPLOYEE_ID: TBCDField;
    EmployeeTableFIRST_NAME: TStringField;
    EmployeeTableLAST_NAME: TStringField;
    EmployeeTableEMAIL: TStringField;
    EmployeeTablePHONE_NUMBER: TStringField;
    EmployeeTableHIRE_DATE: TDateTimeField;
    EmployeeTableJOB_ID: TStringField;
    EmployeeTableSALARY: TBCDField;
    EmployeeTableCOMMISSION_PCT: TBCDField;
    EmployeeTableMANAGER_ID: TBCDField;
    EmployeeTableDEPARTMENT_ID: TBCDField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CarregaIni;
    function  isInteger(valor: string): boolean;
    procedure SetParam(var sqlQuery : TFDQuery; campo : string; tipo : string; valor : variant);
    procedure SetParamB(var sqlQuery : TFDQuery; campo : string; valor : TStringList);
    procedure DataSetToJSONArray(var JSONArray : TJSONArray; sqlQuery : TFDQuery);
  public
    { Public declarations }
    function  Employee(const Key : string) : TJSONArray;

    function  f_maquina_lst(fil_in_codigo, cmaq_in_codigo: string): TJSONArray;
    function  f_listamateriais_lst(p_fil_in_codigo, p_pro_in_codigo, p_cps_in_codigo, p_lis_in_revisao : string) : TJSONArray;
    function  f_ordem_lst(p_fil_in_codigo, p_ord_in_codigo : string) : TJSONArray;
    function  f_apontamento_lst(p_apo_in_sequencia : string) : TJSONArray;
    function  f_operadormaquina_lst(fil_in_codigo, cmaq_in_codigo: string): TJSONArray;
    procedure acceptp_operadormaquina_ins(p_fil_in_codigo, p_cmaq_in_codigo, p_opd_st_alternativo, p_opd_ch_funcao: string);
    procedure acceptp_operadormaquina_del(p_fil_in_codigo, p_cmaq_in_codigo, p_opd_st_alternativo: string);
    procedure acceptp_ordemmaquina_upd(p_fil_in_codigo, p_cmaq_in_codigo, p_ord_in_codigo: string);
    function  f_aviso_lst(p_fil_in_codigo, p_avr_st_nota, p_agn_st_cgc, p_avr_bo_itemaberto, p_avr_bo_itemdivergente, p_avr_bo_estoque : string) : TJSONArray;
    function  f_aviso_itens_lst(
                p_fil_in_codigo,
                p_avr_st_nota,
                p_agn_st_cgc : string
              ) : TJSONArray;
    procedure acceptp_aviso_itens_upd(
                p_objeto : TJSONArray
              );

    function  f_fornecedor_lst(
                p_fil_in_codigo,
                p_fornecedor_codigo : string
              ) : TJSONArray;

    function  f_produto_lst(
                p_fil_in_codigo,
                p_produto_codigo : string
              ) : TJSONArray;

    function  f_etiqueta_lst(
                p_fil_in_codigo,
                p_rcb_st_nota,
                p_agn_in_codigo,
                p_pro_in_codigo,
                p_mvs_st_loteforne : string
              ) : TJSONArray;

    function  f_demandalote_lst(p_fil_in_codigo, p_cmaq_in_codigo, p_mvs_st_loteforne: string): TJSONArray;
    function  f_demandamaquina_lst(p_fil_in_codigo, p_cmaq_in_codigo: string): TJSONArray;
    procedure acceptp_demandamaquina_ins(p_fil_in_codigo, p_cmaq_in_codigo, p_mvs_st_loteforne, p_mvs_re_quantidade : string);
    procedure acceptp_demandamaquina_del(p_mqd_in_sequencia, p_mvs_re_quantidade : string);
    procedure acceptp_apontarproducao_exe(p_fil_in_codigo, p_cmaq_in_codigo, p_ord_in_codigo, p_apo_re_quantidade : string);
    function  f_etiqueta_processo_lst( p_barcode
                                     , p_lote
                                     , p_unidade
                                     , p_quantidade
                                     , p_data
                                     , p_hora
                                     , p_operador
                                     , p_item_codigo
                                     , p_item_descricao
                                     , p_copia : string
                                     ) : TJSONArray;

    function  f_etiqueta_recebimento_lst( p_lote
                                        , p_status
                                        , p_nota_fiscal
                                        , p_data
                                        , p_inspecao
                                        , p_barcode
                                        , p_copia : string
                                        ) : TJSONArray;

    function  f_etiqueta_produtoacabado_lst( p_etiq_in_id
                                           , p_item_descricao
                                           , p_inspecao
                                           , p_embalador
                                           , p_operador
                                           , p_data
                                           , p_lote
                                           , p_barcode
                                           , p_quantidade
                                           , p_tampa
                                           , p_cor
                                           , p_copia : string
                                           ) : TJSONArray;

    function  f_etiqueta_aluminio_lst( p_item_descricao
                                     , p_inspecao
                                     , p_data
                                     , p_lote
                                     , p_barcode
                                     , p_quantidade
                                     , p_tampa
                                     , p_cor
                                     , p_copia : string
                                     ) : TJSONArray;

    function  f_impressorama_lst( p_fil_in_codigo
                                , p_cmaq_in_codigo : string
                                ) : TJSONArray;

    function  f_impressoragr_lst : TJSONArray;

    function  f_encerrarproducao_lst(p_fil_in_codigo, p_cmaq_in_codigo: string): TJSONArray;
    procedure acceptp_encerrarproducao_exe(p_fil_in_codigo, p_cmaq_in_codigo, p_ord_in_codigo, p_apo_re_qtdeproduzidakg : string; jObject : TJSONArray);
    function  f_encerrarconsumo_lst(p_fil_in_codigo, p_cmaq_in_codigo: string): TJSONArray;
    procedure acceptp_encerrarconsumo_exe(p_fil_in_codigo, p_cmaq_in_codigo, p_ord_in_codigo, p_apo_re_qtdeproduzidakg, p_apo_re_qtdeconsumidakg, p_apo_re_qtdeempenhadakg, p_apo_re_qtdesaldokg : string; p_apo_in_sequencia : string ; jObject : TJSONArray);
    function  f_recebimentoetq_lst(p_fil_in_codigo, p_rcb_st_nota, p_agn_st_cgc, p_pro_in_codigo, p_mvs_st_loteforne : string): TJSONArray;
    function  f_avisoetq_lst(p_fil_in_codigo, p_avr_st_nota, p_agn_st_cgc : string) : TJSONArray;
    procedure acceptp_inspecao_exe( p_fil_in_codigo, p_cmaq_in_codigo, p_ord_in_codigo : string);

    procedure acceptp_followup_lst(pParams : String);
    procedure acceptp_maquina_lst;

    function f_impressao_lst(p_imp_st_servidor : string): TJSONArray;

  end;

  Function StringToStream(const AString: string): TStream;

{$METHODINFO OFF}

var
  DSAptServer: TDSAptServer;

  sSID   : string;
  iPORTA : Integer;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}
{ TDSEmployeeServer }

procedure TDSAptServer.CarregaIni;
var
  sArqIni   : string;
  ServerIni : TIniFile;
begin

  sArqIni                      := ChangeFileExt(Application.exename,'.INI');
  ServerIni                    := TIniFile.Create(sArqIni);
  sSID                         := ServerIni.ReadString('APT', 'SID', '');
  iPORTA                       := ServerIni.ReadInteger('APT','PORTA',0);

  FDConnection.Params.Database := sSID;

end;

//Validar inteiro
function TDSAptServer.isInteger(valor: string): boolean;
var
  Val : integer;
  Resultado: boolean;
begin
  Resultado := True;
  try
    Val := StrToInt(Valor);
  except
    on E: EConvertError do
      Resultado := False;
  end;
  Result := Resultado;
end;

procedure TDSAptServer.acceptp_inspecao_exe(p_fil_in_codigo, p_cmaq_in_codigo, p_ord_in_codigo : string);
var
  sqlQuery : TFDQuery;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_apt.p_inspecao_exe( :p_fil_in_codigo');
      SQL.Add('                                    , :p_cmaq_in_codigo');
      SQL.Add('                                    , :p_ord_in_codigo');
      SQL.Add('                                    );');
      SQL.Add('end;');

      SetParam(sqlQuery  , 'p_fil_in_codigo'  , 'I' , p_fil_in_codigo);
      SetParam(sqlQuery  , 'p_cmaq_in_codigo' , 'I' , p_cmaq_in_codigo);
      SetParam(sqlQuery  , 'p_ord_in_codigo'  , 'I' , p_ord_in_codigo);

      try
        ExecSQL;
      except
        on e: exception do
        begin
          GetInvocationMetadata.ResponseCode    := 417;
          GetInvocationMetadata.ResponseMessage := e.Message;
        end;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;

function TDSAptServer.f_listamateriais_lst(p_fil_in_codigo, p_pro_in_codigo, p_cps_in_codigo, p_lis_in_revisao: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_apt.f_listamateriais_lst( :p_fil_in_codigo');
        SQL.Add('                                                     , :p_pro_in_codigo');
        SQL.Add('                                                     , :p_cps_in_codigo');
        SQL.Add('                                                     , :p_lis_in_revisao');
        SQL.Add('                                                     )) lst');

        SetParam(sqlQuery , 'p_fil_in_codigo'  , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_pro_in_codigo'  , 'I' , p_pro_in_codigo);
        SetParam(sqlQuery , 'p_cps_in_codigo'  , 'I' , p_cps_in_codigo);
        SetParam(sqlQuery , 'p_lis_in_revisao' , 'I' , p_lis_in_revisao);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

procedure TDSAptServer.SetParam(var sqlQuery: TFDQuery; campo, tipo: string; valor: variant);
var
  ivalor : integer;
  fvalor : Double;
begin

  //integer
  if tipo = 'I' then
  begin
    sqlQuery.ParamByName(campo).DataType := ftInteger;
    if TryStrToInt(valor,ivalor) then
      sqlQuery.ParamByName(campo).AsInteger := ivalor
    else
      sqlQuery.ParamByName(campo).Clear();
  end;

  //string
  if tipo = 'S' then
  begin
    sqlQuery.ParamByName(campo).DataType := ftString;
    if valor <> '' then
      sqlQuery.ParamByName(campo).AsString := valor
    else
      sqlQuery.ParamByName(campo).Clear();
  end;

  //float
  if tipo = 'F' then
  begin
    sqlQuery.ParamByName(campo).DataType := ftCurrency;
    if TryStrToFloat(valor,fvalor) then
      sqlQuery.ParamByName(campo).AsCurrency := fvalor
    else
      sqlQuery.ParamByName(campo).Clear();
  end;

end;

procedure TDSAptServer.SetParamB(var sqlQuery: TFDQuery; campo: string;
  valor: TStringList);
var
  ms : TMemoryStream;
begin

  ms := TMemoryStream.Create;

  try

    TStringList(valor).SaveToStream(ms);

    ms.Position := 0;
    sqlQuery.ParamByName(campo).LoadFromStream(ms,ftOraClob);

  finally

    ms.Free;

  end;

end;

function TDSAptServer.f_demandalote_lst(p_fil_in_codigo, p_cmaq_in_codigo, p_mvs_st_loteforne: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_apt.f_demandalote_lst( :p_fil_in_codigo');
        SQL.Add('                                                  , :p_cmaq_in_codigo');
        SQL.Add('                                                  , :p_mvs_st_loteforne');
        SQL.Add('                                                  )) lst');

        SetParam(sqlQuery , 'p_fil_in_codigo'    , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_cmaq_in_codigo'   , 'I' , p_cmaq_in_codigo);
        SetParam(sqlQuery , 'p_mvs_st_loteforne' , 'S' , p_mvs_st_loteforne);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

function TDSAptServer.f_demandamaquina_lst(p_fil_in_codigo, p_cmaq_in_codigo: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_apt.f_demandamaquina_lst( :p_fil_in_codigo');
        SQL.Add('                                                     , :p_cmaq_in_codigo');
        SQL.Add('                                                     )) lst');

        SetParam(sqlQuery , 'p_fil_in_codigo'  , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_cmaq_in_codigo' , 'I' , p_cmaq_in_codigo);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

//M�quina Listar
function TDSAptServer.f_maquina_lst(fil_in_codigo, cmaq_in_codigo: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_apt.f_maquina_lst( :fil_in_codigo');
        SQL.Add('                                              , :cmaq_in_codigo');
        SQL.Add('                                              )) lst');

        SetParam(sqlQuery , 'fil_in_codigo'  , 'I' , fil_in_codigo);
        SetParam(sqlQuery , 'cmaq_in_codigo' , 'I' , cmaq_in_codigo);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

function TDSAptServer.f_apontamento_lst(p_apo_in_sequencia: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_apt.f_apontamento_lst(:p_apo_in_sequencia)) lst');

        SetParam(sqlQuery , 'p_apo_in_sequencia' , 'I' , p_apo_in_sequencia);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

procedure TDSAptServer.acceptp_apontarproducao_exe( p_fil_in_codigo, p_cmaq_in_codigo, p_ord_in_codigo, p_apo_re_quantidade : string);
var
  sqlQuery   : TFDQuery;
  jsonobject : TJSONObject;
  a          : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_apt.p_apontarproducao_exe( :p_fil_in_codigo');
      SQL.Add('                                           , :p_cmaq_in_codigo');
      SQL.Add('                                           , :p_ord_in_codigo');
      SQL.Add('                                           , :p_apo_re_quantidade');
      SQL.Add('                                           , :p_apo_in_sequencia');
      SQL.Add('                                           );');
      SQL.Add('end;');

      SetParam(sqlQuery  , 'p_fil_in_codigo'         , 'I' , p_fil_in_codigo);
      SetParam(sqlQuery  , 'p_cmaq_in_codigo'        , 'I' , p_cmaq_in_codigo);
      SetParam(sqlQuery  , 'p_ord_in_codigo'         , 'I' , p_ord_in_codigo);
      SetParam(sqlQuery  , 'p_apo_re_quantidade'     , 'F' , p_apo_re_quantidade);

      ParamByName('p_apo_in_sequencia').DataType  := ftInteger;
      ParamByName('p_apo_in_sequencia').ParamType := ptOutput;

      try

        ExecSQL;

        if (sqlQuery.ParamByName('p_apo_in_sequencia').AsInteger > 0) then
        begin

          jsonobject := TJSONObject.Create;
          jsonobject.AddPair('apo_in_sequencia',TJSONNumber.Create(sqlQuery.ParamByName('p_apo_in_sequencia').AsInteger));

          //a        := TJSONArray.Create;
          //a.Add(jsonobject);

          GetInvocationMetadata().ResponseCode    := 200;
          GetInvocationMetadata().ResponseContent := jsonobject.ToString;

        end;

      except
        on e: exception do
        begin
          GetInvocationMetadata.ResponseCode    := 417;
          GetInvocationMetadata.ResponseMessage := e.Message;
        end;
      end;

    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;

//Operador Listar
function TDSAptServer.f_operadormaquina_lst(fil_in_codigo,
  cmaq_in_codigo: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_apt.f_operadormaquina_lst( :fil_in_codigo');
        SQL.Add('                                                      , :cmaq_in_codigo');
        SQL.Add('                                                      )) lst');

        SetParam(sqlQuery , 'fil_in_codigo'  , 'I' , fil_in_codigo);
        SetParam(sqlQuery , 'cmaq_in_codigo' , 'I' , cmaq_in_codigo);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

function TDSAptServer.f_ordem_lst(p_fil_in_codigo,  p_ord_in_codigo: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_apt.f_ordem_lst( :p_fil_in_codigo');
        SQL.Add('                                            , :p_ord_in_codigo');
        SQL.Add('                                            )) lst');

        SetParam(sqlQuery , 'p_fil_in_codigo'  , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_ord_in_codigo'  , 'I' , p_ord_in_codigo);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

function TDSAptServer.f_recebimentoetq_lst(p_fil_in_codigo, p_rcb_st_nota, p_agn_st_cgc, p_pro_in_codigo, p_mvs_st_loteforne: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_mat.f_recebimentoetq_lst( :p_fil_in_codigo');
        SQL.Add('                                                     , :p_rcb_st_nota');
        SQL.Add('                                                     , :p_agn_st_cgc');
        SQL.Add('                                                     , :p_pro_in_codigo');
        SQL.Add('                                                     , :p_mvs_st_loteforne');
        SQL.Add('                                                     )) lst');

        SetParam(sqlQuery , 'p_fil_in_codigo'    , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_rcb_st_nota'      , 'S' , p_rcb_st_nota);
        SetParam(sqlQuery , 'p_agn_st_cgc'       , 'S' , p_agn_st_cgc);
        SetParam(sqlQuery , 'p_pro_in_codigo'    , 'I' , p_pro_in_codigo);
        SetParam(sqlQuery , 'p_mvs_st_loteforne' , 'S' , p_mvs_st_loteforne);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

procedure TDSAptServer.acceptp_demandamaquina_del(p_mqd_in_sequencia, p_mvs_re_quantidade: string);
var
  sqlQuery : TFDQuery;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_apt.p_demandamaquina_del( :p_mqd_in_sequencia');
      SQL.Add('                                          , :p_mvs_re_quantidade');
      SQL.Add('                                          );');
      SQL.Add('end;');

      SetParam(sqlQuery  , 'p_mqd_in_sequencia'  , 'I' , p_mqd_in_sequencia);
      SetParam(sqlQuery  , 'p_mvs_re_quantidade' , 'F' , p_mvs_re_quantidade);

      try
        ExecSQL;
      except
        on e: exception do
        begin
          GetInvocationMetadata.ResponseCode    := 417;
          GetInvocationMetadata.ResponseMessage := e.Message;
        end;
      end;

    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;

procedure TDSAptServer.acceptp_demandamaquina_ins(p_fil_in_codigo, p_cmaq_in_codigo, p_mvs_st_loteforne, p_mvs_re_quantidade: string);
var
  sqlQuery : TFDQuery;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_apt.p_demandamaquina_ins( :p_fil_in_codigo');
      SQL.Add('                                          , :p_cmaq_in_codigo');
      SQL.Add('                                          , :p_mvs_st_loteforne');
      SQL.Add('                                          , :p_mvs_re_quantidade');
      SQL.Add('                                          );');
      SQL.Add('end;');

      SetParam(sqlQuery  , 'p_fil_in_codigo'     , 'I' , p_fil_in_codigo);
      SetParam(sqlQuery  , 'p_cmaq_in_codigo'    , 'I' , p_cmaq_in_codigo);
      SetParam(sqlQuery  , 'p_mvs_st_loteforne'  , 'S' , p_mvs_st_loteforne);
      SetParam(sqlQuery  , 'p_mvs_re_quantidade' , 'F' , p_mvs_re_quantidade);

      try
        ExecSQL;
      except
        on e: exception do
        begin
          GetInvocationMetadata.ResponseContent := 'ERRO: ' + e.message;
        end;
      end;

    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;

procedure TDSAptServer.acceptp_encerrarproducao_exe(p_fil_in_codigo, p_cmaq_in_codigo, p_ord_in_codigo, p_apo_re_qtdeproduzidakg : string; jObject : TJSONArray);
var
  i          : Integer;
  XML        : TStringList;
  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem      : TJSONValue;
  chave      : string;
  valor      : string;
  sqlQuery   : TFDQuery;
  jsonobject : TJSONObject;
begin

  i   := 0;
  XML := TStringList.Create;

  XML.Add('<consumo>');

  if not(jObject.Null) then
  begin

    LJsonArr := jObject;
    for LJsonValue in LJsonArr do
    begin

      i := i + 1;
      XML.Add('  <demanda>');

      for LItem in TJSONArray(LJsonValue) do
      begin

        chave := UpperCase(TJSONPair(LItem).JsonString.Value);
        valor := TJSONPair(LItem).JsonValue.Value;

        XML.Add('<' + chave + '>' + valor + '</' + chave + '>');

      end;

      XML.Add('  </demanda>');

    end;

  end
  else
  begin

    XML.Add('  <demanda>');
    XML.Add('    <mqd_in_sequencia>0</mqd_in_sequencia>');
    XML.Add('    <mqd_re_qtdesaldokg>0</mqd_re_qtdesaldokg>');
    XML.Add('    <mqd_re_qtdeconsumidakg>0</mqd_re_qtdeconsumidakg>');
    XML.Add('    <mqd_re_devolver>0</mqd_re_devolver>');
    XML.Add('  </demanda>');

  end;

  XML.Add('</consumo>');

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_apt.p_encerrarproducao_exe( :p_fil_in_codigo');
      SQL.Add('                                            , :p_cmaq_in_codigo');
      SQL.Add('                                            , :p_ord_in_codigo');
      SQL.Add('                                            , :p_apo_re_qtdeproduzidakg');
      SQL.Add('                                            , :xml');
      SQL.Add('                                            );');
      SQL.Add('end;');

      SetParam(sqlQuery  , 'p_fil_in_codigo'          , 'I' , p_fil_in_codigo);
      SetParam(sqlQuery  , 'p_cmaq_in_codigo'         , 'I' , p_cmaq_in_codigo);
      SetParam(sqlQuery  , 'p_ord_in_codigo'          , 'I' , p_ord_in_codigo);
      SetParam(sqlQuery  , 'p_apo_re_qtdeproduzidakg' , 'F' , p_apo_re_qtdeproduzidakg);
      SetParamB(sqlQuery , 'xml'                      , XML);

      try
        ExecSQL;
      except
        on e: exception do
        begin
          GetInvocationMetadata.ResponseContent := 'ERRO: ' + e.message;
        end;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;

procedure TDSAptServer.acceptp_ordemmaquina_upd(p_fil_in_codigo, p_cmaq_in_codigo, p_ord_in_codigo: string);
var
  sqlQuery : TFDQuery;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_apt.p_ordemmaquina_upd( :p_fil_in_codigo');
      SQL.Add('                                        , :p_cmaq_in_codigo');
      SQL.Add('                                        , :p_ord_in_codigo');
      SQL.Add('                                        );');
      SQL.Add('end;');

      SetParam(sqlQuery  , 'p_fil_in_codigo'  , 'I' , p_fil_in_codigo);
      SetParam(sqlQuery  , 'p_cmaq_in_codigo' , 'I' , p_cmaq_in_codigo);
      SetParam(sqlQuery  , 'p_ord_in_codigo'  , 'I' , p_ord_in_codigo);

      try
        ExecSQL;
      except
        on e: exception do
        begin
          GetInvocationMetadata.ResponseCode    := 417;
          GetInvocationMetadata.ResponseMessage := e.Message;
        end;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;

procedure TDSAptServer.DataModuleCreate(Sender: TObject);
begin
  CarregaIni;
end;

procedure TDSAptServer.DataSetToJSONArray(var JSONArray : TJSONArray; sqlQuery : TFDQuery);
var
  jsonobject : TJSONObject;
  i          : Integer;
begin

  sqlQuery.First;
  while not(sqlQuery.Eof) do
  begin

    jsonobject := TJSONObject.Create;

    for i := 0 to sqlQuery.Fields.Count - 1 do
    begin

      if sqlQuery.Fields.Fields[i].DataType in [ftSmallint,ftInteger,ftFloat,ftCurrency,ftBCD,ftLargeint,ftFMTBcd,ftExtended] then
        jsonobject.AddPair(sqlQuery.Fields.Fields[i].FieldName,TJSONNumber.Create(sqlQuery.Fields.Fields[i].AsFloat))
      else
        jsonobject.AddPair(sqlQuery.Fields.Fields[i].FieldName,sqlQuery.Fields.Fields[i].AsString);

    end;

    JSONArray.Add(jsonobject);

    sqlQuery.Next;

  end;

end;

function TDSAptServer.Employee(const Key: string): TJSONArray;
var
  j : TJSONObject;
  r : TJSONObject;
  a : TJSONArray;
begin

  EmployeeTable.Close;
  if Key <> '' then
  begin
    EmployeeTable.ParamByName('employee_id').AsString := Key;
  end
  else
  begin
    EmployeeTable.ParamByName('employee_id').Clear;
  end;
  EmployeeTable.Open();

  a := TJSONArray.Create;
  r := TJSONObject.Create;

  r.AddPair('registros',a);

  while not(EmployeeTable.Eof) do
  begin

    j := TJSONObject.Create;

    j.AddPair('employee_id',TJSONNumber.Create(EmployeeTable.FieldByName('employee_id').AsInteger));

    a.Add(j);

    EmployeeTable.Next;

  end;

  EmployeeTable.Close;

  Result := a;

end;

function TDSAptServer.f_avisoetq_lst(p_fil_in_codigo, p_avr_st_nota, p_agn_st_cgc: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_mat.f_avisoetq_lst( :p_fil_in_codigo');
        SQL.Add('                                               , :p_avr_st_nota');
        SQL.Add('                                               , :p_agn_st_cgc');
        SQL.Add('                                               )) lst');

        SetParam(sqlQuery , 'p_fil_in_codigo'    , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_avr_st_nota'      , 'S' , p_avr_st_nota);
        SetParam(sqlQuery , 'p_agn_st_cgc'       , 'S' , p_agn_st_cgc);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

function TDSAptServer.f_aviso_itens_lst(
  p_fil_in_codigo,
  p_avr_st_nota,
  p_agn_st_cgc : string
) : TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('SELECT *');
        SQL.Add('  FROM   TABLE(');
        SQL.Add('           mgcustom.ia_pck_mat.f_aviso_itens_lst(');
        SQL.Add('             p_fil_in_codigo => :p_fil_in_codigo,');
        SQL.Add('             p_avr_st_nota   => :p_avr_st_nota,');
        SQL.Add('             p_agn_st_cgc    => :p_agn_st_cgc');
        SQL.Add('           )');
        SQL.Add('         )');

        SetParam(sqlQuery , 'p_fil_in_codigo', 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_avr_st_nota'  , 'S' , p_avr_st_nota);
        SetParam(sqlQuery , 'p_agn_st_cgc'   , 'S' , p_agn_st_cgc);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;
end;

function TDSAptServer.f_aviso_lst(p_fil_in_codigo, p_avr_st_nota, p_agn_st_cgc, p_avr_bo_itemaberto, p_avr_bo_itemdivergente, p_avr_bo_estoque : string) : TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('     , decode(lst.avr_bo_itemaberto,''S'',''Sim'',''N�o'') as avr_bo_itemaberto_dsc');
        SQL.Add('     , decode(lst.avr_bo_itemdivergente,''S'',''Sim'',''N�o'') as avr_bo_itemdivergente_dsc');
        SQL.Add('     , decode(lst.avr_bo_estoque,''S'',''Sim'',''N�o'') as avr_bo_estoque');
        SQL.Add('  from table(mgcustom.ia_pck_mat.f_aviso_lst( :p_fil_in_codigo');
        SQL.Add('                                            , :p_avr_st_nota');
        SQL.Add('                                            , :p_agn_st_cgc');
        SQL.Add('                                            , :p_avr_bo_itemaberto');
        SQL.Add('                                            , :p_avr_bo_itemdivergente');
        SQL.Add('                                            , :p_avr_bo_estoque');
        SQL.Add('                                            )) lst');

        SetParam(sqlQuery , 'p_fil_in_codigo'         , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_avr_st_nota'           , 'S' , p_avr_st_nota);
        SetParam(sqlQuery , 'p_agn_st_cgc'            , 'S' , p_agn_st_cgc);
        SetParam(sqlQuery , 'p_avr_bo_itemaberto'     , 'S' , p_avr_bo_itemaberto);
        SetParam(sqlQuery , 'p_avr_bo_itemdivergente' , 'S' , p_avr_bo_itemdivergente);
        SetParam(sqlQuery , 'p_avr_bo_estoque'        , 'S' , p_avr_bo_estoque);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;


procedure TDSAptServer.acceptp_aviso_itens_upd(
  p_objeto : TJSONArray
);
var
  sqlQuery : TFDQuery;
  obj : TJSONObject;
  LJsonValue : TJSONValue;
  LItem      : TJSONValue;
  chave: string;
  valor: string;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_mat.p_aviso_itens_upd(');
      SQL.Add('    p_fil_in_codigo => :p_fil_in_codigo,');
      SQL.Add('    p_avr_in_codigo => :p_avr_in_codigo,');
      SQL.Add('    p_iar_in_sequencia => :p_iar_in_sequencia,');
      SQL.Add('    p_iar_re_qtdcontada => replace(:p_iar_re_qtdcontada,'','',''.''),');
      SQL.Add('    p_iar_in_lotes => :p_iar_in_lotes');
      SQL.Add('  );');
      SQL.Add('end;');


      for LJsonValue in p_objeto do
      begin

        for LItem in TJSONArray(LJsonValue) do
        begin

          chave := UpperCase(TJSONPair(LItem).JsonString.Value);
          valor := TJSONPair(LItem).JsonValue.Value;
          SetParam(sqlQuery  , chave, 'S' , valor);

        end;

        try
          ExecSQL;
        except
          on e: exception do
          begin
            GetInvocationMetadata.ResponseCode    := 417;
            GetInvocationMetadata.ResponseMessage := e.Message;
          end;
        end;

      end;

    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;

function TDSAptServer.f_fornecedor_lst(
  p_fil_in_codigo,
  p_fornecedor_codigo : string
) : TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('SELECT *');
        SQL.Add('  FROM   TABLE(');
        SQL.Add('           mgcustom.ia_pck_mat.f_fornecedor(');
        SQL.Add('             p_fil_in_codigo     => :p_fil_in_codigo,');
        SQL.Add('             p_fornecedor_codigo => :p_fornecedor_codigo');
        SQL.Add('           )');
        SQL.Add('         )');

        SetParam(sqlQuery , 'p_fil_in_codigo'    , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_fornecedor_codigo', 'S' , p_fornecedor_codigo);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;
end;

function TDSAptServer.f_produto_lst(
  p_fil_in_codigo,
  p_produto_codigo : string
) : TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('SELECT *');
        SQL.Add('  FROM   TABLE(');
        SQL.Add('           mgcustom.ia_pck_mat.f_produto(');
        SQL.Add('             p_fil_in_codigo     => :p_fil_in_codigo,');
        SQL.Add('             p_produto_codigo => :p_produto_codigo');
        SQL.Add('           )');
        SQL.Add('         )');

        SetParam(sqlQuery , 'p_fil_in_codigo' , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_produto_codigo', 'S' , p_produto_codigo);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;
end;

function TDSAptServer.f_etiqueta_lst(
  p_fil_in_codigo,
  p_rcb_st_nota,
  p_agn_in_codigo,
  p_pro_in_codigo,
  p_mvs_st_loteforne : string
) : TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('SELECT *');
        SQL.Add('  FROM   TABLE(');
        SQL.Add('           mgcustom.ia_pck_mat.f_etiqueta_lst(');
        SQL.Add('             p_fil_in_codigo    => :p_fil_in_codigo,');
        SQL.Add('             p_rcb_st_nota      => :p_rcb_st_nota,');
        SQL.Add('             p_agn_in_codigo    => :p_agn_in_codigo,');
        SQL.Add('             p_pro_in_codigo    => :p_pro_in_codigo,');
        SQL.Add('             p_mvs_st_loteforne => :p_mvs_st_loteforne');
        SQL.Add('           )');
        SQL.Add('         )');

        SetParam(sqlQuery , 'p_fil_in_codigo'    , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_rcb_st_nota', 'S' , p_rcb_st_nota);
        SetParam(sqlQuery , 'p_agn_in_codigo', 'S' , p_agn_in_codigo);
        SetParam(sqlQuery , 'p_pro_in_codigo', 'S' , p_pro_in_codigo);
        SetParam(sqlQuery , 'p_mvs_st_loteforne', 'S' , p_mvs_st_loteforne);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;
end;

procedure TDSAptServer.acceptp_operadormaquina_del(p_fil_in_codigo, p_cmaq_in_codigo, p_opd_st_alternativo: string);
var
  sqlQuery : TFDQuery;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_apt.p_operadormaquina_del( :p_fil_in_codigo');
      SQL.Add('                                           , :p_cmaq_in_codigo');
      SQL.Add('                                           , :p_opd_st_alternativo');
      SQL.Add('                                           );');
      SQL.Add('end;');

      SetParam(sqlQuery  , 'p_fil_in_codigo'      , 'I' , p_fil_in_codigo);
      SetParam(sqlQuery  , 'p_cmaq_in_codigo'     , 'I' , p_cmaq_in_codigo);
      SetParam(sqlQuery  , 'p_opd_st_alternativo' , 'S' , p_opd_st_alternativo);

      try
        ExecSQL;
      except
        on e: exception do
        begin
          GetInvocationMetadata.ResponseCode    := 417;
          GetInvocationMetadata.ResponseMessage := e.Message;
        end;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;

procedure TDSAptServer.acceptp_operadormaquina_ins(p_fil_in_codigo, p_cmaq_in_codigo, p_opd_st_alternativo, p_opd_ch_funcao: string);
var
  sqlQuery : TFDQuery;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_apt.p_operadormaquina_ins( :p_fil_in_codigo');
      SQL.Add('                                           , :p_cmaq_in_codigo');
      SQL.Add('                                           , :p_opd_st_alternativo');
      SQL.Add('                                           , :p_opd_ch_funcao');
      SQL.Add('                                           );');
      SQL.Add('end;');

      SetParam(sqlQuery  , 'p_fil_in_codigo'      , 'I' , p_fil_in_codigo);
      SetParam(sqlQuery  , 'p_cmaq_in_codigo'     , 'I' , p_cmaq_in_codigo);
      SetParam(sqlQuery  , 'p_opd_st_alternativo' , 'S' , p_opd_st_alternativo);
      SetParam(sqlQuery  , 'p_opd_ch_funcao'      , 'S' , p_opd_ch_funcao);

      try
        ExecSQL;
      except
        on e: exception do
        begin
          GetInvocationMetadata.ResponseCode    := 417;
          GetInvocationMetadata.ResponseMessage := e.Message;
        end;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;


function TDSAptServer.f_etiqueta_processo_lst
  ( p_barcode
  , p_lote
  , p_unidade
  , p_quantidade
  , p_data
  , p_hora
  , p_operador
  , p_item_codigo
  , p_item_descricao
  , p_copia : string
  ) : TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select *');
        SQL.Add('  from Table(MGCUSTOM.IA_PCK_ETIQUETA.F_Processo');
        SQL.Add('    ( :p_barcode');
        SQL.Add('    , :p_lote');
        SQL.Add('    , :p_unidade');
        SQL.Add('    , :p_quantidade');
        SQL.Add('    , :p_data');
        SQL.Add('    , :p_hora');
        SQL.Add('    , :p_operador');
        SQL.Add('    , :p_item_codigo');
        SQL.Add('    , :p_item_descricao');
        SQL.Add('    , :p_copia');
        SQL.Add('    ))');
        SetParam(sqlQuery  , 'p_barcode'        , 'S' , p_barcode);
        SetParam(sqlQuery  , 'p_lote'           , 'S' , p_lote);
        SetParam(sqlQuery  , 'p_unidade'        , 'S' , p_unidade);
        SetParam(sqlQuery  , 'p_quantidade'     , 'S' , p_quantidade);
        SetParam(sqlQuery  , 'p_data'           , 'S' , p_data);
        SetParam(sqlQuery  , 'p_hora'           , 'S' , p_hora);
        SetParam(sqlQuery  , 'p_operador'       , 'S' , p_operador);
        SetParam(sqlQuery  , 'p_item_codigo'    , 'S' , p_item_codigo);
        SetParam(sqlQuery  , 'p_item_descricao' , 'S' , p_item_descricao);
        SetParam(sqlQuery  , 'p_copia'          , 'S' , p_copia);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin

        GetInvocationMetadata.ResponseContentType := 'text/xml; charset=utf-8';
        GetInvocationMetadata().ResponseContent   := sqlQuery.FieldByName('COLUMN_VALUE').AsString;

      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := nil;

  end;

end;


function TDSAptServer.f_etiqueta_recebimento_lst
  ( p_lote
  , p_status
  , p_nota_fiscal
  , p_data
  , p_inspecao
  , p_barcode
  , p_copia : string
  ) : TJSONArray;
var
  sqlQuery : TFDQuery;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select *');
        SQL.Add('  from Table(MGCUSTOM.IA_PCK_ETIQUETA.F_Recebimento');
        SQL.Add('    ( :p_lote');
        SQL.Add('    , :p_status');
        SQL.Add('    , :p_nota_fiscal');
        SQL.Add('    , :p_data');
        SQL.Add('    , :p_inspecao');
        SQL.Add('    , :p_barcode');
        SQL.Add('    , :p_copia');
        SQL.Add('    ))');
        SetParam(sqlQuery  , 'p_lote'        , 'S' , p_lote);
        SetParam(sqlQuery  , 'p_status'      , 'S' , p_status);
        SetParam(sqlQuery  , 'p_nota_fiscal' , 'S' , p_nota_fiscal);
        SetParam(sqlQuery  , 'p_data'        , 'S' , p_data);
        SetParam(sqlQuery  , 'p_inspecao'    , 'S' , p_inspecao);
        SetParam(sqlQuery  , 'p_barcode'     , 'S' , p_barcode);
        SetParam(sqlQuery  , 'p_copia'       , 'S' , p_copia);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin

        GetInvocationMetadata.ResponseContentType := 'text/xml; charset=utf-8';
        GetInvocationMetadata().ResponseContent   := sqlQuery.FieldByName('COLUMN_VALUE').AsString;

      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := nil;
  end;

end;

Function StringToStream(const AString: string): TStream;
var utf8: utf8string;
begin
  utf8:= utf8encode(AString);
  Result:= TStringStream.Create(utf8);
end;


function TDSAptServer.f_etiqueta_produtoacabado_lst
  ( p_etiq_in_id
  , p_item_descricao
  , p_inspecao
  , p_embalador
  , p_operador
  , p_data
  , p_lote
  , p_barcode
  , p_quantidade
  , p_tampa
  , p_cor
  , p_copia : string
  ) : TJSONArray;
var
  sqlQuery : TFDQuery;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select *');
        SQL.Add('  from Table(MGCUSTOM.IA_PCK_ETIQUETA.F_ProdutoAcabado');
        SQL.Add('    ( :p_etiq_in_id');
        SQL.Add('    , :p_item_descricao');
        SQL.Add('    , :p_inspecao');
        SQL.Add('    , :p_embalador');
        SQL.Add('    , :p_operador');
        SQL.Add('    , :p_data');
        SQL.Add('    , :p_lote');
        SQL.Add('    , :p_barcode');
        SQL.Add('    , :p_quantidade');
        SQL.Add('    , :p_tampa');
        SQL.Add('    , :p_cor');
        SQL.Add('    , :p_copia');
        SQL.Add('    ))');
        SetParam(sqlQuery  , 'p_etiq_in_id'     , 'I' , p_etiq_in_id);
        SetParam(sqlQuery  , 'p_item_descricao' , 'S' , p_item_descricao);
        SetParam(sqlQuery  , 'p_inspecao'       , 'S' , p_inspecao);
        SetParam(sqlQuery  , 'p_embalador'      , 'S' , p_embalador);
        SetParam(sqlQuery  , 'p_operador'       , 'S' , p_operador);
        SetParam(sqlQuery  , 'p_data'           , 'S' , p_data);
        SetParam(sqlQuery  , 'p_lote'           , 'S' , p_lote);
        SetParam(sqlQuery  , 'p_barcode'        , 'S' , p_barcode);
        SetParam(sqlQuery  , 'p_quantidade'     , 'S' , p_quantidade);
        SetParam(sqlQuery  , 'p_tampa'          , 'S' , p_tampa);
        SetParam(sqlQuery  , 'p_cor'            , 'S' , p_cor);
        SetParam(sqlQuery  , 'p_copia'          , 'S' , p_copia);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin

        GetInvocationMetadata.ResponseContentType := 'text/xml; charset=utf-8';
        GetInvocationMetadata().ResponseContent   := sqlQuery.FieldByName('COLUMN_VALUE').AsString;

      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := nil;

  end;

end;

function TDSAptServer.f_encerrarproducao_lst(p_fil_in_codigo, p_cmaq_in_codigo: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_apt.f_encerrarproducao_lst( :p_fil_in_codigo');
        SQL.Add('                                                       , :p_cmaq_in_codigo');
        SQL.Add('                                                       )) lst');

        SetParam(sqlQuery , 'p_fil_in_codigo'    , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_cmaq_in_codigo'   , 'I' , p_cmaq_in_codigo);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

function TDSAptServer.f_etiqueta_aluminio_lst
  ( p_item_descricao
  , p_inspecao
  , p_data
  , p_lote
  , p_barcode
  , p_quantidade
  , p_tampa
  , p_cor
  , p_copia : string
  ) : TJSONArray;
var
  sqlQuery : TFDQuery;
begin

  sqlQuery := TFDQuery.Create(Self);

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select *');
        SQL.Add('  from Table(MGCUSTOM.IA_PCK_ETIQUETA.F_Aluminio');
        SQL.Add('    ( :p_item_descricao');
        SQL.Add('    , :p_inspecao');
        SQL.Add('    , :p_data');
        SQL.Add('    , :p_lote');
        SQL.Add('    , :p_barcode');
        SQL.Add('    , :p_quantidade');
        SQL.Add('    , :p_tampa');
        SQL.Add('    , :p_cor');
        SQL.Add('    , :p_copia');
        SQL.Add('    ))');
        SetParam(sqlQuery  , 'p_item_descricao' , 'S' , p_item_descricao);
        SetParam(sqlQuery  , 'p_inspecao'       , 'S' , p_inspecao);
        SetParam(sqlQuery  , 'p_data'           , 'S' , p_data);
        SetParam(sqlQuery  , 'p_lote'           , 'S' , p_lote);
        SetParam(sqlQuery  , 'p_barcode'        , 'S' , p_barcode);
        SetParam(sqlQuery  , 'p_quantidade'     , 'S' , p_quantidade);
        SetParam(sqlQuery  , 'p_tampa'          , 'S' , p_tampa);
        SetParam(sqlQuery  , 'p_cor'            , 'S' , p_cor);
        SetParam(sqlQuery  , 'p_copia'          , 'S' , p_copia);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin

        GetInvocationMetadata.ResponseContentType := 'text/xml; charset=utf-8';
        GetInvocationMetadata().ResponseContent   := sqlQuery.FieldByName('COLUMN_VALUE').AsString;

      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := nil;
  end;

end;


function TDSAptServer.f_impressorama_lst( p_fil_in_codigo
                                        , p_cmaq_in_codigo : string
                                        ) : TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;

begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select *');
        SQL.Add('  from Table(MGCUSTOM.IA_PCK_ETIQUETA.F_ImpressoraMa_Lst');
        SQL.Add('    ( :p_fil_in_codigo');
        SQL.Add('    , :p_cmaq_in_codigo');
        SQL.Add('    ))');
        SetParam(sqlQuery  , 'p_fil_in_codigo'  , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery  , 'p_cmaq_in_codigo' , 'I' , p_cmaq_in_codigo);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;


function TDSAptServer.f_impressoragr_lst : TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_etiqueta.f_impressoragr_lst) lst');

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

function TDSAptServer.f_encerrarconsumo_lst(p_fil_in_codigo, p_cmaq_in_codigo: string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('select lst.*');
        SQL.Add('  from table(mgcustom.ia_pck_apt.f_encerrarconsumo_lst( :p_fil_in_codigo');
        SQL.Add('                                                       , :p_cmaq_in_codigo');
        SQL.Add('                                                       )) lst');

        SetParam(sqlQuery , 'p_fil_in_codigo'    , 'I' , p_fil_in_codigo);
        SetParam(sqlQuery , 'p_cmaq_in_codigo'   , 'I' , p_cmaq_in_codigo);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;



procedure TDSAptServer.acceptp_encerrarconsumo_exe( p_fil_in_codigo
                                                  , p_cmaq_in_codigo
                                                  , p_ord_in_codigo
                                                  , p_apo_re_qtdeproduzidakg
                                                  , p_apo_re_qtdeconsumidakg
                                                  , p_apo_re_qtdeempenhadakg
                                                  , p_apo_re_qtdesaldokg : string
                                                  ; p_apo_in_sequencia : string
                                                  ; jObject : TJSONArray
                                                  );
var
  i          : Integer;
  XML        : TStringList;
  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem      : TJSONValue;
  chave      : string;
  valor      : string;
  sqlQuery   : TFDQuery;
  jsonobject : TJSONObject;
begin

  i   := 0;
  XML := TStringList.Create;

  XML.Add('<consumo>');

  if not(jObject.Null) then
  begin

    LJsonArr := jObject;
    for LJsonValue in LJsonArr do
    begin

      i := i + 1;
      XML.Add('  <demanda>');

      for LItem in TJSONArray(LJsonValue) do
      begin

        chave := UpperCase(TJSONPair(LItem).JsonString.Value);
        valor := TJSONPair(LItem).JsonValue.Value;

        XML.Add('<' + chave + '>' + valor + '</' + chave + '>');

      end;

      XML.Add('  </demanda>');

    end;

  end
  else
  begin

    XML.Add('  <demanda>');
    XML.Add('    <mqd_re_qtdeinfo>0</mqd_re_qtdeinfo>');
    XML.Add('    <mqd_in_sequencia>0</mqd_in_sequencia>');
    XML.Add('  </demanda>');

  end;

  XML.Add('</consumo>');

  sqlQuery := TFDQuery.Create(Self);

  try

    FDConnection.Open();

    with sqlQuery do
    begin

      Close;

      Connection := FDConnection;

      SQL.Clear;

      SQL.Add('begin');
      SQL.Add('  mgcustom.ia_pck_apt.p_encerrarconsumo_exe( :p_fil_in_codigo');
      SQL.Add('                                           , :p_cmaq_in_codigo');
      SQL.Add('                                           , :p_ord_in_codigo');
      SQL.Add('                                           , :p_apo_re_qtdeproduzidakg');
      SQL.Add('                                           , :p_apo_re_qtdeconsumidakg');
      SQL.Add('                                           , :p_apo_re_qtdeempenhadakg');
      SQL.Add('                                           , :p_apo_re_qtdesaldokg');
      SQL.Add('                                           , :xml');
      SQL.Add('                                           , :p_apo_in_sequencia');
      SQL.Add('                                           );');
      SQL.Add('end;');

      SetParam(sqlQuery  , 'p_fil_in_codigo'          , 'I' , p_fil_in_codigo);
      SetParam(sqlQuery  , 'p_cmaq_in_codigo'         , 'I' , p_cmaq_in_codigo);
      SetParam(sqlQuery  , 'p_ord_in_codigo'          , 'I' , p_ord_in_codigo);
      SetParam(sqlQuery  , 'p_apo_re_qtdeproduzidakg' , 'F' , p_apo_re_qtdeproduzidakg);
      SetParam(sqlQuery  , 'p_apo_re_qtdeconsumidakg' , 'F' , p_apo_re_qtdeconsumidakg);
      SetParam(sqlQuery  , 'p_apo_re_qtdeempenhadakg' , 'F' , p_apo_re_qtdeempenhadakg);
      SetParam(sqlQuery  , 'p_apo_re_qtdesaldokg'     , 'F' , p_apo_re_qtdesaldokg);
      SetParam(sqlQuery  , 'p_apo_re_qtdesaldokg'     , 'F' , p_apo_re_qtdesaldokg);
      SetParamB(sqlQuery , 'xml'                      , XML);
      SetParam(sqlQuery  , 'p_apo_in_sequencia'       , 'I' , p_apo_in_sequencia);

      ParamByName('p_apo_in_sequencia').DataType  := ftInteger;
      ParamByName('p_apo_in_sequencia').ParamType := ptOutput;

      try

        ExecSQL;

        jsonobject := TJSONObject.Create;
        jsonobject.AddPair('apo_in_sequencia',TJSONNumber.Create(sqlQuery.ParamByName('p_apo_in_sequencia').AsInteger));

        GetInvocationMetadata().ResponseCode    := 200;
        GetInvocationMetadata().ResponseContent := jsonobject.ToString;

      except
        on e: exception do
        begin
          GetInvocationMetadata.ResponseCode    := 417;
          GetInvocationMetadata.ResponseMessage := e.Message;
        end;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

  end;

end;

function TDSAptServer.f_impressao_lst(p_imp_st_servidor : string): TJSONArray;
var
  sqlQuery : TFDQuery;
  a        : TJSONArray;
begin

  sqlQuery := TFDQuery.Create(Self);
  a        := TJSONArray.Create;

  try

    try

      FDConnection.Open();

      with sqlQuery do
      begin

        Close;

        Connection := FDConnection;

        SQL.Clear;

        SQL.Add('SELECT *');
        SQL.Add('FROM   TABLE(MGCUSTOM.IA_PCK_IMPRESSORA.F_WS_IMPRESSAO_LST(P_IMP_ST_SERVIDOR => :P_IMP_ST_SERVIDOR))');

        SetParam(sqlQuery , 'P_IMP_ST_SERVIDOR'  , 'S' , p_imp_st_servidor);

        Open();

      end;

      if sqlQuery.IsEmpty = False then
      begin
        DataSetToJSONArray(a,sqlQuery);
      end;

    except
      on e: exception do
      begin
        GetInvocationMetadata.ResponseCode    := 417;
        GetInvocationMetadata.ResponseMessage := e.Message;
      end;
    end;

  finally

    sqlQuery.Close;
    sqlQuery.Free;

    FDConnection.Close;

    Result := a;

  end;

end;

procedure TDSAptServer.acceptp_followup_lst(pParams : String);
var
  i          : Integer;
  XML        : TStringList;
  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem      : TJSONValue;
  chave      : string;
  valor      : string;
  sqlQuery   : TFDQuery;
  jsonobject : TJSONObject;

  a        : TJSONArray;

  resultStream : TStream;
  stringStream : TStringList;

  teste : TStringStream;

begin

  FDConnection.Open();

  sqlQuery := TFDQuery.Create(Self);
  with sqlQuery do
  begin
    Close;

    Connection := FDConnection;

    SQL.Clear;

    SQL.Add('begin');
    SQL.Add('  mgcustom.ia_pck_ws_man_padrao.p_maquina_ordem_lst(');
    SQL.Add('    p_params => :p_params,');
    SQL.Add('    p_result => :p_result);');
    SQL.Add('end;');

    XML := TStringList.Create;
    XML.Add(pParams);

    SetParamB(sqlQuery ,'p_params', XML);

    ParamByName('p_result').DataType  := ftCursor;
    ParamByName('p_result').ParamType := ptOutput;

    Open;
  end;

  a := TJSONArray.Create;
  DataSetToJSONArray(a,sqlQuery);

  GetInvocationMetadata().ResponseCode    := 200;
  GetInvocationMetadata().ResponseContent := a.ToString;

end;

procedure TDSAptServer.acceptp_maquina_lst;
var
  i          : Integer;
  XML        : TStringList;
  LJsonArr   : TJSONArray;
  LJsonValue : TJSONValue;
  LItem      : TJSONValue;
  chave      : string;
  valor      : string;
  sqlQuery   : TFDQuery;
  jsonobject : TJSONObject;

  a            : TJSONArray;

  resultStream : TStream;
  stringStream : TStringList;

  teste : TStringStream;

begin

  FDConnection.Open();

  sqlQuery := TFDQuery.Create(Self);
  with sqlQuery do
  begin
    Close;

    Connection := FDConnection;

    SQL.Clear;

    SQL.Add('begin');
    SQL.Add('  mgcustom.ia_pck_ws_man_padrao.p_maquina_lst(');
    SQL.Add('    p_params => :p_params,');
    SQL.Add('    p_result => :p_result);');
    SQL.Add('end;');

    XML := TStringList.Create;
    XML.Add('<parametros>');
    XML.Add('    <org_in_codigo>2</org_in_codigo>');
    XML.Add('</parametros>');

    SetParamB(sqlQuery ,'p_params', XML);

    ParamByName('p_result').DataType  := ftCursor;
    ParamByName('p_result').ParamType := ptOutput;

    Open;
  end;

  a := TJSONArray.Create;
  DataSetToJSONArray(a,sqlQuery);

  GetInvocationMetadata().ResponseCode    := 200;
  GetInvocationMetadata().ResponseContent := a.ToString;

end;

end.

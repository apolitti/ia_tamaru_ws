object DSAptServer: TDSAptServer
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 353
  Width = 423
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=mgcustom'
      'Password=megacustom'
      'DriverID=Ora')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object EmployeeTable: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select e.*'
      '  from hr.employees e'
      ' where e.employee_id = nvl(:employee_id,e.employee_id)')
    Left = 40
    Top = 64
    ParamData = <
      item
        Name = 'EMPLOYEE_ID'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
    object EmployeeTableEMPLOYEE_ID: TBCDField
      FieldName = 'EMPLOYEE_ID'
      Origin = 'EMPLOYEE_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Precision = 6
      Size = 0
    end
    object EmployeeTableFIRST_NAME: TStringField
      FieldName = 'FIRST_NAME'
      Origin = 'FIRST_NAME'
    end
    object EmployeeTableLAST_NAME: TStringField
      FieldName = 'LAST_NAME'
      Origin = 'LAST_NAME'
      Required = True
      Size = 25
    end
    object EmployeeTableEMAIL: TStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Required = True
      Size = 25
    end
    object EmployeeTablePHONE_NUMBER: TStringField
      FieldName = 'PHONE_NUMBER'
      Origin = 'PHONE_NUMBER'
    end
    object EmployeeTableHIRE_DATE: TDateTimeField
      FieldName = 'HIRE_DATE'
      Origin = 'HIRE_DATE'
      Required = True
    end
    object EmployeeTableJOB_ID: TStringField
      FieldName = 'JOB_ID'
      Origin = 'JOB_ID'
      Required = True
      Size = 10
    end
    object EmployeeTableSALARY: TBCDField
      FieldName = 'SALARY'
      Origin = 'SALARY'
      Precision = 8
      Size = 2
    end
    object EmployeeTableCOMMISSION_PCT: TBCDField
      FieldName = 'COMMISSION_PCT'
      Origin = 'COMMISSION_PCT'
      Precision = 2
      Size = 2
    end
    object EmployeeTableMANAGER_ID: TBCDField
      FieldName = 'MANAGER_ID'
      Origin = 'MANAGER_ID'
      Precision = 6
      Size = 0
    end
    object EmployeeTableDEPARTMENT_ID: TBCDField
      FieldName = 'DEPARTMENT_ID'
      Origin = 'DEPARTMENT_ID'
      Precision = 4
      Size = 0
    end
  end
end

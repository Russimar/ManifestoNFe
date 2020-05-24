object DMConection: TDMConection
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 264
  Width = 400
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Database=D:\Easy2Solutions\Gestao\Dados\Manifesto.FDB'
      'Password=masterkey'
      'CharacterSet=win1252'
      'Port=3050'
      'Server=localhost'
      'DriverID=FB')
    LoginPrompt = False
    Left = 32
    Top = 16
  end
end

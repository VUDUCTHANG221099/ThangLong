--TEST ACCESS ON TABLE FOR USER SV2
USE PhanQuyen
GO
SELECT * FROM  fn_my_permissions('[dbo].[HT_Role]','object')
SELECT * FROM  fn_my_permissions('[dbo].[HT_RoleUser]','object')
SELECT * FROM  fn_my_permissions('[dbo].[HT_User]','object')
--TEST ACCESS ON TABLE FOR USER SV2
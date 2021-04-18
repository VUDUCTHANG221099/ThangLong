----TEST BACKUP
--USE PhanQuyen 
--SELECT * FROM fn_my_permissions (NULL, 'DATABASE');  
--GO
----TEST BACKUP


----TEST CREATE DATABASE NEW
--USE master 
--SELECT * FROM fn_my_permissions (NULL, 'DATABASE');  
--GO
----TEST CREATE DATABASE NEW

--TEST ACCESS ON TABLE FOR USER SV1
--USE PhanQuyen
--GO
--select * from fn_my_permissions('[dbo].[HT_Role]','object')
--select * from fn_my_permissions('[dbo].[HT_RoleUser]','object')
--select * from fn_my_permissions('[dbo].[HT_User]','object')
--TEST ACCESS ON TABLE FOR USER SV1

--CREATE BACKUP
--USE master
--GO
--BACKUP DATABASE PhanQuyen
--TO DISK = 'D:\PhanQuyen.bak';
--CREATE BACKUP
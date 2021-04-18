--DATABASE
--USE master
--GO
--IF EXISTS (SELECT NAME FROM SYS.DATABASES  WHERE NAME='PhanQuyen')
--DROP DATABASE PhanQuyen
--GO
--CREATE DATABASE PhanQuyen
--GO

--USE PhanQuyen
--GO

--CREATE TABLE	HT_Role(
--				MaRole						tinyint						NOT NULL				PRIMARY KEY,
--				TenRole						nvarchar(50)				NOT NULL,
--				Mota						nvarchar(500),				
--)
--GO

--CREATE TABLE	HT_User(
--				TenDangNhap					varchar(20)					NOT NULL				PRIMARY KEY,
--				MaDonVi						varchar(10)					NOT NULL,
--				HangDKV						char(1),
--				MaDKV						varchar(20),
--				MatKhau						varchar(150)				NOT NULL,
--				HoTen						nvarchar(50)				NOT NULL,
--				Ten							nvarchar(50)				NOT NULL,
--				NgaySinh					date						NOT NULL,
--				SoCMT						varchar(15),
--)
--GO

--CREATE TABLE	HT_RoleUser(
--				MaRole						tinyint						NOT NULL,		
--				TenDangNhap					varchar(20)					NOT NULL,
--				CONSTRAINT	PK_HT_RoleUser PRIMARY KEY (MaRole, TenDangNhap),
--				CONSTRAINT	PK_HT_Role_HT_RoleUser FOREIGN KEY		(MaRole)			REFERENCES		HT_Role(MaRole),
--				CONSTRAINT	PK_HT_User_HT_RoleUser FOREIGN KEY		(TenDangNhap)		REFERENCES		HT_User(TenDangNhap),					
--)
--GO
--DATABASE

--CREATE LOGIN SinhVien1 AND USER OF SinhVien1 
--USE master
--GO
--CREATE LOGIN SinhVien1 WITH PASSWORD='1'
--USE PhanQuyen
--GO
--CREATE USER SV1 FOR LOGIN SinhVien1
--CREATE LOGIN SinhVien1 AND USER OF SinhVien1

--CREATE LOGIN SinhVien2 AND USER OF SinhVien2
--USE master
--GO
--CREATE LOGIN [DESKTOP-60K45M6\ThangVu] FROM WINDOWS
--USE PhanQuyen
--GO
--CREATE USER SV2 FOR LOGIN [DESKTOP-60K45M6\ThangVu]
--CREATE LOGIN SinhVien2 AND USER OF SinhVien2

--GRANT TABLE HT_User AND HT_RoleUser Select, Insert, Update, Delete TO USER OF SV1
--USE PhanQuyen
--GO
--GRANT Select, Insert, Update, Delete ON [dbo].[HT_Role] TO SV1
--GRANT Select, Insert, Update, Delete ON  [dbo].[HT_RoleUser] TO SV1
--GRANT TABLE HT_User AND HT_RoleUser Select, Insert, Update, Delete TO USER OF SV1

--GRANT BACKUP TO USER OF SV1
--USE PhanQuyen
--GO
--exec sp_addrolemember 'Db_backupoperator','SV1'
--exec sp_addrolemember 'Db_ddladmin','SV1'
--GRANT BACKUP TO USER OF SV1

--LOGIN SinhVien1 BACKUP
--USE master
--GO
--BACKUP DATABASE PhanQuyen 
--TO DISK = 'PhanQuyen.bak';
--LOGIN SinhVien1 BACKUP

--GRANT TABLE HT_User Select AND TABLE HT_Role, HT_RoleUser Select, Insert, Update, Delete TO USER OR SV2
--USE PhanQuyen
--GO
--GRANT Select ON [dbo].[HT_User] TO SV2
--GRANT Select, Insert, Update, Delete ON [dbo].[HT_Role] TO SV2
--GRANT Select, Insert, Update, Delete ON [dbo].[HT_RoleUser] TO SV2
--GRANT TABLE HT_User SELECT AND TABLE HT_Role, HT_RoleUser Select, Insert, Update, Delete TO USER OR SV2

--TEST GRANT LOGIN SinhVien1
--USE PhanQuyen
--GO
--SELECT * FROM fn_my_permissions('[dbo].[HT_Role]','object')
--SELECT * FROM fn_my_permissions('[dbo].[HT_RoleUser]','object')
--TEST GRANT LOGIN SinhVien1

--TEST GRANT LOGIN ACCOUNT SinhVien2 OF WINDOWS
--USE PhanQuyen
--GO
--SELECT * FROM fn_my_permissions('[dbo].[HT_User]','object')
--SELECT * FROM fn_my_permissions('[dbo].[HT_Role]','object')
--SELECT * FROM fn_my_permissions('[dbo].[HT_RoleUser]','object')
--TEST GRANT LOGIN ACCOUNT SinhVien2 OF WINDOWS

----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

--CREATE LOGIN UserA AND USER OF UserA
--USE master
--GO
--CREATE LOGIN UserA WITH PASSWORD='1'
--USE PhanQuyen
--GO
--CREATE USER USER1 FOR LOGIN UserA
--CREATE LOGIN UserA AND USER OF UserA

--CREATE LOGIN UserB AND USER OF UserB
--USE master
--GO
--CREATE LOGIN UserB WITH PASSWORD='1'
--USE PhanQuyen
--GO
--CREATE USER USER2 FOR LOGIN UserB
--CREATE LOGIN UserB AND USER OF UserB


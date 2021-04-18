--Bài 1 a)
--DATABASE
--USE master
--GO
--IF EXISTS (SELECT NAME FROM SYS.DATABASES  WHERE NAME='DanhMuc')
--DROP DATABASE DanhMuc
--GO
--CREATE DATABASE DanhMuc
--GO

--USE DanhMuc
--GO

--CREATE TABLE	DM_QuocGia(
--				MaQG						char(2)						NOT NULL				PRIMARY KEY,
--				ThuTu						int							NOT NULL,
--				TenNuoc_TA					nvarchar(250)				NOT NULL,
--				TenNuoc_TV					nvarchar(250)				NOT NULL,				
--)
--GO

--CREATE TABLE	DM_TinhThanh(
--				MaTinhThanh					varchar(3)					NOT NULL				PRIMARY KEY,
--				MaQG						char(2)						NOT NULL,
--				ThuTu						int							NOT NULL,
--				TenTinhThanh_TA					nvarchar(250)				NOT NULL,
--				TenTinhThanh_TV					nvarchar(250)				NOT NULL,		
--				CONSTRAINT	PK_DM_QuocGia_DM_TinhThanh FOREIGN KEY		(MaQG)			REFERENCES		DM_QuocGia(MaQG),
								
--)
--GO

--CREATE TABLE	DM_DonVi_DK(
--				MaDonVi						varchar(20)					NOT NULL				PRIMARY KEY,
--				MaTinhThanh					varchar(3)					NOT NULL,
--				QuyenCapGCN					bit							NOT NULL,
--				DiaChi						nvarchar(250)				NOT NULL,
--				DienThoai					varchar(15),
--				Fax							varchar(15),
--				TenDonVi_TA					varchar(250)				NOT NULL,
--				TenDonVi_TV					varchar(250)				NOT NULL,
--				KyHieuDV					nvarchar(3)					NOT NULL,
--				CONSTRAINT	PK_DM_TinhThanh_DM_DonVi_DK FOREIGN KEY		(MaTinhThanh)		REFERENCES		DM_TinhThanh(MaTinhThanh),	
--)
--GO
--DATABASE

--b)
--Tạo 2 user login
--CREATE LOGIN A32323_1 AND USER OF A32323_1 
--USE master
--GO
--CREATE LOGIN SinhVien1 WITH PASSWORD='1'
--USE DanhMuc
--GO
--CREATE USER SV1 FOR LOGIN A32323_1
--CREATE LOGIN A32323_1 AND USER OF A32323_1 

--CREATE LOGIN A32323_2 AND USER OF A32323_2
--USE master
--GO
--CREATE LOGIN [PC5501\A32323_2] FROM WINDOWS
--USE DanhMuc
--GO
--CREATE USER SV2 FOR LOGIN [PC5501\A32323_2]
--CREATE LOGIN SinhVien2 AND USER OF SinhVien2
--Tạo 2 user login

--User A32323_1 có quyền Backup CSDL trên hệ quản trị.
--USE DanhMuc
--GO
--exec sp_addrolemember 'Db_backupoperator','SV1'
--exec sp_addrolemember 'Db_ddladmin','SV1'
--User A32323_1 có quyền Backup CSDL trên hệ quản trị.

--User  A32323_1:có  quyền  Select,  Insert,  Update,  Delete  trên  bảng DM_QuocGia và DM_TinhThanh.
--USE DanhMuc
--GO
--GRANT Select, Insert, Update, Delete ON [dbo].[DM_QuocGia] TO SV1
--GRANT Select, Insert, Update, Delete ON [dbo].[DM_TinhThanh] TO SV1
--User  A32323_1:có  quyền  Select,  Insert,  Update,  Delete  trên  bảng DM_QuocGia và DM_TinhThanh.

--Có  quyền  Select  trên  bảng DM_QuocGia,  DM_TinhThanh  và  quyền  Select,  Insert,  Update,  Delete  trên bảng DM_DonVi_DK
--USE DanhMuc
--GO
--GRANT Select ON [dbo].[DM_QuocGia] TO SV2
--GRANT Select ON [dbo].[DM_TinhThanh] TO SV2
--GRANT Select, Insert,  Update,  Delete  ON [dbo].[DM_DonVi_DK] TO SV2
--Có  quyền  Select  trên  bảng DM_QuocGia,  DM_TinhThanh  và  quyền  Select,  Insert,  Update,  Delete  trên bảng DM_DonVi_DK

---------------------------------------------------------------------------------------------------------------------------------
--Bài 2:
--Khởi tạo login
--CREATE LOGIN UserA AND USER OF UserA
--USE master
--GO
--CREATE LOGIN UserA WITH PASSWORD='1'
--Login A32323_1 trước khi chạy câu lệnh phía dưới
--USE DanhMuc
--GO
--CREATE USER USER1 FOR LOGIN UserA
--CREATE LOGIN UserA AND USER OF UserA

--CREATE LOGIN UserB AND USER OF UserB
--USE master
--GO
--Login A32323_1 trước khi chạy câu lệnh phía dưới
--CREATE LOGIN UserB WITH PASSWORD='1'
--USE DanhMuc
--GO
--CREATE USER USER2 FOR LOGIN UserB
--CREATE LOGIN UserB AND USER OF UserB
--Khởi tạo login


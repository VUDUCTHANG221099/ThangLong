﻿--Thực hiện các câu lệnh để phân quyền
--USE DanhMuc 
--GO
--SELECT * FROM fn_my_permissions('[dbo].[DM_QuocGia]','object')
--SELECT * FROM fn_my_permissions('[dbo].[DM_TinhThanh]','object')
--Thực hiện các câu lệnh để phân quyền

--Login A32323_1 thực hiện Backup
--USE master
--GO
--BACKUP DATABASE DanhMuc 
--TO DISK = 'D:\PhanQuyen.bak';
--Login A32323_1 thực hiện Backup
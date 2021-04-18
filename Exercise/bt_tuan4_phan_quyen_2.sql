--use master
--go
--create login SinhVien1 with password='004040'

--use master
--go
--create login [pc5502\SinhVien2] from Windows


--use PhanQuyen
--go	
--create user sv1 for login SinhVien1


--use PhanQuyen
--go
--grant backup database to sv1

--use PhanQuyen
--go
--exec sp_addrolemember 'Db_backupoperator','sv1'
--exec sp_addrolemember 'Db_ddladmin','sv1'

--go
--grant select, insert, update, delete on HT_User to sv1
--grant select, insert, update, delete on HT_RoleUser to sv1
--deny select on HT_Role to sv1

--go
--create user sv2 for login [pc5502\SinhVien2]
--grant select on HT_User to sv2
--grant select, insert, update, delete on HT_Role to sv2
--grant select, insert, update, delete on HT_RoleUser to sv2

--Backup database [PhanQuyen] 
--to disk = 'D:\PhanQuyen.bak' 

--bai2

--create login userA with password='004040'
--create user UserA for login userA
--Dang nhap voi Sinhvien1 de phan quyen cho userA
--use master
--grant create any database to userA

--use PhanQuyen
--exec sp_addrolemember 'db_owner', 'UserA'
--grant create table to UserA with grant option

--Cap quyen chon, them tren bang HT_Role, cho phep sinh vien 2 cap quyen nay cho cac login khac
--use PhanQuyen
--grant select, insert on HT_Role to [pc5502\SinhVien2] with grant option


--create login userB with password='004040'
--create user UserB for login userB

--Dang nhap userA 
--use PhanQuyen
--grant create table on database::PhanQuyen to userB 


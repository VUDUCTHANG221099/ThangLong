--use master
--go
--create login SinhVien1 with password='1'
--exec sp_addsrvrolemember 'SinhVien1','securityadmin'---có quyền  quyền cấp mới user và phân quyền cho các user khác


--use PhanQuyen
--go
--create user dbSinhVien1 from login SinhVien1
--grant create table to dbSinhVien1 with grant option-- có quyền tạo mới bảng trong PhanQUyen
--exec sp_addrolemember 'Db_backupoperator','dbSinhVien1'-- có quyền backupcsdl
--exec sp_addsrvrolemember 'SinhVien1','Dbcreator'---có quyền tạo mới CSDL
--grant Select, Insert, Update, Delete on HT_User to dbSinhVien1 with grant option--phan quyen
--grant Select, Insert, Update, Delete on HT_RoleUser to dbSinhVien1 with grant option--phan quyen

-----------Phân quyền cho SinhVien2---
--use master
--go
--create login [huynh\SinhVien2] from windows
--use PhanQuyen
--go
--create user dbSinhVien2 from login [huynh\SinhVien2]
--grant select on HT_User to dbSinhVien2 with grant option
--grant Select, Insert, Update, Delete on HT_Role to dbSinhVien2 with grant option
--grant Select, Insert, Update, Delete on HT_RoleUser  to dbSinhVien2 with grant option
-----------------------------------đăng nhập vào SinhVien1 và sinh viên 2 để  để kiểm tra------------
/*use master 
go
select * from fn_my_permissions(null,null)-- kiểm tra quyền tạo data base
use PhanQuyen
go
select * from fn_my_permissions(null,'database')-- kiểm tra quyền tạo bảng, quyền backup*/

--select * from fn_my_permissions('tên bảng,'object')-- kiểm tra quyền trên bảng
--------------------------------------------bài2------------------------------------------
--use master
--go
--create login userA with password='1'
--create login userB with password='1'

---- đăng nhập vào sinhvien1 để phân quyền cho userA 
--exec sp_addsrvrolemember 'userA','Dbcreator'
-----quay trở lại sa--------------
--use PhanQuyen
--go
--create user dbuserA from login userA
--go
--create user dbuserB from login userB
-------------đăng nhập vào sinhvien1---------------
--use PhanQuyen
--go
--grant create table to dbuserA with grant option

---------------đăng nhập vào userA------------
--use PhanQuyen
--go
--grant create table to dbuserB with grant option

--------------đăng nhập vào sinh viene2----------
--use PhanQuyen
--go
--grant select, insert on HT_Role to dbuserB
-------------quay lại SinhVien1 để thu hồi-------------
--use PhanQuyen
--go
--revoke create table to dbuserA  CASCADE

---------------------------------------------------------------------
--use Northwind
--go
--create trigger dbo.insertToOrderr
--on [dbo].[Orders]
--after INSERT
--as
--begin
--	declare @customerID nchar(5)
--	declare @EmployeeID int
--	declare @orderDate datetime
--	declare @requiredDate datetime
--	declare @ShipperDate datetime
--	declare @shipVia int
--	declare @freight money
--	declare @shipName nvarchar(40)
--	declare @shipAddress nvarchar(60)
--	declare @shipcity nvarchar(15)
--	declare @shipregion nvarchar(15)
--	declare @shipPostalcode nvarchar(10)
--	declare @shipcountry nvarchar(15)
--	declare @country nvarchar(15)
--	select @country=Country
--	from inserted as i inner join dbo.Customers as C on i.CustomerID=C.CustomerID
--	if(@country='France')
--		begin
--			print 'khong the them m?i '
--			rollback tran
--		end
--	else
--	begin
--		insert into dbo.Orders values(@customerID,@EmployeeID,@orderDate,@requiredDate,@ShipperDate,@shipVia,@freight,@shipName,@shipAddress,@shipcity,@shipregion,@shipPostalcode,
--		@shipcountry)---tất cả các trường trong bảng order
--	end
--end
--go
--select * from dbo.Customers
--select * from dbo.Orders
--go
--insert into dbo.Orders values('BOTTM',3,'1996-07-11 00:00:00.000','1996-08-09 00:00:00.000','1996-07-17 00:00:00.000',2,'148.33','Chop-suey Chinese','Carrera 22 con Ave. Carlos Soublette #8-35','San Cristóbal','Táchira','5022','Venezuela')
--go
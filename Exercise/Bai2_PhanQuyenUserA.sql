﻿------Cấp quyền Login
--exec sp_addsrvrolemember 'userA','Dbcreator'
--Phân quyền Backup để userA có thể backup 
--USE DanhMuc
--GO
--exec sp_addrolemember 'Db_backupoperator','User1'
--exec sp_addrolemember 'Db_ddladmin','User1'
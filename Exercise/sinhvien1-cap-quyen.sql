use master
grant create any database to userA

use PhanQuyen
grant create table to UserA with grant option

exec sp_addrolemember 'db_owner', 'UserA'
exec sp_droprolemember'db_owner', 'UserA'

exec sp_addrolemember 'db_owner', 'UserB'
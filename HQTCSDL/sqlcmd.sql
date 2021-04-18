----Sử dụng câu lệnh SQLCMD để chạy và hiển thị kết quả của câu truy vấn “SELECT COUNT(*) FROM Customers” 
----ra màn hình cửa sổ dòng lệnh của Window
kết nối với SQL Server bằng sqlcmd (kết nối với máy cục bộ)
	sqlcmd -S NAME_PC\SQLEXPRESS -E
kết nối với SQL Server bằng sqlcmd (kết nối với một account)
	sqlcmd -S NAME_PC\SQLEXPRESS -U account 
Kiểm tra cơ sở dữ liệu hiện tại trong sqlcmd
	SELECT DB_NAME()
	GO
liệt kê các cơ sở dữ liệu trong sqlcmd
	SELECT NAME FROM SYS.DATABASES
	GO
	Sp_databases
	Go

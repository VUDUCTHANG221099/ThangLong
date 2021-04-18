------------------------------------Define the cursor------------------------------------
--USE Northwind
--GO
--DECLARE orders_cursor CURSOR
--FOR
--SELECT OrderID FROM Orders
--	ORDER BY OrderID
------------------------------------Remove the cursor------------------------------------
----DEALLOCATE orders_cursor------------------------------------------------------------------------------------------
------------------------------------Using Cursor Data------------------------------------
--USE Northwind
--GO
------Local variables
--DECLARE @order_num INT;
------Define the cursor--DECLARE orders_cursor CURSOR
--FOR
--SELECT orderID FROM orders ORDER BY orderID;------Open cursor (retrieve data)--OPEN orders_cursor------Perform the first fetch (get first row)--	FETCH NEXT FROM orders_cursor INTO @order_num;--	WHILE @@FETCH_STATUS=0
--	BEGIN
--		PRINT @order_Num
--		FETCH NEXT FROM orders_cursor INTO @order_num;
--	END------Close cursor--CLOSE orders_cursor------And finally, remove it--DEALLOCATE orders_cursor;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Trên CSDL Northwind, viết một thủ tục (SP) sử dụng Cursor đọc dữ liệu 
----từ bảng Employees và in ra màn hình thông tin về nhân viên: Mã nhân viên, 
----Tên nhân viên (FirstName + LastName) và Ngày vào công ty (Hirdate). Hiển thị 
----Ngày vào công ty theo dạng dd/mm/yyyy.--USE Northwind
--GO
--CREATE PROC HienThiNhanVien
--AS
--BEGIN
--	DECLARE @EmployeeID INT;
--	DECLARE @HoTen NVARCHAR(50);
--	DECLARE @NgayVaoCT VARCHAR(10);
--	DECLARE employee_cursor CURSOR
--	FOR
--		SELECT E.EmployeeID,E.FirstName+' '+E.LastName AS HoTen,
--				CONVERT(VARCHAR(10),E.HireDate,103) AS NgayVaoCT
--		FROM Employees E
--	OPEN employee_cursor;
--		FETCH NEXT FROM employee_cursor INTO @EmployeeID,@HoTen,@NgayVaoCT;
--		WHILE @@FETCH_STATUS = 0
--			BEGIN
--				PRINT CAST(@EmployeeID AS VARCHAR)+' '+@HoTen+' '+@NgayVaoCT
--				FETCH NEXT FROM employee_cursor INTO @EmployeeID,@HoTen,@NgayVaoCT;
--			END
--	CLOSE employee_cursor
--	DEALLOCATE employee_cursor
--RETURN
--END
----DROP PROC HienThiNhanVien---------------------------------------------------------------------------------------------------------
----Viết một thủ tục sử dụng Cursor thực hiện các công việc sau:
----a)Liệt kê, in danh sách khách hàng (Mã khách hàng, Tên khách hàng).
----b)Với mỗi khách hàng liệt kê, in danh sách hoá đơn với các thông tin:
---- mã hoá đơn (OrderID), Ngày hoá đơn (OrderDate), số lượng sản phẩm và số tiền
----  của mỗi hoá đơn (Quantity * UnitPrice * (1-Discount)) đó.
---------------------------------------------------------------------------------------------------------
----a)Liệt kê, in danh sách khách hàng (Mã khách hàng, Tên khách hàng).
--USE Northwind
--GO
--CREATE PROC Display_customers
--AS
--BEGIN
--	DECLARE @CustomerID nchar(5);
--	DECLARE @ContactName nvarchar(40)
--	DECLARE customer_cursor CURSOR
--	FOR
--		SELECT C.CustomerID,C.ContactName
--		FROM Customers C
--	--OPEN CURSOR
--	OPEN customer_cursor
--		FETCH NEXT FROM customer_cursor INTO @CustomerID,@ContactName
--		WHILE @@FETCH_STATUS=0
--			BEGIN
--				PRINT @CustomerID+' '+@ContactName;
--				FETCH NEXT FROM customer_cursor INTO @CustomerID,@ContactName
--			END
--	--CLOSE CURSOS
--	CLOSE customer_cursor
--	DEALLOCATE customer_cursor;
--RETURN
--END
--------PRINT Display_customers
----EXEC Display_customers
---------------------------------------------------------------------------------------------------------
----b)Với mỗi khách hàng liệt kê, in danh sách hoá đơn với các thông tin:
---- mã hoá đơn (OrderID), Ngày hoá đơn (OrderDate), số lượng sản phẩm và số tiền
----  của mỗi hoá đơn (Quantity * UnitPrice * (1-Discount)) đó.
CREATE PROC Display_customers_order
AS
BEGIN
	DECLARE @CustomerID		nchar(5);
	DECLARE @ContactName	nvarchar(40)
	DECLARE customer_cursor CURSOR -------CURSOR 1
	FOR
		SELECT C.CustomerID,C.ContactName
		FROM Customers C
	--OPEN CURSOR customer_cursor
	OPEN customer_cursor
		FETCH NEXT FROM customer_cursor INTO @CustomerID,@ContactName
		WHILE @@FETCH_STATUS=0
			BEGIN
				PRINT @CustomerID+' '+@ContactName;
				FETCH NEXT FROM customer_cursor INTO @CustomerID,@ContactName
				--CREATE DECLARE 
				DECLARE @orderID		INT
				DECLARE @orderDate		DATE
				DECLARE @slsp			INT
				DECLARE @tongtien		FLOAT
				--CREATE DECLARE 
				--CREATE CURSOR 2
				DECLARE orders_cursor CURSOR
				FOR
					SELECT O.OrderID,O.OrderDate,COUNT(OD.ProductID)AS slsp,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS tongtien
					FROM Orders O,[Order Details] OD
					WHERE O.OrderID=OD.OrderID AND O.CustomerID=@CustomerID
					GROUP BY O.OrderID,O.OrderDate
					--OPEN CURSOR orders_cursor
				OPEN orders_cursor
					FETCH NEXT FROM orders_cursor INTO @orderID,@orderDate,@slsp,@tongtien
					WHILE @@FETCH_STATUS=0
						BEGIN
							PRINT ' '+CONVERT(VARCHAR,@orderID)+CONVERT(VARCHAR,@orderDate,103)+
							' '+CONVERT(VARCHAR,@slsp)+CONVERT(VARCHAR,@tongtien)
							FETCH NEXT FROM orders_cursor INTO @orderID,@orderDate,@slsp,@tongtien
						END
					--CLOSE CURSOS  orders_cursor
				CLOSE orders_cursor
				DEALLOCATE orders_cursor;
			END
	--CLOSE CURSOS customer_cursor
	CLOSE customer_cursor
	DEALLOCATE customer_cursor;
RETURN
END
--------PRINT Display_customers_order
----EXEC Display_customers_order
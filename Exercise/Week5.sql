----Define the cursor
--DECLARE @order_num INT
--DECLARE orders_cursor CURSOR
--FOR
--SELECT O.OrderID, O.OrderDate 
--FROM Orders O
----Open cursor (retrieve data)
--OPEN orders_cursor
---- Perform the first fetch (get first row)
--	FETCH NEXT FROM orders_cursor INTO @order_num;
--	WHILE @@FETCH_STATUS=0
--		BEGIN
--			PRINT @order_num
--			FETCH NEXT FROM orders_cursor INTO @order_num;
--		END
---- Close cursor
--CLOSE orders_cursor
---- Remove the cursor
--DEALLOCATE orders_cursor
----Define the cursor
-------------------------------------------------------------------------
--Nested Cursor FALSE
--DECLARE @CustID			NCHAR(5);
--DECLARE @CompanyName	NVARCHAR(30)
--DECLARE @OrderID		INT
--DECLARE @OrderDate		DATETIME
--DECLARE CustomerCursor CURSOR 
--FOR
--SELECT C.CustomerID,C.CompanyName
--FROM Customers C
--OPEN CustomerCursor
--FETCH NEXT FROM CustomerCursor INTO @CustID,@CompanyName
--WHILE @@FETCH_STATUS=0
--	BEGIN
--		DECLARE OrderCursor CURSOR 
--		FOR 
--		SELECT O.OrderID, O.OrderDate
--		FROM Orders O WHERE CustomerID=@CustID
--		OPEN OrderCursor
--		FETCH NEXT FROM OrderCursor INTO @OrderID,@OrderDate
--		WHILE @@FETCH_STATUS=0
--			BEGIN
--				SELECT @OrderID,@OrderDate
--				FETCH NEXT FROM OrderCursor INTO @OrderID,@OrderDate
--			END
--		CLOSE OrderCursor
--		DEALLOCATE OrderCursor
--		FETCH NEXT FROM CustomerCursor INTO @CustID,@CompanyName
--	END
--CLOSE CustomerCursor
--DEALLOCATE CustomerCursor
--Nested Cursor  FALSE
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
--Trên CSDL Northwind, viết một thủ tục (SP) sử dụng Cursor đọc dữ liệu 
--từ bảng Employees và in ra màn hình thông tin về nhân viên: Mã nhân viên, 
--Tên nhân viên (FirstName + LastName) và Ngày vào công ty (Hirdate). Hiển thị 
--Ngày vào công ty theo dạng dd/mm/yyyy.
--USE NORTHWND
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
--	FETCH NEXT FROM employee_cursor INTO @EmployeeID,@HoTen,@NgayVaoCT;
--	WHILE @@FETCH_STATUS = 0
--		BEGIN
--			PRINT CAST(@EmployeeID AS VARCHAR)+' '+@HoTen+' '+@NgayVaoCT
--			FETCH NEXT FROM employee_cursor INTO @EmployeeID,@HoTen,@NgayVaoCT;
--		END
--	CLOSE employee_cursor
--	DEALLOCATE employee_cursor
--RETURN
--END
--DROP PROC HienThiNhanVien

-------------------------------------------------------------------------
--Viết một thủ tục với kiểu dữ liệu đầu ra (output) là Cursor. Cursor chứa câu 
--truy vấn liệt kê danh sách mã nhân viên (EmployeeID), tên nhân viên có hoá đơn và
-- số lượng hoá đơn của nhân viên đó.
-------------------------------------------------------------------------
--Viết một thủ tục sử dụng Cursor thực hiện các công việc sau:
--Liệt kê, in danh sách khách hàng (Mã khách hàng, Tên khách hàng).
--Với mỗi khách hàng liệt kê, in danh sách hoá đơn với các thông tin:
-- mã hoá đơn (OrderID), Ngày hoá đơn (OrderDate), số lượng sản phẩm và số tiền
--  của mỗi hoá đơn (Quantity * UnitPrice * (1-Discount)) đó.
--USE Northwind
--GO
----Liệt kê, in danh sách khách hàng (Mã khách hàng, Tên khách hàng).
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

----PRINT Display_customers
--EXEC Display_customers
--DROP PROC Display_customers
--------------------------------------------------------------------------------------------------
--Với mỗi khách hàng liệt kê, in danh sách hoá đơn với các thông tin:
-- mã hoá đơn (OrderID), Ngày hoá đơn (OrderDate), số lượng sản phẩm và số tiền
-- của mỗi hoá đơn (Quantity * UnitPrice * (1-Discount)) đó.

USE Northwind
GO
--Liệt kê, in danh sách khách hàng (Mã khách hàng, Tên khách hàng).
CREATE PROC Display_customers_order
AS
BEGIN
	DECLARE @CustomerID		nchar(5);
	DECLARE @ContactName	nvarchar(40)
	DECLARE customer_cursor CURSOR
	FOR
		SELECT C.CustomerID,C.ContactName
		FROM Customers C
	--OPEN CURSOR
	OPEN customer_cursor
		FETCH NEXT FROM customer_cursor INTO @CustomerID,@ContactName
		WHILE @@FETCH_STATUS=0
			BEGIN
				PRINT @CustomerID+' '+@ContactName;
				FETCH NEXT FROM customer_cursor INTO @CustomerID,@ContactName
				--CREADTE DECLARE 
				DECLARE @orderID		INT
				DECLARE @orderDate		DATE
				DECLARE @slsp			INT
				DECLARE @tongtien		FLOAT
				--CREADTE DECLARE 
				--CREATE CURSOR
				DECLARE orders_cursor CURSOR
				FOR
					SELECT O.OrderID,O.OrderDate,COUNT(OD.ProductID)AS slsp,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS tongtien
					FROM Orders O,[Order Details] OD
					WHERE O.OrderID=OD.OrderID AND O.CustomerID=@CustomerID
					GROUP BY O.OrderID,O.OrderDate
					--OPEN customer_cursor
					OPEN orders_cursor
						FETCH NEXT FROM orders_cursor INTO @orderID,@orderDate,@slsp,@tongtien
						WHILE @@FETCH_STATUS=0
							BEGIN
								PRINT ' '+CONVERT(VARCHAR,@orderID)+CONVERT(VARCHAR,@orderDate,103)+
								' '+CONVERT(VARCHAR,@slsp)+CONVERT(VARCHAR,@tongtien)
								FETCH NEXT FROM orders_cursor INTO @orderID,@orderDate,@slsp,@tongtien
							END
					--CLOSE CURSOS
					CLOSE orders_cursor
					DEALLOCATE orders_cursor;
			END
	--CLOSE CURSOS
	CLOSE customer_cursor
	DEALLOCATE customer_cursor;
RETURN
END



------PRINT Display_customers
--EXEC Display_customers_order
--DROP PROC Display_customers_order
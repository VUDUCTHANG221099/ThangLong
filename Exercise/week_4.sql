----Creating stored procedures 
--CREATE PROC spShippers
--AS
--SELECT *FROM Shippers
----EXEC spShippers
----Creating stored procedures 
-----------------------------------------------------------------------------------------------------------
----Change/Drop Stored Procedures
--ALTER PROC spShippers
--AS
--SELECT *FROM Shippers
--DROP PROC spShippers
----Change/Drop Stored Procedures
-----------------------------------------------------------------------------------------------------------
----Working with Parameters
--USE Northwind
--GO
--CREATE PROC dbo.usp_GetCustOrders
--	@custid		AS NCHAR(5),
--	@fromdate	AS DATETIME,
--	@todate		AS DATETIME
--AS
--SELECT OrderID,CustomerID,EmployeeID,OrderDate
--FROM [dbo].[Orders]
--WHERE CustomerID=@custid AND OrderDate>=@fromdate AND OrderDate<@todate
--GO
----EXEC dbo.usp_GetCustOrders N'ALFKI','01-01-1997','12-31-1999'
----Working with Parameters
-----------------------------------------------------------------------------------------------------------
----Supplying Default Values
--ALTER PROC dbo.usp_GetCustOrders
--	@custid		AS NCHAR(5),
--	@fromdate	AS DATETIME='19000101',
--	@todate		AS DATETIME='99991231'
--AS
--SET NOCOUNT ON;
--SELECT OrderID, CustomerID, EmployeeID, OrderDate
--FROM dbo.Orders
--WHERE CustomerID= @custid AND OrderDate >= @fromdate AND OrderDate< @todate;
--GO
--EXEC dbo.usp_GetCustOrders N'ALFKI'
----Supplying Default Values
-----------------------------------------------------------------------------------------------------------
----Output Parameters
--ALTER PROC dbo.usp_GetCustOrders
--	@custid AS NCHAR(5),
--	@fromdate AS DATETIME= '19000101',
--	@todate AS DATETIME= '99991231',
--	@numrows AS INT OUTPUT
--AS
--SET NOCOUNT ON
--SELECT OrderID, CustomerID, EmployeeID, OrderDate
--FROM dbo.Orders
--WHERE CustomerID= @custid AND OrderDate >= @fromdate AND OrderDate< @todate;
--SELECT @numrows= @@rowcount;
--GO
----Output Parameters
--DECLARE @mynumrows AS INT;
--EXEC dbo.usp_GetCustOrders
--@custid=N'ALFKI',
--@fromdate= '19970101',
--@todate= '19980101',
--@numrows= @mynumrows OUTPUT;
--SELECT @mynumrows AS rc;
----Output Parameters
-----------------------------------------------------------------------------------------------------------
--Recursion
--CREATE PROC spFactorial @ValueIn int, @ValueOut int 
--OUTPUT
--AS
--	DECLARE @InWorking int
--	DECLARE @OutWorking int
--IF @ValueIn != 1
--	BEGIN
--		SELECT @InWorking = @ValueIn - 1
--		EXEC spFactorial @InWorking, @OutWorking OUTPUT
--		SELECT @ValueOut = @ValueIn * @OutWorking
--	END
--ELSE
--	BEGIN
--		SELECT @ValueOut = 1
--	END
--RETURN
----Input
--DECLARE @WorkingOut int
--DECLARE @WorkingIn int
--SELECT @WorkingIn = 5
--EXEC spFactorial @WorkingIn, @WorkingOut
--OUTPUT
--PRINT CAST(@WorkingIn AS varchar) + ' factorial is ' + CAST(@WorkingOut AS varchar)
----Recursion
-----------------------------------------------------------------------------------------------------------
----Scalar UDFs
--CREATE FUNCTION dbo.Dayonly(@Date datetime)
--RETURNS VARCHAR(12) 
--AS
--BEGIN
--	RETURN CONVERT(VARCHAR(12),@Date,101)
--END
--GO
----Scalar UDFs
--SELECT * FROM Orders
--WHERE dbo.DayOnly(OrderDate) =dbo.DayOnly(GETDATE())
----Scalar UDFs
-----------------------------------------------------------------------------------------------------------
--Table-valued UDFs
--CREATE FUNCTION dbo.fn_GetCustOrders(@cid AS NCHAR(5)) 
--	RETURNS TABLE
--AS
--RETURN SELECT OrderID, CustomerID, EmployeeID, OrderDate,
--			RequiredDate,ShippedDate, ShipVia, Freight,
--			ShipName, ShipAddress, ShipCity,
--			ShipRegion, ShipPostalCode, ShipCountry
--FROM dbo.Orders
--WHERE CustomerID= @cid
--GO
----Table-valued UDFs
--SELECT O.OrderID, O.CustomerID, OD.ProductID, OD.Quantity
--FROM dbo.fn_GetCustOrders(N'ALFKI') AS O JOIN [Order Details] AS OD ON O.OrderID= OD.OrderID;
----Table-valued UDFs--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Trên CSDL Northwind, viết 1 thủ tục (Stored Procedure) trả về thông tin của khách hàng với tham số đầu vào là mã khách hàng (CustomerID)--USE Northwind--GO--CREATE PROC dbo.usp_GetCustomers--	@custid AS NCHAR(5)--AS--SELECT * FROM [dbo].[Customers]--WHERE CustomerID=@custid----EXEC dbo.usp_GetCustomers 'ALFKI'----DROP PROC dbo.usp_GetCustomers-------------------------------------------------------------------------------------------------------------Trên CSDL Northwind, viết một thủ tục thêm mới dữ liệu vào bảng Territories với các tham số đầu vào là --Territory ID, Territory Description và Region ID.--USE Northwind--GO--CREATE PROC dbo.usp_Territories--	@Territory_ID AS nvarchar(20),--	@Territory_Description AS nchar(50),
--	@Region_ID AS INT 
--AS
--BEGIN
--	INSERT INTO  Territories(TerritoryID,TerritoryDescription,RegionID)
--	VALUES(@Territory_ID,@Territory_Description,@Region_ID);
--END
----EXEC dbo.usp_Territories 'Vietnam','Hanoi',1000;
----DROP PROC dbo.usp_Territories
-----------------------------------------------------------------------------------------------------------
--Viết một thủ tục đệ quy tính tổng dãy số của một số (triangular) nguyên.
--Đầu vào: Một số nguyên n (n=5)
--Đầu ra: Tổng của dãy số T=n+ (n-1) + ... + 1.(ví dụ với n=5, T=5+4+3+2+1)
--CREATE PROC sptriangular @ValueIn INT, @ValueOut INT 
--OUTPUT
--AS
--DECLARE @InWorking  INT
--DECLARE @OutWorking INT
--IF @ValueIn!=1
--	BEGIN
--		SELECT @InWorking=@ValueIn-1
--		EXEC sptriangular @InWorking,@OutWorking OUTPUT
--		SELECT @ValueOut = @ValueIn + @OutWorking
--	END
--ELSE
--	BEGIN
--		SELECT @ValueOut = 1
--	END
--RETURN
--Input and Output
--DECLARE @WorkingOut int
--DECLARE @WorkingIn int
--SELECT @WorkingIn = 5
--EXEC sptriangular @WorkingIn, @WorkingOut 
--OUTPUT
--PRINT CAST(@WorkingIn AS varchar) + ' triangular is ' + CAST(@WorkingOut AS varchar)
-----------------------------------------------------------------------------------------------------------
--Trên CSDL Northwind, viết một hàm  với:
--Đầu vào: Mã khách hàng (CustomerID)
--Đầu ra: Chuỗi ký tự chứa danh sách mã hoá đơn (OrderID) của khách hàng. Mỗi mã hoá đơn cách nhau bởi dấu ‘;’
--GetListHoaDon
--------------------------------------No need to run function--------------------------------------
USE Northwind
GO
CREATE FUNCTION dbo.GetListHoaDon (@CustID NCHAR(5))
RETURNS VARCHAR(500)
AS
BEGIN	
	DECLARE @ls VARCHAR(500)
	SET @ls=''
	SELECT @ls=@ls+CONVERT(varchar,O.OrderID)+'; '
	FROM Orders O
	WHERE O.CustomerID=@CustID
	RETURN @ls
END
GO
--GetListHoaDon
------
--GetListSoLuongHoaDon
USE Northwind
GO
CREATE FUNCTION dbo.GetListSoLuongHoaDon (@CustID NCHAR(5))
RETURNS INT 
AS
BEGIN	
	DECLARE @ls INT
	SET @ls=0
	SELECT @ls=COUNT(O.OrderID)
	FROM Orders O
	WHERE O.CustomerID=@CustID
	RETURN @ls
END
GO
--GetListSoLuongHoaDon
--------------------------------------No need to run function--------------------------------------
--DSHoaDon
SELECT dbo.GetListHoaDon('ALFKI') AS DSHoaDon
--DSHoaDon of
----------------------------
--DSHoaDon AND DLHoaDon
SELECT C.CustomerID, dbo.GetListHoaDon(CustomerID) AS DSHD, dbo.GetListSoLuongHoaDon(CustomerID) AS SLHD
FROM Customers C

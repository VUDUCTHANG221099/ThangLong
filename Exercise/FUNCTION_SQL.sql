--Create/Drop Stored Procedures
--USE Northwind
--Go
--CREATE PROC spShippers
--AS
--SELECT * FROM Shippers
--spShippers
--DROP PROC spShippers
--Parameters
--CREATE PROC dbo.usp_GetCustOrders
--@custid  AS NCHAR(5),
--@fromdate AS DATETIME,
--@todate  AS DATETIME
--AS
--SELECT OrderID, CustomerID, EmployeeID, OrderDate
--FROM dbo.Orders
--WHERE CustomerID = @custid
--AND OrderDate >= @fromdate
--AND OrderDate < @todate;
--EXEC dbo.usp_GetCustOrders N'ALFKI', '01-01-1997','12-31-1999'
--Supplying Default Values
--USE Northwind
--Go
--ALTER PROC dbo.usp_GetCustOrders
--@custid  AS NCHAR(5),
--@fromdate AS DATETIME = '19000101',
--@todate  AS DATETIME = '99991231'
--AS
--SET NOCOUNT ON;
--SELECT OrderID, CustomerID, EmployeeID, OrderDate
--FROM dbo.Orders
--WHERE CustomerID = @custid
--AND OrderDate >= @fromdate
--AND OrderDate < @todate;
--GO
--EXEC dbo.usp_GetCustOrders N'ALFKI'
--Output Parameters
--ALTER PROC dbo.usp_GetCustOrders
--@custid  AS NCHAR(5),
--@fromdate AS DATETIME = '19000101',
--@todate  AS DATETIME = '99991231',
--@numrows  AS INT OUTPUT
--AS
--SET NOCOUNT ON
--SELECT OrderID, CustomerID, EmployeeID, OrderDate
--FROM dbo.Orders
--WHERE CustomerID = @custid
--AND OrderDate >= @fromdate
--AND OrderDate < @todate;
--SELECT @numrows = @@rowcount;
--GO
--DECLARE @mynumrows AS INT;
--EXEC dbo.usp_GetCustOrders
--@custid  = N'ALFKI',
--@fromdate = '19970101',
--@todate  = '19980101',
--@numrows  = @mynumrows OUTPUT;
--SELECT @mynumrows AS rc;
--Return Statement
--ALTER PROC dbo.usp_GetCustOrders
--@custid  AS NCHAR(5),
--@fromdate AS DATETIME = '19000101',
--@todate  AS DATETIME = '99991231',
--@numrows  AS INT OUTPUT
--AS
--SET NOCOUNT ON
--DECLARE @err INT
--SELECT OrderID, CustomerID, EmployeeID, OrderDate
--FROM dbo.Orders
--WHERE CustomerID = @custid
--AND OrderDate >= @fromdate
--AND OrderDate < @todate;
--SELECT @numrows = @@rowcount; @err = @@error 
--Return @err
--GO
--DECLARE @myerr AS INT, @mynumrows AS INT;
--EXEC @myerr = dbo.usp_GetCustOrders
--@custid  = N'ALFKI',
--@fromdate = '19970101',
--@todate  = '19980101',
--@numrows  = @mynumrows OUTPUT;
--SELECT @myerr AS err, @mynumrows AS rc;
--Execute As
--USE master
--GO
--CREATE LOGIN USER1 WITH PASSWORD='1'
--USE Northwind
--GO
--CREATE USER USERS FOR LOGIN USER1

--FUNCTION Scalar UDFs
CREATE FUNCTION dbo.Dayonly(@Date datetime)
RETURNS VARCHAR(12) 
AS
BEGIN
	RETURN CONVERT(VARCHAR(12),@Date,101)
END
--------
USE Northwind
GO
SELECT *FROM Orders
WHERE dbo.Dayonly(OrderDate)=dbo.Dayonly(GETDATE())
--DROP FUNCTION dbo.Dayonly
--FUNCTION Table-valued UDFs
USE Northwind
GO
 CREATE FUNCTION dbo.fn_GetCustOrders(@cid AS NCHAR(5))
RETURNS TABLE
AS

	RETURN 
		SELECT OrderID, CustomerID, EmployeeID, OrderDate,
		RequiredDate,ShippedDate, ShipVia, Freight,
		ShipName, ShipAddress, ShipCity,
		ShipRegion, ShipPostalCode, ShipCountry
		FROM dbo.Orders
		WHERE CustomerID = @cid;

SELECT O.OrderID, O.CustomerID, OD.ProductID, OD.Quantity
FROM dbo.fn_GetCustOrders(N'ALFKI') AS O
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID;
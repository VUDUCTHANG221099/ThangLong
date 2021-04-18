--Trên CSDL Northwind, viết 1 thủ tục (Stored Procedure) 
--trả về thông tin của khách hàng với tham số đầu vào là mã khách hàng (CustomerID)
--USE Northwind
--GO
--CREATE PROC dbo.Customer
--@custid  AS NCHAR(5)
--AS
--SELECT * FROM Customers
--WHERE CustomerID=@custid
--EXEC dbo.Customer N'ALFKI'
--Trên CSDL Northwind, viết một thủ tục thêm mới dữ liệu vào bảng 
--Territories với các tham số đầu vào là Territory ID, Territory Description và RegionID.
--USE Northwind
--GO
--CREATE PROC dbo.usp_Territories
--@Territory_ID AS nvarchar(20),
--@Territory_Description AS nchar(50),
--@Region_ID AS INT 
--AS
--BEGIN
--INSERT INTO  Territories(TerritoryID,TerritoryDescription,RegionID)
--VALUES(@Territory_ID,@Territory_Description,@Region_ID);
--END
--DROP PROC dbo.usp_Territories
--EXEC dbo.usp_Territories 'Vietnam','Hanoi',1000;
--Viết một thủ tục đệ quy tính tổng dãy số của một số (triangular) nguyên.
--Đầu vào: Một số nguyên n (n=5)
--Đầu ra: Tổng của dãy số T=n+ (n-1) + ... + 1. (ví dụ với n=5, T=5+4+3+2+1)
--CREATE PROC sptriangular @ValueIn INT, @ValueOut INT OUTPUT
--AS
--DECLARE @InWorking  INT
--DECLARE @OutWorking INT
--IF @ValueIn!=1
--BEGIN
--	SELECT @InWorking=@ValueIn-1
--	EXEC sptriangular @InWorking,@OutWorking OUTPUT
--	SELECT @ValueOut = @ValueIn + @OutWorking
--END
--ELSE
--BEGIN
--	SELECT @ValueOut = 1
--END
--RETURN
--------------
--DECLARE @WorkingOut int
--DECLARE @WorkingIn int
--SELECT @WorkingIn = 5
--EXEC sptriangular @WorkingIn, @WorkingOut 
--OUTPUT
--PRINT CAST(@WorkingIn AS varchar) + ' triangular is ' + CAST(@WorkingOut AS varchar)
------------
--DROP PROC sptriangular
--Trên CSDL Northwind, viết một hàm  với:
--Đầu vào: Mã khách hàng (CustomerID)
--Đầu ra: Chuỗi ký tự chứa danh sách mã hoá đơn (OrderID) của khách hàng. Mỗi mã hoá đơn cách nhau bởi dấu ‘;’
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
-------
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
-------
SELECT dbo.GetListHoaDon('ALFKI') AS DSHoaDon
-------
SELECT C.CustomerID, dbo.GetListHoaDon(CustomerID) AS DSHD, dbo.GetListSoLuongHoaDon(CustomerID) AS SLHD
FROM Customers C

------------

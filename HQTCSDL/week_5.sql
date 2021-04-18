--DECLARE @age	INT;
--DECLARE @firstName	CHAR(20), @lastName		CHAR(20);
--SET @lastName='Forta';
--SET @firstName='Ben';
--SET @age=21;
--PRINT CONVERT(CHAR,@age)+' '+@lastName+' '+@firstName

-------------------------------------IF-ELSE-------------------------------------
--DECLARE @dow INT
--DECLARE @open BIT
--SET @dow= DatePart(dw,GetDate());
--IF @dow= 1 OR @dow=7
--	SET @open=0
--ELSE
--	SET @open=1
--SELECT @open AS OpenForBusiness
-------------------------------------IF-ELSE-------------------------------------
--------------------------------------WHILE--------------------------------------

--DECLARE @n INT;
--DECLARE @list NVARCHAR(50);
--SET @n=10;
--SET @list='';
--WHILE @n>0
--	BEGIN
--		SET @list= @list+' , '+CONVERT(NVARCHAR,@n);
--		SET @n=@n-1;
	
--	END
--PRINT @list
--------------------------------------WHILE--------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

----Viết 1 Script tạo hai biến số nguyên (var1 và var2),
----thiết lập giá trị cho hai biến đó là 2 và 4, In ra giá trị tổng của 2 biến đó.
--DECLARE @var1 INT, @var2 INT;
--SET @var1=2;
--SET @var2=4;
--PRINT @var1+@var2
----------------------------------------------------------------------------------------------------
----Viết một đoạn lệnh sử dụng câu lệnh While in ra kết quả như sau 10  9 8 7 6 5 4 3 2 1
--DECLARE @count	INT;
--DECLARE @list NVARCHAR(40);
--SET @count=10;
--SET @list='';
--WHILE @count>0
--	BEGIN
--		SET @list=@list+' '+CONVERT(NVARCHAR,@count);
--		SET @count=@count-1;
--	END
--PRINT @list
----------------------------------------------------------------------------------------------------
----Trên CSDL Northwind. Viết 1 script thực hiện các công việc sau:
----Tạo một biến là MinOrder
----Lấy thông tin về tổng giá trị (số tiền) nhỏ nhất (Quantity * UnitPrice * (1-Discount)) 
----của sản phẩm trong tất cả hoá đơn của khách hàng có mã CustomerID=’ALFKI’,  gán giá trị này vào biến MinOrder
----Hiển thị thông tin của biến MinOrder.
--USE Northwind
--GO
--DECLARE @MinOrder  INT
--SET @MinOrder=(SELECT MIN(OD.Quantity*OD.UnitPrice*(1-OD.Discount))
--				FROM  Orders O, [Order Details] OD
--				WHERE O.CustomerID='ALFKI' AND OD.OrderID=O.OrderID)
--PRINT 'Min Order of Customer ALFKI '+CONVERT(NVARCHAR,@MinOrder)
----------------------------------------------------------------------------------------------------
----Trên CSDL Northwind , Viết đoạn lệnh thêm mới thông tin vào bảng [Order Details] 
----sử dụng cấu trúc Try/Catch để bắt lỗi, dùng hàm Raiserror() để phát sinh lỗi) :
----Khai báo các biến, nhập giá trị cho các biến @OrderID, @ProductID, @UnitPrice, @Quantity, @Discount
----Kiểm tra nếu số lượng hàng (@Quantity) <= 0 thì hiện ra thông báo lỗi “Số lượng sản phẩm phải >0” 
----và không thực hiện lệnh thêm mới dữ liệu
----Kiểm tra nếu số giảm giá  (@Discount) > 10 thì hiện ra thông báo lỗi “% giảm giá phải <=10%” 
----và không thực hiện lệnh thêm mới dữ liệu
----Nếu thoả mãn hai điều kiện trên thực hiện thêm mới dữ liệu vào bảng [Order Details]. 
----Bắt các lỗi thêm mới dữ liệu nếu có và hiển thị thông tin của lỗi
USE Northwind
GO
DECLARE @OrderID AS INT
SET @OrderID = 12048
-- Get OrderID Available
DECLARE @ProductID AS INT
set @ProductID = 1
-- Get ProductID Available
DECLARE @UnitProce AS INT
SET @UnitProce = 500
DECLARE @Quantiny AS SMALLINT
SET @Quantiny = 100
DECLARE @Discount AS REAL
SET @Discount = 0.2
BEGIN TRY
	IF (@Quantiny <= 0)
		RAISERROR ('Quantiny need more than 0', 11, 1)
	IF (@Discount > 0.1)
		RAISERROR ('Quantiny need less than 10%%', 11, 1)
	INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
	VALUES (@OrderID, @ProductID, @UnitProce, @Quantiny, @Discount)
END TRY
BEGIN CATCH
	PRINT Error_Message()
	PRINT 'Something went wrong'
END CATCH





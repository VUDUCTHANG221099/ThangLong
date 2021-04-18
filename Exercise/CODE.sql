--DECLARE @age INT;
--DECLARE @firstName CHAR(20), @lastName CHAR(20);
--SET @lastName='Forta';
--SET @firstName='Ben';
--SET @age=21
--PRINT @lastName+', '+@firstName+CAST(@age AS nvarchar);
-----------------------------------------------------------------------------
--DECLARE @cust_id NCHAR(5);
--SET @cust_id='ALFKI'
--SELECT @cust_id AS COMPANY
-----------------------------------------------------------------------------
--DECLARE @dow INT
--DECLARE @open BIT
--SET @dow = DATEPART(D,GETDATE())
--IF @dow=1 OR @dow=7
--	SET @open=0
--ELSE
--	SET @open=1
--SELECT @open AS OpenForBusiness
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
--DECLARE @counter INT
--SET @counter=1
--WHILE @counter<=10
--BEGIN 
--	PRINT @counter
--	IF @counter=5
--		GOTO NUMBERS
--	SET @counter=@counter+1
--END
--NUMBERS:
--	PRINT @counter
----------------------------------------------------------------------------- B�i 4
--DECLARE @counter INT
--SET @counter=1
--DECLARE @ds varchar(50)
--SET @ds=''
--WHILE @counter<=10
--BEGIN
--	SET @ds=@ds+ ' ' +convert(varchar, @counter)
--	SET @counter=@counter+1			
--END	
--print @ds
-----------------------------------------------------------------------------     B�i  2
--USE Northwind
--GO
--DECLARE @MinOrder FLOAT
----	T?o m?t bi?n l� MinOrder
----	L?y th�ng tin v? t?ng gi� tr? (s? ti?n) nh? nh?t (Quantity * UnitPrice * (1-Discount)) 
----c?a s?n ph?m trong t?t c? ho� ??n c?a kh�ch h�ng c� m� CustomerID=�ALFKI�,  g�n gi� tr? n�y v�o bi?n MinOrder
----	 Hi?n th? th�ng tin c?a bi?n MinOrder.
--SET @MinOrder= (SELECT MIN((Quantity * UnitPrice * (1-Discount))) AS MINALFKI
--FROM  [dbo].[Orders] O, [dbo].[Order Details] OD
--WHERE O.CustomerID='ALFKI' AND O.OrderID=OD.OrderID)
--PRINT @MinOrder
-----------------------------------------------------------------------------     B�i  3
USE Northwind
GO
--	T?o 2 bi?n l� OrderID, MaxQuantityOrder
--	L?y th�ng tin  v? s? ho� ??n (OrderID ) v� t?ng kh?i l??ng h�ng ho� c?a ho� ??n c� t?ng kh?i l??ng h�ng ho�
-- (Quantity) l?n nh?t  trong t?t c? ho� ??n c?a kh�ch h�ng c� m� CustomerID=�ALFKI�,  
-- g�n c�c gi� tr? n�y l?n l??t v�o c�c bi?n v�o bi?n OrderID, MaxQuantityOrder
--Hi?n th? th�ng tin c?a bi?n OrderID, MaxQuantityOrder
--DECLARE @OrderID INT
--DECLARE @MaxQuantityOrder smallint
--SELECT *
--FROM [dbo].[Orders] O, [dbo].[Order Details] OD
--WHERE O.CustomerID='ALFKI' AND  O.OrderID=OD.OrderID
--GROUP BY OD.OrderID
--HAVING SUM(OD.Quantity)=(SELECT  TOP 1 SUM(OD.Quantity)
--						FROM [dbo].[Orders] O, [dbo].[Order Details] OD)
-----



DECLARE @custID as nchar(5)
DECLARE @oi as int
DECLARE @kl as int
set @custID='ALKFI'
SELECT top(1) @oi=O.OrderID,@kl=SUM(OD.Quantity)
FROM Orders O 
	JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE CustomerID=@custID
GROUP BY O.OrderID
order by sum(od.Quantity) desc
select @oi, @kl
-------------------------
--Tr�n CSDL Northwind , Vi?t ?o?n l?nh th�m m?i th�ng tin v�o b?ng [Order Details] 
--(s? d?ng c?u tr�c Try/Catch ?? b?t l?i, d�ng h�m Raiserror() ?? ph�t sinh l?i) :
--Khai b�o c�c bi?n, nh?p gi� tr? cho c�c bi?n @OrderID, @ProductID, @UnitPrice, @Quantity, @Discount
--Ki?m tra n?u s? l??ng h�ng (@Quantity) <= 0 th� hi?n ra th�ng b�o l?i 
--�S? l??ng s?n ph?m ph?i >0� v� kh�ng th?c hi?n l?nh th�m m?i d? li?u
--Ki?m tra n?u s? gi?m gi�  (@Discount) > 10 th� hi?n ra th�ng b�o l?i
-- �% gi?m gi� ph?i <=10%� v� kh�ng th?c hi?n l?nh th�m m?i d? li?u
--N?u tho? m�n hai ?i?u ki?n tr�n th?c hi?n th�m m?i d? li?u v�o b?ng [Order Details]. 
--B?t c�c l?i th�m m?i d? li?u n?u c� v� hi?n th? th�ng tin c?a l?i. 
--DECLARE @OrderID INT
--DECLARE @ProductID INT
--DECLARE @UnitPrice INT
--DECLARE @Quantity INT
--DECLARE @Discount INT
BEGIN TRY
INSERT INTO [Order Details](OrderID, ProductID,
UnitPrice, Quantity, Discount)
VALUES(999999,11,10.00,10, 0)
PRINT 'INSERT succeeded.';
END TRY
BEGIN CATCH
PRINT 'INSERT failed.';
/* handle error here */
END CATCH
--------------------------------   BA
DECLARE @OrderID INT
DECLARE @ProductID INT
DECLARE @UnitPrice MONEY
DECLARE @Quantity SMALLINT
DECLARE @Discount REAL
SELECT @OrderID=10248, @ProductID=1, @UnitPrice=1000, @Quantity=100, @Discount=0.1
BEGIN TRY
	IF(@Quantity<=0)
		RAISERROR('KHOI LUONG PHAI >0',1,1)
	IF(@Discount>0.1)
		RAISERROR('GIAM GIA PHAI NHO HON 10% ',11,1)
	INSERT INTO ([dbo].[Order Details],
				
					
	VALUES (@OrderID

END TRY
BEGIN CATCH

END CATCH
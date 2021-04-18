USE Northwind
GO
----------------Tạo bảng CustomerTrans dựa trên Customers--------------------------------
----------------SELECT CustomerTrans Khi chưa sử dụng TRANSACTION------------------------
--SELECT CustomerID,CompanyName INTO CustomerTrans FROM Customers
----------------SELECT CustomerTrans Khi sử dụng TRANSACTION-----------------------------
----------------Working with Rollback Tran-----------------------------------------------
----BEGIN TRANSACTION
----	DELETE FROM CustomerTrans
----	INSERT INTO CustomerTrans
----	VALUES('ABCDE','VN Company');
----IF @@ERROR!=0
----	ROLLBACK TRAN
----ELSE
----	COMMIT TRAN
----------------------------------PRINT----------------------------------------------
----SELECT * FROM CustomerTrans
----------------------------------DROP-----------------------------------------------
------DROP TABLE CustomerTrans
-------------------------------------------------------------------------------------------------
---------------------------------Triggers--------------------------------------------------------
--USE Northwind
--GO
--SELECT CustomerID,CompanyName into CustomersTemp from Customers
----------------------------------After DML Triggers---------------------------------------------
----USE Northwind
----GO
----CREATE TRIGGER dbo.tr_CustomersTemp_I
----ON [dbo].[CustomersTemp]
----AFTER INSERT
----AS
----	PRINT 'BAN VUA THEM MOI DU LIEU '+CAST(@@ROWCOUNT AS VARCHAR)+' RECORD(S)!'
------------------Tạo INSERT và kiểm tra đã thêm phần tử nào
----	SELECT * FROM inserted
----GO
-------------------INSERT DATA vào CustomersTemp-----------------------------------
------INSERT INTO [dbo].[CustomersTemp]
------VALUES('ABAAE','AC Company');
--------DELETE   FROM [dbo].[CustomersTemp] 
--------WHERE CustomerID='ABAAE'
-------SELECT * FROM [dbo].[CustomersTemp] 
----------------------DROP TRIGGER-----------------------------------------------
----DROP TRIGGER dbo.tr_CustomersTemp_I
----------------------Instead of triggers---------------------------------------
--CREATE TRIGGER dbo.tr_CustomersTemp_I2
--ON [dbo].[CustomersTemp] INSTEAD OF INSERT
--AS
--	SELECT *FROM inserted
--	INSERT INTO [dbo].[CustomersTemp] 
--	SELECT *FROM inserted
----INSERT INTO [dbo].[CustomersTemp]
----VALUES('ABAAE','AC Company');
----DROP TRIGGER dbo.tr_CustomersTemp_I2
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
----Tạo một thủ tục với 
----Đầu vào: là mã hoá đơn (OrderID),  ngày hoá đơn, ProductId, số lượng sản phẩm (quantity)
----Thủ tục thực hiện các công việc sau:
----Cập nhật ngày hoá đơn cho hoá đơn có mã là OrderID
----Cập nhật giá thành của mỗi sản phẩm. Tăng thêm 20% cho mỗi sản phẩm
----Các công việc này phải thực hiện cùng nhau. Nếu có lỗi thì phục hồi lại trạng thái dữ liệu trước khi thực hiện.
--CREATE PROC bai_1
--	@OrderID		AS	INT,
--	@orderDate		AS	datetime,
--	@ProductID		AS	INT,
--	@Quantity		AS	smallint
--AS
--		BEGIN TRANSACTION
--			UPDATE Orders SET OrderDate=@orderDate
--			WHERE OrderID=@OrderID
--			UPDATE [dbo].[Order Details] SET UnitPrice=1.2*UnitPrice
--			IF @@ERROR!=0
--				ROLLBACK TRAN
--			ELSE
--				COMMIT TRAN
-----------------------------INSERT DATA-----------------------------
----EXEC bai_1 '10000','2020/01/01','1','19'
----------------------------TEST INSERT DATA-----------------------------------------------
------SELECT *
------FROM [dbo].[Products]
------WHERE ProductID=1
----------------------------------------------------------------------------------------
----Tạo một After triggers thực hiện kiểm tra khi thêm mới, cập nhật thông tin sản phẩm vào bảng [Order Details].
----Công việc kiểm tra như sau: kiểm tra trong bảng Product, nếu sản phẩm đó đã ngừng bán (Discontinued = 1) 
----thì không cho phép thêm mới và cập nhật sản phẩm vào trong bảng [Order Details
CREATE TRIGGER tr_themdb1
	ON [dbo].[Order Details]
	AFTER INSERT
AS
BEGIN
	DECLARE @Discontinued BIT 
	SET @Discontinued=0
	SELECT @Discontinued=P.Discontinued 
	FROM inserted I JOIN [dbo].[Products] P ON I.ProductID=P.ProductID
	IF(@Discontinued=1)
		BEGIN
			PRINT 'KHONG THE THEM MOI VI DA NGUNG BAN';
			ROLLBACK
		END
END
GO
---------------------------TEST INSERT TRIGGERS---------------------------------------------------
----INSERT INTO [dbo].[Order Details]
----VALUES(10248,77,100,20,0.15)
-----Tạo một Instead of triggers để thực hiện công việc kiểm tra như bài 2.
ALTER TRIGGER tr_themdb1
ON [dbo].[Order Details] INSTEAD OF INSERT
AS
	BEGIN
		DECLARE		@Discontinued	BIT
		SELECT		@Discontinued=P.Discontinued
		FROM inserted I , Products P
		WHERE I.ProductID=P.ProductID
		IF(@Discontinued=0)
			BEGIN
				PRINT 'THEM MOI THANH CONG';
				INSERT [Order Details] 
				SELECT * FROM inserted
			END
	END
GO
---------------------------TEST INSERT TRIGGERS---------------------------------------------------
INSERT INTO [dbo].[Order Details]
VALUES(10248,8,100,20,0.15)
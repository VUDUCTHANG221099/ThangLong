USE Northwind
GO
----Tạo bảng CustomerTrans dựa trên Customers
--SELECT CustomerID,CompanyName into CustomerTrans from Customers
--DROP TABLE CustomerTrans
--SELECT CustomerTrans Khi chưa sử dụng TRANSACTION
--SELECT * FROM CustomerTrans
--BEGIN TRANSACTION
--	DELETE FROM CustomerTrans
--	INSERT INTO CustomerTrans
--	VALUES('ABCDE','VN Company');
--IF @@ERROR!=0
--	ROLLBACK TRAN
--ELSE
--	COMMIT TRANSACTION
--SELECT CustomerTrans Khi sử dụng TRANSACTION
--SELECT * FROM  CustomerTrans
--Triggers
--SELECT CustomerID,CompanyName into CustomersTemp from Customers
----DML Triggers

--CREATE TRIGGER dbo.tr_CustomersTemp_I
--ON [dbo].[CustomersTemp]
--AFTER INSERT  --FOR INSERT
--AS
--	PRINT'BAN VUA THEM MOI DU LIEU '+	CONVERT(VARCHAR,@@rowcount)+' RECORD(S)!';
--	--Tạo INSERT và kiểm tra luôn
--	SELECT * FROM inserted
--GO
--DROP TRIGGER dbo.tr_CustomersTemp_I
----INSERT DATA vào CustomersTemp
--INSERT INTO [dbo].[CustomersTemp]
--VALUES('ABAAE','AC Company');
--SELECT * FROM [dbo].[CustomersTemp]
--Instead of triggers
----CREATE TRIGGER dbo.tr_CustomersTemp_I2
----ON [dbo].[CustomersTemp] INSTEAD OF INSERT
----AS
----	SELECT *FROM inserted
----	INSERT INTO [dbo].[CustomersTemp] 
----	SELECT *FROM inserted
----INSERT INTO [dbo].[CustomersTemp]
----VALUES('ABAAE','AC Company');
----DROP TRIGGER dbo.tr_CustomersTemp_I2
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
--SELECT *
--FROM Orders
-------------------------------------------------------------
--Tạo một thủ tục với 
--Đầu vào: là mã hoá đơn (OrderID),  ngày hoá đơn, ProductId, số lượng sản phẩm (quantity)
--Thủ tục thực hiện các công việc sau:
--Cập nhật ngày hoá đơn cho hoá đơn có mã là OrderID
--Cập nhật giá thành của mỗi sản phẩm. Tăng thêm 20% cho mỗi sản phẩm
--Các công việc này phải thực hiện cùng nhau. Nếu có lỗi thì phục hồi lại 
--trạng thái dữ liệu trước khi thực hiện.
--CREATE PROC BAI_1
--	@OrderID		AS	INT,
--	@orderDate		AS	datetime,
--	@ProductID		AS	INT,
--	@Quantity		AS	smallint
--AS
--	BEGIN TRANSACTION
--		UPDATE Orders SET OrderDate=@orderDate
--		WHERE OrderID=@OrderID
--		UPDATE [dbo].[Order Details] SET UnitPrice=1.2*UnitPrice
--		IF @@ERROR!=0
--			ROLLBACK TRANSACTION
--		ELSE
--			COMMIT TRANSACTION
--EXEC BAI_1 '10000','2020/01/01','1','19'	
--	Câu lệnh kiểm tra		 
--SELECT *
--FROM [dbo].[Products]
--WHERE ProductID=2
------------------------------------------------------------------------------------------------
--Tạo một After triggers thực hiện kiểm tra khi thêm mới, 
--cập nhật thông tin sản phẩm vào bảng [Order Details]. Công việc kiểm tra như sau: 
--kiểm tra trong bảng Product, nếu sản phẩm đó đã ngừng bán (Discontinued = 1) 
--thì không cho phép thêm mới và cập nhật sản phẩm vào trong bảng [Order Details].
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
----Kiểm tra trigger
--INSERT INTO [dbo].[Order Details]
--VALUES(10248,77,100,20,0.15)
----Kiểm tra trigger
-------------------------------------------------------------------------------------
--Tạo một Instead of triggers để thực hiện công việc kiểm tra như bài 2.
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
----Kiểm tra trigger
INSERT INTO [dbo].[Order Details]
VALUES(10248,8,100,20,0.15)
----Kiểm tra trigger
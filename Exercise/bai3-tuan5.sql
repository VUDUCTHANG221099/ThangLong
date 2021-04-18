----2.	Trên CSDL Northwind. Viết 1 script thực hiện các công việc sau:
----o	Tạo một biến là MinOrder
----o	Lấy thông tin về tổng giá trị (số tiền) nhỏ nhất (Quantity * UnitPrice * (1-Discount)) của sản phẩm trong tất cả hoá đơn của khách hàng có mã CustomerID=’ALFKI’,  gán giá trị này vào biến MinOrder
----o	 Hiển thị thông tin của biến MinOrder.

--use Northwind
--go
--declare @MinOrder int

--select @MinOrder = min(Quantity * UnitPrice * (1 - Discount))
--from [Order Details] od join Orders o
--on od.OrderID = o.OrderID
--where CustomerID = 'ALFKI'

--print 'Tong gia tri nho nhat cua khach hang ALFKI: ' + convert(varchar, @MinOrder)


----3.	Trên CSDL Northwind. Viết 1 script thực hiện các công việc sau:
----o	Tạo 2 biến là OrderID, MaxQuantityOrder
----o	Lấy thông tin  về số hoá đơn (OrderID ) và tổng khối lượng hàng hoá của hoá đơn có tổng khối lượng hàng hoá (Quantity) 
----  lớn nhất  trong tất cả hoá đơn của khách hàng có mã CustomerID=’ALFKI’,  gán các giá trị này lần lượt vào các biến vào 
----  biến OrderID, MaxQuantityOrder
----o	 Hiển thị thông tin của biến OrderID, MaxQuantityOrder

--declare @OrderID as int
--declare @MaxQuantityOrder as int
--declare @custID nchar(5)
--set @custID = 'ALFKI'

--select top(1)@OrderID = od.OrderID, @MaxQuantityOrder = sum(Quantity)
--from [Order Details] od join Orders o
--on od.OrderID = o.OrderID
--where CustomerID = @custID
--group by od.OrderID
--order by sum(Quantity) desc

--print 'Tong gia tri lon nhat: ' + convert(varchar, @MaxQuantityOrder)


--select @OrderID = T.O
--from
--(
--	select distinct o.OrderID, Discount over(partition by o.OrderID) as KL
--	from [Order Details] od join Orders o
--	on od.OrderID = o.OrderID
--) as T
--order by KL as



-- 5.	Sử dụng câu lệnh SQLCMD để chạy và hiển thị kết quả của câu truy vấn 
-- “SELECT COUNT(*) FROM Customers” ra màn hình cửa sổ dòng lệnh của Window


--9. Trên CSDL Northwind , Viết đoạn lệnh thêm mới thông tin vào bảng [Order Details] (sử dụng cấu trúc Try/Catch để bắt lỗi, 
-- dùng hàm Raiserror() để phát sinh lỗi) :
-- Khai báo các biến, nhập giá trị cho các biến @OrderID, @ProductID, @UnitPrice, @Quantity, @Discount
-- Kiểm tra nếu số lượng hàng (@Quantity) <= 0 thì hiện ra thông báo lỗi “Số lượng sản phẩm phải >0” và không thực hiện lệnh thêm mới dữ liệu
-- Kiểm tra nếu số giảm giá  (@Discount) > 10 thì hiện ra thông báo lỗi “% giảm giá phải <=10%” và không thực hiện lệnh thêm mới dữ liệu
-- Nếu thoả mãn hai điều kiện trên thực hiện thêm mới dữ liệu vào bảng [Order Details]. 
-- Bắt các lỗi thêm mới dữ liệu nếu có và hiển thị thông tin của lỗi. 

declare @OrderID as int
set @OrderID = 12048
-- lay orderid co san

declare @ProductID as int
set @ProductID = 1
-- lay productid co san

declare @UnitProce as int
set @UnitProce = 500

declare @Quantiny as smallint
set @Quantiny = 100

declare @Discount as real
set @Discount = 0.2

begin try
	if (@Quantiny <= 0)
		raiserror ('Quantiny need more than 0', 11, 1)

	if (@Discount > 0.1)
		raiserror ('Quantiny need less than 10%%', 11, 1)

	insert into [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
	values (@OrderID, @ProductID, @UnitProce, @Quantiny, @Discount)
end try
begin catch
	print Error_Message()
	print 'Something went wrong'
end catch
Đối tượng chính của NumPy là mảng đa chiều thuần nhất. Nó là một bảng các phần tử (thường là số), tất cả đều thuộc cùng một kiểu, được lập chỉ mục bởi một loạt các số nguyên không âm. Trong NumPy kích thước được gọi là trục .
ndarray.ndim
    số lượng trục (kích thước) của mảng.
ndarray.shape
    kích thước của mảng. Đây là một bộ số nguyên cho biết kích thước của mảng trong mỗi chiều. Đối với một ma trận có n hàng và m cột, shape sẽ là (n,m). Do đó, chiều dài của shapetuple là số trục , ndim.
ndarray.size
    tổng số phần tử của mảng. Điều này bằng tích của các phần tử của shape.
ndarray.dtype
    một đối tượng mô tả kiểu của các phần tử trong mảng. Người ta có thể tạo hoặc chỉ định dtype bằng cách sử dụng các kiểu Python chuẩn. Ngoài ra NumPy cung cấp các loại của riêng mình. numpy.int32, numpy.int16 và numpy.float64 là một số ví dụ.
ndarray.itemsize
    kích thước tính bằng byte của mỗi phần tử của mảng. 
ndarray.data
    vùng đệm chứa các phần tử thực của mảng. Thông thường, chúng ta sẽ không cần sử dụng thuộc tính này vì chúng ta sẽ truy cập các phần tử trong một mảng bằng cách sử dụng các phương tiện lập chỉ mục.


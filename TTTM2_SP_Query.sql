CREATE PROCEDURE [dbo].[sp_CreateOrUpdateCuaHang]
    @CuaHangID INT = NULL, -- Nếu là NULL thì là thêm mới, nếu có giá trị thì là cập nhật
    @TenCuaHang NVARCHAR(100),
    @TangID INT, -- Truyền TangID thay vì TenTang
    @DienTich FLOAT,
    @DonGiaThue FLOAT
AS
BEGIN
    -- Kiểm tra xem cửa hàng đã tồn tại chưa (dựa vào CuaHangID)
    IF @CuaHangID IS NULL
    BEGIN
        -- Thêm mới cửa hàng
        INSERT INTO CuaHang (TenCuaHang, TangID, DienTich, DonGiaThue)
        VALUES (@TenCuaHang, @TangID, @DienTich, @DonGiaThue);
    END
    ELSE
    BEGIN
        -- Cập nhật cửa hàng nếu đã tồn tại
        UPDATE CuaHang
        SET TenCuaHang = @TenCuaHang,
            TangID = @TangID,
            DienTich = @DienTich,
            DonGiaThue = @DonGiaThue
        WHERE CuaHangID = @CuaHangID;
    END
END
CREATE PROCEDURE [dbo].[sp_GetDanhSachTang]
AS
BEGIN
    -- Lấy danh sách tất cả các tầng từ bảng Tang
    SELECT TangID, TenTang
    FROM Tang
    ORDER BY TenTang; -- Sắp xếp theo tên tầng (có thể thay đổi tùy theo yêu cầu)
END
GO

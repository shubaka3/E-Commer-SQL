CREATE PROCEDURE sp_GetDanhSachCuaHang
AS
BEGIN
    SELECT 
        ch.CuaHangID,
        ch.TenCuaHang,
        t.TenTang,
        ch.DienTich,
        ch.DonGiaThue,
        (ch.DienTich * ch.DonGiaThue) AS TienThueDuKien
    FROM CuaHang ch
    JOIN Tang t ON ch.TangID = t.TangID
END
GO

CREATE PROCEDURE sp_GetCuaHangById
	@CuaHangID INT
AS
BEGIN
    SELECT 
        ch.CuaHangID,
        ch.TenCuaHang,
		ch.TangID,
        ch.DienTich,
        ch.DonGiaThue,
        (ch.DienTich * ch.DonGiaThue) AS TienThueDuKien
    FROM CuaHang ch where ch.CuaHangID = @CuaHangID
END
GO

CREATE PROCEDURE sp_ThemCuaHang
    @TenCuaHang NVARCHAR(100),
    @TenTang NVARCHAR(50),
    @DienTich FLOAT,
    @DonGiaThue FLOAT,
    @TienThueDuKien FLOAT -- Có thể không cần nếu bạn tự tính ở phía backend
AS
BEGIN
    DECLARE @TangID INT;

    -- Kiểm tra tầng đã tồn tại chưa, nếu chưa thì thêm
    SELECT @TangID = TangID FROM Tang WHERE TenTang = @TenTang;

    IF @TangID IS NULL
    BEGIN
        INSERT INTO Tang (TenTang, TongDienTich)
        VALUES (@TenTang, 0); -- hoặc bạn có thể truyền Tổng diện tích từ ngoài vào

        SET @TangID = SCOPE_IDENTITY();
    END

    INSERT INTO CuaHang (TenCuaHang, TangID, DienTich, DonGiaThue)
    VALUES (@TenCuaHang, @TangID, @DienTich, @DonGiaThue);
END
GO

CREATE PROCEDURE sp_CapNhatCuaHang
    @CuaHangID INT,
    @TenCuaHang NVARCHAR(100),
    @TenTang NVARCHAR(50),
    @DienTich FLOAT,
    @DonGiaThue FLOAT,
    @TienThueDuKien FLOAT
AS
BEGIN
    DECLARE @TangID INT;

    -- Tìm hoặc thêm tầng nếu chưa có
    SELECT @TangID = TangID FROM Tang WHERE TenTang = @TenTang;

    IF @TangID IS NULL
    BEGIN
        INSERT INTO Tang (TenTang, TongDienTich)
        VALUES (@TenTang, 0);

        SET @TangID = SCOPE_IDENTITY();
    END

    UPDATE CuaHang
    SET
        TenCuaHang = @TenCuaHang,
        TangID = @TangID,
        DienTich = @DienTich,
        DonGiaThue = @DonGiaThue
    WHERE CuaHangID = @CuaHangID;
END
GO

CREATE PROCEDURE sp_XoaCuaHang
    @CuaHangID INT
AS
BEGIN
    DELETE FROM HoaDon WHERE CuaHangID = @CuaHangID; -- Xóa hóa đơn trước nếu có
    DELETE FROM CuaHang WHERE CuaHangID = @CuaHangID;
END
GO


CREATE PROCEDURE sp_FilterCuaHang
    @Keyword NVARCHAR(100),
    @Tang NVARCHAR(50),
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL
AS
BEGIN
    SELECT 
        ch.CuaHangID,
        ch.TenCuaHang,
        t.TenTang,
        ch.DienTich,
        ch.DonGiaThue,
        ISNULL(SUM(hd.TienThue), 0) AS TienThueDuKien
    FROM CuaHang ch
    JOIN Tang t ON ch.TangID = t.TangID
    LEFT JOIN HoaDon hd ON ch.CuaHangID = hd.CuaHangID
        AND (@DateFrom IS NULL OR hd.NgayLap >= @DateFrom)
        AND (@DateTo IS NULL OR hd.NgayLap <= @DateTo)
    WHERE 
        (@Keyword = '' OR ch.TenCuaHang LIKE '%' + @Keyword + '%')
        AND (@Tang = '' OR t.TenTang = @Tang)
    GROUP BY 
        ch.CuaHangID, ch.TenCuaHang, t.TenTang, ch.DienTich, ch.DonGiaThue
    ORDER BY ch.TenCuaHang
END



CREATE PROCEDURE sp_GetDanhSachCuaHang_Paging
    @Skip INT,
    @Take INT,
    @SortColumn NVARCHAR(50) = 'CuaHangID',
    @SortOrder NVARCHAR(4) = 'ASC'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sql NVARCHAR(MAX)

    SET @Sql = '
    SELECT *
    FROM (
        SELECT 
            ch.CuaHangID,
            ch.TenCuaHang,
            t.TenTang,
            ch.DienTich,
            ch.DonGiaThue,
            (ch.DienTich * ch.DonGiaThue) AS TienThueDuKien,
            ROW_NUMBER() OVER (ORDER BY ' + QUOTENAME(@SortColumn) + ' ' + @SortOrder + ') AS RowNum
        FROM CuaHang ch
        INNER JOIN Tang t ON ch.TangID = t.TangID
    ) AS T
    WHERE T.RowNum > @Skip AND T.RowNum <= (@Skip + @Take)
    '

    EXEC sp_executesql @Sql, 
        N'@Skip INT, @Take INT',
        @Skip = @Skip,
        @Take = @Take
END


CREATE PROCEDURE sp_CountCuaHang
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) FROM CuaHang
END

-------- test -------
EXEC sp_CapNhatCuaHang
    @CuaHangID = 1,
    @TenCuaHang = N'Cập nhật Tên',
    @TenTang = N'Tầng 2',
    @DienTich = 60,
    @DonGiaThue = 120000,
    @TienThueDuKien = 7200000;

EXEC sp_XoaCuaHang @CuaHangID = 101;


EXEC sp_GetDanhSachCuaHang_Paging @Skip = 4,@Take = 10;

EXEC sp_GetCuaHangById @CuaHangID = 10

CREATE PROCEDURE sp_GetDanhSachTang
AS
BEGIN
    SELECT TangID, TenTang, TongDienTich
    FROM Tang
END

CREATE PROCEDURE sp_ThemTang
    @TenTang NVARCHAR(50),
    @TongDienTich FLOAT
AS
BEGIN
    INSERT INTO Tang (TenTang, TongDienTich)
    VALUES (@TenTang, @TongDienTich)
END

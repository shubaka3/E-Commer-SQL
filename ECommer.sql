-- Tạo cơ sở dữ liệu E-commerce
CREATE DATABASE ECommerce;
GO
USE ECommerce;
GO

-- 1. Bảng Categories (Danh mục sản phẩm)
CREATE TABLE Categories (
    CategoryID INT IDENTITY PRIMARY KEY,
    CategoryName NVARCHAR(100),
    Description NVARCHAR(500)
);
GO

-- 2. Bảng Customers (Khách hàng)
CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    City NVARCHAR(50),
    State NVARCHAR(50),
    ZipCode NVARCHAR(10),
    Country NVARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 3. Bảng Products (Sản phẩm)
CREATE TABLE Products (
    ProductID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100),
    Description NVARCHAR(500),
    Price DECIMAL(10, 2),
    StockQuantity INT,
    CategoryID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) -- Tham chiếu tới bảng Categories
);
GO

-- 4. Bảng Orders (Đơn hàng)
CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    ShippingAddress NVARCHAR(200),
    ShippingCity NVARCHAR(50),
    ShippingState NVARCHAR(50),
    ShippingZipCode NVARCHAR(10),
    ShippingCountry NVARCHAR(50),
    Status NVARCHAR(20), -- 'Pending', 'Shipped', 'Delivered', 'Cancelled'
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- 5. Bảng OrderDetails (Chi tiết đơn hàng)
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) -- Tham chiếu tới bảng Products
);
GO

-- 6. Bảng Payments (Thanh toán)
CREATE TABLE Payments (
    PaymentID INT IDENTITY PRIMARY KEY,
    OrderID INT,
    PaymentDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(10, 2),
    PaymentMethod NVARCHAR(50), -- 'Credit Card', 'PayPal', 'Bank Transfer'
    PaymentStatus NVARCHAR(20), -- 'Paid', 'Pending', 'Failed'
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO

-- 7. Bảng Shipments (Vận chuyển)
CREATE TABLE Shipments (
    ShipmentID INT IDENTITY PRIMARY KEY,
    OrderID INT,
    ShipmentDate DATETIME DEFAULT GETDATE(),
    TrackingNumber NVARCHAR(50),
    Carrier NVARCHAR(50), -- 'UPS', 'FedEx', 'DHL'
    ShippingCost DECIMAL(10, 2),
    ShippingStatus NVARCHAR(20), -- 'In Transit', 'Delivered', 'Returned'
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO

-- 8. Bảng Discounts (Giảm giá)
CREATE TABLE Discounts (
    DiscountID INT IDENTITY PRIMARY KEY,
    DiscountCode NVARCHAR(50) UNIQUE,        -- Mã giảm giá
    Description NVARCHAR(200),               -- Mô tả về giảm giá
    DiscountType NVARCHAR(50),               -- Loại giảm giá: 'Percentage' (chiết khấu phần trăm) hoặc 'Fixed' (giảm theo số tiền)
    DiscountValue DECIMAL(10, 2),            -- Giá trị giảm giá: giá trị phần trăm hoặc số tiền
    StartDate DATETIME,                      -- Ngày bắt đầu chương trình giảm giá
    EndDate DATETIME,                        -- Ngày kết thúc chương trình giảm giá
    IsActive BIT DEFAULT 1                   -- Trạng thái giảm giá: 1 (hoạt động), 0 (không hoạt động)
);
GO

INSERT INTO Categories (CategoryName, Description)
VALUES
    ('Electronics', 'Devices such as smartphones, laptops, etc.'),
    ('Clothing', 'Apparel including shirts, trousers, dresses, etc.'),
    ('Home Appliances', 'Various appliances for the home, such as refrigerators, washers, etc.'),
    ('Books', 'A wide range of books from different genres.'),
    ('Toys', 'Toys for children including educational and fun toys.'),
    ('Furniture', 'Furniture for home and office, including desks, chairs, etc.');

INSERT INTO Products (Name, Description, Price, StockQuantity, CategoryID)
VALUES
    ('Smartphone', 'Latest model with high performance', 500, 100, 1),
    ('Laptop', 'High-end laptop for work and gaming', 1200, 50, 1),
    ('Tablet', 'Portable and powerful tablet', 300, 75, 1),
    ('Shirt', 'Cotton t-shirt for casual wear', 20, 150, 2),
    ('Jeans', 'Denim jeans for everyday wear', 40, 120, 2),
    ('Dress', 'Evening dress for women', 60, 80, 2),
    ('Refrigerator', 'Double-door refrigerator with cooling technology', 800, 30, 3),
    ('Washing Machine', 'Front-load washing machine with 10kg capacity', 450, 40, 3),
    ('Microwave', 'Microwave oven with quick cooking features', 150, 90, 3),
    ('Novel', 'A mystery novel by famous author', 15, 200, 4),
    ('Science Fiction', 'A sci-fi novel exploring future technologies', 18, 180, 4),
    ('Textbook', 'Mathematics textbook for university students', 40, 60, 4),
    ('Action Figure', 'Superhero action figure for kids', 10, 300, 5),
    ('Lego Set', 'Building block set for children', 25, 250, 5),
    ('Doll', 'Soft doll for children', 15, 350, 5),
    ('Sofa', 'Comfortable sofa for living room', 400, 20, 6),
    ('Office Chair', 'Ergonomic office chair with adjustable height', 100, 50, 6),
    ('Desk', 'Wooden desk with spacious drawers', 120, 40, 6);

INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Main St', 'New York', 'NY', '10001', 'USA'),
    ('Jane', 'Smith', 'jane.smith@example.com', '2345678901', '456 Oak St', 'Los Angeles', 'CA', '90001', 'USA'),
    ('Alice', 'Johnson', 'alice.johnson@example.com', '3456789012', '789 Pine St', 'Chicago', 'IL', '60601', 'USA'),
    ('Bob', 'Williams', 'bob.williams@example.com', '4567890123', '101 Maple St', 'Houston', 'TX', '77001', 'USA'),
    ('Charlie', 'Brown', 'charlie.brown@example.com', '5678901234', '202 Birch St', 'Phoenix', 'AZ', '85001', 'USA'),
    ('David', 'Davis', 'david.davis@example.com', '6789012345', '303 Cedar St', 'San Francisco', 'CA', '94101', 'USA'),
    ('Eva', 'Miller', 'eva.miller@example.com', '7890123456', '404 Elm St', 'Seattle', 'WA', '98001', 'USA');

INSERT INTO Orders (CustomerID, OrderDate, ShippingAddress, ShippingCity, ShippingState, ShippingZipCode, ShippingCountry, Status, TotalAmount)
VALUES
    (1, '2023-07-01', '123 Main St', 'New York', 'NY', '10001', 'USA', 'Shipped', 520),
    (2, '2023-07-03', '456 Oak St', 'Los Angeles', 'CA', '90001', 'USA', 'Pending', 400),
    (3, '2023-07-05', '789 Pine St', 'Chicago', 'IL', '60601', 'USA', 'Delivered', 700),
    (4, '2023-07-07', '101 Maple St', 'Houston', 'TX', '77001', 'USA', 'Cancelled', 300),
    (5, '2023-07-09', '202 Birch St', 'Phoenix', 'AZ', '85001', 'USA', 'Shipped', 600),
    (6, '2023-07-10', '303 Cedar St', 'San Francisco', 'CA', '94101', 'USA', 'Delivered', 800),
    (7, '2023-07-11', '404 Elm St', 'Seattle', 'WA', '98001', 'USA', 'Pending', 450);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, TotalAmount)
VALUES
    (1, 1, 1, 500, 500),  -- 1 Smartphone
    (1, 2, 1, 20, 20),    -- 1 Shirt
    (2, 5, 2, 10, 20),    -- 2 Action Figures
    (3, 3, 1, 300, 300),  -- 1 Tablet
    (3, 6, 2, 15, 30),    -- 2 Lego Sets
    (4, 4, 1, 40, 40),    -- 1 Textbook
    (5, 7, 1, 100, 100),  -- 1 Desk
    (6, 8, 1, 400, 400),  -- 1 Sofa
    (7, 9, 1, 150, 150);  -- 1 Microwave

INSERT INTO Payments (OrderID, PaymentDate, Amount, PaymentMethod, PaymentStatus)
VALUES
    (1, '2023-07-02', 520, 'Credit Card', 'Paid'),
    (2, '2023-07-04', 400, 'PayPal', 'Pending'),
    (3, '2023-07-06', 700, 'Bank Transfer', 'Paid'),
    (5, '2023-07-10', 600, 'Credit Card', 'Paid'),
    (6, '2023-07-11', 800, 'Credit Card', 'Paid');

INSERT INTO Shipments (OrderID, ShipmentDate, TrackingNumber, Carrier, ShippingCost, ShippingStatus)
VALUES
    (1, '2023-07-02', 'TRK123456789', 'UPS', 15, 'Shipped'),
    (2, '2023-07-05', 'TRK987654321', 'FedEx', 20, 'Pending'),
    (3, '2023-07-06', 'TRK567123890', 'DHL', 10, 'Delivered'),
    (4, '2023-07-08', 'TRK112233445', 'UPS', 25, 'Returned'),
    (5, '2023-07-09', 'TRK998877665', 'FedEx', 30, 'Shipped');


INSERT INTO Discounts (DiscountCode, Description, DiscountType, DiscountValue, StartDate, EndDate, IsActive)
VALUES
    ('SUMMER10', '10% off for summer sales', 'Percentage', 10, '2023-06-01', '2023-08-31', 1),
    ('WINTER20', '20% off for winter sales', 'Percentage', 20, '2023-12-01', '2023-12-31', 1),
    ('BLACKFRIDAY50', '50% off on Black Friday', 'Percentage', 50, '2023-11-25', '2023-11-25', 1),
    ('FREESHIP', 'Free shipping on all orders', 'Fixed', 0, '2023-06-01', '2023-12-31', 1);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    ProductCode VARCHAR(20),
    Price DECIMAL(10, 2)
);

CREATE TABLE ProductSales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    SaleDate DATE,
    QuantitySold INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, ProductCode, Price)
VALUES 
    (1, "Laptop","LT001",799.99),
    (2, "Smartphone","SP002",499.99),
    (3, "Tablet","TB003",299.99),
    (4, "Headphones","HD004",149.99),
    (5, "Monitor","MN005",399.99);

INSERT INTO ProductSales(SaleID, ProductID, SaleDate, QuantitySold)
VALUES
    (1,1,'2023-08-01',10),
    (2,1,'2023-08-02',5),
    (3,2,'2023-08-02',8),
    (4,3,'2023-08-03',12),
    (5,3,'2023-08-03',6),
    (6,4,'2023-08-04',20),
    (7,5,'2023-08-04',15);

-- challenges 1
SELECT
    CASE
        WHEN Price < 300 THEN 'Low Price'
        WHEN Price >= 300 AND Price <= 600 THEN 'Medium Price'
        WHEN Price > 600 THEN 'High Price'
    END AS Price_Category,
    COUNT(*) AS Product_Count
FROM
    Products
GROUP BY
    Price_Category;

-- challenges 2
-- Ganti nilai N sesuai kebutuhan Anda
SET @N = 5;

SELECT
    p.ProductName,
    SUM(ps.QuantitySold) AS TotalQuantitySold
FROM
    ProductSales ps
INNER JOIN
    Products p ON ps.ProductID = p.ProductID
GROUP BY
    p.ProductName
ORDER BY
    TotalQuantitySold DESC
LIMIT 5;

-- Challenge 3: Pertumbuhan Penjualan Produk
SET @PreviousMonth = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);

SELECT
    p.ProductName,
    SUM(CASE WHEN ps.SaleDate >= @PreviousMonth THEN ps.QuantitySold ELSE 0 END) AS CurrentPeriodSales,
    SUM(CASE WHEN ps.SaleDate < @PreviousMonth THEN ps.QuantitySold ELSE 0 END) AS PreviousPeriodSales,
    CASE
        WHEN SUM(CASE WHEN ps.SaleDate < @PreviousMonth THEN ps.QuantitySold ELSE 0 END) = 0 THEN 100.00
        ELSE ROUND(SUM(CASE WHEN ps.SaleDate >= @PreviousMonth THEN ps.QuantitySold ELSE 0 END) / SUM(CASE WHEN ps.SaleDate < @PreviousMonth THEN ps.QuantitySold ELSE 0 END) * 100, 2)
    END AS SalesGrowthPercentage
FROM
    ProductSales ps
INNER JOIN
    Products p ON ps.ProductID = p.ProductID
GROUP BY
    p.ProductName
ORDER BY
    SalesGrowthPercentage DESC;


-- Challenge 4: Selisih Harga Rata-rata
SELECT
    p1.ProductID,
    p1.ProductName,
    p1.Price,
    ROUND(p1.Price - p2.PrevPrice, 2) AS AvgPriceDifference
FROM
    Products p1
LEFT JOIN
    (SELECT ProductID, Price AS PrevPrice FROM Products) p2
    ON p1.ProductID = p2.ProductID + 1
WHERE
    p1.ProductID != 1;

-- Challenge 5: Produk tanpa Harga
SELECT
    ProductName,
    ProductCode
FROM
    Products
WHERE
    Price IS NULL;



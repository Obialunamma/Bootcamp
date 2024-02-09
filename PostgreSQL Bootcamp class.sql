SELECT CURRENT_TIMESTAMP AS CurrentDateTime;

--Creating tables 
CREATE TABLE InvoiceData (
    InvoiceLineID SERIAL PRIMARY KEY,
    CustomerCode INT,
    TransactionID INT,
    Date DATE,
    PackageTypeID INT,
    Quantity INT,
    Sales NUMERIC(10, 2),
    TotalDryItems INT,
    TotalChillerItems INT
);


CREATE TABLE CustomerMasterData (
    CustomerID SERIAL PRIMARY KEY,
    CustomerGroup VARCHAR(50),
    CustomerName VARCHAR(100),
    CustomerCategoryName VARCHAR(100),
    PrimaryContact VARCHAR(100),
    City VARCHAR(100),
    Province VARCHAR(100)
);
--Coping in values into the created tables
COPY CustomerMasterData(CustomerID, CustomerGroup, CustomerName, CustomerCategoryName, PrimaryContact, City, Province)
FROM 'C:\\Users\\ADMIN\\Documents\\CustomerMasterData.csv' DELIMITER ',' CSV HEADER ENCODING 'LATIN1';

COPY InvoiceData(InvoiceLineID, CustomerCode, TransactionID, Date, PackageTypeID, Quantity, Sales, TotalDryItems, TotalChillerItems)
FROM 'C:\\Users\\ADMIN\\Documents\\InvoiceData.csv' DELIMITER ',' CSV HEADER ENCODING 'LATIN1';

--To view tables
SELECT * FROM invoicedata;

SELECT * FROM customermasterdata;

-- Calculations for Sales
SELECT MIN(Sales) FROM invoicedata;
SELECT MAX(Sales) FROM invoicedata;
SELECT SUM(Sales) FROM invoicedata;
SELECT AVG(Sales) FROM invoicedata;


--To save your result as a tabler
SELECT *
into Salesgreaterthan2000
FROM invoicedata
WHERE Sales >= 2000;

--To view the table
 SELECT * 
 FROM Salesgreaterthan2000

SELECT CustomerCode, MAX(Sales) AS MaxSales
FROM invoicedata
GROUP BY CustomerCode
HAVING MAX(Sales) > 15000;

-- Calculations for Quantity
SELECT MIN(Quantity) AS MINQuantity FROM invoicedata;
SELECT MAX(Quantity) AS MAXQuantity FROM invoicedata;
SELECT SUM(Quantity) AS SUMQuantity FROM invoicedata;
SELECT AVG(Quantity) AS AVGQuantity FROM invoicedata;

SELECT * FROM invoicedata
WHERE QUANTITY >= 100;

SELECT CustomerCode, AVG(Quantity) AS AverageQuantity
FROM invoicedata
GROUP BY CustomerCode
HAVING AVG(Quantity) >= 45;

-- Sum of TotalDryItems
SELECT SUM(TotalDryItems) AS TotalDryItems FROM invoicedata;

-- Sum of TotalChillerItems
SELECT SUM(TotalChillerItems) AS TotalDryItems FROM invoicedata;

-- Total quantity and AVG sales by year
SELECT EXTRACT(YEAR FROM Date) AS YEAR, 
       SUM(Quantity) AS TotalQuantity, 
       AVG(Sales) AS AVGSales
FROM invoicedata 
GROUP BY EXTRACT(YEAR FROM Date)
ORDER BY YEAR;

-- How many PackageTypeID
SELECT DISTINCT PackageTypeID AS PackageTypeID
FROM invoicedata;

-- Total sales and quantity by CustomerID
SELECT DISTINCT CustomerCode AS CustomerID, 
       SUM(Sales) AS TotalSales, 
       SUM(Quantity) AS TotalQuantity
FROM invoicedata
GROUP BY CustomerCode
ORDER BY CustomerID;

-- Joining two tables to see total sales and quantity by customername
SELECT m.CustomerName AS CustomerName, 
       SUM(i.Sales) AS TotalSales, 
       SUM(i.Quantity) AS TotalQuantity
FROM invoicedata i
JOIN customermasterdata m ON i.CustomerCode = m.CustomerID
GROUP BY m.CustomerName
ORDER BY m.CustomerName;


WITH NoveltyShop AS (
    SELECT customerName, customercategoryname
    FROM customermasterdata
    WHERE customercategoryname = 'Novelty Shop'
)
SELECT *
--into Novelty Shop
FROM NoveltyShop;

WITH Supermarket AS (
    SELECT customerName, customercategoryname
    FROM customermasterdata
    WHERE customercategoryname = 'Supermarket'
)
SELECT *
--into Novelty Shop
FROM Supermarket;










-- Quantity and sales by province
SELECT m.province AS province, 
       SUM(i.Sales) AS TotalSales, 
       SUM(i.Quantity) AS TotalQuantity
FROM invoicedata i
JOIN customermasterdata m ON i.CustomerCode = m.CustomerID
GROUP BY m.province
ORDER BY m.province;

-- Quantity and sales by customercategoryname
SELECT m.CustomerCategoryName AS customercategoryname, 
       AVG(i.Sales) AS AvgSales, 
       AVG(i.Quantity) AS AvgQuantity
FROM invoicedata i
JOIN customermasterdata m ON i.CustomerCode = m.CustomerID
GROUP BY m.CustomerCategoryName
-- ORDER BY SUM(i.Sales) DESC
ORDER BY AVG(i.Quantity) DESC;

-- Quantity sold and sales made by customergroup
SELECT m.CustomerGroup AS customergroup, 
       SUM(i.Sales) AS TotalSales, 
       SUM(i.Quantity) AS TotalQuantity
FROM invoicedata i
JOIN customermasterdata m ON i.CustomerCode = m.CustomerID
GROUP BY m.CustomerGroup
ORDER BY SUM(i.Quantity) DESC;


select customername
from customermasterdata
where customername like '%E_' or customername like '%e_';

select customername
from customermasterdata
where customername ilike '%E_';

SELECT PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY quantity) as median
FROM invoicedata

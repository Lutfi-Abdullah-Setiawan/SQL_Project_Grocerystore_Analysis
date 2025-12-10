/* 
Monthly Sales Performance
    Objective : Analyze sales performance within the four-month period to identify trends and patterns.
*/

--Calculate total sales for each month.--

SELECT
    TO_CHAR (salesdate, 'Month') AS month,
    COUNT(salesid) AS total_transaction,
    SUM (Quantity) AS total_product_sold,
    SUM(Price) AS total_price,
    SUM(Price * Quantity) AS Total_Gross_Sales,
    SUM(Price * Quantity) / SUM(Quantity) AS avg_price_per_unit,
    SUM(Price * Quantity * Discount) AS Total_Discount_Nominal,
    ROUND(SUM(Price * Quantity * (1 - Discount))) AS Total_Revenue
FROM sales
INNER JOIN 
    products ON sales.ProductID = products.ProductID
WHERE
    salesdate IS NOT NULL
GROUP BY 
    month
ORDER BY
    MIN(salesdate)
LIMIT 4

--Compare sales performance across different product categories each month.--

    SELECT 
        TO_CHAR (salesdate, 'Month') AS month,
        CategoryName,
        COUNT(salesid) AS total_transaction,
        SUM(Quantity) AS total_product_sold,
        ROUND (AVG (Price),0) AS avg_price,
        SUM(Price * Quantity * Discount) AS Total_Discount_Nominal,
        SUM(Price * Quantity * (1 - Discount)) AS Total_Revenue
    FROM Sales
    INNER JOIN
        products ON sales.ProductID = products.ProductID
    INNER JOIN
        categories ON products.CategoryID = categories.CategoryID
    WHERE salesdate IS NOT NULL
    GROUP BY 
        month, CategoryName, Price
    ORDER BY 
        MIN(salesdate)

SELECT productid, ProductName, Price, CategoryName
FROM Products
INNER JOIN 
    categories ON Products.CategoryID = categories.CategoryID
Where CategoryName = 'Produce'OR CategoryName = 'Seafood' 
Order by Price Desc


/*
Top Products Identification
    Objective: Determine which products are the best and worst performers within the dataset timeframe
    */


--Rank products Category based on total sales revenue--

WITH Product_Sales AS (
    SELECT
    Productid,
    ProductName,
    CategoryID,
    SUM(discount) AS total_discount,
    SUM(Quantity) AS total_product_sold,
    ROUND(SUM(Quantity * Price * (1 - Discount)), 0) AS sales_revenue_product
    From Sales
    INNER JOIN products USING (ProductID)
    WHERE salesdate IS NOT NULL
    GROUP BY ProductID, ProductName, CategoryID)
SELECT 
    CategoryID,
    Categoryname,
    SUM(total_discount) AS total_category_discount,
    SUM(total_product_sold) AS total_category_sold,
    SUM(sales_revenue_product) AS sales_revenue_category
FROM categories
INNER JOIN Product_Sales USING (CategoryID)
GROUP BY CategoryID, CategoryName
ORDER BY sales_revenue_category DESC
LIMIT 10

SELECT * From products WHERE productid = 345

--Analyze sales quantity and revenue to identify high-demand products.--

SELECT
    ProductID,
    ProductName,
    ROUND(AVG (Price),0) AS product_price,
    SUM(Quantity) AS total_product_sold,
    ROUND(AVG(Price) * SUM(Quantity), 0)AS total_sales_revenue
FROM sales
INNER JOIN products USING (ProductID)
WHERE salesdate IS NOT NULL
GROUP BY ProductID, ProductName
ORDER BY total_product_sold DESC
LIMIT 20

--Examine the impact of product classifications on sales performance.--

SELECT 
    Class,
    TO_CHAR (salesdate, 'Month') AS month,
    COUNT(sales.productid) AS total_product,
    AVG(Price),0 AS avg_product_price,
    SUM(Quantity)*AVG(price) AS total_sales_revenue
FROM sales
INNER JOIN products ON sales.ProductID = products.ProductID
WHERE salesdate IS NOT NULL
GROUP BY Class
ORDER BY total_sales_revenue DESC


SELECT * FROM products
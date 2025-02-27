/*
Top Products Identification
    Objective: Determine which products are the best and worst performers within the dataset timeframe
    */


--Rank products based on total sales revenue--

SELECT
    ProductID,
    ProductName,
    ROUND(AVG (Price),0) AS product_price,
    AVG(discount) AS discount_avg,
    SUM(Quantity) AS total_product_sold,
    ROUND(SUM(Quantity * Price * (1 - Discount)), 0) AS total_sales_revenue
FROM sales
INNER JOIN products USING (ProductID)
WHERE salesdate IS NOT NULL
GROUP BY ProductID, ProductName
ORDER BY total_sales_revenue DESC
LIMIT 20


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
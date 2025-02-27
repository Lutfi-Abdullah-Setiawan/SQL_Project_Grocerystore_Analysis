/* 
Monthly Sales Performance
    Objective : Analyze sales performance within the four-month period to identify trends and patterns.
*/

--Calculate total sales for each month.--

SELECT
    TO_CHAR (salesdate, 'Month') AS month,
    SUM (Quantity) AS total_product_sold,
    COUNT(salesid) AS total_transaction,
    ROUND(AVG(Price),0)* SUM(Quantity) AS total_sales_revenue
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
        SUM(Quantity) AS total_product_sold,
        COUNT(salesid) AS total_transaction,
        ROUND(SUM(Quantity)*AVG(price),0) AS total_sales_revenue
    FROM Sales
    INNER JOIN
        products ON sales.ProductID = products.ProductID
    INNER JOIN
        categories ON products.CategoryID = categories.CategoryID
    WHERE salesdate IS NOT NULL
    GROUP BY 
        month, CategoryName
    ORDER BY 
        MIN(salesdate)




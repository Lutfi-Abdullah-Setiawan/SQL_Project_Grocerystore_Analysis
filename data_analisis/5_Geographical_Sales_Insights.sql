/*
    Objective: Explore how sales are distributed across different cities and countries within the dataset
    */

--Map sales data to specific cities and countries to identify high-performing regions --

WITH geographical AS (
    SELECT  
        CityID,
        CityName,
        CountryID,
        CountryName
    FROM cities
INNER JOIN countries USING (CountryID)
),
Sales_by_customers AS ( 
    SELECT
        CustomerID,
        CityID,
        COUNT(salesid) AS total_sales,
        SUM (Price) AS total_revenue,
        SUM(Quantity) AS total_product_sold
FROM sales
FULL OUTER JOIN customers USING (CustomerID)
INNER JOIN products ON sales.productid = products.productid
WHERE salesdate IS NOT NULL
GROUP BY   
    CustomerID, CityID
)
SELECT
        CityID,
        CityName,
        CountryID,
        CountryName,
        total_sales,
        total_product_sold,
        total_revenue
FROM geographical
INNER JOIN Sales_by_customers USING (CityID)
ORDER BY total_revenue DESC


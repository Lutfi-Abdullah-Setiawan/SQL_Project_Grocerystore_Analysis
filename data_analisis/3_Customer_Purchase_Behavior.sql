/*
Objective: Understand how customers interact with products during the four-month period.
*/


--Segment customers based on their purchase frequency and total spend.--

WITH customer_activity AS (
    SELECT
        CustomerID,
        FirstName AS customer_name,
        SUM(Price) AS total_price,
        COUNT(CustomerID) AS total_order
    FROM sales AS s
    INNER JOIN customers USING (CustomerID)
    INNER JOIN products AS p ON s.productid = p.productid
    WHERE salesdate IS NOT NULL
    GROUP BY CustomerID, customer_name
)
SELECT
    CustomerID,
    customer_name,
    total_price,
    total_order,
    CASE 
        WHEN total_price >= 3500 AND total_order >= 75 THEN 'HIgh-Value Customer'
        WHEN total_price >= 2000 AND total_order >= 50 THEN 'Loyal Customer'
        WHEN total_order >= 25 THEN 'Occasional Buyer'
        ELSE 'Low-Value Customer'
    END AS customer_segment
FROM customer_activity
ORDER BY total_price DESC

--Identify repeat customers versus one-time buyers.--

WITH purchasing_activity AS (
    SELECT 
        CustomerID,
        FirstName AS customer_name,
        SUM(Price) AS total_price,
        COUNT (DISTINCT TO_CHAR (salesdate, 'Month')) AS order_date
    FROM sales AS s
    INNER JOIN customers USING (CustomerID)
    INNER JOIN products AS p ON s.productid = p.productid
    WHERE salesdate IS NOT NULL
    GROUP BY CustomerID, customer_name
)
SELECT
    CustomerID,
    customer_name,
    total_price,
    order_date,
    CASE 
        WHEN order_date > 2 THEN 'Repeat Customers' 
        When order_date <= 2 THEN 'One-Time Buyer'
        END AS purchasing_segment
    FROM purchasing_activity
    ORDER BY total_price ASC
    LIMIT 10
    

--Analyze average order value and basket size.--

WITH order_value AS (
    SELECT 
        CustomerID,
        FirstName AS customer_name,
        SUM(price) AS revenue,
        COUNT(salesid) AS total_order
FROM sales AS s
    INNER JOIN 
        customers USING (CustomerID)
    INNER JOIN 
        products AS p ON s.productid = p.productid
    WHERE 
        salesdate IS NOT NULL
    GROUP BY 
        CustomerID, customer_name
),
basket_value AS (
    SELECT 
        CustomerID,
        SUM(Quantity) AS basket_size
    FROM sales AS s
        INNER JOIN 
            customers USING (CustomerID)
        INNER JOIN 
            products AS p ON s.productid = p.productid
        WHERE 
            salesdate IS NOT NULL
        GROUP BY 
            CustomerID
)
SELECT
    CustomerID,
    customer_name,
    revenue / total_order AS avg_order_value,
    basket_size / total_order AS Avg_basket_size
FROM 
    order_value
JOIN basket_value USING (CustomerID)
ORDER BY 
    avg_order_value DESC, Avg_basket_size DESC


SELECT 
    salesid,
    CustomerID,
    FirstName,
    ProductName,
    Price,
    Quantity,
    salesdate
FROM sales
INNER JOIN customers USING (CustomerID)
INNER JOIN products ON sales.productid = products.productid 
WHERE CustomerID = '66137'
    
SELECT Quantity FROM sales
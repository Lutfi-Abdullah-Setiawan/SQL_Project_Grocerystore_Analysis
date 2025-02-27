/*
Objective: Evaluate the performance of sales personnel in driving sales.
*/

--Calculate total sales attributed to each salesperson.--
SELECT
    EmployeeID,
    CONCAT(FirstName, ' ',MiddleInitial, ' ',LastName) AS EmployeeName,
    COUNT(salesid) AS total_order,
    COUNT(DISTINCT CustomerID) AS total_customer
FROM sales
INNER JOIN 
    employees USING (employeeid)
WHERE
    salesdate IS NOT NULL
GROUP BY
    employeeid, EmployeeName
ORDER BY total_order DESC
    

--Identify top-performing and underperforming sales staff.--
WITH sales_staff AS (
    SELECT
        EmployeeID,
        CONCAT(FirstName, ' ',MiddleInitial, ' ',LastName) AS EmployeeName,
        COUNT(salesid) AS total_order,
        COUNT(DISTINCT CustomerID) AS total_customer
    FROM sales
    INNER JOIN 
        employees USING (employeeid)
    WHERE
        salesdate IS NOT NULL
    GROUP BY
        employeeid, EmployeeName
)
SELECT
    EmployeeID,
    EmployeeName,
    total_order,
    total_customer,
    CASE
        WHEN total_order > 270000 THEN 'top-performing'
        ELSE 'underperforming'
        END AS employee_performance
FROM sales_staff
ORDER BY total_order DESC


--Analyze sales trends based on individual salesperson contributions over time.--

WITH monthly_sales AS (
    SELECT 
        EmployeeID,
        CONCAT(FirstName, ' ',MiddleInitial, ' ',LastName) AS EmployeeName,
        DATE_TRUNC('month', salesdate) AS sales_month,
        COUNT(ProductID) AS total_units_sold,
        ROUND(SUM(Quantity)*AVG(price),0) AS total_revenue_generated
    FROM sales
    INNER JOIN employees USING (EmployeeID)
    INNER JOIN Products USING (ProductID)
    WHERE salesdate IS NOT NULL
    GROUP BY EmployeeID, EmployeeName, sales_month
)

SELECT 
    EmployeeID,
    EmployeeName,
    sales_month,
    total_units_sold,
    total_revenue_generated,
    LAG(total_units_sold) OVER (PARTITION BY EmployeeID ORDER BY sales_month) AS prev_units_sold,
    LAG(total_revenue_generated) OVER (PARTITION BY EmployeeID ORDER BY sales_month) AS prev_revenue,
    
    -- Calculate % change in sales quantity
    ROUND(
        (total_units_sold - LAG(total_units_sold) OVER (PARTITION BY EmployeeID ORDER BY sales_month)) 
        * 100.0 / NULLIF(LAG(total_units_sold) OVER (PARTITION BY EmployeeID ORDER BY sales_month), 0),
        2
    ) AS sales_growth_pct,

    -- Calculate % change in revenue
    ROUND(
        (total_revenue_generated - LAG(total_revenue_generated) OVER (PARTITION BY EmployeeID ORDER BY sales_month)) 
        * 100.0 / NULLIF(LAG(total_revenue_generated) OVER (PARTITION BY EmployeeID ORDER BY sales_month), 0),
        2
    ) AS revenue_growth_pct
FROM monthly_sales
ORDER BY EmployeeID, sales_month;

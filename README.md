# Introduction
This report presents an analytical overview of a grocery store dataset over a four-month period. The goal is to identify key sales trends, understand product and customer behavior, evaluate staff performance, and examine geographical sales distribution. This analysis provides insights that can help optimize business decisions, improve sales strategies, and enhance customer experiences.

# Background
Data hails from [Kaggle](https://www.kaggle.com/datasets/bhavikjikadara/grocery-store-dataset). It's packed with insights on sales, product and employees or sales person.

### The question I want to answer through my SQL queries were :

1. How sales performance within the four-month period?
2. Which products are the best and worst performers within the dataset timeframe?
3. How customers interact with products during the four-month period?
4. How the performance of sales personnel in driving sales?
5. How sales are distributed across different cities and countries within the dataset ?

# Tools I Used 
For my deep dive into the data analyst Groceries Store, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database an unearth critical insight.
- **PostgreSQL:** The choosen database management system, ideal handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & Github:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst groceries store. Here how I approached each question:

### 1. Monthly Sales Performance
Calculate total sales for each month To Analyze sales performance within the four-month period to identify trends and patterns. 

```sql
SELECT
    TO_CHAR (salesdate, 'Month') AS month,
    COUNT(salesid) AS total_transaction,
    SUM (Quantity) AS total_product_sold,
    SUM(Price) AS total_price,
    SUM(Price * Quantity) AS Total_Gross_Sales,
    SUM(Price * Quantity) / SUM(Quantity) AS avg_price_per_unit,
    SUM(Price * Quantity * Discount) AS Total_Discount_Nominal,
    SUM(Price * Quantity * (1 - Discount)) AS Total_Revenue
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
```
Results :
| Month     | Total Transactions | Total Products Sold | Total Price   | Total Gross Sales | Avg Price per Unit | Total Discount Nominal | Total Revenue     |
|-----------|--------------------|----------------------|----------------|--------------------|---------------------|-------------------------|--------------------|
| January   | 1,607,050          | 20,900,454           | 81,722,153     | 1,063,063,745      | 50.86               | 31,759,498.70           | 1,031,304,246.30   |
| February  | 1,451,366          | 18,862,843           | 73,752,077     | 958,419,304        | 50.81               | 28,691,537.50           | 929,727,766.50     |
| March     | 1,609,190          | 20,930,945           | 81,876,763     | 1,064,701,081      | 50.87               | 31,911,706.50           | 1,032,789,374.50   |
| April     | 1,556,091          | 20,229,466           | 79,142,745     | 1,028,729,102      | 50.85               | 30,900,050.40           | 997,829,051.60     |

Here's the breakdown of the top data analyst jobs in 2023

To understand sales dynamics over the four-month period, I calculated several key performance indicators using SQL, including total transactions, quantity sold, gross sales, average unit price, total discount value, and total revenue after discounts. By grouping the data by month, this query reveals how sales activity fluctuated and what patterns emerged across the observed time frame.

The query first counts the total number of sales transactions (COUNT(salesid)), providing insight into how frequently customers made purchases each month. It then aggregates the total number of products sold (SUM(Quantity)), which highlights changes in customer purchasing volume even if transaction counts remain steady.

To evaluate financial performance, the query computes the Total Gross Sales (SUM(Price * Quantity)), representing revenue before any discounts are applied. Alongside this, it calculates the average price per unit sold (SUM(Price * Quantity) / SUM(Quantity)), allowing us to assess monthly pricing consistency and identify potential shifts in product mix or customer purchasing behavior.

The query also measures the impact of discounts by generating the Total Discount Nominal (SUM(Price * Quantity * Discount)), showing how much revenue was reduced due to promotional activity or markdowns. After accounting for discounts, the final metric, Total Revenue (SUM(Price * Quantity * (1 - Discount))), reflects the actual income generated for each month.

By comparing these metrics month-to-month, we can identify peaks in demand, slump periods, seasonal trends, or the effects of pricing and discount strategies. This breakdown serves as the foundation for evaluating overall business performance and making informed decisions about sales planning, product strategy, and revenue management over the four-month timeframe.

### 2. Top Products Identification
To Determine which products are the best and worst performers within the dataset timeframe.

#### Top 10 Best-Selling Products (by Revenue)
```sql
SELECT
    ProductID,
    ProductName,
    Price,
    SUM(discount) AS total_discount,
    SUM(Quantity) AS total_product_sold,
    ROUND(SUM(Quantity * Price * (1 - Discount)), 0) AS total_sales_revenue
FROM sales
INNER JOIN products USING (ProductID)
WHERE salesdate IS NOT NULL
GROUP BY ProductID, ProductName, Price
ORDER BY total_sales_revenue DESC
LIMIT 10
```
Results : 

| Rank | Product ID | Product Name               | Price | Total Discount | Total Products Sold | Total Sales Revenue |
|------|------------|----------------------------|-------|----------------|----------------------|----------------------|
| 1    | 345        | Bread - Calabrese Baguette | 99    | 414.20         | 181,701              | 17,451,453           |
| 2    | 392        | Puree - Passion Fruit      | 99    | 403.60         | 179,876              | 17,290,400           |
| 3    | 98         | Shrimp - 31/40             | 100   | 408.70         | 178,234              | 17,287,550           |
| 4    | 104        | Tia Maria                  | 98    | 426.50         | 180,385              | 17,131,811           |
| 5    | 268        | Vanilla Beans              | 98    | 419.70         | 179,558              | 17,068,601           |
| 6    | 149        | Zucchini - Yellow          | 98    | 414.20         | 178,768              | 16,997,737           |
| 7    | 298        | Pop Shoppe Cream Soda      | 96    | 406.60         | 181,171              | 16,882,445           |
| 8    | 328        | Tuna - Salad Premix        | 97    | 416.80         | 179,317              | 16,865,536           |
| 9    | 32         | Lettuce - Treviso          | 96    | 414.70         | 180,893              | 16,842,288           |
| 10   | 201        | Grenadine                  | 96    | 411.50         | 180,670              | 16,828,867           |

### 3. Segment customers based on their purchase frequency and total spend
This query helped Understand how customers interact with products during the four-month period.
```sql
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
```
Results :


### 4. Calculate total sales attributed to each salesperson
To Evaluate the performance of sales personnel in driving sales.
```sql
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
```
Results :


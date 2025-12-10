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
- **PostgreSQL:** The choosen database management system, ideal handling the groceries store data.
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

Here's the breakdown of the Sales revenue over four-month period

To understand sales dynamics over the four-month period, I calculated several key performance indicators using SQL, including total transactions, quantity sold, gross sales, average unit price, total discount value, and total revenue after discounts. By grouping the data by month, this query reveals how sales activity fluctuated and what patterns emerged across the observed time frame.

![Sales_by_Month](Assets\Sales_by_Month.png) 
*Line Chart visualizing the total revenue by month; I use excel to make this graph and using data from my sql query results*

By comparing these metrics month-to-month, we can identify peaks in demand, slump periods, seasonal trends, or the effects of pricing and discount strategies. This breakdown serves as the foundation for evaluating overall business performance and making informed decisions about sales planning, product strategy, and revenue management over the four-month timeframe.

### 2. Top Products Identification
To Determine which products are the best and worst performers within the dataset timeframe.

#### Top 10 Best-Selling Products Category (by Revenue)
```sql
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
```
![Top10_Sales_by_Category](Assets\Sales_by_Category.png)
Graph Bar Chart visualizing the Top 10 Revenue by Category; I use excel to make this graph and using data from my sql query results*

Here's the breakdown of the Top 10 Sales by Categories :

The Confections category leads sales significantly, indicating strong market demand and effective product placement. Meat and Poultry follow closely, reflecting their role as essential consumer staples. Meanwhile, mid-level categories such as Cereals and Produce offer opportunities for targeted promotional growth. The lowest performers within the top 10—Seafood and Grain—may require evaluation regarding supply chain, pricing strategy, or consumer preferences

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
Here's the Breakdown of the Segment customers based on their purchase frequency and total spend:

Based on customer segmentation using aggregated sales and order frequency, customers fall into four categories: High-Value Customers, Loyal Customers, Occasional Buyers, and Low-Value Customers. The segmentation highlights that a subset of customers generates the majority of revenue, indicating a high-value cluster that should be prioritized for retention. Additionally, the analysis reveals varying purchasing behaviors—some customers purchase frequently with lower transaction values, while others make fewer but higher-value purchases. This segmentation provides actionable insight for targeted marketing, personalized promotions, and customer lifetime value optimization.

### 4. Calculate total sales attributed to each salesperson
To Evaluate the performance of sales personnel in driving sales.
```sql
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
```
Results :

| employeeid | employeename       | total_order | total_customer | employee_performance |
| ---------: | ------------------ | ----------: | -------------: | -------------------- |
|         21 | Devon D Brewer     |      271720 |          92412 | top-performing       |
|          4 | Darnell O Nielsen  |      271366 |          92376 | top-performing       |
|         18 | Warren C Bartlett  |      271325 |          92395 | top-performing       |
|          8 | Julie E Dyer       |      271289 |          92419 | top-performing       |
|          9 | Daphne X King      |      270877 |          92366 | top-performing       |
|         15 | Kari D Finley      |      270855 |          92462 | top-performing       |
|         11 | Sonya E Dickson    |      270829 |          92266 | top-performing       |
|         10 | Jean P Vang        |      270815 |          92481 | top-performing       |
|          7 | Chadwick P Cook    |      270731 |          92416 | top-performing       |
|         19 | Bernard L Moody    |      270646 |          92296 | top-performing       |
|          2 | Christine W Palmer |      270564 |          92401 | top-performing       |
|          6 | Holly E Collins    |      270559 |          92354 | top-performing       |
|         16 | Chadwick U Walton  |      270505 |          92334 | top-performing       |
|         23 | Janet K Flowers    |      270456 |          92390 | top-performing       |
|          5 | Desiree L Stuart   |      270455 |          92377 | top-performing       |
|         14 | Wendi G Buckley    |      270431 |          92404 | top-performing       |
|         13 | Katina Y Marks     |      270420 |          92343 | top-performing       |
|         20 | Shelby P Riddle    |      270337 |          92279 | top-performing       |
|         12 | Lindsay M Chen     |      270154 |          92323 | top-performing       |
|          3 | Pablo Y Cline      |      270048 |          92392 | top-performing       |
|         22 | Tonia O Mc Millan  |      269955 |          92353 | underperforming      |
|          1 | Nicole T Fuller    |      269864 |          92323 | underperforming      |
|         17 | Seth D Franco      |      269496 |          92378 | underperforming      |

Here's The Breakdown of the total sales attributed to each salesperson:

I performed a detailed employee performance analysis using a dataset of 23 sales employees. Metrics included total orders, total customers served, and performance labels. I categorized employees into top-performing and underperforming groups, calculated averages, and identified insights regarding productivity distribution.

Results showed that 87% of the team were top performers with remarkably consistent output, while underperformers deviated only mildly from the group average, indicating a strong overall team performance.

### 5. Map sales data to specific cities and countries to identify high-performing regions
To Explore how sales are distributed across different cities and countries within the dataset 
```sql
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
        SUM(Quantity) AS total_product_sold,
         ROUND(SUM(Price * Quantity * (1 - Discount))) AS Total_Revenue
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
```
Here's The Breakdown :
I created a geographic revenue analysis using SQL by integrating the cities, countries, customers, products, and sales tables.

Using CTEs, I engineered a clean data model that aggregates customer sales activity and ranks cities based on total revenue. This analysis revealed key insights such as top revenue-generating regions, customer purchasing behavior by location, and product demand across cities.

These findings support strategic decisions in marketing, sales resource allocation, inventory planning, and market expansion. This project demonstrates my ability to design analytical SQL pipelines, perform complex joins, and extract business-ready insights from multi-source datasets.

# What I Learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp tables maneuvers.
- **Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **Analytical Wizardly:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions
Through this deep dive into the groceries store data set, several key insights emerged that can guide stakeholder to make a great decesion.

1. Across multiple analytical dimensions—monthly sales performance, product category trends, customer segmentation, employee productivity, and geographic revenue distribution—this project provides a comprehensive view of business performance and market dynamics. By leveraging SQL to engineer clean datasets, aggregate metrics, and uncover patterns, the analysis reveals several key strategic insights.
2. Monthly sales analysis shows meaningful fluctuations in transactions, revenue, and product demand over the four-month period. Identifying these patterns enables better forecasting, seasonal planning, and evaluation of pricing and discount strategies. From a product perspective, the Confections category emerges as the strongest contributor to sales, while other categories such as Cereals and Produce show mid-level potential for targeted marketing efforts. Lower-performing categories signal opportunities for optimization or strategic review.
3. Customer segmentation highlights that a relatively small group of high-value consumers drives a disproportionate share of total revenue. Understanding the distribution of High-Value Customers, Loyal Customers, Occasional Buyers, and Low-Value Customers supports tailored engagement strategies, retention initiatives, and personalized marketing designed to maximize customer lifetime value.
4. Employee performance analysis reveals a high-performing sales team, with most employees achieving consistent results. This indicates operational strength in sales execution, while minor performance gaps among underperformers suggest opportunities for targeted coaching rather than systemic issues.
5. Geographic revenue analysis adds a spatial dimension to these insights by identifying the cities and countries that generate the highest revenue. This information supports informed decisions on market expansion, localized promotions, inventory allocation, and strategic resource placement.

**Final Thought**
Overall, this project demonstrates the ability to build analytic SQL pipelines, integrate multi-table data sources, and convert raw data into actionable business intelligence. The insights obtained can guide leadership in making data-driven decisions related to sales strategy, marketing prioritization, customer relationship management, and organizational performance optimization.
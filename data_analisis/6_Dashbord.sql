--sales by sales person--
WITH sales_data AS (
    SELECT
        sales.SalesID,
        CustomerID,
        ProductID,
        TO_CHAR (salesdate, 'Month') AS month,
        CONCAT(employees.FirstName, ' ',employees.MiddleInitial, ' ',employees.LastName) AS Sales_person,
        employees.gender,
        quantity
    FROM
        sales 
    INNER JOIN employees ON sales.employeeid = employees.employeeid
    WHERE 
        salesdate IS NOT NULL
), customer_data AS (
    SELECT
        CustomerID,
        CONCAT(customers.FirstName, ' ',customers.MiddleInitial, ' ',customers.LastName) AS CustomerName,
        CityName,
        CountryName
    FROM
        customers
    INNER JOIN cities ON customers.cityid = cities.cityid
    INNER JOIN countries ON cities.countryid  = countries.countryid
), Product_data AS (
    SELECT
        sales.productid,
        productname,
        CategoryName,
        Class,
        Price,
        discount,
        quantity * Price AS total_price
FROM
    sales 
INNER JOIN products ON sales.productid = products.productid
INNER JOIN categories ON products.categoryid = categories.categoryid
WHERE 
    salesdate IS NOT NULL
)
SELECT
    SalesID,
    month,
    Sales_person,
    gender,
    CustomerName,
    CityName,
    CountryName,
    productid,
     productname,
    CategoryName,
    Class,
    Price,
    quantity,
    discount,
    total_price
FROM
    sales_data
JOIN customer_data USING (CustomerID)
JOIN Product_data USING (ProductID)

-- sales by product
SELECT
    sales.ProductID AS ID,
    ProductName,
    TO_CHAR (salesdate, 'Month') AS month,
    COUNT(sales.CustomerID) AS total_customer,
    SUM(sales.Quantity) AS total_product_sold,
    ROUND(AVG(products.Price),0)*SUM(sales.Quantity) AS total_revenue
FROM
    sales
INNER JOIN customers ON sales.customerid = customers.customerid
INNER JOIN products ON sales.productid = products.productid
WHERE 
    salesdate IS NOT NULL
GROUP BY
    ID, ProductName, month
ORDER BY 
    total_revenue

SELECT * FROM DASHBORD
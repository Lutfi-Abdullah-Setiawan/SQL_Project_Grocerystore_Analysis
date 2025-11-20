/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy categories FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\categories.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy countries FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\countries.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy cities FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\Cities.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy customers FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\customers.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy employees FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\employees.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy products FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\products.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy sales FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\sales.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

COPY categories
FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\categories.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY cities
FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\cities.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY countries
FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\countries.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY customers
FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\customers.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY employees
FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\employees.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY products
FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\products.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY sales
FROM 'C:\Users\acer\OneDrive\Documents\Dataset\grocery_sales_dataset\csv\sales.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

ALTER TABLE customers
ALTER COLUMN MiddleInitial TYPE VARCHAR (10)

ALTER TABLE products
ADD COLUMN VitalityDays DECIMAL (3,0)

SELECT * FROM products

DROP TABLE products

UPDATE sales
SET salesdate = NULL
WHERE salesdate >= '2018-5-1' 
AND salesdate < '2018-5-31'

ALTER TABLE cities DROP Column Zipcode

ALTER TABLE cities ADD Postal_code VARCHAR(10)

SET postal_code = CASE 
    WHEN cityname = 'Los Angeles' THEN '90001'
    WHEN cityname = 'Seattle' THEN '98101'
    WHEN cityname = 'St. Paul' THEN '55101'
    WHEN cityname = 'Grand Rapids' THEN '49501'
    WHEN cityname = 'Jacksonville' THEN '32099'
    WHEN cityname = 'Hialeah' THEN '33002'
    WHEN cityname = 'Jersey City' THEN '07097'
    WHEN cityname = 'Yonkers' THEN '10701'
    WHEN cityname = 'Garland' THEN '75040'
    WHEN cityname = 'Pittsburgh' THEN '15201'
    ELSE postal_code

    DROP TABLE cities CASCADE;

UPDATE Products
SET Price = 1
WHERE ProductName = 'Pastry - Raisin Muffin - Mini';

UPDATE Products
SET Price = 2
WHERE ProductName = 'Apricots - Halves';

UPDATE Products
SET Price = 3
WHERE ProductName = 'Bread Crumbs - Japanese Style';
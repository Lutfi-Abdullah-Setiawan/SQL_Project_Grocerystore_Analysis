-- Create categories table with primary key
CREATE TABLE public.categories
(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(45)
);

-- Create countries table with primary key
CREATE TABLE public.countries
(
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(45),
    CountryCode VARCHAR(2)
);

-- Create cities table with primary key
DROP TABLE IF EXISTS public.cities;
CREATE TABLE public.cities
(
    CityID INT PRIMARY KEY,
    CityName VARCHAR(45),
    Postal_code VARCHAR(10),
   	CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES public.countries (CountryID)
);

-- Create customers table with primary key
CREATE TABLE public.customers
(
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(45),
    MiddleInitial VARCHAR(1),
    LastName VARCHAR(45),
    CityID INT,
    Address VARCHAR (90),
    FOREIGN KEY (CityID) REFERENCES public.cities(CityID)
);

-- Create employees table with primary key
CREATE TABLE public.employees
(
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(45),
    MiddleInitial VARCHAR(1),
    LastName VARCHAR(45),
    BirthDate DATE,
    Gender VARCHAR (10),
    CityID INT,
    HireDate DATE,
    FOREIGN KEY (CityID) REFERENCES public.cities(CityID)
);

-- Create products table with primary key
CREATE TABLE public.products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(45),
    Price DECIMAL(4,0),
    CategoryID INT,
    Class VARCHAR (15),
    ModifyDate DATE,
    Resistant VARCHAR (15),
    IsAllergic VARCHAR,
    VitalityDays DECIMAL (3,0)
);

-- Create products table with primary key
CREATE TABLE public.sales
(
    SalesID INT PRIMARY KEY,
    EmployeeID INT,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    Discount DECIMAL (10,2),
    TotalPrice DECIMAL (10,2),
    SalesDate TIMESTAMP,
    TransactionNumber VARCHAR (25),
    FOREIGN KEY (EmployeeID) REFERENCES public.employees (EmployeeID),
    FOREIGN KEY (CustomerID) REFERENCES public.customers (CustomerID),
    FOREIGN KEY (ProductID) REFERENCES public.products (ProductID)
);

-- Set ownership of the tables to the postgres user
ALTER TABLE public.categories OWNER to postgres;
ALTER TABLE public.cities OWNER to postgres;
ALTER TABLE public.countries OWNER to postgres;
ALTER TABLE public.customers OWNER to postgres;
ALTER TABLE public.employees OWNER to postgres;
ALTER TABLE public.products OWNER to postgres;
ALTER TABLE public.sales OWNER to postgres;

-- Create indexes on foreign key columns for better performance
CREATE INDEX idx_CountryID ON public.cities (CountryID);
CREATE INDEX idx_CityID ON public.customers (CityID);
CREATE INDEX idx_EmployeeID ON public.sales (EmployeeID);
CREATE INDEX idx_CustomersID ON public.sales (CustomerID);
CREATE INDEX idx_ProductID ON public.sales (ProductID);
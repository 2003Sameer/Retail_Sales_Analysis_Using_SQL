# Retail_Sales_Analysis_Using_SQL

## Project Title: Retail Sales Analysis

## Project Overview
This project demonstrate setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives
#### Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
#### Data Cleaning: Identify and remove any records with missing or null values.
#### Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
#### Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.


## Project Structure

### 1. Database Setup
Database Creation: The project starts by creating a database named my_project
Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

``` sql
CREATE DATABASE my_project;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning
Record Count: Determine the total number of records in the dataset.
``` sql
-- DATA EXPLORATION --
-- Q1. HOW MANY SALES WE HAVE ? --
 
SELECT COUNT(*) AS Total_Sales FROM retail_sales;
```
Customer Count: Find out how many unique customers are in the dataset.
``` sql
-- Q2. HOW MANY UNIQUE CUSTOMERS WE HAVE ? --

SELECT COUNT(DISTINCT customer_id) as Total_Customers FROM retail_sales;
```
Category Count: Identify all unique product categories in the dataset.
```sql
-- Q3. HOW MANY UNIQUE CATEGORY WE HAVE ? --

SELECT DISTINCT category FROM retail_sales;
```
Null Value Check: Check for any null values in the dataset and delete records with missing data.
``` sql
-- NULL VALUE CHECK --

SELECT * FROM retail_sales
WHERE 
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
```

Delete Null Value:
``` sql
DELETE FROM retail_sales
WHERE
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
```

### 3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:

DATA ANALYSIS AND BUSINESS KPI FINDING 

* Q1. WRITE A SQL QUERY TO RETREIVE ALL FOR SALES MADE ON '2022-11-05'
``` sql
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';
```

* Q2. WRITE A SQL QUERY TO RETREIVE ALL TRANSACTIONS WHERE THE CATEGORY IS 'CLOTHING' AND THE QUANTITY SOLD IS MORE THAN OR EQUAL TO 4 IN THE MONTH OF NOV-2022 --
``` sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND 
	quantity >= 4;
```

* Q3. WRITE A SQL QUERY TO CALCULATE THE TOTAL SALES FOR EACH CATEGORY -- 
``` sql
SELECT 
	Category, 
	SUM(total_sale) as Total_Sales,
	COUNT(*) as Total_Orders
FROM retail_sales
GROUP BY 1;
```

* Q4. WRITE A SQL QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE 'BEAUTY' CATEGORY
``` sql
SELECT ROUND(AVG(age),2) as Average_Age
FROM retail_sales
WHERE Category = 'Beauty';
```

* Q5. WRITE A SQL QUERY TO FIND ALL TRANSACTIONS WHERE THE TOTAL SALES IS GREATER THAN 1000
``` sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

* Q6. WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTIONS(transaction_id) MADE BY EACH GENDER IN EACH CATEGORY
``` sql
SELECT
	Category,
	gender,
	COUNT(*) as Count_Of_Transaction_Id
FROM retail_sales
GROUP BY Category,gender
ORDER BY 1;
```

* Q7. WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH.FIND OUT THE BEST SELLING MONTH IN EACH YEAR
``` sql
SELECT 
	year,
	month,
	avg_sale
FROM
(
SELECT 
	EXTRACT (YEAR FROM sale_date) AS year,
	EXTRACT (MONTH FROM sale_date) AS month,
	AVG(total_sale) as avg_sale,
	RANK() OVER (PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1
```

* Q8. WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON HIGHEST TOTAL SALES
``` sql
SELECT 
	customer_id,
	SUM(total_sale) as SUM_TOTAL_SALES
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
Limit 5;
```

* Q9. WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY
``` sql
SELECT 
		category , 
		COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMER_COUNT
FROM retail_sales
GROUP BY category
```

* Q10. WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS(example - Morning < 12, Afternoon Between 12 & 17, Evening > 17)
``` sql
WITH hourly_sales
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning Shift'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon Shift'
		ELSE 'Evening Shift'
	END AS Shift_Timing 
FROM retail_sales
)
SELECT
	Shift_Timing,
	COUNT(*) AS Total_Orders 
FROM hourly_sales
GROUP BY Shift_Timing
```

-- END OF PROJECT --

## Findings

Customer Demographics: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.

High-Value Transactions: Several transactions had a total sale amount greater than 1000, indicating premium purchases.

Sales Trends: Monthly analysis shows variations in sales, helping identify peak seasons.

Customer Insights: The analysis identifies the top-spending customers and the most popular product categories.

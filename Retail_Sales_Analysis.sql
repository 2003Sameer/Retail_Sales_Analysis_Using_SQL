-- SQL RETAIL SALES ANALYSIS PROJECT --
CREATE DATABASE my_project;

-- CHECK IF TABLE ALREADY EXIST OR NOT --
DROP TABLE IF EXISTS retail_sales;

-- CREATE TABLE --
CREATE TABLE retail_sales
           (
				transaction_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT 
			); 


-- CHECK FIRST 10 ROWS --
SELECT * FROM retail_sales
LIMIT 10;

-- CHECK COUNT OF ALL ROWS --
SELECT COUNT(*) FROM retail_sales;

-- CHECK FOR ANY NULL VALUE --
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

-- DELETE NULL VALUES --
-- DATA CLEANING --
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


-- DATA EXPLORATION --

-- Q1. HOW MANY SALES WE HAVE ? -- 
SELECT COUNT(*) AS Total_Sales FROM retail_sales;

-- Q2. HOW MANY UNIQUE CUSTOMERS WE HAVE ? --
SELECT COUNT(DISTINCT customer_id) as Total_Customers FROM retail_sales;

-- Q3. HOW MANY UNIQUE CATEGORY WE HAVE ? --
SELECT DISTINCT category FROM retail_sales;


-- DATA ANALYSIS AND BUSINESS KPI FINDING --

-- Q1. WRITE A SQL QUERY TO RETREIVE ALL FOR SALES MADE ON '2022-11-05'
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q2. WRITE A SQL QUERY TO RETREIVE ALL TRANSACTIONS WHERE THE CATEGORY IS 'CLOTHING' AND THE QUANTITY SOLD IS MORE THAN OR EQUAL TO 4 IN THE MONTH OF NOV-2022 --
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND 
	quantity >= 4;

-- Q3. WRITE A SQL QUERY TO CALCULATE THE TOTAL SALES FOR EACH CATEGORY -- 
SELECT 
	Category, 
	SUM(total_sale) as Total_Sales,
	COUNT(*) as Total_Orders
FROM retail_sales
GROUP BY 1;


-- Q4. WRITE A SQL QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE 'BEAUTY' CATEGORY
SELECT ROUND(AVG(age),2) as Average_Age
FROM retail_sales
WHERE Category = 'Beauty';


-- Q5. WRITE A SQL QUERY TO FIND ALL TRANSACTIONS WHERE THE TOTAL SALES IS GREATER THAN 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- Q6. WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTIONS(transaction_id) MADE BY EACH GENDER IN EACH CATEGORY
SELECT
	Category,
	gender,
	COUNT(*) as Count_Of_Transaction_Id
FROM retail_sales
GROUP BY Category,gender
ORDER BY 1;


-- Q7. WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH.FIND OUT THE BEST SELLING MONTH IN EACH YEAR
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



-- Q8. WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON HIGHEST TOTAL SALES
SELECT 
	customer_id,
	SUM(total_sale) as SUM_TOTAL_SALES
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
Limit 5;


-- Q9. WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY
SELECT 
		category , 
		COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMER_COUNT
FROM retail_sales
GROUP BY category


-- Q10. WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS(example - Morning < 12, Afternoon Between 12 & 17, Evening > 17)
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

-- END OF PROJECT --


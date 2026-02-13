CREATE DATABASE p1_retail_db;

--Creating table

CREATE TABLE retail-sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(35),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

--IMPORTING THE DATA --

-- Checking the null values in the table--
SELECT *
FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;


-- deleting the null rows --

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

SELECT COUNT(*) FROM retail_sales;


-- Data Exploration

-- 1) How many sales we have ?

SELECT COUNT(*) AS Total_Sales FROM retail_sales;

-- 2) How many unique customers we have ?

SELECT COUNT(DISTINCT customer_id) AS Total_customers FROM retail_sales;


-- 3) How many categories are there ?

SELECT DISTINCT category from retail_sales;



-- Data Analysis and Business key problems --

-- 1) write a  SQL  to retrieve all the columns or sales  made on '2022-11-05'.

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


--2) write a SQL query to retrieve all transactions where category is 'Clothing'  and
-- the Quantity sold  is more than 4 in month of Nov-2022

SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
		AND
		TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
		AND
		quantiy >= 4


-- 3) Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
	category,
	SUM(total_sale) as  Total_sale,
	COUNT(*) AS Total_Orders
FROM retail_sales
GROUP BY category;


-- 4) Write a query to find the average age of customers who purchased items for the  'Beauty'  category

SELECT 
	ROUND(AVG(age),2) AS AVG_AGE
from retail_sales
where category = 'Beauty'


-- 5) Write  a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- 6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(transactions_id) as Total_transaction
FROM retail_sales
GROUP BY category,gender
ORDER BY category


-- 7) Write a SQL query to calculate the average sale for each month. Find out the  best selling month in each year
SELECT 
	Year,
	Month,
	Avg_Sales
FROM (
SELECT 
	EXTRACT(YEAR FROM sale_date) AS Year,
	EXTRACT(MONTH FROM sale_date) AS Month,
	AVG(total_sale) AS Avg_Sales,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) AS T1
WHERE rank = 1;


-- 8) Write a SQL query to find the top 5 Customers based on the highest total sales

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- 9) Write a SQL query to find the number of unique customers who purchased items for each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category;


-- 10) Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 and 17 , Evening >17)
WITH hourly_sale
AS (
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS SHIFT
	FROM retail_sales
	)

SELECT SHIFT,
	COUNT(*)
FROM hourly_sale
GROUP BY SHIFT
		
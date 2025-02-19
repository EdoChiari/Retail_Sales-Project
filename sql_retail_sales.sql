-- Create TABLE
DROP TABLE ID EXISTS retail_sales;
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

-- Show the table
SELECT * FROM retail_sales;

-- Count the rows
SELECT COUNT(*) FROM retail_sales

-- Check if there is any null variable
SELECT * FROM retail_sales
WHERE
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
--Note: there are only 3 rows where we have null values. Since various info are missing, we can delete these 3 rows.

-- Delete rows with null values
DELETE FROM retail_sales
WHERE
	transaction_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA EXPLORATION

-- How many sales do we have?
SELECT COUNT(*) AS total_sales 
FROM retail_sales

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_customer
FROM retail_sales

-- What categories are customers divided into?
SELECT DISTINCT(category) 
FROM retail_sales

--DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS

-- Q.1 Write a SQL query to retrive all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-01-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantity >= 4
GROUP BY 1;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(age),0) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category,
	gender,
	COUNT(*) AS total_trans
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY 1;

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT 
	year,
	month,
	avg_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY
	year,
	month
) AS t1
WHERE rank = 1

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.9 Write a SQL query to find the number of unique customer who purchased items drom each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS N_unique_customer
FROM retail_sales
GROUP BY category

--Q.10 Write a SQL query to create each shift and number of orders (Ex. Morning <=12, Afternoon Between 12 & 17, Evening >= 17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(quantity) AS n_orders
FROM hourly_sale
GROUP BY 1
ORDER BY 2 DESC;

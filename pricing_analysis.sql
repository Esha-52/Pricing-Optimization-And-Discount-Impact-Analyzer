-- creating table
CREATE DATABASE pricing_analysis;
USE pricing_analysis;
CREATE TABLE sales_data (
    row_id INT,
    order_id VARCHAR(50),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(150),
    sales DECIMAL(12,4),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(12,4),
    revenue DECIMAL(12,4),
    cost DECIMAL(12,4)
);

SHOW TABLES;
SELECT COUNT(*) FROM sales_data;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_data_final.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM sales_data LIMIT 10;

-- 1.Discount vs Total Sales & Profit
SELECT 
    discount,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM sales_data
GROUP BY discount
ORDER BY discount;

-- 2.Discount vs Average Profit
SELECT 
    discount,
    ROUND(AVG(profit),2) AS avg_profit
FROM sales_data
GROUP BY discount
ORDER BY discount;

-- 3.Identify Loss-Making Discounts
SELECT discount, ROUND(SUM(profit),2) AS total_profit
FROM sales_data
GROUP BY discount
HAVING total_profit < 0;

-- 4.Products That Lose Money When Discounted
SELECT product_name, discount, ROUND(profit,2) AS profit
FROM sales_data
WHERE discount > 0 
AND profit < 0
ORDER BY profit ASC
LIMIT 20;

-- 5.Create Discount Groups
SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount BETWEEN 0.01 AND 0.20 THEN 'Low (1-20%)'
        WHEN discount BETWEEN 0.21 AND 0.40 THEN 'Medium (21-40%)'
        ELSE 'High (>40%)'
    END AS discount_range,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM sales_data
GROUP BY discount_range;

-- 6.Calculate Profit Margin %
SELECT 
    discount,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_percent
FROM sales_data
GROUP BY discount
ORDER BY discount;

-- 7.Find Optimal Discount
SELECT 
    discount,
    ROUND(SUM(profit),2) AS total_profit
FROM sales_data
GROUP BY discount
ORDER BY total_profit DESC
LIMIT 1;

-- 8. Add Executive Summary Query
SELECT 
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS overall_profit_margin
FROM sales_data;

-- 9.ADD WINDOW FUNCTION
SELECT 
    discount,
    SUM(profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM sales_data
GROUP BY discount;

-- 10.ADD CATEGORY-WISE PROFIT MARGIN
SELECT 
    category,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_percent
FROM sales_data
GROUP BY category
ORDER BY profit_margin_percent DESC;






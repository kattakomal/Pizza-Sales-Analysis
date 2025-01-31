create database Sales
use Sales

# Create a Table With Column Names
CREATE TABLE pizza_sales (
    order_id INT,
    order_details_id INT,
    pizza_id VARCHAR(255),
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price DECIMAL(10, 2),
    total_price DECIMAL(10, 2),
    pizza_size VARCHAR(255),
    pizza_type VARCHAR(255),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(500)
);

# Load the Column data into the Table
LOAD DATA infile 'pizza_sales.csv'
into table pizza_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

# Show The Table
select * from pizza_sales;

# Total Revenue
select CAST(SUM(total_price) AS decimal(10,2)) AS Total_Revenue
from pizza_sales;

# Average Order Value

select CAST((SUM(total_price) / count(distinct order_id)) AS decimal(10,2)) 
AS Avg_Order_Value FROM pizza_sales;

# Total Pizza Sold
SELECT SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales;

# Total Orders
SELECT COUNT(distinct order_id) AS Total_Orders
FROM pizza_sales;

# Avg Pizza Per Order
SELECT CAST(CAST(SUM(quantity) AS decimal(10,2)) /
CAST(COUNT(distinct order_id) AS decimal(10,2)) AS Decimal(10,2))
AS Avg_Pizza_Per_Order FROM pizza_sales;

# Daily Trend for Total Orders
SELECT DAYNAME(order_date) AS order_day , COUNT(distinct order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DAYNAME(order_date)
order by Total_Orders;

#Monthly Trend for Orders
SELECT MONTHNAME(order_date) AS order_month, 
COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales 
GROUP BY MONTHNAME(order_date) 
ORDER BY Total_Orders;

# % of Sales by Pizza Category
SELECT pizza_type , CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_type;

# % of Sales by Pizza Size
SELECT pizza_size , CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

# Total Pizzas Sold by Pizza Category
SELECT pizza_type , SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_type
ORDER BY Total_Quantity_Sold DESC;

# Top 5 Pizzas by Revenue
SELECT  pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;

# Bottom 5 Pizzas by Revenue
SELECT  pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
LIMIT 5;

# Top 5 Pizzas by Total Orders
SELECT  pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;

# Bottom 5 Pizzas by Total Orders
SELECT  pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5;

# Top 5 Pizzas by Quantity
SELECT  pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

#Bottom 5 Pizzas by Quantity
SELECT  pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;

# Summary Statistics
CREATE PROCEDURE Summary_Statistics()
SELECT 'Quantity' AS Column_Name, COUNT(quantity) 
AS Count, MIN(quantity) AS Min, MAX(quantity) AS Max, 
AVG(quantity) AS Avg, STDDEV(quantity) AS Std 
FROM pizza_sales
UNION ALL
SELECT 
'Total Price', COUNT(total_price), MIN(total_price), MAX(total_price), 
AVG(total_price), STDDEV(total_price)
FROM pizza_sales
UNION ALL
SELECT 'Unit Price', COUNT(unit_price), MIN(unit_price), MAX(unit_price), 
AVG(unit_price), STDDEV(unit_price)
FROM pizza_sales;
    
CALL Summary_Statistics();

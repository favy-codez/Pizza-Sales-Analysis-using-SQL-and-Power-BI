USE PizzaSales

SELECT * FROM dbo.orders
SELECT * FROM dbo.order_details
SELECT name FROM dbo.pizza_types
SELECT * FROM dbo.pizzas

-- KPI's
-- TOTAL REVENUE
SELECT ROUND(SUM(quantity * price),0) AS [Total Revenue]
FROM dbo.order_details AS o
JOIN dbo.pizzas AS p
ON o.pizza_id = p.pizza_id;

-- Average order value
-- Total order value/ order count
SELECT ROUND(SUM(quantity * price)/ COUNT(DISTINCT order_id),2)  AS [Average order value]
FROM dbo.order_details AS o
JOIN dbo.pizzas AS p
ON o.pizza_id = p.pizza_id;

-- Total pizzas sold
 SELECT SUM(quantity) AS [Total Pizzas Sold]
FROM order_details

-- Total orders
SELECT COUNT(DISTINCT order_id) AS [Total orders]
FROM dbo.order_details;

-- Average pizza per order
-- Pizza sold/ no of pizza sold
SELECT SUM(quantity)/ COUNT(DISTINCT order_id) AS [Average pizza per order]
FROM dbo.order_details;

-- QUESTIONS TO ANSWER 
-- QUESTION 1 DAILY TRENDS FOR TOTAL ORDERS
SELECT FORMAT(date, 'dddd') AS [Day of Week], COUNT(DISTINCT order_id) AS [Total Orders]
FROM dbo.orders
GROUP BY FORMAT(date, 'dddd') 
ORDER BY [Total Orders] DESC

-- QUESTION 2 Hourly trend for Total Orders
SELECT DATEPART(HOUR, time) AS Hour, COUNT(DISTINCT order_id) AS [Total Orders]
FROM dbo.orders
GROUP BY DATEPART(HOUR, time)
ORDER BY Hour DESC;

/* Percentage of Sales by Pizza Category
        a: calculate total revenue per category
        % sales calculated as (a:/total revenue) * 100 */
/* This query calculates the total revenue for each pizza category The percentage 
that each category contributes to the total overall revenue */

-- QUESTION 3 Calculate total revenue by category
SELECT category,SUM(quantity) AS [Quantity Sold]
FROM  dbo.pizzas AS p
JOIN dbo.pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN dbo.order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category;

-- QUESTION 4 Percentage of Sales by Pizza Category
SELECT category, ROUND(SUM(quantity * price), 2) AS Revenue,
    ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM dbo.pizzas
    AS p2 JOIN dbo.order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS [Percentage of Sales]
FROM dbo.pizzas AS p
JOIN dbo.pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN dbo.order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY [Percentage of Sales] DESC;

-- QUESTION 5 Percentage of Sales by Pizza Size
SELECT size, ROUND(SUM(quantity * price), 2) AS Revenue,
    ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM pizzas
    AS p2 JOIN dbo.order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS [Percentage of Sales]
FROM dbo.pizzas AS p
JOIN dbo.pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN dbo.order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY [Percentage of Sales] DESC;

-- QUESTION 6 Total Pizzas sold by Pizza Category
SELECT category, SUM(quantity) AS [Quantity Sold]
FROM dbo.pizzas AS p
JOIN dbo.pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN dbo.order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY [Quantity Sold] DESC;

-- QUESTION 7 Top 5 Best Sellers by Total Pizzas Sold
SELECT TOP 5 name, SUM(quantity) AS [Total Pizzas Sold]
FROM dbo.pizzas AS p
JOIN dbo.pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN dbo.order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY [Total Pizzas Sold] DESC;

-- QUESTION 8 Bottom 5 Worst Sellers by Total Pizzas Sold
SELECT TOP 5 name, SUM(quantity) AS [Total Pizzas Sold]
FROM dbo.pizzas AS p
JOIN dbo.pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN dbo.order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY [Total Pizzas Sold] ASC;
#Selecting the 'pizza_db' database
USE pizza_db;

#Getting an idea about all the tables
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;


#Questions ->

/*
Question 1 ->
Retrieve the total number of orders placed
*/

# Table/s -> orders / order_details

SELECT COUNT(DISTINCT(order_id)) AS count_orders
FROM orders;

SELECT COUNT(DISTINCT(order_id)) AS count_orders
FROM order_details; 


/* Question 2 ->
Calculate the total revenue generated from pizza sales
*/

# Table/s pizzas, order_details

SELECT SUM(od.quantity * p.price) AS Total_Revenue
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id;


SELECT ROUND(SUM(od.quantity * p.price),3) AS Total_Revenue
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id;


SELECT CEIL(SUM(od.quantity * p.price)) AS Total_Revenue
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id;


SELECT FLOOR(SUM(od.quantity * p.price)) AS Total_Revenue
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id;

/*
Question 3 ->
Identify the highest-priced pizza
*/

# Table/s -> pizzas, pizza_types


#Getting the pizza_id for the most expensive pizza
SELECT pizza_id
FROM pizzas
WHERE price = (
SELECT MAX(price)
FROM pizzas
);

SELECT * FROM PIZZAS;
SELECT * FROM PIZZA_TYPES;


SELECT pt.name, p.price
FROM pizza_types AS pt
join pizzas AS p
ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;


#solving the above question with sub-Query
# Method:1
SELECT
    p.pizza_id,
    (SELECT name FROM pizza_types WHERE pizza_types.pizza_type_id = p.pizza_type_id) AS pizza_name, -- Correlated Subquery
    p.size,
    p.price
FROM
    pizzas AS p
WHERE
    p.price = (SELECT MAX(price) FROM pizzas);

#Method:2
SELECT pt.name
FROM pizza_types AS pt
WHERE pt.pizza_type_id = (
SELECT p1.pizza_type_id
FROM pizzas AS p1
WHERE p1.price = (
SELECT MAX(p2.price)
FROM pizzas AS p2
)
);


/*
Question 4 ->
Identify the most common pizza size ordered
*/



#Tables/s -> pizzas, order_details 

SELECT * FROM pizzas;
SELECT * FROM order_details;


SELECT size
FROM (
SELECT p.size, COUNT(od.order_details_id) AS Number_of_orders
FROM pizzas AS p
JOIN order_details AS od
ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY Number_of_orders DESC
) AS a
LIMIT 1;

#solving the above question without joins

SELECT
    (SELECT p.size
     FROM pizzas AS p
     WHERE p.pizza_id = od.pizza_id) AS pizza_size,
    COUNT(*) AS total_orders_of_this_size
FROM
    order_details AS od
GROUP BY
    pizza_size
ORDER BY
    total_orders_of_this_size DESC
LIMIT 1;


/*
Question 5 
List the top 5 most ordered pizza types along with their quantities
*/

#Table/s -> pizza_types,pizzas, order_details

SELECT * FROM pizza_types;
SELECT * FROM order_details;
SELECT * FROM pizzas;

SELECT p.pizza_type_id, SUM(od.quantity) AS Total_Quantity
FROM pizzas AS p
JOIN order_details AS od
ON od.pizza_id =p.pizza_id
GROUP BY p.pizza_type_id
ORDER BY Total_Quantity DESC
LIMIT 5;


/*
Joins cannot be removed in this case because the SELECT clause,
we are taking columns from 2 different tables.
*/


/*
Question 6 ->
Join the necessary tables to find the total quantity of each pizza category ordered
*/

#Table/s -> pizza_types, order_details,pizzas

SELECT pt.category, SUM(od.quantity) AS Total_Quantity
FROM pizza_types AS pt
JOIN pizzas AS p
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY Total_Quantity DESC;


/*
Question7 ->
Determine the distribution of orders by hour of the day.
*/

#Table/s -> orders

SELECT * FROM orders;
SELECT HOUR(time) AS Hour_, COUNT(order_id) AS Number_of_Orders
FROM Orders
GROUP BY Hour_
ORDER BY Hour_;

/*
Question 8 ->
JOin relevant tables to find the category-wise distribition of pizzas
*/

#Table/s -> pizza_types, order_details, order_details

SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

SELECT pt.category, COUNT(od.order_id) AS Number_of_orders
FROM pizza_types AS pt
JOIN pizzas AS p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od
On od.pizza_id =p.pizza_id
GROUP BY pt.category
ORDER BY Number_of_orders DESC;

/*
Question 9 ->
Group the orders by date and calculate
the average number of pizzas ordered per day
*/

#Table/s -> Orders, order_Details

SELECT FLOOR(AVG(Quantity)) AS Avg_pizzas_Ordered_per_Day
FROM (
SELECT o.date, SUM(od.quantity) AS Quantity
FROM Orders AS o
JOIN Order_Details AS od
ON o.order_id = od.order_id
GROUP BY o.date
) AS a;


/*
Question 10 ->
Determine the top 3 most ordered pizza types based on revenue
*/

# Table/s -> pizza_types, order_details, pizza


SELECT pt.name, SUM(od.quantity * p.price) AS Total_Revenue
FROM Pizza_types AS pt
JOIN pizzas AS p
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od
ON od.pizza_id = p.pizza_id
GROUP BY pt.name 
ORDER BY Total_Revenue DESC
LIMIT 3;


/*
Question 11 ->
Calculate the percentage contribution of each pizza category to total revenue 
*/

#Table/s -> pizzas, pizza_types, order_details

SELECT pt.category,
ROUND(SUM(od1.quantity * p1.price) / (SELECT SUM (od2.quantity * p2.price)
FROM order_Details AS od2
JOIN pizzas AS p2
ON od2.pizza_id = p2.pizza_id)) * 100 AS proportion
FROM order_details AS od1
JOIN pizzas AS p1
ON od1.pizza_id =p1.pizza_id
JOIN pizza_types AS pt
ON p1.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;
    
    
/*
Question 12 ->
Analyze the cumulative revenue generated over time
*/
	
#Table/s -> order_details, pizzas, orders

SELECT date, 
SUM(Revenue) OVER (ORDER BY date) AS cum_revenue
FROM ( 
SELECT o.date,
SUM(od.quantity * p.price) AS Revenue
FROM order_details as od
JOIN pizzas AS p
ON p.pizza_id = od.pizza_id
JOIN Orders AS o
ON o.order_id =od.order_id
GROUP BY o.date
) AS s;     
     
     
/* Question 13->
Determine the top 3 most ordered pizza types
based on revenue for each pizza category
*/

#Table/s -> order_details, pizza_types

SELECT name, Revenue
FROM ( 
SELECT category, name, revenue,
RANK() OVER (PARTITION BY category ORDER BY Revenue DESC) AS rank_
FROM ( 
SELECT pt.category, pt.name,
SUM(od.quantity * p.price) AS Revenue
FROM pizza_types AS pt
JOIN pizzas AS p
ON pt.pizza_type_id =p.pizza_type_id
JOIN order_details AS od
ON od.pizza_id = p.pizza_id
GROUP BY pt.category, pt.name
) AS a
)AS b
WHERE rank_ <=3;
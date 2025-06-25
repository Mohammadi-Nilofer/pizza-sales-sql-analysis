#**Pizza Sales SQL Data Analysis:** Unveiling Business Insights with SQLThis repository contains an SQL project focused on analyzing a pizza sales dataset to extract valuable business insights. The project uses a pizza_db database, consisting of four tables: orders, order_details, pizzas, and pizza_types. Through a series of SQL queries, I've explored various aspects of pizza sales, from total revenue and order distribution to identifying popular pizza types and customer behavior patterns.

**Project Goal**
The primary objective of this project was to leverage SQL to:Understand the sales performance of a fictional pizza company.Identify popular pizza types and sizes.Analyze order patterns over time.Calculate key business metrics such as total revenue and average order values.Provide data-driven recommendations.

**Database Schema**
The pizza_db consists of the following tables:orders: Contains information about each order (e.g., order_id, date, time).order_details: Contains details for each item within an order (e.g., order_details_id, order_id, pizza_id, quantity).pizzas: Contains information about different pizza configurations (e.g., pizza_id, pizza_type_id, size, price).pizza_types: Contains general information about pizza types (e.g., pizza_type_id, name, category, ingredients).

**Key Questions Addressed & SQL Queries**
Here are the key business questions addressed in this project, along with the SQL queries used to answer them:

Question 1: Retrieve the total number of orders placed

Objective: To count how many unique orders were recorded in the database.

Query:# Table/s -> orders / order_details

SELECT COUNT(DISTINCT(order_id)) AS total_orders
FROM orders;

Insight: This query provides a foundational metric for understanding the volume of business operations.

Question 2: Calculate the total revenue generated from pizza sales.

Objective: To sum up the total income from all pizza sales.

Query:# Table/s pizzas, order_details

SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id;

Insight: Total revenue is a critical KPI (Key Performance Indicator) to assess overall business performance.

Question 3: Identify the highest-priced pizza.

Objective: To find the name of the pizza type that has the maximum price.

Query:# Table/s -> pizzas, pizza_types

SELECT pt.name, p.price
FROM pizza_types AS pt
JOIN pizzas AS p
ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

Insight: Helps in understanding pricing strategy and identifying premium products.

Question 4: Identify the most common pizza size ordered.

Objective: To determine which pizza size is most frequently purchased by customers.

Query:# Tables/s -> pizzas, order_details

SELECT p.size AS most_common_size
FROM pizzas AS p
JOIN order_details AS od
ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY COUNT(od.order_details_id) DESC
LIMIT 1;

Insight: Useful for inventory management and marketing strategies (e.g., promoting popular sizes or offering deals on less popular ones).

Question 5: List the top 5 most ordered pizza types along with their quantities.

Objective: To identify the most popular pizza types based on the total quantity sold.

Query:# Table/s -> pizza_types, pizzas, order_details

SELECT pt.name AS pizza_type_name, SUM(od.quantity) AS total_quantity_ordered
FROM pizza_types AS pt
JOIN pizzas AS p
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od
ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY total_quantity_ordered DESC
LIMIT 5;

Insight: Highlights best-selling items, which can inform menu planning and promotional efforts.

Question 6: Join the necessary tables to find the total quantity of each pizza category ordered

Objective: To see the sales distribution across different pizza categories (e.g., Classic, Veggie, Chicken).

Query:# Table/s -> pizza_types, order_details, pizzas

SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM pizza_types AS pt
JOIN pizzas AS p
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

Insight: Provides an overview of which pizza categories are most popular, aiding in category-level strategic decisions.

Question 7: Determine the distribution of orders by hour of the day.

Objective: To understand peak ordering times throughout the day.

Query:# Table/s -> orders

SELECT HOUR(time) AS order_hour, COUNT(order_id) AS number_of_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;

Insight: Crucial for staffing, kitchen operations, and scheduling promotional activities during peak hours.

Question 8: Join relevant tables to find the category-wise distribution of pizzas

Objective: To count the number of orders per pizza category.

Query:# Table/s -> pizza_types, pizzas, order_details

SELECT pt.category, COUNT(DISTINCT od.order_id) AS number_of_orders
FROM pizza_types AS pt
JOIN pizzas AS p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY number_of_orders DESC;

Insight: Shows which categories drive the most distinct orders.

Question 9: Group the orders by date and calculate the average number of pizzas ordered per day.

Objective: To find the average daily sales volume in terms of pizza quantity.

Query:# Table/s -> Orders, Order_Details

SELECT ROUND(AVG(daily_pizza_quantity), 2) AS avg_pizzas_ordered_per_day
FROM (
    SELECT o.date, SUM(od.quantity) AS daily_pizza_quantity
    FROM orders AS o
    JOIN order_details AS od
    ON o.order_id = od.order_id
    GROUP BY o.date
) AS daily_orders;

Insight: Provides a baseline for daily operational planning and forecasting.

Question 10: Determine the top 3 most ordered pizza types based on revenue

Objective: To identify the pizza types that contribute the most to total revenue.

Query:# Table/s -> pizza_types, order_details, pizzas

SELECT pt.name AS pizza_type_name, SUM(od.quantity * p.price) AS total_revenue_from_type
FROM pizza_types AS pt
JOIN pizzas AS p
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od
ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY total_revenue_from_type DESC
LIMIT 3;

Insight: Essential for revenue-driven marketing campaigns and optimizing menu offerings.

Question 11: Calculate the percentage contribution of each pizza category to total revenue.

Objective: To understand the revenue share of each pizza category.

Query:# Table/s -> pizzas, pizza_types, order_details

SELECT pt.category,
       ROUND(SUM(od.quantity * p.price) * 100.0 / (SELECT SUM(od_sub.quantity * p_sub.price)
                                                   FROM order_details AS od_sub
                                                   JOIN pizzas AS p_sub
                                                   ON od_sub.pizza_id = p_sub.pizza_id), 2) AS revenue_percentage_contribution
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue_percentage_contribution DESC;

Insight: Reveals the relative importance of each category to the overall business, guiding investment and focus areas.

Question 12: Analyze the cumulative revenue generated over time.

Objective: To observe the growth of revenue over the period covered by the data.

Query:# Table/s -> order_details, pizzas, orders

SELECT date,
       SUM(daily_revenue) OVER (ORDER BY date) AS cumulative_revenue
FROM (
    SELECT o.date,
           SUM(od.quantity * p.price) AS daily_revenue
    FROM order_details AS od
    JOIN pizzas AS p
    ON p.pizza_id = od.pizza_id
    JOIN orders AS o
    ON o.order_id = od.order_id
    GROUP BY o.date
) AS daily_sales;

Insight: Provides a clear visualization of revenue accumulation and helps in identifying growth trends or periods of stagnation.

Question 13: Determine the top 3 most ordered pizza types based on revenue for each pizza category

Objective: To find the highest-earning pizza types within each category.

Query:# Table/s -> order_details, pizza_types, pizzas

SELECT category, name AS pizza_type_name, revenue
FROM (
    SELECT pt.category,
           pt.name,
           SUM(od.quantity * p.price) AS revenue,
           RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rank_in_category
    FROM pizza_types AS pt
    JOIN pizzas AS p
    ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details AS od
    ON od.pizza_id = p.pizza_id
    GROUP BY pt.category, pt.name
) AS ranked_pizzas
WHERE rank_in_category <= 3
ORDER BY category, revenue DESC;

Insight: Offers granular insights into product performance within specific categories, enabling targeted menu adjustments and promotions.

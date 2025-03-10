-- Retrieve the total number of orders placed

USE SANKET_PIZZA;
SELECT 
    COUNT(ORDER_ID)
FROM
    ORDERS;
    -- Calculate the total revenue generated from pizza sales.
USE SANKET_PIZZA;
SELECT 
    ROUND(SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE),
            2) AS TOTAL_REVENUE
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    -- Identify the highest-priced pizza.
use sanket_pizza;
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY PIZZAS.PRICE DESC
LIMIT 1;
-- Identify the most common pizza size ordered.

USE sanket_pizza;
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
limit 1;
-- List the top 5 most ordered pizza types along with their quantities.

use sanket_pizza;
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;
-- Determine the distribution of orders by hour of the day.
use sanket_pizza;
SELECT 
    HOUR(time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY hour;  
-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;
-- Group the orders by date and calculate the average number of pizzas ordered per day.alter
use sanket_pizza;
SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizza_ordered_perday
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.date) AS order_quantity;
    -- Determine the top 3 most ordered pizza types based on revenue.
use sanket_pizza;
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;  
-- Calculate the percentage contribution of each pizza type to total revenue.
use sanket_pizza;
SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    SUM(order_details.quantity * pizzas.price) AS revenue 
                    FROM order_details JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,2) AS percent_revenue
FROM pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY percent_revenue DESC
LIMIT 3;  
-- Analyze the cumulative revenue generated over time.
use sanket_pizza;
select date,
sum(revenue)  over(order by date) as cum_revenue
from
(SELECT orders.date,
sum(order_details.quantity*pizzas.price) as revenue 
from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id
join orders on orders.order_id=order_details.order_id
group by orders.date )as sales;
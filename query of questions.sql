use pizzahut;
-- Question no.1 :- Retrieve the total number of orders placed.
Select count(order_id)as total_number_of_orders from orders;
-- Question no.2 :-Calculate the total revenue generated from pizza sales.
select round(sum(order_details.quantity * pizzas.price)) as total_sales from 
order_details join pizzas on pizzas.pizza_id = order_details.pizza_id;
-- Question no.3 :-Identify the highest-priced pizza.
Select pizza_types.name,pizzas.price from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id order by pizzas.price 
desc limit 1 ;
-- Question no.4 :- Identify the most common pizza size ordered.
select quantity, count(order_details_id)
from order_details group by quantity;
select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;
-- Question no.5 :- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,sum(order_details.quantity) as quantity from pizza_types join pizzas on
pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details on order_details.pizza_id
= pizzas.pizza_id group by pizza_types.name order by quantity desc limit 5 ;
-- Question no.6 :- Join the necessary tables to find the total quantity 
-- of each pizza category ordered.
select pizza_types.category,sum(order_details.quantity) as quantity from pizza_types join pizzas on
pizza_types.pizza_type_id = pizzas.pizza_type_id join order_details on order_details.pizza_id
= pizzas.pizza_id group by pizza_types.category order by quantity desc;
-- Question no.7 :- Determine the distribution of orders by hour of the day.
select hour(order_time) ,count(order_id) from orders group by
hour(order_time);
-- Question no.8 :- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) from pizza_types group by
category;
-- Question no.9 :- Group the orders by date and calculate the average 
-- number of pizzas ordered per day.
select round(avg(quantity),0) from
(select orders.order_date,sum(order_details.quantity) as quantity from orders
join order_details on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;
-- Question no.10 :- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name, sum(quantity*pizzas.price) as revenue
from pizza_types join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id group by
pizza_types.name order by revenue desc limit 4;
-- Question no.10 :-Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category, (sum(quantity*pizzas.price)  /
( select round(sum(order_details.quantity * pizzas.price)) 
as total_sales  from order_details join pizzas on 
pizzas.pizza_id = order_details.pizza_id))*100 as revenue
from pizza_types join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id group by
pizza_types.category order by revenue desc limit 4;
-- Question no.11 : Analyze the cumulative revenue generated over time.
select order_date,sum(revenue) over(order by order_date)
as cum_revenue from
(select orders.order_date,
sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on orders.order_id = order_details.order_id
group by orders.order_date) as sales;
-- Question no.12 : Determine the top 3 most ordered pizza types 
-- based on revenue for each pizza category.
select name,revenue from
(select category,name,revenue, rank()
over(partition by category order by revenue desc)as rn from
(select pizza_types.category,pizza_types.name,sum((
order_details.quantity)*pizzas.price) as revenue 
from pizza_types join pizzas on pizza_types.pizza_type_id 
= pizzas.pizza_type_id join order_details on order_details.pizza_id = 
pizzas.pizza_id group by pizza_types.category,pizza_types.name)as a)as b where rn<=3;
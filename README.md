# pizzas-sales-analysis-using-SQL
This project analyzes pizza sales data using SQL. It includes queries to calculate total and cumulative revenue, identify top-selling pizzas, compare categories, and track daily sales trends. The goal is to gain insights into customer preferences and revenue patterns for better decision-making.

## Project Overview

**Project Title**: Pizza Sales Analysis using SQL
**Level**: Intermediate  
**Database**: `pizza_database`

**The goal is to answer business-driven questions such as:**
1.Which pizza generates the highest revenue?
2.What is the most common pizza size ordered?
3.How does revenue grow cumulatively over time?
4.Which pizza categories perform best?


## Objectives

1.**Database Setup**: Build and load a pizza sales database using the provided dataset.

2.**Data Preparation**: Detect and handle records with missing or null values.

3.**Exploratory Data Analysis (EDA)**: Conduct initial analysis to gain an overview of the dataset.

4.**Business Insights**: Apply SQL queries to address key business questions and extract actionable insights.
## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `pizza_database`.
- **Table Creation**: Multiple tables are created to store the pizza sales data. The database structure includes:

1.**orders** – stores order ID, order date, and order time.

2.**order_details** – stores order ID, pizza ID, and quantity.

3.**pizzas_table** – stores pizza ID, pizza type ID, size, and price.

4.**pizza_types** – stores pizza type ID, category, and pizza name.

**Data Analysis & SQL Queries**
 **Basic Analysis**

## 1.**Retrieve the total number of orders placed**

```sql
select count(order_id) as total_orders from orders
```

### 2. Calculate the total revenue generated from pizza sales

```sql
SELECT ROUND(SUM(order_details.quantity * pizzas_table.price), 2) AS total_revenue
FROM order_details 
JOIN pizzas_table ON pizzas_table.pizza_id = order_details.pizza_id
```

### 3. Identify the highest priced pizza

```sql
SELECT TOP 1 pizza_types.name, pizzas_table.size, ROUND(pizzas_table.price,2) AS price
FROM pizza_types 
JOIN pizzas_table ON pizza_types.pizza_type_id = pizzas_table.pizza_type_id
ORDER BY price DESC

```

## 4. Identify the most common pizza size ordered
```sql
   SELECT pizzas_table.size, COUNT(order_details.quantity) AS order_count
FROM pizzas_table 
JOIN order_details ON pizzas_table.pizza_id = order_details.pizza_id
GROUP BY pizzas_table.size
ORDER BY order_count DESC

```

## 5. List top 5 most ordered pizza types by quantity
```sql
SELECT TOP 5 pizza_types.name, SUM(order_details.quantity) AS total_quantity
FROM pizzas_table 
JOIN pizza_types ON pizzas_table.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas_table.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC;

```

## 6. Find the total quantity of each pizza category ordered
```sql
SELECT pizza_types.category, SUM(order_details.quantity) AS total_quantity
FROM pizzas_table 
JOIN order_details ON pizzas_table.pizza_id = order_details.pizza_id
JOIN pizza_types ON pizza_types.pizza_type_id = pizzas_table.pizza_type_id
GROUP BY pizza_types.category
ORDER BY total_quantity DESC;

```

## 7. Distribution of orders by hour of the day
```sql
SELECT DATEPART(hour, order_time) AS order_hour, COUNT(order_id) AS total_count
FROM orders
GROUP BY DATEPART(hour, order_time)
ORDER BY total_count DESC;

```

## 8. Category-wise distribution of pizzas
```sql
SELECT category, COUNT(name) AS pizza_count 
FROM pizza_types
GROUP BY category;

```

## 9. Average number of pizzas ordered per day
```sql
SELECT ROUND(AVG(sum_of_ordered), 2) AS avg_per_day
FROM (
    SELECT orders.order_date, SUM(order_details.quantity) AS sum_of_ordered
    FROM orders 
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS daily_orders;

```

## 10.Top 3 most ordered pizzas by revenue
```sql
SELECT TOP 3 pizza_types.name, 
       ROUND(SUM(order_details.quantity * pizzas_table.price), 2) AS total_revenue
FROM pizzas_table 
JOIN order_details ON pizzas_table.pizza_id = order_details.pizza_id
JOIN pizza_types ON pizza_types.pizza_type_id = pizzas_table.pizza_type_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC;

```

## 11.Percentage contribution of each pizza category to total revenue
```sql
SELECT pizza_types.category,
       ROUND(SUM(order_details.quantity * pizzas_table.price) * 100.0 /
            (SELECT SUM(order_details.quantity * pizzas_table.price) 
             FROM order_details 
             JOIN pizzas_table ON pizzas_table.pizza_id = order_details.pizza_id), 2) AS revenue_percent
FROM pizza_types 
JOIN pizzas_table ON pizza_types.pizza_type_id = pizzas_table.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas_table.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue_percent DESC;

```

## 12.Cumulative revenue over time
```sql
SELECT order_date,
       SUM(total_sales) OVER(ORDER BY order_date) AS cumulative_revenue
FROM (
    SELECT orders.order_date, 
           ROUND(SUM(order_details.quantity * pizzas_table.price), 2) AS total_sales
    FROM orders
    JOIN order_details ON orders.order_id = order_details.order_id
    JOIN pizzas_table ON order_details.pizza_id = pizzas_table.pizza_id
    GROUP BY orders.order_date
) AS daily_sales;

```
## 13.Top 3 pizzas by revenue within each category
```sql
SELECT category, name, total_revenue
FROM (
    SELECT pizza_types.category, pizza_types.name,
           ROUND(SUM(order_details.quantity * pizzas_table.price), 2) AS total_revenue,
           RANK() OVER(PARTITION BY pizza_types.category ORDER BY SUM(order_details.quantity * pizzas_table.price) DESC) AS rank
    FROM pizza_types 
    JOIN pizzas_table ON pizza_types.pizza_type_id = pizzas_table.pizza_type_id
    JOIN order_details ON order_details.pizza_id = pizzas_table.pizza_id
    GROUP BY pizza_types.category, pizza_types.name
) AS ranked_sales
WHERE rank <= 3;


```

## Findings

1. Most Popular Size: The most common ordered size is Large (L), followed by Medium (M).
2. Top-Selling Pizza: The Classic Deluxe Pizza is the most frequently ordered pizza.
3. Category Preference: The Classic category has the highest quantity of orders.
4. Peak Order Time: Most orders occur between afternoon 12 PM to evening 7 PM.
5. Daily Demand: On average, 138 pizzas are ordered per day.
6. Highest Revenue Pizza: The Thai Chicken Pizza generated the maximum revenue.
7. Revenue Contribution: Classic pizzas contribute more than 27% to total revenue.

## Reports

1. Sales Summary: Revenue and order quantity by pizza, size, and category.

2. Trend Analysis: Daily sales, cumulative revenue, and time-based order trends.

3. Top Performers: Highest revenue-generating pizzas and most popular categories.

## Conclusion

This project provides valuable insights into pizza sales performance, customer preferences, and revenue trends. The findings highlight demand patterns by size, category, and time, helping businesses optimize menu offerings, pricing strategies, and sales planning.

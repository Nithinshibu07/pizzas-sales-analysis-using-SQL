create database pizza_database
 

 --Q1. retrieve the total number of orders placed
		select * from orders

		select count(*) as total_orders from orders
						--OR
		select count(order_id) as total_orders from orders

--Q2.calculate the total revenue generated from pizzas sales
					select * from orders
					select * from pizzas_table
					select * from order_details
					select * from pizza_types

					select distinct pizza_id from pizzas_table

					ALTER TABLE order_details 
					ALTER COLUMN pizza_id NVARCHAR(50);

				
					select round(sum(order_details.quantity * pizzas_table.price),2) as total_revenue
					from order_details 
					join pizzas_table 
					on pizzas_table.pizza_id=order_details.pizza_id 

--Q3.identify the highest priced pizza
			
					select top 1 pizza_types.name,pizzas_table.size,round(pizzas_table.price,2)
					from pizza_types join pizzas_table
					on pizza_types.pizza_type_id=pizzas_table.pizza_type_id
					order by pizzas_table.price desc

--Q4.identify the most common pizza size ordered
			
						/*   select * from orders
						select * from pizzas_table
						select * from order_details
						select * from pizza_types       */

						
						select pizzas_table.size,count(order_details.quantity) as order_count from pizzas_table join order_details 
						on pizzas_table.pizza_id=order_details.pizza_id
					group by  pizzas_table.size 
					order by order_count desc

			---which quantity is mostly ordered
							select quantity,count(order_details_id) as order_count
							from order_details
							group by quantity
							order by order_count desc


---Q5.list top 5 most ordered pizza types along with their quantities

					SELECT  top 5
					pizza_types.name,
				
					SUM(order_details.quantity) AS total_sum
				FROM 
					pizzas_table 
				JOIN 
					pizza_types
					ON pizzas_table.pizza_type_id = pizza_types.pizza_type_id
				JOIN 
					order_details
					ON order_details.pizza_id = pizzas_table.pizza_id
				GROUP BY 
					pizza_types.name
					order by total_sum desc



----									INTERMEDIATE QUESTION

--Q1.join the neccessary table to find the total quantity of each pizza ordered

			
			/*   select * from orders
						select * from pizzas_table
						select * from order_details
						select * from pizza_types 
						select * from orders							*/

						
					select pizza_types.category,sum(order_details.quantity) as total_quantity from
					pizzas_table join order_details
					on pizzas_table.pizza_id=order_details.pizza_id
					join pizza_types 
					on pizza_types.pizza_type_id =pizzas_table.pizza_type_id
					group by  pizza_types.category
					order by total_quantity desc

 --Q2. determine the distribution of orders by hour of the day

								SELECT 
								datepart(hour,order_time) AS order_hour, 
								COUNT(order_id) AS total_count
								FROM orders
								GROUP BY datepart(hour,order_time)
								ORDER BY total_count asc;

---Q3. join relevant tables to find category wise distribution of pizzas

					
			/*   
						select * from pizzas_table
						select * from order_details
						select * from pizza_types 
						select * from orders							*/

					select category,count(name) from pizza_types
					group by category

--Q4. group the orders by date and calculate the average number of pizzas ordered per day

		
			select round(avg(sum_of_ordered),2) as average from
				(
				select orders.order_Date as order_date ,sum(order_details.quantity) as sum_of_ordered
				from 
				orders join order_details
				on orders.order_id = order_details.order_id 

				group by orders.order_Date 
				) as sum_t1

--Q5. Determine the top 3 most ordered pizza types based on revenue

					/*   
						select * from pizzas_table
						select * from order_details
						select * from pizza_types 
						select * from orders							*/
				
				select top 3 pizza_types.name,pizzas_table.pizza_type_id,
							round(sum(order_details.quantity * pizzas_table.price),2) as total_revenue

							from
							 pizzas_table join order_details
							 on pizzas_Table.pizza_id =order_details.pizza_id
							 join pizza_types
							 on pizza_types.pizza_type_id=pizzas_Table.pizza_type_id

							 group by pizza_types.name,pizzas_table.pizza_type_id
							 order by total_revenue desc

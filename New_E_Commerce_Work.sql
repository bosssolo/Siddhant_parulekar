create database e_commerce1 ;
use e_commerce1;
-- ------------------------------------------------------------------ E-Commerce Analysis ------------------------------------------------------------------
create table customer_table(
customer_id varchar(20) ,
name varchar(30),
registration date ,
region varchar(30));

LOAD DATA INFILE 'reviews.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ',' 
ignore 1 lines;

create table orders (
order_id varchar(30),
customer_id varchar(50),
order_date date,
product_id varchar(50),
quantity varchar(50),
order_status varchar(50),
discount varchar(50));

create table products(
product_id varchar(50),
product_name varchar(50),
category varchar(50),
price varchar(50),
supplier_id varchar(50));

create table Returns(
orderid varchar(50),
customer_id varchar(50),
order_date date,
product_id varchar(50),
quantity varchar(50),
order_status varchar(50),
discount varchar(50),
return_id varchar(50),
return_reason varchar(50),
feedback varchar(50));


create table reviews(
review_id varchar(50),
product_id varchar(50),
customer_id varchar(50),
rating varchar(50),
review_date date,
review_text varchar(50));

select * from customer_table;
select * from reviews;
select * from orders;
select * from returns;
select * from products;

-- --------------------------------------- Questions -------------------------------------

# 1. Find the average rating each customer has given across all reviews they’ve posted.

select distinct customer_id , round(avg(rating)) as avg_rating 
from reviews 
group by customer_id;

-- ----------------------------------------------------------------------------------------------
# 2. Identify the most frequently purchased product in each category.

select * from orders;
select * from products;

select category , product_id , sum(quantity) as total_purchased
from orders join products using(product_id)
group by category , product_id
order by category, total_purchased desc;

-- ------------------------------------------------------------------------------------------------
# 3. Calculate the total revenue generated from orders in each region.
select * from orders;
select * from products;
select * from customer_table;

select a.region as Region , round(sum(b.price * c.quantity)) as Total_Revenue
from orders c
join customer_table a on c.customer_id = a.customer_id
join products b on c.product_id = b.product_id
group by region ;

-- ------------------------------------------------------------------------------------------------
# 4. List all products that have received an average rating below 3.

select * from reviews;
select * from products;

select product_name, product_id ,round((avg(rating)))as Average_Rating 
from products join reviews using (product_id)
group by product_name ,product_id
having avg(rating) < 3 ;

-- ------------------------------------------------------------------------------------------------
# 5. Retrieve all customers who have placed an order but never returned or cancelled any product.

select * from orders;
select * from customer_table;
select * from returns;

select a.customer_id , a.name 
from customer_table a
join orders b  using (customer_id)
join returns c using (customer_id)
where b.order_status != "Returned" or b.order_status != "Cancelled" 
group by a.customer_id,a.name;

-- ------------------------------------------------------------------------------------------------
# 6. Find the product with the highest total revenue across all orders.


select * from orders;
select * from products ;

select product_name , round(sum(price * quantity)) as Total_Revenue
from orders join products using (product_id)
group by product_name
order by Total_Revenue desc ;


-- ------------------------------------------------------------------------------------------------
# 7. List the top 3 customers in terms of the total number of orders placed.

select * from orders;
select * from customer_table;

select  customer_id,name ,count(order_id)as Total_number
from orders join customer_table using (customer_id)
group by customer_id,name
order by Total_number desc 
limit 3;

-- ------------------------------------------------------------------------------------------------
# 8. For each product category, find the average discount applied across orders.
select * from orders;
select * from products;
select category , avg(discount) as Average_discount
from products join orders using (product_id)
group by category ;

-- ------------------------------------------------------------------------------------------------
# 9.Identify the region with the highest average product rating.
select * from customer_table;
select * from reviews;

select region , avg(rating) as Average_rating 
from customer_table join reviews using (customer_id)
group by region 
order by Average_rating desc ;

-- ------------------------------------------------------------------------------------------------
# 10.Calculate the total number of returned products for each reason.

select * from returns;

select return_reason , sum(quantity) as total_number_returns
from returns
group by return_reason;

-- ------------------------------------------------------------------------------------------------------
# 11.List categories where the total quantity ordered is below the average quantity ordered across all categories.

select * from products;
select * from orders;

select p.category ,sum(o.quantity) as Total_Quantity 
from products p join orders o on p.product_id = o.product_id
where o.Quantity < (select avg(o.quantity) from orders o )
group by p.category;

-- ------------------------------------------------------------------------------------------------
 # 12.List all products that have never been ordered.
 
 select product_id , product_name , price 
from products p
where p.product_id not in (select o.product_id from orders o )
;

select * from products;

-- ------------------------------------------------------------------ END ------------------------------------------------------------------------------










use salesdb;
# Creating Table for Database 

create table E_commerce(
product_id varchar(50),
product_name varchar(100),
category varchar(50),
price varchar(50),
discount varchar(50),
tax_rate varchar(50),
stock_level varchar(50),
supplier_id varchar(50),
customer_age_grp varchar(30),
customer_states varchar(40),
country varchar(30),
customer_gender varchar(40),
shipping_cost varchar(40),
shipping_method varchar(50),
retrun_rate varchar(30),
seasonality varchar(40),
popularity_index varchar(30));

LOAD DATA INFILE 'E-Commerce Dataset.csv'
INTO TABLE E_commerce 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

select *  from e_commerce;

# ------------------------------------------ EDA process ------------------------------------------ #
# Creating the sales column in dataset 
select * from e_commerce;
alter table e_commerce
add column Total_sales decimal(10,2) as (stock_level * price) stored ;

# -------------------------------------------------------------------------------------------------------------------
# Which e_commerce category have the most sales over the time in it 

select category , concat(round(sum(Total_sales) / 10000000), ' M') as Total_Sales 
from e_commerce
group by category 
order by total_Sales desc ;

# -------------------------------------------------------------------------------------------------------------------
# Which product have most Sales and in which city they have it. 

select product_name , customer_city, concat(round(sum(Total_sales) / 1000000), ' M') as Sales 
from e_commerce 
group by product_name,customer_city
order by Sales desc 
limit 10;

# -------------------------------------------------------------------------------------------------------------------
-- Retrieve the Product Name, Category, Supplier ID, and Stock Level for products where the stock is below 50, 
# and the supplier is located in a specific Country.

select product_name , category , supplier_id , stock_level 
from e_commerce
where stock_level < 50
;

# -------------------------------------------------------------------------------------------------------------------
-- List the Customer_states and the total Sales for each state by top 5 between Customer_states and Sales.
select customer_states , concat(round(sum(Total_sales) / 10000000), ' M') as Total_Sales 
from e_commerce 
group by customer_states 
order by Total_sales desc 
limit 5 ;

# -------------------------------------------------------------------------------------------------------------------
-- Find the Product Name and Category of the products with a Price higher than the average Price of all products.

select product_name , category , round(price )
from e_commerce 
where price > (select avg(price) from e_commerce )
 ;

# -------------------------------------------------------------------------------------------------------------------
-- List the Customer Gender and Sales for customers whose age is above the Average Customer Age.
select * from e_commerce;
select customer_gender  , Total_sales ,customer_age_grp
from e_commerce
where customer_age_grp > (select avg(customer_age_grp) from e_commerce);


# -------------------------------------------------------------------------------------------------------------------
# Man vs Women which gender have make more sales 

select customer_gender , concat(round(sum(Total_sales) / 100000000), ' M') as Total_sales 
from e_commerce 
group by customer_gender 
limit 2;

# -------------------------------------------------------------------------------------------------------------------
-- Calculate a running total of Sales for each shipping_method and display the cumulative Sales column alongside.

select shipping_method,
sum(Total_sales) over (partition by shipping_method order by Total_sales desc ) as Running_Total 
from e_commerce
;

# -------------------------------------------------------------------------------------------------------------------
# Analyizing the Customer behaviour which age group have most interseted 

select 
case 
when customer_age_grp between 18 and 25 then "18-25"
when customer_age_grp between 26 and 35 then "26-35"
else "36+"
end as Age_group ,
count(*) as customer_count 
from e_commerce
group by age_group 
order by customer_count desc ;

# -------------------------------------------------------------------------------------------------------------------
# In which product category have the most return rate in it. 

select category , round(sum(retrun_rate)) as Return_rate
from e_commerce
group by category 
order by return_rate desc ;

# -------------------------------------------------------------------------------------------------------------------
# The Shipping Analysis Which shipping method is the most cost-effective?

select shipping_method , avg(shipping_cost) as Average_shipping_Cost  , concat(round(sum(Total_sales) / 10000000), ' M') as Total_Sales
from e_commerce
group by shipping_method
order by Total_sales desc ;

# -------------------------------------------------------------------------------------------------------------------
# In which product we have high price but low discount in it 

select product_name , concat(round(sum(price) / 100000), ' M'),sum(discount)
from e_commerce 
where discount < (select max(discount) from e_commerce ) 
group by product_name;

# -------------------------------------------------------------------------------------------------------------------
# Write a stored procedure to update the Stock Level of a product when it is restocked.
delimiter //
create procedure UpdateStocklevel(product_id varchar(100) , quantity varchar(100))
begin 
     update e_commerce
     set stock_level = stock_level + quantity
     where product_id = product_id ;
end //
delimiter ;


call updatestocklevel("p6000",20);

# -------------------------------------------------------------------------------------------------------------------
 # Create a view that shows the Product ID, Product Name, Final Price (after applying Discount and Tax Rate), and Stock Level.

create view Product_summary as 
select 
product_id ,
product_name ,
round(price - (price * discount / 100 ) + (price * tax_rate / 100)) as Final_Price ,
stock_level 
from 
e_commerce ;

select * from product_summary ;
# ----------------------------------------------------------------------------------------------------------------------

# 1) The most sales category is books and least one is apparel so they have to focus on apperal sales in category 
# 2) The Product graphic_novels have most sales in the city hovsten and captown and refrigetor and commic have the least sell in dubai and paris 
# 3) Sneakers from footwear category have the price then average price in it . 
# 4) In these Ecommerce firm the male gives more sales than women. 
# 5) The most customers are from age group of 18 - 25. 
# 6) The most sales is done by express shippng method . 












----Case Study - 1
----Problem Statement:
----You are a database administrator. You want to use the data to answer a few questions about your customers, especially about the sales and profit coming 
--from different states, money spent in marketing and various other factors such as COGS (Cost of Goods Sold), budget profit etc. You plan on using these insights
--to help find out which items are being sold the most. You have been provided with the sample of the overall customer data due to privacy issues. But you hope 
--that these samples are enough for you to write fully functioning SQL queries to help answer the questions. 

create database case_study1

use case_study1

----Dataset:
----The 3 key datasets for this case study:
----a. FactTable: The Fact Table has 14 columns mentioned below and4 200 rows. Date, ProductID, Profit, Sales, Margin, COGS, Total Expenses, Marketing,
--Inventory, Budget Profit, Budget COGS, Budget Margin, Budget Sales, and Area Code Note: COGS stands for Cost of Goods Sold
--b. ProductTable: The ProductTable has four columns named Product Type, Product, ProductID, and Type. It has 13 rows which can be broken down into 
--further details to retrieve the information mentioned in the Fact Table. 
--c. LocationTable: Finally, the Location Table has 156 rows and follows a similar approach to Product Table. It has four columns named Area Code, State, 
--Market, and Market Size. 

----Tasks to be performed:

----1. Display the number of states present in the Location Table.

select count(distinct State) from Location

----2. How many products are of regular type?

select count (type) from Product where type = 'regular'

----3. How much spending has been done on marketing of product ID 1?

select sum(Marketing) 
from fact
where ProductId = 1

----4. What is the minimum sales of a product?

select min(sales) from fact

----5. Display the max Cost of Good Sold (COGS).

select max(cogs) as max_cogs from fact

----6. Display the details of the product where product type is coffee. 

select * from Product where Product_type = 'Coffee'

----7. Display the details where total expenses are greater than 40. 

select * from fact where Total_expenses > 40

----8. What is the average sales in area code 719?

select avg(sales) from fact where Area_Code = 719

----9. Find out the total profit generated by Colorado state.

select sum(profit) as total_profit 
from fact join Location on location.area_code = fact.area_code 
where State = 'Colorado' group by State

----10.Display the average inventory for each product ID. 

select avg(inventory) as avg_inventory, productId 
from fact 
group by productId 
order by productId

----11. Display state in a sequential order in a Location Table.

select state 
from Location
group by state
order by state desc


----12. Display the average budget of the Product where the average budget margin should be greater than 100. 

select avg(budget_margin) as budget_margin_above_100 , productId
from fact 
group by productId 
having avg(budget_margin) > 100 

----13. What is the total sales done on date 2010-01-01?

select sum(sales) as totl_sales 
from fact 
where date = '2010-01-01'

----14. Display the average total expense of each product ID on an individual date. 

select productId, date, avg(total_expenses) 
from fact 
group by date, productId 
order by date, productId

----15. Display the table with the following attributes such as date, productID, product_type, product, sales, profit, state, area_code. 

select fact.date, fact.productId, product.product_type, product.product, fact.sales, fact.profit, location.state, location.area_code 
from fact 
join location on fact.area_code = location.area_code 
join product on fact.productId = product.productId

----16. Display the rank without any gap to show the sales wise rank.

select sales, row_number() over (order by sales asc) as rank_of_sales from fact

----17. Find the state wise profit and sales. 

select state, sum(profit) as profit_as_per_state, sum(sales) as sales_per_state
from fact
join location on location.area_code = fact.area_code
group by state

----18. Find the state wise profit and sales along with the productname. 

select state, sum(profit) as profit_as_per_state, sum(sales) as sales_per_state, product
from fact
join location on location.area_code = fact.area_code
join product on fact.productId = product.productId
group by state, product

----19. If there is an increase in sales of 5%, calculate the increased sales. 

select sales, sales * 0.5 as Increased_sales from fact

----20. Find the maximum profit along with the product ID and producttype.

select fact.productId, product.product_type, fact.profit 
from fact
join product on fact.productId = product.productId
where profit = (select max(Profit) from fact )

----21. Create a stored procedure to fetch the result according to the product type from Product Table. 

create procedure product_type @prod_type varchar(20) as
select * from product 
where product_type = @prod_type

exec product_type @prod_type = 'Espresso'

----22. Write a query by creating a condition in which if the total expenses is less than 60 then it is a profit or else loss. 

select total_expenses, iif (total_expenses > 60,'profit','loss') from fact

----23. Give the total weekly sales value with the date and productID details. Use roll-up to pull the data in hierarchical order. 

select productId, date, sum(sales) as Weekly_sales 
from fact
group by date, productId
with rollup

----24. Apply union and intersection operator on the tables which consist of attribute area code.

select area_code from fact
union 
select area_code from location

----25. Create a user-defined function for the product table to fetch a particular product type based upon the user�s preference. 

create function product_table(@product_type varchar(20))
returns table
as
return select * from product where product_type = @product_type

select * from dbo.product_table ('Herbal Tea')

----26. Change the product type from coffee to tea where product ID is 1 and undo it. 

begin transaction
update product
set product_type = 'tea'
where productId = 1

rollback

----27. Display the date, product ID and sales where total expenses are between 100 to 200. 

select productId, date, sales 
from fact
where total_expenses between 100 and 200

----28. Delete the records in the Product Table for regular type.

delete  from product 
where type = 'regular'

----29. Display the ASCII value of the fifth character from the column Product

select product, ascii(substring(Product,5,1)) as ascii_value from product

--------------------------------------------------------------------------------------------------------------------------------------------------------

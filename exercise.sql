/*
1. Write a query against the Sales.Orders table that returns orders placed in April 2016.
Tables involved: Sales.Orders table
Output: orderid, orderdate, custid, empid
*/

select orderid, orderdate, custid, empid
from sales.Orders
where year(orderdate) = 2016 and month(orderdate) = 4 -- o >= '20160401' and orderdate < '20160501'

/*
2. Write a query against the Sales.Orders table that returns orders placed on the last day of the month.
Tables involved: Sales.Orders table
Output: orderid, orderdate, custid, empid
Use EOMONTH function
*/

select orderid, orderdate, custid, empid
from sales.Orders
where orderdate = EOMONTH(orderdate)

/*
3. Write a query against the HR.Employees table that returns employees with last name containing the
letter 'a' twice or more.
Tables involved: HR.Employees table
Output: empid, firstname, lastname
*/

select empid, firstname, lastname
from hr.Employees
where lastname like '%a%a%'

/*
4. Write a query against the Sales.OrderDetails table that returns orders with total value (quantity * unitprice) greater than 10,000, sorted by total value.
Tables involved: Sales.OrderDetails table
Output: orderid, totalvalue
*/

-- è un total value quindi una somma
select orderid, (qty * unitprice) as totalvalue
from sales.OrderDetails
where qty * unitprice > 10000
group by orderid
order by  totalvalue

select orderid, sum(qty*unitprice) as totalvalue
from sales.OrderDetails
group by orderid
having sum(qty*unitprice) > 10000
order by totalvalue

/*
5. Write a query against the Sales.Orders table that returns the three shipped-to countries with the highest average freight in 2016.
Tables involved: Sales.Orders table
Output: shipcountry, avgfreight
*/

select TOP(3) shipcountry, avg(freight) as avgfreight
from sales.Orders
where year(shippeddate) = 2016 
group by shipcountry
order by avgfreight desc

/*
7. Using the HR.Employees table, figure out the SELECT statement that returns for each employee the
gender based on the title of courtesy. For ‘Ms. ‘ and ‘Mrs.’ return ‘Female’; 
for ‘Mr. ‘ return ‘Male’; and in all other cases (for example, ‘Dr. ‘) return ‘Unknown’.
Tables involved: HR.Employees table
Output: empid, firstname, lastname, titleofcourtesy, gender
*/

select empid, firstname, lastname, titleofcourtesy, 
case titleofcourtesy
	when 'Mr.' then 'Male'
	when 'Ms.' then 'Female'
	when 'Mrs.' then 'Female'
	else 'Unkown'
end as gender
from hr.Employees

/*
8. Write a query against the Sales.Customers table that returns for each customer the customer ID and
region. Sort the rows in the output by region, having NULL marks sort last (after non-NULL values).
Note that the default sort behavior for NULL marks in T-SQL is to sort first (before non-NULL values).
Tables involved: Sales.Customers table
Output: custid, region
*/
select custid, region
from sales.Customers
order by region desc

select custid, region
from sales.Customers
order by case when region is null then 1 else 0 end, region

/*
6. Write a query against the Sales.Orders table that calculates row numbers for orders based on order
date ordering (using the order ID as the tiebreaker) for each customer separately.
Tables involved: Sales.Orders table
Output: custid, orderdate, orderid, rownum
*/

select custid, orderdate, orderid, 
row_number() over (partition by custid order by orderdate, orderid) as rownum
from sales.Orders
order by custid, rownum

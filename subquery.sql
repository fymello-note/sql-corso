/*
Subqueries
	Self-contained: autonomous execution
	correlated: parametric subquery
*/

-- Self-contained

use TSQLV4
go

-- questo da errore
select * from sales.Orders
where max(orderid) = orderid

select * 
from sales.Orders 
where orderid = ( -- query esterna (Parent) finnisce prima della parentesy. 
	select max(orderid) from sales.Orders	-- query interna (subquery), deve prima risolversi questa e dopo si esegue la parent.
)

-- variabile di t-sql
declare @maxid as int = (select max(orderid) from sales.Orders)

select * 
from sales.Orders 
where orderid = (
	@maxid
)

-- Exerc. all the orders makes by emp where lastname starts with K

select * from sales.Orders as o
where o.empid in ( --  quando restituisce più di un valore bisogna usare cose tipo in, perché = fa solo confronti tra due elementi e non di più
	select empid from hr.Employees where 
	lastname like 'D%'
)

-- Exerc. 

drop table dbo.Orders

create table dbo.Orders (orderid int not null constraint pk_orders primary key)

insert into dbo.Orders
select orderid from sales.Orders
where orderid % 2 = 0;

select orderid from sales.Orders order by orderid desc

-- Show on screen orderid not present in table
-- dbo.Nums
select orderid from dbo.Orders

select n
from dbo.Nums
where  n >= ( select min(orderid) from dbo.Orders )
and n <= (select max(orderid) from dbo.Orders)
and n not in (select orderid from dbo.Orders)

-- Correlated
select * from sales.Orders as o1
where orderid = (
	select max(o2.orderid) from sales.Orders o2
	where o2.custid = o1.custid -- Per questo o1.custid è una correlated, il valore viene dalla tabella fuori
)

-- Exerc. dato un certo cliente quanto è in percentuale ciascun ordine in base all'ordine totale del cliente
SELECT * FROM sales.OrderValues
-- Orderid, custid, val, pct
-- pct tipo 440 / tot(val)

select orderid, custid, val, 
cast(( ov1.val /( 
	select sum(o2.val) from sales.OrderValues as o2 where ov1.custid = o2.custid
) )*100 as NUMERIC(5,2)) as pct
from sales.OrderValues as ov1
order by ov1.custid

-- EXIST
select * from sales.Customers as c
where c.country = 'Spain' and exists (
	select custid from sales.Orders as o where o.custid = c.custid
)

-- Exerc. 
-- orderid, orderdate, empid, custid, prevorderid
SELECT orderid, orderdate, empid, custid, (
	SELECT orderid FROM sales.Orders as o2 
	WHERE o1.orderid - 1 = o2.orderid
) as prevorderid
FROM sales.Orders as o1


SELECT orderid, orderdate, empid, custid, (
	SELECT max(orderid) FROM sales.Orders as o2
	WHERE o2.orderid < o1.orderid
) as prevorderid,  (
	SELECT min(orderid) FROM sales.Orders as o2
	WHERE o2.orderid > o1.orderid
) as nextorderid
FROM sales.Orders as o1



/*
1. Write a query that returns all orders placed on the last day of activity that can be found in the
Orders table.
Tables involved: Sales.Orders
Output: orderid, orderdate, custid, empid
*/
select o.orderid, o.orderdate, o.custid, o.empid
from sales.Orders as o
where o.orderdate in (
	select max(o1.orderdate)
	from sales.Orders as o1
)

/*
2. Write a query that returns all orders placed by the customer(s) who placed the highest number of
orders. Note that more than one customer might have the same number of orders.
Tables involved: Sales.Orders
Output: custid, orderid, orderdate, empid
*/
select o.custid, o.orderid, o.orderdate, o.empid
from sales.Orders as o
where o.custid in (
	select top(1) with ties o1.custid
	from sales.Orders as o1
	group by o1.custid
	order by count(o1.orderid) desc
)

/*
3. Write a query that returns employees who did not place orders on or after May 1, 2016.
Tables involved: HR.Employees and Sales.Orders
Output: empid, FirstName, lastname
*/
select e.empid, e.firstname, e.lastname
from hr.Employees as e
where not exists (
	select o.empid from sales.Orders as o
	where o.orderdate >= '20160501' and e.empid = o.empid
)



/*
4. Write a query that returns countries where there are customers but not employees.
Tables involved: Sales.Customers and HR.Employees
Output: country
*/
select c.country from sales.Customers as c
where c.country not in (
	select e.country
	from hr.Employees as e
)
group by c.country

/*
5. Write a query that returns for each customer all orders placed on the customer’s last day of activity.
Tables involved: Sales.Orders
Output: custid, orderid, orderdate, empid
*/
select o.custid, o.orderid, o.orderdate, o.empid 
from sales.Orders as o
where o.orderdate = (
	select top(1) with ties o1.orderdate
	from sales.Orders as o1
	where o.custid = o1.custid
	group by o1.custid, o1.orderdate
	order by o1.orderdate desc
)
order by o.custid

/*
6. Write a query that returns customers who placed orders in 2015 but not in 2016.
Tables involved: Sales.Customers and Sales.Orders
Output: custid, companyname
*/
select c.custid, c.companyname
from sales.customers as c
where exists (
	select o.custid
	from sales.Orders as o
	where c.custid = o.custid and year(o.orderdate) = 2015
) and not exists (
	select o.custid
	from sales.Orders as o
	where c.custid = o.custid and year(o.orderdate) = 2016 
)

select c.custid, c.companyname
from sales.customers as c
where exists (
	select o.custid
	from sales.Orders as o
	where c.custid = o.custid and o.orderdate >= '20150101' and o.orderdate <= '20151231'
) and not exists (
	select o.custid
	from sales.Orders as o
	where c.custid = o.custid and o.orderdate >= '20160101' and o.orderdate <= '20161231'
)

/*
7. Write a query that returns customers who ordered product 12.
Tables involved: Sales.Customers, Sales.Orders, and Sales.OrderDetails
Output: custid, companyname
*/
select c.custid, c.companyname
from sales.Customers as c
where c.custid in (
	select o.custid
	from sales.Orders as o
	where o.orderid in (
		select od.orderid
		from sales.OrderDetails as od
		where od.productid = 12
	)
)

select c.custid, c.companyname
from sales.Customers as c
where exists (
	select *
	from sales.Orders as o
	where exists (
		select *
		from sales.OrderDetails as od
		where o.orderid = od.orderid and od.productid = 12
	) and c.custid = o.custid
)

/*
8. Write a query that calculates a running-total quantity for each customer and month.
Tables involved: Sales.CustOrders
Output: custid, ordermonth, qty, runqty
*/
select o.custid, o.ordermonth, o.qty, (
	select sum(od.qty) from sales.CustOrders as od
	where od.ordermonth <= o.ordermonth and o.custid = od.custid
) as runqty
from sales.CustOrders as o
order by o.ordermonth

-- year, custy, custyprec, custdiff
select distinct year(o.orderdate), (
	select count(distinct od.custid) from sales.Orders as od
	where year(o.orderdate) = year(od.orderdate)
) as custy, (
	select count(distinct od.custid) from sales.Orders as od
	where year((SELECT max(o2.orderdate) FROM sales.Orders as o2 WHERE o2.orderdate < od.orderdate))
	= 
	year((SELECT max(o2.orderdate) FROM sales.Orders as o2 WHERE o2.orderdate < o.orderdate))
	
) as custydiff
from sales.Orders as o


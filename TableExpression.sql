/*
	How to express table content
		- Derived tables
		- CTE: Common Table Expression (sono un modo per eseguire una stessa query più volte)
		- Function tables
		- View
*/

-- Derived tables (table subqueries)
select * from ( 
	select custid, companyname from sales.Customers where country = 'USA'
) as USACust

/*
   non si può fare un ordinamento nella table subqueries (order is not guarenteed)
   tutte le colonne devono avere un nome univoco (all columns must have names, and must be unique)
*/

select orderyear, count(distinct  custid) from (
	select year(orderdate) as orderyear, custid from sales.Orders 
) as D
group by orderyear

select orderyear, count(distinct  custid) as custidcount from (
	select year(orderdate), custid from sales.Orders 
) as D (orderyear, custid) -- altro posto dove possono stare gli alias
group by orderyear

-- using arguments
declare @empid as int = 3
select orderyear, count(distinct  custid) as custidcount from (
	select year(orderdate), custid from sales.Orders 
	where empid = @empid
) as D (orderyear, custid)
group by orderyear

-- Nesting Derived Tables
select orderyear, numcust from (
	select orderyear, count(distinct custid) as numcust from (
		select YEAR(orderdate), custid
		from sales.Orders
	) as d1 (orderyear, custid)
	group by orderyear
) as d2 
where numcust > 70

-- Exerc. Using table expression, sales.Order
-- year, custcurr, custyprec, custdif

select distinct cur.tyear, cur.custcurr, prv.custprv, (cur.custcurr - prv.custprv) as custdiff   from (
	select year(o.orderdate), (
		select count(distinct od.custid) from sales.Orders as od
		where year(o.orderdate) = year(od.orderdate)
	)
	from sales.Orders as o
	group by o.orderdate
) as cur (tyear, custcurr)
left outer join (
	select year(o.orderdate),  (
		select count(distinct od.custid) from sales.Orders as od
		where year(o.orderdate) = year(od.orderdate)
	)
	from sales.Orders as o
	group by o.orderdate
)as prv (prvyear, custprv)
on cur.tyear = prv.prvyear + 1

-- CTE Common Table Expression
/*
WITH <cte_name> 
AS
(
 <inner_query_defining_cte>
)
<outer_query_against_cte>
*/

WITH USACust AS (
	select custid, companyname 
	from sales.customers
	where country = 'USA'
)
select * from USACust;

with cin as (
	select year(orderdate) as orderyear, custid
	from sales.Orders
)
select orderyear, count(distinct custid) as numcusts
from cin
group by orderyear;

with cin1 (orderyear, custid) as (
	select year(orderdate), custid
	from sales.Orders
)
select orderyear, count(distinct custid) as numcusts
from cin1
group by orderyear;

-- using arguments in CTE
declare @empid2 as int = 3;
with cin2 (orderyear, custid) as (
	select year(orderdate), custid
	from sales.Orders
	where empid = @empid2
)
select orderyear, count(distinct custid) as numcusts
from cin2
group by orderyear;

-- define multiple CTEs

with A (orderyear, custid) as (
	select year(orderdate), custid from sales.orders
),
B (orderyear, numcusts) as (
	select orderyear, count(distinct custid) 
	from A
	group by orderyear
)
select * 
from B
where numcusts > 70;

with yearlycount (yearly, numcustid) as (
	select year(o.orderdate), count(distinct o.custid)
	from sales.Orders as o
	group by year(o.orderdate)
)
select cur.yearly, cur.numcustid, prv.numcustid, (cur.numcustid - prv.numcustid) as custdiff   
from yearlycount as cur left outer join yearlycount as prv
on cur.yearly = prv.yearly + 1;

-- CTE Recursive
/*
WITH <cte_name> 
AS (
	 <anchor_member>
	 UNION ALL
	 <recursive_member>
)
<outer_query_against_cte>
*/

with findEmps as (
	select empid, mgrid, firstname, lastname from hr.Employees
	where empid = 2 
	-- questo valore verrà aumentato dopo che la query sottostante non trova più dati da aggiungere a questo valore e il p diventa la tabella uscita dalla query
	UNION ALL
	select c.empid, c.mgrid, c.firstname, c.lastname 
	from findEmps as p
	join hr.Employees as c
	on c.mgrid = p.empid
)
select * from findEmps;

select empid, mgrid, firstname, lastname from hr.Employees


/*
1-1. Write a query that returns the maximum value in the orderdate column for each employee.
Tables involved: Sales.Orders table
Output: empid, maxorderdate
*/
select distinct o.empid, max(orderdate) as maxorderdate
from sales.orders as o
group by empid;

/*
1-2. Encapsulate the query from Exercise 1-1 in a derived table. Write a join query between the derived
table and the Orders table to return the orders with the maximum order date for each employee.
Tables involved: Sales.Orders
Output: empid, orderdate, orderid, custid
*/
with maxDateOrder as (
	select distinct o.empid, max(orderdate) as maxorderdate
	from sales.orders as o
	group by empid
)
select distinct o.empid, o.orderdate, o.orderid, o.custid
from  maxDateOrder as m
inner join sales.orders as o
on o.empid = m.empid and o.orderdate = m.maxorderdate
order by o.empid;


/*
3. Write a solution using a recursive CTE that returns the management chain leading to Zoya
Dolgopyatova (employee ID 9).
Tables involved: HR.Employees
Output: empid, mgrid, firstname, lastname
*/
with findEmps as (
	select empid, mgrid, firstname, lastname from hr.Employees
	where empid = 9
	UNION ALL
	select c.empid, c.mgrid, c.firstname, c.lastname 
	from findEmps as p
	join hr.Employees as c
	on p.mgrid = c.empid
)
select * from findEmps
order by empid desc;

-- Views
/*
	horizontal/vertical filtering from tables
	sono come le CTE ma le viste vengono salvate nel db
	save complex queries può anche essere usata come privasy per nascondere colonne o righe sensibili, 
	ma questo non preclude la possibilità di inserire dei dati attraverso la vista.
	Se la vista ha più join si usano dei trigger che permettono di dividere i dati in tutte le tabelle,
	anche nei casi in cui non si vedono delle colonne vengono usati i trigger.

				tables
			--------------------
			|		   |
		     Views		Proc/Func
*/

create view sales.USACusts
AS
select custid, companyname, contacttitle, address, city, region, postalcode, country
from sales.Customers
where country='USA';

select * from sales.USACusts;

-- check for order by
alter view sales.USACusts
as
select custid, companyname, contacttitle, address, city, region, postalcode, country
from sales.Customers
where country='USA'
order by region;
-- you cant do the order by in a view, but if you make it a OFFSET it make you do it.
alter view sales.USACusts
as
select custid, companyname, contacttitle, address, city, region, postalcode, country
from sales.Customers
where country='USA'
order by region
OFFSET 0 ROWS;

drop view sales.UsaCusts;

create view sales.USACusts with encryption
AS
select custid, companyname, contacttitle, address, city, region, postalcode, country
from sales.Customers
where country='USA';

select object_definition(object_id('sales.USACusts'));
exec sp_helptext 'Sales.USACusts';

alter view sales.USACusts with schemabinding
AS
select custid, companyname, contacttitle, address, city, region, postalcode, country
from sales.Customers
where country='USA';

alter table sales.customers drop column address;

-- dml through view
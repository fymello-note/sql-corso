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
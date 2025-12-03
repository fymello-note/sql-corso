/*
	Joins 
	A
		B
			C
				D

	degree of parallelism
*/
use TSQLV4
go

-- Cross Join
-- SQL-92 Syntax
SELECT c.custid, e.empid
FROM sales.Customers c
CROSS JOIN
hr.Employees as e

-- SQL-89 Syntax ERRORE, bisogna sempre mettere una relazione
SELECT c.custid, e.empid
FROM sales.Customers c,
hr.Employees as e; -- se ho n tabelle devo avere almeno n-1 legami

-- Inner Join
-- SQL-92 Syntax
select
	e.empid, e.firstname, e.lastname, o.orderid
from
	hr.Employees as e
inner join
	sales.Orders as o
on
	e.empid = o.empid

-- SQL-89 Syntax
select
	e.empid, e.firstname, e.lastname, o.orderid
from
	hr.Employees as e,
	sales.Orders as o
where
	e.empid = o.empid

-- Non-Equi Join
-- using not equal operator
select e1.empid, e1.firstname, e1.lastname,
	e2.empid, e2.firstname, e2.lastname
from 
	hr.Employees as e1
inner join 
	hr.Employees as e2
on 
	e1.empid < e2.empid
order by e1.empid

-- Exerc.
/*
	c.custid, c.companyname, o.orderid, od.productid, od.qty
*/

select c.custid, c.companyname, o.orderid, od.productid, od.qty
from
	sales.Customers as c
inner join
	sales.Orders as o
on c.custid = o.custid
inner join
	sales.OrderDetails as od
on o.orderid = od.orderid

-- Outer joins
-- left
select c.custid, c.companyname, o.orderid
from sales.Customers as c
left outer join sales.Orders as o
on c.custid = o.custid

select c.custid, c.companyname, o.orderid
from sales.Customers as c
left outer join sales.Orders as o
on c.custid = o.custid
where o.orderid IS NULL


-- Exerc. add a count numorders
select c.custid, count(o.orderid) as numorders
from sales.Customers as c
left outer join sales.Orders as o
on c.custid = o.custid
group by c.custid

-- right 
select c.custid, c.companyname, o.orderid
from sales.Customers as c
right outer join sales.Orders as o
on c.custid = o.custid



/*
1. Write a query that generates five copies of each employee row.
Tables involved: HR.Employees and dbo.Nums
Output: empid, firstname, lastname, n
*/
select e.empid, e.firstname, e.lastname, n.n
from hr.Employees as e
inner join dbo.Nums as n
on n.n between 1 and 5
order by e.empid

select e.empid, e.firstname, e.lastname, n.n
from hr.Employees as e
cross join dbo.Nums as n
where n.n <= 5
order by n.n, empid


/*
2. Return United States customers, and for each customer return the total number of orders and total quantities.
Tables involved: Sales.Customers, Sales.Orders, and Sales.OrderDetails
Output: custid, numorders, totalqty
*/

select c.custid, count(distinct o.orderid) as numorders, sum(od.qty) as totalqty
from 
	sales.Customers as c
left outer join 
	sales.Orders as o
on c.custid = o.custid
left outer join sales.OrderDetails as od
on o.orderid = od.orderid
where c.country = 'USA'
group by c.custid 
order by c.custid

/*
3. Return customers and their orders, including customers who placed no orders.
Tables involved: Sales.Customers and Sales.Orders
Output: custid, companyname, orderid, orderdate
*/

select c.custid, c.companyname, coalesce(o.orderid, ''), coalesce(o.orderdate, '')
from 
	sales.Customers as c
left outer join 
	sales.Orders as o
on c.custid = o.custid
order by c.custid

/*
4. Return customers who placed no orders.
Tables involved: Sales.Customers and Sales.Orders
Output: custid, companyname
*/
select c.custid, companyname
from sales.customers as c
left outer join sales.Orders as o
on c.custid = o.custid
where o.orderid is NULL

/*
5. Return customers with orders placed on February 12, 2016, along with their orders.
Tables involved: Sales.Customers and Sales.Orders
Output: custid, companyname, orderid, orderdate
*/

select c.custid, c.companyname, o.orderid, o.orderdate
from sales.customers as c 
inner join 
	sales.Orders as o
on 
	c.custid = o.custid
where
	o.orderdate = '20160212'

/*
6. Return customers with orders placed on February 12, 2016, along with their orders. Also return customers who didn’t place orders on February 12, 2016.
Tables involved: Sales.Customers and Sales.Orders
Output: custid, companyname, orderid, orderdate
*/
select DISTINCT c.custid, c.companyname,
case o.orderdate
	when '20160212' then o.orderid
	else NULL
end as orderid, 
case o.orderdate
	when '20160212' then o.orderdate
	else NULL
end as orderdate
from sales.customers as c 
left outer join 
	sales.Orders as o
on 
	c.custid = o.custid
order by c.custid

select DISTINCT c.custid, c.companyname, o.orderdate, o.orderdate
from sales.customers as c 
left outer join 
	sales.Orders as o
on 
	c.custid = o.custid and o.orderdate = '20160212'
order by c.custid

/*
7. Return all customers, and for each return a Yes/No value depending on whether the customer placed
an order on February 12, 2016.
Tables involved: Sales.Customers and Sales.Orders
Output: custid, companyname, HasOrderOn20160212
*/
select c.custid, c.companyname, 
case o.orderdate
	when '20160212' then 'Yes'
	else 'No'
end as HasOrderOn20160212
from sales.customers as c 
left outer join 
	sales.Orders as o
on 
	c.custid = o.custid

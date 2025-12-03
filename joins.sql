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




3. Return customers and their orders, including customers who placed no orders.
Tables involved: Sales.Customers and Sales.Orders
Output: custid, companyname, orderid, orderdate
*/

/*
1. Write a query that generates five copies of each employee row.
Tables involved: HR.Employees and dbo.Nums
Output: empid, firstname, lastname, n
*/
select e.empid, e.firstname, e.lastname, n
from hr.Employees as e
cross join dbo.Nums


/*
2. Return United States customers, and for each customer return the total number of orders and total quantities.
Tables involved: Sales.Customers, Sales.Orders, and Sales.OrderDetails
Output: custid, numorders, totalqty
*/

select c.custid
from 
	sales.Customers as c
inner join 
	sales.Orders as o
on o.custid = c.custid

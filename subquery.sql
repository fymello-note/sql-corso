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
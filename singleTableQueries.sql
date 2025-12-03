/*
	DML - Data Manipulation Language (INSERT, UPDATE, DELITE, MERGE)
	DDL - Data Definition Language (CREATE, ALTER, DROP, TRUNCATE)
	DQL - Data Query Language (SELECT, JOIN, ...)
	DCL - Data Control Language (GRANT, REVOKE, ...)
*/

use TSQLV4
go

-- ALL DQL: 
SELECT empid, YEAR(orderdate) AS orderyear, count(*) AS numorders FROM sales.Orders 
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear

/* 
-> valutazione della query dal sistema dell'sql:

	1.	FROM
	2.	WHERE
	3.	GROUP BY
	4.	HAVING
	5.	SELECT
	6.	ORDER BY
*/

-- FROM
SELECT o.empid
FROM sales.Orders as o

-- WHERE
SELECT empid
FROM sales.Orders 
WHERE custid = 71 and empid = 20;	-- discard data before use

-- GROUP BY
-- non si può fare la select per dei campi non appartenti alla group by se non in una aggregazione (SUM, COUNT, MIN, MAX, ...)
SELECT empid, YEAR(orderdate) AS orderyear, 
SUM(freight) as totalfreight,
count(*) as numorders
FROM sales.Orders 
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

-- count(*)
-- count(distinct custid)

SELECT empid, YEAR(orderdate) AS orderyear, 
SUM(freight) as totalfreight,
count(distinct custid) as numcust
FROM sales.Orders
GROUP BY empid, YEAR(orderdate);

-- HAVING
-- viene applicata sui gruppi e DEVE per forza avere una group by sopra
SELECT empid, YEAR(orderdate) AS orderyear, 
SUM(freight) as totalfreight,
count(distinct custid) as numcust
FROM sales.Orders
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 6

-- SELECT
/*
	select orderid, year(orderdate) as ordereyear
	from sales.Orders
	where orderyear > 2006; -- ERRORE non si può usare un alias nella where, si può usare solo nella '''order by'''
*/

-- si prende la distinct della empid + year (della endupla), non importa quanti ordini ha fatto per quel custumer in un anno,
-- importa che ne abbia fatta almeno uno
SELECT DISTINCT empid, year(orderdate) as orderyear 
from sales.Orders
where custid = 71

-- tutte le colonne esistono nello stesso momento, non si può avere un back reference.
/*
	select orderid, year(orderdate) as orderyear, orderyear + 1
	from sales.Orders
*/

-- ORDER BY
-- è l'unico modo per garantire l'ordinamento nello stampare della tabella
SELECT empid, YEAR(orderdate) AS orderyear, count(*) AS numorders FROM sales.Orders 
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid DESC, orderyear ASC -- o 1, 2 (prende le prime colonne della select)

-- Samping
SELECT TOP(5) orderid, orderdate
from sales.Orders
order by orderdate desc;

SELECT TOP(5) WITH TIES orderid, orderdate
from sales.Orders
order by orderdate desc;

SELECT TOP(5) PERCENT orderid, orderdate
from sales.Orders
order by orderdate desc, orderid desc;

-- Pagination support
SELECT orderid, orderdate, custid, empid
FROM sales.Orders
ORDER BY orderdate
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

-- Predicates and Operators
-- BETWEEN AND
select * from sales.Orders
where orderid between 10300 and 10310;

-- IN
select * from sales.Orders
where orderid in (10300, 10301, 10302);

/* operatori con valutazione:
	()
	*, /, %
	+, -, +, - (Addition, Concatenation).
	=, >, <, <=, >=, !=, <>
	NOT
	AND
	BETWEEN, IN, OR, LIKE
	= (Assignment)
*/

select * from sales.Orders
where custid = 1 
and empid in (1, 3, 5)
or custid = 85
and empid in (2, 4, 6)

select * from sales.Orders
where (custid = 1  and empid in (1, 3, 5))
or (custid = 85 and empid in (2, 4, 6))

-- CASE Expression

-- Simple CASE
select productid, productname,
case categoryid
	when 1 then 'Beverages' -- si chiama simple perché non ci sono formule, ci sono dei valori fissi dopo il when
	when 2 then 'Condiments'
	else 'Unknown category'
end as categoryname
from Production.Products

-- Searched CASE
select orderid, custid, val,
case
	when val < 1000 then 'Less then 1000'
	when val BETWEEN 1000 AND 3000 then 'Between 1000 and 3000'
	else 'Unknown'
end as valuecategory
from sales.OrderValues

-- NULL values
select * from sales.Customers
where region = 'WA';

select * from sales.Customers
where region <> 'WA'; -- != 'WA'

select * from sales.Customers

select * from sales.Customers
where region is NULL

select * from sales.Customers
where region is not NULL

-- collation (data maze)
select * from hr.Employees
where lastname collate latin1_general_cs_as = 'davis';

-- character management
-- +
select empid, firstname + ' ' + lastname as fullname
from hr.Employees

-- null propagation
select custid, country + ' ' + region as location
from sales.Customers

-- solution: coalesce
select custid, country + ', ' + coalesce(region, '') as location
from sales.Customers

-- concat
select custid, concat(country, ',' + region, city) as location
from sales.Customers

-- substring
select substring('abcde', 1, 3)

-- right left
select right('abcde', 3)

-- len
select len('abcde')

-- charindex
select charindex('c', 'abcde')

-- replace
select replace('abcde', 'd', 'm')

-- upper, lower
select * from hr.Employees where lower(lastname) = 'davis'

-- ltrim, rtrim
select rtrim(ltrim('   abc   '))

-- LIKE (predicato)
-- %: va bene qualsiasi cosa dopo
-- _: un solo valore dopo
select * from hr.Employees 
where lastname like 'D%'

select * from hr.Employees
where lastname like '_e%'

select * from hr.Employees
where lastname like '[a-e]%' -- con [] si utiliazzano le regular expression

select * from hr.Employees
where lastname like '[^A-E]%'

-- date
select * from sales.Orders
where orderdate = '20140704' -- trasforma in automatico in data, basta mettere il formato yyyyMMdd

select * from sales.Orders
where orderdate = cast('20140704' as datetime)

set language us_english;
select cast('02/12/2007' as datetime)

set language British;
select cast('02/12/2007' as datetime)

-- date and time functions

-- actual date
select 
	getdate(),
	current_timestamp

-- dateadd
select dateadd(year, 1, '20251202')

-- datediff
select datediff(day, '20251202', '20251227')

-- year, month, day
select year(orderdate), month(orderdate), day(orderdate), orderdate from sales.Orders
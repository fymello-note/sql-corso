-- Set Operation


-- UNION Operator	   -- toglie i duplicati
-- UNION ALL Operator -- tiene i duplicati

-- with Duplicates
select country, region, city 
from hr.Employees
UNION ALL
select country, region, city 
from sales.Customers

-- UNION Distinct
select country, region, city 
from hr.Employees
UNION
select country, region, city 
from sales.Customers

-- INTERSECT Operator
select country, region, city 
from hr.Employees
INTERSECT
select country, region, city
from sales.Customers

-- EXCEPT Operator
select country, region, city 
from hr.Employees
EXCEPT
select country, region, city
from sales.Customers

/*
	Precendence
	INTERSECT has higher priority over UNION and EXCEPT.
	UNION and EXCEPT have the same priority
*/

select country, region, city from production.Suppliers
EXCEPT
select country, region, city from hr.Employees
INTERSECT
select country, region, city from sales.Customers



/*
1. Write a query that generates a virtual auxiliary table of 10 numbers in the range 1 through 10 without using a looping construct.
You do not need to guarantee any order of the rows in the output of your solution.
Tables involved: None
Output: n
*/

select 1 union all
select 2 union all
select 3 union all
select 4 union all
select 5 union all
select 6 union all
select 7 union all
select 8 union all
select 9 union all
select 10

/*
2. Write a query that returns customer and employee pairs that had order activity in January 2016 but
not in February 2016.
Tables involved: Sales.Orders table
Output: custid, empid
*/

select distinct o.custid, o.empid from sales.Orders as o where o.orderdate between '20160101' and eomonth('20160101')
except
select distinct o.custid, o.empid from sales.Orders as o where o.orderdate between '20160201' and eomonth('20160201');

/*
3. Write a query that returns customer and employee pairs that had order activity in both January 2016
and February 2016.
Tables involved: Sales.Orders
Output: custid, empid
*/
select distinct o.custid, o.empid from sales.Orders as o where o.orderdate between '20160101' and eomonth('20160101')
intersect
select distinct o.custid, o.empid from sales.Orders as o where o.orderdate between '20160201' and eomonth('20160201');



/*
4. Write a query that returns customer and employee pairs that had order activity in both January 2016
and February 2016 but not in 2015.
Tables involved: Sales.Orders
Output: custid, empid
*/
select distinct o.custid, o.empid from sales.Orders as o where o.orderdate between '20160101' and eomonth('20160101')
intersect
select distinct o.custid, o.empid from sales.Orders as o where o.orderdate between '20160201' and eomonth('20160201')
except
select distinct o.custid, o.empid from sales.Orders as o where o.orderdate between '20150101' and eomonth('20151201')

/*
5. You are given the following query.

SELECT country, region, city
FROM HR.Employees
UNION ALL
SELECT country, region, city
FROM Production.Suppliers;

You are asked to add logic to the query so that it guarantees that the rows from Employees are
returned in the output before the rows from Suppliers. Also, within each segment, the rows should be
sorted by country, region, and city.

Tables involved: HR.Employees and Production.Suppliers
Output: country, region, city
*/

select * from (SELECT country, region, city
FROM HR.Employees
order by country, region, city
offset 0 row) as emp
UNION ALL
select * from (SELECT country, region, city
FROM Production.Suppliers
order by country, region, city
offset 0 row) as sup

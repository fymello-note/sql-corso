/*
1. Run the following code to create the dbo.Customers table.

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;

CREATE TABLE dbo.Customers
(
custid INT NOT NULL PRIMARY KEY,
companyname NVARCHAR(40) NOT NULL,
country NVARCHAR(15) NOT NULL,
region NVARCHAR(15) NULL,
city NVARCHAR(15) NOT NULL
);
*/
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;

CREATE TABLE dbo.Customer (
custid INT NOT NULL PRIMARY KEY,
companyname NVARCHAR(40) NOT NULL,
country NVARCHAR(15) NOT NULL,
region NVARCHAR(15) NULL,
city NVARCHAR(15) NOT NULL
);


/*
1-1. Insert into the dbo.Customers table a row with:
custid: 100
companyname: Coho Winery
country: USA
region: WA
city: Redmond
*/
insert into dbo.Customer (custid, companyname, country, region, city)
values (100, 'Coho Winery', 'USA', 'WA', 'Redmond')

/*
1-2. Insert into the dbo.Customers table all customers from Sales.Customers who placed orders.
Check if you have to truncate.
*/
truncate table dbo.Customer;
insert into dbo.Customer (custid, companyname, country, region, city)
select distinct c.custid, c.companyname, c.country, c.region, c.city
from sales.Customers as c 
where c.custid = (select o.custid from sales.Orders as o where o.custid = c.custid)

/*
1-3. Use a SELECT INTO statement to create and populate the dbo.Orders table with orders from the
Sales.Orders table that were placed in the years 2014 through 2016.
*/
SELECT * into dbo.Orders4 
from sales.Orders as o
where o.orderdate between '20140101' and eomonth('20161201')

/*
2. Delete from the dbo.Orders table orders that were placed before August 2014. Use the OUTPUT
clause to return the orderid and orderdate of the deleted orders.
Output: orderid, orderdate
*/
delete from dbo.orders4 
output deleted.orderid, deleted.orderdate
where orderdate < '20140801'

/*
3. Delete from the dbo.Orders table orders placed by customers from Brazil.
*/
delete from  dbo.Orders4
where exists (
    select * from sales.Customers as c 
    where c.custid = Orders4.custid and c.country = 'Brazil'
)

delete from  o  
from dbo.Orders4 as o 
inner join sales.Customers as c
 on o.custid = c.custid
where c.country = 'Brazil'

/*
4. Run the following query against dbo.Customers, and notice that some rows have a NULL in the region
column.

SELECT * FROM dbo.Customers;

Update the dbo.Customers table and change all NULL region values to <None>. Use the OUTPUT
clause to show the custid, oldregion, and newregion.

Output: custid, oldregion, newregion
*/
SELECT * FROM dbo.Customer;

UPDATE dbo.Customer 
set region = '<None>' 
output inserted.custid, deleted.region as oldregion, inserted.region as newregion
where region is NULL

/*
5. Update all orders in the dbo.Orders table that were placed by United Kingdom customers and set
their shipcountry, shipregion, and shipcity values to the country, region, and city values of the corresponding customers.
*/
UPDATE o
set o.shipcountry = c.country, o.shipregion = c.region, o.shipcity = c.city
from dbo.Orders4 as o inner join dbo.Customer as c 
on o.custid = c.custid
where c.country = 'UK'

/*
6. When you’re done, run the following code for cleanup.

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
*/
IF OBJECT_ID('dbo.Orders4', 'U') IS NOT NULL DROP TABLE dbo.Orders4;
IF OBJECT_ID('dbo.Customer', 'U') IS NOT NULL DROP TABLE dbo.Customer;
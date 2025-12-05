-- Pivot

create table dbo.Orders1 (
	orderid int not null,
	orderdate date not null,
	empid int not null,
	custid varchar(5) not null,
	qty int not null,
	constraint pk_orders1 primary key(orderid)
)

insert into dbo.Orders1
values (30001, '20160101', 3, 'a', 10), (10001, '20160101', 2, 'a', 12), (10005, '20160101', 1, 'b', 20)

select * from dbo.Orders1

select empid, custid, sum(qty) as sumqty
from dbo.orders1
group by empid, custid

/*
empid	custid	 s(qty)
2		  a			12
3		  a			10
1		  b			20

PVO 

		a		b
empid	
1	  null		20
2	   12		null
3	   10		null

mette empid come righe e custid come colonne
*/

-- Pivot usign standard sql
select o.empid, 
(select sum(qty) from dbo.Orders1 as o2 where o2.custid = 'a' and o.empid = o2.empid) as a,
(select sum(qty) from dbo.Orders1 as o2 where o2.custid = 'b' and o.empid = o2.empid) as b
from dbo.Orders1 as o
group by o.empid
-- or
select empid,
	case when custid = 'a' then sum(qty) end as a,
	case when custid = 'b' then sum(qty) end as b
from dbo.Orders1
group by empid, custid
order by empid

-- sql using native T-SQL Pivot Operator

select empid, a, b from
(select empid, custid, qty from dbo.Orders1) as D
PIVOT (sum(qty) for custid in (a, b)) as P

-- Multiple grouping

select empid, custid, SUM(qty) as sumqty
from dbo.Orders1
group by empid, custid
UNION ALL
select empid, null, SUM(qty) as sumqty
from dbo.Orders1
group by empid
union all
select null, custid, SUM(qty) as sumqty
from dbo.Orders1
group by custid
union all
select null, null, SUM(qty) as sumqty
from dbo.Orders1

-- and a native approach using GROUPING SETS

select empid, custid, SUM(qty) as sumqty
from dbo.Orders1
group by
grouping sets ((empid, custid), (empid), (custid), ())

-- è molto dispendiosa perché combina tutte le colonne che menzioniamo
select empid, custid, SUM(qty) as sumqty
from dbo.Orders1
group by cube(empid, custid)

-- è meno dispendiosa della cude perché combina le colonne che menzioniamo da sinistra a destra
select year(orderdate) as orderyear, month(orderdate) as ordermonth, day(orderdate) as orderday, sum(qty) as sumqty
from dbo.Orders1
group by rollup(year(orderdate), month(orderdate), day(orderdate))

-- identifying group level
select GROUPING(empid) as grpemp, GROUPING(custid) as grpcust, empid, custid, sum(qty) as sumqty
from dbo.orders1
group by cube(empid, custid)
order by grpemp, grpcust

-- questo lo fa in binario, per la lettura non va molto bene
select GROUPING_ID(empid, custid) as gropingset, empid, custid, sum(qty) as sumqty
from dbo.orders1
group by cube(empid, custid)
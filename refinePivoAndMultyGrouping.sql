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


/*
	DML: INSERT, UPDATE, DELETE, MERGE
*/

use TSQLV4
go

-- INSERT VALUES
create table dbo.Orders2 (
	orderid int not null constraint pk_orders2 primary key,
	orderdate date not null constraint df_orderdate2 default(sysdatetime()),
	empid int not null,
	custid varchar(10) not null
);

insert into dbo.Orders2(orderid, orderdate, empid, custid)
values (10001, '20250101', 3, 'a');

insert into dbo.Orders2
values (10002, '20250101', 3, 'a');

insert into dbo.Orders2
values 
(10003, '20250101', 3, 'a'),
(10004, '20250101', 3, 'a'),
(10005, '20250101', 3, 'a'),
(10006, '20250101', 3, 'a')


-- insert select
insert into dbo.Orders2(orderid, orderdate, empid, custid)
select orderid, orderdate, empid, custid
from sales.Orders
where shipcountry = 'UK'


go
-- insert exec
create procedure sales.get_orders
    @country as varchar(40)
as
    select orderid, orderdate, empid, custid
    from sales.Orders
    where shipcountry = @country

insert into dbo.Orders2(orderid, orderdate, empid, custid)
exec sales.get_orders @country="France"

-- SELECT INTO
select orderid, orderdate, empid, custid
into dbo.orders3
from sales.Orders

-- Automatic generation of PK values
-- Possiamo avere una sola identità, ed è l'unico motivo che ci garantisce la concorrenza
create table dbo.t1 (
    keycol int not null identity (1, 1) constraint pk_t1 primary key,
    datacol varchar(50)
)

insert into t1 (datacol) values ('a')

select $identity from t1

-- se abbiamo più database su più basi che non vogliono che i dati escano dal paese si usa una sequence per garantire l'identità

create sequence sequordersIDs AS int
MINVALUE 1 -- si può mettere anche un limite massimo
CYCLE

select next value for sequordersIDs


create table dbo.t2 (
    keycol int not null constraint pk_t1 primary key,
    datacol varchar(50)
)

declare @newworderid as int = next value for sequordersIDs;
insert into dbo.t2(keycol, datacol) values (@newworderid, 'a');



insert into dbo.t2(keycol, datacol) values (next value for sequordersIDs, 'a');


-- Delete

delete from dbo.orders3
where empid = 1;

-- Per salvare da una delete server un back up

-- la truncate non è recuperabile 
truncate table dbo.orders3

-- Delete based on join

select * from sales.Orders
select * from sales.Customers

select * into dbo.MYORDERS from sales.Orders;
select * into dbo.MYCUSTOMERS from sales.customers;

delete from o
from dbo.MyOrders as o 
join dbo.MyCustomers as c 
on c.custid = o.custid
where c.country = 'USA';


--      UPDATE

/*
    update tbname
    set field = newvalue, 
    ...
    [where]
*/

update sales.OrderDetails
set discount += +0.05
where productid = 51

-- UPDATE Based On Join
update od
set discount += +0.05
from sales.OrderDetails as od inner join sales.Orders as o on od.orderid = o.orderid
where o.custid = 1

--      MERGE

/*
        database oltp
                customers
                    1  aa (MODIFIED
                    2  b
                    3  c (ADDED)


                            database dwh
                                customers
                                    1  a
                                    2  b
*/


select * into customersdwh
from sales.customers
where 1=0

select * from sales.Customers
select * from customersdwh

set IDENTITY_INSERT customersdwh ON;

merge into customersdwh as TGT 
using sales.customers as SRC
on TGT.custid = SRC.custid
when matched THEN
update SET      -- bisogna per forza scrivere tutti i campi, l'* non funziona
    tgt.companyname = src.companyname,
    tgt.city = src.city
when not matched THEN
insert (custid, companyname, phone, address)
values (src.custid, src.companyname, src.phone, src.address);

--      OUTPUT Clause

-- insert with output
insert into t1 (datacol) 
output inserted.keycol, inserted.datacol
values ('aaaa')

-- delite with output
delete from t1
output deleted.keycol, deleted.datacol

-- update with output
update sales.orderDetails
set discount += 0.05
output inserted.productid,
deleted.discount as olddiscount,
inserted.discount as newdiscount
where productid = 51

-- merge with output
merge into customersdwh as TGT 
using sales.customers as SRC
on TGT.custid = SRC.custid
when matched THEN
update SET      -- bisogna per forza scrivere tutti i campi, l'* non funziona
    tgt.companyname = src.companyname,
    tgt.city = src.city
when not matched THEN
insert (custid, companyname, phone, address)
values (src.custid, src.companyname, src.phone, src.address)
output $action as theaction, inserted.custid, deleted.companyname;
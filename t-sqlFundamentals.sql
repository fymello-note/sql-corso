/*
    sql - declarative
    t-sql - programmable (un sql programmabile)
        aggiunge if, while, declare, function, procedure, trigger 
*/

-- declare
-- Variable
declare @i as int;
set @i = 10

declare @e as int = 10;

-- il risultato di una query può essere contentuto in una variabile
declare @empname as varchar(50);
set @empname = (select firstname + ' ' + lastname from hr.Employees where empid = 3)

-- Exer. @firstname, @lastname  where empid = 3
-- Using SELECT print both the variables
declare @firstname as varchar(50);
set @firstname = (select firstname from hr.Employees where empid = 3)
declare @lastname as varchar(50);
set @lastname = (select lastname from hr.Employees where empid = 3)
select @firstname as fname, @lastname as lname

declare @firstname1 as varchar(50), @lastname1 as varchar(50);
select
    @firstname1 = firstname,
    @lastname1 = lastname
from hr.Employees
where empid = 3;

-- Conditional and Loops
-- If
if DAY(SYSDATETIME()) = 1
begin
    print 'Today is the first of the month'
end else
begin
    print 'Today is not the first day of the month'
end

-- While
DECLARE @p as int = 1;
while @p <= 10 begin
    print @p;
    set @p = @p + 1;
end

while @p <= 10 begin
    set @p = @p + 1;
    if @p = 6 break;
    if @p = 7 continue;
    print @p;
end

-- Cursor
/*
    1. Cursor declaration: sempre basata su un custrutto della select
    2. OPEN cursor
    3. FETCH of the next row
    4. Check
    5. CLOSE cursor
*/

DECLARE @Result TABLE (
    custid INT,
    ordermonth DATETIME,
    qty int,
    runqty int,
    primary key(custid, ordermonth) -- l'ordinamento sarebbe previsto per queste chiavi primarie
)

DECLARE @custid as int, @prvcustid as int, @ordermonth datetime, @qty as int, @runqty as int;

declare c cursor 
fast_forward --read only, forward only
for select custid, ordermonth, qty from sales.custorders ORDER by custid, ordermonth;

open c;

fetch next from c into @custid, @ordermonth, @qty;
select @prvcustid=@custid, @runqty = 0;

while @@FETCH_STATUS = 0
begin
    if @custid <> @prvcustid
        select @prvcustid = @custid, @runqty = 0;

    set @runqty = @runqty + @qty;
    insert into @Result values (@custid, @ordermonth, @qty, @runqty);
    fetch next from c into @custid, @ordermonth, @qty;
end

close c;
deallocate c;

select * from @result
order by custid, ordermonth;

-- Exerc. Declare a cursor to compute the total amount of the orders
-- sum(qty*unitprice) from orderDetails

declare @ResultSum as numeric(10,2);

DECLARE @qtyn as int, @unitprice as numeric(10, 2);

declare cur cursor fast_forward for select qty, unitprice from sales.OrderDetails;

open cur;
fetch next from cur into @qtyn, @unitprice;
set @ResultSum = 0;

while @@FETCH_STATUS = 0
begin
    set @ResultSum = @ResultSum + (@qtyn * @unitprice) 
    fetch next from cur into @qtyn, @unitprice;
end

select @ResultSum as totalSum;

close cur;
deallocate cur;

-- dove viene salvata la tabella  nella variabile, nella memoria ram o è un puntatore?
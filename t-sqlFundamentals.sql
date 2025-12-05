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
print @ResultSum;

close cur;
deallocate cur;

-- Function
-- table-valued function
-- -> quella vista in precendenza.


------------------
go --- separator
------------------
-- scalar function

create function dbo.GetAge(@BIRTHDAY as DATE, @eventday as DATE)
returns int as begin 
    return datediff(year, @BIRTHDAY, @eventday);
end
------------------
go --- separator
------------------

select empid, firstname, lastname, dbo.GetAge(birthdate, SYSDATETIME()) from hr.Employees

-- Procedures

------------------
go --- separator
------------------
create procedure myGetCustOrders
    @custid as int,
    @fromdate as date = '20100101',
    @todate as date = '20201231',
    @numrows as int output
as
    select * from sales.Orders
    where custid = @custid and orderdate >= @fromdate and orderdate <= @todate;

    set @numrows = @@ROWCOUNT;

declare @rc as int;
exec myGetCustOrders @custid = 1, @numrows = @rc output;

select @rc as numrows;
------------------
go --- separator
------------------

-- Trigger
/*
    eventi validi: DML (INSERT, DELETE, UPDATE)
*/

create table ttt1 (
    keycol int not null primary key,
    datacol varchar (10) not null
)

create table ttt1_audit (
    audit_lsn int not null identity primary key,
    dt datetime not null default (sysdatetime()),
    login_name sysname not null default (original_login()),
    keycol int not null,
    datacol varchar(10) not null,
    outcome char(1) not null default ('Y')
)

------------------
go --- separator
------------------
create TRIGGER trg_ttt1_insert_audit on dbo.ttt1 after insert as
insert into ttt1_audit (keycol, datacol)
select keycol, datacol from inserted
------------------
go --- separator
------------------

insert into ttt1 (keycol, datacol) values (1, 'aaa')

select * from ttt1_audit;
select * from ttt1;

-- Error handling
begin try
    insert into ttt1 values (1, 'aaa')
end try
begin catch
    if ERROR_NUMBER() = 2627
    begin
        print 'pk violated';
    end
end catch


/*
1. Create a Stored Procedure with Parameters

Write a SQL query to create a stored procedure that takes parameters and returns results.

Create a stored procedure called GetEmployeesByDepartment that takes a DepartmentID in input, returning the list of Employees in that department. Test the invocation of the procedure.

CREATE TABLE Employees (
	..
	DepartmentID ..
)
*/
CREATE TABLE EmployeesM (
    custid int not null identity primary key, 
	DepartmentID int not null,
    datacust varchar(20) not null
)

go
create procedure SetEmployeesByDepartment
    @departmentid as int,
    @datacust as varchar(20)
as
    insert into EmployeesM (DepartmentID, datacust) values (@departmentid, @datacust)
    select * from EmployeesM;


exec SetEmployeesByDepartment @departmentid = 29, @datacust = 'a'
exec SetEmployeesByDepartment @departmentid = 28, @datacust = 'a'
exec SetEmployeesByDepartment @departmentid = 8, @datacust = 'a'
exec SetEmployeesByDepartment @departmentid = 29, @datacust = 'a'

go
create procedure GetEmployeesByDepartment
    @departmentid as int
as
    select * from EmployeesM where DepartmentID = @departmentid;

exec GetEmployeesByDepartment @departmentid = 29; 

/*
2. Execute a Stored Procedure with Output Parameters

Write a SQL query to create and execute a stored procedure that uses output parameters. 
Write a procedure called GetEmployeeCountByDepartment that receives in input DepartmentID and return in output the number of Employees in that department. Test the procedure.
*/
go
create procedure GetEmployeesCountByDepartment
    @departmentid as int,
    @numrows as int output
as
    select @numrows = (select count (*) from EmployeesM where DepartmentID = @departmentid);

declare @rc as int;
exec GetEmployeesCountByDepartment @departmentid = 1, @numrows = @rc output;

select @rc;
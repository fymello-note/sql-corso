use TSQLV4
go

DROP TABLE dbo.Employees
go

CREATE TABLE dbo.Employees(
	empid INT NOT NULL,
	firstname VARCHAR(30) NOT NULL,
	lastname VARCHAR(30) NOT NULL,
	hiredate DATE NOT NULL,
	mgrid INT NULL,
	salary MONEY NOT NULL,
	ssn VARCHAR(20) NOT NULL
)

-- 1. constraint: primary key

ALTER TABLE dbo.Employees
ADD CONSTRAINT PK_Employees
PRIMARY KEY(empid);

SELECT * FROM dbo.Employees
WHERE empid = 10

-- 2. constraint: unique

alter table dbo.Employees
ADD CONSTRAINT UNQ_Employees_ssn
UNIQUE(ssn);

-- 3. constraint: foreign key
-- referential integrity

CREATE TABLE dbo.Orders (
	orderid int not null,
	empid int not null,
	custid varchar(10) not null,
	qty int not null,
	constraint pk_orders primary key(orderid)		-- creazione della chiave primaria all'interno della creazione della tabella.
)

ALTER TABLE dbo.Orders
ADD CONSTRAINT FK_Orders_Employees
FOREIGN KEY(empid)
REFERENCES dbo.Employees(empid);

-- VER -> verifica dell'esistenza della foreign key.

INSERT INTO dbo.Orders VALUES (1, 1, '1', 1);

-- 4. constraint: check

ALTER  TABLE dbo.Employees
ADD CONSTRAINT CHK_Employees_salary
CHECK(salary > 0);

-- Constraints are all proactive...
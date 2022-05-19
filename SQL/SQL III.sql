--aggregation function: 
--subquery:
--union vs. union all
--window function
--CTE


--@
--#

--temporary table: special type of table so that we can store data temporarily
--# -> local temp table: 
CREATE TABLE #LocalTemp
(
Number int
)

DECLARE @Variable INT = 1
WHILE (@Variable <= 10)
BEGIN
INSERT INTO #LocalTemp(Number) VALUES(@Variable)
SET @Variable = @Variable  + 1
END

SELECT *
FROM #LocalTemp

--## -> global temp objects
CREATE TABLE ##GlobalTemp(
Number int
)

DECLARE @Num INT = 1
WHILE (@Num <= 10)
BEGIN
INSERT INTO ##GlobalTemp(Number) VALUES(@Num)
SET @Num = @Num  + 1
END

SELECT *
FROM ##GlobalTemp


--table variable:
DECLARE @today DATETIME
SELECT @today = getdate()
PRINT @today

DECLARE @WeekDays TABLE (DayNum int, DayAbb varchar(10), WeekName varchar(10))
INSERT INTO @WeekDays
VALUES
(1,'Mon','Monday')  ,
(2,'Tue','Tuesday') ,
(3,'Wed','Wednesday') ,
(4,'Thu','Thursday'),
(5,'Fri','Friday'),
(6,'Sat','Saturday'),
(7,'Sun','Sunday')	
SELECT * FROM @WeekDays
SELECT * FROM tempdb.sys.tables

--temp tables vs table variables
--1. temp tables and tables variables are stored in temp db
--2. scope: local/global; current batch
--3. size: >100 rows; <100 
--4. usage: do not use in SP/FUNCITION; can be used in sp/function 

--view: virtual table that contains data from one or multiple tables
SELECT *
FROM Employee

INSERT INTO Employee
VALUES(1, 'Fred', 5000),(2, 'Laura', 7000), (3,'Amy', 6000)

CREATE VIEW vwEmp
AS
SELECT ID, ENAME, Salary
FROM Employee

SELECT *
FROM vwEmp

--sp: prepared sql query that we can save and reuse over and over again
BEGIN
PRINT 'Hello anonymous block'
END

CREATE PROC spHello
AS
BEGIN
PRINT 'Hello Stored Procedure'
END

EXECUTE spHello

--input
CREATE PROC spAddNumbers
@a int,
@b int
AS
BEGIN
	PRINT @a + @b
END

EXEC spAddNumbers 10,20

--output
CREATE PROC spGetEmpName
@id int,
@ename varchar(20) out
AS
BEGIN
SELECT @ename = Ename FROM Employee WHERE ID = @id
END

BEGIN
DECLARE @EName varchar(20)
EXEC spGetEmpName 2, @EName out
PRINT @EName
END

SELECT *
FROM Employee

CREATE PROC spGetAllEmp
AS
BEGIN
SELECT Id, EName, Salary
FROM Employee
END

EXEC spGetAllEmp

--trigger:automatically run when an event occurrs
--DML trigger
--DDL trigger
--Logon Trigger


--function: 
CREATE FUNCTION GetTotalRevenue(@price money, @discount real, @quantity smallint) 
returns money
AS
BEGIN
DECLARE @revenue money
SET @revenue = @price * (1 - @discount) * @quantity
RETURN @revenue
END

SELECT UnitPrice, Discount, Quantity, dbo.GetTotalRevenue(UnitPrice, Discount, Quantity) AS TotalRevenue
FROM [Order Details]

CREATE FUNCTION expensiveProduct (@threshold money) 
RETURNS TABLE 
AS
RETURN
	SELECT *
	FROM Products
	WHERE UnitPrice > @threshold

SELECT *
FROM dbo.expensiveProduct(10)

--sp vs. function
--usage: sp for DML, function for calculations
--how to call: sp called by its name, function will be called in SQL query
--output: sp may or maynot have output, but function must return some value
--SP can function but function can not call sp



--Pagination:
--OFFSET: skip
--FETCH: select

SELECT CustomerId, ContactName, City
FROM Customers
ORDER BY CustomerID
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY

SELECT CustomerId, ContactName, City
FROM Customers
ORDER BY CustomerID

--DECLARE @PageNumber AS INT
--DECLARE @RowsOfPage AS INT 
--SET @PageNumber = 2
--SET @RowsOfPage = 10
--SELECT CustomerId, ContactName, City
--FROM Customers
--ORDER BY CustomerID
--OFFSET (@PageNumber - 1) * @RowsOfPage ROWS
--FETCH NEXT @RowsOfPage ROWS ONLY

DECLARE @PageNumber AS INT
DECLARE @RowOfPage AS INT
DECLARE @MaxTablePage AS FLOAT
SET @PageNumber = 1
SET @RowOfPage = 10
SELECT @MaxTablePage = COUNT(*) FROM Customers --91.0
SET @MaxTablePage = CEILING(@MaxTablePage / @RowOfPage) --91.0/10 -9.1 --10
WHILE @MaxTablePage >= @PageNumber
BEGIN
SELECT CustomerId, ContactName, City
FROM Customers
ORDER BY CustomerID
OFFSET (@PageNumber - 1) * @RowOfPage ROWS
FETCH NEXT @RowOfPage ROWS ONLY
SET @PageNumber = @PageNumber + 1
END


--constraints

DROP TABLE Employee

CREATE TABLE Employee(
Id int,
EName varchar(20),
Age int
)
SELECT *
FROM Employee

INSERT INTO Employee VALUES(1, 'Sam', 49)

INSERT INTO Employee VALUES(Null, Null, Null)

CREATE TABLE Employee(
Id int not null,
EName varchar(20) not null,
Age int
)

CREATE TABLE Employee(
Id int Unique,
EName varchar(20) not null,
Age int
)

SELECT *
FROM Employee

INSERT INTO Employee VALUES(Null, 'Fiona', 45)

DROP TABLE Employee

CREATE TABLE Employee(
Id int Primary Key,
EName varchar(20) not null,
Age int
)

--primary key vs unique key
--1. unique key can accept one and only one null value; pk cannot accept any null values
--2. one table can have multiple unique keys, but only one pk
--3. pk will sort the data by default, but unique key will not
SELECT *
FROM Employee

delete Employee

INSERT INTO Employee
VALUES(4, 'Fred', 45)

INSERT INTO Employee
VALUES(1, 'Laura', 34)

INSERT INTO Employee
VALUES(3, 'Peter', 19)

INSERT INTO Employee
VALUES(2, 'Stella', 24)
--PK will by default create clusterd index, and unique key will create non-clustered index
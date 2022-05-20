--basic query: select, where, order by, join, aggregation function, having, 
--advanced topics: subquery, cte, window function, pagination
--temp tables, table variables, views, sp, user defined functions, normalization

INSERT INTO Employee VALUES(5, 'Monster', 3000)
INSERT INTO Employee VALUES(6, 'Weird', -3000)

--check constraint: limit the value range that can be placed in the column
DELETE Employee

ALTER TABLE Employee
ADD Constraint Chk_Age_Employee CHECK(Age BETWEEN 18 AND 60)

INSERT INTO Employee VALUES(1, 'Fred', 20)

SELECT * FROM Employee

--identity
CREATE TABLE Product (
Id int PRIMARY KEY IDENTITY(1,1),
ProductName varchar(20) UNIQUE NOT NULL,
UnitPrice Money
)

INSERT INTO Product VALUES('Green Tea', 2)
INSERT INTO Product VALUES('Latte', 3)
INSERT INTO Product VALUES('Cold Brew', 4)

SELECT * FROM PRODUCT

--Set Identity_Insert Product OFF
--INSERT INTO Product (Id, ProductName, UnitPrice) VALUES(5, 'Milk', 4)

--Delete vs. Truncate
--1) DELETE is a DML statement, will not reset identity; but Truncate is a DDL statement, will reset the identity

DELETE PRODUCT

TRUNCATE TABLE Product
--2) DELETE can be used with WHERE clause to remove one or more records, but TRUNCATE will remove all records and cannot be used with WHERE

DELETE PRODUCT
WHERE ID = 3

--referential integrity - implemented by foreign key
CREATE TABLE Department(
Id int PRIMARY KEY,
DName varchar(20) NOT NULL,
Loc varchar(20)
)

CREATE TABLE Employee (
Id int PRIMARY KEY,
EName varchar(20) NOT NULL,
Age int CHECK(Age BETWEEN 18 AND 60),
DeptId int FOREIGN KEY REFERENCES Department(ID)
)

SELECT * FROM Department
SELECT * FROM Employee

INSERT INTO Department VALUES(1, 'IT', 'Chicago')
INSERT INTO Department VALUES(2, 'HR', 'Sterling')
INSERT INTO Department VALUES(3, 'QA', 'Paris')

INSERT INTO Employee VALUES(1, 'Fred', 34, 1)
INSERT INTO Employee VALUES(2, 'Laura', 34, 3)

DELETE FROM Department
WHERE ID  = 2

--transaction: a group of logically related DML statements that will either succeed together or fail together
--three mode of transactions:
--autocommit transaction: default
--implicit transaction
--explicit transaction

DROP TABLE PRODUCT

CREATE TABLE PRODUCT
(ID int primary key,
ProductName varchar(20) not null,
UnitPrice money,
Quantity int)

INSERT INTO Product VALUES(1, 'Green Tea', 2, 100)
INSERT INTO Product VALUES(2, 'Latte', 3, 100)
INSERT INTO Product VALUES(3, 'Cold Brew', 4, 100)

SELECT * FROM PRODUCT

BEGIN TRAN
INSERT INTO PRODUCT VALUES(4, 'Flat White', 4, 100)

SELECT * FROM PRODUCT
COMMIT

BEGIN TRAN
INSERT INTO PRODUCT VALUES(5, 'Earl Gray', 3, 100)

SELECT * FROM PRODUCT
ROLLBACK

--properties of transactions
/*ACID
A: Atomicity -- work is atomic
C: Consistency -- whatever happends in the middle of the transaction, this property will never leave your db in half-completed state
I: Isolation -- two transactions will be isolated from each other by locking the resource
D: Durability -- once the transaction is completed, then the changes it has made to the db will be permanent

concurrency occurs when two or more transactions are trying to access the same data or info
1. dirty reads:
	t1 allows t2 to read uncommitted data and then t1 rolled back
	caused by isolation level read uncommitted
	solved by isolation level read committed
2. lost update
	t1 and t2 read and update the same data but t2 finish its work earlier than t1, then t2 will lost their update
	caused by isolation level read committed
	solved by isolation level repeatable read
3. non repeatable read
	t1 read the same data twice while t2 is updating the data
	caused by isolation level read committed
	solved by isolation level repeatable read
4. phantom read
	t1 reads the same data twice while t2 is inserting records
	cuased by isolation level repeatable read
	solved by isolation level serializable
*/

--ats
--1.update candidate table
--2. insert into employee table
--3. insert into timesheet table

--index: an on-disk structure associated with a table that increase retrieval speed of rows from the table

--clustered index: physically sort the data; one table can only have one clustered index 

--non clustered index: will not sort the data, will be sotred seperately

CREATE TABLE Customer(
Id int, 
FullName varchar(20),
City varchar(20),
Country varchar(20)
)
SELECT * FROM Customer

CREATE CLUSTERED INDEX Cluster_IX_Customer_ID ON Customer(ID)

INSERT INTO Customer VALUES(4, 'Fred', 'Stering','USA')
INSERT INTO Customer VALUES(1, 'Laura', 'Stering','USA')
INSERT INTO Customer VALUES(3, 'Sam', 'Stering','USA')
INSERT INTO Customer VALUES(2, 'Fiona', 'Stering','USA')

drop table customer
CREATE TABLE Customer(
Id int PRIMARY KEY,  
FullName varchar(20),
City varchar(20),
Country varchar(20)
)

select * from Customer

CREATE INDEX Noncluster_IX_Customer_City ON Customer(City)

--when to create index
--clustered index: always necessary, go with pk
--non clustered index: WHERE, JOIN condition, Aggregated fields

--Pros: index will help us improve retrieving speed -- improve performance of select
--Cons: slow down other DML statements, extra space

--performance tuning
--1. look at the execution plan
--2. choose index wisely
--3. avoid unnecessary joins
--Student table: sId, sName;
--Course table: cId, cName
--studentCourse: sId, cId
--sName, numOfCourse
--4. avoid SELECT *
--5. JOIN to replace subquery
--6. derived table to avoid a lot of grouping by
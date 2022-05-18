--select: retrieve the columns
--where: filter the data
--order by: sort the data
--join: combine multiple tables in one query


--Aggregation functions: perform a calculation on a set of values and return a single value
--1. COUNT(): returns the number of rows
SELECT COUNT(*) TotalNumOfOrders
FROM Orders

SELECT COUNT(OrderID) TotalNumOfOrders
FROM Orders


--COUNT(*) vs. COUNT(colName): count(*) will include null values, but count(colname) will not include null values
SELECT EmployeeID, LastName, FirstName, Region
FROM Employees

SELECT COUNT(*), COUNT(Region)
FROM Employees

--use w/ GROUP BY: group rows that have the same value into summary rows
--find total number of orders placed by each customers
SELECT c.CustomerID, c.ContactName, c.Country, COUNT(o.OrderID) AS NumOfOrders
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.ContactName, c.Country
ORDER BY NumOfOrders DESC

--a more complex template: 
--only retreive total order numbers where customers located in USA or Canada, and order number should be greater than or equal to 10
SELECT c.ContactName, c.Country, COUNT(o.OrderID) AS NumOfOrders
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Country IN ('USA', 'Canada')
GROUP BY c.ContactName, c.Country
HAVING COUNT(o.OrderID) >= 10
ORDER BY NumOfOrders DESC

--SELECT fieds, aggregate(fields)
--FROM table JOIN table2 ON...
--WHERE criteria --optional
--GROUP BY fieds
--HAVING criteria --optional
--ORDER BY field --optional

--WHERE vs. HAVING
--1) both are used as filters, but having apply only to groups as a whole, and only filters on aggregation functions; where applys to individual rows
--2) WHERE goes before aggregations, but HAVING filters after the aggregations
	--FROM/JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY
	             --|_________________________|
				 --cannot use alias in select
	SELECT c.ContactName, c.Country AS Cty, COUNT(o.OrderID) AS NumOfOrders
	FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
	WHERE Cty IN ('USA', 'Canada')
	GROUP BY c.ContactName, Cty
	HAVING NumOfOrders >= 10
	ORDER BY NumOfOrders DESC
--3) WHERE can used with SELECT UPDATE OR DELETE, but HAVING will only be used in SELECT 
select *
from Products

update Products
set UnitPrice = 20
where ProductID = 1

--COUNT DISTINCT: 
SELECT City
FROM Customers

SELECT COUNT(DISTINCT City)
FROM Customers


SELECT COUNT(City)
FROM Customers

--2. AVG(): return the average value of a numeric column
--list average revenue for each customer
SELECT c.ContactName, AVG(od.Quantity * od.UnitPrice) AS AvgRevenuePerCustomer
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY AvgRevenuePerCustomer DESC


--3. SUM(): 
--list sum of revenue for each customer
SELECT c.ContactName, SUM(od.Quantity * od.UnitPrice) AS SumRevenuePerCustomer
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY SumRevenuePerCustomer DESC

--4. MAX(): 
--list maxinum revenue from each customer
SELECT c.ContactName, MAX(od.Quantity * od.UnitPrice) AS MaxRevenuePerCustomer
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY MaxRevenuePerCustomer DESC


--5.MIN(): 
--list the cheapeast product bought by each customer
SELECT c.ContactName, MIN(od.UnitPrice) AS CheapestProduct
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName

--TOP predicate: select a specific number or a certain percentage of records from data
--retrieve top 5 most expensive products
SELECT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

SELECT TOP 5 ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

--retrieve top 10 percent most expensive products
SELECT TOP 10 PERCENT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

--limit

--list top 5 customers who created the most total revenue
SELECT TOP 5 c.ContactName, SUM(od.Quantity * od.UnitPrice) AS SumRevenuePerCustomer
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY SumRevenuePerCustomer DESC


--Subquery: a SELECT statement taht is embeded in a clause of another sql statement

--find the customers from the same city where Alejandra Camino lives 
SELECT ContactName, City
FROM Customers 
WHERE City = 
(SELECT City
FROM Customers
WHERE ContactName = 'Alejandra Camino') AND ContactName != 'Alejandra Camino'

--find customers who make any orders
--join
SELECT DISTINCT c.CustomerID, c.ContactName, c.City, c.Country
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID

--subquery
SELECT CustomerID, ContactName, City, Country
FROM Customers
WHERE CustomerID IN 
(SELECT CustomerID
FROM Orders)

--subquery vs. join
--1) JOIN can only be used in FROM; Subquery can be used in SELECT, WHERE, FROM, ORDER BY 
--list all the orders and corrsponding employee who's in charge of this order
--join
SELECT o.OrderDate, e.FirstName, e.LastName
FROM Orders o INNER JOIN Employees e ON e.EmployeeID = o.EmployeeID
WHERE e.City = 'London'
ORDER BY o.OrderDate, e.FirstName, e.LastName

--subquery
SELECT o.OrderDate,
(SELECT e1.FirstName FROM Employees e1 WHERE o.EmployeeID = e1.EmployeeID) AS FirstName,
(SELECT e2.LastName FROM Employees e2 WHERE o.EmployeeID = e2.EmployeeID) AS LastName
FROM Orders o 
WHERE (SELECT e3.City FROM Employees e3 WHERE o.EmployeeID = e3.EmployeeID) = 'London'
ORDER BY o.OrderDate, 
(SELECT e1.FirstName FROM Employees e1 WHERE o.EmployeeID = e1.EmployeeID),
(SELECT e2.LastName FROM Employees e2 WHERE o.EmployeeID = e2.EmployeeID) 
--2)subquery is easy to understand and maintain
--find customers who never placed any order
--join
SELECT c.CustomerID, c.ContactName, c.City, c.Country
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL

--subquery
SELECT CustomerID, ContactName, City, Country
FROM Customers
WHERE CustomerID NOT IN
(SELECT CustomerID
FROM Orders)

--3) usually join will have a better performance than subquery


--Correlated Subquery: inner query is dependent on the outer query
--Customer name and total number of orders by customer
--join
SELECT c.ContactName, COUNT(o.OrderID) AS NumOfOrders
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerId
GROUP BY c.ContactName
ORDER BY NumOfOrders DESC

--corrlated subqury
SELECT c.ContactName, 
(SELECT COUNT(o.OrderId) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS NumOfOrders
FROM Customers c 
ORDER BY NumOfOrders DESC


--derived table: 
--syntax
SELECT CustomerID, ContactName
FROM (SELECT *
FROM Customers) dt

--customers and the number of orders they made
--regular join:
SELECT c.ContactName, c.CompanyName, c.City, c.Country, COUNT(o.OrderID) AS NumOfOrders
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName, c.CompanyName, c.City, c.Country
ORDER BY NumOfOrders DESC

--use derived table to optimze join
SELECT c.ContactName, c.CompanyName, c.City, c.Country, dt.NumOfOrders
FROM Customers c LEFT JOIN 
(SELECT CustomerID, Count(OrderID) AS NumOfOrders
FROM Orders 
GROUP BY CustomerID) dt ON c.CustomerID = dt.CustomerID
ORDER BY dt.NumOfOrders DESC


--Union vs. Union ALL: 
--common features 
--1. both UNION and UNION ALL are used to combine multiple result sets vertically
SELECT City, Country
FROM Customers

SELECT City, Country
FROM Employees

SELECT City, Country
FROM Customers
UNION ALL
SELECT City, Country
FROM Employees
ORDER BY City

--2. criteria
--the num of columns must be the same
SELECT City, Country
FROM Customers
UNION ALL
SELECT City, Country, Region
FROM Employees

--columns types must be identical
SELECT City, Country, ContactName
FROM Customers
UNION ALL
SELECT City, Country, EmployeeID
FROM Employees
--3.alias must be given in the first SELECT statement
SELECT City, Country Cty
FROM Customers
UNION ALL
SELECT City, Country 
FROM Employees
ORDER BY City

--difference
--1. UNION remove all duplicate records, but UNION ALL will not
SELECT City, Country
FROM Customers
UNION
SELECT City, Country
FROM Employees
ORDER BY City
--2. UNION sort the first column ascendingly, but UNION ALL will not
SELECT City, Country
FROM Customers
UNION ALL
SELECT City, Country
FROM Employees
--3. UNION cannot be used in recursive cte, but UNION ALL can


--Window Function
--RANK(): if there is the same rank ,the there will be a gap for the next rank
--rank for product price
SELECT ProductId, ProductName, UnitPrice, RANK() OVER (ORDER BY UnitPrice) AS RNK
FROM Products

SELECT ProductId, ProductName, UnitPrice, RANK() OVER (ORDER BY UnitPrice DESC) AS RNK
FROM Products

--product with the 2nd highest price
SELECT ProductId, ProductName, UnitPrice, RANK() OVER (ORDER BY UnitPrice DESC) AS RNK
FROM Products
WHERE RANK() OVER (ORDER BY UnitPrice DESC) = 2 


SELECT dt.ProductID, dt.ProductName, DT.UnitPrice,DT.RNK
FROM 
(SELECT ProductId, ProductName, UnitPrice, RANK() OVER (ORDER BY UnitPrice DESC) AS RNK
FROM Products) dt
WHERE dt.RNK = 2


--DENSE_RANK(): will not skip any number in rank if there is a tie
SELECT ProductId, ProductName, UnitPrice, RANK() OVER (ORDER BY UnitPrice DESC) AS RNK, DENSE_RANK() OVER(ORDER BY UnitPrice DESC) AS DenseRnk
FROM Products

--ROW_NUMBER(): return the row number of the sorted records starting with 1
SELECT ProductId, ProductName, UnitPrice, RANK() OVER (ORDER BY UnitPrice DESC) AS RNK, DENSE_RANK() OVER(ORDER BY UnitPrice DESC) AS DenseRnk,
ROW_NUMBER() OVER(ORDER BY UnitPrice DESC) AS RowNum
FROM Products

--partition by: used to divde the result set into partitions and perform computation on each subset of partitioned data
--list customers from every country with the ranking for number of orders
SELECT C.ContactName, C.Country, count(o.OrderID) AS NumOfOrders, 
RANK() OVER(PARTITION BY c.Country ORDER BY COUNT(o.OrderId) DESC) AS RNK 
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY C.ContactName, C.Country

--- find top 3 customers from every country with maximum orders
SELECT dt.ContactName, dt.Country, dt.NumOfOrders, DT.RNK
FROM (SELECT C.ContactName, C.Country, count(o.OrderID) AS NumOfOrders, 
RANK() OVER(PARTITION BY c.Country ORDER BY COUNT(o.OrderId) DESC) AS RNK 
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY C.ContactName, C.Country) dt
WHERE dt.RNK <= 3


--cte: common table expression
--derived table
SELECT c.ContactName, c.CompanyName, c.City, c.Country, dt.NumOfOrders
FROM Customers c LEFT JOIN 
(SELECT CustomerID, Count(OrderID) AS NumOfOrders
FROM Orders 
GROUP BY CustomerID) dt ON c.CustomerID = dt.CustomerID
ORDER BY dt.NumOfOrders DESC

WITH OrderCntCTE
AS
(
SELECT CustomerID, COUNT(OrderID) NumOfOrders FROM Orders GROUP BY CustomerID
)
SELECT c.ContactName, c.CompanyName, c.City, C.Country, CTE.NumOfOrders
FROM Customers c LEFT JOIN OrderCntCTE cte ON c.CustomerID = cte.CustomerID
ORDER BY cte.NumOfOrders DESC



--recursive CTE: the cte will call itself again and again until it thinks it can stop and return something
--initialization: initial call to the cte which passes in some values to get things started
--recursive rule

SELECT EmployeeID, FirstName, ReportsTo
FROM Employees

--Level 1: Andrew →  reports to no one
--Level 2: Nancy, Janet, Margaret, Steven, Laura →  reports to Andrew
--Level 3: Michael, Robert, Anne →  reports to Steven.

WITH empHierachyCte
AS
(
SELECT EmployeeID, FirstName, ReportsTo, 1 AS lvl
FROM Employees 
WHERE ReportsTo is null
UNION ALL
SELECT e.EmployeeID, e.FirstName, e.ReportsTo, cte.lvl + 1
FROM Employees e INNER JOIN empHierachyCte cte ON e.ReportsTo = cte.EmployeeID
)
SELECT * FROM empHierachyCte





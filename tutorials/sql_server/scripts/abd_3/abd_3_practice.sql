-- 1. Create a table containing a primary key and a few columns. Look at indexes node of this table in Management Studio. Create a non-clustered index on any column.
CREATE TABLE person
(
	id int PRIMARY KEY,
	name varchar(50),
	surname varchar(50),
	age numeric (2)
);

-- 2. Do exercise 1 again, but this time don't use Management Studio graphical user interface options only SQL statements and sp_helpindex system stored procedure.
CREATE NONCLUSTERED INDEX ncindex_1 on person (name);
execute sp_helpindex person

-- 3. Execute the following script to prepare a table containing many records:
CREATE TABLE test (Id INT IDENTITY, data INT)
GO

DECLARE @a INT
SET @a = 1
WHILE @a < 100000 BEGIN
	INSERT INTO test (data) VALUES (CONVERT(INT,RAND() * 100000))
	SET @a = @a + 1
END
GO

-- 4. Turn on query execution plan option and execute the following query:
SELECT * FROM test WHERE data = 12346;
-- Please observe the plan. You'll see Table scan operation. Write down its costs (CPU and IO). Please write down the summary cost of the entire query (Estimated subtree cost of the most left operation of the plan).
/*
estimated I/O cost 0.166166
estimated CPU cost 0.110077
estimated Subtree cost 0.276244
*/

-- 5. Create a non-clustered index on "data" column. Execute the query again. Compare the plan and the costs. The server should use the index (Index seek operation) and costs should be much lower.
SELECT * FROM test WHERE data = 12346;
/*
estimated I/O cost 0
estimated CPU cost 0.0000068
estimated Subtree cost 0.0075616
*/

-- TO BE EXECUTED ON northwind_db
-- 6. Test covering index strategy. Execute the following query on Northwind database, with the query execution plan enabled. Write down Estimated subtree cost of the last (most left) operation in the plan.
SELECT TerritoryDescription FROM Territories ORDER BY TerritoryDescription
/*
estimated Subtree cost 0.0151753
*/
-- Create the index on "TerritoryDescription" column. Observe the difference in the plan and costs. You'll see, that the plan contains two operations only. The first is Index scan and the second Select. It means, that the server didn't have to read data records, but all required information was found in the index.
CREATE NONCLUSTERED INDEX ncindex_1 on Territories (TerritoryDescription);
execute sp_helpindex Territories
SELECT TerritoryDescription FROM Territories ORDER BY TerritoryDescription
/*
estimated I/O cost 0.003125
estimated CPU cost 0.0002153
estimated Subtree cost 0.0033403
*/

-- 7. Test covering index strategy achieved by Included columns. Drop all indexes but primary key, from "Orders" table. Execute the following query:
SELECT CustomerId, ShipCountry FROM Orders 
WHERE ShipCountry = 'Austria'
-- DROP INDEX Orders.ShipPostalCode;
/*
estimated I/O cost 0.0171991
estimated CPU cost 0.00107
estimated Subtree cost 0.0182691
*/
-- Create a non-clustered index on "ShipCountry" column and use "CustomerId" as Included column. Execute the query again and compare the plan and costs. The result should be similar to exercise 6.
SELECT CustomerId, ShipCountry FROM Orders 
WHERE ShipCountry = 'Austria'
/*
estimated I/O cost 0.003125
estimated CPU cost 0.000201
estimated Subtree cost 0.003326
*/

-- 8. Range query. Drop all indexes from the table created in exercise 3 and execute the following query with execution plan enabled:
execute sp_helpindex test
-- DROP INDEX "NonClusteredIndex-20230312-163929" ON abd_2_db_1.test
SELECT * FROM test WHERE data BETWEEN 10000 and 20000
-- You'll see Table scan operation. Write down the cost. Create a non-clustered index on "data" column. Execute the query again. Probably, the server will not use non-clustered index, because non-clustered indexes are not good for range queries. Drop non-clustered index and create clustered. Execute the query again. Compare the plan and costs.
/*
estimated I/O cost 0.166166
estimated CPU cost 0.110077
estimated Subtree cost 0.276244
*/
CREATE NONCLUSTERED INDEX ncindex_2 ON test(data)
SELECT * FROM test WHERE data BETWEEN 10000 and 20000
-- DROP INDEX ncindex_2 ON abd_2_db_1.test
CREATE CLUSTERED INDEX cindex_1 ON test(data)
SELECT * FROM test WHERE data BETWEEN 10000 and 20000
/*
estimated I/O cost 0.0216435
estimated CPU cost 0.0112644
estimated Subtree cost 0.0329079
*/

-- 9. Sorting query. Drop all indexes from "test" table and execute the following query with execution plan enabled:
SELECT * FROM test ORDER BY data
-- You'll see two expensive operations: Table scan and sorting. Create a non-clustered index on "data" column and execute the query again. There will be no change. Drop the non-clustered index and create a clustered one. Execute the query and compare the plan and cost.
/*
Table scan:
estimated I/O cost 0.189129
estimated CPU cost 0.0183462
Sort:
estimated I/O cost 0.0018769
estimated CPU cost 1.27064

estimated Subtree cost 1.98319
*/
CREATE NONCLUSTERED INDEX ncindex_3 ON test(data)
SELECT * FROM test ORDER BY data
CREATE CLUSTERED INDEX cindex_2 ON test(data)
SELECT * FROM test ORDER BY data
/*
estimated I/O cost 0.189051
estimated CPU cost 0.0110156
estimated Subtree cost 0.299207
*/

-- 10. Turn off query execution plan and turn on the following options:
SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT * FROM test ORDER BY data
-- Execute one of the queries from previous points. Observe the results (Messages tab). Can you interpret the results? Will the results be the same after the next execution of the same query?
/*
logical reads 254, physical reads 1, read-ahead reads 336
*/
SELECT * FROM test ORDER BY data
/*
logical reads 254, physical reads 0, read-ahead reads 0
*/

-- 11. Create (using Management Studio or SQL) a composite index on 2 or more columns. Write and test a query containing both columns in WHERE clause with AND operator.
-- ???
SELECT OrderDate, ShipAddress
FROM Orders
WHERE ShipAddress='12, rue des Bouchers' OR OrderDate BETWEEN '1996-07-04 00:00:00.000' AND '1996-07-31 00:00:00.000';
/*
estimated I/O cost 0.0171991
estimated CPU cost 0.00107
estimated Subtree cost 0.0182691
*/
CREATE INDEX comp_index_1 ON Orders(OrderDate, ShipAddress)
/*
estimated I/O cost 0.0075694
estimated CPU cost 0.00107
estimated Subtree cost 0.0086394
*/

--12. Indexes maintenance:
-- Make sure you have created a non-clustered index on "data" column of "test" table.
CREATE NONCLUSTERED INDEX non_cl_index_1 ON test(data)
-- See properties of the index (Fragmentation tab). The most important values are: Total fragmentation and Page fullness. Observe also the number of B+tree levels (Depth parameter) and the number of disk pages used by the index. Write down the results.
/*
Total fragmentation: 13.60 %
Page fullness: 97.51 %
Depth: 2
Pages: 228
*/
-- Insert many records to the table using script from exercise 3. Execute some DELETE statements, deleting many records (f. ex. using BETWEEN).
DECLARE @a INT
SET @a = 1
WHILE @a < 100000 BEGIN
	INSERT INTO test (data) VALUES (CONVERT(INT,RAND() * 10000))
	SET @a = @a + 1
END
GO
select * from test

DELETE FROM test where data BETWEEN 12345 AND 15432
-- See the fragmentation and other parameters again. Observe the difference.
/*
Total fragmentation: 51.06 %
Page fullness: 97.88 %
Depth: 3
Pages: 425
*/
-- Use Rebuild option. Observe the difference.
/*
Total fragmentation: 0.00 %
Page fullness: 99.57 %
Depth: 2
Pages: 218
*/

-- 13. Write a complex query (containing f. ex.: WHERE, GROUP BY, HAVING, ORDER BY, UNION). Observe, that the query execution plan may be really complex.
SELECT CompanyName, ContactName, PostalCode
FROM Customers
WHERE CompanyName LIKE 'A%'
GROUP BY CompanyName, ContactName, PostalCode
HAVING ContactName LIKE 'A%'
ORDER BY PostalCode;
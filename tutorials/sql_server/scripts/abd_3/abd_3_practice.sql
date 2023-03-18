-- 1. Create a database. Open a new connection to the database using Management Studio. Execute following SQL statements one by one:
SET IMPLICIT_TRANSACTIONS ON
CREATE TABLE person (Id INT, name VARCHAR(50))
COMMIT
INSERT INTO person VALUES (1, 'Lenkiewicz')
INSERT INTO person VALUES (2, 'Kowalski')
SELECT * FROM person	-- you’ll see 2 people
ROLLBACK
SELECT * FROM person	-- you’ll see empty table
INSERT INTO person VALUES (3, 'Iksiñski')
COMMIT
SELECT * FROM person	-- you’ll see one person

-- 2. Do the exercise 1 once again, but this time turn off the option:
SET IMPLICIT_TRANSACTIONS OFF

-- Before the next exercise set this option to on.
-- During execution of COMMIT and ROLLBACK statements you’ll see errors informing, that the transaction can’t be committed or rolled back. It’s ok, because with IMPLICIT_TRANSACTIONS set to off, every transaction is committed automatically. Do the next exercises with the option set to ON.

-- 3. Open another window or tab in Management Studio. Execute:
SET IMPLICIT_TRANSACTIONS ON
SELECT * FROM person

-- In window 1 run:

INSERT INTO person VALUES (2, 'Kowalski')

-- In window 2 try to run again:

SELECT * FROM person

-- The query will wait for releasing a lock. In window 1 execute:

COMMIT

-- Check, if the query in window 2 is finished.
-- ATTENTION: In this and next exercises which are performed with IMPLICIT_TRANSACTIONS set to ON there may occur problems due to previous, uncommitted transactions. So, before every exercise execute COMMIT in each window.

-- 4. In window 1 delete all records:
DELETE FROM person
COMMIT

-- Insert 2 records and do the SAVEPOINT named “x”:

INSERT INTO person VALUES (1, 'Lenkiewicz')
INSERT INTO person VALUES (2, 'Kowalski')
SAVE TRAN x
INSERT INTO person VALUES (3, 'Iksiñski')
SELECT * FROM person	-- you’ll see 3 people
ROLLBACK TRAN x			-- rolling back to savepoint “x”
SELECT * FROM person	-- you’ll see 2 people
ROLLBACK TRAN
SELECT * FROM person	-- you’ll see empty table

-- 5. In the second Management Studio window set the lowest isolation level:

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- Perform the exercise 3 (or similar). In the first window enter any changes, in the second window check if you’ll see the uncommitted data.
-- ATTENTION: Setting isolation level will not affect the current, running transaction. Therefore it’s a good idea to perform COMMIT or ROLLBACK after SET TRANSACTION ISOLATION LEVEL instruction.

-- 6. Return to READ COMMITTED isolation level. Execute some DML statements on two windows (f.ex. INSERT, DELETE) viewing locks in Activity Monitor tool.

-- 7. For this exercise you’ll need a database with a bigger number of records. Switch to Northwind database in both windows. IMPLICIT_TRANSACTIONS option should be set to ON. See Order details table. Execute in window 1:

DELETE FROM [Order details] WHERE OrderId=10248 AND ProductId=11

-- and in window 2:

DELETE FROM [Order details] WHERE OrderId=11077 AND ProductId=77

-- Notice that both queries have been executed in parallel, because server locked only some rows, not the entire table. But the following query:

SELECT * FROM [Order details]

-- will not be executed until COMMIT in the second window because it requires access to entire table.

-- 8. Return to your database in both windows. Check if there is a table “person” and if it contains records. If not, create it using script from exercise 1. Do not forget to execute COMMIT afterwards. Then set SERIALIZABLE isolation level in both windows.

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Execute in both windows:

SELECT * FROM person

-- Next, execute any INSERT statement in window 1:

INSERT INTO person VALUES (3, 'Iksiñski')

-- Notice that this time SELECT statement locked the entire table “person” and we can’t INSERT a  new row until COMMIT in window 2. In case of READ COMMITTED isolation level INSERT would run immediately (phantom).

-- 9. Return to READ COMMITTED isolation level in both windows. Execute any SELECT statement using locking hint e.g. to set exclusive lock on entire table:

SELECT * FROM person WITH (TABLOCKX)

-- Check if you can execute any SQL statement on that table in the second window. You can also see acquired locks in Activity Monitor tool.

-- 10. To prepare the table for exercise, run:

DELETE FROM person
INSERT INTO person VALUES (1, 'Lenkiewicz')
INSERT INTO person VALUES (2, 'Kowalski')
INSERT INTO person VALUES (3, 'Iksinski')
COMMIT

-- Next, enable your database to use SNAPSHOT isolation level:

ALTER DATABASE abd_3 SET allow_snapshot_isolation ON

-- Set this isolation level:

SET TRANSACTION ISOLATION LEVEL SNAPSHOT
SET IMPLICIT_TRANSACTIONS ON

-- And select all records:

SELECT * FROM person

-- In window 2 execute:

UPDATE person SET name = 'Nowak' WHERE Id = 2
COMMIT

-- In window 1:

SELECT * FROM person

-- You’ll see the old values because transaction works with the snapshot.
-- Try to update the same record:

UPDATE person SET name = 'Iksinski' WHERE Id = 2

-- You’ll see the error: „Snapshot isolation transaction aborted due to update conflict...”.

-- 11. Try to evoke a deadlock.
UPDATE person SET name = 'Iksinski' WHERE Id = 2
COMMIT
-- 1. Create a database. Open a new connection to the database using Management Studio. Execute following SQL statements one by one:
SET IMPLICIT_TRANSACTIONS ON
CREATE TABLE person (Id INT, name VARCHAR(50))
COMMIT
INSERT INTO person VALUES (1, 'Lenkiewicz')
INSERT INTO person VALUES (2, 'Kowalski')
SELECT * FROM person   -- you’ll see 2 persons 
ROLLBACK
SELECT * FROM person   -- you’ll see empty table
INSERT INTO person VALUES (3, 'Iksiñski')
COMMIT
SELECT * FROM person   -- you’ll see one person

-- 2. Do the exercise 1 once again, but this time turn off the option:
SET IMPLICIT_TRANSACTIONS OFF

/*
	Before the next exercise set this option to on.
	During execution of COMMIT and ROLLBACK statements you’ll see errors informing, that the transaction can’t be committed or rolled back. It’s ok, because with IMPLICIT_TRANSACTIONS set to off, every transaction is committed automatically. Do the next exercises with the option set to ON.
*/

-- 1. Create SQL Server Authentication login and database user in your database. Try to log in as this user to Management Studio and connect to your database. Check if you can perform any SQL statement.
-- [prod. ChatGPT w/ my modifications]
-- Create a SQL Server Authentication login
CREATE LOGIN user_1 WITH PASSWORD = 'pass';

-- Create a database user for the login
USE abd_4;
CREATE USER user_1 FOR LOGIN user_1;

-- Grant appropriate permissions to the user
ALTER ROLE [db_datareader] ADD MEMBER user_1;
ALTER ROLE [db_datawriter] ADD MEMBER user_1;

-- drop login user_1
-- drop user user_1


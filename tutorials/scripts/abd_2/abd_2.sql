--	tasks from ABD tutorials_1
-- 4. Try to use sp_ system stored procedures described in the lecture.
execute sp_helpdb master;

-- 6. Create database (pay attention to location of data and transaction log files and other settings)
CREATE DATABASE db_1 ON (
NAME = db_1, 
FILENAME = 'D:\PJATK\sem6\ABD\tutorials\databases\database_1\files\db_1.mdf',
SIZE = 2MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)
LOG ON (
NAME = 'db_1_log',
FILENAME = 'D:\PJATK\sem6\ABD\tutorials\databases\database_1\logs\db_1_log.ldf',
SIZE = 2MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)

-- Additionally, create a table in the new database
CREATE TABLE person_1 (
    personID int,
    firstName varchar(255),
    lastName varchar(255),
    email varchar(255)
);

-- 8. using sp_ system stored procedures see properties of your database.
execute sp_helpdb db_1;

-- 9. Try to use full and short object name in any SELECT statement.
SELECT * FROM SYS.assembly_files;
SELECT * FROM SYS.databases;

-- 10. Create a second database using SQL statement.
CREATE DATABASE db_2 ON (
NAME = db_2, 
FILENAME = 'D:\PJATK\sem6\ABD\tutorials\databases\database_2\files\db_2.mdf',
SIZE = 4MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)
LOG ON (
NAME = 'db_2_log',
FILENAME = 'D:\PJATK\sem6\ABD\tutorials\databases\database_2\logs\db_2_log.ldf',
SIZE = 2MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)

-- 11. Add a secondary data file (.ndf) to your database. The file should be stored in a different folder than the main (.mdf) file. 
ALTER DATABASE db_1   
ADD FILE 
(  
    NAME = db_1_2,  
    FILENAME = 'D:\PJATK\sem6\ABD\tutorials\databases\database_1\tmp_files\db_1_2.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5%  
);
GO

-- 12. Add a filegroup to your database. Add a file to this new filegroup. Move a table to the new filegroup.
ALTER DATABASE db_1  
ADD FILEGROUP file_group_1;
GO
ALTER DATABASE db_1   
ADD FILE 
(  
    NAME = db_1_2,  
    FILENAME = 'D:\PJATK\sem6\ABD\tutorials\databases\database_1\tmp_files\db_1_2.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5%  
);
GO

-- HOW TO MOVE A TABLE TO A NEW FILE GROUP USING SQL?

-- 13. Change the default filegroup. Create a table. Check in which filegroup the table was created.

ALTER DATABASE db_1 MODIFY FILEGROUP file_group_1 DEFAULT
GO

CREATE TABLE person_2 (
    personID int,
    firstName varchar(255),
    lastName varchar(255),
    email varchar(255)
);

-- 14. Try to use „shrink database” option (using Management Studio or DBCC command).
DBCC SHRINKDATABASE (db_2, 10);
GO

-- ADDITIONAL SCRIPTS

CREATE DATABASE abd_2;

CREATE DATABASE abd_3 ON (
NAME = abd_3, 
FILENAME = 'D:\PJATK\sem6\ABD\tutorials\databases\database_abd_3\files\abd_3.mdf',
SIZE = 2MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)
LOG ON (
NAME = 'abd_3_log',
FILENAME = 'D:\PJATK\sem6\ABD\tutorials\databases\database_abd_3\logs\abd_3_log.ldf',
SIZE = 2MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)

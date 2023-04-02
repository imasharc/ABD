-- 1. Check the current state of an SQL db
SELECT name, state_desc from sys.databases 
GO

-- 2. Change the file locations with an ALTER DATABASE command:
ALTER DATABASE abd_3 MODIFY FILE (name='abd_3',filename='D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_3\files\abd_3.mdf');
ALTER DATABASE abd_3 MODIFY FILE (name='abd_3_log',filename='D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_3\logs\abd_3_log.ldf');

-- Set the database offline (use WITH ROLLBACK IMMEDIATE to kick everyone out and rollback all currently open transactions)
ALTER DATABASE abd_3 SET OFFLINE WITH ROLLBACK IMMEDIATE;

-- Bring the database back online
ALTER DATABASE abd_3 SET ONLINE;

/*
SOURCES:
1. https://www.stellarinfo.com/blog/fix-sql-database-recovery-pending-state-issue/
2. https://dba.stackexchange.com/a/52010
*/
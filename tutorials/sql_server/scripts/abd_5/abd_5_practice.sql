-- NOT MANDATORY
-- THERE IS SOME BUG - TO BE FIXED LATER
DECLARE @path VARCHAR(100) = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\backup\abd_5_backup.bak'
GO
PRINT @path

-- EXERCISES
-- 1. Perform full database backup. Drop the database and restore it using created backup file.
BACKUP DATABASE abd_5 
TO DISK = @path

/*
Processed 512 pages for database 'abd_5', file 'abd_5' on file 1.
Processed 2 pages for database 'abd_5', file 'abd_5_log' on file 1.
BACKUP DATABASE successfully processed 514 pages in 2.364 seconds (1.697 MB/sec).
*/

-- Drop the database
USE master
DROP DATABASE abd_5

-- restore it using created backup file
RESTORE DATABASE abd_5
FROM DISK = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\backup\abd_5_backup.bak'

/*
Processed 512 pages for database 'abd_5', file 'abd_5' on file 1.
Processed 2 pages for database 'abd_5', file 'abd_5_log' on file 1.
RESTORE DATABASE successfully processed 514 pages in 0.812 seconds (4.940 MB/sec).
*/

-- 2. Restore the database from backup created in exercise 1, but under different name.
--	After the exercise you should have two identical databases with different names.
RESTORE DATABASE abd_5_db_2 FROM DISK = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\backup\abd_5_backup.bak'
WITH REPLACE, RECOVERY,
MOVE 'abd_5' TO 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5_db_2\files\abd_5_db_2.mdf',
MOVE 'abd_5_log' TO 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5_db_2\logs\abd_5_db_2_log.ldf'

-- 3. Do the exercise 1 again, but this time don’t use graphical user interface. Use proper SQL statements.
-- DONE

-- 4. Perform full database backup. Then enter any changes to your database and perform differential backup.
-- Enter another change and perform transactional log backup. Drop the database and restore it from three created backups.
-- Check if all changes are restored.
USE master
BACKUP DATABASE abd_5 
TO DISK = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\backup\abd_5_backup.bak'

-- Then enter any changes to your database and perform differential backup
USE abd_5
CREATE TABLE table_2
(
	id NUMERIC(5) NOT NULL,
	username varchar(20)
)

INSERT INTO table_2 (id, username)
VALUES (1, 'John'), (2, 'Karl'), (3, 'Sandy')

USE master
BACKUP DATABASE abd_5 
TO DISK = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\backup\abd_5_diff_backup.bak'
WITH DIFFERENTIAL

-- Enter another change and perform transactional log backup
USE abd_5
INSERT INTO table_2 (id, username)
VALUES (4, 'Patrick'), (5, 'Gary')

USE master
BACKUP LOG abd_5
TO DISK = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\backup\abd_5_trans_log_backup.trn'

-- Drop the database and restore it from three created backups
USE master
DROP DATABASE abd_5

-- 1) full restore
USE master
RESTORE DATABASE abd_5
FROM DISK = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\backup\abd_5_backup.bak'
WITH NORECOVERY

/*
Processed 512 pages for database 'database_name', file 'abd_5' on file 1.
Processed 2 pages for database 'database_name', file 'abd_5_log' on file 1.
RESTORE DATABASE successfully processed 514 pages in 0.774 seconds (5.183 MB/sec).
*/

USE master
DROP DATABASE abd_5

-- 2) differential restore
USE master
CREATE DATABASE abd_5

USE master
RESTORE DATABASE abd_5
FROM DISK = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\backup\abd_5_diff_backup.bak'
WITH NORECOVERY

/*
This differential backup cannot be restored because the database has not been restored to the correct earlier state.
Msg 3013, Level 16, State 1, Line 97
RESTORE DATABASE is terminating abnormally.
*/

/*
The backup set holds a backup of a database other than the existing 'abd_5' database.
Msg 3013, Level 16, State 1, Line 98
RESTORE DATABASE is terminating abnormally.
*/



-- 3) transactional log restore
USE master
RESTORE DATABASE abd_5
FROM DISK = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\backup\abd_5_trans_log_backup.trn'
WITH RECOVERY

/*
The backup set holds a backup of a database other than the existing 'abd_5' database.
Msg 3013, Level 16, State 1, Line 118
RESTORE DATABASE is terminating abnormally.
*/

USE abd_5
SELECT * FROM table_2

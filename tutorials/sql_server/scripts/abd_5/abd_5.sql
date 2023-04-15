CREATE DATABASE abd_5 ON (
NAME = abd_5, 
FILENAME = 'C:\ABD\abd_5\files\abd_5.mdf',
SIZE = 2MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)
LOG ON (
NAME = 'abd_5_log',
FILENAME = 'C:\ABD\abd_5\logs\abd_5.ldf',
SIZE = 2MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)

-- EXERCISES
-- 1. Perform full database backup. Drop the database and restore it using created backup file.
USE master
BACKUP DATABASE abd_5 
TO DISK = 'C:\ABD\abd_5\backup\abd_5_backup.bak'

/*
Processed 512 pages for database 'abd_5', file 'abd_5' on file 1.
Processed 2 pages for database 'abd_5', file 'abd_5_log' on file 1.
BACKUP DATABASE successfully processed 514 pages in 2.364 seconds (1.697 MB/sec).
*/

-- Drop the database
USE master
DROP DATABASE abd_5

-- restore it using created backup file
USE master
RESTORE DATABASE abd_5
FROM DISK = 'C:\ABD\abd_5\backup\abd_5_backup.bak'

/*
Processed 512 pages for database 'abd_5', file 'abd_5' on file 1.
Processed 2 pages for database 'abd_5', file 'abd_5_log' on file 1.
RESTORE DATABASE successfully processed 514 pages in 0.812 seconds (4.940 MB/sec).
*/

-- 2. Restore the database from backup created in exercise 1, but under different name.
--	After the exercise you should have two identical databases with different names.
RESTORE DATABASE abd_5_db_2 FROM DISK = 'C:\ABD\abd_5\backup\abd_5_backup.bak'
WITH REPLACE, RECOVERY,
MOVE 'abd_5' TO 'C:\ABD\abd_5_db_2\files\abd_5_db_2.mdf',
MOVE 'abd_5_log' TO 'C:\ABD\abd_5_db_2\logs\abd_5_db_2_log.ldf'

-- 3. Do the exercise 1 again, but this time don�t use graphical user interface. Use proper SQL statements.
-- DONE

-- 4. Perform full database backup. Then enter any changes to your database and perform differential backup.
-- Enter another change and perform transactional log backup. Drop the database and restore it from three created backups.
-- Check if all changes are restored.
USE master
BACKUP DATABASE abd_5 
TO DISK = 'C:\ABD\abd_5\backup\abd_5_backup.bak'

-- Then enter any changes to your database and perform differential backup
USE abd_5
CREATE TABLE table_2
(
	id NUMERIC(5) NOT NULL,
	username varchar(20)
)

USE abd_5
DROP TABLE table_2

USE abd_5
SELECT * FROM table_2

INSERT INTO table_2 (id, username)
VALUES (1, 'John'), (2, 'Karl'), (3, 'Sandy')

USE master
BACKUP DATABASE abd_5 
TO DISK = 'C:\ABD\abd_5\backup\abd_5_diff_backup.bak'
WITH DIFFERENTIAL

-- Enter another change and perform transactional log backup
USE abd_5
INSERT INTO table_2 (id, username)
VALUES (4, 'Patrick'), (5, 'Gary')

USE abd_5
BACKUP LOG abd_5
TO DISK = 'C:\ABD\abd_5\backup\abd_5_trans_log_backup.trn'

-- Drop the database and restore it from three created backups
USE master
DROP DATABASE abd_5

-- 1) full restore
USE master
RESTORE DATABASE abd_5
FROM DISK = 'C:\ABD\abd_5\backup\abd_5_backup.bak'
WITH NORECOVERY

USE master
DROP DATABASE abd_5

-- 2) differential restore
USE master
RESTORE DATABASE abd_5
FROM DISK = 'C:\ABD\abd_5\backup\abd_5_diff_backup.bak'
WITH NORECOVERY

-- 3) transactional log restore
USE master
RESTORE DATABASE abd_5
FROM DISK = 'C:\ABD\abd_5\backup\abd_5_trans_log_backup.trn'
WITH RECOVERY

USE abd_5
SELECT * FROM table_3

-- 6.
USE abd_5
BACKUP DATABASE abd_5 
TO DISK = 'C:\ABD\abd_5\backup\abd_5_backup_2.bak'

USE abd_5
CREATE TABLE table_1
(
	id NUMERIC(5) NOT NULL,
	firstName varchar(20)
)

-- 7.
USE abd_5
BACKUP LOG abd_5
TO DISK = 'C:\ABD\abd_5\backup\abd_5_trans_log_backup_2.trn'

-- 8.
USE abd_5
BACKUP DATABASE abd_5 
TO DISK = 'C:\ABD\abd_5\backup\abd_5_backup_3.bak'

USE abd_5
CREATE TABLE table_4
(
	id NUMERIC(5) NOT NULL,
	firstName varchar(20)
)

USE abd_5
BACKUP LOG abd_5
TO DISK = 'C:\ABD\abd_5\backup\abd_5_trans_log_backup_3.trn'

-- 9.
USE zad5
SELECT * FROM zad5

USE master
DROP DATABASE zad5

USE master
RESTORE DATABASE zad5
FROM DISK = 'C:\ABD\zad_5\zad5a_file1.bak'
WITH NORECOVERY

USE master
RESTORE DATABASE zad5
FROM DISK = 'C:\ABD\zad_5\zad5a_file2.bak'
WITH NORECOVERY

USE master
RESTORE DATABASE zad5
FROM DISK = 'C:\ABD\zad_5\zad5a_file3.bak'
WITH RECOVERY

RESTORE HEADERONLY FROM DISK = 'C:\ABD\zad_5\zad5a_file1.bak'
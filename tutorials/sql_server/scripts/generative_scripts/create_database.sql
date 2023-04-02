CREATE DATABASE abd_5 ON (
NAME = abd_5, 
FILENAME = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\files\abd_5.mdf',
SIZE = 2MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)
LOG ON (
NAME = 'abd_5_log',
FILENAME = 'D:\PJATK\sem6\ABD\tutorials\sql_server\databases\abd_5\logs\abd_5.ldf',
SIZE = 2MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)
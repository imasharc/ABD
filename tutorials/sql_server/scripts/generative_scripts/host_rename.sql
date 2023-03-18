-- For renaming a computer that hosts a stand-alone instance of SQL Server
EXEC sp_dropserver '<old_name>';
GO
EXEC sp_addserver '<new_name>', local;
GO

-- For verifying rename operation
select @@SERVERNAME AS 'Server Name';
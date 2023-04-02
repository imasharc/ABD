DROP TABLE IF EXISTS dbo.table_1;

CREATE TABLE dbo.table_1 (
	id int PRIMARY KEY,
	number int,
	-- name nvarchar(10)
);


IF OBJECT_ID ('dbo.add_rows', 'P') IS NOT NULL
	DROP PROCEDURE dbo.add_rows;
GO

CREATE PROCEDURE dbo.add_rows 
	@rowsNumber int
AS
BEGIN
	SET NOCOUNT ON

	-- start point for adding rows
	DECLARE @id INT = ISNULL((SELECT MAX(id) FROM dbo.table_1)+1, 1)
	DECLARE @iteration INT = 0
	WHILE @iteration < @rowsNumber
		BEGIN

			--get a random int from 0 to 100
			DECLARE @number INT = CAST(RAND()*10000 AS INT)

			/**
			-- generate random nvarchar
			-- get a random nvarchar ascii char 65 to 128
			DECLARE @name NVARCHAR(10) = N'' --empty string for start
			DECLARE @length INT = CAST(RAND() * 10 AS INT) --random length of nvarchar
			WHILE @length <> 0 --in loop we will randomize chars till the last one
				BEGIN
					SELECT @name = @name + CHAR(CAST(RAND() * 63 + 65 as INT))
					SET @length = @length - 1 --next iteration
				END
			**/

			--insert data
			INSERT INTO dbo.table_1 (id, number)
			VALUES (@id, @number)
			SET @iteration += 1
			SET @id += 1
		END
	SET NOCOUNT OFF
END

EXEC dbo.add_rows 10000 -- elapsed time 00:00:49
-- EXEC dbo.add_rows 10000 -- elapsed time 00:06:33
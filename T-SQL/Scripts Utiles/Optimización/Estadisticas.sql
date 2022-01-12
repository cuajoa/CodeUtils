SET NOCOUNT ON;

DECLARE @objectname nvarchar(130); 
DECLARE @command nvarchar(4000); 

DECLARE partitions CURSOR FOR
SELECT  TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_NAME
OPEN partitions;
FETCH NEXT FROM partitions
INTO  @objectname 


WHILE @@FETCH_STATUS <> -1
BEGIN
     SET @command = 'UPDATE STATISTICS ' + @objectname 
	 --SET @command = 'UPDATE STATISTICS VTOSINSTRCTASCTECMT'
     PRINT N'Executed: ' + @command;
	 EXEC (@command)
    FETCH NEXT FROM partitions
    INTO @objectname
END

CLOSE partitions;
DEALLOCATE partitions;


GO

--UPDATE STATISTICS VTOSINSTRCTASCTECMT
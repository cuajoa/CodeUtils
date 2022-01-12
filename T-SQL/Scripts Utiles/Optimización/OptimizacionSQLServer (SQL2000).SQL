DBCC CHECKDB
go

DECLARE @tablename varchar(30)
DECLARE @tablename_header varchar(75)
DECLARE @ID Int
DECLARE @propietarioname varchar(30)

DECLARE tnames_cursor CURSOR FOR 
	SELECT sysusers.name, sysobjects.name, sysobjects.id FROM sysobjects inner join sysusers on sysobjects.uid = sysusers.uid
	WHERE type = 'U'
OPEN tnames_cursor

FETCH NEXT FROM tnames_cursor INTO @propietarioname, @tablename, @ID

WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SELECT @tablename_header = 'Updating [' + @propietarioname + '].' + RTRIM(@tablename)
		PRINT @tablename_header
		EXEC ('DBCC CHECKTABLE (''[' + @propietarioname + '].' + @tablename + ''') ' )

		IF EXISTS (select * from syscolumns where id =@ID and colstat & 1 = 1) 
    		EXEC ('DBCC CHECKIDENT (''[' + @propietarioname + '].' + @tablename + ''') ' )

   		EXEC ('DBCC DBREINDEX (''[' + @propietarioname + '].' + @tablename + ''', '''', 90, SORTED_DATA_REORG) ' )
		EXEC ('UPDATE STATISTICS [' + @propietarioname + '].' + @tablename + ' WITH FULLSCAN ')
	END
	FETCH NEXT FROM tnames_cursor INTO @propietarioname, @tablename, @ID
END
PRINT ' '
PRINT ' '
SELECT @tablename_header = '*************  NO MORE TABLES'
	
PRINT @tablename_header
PRINT ' '
PRINT 'Statistics have been updated for all tables.'
DEALLOCATE tnames_cursor

GO   

dbcc checkalloc
DBCC SQLPERF (IOSTATS, CLEAR)
DBCC SQLPERF (NETSTATS, CLEAR)
DBCC SQLPERF (LRUSTATS, CLEAR)
DBCC SQLPERF (RASTATS, CLEAR)
DBCC SQLPERF (THREADS)
DBCC SQLPERF (LOGSPACE)

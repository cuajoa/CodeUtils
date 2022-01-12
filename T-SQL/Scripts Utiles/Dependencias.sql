----------------------------------------------------------

DECLARE @name varchar(250)

set @name = 'dbo.CTASCORRIENTESCMT'
 
DECLARE @LEVEL int
DECLARE @COUNTAnt int
DECLARE @COUNT int
DECLARE @NAMEITEM varchar(250)
set @LEVEL = 0
set @COUNTAnt = 0
set @COUNT = 0
 
SELECT referencing_schema_name, referencing_entity_name,
referencing_id, referencing_class_desc, is_caller_dependent, @LEVEL as 'level'
INTO #DEPENCENDE
FROM sys.dm_sql_referencing_entities (@name, 'OBJECT');
 
SET @COUNTAnt = @COUNT
SELECT @COUNT = COUNT(*) FROM #DEPENCENDE
 
WHILE (@COUNTAnt <> @COUNT)
    BEGIN
 
        DECLARE DEPENDS CURSOR
            FOR
            SELECT referencing_entity_name FROM #DEPENCENDE WHERE level = @LEVEL
 
        OPEN DEPENDS
        FETCH NEXT FROM DEPENDS into @NAMEITEM
        WHILE (@@FETCH_STATUS = 0)
            BEGIN
                INSERT INTO #DEPENCENDE
                SELECT DEP.referencing_schema_name, DEP.referencing_entity_name, DEP.referencing_id, DEP.referencing_class_desc, DEP.is_caller_dependent, @LEVEL +1
                FROM sys.dm_sql_referencing_entities ('dbo.' +@NAMEITEM, 'OBJECT') DEP
                LEFT JOIN #DEPENCENDE DT ON DEP.referencing_entity_name = DT.referencing_entity_name
                WHERE DT.referencing_entity_name IS NULL
                FETCH NEXT FROM DEPENDS into @NAMEITEM
            END
 
        CLOSE DEPENDS
        DEALLOCATE DEPENDS
 
        SET @LEVEL = @LEVEL + 1
        SET @COUNTAnt = @COUNT
        SELECT @COUNT = COUNT(*) FROM #DEPENCENDE
 
    END
 
SELECT referencing_entity_name, level FROM #DEPENCENDE
ORDER BY level

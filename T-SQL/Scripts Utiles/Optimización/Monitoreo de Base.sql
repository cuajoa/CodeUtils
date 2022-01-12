
SELECT si.NAME
 ,si.index_id
 ,index_level
 ,index_type_desc
 ,avg_fragmentation_in_percent
 ,avg_page_space_used_in_percent
 ,fragment_count
 ,page_count
 ,record_count
 ,'Fragmentacion de indices'

FROM sys.dm_db_index_physical_stats(db_id('etsconsultatio-performance'), NULL, NULL, NULL, NULL) v
INNER JOIN sys.indexes si ON v.object_id = si.object_id
 AND v.index_id = si.index_id
 WHERE avg_fragmentation_in_percent <> 0
 ORDER BY avg_fragmentation_in_percent DESC
GO




--Consulta DMV que nos indica cuantas lecturas y como se realizan (seek, scan y read) de los indices de las tablas; así mismo también las escrituras. 
--Permite detectar indices que se uso no es correcto, ineficiente o simplemente no se usan. Permite ver que indices producen overhead de cara eliminarlos ;-).

SELECT  OBJECT_NAME(ddius.[object_id], ddius.database_id) AS [object_name] ,        
        ddius.index_id ,
    i.[name] AS [index_name],
        ddius.user_seeks ,
        ddius.user_scans ,
        ddius.user_lookups ,
        ddius.user_seeks + ddius.user_scans + ddius.user_lookups 
                                                     AS user_reads ,
        ddius.user_updates AS user_writes ,
        ddius.last_user_scan ,
        ddius.last_user_update,
		'Uso de Indices'
FROM    sys.dm_db_index_usage_stats ddius
 INNER JOIN sys.indexes i ON ddius.[object_id] = i.[object_id]
                                     AND i.[index_id] = ddius.[index_id]
WHERE   ddius.database_id > 4 -- filter out system tables
        AND OBJECTPROPERTY(ddius.OBJECT_ID, 'IsUserTable') = 1
        AND ddius.index_id > 0  -- filter out heaps      
ORDER BY ddius.user_scans 





--espacio y crecimiento
DBCC SQLPERF(LOGSPACE);  
GO  



SELECT
    stat.name,
    last_updated, 
    rows, 
    rows_sampled,
    CASE AUTO_CREATED
        WHEN 0
        THEN 'Index Statistics'
        WHEN 1
        THEN 'Auto Created Statistics'
    END AS 'Auto Created Statistics',
    --    AUTO_CREATED AS 'Auto Created Statistisc', 
    USER_CREATED AS 'User Created Statistics',
    c.name ColumnName,
	OBJECT_NAME(stat.object_id),
	'Estadisticas'
FROM sys.stats AS stat
  CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
  INNER JOIN sys.stats_columns sc ON stat.object_id = sc.object_id
                                     AND stat.stats_id = sc.stats_id
  INNER JOIN sys.columns c ON sc.object_id = c.object_id
                              AND sc.column_id = c.column_id
WHERE stat.object_id = OBJECT_ID('LIQUIDACIONES')
ORDER BY AUTO_CREATED DESC;



SELECT TOP (50)
    q.text, s.total_elapsed_time, s.max_elapsed_time, s.min_elapsed_time,
    s.last_elapsed_time, s.execution_count, last_execution_time, 'Ultimas 50 Select más costosas ejecutadas'
FROM sys.dm_exec_query_stats as s
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS q
WHERE s.last_execution_time > DateAdd(mi , -1500 , GetDate()) -- solo las recientementes
AND text not like '%sys.%' -- eliminar consulta sys
ORDER BY s.total_elapsed_time DESC



SELECT TOP 100
  qs.total_elapsed_time / qs.execution_count / 1000000.0 AS average_seconds,
  qs.total_elapsed_time / 1000000.0 AS total_seconds,
  qs.execution_count,
  SUBSTRING ( qt.text,qs.statement_start_offset/2,
  ((CASE WHEN qs.statement_end_offset = -1
  THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
  ELSE qs.statement_end_offset
  END ) - qs.statement_start_offset) / 2 ) AS individual_query,
  o.name AS object_name,
  DB_NAME(qt.dbid) AS database_name,'Las 100 Select ejecutadas que consumen más tiempo en segundos'
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
LEFT OUTER JOIN sys.objects o ON qt.objectid = o.object_id
WHERE qt.dbid = DB_ID()
ORDER BY average_seconds DESC;



SELECT TOP 25
  (total_logical_reads+total_logical_writes) / qs.execution_count AS average_IO,
  (total_logical_reads+total_logical_writes) AS total_IO,
   qs.execution_count AS execution_count,
   SUBSTRING (qt.text,qs.statement_start_offset/2,
   ((CASE WHEN qs.statement_end_offset = -1
   THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
   ELSE qs.statement_end_offset END) - qs.statement_start_offset)/2) AS indivudual_query,
   o.name AS object_name,
   DB_NAME(qt.dbid) AS database_name,'Las 25 Select ejecutadas que consumen más IO (logical reads/writes)'
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
LEFT OUTER JOIN sys.objects o ON qt.objectid = o.object_id
WHERE qt.dbid = DB_ID()
ORDER BY average_IO DESC;



SELECT TOP(25) p.name AS [SP Name],qs.total_physical_reads AS [TotalPhysicalReads],
qs.total_physical_reads/qs.execution_count AS [AvgPhysicalReads], qs.execution_count,
qs.total_logical_reads,qs.total_elapsed_time, qs.total_elapsed_time/qs.execution_count
AS [avg_elapsed_time], qs.cached_time,'Los 25 StoredProcs que consumen más IO (total_physical_reads)'
FROM sys.procedures AS p WITH (NOLOCK)
INNER JOIN sys.dm_exec_procedure_stats AS qs WITH (NOLOCK)
ON p.[object_id] = qs.[object_id]
WHERE qs.database_id = DB_ID()
AND qs.total_physical_reads > 0
ORDER BY qs.total_physical_reads DESC, qs.total_logical_reads DESC OPTION (RECOMPILE);

----Con esto veremos el uso de los indices en nuestra BBDD

--SELECT OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], I.[NAME] AS [INDEX NAME], USER_SEEKS, USER_SCANS, USER_LOOKUPS, USER_UPDATES
--FROM SYS.DM_DB_INDEX_USAGE_STATS AS S 
--INNER JOIN SYS.INDEXES AS I 
--ON I.[OBJECT_ID] = S.[OBJECT_ID] 
--AND I.INDEX_ID = S.INDEX_ID
--WHERE OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1
--ORDER BY OBJECT_NAME(S.[OBJECT_ID])

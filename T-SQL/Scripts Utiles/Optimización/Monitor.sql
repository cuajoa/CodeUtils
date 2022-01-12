select s.[host_name], 
	s.lock_timeout,
   s.login_name,
   s.login_time,
   s.original_login_name,
   s.row_count,
   s.deadlock_priority,
   s.open_transaction_count,
   bd.name,
   p.* ,bd.*
from  master.sys.sysprocesses  p
 JOIN sys.dm_exec_sessions AS s ON p.spid= s.session_id
 LEFT JOIN sys.sysdatabases bd ON s.database_id = bd.dbid
WHERE p.dbid = DB_ID() --AND lastwaittype = 'LCK_M_S                         '
ORDER BY cpu desc

--DBCC INPUTBUFFER ( 83)  WITH NO_INFOMSGS 


---- SP ejecutados
SELECT  d.object_id, d.database_id, OBJECT_NAME(object_id, database_id) 'proc name',   
    d.cached_time, d.last_execution_time, d.total_elapsed_time,  
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],  
    d.last_elapsed_time, d.execution_count  , d.*
FROM sys.dm_exec_procedure_stats AS d  
ORDER BY d.last_execution_time DESC; 



----script ejecutados  en la base
SELECT  TOP 3000 execquery.last_execution_time AS [Date Time], execsql.text AS [Script],DB_NAME(execsql.dbid),OBJECT_NAME(execsql.objectid),execsql.text,execquery.*
FROM sys.dm_exec_query_stats AS execquery
CROSS APPLY sys.dm_exec_sql_text(execquery.sql_handle) AS execsql
WHERE execsql.dbid = DB_ID()
ORDER BY execquery.last_execution_time DESC
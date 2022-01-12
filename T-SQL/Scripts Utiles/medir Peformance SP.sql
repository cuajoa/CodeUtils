SELECT  d.database_id, OBJECT_NAME(object_id, database_id) 'proc name',   
    d.cached_time, 
	d.last_execution_time, 
	d.total_elapsed_time,  
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],  
    d.last_elapsed_time, 
	d.execution_count,
	d.last_logical_reads,
	d.last_logical_writes,
	d.last_physical_reads,
	d.max_physical_reads,
	d.max_logical_writes,
	d.max_worker_time,
	d.type_desc,
	d.plan_handle

FROM sys.dm_exec_procedure_stats AS d  
WHERE OBJECT_NAME(object_id, database_id) IN ('dbo.fnMenuFijoHabilitado','dbo.fnMenuFijoHabilitado2')
AND  d.last_execution_time >=  '20200820'
ORDER BY [total_worker_time] DESC;  





--total_elapsed_time	bigint	El tiempo total transcurrido, en microsegundos para las ejecuciones completadas de este procedimiento almacenado.
--execution_count	bigint	El número de veces que se ha ejecutado el procedimiento almacenado desde que se compiló por última vez.





--cached_time	datetime	Momento en el que el procedimiento almacenado se agregó a la caché.
--last_execution_time	datetime	Hora en que se ejecutó el procedimiento almacenado por última vez.
--execution_count	bigint	El número de veces que se ha ejecutado el procedimiento almacenado desde que se compiló por última vez.
--total_worker_time	bigint	La cantidad total de tiempo de CPU, en microsegundos, consumido por las ejecuciones de este procedimiento almacenado desde que se compiló.

--Para los procedimientos almacenados compilados de forma nativa, total_worker_time puede no ser exacto si varias ejecuciones tardan menos de 1 milisegundo.
--last_worker_time	bigint	Tiempo de CPU, en microsegundos, consumido la última vez que se ejecutó el procedimiento almacenado. 1
--min_worker_time	bigint	El tiempo de CPU mínimo, en microsegundos, hasta que este procedimiento almacenado ha consumido alguna vez durante una ejecución. 1
--max_worker_time	bigint	El tiempo de CPU máximo, en microsegundos, hasta que este procedimiento almacenado ha consumido alguna vez durante una ejecución. 1
--total_physical_reads	bigint	El número total de lecturas físicas realizadas por las ejecuciones de este procedimiento almacenado desde que se compiló.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--last_physical_reads	bigint	El número de lecturas físicas realizadas la última vez que se ejecutó el procedimiento almacenado.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--min_physical_reads	bigint	El número mínimo de lecturas físicas que este procedimiento almacenado ha realizado durante una ejecución.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--max_physical_reads	bigint	El número máximo de lecturas físicas que este procedimiento almacenado ha realizado durante una ejecución.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--total_logical_writes	bigint	El número total de escrituras lógicas realizadas por las ejecuciones de este procedimiento almacenado desde que se compiló.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--last_logical_writes	bigint	El número de páginas del grupo de búferes desfasadas la última vez que se ejecutó el plan. Si una página ya está desfasada (modificada) no se cuenta ninguna escritura.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--min_logical_writes	bigint	El número mínimo de escrituras lógicas que este procedimiento almacenado ha realizado durante una ejecución.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--max_logical_writes	bigint	El número máximo de escrituras lógicas que este procedimiento almacenado ha realizado durante una ejecución.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--total_logical_reads	bigint	El número total de lecturas lógicas realizadas por las ejecuciones de este procedimiento almacenado desde que se compiló.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--last_logical_reads	bigint	El número de lecturas lógicas realizadas la última vez que se ejecutó el procedimiento almacenado.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--min_logical_reads	bigint	El número mínimo de lecturas lógicas que este procedimiento almacenado ha realizado durante una ejecución.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--max_logical_reads	bigint	El número máximo de lecturas lógicas que este procedimiento almacenado ha realizado durante una ejecución.

--Será siempre 0 al consultar una tabla optimizada para memoria.
--total_elapsed_time	bigint	El tiempo total transcurrido, en microsegundos para las ejecuciones completadas de este procedimiento almacenado.
--last_elapsed_time	bigint	El tiempo transcurrido, en microsegundos, hasta la ejecución completada más recientemente de este procedimiento almacenado.
--min_elapsed_time	bigint	El tiempo mínimo transcurrido, en microsegundos, completa cualquier ejecución de este procedimiento almacenado.
--max_elapsed_time	bigint	El tiempo máximo transcurrido, en microsegundos, completa cualquier ejecución de este procedimiento almacenado.


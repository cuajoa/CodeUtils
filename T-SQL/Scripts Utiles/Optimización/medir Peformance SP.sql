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
--execution_count	bigint	El n�mero de veces que se ha ejecutado el procedimiento almacenado desde que se compil� por �ltima vez.





--cached_time	datetime	Momento en el que el procedimiento almacenado se agreg� a la cach�.
--last_execution_time	datetime	Hora en que se ejecut� el procedimiento almacenado por �ltima vez.
--execution_count	bigint	El n�mero de veces que se ha ejecutado el procedimiento almacenado desde que se compil� por �ltima vez.
--total_worker_time	bigint	La cantidad total de tiempo de CPU, en microsegundos, consumido por las ejecuciones de este procedimiento almacenado desde que se compil�.

--Para los procedimientos almacenados compilados de forma nativa, total_worker_time puede no ser exacto si varias ejecuciones tardan menos de 1 milisegundo.
--last_worker_time	bigint	Tiempo de CPU, en microsegundos, consumido la �ltima vez que se ejecut� el procedimiento almacenado. 1
--min_worker_time	bigint	El tiempo de CPU m�nimo, en microsegundos, hasta que este procedimiento almacenado ha consumido alguna vez durante una ejecuci�n. 1
--max_worker_time	bigint	El tiempo de CPU m�ximo, en microsegundos, hasta que este procedimiento almacenado ha consumido alguna vez durante una ejecuci�n. 1
--total_physical_reads	bigint	El n�mero total de lecturas f�sicas realizadas por las ejecuciones de este procedimiento almacenado desde que se compil�.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--last_physical_reads	bigint	El n�mero de lecturas f�sicas realizadas la �ltima vez que se ejecut� el procedimiento almacenado.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--min_physical_reads	bigint	El n�mero m�nimo de lecturas f�sicas que este procedimiento almacenado ha realizado durante una ejecuci�n.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--max_physical_reads	bigint	El n�mero m�ximo de lecturas f�sicas que este procedimiento almacenado ha realizado durante una ejecuci�n.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--total_logical_writes	bigint	El n�mero total de escrituras l�gicas realizadas por las ejecuciones de este procedimiento almacenado desde que se compil�.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--last_logical_writes	bigint	El n�mero de p�ginas del grupo de b�feres desfasadas la �ltima vez que se ejecut� el plan. Si una p�gina ya est� desfasada (modificada) no se cuenta ninguna escritura.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--min_logical_writes	bigint	El n�mero m�nimo de escrituras l�gicas que este procedimiento almacenado ha realizado durante una ejecuci�n.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--max_logical_writes	bigint	El n�mero m�ximo de escrituras l�gicas que este procedimiento almacenado ha realizado durante una ejecuci�n.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--total_logical_reads	bigint	El n�mero total de lecturas l�gicas realizadas por las ejecuciones de este procedimiento almacenado desde que se compil�.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--last_logical_reads	bigint	El n�mero de lecturas l�gicas realizadas la �ltima vez que se ejecut� el procedimiento almacenado.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--min_logical_reads	bigint	El n�mero m�nimo de lecturas l�gicas que este procedimiento almacenado ha realizado durante una ejecuci�n.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--max_logical_reads	bigint	El n�mero m�ximo de lecturas l�gicas que este procedimiento almacenado ha realizado durante una ejecuci�n.

--Ser� siempre 0 al consultar una tabla optimizada para memoria.
--total_elapsed_time	bigint	El tiempo total transcurrido, en microsegundos para las ejecuciones completadas de este procedimiento almacenado.
--last_elapsed_time	bigint	El tiempo transcurrido, en microsegundos, hasta la ejecuci�n completada m�s recientemente de este procedimiento almacenado.
--min_elapsed_time	bigint	El tiempo m�nimo transcurrido, en microsegundos, completa cualquier ejecuci�n de este procedimiento almacenado.
--max_elapsed_time	bigint	El tiempo m�ximo transcurrido, en microsegundos, completa cualquier ejecuci�n de este procedimiento almacenado.


/*

SELECT * FROM FONDOS 

--144
--145
--146
--147
--148
--149
--150
--151
--152
--153
--154
--155
--156
--157
--158
--159
--160

*/

BEGIN TRAN 

DECLARE @CodFondo numeric(10) = 158


SELECT ROW_NUMBER() OVER (ORDER BY CodAuditoriaRef) AS ID, SOLRESC.NumSolicitud, FechaConcertacion, CodSolResc
INTO #SOL
FROM SOLRESC
WHERE CodFondo = @CodFondo AND SOLRESC.FechaConcertacion between '20220214' and '20220224'

UPDATE SOLRESC
SET
	NumSolicitud= SOL.ID
FROM SOLRESC INNER JOIN
#SOL SOL ON SOLRESC.CodSolResc = SOL.CodSolResc

SELECT ROW_NUMBER() OVER (ORDER BY CodAuditoriaRef) AS ID, SOLRESC.NumSolicitud, FechaConcertacion, CodSolResc
FROM SOLRESC
WHERE CodFondo = @CodFondo AND SOLRESC.FechaConcertacion between '20220214' and '20220224'


DROP TABLE #SOL


--commit tran
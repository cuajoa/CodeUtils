/*

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

SELECT ROW_NUMBER() OVER (ORDER BY CodAuditoriaRef) AS ID, SOLSUSC.NumSolicitud, FechaConcertacion, CodSolSusc
INTO #SOL
FROM SOLSUSC
WHERE CodFondo = @CodFondo AND SOLSUSC.FechaConcertacion between '20220214' and '20220224'

UPDATE SOLSUSC
SET
	NumSolicitud= SOL.ID
FROM SOLSUSC INNER JOIN
#SOL SOL ON SOLSUSC.CodSolSusc = SOL.CodSolSusc

SELECT ROW_NUMBER() OVER (ORDER BY CodAuditoriaRef) AS ID, SOLSUSC.NumSolicitud, FechaConcertacion, CodSolSusc
FROM SOLSUSC
WHERE CodFondo = @CodFondo AND SOLSUSC.FechaConcertacion between '20220214' and '20220224'


DROP TABLE #SOL

--commit tran
CREATE TABLE #ASIENTOS
(
	NumFondo numeric(6,0), 
	NumAsiento numeric(12,0), 
	FechaNueva smalldatetime,
	FechaAnterior smalldatetime,
	CodFondo numeric(5,0)
)

INSERT INTO #ASIENTOS (NumFondo, NumAsiento, FechaNueva, FechaAnterior) SELECT 	12,6243,'20190628','20190924'

--Busco el CodFondo y lo Actualizo
UPDATE #ASIENTOS
SET CodFondo = FONDOSREAL.CodFondo
FROM #ASIENTOS
INNER JOIN FONDOSREAL ON FONDOSREAL.NumFondo = #ASIENTOS.NumFondo

--Actualizo los Asientos
UPDATE ASIENTOSCAB SET FechaConcertacion = #ASIENTOS.FechaNueva 
FROM ASIENTOSCAB
INNER JOIN #ASIENTOS ON #ASIENTOS.CodFondo = ASIENTOSCAB.CodFondo AND #ASIENTOS.NumAsiento = ASIENTOSCAB.NumAsiento
WHERE FechaConcertacion = #ASIENTOS.FechaAnterior


DROP TABLE #ASIENTOS

GO
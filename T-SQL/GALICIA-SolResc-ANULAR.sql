DECLARE @FechaProceso smalldatetime = '20200713'

CREATE TABLE #SOLRESCANUL(
	CodSolResc numeric(10) NULL,
	CodAuditoriaRef numeric(20) NOT NULL,
	Procesada Boolean NOT NULL
)

-- :::::::::: SOLICITUDES ANULADAS :::::::::::
INSERT INTO #SOLRESCANUL(CodSolResc, CodAuditoriaRef, Procesada)
SELECT CodSolResc, CodAuditoriaRef, 0
FROM SOLRESC
WHERE FechaConcertacion=@FechaProceso AND CodFondo=3 AND EstaAnulado=0


-- ANULO SOLICITUDES DE RESCATES
UPDATE SOLRESC
SET
	SOLRESC.EstaAnulado=-1
FROM SOLRESC
INNER JOIN #SOLRESCANUL ON SOLRESC.CodAuditoriaRef = #SOLRESCANUL.CodAuditoriaRef
WHERE FechaConcertacion=@FechaProceso AND CodFondo=3


SELECT TOP 3000 CodSolResc, CodAuditoriaRef, Procesada
FROM #SOLRESCANUL
WHERE Procesada=0


-- RECUPERO LAS PRIMERAS 3000
UPDATE SOLRESC
SET
	SOLRESC.EstaAnulado=0
FROM SOLRESC
INNER JOIN #SOLRESCANUL ON SOLRESC.CodAuditoriaRef = #SOLRESCANUL.CodAuditoriaRef
WHERE FechaConcertacion=@FechaProceso AND CodFondo=3

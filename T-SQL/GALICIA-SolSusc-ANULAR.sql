DECLARE @FechaProceso smalldatetime = '20200713'

CREATE TABLE #SOLSUSCANUL(
	CodSolSusc numeric(10) NULL,
	CodAuditoriaRef numeric(20) NOT NULL,
	Procesada Boolean NOT NULL
)

-- :::::::::: SOLICITUDES ANULADAS :::::::::::
INSERT INTO #SOLSUSCANUL(CodSolSusc, CodAuditoriaRef, Procesada)
SELECT CodSolSusc, CodAuditoriaRef, 0
FROM SOLSUSC
WHERE FechaConcertacion=@FechaProceso AND CodFondo=3 AND EstaAnulado=0


-- ANULO SOLICITUDES DE SUSCRIPCION
UPDATE SOLSUSC
SET
	SOLSUSC.EstaAnulado=-1
FROM SOLSUSC
INNER JOIN #SOLSUSCANUL ON SOLSUSC.CodAuditoriaRef = #SOLSUSCANUL.CodAuditoriaRef
WHERE FechaConcertacion=@FechaProceso AND CodFondo=3



-- ANULO SOLICITUDES DE SUSCRIPCION
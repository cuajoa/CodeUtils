--SELECT * FROM FONDOS

DECLARE @CodFondo numeric(10)

SELECT @CodFondo=CodFondo FROM FONDOSREAL
WHERE NumFondo=9

SELECT * FROM SOLRESC
WHERE CodFondo=@CodFondo AND NumSolicitud=317142


SELECT * 
FROM SOLRESC 
LEFT JOIN SOLRESCSONIC on  SOLRESC.CodSolResc=SOLRESCSONIC.CodSolResc
AND  SOLRESC.CodFondo=SOLRESCSONIC.CodFondo
AND  SOLRESC.CodSucursal=SOLRESCSONIC.CodSucursal
AND  SOLRESC.CodAgColocador=SOLRESCSONIC.CodAgColocador
WHERE SOLRESC.CodFondo=@CodFondo AND SOLRESC.NumSolicitud=32645
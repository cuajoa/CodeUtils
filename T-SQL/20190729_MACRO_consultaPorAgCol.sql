SELECT DISTINCT CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.Nombre, CUOTAPARTISTAS.FechaIngreso
  FROM SOLRESC INNER JOIN CUOTAPARTISTAS ON SOLRESC.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
 WHERE NOT EXISTS (SELECT  1 
  FROM SOLRESCLIQMON WHERE SOLRESC.CodFondo=SOLRESCLIQMON.CodFondo
   AND SOLRESC.CodAgColocador=SOLRESCLIQMON.CodAgColocador AND SOLRESC.CodSucursal=SOLRESCLIQMON.CodSucursal
   AND SOLRESC.CodSolResc=SOLRESCLIQMON.CodSolResc )
   AND CUOTAPARTISTAS.CodAgColocador = 1
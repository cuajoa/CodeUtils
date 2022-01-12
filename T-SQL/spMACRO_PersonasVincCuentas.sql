DECLARE @NumAgColocador numeric
SET @NumAgColocador = 1

DECLARE @CodAgColocador numeric
SELECT @CodAgColocador = CodAgColocador FROM AGCOLOCADORES WHERE NumAgColocador = @NumAgColocador

--Cuotapartistas Físicos no vinculados sin cuentas bancarias
SELECT * 
FROM CUOTAPARTISTAS
LEFT JOIN CPTCTASBANCARIAS ON CUOTAPARTISTAS.CodCuotapartista = CPTCTASBANCARIAS.CodCuotapartista
WHERE CUOTAPARTISTAS.CodSistemaExtOrig IS NULL AND CUOTAPARTISTAS.EsPersonaFisica = -1 AND CPTCTASBANCARIAS.CodCtaBancaria IS NULL
AND CUOTAPARTISTAS.CodAgColocador = @CodAgColocador


--Cuotapartistas Físicos no vinculados con cuentas bancarias
SELECT * 
FROM CUOTAPARTISTAS
INNER JOIN CPTCTASBANCARIAS ON CUOTAPARTISTAS.CodCuotapartista = CPTCTASBANCARIAS.CodCuotapartista
WHERE CUOTAPARTISTAS.CodSistemaExtOrig IS NULL AND CUOTAPARTISTAS.EsPersonaFisica = -1
AND CUOTAPARTISTAS.CodAgColocador = @CodAgColocador



--Cuotapartistas Jurídicos no vinculados sin cuentas bancarias
SELECT * 
FROM CUOTAPARTISTAS
LEFT JOIN CPTCTASBANCARIAS ON CUOTAPARTISTAS.CodCuotapartista = CPTCTASBANCARIAS.CodCuotapartista
WHERE CUOTAPARTISTAS.CodSistemaExtOrig IS NULL AND CUOTAPARTISTAS.EsPersonaFisica = 0 AND CPTCTASBANCARIAS.CodCtaBancaria IS NULL
AND CUOTAPARTISTAS.CodAgColocador = @CodAgColocador


--Cuotapartistas Jurídicos no vinculados con cuentas bancarias
SELECT * 
FROM CUOTAPARTISTAS
INNER JOIN CPTCTASBANCARIAS ON CUOTAPARTISTAS.CodCuotapartista = CPTCTASBANCARIAS.CodCuotapartista
WHERE CUOTAPARTISTAS.CodSistemaExtOrig IS NULL AND CUOTAPARTISTAS.EsPersonaFisica = 0
AND CUOTAPARTISTAS.CodAgColocador = @CodAgColocador

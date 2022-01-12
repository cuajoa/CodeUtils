UPDATE FONDOSREAL
SET
CodInterfaz=NumFondo
WHERE CodInterfaz IS NULL



UPDATE SUCURSALES
SET
CodInterfaz=NumSucursal
WHERE CodInterfaz IS NULL


UPDATE TPVALORESCP
SET
CodInterfaz=LTRIM(NumFondo) + REPLACE( REPLACE(Descripcion,'Clase ',''), 'Unico','U')
FROM FONDOSREAL
INNER JOIN TPVALORESCP ON FONDOSREAL.CodFondo = TPVALORESCP.CodFondo
WHERE TPVALORESCP.CodInterfaz IS NULL



UPDATE CUOTAPARTISTAS
SET
CodInterfaz=NumCuotapartista
WHERE CodInterfaz IS NULL


UPDATE TPDOCIDENTIDAD
SET
CodInterfaz=CodInterfazBanco
WHERE CodInterfaz IS NULL
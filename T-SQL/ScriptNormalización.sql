--Actualiza todos los códigos de interfaz de los fondos con el número
UPDATE FONDOSREAL
SET
CodInterfaz=NumFondo
WHERE CodInterfaz IS NULL

--Actualiza todos los códigos de interfaz de la clase con el CodCAFCI
--Se puede pasar el CodCafci de la clase en el servicesLayer y este automaticamente reconoce fondo y clase.
UPDATE TPVALORESCP
SET
CodInterfaz=CodCAFCI
WHERE CodInterfaz IS NULL

--Actualiza el ID (codInterfaz) de la clase con el numero de fondo y clase. 1A, 2C, etc
--Si se ejecuta este, no se ejecuta el anterior
UPDATE TPVALORESCP
SET
TPVALORESCP.CodInterfaz=ltrim(FONDOSREAL.NumFondo) + TPVALORESCP.Abreviatura
FROM TPVALORESCP
INNER JOIN FONDOSREAL ON TPVALORESCP.CodFondo = FONDOSREAL.CodFondo
WHERE TPVALORESCP.CodInterfaz IS NULL

--Actualiza el Cod Interfaz de la Condicion de Ingreso y egreso
-- Le pone el número de fondo
UPDATE CONDICIONESINGEGR
SET
CONDICIONESINGEGR.CodInterfaz=ltrim(FONDOSREAL.NumFondo)
FROM CONDICIONESINGEGR
INNER JOIN FONDOSREAL ON CONDICIONESINGEGR.CodFondo = FONDOSREAL.CodFondo
WHERE CONDICIONESINGEGR.CodInterfaz IS NULL AND CONDICIONESINGEGR.EstaAnulado=0

--Actualia el código de interfaz del cuotapartista
UPDATE CUOTAPARTISTAS
SET
CodInterfaz=NumCuotapartista
WHERE CodInterfaz IS NULL

--actualia los códigos de interfaz de la sucursal.
UPDATE SUCURSALES
SET
CodInterfaz=NumSucursal
WHERE CodInterfaz IS NULL
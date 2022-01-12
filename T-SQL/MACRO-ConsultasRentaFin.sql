--Clientes que posean cuentas cuotapartirstas abiertas y/o cerradas
SELECT PER.CodTpDocIdentidad, PER.NumDocumento, CUO.NumCuotapartista, CUO.Nombre, CUO.CodInterfaz, CUO.EstaAnulado  FROM CONDOMINIOS CON
INNER JOIN CUOTAPARTISTAS AS CUO ON CUO.CodCuotapartista = CON.CodCuotapartista
INNER JOIN PERSONAS AS PER ON PER.CodPersona = CON.CodPersona

--Cuentas cerradas CON movimiento en 2018
SELECT PER.CodTpDocIdentidad, PER.NumDocumento, CUO.NumCuotapartista, CUO.Nombre, CUO.CodInterfaz, CUO.EstaAnulado  FROM CONDOMINIOS CON
INNER JOIN CUOTAPARTISTAS AS CUO ON CUO.CodCuotapartista = CON.CodCuotapartista AND CUO.EstaAnulado = -1
INNER JOIN PERSONAS AS PER ON PER.CodPersona = CON.CodPersona
INNER JOIN LIQUIDACIONES AS LIQ ON LIQ.CodCuotapartista = CON.CodCuotapartista AND YEAR(LIQ.FechaConcertacion) = 2018

--Cuentas abiertas CON movimiento en 2018
SELECT PER.CodTpDocIdentidad, PER.NumDocumento, CUO.NumCuotapartista, CUO.Nombre, CUO.CodInterfaz, CUO.EstaAnulado  FROM CONDOMINIOS CON
INNER JOIN CUOTAPARTISTAS AS CUO ON CUO.CodCuotapartista = CON.CodCuotapartista AND CUO.EstaAnulado = 0
INNER JOIN PERSONAS AS PER ON PER.CodPersona = CON.CodPersona
INNER JOIN LIQUIDACIONES AS LIQ ON LIQ.CodCuotapartista = CON.CodCuotapartista AND YEAR(LIQ.FechaConcertacion) = 2018

--Cuentas cerradas SIN movimiento en 2018
SELECT PER.CodTpDocIdentidad, PER.NumDocumento, CUO.NumCuotapartista, CUO.Nombre, CUO.CodInterfaz, CUO.EstaAnulado  FROM CONDOMINIOS CON
INNER JOIN CUOTAPARTISTAS AS CUO ON CUO.CodCuotapartista = CON.CodCuotapartista AND CUO.EstaAnulado = -1
INNER JOIN PERSONAS AS PER ON PER.CodPersona = CON.CodPersona
INNER JOIN LIQUIDACIONES AS LIQ ON LIQ.CodCuotapartista = CON.CodCuotapartista AND YEAR(LIQ.FechaConcertacion) = 2018
WHERE CON.CodCuotapartista NOT IN (SELECT DISTINCT CodCuotapartista FROM LIQUIDACIONES WHERE YEAR(FechaConcertacion) = 2018)

--Cuentas abiertas SIN movimientos 2018
SELECT PER.CodTpDocIdentidad, PER.NumDocumento, CUO.NumCuotapartista, CUO.Nombre, CUO.CodInterfaz, CUO.EstaAnulado FROM CONDOMINIOS CON
INNER JOIN CUOTAPARTISTAS AS CUO ON CUO.CodCuotapartista = CON.CodCuotapartista AND CUO.EstaAnulado = 0
INNER JOIN PERSONAS AS PER ON PER.CodPersona = CON.CodPersona
WHERE CON.CodCuotapartista NOT IN (SELECT DISTINCT CodCuotapartista FROM LIQUIDACIONES WHERE YEAR(FechaConcertacion) = 2018)
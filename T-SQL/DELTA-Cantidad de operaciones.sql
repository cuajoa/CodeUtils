--Cantidad de Operaciones Diarias
SELECT COUNT(*) FROM LIQUIDACIONES
WHERE FechaConcertacion='2019-05-27'

--Cantidad de Operaciones mensuales
SELECT COUNT(*) FROM LIQUIDACIONES
WHERE FechaConcertacion BETWEEN '2019-05-01' AND '2019-05-29'
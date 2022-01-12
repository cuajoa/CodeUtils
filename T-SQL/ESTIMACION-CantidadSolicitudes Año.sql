SELECT SUM(Cantidad)Cantidad, ltrim(Año) año FROM
(
	SELECT COUNT(FechaConcertacion) Cantidad, year(FechaConcertacion) Año, month(FechaConcertacion) Mes
	FROM SOLSUSC
	GROUP BY FechaConcertacion
	UNION ALL
	SELECT COUNT(FechaConcertacion) Cantidad, year(FechaConcertacion) Año, month(FechaConcertacion) Mes
	FROM SOLRESC
	GROUP BY FechaConcertacion
)RESUL
WHERE Año < 2018
GROUP BY  Año
Order by Año

SELECT SUM(Cantidad)Cantidad, ltrim(A�o) a�o FROM
(
	SELECT COUNT(FechaConcertacion) Cantidad, year(FechaConcertacion) A�o, month(FechaConcertacion) Mes
	FROM SOLSUSC
	GROUP BY FechaConcertacion
	UNION ALL
	SELECT COUNT(FechaConcertacion) Cantidad, year(FechaConcertacion) A�o, month(FechaConcertacion) Mes
	FROM SOLRESC
	GROUP BY FechaConcertacion
)RESUL
WHERE A�o < 2018
GROUP BY  A�o
Order by A�o

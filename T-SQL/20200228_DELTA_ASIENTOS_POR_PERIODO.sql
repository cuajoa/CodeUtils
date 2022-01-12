
/*Los asientos de un periodo seleccionado de Todos los fondos*/

DECLARE @FechaDesde Fecha
DECLARE @FechaHasta Fecha

SET @FechaDesde = '20190101'
SET @FechaHasta = '20191231'

Select FONDOSREAL.NumFondo, 
	   FONDOSREAL.Nombre 'Fondo',
	   FONDOSREAL.NombreAbreviado,
	   ASIENTOSCAB.FechaConcertacion,
	   ASIENTOSCAB.Leyenda,
	   ASIENTOSCAB.AsientoManual,
	   ASIENTOSIT.NumAsiento,
	   ASIENTOSIT.CodAsientoIt,
	   ASIENTOSIT.CodCtaContable,
	   CTASCONTABLES.Descripcion 'Cta Contable',
	   ASIENTOSIT.ImporteDebe,
	   ASIENTOSIT.ImporteHaber
From ASIENTOSCAB
	 inner join ASIENTOSIT ON ASIENTOSCAB.CodFondo = ASIENTOSIT.CodFondo AND ASIENTOSCAB.NumAsiento = ASIENTOSIT.NumAsiento
	 inner join FONDOSREAL ON ASIENTOSCAB.CodFondo = FONDOSREAL.CodFondo
	 inner join CTASCONTABLES ON CTASCONTABLES.CodFondo = ASIENTOSIT.CodFondo
								 AND CTASCONTABLES.CodCtaContable = ASIENTOSIT.CodCtaContable
								 AND CTASCONTABLES.CodTpPlanCtaContable = ASIENTOSIT.CodTpPlanCtaContable
WHERE ASIENTOSCAB.FechaConcertacion >= @FechaDesde AND ASIENTOSCAB.FechaConcertacion <= @FechaHasta


DECLARE	@FechaDesde Fecha='20180808'
DECLARE	@FechaHasta Fecha = '20190101'

	if @FechaHasta is null
	begin 
		set @FechaHasta = @FechaDesde
	end


	CREATE TABLE #CUOTAPARTISTAS
		(CodCuotapartista Numeric(10))

	INSERT INTO #CUOTAPARTISTAS
	SELECT CodCuotapartista
	FROM CUOTAPARTISTAS
	--WHERE NumCuotapartista IN (4141,4245,4249,4250,4259,4277,4303,4305,4312,4318,4322,4324,4343,4352,4386,4404,4423,4478,4487,4504,4505)

	CREATE TABLE #CUOTAPARTISTASFDO
		(CodFondo Numeric(10))

	CREATE TABLE #CUOTAPARTISTASPOS
		(CodFondo Numeric(15)
		,CodTpValorCp Numeric(15)
		,CodAgColocador Numeric(15)
		,CodCuotapartista Numeric(15)
		,CantCuotapartes Numeric(28,8)
		,CantCuotapartesTotal Numeric(28,8)
		,PorcentajeHSG Numeric(28,2)
		,ImporteHSG Numeric(28,2)
		,TotalHSG Numeric(28,2)
		,PorcentajeMFCI Numeric(28,2)
		,ImporteMFCI Numeric(28,2)
		,TpCambio Numeric(28,2)
		,Fecha smalldatetime)

	insert #CUOTAPARTISTASFDO
		(CodFondo)
	select distinct LIQUIDACIONES.CodFondo
	from LIQUIDACIONES
	INNER JOIN #CUOTAPARTISTAS ON #CUOTAPARTISTAS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista 
	WHERE LIQUIDACIONES.FechaConcertacion >= @FechaDesde
		and LIQUIDACIONES.FechaConcertacion <= @FechaHasta
		and LIQUIDACIONES.EstaAnulado = 0

	declare @CodFondo CodigoLargo
	declare @CodFondoAnt CodigoLargo
	declare @FechaMin Fecha
	declare @FechaAnt Fecha

	select @CodFondo = min(CodFondo)
	from #CUOTAPARTISTASFDO
 
	while not @CodFondo is null
	begin

		select @FechaMin = MIN(Fecha)
		from CUOTAPARTES
		WHERE CodFondo = @CodFondo
			and Fecha >= @FechaDesde
			and Fecha <= @FechaHasta
	
		while @FechaMin <= @FechaHasta and not @FechaMin is null
		begin

			insert #CUOTAPARTISTASPOS
				(CodFondo, CodTpValorCp, CodAgColocador, CodCuotapartista, CantCuotapartes, Fecha)
			select LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodAgColocador, #CUOTAPARTISTAS.CodCuotapartista, sum(LIQUIDACIONES.CantCuotapartes), @FechaMin
			from LIQUIDACIONES
			INNER JOIN #CUOTAPARTISTAS ON #CUOTAPARTISTAS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
			WHERE LIQUIDACIONES.CodFondo = @CodFondo
				and LIQUIDACIONES.FechaConcertacion < @FechaMin 
				and LIQUIDACIONES.EstaAnulado = 0
			group by LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodAgColocador, #CUOTAPARTISTAS.CodCuotapartista

			select @FechaAnt = @FechaMin 
			select @FechaMin = null
			select @FechaMin = MIN(Fecha)
			from CUOTAPARTES
			WHERE CodFondo = @CodFondo
				and Fecha > @FechaAnt
				and Fecha <= @FechaHasta

		end

		set @CodFondoAnt = @CodFondo
		set @CodFondo = NULL

		select @CodFondo = min(CodFondo)
		from #CUOTAPARTISTASFDO
		where CodFondo > @CodFondoAnt
	 	
	end

	update #CUOTAPARTISTASPOS
		SET CantCuotapartesTotal = VALORESCP.CuotapartesCirculacionSL			
	FROM #CUOTAPARTISTASPOS
	INNER JOIN VALORESCP ON VALORESCP.CodFondo = #CUOTAPARTISTASPOS.CodFondo
		AND VALORESCP.CodTpValorCp = #CUOTAPARTISTASPOS.CodTpValorCp
		AND VALORESCP.Fecha = #CUOTAPARTISTASPOS.Fecha

	--Honorarios Sociedad Gerente
	update #CUOTAPARTISTASPOS
		SET TotalHSG = VALORESCPITPROV.Importe,
			PorcentajeHSG = VALORESCPITPROV.PorcHonorario
	FROM #CUOTAPARTISTASPOS
	INNER JOIN VALORESCPITPROV ON VALORESCPITPROV.CodFondo = #CUOTAPARTISTASPOS.CodFondo
		AND VALORESCPITPROV.CodTpValorCp = #CUOTAPARTISTASPOS.CodTpValorCp
		AND VALORESCPITPROV.Fecha = #CUOTAPARTISTASPOS.Fecha
		AND VALORESCPITPROV.CodProvision = 'PHON'
		AND VALORESCPITPROV.CodTpPorcProvision= 'S'

	UPDATE #CUOTAPARTISTASPOS
	SET
		PorcentajeMFCI = COALESCE(AGCOLOCPORCCOMISION.PorcentajeComision,50)
	FROM #CUOTAPARTISTASPOS
	LEFT JOIN AGCOLOCPORCCOMISION ON #CUOTAPARTISTASPOS.CodAgColocador = AGCOLOCPORCCOMISION.CodAgColocador
		  AND #CUOTAPARTISTASPOS.CodFondo = AGCOLOCPORCCOMISION.CodFondo

	update #CUOTAPARTISTASPOS
		SET ImporteHSG = CantCuotapartes / CantCuotapartesTotal * COALESCE(TotalHSG,0)
	where COALESCE(CantCuotapartesTotal,0) <> 0 
	
	update #CUOTAPARTISTASPOS
		SET ImporteMFCI = (ImporteHSG * PorcentajeMFCI)/100
	where COALESCE(CantCuotapartesTotal,0) <> 0 

	--Multiplico todos los fondos en USD por el ultimo tipo de cambio
	update #CUOTAPARTISTASPOS
		SET ImporteMFCI = (ImporteMFCI/CambioVendedor),
		TpCambio=1/CambioVendedor
	FROM #CUOTAPARTISTASPOS
	INNER JOIN FONDOS ON #CUOTAPARTISTASPOS.CodFondo = FONDOS.CodFondo
	INNER JOIN COTIZACIONESMON ON FONDOS.CodMoneda = COTIZACIONESMON.CodMoneda AND #CUOTAPARTISTASPOS.CodFondo = COTIZACIONESMON.CodFondo
	WHERE COTIZACIONESMON.Fecha >= @FechaHasta
	AND ImporteMFCI > 0 

	update #CUOTAPARTISTASPOS
		SET TpCambio=1
	WHERE TpCambio IS NULL

	select CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.Nombre, FONDOS.NumFondo, TPVALORESCP.Abreviatura, TPVALORESCP.CodCAFCI, Fecha, MONEDAS.CodISO as Moneda,
	PorcentajeHSG, COALESCE(ImporteHSG,0) as ImporteHSG, PorcentajeMFCI, ImporteMFCI, TpCambio
	from #CUOTAPARTISTASPOS
	inner join FONDOS ON FONDOS.CodFondo = #CUOTAPARTISTASPOS.CodFondo
	INNER JOIN MONEDAS ON FONDOS.CodMoneda = MONEDAS.CodMoneda
	INNER JOIN TPVALORESCP ON  TPVALORESCP.CodFondo = #CUOTAPARTISTASPOS.CodFondo
		and TPVALORESCP.CodTpValorCp = #CUOTAPARTISTASPOS.CodTpValorCp
	INNER JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista = #CUOTAPARTISTASPOS.CodCuotapartista  
	--group by CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.Nombre, FONDOS.NumFondo, TPVALORESCP.Abreviatura, TPVALORESCP.CodCAFCI, Fecha
	WHERE ImporteMFCI > 0 
	ORDER BY NumCuotapartista,Fecha,TPVALORESCP.CodCAFCI


	DROP TABLE #CUOTAPARTISTASPOS	
	DROP TABLE #CUOTAPARTISTASFDO
	DROP TABLE #CUOTAPARTISTAS
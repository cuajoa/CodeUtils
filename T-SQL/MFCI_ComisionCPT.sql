DECLARE	@FechaDesde Fecha='20200701'
DECLARE	@FechaHasta Fecha = '20200731'


	if @FechaHasta is null
	begin 
		set @FechaHasta = @FechaDesde
	end
	
	CREATE TABLE #CUOTAPARTISTAS
		(CodCuotapartista Numeric(10))

	INSERT INTO #CUOTAPARTISTAS
	SELECT CodCuotapartista
	FROM CUOTAPARTISTAS
	WHERE NumCuotapartista IN (4141,4245,4249,4250,4259,4277,4303,4305,4312,4318,4322,4324,4343,4352,4386,4404,4423,4478,4487,4504,4505)

	CREATE TABLE #CUOTAPARTISTASFDO
		(CodFondo Numeric(10))

	CREATE TABLE #CUOTAPARTISTASPOS
		(CodFondo Numeric(15)
		,CodTpValorCp Numeric(15)
		,CodCuotapartista Numeric(15)
		,CantCuotapartes Numeric(28,8)
		,CantCuotapartesTotal Numeric(28,8)
		,TotalHSG Numeric(28,2)
		,TotalHSD Numeric(28,2)
		,TotalGSG Numeric(28,2)
		,TotalGSD Numeric(28,2)
		,ImporteHSG Numeric(28,2)
		,ImporteHSD Numeric(28,2)
		,ImporteGSG Numeric(28,2)
		,ImporteGSD Numeric(28,2)
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
				(CodFondo, CodTpValorCp, CodCuotapartista, CantCuotapartes, Fecha)
			select LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, #CUOTAPARTISTAS.CodCuotapartista, sum(LIQUIDACIONES.CantCuotapartes), @FechaMin
			from LIQUIDACIONES
			INNER JOIN #CUOTAPARTISTAS ON #CUOTAPARTISTAS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
			WHERE LIQUIDACIONES.CodFondo = @CodFondo
				and LIQUIDACIONES.FechaConcertacion < @FechaMin 
				and LIQUIDACIONES.EstaAnulado = 0
			group by LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, #CUOTAPARTISTAS.CodCuotapartista

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
		SET TotalHSG = VALORESCPITPROV.Importe
	FROM #CUOTAPARTISTASPOS
	INNER JOIN VALORESCPITPROV ON VALORESCPITPROV.CodFondo = #CUOTAPARTISTASPOS.CodFondo
		AND VALORESCPITPROV.CodTpValorCp = #CUOTAPARTISTASPOS.CodTpValorCp
		AND VALORESCPITPROV.Fecha = #CUOTAPARTISTASPOS.Fecha
		AND VALORESCPITPROV.CodProvision = 'PHON'
		AND VALORESCPITPROV.CodTpPorcProvision= 'S'


	update #CUOTAPARTISTASPOS
		SET TotalHSD = VALORESCPITPROV.Importe
	FROM #CUOTAPARTISTASPOS
	INNER JOIN VALORESCPITPROV ON VALORESCPITPROV.CodFondo = #CUOTAPARTISTASPOS.CodFondo
		AND VALORESCPITPROV.CodTpValorCp = #CUOTAPARTISTASPOS.CodTpValorCp
		AND VALORESCPITPROV.Fecha = #CUOTAPARTISTASPOS.Fecha
		AND VALORESCPITPROV.CodProvision = 'PHON'
		AND VALORESCPITPROV.CodTpPorcProvision= 'A'

	update #CUOTAPARTISTASPOS
		SET TotalGSD = VALORESCPITPROV.Importe
	FROM #CUOTAPARTISTASPOS
	INNER JOIN VALORESCPITPROV ON VALORESCPITPROV.CodFondo = #CUOTAPARTISTASPOS.CodFondo
		AND VALORESCPITPROV.CodTpValorCp = #CUOTAPARTISTASPOS.CodTpValorCp
		AND VALORESCPITPROV.Fecha = #CUOTAPARTISTASPOS.Fecha
		AND VALORESCPITPROV.CodProvision = 'PHON'
		AND VALORESCPITPROV.CodTpPorcProvision= 'D'

	update #CUOTAPARTISTASPOS
		SET TotalGSG = VALORESCPITPROV.Importe
	FROM #CUOTAPARTISTASPOS
	INNER JOIN VALORESCPITPROV ON VALORESCPITPROV.CodFondo = #CUOTAPARTISTASPOS.CodFondo
		AND VALORESCPITPROV.CodTpValorCp = #CUOTAPARTISTASPOS.CodTpValorCp
		AND VALORESCPITPROV.Fecha = #CUOTAPARTISTASPOS.Fecha
		AND VALORESCPITPROV.CodProvision = 'PHON'
		AND VALORESCPITPROV.CodTpPorcProvision= 'G'
	--SELECT CodFondo 
	--FROM VALORESCPITPROV
	--WHERE Fecha >= @FechaDesde and Fecha <= @FechaHasta 

	update #CUOTAPARTISTASPOS
		SET ImporteGSD = CantCuotapartes / CantCuotapartesTotal * COALESCE(TotalGSD,0)
			,ImporteGSG = CantCuotapartes / CantCuotapartesTotal * COALESCE(TotalGSG,0)
			,ImporteHSD = CantCuotapartes / CantCuotapartesTotal * COALESCE(TotalHSD,0)
			,ImporteHSG = CantCuotapartes / CantCuotapartesTotal * COALESCE(TotalHSG,0)
	where COALESCE(CantCuotapartesTotal,0) <> 0 
	
	select  FONDOS.NumFondo, TPVALORESCP.Abreviatura, CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.Nombre NomCuotapartista, Fecha, sum(COALESCE(ImporteGSD,0)) as ImporteGSD, sum(COALESCE(ImporteGSG,0)) as ImporteGSG, 
		sum(COALESCE(ImporteHSD,0)) as ImporteHSD, sum(COALESCE(ImporteHSG,0)) as ImporteHSG
	from #CUOTAPARTISTASPOS
	INNER JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista = #CUOTAPARTISTASPOS.CodCuotapartista
	inner join FONDOS ON FONDOS.CodFondo = #CUOTAPARTISTASPOS.CodFondo
	INNER JOIN TPVALORESCP ON  TPVALORESCP.CodFondo = #CUOTAPARTISTASPOS.CodFondo
		and TPVALORESCP.CodTpValorCp = #CUOTAPARTISTASPOS.CodTpValorCp
	group by FONDOS.NumFondo, TPVALORESCP.Abreviatura, Fecha, CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.Nombre 
	ORDER BY FONDOS.NumFondo,Fecha,TPVALORESCP.Abreviatura


	DROP TABLE #CUOTAPARTISTAS
	DROP TABLE #CUOTAPARTISTASFDO
	DROP TABLE #CUOTAPARTISTASPOS

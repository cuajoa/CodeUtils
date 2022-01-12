DECLARE @Fecha Fecha
SET @Fecha = '20180630'
	IF (select count(*) from tempdb..sysobjects where id = object_id('tempdb..#DATA')) <> 0
		DROP TABLE #DATA

	IF (select count(*) from tempdb..sysobjects where id = object_id('tempdb..#FONDOSFILTER')) <> 0
		DROP TABLE #FONDOSFILTER

	IF (select count(*) from tempdb..sysobjects where id = object_id('tempdb..#ARCHIVOFINAL')) <> 0
		DROP TABLE #ARCHIVOFINAL


	DECLARE @CodMonedaApp	CodigoMedio
	DECLARE @NumAgColocador CodigoMedio
	DECLARE @NumFondo		NumeroCorto
	DECLARE @FechaTexto		varchar(100)
	DECLARE @Separador varchar(1)

	SET @Separador = '@'

	SET @CodMonedaApp = dbo.fnMonPaisAplicacion()


	/*-------------------------------------------------------------------------------*/
	/*
	Parametros del script
	@Fecha = Pasar siempre un valor en la fecha. para filtrar la fecha de las liquidaciones.
	@NumFondo = Filtrar fondo por numero de fondo. O setearlo a NULL para traer todos los fondos.
	*/
	SET @NumFondo = NULL
	/*-------------------------------------------------------------------------------*/

	--select @Fecha = dbo.fnUltimoDiaDelMes(@Fecha)

	SET @FechaTexto = dbo.fnFormatDateTime(@Fecha,'MM/DD/YYYY')

	SET @CodMonedaApp = dbo.fnMonPaisAplicacion()
	SET @NumAgColocador = 80


	CREATE TABLE #DATA
	(ID numeric(10) IDENTITY (1,1)
	,CodFondo			numeric(10) NOT NULL
	,CodMoneda			numeric(10) NOT NULL
	,CodTpValorCp		numeric(10) NOT NULL
	,CodCuotapartista	numeric(10) NOT NULL
	,CantCuotapartes	numeric(22,4) NOT NULL
	,CodMonedaIE		numeric(5) NOT NULL
	,CodMonedaIEInterfaz varchar(30) collate database_default
	,Cotizacion		numeric(19,8) NULL
	,ValoresCP		numeric(19,8) NULL
	,SaldoMonOri		numeric(19,4)
	,SaldoMonLoc		numeric(19,4)
	)

	CREATE TABLE #ARCHIVOFINAL
	(
		Linea varchar(4000) NOT NULL
	)



	INSERT INTO #DATA (CodFondo, CodMoneda, CodTpValorCp, CodCuotapartista, CantCuotapartes, CodMonedaIE,CodMonedaIEInterfaz)
	SELECT        dbo.LIQUIDACIONES.CodFondo, 
					FONDOSREAL.CodMoneda,
					LIQUIDACIONES.CodTpValorCp, 
					LIQUIDACIONES.CodCuotapartista, 
					sum(LIQUIDACIONES.CantCuotapartes) AS CantCuotapartes,
					MONEDASFONDOSREAL.CodMoneda  AS CodMonedaIE,
					MONEDASFONDOSREAL.CodInterfaz as CodMonedaIEInterfaz
	FROM            LIQUIDACIONES
	INNER JOIN dbo.FONDOSREAL
		inner join MONEDAS MONEDASFONDOSREAL ON FONDOSREAL.CodMoneda = MONEDASFONDOSREAL.CodMoneda
	ON dbo.LIQUIDACIONES.CodFondo = dbo.FONDOSREAL.CodFondo 

	WHERE        (LIQUIDACIONES.FechaLiquidacion <= @Fecha)
				AND dbo.LIQUIDACIONES.EstaAnulado = 0
	GROUP BY dbo.LIQUIDACIONES.CodFondo, dbo.LIQUIDACIONES.CodTpValorCp, dbo.LIQUIDACIONES.CodCuotapartista, MONEDASFONDOSREAL.CodInterfaz, FONDOSREAL.CodMoneda,MONEDASFONDOSREAL.CodMoneda
	HAVING        (SUM(dbo.LIQUIDACIONES.CantCuotapartes) > 0.00000000)
	ORDER BY dbo.LIQUIDACIONES.CodFondo, dbo.LIQUIDACIONES.CodTpValorCp, dbo.LIQUIDACIONES.CodCuotapartista



	UPDATE #DATA
	SET Cotizacion = 1
	WHERE CodMoneda = @CodMonedaApp

	UPDATE #DATA
	SET  Cotizacion =  1/COTIZACIONESMON.CambioComprador
	FROM #DATA
 		LEFT JOIN COTIZACIONESMON ON COTIZACIONESMON.CodFondo = #DATA.CodFondo
		AND COTIZACIONESMON.CodMoneda = #DATA.CodMonedaIE
		AND COTIZACIONESMON.Fecha = (SELECT MAX(Fecha) FROM COTIZACIONESMON COTI
					WHERE	COTI.CodFondo = #DATA.CodFondo
								AND COTI.CodMoneda = #DATA.CodMonedaIE
								AND COTI.Fecha <= @Fecha)
	WHERE #DATA.CodMoneda <> @CodMonedaApp


	UPDATE #DATA 
		SET ValoresCP = VALORESCP.ValorCuotaparte
	FROM #DATA
	INNER JOIN VALORESCP 
		on VALORESCP.CodFondo=#DATA.CodFondo 
		AND VALORESCP.CodTpValorCp = #DATA.CodTpValorCp
		AND VALORESCP.Fecha = (SELECT MAX(Fecha) FROM VALORESCP AS VCP
								WHERE	VCP.CodFondo = #DATA.CodFondo
								AND VCP.CodTpValorCp = #DATA.CodTpValorCp
								AND VCP.Fecha <= @Fecha)

	UPDATE #DATA 
		SET SaldoMonLoc  = (CantCuotapartes * ValoresCP) * Cotizacion,
			SaldoMonOri  = (CantCuotapartes * ValoresCP)

	DECLARE @NroCtaComitente AbreviaturaMedia
	DECLARE @DescCtaComitente Nombre
	DECLARE @TipoFondo CodigoTextoCorto
	DECLARE @DescFondo DescripcionMedia
	DECLARE @ClienteCobis CodigoInterfazLargo
	DECLARE @TipoDocPersonal CodigoTextoMedio
	DECLARE @NumDocPersonal AbreviaturaCorta
	DECLARE @TipoIdTributaria CodigoTextoCorto
	DECLARE @NroIdTributaria AbreviaturaMedia
	DECLARE @CondominioNombre DescripcionLarga
	DECLARE @CantCuotapartes DescripcionMedia
	DECLARE @ValorCuotaparte DescripcionMedia
	DECLARE @Moneda CodigoTextoMedio
	DECLARE @SaldoMonOri DescripcionMedia
	DECLARE @Cotizacion DescripcionMedia
	DECLARE @SaldoMonLoc DescripcionMedia
	DECLARE @Entidad CodigoTextoMedio
	DECLARE @TipoPersona CodigoTextoMedio
	DECLARE @Empleado CodigoTextoMedio
	DECLARE @Sector CodigoTextoMedio
	DECLARE @Residencia CodigoTextoMedio
	DECLARE @Modulo CodigoTextoMedio
	DECLARE @EstadoRegistro CodigoTextoMedio

	SELECT	@Entidad = '285', 
			@TipoPersona = '',
			@Empleado = '',
			@Sector = '',
			@Residencia = '',
			@Modulo = '104',
			@EstadoRegistro = 'I'

	DECLARE FCI_Cursor CURSOR FOR   
	SELECT CONVERT(varchar(15),CUOTAPARTISTAS.NumCuotapartista)
		,RTRIM(LTRIM(COALESCE(CUOTAPARTISTAS.Nombre,'')))
		,COALESCE(FONDOSREAL.CodTpFondo,'') 
		,COALESCE(FONDOSREAL.Nombre,'') 
		,COALESCE(PERSONAS.CodInterfazBanco,'')
		,CASE WHEN TPDOCIDENTIDAD.CodDocIdentidad='DNI' THEN '01'
			WHEN TPDOCIDENTIDAD.CodDocIdentidad='LE' THEN '02'
			WHEN TPDOCIDENTIDAD.CodDocIdentidad='LC' THEN '03'
			WHEN TPDOCIDENTIDAD.CodDocIdentidad='PAS' THEN '125'
			WHEN TPDOCIDENTIDAD.CodDocIdentidad='DE' THEN '135'
			ELSE ''
			END
		,CASE WHEN PERSONAS.EsFisica = -1 then
			COALESCE(convert(varchar,PERSONAS.NumDocumento),'')
		else
			''
		end
		,CASE WHEN NOT PERSONAS.CUIT IS NULL THEN '11'
			WHEN NOT PERSONAS.CUIL IS NULL THEN '08'
			WHEN NOT PERSONAS.CDI IS NULL THEN '09'
			ELSE ''
			END 
		,CASE WHEN PERSONAS.EsFisica = 0 then
				COALESCE(CONVERT(VARCHAR(11),PERSONAS.CUIT), CONVERT(VARCHAR(11),PERSONAS.CUIL), CONVERT(VARCHAR(11),PERSONAS.CDI),'')
			else
			    COALESCE(CONVERT(VARCHAR(11),PERSONAS.CUIT), CONVERT(VARCHAR(11),PERSONAS.CUIL), CONVERT(VARCHAR(11),PERSONAS.CDI),'')
			end
		,RTRIM(LTRIM(ISNULL(PERSONAS.Apellido,''))) + ' ' + 
		case when RTRIM(LTRIM(isnull(PERSONAS.Nombre,''))) = RTRIM(LTRIM(ISNULL(PERSONAS.Apellido,''))) then ' ' else RTRIM(LTRIM(isnull(PERSONAS.Nombre,''))) end
		,COALESCE(CONVERT(varchar,#DATA.CantCuotapartes),'')
		,COALESCE(CONVERT(varchar,#DATA.ValoresCP),'')
		,COALESCE(CONVERT(varchar,#DATA.CodMonedaIEInterfaz),'')
		,SUM(#DATA.SaldoMonOri) 
		,COALESCE(CONVERT(varchar,#DATA.Cotizacion),'')
		,SUM(#DATA.SaldoMonLoc)
	FROM #DATA
	INNER JOIN FONDOSREAL		ON FONDOSREAL.CodFondo = #DATA.CodFondo
	INNER JOIN CUOTAPARTISTAS	ON #DATA.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
	LEFT JOIN CONDOMINIOS		ON #DATA.CodCuotapartista = CONDOMINIOS.CodCuotapartista AND CONDOMINIOS.EstaAnulado = 0
	LEFT JOIN PERSONAS			ON CONDOMINIOS.CodPersona =PERSONAS.CodPersona
	LEFT JOIN TPDOCIDENTIDAD	ON PERSONAS.CodTpDocIdentidad  = TPDOCIDENTIDAD.CodTpDocIdentidad 
	WHERE NOT COALESCE(PERSONAS.CodInterfazBanco,'') = ''
	GROUP BY CONVERT(varchar(15),CUOTAPARTISTAS.NumCuotapartista)
		,RTRIM(LTRIM(COALESCE(CUOTAPARTISTAS.Nombre,'')))
		,COALESCE(FONDOSREAL.CodTpFondo,'') 
		,COALESCE(FONDOSREAL.Nombre,'') 
		,COALESCE(PERSONAS.CodInterfazBanco,'')
		,CASE WHEN TPDOCIDENTIDAD.CodDocIdentidad='DNI' THEN '01'
			WHEN TPDOCIDENTIDAD.CodDocIdentidad='LE' THEN '02'
			WHEN TPDOCIDENTIDAD.CodDocIdentidad='LC' THEN '03'
			WHEN TPDOCIDENTIDAD.CodDocIdentidad='PAS' THEN '125'
			WHEN TPDOCIDENTIDAD.CodDocIdentidad='DE' THEN '135'
			ELSE ''
			END
		,CASE WHEN PERSONAS.EsFisica = -1 then
				COALESCE(convert(varchar,PERSONAS.NumDocumento),'')
			else
				''
			end
		,CASE WHEN NOT PERSONAS.CUIT IS NULL THEN '11'
			WHEN NOT PERSONAS.CUIL IS NULL THEN '08'
			WHEN NOT PERSONAS.CDI IS NULL THEN '09'
			ELSE ''
			END 
		,CASE WHEN PERSONAS.EsFisica = 0 then
				COALESCE(CONVERT(VARCHAR(11),PERSONAS.CUIT), CONVERT(VARCHAR(11),PERSONAS.CUIL), CONVERT(VARCHAR(11),PERSONAS.CDI),'')
			else
			    COALESCE(CONVERT(VARCHAR(11),PERSONAS.CUIT), CONVERT(VARCHAR(11),PERSONAS.CUIL), CONVERT(VARCHAR(11),PERSONAS.CDI),'')
				
			end
		,RTRIM(LTRIM(ISNULL(PERSONAS.Apellido,''))) 
		, RTRIM(LTRIM(isnull(PERSONAS.Nombre,'')))
		,COALESCE(CONVERT(varchar,#DATA.CantCuotapartes),'')
		,COALESCE(CONVERT(varchar,#DATA.ValoresCP),'')
		,COALESCE(CONVERT(varchar,#DATA.CodMonedaIEInterfaz),'')
		,COALESCE(CONVERT(varchar,#DATA.Cotizacion),'')


	OPEN FCI_Cursor  

	FETCH NEXT FROM FCI_Cursor   
	INTO @NroCtaComitente, @DescCtaComitente, @TipoFondo, @DescFondo, @ClienteCobis, @TipoDocPersonal, @NumDocPersonal, @TipoIdTributaria, @NroIdTributaria,
	@CondominioNombre, @CantCuotapartes, @ValorCuotaparte, @Moneda, @SaldoMonOri, @Cotizacion, @SaldoMonLoc

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
	
		INSERT #ARCHIVOFINAL (Linea)
		SELECT @FechaTexto + @Separador + @Entidad + @Separador + @NroCtaComitente + @Separador + @DescCtaComitente + @Separador + @TipoFondo + @Separador + @DescFondo + @Separador + 
		@ClienteCobis + @Separador + @TipoDocPersonal + @Separador + @NumDocPersonal + @Separador + @TipoIdTributaria + @Separador + @NroIdTributaria + @Separador + @CondominioNombre + 
		@Separador + @CantCuotapartes + @Separador + @ValorCuotaparte + @Separador + @Moneda + @Separador + @SaldoMonOri + @Separador + @Cotizacion + @Separador + @SaldoMonLoc +
		@Separador + @TipoPersona + @Separador + @Empleado + @Separador + @Sector + @Separador + @Residencia + @Separador + @Modulo + @Separador + @EstadoRegistro

     
		FETCH NEXT FROM FCI_Cursor   
		INTO @NroCtaComitente, @DescCtaComitente, @TipoFondo, @DescFondo, @ClienteCobis, @TipoDocPersonal, @NumDocPersonal, @TipoIdTributaria, @NroIdTributaria,
		@CondominioNombre, @CantCuotapartes, @ValorCuotaparte, @Moneda, @SaldoMonOri, @Cotizacion, @SaldoMonLoc
	END   
	CLOSE FCI_Cursor  
	DEALLOCATE FCI_Cursor  

	SELECT * FROM #ARCHIVOFINAL

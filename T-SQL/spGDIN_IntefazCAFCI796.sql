exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Id'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Id
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as

	insert into #CAFCIUNIFICADA_Tag_Id (CampoXml)
		select '<Id>'
	union all
		select  case when coalesce(dbo.fnSacarCaracteresEspXML(ISNULL(SOCIEDADESGTE.Descripcion, '')),'') = '' then  '<AANom/>' else '<AANom>' + dbo.fnSacarCaracteresEspXML(ISNULL(SOCIEDADESGTE.Descripcion, '')) + '</AANom>' end +
				case when coalesce(dbo.fnSacarCaracteresEspXML(ISNULL(SOCIEDADESGTE.CodCAFCI, '')),'') = '' then '<AAId/>' else '<AAId>' + dbo.fnSacarCaracteresEspXML(ISNULL(SOCIEDADESGTE.CodCAFCI, '')) + '</AAId>' end +
				case when coalesce(dbo.fnSacarCaracteresEspXML(ISNULL(FONDOS.NombreCorto, '')),'') = '' then '<FdoNom/>' else '<FdoNom>' + dbo.fnSacarCaracteresEspXML(ISNULL(FONDOS.NombreCorto, '')) + '</FdoNom>' end +
				case when coalesce(dbo.fnSacarCaracteresEspXML(ISNULL(FONDOS.CodCAFCI, '')),'') = '' then '<FdoId/>' else '<FdoId>' + dbo.fnSacarCaracteresEspXML(ISNULL(FONDOS.CodCAFCI, '')) + '</FdoId>' end +
				case when coalesce(dbo.fnSacarCaracteresEspXML(ISNULL(MONEDAS.Descripcion, '')),'') = '' then '<MonFdoNom/>' else '<MonFdoNom>' + dbo.fnSacarCaracteresEspXML(ISNULL(MONEDAS.Descripcion, '')) + '</MonFdoNom>' end +
				case when coalesce(dbo.fnSacarCaracteresEspXML(ISNULL(MONEDAS.CodCAFCI, '')),'') = '' then '<MonFdoId/>' else '<MonFdoId>' + dbo.fnSacarCaracteresEspXML(ISNULL(MONEDAS.CodCAFCI, '')) + '</MonFdoId>' end +
				'<FechaInfo>' + convert(varchar(10),@FechaProceso,120) + '</FechaInfo>'
		from SOCIEDADESGTE
		INNER JOIN FONDOS ON FONDOS.CodSociedadGte = SOCIEDADESGTE.CodSociedadGte
		INNER JOIN FONDOSUSER ON FONDOSUSER.CodFondo = FONDOS.CodFondo AND FONDOSUSER.CodUsuario = @CodUsuario
		INNER JOIN MONEDAS ON MONEDAS.CodMoneda = FONDOS.CodMoneda
		INNER JOIN FONDOSREAL ON FONDOSREAL.CodFondo = FONDOS.CodFondo
		where FONDOSREAL.CodFondo = @CodFondo 
	union all
		select '</Id>'
	

go





exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Diario'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Diario
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as
	DECLARE @CodMonedaPais CodigoLargo

	set @CodMonedaPais = dbo.fnMonPaisAplicacion()

	
	CREATE TABLE #CAFCIDIARIA_Q
       (CodFondo numeric(5) NOT NULL,
        CodTpValorCp numeric(5) NOT NULL,
        QT varchar(4) COLLATE database_default NOT NULL,
        CantCuotapartes numeric(22, 8),
        EsLiquidacion smallint )
	
    CREATE TABLE #VCPITINT_TPVALORCP (
        CodFondo		 numeric(6,0)    NULL,
        CodTpValorCp     numeric(6,0)    NULL,
        Descripcion      varchar(80) COLLATE database_default NULL,
        CodCAFCI		 varchar(30) COLLATE database_default NULL)   
           
    INSERT #VCPITINT_TPVALORCP (CodFondo,CodTpValorCp, Descripcion, CodCAFCI)
    SELECT CodFondo,CodTpValorCp, Descripcion, CodCAFCI
    FROM TPVALORESCP
	WHERE COALESCE(FechaFin,DATEADD(dd,1,@FechaProceso)) > @FechaProceso 
	---------------------------------------------------------------------------------------------------------------
    INSERT INTO #CAFCIDIARIA_Q (CodFondo, CodTpValorCp, QT, CantCuotapartes, EsLiquidacion)
    SELECT  LIQUIDACIONES.CodFondo, 
            LIQUIDACIONES.CodTpValorCp,
            (CASE WHEN SignoPositivo = -1 THEN 'QSUS' ELSE 'QRES' END) QT,
            ABS(SUM(CantCuotapartes)) AS CantCuotapartes,
            -1 AS EsLiquidacion
    FROM    LIQUIDACIONES
    INNER JOIN TPLIQUIDACION ON TPLIQUIDACION.CodTpLiquidacion = LIQUIDACIONES.CodTpLiquidacion
    INNER JOIN #TEMP_CAFCIUNIFICADA ON #TEMP_CAFCIUNIFICADA.CodFondo = LIQUIDACIONES.CodFondo
    INNER JOIN #VCPITINT_TPVALORCP ON #VCPITINT_TPVALORCP.CodFondo=LIQUIDACIONES.CodFondo AND #VCPITINT_TPVALORCP.CodTpValorCp=LIQUIDACIONES.CodTpValorCp
    WHERE   LIQUIDACIONES.FechaConcertacion = @FechaProceso 
        AND EstaAnulado = 0 
        AND TPLIQUIDACION.CodTpLiquidacion IN ('SM' , 'SU' , 'TP', 'RM' , 'RE' , 'TN', 'CD')
		AND NOT EXISTS (SELECT * FROM MOVLIQGLOBALES WHERE MOVLIQGLOBALES.CodFondo = #TEMP_CAFCIUNIFICADA.CodFondo  
				AND MOVLIQGLOBALES.FechaConcertacion = @FechaProceso AND MOVLIQGLOBALES.EstaAnulado = 0)
    GROUP BY LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp,
             (CASE WHEN SignoPositivo = -1 THEN 'QSUS' ELSE 'QRES' END )
	---------------------------------------------------------------------------------------------------------------
    INSERT INTO #CAFCIDIARIA_Q (CodFondo, CodTpValorCp, QT, CantCuotapartes, EsLiquidacion)
    SELECT  VALORESCPSUSCRESC.CodFondo, VALORESCPSUSCRESC.CodTpValorCp,
            'QSUS' AS QT,
            SUM(CantSuscripcion) AS CantCuotapartes,
            0 AS EsLiquidacion
    FROM    VALORESCPSUSCRESC
            INNER JOIN #TEMP_CAFCIUNIFICADA ON #TEMP_CAFCIUNIFICADA.CodFondo = VALORESCPSUSCRESC.CodFondo
            INNER JOIN #VCPITINT_TPVALORCP ON #VCPITINT_TPVALORCP.CodFondo=VALORESCPSUSCRESC.CodFondo AND #VCPITINT_TPVALORCP.CodTpValorCp=VALORESCPSUSCRESC.CodTpValorCp
            LEFT  JOIN #CAFCIDIARIA_Q CCTRL ON CCTRL.CodFondo = VALORESCPSUSCRESC.CodFondo AND CCTRL.CodTpValorCp = VALORESCPSUSCRESC.CodTpValorCp AND CCTRL.EsLiquidacion = -1
    WHERE   EstaAnulado = 0
        AND VALORESCPSUSCRESC.Fecha = @FechaProceso
        AND CCTRL.CodTpValorCp IS NULL
    GROUP BY VALORESCPSUSCRESC.CodFondo, VALORESCPSUSCRESC.CodTpValorCp
	---------------------------------------------------------------------------------------------------------------
    INSERT INTO #CAFCIDIARIA_Q (CodFondo, CodTpValorCp, QT, CantCuotapartes, EsLiquidacion)
    SELECT  MOVLIQGLOBALES.CodFondo, MOVLIQGLOBALES.CodTpValorCp,
            'QSUS' AS QT,
            SUM(CantidadCuotapartes) AS CantCuotapartes,
            -1 AS EsLiquidacion
    FROM    MOVLIQGLOBALES
		INNER JOIN TPMOVLIQGLOBAL ON TPMOVLIQGLOBAL.CodTpMovLiqGlobal = MOVLIQGLOBALES.CodTpMovLiqGlobal
			AND TPMOVLIQGLOBAL.AfectaVCPDia = 0
			AND TPMOVLIQGLOBAL.SignoPositivo = -1
        INNER JOIN #TEMP_CAFCIUNIFICADA ON #TEMP_CAFCIUNIFICADA.CodFondo = MOVLIQGLOBALES.CodFondo
        INNER JOIN #VCPITINT_TPVALORCP ON #VCPITINT_TPVALORCP.CodFondo=MOVLIQGLOBALES.CodFondo AND #VCPITINT_TPVALORCP.CodTpValorCp=MOVLIQGLOBALES.CodTpValorCp
        LEFT  JOIN #CAFCIDIARIA_Q CCTRL ON CCTRL.CodFondo = MOVLIQGLOBALES.CodFondo AND CCTRL.CodTpValorCp = MOVLIQGLOBALES.CodTpValorCp 
			AND QT = 'QSUS'
    WHERE   EstaAnulado = 0
        AND MOVLIQGLOBALES.FechaConcertacion = @FechaProceso
        AND CCTRL.CodTpValorCp IS NULL
    GROUP BY MOVLIQGLOBALES.CodFondo, MOVLIQGLOBALES.CodTpValorCp
	---------------------------------------------------------------------------------------------------------------
    INSERT INTO #CAFCIDIARIA_Q (CodFondo, CodTpValorCp, QT, CantCuotapartes, EsLiquidacion)
    SELECT  VALORESCPSUSCRESC.CodFondo, VALORESCPSUSCRESC.CodTpValorCp,
            'QRES' AS QT,
            SUM(CantRescates) AS CantCuotapartes,
            0 AS EsLiquidacion
    FROM    VALORESCPSUSCRESC
            INNER JOIN #TEMP_CAFCIUNIFICADA ON #TEMP_CAFCIUNIFICADA.CodFondo = VALORESCPSUSCRESC.CodFondo
            INNER JOIN #VCPITINT_TPVALORCP ON #VCPITINT_TPVALORCP.CodFondo=VALORESCPSUSCRESC.CodFondo AND #VCPITINT_TPVALORCP.CodTpValorCp=VALORESCPSUSCRESC.CodTpValorCp
            LEFT  JOIN #CAFCIDIARIA_Q CCTRL ON CCTRL.CodFondo = VALORESCPSUSCRESC.CodFondo AND CCTRL.CodTpValorCp = VALORESCPSUSCRESC.CodTpValorCp AND CCTRL.EsLiquidacion = -1
    WHERE   EstaAnulado = 0
        AND VALORESCPSUSCRESC.Fecha = @FechaProceso
        AND CCTRL.CodTpValorCp IS NULL
    GROUP BY VALORESCPSUSCRESC.CodFondo, VALORESCPSUSCRESC.CodTpValorCp
	---------------------------------------------------------------------------------------------------------------
    INSERT INTO #CAFCIDIARIA_Q (CodFondo, CodTpValorCp, QT, CantCuotapartes, EsLiquidacion)
    SELECT  MOVLIQGLOBALES.CodFondo, MOVLIQGLOBALES.CodTpValorCp,
            'QRES' AS QT,
            ABS(SUM(CantidadCuotapartes)) AS CantCuotapartes,
            -1 AS EsLiquidacion
    FROM    MOVLIQGLOBALES
		INNER JOIN TPMOVLIQGLOBAL ON TPMOVLIQGLOBAL.CodTpMovLiqGlobal = MOVLIQGLOBALES.CodTpMovLiqGlobal
			AND TPMOVLIQGLOBAL.AfectaVCPDia = 0
			AND TPMOVLIQGLOBAL.SignoPositivo = 0
        INNER JOIN #TEMP_CAFCIUNIFICADA ON #TEMP_CAFCIUNIFICADA.CodFondo = MOVLIQGLOBALES.CodFondo
		INNER JOIN #VCPITINT_TPVALORCP ON #VCPITINT_TPVALORCP.CodFondo=MOVLIQGLOBALES.CodFondo AND #VCPITINT_TPVALORCP.CodTpValorCp=MOVLIQGLOBALES.CodTpValorCp        
        LEFT  JOIN #CAFCIDIARIA_Q CCTRL ON CCTRL.CodFondo = MOVLIQGLOBALES.CodFondo 
			AND CCTRL.CodTpValorCp = MOVLIQGLOBALES.CodTpValorCp 
			AND QT = 'QRES'
    WHERE   EstaAnulado = 0
        AND MOVLIQGLOBALES.FechaConcertacion = @FechaProceso
        AND CCTRL.CodTpValorCp IS NULL
    GROUP BY MOVLIQGLOBALES.CodFondo, MOVLIQGLOBALES.CodTpValorCp

	------------------------------------------------------------------------------------------------------------------------
	--    Agregar los Faltantes
	------------------------------------------------------------------------------------------------------------------------
	Declare @ParametroEVRCD Smallint
	Declare @InformaClasesSinPat Smallint
	Declare @ValorDefecto  numeric(22,3)

	set @ParametroEVRCD=dbo.fnParametroEVRCD()
	set @InformaClasesSinPat=-1 --dbo.fnParametroVARPAT()
	select @ValorDefecto=0.000--case when @InformaClasesSinPat=-1  then 0.000 else 0.000 end

	create table #TEMP_FINAL 
	(
		CodFondo numeric(5),
		CodTpValorCp numeric(3),
		ClaseId varchar(30) collate database_Default,
		ClaseNom varchar(80) collate database_Default,
		MonId varchar(30) collate database_Default,
		MonNom varchar(80) collate database_Default,
		CRes numeric(22,8),
		CSus numeric(22,8),
		CCP numeric(22,8),
		VCP numeric(19,10),
		PN numeric(19,2),
		Precio  numeric(19,10),
		PNFdo numeric(19,2),
		VCPr numeric(19,10),
		RenImpD numeric(19,10)
	)

	insert into #TEMP_FINAL (CodFondo,
		CodTpValorCp,
		ClaseId,
		ClaseNom,
		MonId,
		MonNom,
		CRes,
		CSus,
		CCP,
		VCP,
		PN,
		Precio,
		VCPr,
		PNFdo,
		RenImpD)
    SELECT  DISTINCT FONDOS.CodFondo,
            TPVCP.CodTpValorCp,
            ISNULL(TPVCP.CodCAFCI, '') AS ClaseId,
            CASE WHEN @ParametroEVRCD  = 0 OR FONDOSMON.CodFondoMon IS NULL THEN 
                    dbo.fnSacarCaracteresEspXML(ISNULL(TPVCP.Descripcion, ''))
             ELSE 
                    FONDOSMON.Abreviatura
            END AS ClaseNom,
            CASE WHEN @ParametroEVRCD  = 0 OR FONDOSMON.CodFondoMon IS NULL THEN 
                ISNULL(MONEDAS.CodCAFCI, '') 
            ELSE 
                COALESCE(MONEDASREEXP.CodCAFCI, '')
			END AS MonId,
            CASE WHEN @ParametroEVRCD  = 0 OR FONDOSMON.CodFondoMon IS NULL THEN 
                dbo.fnSacarCaracteresEspXML(ISNULL(MONEDAS.Descripcion, ''))
			ELSE 
                dbo.fnSacarCaracteresEspXML(COALESCE(MONEDASREEXP.Descripcion, ''))
			END AS MonNom,
            ISNULL(QRES.CantCuotapartes, 0) AS CRes,
            ISNULL(QSUS.CantCuotapartes, 0) AS CSus,
            (CASE WHEN ISNULL(QRES.CantCuotapartes, 0)=0 and ISNULL(QSUS.CantCuotapartes, 0)=0 and PatrimonioNeto=0 and @InformaClasesSinPat = -1 THEN @ValorDefecto else
			  ISNULL(CuotapartesCirculacion, 0.000) end ) + 
            (CASE WHEN QSUS.EsLiquidacion = 0 THEN
                ISNULL(QSUS.CantCuotapartes, 0.000) 
            ELSE
                0.000
            END) -
            (CASE WHEN QRES.EsLiquidacion = 0 THEN
                 ISNULL(QRES.CantCuotapartes, 0.000) 
            ELSE
                0.000
            END) AS CCP,
            CASE WHEN @ParametroEVRCD  = 0 OR FONDOSMON.CodFondoMon IS NULL THEN 
			    ISNULL(VALORESCP.ValorCuotaparte * 1000, 0)
            ELSE 
                COALESCE(VALORESCPREEXP.ValorCuotaparte*1000,VALORESCP.ValorCuotaparte*1000,0)
			END AS VCP,
			CASE WHEN @ParametroEVRCD = 0 OR VALORESCPREEXP.FactConvReexpFdo IS NULL THEN
						    case when @InformaClasesSinPat = -1 AND PatrimonioNeto=0 THEN @ValorDefecto else ISNULL(PatrimonioNeto, @ValorDefecto) END +
							(CASE WHEN QSUS.EsLiquidacion = 0 THEN
									ISNULL(QSUS.CantCuotapartes * VALORESCP.ValorCuotaparte, 0.00) 
							 ELSE
									0.00
							END) - 
							(CASE WHEN QRES.EsLiquidacion = 0 THEN
								 ISNULL(QRES.CantCuotapartes * VALORESCP.ValorCuotaparte, 0.000) 
							ELSE
								0.000
							END) 
				ELSE
							(ISNULL(VALORESCP.CuotapartesCirculacion,@ValorDefecto) +
						(CASE WHEN QSUS.EsLiquidacion = 0 THEN ISNULL(QSUS.CantCuotapartes, 0.00) 
						 ELSE
								0.00
						END) - 
						(CASE WHEN QRES.EsLiquidacion = 0 THEN ISNULL(QRES.CantCuotapartes, 0.000) 
						ELSE
							0.000
						END)) * ISNULL(VALORESCP.ValorCuotaparte, 0) / ISNULL(VALORESCPREEXP.FactConvReexpFdo,1) 
			END AS PN,
			ISNULL(CambioComprador, 1) AS Precio,
			-----------------------------------------------------------------------------------
			--A FIN DE EXPRESAR EL VALOR EN MONEDA DEL PAIS, SE TOMARA EL CAMBIO TIPO COMPRADOR
			-----------------------------------------------------------------------------------
            case when @CodMonedaPais = FONDOS.CodMoneda then
					VALORESCP.ValorCuotaparte
				when FONDOSMON.CodMoneda  = @CodMonedaPais then 
					VALORESCPREEXP.ValorCuotaparte
				else
					ISNULL(VALORESCP.ValorCuotaparte, 0) / ISNULL(CambioComprador, 1)
				end  * 1000 AS VCPr,
			VALORESCP.PatrimonioNeto,
			VALORESCP.VariacionVCPF 
    FROM    FONDOS
            INNER JOIN #TEMP_CAFCIUNIFICADA ON #TEMP_CAFCIUNIFICADA.CodFondo = FONDOS.CodFondo
            INNER JOIN #VCPITINT_TPVALORCP TPVCP ON TPVCP.CodFondo = FONDOS.CodFondo
            INNER JOIN MONEDAS ON MONEDAS.CodMoneda = FONDOS.CodMoneda
            INNER JOIN VALORESCP
                    LEFT JOIN VALORESCPREEXP
                                INNER jOIN FONDOSMON 
                                    LEFT JOIN MONEDAS MONEDASREEXP ON MONEDASREEXP.CodMoneda = FONDOSMON.CodMoneda
                                ON FONDOSMON.CodFondo = VALORESCPREEXP.CodFondo AND
                                    FONDOSMON.CodTpValorCp = VALORESCPREEXP.CodTpValorCp AND
                                    FONDOSMON.CodMoneda = VALORESCPREEXP.CodMoneda AND
                                    FONDOSMON.CodFondoMon = VALORESCPREEXP.CodFondoMon AND
                                    FONDOSMON.EsValorRef = -1
                            ON VALORESCPREEXP.CodFondo = VALORESCP.CodFondo
                           AND VALORESCPREEXP.CodTpValorCp = VALORESCP.CodTpValorCp
                           AND VALORESCPREEXP.Fecha = VALORESCP.Fecha
                    ON VALORESCP.CodFondo = TPVCP.CodFondo
                   AND VALORESCP.CodTpValorCp = TPVCP.CodTpValorCp
                   AND VALORESCP.Fecha = @FechaProceso
            LEFT  JOIN #CAFCIDIARIA_Q QRES
                    ON QRES.CodFondo = FONDOS.CodFondo
                   AND QRES.CodTpValorCp = TPVCP.CodTpValorCp
                   AND QRES.QT = 'QRES'
            LEFT  JOIN #CAFCIDIARIA_Q QSUS
                    ON QSUS.CodFondo = FONDOS.CodFondo
                   AND QSUS.CodTpValorCp = TPVCP.CodTpValorCp
                   AND QSUS.QT = 'QSUS'
            LEFT  JOIN COTIZACIONESMON
                    ON COTIZACIONESMON.CodFondo = FONDOS.CodFondo
                   AND COTIZACIONESMON.CodMoneda = FONDOS.CodMoneda
                   AND COTIZACIONESMON.Fecha = VALORESCP.Fecha 
			
	WHERE   ((( ((ISNULL(CuotapartesCirculacion, 0.000) + (CASE WHEN QSUS.EsLiquidacion = 0 THEN ISNULL(QSUS.CantCuotapartes, 0.000) ELSE 0.000 END) -
				(CASE WHEN QRES.EsLiquidacion = 0 THEN ISNULL(QRES.CantCuotapartes, 0.000) ELSE 0.000 END)  <> 0.000)
				AND (ISNULL(PatrimonioNeto,@ValorDefecto) + (CASE WHEN QSUS.EsLiquidacion = 0 THEN ISNULL(QSUS.CantCuotapartes * VALORESCP.ValorCuotaparte, 0.00) ELSE 0.00 END) - 
			(CASE WHEN QRES.EsLiquidacion = 0 THEN ISNULL(QRES.CantCuotapartes * VALORESCP.ValorCuotaparte, 0.000) ELSE 0.000 END) <> 0.000)) OR @InformaClasesSinPat=-1  )

			)
		OR (@ParametroEVRCD= -1 AND VALORESCPREEXP.FactConvReexpFdo IS NOT NULL AND ((ISNULL(VALORESCP.CuotapartesCirculacion, 0.000 ) +
						(CASE WHEN QSUS.EsLiquidacion = 0 THEN ISNULL(QSUS.CantCuotapartes, 0.00) 
							ELSE 0.00 END) - 
						(CASE WHEN QRES.EsLiquidacion = 0 THEN ISNULL(QRES.CantCuotapartes, 0.000) 
						ELSE 0.000 END)) * ISNULL(VALORESCP.ValorCuotaparte, 0) / ISNULL(VALORESCPREEXP.FactConvReexpFdo,1) <> 0.000)) ) 
						
	 ORDER BY FONDOS.CodFondo, TPVCP.CodTpValorCp

	DECLARE @CodMonedaApp CodigoMedio
	SET @CodMonedaApp	= dbo.fnMonPaisAplicacion()

	
	 insert into #CAFCIUNIFICADA_Tag_Diario (CampoXml)
	 select '<VDiarios>'
	 
	 
	 
	 if (select count(*) from #TEMP_FINAL where ISNULL(#TEMP_FINAL.ClaseId, '') <> '')> 0
	 begin
		insert into #CAFCIUNIFICADA_Tag_Diario (CampoXml)
		select '<VDiario>' +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(convert(varchar,ClaseNom),'')),'') ='' then '<ClaseNom/>' else '<ClaseNom>' + dbo.fnSacarCaracteresEspXML(convert(varchar,ClaseNom)) + '</ClaseNom>' end +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(convert(varchar,ClaseId),'')),'') ='' then '<ClaseId/>' else '<ClaseId>' + dbo.fnSacarCaracteresEspXML(convert(varchar,ClaseId)) + '</ClaseId>' end +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(convert(varchar,MonNom),'')),'') ='' then '<MonNomCl/>' else '<MonNomCl>' + dbo.fnSacarCaracteresEspXML(convert(varchar,MonNom)) + '</MonNomCl>' end +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(convert(varchar,MonId),'')),'') ='' then '<MonIdCl/>' else '<MonIdCl>' + dbo.fnSacarCaracteresEspXML(convert(varchar,MonId)) + '</MonIdCl>'end  +
			case when coalesce(convert(varchar,convert(numeric(24,4),VCP)),'') = '' then '<VCP/>' else '<VCP>' + convert(varchar,convert(numeric(24,4),VCP)) + '</VCP>' end +
			case when coalesce(convert(varchar,convert(numeric(22,2),CCP)),'')='' then '<CCP/>' else '<CCP>' + convert(varchar,convert(numeric(22,2),CCP)) + '</CCP>' end +
			case when coalesce(convert(varchar,convert(numeric(22,2),PN)),'')='' then '<PN/>' else '<PN>' + convert(varchar,convert(numeric(22,2),PN)) + '</PN>'  end +
			case when coalesce(convert(varchar,convert(numeric(22,2),PNFdo)),'')='' then '<PNMFdo/>' else '<PNMFdo>' + convert(varchar,convert(numeric(22,2),PNFdo)) + ' </PNMFdo>' end +
			case when coalesce(convert(varchar,convert(numeric(24,4),VCPr)),'')='' then '<VCPr/>' else '<VCPr>' + convert(varchar,convert(numeric(24,4),VCPr)) + '</VCPr>' end +
			case when coalesce(convert(varchar,convert(numeric(22,2),CSus)),'')='' then '<CSus/>' else '<CSus>' + convert(varchar,convert(numeric(22,2),CSus)) + '</CSus>' end +
			case when coalesce(convert(varchar,convert(numeric(22,2),CRes)),'')='' then '<CRes/>' else '<CRes>' + convert(varchar,convert(numeric(22,2),CRes)) + '</CRes>' end +
			case when coalesce(convert(varchar,convert(numeric(24,4),RenImpD)),'')='' then '<RenImpD/>' else '<RenImpD>' + convert(varchar,convert(numeric(24,4),RenImpD)) + '</RenImpD>' end +
			--'<RendImpD>RendImpD</RendImpD>'+
			'</VDiario>'
			from #TEMP_FINAL
			where ISNULL(#TEMP_FINAL.ClaseId, '') <> ''
			
	end
	else
	begin 
		insert into #CAFCIUNIFICADA_Tag_Diario (CampoXml)
		select '<VDiario>' +
			'<ClaseNom/>' +
			'<ClaseId/>' +
			'<MonNomCl/>' +
			'<MonIdCl/>' +
			'<VCP/>' +
			'<CCP/>' +
			'<PN/>' +
			'<PNMFdo/>' +
			'<VCPr/>' +
			'<CSus/>' +
			'<CRes/>' +			
			'<RenImpD/>' +	
			'</VDiario>'
	end
	

	insert into #CAFCIUNIFICADA_Tag_Diario (CampoXml)
		select '<PNT>'+
				case when coalesce(convert(varchar,convert(numeric(22,2),sum(PatrimonioNeto))),'') = '' then '<PNTMFdo/>' else '<PNTMFdo>' + coalesce(convert(varchar,convert(numeric(22,2),sum(PatrimonioNeto))),'') + '</PNTMFdo>' end +
				'</PNT>'
		from CUOTAPARTES 
		where CodFondo = @CodFondo and Fecha = @FechaProceso


	insert into #CAFCIUNIFICADA_Tag_Diario (CampoXml)
	select '</VDiarios>'
	
go


exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_TCambio'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_TCambio
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as

	DECLARE @CodMonedaApp      CodigoMedio
	DECLARE @COTESP Boolean

	select @COTESP = dbo.fnParametroCOTESP()
    SELECT  @CodMonedaApp = dbo.fnMonPaisAplicacion()

	DELETE #CAFCIUNIFICADA_TPCAMBIO

    CREATE TABLE #CAFCISEMANAL_TPCAMBIOORIGEN
       (CodFondo numeric(5) NOT NULL,
        CodMoneda numeric(5) NOT NULL,
        CambioComprador numeric(19, 10) NOT NULL,
        CambioVendedor numeric(19, 10) NOT NULL)


    -- cambios que no están en la tabla de COTIZACIONESMON
    INSERT  INTO #CAFCISEMANAL_TPCAMBIOORIGEN (CodFondo, CodMoneda, CambioComprador, CambioVendedor)
    SELECT  @CodFondo AS CodFondo,
            COTIZACIONESESP.CodMoneda,
            1/AVG(COTIZACIONESESP.FactorConversion) AS CambioComprador,
            1/AVG(COTIZACIONESESP.FactorConversion) AS CambioVendedor
    FROM    COTIZACIONESESP 
            INNER JOIN VALORESCPITPAP
                    ON VALORESCPITPAP.CodFondo = @CodFondo
                   AND VALORESCPITPAP.CodEspecie = COTIZACIONESESP.CodEspecie
                   AND VALORESCPITPAP.Fecha = COTIZACIONESESP.Fecha
    WHERE   COTIZACIONESESP.Fecha = @FechaProceso
        and @COTESP = 0
		AND COTIZACIONESESP.CodMoneda NOT IN (SELECT  CodMoneda
                                              FROM    #CAFCISEMANAL_TPCAMBIOORIGEN
                                              GROUP BY CodMoneda)
    GROUP BY COTIZACIONESESP.CodMoneda
    
    -- cambios que provienen de COTIZACIONESMON
    INSERT  INTO #CAFCISEMANAL_TPCAMBIOORIGEN (CodFondo, CodMoneda, CambioComprador, CambioVendedor)
    SELECT  @CodFondo AS CodFondo,
            COTIZACIONESMON.CodMoneda,
            ISNULL(COTIZACIONESMON.CambioComprador, 1) AS CambioComprador,
            ISNULL(COTIZACIONESMON.CambioVendedor, 1) AS CambioVendedor
    FROM    FONDOS
            INNER JOIN COTIZACIONESMON
                    ON COTIZACIONESMON.CodFondo = FONDOS.CodFondo
                   AND COTIZACIONESMON.Fecha = @FechaProceso
    WHERE   FONDOS.CodFondo = @CodFondo
    AND COTIZACIONESMON.CodMoneda NOT IN (SELECT  CodMoneda
                                              FROM    #CAFCISEMANAL_TPCAMBIOORIGEN
                                              GROUP BY CodMoneda)
    

    --cargo cambio comprador
    INSERT  INTO #CAFCIUNIFICADA_TPCAMBIO (TipoDeCambioCod, CodMonedaOrigen, CambioOrigen, CodMonedaDestino, CambioDestino, CambioMax)
    SELECT  'C' AS TipoDeCambioCod,
            COTMONAPP.CodMoneda AS CodMonedaOrigen,
            ISNULL(COTMONAPP.CambioComprador, 1) AS CambioOrigen,
            FONDOS.CodMoneda AS CodMonedaDestino,
            ISNULL(COTFDOAPP.CambioComprador, 1) AS CambioDestino,
            CASE WHEN ABS(ISNULL(COTMONAPP.CambioComprador, 1)) > ABS(ISNULL(COTFDOAPP.CambioComprador, 1))
                 THEN ABS(ISNULL(COTMONAPP.CambioComprador, 1))
                 ELSE ABS(ISNULL(COTFDOAPP.CambioComprador, 1))
            END CambioMax
    FROM    FONDOS
            INNER JOIN #CAFCISEMANAL_TPCAMBIOORIGEN COTMONAPP
                    ON COTMONAPP.CodFondo = FONDOS.CodFondo
            LEFT  JOIN COTIZACIONESMON COTFDOAPP
                    ON COTFDOAPP.CodFondo = FONDOS.CodFondo
                   AND COTFDOAPP.CodMoneda = FONDOS.CodMoneda
                   AND COTFDOAPP.Fecha = @FechaProceso
    WHERE   FONDOS.CodMoneda <> COTMONAPP.CodMoneda
        AND FONDOS.CodFondo = @CodFondo


    --cargo cambio vendedor
    INSERT  INTO #CAFCIUNIFICADA_TPCAMBIO (TipoDeCambioCod, CodMonedaOrigen, CambioOrigen, CodMonedaDestino, CambioDestino, CambioMax)
    SELECT  'V' AS TipoDeCambioCod,
            COTMONAPP.CodMoneda AS CodMonedaOrigen,
            ISNULL(COTMONAPP.CambioVendedor, 1) AS CambioOrigen,
            FONDOS.CodMoneda AS CodMonedaDestino,
            ISNULL(COTFDOAPP.CambioVendedor, 1) AS CambioDestino,
            CASE WHEN ABS(ISNULL(COTMONAPP.CambioVendedor, 1)) > ABS(ISNULL(COTFDOAPP.CambioVendedor, 1))
                 THEN ABS(ISNULL(COTMONAPP.CambioVendedor, 1))
                 ELSE ABS(ISNULL(COTFDOAPP.CambioVendedor, 1))
            END CambioMax
    FROM    FONDOS
            INNER JOIN #CAFCISEMANAL_TPCAMBIOORIGEN COTMONAPP
                    ON COTMONAPP.CodFondo = FONDOS.CodFondo
            LEFT  JOIN COTIZACIONESMON COTFDOAPP
                    ON COTFDOAPP.CodFondo = FONDOS.CodFondo
                   AND COTFDOAPP.CodMoneda = FONDOS.CodMoneda
                   AND COTFDOAPP.Fecha = @FechaProceso
    WHERE   FONDOS.CodMoneda <> COTMONAPP.CodMoneda
        AND FONDOS.CodFondo = @CodFondo

    --cargo tipo de cambio para fondos con moneda distinta a la aplicación
    IF (SELECT CodMoneda FROM FONDOS WHERE CodFondo = @CodFondo) <> @CodMonedaApp BEGIN

        --cargo cambio comprador
        INSERT  INTO #CAFCIUNIFICADA_TPCAMBIO (TipoDeCambioCod, CodMonedaOrigen, CambioOrigen, CodMonedaDestino, CambioDestino, CambioMax)
        SELECT  'C' AS TipoDeCambioCod,
                @CodMonedaApp AS CodMonedaOrigen,
                1 AS CambioOrigen,
                COTFDOAPP.CodMoneda AS CodMonedaDestino,
                ISNULL(COTFDOAPP.CambioComprador, 1) AS CambioDestino,
                CASE WHEN 1 > ABS(ISNULL(COTFDOAPP.CambioComprador, 1))
                     THEN 1
                     ELSE ABS(ISNULL(COTFDOAPP.CambioComprador, 1))
                END CambioMax
        FROM    FONDOS
                INNER JOIN COTIZACIONESMON COTFDOAPP
                        ON COTFDOAPP.CodFondo = FONDOS.CodFondo
                       AND COTFDOAPP.CodMoneda = FONDOS.CodMoneda
                       AND COTFDOAPP.Fecha = @FechaProceso
        WHERE   FONDOS.CodFondo = @CodFondo    
    
        --cargo cambio vendedor
        INSERT  INTO #CAFCIUNIFICADA_TPCAMBIO (TipoDeCambioCod, CodMonedaOrigen, CambioOrigen, CodMonedaDestino, CambioDestino, CambioMax)
        SELECT  'V' AS TipoDeCambioCod,
                @CodMonedaApp AS CodMonedaOrigen,
                1 AS CambioOrigen,
                COTFDOAPP.CodMoneda AS CodMonedaDestino,
                ISNULL(COTFDOAPP.CambioVendedor, 1) AS CambioDestino,
                CASE WHEN 1 > ABS(ISNULL(COTFDOAPP.CambioVendedor, 1))
                     THEN 1
                     ELSE ABS(ISNULL(COTFDOAPP.CambioVendedor, 1))
                END CambioMax
        FROM    FONDOS
                INNER JOIN COTIZACIONESMON COTFDOAPP
                        ON COTFDOAPP.CodFondo = FONDOS.CodFondo
                       AND COTFDOAPP.CodMoneda = FONDOS.CodMoneda
                       AND COTFDOAPP.Fecha = @FechaProceso
        WHERE   FONDOS.CodFondo = @CodFondo

    END


    --actualizo FactorCambio para CAFCI
    UPDATE  #CAFCIUNIFICADA_TPCAMBIO
    SET     FactorCambio = CASE WHEN CambioMax >= 1 AND CambioMax < 10 THEN 6
                                WHEN CONVERT(integer, LOG10(CambioMax)) > 0 THEN 6 - CONVERT(integer, LOG10(CambioMax))
                                ELSE 7 + ABS(CONVERT(integer, LOG10(CambioMax)))
                           END 
    
	create table #TEMP_FINAL 
	(
		IdTabla numeric(5) identity(1,1) not null,
		TCambioCod varchar(1) collate database_default,
		MonONom varchar(80) collate database_default,
		MonOTCod varchar(1) collate database_default,
		MonOCod varchar(30) collate database_default,
		MonOCant numeric(19,10),
		MonDNom varchar(80) collate database_default,
		MonDTCod varchar(1) collate database_default,
		MonDCod varchar(30) collate database_default,
		MonDCant numeric(19,10),
		CodMonedaOrigen numeric(5),
		CodMonedaDestino numeric(5)
	)
    
    --devuelvo datos
	insert into #TEMP_FINAL (TCambioCod, MonONom, MonOTCod, MonOCod, MonOCant, MonDNom, MonDTCod, MonDCod, MonDCant, CodMonedaOrigen, CodMonedaDestino)
    SELECT  DISTINCT TipoDeCambioCod,
            dbo.fnSacarCaracteresEspXML(ISNULL(MONORI.Descripcion, '')) AS MOrigenNombre,
			CASE WHEN MONORI.CodCAFCI IS NULL THEN 'P'
                 ELSE 'C'
            END AS MOrigenTCod,
			COALESCE(MONORI.CodCAFCI, MONORI.CodInterfaz, MONORI.CodUIF, '') AS MOrigenCod,
            CambioOrigen * POWER(10, FactorCambio) AS MOrigenQ,
			
			dbo.fnSacarCaracteresEspXML(ISNULL(MONDES.Descripcion, '')) AS MDestinoNombre,
            CASE WHEN MONDES.CodCAFCI IS NULL THEN 'P'
                 ELSE 'C'
            END AS MDestinoTCod,
            COALESCE(MONDES.CodCAFCI, MONDES.CodInterfaz, MONDES.CodUIF, '') AS MDestinoCod,
            
            CambioDestino * POWER(10, FactorCambio) AS MDestinoQ,
            MONORI.CodMoneda CodMonedaOrigen,
            MONDES.CodMoneda CodMonedaDestino
            
    FROM    #CAFCIUNIFICADA_TPCAMBIO
            INNER JOIN MONEDAS MONORI ON MONORI.CodMoneda = #CAFCIUNIFICADA_TPCAMBIO.CodMonedaOrigen
            INNER JOIN MONEDAS MONDES ON MONDES.CodMoneda = #CAFCIUNIFICADA_TPCAMBIO.CodMonedaDestino


	insert into #CAFCIUNIFICADA_Tag_TCambio (CampoXml)
	select '<TCambios>'
	
	if (select count(*) from #TEMP_FINAL)> 0
	begin
		insert into #CAFCIUNIFICADA_Tag_TCambio (CampoXml)
		select 
			'<TCambio>' +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(convert(varchar,TCambioCod),'')),'') = '' then '<TCambioCod/>' else '<TCambioCod>' + dbo.fnSacarCaracteresEspXML(coalesce(TCambioCod,'')) + '</TCambioCod>' end +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(MonONom,'')),'') = '' then '<MonONom/>' else '<MonONom>' + dbo.fnSacarCaracteresEspXML(coalesce(MonONom,'')) + '</MonONom>' end +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(MonOTCod,'')),'') = '' then '<MonOTCod/>' else '<MonOTCod>' + dbo.fnSacarCaracteresEspXML(coalesce(MonOTCod,'')) + '</MonOTCod>' end +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(MonOCod,'')),'') = '' then '<MonOCod/>' else '<MonOCod>' + dbo.fnSacarCaracteresEspXML(coalesce(MonOCod,'')) + '</MonOCod>' end  +
			case when coalesce(convert(varchar,coalesce(convert(numeric(10,2),MonOCant),0)),'')='' then '<MonOCant/>' else '<MonOCant>' + convert(varchar,coalesce(convert(numeric(10,2),MonOCant),0)) + '</MonOCant>' end +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(MonDNom,'')),'') = '' then '<MonDNom/>' else '<MonDNom>' + dbo.fnSacarCaracteresEspXML(coalesce(MonDNom,'')) + '</MonDNom>' end +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(MonDTCod,'')),'') = '' then '<MonDTCod/>' else '<MonDTCod>' + dbo.fnSacarCaracteresEspXML(coalesce(MonDTCod,'')) + '</MonDTCod>' end  +
			case when coalesce(dbo.fnSacarCaracteresEspXML(coalesce(MonDCod,'')),'') = '' then '<MonDCod/>' else '<MonDCod>' + dbo.fnSacarCaracteresEspXML(coalesce(MonDCod,'')) + '</MonDCod>' end +
			case when coalesce(convert(varchar,coalesce(convert(numeric(10,2),MonDCant),0)),'')='' then '<MonDCant/>' else '<MonDCant>' + convert(varchar,coalesce(convert(numeric(10,2),MonDCant),0)) + '</MonDCant>' end  +
			'</TCambio>'
		from #TEMP_FINAL
	end
	else
	begin
		insert into #CAFCIUNIFICADA_Tag_TCambio (CampoXml)
		select 
			'<TCambio>' +
			'<TCambioCod/>' +
			'<MonONom/>' +
			'<MonOTCod/>' +
			'<MonOCod/>' +
			'<MonOCant/>' +
			'<MonDNom/>' +
			'<MonDTCod/>' +
			'<MonDCod/>' +
			'<MonDCant/>' +
			'</TCambio>'
	end
	
	insert into #CAFCIUNIFICADA_Tag_TCambio (CampoXml)
	select '</TCambios>'
	

go



exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Activo_Especie'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Activo_Especie
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @EsVendedor	Boolean
	DECLARE @CodMonedaCursoLgl CodigoMedio
	DECLARE @ParamLetesMixtas Boolean
	
	select @ParamLetesMixtas = ValorParametro FROM PARAMETROS WHERE CodParametro = 'CSLRMM'

	select @CodMonedaCursoLgl = CodMonedaCursoLgl from PARAMETROSREL

	--variables CURSOR
	DECLARE @Cur_CodEspecie CodigoLargo
	DECLARE @Cur_MonCoti CodigoMedio
	DECLARE @Cur_MonFdo CodigoMedio
	DECLARE @Cur_TpCambio Precio

	 --temporal para las partidas compradas de cedears
	CREATE TABLE #CAFCISEMANAL_PARTIDAS_COMPRADAS_CEDEAR
		(CodFondo Numeric(6) NOT NULL, 
		CodEspecie Numeric(10) NOT NULL, 
		TotalCompras Numeric(10), Cantidad Numeric(28,10),  
		CantidadTotalVenta Numeric(28,10), 
		CantidadTotalCompra Numeric(28,10), 
		CantidadDisponible  Numeric(28,10), 
		FechaConcertacion smalldatetime NOT NULL, 
		ID Numeric(10) not null identity, 
		PRIMARY KEY (CodFondo, CodEspecie, FechaConcertacion, ID) )

    -- temporales para ESPECIES que no son LETES
    CREATE TABLE #CAFCISEMANAL_ABREVESP
       (ID numeric(10) identity(1,1),
	   CodEspecie numeric(10) NOT NULL,
        CodTpAbreviatura varchar(2) COLLATE database_default  NULL,
		CodMoneda numeric(10)  NULL,
        Descripcion varchar(30) COLLATE database_default NOT NULL,
        UnidadesPorCotizacion numeric(22, 10) NULL,
		CodTpTickerCAFCI varchar(6) COLLATE database_default NULL,
        OrdenTicker Numeric(10),
        PrimerTicker Numeric(10))

	-- temporales para las COTIZACIONES de las LETRAS del TESORO
    CREATE TABLE #CAFCISEMANAL_COTILETRAS
       (CodFondo Numeric(6) NOT NULL, 
		CodEspecie numeric(10) NOT NULL,
		CodMoneda numeric(10)  NULL,
		Cotizacion numeric(19,10) null,
		FactConvMonPtdaCotFdo numeric(16,10),
		PPP numeric(19,10),
		InteresDia numeric(19,2),
		CotizacionFdo numeric(16,10))
	
    INSERT INTO #CAFCISEMANAL_ABREVESP(CodEspecie, Descripcion, UnidadesPorCotizacion, CodTpTickerCAFCI, OrdenTicker)
    SELECT  distinct CodEspecie, IsinCode, 1, 'I', 1
    FROM    ESPECIES
	WHERE ESPECIES.EstaAnulado = 0 AND NOT IsinCode IS NULL  and 
		(ESPECIES.FechaVencimiento >= @FechaProceso or ESPECIES.FechaVencimiento is null) and
		ESPECIES.CodEspecie IN (SELECT DISTINCT CodEspecie FROM TITULOS WHERE EstaActivo = -1 and CodFondo = @CodFondo)

    INSERT INTO #CAFCISEMANAL_ABREVESP(CodEspecie, Descripcion, UnidadesPorCotizacion, CodTpTickerCAFCI, OrdenTicker)
    SELECT  distinct CodEspecie, COALESCE(CodCAFCI, CodInterfaz), 1, 'M', 2
    FROM    ESPECIES
	WHERE ESPECIES.EstaAnulado = 0 AND (NOT CodCAFCI IS NULL OR NOT CodInterfaz IS NULL) and 
		(ESPECIES.FechaVencimiento >= @FechaProceso or ESPECIES.FechaVencimiento is null)  and
		ESPECIES.CodEspecie IN (SELECT DISTINCT CodEspecie FROM TITULOS WHERE EstaActivo = -1 and CodFondo = @CodFondo)


    INSERT INTO #CAFCISEMANAL_ABREVESP(CodEspecie, Descripcion, UnidadesPorCotizacion, CodTpTickerCAFCI, OrdenTicker, CodMoneda)
		SELECT  distinct ABREVESP.CodEspecie, dbo.fnSacarCaracteresEspXML(ABREVESP.Descripcion), TipoCotizacion, (CASE CodTpAbreviatura 
									WHEN 'FT' THEN 'B' 
									WHEN 'MA' THEN 'E'
									WHEN 'BL' THEN 'BL'
									WHEN 'RT' THEN 'R'
									ELSE 'P' -- 'ML' 'MN' 'SR'
								END),
						(CASE CodTpAbreviatura 
									WHEN 'FT' THEN 3
									WHEN 'MA' THEN 4
									WHEN 'BL' THEN 5
									WHEN 'RT' THEN 6
									ELSE 7 -- 'ML' 'MN' 'SR'
								END
								)            , 
								ABREVESP.CodMoneda
		FROM    ABREVIATURASESP ABREVESP
		inner join ESPECIES on ESPECIES.CodEspecie = ABREVESP.CodEspecie
		WHERE ABREVESP.EstaAnulado = 0 AND
			(ESPECIES.FechaVencimiento >= @FechaProceso or ESPECIES.FechaVencimiento is null)  and
			ESPECIES.CodEspecie IN (SELECT DISTINCT CodEspecie FROM TITULOS WHERE EstaActivo = -1 and CodFondo = @CodFondo)

    DELETE #CAFCISEMANAL_ABREVESP
    FROM #CAFCISEMANAL_ABREVESP
    INNER JOIN ESPECIES ON ESPECIES.CodEspecie = #CAFCISEMANAL_ABREVESP.CodEspecie
        and  NOT ESPECIES.CodTpTickerCAFCI IS NULL
    WHERE ESPECIES.CodTpTickerCAFCI <> #CAFCISEMANAL_ABREVESP.CodTpTickerCAFCI

    UPDATE #CAFCISEMANAL_ABREVESP
        SET PrimerTicker = (SELECT MIN(OrdenTicker) FROM #CAFCISEMANAL_ABREVESP interno WHERE interno.CodEspecie = #CAFCISEMANAL_ABREVESP.CodEspecie)
   
    DELETE #CAFCISEMANAL_ABREVESP
    FROM #CAFCISEMANAL_ABREVESP
    WHERE OrdenTicker <> PrimerTicker

   
    DELETE #CAFCISEMANAL_ABREVESP
    FROM #CAFCISEMANAL_ABREVESP
	where ID > (select MIN(ID)     FROM #CAFCISEMANAL_ABREVESP  ABREVESP WHERE #CAFCISEMANAL_ABREVESP.CodEspecie = ABREVESP.CodEspecie) AND 
		CodEspecie 
		IN (select CodEspecie FROM #CAFCISEMANAL_ABREVESP GROUP BY CodEspecie
	having COUNT(*) > 1)

	-- temporales para ESPECIES que son LETES
    CREATE TABLE #CAFCISEMANAL_LETENO
           (CodEspecie numeric(10) NOT NULL)

    CREATE TABLE #CAFCISEMANAL_PARTIDASLETE
           (CodFondo numeric(5) NOT NULL,
            CodEspecie numeric(10) NOT NULL,
            Cantidad numeric(22, 10) NOT NULL,
            PrecioInicial numeric(19,10) NULL,
            CodMonedaInicial numeric(6) NULL,
            Precio numeric(19,10) NULL,
			FactorConvOperFdo numeric(19, 10) NULL,
			InformaLetesMixtasComoMercado numeric(1))
      
	--DEVENGAMIENTO: Dentro de periodo de remanencia (Informa campos FeOr, TNA y TDFeDe)
	/*
	Si @ParamLetesMixtas = 0 se toman las Letes en período de remanencia
	Si @ParamLetesMixtas = -1 se toman TODAS las Letes que NO cumplan al mismo tiempo las siguientes condiciones:
		- En período de remanencia
		- Mixtas
	*/
    INSERT  #CAFCISEMANAL_LETENO (CodEspecie)
    SELECT  PARTIDAS.CodEspecie
    FROM    PARTIDAS
            LEFT  JOIN PARTIDASTIT ON PARTIDASTIT.CodFondo = PARTIDAS.CodFondo AND PARTIDASTIT.CodPartida = PARTIDAS.CodPartida AND PARTIDASTIT.Fecha <= @FechaProceso AND PARTIDASTIT.EstaAnulado = 0 
            INNER JOIN ESPECIES ON ESPECIES.CodEspecie = PARTIDAS.CodEspecie AND ESPECIES.FechaVencimiento >= @FechaProceso
			LEFT JOIN TPPAPVALUACION ON ESPECIES.CodTpPapValuacion = TPPAPVALUACION.CodTpPapValuacion
			LEFT JOIN TPVALUACIONESPFDO 
				INNER JOIN TPPAPVALUACION TPPAPVALUACIONFDO ON TPVALUACIONESPFDO.CodTpPapValuacion = TPPAPVALUACIONFDO.CodTpPapValuacion            
			ON TPVALUACIONESPFDO.CodFondo = @CodFondo				
    WHERE   PARTIDAS.CodFondo = @CodFondo
     AND (DATEDIFF(day, @FechaProceso, ESPECIES.FechaVencimiento) < COALESCE(ESPECIES.TiempoRemanencia,0))
     AND NOT (@ParamLetesMixtas = -1 AND COALESCE(TPVALUACIONESPFDO.TpValuacionMixta, ESPECIES.TpValuacionMixta)=-1)
    GROUP BY PARTIDAS.CodFondo, PARTIDAS.CodEspecie, PARTIDAS.CodPartida
    HAVING SUM(PARTIDASTIT.Cantidad) <> 0.000

	
	--MERCADO: Fuera de periodo de remanencia (No informa campos FeOr, TNA y TDFeDe)
	/*
	Si @ParamLetesMixtas = 0 se toman las Letes Fuera del período de remanencia
	Si @ParamLetesMixtas = -1 se toman las Letes que CUMPLEN al mismo tiempo las siguientes condiciones:
		- En período de remanencia
		- Mixtas
	*/	
    INSERT  #CAFCISEMANAL_PARTIDASLETE (CodFondo, CodEspecie, Cantidad, PrecioInicial, CodMonedaInicial, Precio, InformaLetesMixtasComoMercado)
    SELECT  PARTIDAS.CodFondo,
            PARTIDAS.CodEspecie,
            SUM(PARTIDASTIT.Cantidad) AS Cantidad,
            COALESCE(PARTIDAS.Precio, (CASE WHEN ESPECIES.CodMoneda = COTIZACIONESESP.CodMoneda THEN 1
                                           ELSE COTIZACIONESESP.FactorConversion END) * COTIZACIONESESP.Cotizacion, 0) AS PrecioInicial,
            ISNULL(COTIZACIONESESP.CodMoneda, ESPECIES.CodMoneda) AS CodMonedaInicial,
            ISNULL(PARTIDASCOTI.Cotizacion, PARTIDAS.Precio) AS Precio,
            CASE WHEN (@ParamLetesMixtas = -1 AND COALESCE(TPVALUACIONESPFDO.TpValuacionMixta, ESPECIES.TpValuacionMixta)=-1) THEN -1 ELSE 0 END as InformaLetesMixtasComoMercado                        
    FROM    PARTIDAS
            LEFT  JOIN FONDOS ON FONDOS.CodFondo=PARTIDAS.CodFondo
            LEFT  JOIN PARTIDASTIT ON PARTIDASTIT.CodFondo = PARTIDAS.CodFondo AND PARTIDASTIT.CodPartida = PARTIDAS.CodPartida AND PARTIDASTIT.Fecha <= @FechaProceso AND PARTIDASTIT.EstaAnulado = 0 
            LEFT  JOIN PARTIDASCOTI ON PARTIDASCOTI.CodFondo = PARTIDASTIT.CodFondo AND PARTIDASCOTI.CodPartida = PARTIDASTIT.CodPartida AND PARTIDASCOTI.Fecha = @FechaProceso           
            INNER JOIN ESPECIES ON ESPECIES.CodEspecie = PARTIDAS.CodEspecie AND ESPECIES.FechaVencimiento >= @FechaProceso
			LEFT JOIN TPPAPVALUACION ON ESPECIES.CodTpPapValuacion = TPPAPVALUACION.CodTpPapValuacion
			LEFT JOIN TPVALUACIONESPFDO 
				INNER JOIN TPPAPVALUACION TPPAPVALUACIONFDO ON TPVALUACIONESPFDO.CodTpPapValuacion = TPPAPVALUACIONFDO.CodTpPapValuacion            
			ON TPVALUACIONESPFDO.CodFondo = @CodFondo
            LEFT  JOIN COTIZACIONESESP
                ON COTIZACIONESESP.CodEspecie = PARTIDAS.CodEspecie
                AND COTIZACIONESESP.Fecha = (SELECT TOP 1 MAX(Fecha)
                                                FROM    COTIZACIONESESP COTMAX
                                                WHERE   COTMAX.CodEspecie = COTIZACIONESESP.CodEspecie
                                                    AND COTMAX.Fecha <= DATEADD(day, COALESCE(ESPECIES.TiempoRemanencia,0) * -1, ESPECIES.FechaVencimiento))			
				AND COTIZACIONESESP.CodRueda = (
												SELECT TOP 1 CodRueda FROM VALORESCPITPAP 
												WHERE VALORESCPITPAP.CodFondo 	=@CodFondo 
												AND VALORESCPITPAP.CodEspecie 	= PARTIDAS.CodEspecie 
												AND VALORESCPITPAP.Fecha 		= COTIZACIONESESP.Fecha
												AND VALORESCPITPAP.CodSerie IS NULL
												)
    WHERE   PARTIDAS.CodFondo = @CodFondo
      AND ((DATEDIFF(day, @FechaProceso, ESPECIES.FechaVencimiento) >= COALESCE(ESPECIES.TiempoRemanencia,0))
       OR (@ParamLetesMixtas = -1 
		   and (DATEDIFF(day, @FechaProceso, ESPECIES.FechaVencimiento) < COALESCE(ESPECIES.TiempoRemanencia,0)) 
		   AND COALESCE(TPVALUACIONESPFDO.TpValuacionMixta, ESPECIES.TpValuacionMixta)=-1))
      GROUP BY PARTIDAS.CodPartida, PARTIDAS.CodFondo, PARTIDAS.CodEspecie, PARTIDAS.Precio, PARTIDASCOTI.Cotizacion, ESPECIES.CodMoneda, FONDOS.CodMoneda,
			ESPECIES.TpValuacionMixta, TPVALUACIONESPFDO.TpValuacionMixta,
            COTIZACIONESESP.Cotizacion, COTIZACIONESESP.CodMoneda, COTIZACIONESESP.CodMercado, COTIZACIONESESP.FactorConversion,
            PARTIDAS.FactConvMonPtdaFdo
     HAVING SUM(PARTIDASTIT.Cantidad) <> 0.000


    --temporal para ajustar Precio
    CREATE TABLE #CAFCISEMANAL_FACCAM
       (CodEspecie numeric(10) NOT NULL,
        Cantidad numeric(22, 10) NOT NULL,
        UnidadesPorCotizacion numeric(22, 10) NOT NULL,
        Precio numeric(19, 10) NULL,
        Enteros integer NULL,
        Decimales integer NULL,
        FactorCambio numeric(2) NULL,
        FechaCompra smalldatetime NULL,
        FechaUltMovim smalldatetime NULL,
        ValuaADevengamiento numeric(1),
		CodMonedaCoti numeric(5) NULL,
		CodTpFuentePrecio varchar(6) null,
		FactorConvOperFdo      numeric(19,10) NULL,		
        TpCambio varchar(1) COLLATE database_default NULL)

    --------------
    --temporal para ajustar Precio
	exec dbo.spOCAFCISemanalCartera_CEDEARS @CodFondo, @FechaProceso
	--temporal para Cotizaciones de Letras
	exec dbo.spOCAFCISemanalCartera_CotizacionLetras @CodFondo, @FechaProceso

   
    --ESPECIES que no son LETES ni Futuros
    INSERT  INTO #CAFCISEMANAL_FACCAM (CodEspecie, Cantidad, UnidadesPorCotizacion, Precio, ValuaADevengamiento,CodMonedaCoti,FechaCompra, CodTpFuentePrecio, FactorConvOperFdo)
    SELECT  distinct VALORESCPITPAP.CodEspecie,
            VALORESCPITPAP.Cantidad,
            1 AS UnidadesPorCotizacion,
            VALORESCPITPAP.CotizacionCarga AS Precio,
            0,
			VALORESCPITPAP.CodMonedaCoti,
			null FechaCompra,
			VALORESCPITPAP.CodTpFuentePrecio,
			VALORESCPITPAP.FactorConversion
    FROM    VALORESCPITPAP
            INNER JOIN FONDOS ON FONDOS.CodFondo = VALORESCPITPAP.CodFondo
            INNER JOIN ESPECIES ON ESPECIES.CodEspecie = VALORESCPITPAP.CodEspecie
            LEFT  JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
            LEFT  JOIN TPPAPEL ON TPPAPEL.CodTpPapel = TPESPECIE.CodTpPapel
    WHERE   VALORESCPITPAP.CodFondo = @CodFondo
        AND VALORESCPITPAP.Fecha = @FechaProceso
        AND VALORESCPITPAP.CodSerie IS NULL
        AND NOT ISNULL(TPPAPEL.CodTpPapel,'') IN ('LE', 'FU', 'CD', 'CB')
   UNION ALL
	
	----Agregar la rueda -*-
	SELECT #CAFCISEMANAL_PARTIDAS_COMPRADAS_CEDEAR.CodEspecie
		,#CAFCISEMANAL_PARTIDAS_COMPRADAS_CEDEAR.CantidadDisponible
        ,    1 AS UnidadesPorCotizacion
        ,VALORESCPITPAP.CotizacionCarga AS Precio
		,0
		,VALORESCPITPAP.CodMonedaCoti AS CodMonedaCoti
		,FechaConcertacion FechaCompra -- Antes decia FechaConcertacion pero no se a que hace referencia ahora le puse la Fecha de la tabla VALORESCPITPAP
		,VALORESCPITPAP.CodTpFuentePrecio
		,VALORESCPITPAP.FactorConversion
	FROM dbo.#CAFCISEMANAL_PARTIDAS_COMPRADAS_CEDEAR
	INNER JOIN FONDOS ON FONDOS.CodFondo = #CAFCISEMANAL_PARTIDAS_COMPRADAS_CEDEAR.CodFondo
	INNER JOIN ESPECIES ON ESPECIES.CodEspecie = #CAFCISEMANAL_PARTIDAS_COMPRADAS_CEDEAR.CodEspecie
	LEFT  JOIN #CAFCISEMANAL_ABREVESP ABREV ON ABREV.CodEspecie = #CAFCISEMANAL_PARTIDAS_COMPRADAS_CEDEAR.CodEspecie
	LEFT JOIN VALORESCPITPAP ON VALORESCPITPAP.CodFondo = @CodFondo
        AND VALORESCPITPAP.Fecha = @FechaProceso
		AND VALORESCPITPAP.CodEspecie = #CAFCISEMANAL_PARTIDAS_COMPRADAS_CEDEAR.CodEspecie
		AND VALORESCPITPAP.CodSerie IS NULL
		
		
    UNION ALL
    SELECT  distinct #CAFCISEMANAL_PARTIDASLETE.CodEspecie,
            #CAFCISEMANAL_PARTIDASLETE.Cantidad,
            1 AS UnidadesPorCotizacion,
			VALORESCPITPAP.CotizacionCarga AS Precio
			,0
			,VALORESCPITPAP.CodMonedaCoti AS CodMonedaCoti
			,VALORESCPITPAP.Fecha FechaCompra
			,VALORESCPITPAP.CodTpFuentePrecio
			,VALORESCPITPAP.FactorConversion
    FROM    #CAFCISEMANAL_PARTIDASLETE
            INNER JOIN FONDOS ON FONDOS.CodFondo = #CAFCISEMANAL_PARTIDASLETE.CodFondo
            INNER JOIN ESPECIES ON ESPECIES.CodEspecie = #CAFCISEMANAL_PARTIDASLETE.CodEspecie
            LEFT  JOIN #CAFCISEMANAL_ABREVESP ABREV ON ABREV.CodEspecie = #CAFCISEMANAL_PARTIDASLETE.CodEspecie
			LEFT JOIN VALORESCPITPAP ON VALORESCPITPAP.CodFondo = @CodFondo
			AND VALORESCPITPAP.Fecha = @FechaProceso
			AND VALORESCPITPAP.CodEspecie = #CAFCISEMANAL_PARTIDASLETE.CodEspecie
			AND VALORESCPITPAP.CodSerie IS NULL
            LEFT  JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
            LEFT  JOIN TPPAPEL ON TPPAPEL.CodTpPapel = TPESPECIE.CodTpPapel
			LEFT JOIN #CAFCISEMANAL_COTILETRAS 
				ON #CAFCISEMANAL_COTILETRAS.CodFondo = FONDOS.CodFondo
				AND #CAFCISEMANAL_COTILETRAS.CodEspecie = ESPECIES.CodEspecie 
    WHERE   #CAFCISEMANAL_PARTIDASLETE.CodFondo = @CodFondo
        AND ISNULL(TPPAPEL.CodTpPapel,'') IN ('LE')
        AND #CAFCISEMANAL_PARTIDASLETE.CodEspecie NOT IN (SELECT CodEspecie FROM #CAFCISEMANAL_LETENO)

	
    --calcule factores para el ajuste de precios
    UPDATE  #CAFCISEMANAL_FACCAM
    SET     Enteros = CASE WHEN UnidadesPorCotizacion >= 1
                              THEN LEN(CONVERT(integer, ROUND(UnidadesPorCotizacion, 0, 1)))
                              ELSE 0
                         END,
            Decimales = LEN(LTRIM(RTRIM(REPLACE(CONVERT(varchar(15), (Precio - ROUND(Precio, 0, 1))), '0', ' ')))) - 1

    UPDATE  #CAFCISEMANAL_FACCAM
    SET     FactorCambio = CASE WHEN Decimales > 4
                                THEN CASE WHEN (10 - Enteros) > (Decimales - 4)
                                          THEN (Decimales - 4)
                                          ELSE (10 - Enteros)
                                     END
                                ELSE 0
                           END

    UPDATE  #CAFCISEMANAL_FACCAM
    SET     FechaUltMovim = (SELECT MAX(FechaConcertacion) FROM TITULOS 
                              WHERE CodEspecie=#CAFCISEMANAL_FACCAM.CodEspecie
                                AND Cantidad > 0 
                                AND EstaActivo = -1
                                AND FechaConcertacion <= @FechaProceso)
    FROM    #CAFCISEMANAL_FACCAM

    UPDATE  #CAFCISEMANAL_FACCAM
    SET     FechaCompra = COALESCE((SELECT MAX(Fecha) FROM VALORESCPITPAP COTIZANT 
                                     WHERE COTIZANT.CodFondo = @CodFondo 
                                       AND COTIZANT.CodEspecie = #CAFCISEMANAL_FACCAM.CodEspecie
                                       AND COTIZANT.Fecha < @FechaProceso),@FechaProceso),
            ValuaADevengamiento = -1
    FROM    #CAFCISEMANAL_FACCAM
    INNER JOIN ESPECIES ON ESPECIES.CodEspecie=#CAFCISEMANAL_FACCAM.CodEspecie
    LEFT JOIN TPPAPVALUACION ON ESPECIES.CodTpPapValuacion = TPPAPVALUACION.CodTpPapValuacion
    LEFT JOIN TPVALUACIONESPFDO 
        INNER JOIN TPPAPVALUACION TPPAPVALUACIONFDO ON TPVALUACIONESPFDO.CodTpPapValuacion = TPPAPVALUACIONFDO.CodTpPapValuacion
    ON TPVALUACIONESPFDO.CodFondo = @CodFondo
        and TPVALUACIONESPFDO.CodEspecie = ESPECIES.CodEspecie
        AND TPVALUACIONESPFDO.EstaAnulado = 0                       
    WHERE (COALESCE(TPPAPVALUACIONFDO.CodTpValuacion, TPPAPVALUACION.CodTpValuacion) <> 'MD'
      AND COALESCE(TPVALUACIONESPFDO.TpValuacionMixta, ESPECIES.TpValuacionMixta)=0)
	
	
	update #CAFCISEMANAL_FACCAM
		set TpCambio = TipoDeCambioCod
	from #CAFCISEMANAL_FACCAM
	inner join #CAFCIUNIFICADA_TPCAMBIO ON #CAFCIUNIFICADA_TPCAMBIO.CodMonedaOrigen = #CAFCISEMANAL_FACCAM.CodMonedaCoti
	where #CAFCIUNIFICADA_TPCAMBIO.CodMonedaDestino = dbo.fnMonFondo(@CodFondo)
		and  ROUND((CambioDestino / CambioOrigen),4) = ROUND(FactorConvOperFdo,4)
	
	----TIPO DE CAMBIO
   DECLARE cursor_TpCambio cursor for
	SELECT	distinct #CAFCISEMANAL_FACCAM.CodMonedaCoti
	FROM #CAFCISEMANAL_FACCAM
	where TpCambio is null

    OPEN cursor_TpCambio

    FETCH NEXT FROM cursor_TpCambio INTO @Cur_MonFdo

    WHILE @@FETCH_STATUS = 0
    BEGIN
		
		SELECT @Cur_TpCambio = MIN(CambioDestino / CambioOrigen) FROM #CAFCIUNIFICADA_TPCAMBIO where CodMonedaOrigen = @Cur_MonFdo
		
		SELECT @EsVendedor = (case when TipoDeCambioCod = 'V' then -1 ELSE 0 END)
		FROM #CAFCIUNIFICADA_TPCAMBIO 
		where CodMonedaOrigen = @Cur_MonFdo 
			and ROUND((CambioDestino / CambioOrigen), 4) = ROUND(@Cur_TpCambio,4)
		
        UPDATE #CAFCISEMANAL_FACCAM
			SET FactorConvOperFdo = @Cur_TpCambio,
				TpCambio = (case when (@EsVendedor = -1) then 'V' ELSE 'C' END)
		WHERE CodMonedaCoti = @Cur_MonFdo 
			and TpCambio is null
			

		FETCH NEXT FROM cursor_TpCambio INTO @Cur_MonFdo
    END

    CLOSE cursor_TpCambio
    DEALLOCATE cursor_TpCambio
	--*****
	
	--select * from #CAFCISEMANAL_ABREVESP
	insert into #TEMP_ACTIVOS(CodEspecie, CodPapel, Nro,
		ActTTic,ActTic,ActNom,EntENom,EntONom,MerTCod,MerCod,MerNom,MonActTCod,
		MonActCod,MonActNom,Cant,CantCot,Pre,MtoMAct,TCCod,MtoMFdo,Cl,SCl,FeOr,
		TNA,TDFDev,ClId,AA,CodImpAct,NomClImp, NomSClImp, NomImpAct,
		PaisNomEmi, PaisNomEmiTCod, PaisNomEmiCod, PaisNomNeg, PaisNomNegTCod, PaisNomNegCod, CtaCteRem,
		ASNom,ASTic,ASTTic,OrigenActivo)

  	--SE ENGLOBA UNION EN UN SELECT PORA COMPATIBILIZAR SQL2005 - SQL2000
   SELECT  VALORESCPITPAP.CodEspecie,
            TPPAPEL.CodTpPapel,
			0 as Nro,
            ABREV.CodTpTickerCAFCI AS TTCod,
            dbo.fnSacarCaracteresEspXML(ABREV.Descripcion) AS TNom,
            dbo.fnSacarCaracteresEspXML(COALESCE(ESPECIES.Descripcion, '')) AS AcNomCor,
            ISNULL(MEROPER.Descripcion, '') AS EENom,
            '' AS EONom,
			(CASE WHEN VALORESCPITPAP.CodTpFuentePrecio = 'VFAUT' THEN
                'C'
    --         WHEN NOT COTIZACIONESESPFDO.Cotizacion IS NULL AND COTIZACIONESESPFDO.EsCotizacionAutomatica = 0 AND COTIZACIONESESP.Cotizacion IS NULL  THEN
				--'C'
            ELSE
                CASE WHEN NOT COALESCE(MERCOTI.CodCAFCI, '') = '' THEN 'C' ELSE 'P' END 
            END) AS MeTCod,
			(CASE WHEN VALORESCPITPAP.CodTpFuentePrecio = 'VFAUT' THEN
                'NA'
    --           WHEN NOT COTIZACIONESESPFDO.Cotizacion IS NULL AND COTIZACIONESESPFDO.EsCotizacionAutomatica = 0 AND COTIZACIONESESP.Cotizacion IS NULL THEN
				--COALESCE(MERCOTIFDO.CodCAFCI, MERCOTIFDO.CodInterfaz, '') 
            ELSE
                COALESCE(MERCOTI.CodCAFCI, MERCOTI.CodInterfaz, '') 
            END)AS MeCod, 
            dbo.fnSacarCaracteresEspXML(ISNULL(MERCOTI.Descripcion, '')) AS MeNom,
            'C' AS MoTCod,
			COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '') AS MoCod,
			dbo.fnSacarCaracteresEspXML(ISNULL(MONCOTI.Descripcion, '')) AS MoNom,
            (CASE WHEN NOT TPPAPEL.CodTpPapel IN ('CD', 'CB')  THEN
					VALORESCPITPAP.Cantidad 
			 ELSE
			     #CAFCISEMANAL_FACCAM.Cantidad
			 END)AS Q,
             1 * POWER(10, FactorCambio) AS QC,
            VALORESCPITPAP.CotizacionCarga * POWER(10, FactorCambio) AS P,
            (CASE WHEN NOT TPPAPEL.CodTpPapel IN ('CD', 'CB')  THEN
				VALORESCPITPAP.Cantidad  
			else	
				#CAFCISEMANAL_FACCAM.Cantidad
			end) * VALORESCPITPAP.CotizacionCarga AS MontoMO,
            COALESCE(#CAFCISEMANAL_FACCAM.TpCambio,'N') AS TCCod,

            (CASE WHEN NOT TPPAPEL.CodTpPapel IN ('CD', 'CB')  THEN
				VALORESCPITPAP.Cantidad 			else	
				#CAFCISEMANAL_FACCAM.Cantidad
			end) * VALORESCPITPAP.Cotizacion AS MontoMF,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPESPECIE.Descripcion, '')) AS ClNom,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPPAPEL.Descripcion, '')) AS SClNom,
            (CASE WHEN NOT TPPAPEL.CodTpPapel IN ('CD', 'CB')  THEN
			    (CASE WHEN VALORESCPITPAP.CodTpFuentePrecio	= 'VFAUT' AND #CAFCISEMANAL_FACCAM.ValuaADevengamiento=-1 THEN
				    #CAFCISEMANAL_FACCAM.FechaUltMovim 
			    ELSE
				    NULL
			    END)
			 ELSE
			     #CAFCISEMANAL_FACCAM.FechaCompra
			 END) AS FeOr,
            (CASE WHEN VALORESCPITPAP.CodTpFuentePrecio	= 'VFAUT' AND #CAFCISEMANAL_FACCAM.ValuaADevengamiento=-1 THEN
	            VALORESCPITPAP.TNA 
			ELSE NULL END ) AS TNA,
			(CASE WHEN VALORESCPITPAP.CodTpFuentePrecio	= 'VFAUT' AND #CAFCISEMANAL_FACCAM.ValuaADevengamiento=-1 THEN
				#CAFCISEMANAL_FACCAM.FechaCompra 
			ELSE
				NULL
			END) as TDFeDe,
			VALORESCPITPAP.CodEspecie,
			dbo.fnFechaOperaciones(ESPECIES.CodEspecie,@FechaProceso) as 'AA',
			dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
			dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIP.Descripcion,'')) as NomClImp, 
			dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.Descripcion,'')) as NomSClImp, 
			dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.Descripcion,'')) as NomImpAct,
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISEMI.Descripcion,'')) as PaisNomEmi, 
			case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, 
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISEMI.CodCAFCI,'')) as PaisNomEmiCod, 
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISMERCADO.Descripcion,'')) as PaisNomNeg, 
			case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, 
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISMERCADO.CodCAFCI,'')) as PaisNomNegCod,
			'' as CtaCteRem,
			'' AS ASNom,
			'' AS ASTic,
			'' AS ASTTic,
			'ESPECIES' as OrigenActivo
    FROM    VALORESCPITPAP
            INNER JOIN FONDOS ON FONDOS.CodFondo = VALORESCPITPAP.CodFondo
            INNER JOIN ESPECIES ON ESPECIES.CodEspecie = VALORESCPITPAP.CodEspecie
			INNER JOIN EMISORES ON EMISORES.CodEmisor = ESPECIES.CodEmisor
			INNER JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais
			LEFT JOIN MERCADOS 
				inner join PAISES PAISMERCADO on PAISMERCADO.CodPais = MERCADOS.CodPais
				ON MERCADOS.CodMercado = ESPECIES.CodMercadoOperacion 
            INNER JOIN #CAFCISEMANAL_FACCAM ON #CAFCISEMANAL_FACCAM.CodEspecie = ESPECIES.CodEspecie			
            LEFT  JOIN MERCADOS MEROPER ON MEROPER.CodMercado = ESPECIES.CodMercadoOperacion
			LEFT JOIN #CAFCISEMANAL_ABREVESP ABREV ON ABREV.CodEspecie = VALORESCPITPAP.CodEspecie 
			--and 
			--	VALORESCPITPAP.CodMonedaCoti = COALESCE(ABREV.CodMoneda, VALORESCPITPAP.CodMonedaCoti)
            LEFT  JOIN MERCADOS MERCOTI ON MERCOTI.CodMercado = VALORESCPITPAP.CodMercado
            LEFT  JOIN MONEDAS MONCOTI ON MONCOTI.CodMoneda = VALORESCPITPAP.CodMonedaCoti
            LEFT  JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
            LEFT  JOIN TPPAPEL ON TPPAPEL.CodTpPapel = TPESPECIE.CodTpPapel
			LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = ESPECIES.CodTpActivoAfipIt 
			LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
    WHERE   VALORESCPITPAP.CodFondo = @CodFondo
        AND VALORESCPITPAP.Fecha = @FechaProceso
        AND VALORESCPITPAP.CodSerie IS NULL
        AND NOT ISNULL(TPPAPEL.CodTpPapel,'') IN ('FU') --, 'LE')


		insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
		select IdTabla, '<Entidades><Entidad>
				<TipoEntNom>Entidad Emisora</TipoEntNom>
				<TipoEntId>13</TipoEntId>
				<EntNom>' + dbo.fnSacarCaracteresEspXML(coalesce(EMISORES.Descripcion,'')) + '</EntNom>
				<EntTic/>
				<EntTTic/>
				<PaisNom>' + dbo.fnSacarCaracteresEspXML(COALESCE(PAISES.Descripcion,''))  + '</PaisNom>
				<PaisTCod>' + case when coalesce(PAISES.CodCAFCI,'') <> '' then 'C' else '' end + '</PaisTCod>
				<PaisCod>' + dbo.fnSacarCaracteresEspXML(coalesce(PAISES.CodCAFCI,'')) + '</PaisCod>
				<ActNom/>
				<ActNomId/>
				</Entidad></Entidades>'
		from #TEMP_ACTIVOS
			INNER JOIN ESPECIES ON ESPECIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie 
			INNER JOIN EMISORES ON EMISORES.CodEmisor = ESPECIES.CodEmisor 
			INNER JOIN PAISES ON PAISES.CodPais = EMISORES.CodPais 
		where OrigenActivo like 'ESPECIES'

		create table #CAFCI_FECHAS
		(
			CodEspecie numeric(10) not null,
			TipoFechaId varchar(1) collate database_default not null,
			TipoFechaNom varchar(80) collate database_default not null,
			FechaDato smalldatetime not null
		)

		insert into #CAFCI_FECHAS (CodEspecie, TipoFechaId, TipoFechaNom, FechaDato)
		select #TEMP_ACTIVOS.CodEspecie, '1', 'Emisión del Activo',ESPECIES.FechaEmision 
		from #TEMP_ACTIVOS
			INNER JOIN  ESPECIES  
				ON ESPECIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie
		where not ESPECIES.FechaEmision is null and OrigenActivo like 'ESPECIES'
		union all
		select #TEMP_ACTIVOS.CodEspecie, '2', 'Vencimiento del Activo',ESPECIES.FechaVencimiento 
		from #TEMP_ACTIVOS
			INNER JOIN  ESPECIES  
				ON ESPECIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie
		where not ESPECIES.FechaVencimiento is null and OrigenActivo like 'ESPECIES'
		

		
		declare @MaxIdTabla numeric(10)
		declare @MinIdTabla numeric(10)

		select @MaxIdTabla = max(IdTabla) from #TEMP_ACTIVOS
		select @MinIdTabla = min(IdTabla) from #TEMP_ACTIVOS

		/*--'RG 796 - Informa abreviaturas anuladas.'*/
		DECLARE @PARAMETRO_ABREVIATURAS_ANULADAS Boolean
		SELECT @PARAMETRO_ABREVIATURAS_ANULADAS = ValorParametro FROM PARAMETROS WHERE CodParametro = 'ABR796'	
		/**/

		while @MinIdTabla <= @MaxIdTabla
		begin
			
			/*FECHAS*/
			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				SELECT @MinIdTabla, '<Fechas>'

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select IdTabla, case when coalesce(#CAFCI_FECHAS.TipoFechaNom,'') <> '' then
				'<Fecha>'+
				'<TipoFechaNom>' + #CAFCI_FECHAS.TipoFechaNom + '</TipoFechaNom>'+
				'<FechaDato>' + convert(varchar(10),#CAFCI_FECHAS.FechaDato,120) + '</FechaDato>'+
				'<TipoFechaId>' + #CAFCI_FECHAS.TipoFechaId + '</TipoFechaId>'+
				'</Fecha>'
				else
				'<Fecha><TipoFechaNom/><FechaDato/><TipoFechaId/></Fecha>'
				end
				from #TEMP_ACTIVOS
				LEFT join #CAFCI_FECHAS
				on #CAFCI_FECHAS.CodEspecie = #TEMP_ACTIVOS.CodEspecie
				where OrigenActivo like 'ESPECIES' and IdTabla = @MinIdTabla

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				SELECT @MinIdTabla, '</Fechas>'

			/*******/
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select @MinIdTabla, '<Tickers>'
				
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select IdTabla, case when COALESCE(IsinCode,'') <> '' then 
								'<Ticker>' +
								'<ActTicEnt>ISIN</ActTicEnt>'+
								case when coalesce(ESPECIES.IsinCode,'') = '' then '<ActTic/>' else '<ActTic>' + ltrim(rtrim(dbo.fnSacarCaracteresEspXML(coalesce(ESPECIES.IsinCode,''))))  + '</ActTic>' end +
								'<ActTTicId>I</ActTTicId>'+
								case when coalesce(MONEDAS.CodCAFCI,'') = '' then '<ActMonCotId/>' else '<ActMonCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MONEDAS.CodCAFCI,'')) + '</ActMonCotId>' end +
								case when coalesce(MERCADOS.CodCAFCI,'') = '' then '<ActMerCotId/>' else '<ActMerCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MERCADOS.CodCAFCI,'')) + '</ActMerCotId>' end +
								'</Ticker>'
								end
				from #TEMP_ACTIVOS
					INNER JOIN  ESPECIES  
						ON ESPECIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie
					inner join MONEDAS 
						ON MONEDAS.CodMoneda = ESPECIES.CodMoneda 
					LEFT JOIN MERCADOS
						ON MERCADOS.CodMercado = ESPECIES.CodMercadoOperacion 
				where OrigenActivo like 'ESPECIES' and IdTabla = @MinIdTabla
			
			
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select IdTabla, '<Ticker>' +
						'<ActTicEnt>' + CASE ABREVIATURASESP.CodTpAbreviatura 
										WHEN 'ML' THEN 'CAFCI'
										WHEN 'FT' THEN 'BCBA' 
										ELSE dbo.fnSacarCaracteresEspXML(coalesce(TPABREVIATURA.Descripcion,'')) 
									END + '</ActTicEnt>' +
						'<ActTic>' + dbo.fnSacarCaracteresEspXML(coalesce(ABREVIATURASESP.Descripcion,'')) + '</ActTic>' +
						'<ActTTicId>' + CASE ABREVIATURASESP.CodTpAbreviatura 
										WHEN 'FT' THEN 'B' 
										WHEN 'MA' THEN 'E'
										WHEN 'BL' THEN 'BL'
										WHEN 'RT' THEN 'R'
										WHEN 'ML' THEN 'M'
										ELSE 'P' -- 'ML' 'MN' 'SR'
									END  + '</ActTTicId>' +
						case when coalesce(MONEDAS.CodCAFCI,'') = '' then '<ActMonCotId/>' else '<ActMonCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MONEDAS.CodCAFCI,'')) + '</ActMonCotId>' end +
						case when coalesce(MERCADOS.CodCAFCI,'') = '' then '<ActMerCotId/>' else '<ActMerCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MERCADOS.CodCAFCI,'')) + '</ActMerCotId>' end +
						'</Ticker>'
				from #TEMP_ACTIVOS
					INNER JOIN  ABREVIATURASESP 
						ON ABREVIATURASESP.CodEspecie = #TEMP_ACTIVOS.CodEspecie
					INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASESP.CodMercado 
						and MERCADOS.EstaAnulado = 0
					INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
						AND PAISES.EstaAnulado = 0
					INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
						AND MERCOD.EstaAnulado = 0
					INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASESP.CodMoneda
						AND MONEDAS.EstaAnulado = 0
					INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura 
				where OrigenActivo like 'ESPECIES' and IdTabla = @MinIdTabla
				AND (ABREVIATURASESP.EstaAnulado = 0 OR ABREVIATURASESP.EstaAnulado = @PARAMETRO_ABREVIATURAS_ANULADAS)
			
			
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select @MinIdTabla, '</Tickers>'

			select @MinIdTabla = @MinIdTabla + 1
		end 

go



exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Activo_Lete'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Activo_Lete
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as

	DECLARE @CodPais           CodigoMedio
    DECLARE @FechaLiquidez     Fecha
	DECLARE @Parametro		   Boolean
    DECLARE @EsVendedor	Boolean
	DECLARE @ParamLetesMixtas Boolean
	
	select @ParamLetesMixtas = ValorParametro FROM PARAMETROS WHERE CodParametro = 'CSLRMM'    

	--variables CURSOR
	DECLARE @Cur_CodEspecie CodigoLargo
	DECLARE @Cur_MonCoti CodigoMedio
	DECLARE @Cur_MonFdo CodigoMedio
	DECLARE @Cur_TpCambio Precio

	DECLARE @CodMonedaCursoLgl CodigoMedio
	select @CodMonedaCursoLgl = CodMonedaCursoLgl from PARAMETROSREL

    SELECT  @CodPais = CodPais FROM PARAMETROSREL
    SELECT @Parametro = ValorParametro FROM PARAMETROS WHERE CodParametro = 'COTESP'

    EXEC sp_dfxSumarDiasHabiles @FechaProceso, 1, @FechaLiquidez OUTPUT, @CodPais


    CREATE TABLE #CAFCISEMANAL_PARTIDASLETE
           (CodPartida numeric(15) NOT NULL,
			CodFondo numeric(5) NOT NULL,
            CodEspecie numeric(10) NOT NULL,
            Cantidad numeric(22, 10) NOT NULL,
            PrecioInicial numeric(19, 10) NOT NULL,
            CodMonedaInicial numeric(5) NOT NULL,
            CodMercadoInicial numeric(5) NOT NULL,
            Precio numeric(19, 10) NOT NULL,
            FechaCompra datetime,
            FechaDevengamiento datetime,
			FactorConvOperFdo numeric(19, 10) NULL)
    
    INSERT  #CAFCISEMANAL_PARTIDASLETE (CodPartida, CodFondo, CodEspecie, Cantidad, PrecioInicial, CodMonedaInicial, CodMercadoInicial, Precio, FechaCompra, FechaDevengamiento,FactorConvOperFdo)
    SELECT  PARTIDAS.CodPartida,
            PARTIDAS.CodFondo,
            PARTIDAS.CodEspecie,
            SUM(PARTIDASTIT.Cantidad) AS Cantidad,
            COALESCE(VALORESCPITPAP.CotizacionCarga, (CASE WHEN ESPECIES.CodMoneda = VALORESCPITPAP.CodMonedaCoti THEN 1
                                           ELSE VALORESCPITPAP.FactorConversion END) * VALORESCPITPAP.CotizacionCarga, 0) AS PrecioInicial,
            ISNULL(VALORESCPITPAP.CodMonedaCoti, ESPECIES.CodMoneda) AS CodMonedaInicial,
            -1 AS CodMercadoInicial,
            ISNULL(VALORESCPITPAP.CotizacionCarga, 0) AS Precio,
            ISNULL(PARTIDAS.Fecha, DATEADD(day, COALESCE(ESPECIES.TiempoRemanencia,0) * -1, ESPECIES.FechaVencimiento)) AS FechaCompra,
            COALESCE(VALORESCPITPAP.Fecha, DATEADD(day, COALESCE(ESPECIES.TiempoRemanencia,0) * -1, ESPECIES.FechaVencimiento)) + (CASE FONDOS.CodTpDevengamiento WHEN 'ED' THEN 1 WHEN 'LD' THEN 1 ELSE 0 END) AS FechaDevengamiento,
			CASE WHEN COALESCE(PARTIDAS.Precio,0) <> 0 THEN PARTIDAS.FactConvMonPtdaFdo ELSE (CASE WHEN @Parametro = 0 THEN					
														VALORESCPITPAP.FactorConversion
													   ELSE NULL END) END AS FactorConvOperFdo
    FROM    PARTIDAS
	INNER JOIN VALORESCPITPAP ON VALORESCPITPAP.CodFondo = PARTIDAS.CodFondo
		and VALORESCPITPAP.CodEspecie = PARTIDAS.CodEspecie
		and VALORESCPITPAP.Fecha = @FechaProceso

            INNER JOIN FONDOS ON FONDOS.CodFondo = PARTIDAS.CodFondo 
            LEFT  JOIN PARTIDASTIT ON PARTIDASTIT.CodFondo = PARTIDAS.CodFondo 
				AND PARTIDASTIT.CodPartida = PARTIDAS.CodPartida 
				AND PARTIDASTIT.Fecha <= @FechaProceso 
				AND PARTIDASTIT.EstaAnulado = 0 
            LEFT  JOIN PARTIDASCOTI ON PARTIDASCOTI.CodFondo = PARTIDASTIT.CodFondo 
				AND PARTIDASCOTI.CodPartida = PARTIDASTIT.CodPartida 
				AND PARTIDASCOTI.Fecha = @FechaProceso
            INNER JOIN ESPECIES 
                INNER JOIN TPESPECIE ON TPESPECIE.CodTpPapel = 'LE' AND TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
            ON ESPECIES.CodEspecie = PARTIDAS.CodEspecie AND ESPECIES.FechaVencimiento >= @FechaProceso
			LEFT JOIN TPPAPVALUACION ON ESPECIES.CodTpPapValuacion = TPPAPVALUACION.CodTpPapValuacion
			LEFT JOIN TPVALUACIONESPFDO 
				INNER JOIN TPPAPVALUACION TPPAPVALUACIONFDO ON TPVALUACIONESPFDO.CodTpPapValuacion = TPPAPVALUACIONFDO.CodTpPapValuacion
			ON TPVALUACIONESPFDO.CodFondo = @CodFondo  AND TPVALUACIONESPFDO.EstaAnulado = 0                                                                                                     
    WHERE   PARTIDAS.CodFondo = @CodFondo
        AND ((DATEDIFF(day, @FechaProceso, ESPECIES.FechaVencimiento) < COALESCE(ESPECIES.TiempoRemanencia,0))
        AND NOT (@ParamLetesMixtas = -1 AND COALESCE(TPVALUACIONESPFDO.TpValuacionMixta, ESPECIES.TpValuacionMixta)=-1))       
    GROUP BY PARTIDAS.CodPartida, PARTIDAS.CodFondo, PARTIDAS.CodEspecie, PARTIDAS.CodPartida, PARTIDAS.Precio, PARTIDAS.Fecha,
            ESPECIES.CodMoneda, ESPECIES.FechaVencimiento, ESPECIES.CodMercadoOperacion,
            PARTIDASCOTI.Cotizacion, PARTIDASCOTI.FactConvMonPtdaCotFdo,PARTIDASCOTI.Fecha , VALORESCPITPAP.CotizacionCarga,VALORESCPITPAP.Fecha,
            VALORESCPITPAP.CodMonedaCoti, VALORESCPITPAP.FactorConversion,
            FONDOS.CodTpDevengamiento, ESPECIES.TiempoRemanencia, FONDOS.CodMoneda, PARTIDAS.FactConvMonPtdaFdo, PARTIDAS.Fecha
    HAVING SUM(PARTIDASTIT.Cantidad) <> 0.000

	

    CREATE TABLE #CAFCISEMANAL_ABREVLETE
       (CodEspecie numeric(10) NOT NULL,
        CodTpAbreviatura varchar(2) COLLATE database_default  NOT NULL,
        Abreviatura varchar(30) COLLATE database_default  NOT NULL,
		CodTpTickerCAFCI varchar(6) COLLATE database_default NULL)

    INSERT  #CAFCISEMANAL_ABREVLETE(CodEspecie, CodTpAbreviatura, Abreviatura)
		SELECT  DISTINCT ABREVLETE.CodEspecie, dbo.fnSacarCaracteresEspXML(coalesce(CodTpAbreviatura,'')), dbo.fnSacarCaracteresEspXML(coalesce(Descripcion,''))
		FROM    ABREVIATURASESP ABREVLETE
				INNER JOIN #CAFCISEMANAL_PARTIDASLETE ON #CAFCISEMANAL_PARTIDASLETE.CodEspecie = ABREVLETE.CodEspecie
		WHERE EstaAnulado = 0
	--    WHERE   Descripcion IN (SELECT TOP 1 Descripcion FROM ABREVIATURASESP WHERE EstaAnulado = 0 AND CodEspecie = ABREVLETE.CodEspecie ORDER BY CASE CodTpAbreviatura WHEN 'FT' THEN (CASE EsDefault WHEN -1 THEN 1 ELSE 2 END) WHEN 'MA' THEN 3 WHEN 'BL' THEN 4 WHEN 'RT' THEN 5 ELSE 6 END ASC)
	--        AND CodTpAbreviatura IN (SELECT TOP 1 CodTpAbreviatura FROM ABREVIATURASESP WHERE EstaAnulado = 0 AND CodEspecie = ABREVLETE.CodEspecie ORDER BY CASE CodTpAbreviatura WHEN 'FT' THEN (CASE EsDefault WHEN -1 THEN 1 ELSE 2 END) WHEN 'MA' THEN 3 WHEN 'BL' THEN 4 WHEN 'RT' THEN 5 ELSE 6 END ASC)
		ORDER BY ABREVLETE.CodEspecie

	--
	UPDATE #CAFCISEMANAL_ABREVLETE
	SET CodTpTickerCAFCI =	CASE CodTpAbreviatura 
								WHEN 'FT' THEN 'B'
								WHEN 'MA' THEN 'E'
								WHEN 'BL' THEN 'BL'
								WHEN 'RT' THEN 'R'
								ELSE 'P' -- 'ML' 'MN' 'SR'
							END
	--	

    --temporal para ajustar Precio
    CREATE TABLE #CAFCISEMANAL_FACCAM
       (CodPartida numeric(10) NOT NULL,
        CodEspecie numeric(10) NOT NULL,
        Precio numeric(19, 10) NOT NULL,
        Enteros integer NULL,
        Decimales integer NULL,
        FactorCambio numeric(2) NULL,
		CodMonedaCoti numeric(5) NULL,
		FactorConvOperFdo      numeric(19,10) NULL,		
        TpCambio varchar(1) COLLATE database_default NULL)

    INSERT  INTO #CAFCISEMANAL_FACCAM (CodPartida, CodEspecie, Precio,CodMonedaCoti,FactorConvOperFdo)
    SELECT  DISTINCT #CAFCISEMANAL_PARTIDASLETE.CodPartida,
            #CAFCISEMANAL_PARTIDASLETE.CodEspecie,
            #CAFCISEMANAL_PARTIDASLETE.PrecioInicial,
			ESPECIES.CodMoneda,
			#CAFCISEMANAL_PARTIDASLETE.FactorConvOperFdo
    FROM    #CAFCISEMANAL_PARTIDASLETE
            INNER JOIN FONDOS ON FONDOS.CodFondo = #CAFCISEMANAL_PARTIDASLETE.CodFondo
            INNER JOIN ESPECIES ON ESPECIES.CodEspecie = #CAFCISEMANAL_PARTIDASLETE.CodEspecie
    WHERE   #CAFCISEMANAL_PARTIDASLETE.CodFondo = @CodFondo

    --calcule factores para el ajuste de precios
    UPDATE  #CAFCISEMANAL_FACCAM
    SET     Enteros = 1,
            Decimales = LEN(LTRIM(RTRIM(REPLACE(CONVERT(varchar(15), (Precio - ROUND(Precio, 0, 1))), '0', ' ')))) - 1

    UPDATE  #CAFCISEMANAL_FACCAM
    SET     FactorCambio = CASE WHEN Decimales > 4
                                THEN CASE WHEN (10 - Enteros) > (Decimales - 4)
                                          THEN (Decimales - 4)
                                          ELSE (10 - Enteros)
                                     END
                                ELSE 0
                           END


	--TIPO DE CAMBIO
    DECLARE cursor_Cambio cursor for
		SELECT	#CAFCISEMANAL_FACCAM.CodEspecie,
				#CAFCISEMANAL_FACCAM.CodMonedaCoti,
				FONDOS.CodMoneda
		FROM #CAFCISEMANAL_FACCAM
		INNER JOIN FONDOS ON FONDOS.CodFondo = @CodFondo

    OPEN cursor_Cambio

    FETCH NEXT FROM cursor_Cambio INTO @Cur_CodEspecie, @Cur_MonCoti, @Cur_MonFdo
    
    WHILE @@FETCH_STATUS = 0
    BEGIN

		IF @Parametro=0 BEGIN
		   IF @CodMonedaCursoLgl <>@Cur_MonFdo  
			  SELECT @EsVendedor = -1
			ELSE 
			  SELECT @EsVendedor = 0

			UPDATE #CAFCISEMANAL_FACCAM
			SET TpCambio = (case when @EsVendedor = -1 then 'V' ELSE 'C' END)
			WHERE CodEspecie = @Cur_CodEspecie

		END
		ELSE BEGIN
			exec spXCalcularUltCambioActPas -1, @CodFondo, @Cur_MonCoti, @Cur_MonFdo,@FechaProceso , @Cur_TpCambio OUTPUT, @EsVendedor OUTPUT

			UPDATE #CAFCISEMANAL_FACCAM
			SET FactorConvOperFdo = @Cur_TpCambio,
				TpCambio = (case when @EsVendedor = -1 then 'V' ELSE 'C' END)
			WHERE CodEspecie = @Cur_CodEspecie

		END

		FETCH NEXT FROM cursor_Cambio INTO @Cur_CodEspecie, @Cur_MonCoti, @Cur_MonFdo
    END

    CLOSE cursor_Cambio
    DEALLOCATE cursor_Cambio


    -- LETES
	
	insert into #TEMP_ACTIVOS(CodEspecie, CodPapel,		
		Nro,Cl,SCl,EntENom,EntONom,ActNom,ActTTic,ActTic,MerNom,MerTCod,MerCod,
		MonActNom,MonActTCod,MonActCod,Pre,Cant,CantCot,TCCod,MtoMAct,MtoMFdo,
		FeOr,FeVto,MtoAc,Plazo,TNA,TTasa,PFTra,PFPre,TDFDev,PFPreF,
		PFPreInm,DOFEj,DOPEj,DOSub,ML,ClId,AA,CodImpAct,NomClImp, NomSClImp, NomImpAct,
		PaisNomEmi, PaisNomEmiTCod, PaisNomEmiCod, PaisNomNeg, PaisNomNegTCod, PaisNomNegCod, CtaCteRem,
		ASNom,ASTic,ASTTic,OrigenActivo)

    SELECT  #CAFCISEMANAL_PARTIDASLETE.CodEspecie,
            TPPAPEL.CodTpPapel,
			0 as Nro,
			dbo.fnSacarCaracteresEspXML(ISNULL(TPESPECIE.Descripcion, '')) AS Cl,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPPAPEL.Descripcion, '')) AS SCl,
			dbo.fnSacarCaracteresEspXML(ISNULL(MEROPER.Descripcion, '')) AS EntENom,
            '' AS EntONom,
			dbo.fnSacarCaracteresEspXML(COALESCE(ESPECIES.Descripcion, '')) AS ActNom,
			CASE WHEN (NOT ESPECIES.CodTpTickerCAFCI IS NULL AND NOT ABVTPTICKER.Abreviatura IS NULL) THEN dbo.fnSacarCaracteresEspXML(coalesce(ESPECIES.CodTpTickerCAFCI,''))
			ELSE
				CASE	WHEN NOT IsinCode IS NULL                   THEN 'I'
						WHEN NOT ESPECIES.CodCAFCI IS NULL          THEN 'M'
						WHEN NOT ABREV.CodTpAbreviatura IS NULL		THEN ABREV.CodTpTickerCAFCI
				END 
			END AS ActTTic,
            dbo.fnSacarCaracteresEspXML(COALESCE(ABVTPTICKER.Abreviatura, IsinCode, ESPECIES.CodCAFCI, ABREV.Abreviatura, ESPECIES.CodInterfaz, '')) AS ActTic,
            dbo.fnSacarCaracteresEspXML(ISNULL(MERCOTI.Descripcion, '')) AS MerNom,
            'C' AS MerTCod,
			'NA' AS MerCod,
			dbo.fnSacarCaracteresEspXML(ISNULL(MONCOTI.Descripcion, '')) AS MonActNom,
			'C' AS MonActTCod,            
            dbo.fnSacarCaracteresEspXML(COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '')) as MonActCod,
			#CAFCISEMANAL_PARTIDASLETE.PrecioInicial * POWER(10, FactorCambio) AS Pre,
			#CAFCISEMANAL_PARTIDASLETE.Cantidad AS Cant,
			1 * POWER(10, FactorCambio) AS CantCot,
			COALESCE(#CAFCISEMANAL_FACCAM.TpCambio,'N') AS TCCod,
			ABS(#CAFCISEMANAL_PARTIDASLETE.PrecioInicial * #CAFCISEMANAL_PARTIDASLETE.Cantidad) AS MtoMAct,
			ABS((CASE #CAFCISEMANAL_PARTIDASLETE.Precio 
                       WHEN 0 THEN #CAFCISEMANAL_PARTIDASLETE.PrecioInicial * COALESCE(#CAFCISEMANAL_FACCAM.FactorConvOperFdo,1)
                       ELSE        #CAFCISEMANAL_PARTIDASLETE.Precio
                 END) * #CAFCISEMANAL_PARTIDASLETE.Cantidad)

                / (CASE WHEN @Parametro = 0 THEN (
					(CASE WHEN @CodMonedaCursoLgl <> FONDOS.CodMoneda THEN 
															ISNULL(COTOP.CambioVendedor, 1) 
														ELSE 
															ISNULL(COTOP.CambioComprador, 1)
														end) *
					(CASE WHEN @CodMonedaCursoLgl <> FONDOS.CodMoneda THEN 
															ISNULL(COTFDO.CambioVendedor, 1) 
														ELSE 
															ISNULL(COTFDO.CambioComprador, 1) 
														end))
										  ELSE 	COALESCE(#CAFCISEMANAL_FACCAM.FactorConvOperFdo,1)
										  END)
			AS MtoMFdo,
            #CAFCISEMANAL_PARTIDASLETE.FechaCompra AS FeOr,
			null as FeVto,
			ABS((CASE #CAFCISEMANAL_PARTIDASLETE.Precio WHEN 0 THEN (#CAFCISEMANAL_PARTIDASLETE.PrecioInicial * COALESCE(#CAFCISEMANAL_FACCAM.FactorConvOperFdo,1)) 
															   ELSE #CAFCISEMANAL_PARTIDASLETE.Precio END) * #CAFCISEMANAL_PARTIDASLETE.Cantidad) AS MtoAc,
			0 as Plazo,
			365 * ( ((1/CASE #CAFCISEMANAL_PARTIDASLETE.PrecioInicial WHEN 0 THEN 1 ELSE #CAFCISEMANAL_PARTIDASLETE.PrecioInicial END) -1)
                    /(CASE DATEDIFF(day, #CAFCISEMANAL_PARTIDASLETE.FechaDevengamiento, ESPECIES.FechaVencimiento) WHEN 0 THEN 1 ELSE DATEDIFF(day, #CAFCISEMANAL_PARTIDASLETE.FechaDevengamiento, ESPECIES.FechaVencimiento) END)
            ) * 100 AS TNA,
			'' as TTasa,
			'' as PFTra,
			'' as PFPre,
			(CASE WHEN DATEDIFF(d, @FechaProceso, #CAFCISEMANAL_PARTIDASLETE.FechaCompra) = 0 THEN #CAFCISEMANAL_PARTIDASLETE.FechaCompra ELSE #CAFCISEMANAL_PARTIDASLETE.FechaDevengamiento END) AS TDFDev,
			null as PFPreF,
            '' as PFPreInm,
			null as DOFEj,
            0 as DOPEj,
			'' as DOSub,
			CASE ESPECIES.FechaVencimiento WHEN @FechaLiquidez THEN 'S' ELSE 'N' END as ML,
			#CAFCISEMANAL_PARTIDASLETE.CodEspecie ClId,
			dbo.fnFechaOperaciones(ESPECIES.CodEspecie,@FechaProceso) as 'AA',
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIP.Descripcion,'')) as NomClImp, 
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomSClImp, 
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomImpAct,
			dbo.fnSacarCaracteresEspXML(coalesce(PAISEMI.Descripcion,'')) as PaisNomEmi, 
			case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(PAISEMI.CodCAFCI,'')) as PaisNomEmiCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(PAISMERCADO.Descripcion,'')) as PaisNomNeg, 
			case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(PAISMERCADO.CodCAFCI,'')) as PaisNomNegCod,
			'' as CtaCteRem,
			'' AS ASNom,
			'' AS ASTic,
			'' AS ASTTic,
			'LETE' as OrigenActivo
    FROM    #CAFCISEMANAL_PARTIDASLETE
            INNER JOIN FONDOS ON FONDOS.CodFondo = #CAFCISEMANAL_PARTIDASLETE.CodFondo
            INNER JOIN ESPECIES ON ESPECIES.CodEspecie = #CAFCISEMANAL_PARTIDASLETE.CodEspecie
			INNER JOIN EMISORES ON EMISORES.CodEmisor = ESPECIES.CodEmisor
			INNER JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais
			LEFT JOIN MERCADOS 
				inner join PAISES PAISMERCADO on PAISMERCADO.CodPais = MERCADOS.CodPais
				ON MERCADOS.CodMercado = ESPECIES.CodMercadoOperacion 
            INNER JOIN #CAFCISEMANAL_FACCAM ON #CAFCISEMANAL_FACCAM.CodEspecie = #CAFCISEMANAL_PARTIDASLETE.CodEspecie AND #CAFCISEMANAL_FACCAM.CodPartida = #CAFCISEMANAL_PARTIDASLETE.CodPartida
			--
			LEFT JOIN #CAFCISEMANAL_ABREVLETE ABVTPTICKER ON ABVTPTICKER.CodTpTickerCAFCI = ESPECIES.CodTpTickerCAFCI
					AND ABVTPTICKER.CodEspecie = ESPECIES.CodEspecie
			
            LEFT JOIN #CAFCISEMANAL_ABREVLETE ABREV ON ABREV.CodEspecie = #CAFCISEMANAL_PARTIDASLETE.CodEspecie	
					AND ABREV.CodTpTickerCAFCI = (CASE WHEN (NOT ESPECIES.CodTpTickerCAFCI IS NULL) THEN ESPECIES.CodTpTickerCAFCI
												ELSE
													CASE	WHEN NOT IsinCode IS NULL                   THEN 'I'
															WHEN NOT ESPECIES.CodCAFCI IS NULL          THEN 'M'
															WHEN NOT ABREV.CodTpAbreviatura IS NULL		THEN ABREV.CodTpTickerCAFCI
													END 
												END)
					AND ABREV.Abreviatura IN (SELECT TOP 1 Descripcion FROM ABREVIATURASESP WHERE EstaAnulado = 0 AND CodEspecie = ABREV.CodEspecie ORDER BY CASE CodTpAbreviatura WHEN 'FT' THEN (CASE EsDefault WHEN -1 THEN 1 ELSE 2 END) WHEN 'MA' THEN 3 WHEN 'BL' THEN 4 WHEN 'RT' THEN 5 ELSE 6 END ASC)
					AND ABREV.CodTpAbreviatura IN (SELECT TOP 1 CodTpAbreviatura FROM ABREVIATURASESP WHERE EstaAnulado = 0 AND CodEspecie = ABREV.CodEspecie ORDER BY CASE CodTpAbreviatura WHEN 'FT' THEN (CASE EsDefault WHEN -1 THEN 1 ELSE 2 END) WHEN 'MA' THEN 3 WHEN 'BL' THEN 4 WHEN 'RT' THEN 5 ELSE 6 END ASC)
			--
            LEFT  JOIN MERCADOS MEROPER ON MEROPER.CodMercado = ESPECIES.CodMercadoOperacion
            
            LEFT  JOIN COTIZACIONESMON ON COTIZACIONESMON.CodFondo = FONDOS.CodFondo AND COTIZACIONESMON.CodMoneda = FONDOS.CodMoneda
                   AND COTIZACIONESMON.Fecha = (SELECT  MAX(Fecha) FROM COTIZACIONESMON COTMAX
                                                WHERE   COTMAX.CodFondo = FONDOS.CodFondo AND COTMAX.CodMoneda = FONDOS.CodMoneda AND COTMAX.Fecha <= @FechaProceso)
            LEFT  JOIN MERCADOS MERCOTI ON MERCOTI.CodMercado = #CAFCISEMANAL_PARTIDASLETE.CodMercadoInicial
            LEFT  JOIN MONEDAS MONCOTI ON MONCOTI.CodMoneda = #CAFCISEMANAL_PARTIDASLETE.CodMonedaInicial
            LEFT  JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
            LEFT  JOIN TPPAPEL ON TPPAPEL.CodTpPapel = TPESPECIE.CodTpPapel
            LEFT  JOIN COTIZACIONESMON COTOP ON COTOP.CodFondo = #CAFCISEMANAL_PARTIDASLETE.CodFondo AND COTOP.CodMoneda = #CAFCISEMANAL_PARTIDASLETE.CodMonedaInicial AND COTOP.Fecha = @FechaProceso
            LEFT  JOIN COTIZACIONESMON COTFDO ON COTFDO.CodFondo = FONDOS.CodFondo AND COTFDO.CodMoneda = FONDOS.CodMoneda AND COTFDO.Fecha = @FechaProceso
			LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = ESPECIES.CodTpActivoAfipIt 
			LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
    WHERE   #CAFCISEMANAL_PARTIDASLETE.CodFondo = @CodFondo

	insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
		select IdTabla, '<Entidades><Entidad>
				<TipoEntNom/>
				<TipoEntId/>
				<EntNom/>
				<EntTic/>
				<EntTTic/>
				<PaisNom/>
				<PaisTCod/>
				<PaisCod/>
				<ActNom/>
				<ActNomId/>
				</Entidad></Entidades>'
		from #TEMP_ACTIVOS
		where OrigenActivo like 'LETE'
			
		create table #CAFCI_FECHAS
		(
			CodEspecie numeric(10) not null,
			TipoFechaId varchar(1) collate database_default not null,
			TipoFechaNom varchar(80) collate database_default not null,
			FechaDato smalldatetime not null
		)

		insert into #CAFCI_FECHAS (CodEspecie, TipoFechaId, TipoFechaNom, FechaDato)
		select #TEMP_ACTIVOS.CodEspecie, '1', 'Emisión del Activo',ESPECIES.FechaEmision 
		from #TEMP_ACTIVOS
			INNER JOIN  ESPECIES  
				ON ESPECIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie
		where not ESPECIES.FechaEmision is null and OrigenActivo like 'LETE'
		union all
		select #TEMP_ACTIVOS.CodEspecie, '2', 'Vencimiento del Activo',ESPECIES.FechaVencimiento 
		from #TEMP_ACTIVOS
			INNER JOIN  ESPECIES  
				ON ESPECIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie
		where not ESPECIES.FechaVencimiento is null and OrigenActivo like 'LETE'
		

		/*FECHAS*/
		IF EXISTS (SELECT 1 FROM #TEMP_ACTIVOS
								LEFT join #CAFCI_FECHAS
									on #CAFCI_FECHAS.CodEspecie = #TEMP_ACTIVOS.CodEspecie
							where OrigenActivo like 'LETE')
		BEGIN
			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				SELECT distinct IdTabla, '<Fechas>'
				from #TEMP_ACTIVOS
					LEFT join #CAFCI_FECHAS
						on #CAFCI_FECHAS.CodEspecie = #TEMP_ACTIVOS.CodEspecie
				where OrigenActivo like 'LETE'

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select IdTabla, case when coalesce(#CAFCI_FECHAS.TipoFechaNom,'') <> '' then 
						'<Fecha>'+
						'<TipoFechaNom>' + #CAFCI_FECHAS.TipoFechaNom + '</TipoFechaNom>'+
						'<FechaDato>' + convert(varchar(10),#CAFCI_FECHAS.FechaDato,120) + '</FechaDato>'+
						'<TipoFechaId>' + #CAFCI_FECHAS.TipoFechaId + '</TipoFechaId>'+
						'</Fecha>'
					else
						'<Fecha><TipoFechaNom/><FechaDato/><TipoFechaId/></Fecha>'
					end
				from #TEMP_ACTIVOS
					LEFT join #CAFCI_FECHAS
						on #CAFCI_FECHAS.CodEspecie = #TEMP_ACTIVOS.CodEspecie
				where OrigenActivo like 'LETE'

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				SELECT distinct IdTabla, '</Fechas>'
				from #TEMP_ACTIVOS
					LEFT join #CAFCI_FECHAS
						on #CAFCI_FECHAS.CodEspecie = #TEMP_ACTIVOS.CodEspecie
				where OrigenActivo like 'LETE'
		END
		
		/*--'RG 796 - Informa abreviaturas anuladas.'*/
		DECLARE @PARAMETRO_ABREVIATURAS_ANULADAS Boolean
		SELECT @PARAMETRO_ABREVIATURAS_ANULADAS = ValorParametro FROM PARAMETROS WHERE CodParametro = 'ABR796'	
		/**/

		/*TICKERS*/
		IF EXISTS (SELECT 1 FROM #TEMP_ACTIVOS
						INNER JOIN  ABREVIATURASESP 
							ON ABREVIATURASESP.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASESP.CodMercado 
							and MERCADOS.EstaAnulado = 0
						INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
							AND PAISES.EstaAnulado = 0
						INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
							AND MERCOD.EstaAnulado = 0
						INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASESP.CodMoneda
							AND MONEDAS.EstaAnulado = 0
						INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura 
				where OrigenActivo like 'LETE' )
		BEGIN								
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, '<Tickers>'
				from #TEMP_ACTIVOS
						INNER JOIN  ABREVIATURASESP 
							ON ABREVIATURASESP.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASESP.CodMercado 
							and MERCADOS.EstaAnulado = 0
						INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
							AND PAISES.EstaAnulado = 0
						INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
							AND MERCOD.EstaAnulado = 0
						INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASESP.CodMoneda
							AND MONEDAS.EstaAnulado = 0
						INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura 
				where OrigenActivo like 'LETE'
					
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select IdTabla, '<Ticker>' +
						'<ActTicEnt>' + CASE ABREVIATURASESP.CodTpAbreviatura 
										WHEN 'ML' THEN 'CAFCI'
										WHEN 'FT' THEN 'BCBA' 
										ELSE dbo.fnSacarCaracteresEspXML(coalesce(TPABREVIATURA.Descripcion,'')) 
									END + '</ActTicEnt>' +
						'<ActTic>' + dbo.fnSacarCaracteresEspXML(coalesce(ABREVIATURASESP.Descripcion,''))  + '</ActTic>' +
						'<ActTTicId>' + CASE ABREVIATURASESP.CodTpAbreviatura 
										WHEN 'FT' THEN 'B' 
										WHEN 'MA' THEN 'E'
										WHEN 'BL' THEN 'BL'
										WHEN 'RT' THEN 'R'
										WHEN 'ML' THEN 'M'
										ELSE 'P' -- 'ML' 'MN' 'SR'
									END  + '</ActTTicId>' +
						case when  coalesce(MONEDAS.CodCAFCI,'') = '' then '<ActMonCotId/>' else '<ActMonCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MONEDAS.CodCAFCI,'')) + '</ActMonCotId>' end +
						case when  coalesce(MERCADOS.CodCAFCI,'') = '' then '<ActMerCotId/>' else '<ActMerCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MERCADOS.CodCAFCI,'')) + '</ActMerCotId>' end +
						'</Ticker>'
				from #TEMP_ACTIVOS
					INNER JOIN  ABREVIATURASESP 
						ON ABREVIATURASESP.CodEspecie = #TEMP_ACTIVOS.CodEspecie
					INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASESP.CodMercado 
						and MERCADOS.EstaAnulado = 0
					INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
						AND PAISES.EstaAnulado = 0
					INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
						AND MERCOD.EstaAnulado = 0
					INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASESP.CodMoneda
						AND MONEDAS.EstaAnulado = 0
					INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura 
				where OrigenActivo like 'LETE'
				AND (ABREVIATURASESP.EstaAnulado = 0 OR ABREVIATURASESP.EstaAnulado = @PARAMETRO_ABREVIATURAS_ANULADAS)

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, '</Tickers>'
				from #TEMP_ACTIVOS
						INNER JOIN  ABREVIATURASESP 
							ON ABREVIATURASESP.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASESP.CodMercado 
							and MERCADOS.EstaAnulado = 0
						INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
							AND PAISES.EstaAnulado = 0
						INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
							AND MERCOD.EstaAnulado = 0
						INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASESP.CodMoneda
							AND MONEDAS.EstaAnulado = 0
						INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura 
			where OrigenActivo like 'LETE'
		END
go




exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Activo_Serie'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Activo_Serie
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @CodMonedaCursoLgl CodigoMedio
	DECLARE @Parametro		   Boolean
	DECLARE @EsVendedor		   Boolean

	--variables CURSOR
	DECLARE @Cur_CodSerie CodigoLargo
	DECLARE @Cur_CodEspecie CodigoLargo
	DECLARE @Cur_MonCoti CodigoMedio
	DECLARE @Cur_MonFdo CodigoMedio
	DECLARE @Cur_TpCambio Precio
	DECLARE @Cur_Fecha Fecha

	select @CodMonedaCursoLgl = CodMonedaCursoLgl from PARAMETROSREL
	
    -- temporales para SERIES
    CREATE TABLE #CAFCISEMANAL_ABREVSER
       (CodEspecie numeric(10) NOT NULL,
        CodSerie numeric(10) NOT NULL,
        CodTpAbreviatura varchar(2) COLLATE database_default  NOT NULL,
        Descripcion varchar(30) COLLATE database_default  NOT NULL,
        UnidadesPorCotizacion numeric(22, 10) NULL)

    INSERT INTO #CAFCISEMANAL_ABREVSER(CodEspecie, CodSerie, CodTpAbreviatura, Descripcion, UnidadesPorCotizacion)
		SELECT  ABREVSER.CodEspecie, ABREVSER.CodSerie, dbo.fnSacarCaracteresEspXML(coalesce(CodTpAbreviatura,'')), dbo.fnSacarCaracteresEspXML(coalesce(ABREVSER.Descripcion,'')), AccionesPorLote
		FROM    ABREVIATURASSER ABREVSER
				INNER JOIN SERIES ON SERIES.CodEspecie = ABREVSER.CodEspecie AND SERIES.CodSerie = ABREVSER.CodSerie
		WHERE   ABREVSER.Descripcion IN (SELECT TOP 1 Descripcion FROM ABREVIATURASSER WHERE EstaAnulado = 0 and CodEspecie = ABREVSER.CodEspecie AND CodSerie = ABREVSER.CodSerie ORDER BY CASE CodTpAbreviatura WHEN 'FT' THEN (CASE EsDefault WHEN -1 THEN 1 ELSE 2 END) WHEN 'MA' THEN 3 WHEN 'BL' THEN 4 WHEN 'RT' THEN 5 ELSE 6 END ASC)
			AND CodTpAbreviatura IN (SELECT TOP 1 CodTpAbreviatura FROM ABREVIATURASSER WHERE EstaAnulado = 0 and CodEspecie = ABREVSER.CodEspecie AND CodSerie = ABREVSER.CodSerie ORDER BY CASE CodTpAbreviatura WHEN 'FT' THEN (CASE EsDefault WHEN -1 THEN 1 ELSE 2 END) WHEN 'MA' THEN 3 WHEN 'BL' THEN 4 WHEN 'RT' THEN 5 ELSE 6 END ASC)
		ORDER BY ABREVSER.CodEspecie


    CREATE TABLE #CAFCISEMANAL_COTSER
       (CodEspecie numeric(10) NOT NULL,
        CodSerie numeric(10) NOT NULL,
        CodMoneda numeric(5) NOT NULL,
        Fecha datetime NOT NULL,
        FactorConversion numeric(16, 10) NOT NULL,
        Cotizacion numeric(19, 10) NOT NULL,
        CodMercado numeric(5) NOT NULL,
        TpCambio varchar(1) COLLATE database_default NULL)

    INSERT INTO #CAFCISEMANAL_COTSER (CodEspecie, CodSerie, CodMoneda, Fecha, FactorConversion, Cotizacion, CodMercado)
		SELECT  CodEspecie, CodSerie, COTSER.CodMoneda, Fecha, FactorConversion, Cotizacion, CodMercado
		FROM    COTIZACIONESSER COTSER INNER JOIN FONDOS ON FONDOS.CodFondo = @CodFondo
		WHERE   COTSER.CodMoneda = FONDOS.CodMoneda AND Fecha = @FechaProceso
		ORDER BY CodEspecie, CodSerie

    INSERT INTO #CAFCISEMANAL_COTSER (CodEspecie, CodSerie, CodMoneda, Fecha, FactorConversion, Cotizacion, CodMercado)
		SELECT  COTSER.CodEspecie, COTSER.CodSerie, COTSER.CodMoneda, COTSER.Fecha, COTSER.FactorConversion, COTSER.Cotizacion, COTSER.CodMercado
		FROM    COTIZACIONESSER COTSER INNER JOIN FONDOS ON FONDOS.CodFondo = @CodFondo LEFT  JOIN #CAFCISEMANAL_COTSER COTTMP ON COTTMP.CodEspecie = COTSER.CodEspecie AND COTTMP.CodSerie = COTSER.CodSerie
		WHERE   COTSER.CodMoneda <> FONDOS.CodMoneda AND COTSER.Fecha = @FechaProceso AND COTTMP.CodSerie IS NULL
		ORDER BY COTSER.CodEspecie, COTSER.CodSerie


	--TIPO DE CAMBIO
	SELECT @Parametro = ValorParametro FROM PARAMETROS WHERE CodParametro = 'COTESP'
    DECLARE cursor_Cambio cursor for
		SELECT	#CAFCISEMANAL_COTSER.CodSerie,
				#CAFCISEMANAL_COTSER.CodEspecie,
				#CAFCISEMANAL_COTSER.CodMoneda,
				FONDOS.CodMoneda,
				#CAFCISEMANAL_COTSER.Fecha
		FROM #CAFCISEMANAL_COTSER
		INNER JOIN FONDOS ON FONDOS.CodFondo = @CodFondo

    OPEN cursor_Cambio

    FETCH NEXT FROM cursor_Cambio INTO @Cur_CodSerie, @Cur_CodEspecie, @Cur_MonCoti, @Cur_MonFdo, @Cur_Fecha
    
    WHILE @@FETCH_STATUS = 0
    BEGIN

		IF @Parametro=0 BEGIN
		   IF @CodMonedaCursoLgl <>@Cur_MonFdo  
			  SELECT @EsVendedor = -1
			ELSE 
			  SELECT @EsVendedor = 0
		END
		ELSE BEGIN
        exec spXCalcularUltCambioActPas -1, @CodFondo, @Cur_MonCoti, @Cur_MonFdo,@Cur_Fecha , @Cur_TpCambio OUTPUT, @EsVendedor OUTPUT
		END


        UPDATE #CAFCISEMANAL_COTSER
		SET  TpCambio = (case when @EsVendedor = -1 then 'V' ELSE 'C' END)
		WHERE CodSerie = @Cur_CodSerie AND
			  CodEspecie = @Cur_CodEspecie AND
			  CodMoneda = @Cur_MonCoti AND
			  Fecha = @Cur_Fecha

		FETCH NEXT FROM cursor_Cambio INTO @Cur_CodSerie, @Cur_CodEspecie, @Cur_MonCoti, @Cur_MonFdo, @Cur_Fecha
    END

    CLOSE cursor_Cambio
    DEALLOCATE cursor_Cambio

	--*****

    --SERIES
	
	insert into #TEMP_ACTIVOS(CodEspecie, CodSerie, CodPapel,		
		Nro,Cl,SCl,EntENom,EntONom,ActNom,ActTTic,ActTic,MerNom,MerTCod,MerCod,
		MonActNom,MonActTCod,MonActCod,Pre,Cant,CantCot,TCCod,MtoMAct,MtoMFdo,
		FeOr,FeVto,MtoAc,Plazo,TNA,TTasa,PFTra,PFPre,TDFDev,PFPreF,
		PFPreInm,DOFEj,DOPEj,DOSub,ML,ClId,AA,CodImpAct,NomClImp, NomSClImp, NomImpAct,
		PaisNomEmi, PaisNomEmiTCod, PaisNomEmiCod, PaisNomNeg, PaisNomNegTCod, PaisNomNegCod, CtaCteRem,
		ASNom,ASTic,ASTTic,OrigenActivo)
    SELECT  VALORESCPITPAP.CodEspecie,
            VALORESCPITPAP.CodSerie,
            TPPAPEL.CodTpPapel,
			0 as Nro,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPESPECIE.Descripcion, '')) AS Cl,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPPAPEL.Descripcion, '')) AS SCl,
			dbo.fnSacarCaracteresEspXML(ISNULL(MEROPER.Descripcion, '')) AS EntENom,
            '' AS EntONom,
			COALESCE(SERIES.Descripcion, '') AS ActNom,
			CASE WHEN NOT SERIES.CodCAFCI IS NULL                               THEN 'M'
                 WHEN NOT ABREV.CodTpAbreviatura IS NULL
                      THEN CASE ABREV.CodTpAbreviatura
                                WHEN 'FT' THEN 'B'
                                WHEN 'MA' THEN 'E'
                                WHEN 'BL' THEN 'BL'
                                WHEN 'RT' THEN 'R'
                                ELSE 'P' -- 'ML' 'MN' 'SR'
                           END
                 ELSE 'P' --CodInterfaz
            END AS ActTTic,
			dbo.fnSacarCaracteresEspXML(COALESCE(SERIES.CodCAFCI, ABREV.Descripcion, SERIES.CodInterfaz, '')) AS ActTic,
			dbo.fnSacarCaracteresEspXML(ISNULL(MERCOTI.Descripcion, '')) AS MerNom,
			CASE WHEN NOT ISNULL(MERCOTI.CodCAFCI, '') = '' THEN 'C' ELSE 'P' END AS MerTCod,
			dbo.fnSacarCaracteresEspXML(COALESCE(MERCOTI.CodCAFCI, MERCOTI.CodInterfaz, '')) AS MerCod,
            dbo.fnSacarCaracteresEspXML(ISNULL(MONCOTI.Descripcion, '')) AS MonActNom,
            'C' AS MonActTCod,
            dbo.fnSacarCaracteresEspXML(COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '')) AS MonActCod,
            COALESCE(COTTMP.Cotizacion, 0) AS Pre,
            VALORESCPITPAP.Cantidad AS Cant,
            1 AS CantCot,
            COALESCE(COTTMP.TpCambio,'N') AS TCCod,
            COALESCE(COTTMP.Cotizacion, 0) * VALORESCPITPAP.Cantidad AS MtoMAct,            
            VALORESCPITPAP.Cotizacion * VALORESCPITPAP.Cantidad AS MtoMFdo,
			SERIES.FechaEmision AS FeOr,
			null as FeVto,
			0 as MtoAc,
            0 as Plazo,
			0 as TNA,
			'' as TTasa,
			'' as PFTra,
			'' as PFPre,
			null as TDFDev,
			null as PFPreF,
			'' as PFPreInm,
			SERIES.FechaEjercicio AS DOFEj,
			ISNULL(SERIES.PrecioEjercicio, 0) as DOPEj,
			ISNULL(ESPECIES.Descripcion, '') AS DOSub,
			'' as ML,
			VALORESCPITPAP.CodSerie ClId,
			dbo.fnFechaOperaciones(ESPECIES.CodEspecie,@FechaProceso) as 'AA',
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIP.Descripcion,'')) as NomClImp, 
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomSClImp, 
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomImpAct,
			dbo.fnSacarCaracteresEspXML(coalesce(PAISEMI.Descripcion,'')) as PaisNomEmi, 
			case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(PAISEMI.CodCAFCI,'')) as PaisNomEmiCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(PAISMERCADO.Descripcion,'')) as PaisNomNeg, 
			case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(PAISMERCADO.CodCAFCI,'')) as PaisNomNegCod,
			'' as CtaCteRem,
			'' AS ASNom,
			'' AS ASTic,
			'' AS ASTTic,
			'SERIE' as OrigenActivo
    FROM    VALORESCPITPAP
            INNER JOIN FONDOS ON FONDOS.CodFondo = VALORESCPITPAP.CodFondo
            INNER JOIN ESPECIES ON ESPECIES.CodEspecie = VALORESCPITPAP.CodEspecie
			INNER JOIN EMISORES ON EMISORES.CodEmisor = ESPECIES.CodEmisor
			INNER JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais
			LEFT JOIN MERCADOS 
				inner join PAISES PAISMERCADO on PAISMERCADO.CodPais = MERCADOS.CodPais
				ON MERCADOS.CodMercado = ESPECIES.CodMercadoOperacion 
            INNER JOIN SERIES ON SERIES.CodEspecie = VALORESCPITPAP.CodEspecie AND SERIES.CodSerie = VALORESCPITPAP.CodSerie
            LEFT  JOIN MERCADOS MEROPER ON MEROPER.CodMercado = ESPECIES.CodMercadoOperacion
            LEFT  JOIN #CAFCISEMANAL_ABREVSER ABREV ON ABREV.CodEspecie = VALORESCPITPAP.CodEspecie AND ABREV.CodSerie = VALORESCPITPAP.CodSerie
            LEFT  JOIN #CAFCISEMANAL_COTSER COTTMP ON COTTMP.CodEspecie = VALORESCPITPAP.CodEspecie AND COTTMP.CodSerie = VALORESCPITPAP.CodSerie AND COTTMP.Fecha = VALORESCPITPAP.Fecha
            LEFT  JOIN MERCADOS MERCOTI ON MERCOTI.CodMercado = COTTMP.CodMercado
            LEFT  JOIN MONEDAS MONCOTI ON MONCOTI.CodMoneda = COTTMP.CodMoneda
            LEFT  JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
            LEFT  JOIN TPPAPEL ON TPPAPEL.CodTpPapel = TPESPECIE.CodTpPapel
			LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = SERIES.CodTpActivoAfipIt 
			LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
    WHERE   VALORESCPITPAP.CodFondo = @CodFondo
        AND VALORESCPITPAP.Fecha = @FechaProceso
        AND NOT VALORESCPITPAP.CodSerie IS NULL


	insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
		select IdTabla, '<Entidades><Entidad>' +
				'<TipoEntNom>Entidad Emisora</TipoEntNom>'+
				'<TipoEntId>13</TipoEntId>'+
				'<EntNom>' + dbo.fnSacarCaracteresEspXML(coalesce(EMISORES.Descripcion,'')) + '</EntNom>' +
				'<EntTic/>' +
				'<EntTTic/>' +
				'<PaisNom>' + dbo.fnSacarCaracteresEspXML(COALESCE(PAISES.Descripcion,''))  + '</PaisNom>' +
				case when coalesce(PAISES.CodCAFCI,'') <> '' then '<PaisTCod>C</PaisTCod>' else '<PaisTCod/>' end + 
				case when coalesce(PAISES.CodCAFCI,'') = '' then '<PaisCod/>' else '<PaisCod>' + dbo.fnSacarCaracteresEspXML(coalesce(PAISES.CodCAFCI,'')) + '</PaisCod>' end + 
				'<ActNom/>' +
				'<ActNomId/>' +
				'</Entidad></Entidades>' 
		from #TEMP_ACTIVOS
			INNER JOIN SERIES ON SERIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie AND SERIES.CodSerie = #TEMP_ACTIVOS.CodSerie
			INNER JOIN ESPECIES ON ESPECIES.CodEspecie = SERIES.CodEspecie 
			INNER JOIN EMISORES ON EMISORES.CodEmisor = ESPECIES.CodEmisor 
			INNER JOIN PAISES ON PAISES.CodPais = EMISORES.CodPais 
		where OrigenActivo like 'SERIE'
			
		create table #CAFCI_FECHAS
		(
			CodEspecie numeric(10) not null,
			CodSerie numeric(10) not null,
			TipoFechaId varchar(1) collate database_default not null,
			TipoFechaNom varchar(80) collate database_default not null,
			FechaDato smalldatetime not null
		)

		insert into #CAFCI_FECHAS (CodEspecie, CodSerie, TipoFechaId, TipoFechaNom, FechaDato)
			select #TEMP_ACTIVOS.CodEspecie, #TEMP_ACTIVOS.CodSerie, '4', 'Origen de la Inversion',SERIES.FechaEmision 
			from #TEMP_ACTIVOS
				INNER JOIN SERIES ON SERIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie AND SERIES.CodSerie = #TEMP_ACTIVOS.CodSerie
				INNER JOIN ESPECIES ON ESPECIES.CodEspecie = SERIES.CodEspecie 
			where not SERIES.FechaEmision  is null and OrigenActivo like 'SERIE'
			--union all
			--select #TEMP_ACTIVOS.CodEspecie, #TEMP_ACTIVOS.CodSerie, '2', 'Vencimiento del Activo',ESPECIES.FechaVencimiento 
			--from #TEMP_ACTIVOS
			--	INNER JOIN SERIES ON SERIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie AND SERIES.CodSerie = #TEMP_ACTIVOS.CodSerie
			--	INNER JOIN ESPECIES ON ESPECIES.CodEspecie = SERIES.CodEspecie 
			--where not ESPECIES.FechaVencimiento is null and OrigenActivo like 'SERIE'
			union all
			select #TEMP_ACTIVOS.CodEspecie, #TEMP_ACTIVOS.CodSerie, '7', 'Ejercicio DO',SERIES.FechaEjercicio 
			from #TEMP_ACTIVOS
				INNER JOIN SERIES ON SERIES.CodEspecie = #TEMP_ACTIVOS.CodEspecie AND SERIES.CodSerie = #TEMP_ACTIVOS.CodSerie
				INNER JOIN ESPECIES ON ESPECIES.CodEspecie = SERIES.CodEspecie 
			where not SERIES.FechaEjercicio  is null and OrigenActivo like 'SERIE'
		
		/*FECHAS*/
		IF EXISTS (SELECT 1 FROM #TEMP_ACTIVOS
				left join #CAFCI_FECHAS
					on #CAFCI_FECHAS.CodEspecie = #TEMP_ACTIVOS.CodEspecie
					and #CAFCI_FECHAS.CodSerie = #TEMP_ACTIVOS.CodSerie
			where OrigenActivo like 'SERIE')
		BEGIN
			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select distinct IdTabla, '<Fechas>'
				from #TEMP_ACTIVOS
					left join #CAFCI_FECHAS
						on #CAFCI_FECHAS.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						and #CAFCI_FECHAS.CodSerie = #TEMP_ACTIVOS.CodSerie
				where OrigenActivo like 'SERIE'

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select IdTabla, case when coalesce(#CAFCI_FECHAS.TipoFechaNom,'') <> '' then 
						'<Fecha>'+
						'<TipoFechaNom>' + #CAFCI_FECHAS.TipoFechaNom + '</TipoFechaNom>'+
						'<FechaDato>' + convert(varchar(10),#CAFCI_FECHAS.FechaDato,120) + '</FechaDato>'+
						'<TipoFechaId>' + #CAFCI_FECHAS.TipoFechaId + '</TipoFechaId>'+
						'</Fecha>'
					else
						'<Fecha><TipoFechaNom/><FechaDato/><TipoFechaId/></Fecha>'
					end
				from #TEMP_ACTIVOS
					left join #CAFCI_FECHAS
						on #CAFCI_FECHAS.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						and #CAFCI_FECHAS.CodSerie = #TEMP_ACTIVOS.CodSerie
				where OrigenActivo like 'SERIE'

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select distinct IdTabla, '</Fechas>'
				from #TEMP_ACTIVOS
					left join #CAFCI_FECHAS
						on #CAFCI_FECHAS.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						and #CAFCI_FECHAS.CodSerie = #TEMP_ACTIVOS.CodSerie
				where OrigenActivo like 'SERIE'
		 END
		
		
		/*--'RG 796 - Informa abreviaturas anuladas.'*/
		DECLARE @PARAMETRO_ABREVIATURAS_ANULADAS Boolean
		SELECT @PARAMETRO_ABREVIATURAS_ANULADAS = ValorParametro FROM PARAMETROS WHERE CodParametro = 'ABR796'	
		/**/

		
		/*TICKERS*/
		IF EXISTS (SELECT 1 FROM #TEMP_ACTIVOS
					INNER JOIN  ABREVIATURASSER 
						ON ABREVIATURASSER.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						   AND ABREVIATURASSER.CodSerie = #TEMP_ACTIVOS.CodSerie
					INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASSER.CodMercado 
						and MERCADOS.EstaAnulado = 0
					INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
						AND PAISES.EstaAnulado = 0
					INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
						AND MERCOD.EstaAnulado = 0
					INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASSER.CodMoneda
						AND MONEDAS.EstaAnulado = 0
					INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASSER.CodTpAbreviatura  
				where OrigenActivo like 'SERIE')
		BEGIN
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, '<Tickers>'
				from #TEMP_ACTIVOS
					INNER JOIN  ABREVIATURASSER 
						ON ABREVIATURASSER.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						   AND ABREVIATURASSER.CodSerie = #TEMP_ACTIVOS.CodSerie
					INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASSER.CodMercado 
						and MERCADOS.EstaAnulado = 0
					INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
						AND PAISES.EstaAnulado = 0
					INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
						AND MERCOD.EstaAnulado = 0
					INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASSER.CodMoneda
						AND MONEDAS.EstaAnulado = 0
					INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASSER.CodTpAbreviatura  
				where OrigenActivo like 'SERIE'

				--Select * From ESPECIES where CodigoEspecie = '457'
				--Select * From SERIES where CodEspecie = 162
				--Select * From ABREVIATURASSER where CodEspecie = 162

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select IdTabla, '<Ticker>' +
						'<ActTicEnt>' + CASE ABREVIATURASSER.CodTpAbreviatura 
										WHEN 'ML' THEN 'CAFCI'
										WHEN 'FT' THEN 'BCBA' 
										ELSE dbo.fnSacarCaracteresEspXML(coalesce(TPABREVIATURA.Descripcion ,''))
									END + '</ActTicEnt>' +
						'<ActTic>' + dbo.fnSacarCaracteresEspXML(coalesce(ABREVIATURASSER.Descripcion,'')) + '</ActTic>' +
						'<ActTTicId>' + CASE ABREVIATURASSER.CodTpAbreviatura 
										WHEN 'FT' THEN 'B' 
										WHEN 'MA' THEN 'E'
										WHEN 'BL' THEN 'BL'
										WHEN 'RT' THEN 'R'
										WHEN 'ML' THEN 'M'
										ELSE 'P' -- 'ML' 'MN' 'SR'
									END  + '</ActTTicId>' +
						case when coalesce(MONEDAS.CodCAFCI,'') = '' then '<ActMonCotId/>' else '<ActMonCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MONEDAS.CodCAFCI,'')) + '</ActMonCotId>' end +
						case when coalesce(MERCADOS.CodCAFCI,'') = '' then '<ActMerCotId/>' else '<ActMerCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MERCADOS.CodCAFCI,'')) + '</ActMerCotId>' end +
						'</Ticker>'
				from #TEMP_ACTIVOS
					INNER JOIN  ABREVIATURASSER 
						ON ABREVIATURASSER.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						   AND ABREVIATURASSER.CodSerie = #TEMP_ACTIVOS.CodSerie
					INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASSER.CodMercado 
						and MERCADOS.EstaAnulado = 0
					INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
						AND PAISES.EstaAnulado = 0
					INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
						AND MERCOD.EstaAnulado = 0
					INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASSER.CodMoneda
						AND MONEDAS.EstaAnulado = 0
					INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASSER.CodTpAbreviatura 
				where OrigenActivo like 'SERIE'

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, '</Tickers>'
				from #TEMP_ACTIVOS
					INNER JOIN  ABREVIATURASSER 
						ON ABREVIATURASSER.CodEspecie = #TEMP_ACTIVOS.CodEspecie
						   AND ABREVIATURASSER.CodSerie = #TEMP_ACTIVOS.CodSerie
					INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASSER.CodMercado 
						and MERCADOS.EstaAnulado = 0
					INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
						AND PAISES.EstaAnulado = 0
					INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
						AND MERCOD.EstaAnulado = 0
					INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASSER.CodMoneda
						AND MONEDAS.EstaAnulado = 0
					INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASSER.CodTpAbreviatura  
				where OrigenActivo like 'SERIE'
		END

go




exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Activo_PF'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Activo_PF
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @Precancelable     Entero
    DECLARE @CodPais           CodigoMedio
    DECLARE @FechaLiquidez     Fecha
    DECLARE @EsVendedor	Boolean

	--variables CURSOR
	DECLARE @Cur_CodFondo CodigoMedio
	DECLARE @Cur_CodOperFinanciera CodigoLargo
	DECLARE @Cur_CodPlazoFijo CodigoLargo
	DECLARE @Cur_MonCoti CodigoMedio
	DECLARE @Cur_MonFdo CodigoMedio
	DECLARE @Cur_TpCambio Precio
	declare @EsOperFin smallint

    SELECT  @Precancelable = ValorParametro FROM PARAMETROS WHERE CodParametro = 'PPREPF'
    
    SELECT  @CodPais = CodPais FROM PARAMETROSREL
    EXEC sp_dfxSumarDiasHabiles @FechaProceso, 1, @FechaLiquidez OUTPUT, @CodPais

	DECLARE @CodMonedaCursoLgl CodigoMedio
	select @CodMonedaCursoLgl = CodMonedaCursoLgl from PARAMETROSREL
    -- temporales
    CREATE TABLE #CAFCISEMANAL_OPERPLAZO (
		IdTabla					numeric(10) identity(1,1) not null,
        CodFondo               numeric(5) NOT NULL,
        CodOperFinanciera      numeric(10) NULL,
        CodPlazoFijo           numeric(10) NULL,
        Capital                numeric(22, 2) NOT NULL,
        Tasas                  numeric(4) NOT NULL,
        TasaInteres            numeric(12, 8) NOT NULL,
        EnPrecancelacion       smallint NOT NULL,
		FactorConvOperFdo      numeric(19,10) NULL,		
        TpCambio               varchar(1) COLLATE database_default NULL,
		CodOperacion      numeric(10) NULL,
		EsOperFin			smallint
    )

    --filtro PF viejos en temporal
    INSERT INTO #CAFCISEMANAL_OPERPLAZO(CodFondo, CodOperacion, Capital, Tasas, TasaInteres, EnPrecancelacion,EsOperFin)
    SELECT  OPERFINANCIERAS.CodFondo,
            OPERFINANCIERAS.CodOperFinanciera,
            ISNULL(SUM(OPERFINHIST.ImporteMonOp), 0) AS Capital,
           (SELECT  COUNT(*)
            FROM    OPERFINTASAS
            WHERE   OPERFINTASAS.CodFondo = OPERFINANCIERAS.CodFondo
                AND OPERFINTASAS.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera) AS Tasas,
            ISNULL(TASAACTUAL.TasaInteres, 1) AS TasaInteres,
            CASE WHEN  DATEDIFF(d, OPERFINANCIERAS.FechaConcertacion, @FechaLiquidez) >= @Precancelable AND OPERFINPZOFIJO.EsPrecancelable = -1 THEN -1
                 WHEN @FechaLiquidez = OPERFINANCIERAS.FechaLiquidacion AND OPERFINPZOFIJO.EsPrecancelable = 0 THEN -1
                 ELSE 0
            END AS EnPrecancelacion,
			-1 as EsOperFin
    FROM    OPERFINANCIERAS
            INNER JOIN OPERFINPZOFIJO
                    ON OPERFINPZOFIJO.CodFondo = OPERFINANCIERAS.CodFondo
                   AND OPERFINPZOFIJO.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
            LEFT  JOIN OPERFINHIST
                    ON OPERFINHIST.CodFondo = OPERFINANCIERAS.CodFondo
                   AND OPERFINHIST.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
                   AND OPERFINHIST.CodTpMovimiento IN ('IMPCAP', 'IMPANT', 'IMPAPR', 'IMPDEV')
                   AND OPERFINHIST.Fecha <= @FechaProceso
                   AND OPERFINHIST.FechaAsiento <= @FechaProceso
            LEFT  JOIN OPERFINTASAS TASAACTUAL
                    ON TASAACTUAL.CodFondo = OPERFINANCIERAS.CodFondo
                   AND TASAACTUAL.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
                   AND TASAACTUAL.FechaDesde <= (CASE WHEN CodTpDevengamiento IN ('LD', 'ED') AND FechaConcertacion = @FechaProceso then DATEADD(DD,1,@FechaProceso)
                                                      WHEN CodTpDevengamiento IN ('LI', 'EI') AND FechaLiquidacion = @FechaProceso then DATEADD(DD,-1,@FechaProceso)
                                                      ELSE @FechaProceso
                                                      END)
                   AND TASAACTUAL.FechaHasta >= (CASE WHEN CodTpDevengamiento = 'LD' AND FechaConcertacion = @FechaProceso then DATEADD(DD,1,@FechaProceso)
                                                      WHEN CodTpDevengamiento = 'LI' AND FechaLiquidacion = @FechaProceso then DATEADD(DD,-1,@FechaProceso)
                                                      ELSE @FechaProceso
                                                      END)
    WHERE   OPERFINANCIERAS.CodFondo = @CodFondo
        AND OPERFINANCIERAS.CodTpOperacion = 'PF'
        AND OPERFINANCIERAS.FechaConcertacion <= @FechaProceso
        AND ISNULL(OPERFINPZOFIJO.FechaPrecancelacion, OPERFINANCIERAS.FechaLiquidacion) > @FechaProceso
        AND OPERFINANCIERAS.EstaAnulado = 0
    GROUP BY OPERFINANCIERAS.CodFondo, OPERFINANCIERAS.CodOperFinanciera, TASAACTUAL.TasaInteres, OPERFINPZOFIJO.EsPrecancelable, OPERFINANCIERAS.FechaConcertacion, OPERFINANCIERAS.FechaLiquidacion
    ORDER BY OPERFINANCIERAS.CodFondo, OPERFINANCIERAS.CodOperFinanciera


	--TIPO DE CAMBIO PF OPERFIN
	/*
    DECLARE cursor_CambioOperFin cursor for
		SELECT	#CAFCISEMANAL_OPERPLAZO.CodFondo,
				#CAFCISEMANAL_OPERPLAZO.CodOperFinanciera,
				OPERFIN.CodMoneda,
				FONDOS.CodMoneda
		FROM #CAFCISEMANAL_OPERPLAZO
		INNER JOIN OPERFINANCIERAS OPERFIN ON OPERFIN.CodFondo = #CAFCISEMANAL_OPERPLAZO.CodFondo
			and OPERFIN.CodOperFinanciera =  #CAFCISEMANAL_OPERPLAZO.CodOperFinanciera
		INNER JOIN FONDOS ON FONDOS.CodFondo = #CAFCISEMANAL_OPERPLAZO.CodFondo
		WHERE #CAFCISEMANAL_OPERPLAZO.CodOperFinanciera IS NOT NULL

    OPEN cursor_CambioOperFin

    FETCH NEXT FROM cursor_CambioOperFin INTO @Cur_CodFondo, @Cur_CodOperFinanciera, @Cur_MonCoti, @Cur_MonFdo
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        exec spXCalcularUltCambioActPas -1, @Cur_CodFondo, @Cur_MonCoti, @Cur_MonFdo,@FechaProceso , @Cur_TpCambio OUTPUT, @EsVendedor OUTPUT

        UPDATE #CAFCISEMANAL_OPERPLAZO
		SET FactorConvOperFdo = @Cur_TpCambio
            ,TpCambio = (case when @EsVendedor = -1 then 'V' ELSE 'C' END)
		WHERE CodFondo = @Cur_CodFondo AND CodOperFinanciera = @Cur_CodOperFinanciera

        FETCH NEXT FROM cursor_CambioOperFin  INTO @Cur_CodFondo, @Cur_CodOperFinanciera, @Cur_MonCoti, @Cur_MonFdo
    END

    CLOSE cursor_CambioOperFin
    DEALLOCATE cursor_CambioOperFin
	*/
	--*****

    --filtro PF nuevos en temporal
    INSERT INTO #CAFCISEMANAL_OPERPLAZO(CodFondo, CodOperacion, Capital, Tasas, TasaInteres, EnPrecancelacion, EsOperFin)
    SELECT  PLAZOSFIJOS.CodFondo,
            PLAZOSFIJOS.CodPlazoFijo,
            ISNULL(PLAZOSFIJOSCAPITAL.Capital,0) - ISNULL(PLAZOSFIJOSCAPITAL.Ajuste,0) + ISNULL(PLAZOSFIJOSCERMOV.Capital,0) + ISNULL(DEVENGAMIENTOSMOV.Importe,0) - ISNULL(PFRETIR.Importe,0) AS Capital,
           (SELECT COUNT(*) FROM PLAZOSFIJOSTASA WHERE PLAZOSFIJOSTASA.CodFondo = PLAZOSFIJOS.CodFondo AND PLAZOSFIJOSTASA.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo) AS Tasas,
            PLAZOSFIJOSTASA.Tasa + ISNULL(PLAZOSFIJOS.TasaFija,0) + ISNULL(PLAZOSFIJOSAJUSTE.Tasa,0) AS TasaInteres,
            0 AS EnPrecancelacion,
			0 as EsOperFin
    FROM    PLAZOSFIJOS
            INNER JOIN MONEDAS ON MONEDAS.CodMoneda = PLAZOSFIJOS.CodMoneda
            INNER JOIN BANCOS ON BANCOS.CodBanco = PLAZOSFIJOS.CodBanco
            INNER JOIN (SELECT  CodFondo, CodPlazoFijo, SUM(ISNULL(Plazo,0)) AS Plazo
                        FROM    PLAZOSFIJOSPLAZO
                        WHERE   Fecha <= @FechaProceso
                        GROUP BY CodFondo, CodPlazoFijo) PLAZOSFIJOSPLAZO
                     ON PLAZOSFIJOSPLAZO.CodFondo = PLAZOSFIJOS.CodFondo
                    AND PLAZOSFIJOSPLAZO.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
            INNER JOIN PLAZOSFIJOSTASA
                       INNER JOIN (SELECT  CodFondo, CodPlazoFijo, MAX(Fecha) AS Fecha
                                   FROM    PLAZOSFIJOSTASA
                                   WHERE   Fecha <= @FechaProceso
                                   GROUP BY CodFondo, CodPlazoFijo) PFTASAMAX
                               ON PFTASAMAX.CodFondo = PLAZOSFIJOSTASA.CodFondo
                              AND PFTASAMAX.CodPlazoFijo = PLAZOSFIJOSTASA.CodPlazoFijo
                              AND PFTASAMAX.Fecha = PLAZOSFIJOSTASA.Fecha
                    ON PLAZOSFIJOSTASA.CodFondo = PLAZOSFIJOS.CodFondo
                   AND PLAZOSFIJOSTASA.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
            INNER JOIN (SELECT  CodFondo, CodPlazoFijo, SUM(ISNULL(Capital,0)) AS Capital, SUM(ISNULL(Ajuste,0)) AS Ajuste
                        FROM    PLAZOSFIJOSCAPITAL
                        WHERE   Fecha <= @FechaProceso
                        GROUP BY CodFondo, CodPlazoFijo) PLAZOSFIJOSCAPITAL
                     ON PLAZOSFIJOSCAPITAL.CodFondo = PLAZOSFIJOS.CodFondo
                    AND PLAZOSFIJOSCAPITAL.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
            LEFT  JOIN (SELECT  CodFondo, CodPlazoFijo, SUM(ISNULL(Tasa,0)) AS Tasa
                        FROM    PLAZOSFIJOSAJUSTE
                        WHERE   FechaConcertacion <= @FechaProceso
                            AND FechaInicio <= @FechaProceso
                            AND FechaFin >= @FechaProceso
                            AND EstaAnulado = 0
                        GROUP BY CodFondo, CodPlazoFijo) PLAZOSFIJOSAJUSTE
                     ON PLAZOSFIJOSAJUSTE.CodFondo = PLAZOSFIJOS.CodFondo
                    AND PLAZOSFIJOSAJUSTE.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
            LEFT  JOIN (SELECT  CodFondo, CodPlazoFijo, SUM(ISNULL(Capital,0)) AS Capital
                        FROM    PLAZOSFIJOSCERMOV
                        WHERE   Fecha <= @FechaProceso
                            AND EstaAnulado = 0
                        GROUP BY CodFondo, CodPlazoFijo) PLAZOSFIJOSCERMOV
                     ON PLAZOSFIJOSCERMOV.CodFondo = PLAZOSFIJOS.CodFondo
                    AND PLAZOSFIJOSCERMOV.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
            LEFT  JOIN (SELECT  CodFondo, CodDevengamientoCab, SUM(ISNULL(Importe,0)) AS Importe
                        FROM    DEVENGAMIENTOSMOV
                        WHERE   Fecha <= @FechaProceso
                            AND EstaAnulado = 0
                        GROUP BY CodFondo, CodDevengamientoCab) DEVENGAMIENTOSMOV
                     ON DEVENGAMIENTOSMOV.CodFondo = PLAZOSFIJOS.CodFondo
                    AND DEVENGAMIENTOSMOV.CodDevengamientoCab = PLAZOSFIJOS.CodDevengamientoCab
            LEFT  JOIN (SELECT  CodFondo, CodPlazoFijo, SUM(ISNULL(Interes,0)) AS Importe
                        FROM    PLAZOSFIJOSINTERES
                        WHERE   Fecha <= @FechaProceso
                            AND CodTpPlazoFijoInteres = 'RP'
                            AND EstaAnulado = 0
                        GROUP BY CodFondo, CodPlazoFijo) PFRETIR
                     ON PFRETIR.CodFondo = PLAZOSFIJOS.CodFondo
                    AND PFRETIR.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
    WHERE   PLAZOSFIJOS.EstaAnulado = 0
        AND PLAZOSFIJOS.FechaConcertacion <= @FechaProceso
        AND PLAZOSFIJOS.CodFondo = @CodFondo
    GROUP BY PLAZOSFIJOS.CodFondo, PLAZOSFIJOS.CodPlazoFijo, PLAZOSFIJOS.FechaConcertacion, PLAZOSFIJOSTASA.Tasa, PLAZOSFIJOSAJUSTE.Tasa, PLAZOSFIJOS.TasaFija,
            PLAZOSFIJOSCAPITAL.Capital, PLAZOSFIJOSCAPITAL.Ajuste, PLAZOSFIJOSCERMOV.Capital, DEVENGAMIENTOSMOV.Importe, PFRETIR.Importe,
            PLAZOSFIJOSPLAZO.Plazo
    HAVING  DATEADD(dd, PLAZOSFIJOSPLAZO.Plazo, PLAZOSFIJOS.FechaConcertacion) > @FechaProceso

	create table #CAFCISEMANAL_COTIZACIONES
	(
		IdTabla					numeric(10) identity(1,1) not null,
		CodFondo               numeric(5) NOT NULL,
		CodOperacion      numeric(10) NULL,
		CodMonedaPF              numeric(5) NOT NULL,
		CodMonedaFdo              numeric(5) NOT NULL,
		FactorConvOperFdo      numeric(19,10) NULL,		
        TpCambio               varchar(1) COLLATE database_default NULL,
		EsOperFin			smallint,
		IdTablaPadre		numeric(10) NOT NULL
	)


	insert into #CAFCISEMANAL_COTIZACIONES (CodFondo,  CodOperacion,CodMonedaPF,CodMonedaFdo, EsOperFin, IdTablaPadre)
	SELECT	#CAFCISEMANAL_OPERPLAZO.CodFondo,
				#CAFCISEMANAL_OPERPLAZO.CodOperacion,
				PLAZOSFIJOS.CodMoneda,
				FONDOS.CodMoneda,
				EsOperFin,
				IdTabla
		FROM #CAFCISEMANAL_OPERPLAZO
		INNER JOIN PLAZOSFIJOS ON PLAZOSFIJOS.CodFondo = #CAFCISEMANAL_OPERPLAZO.CodFondo
			and PLAZOSFIJOS.CodPlazoFijo =  #CAFCISEMANAL_OPERPLAZO.CodOperacion
		INNER JOIN FONDOS ON FONDOS.CodFondo = #CAFCISEMANAL_OPERPLAZO.CodFondo
		WHERE #CAFCISEMANAL_OPERPLAZO.EsOperFin = 0
		
	insert into #CAFCISEMANAL_COTIZACIONES (CodFondo,  CodOperacion,CodMonedaPF,CodMonedaFdo, EsOperFin, IdTablaPadre)
	SELECT	#CAFCISEMANAL_OPERPLAZO.CodFondo,
			#CAFCISEMANAL_OPERPLAZO.CodOperacion,
			OPERFIN.CodMoneda,
			FONDOS.CodMoneda,
			EsOperFin,
			IdTabla
	FROM #CAFCISEMANAL_OPERPLAZO
	INNER JOIN OPERFINANCIERAS OPERFIN ON OPERFIN.CodFondo = #CAFCISEMANAL_OPERPLAZO.CodFondo
		and OPERFIN.CodOperFinanciera =  #CAFCISEMANAL_OPERPLAZO.CodOperacion
	INNER JOIN FONDOS ON FONDOS.CodFondo = #CAFCISEMANAL_OPERPLAZO.CodFondo
	WHERE #CAFCISEMANAL_OPERPLAZO.EsOperFin = -1


	--TP CAMBIO PALZOSFIJOS
    DECLARE cursor_CambioPF cursor for
		SELECT	CodFondo,
				CodOperacion,
				CodMonedaPF,
				CodMonedaFdo,
				EsOperFin
		FROM #CAFCISEMANAL_COTIZACIONES
		

    OPEN cursor_CambioPF

    FETCH NEXT FROM cursor_CambioPF INTO @Cur_CodFondo, @Cur_CodPlazoFijo, @Cur_MonCoti, @Cur_MonFdo, @EsOperFin
    
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        exec spXCalcularUltCambioActPas -1, @Cur_CodFondo, @Cur_MonCoti, @Cur_MonFdo,@FechaProceso , @Cur_TpCambio OUTPUT, @EsVendedor OUTPUT

        UPDATE #CAFCISEMANAL_COTIZACIONES
    		SET FactorConvOperFdo = @Cur_TpCambio
               ,TpCambio = (case when @EsVendedor = -1 then 'V' ELSE 'C' END)
        WHERE CodFondo = @Cur_CodFondo AND CodOperacion = @Cur_CodPlazoFijo and EsOperFin = @EsOperFin 

        FETCH NEXT FROM cursor_CambioPF  INTO @Cur_CodFondo, @Cur_CodPlazoFijo, @Cur_MonCoti, @Cur_MonFdo, @EsOperFin
    END

    CLOSE cursor_CambioPF
    DEALLOCATE cursor_CambioPF
	
	--*****

	update #CAFCISEMANAL_OPERPLAZO
	set #CAFCISEMANAL_OPERPLAZO.FactorConvOperFdo = #CAFCISEMANAL_COTIZACIONES.FactorConvOperFdo 
		,#CAFCISEMANAL_OPERPLAZO.TpCambio = #CAFCISEMANAL_COTIZACIONES.TpCambio 
	FROM #CAFCISEMANAL_OPERPLAZO
		INNER JOIN #CAFCISEMANAL_COTIZACIONES
			ON #CAFCISEMANAL_COTIZACIONES.IdTablaPadre = #CAFCISEMANAL_OPERPLAZO.IdTabla


    --devuelvo resultados
	
	insert into #TEMP_ACTIVOS(CodFondo, CodOperacion,	CodTpOperacion,	Nro,
		ActTTic,ActTic,ActNom,EntENom,EntONom,MerTCod,MerCod,MerNom,MonActTCod,
		MonActCod,MonActNom,Cant,CantCot,Pre,MtoMAct,TCCod,MtoMFdo,Cl,SCl,TTasa,
		TNA,MtoAc,FeOr,FeVto,Plazo,PFTra,PFPre,PFPreInm,PFPreF,ML,ClId,AA,CodImpAct,NomClImp, NomSClImp, NomImpAct,
		PaisNomEmi, PaisNomEmiTCod, PaisNomEmiCod, PaisNomNeg, PaisNomNegTCod, PaisNomNegCod, CtaCteRem,
		ASNom,ASTic,ASTTic,OrigenActivo)
		SELECT  OPERFINANCIERAS.CodFondo,
				OPERFINANCIERAS.CodOperFinanciera AS CodOperacion,
				OPERFINANCIERAS.CodTpOperacion,
				0 as Nro,
				CASE WHEN UPPER(LEFT(ISNULL(OPERFINPZOFIJO.CodCAFCI,''),2)) <> 'PF' THEN 'B'
					 WHEN NOT OPERFINPZOFIJO.CodCAFCI IS NULL THEN 'M'
					 ELSE 'P' --CodInterfaz/NumOperFinanciera
				END AS TTCod,
				COALESCE(OPERFINPZOFIJO.CodCAFCI, OPERFINPZOFIJO.CodInterfaz, OPERFINANCIERAS.NumOperFinanciera, '') AS TNom,
				COALESCE(OPERFINANCIERAS.NumOperFinanciera, '') AS AcNomCor,
				dbo.fnSacarCaracteresEspXML(ISNULL(BANCOS.Descripcion, '')) AS EENom,
				'' AS EONom,
				'C' AS MeTCod,
				'NA' AS MeCod,
				'' AS MeNom,
				'C' AS MoTCod,
				COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '') AS MoCod,
				dbo.fnSacarCaracteresEspXML(ISNULL(MONCOTI.Descripcion, '')) AS MoNom,
				1 AS Q,
				1 AS QC,
				0 AS P,
				ISNULL(ABS(OPERFINANCIERAS.Importe),0) AS MontoMO,
				COALESCE(#CAFCISEMANAL_OPERPLAZO.TpCambio,'N') AS TCCod,
				ISNULL(#CAFCISEMANAL_OPERPLAZO.Capital,0) * FactorConvOperFdo AS MontoMF,
				dbo.fnSacarCaracteresEspXML(ISNULL(TPOPERACION.Descripcion, '')) AS ClNom,
				dbo.fnSacarCaracteresEspXML(ISNULL(TPDEVENGAMIENTO.Descripcion, '')) AS SClNom,
				CASE #CAFCISEMANAL_OPERPLAZO.Tasas WHEN 1 THEN 'F' ELSE 'O' END AS TTasa,
				ISNULL(#CAFCISEMANAL_OPERPLAZO.TasaInteres,0) AS TNA,
				ISNULL(#CAFCISEMANAL_OPERPLAZO.Capital,0) AS MontoAc,
				OPERFINANCIERAS.FechaConcertacion AS FeOr,
				OPERFINANCIERAS.FechaLiquidacion AS FeVto,
				ISNULL(OPERFINANCIERAS.Plazo,0) AS Pzo,
				CASE OPERFINPZOFIJO.EsTransferible WHEN -1 THEN 'S' ELSE 'N' END AS PFTr,
				CASE OPERFINPZOFIJO.EsPrecancelable WHEN -1 THEN 'S' ELSE 'N' END AS PFPr,
				CASE OPERFINPZOFIJO.EsPrecancelableInmediato WHEN -1 THEN 'S' ELSE 'N' END AS PFPrIn,
				CASE OPERFINPZOFIJO.EsPrecancelable WHEN -1 THEN DATEADD(d, @Precancelable, OPERFINANCIERAS.FechaConcertacion) ELSE NULL END AS PFFePr,
				CASE #CAFCISEMANAL_OPERPLAZO.EnPrecancelacion
					 WHEN -1 THEN 'S'
					 ELSE CASE OPERFINANCIERAS.FechaLiquidacion WHEN @FechaLiquidez THEN 'S' ELSE 'N' END
				END AS MLiq,
				OPERFINANCIERAS.CodOperFinanciera AS ClId,
				dbo.fnFechaOperaciones(-1,@FechaProceso) as 'AA',
				dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
				dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIP.Descripcion,'')) as NomClImp, 
				dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomSClImp, 
				dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomImpAct,
				dbo.fnSacarCaracteresEspXML(COALESCE(PAISEMI.Descripcion,'')) as PaisNomEmi, 
				case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, 
				dbo.fnSacarCaracteresEspXML(coalesce(PAISEMI.CodCAFCI,'')) as PaisNomEmiCod, 
				dbo.fnSacarCaracteresEspXML(COALESCE(PAISMERCADO.Descripcion, '')) as PaisNomNeg, 
				case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, 
				dbo.fnSacarCaracteresEspXML(coalesce(PAISMERCADO.CodCAFCI,'')) as PaisNomNegCod,
				'' as CtaCteRem,
				'' AS ASNom,
				'' AS ASTic,
				'' AS ASTTic,
				'PF' as OrigenActivo
		FROM    OPERFINANCIERAS
				INNER JOIN FONDOS ON FONDOS.CodFondo = OPERFINANCIERAS.CodFondo
				INNER JOIN #CAFCISEMANAL_OPERPLAZO ON #CAFCISEMANAL_OPERPLAZO.CodFondo = OPERFINANCIERAS.CodFondo AND #CAFCISEMANAL_OPERPLAZO.CodOperacion = OPERFINANCIERAS.CodOperFinanciera AND #CAFCISEMANAL_OPERPLAZO.EsOperFin = -1
				INNER JOIN OPERFINPZOFIJO ON OPERFINPZOFIJO.CodFondo = OPERFINANCIERAS.CodFondo AND OPERFINPZOFIJO.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
				INNER JOIN BANCOS ON BANCOS.CodBanco = OPERFINANCIERAS.CodBanco
					LEFT JOIN EMISORES 
						INNER JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais 
					ON EMISORES.CodEmisor = BANCOS.CodEmisor
				INNER JOIN PAISES PAISMERCADO ON PAISMERCADO.CodPais = BANCOS.CodPais
				LEFT  JOIN MONEDAS MONCOTI ON MONCOTI.CodMoneda = OPERFINANCIERAS.CodMoneda
				LEFT  JOIN TPOPERACION ON TPOPERACION.CodTpOperacion = OPERFINANCIERAS.CodTpOperacion
				LEFT  JOIN TPDEVENGAMIENTO ON TPDEVENGAMIENTO.CodTpDevengamiento = OPERFINANCIERAS.CodTpDevengamiento
				LEFT  JOIN COTIZACIONESMON ON COTIZACIONESMON.CodFondo = OPERFINANCIERAS.CodFondo AND COTIZACIONESMON.CodMoneda = OPERFINANCIERAS.CodMoneda AND COTIZACIONESMON.Fecha = @FechaProceso
				LEFT  JOIN COTIZACIONESMON COTFDO ON COTFDO.CodFondo = FONDOS.CodFondo AND COTFDO.CodMoneda = FONDOS.CodMoneda AND COTFDO.Fecha = @FechaProceso
				LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = OPERFINANCIERAS.CodTpActivoAfipIt 
				LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
	UNION
		SELECT  PLAZOSFIJOS.CodFondo,
				PLAZOSFIJOS.CodPlazoFijo AS CodOperacion,
				PLAZOSFIJOS.CodTpOperacion,
				0 as Nro,
				CASE WHEN UPPER(LEFT(ISNULL(PLAZOSFIJOS.CodCAFCI,''),2)) <> 'PF' THEN 'B'
					 WHEN NOT PLAZOSFIJOS.CodCAFCI IS NULL THEN 'M'
					 ELSE 'P' --CodInterfaz/NumPlazoFijo
				END AS TTCod,
				COALESCE(PLAZOSFIJOS.CodCAFCI, PLAZOSFIJOS.CodInterfaz, PLAZOSFIJOS.NumPlazoFijo, '') AS TNom,
				COALESCE(PLAZOSFIJOS.NumPlazoFijo, '') AS AcNomCor,
				dbo.fnSacarCaracteresEspXML(ISNULL(BANCOS.Descripcion, '')) AS EENom,
				'' AS EONom,
				'C' AS MeTCod,
				'NA' AS MeCod,
				'' AS MeNom,
				'C' AS MoTCod,
				COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '') AS MoCod,
				dbo.fnSacarCaracteresEspXML(ISNULL(MONCOTI.Descripcion, '')) AS MoNom,
				1 AS Q,
				1 AS QC,
				0 AS P,
				ISNULL(#CAFCISEMANAL_OPERPLAZO.Capital,0) AS MontoMO,
				COALESCE(#CAFCISEMANAL_OPERPLAZO.TpCambio, 'N') AS TCCod,
				ISNULL(#CAFCISEMANAL_OPERPLAZO.Capital,0) * FactorConvOperFdo AS MontoMF, 
				dbo.fnSacarCaracteresEspXML(ISNULL(TPOPERACION.Descripcion, '')) AS ClNom,
				dbo.fnSacarCaracteresEspXML(ISNULL(TPDEVENGAMIENTO.Descripcion, '')) AS SClNom,
				CASE #CAFCISEMANAL_OPERPLAZO.Tasas WHEN 1 THEN 'F' ELSE 'O' END AS TTasa,
				ISNULL(#CAFCISEMANAL_OPERPLAZO.TasaInteres,0) AS TNA,
				ISNULL(#CAFCISEMANAL_OPERPLAZO.Capital,0) AS MontoAc,
				PLAZOSFIJOS.FechaConcertacion AS FeOr,
				DATEADD(dd, PLAZOSFIJOSPLAZO.Plazo, PLAZOSFIJOS.FechaConcertacion) AS FeVto,
				ISNULL(PLAZOSFIJOSPLAZO.Plazo,0) AS Pzo,
				CASE PLAZOSFIJOS.EsTransferible WHEN -1 THEN 'S' ELSE 'N' END AS PFTr,
				'N' AS PFPr,
				'N' AS PFPrIn,
				NULL AS PFFePr,
				CASE #CAFCISEMANAL_OPERPLAZO.EnPrecancelacion
					 WHEN -1 THEN 'S'
					 ELSE CASE DATEADD(dd, PLAZOSFIJOSPLAZO.Plazo, PLAZOSFIJOS.FechaConcertacion) WHEN @FechaLiquidez THEN 'S' ELSE 'N' END
				END AS MLiq,
				PLAZOSFIJOS.CodPlazoFijo AS ClId,
				dbo.fnFechaOperaciones(-1,@FechaProceso) as 'AA',
				dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
				dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIP.Descripcion,'')) as NomClImp, 
				dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomSClImp, 
				dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomImpAct,
				dbo.fnSacarCaracteresEspXML(COALESCE(PAISEMI.Descripcion,'')) as PaisNomEmi, 
				case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, 
				dbo.fnSacarCaracteresEspXML(coalesce(PAISEMI.CodCAFCI,'')) as PaisNomEmiCod, 
				dbo.fnSacarCaracteresEspXML(COALESCE(PAISMERCADO.Descripcion, '')) as PaisNomNeg, 
				case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, 
				dbo.fnSacarCaracteresEspXML(coalesce(PAISMERCADO.CodCAFCI,'')) as PaisNomNegCod,
				--'' as PaisNomEmi, 
				--'' as PaisNomEmiTCod, 
				--'' as PaisNomEmiCod, 
				--'' as PaisNomNeg, 
				--'' as PaisNomNegTCod, 
				--'' as PaisNomNegCod,		   		 
				'' as CtaCteRem,
				'' AS ASNom,
				'' AS ASTic,
				'' AS ASTTic,
				'PFCERUVA' as OrigenActivo
		FROM    PLAZOSFIJOS
				--INNER JOIN PLAZOSFIJOSCAPITAL PFCAPITAL ON PFCAPITAL.CodFondo = PLAZOSFIJOS.CodFondo AND PFCAPITAL.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo AND PFCAPITAL.Fecha = PLAZOSFIJOS.FechaConcertacion
				INNER JOIN (SELECT  CodFondo, CodPlazoFijo, SUM(ISNULL(Plazo,0)) AS Plazo
							FROM    PLAZOSFIJOSPLAZO
							WHERE   Fecha <= @FechaProceso
							GROUP BY CodFondo, CodPlazoFijo) PLAZOSFIJOSPLAZO
						 ON PLAZOSFIJOSPLAZO.CodFondo = PLAZOSFIJOS.CodFondo
						AND PLAZOSFIJOSPLAZO.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
				INNER JOIN FONDOS ON FONDOS.CodFondo = PLAZOSFIJOS.CodFondo
				INNER JOIN #CAFCISEMANAL_OPERPLAZO ON #CAFCISEMANAL_OPERPLAZO.CodFondo = PLAZOSFIJOS.CodFondo AND #CAFCISEMANAL_OPERPLAZO.CodOperacion = PLAZOSFIJOS.CodPlazoFijo AND #CAFCISEMANAL_OPERPLAZO.EsOperFin = 0
				INNER JOIN BANCOS ON BANCOS.CodBanco = PLAZOSFIJOS.CodBanco
				LEFT JOIN EMISORES 
						INNER JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais 
					ON EMISORES.CodEmisor = BANCOS.CodEmisor		   
				INNER JOIN PAISES PAISMERCADO ON PAISMERCADO.CodPais = BANCOS.CodPais
				LEFT  JOIN MONEDAS MONCOTI ON MONCOTI.CodMoneda = PLAZOSFIJOS.CodMoneda
				LEFT  JOIN TPOPERACION ON TPOPERACION.CodTpOperacion = PLAZOSFIJOS.CodTpOperacion
				LEFT  JOIN TPDEVENGAMIENTO ON TPDEVENGAMIENTO.CodTpDevengamiento = PLAZOSFIJOS.CodTpDevengamiento
				LEFT  JOIN COTIZACIONESMON ON COTIZACIONESMON.CodFondo = PLAZOSFIJOS.CodFondo AND COTIZACIONESMON.CodMoneda = PLAZOSFIJOS.CodMoneda AND COTIZACIONESMON.Fecha = @FechaProceso
				LEFT  JOIN COTIZACIONESMON COTFDO ON COTFDO.CodFondo = FONDOS.CodFondo AND COTFDO.CodMoneda = FONDOS.CodMoneda AND COTFDO.Fecha = @FechaProceso
				LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = PLAZOSFIJOS.CodTpActivoAfipIt 
				LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 


		/**/
		--SELECT * FROM #TEMP_ACTIVOS order by IdTabla

		/********************************************************************/
		/*ENTIDADES*/
		/********************************************************************/
		-- UVA - CER
		if (select COUNT(*)
			from #TEMP_ACTIVOS
				INNER JOIN PLAZOSFIJOS ON PLAZOSFIJOS.CodPlazoFijo = #TEMP_ACTIVOS.CodOperacion
									and PLAZOSFIJOS.CodFondo = #TEMP_ACTIVOS.CodFondo
				INNER JOIN BANCOS on BANCOS.CodBanco = PLAZOSFIJOS.CodBanco 
					LEFT JOIN EMISORES on EMISORES.CodEmisor = BANCOS.CodEmisor 
					left join PAISES on PAISES.CodPais = EMISORES.CodPais 
			where OrigenActivo like 'PFCERUVA')>0 
		begin
			insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
				select IdTabla, '<Entidades>'
				from #TEMP_ACTIVOS
					INNER JOIN PLAZOSFIJOS ON PLAZOSFIJOS.CodPlazoFijo = #TEMP_ACTIVOS.CodOperacion
										and PLAZOSFIJOS.CodFondo = #TEMP_ACTIVOS.CodFondo
					INNER JOIN BANCOS on BANCOS.CodBanco = PLAZOSFIJOS.CodBanco 
						LEFT JOIN EMISORES on EMISORES.CodEmisor = BANCOS.CodEmisor 
						left join PAISES on PAISES.CodPais = EMISORES.CodPais 
				where OrigenActivo like 'PFCERUVA'

			insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
				select IdTabla, '<Entidad>' +
						'<TipoEntNom>Entidad Emisora</TipoEntNom>'+
						'<TipoEntId>13</TipoEntId>'+
						case when dbo.fnSacarCaracteresEspXML(coalesce(EMISORES.Descripcion,'')) = '' then '<EntNom/>' else '<EntNom>' + dbo.fnSacarCaracteresEspXML(coalesce(EMISORES.Descripcion,'')) + '</EntNom>' end +
						'<EntTic/>' +
						'<EntTTic/>' +
						case when COALESCE(PAISES.Descripcion,'') = '' then '<PaisNom/>' else '<PaisNom>' + dbo.fnSacarCaracteresEspXML(COALESCE(PAISES.Descripcion,''))  + '</PaisNom>' end +
						case when coalesce(PAISES.CodCAFCI,'') <> '' then '<PaisTCod>C</PaisTCod>' else '<PaisTCod/>' end + 
						case when coalesce(PAISES.CodCAFCI,'') = '' then '<PaisCod/>' else '<PaisCod>' + dbo.fnSacarCaracteresEspXML(coalesce(PAISES.CodCAFCI,'')) + '</PaisCod>' end +
						'<ActNom/>' +
						'<ActNomId/>' +
						'</Entidad>'
				from #TEMP_ACTIVOS
					INNER JOIN PLAZOSFIJOS ON PLAZOSFIJOS.CodPlazoFijo = #TEMP_ACTIVOS.CodOperacion
										and PLAZOSFIJOS.CodFondo = #TEMP_ACTIVOS.CodFondo
					INNER JOIN BANCOS on BANCOS.CodBanco = PLAZOSFIJOS.CodBanco 
						LEFT JOIN EMISORES on EMISORES.CodEmisor = BANCOS.CodEmisor 
						left join PAISES on PAISES.CodPais = EMISORES.CodPais 
				where OrigenActivo like 'PFCERUVA'

			insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
				select IdTabla, '</Entidades>'
				from #TEMP_ACTIVOS
					INNER JOIN PLAZOSFIJOS ON PLAZOSFIJOS.CodPlazoFijo = #TEMP_ACTIVOS.CodOperacion
										and PLAZOSFIJOS.CodFondo = #TEMP_ACTIVOS.CodFondo
					INNER JOIN BANCOS on BANCOS.CodBanco = PLAZOSFIJOS.CodBanco 
						LEFT JOIN EMISORES on EMISORES.CodEmisor = BANCOS.CodEmisor 
						left join PAISES on PAISES.CodPais = EMISORES.CodPais 
				where OrigenActivo like 'PFCERUVA'
		end
		
		-- PF TRADICIONAL
		if (select COUNT(*)
			from #TEMP_ACTIVOS
				 INNER JOIN OPERFINANCIERAS ON OPERFINANCIERAS.CodOperFinanciera = #TEMP_ACTIVOS.CodOperacion
												and OPERFINANCIERAS.CodFondo = #TEMP_ACTIVOS.CodFondo
				 INNER JOIN BANCOS on BANCOS.CodBanco = OPERFINANCIERAS.CodBanco 
					LEFT JOIN EMISORES on EMISORES.CodEmisor = BANCOS.CodEmisor 
					left join PAISES on PAISES.CodPais = EMISORES.CodPais 
			where OrigenActivo like 'PF')>0 
		begin 
			insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
				select IdTabla, '<Entidades>'
				from #TEMP_ACTIVOS
					INNER JOIN OPERFINANCIERAS ON OPERFINANCIERAS.CodOperFinanciera = #TEMP_ACTIVOS.CodOperacion
												and OPERFINANCIERAS.CodFondo = #TEMP_ACTIVOS.CodFondo
					 INNER JOIN BANCOS on BANCOS.CodBanco = OPERFINANCIERAS.CodBanco 
						LEFT JOIN EMISORES on EMISORES.CodEmisor = BANCOS.CodEmisor 
						left join PAISES on PAISES.CodPais = EMISORES.CodPais 
				where OrigenActivo like 'PF'

			insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
				select IdTabla, '<Entidad>' +
						'<TipoEntNom>Entidad Emisora</TipoEntNom>'+
						'<TipoEntId>13</TipoEntId>'+
						case when dbo.fnSacarCaracteresEspXML(coalesce(EMISORES.Descripcion,'')) = '' then '<EntNom/>' else '<EntNom>' + dbo.fnSacarCaracteresEspXML(coalesce(EMISORES.Descripcion,'')) + '</EntNom>' end +
						'<EntTic/>' +
						'<EntTTic/>' +
						case when COALESCE(PAISES.Descripcion,'') = '' then '<PaisNom/>' else '<PaisNom>' + dbo.fnSacarCaracteresEspXML(COALESCE(PAISES.Descripcion,''))  + '</PaisNom>' end +
						case when coalesce(PAISES.CodCAFCI,'') <> '' then '<PaisTCod>C</PaisTCod>' else '<PaisTCod/>' end + 
						case when coalesce(PAISES.CodCAFCI,'') = '' then '<PaisCod/>' else '<PaisCod>' + dbo.fnSacarCaracteresEspXML(coalesce(PAISES.CodCAFCI,'')) + '</PaisCod>' end +
						'<ActNom/>' +
						'<ActNomId/>' +
						'</Entidad>'
				from #TEMP_ACTIVOS
					INNER JOIN OPERFINANCIERAS ON OPERFINANCIERAS.CodOperFinanciera = #TEMP_ACTIVOS.CodOperacion
												and OPERFINANCIERAS.CodFondo = #TEMP_ACTIVOS.CodFondo
					 INNER JOIN BANCOS on BANCOS.CodBanco = OPERFINANCIERAS.CodBanco 
						LEFT JOIN EMISORES on EMISORES.CodEmisor = BANCOS.CodEmisor 
						left join PAISES on PAISES.CodPais = EMISORES.CodPais 
				where OrigenActivo like 'PF'
			
			insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
				select IdTabla, '</Entidades>'
				from #TEMP_ACTIVOS
					INNER JOIN OPERFINANCIERAS ON OPERFINANCIERAS.CodOperFinanciera = #TEMP_ACTIVOS.CodOperacion
												and OPERFINANCIERAS.CodFondo = #TEMP_ACTIVOS.CodFondo
					 INNER JOIN BANCOS on BANCOS.CodBanco = OPERFINANCIERAS.CodBanco 
						LEFT JOIN EMISORES on EMISORES.CodEmisor = BANCOS.CodEmisor 
						left join PAISES on PAISES.CodPais = EMISORES.CodPais 
				where OrigenActivo like 'PF'
		end

		/*Guarda registro defauld para los Idtablas correspondientes*/
		insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
			select IdTabla, '<Entidades><Entidad>
								<TipoEntNom/>
								<TipoEntId/>
								<EntNom/>
								<EntTic/>
								<EntTTic/>
								<PaisNom/>
								<PaisTCod/>
								<PaisCod/>
								<ActNom/>
								<ActNomId/>
								</Entidad></Entidades>'
			from #TEMP_ACTIVOS				  
			where OrigenActivo IN ('PF','PFCERUVA')
			AND NOT EXISTS (SELECT 1
							FROM #CAFCIUNIFICADA_Tag_Activo_Entidades
							WHERE #CAFCIUNIFICADA_Tag_Activo_Entidades.IdTabla = #TEMP_ACTIVOS.IdTabla)

		
		/********************************************************************/
		/*FECHAS*/
		/********************************************************************/
		IF EXISTS (SELECT 1 FROM #TEMP_ACTIVOS where OrigenActivo IN ('PF','PFCERUVA'))
		BEGIN
			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select distinct IdTabla, '<Fechas>'
				from #TEMP_ACTIVOS
				where OrigenActivo IN ('PF','PFCERUVA')

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
					select IdTabla, case when #TEMP_ACTIVOS.FeOr is null then 
									'<Fecha>'+
									'<TipoFechaNom/>'+
									'<FechaDato/>'+
									'<TipoFechaId/>'+
									'</Fecha>'
							else
									'<Fecha>'+
									'<TipoFechaNom>Origen de la Inversión</TipoFechaNom>'+
									'<FechaDato>' + convert(varchar(10),#TEMP_ACTIVOS.FeOr,120) + '</FechaDato>'+
									'<TipoFechaId>4</TipoFechaId>'+
									'</Fecha>'
							end
					from #TEMP_ACTIVOS
					where OrigenActivo IN ('PF','PFCERUVA')
					--FeVto
				union all
					select IdTabla, case when #TEMP_ACTIVOS.FeVto is null then 
									'<Fecha>'+
									'<TipoFechaNom/>'+
									'<FechaDato/>'+
									'<TipoFechaId/>'+
									'</Fecha>'
							else
									'<Fecha>'+
									'<TipoFechaNom>Vencimiento de la Inversión</TipoFechaNom>'+
									'<FechaDato>' + convert(varchar(10),#TEMP_ACTIVOS.FeVto,120) + '</FechaDato>'+
									'<TipoFechaId>3</TipoFechaId>'+
									'</Fecha>'
							end
					from #TEMP_ACTIVOS
					where OrigenActivo IN ('PF','PFCERUVA')

			
			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select IdTabla, '<Fecha>'+
									'<TipoFechaNom>Precancelación PFP</TipoFechaNom>'+
									'<FechaDato>' + convert(varchar(10),#TEMP_ACTIVOS.PFPreF,120) + '</FechaDato>'+
									'<TipoFechaId>6</TipoFechaId>'+
								'</Fecha>'
				from #TEMP_ACTIVOS
				where OrigenActivo IN ('PF')
				AND PFPre = 'S'
				AND NOT PFPreF IS NULL
			

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select distinct IdTabla, '</Fechas>'
				from #TEMP_ACTIVOS
				where OrigenActivo IN ('PF','PFCERUVA')
		END

		

		/********************************************************************/
		/*TICKERS*/
		/********************************************************************/
		-- UVA - CER
		if exists (select IdTabla 
					from #TEMP_ACTIVOS
					INNER JOIN PLAZOSFIJOS ON PLAZOSFIJOS.CodPlazoFijo = #TEMP_ACTIVOS.CodOperacion
												and PLAZOSFIJOS.CodFondo = #TEMP_ACTIVOS.CodFondo
					where OrigenActivo like 'PFCERUVA' and coalesce(PLAZOSFIJOS.CodCAFCI,'') <> '') 
		begin
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				--select min(IdTabla),'<Tickers>' from #TEMP_ACTIVOS
				select distinct IdTabla,'<Tickers>' from #TEMP_ACTIVOS
					INNER JOIN PLAZOSFIJOS ON PLAZOSFIJOS.CodPlazoFijo = #TEMP_ACTIVOS.CodOperacion
													and PLAZOSFIJOS.CodFondo = #TEMP_ACTIVOS.CodFondo
				where OrigenActivo like 'PFCERUVA' and coalesce(PLAZOSFIJOS.CodCAFCI,'') <> ''

			
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select IdTabla, 
				'<Ticker>' +
				'<ActTicEnt>CAFCI</ActTicEnt>' +
				case when coalesce(PLAZOSFIJOS.CodCAFCI,'') = '' then '<ActTic/>' else '<ActTic>' + ltrim(rtrim(dbo.fnSacarCaracteresEspXML(coalesce(PLAZOSFIJOS.CodCAFCI,''))))  + '</ActTic>' end +
				'<ActTTicId>M</ActTTicId>' +
				'<ActMonCotId/>' +
				'<ActMerCotId/>' +
				'</Ticker>'
				from #TEMP_ACTIVOS
					INNER JOIN PLAZOSFIJOS ON PLAZOSFIJOS.CodPlazoFijo = #TEMP_ACTIVOS.CodOperacion
													and PLAZOSFIJOS.CodFondo = #TEMP_ACTIVOS.CodFondo
				where OrigenActivo like 'PFCERUVA' and coalesce(PLAZOSFIJOS.CodCAFCI,'') <> ''

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				--select max(IdTabla),'</Tickers>' 
				select distinct IdTabla,'</Tickers>' 
				from #TEMP_ACTIVOS
					INNER JOIN PLAZOSFIJOS ON PLAZOSFIJOS.CodPlazoFijo = #TEMP_ACTIVOS.CodOperacion
													and PLAZOSFIJOS.CodFondo = #TEMP_ACTIVOS.CodFondo
				where OrigenActivo like 'PFCERUVA' and coalesce(PLAZOSFIJOS.CodCAFCI,'') <> ''

				--Select * from PLAZOSFIJOS where CodFondo = 1
				--Se
		end
		
		--PF TRADICIONAL
		if EXISTS (select IdTabla 
					from #TEMP_ACTIVOS
					INNER JOIN OPERFINANCIERAS ON OPERFINANCIERAS.CodOperFinanciera = #TEMP_ACTIVOS.CodOperacion
												and OPERFINANCIERAS.CodFondo = #TEMP_ACTIVOS.CodFondo
					INNER JOIN OPERFINPZOFIJO ON OPERFINPZOFIJO.CodFondo = OPERFINANCIERAS.CodFondo AND OPERFINPZOFIJO.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
					where OrigenActivo like 'PF' and coalesce(OPERFINPZOFIJO.CodCAFCI,'') <> '')
		begin
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				--select min(IdTabla),'<Tickers>' from #TEMP_ACTIVOS
				select distinct IdTabla,'<Tickers>' from #TEMP_ACTIVOS
					INNER JOIN OPERFINANCIERAS ON OPERFINANCIERAS.CodOperFinanciera = #TEMP_ACTIVOS.CodOperacion
												and OPERFINANCIERAS.CodFondo = #TEMP_ACTIVOS.CodFondo
					INNER JOIN OPERFINPZOFIJO ON OPERFINPZOFIJO.CodFondo = OPERFINANCIERAS.CodFondo AND OPERFINPZOFIJO.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
					where OrigenActivo like 'PF' and coalesce(OPERFINPZOFIJO.CodCAFCI,'') <> '' 
			
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select IdTabla, 
				'<Ticker>' +
				'<ActTicEnt>CAFCI</ActTicEnt>' +
				case when coalesce(OPERFINPZOFIJO.CodCAFCI,'') = '' then '<ActTic/>' else '<ActTic>' + ltrim(rtrim(dbo.fnSacarCaracteresEspXML(coalesce(OPERFINPZOFIJO.CodCAFCI,''))))  + '</ActTic>' end +
				'<ActTTicId>M</ActTTicId>' +
				'<ActMonCotId/>' +
				'<ActMerCotId/>' +
				'</Ticker>'
				from #TEMP_ACTIVOS
					INNER JOIN OPERFINANCIERAS ON OPERFINANCIERAS.CodOperFinanciera = #TEMP_ACTIVOS.CodOperacion
												and OPERFINANCIERAS.CodFondo = #TEMP_ACTIVOS.CodFondo
					INNER JOIN OPERFINPZOFIJO ON OPERFINPZOFIJO.CodFondo = OPERFINANCIERAS.CodFondo AND OPERFINPZOFIJO.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
				where OrigenActivo like 'PF' and coalesce(OPERFINPZOFIJO.CodCAFCI,'') <> ''

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				--select max(IdTabla),'</Tickers>' 
				select distinct IdTabla,'</Tickers>' 
				from #TEMP_ACTIVOS
					INNER JOIN OPERFINANCIERAS ON OPERFINANCIERAS.CodOperFinanciera = #TEMP_ACTIVOS.CodOperacion
												and OPERFINANCIERAS.CodFondo = #TEMP_ACTIVOS.CodFondo
					INNER JOIN OPERFINPZOFIJO ON OPERFINPZOFIJO.CodFondo = OPERFINANCIERAS.CodFondo AND OPERFINPZOFIJO.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
				where OrigenActivo like 'PF' and coalesce(OPERFINPZOFIJO.CodCAFCI,'') <> ''
		end

		/*Guarda registro defauld para los Idtablas correspondientes*/
		insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
			select IdTabla, '<Tickers>
						<Ticker>
						<ActTicEnt/>
						<ActTic/>
						<ActTTicId/>
						<ActMonCotId/>
						<ActMerCotId/>
						</Ticker>
						</Tickers>'
			from #TEMP_ACTIVOS				  
			where OrigenActivo IN ('PF','PFCERUVA')
			AND NOT EXISTS (SELECT 1
							FROM #CAFCIUNIFICADA_Tag_Activo_Tickers
							WHERE #CAFCIUNIFICADA_Tag_Activo_Tickers.IdTabla = #TEMP_ACTIVOS.IdTabla)
		


	
	/**/
	--sELECT * fROM #CAFCIUNIFICADA_Tag_Activo_Tickers order by IdTabla

	--EXEC dbo.spGDIN_IntefazCAFCI796 1,'20190712', 1,-1,-1,0

go


exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Activo_APC'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Activo_APC
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @CodPais           CodigoMedio
    DECLARE @FechaLiquidez     Fecha

    SELECT  @CodPais = CodPais FROM PARAMETROSREL
    EXEC sp_dfxSumarDiasHabiles @FechaProceso, 1, @FechaLiquidez OUTPUT, @CodPais

	DECLARE @CodMonedaCursoLgl CodigoMedio
	select @CodMonedaCursoLgl = CodMonedaCursoLgl from PARAMETROSREL

	--variables CURSOR
	DECLARE @Cur_CodFondo CodigoMedio
	DECLARE @Cur_CodPaseCau CodigoLargo
	DECLARE @Cur_MonCoti CodigoMedio
	DECLARE @Cur_MonFdo CodigoMedio
	DECLARE @Cur_TpCambio Precio

    -- temporales para APC
    CREATE TABLE #CAFCISEMANAL_OPERAPC
       (CodFondo numeric(5) NOT NULL,
        CodPaseCau numeric(5) NOT NULL,
        CapitalInicial numeric(19, 2) NOT NULL,
        CapitalActual numeric(22, 2) NOT NULL,
        CapitalFinal numeric(22, 2) NOT NULL,
        TasaInteres numeric(22, 10) NOT NULL,
		FactorConvOperFdo numeric(20,12) NULL, 
        TpCambio               varchar(1) COLLATE database_default NULL
        )
		
    INSERT INTO #CAFCISEMANAL_OPERAPC (CodFondo, CodPaseCau, CapitalInicial, CapitalActual, CapitalFinal, TasaInteres)
    SELECT  PASESCAU.CodFondo,
            PASESCAU.CodPaseCau,
            convert(numeric(19,2),CASE WHEN OBCTP.EsDebito = 0 Then /* No es Debito */
               ((OBC.Bruto * convert(numeric(19,2),OBC.FactConvMonCargaOperacion))) + (( OBC.Arancel + OBC.Impuesto + OBC.DerechoBolsa + OBC.DerechoMercado + OBC.GastosSEC) * convert(numeric(19,2),OBC.FactConvMonCargaOperacion))
            ELSE
               ((OBC.Bruto * convert(numeric(19,2),OBC.FactConvMonCargaOperacion))) - (( OBC.Arancel + OBC.Impuesto + OBC.DerechoBolsa + OBC.DerechoMercado + OBC.GastosSEC) * convert(numeric(19,2),OBC.FactConvMonCargaOperacion))
            END) AS CapitalInicial,
            0 AS CapitalActual,
            convert(numeric(19,2),CASE WHEN OBFTP.EsDebito = 0 Then /* No es Debito */
               ((OBF.Bruto * convert(numeric(19,2),OBF.FactConvMonCargaOperacion))) + (( OBF.Arancel + OBF.Impuesto + OBF.DerechoBolsa + OBF.DerechoMercado + OBF.GastosSEC) * convert(numeric(19,2),OBF.FactConvMonCargaOperacion))
            ELSE
               ((OBF.Bruto * convert(numeric(19,2),OBF.FactConvMonCargaOperacion))) - (( OBF.Arancel + OBF.Impuesto + OBF.DerechoBolsa + OBF.DerechoMercado + OBF.GastosSEC) * convert(numeric(19,2),OBF.FactConvMonCargaOperacion))
            END) AS CapitalFinal,
			
			convert(numeric(22,10),CASE WHEN DATEDIFF(dd, OBC.FechaLiquidacion, OBF.FechaLiquidacion) = 0
                 THEN 0
                 ELSE 
				 
					CONVERT(float,
						(
							(
								( CONVERT(float,
									(OBF.Bruto - CONVERT(float,
										(
											(
												OBF.Arancel + OBF.Impuesto + OBF.DerechoBolsa + OBF.DerechoMercado + OBF.GastosSEC
											) 
											* 
											(
												1 / OBF.FactConvMonCargaGasto
											)
										)
									)
								)
							)
                    / CONVERT(float,
						(
							OBC.Bruto + CONVERT(float,
								(
									(
										OBC.Arancel + OBC.Impuesto + OBC.DerechoBolsa + OBC.DerechoMercado + OBC.GastosSEC
									) 
									* 
									(
										1 / OBC.FactConvMonCargaGasto
									)
								)
							)
						)
					)
				) 
				- 
				1
			) 
			* 
			36500
		)
	)
	/ DATEDIFF(dd, OBC.FechaLiquidacion, OBF.FechaLiquidacion)

            END) AS TasaInteres
    FROM    PASESCAU
            INNER JOIN OPERBURSATILES OBC
                    ON OBC.CodFondo = PASESCAU.CodFondo
                   AND OBC.CodPaseCau = PASESCAU.CodPaseCau
                   AND OBC.CodTpOperacion IN ('APCC', 'CCC', 'PCC')
                   AND OBC.FechaConcertacion <= @FechaProceso
                   AND OBC.FechaD IS NULL 
            INNER JOIN TPOPERACION OBCTP ON OBCTP.CodTpOperacion = OBC.CodTpOperacion
            INNER JOIN OPERBURSATILES OBF
                    ON OBF.CodFondo = PASESCAU.CodFondo
                   AND OBF.CodPaseCau = PASESCAU.CodPaseCau
                   AND OBF.CodTpOperacion IN ('APCF', 'CCF', 'PCF')
                   AND OBF.FechaLiquidacion >= @FechaProceso
                   AND OBF.FechaD IS NULL
            INNER JOIN TPOPERACION OBFTP ON OBFTP.CodTpOperacion = OBF.CodTpOperacion
    WHERE   PASESCAU.CodFondo = @CodFondo
        AND PASESCAU.EstaAnulado = 0
    GROUP BY PASESCAU.CodFondo, PASESCAU.CodPaseCau,
             OBC.Bruto, OBC.Arancel, OBC.Impuesto, OBC.DerechoBolsa, OBC.DerechoMercado, OBC.GastosSEC,
             OBF.Bruto, OBF.Arancel, OBF.Impuesto, OBF.DerechoBolsa, OBF.DerechoMercado, OBF.GastosSEC,
             OBC.FactConvMonCargaOperacion, OBC.FactConvMonCargaGasto, OBC.FechaLiquidacion, OBCTP.EsDebito,
             OBF.FactConvMonCargaOperacion, OBF.FactConvMonCargaGasto, OBF.FechaLiquidacion, OBFTP.EsDebito
    ORDER BY PASESCAU.CodFondo, PASESCAU.CodPaseCau
	

    --capital actual
    UPDATE  #CAFCISEMANAL_OPERAPC
    SET     CapitalActual = CapitalInicial + COALESCE((SELECT  SUM(ImporteMonOp)
                                                       FROM    OPERBURSHIST
                                                       WHERE   OPERBURSHIST.CodFondo = #CAFCISEMANAL_OPERAPC.CodFondo 
                                                           AND OPERBURSHIST.CodPaseCau = #CAFCISEMANAL_OPERAPC.CodPaseCau
                                                           AND OPERBURSHIST.CodTpMovimiento = 'IMPDEV'
                                                           AND OPERBURSHIST.Fecha <= @FechaProceso), 0)

    --anticipos
    CREATE TABLE #CAFCISEMANAL_ANTICIPOS
       (CodPaseCau numeric(5) NOT NULL,
        CodFondo numeric(5) NOT NULL,
        Capital numeric(19,2) NOT NULL,
        Interes numeric(19,2) NOT NULL,
        InteresTotal numeric(19,2) NOT NULL)
    
    INSERT  INTO #CAFCISEMANAL_ANTICIPOS
    SELECT  #CAFCISEMANAL_OPERAPC.CodPaseCau,
            #CAFCISEMANAL_OPERAPC.CodFondo,
            SUM(ANTICPASESCAU.Capital * ANTICPASESCAU.FactConvMonCargaOperacion) AS Capital,
           (SELECT  SUM(ImporteMonOp) FROM OPERBURSHIST
            WHERE   OPERBURSHIST.CodFondo = #CAFCISEMANAL_OPERAPC.CodFondo AND OPERBURSHIST.CodPaseCau = #CAFCISEMANAL_OPERAPC.CodPaseCau
                AND (OPERBURSHIST.CodTpMovimiento = 'IMPANT' OR OPERBURSHIST.CodTpMovimiento = 'IMPDEV')
                AND OPERBURSHIST.Fecha <= @FechaProceso) AS Interes,
            SUM(ANTICPASESCAU.Interes * ANTICPASESCAU.FactConvMonCargaOperacion) AS InteresTotal
    FROM    #CAFCISEMANAL_OPERAPC INNER JOIN ANTICPASESCAU ON ANTICPASESCAU.CodFondo = #CAFCISEMANAL_OPERAPC.CodFondo AND ANTICPASESCAU.CodPaseCau = #CAFCISEMANAL_OPERAPC.CodPaseCau
    WHERE   ANTICPASESCAU.Fecha <= @FechaProceso AND ANTICPASESCAU.EstaAnulado = 0
    GROUP BY #CAFCISEMANAL_OPERAPC.CodPaseCau, #CAFCISEMANAL_OPERAPC.CodFondo

	
    UPDATE  #CAFCISEMANAL_OPERAPC
    SET     CapitalInicial = CapitalInicial - #CAFCISEMANAL_ANTICIPOS.Capital,
            CapitalActual = CapitalInicial - #CAFCISEMANAL_ANTICIPOS.Capital + (#CAFCISEMANAL_ANTICIPOS.Interes - #CAFCISEMANAL_ANTICIPOS.InteresTotal),
            CapitalFinal = CapitalFinal - #CAFCISEMANAL_ANTICIPOS.Capital - #CAFCISEMANAL_ANTICIPOS.InteresTotal
    FROM    #CAFCISEMANAL_OPERAPC
            INNER JOIN #CAFCISEMANAL_ANTICIPOS
                    ON #CAFCISEMANAL_ANTICIPOS.CodFondo = #CAFCISEMANAL_OPERAPC.CodFondo
                   AND #CAFCISEMANAL_ANTICIPOS.CodPaseCau = #CAFCISEMANAL_OPERAPC.CodPaseCau


    DELETE  #CAFCISEMANAL_OPERAPC
    WHERE   CapitalFinal <= 0

	--TPCAMBIO PASES Y CAUCIONES
    DECLARE cursor_CambioPaseCau cursor for
		SELECT	#CAFCISEMANAL_OPERAPC.CodFondo,
				#CAFCISEMANAL_OPERAPC.CodPaseCau,
				OPERBURS.CodMonedaOperacion,
				FONDOS.CodMoneda
		FROM #CAFCISEMANAL_OPERAPC
		INNER JOIN PASESCAU ON PASESCAU.CodFondo = #CAFCISEMANAL_OPERAPC.CodFondo
        INNER JOIN OPERBURSATILES OPERBURS ON OPERBURS.CodFondo = PASESCAU.CodFondo
                   AND OPERBURS.CodPaseCau = PASESCAU.CodPaseCau		
			AND PASESCAU.CodPaseCau =  #CAFCISEMANAL_OPERAPC.CodPaseCau
		INNER JOIN FONDOS ON FONDOS.CodFondo = #CAFCISEMANAL_OPERAPC.CodFondo

    OPEN cursor_CambioPaseCau

    FETCH NEXT FROM cursor_CambioPaseCau INTO @Cur_CodFondo, @Cur_CodPaseCau, @Cur_MonCoti, @Cur_MonFdo

    DECLARE @EsVendedor	Boolean

    WHILE @@FETCH_STATUS = 0
    BEGIN
        exec spXCalcularUltCambioActPas -1, @Cur_CodFondo, @Cur_MonCoti, @Cur_MonFdo,@FechaProceso , @Cur_TpCambio OUTPUT, @EsVendedor OUTPUT

        UPDATE #CAFCISEMANAL_OPERAPC
		    SET FactorConvOperFdo = @Cur_TpCambio
                ,TpCambio = (case when @EsVendedor = -1 then 'V' ELSE 'C' END)
		WHERE CodFondo = @Cur_CodFondo AND CodPaseCau = @Cur_CodPaseCau

        FETCH NEXT FROM cursor_CambioPaseCau  INTO @Cur_CodFondo, @Cur_CodPaseCau, @Cur_MonCoti, @Cur_MonFdo
    END

    CLOSE cursor_CambioPaseCau
    DEALLOCATE cursor_CambioPaseCau
	--*****	

    --apc
	
	DECLARE @PaisDescripcionArg DescripcionMedia 
	DECLARE @PaisCodCafciArg CodigoInterfazLargo
	
	SELECT @PaisDescripcionArg = Descripcion, @PaisCodCafciArg = CodCAFCI FROM PAISES WHERE CodCAFCI = 'AR'
	
	insert into #TEMP_ACTIVOS(CodFondo, CodOperacion, Nro,
		ActTTic,ActTic,ActNom,EntENom,EntONom,MerTCod,MerCod,MerNom,MonActTCod,
		MonActCod,MonActNom,Cant,CantCot,Pre,MtoMAct,TCCod,MtoMFdo,Cl,SCl,TTasa,
		TNA,MtoAc,FeOr,FeVto,Plazo,PFTra,PFPre,PFPreInm,PFPreF,ML,ClId,AA,CodImpAct,NomClImp, NomSClImp, NomImpAct,
		PaisNomEmi, PaisNomEmiTCod, PaisNomEmiCod, PaisNomNeg, PaisNomNegTCod, PaisNomNegCod, CtaCteRem,
		ASNom,ASTic,ASTTic,OrigenActivo)
    SELECT  #CAFCISEMANAL_OPERAPC.CodFondo,
            #CAFCISEMANAL_OPERAPC.CodPaseCau,
			0 as Nro,
            'M' AS TTCod,
            ISNULL(OBC.CodCAFCI, '') AS TNom,
            COALESCE(OBC.NumeroOperacionBursatil + '/' + OBF.NumeroOperacionBursatil, '') AS AcNomCor,
            dbo.fnSacarCaracteresEspXML(ISNULL(AGENTES.Descripcion, '')) AS EENom,
            '' AS EONom,
            'C' AS MeTCod,
            'NA' AS MeCod,
            '' AS MeNom,
            'C' AS MoTCod,
            COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '') AS MoCod,
            dbo.fnSacarCaracteresEspXML(ISNULL(MONCOTI.Descripcion, '')) AS MoNom,
            1 AS Q,
            1 AS QC,
            0 AS P,
            ABS(#CAFCISEMANAL_OPERAPC.CapitalInicial) AS MontoMO,
            COALESCE(#CAFCISEMANAL_OPERAPC.TpCambio, 'N') AS TCCod,
            ABS(CONVERT(float,#CAFCISEMANAL_OPERAPC.CapitalActual) * CONVERT(float,FactorConvOperFdo)) AS MontoMF,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPOPERACION.Descripcion, '')) AS ClNom,
            dbo.fnSacarCaracteresEspXML(COALESCE(ESPECIES.Descripcion, '')) AS SClNom,
            'F' AS TTasa,
            #CAFCISEMANAL_OPERAPC.TasaInteres AS TNA,
            ABS(#CAFCISEMANAL_OPERAPC.CapitalActual) AS MontoAc,
            OBF.FechaConcertacion AS FeOr,
            OBF.FechaLiquidacion AS FeVto,
            OBF.Plazo AS Pzo,
            'N' AS PFTr,
            'N' AS PFPr,
            '' AS PFPrIn,
            NULL AS PFFePr,
            CASE OBF.FechaLiquidacion WHEN @FechaLiquidez THEN 'S' ELSE 'N' END AS MLiq,
			#CAFCISEMANAL_OPERAPC.CodPaseCau ClId,
			dbo.fnFechaOperaciones(-1,@FechaProceso) as 'AA',
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIP.Descripcion,'')) as NomClImp, 
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomSClImp, 
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomImpAct,
			dbo.fnSacarCaracteresEspXML(COALESCE(@PaisDescripcionArg,'')) as PaisNomEmi, 
			case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(@PaisCodCafciArg,'')) as PaisNomEmiCod, 
			dbo.fnSacarCaracteresEspXML(COALESCE(@PaisDescripcionArg,'')) as PaisNomNeg, 
			case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(@PaisCodCafciArg,'')) as PaisNomNegCod,
			'' as CtaCteRem,
			'' AS ASNom,
			'' AS ASTic,
			'' AS ASTTic,
			'APC' as OrigenActivo
    FROM    PASESCAU
            INNER JOIN FONDOS ON FONDOS.CodFondo = PASESCAU.CodFondo
            INNER JOIN #CAFCISEMANAL_OPERAPC
                    ON #CAFCISEMANAL_OPERAPC.CodFondo = PASESCAU.CodFondo
                   AND #CAFCISEMANAL_OPERAPC.CodPaseCau = PASESCAU.CodPaseCau
            INNER JOIN OPERBURSATILES OBC
                    ON OBC.CodFondo = PASESCAU.CodFondo
                   AND OBC.CodPaseCau = PASESCAU.CodPaseCau
                   AND OBC.CodTpOperacion IN ('APCC', 'CCC', 'PCC')
                   AND OBC.FechaConcertacion <= @FechaProceso
                   AND OBC.FechaD IS NULL 
            INNER JOIN OPERBURSATILES OBF
                    ON OBF.CodFondo = PASESCAU.CodFondo
                   AND OBF.CodPaseCau = PASESCAU.CodPaseCau
                   AND OBF.CodTpOperacion IN ('APCF', 'CCF', 'PCF')
                   AND OBF.FechaLiquidacion > @FechaProceso
                   AND OBF.FechaD IS NULL
            INNER JOIN TPOPERACION ON TPOPERACION.CodTpOperacion = OBC.CodTpOperacion
            LEFT  JOIN ESPECIES ON ESPECIES.CodEspecie = OBC.CodEspecie
				left JOIN EMISORES 
					left JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais
				ON EMISORES.CodEmisor = ESPECIES.CodEmisor
            LEFT  JOIN AGENTES ON AGENTES.CodAgente = OBC.CodAgente
            LEFT  JOIN MONEDAS MONCOTI ON MONCOTI.CodMoneda = OBC.CodMonedaOperacion
            LEFT  JOIN COTIZACIONESMON
                    ON COTIZACIONESMON.CodFondo = PASESCAU.CodFondo
                   AND COTIZACIONESMON.CodMoneda = OBC.CodMonedaOperacion
                   AND COTIZACIONESMON.Fecha = (SELECT  MAX(Fecha)
                                                FROM    COTIZACIONESMON COTMON
                                                WHERE   COTMON.CodFondo = COTIZACIONESMON.CodFondo
                                                    AND COTMON.CodMoneda = COTIZACIONESMON.CodMoneda
                                                    AND COTMON.Fecha <= @FechaProceso)
            LEFT  JOIN COTIZACIONESMON COTFDO ON COTFDO.CodFondo = FONDOS.CodFondo AND COTFDO.CodMoneda = FONDOS.CodMoneda AND COTFDO.Fecha = @FechaProceso
			left JOIN MERCADOS 
				inner join PAISES PAISMERCADO on PAISMERCADO.CodPais = MERCADOS.CodPais
			ON MERCADOS.CodMercado = OBC.CodMercado 
			LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = OBC.CodTpActivoAfipIt 
			LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 

	insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
		select IdTabla, '<Entidades><Entidad>
				<TipoEntNom/>
				<TipoEntId/>
				<EntNom/>
				<EntTic/>
				<EntTTic/>
				<PaisNom/>
				<PaisTCod/>
				<PaisCod/>
				<ActNom/>
				<ActNomId/>
				</Entidad></Entidades>'
		from #TEMP_ACTIVOS
		where OrigenActivo like 'APC'
			
		/*FECHAS*/
		IF EXISTS (SELECT 1 from #TEMP_ACTIVOS where OrigenActivo like 'APC')
		BEGIN
			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select distinct IdTabla, '<Fechas>'
				from #TEMP_ACTIVOS
				where OrigenActivo like 'APC'
			
			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
					select IdTabla, case when #TEMP_ACTIVOS.FeOr is null then 
									'<Fecha>'+
									'<TipoFechaNom/>'+
									'<FechaDato/>'+
									'<TipoFechaId/>'+
									'</Fecha>'
							else
									'<Fecha>'+
									'<TipoFechaNom>Origen de la Inversión</TipoFechaNom>'+
									'<FechaDato>' + convert(varchar(10),#TEMP_ACTIVOS.FeOr,120) + '</FechaDato>'+
									'<TipoFechaId>4</TipoFechaId>'+
									'</Fecha>'
							end
					from #TEMP_ACTIVOS
					where OrigenActivo like 'APC'
				union all --FeVto
					select IdTabla, case when #TEMP_ACTIVOS.FeVto is null then 
									'<Fecha>'+
									'<TipoFechaNom/>'+
									'<FechaDato/>'+
									'<TipoFechaId/>'+
									'</Fecha>'
							else
									'<Fecha>'+
									'<TipoFechaNom>Vencimiento de la Inversión</TipoFechaNom>'+
									'<FechaDato>' + convert(varchar(10),#TEMP_ACTIVOS.FeVto,120) + '</FechaDato>'+
									'<TipoFechaId>3</TipoFechaId>'+
									'</Fecha>'
							end
					from #TEMP_ACTIVOS
					where OrigenActivo like 'APC'

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select distinct IdTabla, '</Fechas>'
				from #TEMP_ACTIVOS
				where OrigenActivo like 'APC'
		END
		
		/*TICKERS*/
		if exists (select IdTabla from #TEMP_ACTIVOS
				inner join OPERBURSATILES on OPERBURSATILES.CodPaseCau = #TEMP_ACTIVOS.CodOperacion 
										and OPERBURSATILES.CodFondo = @CodFondo 
			where OrigenActivo like 'APC' and coalesce(OPERBURSATILES.CodCAFCI,'') <> '')
		begin
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, '<Tickers>'
				from #TEMP_ACTIVOS
					inner join OPERBURSATILES on OPERBURSATILES.CodPaseCau = #TEMP_ACTIVOS.CodOperacion 
											and OPERBURSATILES.CodFondo = @CodFondo 
				where OrigenActivo like 'APC' and coalesce(OPERBURSATILES.CodCAFCI,'') <> ''

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, 
				'<Ticker>' +
				'<ActTicEnt>CAFCI</ActTicEnt>' +
				case when dbo.fnSacarCaracteresEspXML(coalesce(OPERBURSATILES.CodCAFCI,'')) = '' then '<ActTic/>' else '<ActTic>' + ltrim(rtrim(dbo.fnSacarCaracteresEspXML(coalesce(OPERBURSATILES.CodCAFCI,''))))  + '</ActTic>' end +
				'<ActTTicId>M</ActTTicId>' +
				'<ActMonCotId/>' +
				'<ActMerCotId/>' +
				'</Ticker>'
				from #TEMP_ACTIVOS
					inner join OPERBURSATILES on OPERBURSATILES.CodPaseCau = #TEMP_ACTIVOS.CodOperacion 
											and OPERBURSATILES.CodFondo = @CodFondo 
				where OrigenActivo like 'APC' and coalesce(OPERBURSATILES.CodCAFCI,'') <> ''

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, '</Tickers>'
				from #TEMP_ACTIVOS
					inner join OPERBURSATILES on OPERBURSATILES.CodPaseCau = #TEMP_ACTIVOS.CodOperacion 
											and OPERBURSATILES.CodFondo = @CodFondo 
				where OrigenActivo like 'APC' and coalesce(OPERBURSATILES.CodCAFCI,'') <> ''

		end
		else
		begin
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select IdTabla, '<Tickers>
						<Ticker>
						<ActTicEnt/>
						<ActTic/>
						<ActTTicId/>
						<ActMonCotId/>
						<ActMerCotId/>
						</Ticker>
						</Tickers>'
				from #TEMP_ACTIVOS
				where OrigenActivo like 'APC'
		end

GO


exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Activo_CtaBancaria'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Activo_CtaBancaria
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @CodMonedaCursoLgl CodigoMedio
	select @CodMonedaCursoLgl = CodMonedaCursoLgl from PARAMETROSREL

	create table #CAFCISEMANAL_CTASBANCARIASFILTER
	(
		CodFondo numeric(5) NOT NULL,
		CodCtaBancaria numeric(5) NOT NULL,
		CodTpCtaAutomatica varchar(6) collate database_default null,
		CodCtaContableCBANC char(19) collate database_default null,
		CodCtaContableINTACO char(19) collate database_default null
	)

    CREATE TABLE #CAFCISEMANAL_CTASBANCARIAS
           (CodFondo numeric(5) NOT NULL,
            CodCtaBancaria numeric(5) NOT NULL,
            SaldoCta numeric(22, 2) NOT NULL,
            SaldoFdo numeric(22, 2) NOT NULL)
    
	CREATE TABLE #TMP_TESORERIA_INTACO (
        CodFondo               numeric(5) not null,
        CodCtaBancaria         numeric(5) not null,
        ImporteDebe            numeric(19,2) not null,
        ImporteHaber           numeric(19,2) not null,
        primary key (CodFondo, CodCtaBancaria)
    )

	CREATE TABLE #TMP_TESORERIA_INTERESES (
        CodFondo               numeric(5) not null,
        CodCtaBancaria         numeric(5) not null,
		--CodMoneda			numeric(5) null,
        InteresesACobrar       numeric(19,2) not null,
        primary key (CodFondo, CodCtaBancaria)
    )

	INSERT INTO #CAFCISEMANAL_CTASBANCARIASFILTER (CodFondo, CodCtaBancaria)
		SELECT CTASBANCARIAS.CodFondo, CTASBANCARIAS.CodCtaBancaria
		FROM CTASBANCARIAS
		WHERE CTASBANCARIAS.CodFondo = @CodFondo

	UPDATE  #CAFCISEMANAL_CTASBANCARIASFILTER
    SET     CodCtaContableCBANC = CTASCONTABLES.CodCtaContable
    FROM    #CAFCISEMANAL_CTASBANCARIASFILTER
            INNER JOIN CTASCONTABLES
                    ON CTASCONTABLES.CodFondo = #CAFCISEMANAL_CTASBANCARIASFILTER.CodFondo
                   AND CTASCONTABLES.CodCtaBancaria = #CAFCISEMANAL_CTASBANCARIASFILTER.CodCtaBancaria
    WHERE   CTASCONTABLES.CodTpCtaAutomatica = 'CBANC'

    UPDATE  #CAFCISEMANAL_CTASBANCARIASFILTER
    SET     CodCtaContableINTACO = CTASCONTABLES.CodCtaContable
    FROM    #CAFCISEMANAL_CTASBANCARIASFILTER
            INNER JOIN CTASCONTABLES
                    ON CTASCONTABLES.CodFondo = #CAFCISEMANAL_CTASBANCARIASFILTER.CodFondo
                   AND CTASCONTABLES.CodCtaBancaria = #CAFCISEMANAL_CTASBANCARIASFILTER.CodCtaBancaria
    WHERE   CTASCONTABLES.CodTpCtaAutomatica = 'INTACO'

    INSERT  INTO #CAFCISEMANAL_CTASBANCARIAS (CodFondo, CodCtaBancaria, SaldoCta, SaldoFdo)
		SELECT  #CAFCISEMANAL_CTASBANCARIASFILTER.CodFondo, #CAFCISEMANAL_CTASBANCARIASFILTER.CodCtaBancaria,
				SUM(CONVERT(NUMERIC(22,2),COALESCE(ImporteDebe, -ImporteHaber, 0) * ISNULL(Coeficiente, 0))) AS SaldoCta,
				SUM(COALESCE(ImporteDebe, -ImporteHaber, 0)) AS SaldoFdo
		FROM    ASIENTOSCAB
				INNER JOIN ASIENTOSIT ON ASIENTOSIT.CodFondo = ASIENTOSCAB.CodFondo 
										 AND ASIENTOSIT.NumAsiento = ASIENTOSCAB.NumAsiento 
				INNER JOIN #CAFCISEMANAL_CTASBANCARIASFILTER ON #CAFCISEMANAL_CTASBANCARIASFILTER.CodFondo = ASIENTOSIT.CodFondo 
																AND #CAFCISEMANAL_CTASBANCARIASFILTER.CodCtaContableCBANC = ASIENTOSIT.CodCtaContable
		WHERE   ASIENTOSCAB.CodFondo = @CodFondo
				AND ASIENTOSCAB.FechaConcertacion <= @FechaProceso
		GROUP BY #CAFCISEMANAL_CTASBANCARIASFILTER.CodFondo, #CAFCISEMANAL_CTASBANCARIASFILTER.CodCtaBancaria
		HAVING SUM(CONVERT(numeric(22,2), COALESCE(ImporteDebe, -ImporteHaber, 0) * ISNULL(Coeficiente, 0))) <> 0

	INSERT  INTO #TMP_TESORERIA_INTACO (CodFondo, CodCtaBancaria, ImporteDebe, ImporteHaber)
		SELECT  CTASBANCARIAS.CodFondo,
				CTASBANCARIAS.CodCtaBancaria,
				SUM(ISNULL(ASIENTOSIT.ImporteDebe * Coeficiente,0) ) AS ImporteDebe,
				SUM(ISNULL(ASIENTOSIT.ImporteHaber * Coeficiente,0)) AS ImporteHaber
		FROM    ASIENTOSCAB
				INNER JOIN ASIENTOSIT
					INNER JOIN #CAFCISEMANAL_CTASBANCARIASFILTER CTASBANCARIAS ON CTASBANCARIAS.CodFondo = ASIENTOSIT.CodFondo
																	AND CTASBANCARIAS.CodCtaContableINTACO = ASIENTOSIT.CodCtaContable
				ON ASIENTOSIT.CodFondo = ASIENTOSCAB.CodFondo
				   AND ASIENTOSIT.NumAsiento = ASIENTOSCAB.NumAsiento
		WHERE ASIENTOSCAB.FechaConcertacion <= ISNULL(@FechaProceso, ASIENTOSCAB.FechaConcertacion)
		GROUP BY CTASBANCARIAS.CodFondo, CTASBANCARIAS.CodCtaBancaria

	INSERT INTO #TMP_TESORERIA_INTERESES (CodFondo, CodCtaBancaria, InteresesACobrar)
		SELECT  CTASBANCARIAS.CodFondo,
				CTASBANCARIAS.CodCtaBancaria,
				--CTASBANCARIAS.CodMoneda,
				ROUND(SUM(COALESCE(ASIENTOSIT.ImporteDebe, -ASIENTOSIT.ImporteHaber) * COALESCE(Coeficiente,0)),2)
		FROM ASIENTOSCAB
			 INNER JOIN ASIENTOSIT
					INNER JOIN #CAFCISEMANAL_CTASBANCARIASFILTER CTASBANCARIAS
							LEFT  JOIN #TMP_TESORERIA_INTACO ON #TMP_TESORERIA_INTACO.CodFondo = CTASBANCARIAS.CodFondo
																AND #TMP_TESORERIA_INTACO.CodCtaBancaria = CTASBANCARIAS.CodCtaBancaria
							ON CTASBANCARIAS.CodFondo = ASIENTOSIT.CodFondo
							AND CTASBANCARIAS.CodCtaContableCBANC = ASIENTOSIT.CodCtaContable
					ON ASIENTOSIT.CodFondo = ASIENTOSCAB.CodFondo
					AND ASIENTOSIT.NumAsiento = ASIENTOSCAB.NumAsiento
					AND NOT (ASIENTOSIT.Coeficiente IS NULL OR ASIENTOSIT.Coeficiente = 0)
		WHERE ASIENTOSCAB.FechaConcertacion <= ISNULL(@FechaProceso, ASIENTOSCAB.FechaConcertacion)
		GROUP BY CTASBANCARIAS.CodFondo, CTASBANCARIAS.CodCtaBancaria
		HAVING ROUND(SUM(COALESCE(ASIENTOSIT.ImporteDebe, -ASIENTOSIT.ImporteHaber) * Coeficiente) ,2) > 0.00

    -- Cuentas Bancarias
	
	insert into #TEMP_ACTIVOS(CodOperacion, Nro,
		ActTTic,ActTic,ActNom,EntENom,EntONom,MerTCod,MerCod,MerNom,MonActTCod,
		MonActCod,MonActNom,Cant,CantCot,Pre,MtoMAct,TCCod,MtoMFdo,Cl,SCl,ML,ClId,AA,CodImpAct,NomClImp, NomSClImp, NomImpAct,
		PaisNomEmi, PaisNomEmiTCod, PaisNomEmiCod, PaisNomNeg, PaisNomNegTCod, PaisNomNegCod, CtaCteRem,
		ASNom,ASTic,ASTTic,IntDevCtasVista,IntDevCtasVistaCap,OrigenActivo)
    SELECT  CTASBANCARIAS.CodCtaBancaria,
			0 as Nro,
            CASE WHEN NOT CTASBANCARIAS.CodCAFCI IS NULL                       THEN 'M'
                 ELSE 'P' --CodInterfaz
            END AS TTCod,
            COALESCE(CTASBANCARIAS.CodCAFCI, CTASBANCARIAS.CodInterfaz, CTASBANCARIAS.NumeroCuenta, '') AS TNom,
            COALESCE(CTASBANCARIAS.NumeroCuenta, '') AS AcNomCor,
            dbo.fnSacarCaracteresEspXML(ISNULL(BANCOS.Descripcion, '')) AS EENom,
            '' AS EONom,
            'C' AS MeTCod,
            'NA' AS MeCod,
            '' AS MeNom,
            'C' AS MoTCod,
            dbo.fnSacarCaracteresEspXML(COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '')) AS MoCod,
            dbo.fnSacarCaracteresEspXML(ISNULL(MONCOTI.Descripcion, '')) AS MoNom,
            1 AS Q,
            1 AS QC,
            0 AS P,
            #CAFCISEMANAL_CTASBANCARIAS.SaldoCta AS MontoMO,
			COALESCE(CASE WHEN (FONDOS.CodMoneda <> MONCOTI.CodMoneda AND @CodMonedaCursoLgl = FONDOS.CodMoneda) THEN
					'C'
				WHEN FONDOS.CodMoneda <> MONCOTI.CodMoneda AND @CodMonedaCursoLgl <> FONDOS.CodMoneda  THEN
					(select top 1 TipoDeCambioCod 
					from #CAFCIUNIFICADA_TPCAMBIO 
					WHERE CodMonedaOrigen = MONCOTI.CodMoneda 
						and CodMonedaDestino = FONDOS.CodMoneda
						AND (convert(Numeric(28,3),CambioOrigen / CambioDestino)) = convert(Numeric(28,3),(SaldoCta / SaldoFdo)))
				ELSE  
					'N' 
			END, 'C') AS TCCod,
            #CAFCISEMANAL_CTASBANCARIAS.SaldoFdo AS MontoMF,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPCTABANCARIA.Descripcion, '')) AS ClNom,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPDEVCTABANCARIA.Descripcion, '')) AS SClNom,
            CASE CTASBANCARIAS.AfectaMargenLiquidez WHEN -1 THEN 'S' ELSE 'N' END AS MLiq,
			CTASBANCARIAS.CodCtaBancaria AS ClId,
			dbo.fnFechaOperaciones(-1,@FechaProceso) as 'AA',
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIP.Descripcion,'')) as NomClImp, 
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomSClImp, 
			dbo.fnSacarCaracteresEspXML(coalesce(TPACTIVOAFIPIT.Descripcion,'')) as NomImpAct,
			dbo.fnSacarCaracteresEspXML(COALESCE(PAISEMI.Descripcion,'')) as PaisNomEmi, --'' as PaisNomEmi, 
			case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, --'' as PaisNomEmiTCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(PAISEMI.CodCAFCI,'')) as PaisNomEmiCod, --'' as PaisNomEmiCod, 
			dbo.fnSacarCaracteresEspXML(COALESCE(PAISMERCADO.Descripcion,'')) as PaisNomNeg,  --'' as PaisNomNeg, 
			case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, --'' as PaisNomNegTCod, 
			dbo.fnSacarCaracteresEspXML(coalesce(PAISMERCADO.CodCAFCI,'')) as PaisNomNegCod, --'' as PaisNomNegCod,
			case when CTASBANCARIAS.CodTpDevCtaBancaria = 'ND' then 'N' else 'S' end as CtaCteRem, 
			'' AS ASNom,
			'' AS ASTic,
			'' AS ASTTic,
			case when CTASBANCARIAS.CodTpDevCtaBancaria = 'ND' then 0 else ISNULL(#TMP_TESORERIA_INTACO.ImporteDebe - #TMP_TESORERIA_INTACO.ImporteHaber,0) end AS IntDevCtasVista,
			case when CTASBANCARIAS.CodTpDevCtaBancaria = 'ND' then 0 else isnull(InteresesACobrar,0) end as IntDevCtasVistaCap,
			'CTABANCARIA' as OrigenActivo
    FROM    CTASBANCARIAS
            INNER JOIN FONDOS ON FONDOS.CodFondo = CTASBANCARIAS.CodFondo
            INNER JOIN #CAFCISEMANAL_CTASBANCARIAS ON #CAFCISEMANAL_CTASBANCARIAS.CodFondo = CTASBANCARIAS.CodFondo AND #CAFCISEMANAL_CTASBANCARIAS.CodCtaBancaria = CTASBANCARIAS.CodCtaBancaria
			INNER JOIN BANCOS ON BANCOS.CodBanco = CTASBANCARIAS.CodBanco
				LEFT JOIN EMISORES 
					INNER JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais
				ON EMISORES.CodEmisor = BANCOS.CodEmisor
			INNER JOIN PAISES PAISMERCADO ON BANCOS.CodPais = PAISMERCADO.CodPais
            LEFT  JOIN MONEDAS MONCOTI ON MONCOTI.CodMoneda = CTASBANCARIAS.CodMoneda
            LEFT  JOIN TPCTABANCARIA ON TPCTABANCARIA.CodTpCtaBancaria = CTASBANCARIAS.CodTpCtaBancaria
            LEFT  JOIN TPDEVCTABANCARIA ON TPDEVCTABANCARIA.CodTpDevCtaBancaria = CTASBANCARIAS.CodTpDevCtaBancaria
			LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = CTASBANCARIAS.CodTpActivoAfipIt 
			LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
			LEFT  JOIN #TMP_TESORERIA_INTACO ON #TMP_TESORERIA_INTACO.CodFondo = CTASBANCARIAS.CodFondo
                        AND #TMP_TESORERIA_INTACO.CodCtaBancaria = CTASBANCARIAS.CodCtaBancaria
			LEFT JOIN #TMP_TESORERIA_INTERESES ON #TMP_TESORERIA_INTERESES.CodFondo = CTASBANCARIAS.CodFondo
                        AND #TMP_TESORERIA_INTERESES.CodCtaBancaria = CTASBANCARIAS.CodCtaBancaria
						--AND #TMP_TESORERIA_INTERESES.CodMoneda = CTASBANCARIAS.CodMoneda
    WHERE   CTASBANCARIAS.CodFondo = @CodFondo
        AND CTASBANCARIAS.EstaAnulado = 0
		AND SaldoFdo <> 0

	insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
		select IdTabla, '<Entidades><Entidad>' +
				'<TipoEntNom>Entidad Emisora</TipoEntNom>'+
				'<TipoEntId>13</TipoEntId>'+
				case when dbo.fnSacarCaracteresEspXML(coalesce(EMISORES.Descripcion,'')) = '' then '<EntNom/>' else '<EntNom>' + dbo.fnSacarCaracteresEspXML(coalesce(EMISORES.Descripcion,'')) + '</EntNom>' end +
				'<EntTic/>' +
				'<EntTTic/>' +
				case when COALESCE(PAISES.Descripcion,'') = '' then '<PaisNom/>' else '<PaisNom>' + dbo.fnSacarCaracteresEspXML(COALESCE(PAISES.Descripcion,''))  + '</PaisNom>' end +
				case when coalesce(PAISES.CodCAFCI,'') <> '' then '<PaisTCod>C</PaisTCod>' else '<PaisTCod/>' end + 
				case when coalesce(PAISES.CodCAFCI,'') = '' then '<PaisCod/>' else '<PaisCod>' + dbo.fnSacarCaracteresEspXML(coalesce(PAISES.CodCAFCI,'')) + '</PaisCod>' end +
				'<ActNom/>' +
				'<ActNomId/>' +
				'</Entidad></Entidades>'
		from #TEMP_ACTIVOS
				inner join CTASBANCARIAS ON CTASBANCARIAS.CodCtaBancaria = #TEMP_ACTIVOS.CodOperacion
										AND CTASBANCARIAS.CodFondo = @CodFondo 
				INNER JOIN BANCOS on BANCOS.CodBanco = CTASBANCARIAS.CodBanco 
				LEFT JOIN EMISORES on EMISORES.CodEmisor = BANCOS.CodEmisor 
				left join PAISES on PAISES.CodPais = EMISORES.CodPais 
			where OrigenActivo like 'CTABANCARIA'
			
		/*FECHAS*/
		IF EXISTS (SELECT 1 from #TEMP_ACTIVOS where OrigenActivo like 'CTABANCARIA')
		BEGIN
			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select distinct IdTabla, '<Fechas>'
				from #TEMP_ACTIVOS
				where OrigenActivo like 'CTABANCARIA'

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select IdTabla, '<Fecha>
								<TipoFechaNom/>
								<FechaDato/>
								<TipoFechaId/>
								</Fecha>'
				from #TEMP_ACTIVOS
				where OrigenActivo like 'CTABANCARIA'

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select distinct IdTabla, '</Fechas>'
				from #TEMP_ACTIVOS
				where OrigenActivo like 'CTABANCARIA'
		END

		/*TICKERS*/
		if exists (select IdTabla from #TEMP_ACTIVOS
				inner join CTASBANCARIAS ON CTASBANCARIAS.CodCtaBancaria = #TEMP_ACTIVOS.CodOperacion
										AND CTASBANCARIAS.CodFondo = @CodFondo 
			where OrigenActivo like 'CTABANCARIA' and coalesce(CTASBANCARIAS.CodCAFCI,'') <> '') 
		begin
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, '<Tickers>'
				from #TEMP_ACTIVOS
					inner join CTASBANCARIAS ON CTASBANCARIAS.CodCtaBancaria = #TEMP_ACTIVOS.CodOperacion
											AND CTASBANCARIAS.CodFondo = @CodFondo 
				where OrigenActivo like 'CTABANCARIA' and coalesce(CTASBANCARIAS.CodCAFCI,'') <> ''

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, 
				'<Ticker>' +
				'<ActTicEnt>CAFCI</ActTicEnt>' +
				case when coalesce(CTASBANCARIAS.CodCAFCI,'') = '' then '<ActTic/>' else '<ActTic>' + ltrim(rtrim(dbo.fnSacarCaracteresEspXML(coalesce(CTASBANCARIAS.CodCAFCI,''))))  + '</ActTic>' end +
				'<ActTTicId>M</ActTTicId>' +
				'<ActMonCotId/>' +
				'<ActMerCotId/>' +
				'</Ticker>'
				from #TEMP_ACTIVOS
					inner join CTASBANCARIAS ON CTASBANCARIAS.CodCtaBancaria = #TEMP_ACTIVOS.CodOperacion
											AND CTASBANCARIAS.CodFondo = @CodFondo 
				where OrigenActivo like 'CTABANCARIA' and coalesce(CTASBANCARIAS.CodCAFCI,'') <> ''
			
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select distinct IdTabla, '</Tickers>'
				from #TEMP_ACTIVOS
					inner join CTASBANCARIAS ON CTASBANCARIAS.CodCtaBancaria = #TEMP_ACTIVOS.CodOperacion
											AND CTASBANCARIAS.CodFondo = @CodFondo 
				where OrigenActivo like 'CTABANCARIA' and coalesce(CTASBANCARIAS.CodCAFCI,'') <> ''

		end
		else
		begin
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
			select IdTabla, '<Tickers>
					<Ticker>
					<ActTicEnt/>
					<ActTic/>
					<ActTTicId/>
					<ActMonCotId/>
					<ActMerCotId/>
					</Ticker>
					</Tickers>'
			from #TEMP_ACTIVOS
			where OrigenActivo like 'CTABANCARIA'
		end

go



exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Activo_Futuro'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Activo_Futuro
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @CodMonedaCursoLgl CodigoMedio
	DECLARE @Parametro Boolean
	DECLARE @EsVendedor Boolean

	--variables CURSOR
	DECLARE @Cur_CodEspecie CodigoLargo
	DECLARE @Cur_MonCoti CodigoMedio
	DECLARE @Cur_MonFdo CodigoMedio
	DECLARE @Cur_TpCambio Precio


	select @CodMonedaCursoLgl = CodMonedaCursoLgl from PARAMETROSREL

    CREATE TABLE #CAFCISEMANAL_ABREVESP
       (CodAbreviaturaEsp numeric(10) NULL,
		CodEspecie numeric(10) NOT NULL,
        CodTpAbreviatura varchar(2) COLLATE database_default  NULL,
        Descripcion varchar(30) COLLATE database_default NOT NULL,
        UnidadesPorCotizacion numeric(22, 10) NULL,
		CodTpTickerCAFCI varchar(6) COLLATE database_default NULL,
        OrdenTicker Numeric(10),
        PrimerTicker Numeric(10))

    INSERT INTO #CAFCISEMANAL_ABREVESP(CodEspecie, Descripcion, UnidadesPorCotizacion, CodTpTickerCAFCI, OrdenTicker)
		SELECT  distinct CodEspecie, IsinCode, 1, 'I', 1
		FROM    ESPECIES
		INNER JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
		WHERE ESPECIES.EstaAnulado = 0 AND NOT IsinCode IS NULL
			AND TPESPECIE.CodTpPapel = 'FU'
			AND (ESPECIES.FechaVencimiento > @FechaProceso OR ESPECIES.FechaVencimiento IS NULL)

    INSERT INTO #CAFCISEMANAL_ABREVESP(CodEspecie, Descripcion, UnidadesPorCotizacion, CodTpTickerCAFCI, OrdenTicker)
		SELECT  distinct CodEspecie, COALESCE(ESPECIES.CodCAFCI, ESPECIES.CodInterfaz), 1, 'M', 2
		FROM    ESPECIES
		INNER JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
		WHERE ESPECIES.EstaAnulado = 0 AND (NOT ESPECIES.CodCAFCI IS NULL OR NOT ESPECIES.CodInterfaz IS NULL)
			AND TPESPECIE.CodTpPapel = 'FU'
			AND (ESPECIES.FechaVencimiento > @FechaProceso OR ESPECIES.FechaVencimiento IS NULL)

    INSERT INTO #CAFCISEMANAL_ABREVESP(CodEspecie, Descripcion, UnidadesPorCotizacion, CodTpTickerCAFCI, OrdenTicker, CodAbreviaturaEsp)
		SELECT  distinct ABREVIATURASESP.CodEspecie, ABREVIATURASESP.Descripcion, ABREVIATURASESP.TipoCotizacion, COALESCE(TPABREVIATURA.CodCAFCI, 'P'),
						COALESCE(TPABREVIATURA.OrdenCAFCI, 7), ABREVIATURASESP.CodAbreviaturaEsp
		FROM    ABREVIATURASESP 
		INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura
		INNER JOIN ESPECIES 
			INNER JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
		ON ESPECIES.CodEspecie = ABREVIATURASESP.CodEspecie
		WHERE ESPECIES.EstaAnulado = 0 AND TPESPECIE.CodTpPapel = 'FU'
			AND ABREVIATURASESP.EstaAnulado = 0 
			AND (ESPECIES.FechaVencimiento > @FechaProceso OR ESPECIES.FechaVencimiento IS NULL)
			
    DELETE #CAFCISEMANAL_ABREVESP
    FROM #CAFCISEMANAL_ABREVESP
    INNER JOIN ESPECIES ON ESPECIES.CodEspecie = #CAFCISEMANAL_ABREVESP.CodEspecie
        and  NOT ESPECIES.CodTpTickerCAFCI IS NULL
    WHERE ESPECIES.CodTpTickerCAFCI <> #CAFCISEMANAL_ABREVESP.CodTpTickerCAFCI

    UPDATE #CAFCISEMANAL_ABREVESP
        SET PrimerTicker = (SELECT MIN(OrdenTicker) FROM #CAFCISEMANAL_ABREVESP interno WHERE interno.CodEspecie = #CAFCISEMANAL_ABREVESP.CodEspecie)
   
    DELETE #CAFCISEMANAL_ABREVESP
    FROM #CAFCISEMANAL_ABREVESP
    WHERE OrdenTicker <> PrimerTicker

    DELETE #CAFCISEMANAL_ABREVESP
    FROM #CAFCISEMANAL_ABREVESP
    WHERE COALESCE(CodAbreviaturaEsp,0) > 
		(SELECT MIN(COALESCE(CodAbreviaturaEsp,0)) FROM #CAFCISEMANAL_ABREVESP ABREVIATURA WHERE ABREVIATURA.CodEspecie = #CAFCISEMANAL_ABREVESP.CodEspecie)
			
    --temporal para ajustar Precio
    CREATE TABLE #CAFCISEMANAL_FACCAM
       (CodEspecie numeric(10) NOT NULL,
        Cantidad numeric(22, 10) NOT NULL,
        UnidadesPorCotizacion numeric(22, 10) NOT NULL,
        Precio numeric(19, 10) NOT NULL,
        Enteros integer NULL,
        Decimales integer NULL,
        FactorCambio numeric(2) NULL,
		CodMonedaCoti numeric(5) NULL,
		FactorConvOperFdo      numeric(19,10) NULL,		
        TpCambio varchar(1) COLLATE database_default NULL)

    --ESPECIES que no son LETES
    INSERT  INTO #CAFCISEMANAL_FACCAM (CodEspecie, Cantidad, UnidadesPorCotizacion, Precio, CodMonedaCoti)
		SELECT  DISTINCT VALORESCPITPAP.CodEspecie,
				VALORESCPITPAP.Cantidad,
				ISNULL(ABREV.UnidadesPorCotizacion, 1) AS UnidadesPorCotizacion,
				COALESCE(COTIZACIONESESP.Cotizacion, 0) * ISNULL(ABREV.UnidadesPorCotizacion, 0) AS Precio,
				COTIZACIONESESP.CodMoneda AS CodMonedaCoti
		FROM    VALORESCPITPAP
				INNER JOIN FONDOS ON FONDOS.CodFondo = VALORESCPITPAP.CodFondo
				INNER JOIN ESPECIES ON ESPECIES.CodEspecie = VALORESCPITPAP.CodEspecie
				LEFT  JOIN #CAFCISEMANAL_ABREVESP ABREV ON ABREV.CodEspecie = VALORESCPITPAP.CodEspecie
				LEFT  JOIN COTIZACIONESESP ON COTIZACIONESESP.CodEspecie = VALORESCPITPAP.CodEspecie 
					AND COTIZACIONESESP.Fecha = VALORESCPITPAP.Fecha
					AND COTIZACIONESESP.CodRueda = VALORESCPITPAP.CodRueda
				LEFT  JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
				LEFT  JOIN TPPAPEL ON TPPAPEL.CodTpPapel = TPESPECIE.CodTpPapel
		WHERE   VALORESCPITPAP.CodFondo = @CodFondo
			AND VALORESCPITPAP.Fecha = @FechaProceso
			AND VALORESCPITPAP.CodSerie IS NULL
			AND ISNULL(TPPAPEL.CodTpPapel,'') IN ('FU')

    --calcule factores para el ajuste de precios
    UPDATE  #CAFCISEMANAL_FACCAM
    SET     Enteros = CASE WHEN UnidadesPorCotizacion >= 1
                              THEN LEN(CONVERT(integer, ROUND(UnidadesPorCotizacion, 0, 1)))
                              ELSE 0
                         END,
            Decimales = LEN(LTRIM(RTRIM(REPLACE(CONVERT(varchar(15), (Precio - ROUND(Precio, 0, 1))), '0', ' ')))) - 1

    UPDATE  #CAFCISEMANAL_FACCAM
    SET     FactorCambio = CASE WHEN Decimales > 4
                                THEN CASE WHEN (10 - Enteros) > (Decimales - 4)
                                          THEN (Decimales - 4)
                                          ELSE (10 - Enteros)
                                     END
                                ELSE 0
                           END
    
	--TIPO DE CAMBIO
	SELECT @Parametro = ValorParametro FROM PARAMETROS WHERE CodParametro = 'COTESP'
    DECLARE cursor_Cambio cursor for
		SELECT	#CAFCISEMANAL_FACCAM.CodEspecie,
				#CAFCISEMANAL_FACCAM.CodMonedaCoti,
				FONDOS.CodMoneda
		FROM #CAFCISEMANAL_FACCAM
		INNER JOIN FONDOS ON FONDOS.CodFondo = @CodFondo

    OPEN cursor_Cambio

    FETCH NEXT FROM cursor_Cambio INTO @Cur_CodEspecie, @Cur_MonCoti, @Cur_MonFdo
    
    WHILE @@FETCH_STATUS = 0
    BEGIN

		IF @Parametro=0 BEGIN
		   IF @CodMonedaCursoLgl <>@Cur_MonFdo  
			  SELECT @EsVendedor = -1
			ELSE 
			  SELECT @EsVendedor = 0
		END
		ELSE BEGIN
        exec spXCalcularUltCambioActPas -1, @CodFondo, @Cur_MonCoti, @Cur_MonFdo,@FechaProceso , @Cur_TpCambio OUTPUT, @EsVendedor OUTPUT
		END


        UPDATE #CAFCISEMANAL_FACCAM
		SET TpCambio = (case when @EsVendedor = -1 then 'V' ELSE 'C' END)
		WHERE CodEspecie = @Cur_CodEspecie

		FETCH NEXT FROM cursor_Cambio INTO @Cur_CodEspecie, @Cur_MonCoti, @Cur_MonFdo
    END

    CLOSE cursor_Cambio
    DEALLOCATE cursor_Cambio

	--*****

    --ESPECIES que no son LETES
	
	insert into #TEMP_ACTIVOS(CodEspecie, CodPapel, Nro,
		ActTTic,ActTic,ActNom,EntENom,EntONom,MerTCod,MerCod,MerNom,MonActTCod,
		MonActCod,MonActNom,Cant,CantCot,Pre,MtoMAct,TCCod,MtoMFdo,Cl,SCl,
		DOPEj,FeOr,DOFEj,DOSub,ClId,AA,CodImpAct,NomClImp, NomSClImp, NomImpAct,
		PaisNomEmi, PaisNomEmiTCod, PaisNomEmiCod, PaisNomNeg, PaisNomNegTCod, PaisNomNegCod, CtaCteRem,
		ASNom,ASTic,ASTTic,OrigenActivo,CodOperacion)
    SELECT  VALORESCPITPAP.CodEspecie,
            TPPAPEL.CodTpPapel,
			0 as Nro,
			#CAFCISEMANAL_ABREVESP.CodTpTickerCAFCI AS TTCod,
            dbo.fnSacarCaracteresEspXML(COALESCE(#CAFCISEMANAL_ABREVESP.Descripcion, '')) AS TNom,
            dbo.fnSacarCaracteresEspXML(COALESCE(ESPECIES.Descripcion, '')) AS AcNomCor,
            dbo.fnSacarCaracteresEspXML(ISNULL(MEROPER.Descripcion, '')) AS EENom,
            '' AS EONom,
            CASE WHEN NOT ISNULL(MERCOTI.CodCAFCI, '') = '' THEN 'C' ELSE 'P' END AS MeTCod,
            COALESCE(MERCOTI.CodCAFCI, MERCOTI.CodInterfaz, '') AS MeCod,
            dbo.fnSacarCaracteresEspXML(ISNULL(MERCOTI.Descripcion, '')) AS MeNom,
            'C' AS MoTCod,
            dbo.fnSacarCaracteresEspXML(COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '')) AS MoCod,
            dbo.fnSacarCaracteresEspXML(ISNULL(MONCOTI.Descripcion, '')) AS MoNom,
            VALORESCPITPAP.Cantidad AS Q,
            ISNULL(#CAFCISEMANAL_ABREVESP.UnidadesPorCotizacion, 1) * POWER(10, FactorCambio) AS QC,
            COALESCE(VALORESCPITPAP.CotizacionCarga, 0) * ISNULL(#CAFCISEMANAL_ABREVESP.UnidadesPorCotizacion, 0) * POWER(10, FactorCambio) AS P,
            COALESCE(VALORESCPITPAP.CotizacionCarga, 0) * VALORESCPITPAP.Cantidad AS MontoMO,
			COALESCE(#CAFCISEMANAL_FACCAM.TpCambio,'N') AS TCCod,
            VALORESCPITPAP.Cotizacion * VALORESCPITPAP.Cantidad AS MontoMF,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPESPECIE.Descripcion, '')) AS ClNom,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPPAPEL.Descripcion, '')) AS SClNom,
            COALESCE(COTIZACIONESESP.Cotizacion, 0) * ISNULL(#CAFCISEMANAL_ABREVESP.UnidadesPorCotizacion, 0) * POWER(10, FactorCambio) AS DOPEj,
            ESPECIES.FechaEmision FeOr,
            ESPECIES.FechaVencimiento DOFeEj,
            SUBYACENTES.Descripcion DOSy,
			VALORESCPITPAP.CodEspecie ClId,
			dbo.fnFechaOperaciones(ESPECIES.CodEspecie,@FechaProceso) as 'AA',
			dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
			dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIP.Descripcion,'')) as NomClImp, 
			dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.Descripcion,'')) as NomSClImp, 
			dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.Descripcion,'')) as NomImpAct,
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISEMI.Descripcion,'')) as PaisNomEmi, 
			case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, 
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISEMI.CodCAFCI,'')) as PaisNomEmiCod, 
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISMERCADO.Descripcion,'')) as PaisNomNeg, 
			case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, 
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISMERCADO.CodCAFCI,'')) as PaisNomNegCod,
			'' as CtaCteRem,
			dbo.fnSacarCaracteresEspXML(ISNULL(SUBYACENTES.Descripcion,'')) AS ASNom,
			dbo.fnSacarCaracteresEspXML(coalesce(SUBYACENTES.TicketETrader,'')) AS ASTic,
			'' AS ASTTic,
			'FUTURO' as OrigenActivo,
			VALORESCPITPAP.CodEspecie as CodOperacion
    FROM    VALORESCPITPAP
            INNER JOIN FONDOS ON FONDOS.CodFondo = VALORESCPITPAP.CodFondo
            INNER JOIN ESPECIES 
                INNER JOIN SUBYACENTES ON SUBYACENTES.CodSubyacente = ESPECIES.CodSubyacente
            ON ESPECIES.CodEspecie = VALORESCPITPAP.CodEspecie
			INNER JOIN EMISORES ON EMISORES.CodEmisor = ESPECIES.CodEmisor
			INNER JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais			
            INNER JOIN #CAFCISEMANAL_FACCAM ON #CAFCISEMANAL_FACCAM.CodEspecie = ESPECIES.CodEspecie
            LEFT  JOIN MERCADOS MEROPER ON MEROPER.CodMercado = ESPECIES.CodMercadoOperacion
			LEFT  JOIN #CAFCISEMANAL_ABREVESP ON #CAFCISEMANAL_ABREVESP.CodEspecie = ESPECIES.CodEspecie
            LEFT  JOIN COTIZACIONESESP ON COTIZACIONESESP.CodEspecie = VALORESCPITPAP.CodEspecie 
				AND COTIZACIONESESP.Fecha = VALORESCPITPAP.Fecha
				AND COTIZACIONESESP.CodRueda =VALORESCPITPAP.CodRueda
            LEFT  JOIN MERCADOS MERCOTI ON MERCOTI.CodMercado = COTIZACIONESESP.CodMercado
            LEFT  JOIN MONEDAS MONCOTI ON MONCOTI.CodMoneda = COTIZACIONESESP.CodMoneda
            LEFT  JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
            LEFT  JOIN TPPAPEL ON TPPAPEL.CodTpPapel = TPESPECIE.CodTpPapel
			inner join PAISES PAISMERCADO on PAISMERCADO.CodPais = MERCOTI.CodPais
			LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = ESPECIES.CodTpActivoAfipIt 
			LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
    WHERE   VALORESCPITPAP.CodFondo = @CodFondo
        AND VALORESCPITPAP.Fecha = @FechaProceso
        AND VALORESCPITPAP.CodSerie IS NULL
        AND ISNULL(TPPAPEL.CodTpPapel,'') IN ('FU')

	UNION ALL
    SELECT  VALORESCPITPAP.CodEspecie,
            TPPAPEL.CodTpPapel,
			0 as Nro,
			'M' AS TTCod,
            'FUTREG' + COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '') + '001' AS TNom,
            'Fut Reg ' + COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '') AS AcNomCor,
            '' AS EENom,
            '' AS EONom,
            'C' AS MeTCod,
            'BC' AS MeCod,
            'Bolsa' AS MeNom,
            'C' AS MoTCod,
            COALESCE(MONCOTI.CodCAFCI, MONCOTI.CodInterfaz, '') AS MoCod,
            dbo.fnSacarCaracteresEspXML(ISNULL(MONCOTI.Descripcion, '')) AS MoNom,
            -VALORESCPITPAP.Cantidad AS Q,
            ISNULL(#CAFCISEMANAL_ABREVESP.UnidadesPorCotizacion, 1) * POWER(10, FactorCambio) AS QC,
            COALESCE(VALORESCPITPAP.CotizacionCarga, 0) * ISNULL(#CAFCISEMANAL_ABREVESP.UnidadesPorCotizacion, 0) * POWER(10, FactorCambio) AS P,
            -COALESCE(VALORESCPITPAP.CotizacionCarga, 0) * VALORESCPITPAP.Cantidad AS MontoMO,
			COALESCE(#CAFCISEMANAL_FACCAM.TpCambio,'N') AS TCCod,
            -VALORESCPITPAP.Cotizacion * VALORESCPITPAP.Cantidad AS MontoMF,
            '' AS ClNom,
            '' AS SClNom,
            COALESCE(COTIZACIONESESP.Cotizacion, 0) * ISNULL(#CAFCISEMANAL_ABREVESP.UnidadesPorCotizacion, 0) * POWER(10, FactorCambio) AS DOPEj,
            ESPECIES.FechaEmision FeOr,
            ESPECIES.FechaVencimiento DOFeEj,
            dbo.fnSacarCaracteresEspXML(SUBYACENTES.Descripcion) DOSy,
			VALORESCPITPAP.CodEspecie ClId,
			dbo.fnFechaOperaciones(ESPECIES.CodEspecie,@FechaProceso) as 'AA',
			dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
			'' as NomClImp, 
			'' as NomSClImp, 
			'' as NomImpAct,
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISEMI.Descripcion,'')) as PaisNomEmi, 
			case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, 
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISEMI.CodCAFCI,'')) as PaisNomEmiCod, 
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISMERCADO.Descripcion,'')) as PaisNomNeg, 
			case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, 
			dbo.fnSacarCaracteresEspXML(ISNULL(PAISMERCADO.CodCAFCI,'')) as PaisNomNegCod,
			'' as CtaCteRem,
			dbo.fnSacarCaracteresEspXML(ISNULL(SUBYACENTES.Descripcion,'')) AS ASNom,
			dbo.fnSacarCaracteresEspXML(coalesce(SUBYACENTES.TicketETrader,'')) AS ASTic,
			'' AS ASTTic,
			'FUTURO' as OrigenActivo,
			VALORESCPITPAP.CodEspecie as CodOperacion
    FROM    VALORESCPITPAP
            INNER JOIN FONDOS ON FONDOS.CodFondo = VALORESCPITPAP.CodFondo
            INNER JOIN ESPECIES 
                INNER JOIN SUBYACENTES ON SUBYACENTES.CodSubyacente = ESPECIES.CodSubyacente
            ON ESPECIES.CodEspecie = VALORESCPITPAP.CodEspecie
			INNER JOIN EMISORES ON EMISORES.CodEmisor = ESPECIES.CodEmisor
			INNER JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais
            INNER JOIN #CAFCISEMANAL_FACCAM ON #CAFCISEMANAL_FACCAM.CodEspecie = ESPECIES.CodEspecie
            LEFT  JOIN MERCADOS MEROPER ON MEROPER.CodMercado = ESPECIES.CodMercadoOperacion
			LEFT  JOIN #CAFCISEMANAL_ABREVESP ON #CAFCISEMANAL_ABREVESP.CodEspecie = ESPECIES.CodEspecie
            LEFT  JOIN COTIZACIONESESP ON COTIZACIONESESP.CodEspecie = VALORESCPITPAP.CodEspecie 
				AND COTIZACIONESESP.Fecha = VALORESCPITPAP.Fecha
				AND COTIZACIONESESP.CodRueda =VALORESCPITPAP.CodRueda
            LEFT  JOIN MERCADOS MERCOTI ON MERCOTI.CodMercado = COTIZACIONESESP.CodMercado
            LEFT  JOIN MONEDAS MONCOTI ON MONCOTI.CodMoneda = COTIZACIONESESP.CodMoneda
            LEFT  JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie
            LEFT  JOIN TPPAPEL ON TPPAPEL.CodTpPapel = TPESPECIE.CodTpPapel
			inner join PAISES PAISMERCADO on PAISMERCADO.CodPais = MERCOTI.CodPais
			LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = ESPECIES.CodTpActivoAfipIt 
			LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
    WHERE   VALORESCPITPAP.CodFondo = @CodFondo
        AND VALORESCPITPAP.Fecha = @FechaProceso
        AND VALORESCPITPAP.CodSerie IS NULL
        AND ISNULL(TPPAPEL.CodTpPapel,'') IN ('FU')

	insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
		select IdTabla, '<Entidades><Entidad>
				<TipoEntNom/>
				<TipoEntId/>
				<EntNom/>
				<EntTic/>
				<EntTTic/>
				<PaisNom/>
				<PaisTCod/>
				<PaisCod/>
				<ActNom/>
				<ActNomId/>
				</Entidad></Entidades>'
		from #TEMP_ACTIVOS
		where OrigenActivo like 'FUTURO'
			
		/*FECHAS*/	
		IF EXISTS (SELECT 1 from #TEMP_ACTIVOS where OrigenActivo like 'FUTURO')
		BEGIN
			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				SELECT distinct IdTabla, '<Fechas>'
				from #TEMP_ACTIVOS
				where OrigenActivo like 'FUTURO'

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				select IdTabla, case when #TEMP_ACTIVOS.FeOr is null then 
									'<Fecha>'+
									'<TipoFechaNom/>'+
									'<FechaDato/>'+
									'<TipoFechaId/>'+
									'</Fecha>'
							else
									'<Fecha>'+
									'<TipoFechaNom>Origen de la Inversión</TipoFechaNom>'+
									'<FechaDato>' + convert(varchar(10),#TEMP_ACTIVOS.FeOr,120) + '</FechaDato>'+
									'<TipoFechaId>4</TipoFechaId>'+
									'</Fecha>'
							end
					from #TEMP_ACTIVOS
					where OrigenActivo IN ('FUTURO')
					--FeVto
				union all
					select IdTabla, case when #TEMP_ACTIVOS.DOFEj is null then 
									'<Fecha>'+
									'<TipoFechaNom/>'+
									'<FechaDato/>'+
									'<TipoFechaId/>'+
									'</Fecha>'
							else
									'<Fecha>'+
									'<TipoFechaNom>Ejercicio DO</TipoFechaNom>'+
									'<FechaDato>' + convert(varchar(10),#TEMP_ACTIVOS.DOFEj,120) + '</FechaDato>'+
									'<TipoFechaId>7</TipoFechaId>'+
									'</Fecha>'
							end
					from #TEMP_ACTIVOS
					where OrigenActivo IN ('FUTURO')

			insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas)
				SELECT distinct IdTabla, '</Fechas>'
				from #TEMP_ACTIVOS
				where OrigenActivo like 'FUTURO'
		END
		
		/*TICKERS*/
		/*--'RG 796 - Informa abreviaturas anuladas.'*/
		DECLARE @PARAMETRO_ABREVIATURAS_ANULADAS Boolean
		SELECT @PARAMETRO_ABREVIATURAS_ANULADAS = ValorParametro FROM PARAMETROS WHERE CodParametro = 'ABR796'	
		/**/


		IF EXISTS (SELECT 1 FROM #TEMP_ACTIVOS
								INNER JOIN  ABREVIATURASESP 
									ON ABREVIATURASESP.CodEspecie = #TEMP_ACTIVOS.CodOperacion
								INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASESP.CodMercado 
									and MERCADOS.EstaAnulado = 0
								INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
									AND PAISES.EstaAnulado = 0
								INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
									AND MERCOD.EstaAnulado = 0
								INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASESP.CodMoneda
									AND MONEDAS.EstaAnulado = 0
								INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura 
							where OrigenActivo like 'FUTURO')
		BEGIN
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				Select DISTINCT IdTabla, '<Tickers>'
				from #TEMP_ACTIVOS
					INNER JOIN  ABREVIATURASESP 
						ON ABREVIATURASESP.CodEspecie = #TEMP_ACTIVOS.CodOperacion
					INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASESP.CodMercado 
						and MERCADOS.EstaAnulado = 0
					INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
						AND PAISES.EstaAnulado = 0
					INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
						AND MERCOD.EstaAnulado = 0
					INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASESP.CodMoneda
						AND MONEDAS.EstaAnulado = 0
					INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura 
				where OrigenActivo like 'FUTURO'

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				select IdTabla, '<Ticker>' +
						'<ActTicEnt>' + CASE ABREVIATURASESP.CodTpAbreviatura 
										WHEN 'ML' THEN 'CAFCI'
										WHEN 'FT' THEN 'BCBA' 
										ELSE dbo.fnSacarCaracteresEspXML(ISNULL(TPABREVIATURA.Descripcion,''))
									END + '</ActTicEnt>' +
						'<ActTic>' + dbo.fnSacarCaracteresEspXML(ISNULL(ABREVIATURASESP.Descripcion,'')) + '</ActTic>' +
						'<ActTTicId>' + CASE ABREVIATURASESP.CodTpAbreviatura  
										WHEN 'FT' THEN 'B' 
										WHEN 'MA' THEN 'E'
										WHEN 'BL' THEN 'BL'
										WHEN 'RT' THEN 'R'
										WHEN 'ML' THEN 'M'
										WHEN 'FU' THEN 'RX'
										ELSE 'P' -- 'ML' 'MN' 'SR'
									END  + '</ActTTicId>' +
						case when  coalesce(MONEDAS.CodCAFCI,'') = '' then '<ActMonCotId/>' else '<ActMonCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MONEDAS.CodCAFCI,'')) + '</ActMonCotId>' end +
						case when  coalesce(MERCADOS.CodCAFCI,'') = '' then '<ActMerCotId/>' else '<ActMerCotId>' + dbo.fnSacarCaracteresEspXML(coalesce(MERCADOS.CodCAFCI,'')) + '</ActMerCotId>' end +
						'</Ticker>'
				from #TEMP_ACTIVOS
					INNER JOIN  ABREVIATURASESP 
						ON ABREVIATURASESP.CodEspecie = #TEMP_ACTIVOS.CodOperacion
					INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASESP.CodMercado 
						and MERCADOS.EstaAnulado = 0
					INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
						AND PAISES.EstaAnulado = 0
					INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
						AND MERCOD.EstaAnulado = 0
					INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASESP.CodMoneda
						AND MONEDAS.EstaAnulado = 0
					INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura 
				where OrigenActivo like 'FUTURO'
				AND (ABREVIATURASESP.EstaAnulado = 0 OR ABREVIATURASESP.EstaAnulado = @PARAMETRO_ABREVIATURAS_ANULADAS)

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
				Select DISTINCT IdTabla, '</Tickers>'
				from #TEMP_ACTIVOS
					INNER JOIN  ABREVIATURASESP 
						ON ABREVIATURASESP.CodEspecie = #TEMP_ACTIVOS.CodOperacion
					INNER JOIN MERCADOS ON MERCADOS.CodMercado  = ABREVIATURASESP.CodMercado 
						and MERCADOS.EstaAnulado = 0
					INNER JOIN PAISES ON PAISES.CodPais = MERCADOS.CodPais 
						AND PAISES.EstaAnulado = 0
					INNER JOIN MONEDAS MERCOD ON MERCOD.CodMoneda = PAISES.CodMoneda 
						AND MERCOD.EstaAnulado = 0
					INNER JOIN MONEDAS on MONEDAS.CodMoneda = ABREVIATURASESP.CodMoneda
						AND MONEDAS.EstaAnulado = 0
					INNER JOIN TPABREVIATURA ON TPABREVIATURA.CodTpAbreviatura = ABREVIATURASESP.CodTpAbreviatura 
				where OrigenActivo like 'FUTURO'
		END

go

---spGDIN_CAFCIUnificada_Tag_Activo_ChequeDif
exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Activo_ChequeDif'
go

alter procedure dbo.spGDIN_CAFCI796_Tag_Activo_ChequeDif
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as

	DECLARE @CodMonedaCursoLgl CodigoMedio
	DECLARE @CodMoneda CodigoMedio
	
	select @CodMoneda = dbo.fnMonPaisAplicacion()
	select @CodMonedaCursoLgl = CodMonedaCursoLgl from PARAMETROSREL
	
    --Cheque 
	
	insert into #TEMP_ACTIVOS(CodOperacion, Nro,
		ActTTic,ActTic,ActNom,EntENom,EntONom,MerTCod,MerCod,MerNom,MonActTCod,
		MonActCod,MonActNom,Cant,CantCot,Pre,MtoMAct,TCCod,MtoMFdo, FeOr,FeVto,
		PFTra,PFPre,ML,ClId,AA,CodImpAct,NomClImp, NomSClImp, NomImpAct,
		PaisNomEmi, PaisNomEmiTCod, PaisNomEmiCod, PaisNomNeg, PaisNomNegTCod, PaisNomNegCod, CtaCteRem,
		ASNom,ASTic,ASTTic,OrigenActivo)
		SELECT  CHEQUESDIFMOV.CodChequeDifMov as CodOperacion,--select * from CHEQUESDIFMOV
				0 as Nro,
				case when SUBSTRING(CHEQUESDIF.CodCAFCI,1,1) = '$' then 'B' ELSE 'M' END AS TTCod,
				COALESCE(CHEQUESDIF.CodCAFCI,'') AS TNom,
				'CHEQUE DE PAGO DIFERIDO' AS AcNomCor,
				'' as EENom,
				'' as EONom,
				'C' AS MeTCod,
				'SG' AS MeCod,
				'' AS MeNom,
				'C' AS MoTCod,
				dbo.fnSacarCaracteresEspXML(COALESCE(MONEDAS.CodCAFCI, MONEDAS.CodInterfaz, '')) AS MoCod,
				dbo.fnSacarCaracteresEspXML(ISNULL(MONEDAS.Descripcion, '')) AS MoNom,
				CHEQUESDIF.Importe AS Q,
				1000000 AS QC,
				CHEQUESDIFMOV.Tasa * 1000000 AS P,
				CHEQUESDIFMOV.ImporteActual AS MontoMO,
				--CASE WHEN (CHEQUESDIFMOV.FactorConvCheqDifFdo <= COTCHEQUEDIF.FactorConvCheqDifFdo ) THEN
					--	'C' 
					--ELSE  
						CASE WHEN FONDOSREAL.CodMoneda = @CodMoneda then
							'C'
						ELSE
							'V'
						END
				/*END*/ AS TCCod,
				CONVERT(NUMERIC(19,2) ,CHEQUESDIFMOV.ImporteActual * CHEQUESDIFMOV.FactorConvCheqDifFdo) AS MontoMF,
				CHEQUESDIF.FechaEmision as FeOr,					   
				CHEQUESDIF.FechaVencimiento as FeVto,
				'N' as PFTr,
				'N' AS PFPr,
				'N' AS MLiq,
				CHEQUESDIF.CodChequeDif ClId,
				dbo.fnFechaOperaciones(-1,@FechaProceso) as 'AA',
				dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.CodInterfazAFIP,''))  AS 'CodImpAct',
				dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIP.Descripcion,'')) as NomClImp, 
				dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.Descripcion,'')) as NomSClImp, 
				dbo.fnSacarCaracteresEspXML(ISNULL(TPACTIVOAFIPIT.Descripcion,'')) as NomImpAct,
				dbo.fnSacarCaracteresEspXML(coalesce(PAISEMI.Descripcion,'')) as PaisNomEmi, 
				case when coalesce(PAISEMI.CodCAFCI,'') = '' then 'P' else 'C' end  as PaisNomEmiTCod, 
				dbo.fnSacarCaracteresEspXML(ISNULL(PAISEMI.CodCAFCI,'')) as PaisNomEmiCod, 
				dbo.fnSacarCaracteresEspXML(ISNULL(PAISMERCADO.Descripcion,'')) as PaisNomNeg, 
				case when coalesce(PAISMERCADO.CodCAFCI,'') = '' then 'P' else 'C' end as PaisNomNegTCod, 
				dbo.fnSacarCaracteresEspXML(ISNULL(PAISMERCADO.CodCAFCI,'')) as PaisNomNegCod,
				'' as CtaCteRem,
				'' AS ASNom,
				'' AS ASTic,
				'' AS ASTTic,
				'CHEQUEDIF' as OrigenActivo
		FROM    CHEQUESDIFMOV
		INNER JOIN FONDOSREAL ON FONDOSREAL.CodFondo = CHEQUESDIFMOV.CodFondo
		INNER JOIN CHEQUESDIFCOMPRA 
			INNER JOIN CHEQUESDIF 
				INNER JOIN MONEDAS ON MONEDAS.CodMoneda = CHEQUESDIF.CodMoneda
			ON CHEQUESDIFCOMPRA.CodChequeDif = CHEQUESDIF.CodChequeDif
		ON CHEQUESDIFCOMPRA.CodFondo = CHEQUESDIFMOV.CodFondo
			AND CHEQUESDIFCOMPRA.CodChequeDifCpa = CHEQUESDIFMOV.CodChequeDifCpa
		LEFT JOIN SOCGTIASRECIPROCAS ON SOCGTIASRECIPROCAS.CodSocGtiaReciproca = CHEQUESDIF.CodSocGtiaReciproca
		LEFT JOIN BANCOS ON BANCOS.CodBanco=CHEQUESDIF.CodBanco
			LEFT JOIN EMISORES 
				LEFT JOIN PAISES PAISEMI ON PAISEMI.CodPais = EMISORES.CodPais
			ON EMISORES.CodEmisor = BANCOS.CodEmisor
		INNER JOIN PAISES PAISMERCADO ON PAISMERCADO.CodPais = BANCOS.CodPais				 
		LEFT JOIN BANCOSBCRA ON BANCOSBCRA.CodBanco = BANCOS.CodBanco AND BANCOSBCRA.CodMoneda = CHEQUESDIF.CodMoneda
		LEFT JOIN TPACTIVOAFIPIT ON TPACTIVOAFIPIT.CodTpActivoAfipIt = CHEQUESDIF.CodTpActivoAfipIt 
				LEFT JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
	/*
	LEFT  JOIN CHEQUESDIFMOV COTCHEQUEDIF
                    ON COTCHEQUEDIF.CodFondo = CHEQUESDIFMOV.CodFondo
                   AND COTCHEQUEDIF.CodChequeDifCpa = CHEQUESDIFMOV.CodChequeDifCpa
                   AND COTCHEQUEDIF.Fecha = (SELECT  MAX(Fecha)
                                                FROM    CHEQUESDIFMOV COTMON
                                                WHERE   COTMON.CodFondo = COTCHEQUEDIF.CodFondo
                                                    AND COTMON.CodChequeDifCpa = COTCHEQUEDIF.CodChequeDifCpa
                                                    AND COTMON.Fecha < @FechaProceso)
													*/
    WHERE   CHEQUESDIFMOV.Fecha = @FechaProceso
        and CHEQUESDIFMOV.CodFondo = @CodFondo
		AND CHEQUESDIFCOMPRA.EstaAnulado = 0
        AND CHEQUESDIF.EstaAnulado = 0
		and CHEQUESDIF.FechaVencimiento > @FechaProceso
	
	--EXEC dbo.spGDIN_IntefazCAFCI796 5,'20190731', 1,-1,-1,0

	/**/
	--SELECT * FROM #TEMP_ACTIVOS

	insert into #CAFCIUNIFICADA_Tag_Activo_Entidades (IdTabla, CampoEntidades)
	select IdTabla, '<Entidades><Entidad>
			<TipoEntNom/>
			<TipoEntId/>
			<EntNom/>
			<EntTic/>
			<EntTTic/>
			<PaisNom/>
			<PaisTCod/>
			<PaisCod/>
			<ActNom/>
			<ActNomId/>
			</Entidad></Entidades>'
	from #TEMP_ACTIVOS
	where OrigenActivo like 'CHEQUEDIF'

	/**/
	--SELECT * FROM #CAFCIUNIFICADA_Tag_Activo_Entidades
			
	/*FECHAS*/

		insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas,Prioridad)
			SELECT distinct IdTabla, '<Fechas>',1
			from #TEMP_ACTIVOS												
			where OrigenActivo like 'CHEQUEDIF'

		insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas, Prioridad)
				select IdTabla, case when #TEMP_ACTIVOS.FeOr is null then 
							'<Fecha>'+
								'<TipoFechaNom/>'+
								'<FechaDato/>'+
								'<TipoFechaId/>'+
							'</Fecha>'
						else
							'<Fecha>'+
								'<TipoFechaNom>Origen de la Inversión</TipoFechaNom>'+
								'<FechaDato>' + convert(varchar(10),#TEMP_ACTIVOS.FeOr,120) + '</FechaDato>'+
								'<TipoFechaId>4</TipoFechaId>'+
							'</Fecha>'
						end,
						2
				from #TEMP_ACTIVOS												
				where OrigenActivo like 'CHEQUEDIF'
			union all --FeVto
				select IdTabla, case when #TEMP_ACTIVOS.FeVto is null then 
								'<Fecha>'+
								'<TipoFechaNom/>'+
								'<FechaDato/>'+
								'<TipoFechaId/>'+
								'</Fecha>'
						else
								'<Fecha>'+
								'<TipoFechaNom>Vencimiento de la Inversión</TipoFechaNom>'+
								'<FechaDato>' + convert(varchar(10),#TEMP_ACTIVOS.FeVto,120) + '</FechaDato>'+
								'<TipoFechaId>3</TipoFechaId>'+
								'</Fecha>'
						end,
						2
				from #TEMP_ACTIVOS
				where OrigenActivo like 'CHEQUEDIF'

		insert into #CAFCIUNIFICADA_Tag_Activo_Fechas (IdTabla, CampoFechas,Prioridad)
			SELECT distinct IdTabla, '</Fechas>',3
			from #TEMP_ACTIVOS												
			where OrigenActivo like 'CHEQUEDIF'
	

	/*TICKERS*/
	
		--if exists (select IdTabla from #TEMP_ACTIVOS
		--		  INNER JOIN CHEQUESDIFMOV ON CHEQUESDIFMOV.CodChequeDifMov = #TEMP_ACTIVOS.CodOperacion										
		--								and CHEQUESDIFMOV.CodFondo = @CodFondo
		--		INNER JOIN CHEQUESDIFCOMPRA 
		--			INNER JOIN CHEQUESDIF 
		--				INNER JOIN MONEDAS ON MONEDAS.CodMoneda = CHEQUESDIF.CodMoneda
		--			ON CHEQUESDIFCOMPRA.CodChequeDif = CHEQUESDIF.CodChequeDif
		--		ON CHEQUESDIFCOMPRA.CodFondo = CHEQUESDIFMOV.CodFondo
		--			AND CHEQUESDIFCOMPRA.CodChequeDifCpa = CHEQUESDIFMOV.CodChequeDifCpa
		--	where OrigenActivo like 'CHEQUEDIF' and coalesce(CHEQUESDIF.CodCAFCI,'') <> '') 
		--begin		
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers, Prioridad)
				select distinct IdTabla, '<Tickers>',1
				from #TEMP_ACTIVOS
					 left JOIN CHEQUESDIFMOV ON CHEQUESDIFMOV.CodChequeDifMov = #TEMP_ACTIVOS.CodOperacion
											and CHEQUESDIFMOV.CodFondo = @CodFondo
					INNER JOIN CHEQUESDIFCOMPRA 
						INNER JOIN CHEQUESDIF 
							INNER JOIN MONEDAS ON MONEDAS.CodMoneda = CHEQUESDIF.CodMoneda
						ON CHEQUESDIFCOMPRA.CodChequeDif = CHEQUESDIF.CodChequeDif
					ON CHEQUESDIFCOMPRA.CodFondo = CHEQUESDIFMOV.CodFondo
						AND CHEQUESDIFCOMPRA.CodChequeDifCpa = CHEQUESDIFMOV.CodChequeDifCpa
				where OrigenActivo like 'CHEQUEDIF' and coalesce(CHEQUESDIF.CodCAFCI,'') <> ''
								  
			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers, Prioridad)
				select IdTabla, 
				'<Ticker>' +
					'<ActTicEnt>CAFCI</ActTicEnt>' +
					case when coalesce(CHEQUESDIF.CodCAFCI,'') = '' then '<ActTic/>' else '<ActTic>' + ltrim(rtrim(dbo.fnSacarCaracteresEspXML(ISNULL(CHEQUESDIF.CodCAFCI,''))))  + '</ActTic>' end +
					'<ActTTicId>M</ActTTicId>' +
					case when coalesce(MONEDAS.CodCAFCI,'') = '' then '<ActMonCotId/>' else '<ActMonCotId>' + dbo.fnSacarCaracteresEspXML(ISNULL(MONEDAS.CodCAFCI,''))  + '</ActMonCotId>' end +
					'<ActMerCotId/>' +
				'</Ticker>',2
				from #TEMP_ACTIVOS
					 left JOIN CHEQUESDIFMOV ON CHEQUESDIFMOV.CodChequeDifMov = #TEMP_ACTIVOS.CodOperacion
											and CHEQUESDIFMOV.CodFondo = @CodFondo
					INNER JOIN CHEQUESDIFCOMPRA 
						INNER JOIN CHEQUESDIF 
							INNER JOIN MONEDAS ON MONEDAS.CodMoneda = CHEQUESDIF.CodMoneda
						ON CHEQUESDIFCOMPRA.CodChequeDif = CHEQUESDIF.CodChequeDif
					ON CHEQUESDIFCOMPRA.CodFondo = CHEQUESDIFMOV.CodFondo
						AND CHEQUESDIFCOMPRA.CodChequeDifCpa = CHEQUESDIFMOV.CodChequeDifCpa
				where OrigenActivo like 'CHEQUEDIF' and coalesce(CHEQUESDIF.CodCAFCI,'') <> ''

			insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers, Prioridad)
				select distinct IdTabla, '</Tickers>',3
				from #TEMP_ACTIVOS
					 left JOIN CHEQUESDIFMOV ON CHEQUESDIFMOV.CodChequeDifMov = #TEMP_ACTIVOS.CodOperacion
											and CHEQUESDIFMOV.CodFondo = @CodFondo
					INNER JOIN CHEQUESDIFCOMPRA 
						INNER JOIN CHEQUESDIF 
							INNER JOIN MONEDAS ON MONEDAS.CodMoneda = CHEQUESDIF.CodMoneda
						ON CHEQUESDIFCOMPRA.CodChequeDif = CHEQUESDIF.CodChequeDif
					ON CHEQUESDIFCOMPRA.CodFondo = CHEQUESDIFMOV.CodFondo
						AND CHEQUESDIFCOMPRA.CodChequeDifCpa = CHEQUESDIFMOV.CodChequeDifCpa
				where OrigenActivo like 'CHEQUEDIF' and coalesce(CHEQUESDIF.CodCAFCI,'') <> ''
				
	--end
	--else
	--begin
		

	--	insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
	--		select top 1 IdTabla, '<Ticker>
	--								<ActTicEnt/>
	--								<ActTic/>
	--								<ActTTicId/>
	--								<ActMonCotId/>
	--								<ActMerCotId/>
	--								</Ticker>'
	--		from #TEMP_ACTIVOS
	--		where OrigenActivo like 'CHEQUEDIF'

	--	insert into #CAFCIUNIFICADA_Tag_Activo_Tickers (IdTabla, CampoTickers)
	--		select MIN(IdTabla), '</Tickers>'
	--		from #TEMP_ACTIVOS
	--		where OrigenActivo like 'CHEQUEDIF'
	--end
	

go

exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Duration'
go

alter procedure dbo.spGDIN_CAFCI796_Tag_Duration
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as
	declare @Duration Importe

	exec spXDuration @CodFondo, @FechaProceso, @Duration OUTPUT
	
	insert into #CAFCIUNIFICADA_Tag_Duration (CampoXml)
		select '<Durations>'
		union all
		select '<Duration>' + convert(varchar,coalesce(convert(numeric(10,2),@Duration),0)) + '</Duration>'
		union all
		select '</Durations>'
	
go


exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_CalcCP'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_CalcCP
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @DividendosYRentas Importe
    DECLARE @CreditosXSus      Importe
    DECLARE @CreditosXVtasLN   Importe
    DECLARE @CreditosXVtasOP   Importe
    DECLARE @CreditosOtros     Importe
    DECLARE @ActivosOtros      Importe
    DECLARE @ActivoTotal       Importe
    DECLARE @DeudasXRes        Importe
    DECLARE @DeudasXCmpLN      Importe
    DECLARE @DeudasXCmpOP      Importe
    DECLARE @DeudasOtras       Importe
    DECLARE @Provisiones       Importe
    DECLARE @PasivosOtros      Importe
    DECLARE @PasivoTotal       Importe
	declare @FCCAR				Importe
    DECLARE @PatrimonioNetoTotal   Importe
    DECLARE @Duration          Importe
    DECLARE @TieneVCP          integer

    DECLARE @FechaTope smalldatetime
    DECLARE @CodMonedaPais numeric(6)
    DECLARE @CantMonedas int
    DECLARE @FechaCotizacion Fecha
    DECLARE @CodMonedaFdo CodigoMedio
    DECLARE @CodMonedaCarga CodigoMedio
    DECLARE @Cambio Precio
    DECLARE @Indice int    

    SELECT  @TieneVCP = COUNT(*)
    FROM    VALORESCP
    WHERE   CodFondo = @CodFondo AND Fecha = @FechaProceso
	
    IF (@TieneVCP > 0) BEGIN

        SELECT  @ActivoTotal = SUM(Importe)
        FROM    VALORESCPIT
        WHERE   VALORESCPIT.CodFondo = @CodFondo AND VALORESCPIT.Fecha = @FechaProceso AND VALORESCPIT.RubroID = 'AC'
        
        SELECT  @PasivoTotal = SUM(Importe)
        FROM    VALORESCPIT
        WHERE   VALORESCPIT.CodFondo = @CodFondo AND VALORESCPIT.Fecha = @FechaProceso AND VALORESCPIT.RubroID = 'PA'
    
        --por el sistema londres de multiple valor de cuota
        SELECT  @PatrimonioNetoTotal = ISNULL(@ActivoTotal,0) + ISNULL(@PasivoTotal,0)

		
        CREATE TABLE #CAFCISEMANAL_CTAS (
            CodFondo Numeric(5) NOT NULL, 
            CodCtaContable Char(19) COLLATE database_default  NOT NULL,
            Importe Numeric(19,2) NULL,
            PRIMARY KEY (CodFondo,CodCtaContable))
            
		CREATE TABLE #OPERS_spOCAFCISemanalCp
			(CodMoneda			Numeric(6)
			,CodCtaContable		varchar(19)
			,CodCtaBancaria		Numeric(6)
			,CreditosXVtasLN    Numeric(19,2)
			,CreditosXVtasOP    Numeric(19,2)
			,DeudasXCmpLN		Numeric(19,2)
			,DeudasXCmpOP		Numeric(19,2)
			,FactorConversionCpas Numeric(19,10)
			,FactorConversionVtas Numeric(19,10)) 
			
		CREATE TABLE #MONEDAS_spOCAFCISemanalCp (
			Indice Numeric(5) NOT NULL identity(1,1),
			CodMoneda Numeric(5) NOT NULL)
			
		select @CodMonedaFdo = CodMoneda
		FROM FONDOSREAL
		WHERE @CodFondo = CodFondo

        INSERT  #CAFCISEMANAL_CTAS (CodFondo, CodCtaContable, Importe)
			SELECT  ASIENTOSIT.CodFondo, ASIENTOSIT.CodCtaContable, SUM(ISNULL(ImporteDebe, -ImporteHaber))
			FROM    ASIENTOSCAB INNER JOIN ASIENTOSIT ON ASIENTOSIT.CodFondo = ASIENTOSCAB.CodFondo AND ASIENTOSIT.NumAsiento = ASIENTOSCAB.NumAsiento
			WHERE   ASIENTOSCAB.CodFondo = @CodFondo AND ASIENTOSCAB.FechaConcertacion <= @FechaProceso
			GROUP BY ASIENTOSIT.CodFondo,ASIENTOSIT.CodCtaContable
        
		DELETE FROM #CAFCISEMANAL_CTAS WHERE Importe = 0
    
		
        SELECT  @DividendosYRentas = SUM(CASE CTASCONTABLES.CodTpCtaAutomatica
                                              WHEN 'DEFACO' THEN Importe
                                              WHEN 'RNTACO' THEN Importe
                                              ELSE 0
                                         END),
                @CreditosXSus =      SUM(CASE CTASCONTABLES.CodTpCtaAutomatica
                                              WHEN 'SUSACO' THEN Importe
                                              ELSE 0
                                         END),
                @CreditosOtros =     SUM(CASE CTASCONTABLES.CodTpCtaAutomatica
                                              WHEN 'INTACO' THEN Importe
                                              WHEN 'INTANT' THEN Importe
                                              WHEN 'INTNOD' THEN Importe
                                              ELSE 0
                                         END),
                @DeudasXRes =        SUM(CASE CTASCONTABLES.CodTpCtaAutomatica
                                              WHEN 'ACXRES' THEN Importe
                                              ELSE 0
                                         END),
                @DeudasOtras =       SUM(CASE CTASCONTABLES.CodTpCtaAutomatica
                                              WHEN 'FRACAP' THEN Importe
                                              ELSE 0
                                         END),
                @Provisiones =       SUM(CASE CTASCONTABLES.CodTpCtaAutomatica
                                              WHEN 'PGTOD'  THEN Importe
                                              WHEN 'PGTOG'  THEN Importe
                                              WHEN 'PHOND'  THEN Importe
                                              WHEN 'PHONG'  THEN Importe
                                              ELSE 0
                                         END),

				@FCCAR	 =			 SUM(CASE CTASCONTABLES.CodTpCtaAutomatica
                                              WHEN 'FCCAR'  THEN Importe
                                              ELSE 0
                                         END)

        FROM    #CAFCISEMANAL_CTAS
                INNER JOIN CTASCONTABLES
                        ON CTASCONTABLES.CodFondo = #CAFCISEMANAL_CTAS.CodFondo
                       AND CTASCONTABLES.CodCtaContable = #CAFCISEMANAL_CTAS.CodCtaContable
       
	   CREATE TABLE #OPERS_spOCAFCISemanalCp_Tabla
			(CodMoneda			Numeric(6)
			,EsDebito		numeric(5)
			,Plazo		Numeric(4)
			,CodTpCtaAutomatica    varchar(6)
			,ImporteHaber    Numeric(19,2)
			,ImporteDebe		Numeric(19,2)
			,Coeficiente		Numeric(16,10)) 
		
		
		insert into #OPERS_spOCAFCISemanalCp_Tabla (CodMoneda, EsDebito, Plazo, CodTpCtaAutomatica, ImporteHaber, ImporteDebe, Coeficiente)
		SELECT  CTASCONTABLES.CodMoneda, EsDebito, Plazo, CodTpCtaAutomatica, ImporteHaber, ImporteDebe, Coeficiente
        FROM    OPERBURSATILES
                INNER JOIN TPOPERACION
                        ON TPOPERACION.CodTpOperacion = OPERBURSATILES.CodTpOperacion
                INNER JOIN ASIENTOSCABREL
                        ON ASIENTOSCABREL.CodFondo = OPERBURSATILES.CodFondo
                       AND ASIENTOSCABREL.CodOperBursatil = OPERBURSATILES.CodOperBursatil
                INNER JOIN ASIENTOSCAB
                        INNER JOIN ASIENTOSIT
                                INNER JOIN CTASCONTABLES
                                        ON CTASCONTABLES.CodFondo = ASIENTOSIT.CodFondo
                                       AND CTASCONTABLES.CodCtaContable = ASIENTOSIT.CodCtaContable
                                ON ASIENTOSIT.CodFondo = ASIENTOSCAB.CodFondo
                               AND ASIENTOSIT.NumAsiento = ASIENTOSCAB.NumAsiento
                        ON ASIENTOSCAB.CodFondo = ASIENTOSCABREL.CodFondo
                       AND ASIENTOSCAB.NumAsiento = ASIENTOSCABREL.NumAsiento
                       AND ASIENTOSCAB.FechaConcertacion <= @FechaProceso
        WHERE   OPERBURSATILES.CodFondo = @CodFondo
            AND OPERBURSATILES.FechaConcertacion <= @FechaProceso
            AND @FechaProceso < OPERBURSATILES.FechaLiquidacion
            AND OPERBURSATILES.EstaAnulado = 0

		
		INSERT INTO #OPERS_spOCAFCISemanalCp
		(CodMoneda, CreditosXVtasLN, CreditosXVtasOP, DeudasXCmpLN, DeudasXCmpOP)
        SELECT  CodMoneda, 
				CreditosXVtasLN =  SUM(CASE WHEN EsDebito = -1 AND Plazo <= 3 AND CodTpCtaAutomatica = 'DEXOAL'
                                         THEN ROUND(ISNULL(ImporteHaber, -ImporteDebe)  * Coeficiente,2)
                                         ELSE 0
                                    END),
                CreditosXVtasOP =  SUM(CASE WHEN EsDebito = -1 AND Plazo > 3 AND CodTpCtaAutomatica = 'DEXOAL'
                                         THEN ROUND(ISNULL(ImporteHaber, -ImporteDebe) * Coeficiente,2)
                                         ELSE 0
                                    END),
                DeudasXCmpLN =     SUM(CASE WHEN EsDebito = 0 AND Plazo <= 3 AND CodTpCtaAutomatica = 'ACXOAL'
                                         THEN ROUND(ISNULL(ImporteHaber, -ImporteDebe) * Coeficiente,2)
                                         ELSE 0
                                    END),
                DeudasXCmpOP =     SUM(CASE WHEN EsDebito = 0 AND Plazo > 3 AND CodTpCtaAutomatica = 'ACXOAL'
                                         THEN ROUND(ISNULL(ImporteHaber, -ImporteDebe) * Coeficiente,2)
                                         ELSE 0
                                    END)
        FROM    #OPERS_spOCAFCISemanalCp_Tabla
		group by #OPERS_spOCAFCISemanalCp_Tabla.CodMoneda


		
		--Actualizo Tipos de Cambio
		IF (SELECT COUNT(*) FROM #OPERS_spOCAFCISemanalCp) > 0
		BEGIN
			INSERT  #MONEDAS_spOCAFCISemanalCp
			SELECT DISTINCT OPER.CodMoneda
			FROM   #OPERS_spOCAFCISemanalCp OPER
			WHERE  OPER.CodMoneda <> @CodMonedaFdo
		    
			SELECT  @CantMonedas = @@ROWCOUNT
			SELECT  @Indice = 1
		
			WHILE   @Indice <= @CantMonedas BEGIN
				SELECT  @CodMonedaCarga = CodMoneda FROM #MONEDAS_spOCAFCISemanalCp WHERE Indice = @Indice
				EXEC    spXCalcularUltCambioActPas 0, @CodFondo, @CodMonedaCarga, @CodMonedaFdo, @FechaProceso, @Cambio OUTPUT, NULL, NULL

				UPDATE  #OPERS_spOCAFCISemanalCp
					SET FactorConversionCpas = @Cambio
				WHERE   CodMoneda = @CodMonedaCarga  and FactorConversionCpas IS NULL

				EXEC    spXCalcularUltCambioActPas -1, @CodFondo, @CodMonedaCarga, @CodMonedaFdo, @FechaProceso, @Cambio OUTPUT, NULL, NULL

				UPDATE  #OPERS_spOCAFCISemanalCp
					SET FactorConversionVtas = @Cambio
				WHERE   CodMoneda = @CodMonedaCarga  and FactorConversionVtas IS NULL

				SELECT @Indice = @Indice + 1
			END
		END

		--Actualizo importe con Tipo Cambio obtenido
		UPDATE #OPERS_spOCAFCISemanalCp
		SET CreditosXVtasLN=ROUND(CreditosXVtasLN * FactorConversionVtas,2),
			CreditosXVtasOP=ROUND(CreditosXVtasOP * FactorConversionVtas,2), 
			DeudasXCmpLN=ROUND(DeudasXCmpLN * FactorConversionCpas,2), 
			DeudasXCmpOP=ROUND(DeudasXCmpOP * FactorConversionCpas,2) 
		WHERE CodMoneda <> @CodMonedaFdo
		
		SELECT @CreditosXVtasLN = SUM(CreditosXVtasLN),
			   @CreditosXVtasOP = SUM(CreditosXVtasOP),
			   @DeudasXCmpLN = SUM(DeudasXCmpLN),
			   @DeudasXCmpOP = SUM(DeudasXCmpOP)
		FROM #OPERS_spOCAFCISemanalCp
		
	END

    SELECT  @DividendosYRentas = ABS(ISNULL(@DividendosYRentas, 0))
    SELECT  @CreditosXSus = ABS(ISNULL(@CreditosXSus, 0))
    SELECT  @CreditosXVtasLN = ABS(ISNULL(@CreditosXVtasLN, 0))
    SELECT  @CreditosXVtasOP = ABS(ISNULL(@CreditosXVtasOP, 0))
    SELECT  @CreditosOtros = ABS(ISNULL(@CreditosOtros, 0))
    SELECT  @ActivoTotal = ABS(ISNULL(@ActivoTotal, 0))
    SELECT  @DeudasXRes = ABS(ISNULL(@DeudasXRes, 0))
    SELECT  @DeudasXCmpLN = ABS(ISNULL(@DeudasXCmpLN, 0))
    SELECT  @DeudasXCmpOP = ABS(ISNULL(@DeudasXCmpOP, 0))
    SELECT  @DeudasOtras = ABS(ISNULL(@DeudasOtras, 0))
    SELECT  @Provisiones = ABS(ISNULL(@Provisiones, 0))
    SELECT  @PasivoTotal = ABS(ISNULL(@PasivoTotal, 0))
    SELECT  @PatrimonioNetoTotal = ISNULL(@PatrimonioNetoTotal, 0)
    SELECT  @Duration = ISNULL(@Duration, 0)


    IF (@TieneVCP > 0) BEGIN
        SELECT  @ActivosOtros = @ActivoTotal - (@DividendosYRentas + @CreditosXSus + @CreditosXVtasLN + @CreditosXVtasOP + @CreditosOtros) 
        SELECT  @PasivosOtros = @PasivoTotal - (@DeudasXRes + @DeudasXCmpLN + @DeudasXCmpOP + @DeudasOtras + @Provisiones)
    END
	

	insert into #CAFCIUNIFICADA_Tag_Duration (CampoXml)
		SELECT  '<CalcCP>' +
					'<ActTotal>' + convert(varchar,coalesce(convert(numeric(20,2),@ActivoTotal),0)) + '</ActTotal>' +
					'<CredxSus>' + convert(varchar,coalesce(convert(numeric(20,2),@CreditosXSus),0)) + '</CredxSus>' +
					'<CredxVtasLiqNorm>' + convert(varchar,coalesce(convert(numeric(20,2),@CreditosXVtasLN),0)) + '</CredxVtasLiqNorm>' +
					'<CredxVtasOP>' + convert(varchar,coalesce(convert(numeric(20,2),@CreditosXVtasOP),0)) + '</CredxVtasOP>' +
					'<CredOtros>' + convert(varchar,coalesce(convert(numeric(20,2),@CreditosOtros),0))  + '</CredOtros>' +
					'<DivRentas>' + convert(varchar,coalesce(convert(numeric(20,2),@DividendosYRentas),0))  + '</DivRentas>' +
					'<ActOtros>' + convert(varchar,coalesce(convert(numeric(20,2),@ActivosOtros),0))  + '</ActOtros>' +
					'<PasTotal>' + convert(varchar,coalesce(convert(numeric(20,2),@PasivoTotal),0))  + '</PasTotal>' +
					'<DeuxCompLiqNorm>' + convert(varchar,coalesce(convert(numeric(20,2),@DeudasXCmpLN),0))  + '</DeuxCompLiqNorm>' +
					'<DeuxCompOP>' + convert(varchar,coalesce(convert(numeric(20,2),@DeudasXCmpOP),0))  + '</DeuxCompOP>' +
					'<DeuxRes>' + convert(varchar,coalesce(convert(numeric(20,2),@DeudasXRes),0))  + '</DeuxRes>' +
					'<DeuOtras>' + convert(varchar,coalesce(convert(numeric(20,2),@DeudasOtras),0))  + '</DeuOtras>' +
					'<Prov>' + convert(varchar,coalesce(convert(numeric(20,2),@Provisiones),0))  + '</Prov>' +
					'<PasOtros>' + convert(varchar,coalesce(convert(numeric(20,2),@PasivosOtros),0))  + '</PasOtros>' +
					'<PNTotal>' + convert(varchar,coalesce(convert(numeric(20,2),@PatrimonioNetoTotal),0))  + '</PNTotal>' +            
				--@Duration AS Duration +
				'</CalcCP>'
	

go


exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Inversor'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Inversor
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as

	DECLARE @FechaVCP   Fecha
    DECLARE @CodTpFondo CodigoTextoCorto

    SELECT  @FechaVCP = MAX(Fecha) FROM VALORESCP WHERE VALORESCP.CodFondo = @CodFondo AND VALORESCP.Fecha <= @FechaProceso
    SELECT  @CodTpFondo = CodTpFondo FROM FONDOSREAL WHERE CodFondo=@CodFondo

    CREATE TABLE #CAFCIMENSUAL_INVERSORES_TOC2013OUT
       (
		CodigoSubTipo varchar(30) not null,
		CodInterfaz varchar(30) null, 
		Campo_Q numeric (15) not null, 
		Campo_Monto numeric(19,2) not null
		)

    CREATE TABLE #CAFCIMENSUAL_LIQ
       (CodTpValorCp numeric(5) NOT NULL,
        CodCuotapartista numeric(10) NOT NULL,
        CantCuotapartes numeric(22, 8))

	--Busco informacion básica
	
    INSERT INTO #CAFCIMENSUAL_LIQ (CodTpValorCp, CodCuotapartista, CantCuotapartes)
    SELECT  LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista, SUM(LIQUIDACIONES.CantCuotapartes) AS CantCuotapartes
    FROM    LIQUIDACIONES
    WHERE   LIQUIDACIONES.CodFondo = @CodFondo AND FechaConcertacion <= @FechaVCP AND EstaAnulado = 0
    GROUP BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista 
    HAVING SUM(LIQUIDACIONES.CantCuotapartes) <> 0
    ORDER BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista
	
	
    IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_TIPO_DE_INVERSOR')) 
	BEGIN

		
		INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
		SELECT isnull(Inversor,'     '), 
			NULL, 
			Cantidad, 
			Monto 
		FROM FM_MONTO_POR_TIPO_DE_INVERSOR
        INNER JOIN CONDICIONESINGEGR			
			ON FM_MONTO_POR_TIPO_DE_INVERSOR.Fondo = CONVERT(NUMERIC(5),CONDICIONESINGEGR.CodInterfaz)
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
			and ISNUMERIC(CONDICIONESINGEGR.CodInterfaz) = 1
        WHERE Fecha = @FechaVCP
        
    END
	ELSE IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_TIPO_PERSONA')) 
	BEGIN
		
        INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT 
				(CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
		SELECT 
		dbo.fnTraerCodCAFCIDefault(CASE WHEN UPPER(FM_MONTO_POR_TIPO_PERSONA.Persona) = 'F' THEN -1 ELSE 0 END) AS CodigoSubTipo, 
		NULL,
		FM_MONTO_POR_TIPO_PERSONA.Cantidad, 
		FM_MONTO_POR_TIPO_PERSONA.Monto 
		FROM FM_MONTO_POR_TIPO_PERSONA
			INNER JOIN CONDICIONESINGEGR 
			ON FM_MONTO_POR_TIPO_PERSONA.Fondo = CONVERT(NUMERIC(5),CONDICIONESINGEGR.CodInterfaz)            
			AND CONDICIONESINGEGR.CodFondo = @CodFondo
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
			and ISNUMERIC(CONDICIONESINGEGR.CodInterfaz) = 1
        WHERE FM_MONTO_POR_TIPO_PERSONA.Fecha = @FechaVCP
        
    END
    ELSE BEGIN
			
			--Involucrar los que tienen configurado TIPO DE INVERSOR en el cuotapartista
			INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
            SELECT  
    				isnull(TPINVERSORES.CodCAFCI,'     '),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
					INNER JOIN TPINVERSORES ON CUOTAPARTISTAS.CodTpInversor =TPINVERSORES.CodTpInversor
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP

			GROUP BY  TPINVERSORES.CodCAFCI



			--Involucrar los que tienen configurado TIPO DE INVERSOR en el Segmento de Inversión (porque no lo tienen en el cuotapartista), 
			INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
            SELECT  
    				isnull(TPINVERSORES.CodCAFCI,'     '),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
					INNER JOIN SEGMENTOSINV 
							ON CUOTAPARTISTAS.CodSegmentoInv = SEGMENTOSINV.CodSegmentoInv
						   AND CUOTAPARTISTAS.EsPersonaFisica = SEGMENTOSINV.EsPersonaFisica
					INNER JOIN TPINVERSORES 
							ON SEGMENTOSINV.CodTpInversor = TPINVERSORES.CodTpInversor
						   AND SEGMENTOSINV.EsPersonaFisica = TPINVERSORES.EsPersonaFisica
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP

			WHERE	CUOTAPARTISTAS.CodTpInversor IS NULL
			GROUP BY  TPINVERSORES.CodCAFCI
			

			--Involucrar los que NO tienen configurado TIPO DE INVERSOR, asignándoles uno por default, según el campo EsPersonaFísica
			INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
            SELECT  
    				dbo.fnTraerCodCAFCIDefault(CUOTAPARTISTAS.EsPersonaFisica),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista 
					LEFT JOIN  SEGMENTOSINV 
							ON CUOTAPARTISTAS.CodSegmentoInv = SEGMENTOSINV.CodSegmentoInv
					LEFT JOIN TPINVERSORES 
						     ON SEGMENTOSINV.CodTpInversor = TPINVERSORES.CodTpInversor
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP
			WHERE   (
						CUOTAPARTISTAS.CodSegmentoInv is null
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND SEGMENTOSINV.CodTpInversor is null)
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND (SEGMENTOSINV.EsPersonaFisica <> CUOTAPARTISTAS.EsPersonaFisica))
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND (TPINVERSORES.EsPersonaFisica <> CUOTAPARTISTAS.EsPersonaFisica))
					)
					AND CUOTAPARTISTAS.CodTpInversor is null

			GROUP BY  dbo.fnTraerCodCAFCIDefault(CUOTAPARTISTAS.EsPersonaFisica)
        
    END

	create table #TEMP_FINAL 
	(
		SubTipoCod varchar(30) collate database_default not null,
		CodInterfaz varchar(30) collate database_default null, 
		Monto numeric (19,2) not null, 
		CantInv numeric(20) not null		
	)

	insert into #TEMP_FINAL (SubTipoCod, CodInterfaz, CantInv, Monto)
    SELECT 
		CodigoSubTipo, 
		CodInterfaz, 
		sum(Campo_Q) AS Campo_Q, 
		sum(Campo_Monto) AS Campo_Monto
	FROM #CAFCIMENSUAL_INVERSORES_TOC2013OUT
	group by CodigoSubTipo, CodInterfaz
	
	
	insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
	select '<Inversores>'
	
	if (select count(*) from #TEMP_FINAL) > 0
	begin
		insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
		SELECT  
			'<Inversor>' +
			case when coalesce(convert(varchar,SubTipoCod),'') = '' then '<SubTipoCod/>' else '<SubTipoCod>' + dbo.fnSacarCaracteresEspXML(convert(varchar,SubTipoCod)) + '</SubTipoCod>' end +
			case when coalesce(convert(varchar,convert(numeric(20,2),Monto)),'') = '' then '<Monto/>' else '<Monto>'  + convert(varchar,convert(numeric(20,2),Monto)) + '</Monto>' end +			
			case when coalesce(convert(varchar,convert(numeric(20),CantInv)),'') = '' then '<CantInv/>' else '<CantInv>' + convert(varchar,convert(numeric(20),CantInv)) + '</CantInv>' end +			
			'</Inversor>'
		FROM #TEMP_FINAL
		
		insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
		SELECT  
			'<Inversor>' +
			'<SubTipoCod>TOTAL</SubTipoCod>' +
			'<Monto>' + convert(varchar,convert(numeric(20,2),SUM(COALESCE(Monto,0)))) + '</Monto>' +			
			'<CantInv>' + convert(varchar,convert(numeric(20),SUM(COALESCE(CantInv,0)))) +  '</CantInv>' +			
			'</Inversor>'
		FROM #TEMP_FINAL
		

	end
	else
	begin
		insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
		SELECT  
			'<Inversor>' +
			'<SubTipoCod/>' +
			'<Monto/>' +			
			'<CantInv/>' +			
			'</Inversor>'
	end
	
	insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
	select '</Inversores>'
	
go




exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_ResidenciaInversores'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_ResidenciaInversores
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @FechaVCP   Fecha
    DECLARE @CodTpFondo CodigoTextoCorto

    SELECT  @FechaVCP = MAX(Fecha) FROM VALORESCP WHERE VALORESCP.CodFondo = @CodFondo AND VALORESCP.Fecha <= @FechaProceso
    SELECT  @CodTpFondo = CodTpFondo FROM FONDOSREAL WHERE CodFondo=@CodFondo

  
    CREATE TABLE #CAFCIMENSUAL_LIQ
       (CodTpValorCp numeric(5) NOT NULL,
        CodCuotapartista numeric(10) NOT NULL,
        CantCuotapartes numeric(22, 8))


	--Busco informacion básica
    INSERT INTO #CAFCIMENSUAL_LIQ (CodTpValorCp, CodCuotapartista, CantCuotapartes)
    SELECT  LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista, SUM(LIQUIDACIONES.CantCuotapartes) AS CantCuotapartes
    FROM    LIQUIDACIONES
    WHERE   LIQUIDACIONES.CodFondo = @CodFondo AND FechaConcertacion <= @FechaVCP AND EstaAnulado = 0
    GROUP BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista
    HAVING SUM(LIQUIDACIONES.CantCuotapartes) <> 0
    ORDER BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista

	create table #TEMP_FINAL 
	(
		PaisTCod varchar(1) collate database_default,
		PaisNom	varchar(30) collate database_default,
		PaisCod varchar(80) collate database_default,
		MontoPais numeric(19,2) NOT NULL,
		CCPPais numeric(22,8)
	)

	IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_PAIS_RESIDENCIA')) 
	BEGIN
		
		insert into #TEMP_FINAL(PaisTCod, PaisNom, PaisCod, CCPPais, MontoPais)
        SELECT  CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                     ELSE 'C'
                END AS PaisTCod,
                dbo.fnSacarCaracteresEspXML(ISNULL(PAISES.Descripcion, '')) AS PaisNombre,
				dbo.fnSacarCaracteresEspXML(COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, PAISES.CodDGI, '')) AS PaisCod,                
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Cuotapartes), 0) AS Q,
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Monto), 0) AS Monto
        FROM    FM_MONTO_POR_PAIS_RESIDENCIA
        INNER JOIN CONDICIONESINGEGR ON FM_MONTO_POR_PAIS_RESIDENCIA.Fondo = convert(numeric(5),CONDICIONESINGEGR.CodInterfaz)
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
        LEFT JOIN PAISES ON PAISES.CodPais = FM_MONTO_POR_PAIS_RESIDENCIA.PaisResidencia
        WHERE  datediff(d, FM_MONTO_POR_PAIS_RESIDENCIA.Fecha, @FechaVCP) = 0
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
        GROUP BY PAISES.CodCAFCI, PAISES.CodInterfaz, PAISES.CodDGI, PAISES.Descripcion

    END
    ELSE BEGIN
        IF @CodTpFondo='MM' BEGIN
			insert into #TEMP_FINAL(PaisTCod, PaisNom, PaisCod, CCPPais,MontoPais)
            SELECT  CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END AS PaisTCod,
                    dbo.fnSacarCaracteresEspXML(ISNULL(PAISES.Descripcion, '')) AS PaisNombre,
					dbo.fnSacarCaracteresEspXML(COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, CodDGI, '')) AS PaisCod,                    
                    ISNULL(SUM(CantCuotapartes), 0) AS Q,
                    ISNULL(SUM(CantCuotapartes * ValorCpInicial), 0) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
            GROUP BY CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END,
                    COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, CodDGI, ''),
                    ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais
        END
        ELSE BEGIN
			insert into #TEMP_FINAL(PaisTCod, PaisNom, PaisCod, CCPPais,MontoPais)
            SELECT  CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END AS PaisTCod,
                    dbo.fnSacarCaracteresEspXML(ISNULL(PAISES.Descripcion, '')) AS PaisNombre,
					dbo.fnSacarCaracteresEspXML(coalesce(PAISES.CodCAFCI, PAISES.CodInterfaz, CodDGI, '')) AS PaisCod,                    
                    ISNULL(SUM(CantCuotapartes), 0) AS Q,
                    ISNULL(SUM(CantCuotapartes * ValorCuotaparte), 0) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP
            GROUP BY CASE WHEN CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END,
                    COALESCE(CodCAFCI, PAISES.CodInterfaz, CodDGI, ''),
                    ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais        
        END
    END
	
	insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
	select '<ResidenciasInversores>'
	
	if (select count(*) from #TEMP_FINAL) > 0
	begin
		insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
		select	'<ResidenciaInversores>' +
				case when dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(PaisNom,''))) = '' then '<PaisNom/>' else '<PaisNom>' + dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(PaisNom,''))) + '</PaisNom>' end +
				case when convert(varchar,coalesce(PaisTCod,''))='' then '<PaisTCod/>' else '<PaisTCod>' + convert(varchar,coalesce(PaisTCod,'')) + '</PaisTCod>' end +
				case when convert(varchar,coalesce(PaisCod,'')) = '' then '<PaisCod/>' else '<PaisCod>' + convert(varchar,coalesce(PaisCod,'')) +  '</PaisCod>' end +
				'<MontoPais>' + convert(varchar,coalesce(convert(numeric(19,2),MontoPais),0)) + '</MontoPais>' +
				'<CCPPais>' + convert(varchar,coalesce(convert(numeric(22,8),CCPPais),0)) +  '</CCPPais>' +
				'</ResidenciaInversores>'
		from	#TEMP_FINAL
	end
	else
	begin
		insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
		select	'<ResidenciaInversores>' +
				'<PaisNom/>' +
				'<PaisTCod/>' +
				'<PaisCod/>' +
				'<MontoPais/>' +
				'<CCPPais/>' +
				'</ResidenciaInversores>'
	end
	
	insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
	select '</ResidenciasInversores>'
	


go



exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_HonCom'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_HonCom
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	CREATE TABLE #VCPITINT_TPVALORCP (
        CodFondo		 numeric(6,0)    NULL,
        CodTpValorCp     numeric(6,0)    NULL,
        Descripcion      varchar(80) COLLATE database_default NULL,
        CodCAFCI		 varchar(30) COLLATE database_default NULL)   
           
    INSERT #VCPITINT_TPVALORCP (CodFondo,CodTpValorCp, Descripcion, CodCAFCI)
		SELECT CodFondo,CodTpValorCp, Descripcion, CodCAFCI
		FROM TPVALORESCP
		WHERE CodFondo=@CodFondo
		AND COALESCE(FechaFin,DATEADD(dd,1,@FechaProceso)) > @FechaProceso 


	create table #TEMP_FINAL
	(
		ClaseId varchar(30) collate database_default null,
		ClaseNom varchar(80) collate database_default null,
		InvMinima numeric(19,2) null,
		HAdmAA numeric(12,8) null,
		HAdmAC  numeric(12,8) null,
		HExito varchar(30) collate database_default null,
		CIngreso numeric(12,8) null,
		CRescate numeric(12,8) null,
		CTransf numeric(12,8) null,
		GOrdG numeric(12,8) null
	)

	insert into #TEMP_FINAL (ClaseId,ClaseNom,InvMinima,HAdmAA,HAdmAC,HExito,CIngreso,CRescate,CTransf,GOrdG)
    SELECT  
			dbo.fnSacarCaracteresEspXML(ISNULL(TPVCP.CodCAFCI, '')) AS ClaseId,
            dbo.fnSacarCaracteresEspXML(ISNULL(TPVCP.Descripcion, '')) AS ClaseNombre,
            CASE MAX(CONDICIONESINGEGR.SuscripcionMinima)
                 WHEN 0 THEN 1
                 ELSE MAX(CONDICIONESINGEGR.SuscripcionMinima)
            END AS Minimo,
			--case when dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'S',@FechaProceso) = 0 then	
			--	dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'G',@FechaProceso)
			--else
				dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'S',@FechaProceso) 
			--end 
			AS AdmSGte,
			
			--case when dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'A',@FechaProceso) = 0 then
			--	dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'D',@FechaProceso) 
			--else
			--	dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'A',@FechaProceso) 
			--end AS AdmSDep,
			dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'A',@FechaProceso)
			--+ dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'D',@FechaProceso)
			AS AdmSDep, /*Honorarios Sociedad Depositaria + Gastos Sociedad Depositaria*/	

            CASE WHEN MAX(CASE CodTpComDesempeno WHEN 'SC' THEN 0 ELSE 1 END) = 1
                 THEN 'S'
                 ELSE 'N'
            END AS Exito,
            MAX(ISNULL(GTSU.Porcentaje, CONDICIONESINGEGR.PorcComSuscripcion)) AS Ingreso,
            MAX(ISNULL(GTRE.Porcentaje, CONDICIONESINGEGR.PorcComRescate)) AS Rescate,
            0 AS Transferencia,
			dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'G',@FechaProceso)
				+ dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'D',@FechaProceso) AS GOG
    FROM    #VCPITINT_TPVALORCP TPVCP
            INNER JOIN CONDINGEGRTPVALORESCP
                    ON CONDINGEGRTPVALORESCP.CodFondo = TPVCP.CodFondo
                   AND CONDINGEGRTPVALORESCP.CodTpValorCp = TPVCP.CodTpValorCp
                   AND CONDINGEGRTPVALORESCP.EstaAnulado = 0
            INNER JOIN CONDICIONESINGEGR
                    ON CONDICIONESINGEGR.CodFondo = CONDINGEGRTPVALORESCP.CodFondo
                   AND CONDICIONESINGEGR.CodCondicionIngEgr = CONDINGEGRTPVALORESCP.CodCondicionIngEgr
                   AND CONDICIONESINGEGR.EstaAnulado = 0
            LEFT  JOIN GTOSADQUISICION GTSU
                    ON GTSU.CodFondo = CONDICIONESINGEGR.CodFondo
                   AND GTSU.CodTpGtoAdquisicion = CONDICIONESINGEGR.CodTpGtoAdquisicionSusc
                   AND GTSU.CodCondicionIngEgr = CONDICIONESINGEGR.CodCondicionIngEgr
                   AND GTSU.EstaAnulado = 0
            LEFT  JOIN GTOSADQUISICION GTRE
                    ON GTRE.CodFondo = CONDICIONESINGEGR.CodFondo
                   AND GTRE.CodTpGtoAdquisicion = CONDICIONESINGEGR.CodTpGtoAdquisicionResc
                   AND GTRE.CodCondicionIngEgr = CONDICIONESINGEGR.CodCondicionIngEgr
                   AND GTRE.EstaAnulado = 0
    WHERE   TPVCP.CodFondo = @CodFondo
    GROUP BY TPVCP.CodFondo,TPVCP.CodTpValorCp, TPVCP.CodCAFCI, TPVCP.Descripcion
    ORDER BY TPVCP.CodTpValorCp

	
	insert into #CAFCIUNIFICADA_Tag_HonCom (CampoXml)
	select '<HonComs>'
	
	if (select count(*) from #TEMP_FINAL) > 0
	begin
		insert into #CAFCIUNIFICADA_Tag_HonCom (CampoXml)
		select	'<HonCom>' +
				case when dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(ClaseNom,'')))='' then '<ClaseNom/>' else '<ClaseNom>' + dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(ClaseNom,''))) + '</ClaseNom>' end +
				case when convert(varchar,coalesce(ClaseId,''))='' then '<ClaseId/>' else '<ClaseId>' + convert(varchar,coalesce(ClaseId,'')) + '</ClaseId>' end +
				'<InvMinima>' + convert(varchar,coalesce(convert(numeric(20,2),InvMinima),0)) + '</InvMinima>' +
				'<HAdmAA>' + convert(varchar,coalesce(convert(numeric(8,4),HAdmAA),0)) + '</HAdmAA>' +
				'<HAdmAC>' + convert(varchar,coalesce(convert(numeric(8,4),HAdmAC),0)) + '</HAdmAC>' +
				case when convert(varchar,coalesce(HExito,''))='' then '<HExito/>' else '<HExito>' + convert(varchar,coalesce(HExito,'')) + '</HExito>' end +
				'<CIngreso>' + convert(varchar,coalesce(convert(numeric(8,4),CIngreso),0)) + '</CIngreso>' +
				'<CRescate>' + convert(varchar,coalesce(convert(numeric(8,4),CRescate),0)) + '</CRescate>' +
				'<CTransf>' + convert(varchar,coalesce(convert(numeric(8,4),CTransf),0)) + '</CTransf>' +
				'<GOrdG>' + convert(varchar,coalesce(convert(numeric(8,4),GOrdG),0)) + '</GOrdG>' +
				'</HonCom>'
		from	#TEMP_FINAL
		where ISNULL(#TEMP_FINAL.ClaseId, '') <> ''
	end
	else
	begin
		insert into #CAFCIUNIFICADA_Tag_HonCom (CampoXml)
		select	'<HonCom>' +
				'<ClaseNom/>' +
				'<ClaseId/>' +
				'<InvMinima/>' +
				'<HAdmAA/>' +
				'<HAdmAC/>' +
				'<HExito/>' +
				'<CIngreso/>' +
				'<CRescate/>' +
				'<CTransf/>' +
				'<GOrdG/>' +
				'</HonCom>'
	end
	
	insert into #CAFCIUNIFICADA_Tag_HonCom (CampoXml)
	select '</HonComs>'
	

go


exec sp_CreateProcedure 'dbo.spGDIN_CAFCIUnificada_Tag_HonCom'
go
alter procedure dbo.spGDIN_CAFCIUnificada_Tag_HonCom
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	CREATE TABLE #VCPITINT_TPVALORCP (
        CodFondo		 numeric(6,0)    NULL,
        CodTpValorCp     numeric(6,0)    NULL,
        Descripcion      varchar(80) COLLATE database_default NULL,
        CodCAFCI		 varchar(30) COLLATE database_default NULL)   
           
    INSERT #VCPITINT_TPVALORCP (CodFondo,CodTpValorCp, Descripcion, CodCAFCI)
		SELECT CodFondo,CodTpValorCp, Descripcion, CodCAFCI
		FROM TPVALORESCP
		WHERE CodFondo=@CodFondo
		AND COALESCE(FechaFin,DATEADD(dd,1,@FechaProceso)) > @FechaProceso 


	create table #TEMP_FINAL
	(
		ClaseId varchar(30) collate database_default null,
		ClaseNom varchar(80) collate database_default null,
		InvMinima numeric(19,2) null,
		HAdmAA numeric(12,8) null,
		HAdmAC  numeric(12,8) null,
		HExito varchar(30) collate database_default null,
		CIngreso numeric(12,8) null,
		CRescate numeric(12,8) null,
		CTransf numeric(12,8) null,
		GOrdG numeric(12,8) null
	)

	insert into #TEMP_FINAL (ClaseId,ClaseNom,InvMinima,HAdmAA,HAdmAC,HExito,CIngreso,CRescate,CTransf,GOrdG)
    SELECT  
			ISNULL(TPVCP.CodCAFCI, '') AS ClaseId,
            ISNULL(TPVCP.Descripcion, '') AS ClaseNombre,
            CASE MAX(CONDICIONESINGEGR.SuscripcionMinima)
                 WHEN 0 THEN 1
                 ELSE MAX(CONDICIONESINGEGR.SuscripcionMinima)
            END AS Minimo,
			--case when dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'S',@FechaProceso) = 0 then	
			--	dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'G',@FechaProceso)
			--else
				dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'S',@FechaProceso) 
			--end 
			AS AdmSGte,
			
			--case when dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'A',@FechaProceso) = 0 then
			--	dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'D',@FechaProceso) 
			--else
			--	dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'A',@FechaProceso) 
			--end AS AdmSDep,
			dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'A',@FechaProceso)
			--+ dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'D',@FechaProceso)
			AS AdmSDep, /*Honorarios Sociedad Depositaria + Gastos Sociedad Depositaria*/	

            CASE WHEN MAX(CASE CodTpComDesempeno WHEN 'SC' THEN 0 ELSE 1 END) = 1
                 THEN 'S'
                 ELSE 'N'
            END AS Exito,
            MAX(ISNULL(GTSU.Porcentaje, CONDICIONESINGEGR.PorcComSuscripcion)) AS Ingreso,
            MAX(ISNULL(GTRE.Porcentaje, CONDICIONESINGEGR.PorcComRescate)) AS Rescate,
            0 AS Transferencia,
			dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'G',@FechaProceso)
				+ dbo.fnPorcentajeProvisionPublicacion(TPVCP.CodFondo,TPVCP.CodTpValorCp,'D',@FechaProceso) AS GOG
    FROM    #VCPITINT_TPVALORCP TPVCP
            INNER JOIN CONDINGEGRTPVALORESCP
                    ON CONDINGEGRTPVALORESCP.CodFondo = TPVCP.CodFondo
                   AND CONDINGEGRTPVALORESCP.CodTpValorCp = TPVCP.CodTpValorCp
                   AND CONDINGEGRTPVALORESCP.EstaAnulado = 0
            INNER JOIN CONDICIONESINGEGR
                    ON CONDICIONESINGEGR.CodFondo = CONDINGEGRTPVALORESCP.CodFondo
                   AND CONDICIONESINGEGR.CodCondicionIngEgr = CONDINGEGRTPVALORESCP.CodCondicionIngEgr
                   AND CONDICIONESINGEGR.EstaAnulado = 0
            LEFT  JOIN GTOSADQUISICION GTSU
                    ON GTSU.CodFondo = CONDICIONESINGEGR.CodFondo
                   AND GTSU.CodTpGtoAdquisicion = CONDICIONESINGEGR.CodTpGtoAdquisicionSusc
                   AND GTSU.CodCondicionIngEgr = CONDICIONESINGEGR.CodCondicionIngEgr
                   AND GTSU.EstaAnulado = 0
            LEFT  JOIN GTOSADQUISICION GTRE
                    ON GTRE.CodFondo = CONDICIONESINGEGR.CodFondo
                   AND GTRE.CodTpGtoAdquisicion = CONDICIONESINGEGR.CodTpGtoAdquisicionResc
                   AND GTRE.CodCondicionIngEgr = CONDICIONESINGEGR.CodCondicionIngEgr
                   AND GTRE.EstaAnulado = 0
    WHERE   TPVCP.CodFondo = @CodFondo
    GROUP BY TPVCP.CodFondo,TPVCP.CodTpValorCp, TPVCP.CodCAFCI, TPVCP.Descripcion
    ORDER BY TPVCP.CodTpValorCp

	
	insert into #CAFCIUNIFICADA_Tag_HonCom (CampoXml)
	select '<HonComs>'
	
	if (select count(*) from #TEMP_FINAL) > 0
	begin
		insert into #CAFCIUNIFICADA_Tag_HonCom (CampoXml)
		select	'<HonCom>' +
				case when dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(ClaseNom,'')))='' then '<ClaseNom/>' else '<ClaseNom>' + dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(ClaseNom,''))) + '</ClaseNom>' end +
				case when convert(varchar,coalesce(ClaseId,''))='' then '<ClaseId/>' else '<ClaseId>' + convert(varchar,coalesce(ClaseId,'')) + '</ClaseId>' end +
				'<InvMinima>' + convert(varchar,coalesce(convert(numeric(20,2),InvMinima),0)) + '</InvMinima>' +
				'<HAdmAA>' + convert(varchar,coalesce(convert(numeric(8,4),HAdmAA),0)) + '</HAdmAA>' +
				'<HAdmAC>' + convert(varchar,coalesce(convert(numeric(8,4),HAdmAC),0)) + '</HAdmAC>' +
				case when convert(varchar,coalesce(HExito,''))='' then '<HExito/>' else '<HExito>' + convert(varchar,coalesce(HExito,'')) + '</HExito>' end +
				'<CIngreso>' + convert(varchar,coalesce(convert(numeric(8,4),CIngreso),0)) + '</CIngreso>' +
				'<CRescate>' + convert(varchar,coalesce(convert(numeric(8,4),CRescate),0)) + '</CRescate>' +
				'<CTransf>' + convert(varchar,coalesce(convert(numeric(8,4),CTransf),0)) + '</CTransf>' +
				'<GOrdG>' + convert(varchar,coalesce(convert(numeric(8,4),GOrdG),0)) + '</GOrdG>' +
				'</HonCom>'
		from	#TEMP_FINAL
		where ISNULL(#TEMP_FINAL.ClaseId, '') <> ''
	end
	else
	begin
		insert into #CAFCIUNIFICADA_Tag_HonCom (CampoXml)
		select	'<HonCom>' +
				'<ClaseNom/>' +
				'<ClaseId/>' +
				'<InvMinima/>' +
				'<HAdmAA/>' +
				'<HAdmAC/>' +
				'<HExito/>' +
				'<CIngreso/>' +
				'<CRescate/>' +
				'<CTransf/>' +
				'<GOrdG/>' +
				'</HonCom>'
	end
	
	insert into #CAFCIUNIFICADA_Tag_HonCom (CampoXml)
	select '</HonComs>'
	

go

exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Calif'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Calif
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as
	
	insert into #CAFCIUNIFICADA_Tag_Calif (CampoXml)
	select '<Califs>'

	if (SELECT  count(*)	FROM    CALIFICACIONESRSGOFDO			INNER JOIN CALIFICADORASRIESGO
						ON CALIFICADORASRIESGO.CodCalificadoraRiesgo = CALIFICACIONESRSGOFDO.CodCalificadoraRiesgo
				INNER JOIN CALIFICACIONESRIESGO
						ON CALIFICACIONESRIESGO.CodCalificadoraRiesgo = CALIFICACIONESRSGOFDO.CodCalificadoraRiesgo
					   AND CALIFICACIONESRIESGO.CodCalificacionRiesgo = CALIFICACIONESRSGOFDO.CodCalificacionRiesgo
				INNER JOIN (SELECT  CodFondo, CodCalificadoraRiesgo, MAX(FechaVigencia) AS FechaVigencia
							FROM    CALIFICACIONESRSGOFDO
							WHERE   EstaAnulado = 0
								AND FechaVigencia <= @FechaProceso
							GROUP BY CodFondo, CodCalificadoraRiesgo) CFMAX 
						ON CFMAX.CodFondo = CALIFICACIONESRSGOFDO.CodFondo
					   AND CFMAX.CodCalificadoraRiesgo = CALIFICACIONESRSGOFDO.CodCalificadoraRiesgo
					   AND CFMAX.FechaVigencia = CALIFICACIONESRSGOFDO.FechaVigencia
		WHERE   CALIFICACIONESRSGOFDO.CodFondo = @CodFondo
			AND CALIFICACIONESRSGOFDO.EstaAnulado = 0) > 0
	begin

		insert into #CAFCIUNIFICADA_Tag_Calif (CampoXml)
		SELECT  '<Calif>' +
				case when dbo.fnSacarCaracteresEspXML(coalesce(CALIFICADORASRIESGO.Descripcion, '')) = '' then '<EntCalifNom/>' else '<EntCalifNom>' + dbo.fnSacarCaracteresEspXML(coalesce(CALIFICADORASRIESGO.Descripcion, '')) + '</EntCalifNom>' end +
				'<EntCalifTCod>' + CASE WHEN CALIFICADORASRIESGO.CodCAFCI IS NULL THEN 'P' ELSE 'C' END + '</EntCalifTCod>' +
				case when COALESCE(CALIFICADORASRIESGO.CodCAFCI, CALIFICADORASRIESGO.CodInterfaz, '') = '' then '<EntCalifCod/>' else '<EntCalifCod>' + COALESCE(CALIFICADORASRIESGO.CodCAFCI, CALIFICADORASRIESGO.CodInterfaz, '') + '</EntCalifCod>' end +
				'<CalifFecha>' + convert(varchar(10),CALIFICACIONESRSGOFDO.FechaVigencia,120) + '</CalifFecha>' +
				'<CalifValor>' + CALIFICACIONESRIESGO.Descripcion + '</CalifValor>' +
				'</Calif>'
		FROM    CALIFICACIONESRSGOFDO
				INNER JOIN CALIFICADORASRIESGO
						ON CALIFICADORASRIESGO.CodCalificadoraRiesgo = CALIFICACIONESRSGOFDO.CodCalificadoraRiesgo
				INNER JOIN CALIFICACIONESRIESGO
						ON CALIFICACIONESRIESGO.CodCalificadoraRiesgo = CALIFICACIONESRSGOFDO.CodCalificadoraRiesgo
					   AND CALIFICACIONESRIESGO.CodCalificacionRiesgo = CALIFICACIONESRSGOFDO.CodCalificacionRiesgo
				INNER JOIN (SELECT  CodFondo, CodCalificadoraRiesgo, MAX(FechaVigencia) AS FechaVigencia
							FROM    CALIFICACIONESRSGOFDO
							WHERE   EstaAnulado = 0
								AND FechaVigencia <= @FechaProceso
							GROUP BY CodFondo, CodCalificadoraRiesgo) CFMAX 
						ON CFMAX.CodFondo = CALIFICACIONESRSGOFDO.CodFondo
					   AND CFMAX.CodCalificadoraRiesgo = CALIFICACIONESRSGOFDO.CodCalificadoraRiesgo
					   AND CFMAX.FechaVigencia = CALIFICACIONESRSGOFDO.FechaVigencia
		WHERE   CALIFICACIONESRSGOFDO.CodFondo = @CodFondo
			AND CALIFICACIONESRSGOFDO.EstaAnulado = 0		

	end
	else
	begin
		
		insert into #CAFCIUNIFICADA_Tag_Calif (CampoXml)
		SELECT  '<Calif>' +
				'<EntCalifNom>No Aplicable</EntCalifNom>' +
				'<EntCalifTCod>C</EntCalifTCod>' +
				'<EntCalifCod>NA</EntCalifCod>' +
				'<CalifFecha/>' +
				'<CalifValor>No Aplicable</CalifValor>' +
				'</Calif>'		
		
	end
	
	insert into #CAFCIUNIFICADA_Tag_Calif (CampoXml)
	select '</Califs>'
	
go



exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_DistUtil'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_DistUtil
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as
	Declare @ParametroEVRCD Smallint

	set @ParametroEVRCD=dbo.fnParametroEVRCD()

	create table #TEMP_FINAL
	(
		ClaseId varchar(30) collate database_default null,
		ClaseNom varchar(80) collate database_default null,
		FechaIniPe smalldatetime null,
		VCPUnitIni numeric(19,10) null,
		FechaCiePe smalldatetime null,
		VCPUnitCie numeric(19,10) null,
		UtilxCP numeric(22,8) null,
		MontoTotDist numeric(19,2) null,
		PorcDist numeric(12,8) null,
		FechaCorte smalldatetime null,
		FechaPago smalldatetime null
	)

	insert into #TEMP_FINAL (ClaseId,ClaseNom,FechaIniPe,VCPUnitIni,FechaCiePe,VCPUnitCie,UtilxCP,MontoTotDist,PorcDist,FechaCorte,FechaPago)
	select 
		ISNULL(TPVALORESCP.CodCAFCI, '') AS ClaseId,
		dbo.fnSacarCaracteresEspXML(ISNULL(TPVALORESCP.Descripcion, '')) as ClaseNom,
		
		coalesce(DIVIDENDOSFDO.FechaBase,TPVALORESCP.FechaInicio) as FechaIniPe,
		
		(select VCP.ValorCuotaparte from VALORESCP VCP where VCP.Fecha = coalesce(DIVIDENDOSFDO.FechaBase,TPVALORESCP.FechaInicio) and VCP.CodFondo = VALORESCP.CodFondo and VCP.CodTpValorCp = VALORESCP.CodTpValorCp ) as VCPUnitIni,
		DIVIDENDOSFDO.FechaCorte AS FechaCiePe ,
		(select VCP.ValorCuotaparte from VALORESCP VCP where VCP.Fecha = DIVIDENDOSFDO.FechaCorte and VCP.CodFondo = VALORESCP.CodFondo and VCP.CodTpValorCp = VALORESCP.CodTpValorCp ) as VCPUnitCie,
		VALORESCP.ValorCuotaparteDividendo AS UtilxCP,
		VALORESCP.ImporteDividendo AS MontoTotDist,
		DIVIDENDOSFDO.PorcDividendo AS PorcDist,
		DIVIDENDOSFDO.FechaCorte AS FechaCorte,
		DIVIDENDOSFDO.FechaPago AS FechaPago
	from DIVIDENDOSFDO 
		inner join FONDOSREAL on FONDOSREAL.CodFondo = DIVIDENDOSFDO .CodFondo 
		inner JOIN TPVALORESCP on TPVALORESCP.CodFondo = FONDOSREAL.CodFondo 
			and TPVALORESCP.CodTpValorCp = DIVIDENDOSFDO.CodTpValorCp 
		INNER JOIN VALORESCP on VALORESCP.CodFondo = DIVIDENDOSFDO.CodFondo
			AND VALORESCP.CodTpValorCp = DIVIDENDOSFDO.CodTpValorCp
			and VALORESCP.Fecha = DIVIDENDOSFDO.FechaCalculo 
	where DIVIDENDOSFDO.CodFondo = @CodFondo 
		and DIVIDENDOSFDO.FechaPago = @FechaProceso 
		and DIVIDENDOSFDO.EstaAnulado = 0
	
	
	
	if (select COUNT(*) from #TEMP_FINAL) > 0 begin		
		insert into #CAFCIUNIFICADA_Tag_DistUtil (CampoXml)
		select '<TDistUtils>'
				
		insert into #CAFCIUNIFICADA_Tag_DistUtil (CampoXml)
		select	'<TDistUtil>' +
				'<ClaseNom>' + CONVERT(VARCHAR,coalesce(ClaseId,'')) + '</ClaseNom>' +
				'<ClaseId>' + CONVERT(VARCHAR,coalesce(ClaseNom,'')) + '</ClaseId>' +
				'<FechaIniPe>' + CONVERT(VARCHAR(10),FechaIniPe, 120) + '</FechaIniPe>' +
				'<VCPUnitIni>' + CONVERT(VARCHAR,VCPUnitIni) + '</VCPUnitIni>' +
				'<FechaCiePe>' + CONVERT(VARCHAR(10),FechaCiePe, 120) + '</FechaCiePe>' +
				'<VCPUnitCie>' + CONVERT(VARCHAR,VCPUnitCie) + '</VCPUnitCie>' +
				'<UtilxCP>' + CONVERT(VARCHAR,UtilxCP) + '</UtilxCP>' +
				'<MontoTotDist>' + CONVERT(VARCHAR,MontoTotDist) + '</MontoTotDist>' +
				case when coalesce(CONVERT(VARCHAR,PorcDist),'') = '' then '<PorcDist/>' else '<PorcDist>' + coalesce(CONVERT(VARCHAR,PorcDist),'') + '</PorcDist>' end +
				'<FechaCorte>' + CONVERT(VARCHAR(10),FechaCorte, 120) + '</FechaCorte>' +
				'<FechaPago>' + CONVERT(VARCHAR(10),FechaPago, 120) + '</FechaPago>' +
				'</TDistUtil>'
		FROM #TEMP_FINAL

		insert into #CAFCIUNIFICADA_Tag_DistUtil (CampoXml)
		select '</TDistUtils>'
	END	

go

--Select * from FONDOSREAL
--EXEC dbo.spGDIN_IntefazCAFCI796 5,'20170823', 1,-1,-1,0

exec sp_CreateProcedure 'dbo.spGDIN_IntefazCAFCI796'
go
alter procedure dbo.spGDIN_IntefazCAFCI796
    @CodFondo CodigoMedio,
	@FechaProceso smalldatetime,
	@CodUsuario CodigoMedio,
	@Diaria Boolean,
	@Semanal Boolean,
	@Mensual Boolean
with encryption 
as

	/* creo las temporales que va a utilizar la interfaz de la cafci */
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#TEMP_CAFCIUNIFICADA'))
		DROP TABLE #TEMP_CAFCIUNIFICADA

	create table #TEMP_CAFCIUNIFICADA
	(
		CodFondo numeric(5) not null
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_TPCAMBIO'))
		DROP TABLE #CAFCIUNIFICADA_TPCAMBIO

	create table #CAFCIUNIFICADA_TPCAMBIO
	(
		TipoDeCambioCod varchar(1) collate database_default  not null ,
		CodMonedaOrigen numeric(5) not null,
		CambioOrigen numeric(19,10) null,
		CodMonedaDestino numeric(5) not null,
		CambioDestino numeric(19,10) null,
		CambioMax numeric(19,10) null,
		FactorCambio numeric(19,10) null
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#TEMP_ACTIVOS'))
		DROP TABLE #TEMP_ACTIVOS

	create table #TEMP_ACTIVOS
	(
		IdTabla numeric(10) identity (1,1),
		CodFondo numeric(5),
		CodEspecie numeric(5),
		CodPapel varchar(2) collate database_default,
		CodSerie numeric(5),
        CodOperacion numeric(10),
        CodTpOperacion varchar(6) collate database_default,
		Nro numeric(5),
		Cl varchar(80) collate database_default,
		SCl varchar(80) collate database_default,
		EntENom varchar(80) collate database_default,
		EntONom varchar(80) collate database_default,
		ActNom varchar(80) collate database_default,
		ActTTic varchar(2) collate database_default,
		ActTic varchar(80) collate database_default,
		MerNom varchar(80) collate database_default,
		MerTCod varchar(1) collate database_default,
		MerCod varchar(80) collate database_default,
		MonActNom varchar(80) collate database_default,
		MonActTCod varchar(1) collate database_default,
		MonActCod varchar(80) collate database_default,
		Pre numeric(22,10),
		Cant numeric(20,8),
		CantCot numeric(20,8),
		TCCod varchar(1) collate database_default,
		MtoMAct numeric(22,2),
		MtoMFdo numeric(19,2),
		FeOr  smalldatetime,
		FeVto  smalldatetime,
		MtoAc numeric(19,2),
		Plazo numeric(5),
		TNA numeric(22,10),
		TTasa varchar(1) collate database_default,
		PFTra varchar(1) collate database_default,
		PFPre varchar(1) collate database_default,
		TDFDev smalldatetime,
		PFPreF smalldatetime,
		PFPreInm varchar(1) collate database_default,
		DOFEj smalldatetime,
		DOPEj numeric(20,4),
		DOSub varchar(255) collate database_default,
		ML varchar(1) collate database_default,
		ClId numeric(10),
		AA varchar(1) collate database_default,
		CodImpAct varchar(30) collate database_default,
		NomClImp varchar(80) collate database_default,
		NomSClImp varchar(300) collate database_default,
		NomImpAct varchar(300) collate database_default,
		PaisNomEmi varchar(80) collate database_default,
		PaisNomEmiTCod varchar(80) collate database_default,
		PaisNomEmiCod varchar(80) collate database_default,
		PaisNomNeg varchar(80) collate database_default,
		PaisNomNegTCod varchar(80) collate database_default,
		PaisNomNegCod varchar(80) collate database_default,
		CtaCteRem varchar(80) collate database_default,
		ASNom varchar(80) collate database_default,
		ASTic varchar(80) collate database_default,
		ASTTic varchar(80) collate database_default,
		CodTpActivoAfipIt numeric(9),
		IntDevCtasVista numeric(19,2),
		IntDevCtasVistaCap numeric(19,2),
		OrigenActivo varchar(300) collate database_default,
		FechaGeneral smalldatetime,
		CampoEntidades text,
		CampoFechas text,
		CampoTickers text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA'))
		DROP TABLE #CAFCIUNIFICADA

	create table #CAFCIUNIFICADA
	(
		IdTabla numeric(10) not null identity(1,1),
		CampoXml text		
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_Id'))
		DROP TABLE #CAFCIUNIFICADA_Tag_Id

	create table #CAFCIUNIFICADA_Tag_Id
	(
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_Diario'))
		DROP TABLE #CAFCIUNIFICADA_Tag_Diario

	create table #CAFCIUNIFICADA_Tag_Diario
	(
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_TCambio'))
		DROP TABLE #CAFCIUNIFICADA_Tag_TCambio

	create table #CAFCIUNIFICADA_Tag_TCambio
	(
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_Duration'))
		DROP TABLE #CAFCIUNIFICADA_Tag_Duration

	create table #CAFCIUNIFICADA_Tag_Duration
	(
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_CalcCP'))
		DROP TABLE #CAFCIUNIFICADA_Tag_CalcCP

	create table #CAFCIUNIFICADA_Tag_CalcCP
	(
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_Inversor'))
		DROP TABLE #CAFCIUNIFICADA_Tag_Inversor

	create table #CAFCIUNIFICADA_Tag_Inversor
	(
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_ResidenciaInversores'))
		DROP TABLE #CAFCIUNIFICADA_Tag_ResidenciaInversores

	create table #CAFCIUNIFICADA_Tag_ResidenciaInversores
	(
		CampoXml text
	)
	
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_HonCom'))
		DROP TABLE #CAFCIUNIFICADA_Tag_HonCom

	create table #CAFCIUNIFICADA_Tag_HonCom
	(
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_Calif'))
		DROP TABLE #CAFCIUNIFICADA_Tag_Calif

	create table #CAFCIUNIFICADA_Tag_Calif
	(
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_DistUtil'))
		DROP TABLE #CAFCIUNIFICADA_Tag_DistUtil

	create table #CAFCIUNIFICADA_Tag_DistUtil
	(
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_Activo'))
		DROP TABLE #CAFCIUNIFICADA_Tag_Activo

	create table #CAFCIUNIFICADA_Tag_Activo
	(
		Id numeric(10) identity (1,1),
		CampoXml text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_Activo_Entidades'))
		DROP TABLE #CAFCIUNIFICADA_Tag_Activo_Entidades

	create table #CAFCIUNIFICADA_Tag_Activo_Entidades
	(
		IdTabla numeric(10),
		CampoEntidades text
	)

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_Activo_Fechas'))
		DROP TABLE #CAFCIUNIFICADA_Tag_Activo_Fechas

	create table #CAFCIUNIFICADA_Tag_Activo_Fechas
	(
		IdTabla numeric(10),
		CampoFechas text,
		Prioridad numeric(5)
	)
	
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#CAFCIUNIFICADA_Tag_Activo_Tickers'))
		DROP TABLE #CAFCIUNIFICADA_Tag_Activo_Tickers

	create table #CAFCIUNIFICADA_Tag_Activo_Tickers
	(
		IdTabla numeric(10),
		CampoTickers text,
		Prioridad numeric(5)
	)

	/*---------------------------------------------------------------*/
	
	/* proceso la Interfaz */
	insert into #TEMP_CAFCIUNIFICADA (CodFondo)
	select FONDOS.CodFondo
	from SOCIEDADESGTE
	INNER JOIN FONDOS ON FONDOS.CodSociedadGte = SOCIEDADESGTE.CodSociedadGte
	INNER JOIN FONDOSUSER ON FONDOSUSER.CodFondo = FONDOS.CodFondo AND FONDOSUSER.CodUsuario = @CodUsuario
	INNER JOIN MONEDAS ON MONEDAS.CodMoneda = FONDOS.CodMoneda
	INNER JOIN FONDOSREAL ON FONDOSREAL.CodFondo = FONDOS.CodFondo
	where FONDOSREAL.CodFondo = @CodFondo 
	
	-- LLAMO A VPCFISCAL
	exec dbo.spProcVCPFiscal @CodFondo, @FechaProceso, @FechaProceso

	--print 'spGDIN_CAFCIUnificada_Tag_Id ' + convert(varchar,getdate(),108)
	exec dbo.spGDIN_CAFCI796_Tag_Id @CodFondo, @FechaProceso, @CodUsuario

	if @Diaria = -1 begin
		--print 'spGDIN_CAFCIUnificada_Tag_Diario ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Diario @CodFondo, @FechaProceso, @CodUsuario
	end

	--print 'spGDIN_CAFCIUnificada_Tag_TCambio ' + convert(varchar,getdate(),108)
	exec dbo.spGDIN_CAFCI796_Tag_TCambio @CodFondo, @FechaProceso, @CodUsuario	
	
	if @Semanal = -1 begin		
		--print 'spGDIN_CAFCIUnificada_Tag_Activo_Especie ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Activo_Especie @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_Activo_Lete ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Activo_Lete @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_Activo_Serie ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Activo_Serie @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_Activo_PF ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Activo_PF @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_Activo_APC ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Activo_APC @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_Activo_CtaBancaria ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Activo_CtaBancaria @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_Activo_Futuro ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Activo_Futuro @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_Activo_ChequeDif ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Activo_ChequeDif @CodFondo, @FechaProceso, @CodUsuario
		
		--print 'insert into #CAFCIUNIFICADA_Tag_Activo (CampoXml) ' + convert(varchar,getdate(),108)
		declare @MaxIdTabla numeric(10)
		declare @MinIdTabla numeric(10)

		select @MaxIdTabla = max(IdTabla) from #TEMP_ACTIVOS
		select @MinIdTabla = min(IdTabla) from #TEMP_ACTIVOS

		--select * from #TEMP_ACTIVOS WHERE ActTic LIKE 'CHGGARA00034'

		--select @MinIdTabla = 10001
		--select @MaxIdTabla = 20000

		/**/
		--SELECT * fROM #TEMP_ACTIVOS
		--SELECT * fROM FONDOSREAL
		--EXEC dbo.spGDIN_IntefazCAFCI796 5,'20190731', 1,-1,-1,0
		--EXEC dbo.spGDIN_IntefazCAFCI796 1,'20190712', 1,-1,-1,0
		--select * from #TEMP_ACTIVOS where OrigenActivo like 'CHEQUEDIF'
		--select * from #CAFCIUNIFICADA_Tag_Activo_Tickers
		while @MinIdTabla <= @MaxIdTabla
		begin
			if exists (select * from #TEMP_ACTIVOS where IdTabla = @MinIdTabla)
			begin
				print 'IdTabla: ' +  convert(varchar,@MinIdTabla)


				insert into #CAFCIUNIFICADA_Tag_Activo (CampoXml)
					select '<Activo>' 

				insert into #CAFCIUNIFICADA_Tag_Activo (CampoXml)
					select 
						--'<Activo>' +
						case when coalesce(convert(varchar,IdTabla),'') = '' then '<Nro/>' else '<Nro>'+ convert(varchar,IdTabla) + '</Nro>' end +
						case when coalesce(convert(varchar,AA),'') = '' then '<AA/>' else '<AA>' + convert(varchar,coalesce(AA,'')) + '</AA>' end +
						case when coalesce(convert(varchar,Cl),'') = '' then '<Cl/>' else '<Cl>' + convert(varchar,coalesce(Cl,'')) + '</Cl>' end + --'<Cl></Cl>' +--
						case when coalesce(convert(varchar,''),'') = '' then '<ClId/>' else '<ClId>' + convert(varchar,coalesce(ClId,'')) + '</ClId>' end +--'<ClId></ClId>' +--
						case when coalesce(convert(varchar,SCl),'') = '' then '<SCl/>' else '<SCl>' + convert(varchar,coalesce(SCl,'')) + '</SCl>' end +--'<SCl></SCl>' +--
						'<SClId/>'+--ACA ENVIAR DATOS
						'<ClCnv/>'+
						'<ClCnvId/>'+
						'<SClCnv/>'+
						'<SClCnvId/>'+--ACA ENVIAR DATOS
						--case when coalesce(convert(varchar,EntENom),'') = '' then '<EntENom/>' else '<EntENom>' + convert(varchar,coalesce(EntENom,'')) + '</EntENom>' end +
						--case when coalesce(convert(varchar,EntONom),'') = '' then '<EntONom/>' else '<EntONom>' + convert(varchar,coalesce(EntONom,'')) + '</EntONom>' end +
						case when coalesce(convert(varchar,ActNom),'') = '' then '<ActNom/>' else '<ActNom>' + convert(varchar,coalesce(ActNom,'')) + '</ActNom>' end +
						'<ActNomLa/>'+--ACA ENVIAR DATOS
						case when coalesce(convert(varchar,CodImpAct),'') = '' then '<CodImpAct/>' else '<CodImpAct>' + convert(varchar,coalesce(CodImpAct,'')) + '</CodImpAct>' end +
						case when coalesce(convert(varchar,''),'') = '' then '<NomClImp/>' else '<NomClImp>' + convert(varchar,coalesce(NomClImp,'')) + '</NomClImp>' end +
						case when coalesce(convert(varchar,''),'') = '' then '<NomSClImp/>' else '<NomSClImp>' + convert(varchar,coalesce(NomSClImp,'')) + '</NomSClImp>' end +
						case when coalesce(convert(varchar,NomImpAct),'') = '' then '<NomImpAct/>' else '<NomImpAct>' + convert(varchar,coalesce(NomImpAct,'')) + '</NomImpAct>' end +
				
						case when coalesce(convert(varchar,PaisNomEmi),'') = '' then '<PaisNomEmi/>' else '<PaisNomEmi>' + convert(varchar,coalesce(PaisNomEmi,'')) + '</PaisNomEmi>' end +
						case when coalesce(convert(varchar,PaisNomEmiTCod),'') = '' then '<PaisNomEmiTCod/>' else '<PaisNomEmiTCod>' + convert(varchar,coalesce(PaisNomEmiTCod,'')) + '</PaisNomEmiTCod>' end +
						case when coalesce(convert(varchar,PaisNomEmiCod),'') = '' then '<PaisNomEmiCod/>' else '<PaisNomEmiCod>' + convert(varchar,coalesce(PaisNomEmiCod,'')) + '</PaisNomEmiCod>' end +
						case when coalesce(convert(varchar,PaisNomNeg),'') = '' then '<PaisNomNeg/>' else '<PaisNomNeg>' + convert(varchar,coalesce(PaisNomNeg,'')) + '</PaisNomNeg>' end +
						case when coalesce(convert(varchar,PaisNomNegTCod),'') = '' then '<PaisNomNegTCod/>' else '<PaisNomNegTCod>' + convert(varchar,coalesce(PaisNomNegTCod,'')) + '</PaisNomNegTCod>' end +
						case when coalesce(convert(varchar,PaisNomNegCod),'') = '' then '<PaisNomNegCod/>' else '<PaisNomNegCod>' + convert(varchar,coalesce(PaisNomNegCod,'')) + '</PaisNomNegCod>' end +

						--case when coalesce(convert(varchar,ActTTic),'') = '' then '<ActTTic/>' else '<ActTTic>' + convert(varchar,coalesce(ActTTic,'')) + '</ActTTic>' end +
						--case when coalesce(convert(varchar,ActTic),'') = '' then '<ActTic/>' else '<ActTic>' + convert(varchar,coalesce(ActTic,'')) + '</ActTic>' end +
						case when coalesce(convert(varchar,MonActNom),'') = '' then '<MonActNom/>' else '<MonActNom>' + convert(varchar,coalesce(MonActNom,'')) + '</MonActNom>' end +
						case when coalesce(convert(varchar,MonActTCod),'') = '' then '<MonActTCod/>' else '<MonActTCod>' + convert(varchar,coalesce(MonActTCod,'')) + '</MonActTCod>' end +
						case when coalesce(convert(varchar,MonActCod),'') = '' then '<MonActCod/>' else '<MonActCod>' + convert(varchar,coalesce(MonActCod,'')) + '</MonActCod>' end +
						'<Pitny/>'+
						'<RegPy/>'+
						case when coalesce(convert(varchar,MerNom),'') = '' then '<MerNom/>' else '<MerNom>' + convert(varchar,coalesce(MerNom,'')) + '</MerNom>' end +
						case when coalesce(convert(varchar,MerTCod),'') = '' then '<MerTCod/>' else '<MerTCod>' + convert(varchar,coalesce(MerTCod,'')) + '</MerTCod>' end +
						case when coalesce(convert(varchar,MerCod),'') = '' then '<MerCod/>' else '<MerCod>' + convert(varchar,coalesce(MerCod,'')) + '</MerCod>' end +
						'<Pre>' + convert(varchar,coalesce(convert(numeric(20,4),Pre),0)) + '</Pre>' +
						'<Cant>' + convert(varchar,coalesce(convert(numeric(20,8),Cant),0)) + '</Cant>' +
						'<CantCot>' + convert(varchar,coalesce(convert(numeric(20,8),CantCot),0)) + '</CantCot>' +
						case when coalesce(convert(varchar,TCCod),'') = '' then '<TCCod/>' else '<TCCod>' + convert(varchar,coalesce(TCCod,'')) + '</TCCod>' end +
						'<MtoMAct>' + convert(varchar,coalesce(convert(numeric(20,2),MtoMAct),0)) + '</MtoMAct>' +
						'<MtoMFdo>' + convert(varchar,coalesce(convert(numeric(20,2),MtoMFdo),0)) + '</MtoMFdo>' +
			
						--case when coalesce(FeOr,'')='1900-01-01 00:00:00' then '<FeOr/>' else '<FeOr>' + convert(varchar(10),FeOr,120) + '</FeOr>' end  +
						--case when coalesce(FeVto,'')='1900-01-01 00:00:00' then '<FeVto/>' else '<FeVto>' +  convert(varchar(10),FeVto,120) + '</FeVto>' end  +
						case when coalesce(convert(numeric(20,2),MtoAc),0) = 0 then '<MtoAc/>' else '<MtoAc>' + convert(varchar,coalesce(MtoAc,0)) + '</MtoAc>' end +
						'<Plazo>' + convert(varchar,coalesce(Plazo,0)) + '</Plazo>' +
						case when coalesce(TNA,0) = 0 then '<TNA/>' else '<TNA>' + convert(varchar,coalesce(convert(numeric(10,4),TNA),0)) + '</TNA>' end  +		
						case when coalesce(convert(varchar,TTasa),'') = '' then '<TTasa/>' else '<TTasa>' + convert(varchar,coalesce(TTasa,'')) + '</TTasa>' end +
						case when coalesce(convert(varchar,PFTra),'') = '' then '<PFTra/>' else '<PFTra>' + convert(varchar,coalesce(PFTra,'')) + '</PFTra>' end +
						case when coalesce(convert(varchar,PFPre),'') = '' then '<PFPre/>' else '<PFPre>' + convert(varchar,coalesce(PFPre,'')) + '</PFPre>' end +
						case when coalesce(convert(varchar,PFPreInm),'') = '' then '<PFPreInm/>' else '<PFPreInm>' + convert(varchar,coalesce(PFPreInm,'')) + '</PFPreInm>' end +

						case when coalesce(convert(varchar,CtaCteRem),'') = '' then '<CtaCteRem/>' else '<CtaCteRem>' + convert(varchar,coalesce(CtaCteRem,'')) + '</CtaCteRem>' end +
						'<ClaseTD/>'+
						'<TipoTD/>'+
						'<AmbitoTD/>'+
						'<MontoEmiTD/>'+
						'<Clasif/>'+
						case when coalesce(DOPEj,0) = 0 then '<DOPEj/>' else '<DOPEj>' + convert(varchar,coalesce(convert(numeric(20,4),DOPEj),0)) + '</DOPEj>' end  +
						case when coalesce(convert(varchar,DOSub),'') = '' then '<DOSub/>' else '<DOSub>' + dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(DOSub,''))) + '</DOSub>' end +
				
						case when coalesce(CtaCteRem,'') = '' then '<IntDevCtasVista/>' else '<IntDevCtasVista>' + convert(varchar,coalesce(convert(numeric(19,2),IntDevCtasVista),0)) + '</IntDevCtasVista>' end +				
						case when coalesce(CtaCteRem,'') = '' then '<IntDevCtasVistaCap/>' else '<IntDevCtasVistaCap>' + convert(varchar,coalesce(convert(numeric(19,2),IntDevCtasVistaCap),0)) + '</IntDevCtasVistaCap>' end + 
				
						case when coalesce(convert(varchar,ASNom),'') = '' then '<ASNom/>' else '<ASNom>' + convert(varchar,coalesce(ASNom,'')) + '</ASNom>' end +
						case when coalesce(convert(varchar,ASTic),'') = '' then '<ASTic/>' else '<ASTic>' + convert(varchar,coalesce(ASTic,'')) + '</ASTic>' end +
						case when coalesce(convert(varchar,ASTTic),'') = '' then '<ASTTic/>' else '<ASTTic>' + convert(varchar,coalesce(ASTTic,'')) + '</ASTTic>' end +
				
						'<ASCant/>'+
						'<ASCantRDD/>'+
						case when coalesce(convert(varchar,ML),'') = '' then '<ML/>' else '<ML>' + convert(varchar,coalesce(ML,'')) + '</ML>' end
				
						--case when coalesce(TDFDev,'')='1900-01-01 00:00:00' then '<TDFDev/>' else '<TDFDev>' + convert(varchar(10),TDFDev,120) + '</TDFDev>' end  +
						--case when coalesce(PFPreF,'')='1900-01-01 00:00:00' then '<PFPreF/>' else '<PFPreF>' + convert(varchar(10),PFPreF,120) + '</PFPreF>' end  +			
						--case when coalesce(DOFEj,'')='1900-01-01 00:00:00' then '<DOFEj/>' else '<DOFEj>' +  convert(varchar(10),DOFEj,120) + '</DOFEj>' end  +
				
					from #TEMP_ACTIVOS
					where IdTabla = @MinIdTabla

				insert into #CAFCIUNIFICADA_Tag_Activo (CampoXml)
					select CampoEntidades
					from #CAFCIUNIFICADA_Tag_Activo_Entidades
					where IdTabla = @MinIdTabla

				insert into #CAFCIUNIFICADA_Tag_Activo (CampoXml)
					select CampoFechas
					from #CAFCIUNIFICADA_Tag_Activo_Fechas
					where IdTabla = @MinIdTabla
					order by Prioridad 

				insert into #CAFCIUNIFICADA_Tag_Activo (CampoXml)
					select CampoTickers
					from #CAFCIUNIFICADA_Tag_Activo_Tickers
					where IdTabla = @MinIdTabla
					order by Prioridad 

				insert into #CAFCIUNIFICADA_Tag_Activo (CampoXml)
					select '</Activo>'
					--from #TEMP_ACTIVOS
					--where IdTabla = @MinIdTabla
			end

			select @MinIdTabla = @MinIdTabla + 1
		end 		
		

		--print 'spGDIN_CAFCIUnificada_Tag_Duration ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Duration @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_CalcCP ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_CalcCP @CodFondo, @FechaProceso, @CodUsuario

		
	end
	
	
	if @Mensual = -1 begin
		--print 'spGDIN_CAFCIUnificada_Tag_Inversor ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Inversor @CodFondo, @FechaProceso, @CodUsuario	
		--print 'spGDIN_CAFCIUnificada_Tag_ResidenciaInversores ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_ResidenciaInversores @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_HonCom ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_HonCom @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_Calif ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_Calif @CodFondo, @FechaProceso, @CodUsuario
		--print 'spGDIN_CAFCIUnificada_Tag_DistUtil ' + convert(varchar,getdate(),108)
		exec dbo.spGDIN_CAFCI796_Tag_DistUtil @CodFondo, @FechaProceso, @CodUsuario
	end
	
	
	/*---------------------------------------------------------------*/

	/* Armo la consulta para devolver el archivo */
	
	insert into  #CAFCIUNIFICADA (CampoXml)
	select '<?xml version="1.0"?><Informacion>'
	insert into  #CAFCIUNIFICADA (CampoXml)
	select CampoXml from #CAFCIUNIFICADA_Tag_Id

	insert into  #CAFCIUNIFICADA (CampoXml)
	select CampoXml from #CAFCIUNIFICADA_Tag_TCambio

	if @Diaria = -1 begin
		
		insert into  #CAFCIUNIFICADA (CampoXml)
			select CampoXml from #CAFCIUNIFICADA_Tag_Diario
	end
	
	if @Semanal = -1 begin
		
		insert into  #CAFCIUNIFICADA (CampoXml)
			select '<CarterasInversiones>'		
		insert into  #CAFCIUNIFICADA (CampoXml)
			select '<Activos>'

		/**/
		--select CampoXml from #CAFCIUNIFICADA_Tag_Activo order by Id

		insert into  #CAFCIUNIFICADA (CampoXml)
			select CampoXml from #CAFCIUNIFICADA_Tag_Activo order by Id
		
		/* Si no se ha insertado ningun movimento de activos pongo el formato por default vacio*/

		if ((select count(*) from #CAFCIUNIFICADA_Tag_Activo)) = 0
		begin
			insert into  #CAFCIUNIFICADA (CampoXml)
			select  '<Activo>' +
				'<Nro/>' +
				'<AA/>' +
				'<Cl/>' + --'<Cl></Cl>' +--
				'<ClId/>' +--'<ClId></ClId>' +--
				'<SCl/>' +--'<SCl></SCl>' +--
				'<SClId/>'+--ACA ENVIAR DATOS
				'<ClCnv/>'+
				'<ClCnvId/>'+
				'<SClCnv/>'+
				'<SClCnvId/>'+--ACA ENVIAR DATOS
				'<ActNom/>' +
				'<ActNomLa/>'+--ACA ENVIAR DATOS
				'<CodImpAct/>'  +
				'<NomClImp/>' +
				'<NomSClImp/>' +
				'<NomImpAct/>' +
				'<PaisNomEmi/>' +
				'<PaisNomEmiTCod/>' +
				'<PaisNomEmiCod/>' +
				'<PaisNomNeg/>' +
				'<PaisNomNegTCod/>' +
				'<PaisNomNegCod/>' +
				'<MonActNom/>' +
				'<MonActTCod/>' +
				'<MonActCod/>' +
				'<Pitny/>'+
				'<RegPy/>'+
				'<MerNom/>' +
				'<MerTCod/>' +
				'<MerCod/>' +
				'<Pre/>' +
				'<Cant/>' +
				'<CantCot/>' +
				'<TCCod/>' +
				'<MtoMAct/>' +
				'<MtoMFdo/>' +
				'<MtoAc/>' +
				'<Plazo/>' +
				'<TNA/>' +		
				'<TTasa/>' +
				'<PFTra/>' +
				'<PFPre/>' +
				'<PFPreInm/>' +
				'<CtaCteRem/>' +
				'<ClaseTD/>'+
				'<TipoTD/>'+
				'<AmbitoTD/>'+
				'<MontoEmiTD/>'+
				'<Clasif/>'+
				'<DOPEj/>' +
				'<DOSub/>' +
				'<IntDevCtasVista/>'+
				'<IntDevCtasVistaCap/>'+
				'<ASNom/>' +
				'<ASTic/>' +
				'<ASTTic/>' +				
				'<ASCant/>'+
				'<ASCantRDD/>'+
				'<ML/>'
				

			insert into  #CAFCIUNIFICADA (CampoXml)
			select '<Entidades><Entidad>
					<TipoEntNom/>
					<TipoEntId/>
					<EntNom/>
					<EntTic/>
					<EntTTic/>
					<PaisNom/>
					<PaisTCod/>
					<PaisCod/>
					<ActNom/>
					<ActNomId/>
					</Entidad></Entidades>'
		
			insert into  #CAFCIUNIFICADA (CampoXml)
			select '<Fechas>
					<Fecha>
					<TipoFechaNom/>
					<FechaDato/>
					<TipoFechaId/>
					</Fecha>
				</Fechas>'
		
			insert into  #CAFCIUNIFICADA (CampoXml)
			select '<Tickers>
					<Ticker>
					<ActTicEnt/>
					<ActTic/>
					<ActTTicId/>
					<ActMonCotId/>
					<ActMerCotId/>
					</Ticker>
					</Tickers>'
		
			insert into  #CAFCIUNIFICADA (CampoXml)
			select '</Activo>'

		end

		
		insert into  #CAFCIUNIFICADA (CampoXml)
		select '</Activos>'
		
		declare @ActivoPrincipalCant numeric(5)
		declare @ActivoPrincipalSi numeric(5)
		declare @ActivoPrincipal75 numeric(5)
		declare @Resultado numeric(12,8)
		

		select @ActivoPrincipal75 = 75
		select @ActivoPrincipalCant = COUNT(*) from #TEMP_ACTIVOS 
			LEFT JOIN TPACTIVOAFIPIT 
				INNER JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
				ON TPACTIVOAFIPIT.CodTpActivoAfipIt = #TEMP_ACTIVOS.CodTpActivoAfipIt
		--where coalesce(TPACTIVOAFIP.ActivoPrincipal,0) = 0

		select @ActivoPrincipalSi = COUNT(*) from #TEMP_ACTIVOS 
			LEFT JOIN TPACTIVOAFIPIT 
				INNER JOIN TPACTIVOAFIP ON TPACTIVOAFIP.CodTpActivoAfip = TPACTIVOAFIPIT.CodTpActivoAfip 
				ON TPACTIVOAFIPIT.CodTpActivoAfipIt = #TEMP_ACTIVOS.CodTpActivoAfipIt
		where coalesce(TPACTIVOAFIP.ActivoPrincipal,0) = -1
		
		select @Resultado=(@ActivoPrincipalSi*@ActivoPrincipalCant)/100

		insert into #CAFCIUNIFICADA (CampoXml)
		select '<ActSubPpals>' +
				'<ActSubPpal>' + case when @Resultado>=@ActivoPrincipal75 then 'S' else 'N' end + '</ActSubPpal>' +
				'</ActSubPpals>'
		
		
		insert into  #CAFCIUNIFICADA (CampoXml)
			select CampoXml from #CAFCIUNIFICADA_Tag_Duration
		insert into  #CAFCIUNIFICADA (CampoXml)
			select CampoXml from #CAFCIUNIFICADA_Tag_CalcCP
		insert into  #CAFCIUNIFICADA (CampoXml)
			select '</CarterasInversiones>'	

	end 


	if @Mensual = -1 begin
		insert into  #CAFCIUNIFICADA (CampoXml)
			select '<InversoresComisiones>'	
		insert into  #CAFCIUNIFICADA (CampoXml)
			select CampoXml from #CAFCIUNIFICADA_Tag_Inversor
		insert into  #CAFCIUNIFICADA (CampoXml)
			select CampoXml from #CAFCIUNIFICADA_Tag_ResidenciaInversores
		insert into  #CAFCIUNIFICADA (CampoXml)
			select CampoXml from #CAFCIUNIFICADA_Tag_HonCom
		insert into  #CAFCIUNIFICADA (CampoXml)
			select CampoXml from #CAFCIUNIFICADA_Tag_Calif
		insert into  #CAFCIUNIFICADA (CampoXml)
			select '</InversoresComisiones>'	
		
	end

	insert into  #CAFCIUNIFICADA (CampoXml)
		select CampoXml from #CAFCIUNIFICADA_Tag_DistUtil
	insert into  #CAFCIUNIFICADA (CampoXml)
	select '</Informacion>'
	
	/*---------------------------------------------------------------*/

	
	/* Informacion necesaria para armar el archivo */
	--right(REPLICATE(' ', 4) + coalesce(convert(varchar(4),CodInterfazGte),''), 4)
	select	right(REPLICATE('0', 4) + coalesce(convert(varchar(4),SOCIEDADESGTE.CodCAFCI),''), 4) AS AAId,			
			right(REPLICATE('0', 4) + coalesce(convert(varchar(4),FONDOS.CodCAFCI),''), 4) AS FdoId,
			convert(varchar(10),@FechaProceso,112) FechaDatos
	from SOCIEDADESGTE
		INNER JOIN FONDOS ON FONDOS.CodSociedadGte = SOCIEDADESGTE.CodSociedadGte
		INNER JOIN FONDOSUSER ON FONDOSUSER.CodFondo = FONDOS.CodFondo AND FONDOSUSER.CodUsuario = @CodUsuario
		INNER JOIN MONEDAS ON MONEDAS.CodMoneda = FONDOS.CodMoneda
		INNER JOIN FONDOSREAL ON FONDOSREAL.CodFondo = FONDOS.CodFondo
	where FONDOSREAL.CodFondo = @CodFondo 

	/*---------------------------------------------------------------*/
	

	/* Devuelvo el archivo para que el front arme el XML */
	select CampoXml from #CAFCIUNIFICADA order by IdTabla 	

	/*---------------------------------------------------------------*/

	DROP TABLE #TEMP_CAFCIUNIFICADA
	DROP TABLE #CAFCIUNIFICADA_TPCAMBIO
	DROP TABLE #TEMP_ACTIVOS
	DROP TABLE #CAFCIUNIFICADA
	DROP TABLE #CAFCIUNIFICADA_Tag_Id
	DROP TABLE #CAFCIUNIFICADA_Tag_Diario	
	DROP TABLE #CAFCIUNIFICADA_Tag_TCambio	
	DROP TABLE #CAFCIUNIFICADA_Tag_Duration	
	DROP TABLE #CAFCIUNIFICADA_Tag_CalcCP
	DROP TABLE #CAFCIUNIFICADA_Tag_Inversor
	DROP TABLE #CAFCIUNIFICADA_Tag_ResidenciaInversores	
	DROP TABLE #CAFCIUNIFICADA_Tag_HonCom	
	DROP TABLE #CAFCIUNIFICADA_Tag_Calif	
	DROP TABLE #CAFCIUNIFICADA_Tag_DistUtil	
	DROP TABLE #CAFCIUNIFICADA_Tag_Activo	
	DROP TABLE #CAFCIUNIFICADA_Tag_Activo_Entidades
	DROP TABLE #CAFCIUNIFICADA_Tag_Activo_Fechas
	DROP TABLE #CAFCIUNIFICADA_Tag_Activo_Tickers	
	

GO


exec sp_CreateFn 'dbo.fnFechaOperaciones'
go

ALTER FUNCTION  dbo.fnFechaOperaciones
	(@CodEspecie CodigoLargo, @FechaProceso Fecha)
RETURNS DescripcionCorta
WITH ENCRYPTION
AS	
BEGIN
	DECLARE @OUTRET DescripcionCorta
	DECLARE @Fecha FechaLarga
	DECLARE @CodAuditoriaRef CodigoLargo
	DECLARE @ParamAA Boolean
	
	SELECT @ParamAA = ValorParametro FROM PARAMETROS WHERE CodParametro = 'HAA796'	/*Habilita alta de activo (AA - CAFCI 796)*/
	
	select @OUTRET = 'N'

	IF @ParamAA = -1
	BEGIN
		if @CodEspecie <> -1 
		begin 
			select @CodAuditoriaRef = CodAuditoriaRef from ESPECIES where CodEspecie= @CodEspecie
			select @Fecha = Fecha FROM AUDITORIASHIST WHERE CodAuditoriaRef = @CodAuditoriaRef and CodAccion = 'a'
	
			if @Fecha <= '20190731' begin
				SELECT @OUTRET = 'N'
			end
			else
			begin
				if (select count(*) from OPERBURSATILES WHERE CodEspecie = @CodEspecie and FechaConcertacion < @FechaProceso) > 0
				begin
					SELECT @OUTRET = 'N'
				end
				else
				begin
					SELECT @OUTRET = 'S'
				end		
			end
		end
	END

    RETURN @OUTRET
END
GO




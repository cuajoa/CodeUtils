IF EXISTS (SELECT name FROM tempdb..sysobjects where id = object_id('tempdb..#INTERFAZINVERSION'))
    DROP TABLE #INTERFAZINVERSION
GO

CREATE TABLE #INTERFAZINVERSION (
    CodFondo                   numeric(10),
    CodOperBursatil            numeric(15),
    CodOperFinanciera          numeric(15),
    CodPlazoFijo               numeric(15),
    FechaD                     datetime,
	FechaConcertacion          datetime,
	CodChequeDifCpa            numeric(10),
    CodChequeDifVta            numeric(10))
GO

EXEC sp_CreateProcedure 'dbo.spSInversiones_Insert'
GO

ALTER PROCEDURE dbo.spSInversiones_Insert
	@FechaConcertacion Fecha = null
WITH ENCRYPTION 
AS

	INSERT INTO #INTERFAZINVERSION (CodFondo, CodOperBursatil, FechaD, FechaConcertacion)
    SELECT OPERBURSATILES.CodFondo, OPERBURSATILES.CodOperBursatil, OPERBURSATILES.FechaD, @FechaConcertacion
    FROM OPERBURSATILES
    INNER JOIN FONDOS 
		INNER JOIN #INTERFAZINVERSION_FONDOS 
			ON #INTERFAZINVERSION_FONDOS.CodFondo = FONDOS.CodFondo
		ON FONDOS.CodFondo = OPERBURSATILES.CodFondo
    INNER JOIN MONEDAS 
		INNER JOIN #INTERFAZINVERSION_MONEDAS 
			ON #INTERFAZINVERSION_MONEDAS.CodMoneda = MONEDAS.CodMoneda
		ON MONEDAS.CodMoneda = OPERBURSATILES.CodMonedaOperacion
    INNER JOIN TPOPERACION 
		INNER JOIN #INTERFAZINVERSION_TPOPERACION
			ON #INTERFAZINVERSION_TPOPERACION.CodTpOperacion = TPOPERACION.CodTpOperacion
		ON TPOPERACION.CodTpOperacion = OPERBURSATILES.CodTpOperacion
    WHERE (OPERBURSATILES.FechaConcertacion = @FechaConcertacion OR @FechaConcertacion IS NULL)
    
    INSERT INTO #INTERFAZINVERSION (CodFondo, CodOperFinanciera, FechaD, FechaConcertacion)
    SELECT OPERFINANCIERAS.CodFondo, OPERFINANCIERAS.CodOperFinanciera, OPERFINANCIERAS.FechaD, @FechaConcertacion
    FROM OPERFINANCIERAS
    INNER JOIN FONDOS 
		INNER JOIN #INTERFAZINVERSION_FONDOS 
			ON #INTERFAZINVERSION_FONDOS.CodFondo = FONDOS.CodFondo
		ON FONDOS.CodFondo = OPERFINANCIERAS.CodFondo
    INNER JOIN MONEDAS 
		INNER JOIN #INTERFAZINVERSION_MONEDAS 
			ON #INTERFAZINVERSION_MONEDAS.CodMoneda = MONEDAS.CodMoneda
		ON MONEDAS.CodMoneda = OPERFINANCIERAS.CodMoneda
    INNER JOIN TPOPERACION 
		INNER JOIN #INTERFAZINVERSION_TPOPERACION
			ON #INTERFAZINVERSION_TPOPERACION.CodTpOperacion = TPOPERACION.CodTpOperacion
		ON TPOPERACION.CodTpOperacion = OPERFINANCIERAS.CodTpOperacion
    WHERE (OPERFINANCIERAS.FechaConcertacion = @FechaConcertacion OR @FechaConcertacion IS NULL)
	    
    INSERT  INTO #INTERFAZINVERSION (CodFondo, CodPlazoFijo, FechaConcertacion)
    SELECT  PLAZOSFIJOS.CodFondo, PLAZOSFIJOS.CodPlazoFijo, @FechaConcertacion
    FROM PLAZOSFIJOS
    INNER JOIN FONDOS 
		INNER JOIN #INTERFAZINVERSION_FONDOS 
			ON #INTERFAZINVERSION_FONDOS.CodFondo = FONDOS.CodFondo
		ON FONDOS.CodFondo = PLAZOSFIJOS.CodFondo
    INNER JOIN MONEDAS 
		INNER JOIN #INTERFAZINVERSION_MONEDAS 
			ON #INTERFAZINVERSION_MONEDAS.CodMoneda = MONEDAS.CodMoneda
		ON MONEDAS.CodMoneda = PLAZOSFIJOS.CodMoneda
    INNER JOIN TPOPERACION 
		INNER JOIN #INTERFAZINVERSION_TPOPERACION
			ON #INTERFAZINVERSION_TPOPERACION.CodTpOperacion = TPOPERACION.CodTpOperacion
		ON TPOPERACION.CodTpOperacion = PLAZOSFIJOS.CodTpOperacion
	WHERE (PLAZOSFIJOS.FechaConcertacion = @FechaConcertacion OR @FechaConcertacion IS NULL)

	INSERT  INTO #INTERFAZINVERSION (CodFondo, CodChequeDifCpa, FechaConcertacion)
    SELECT  CHEQUESDIFCOMPRA.CodFondo, CHEQUESDIFCOMPRA.CodChequeDifCpa, @FechaConcertacion
    FROM CHEQUESDIFCOMPRA
    INNER JOIN FONDOS 
		INNER JOIN #INTERFAZINVERSION_FONDOS 
			ON #INTERFAZINVERSION_FONDOS.CodFondo = FONDOS.CodFondo
		ON FONDOS.CodFondo = CHEQUESDIFCOMPRA.CodFondo
	WHERE (CHEQUESDIFCOMPRA.FechaConcertacion = @FechaConcertacion OR @FechaConcertacion IS NULL)
		and 'C' in (select #INTERFAZINVERSION_TPOPERACION.CodTpOperacion from #INTERFAZINVERSION_TPOPERACION)

	INSERT  INTO #INTERFAZINVERSION (CodFondo, CodChequeDifVta, CodChequeDifCpa, FechaConcertacion)
    SELECT  CHEQUESDIFVENTA.CodFondo, CHEQUESDIFVENTA.CodChequeDifVta, CHEQUESDIFVENTA.CodChequeDifCpa, @FechaConcertacion
    FROM CHEQUESDIFVENTA
    INNER JOIN FONDOS 
		INNER JOIN #INTERFAZINVERSION_FONDOS 
			ON #INTERFAZINVERSION_FONDOS.CodFondo = FONDOS.CodFondo
		ON FONDOS.CodFondo = CHEQUESDIFVENTA.CodFondo
	WHERE (CHEQUESDIFVENTA.FechaConcertacion = @FechaConcertacion OR @FechaConcertacion IS NULL)
		and 'V' in (select #INTERFAZINVERSION_TPOPERACION.CodTpOperacion from #INTERFAZINVERSION_TPOPERACION)

go


EXEC sp_CreateProcedure 'dbo.spSInversiones'
GO

ALTER PROCEDURE dbo.spSInversiones
	@ExpresionSocDepositaria TextoCorto = NULL

WITH ENCRYPTION 
AS

	create table #SOCDESPOSITARIA
		(CodAgColocador Numeric(10),
		CodInterfaz Varchar(30) COLLATE DATABASE_DEFAULT)

	DECLARE @ssql nvarchar(2000)
	set @ssql = 'INSERT #SOCDESPOSITARIA (CodAgColocador, CodInterfaz) SELECT CodAgColocador, CodInterfaz from AGCOLOCADORES '
	if not @ExpresionSocDepositaria is null
	begin
		set @ExpresionSocDepositaria = REPLACE (@ExpresionSocDepositaria, 'CodAgColocador', 'Descripcion')
		set @ssql = @ssql  + @ExpresionSocDepositaria
	end
	exec sp_executesql @ssql 
    
	create table #FONDOS_sInversiones
		(CodFondo Numeric(10)
		,NRCNV	Varchar(10)COLLATE DATABASE_DEFAULT
		, CodAgColocadorDep Numeric(10)
		, CodInterfaz Varchar(30) COLLATE DATABASE_DEFAULT
		, CodInterfazDep Varchar(30) COLLATE DATABASE_DEFAULT)

	INSERT #FONDOS_sInversiones
		(CodFondo
		,NRCNV	
		,CodAgColocadorDep 
		,CodInterfaz
		,CodInterfazDep)
	SELECT FONDOSREAL.CodFondo
		,case when floor(coalesce(FONDOSPARAM.ValorNumero,0)) <> 0
			then convert(varchar,floor(FONDOSPARAM.ValorNumero)) 
			else ''
			end 
			,FONDOSREAL.CodAgColocadorDep
		,FONDOSREAL.CodInterfaz
		,#SOCDESPOSITARIA.CodInterfaz
	FROM FONDOSREAL
	INNER JOIN FONDOSPARAM ON FONDOSPARAM.CodFondo = FONDOSREAL.CodFondo 
		and FONDOSPARAM.CodParametroFdo = 'NRCNV'
	inner JOIN #SOCDESPOSITARIA ON #SOCDESPOSITARIA.CodAgColocador = FONDOSREAL.CodAgColocadorDep

	
	/*******************************************************************/
    --Boletos
    /*******************************************************************/
	SELECT  'INV' AS InterfazItId,
            dbo.fnAuditoriaHistAccion(OPERBURSATILES.CodAuditoriaRef,-1) AS Accion,
            OPERBURSATILES.FechaConcertacion AS FechaConcertacion,
            OPERBURSATILES.FechaLiquidacion AS FechaLiquidacion,
            OPERBURSATILES.FechaLiquidacion AS FechaContraEspecie,
            TPOPERACION.Descripcion AS CodTpOperacionId,
            CASE WHEN TPOPERACION.EsDebito = -1 THEN 'D' ELSE 'C' END AS DebitoCredito,
            convert(varchar(20), OPERBURSATILES.NumeroOperacionBursatil) AS NumOperacion,
            #FONDOS_sInversiones.CodInterfaz AS CodFondoId,
            AGENTES.CodInterfaz AS CodAgenteId,
            case when upper(DEPOSITARIOS.Descripcion) like 'ROFEX%' then 'RX1' ELSE DEPOSITARIOS.CodInterfaz END AS CodDepositarioId,
			CASE WHEN TPESPECIE.CodTpPapel in ('FU') then  
					(SELECT TOP 1 Descripcion from ABREVIATURASESP WHERE  ABREVIATURASESP.CodTpAbreviatura = 'FU' 
						and ABREVIATURASESP.CodEspecie = OPERBURSATILES.CodEspecie AND ABREVIATURASESP.EstaAnulado = 0)
				else
				 ESPECIES.CodInterfaz 
				 end AS CodEspecieId,
            ESPECIES.IsinCode,
            MONEDAS.CodInterfaz AS CodMonedaId,
           convert(numeric(28,10),(CASE WHEN OPERBURSATILES.CodSerie IS NOT NULL
                 THEN OPERBURSATILESITTEMP.Cantidad * SERIES.AccionesPorLote
                 ELSE OPERBURSATILESITTEMP.Cantidad
            END)) AS ValorNominal,
           (CASE WHEN TPOPERACION.EsDebito = -1
                 THEN convert(numeric(19,2) ,(convert(numeric(28,10), OPERBURSATILES.Bruto) 
                        - ( ISNULL(convert(numeric(28,10), OPERBURSATILES.Arancel),0.00) + 
                            ISNULL(convert(numeric(28,10), OPERBURSATILES.Impuesto) ,0.00) + 
                            ISNULL(convert(numeric(28,10), OPERBURSATILES.DerechoBolsa) ,0.00) + 
                            ISNULL(convert(numeric(28,10), OPERBURSATILES.DerechoMercado) ,0.00) + 
                            ISNULL(convert(numeric(28,10), OPERBURSATILES.GastosSEC) ,0.00) )) * convert(numeric(28,10), OPERBURSATILES.FactConvMonCargaOperacion))
                 ELSE convert(numeric(19,2) ,( convert(numeric(28,10), OPERBURSATILES.Bruto)
                        + ( ISNULL(convert(numeric(28,10), OPERBURSATILES.Arancel),0.00) + 
                            ISNULL(convert(numeric(28,10), OPERBURSATILES.Impuesto) ,0.00) + 
                            ISNULL(convert(numeric(28,10), OPERBURSATILES.DerechoBolsa) ,0.00) + 
                            ISNULL(convert(numeric(28,10), OPERBURSATILES.DerechoMercado) ,0.00) + 
                            ISNULL(convert(numeric(28,10), OPERBURSATILES.GastosSEC) ,0.00) )) * convert(numeric(28,10), OPERBURSATILES.FactConvMonCargaOperacion)) 
            END) AS ImporteNeto,
            0 AS Tasa,
            NULL AS NumOperacionRef,
			OPERBURSATILES.CodAuditoriaRef AS CodAuditoriaRef,
			#FONDOS_sInversiones.NRCNV as FondoBancoValoresId,
			AGENTES.NumeroAgente as NumAgente,
			coalesce(MONEDASGASTOS.CodCAFCI,'') as MonedaGastoId,
			(OPERBURSATILES.Arancel+OPERBURSATILES.DerechoMercado+OPERBURSATILES.DerechoBolsa+OPERBURSATILES.Impuesto+OPERBURSATILES.GastosSEC) as ImporteGastos,
			OPERBURSATILES.Bruto as ImporteBruto,
			
				case when TPESPECIE.CodTpPapel in ('FI') then
					ESPECIES.CodCAFCI
				else
					case when ESPECIES.NumEspecieCV is null then 
					''
					else convert(varchar,ESPECIES.NumEspecieCV) end
			
			end as CodCajaValoresCAFCI,
			0 as EsTransferible,
			0 as EsPrecancelable,
			case when ENTLIQUIDACION.CodInterfaz LIKE 'SENEBI' OR ENTLIQUIDACION.CodInterfaz LIKE 'GARA' OR ENTLIQUIDACION.CodInterfaz LIKE 'BYMA' OR ENTLIQUIDACION.CodInterfaz LIKE 'EP' OR ENTLIQUIDACION.CodInterfaz LIKE 'CV' OR ENTLIQUIDACION.CodInterfaz LIKE 'MAE CLEAR' THEN
				'CJ2'
			ELSE
				 coalesce(ENTLIQUIDACION.CodInterfaz,'') 
			END as EntidadLiquidacion,
			coalesce(AGENTESAGCOLOCADORESREL.CodInterfaz,'') as CodAgenteCustodiaId,
			DEPOSITARIOS.CodInterfazAgCus as CodInterfazDepAdicional, 
			MONEDAS.CodCAFCI as CodCAFCIMonedaConc, 
			MONEDASGASTOS.CodCAFCI as CodCAFCIMonedaGas, 
			MERCADOS.CodCAFCI as CodCAFCIMercado,
			'' as AbrevChequePagare, 
			ESPECIES.FechaVencimiento as FechaVencimiento,
			NULL as CodAuditoriaOperRel,
			TPOPERACION.CodTpOperacion as CodTpOperacion,
			AGENTESAGCOLOCADORESREL.CodInterfaz as CodInterfazAgCus, 
			dbo.fnAuditoriaFechaAlta(OPERBURSATILES.CodAuditoriaRef, 'OPERBURS'+lower(dbo.fnAuditoriaHistAccion(OPERBURSATILES.CodAuditoriaRef,0))) as FechaAlta, --FechaAlta
			dbo.fnAuditoriaFechaAlta(OPERBURSATILES.CodAuditoriaRef, 'OPERBURS'+lower(dbo.fnAuditoriaHistAccion(OPERBURSATILES.CodAuditoriaRef,0))) as FechaActualizacion, --FechaActualizacion
			Case 
				when #INTERFAZINVERSION.FechaConcertacion is not NULL  then #INTERFAZINVERSION.FechaConcertacion
				when #INTERFAZINVERSION.FechaConcertacion is NULL then GETDATE()
			End FechaProceso,			
			TPPAPEL.Abreviatura as CodTpInstrumento,
			null as FechaPrecancelacion,
			AGENTESCTASBANC.CBU as CBUCtaAgente,
			AGENTES.CUIT AS CUITAgente,
			AGENTESDEPOSITARIOS.NumDepositante as NroDepositante,
			AGENTESDEPOSITARIOSIT.NumComitente as NroComitente
    FROM    #INTERFAZINVERSION
            INNER JOIN OPERBURSATILES 
					INNER JOIN #FONDOS_sInversiones on #FONDOS_sInversiones.CodFondo = OPERBURSATILES.CodFondo
					LEFT JOIN ENTLIQUIDACION ON ENTLIQUIDACION.CodEntLiquidacion = OPERBURSATILES.CodEntLiquidacion 
                    LEFT  JOIN DEPOSITARIOS ON OPERBURSATILES.CodDepositario = DEPOSITARIOS.CodDepositario
                    INNER JOIN TPOPERACION ON TPOPERACION.CodTpOperacion =  OPERBURSATILES.CodTpOperacion
					LEFT JOIN AGENTESDEPOSITARIOS 
						LEFT JOIN AGENTESDEPOSITARIOSIT ON AGENTESDEPOSITARIOSIT.CodAgente = AGENTESDEPOSITARIOS.CodAgente
							AND AGENTESDEPOSITARIOSIT.CodAgenteDepositario = AGENTESDEPOSITARIOS.CodAgenteDepositario
							
					ON AGENTESDEPOSITARIOS.CodAgente = OPERBURSATILES.CodAgente 
						AND coalesce(AGENTESDEPOSITARIOS.CodDepositario, OPERBURSATILES.CodDepositario)  = OPERBURSATILES.CodDepositario
					LEFT JOIN AGENTESCTASBANC ON AGENTESCTASBANC.CodAgente = OPERBURSATILES.CodAgente 

                    INNER JOIN AGENTES ON AGENTES.CodAgente = OPERBURSATILES.CodAgente
                    LEFT JOIN ESPECIES ON ESPECIES.CodEspecie = OPERBURSATILES.CodEspecie
                    INNER JOIN MONEDAS ON MONEDAS.CodMoneda = OPERBURSATILES.CodMonedaOperacion
					INNER JOIN MONEDAS AS MONEDASGASTOS ON MONEDASGASTOS.CodMoneda = OPERBURSATILES.CodMonedaGasto
                    INNER JOIN (SELECT  CodFondo, CodOperBursatil, SUM(ISNULL(Cantidad,0.00)) AS Cantidad, SUM(ISNULL(Cantidad,0.00) * ISNULL(CONVERT(numeric(28,10), Precio),0.00)) AS Bruto 
                                FROM    OPERBURSATILESIT GROUP BY CodFondo, CodOperBursatil) AS OPERBURSATILESITTEMP
                            ON OPERBURSATILES.CodFondo = OPERBURSATILESITTEMP.CodFondo AND OPERBURSATILES.CodOperBursatil = OPERBURSATILESITTEMP.CodOperBursatil
                    LEFT JOIN SERIES ON SERIES.CodEspecie = OPERBURSATILES.CodEspecie AND SERIES.CodSerie  = OPERBURSATILES.CodSerie 
                    ON OPERBURSATILES.CodFondo = #INTERFAZINVERSION.CodFondo AND OPERBURSATILES.CodOperBursatil = #INTERFAZINVERSION.CodOperBursatil
					LEFT JOIN AGENTESAGCOLOCADORESREL ON AGENTESAGCOLOCADORESREL.CodAgente = AGENTES.CodAgente and AGENTESAGCOLOCADORESREL.CodAgColocador = #FONDOS_sInversiones.CodAgColocadorDep
									
					LEFT JOIN MERCADOS ON MERCADOS.CodMercado = OPERBURSATILES.CodMercado 
		left JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie 
					left JOIN TPPAPEL ON TPESPECIE.CodTpPapel = TPPAPEL.CodTpPapel
		WHERE NOT OPERBURSATILES.CodTpOperacion IN ('CCC','PCC','APCC','CCF','PCF','APCF') 
			and coalesce(AGENTESCTASBANC.CodMoneda,OPERBURSATILES.CodMonedaOperacion) = OPERBURSATILES.CodMonedaOperacion
			and coalesce(AGENTESDEPOSITARIOSIT.CodFondo,OPERBURSATILES.CodFondo) = OPERBURSATILES.CodFondo
			
    UNION
	/*******************************************************************/
    --aperturas, pases y cauciones
    /*******************************************************************/
	SELECT  'INV' AS InterfazItId,
            dbo.fnAuditoriaHistAccion(CACO.CodAuditoriaRef,-1) AS Accion,
            CACO.FechaConcertacion AS FechaConcertacion,
            CACO.FechaLiquidacion AS FechaLiquidacion,
            CACO.FechaLiquidacion AS FechaContraEspecie,
            OPCACO.Descripcion AS CodTpOperacionId,
            CASE WHEN OPCACO.EsDebito = -1 THEN 'D' ELSE 'C' END AS DebitoCredito,
            convert(varchar(20), CACO.NumeroOperacionBursatil) AS NumOperacion,
            #FONDOS_sInversiones.CodInterfaz AS CodFondoId,
            AGENTES.CodInterfaz AS CodAgenteId,
            DEPOSITARIOS.CodInterfaz AS CodDepositarioId,
            ESPECIES.CodInterfaz AS CodEspecieId,
            ESPECIES.IsinCode,
            MONEDAS.CodCAFCI AS CodMonedaId,
			CACO.Bruto AS ValorNominal,
           (CASE WHEN OPCACO.EsDebito = -1
                 THEN convert(numeric(19,2) ,(convert(numeric(28,10), CACO.Bruto) 
                        - ( ISNULL(convert(numeric(28,10), CACO.Arancel),0.00) + 
                            ISNULL(convert(numeric(28,10), CACO.Impuesto) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CACO.DerechoBolsa) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CACO.DerechoMercado) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CACO.GastosSEC) ,0.00) )) * convert(numeric(28,10), CACO.FactConvMonCargaOperacion))
                 ELSE convert(numeric(19,2) ,( convert(numeric(28,10), CACO.Bruto)
                        + ( ISNULL(convert(numeric(28,10), CACO.Arancel),0.00) + 
                            ISNULL(convert(numeric(28,10), CACO.Impuesto) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CACO.DerechoBolsa) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CACO.DerechoMercado) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CACO.GastosSEC) ,0.00) )) * convert(numeric(28,10), CACO.FactConvMonCargaOperacion))
            END) AS ImporteNeto,

            CASE WHEN DATEDIFF(dd, CACO.FechaLiquidacion, CAFU.FechaLiquidacion ) = 0 
             THEN NULL 
             ELSE CONVERT(float,((( CONVERT(float,(CAFU.Bruto - CONVERT(float,((CAFU.Arancel + CAFU.Impuesto + CAFU.DerechoBolsa + CAFU.DerechoMercado) * (1 / CAFU.FactConvMonCargaGasto))))) 
                / CONVERT(float,(CACO.Bruto + CONVERT(float,((CACO.Arancel + CACO.Impuesto + CACO.DerechoBolsa + CACO.DerechoMercado) * (1 / CACO.FactConvMonCargaGasto))))) ) - 1) * 36500)) 
                / DATEDIFF(dd, CACO.FechaLiquidacion, CAFU.FechaLiquidacion)
             END AS Tasa,
            NULL AS NumOperacionRef,
			CACO.CodAuditoriaRef AS CodAuditoriaRef,
			#FONDOS_sInversiones.NRCNV as FondoBancoValoresId,
			AGENTES.NumeroAgente as NumAgente,
			coalesce(MONEDASGASTOS.CodCAFCI,'') as MonedaGastoId,
			(CACO.Arancel+CACO.DerechoMercado+CACO.DerechoBolsa+CACO.Impuesto+CACO.GastosSEC) as ImporteGastos,
			CACO.Bruto as ImporteBruto,
			case when ESPECIES.NumEspecieCV is null
			then ''
			else convert(varchar,ESPECIES.NumEspecieCV)
			end as CodCajaValoresCAFCI,
			0 as EsTransferible,
			0 as EsPrecancelable,
			case when ENTLIQUIDACION.CodInterfaz LIKE 'SENEBI' OR ENTLIQUIDACION.CodInterfaz LIKE 'GARA' OR ENTLIQUIDACION.CodInterfaz LIKE 'BYMA' OR ENTLIQUIDACION.CodInterfaz LIKE 'EP' OR ENTLIQUIDACION.CodInterfaz LIKE 'CV' OR ENTLIQUIDACION.CodInterfaz LIKE 'MAE CLEAR' THEN
				'CJ2'
			ELSE
				 coalesce(ENTLIQUIDACION.CodInterfaz,'') 
			END as EntidadLiquidacion,
			coalesce(AGENTESAGCOLOCADORESREL.CodInterfaz,'') as CodAgenteCustodiaId,
			NULL as CodInterfazDepAdicional, 
			MONEDAS.CodCAFCI as CodCAFCIMonedaConc, 
			MONEDASGASTOS.CodCAFCI as CodCAFCIMonedaGas, 
			MERCADOS.CodCAFCI as CodCAFCIMercado,
			''  as AbrevChequePagare, 
			NULL as FechaVencimiento,
			CAFU.CodAuditoriaRef CodAuditoriaOperRel,
			CACO.CodTpOperacion as CodTpOperacion,
			--AGENTESAGCOLOCADORESREL.CodAuditoriaRef as CodInterfazAgCus,
			AGENTESAGCOLOCADORESREL.CodInterfaz as CodInterfazAgCus,
			dbo.fnAuditoriaFechaAlta(CACO.CodAuditoriaRef, 'OPERBURS'+lower(dbo.fnAuditoriaHistAccion(CACO.CodAuditoriaRef,0))) as FechaAlta, 
			dbo.fnAuditoriaFechaAlta(CACO.CodAuditoriaRef, 'OPERBURS'+lower(dbo.fnAuditoriaHistAccion(CACO.CodAuditoriaRef,0))) as FechaActualizacion, 
			Case 
				when #INTERFAZINVERSION.FechaConcertacion is not NULL  then #INTERFAZINVERSION.FechaConcertacion
				when #INTERFAZINVERSION.FechaConcertacion is NULL then GETDATE()
			End FechaProceso,
			TPPAPEL.Abreviatura as CodTpInstrumento ,
			null as FechaPrecancelacion,
			AGENTESCTASBANC.CBU as CBUCtaAgente,
			AGENTES.CUIT AS CUITAgente,
			null as NroDepositante,
			null as NroComitente
	FROM    PASESCAU
	inner join #FONDOS_sInversiones ON #FONDOS_sInversiones.CodFondo = PASESCAU.CodFondo
	INNER JOIN OPERBURSATILES AS CACO 
		LEFT JOIN ENTLIQUIDACION ON ENTLIQUIDACION.CodEntLiquidacion = CACO.CodEntLiquidacion 
		LEFT  JOIN DEPOSITARIOS ON CACO.CodDepositario = DEPOSITARIOS.CodDepositario
		LEFT JOIN ESPECIES ON ESPECIES.CodEspecie = CACO.CodEspecie 
		INNER JOIN AGENTES 
			LEFT JOIN AGENTESCTASBANC ON AGENTESCTASBANC.CodAgente = AGENTES.CodAgente 
		ON AGENTES.CodAgente = CACO.CodAgente
		INNER JOIN MONEDAS AS MONEDASGASTOS ON MONEDASGASTOS.CodMoneda = CACO.CodMonedaGasto
		INNER JOIN TPOPERACION AS OPCACO ON OPCACO.CodTpOperacion = CACO.CodTpOperacion
		INNER JOIN MONEDAS ON MONEDAS.CodMoneda = CACO.CodMonedaOperacion
		INNER JOIN (SELECT  CodFondo, CodOperBursatil, SUM(ISNULL(Cantidad,0.00)) AS Cantidad, SUM(ISNULL(Cantidad,0.00) * ISNULL(CONVERT(numeric(28,10), Precio),0.00)) AS Bruto 
								FROM    OPERBURSATILESIT GROUP BY CodFondo, CodOperBursatil) AS OPERBURSATILESITTEMP
							ON CACO.CodFondo = OPERBURSATILESITTEMP.CodFondo AND CACO.CodOperBursatil = OPERBURSATILESITTEMP.CodOperBursatil
					LEFT JOIN SERIES ON SERIES.CodEspecie = CACO.CodEspecie AND SERIES.CodSerie  = CACO.CodSerie 
	ON CACO.CodPaseCau = PASESCAU.CodPaseCau and CACO.CodTpOperacion IN ('CCC','PCC','APCC' ) 
					AND CACO.CodFondo = PASESCAU.CodFondo
	LEFT JOIN AGENTESAGCOLOCADORESREL ON AGENTESAGCOLOCADORESREL.CodAgente = CACO.CodAgente and AGENTESAGCOLOCADORESREL.CodAgColocador = #FONDOS_sInversiones.CodAgColocadorDep
	INNER JOIN OPERBURSATILES AS CAFU 
		INNER JOIN TPOPERACION AS OPCAFU ON OPCAFU.CodTpOperacion = CAFU.CodTpOperacion
	ON CAFU.CodPaseCau = PASESCAU.CodPaseCau AND CAFU.CodTpOperacion IN ('CCF','PCF','APCF' )
			AND CAFU.CodFondo = PASESCAU.CodFondo
	INNER JOIN #INTERFAZINVERSION ON  #INTERFAZINVERSION.CodFondo = CACO.CodFondo 
		AND #INTERFAZINVERSION.CodOperBursatil = CACO.CodOperBursatil

	LEFT JOIN MERCADOS ON MERCADOS.CodMercado = CACO.CodMercado 
	left JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie 
	left JOIN TPPAPEL ON TPESPECIE.CodTpPapel = TPPAPEL.CodTpPapel
					
	WHERE	CACO.CodTpOperacion IN ('CCC','PCC','APCC') 
		and coalesce(AGENTESCTASBANC.CodMoneda,CACO.CodMonedaOperacion) = CACO.CodMonedaOperacion

	UNION
	/*******************************************************************/
    --aperturas, pases y cauciones
    /*******************************************************************/
	SELECT  'INV' AS InterfazItId,
            dbo.fnAuditoriaHistAccion(CACO.CodAuditoriaRef,-1) AS Accion,
            CAFU.FechaConcertacion AS FechaConcertacion,
            CAFU.FechaLiquidacion AS FechaLiquidacion,
            CAFU.FechaLiquidacion AS FechaContraEspecie,
            OPCAFU.Descripcion AS CodTpOperacionId,
            CASE WHEN OPCAFU.EsDebito = -1 THEN 'D' ELSE 'C' END AS DebitoCredito,
            convert(varchar(20), CAFU.NumeroOperacionBursatil) AS NumOperacion,
            #FONDOS_sInversiones.CodInterfaz AS CodFondoId,
            AGENTES.CodInterfaz AS CodAgenteId,
            DEPOSITARIOS.CodInterfaz AS CodDepositarioId,
            ESPECIES.CodInterfaz AS CodEspecieId,
            ESPECIES.IsinCode,
            MONEDAS.CodCAFCI AS CodMonedaId,
			CACO.Bruto AS ValorNominal,
           (CASE WHEN OPCAFU.EsDebito = -1
                 THEN convert(numeric(19,2) ,(convert(numeric(28,10), CAFU.Bruto) 
                        - ( ISNULL(convert(numeric(28,10), CAFU.Arancel),0.00) + 
                            ISNULL(convert(numeric(28,10), CAFU.Impuesto) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CAFU.DerechoBolsa) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CAFU.DerechoMercado) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CAFU.GastosSEC) ,0.00) )) * convert(numeric(28,10), CAFU.FactConvMonCargaOperacion))
                 ELSE convert(numeric(19,2) ,( convert(numeric(28,10), CAFU.Bruto)
                        + ( ISNULL(convert(numeric(28,10), CAFU.Arancel),0.00) + 
                            ISNULL(convert(numeric(28,10), CAFU.Impuesto) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CAFU.DerechoBolsa) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CAFU.DerechoMercado) ,0.00) + 
                            ISNULL(convert(numeric(28,10), CAFU.GastosSEC) ,0.00) )) * convert(numeric(28,10), CAFU.FactConvMonCargaOperacion))
            END) AS ImporteNeto,

            CASE WHEN DATEDIFF(dd, CACO.FechaLiquidacion, CAFU.FechaLiquidacion ) = 0 
             THEN NULL 
             ELSE CONVERT(float,((( CONVERT(float,(CAFU.Bruto - CONVERT(float,((CAFU.Arancel + CAFU.Impuesto + CAFU.DerechoBolsa + CAFU.DerechoMercado) * (1 / CAFU.FactConvMonCargaGasto))))) 
                / CONVERT(float,(CACO.Bruto + CONVERT(float,((CACO.Arancel + CACO.Impuesto + CACO.DerechoBolsa + CACO.DerechoMercado) * (1 / CACO.FactConvMonCargaGasto))))) ) - 1) * 36500)) 
                / DATEDIFF(dd, CACO.FechaLiquidacion, CAFU.FechaLiquidacion)
             END AS Tasa,
            NULL AS NumOperacionRef,
			CAFU.CodAuditoriaRef AS CodAuditoriaRef,
			#FONDOS_sInversiones.NRCNV as FondoBancoValoresId,
			AGENTES.NumeroAgente as NumAgente,
			coalesce(MONEDASGASTOS.CodCAFCI,'') as MonedaGastoId,
			(CAFU.Arancel+CAFU.DerechoMercado+CAFU.DerechoBolsa+CAFU.Impuesto+CAFU.GastosSEC) as ImporteGastos,
			CAFU.Bruto as ImporteBruto,
			case when ESPECIES.NumEspecieCV is null
			then ''
			else convert(varchar,ESPECIES.NumEspecieCV)
			end as CodCajaValoresCAFCI,
			0 as EsTransferible,
			0 as EsPrecancelable,
			case when ENTLIQUIDACION.CodInterfaz LIKE 'SENEBI' OR ENTLIQUIDACION.CodInterfaz LIKE 'GARA' OR ENTLIQUIDACION.CodInterfaz LIKE 'BYMA' OR ENTLIQUIDACION.CodInterfaz LIKE 'EP' OR ENTLIQUIDACION.CodInterfaz LIKE 'CV' OR ENTLIQUIDACION.CodInterfaz LIKE 'MAE CLEAR' THEN
				'CJ2'
			ELSE
				 coalesce(ENTLIQUIDACION.CodInterfaz,'') 
			END as EntidadLiquidacion,
			coalesce(AGENTESAGCOLOCADORESREL.CodInterfaz,'') as CodAgenteCustodiaId,
			NULL as CodInterfazDepAdicional, 
			MONEDAS.CodCAFCI as CodCAFCIMonedaConc, 
			MONEDASGASTOS.CodCAFCI as CodCAFCIMonedaGas, 
			MERCADOS.CodCAFCI as CodCAFCIMercado,
			''  as AbrevChequePagare, 
			NULL as FechaVencimiento,
			CACO.CodAuditoriaRef AS CodAuditoriaOperRel,
			CAFU.CodTpOperacion as CodTpOperacion,
			AGENTESAGCOLOCADORESREL.CodInterfaz as CodInterfazAgCus,
			dbo.fnAuditoriaFechaAlta(CAFU.CodAuditoriaRef, 'OPERBURS'+lower(dbo.fnAuditoriaHistAccion(CAFU.CodAuditoriaRef,0))) as FechaAlta, 
			dbo.fnAuditoriaFechaAlta(CAFU.CodAuditoriaRef, 'OPERBURS'+lower(dbo.fnAuditoriaHistAccion(CAFU.CodAuditoriaRef,0))) as FechaActualizacion, 
			Case 
				when #INTERFAZINVERSION.FechaConcertacion is not NULL  then #INTERFAZINVERSION.FechaConcertacion
				when #INTERFAZINVERSION.FechaConcertacion is NULL then GETDATE()
			End FechaProceso,
			TPPAPEL.Abreviatura as CodTpInstrumento,
			null as FechaPrecancelacion,
			AGENTESCTASBANC.CBU as CBUCtaAgente,
			AGENTES.CUIT AS CUITAgente,
			null as NroDepositante,
			null as NroComitente
	FROM    PASESCAU
	inner join #FONDOS_sInversiones ON #FONDOS_sInversiones.CodFondo = PASESCAU.CodFondo
	INNER JOIN OPERBURSATILES AS CACO 
			LEFT JOIN ENTLIQUIDACION ON ENTLIQUIDACION.CodEntLiquidacion = CACO.CodEntLiquidacion 
			LEFT  JOIN DEPOSITARIOS ON CACO.CodDepositario = DEPOSITARIOS.CodDepositario
			LEFT JOIN ESPECIES ON ESPECIES.CodEspecie = CACO.CodEspecie 
			INNER JOIN AGENTES 
				LEFT JOIN AGENTESCTASBANC ON AGENTESCTASBANC.CodAgente = AGENTES.CodAgente 
			ON AGENTES.CodAgente = CACO.CodAgente
			INNER JOIN MONEDAS AS MONEDASGASTOS ON MONEDASGASTOS.CodMoneda = CACO.CodMonedaGasto
			INNER JOIN TPOPERACION AS OPCACO ON OPCACO.CodTpOperacion = CACO.CodTpOperacion
			INNER JOIN MONEDAS ON MONEDAS.CodMoneda = CACO.CodMonedaOperacion
			INNER JOIN (SELECT  CodFondo, CodOperBursatil, SUM(ISNULL(Cantidad,0.00)) AS Cantidad, SUM(ISNULL(Cantidad,0.00) * ISNULL(CONVERT(numeric(28,10), Precio),0.00)) AS Bruto 
									FROM    OPERBURSATILESIT GROUP BY CodFondo, CodOperBursatil) AS OPERBURSATILESITTEMP
								ON CACO.CodFondo = OPERBURSATILESITTEMP.CodFondo AND CACO.CodOperBursatil = OPERBURSATILESITTEMP.CodOperBursatil
						LEFT JOIN SERIES ON SERIES.CodEspecie = CACO.CodEspecie AND SERIES.CodSerie  = CACO.CodSerie 
		ON CACO.CodPaseCau = PASESCAU.CodPaseCau and CACO.CodTpOperacion IN ('CCC','PCC','APCC' ) 
				AND CACO.CodFondo = PASESCAU.CodFondo
		INNER JOIN OPERBURSATILES AS CAFU 
			INNER JOIN #INTERFAZINVERSION ON  #INTERFAZINVERSION.CodFondo = CAFU.CodFondo 
				AND #INTERFAZINVERSION.CodOperBursatil = CAFU.CodOperBursatil

			INNER JOIN TPOPERACION AS OPCAFU ON OPCAFU.CodTpOperacion = CAFU.CodTpOperacion
		ON CAFU.CodPaseCau = PASESCAU.CodPaseCau AND CAFU.CodTpOperacion IN ('CCF','PCF','APCF' )
				AND CAFU.CodFondo = PASESCAU.CodFondo
		LEFT JOIN AGENTESAGCOLOCADORESREL ON AGENTESAGCOLOCADORESREL.CodAgente = AGENTES.CodAgente and AGENTESAGCOLOCADORESREL.CodAgColocador = #FONDOS_sInversiones.CodAgColocadorDep

		LEFT JOIN MERCADOS ON MERCADOS.CodMercado = CACO.CodMercado 
		left JOIN TPESPECIE ON TPESPECIE.CodTpEspecie = ESPECIES.CodTpEspecie 
		left JOIN TPPAPEL ON TPESPECIE.CodTpPapel = TPPAPEL.CodTpPapel
					
	WHERE	CAFU.CodTpOperacion IN ('CCF','PCF','APCF') 
		and coalesce(AGENTESCTASBANC.CodMoneda,CACO.CodMonedaOperacion) = CACO.CodMonedaOperacion
   UNION	
			 
    /*******************************************************************/
    --Compra/Vta
    /*******************************************************************/
    SELECT  'INV' AS InterfazId,
            dbo.fnAuditoriaHistAccion(OPERFINANCIERAS.CodAuditoriaRef,-1) AS Accion,
            OPERFINANCIERAS.FechaConcertacion AS FechaConcertacion,
            OPERFINANCIERAS.FechaLiquidacion AS FechaLiquidacion,
            OPERFINANCIERAS.FechaLiquidacion AS FechaContraEspecie,
            TPOPERACION.Descripcion AS CodTpOperacionId,
            CASE WHEN TPOPERACION.EsDebito = -1 THEN 'D' ELSE 'C' END AS DebitoCredito,
            convert(varchar(20), OPERFINANCIERAS.NumOperFinanciera) AS NumOperacion,
            #FONDOS_sInversiones.CodInterfaz AS CodFondoId,
            '' AS CodAgenteId,
            #FONDOS_sInversiones.CodInterfazDep AS CodDepositarioId,
            MONEDAS.CodCAFCI AS CodEspecieId,
            '' AS IsinCode,
            MONEDACD.CodCAFCI AS CodMonedaId, 
            convert(numeric(28,10),CASE WHEN OPERFINANCIERAS.CodTpOperacion = 'VD' THEN OPERFINCVDIVISAS.Importe WHEN  OPERFINANCIERAS.CodTpOperacion = 'CD' THEN OPERFINANCIERAS.Importe ELSE 0.0 END) AS ValorNominal, 
            CASE WHEN OPERFINANCIERAS.CodTpOperacion = 'CD' THEN OPERFINCVDIVISAS.Importe  WHEN OPERFINANCIERAS.CodTpOperacion = 'VD' THEN OPERFINANCIERAS.Importe ELSE 0.0 END AS ImporteNeto,
            OPERFINANCIERAS.FactorConversion AS Tasa,
            NULL AS NumOperacionRef,
			OPERFINANCIERAS.CodAuditoriaRef AS CodAuditoriaRef,
			#FONDOS_sInversiones.NRCNV FondoBancoValoresId,
			'' as NumAgente,
			MONEDACD.CodCAFCI as MonedaGastoId,
			0 as ImporteGastos,
			OPERFINANCIERAS.Importe as ImporteBruto,
			case when OPERFINANCIERAS.CodInterfOperFinCV is null
			then ''
			else convert(varchar,OPERFINANCIERAS.CodInterfOperFinCV)
			end as CodCajaValoresCAFCI,
			0 as EsTransferible,
			0 as EsPrecancelable,
			'' as EntidadLiquidacion,
			'' as CodAgenteCustodiaId,

			NULL as CodInterfazDepAdicional,
			MONEDAS.CodCAFCI as CodCAFCIMonedaConc,
			MONEDAS.CodCAFCI as CodCAFCIMonedaGas, 
			'' as CodCAFCIMercado,
			''  as AbrevChequePagare, 
			NULL as FechaVencimiento,
			NULL as CodAuditoriaOperRel, 
			TPOPERACION.CodTpOperacion as CodTpOperacion,
			BANCOSAGCOLOCADORESREL.CodInterfaz as CodInterfazAgCus,
			dbo.fnAuditoriaFechaAlta(OPERFINANCIERAS.CodAuditoriaRef, 'CVDIV'+lower(dbo.fnAuditoriaHistAccion(OPERFINANCIERAS.CodAuditoriaRef,0))) as FechaAlta, 
			dbo.fnAuditoriaFechaAlta(OPERFINANCIERAS.CodAuditoriaRef, 'CVDIV'+lower(dbo.fnAuditoriaHistAccion(OPERFINANCIERAS.CodAuditoriaRef,0))) as FechaActualizacion, 
			Case 
				when #INTERFAZINVERSION.FechaConcertacion is not NULL  then #INTERFAZINVERSION.FechaConcertacion
				when #INTERFAZINVERSION.FechaConcertacion is NULL then GETDATE()
			End FechaProceso,
			NULL as CodTpInstrumento,
			null as FechaPrecancelacion,
			null as CBUCtaAgente,
			null AS CUITAgente,
			null as NroDepositante,
			null as NroComitente
    FROM    #INTERFAZINVERSION
            INNER JOIN OPERFINANCIERAS     
                    INNER JOIN OPERFINCVDIVISAS 
                            INNER JOIN MONEDAS MONEDACD ON MONEDACD.CodMoneda = OPERFINCVDIVISAS.CodMoneda 
                            ON OPERFINCVDIVISAS.CodFondo = OPERFINANCIERAS.CodFondo AND OPERFINCVDIVISAS.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
                    INNER JOIN TPOPERACION ON TPOPERACION.CodTpOperacion =  OPERFINANCIERAS.CodTpOperacion
                    INNER JOIN #FONDOS_sInversiones ON #FONDOS_sInversiones.CodFondo = OPERFINANCIERAS.CodFondo					
                    INNER JOIN MONEDAS ON MONEDAS.CodMoneda = OPERFINANCIERAS.CodMoneda
                    ON OPERFINANCIERAS.CodFondo = #INTERFAZINVERSION.CodFondo AND OPERFINANCIERAS.CodOperFinanciera = #INTERFAZINVERSION.CodOperFinanciera
					inner join BANCOSAGCOLOCADORESREL ON OPERFINANCIERAS.CodBanco = BANCOSAGCOLOCADORESREL.CodBanco AND BANCOSAGCOLOCADORESREL.CodAgColocador = #FONDOS_sInversiones.CodAgColocadorDep
    WHERE   OPERFINANCIERAS.CodTpOperacion IN ('CD', 'VD') 
    UNION
    /*******************************************************************/
    --Plazo Fijo viejos 
    /*******************************************************************/
    SELECT  'INV' AS InterfazId,
            dbo.fnAuditoriaHistAccion(OPERFINANCIERAS.CodAuditoriaRef,-1) AS Accion,
            OPERFINANCIERAS.FechaConcertacion AS FechaConcertacion,
            OPERFINANCIERAS.FechaLiquidacion AS FechaLiquidacion,
            OPERFINANCIERAS.FechaLiquidacion AS FechaContraEspecie,
            TPOPERACION.Descripcion AS CodTpOperacionId,
            ' ' AS DebitoCredito,
            convert(varchar(20), OPERFINANCIERAS.NumOperFinanciera) AS NumOperacion,
            #FONDOS_sInversiones.CodInterfaz AS CodFondoId, 
            COALESCE(BANCOSBCRA.CodBCRA,'') AS CodAgenteId,
            #FONDOS_sInversiones.CodInterfazDep AS CodDepositarioId,
            '' AS CodEspecieId,
            '' AS IsinCode,
            MONEDAS.CodCAFCI AS CodMonedaId, 
            convert(numeric(28,10),OPERFINANCIERAS.Importe) AS ValorNominal,
            (OPERFINANCIERAS.Importe + OPERFINANCIERAS.Interes - COALESCE(OPERFINANCIERAS.Gastos,0)) AS ImporteNeto,
            OPERFINANCIERAS.TasaInteres AS Tasa,
            OPERREL.NumOperFinanciera AS NumOperacionRef,
			OPERFINANCIERAS.CodAuditoriaRef AS CodAuditoriaRef,
			#FONDOS_sInversiones.NRCNV FondoBancoValoresId,
			'' as NumAgente,
			MONEDAS.CodCAFCI as MonedaGastoId,
			0 as ImporteGastos,
			OPERFINANCIERAS.Importe as ImporteBruto,
			case when OPERFINANCIERAS.CodInterfOperFinCV is null
			then ''
			else convert(varchar,OPERFINANCIERAS.CodInterfOperFinCV)
			end as CodCajaValoresCAFCI,
			OPERFINPZOFIJO.EsTransferible as EsTransferible,
			OPERFINPZOFIJO.EsPrecancelable as EsPrecancelable,
			'' as EntidadLiquidacion,
			'' as CodAgenteCustodiaId,

			ISNULL(BANCOSBCRA.CodBCRA, '') as CodInterfazDepAdicional,
			MONEDAS.CodCAFCI as CodCAFCIMonedaConc, 
			MONEDAS.CodCAFCI as CodCAFCIMonedaGas, 
			'' as CodCAFCIMercado,
			'' as AbrevChequePagare, 
			NULL as FechaVencimiento,
			NULL as CodAuditoriaOperRel, 
			TPOPERACION.CodTpOperacion as CodTpOperacion,
			BANCOSAGCOLOCADORESREL.CodInterfaz as CodInterfazAgCus,
			dbo.fnAuditoriaFechaAlta(OPERFINANCIERAS.CodAuditoriaRef, 'OPERFINPZOFJO'+lower(dbo.fnAuditoriaHistAccion(OPERFINANCIERAS.CodAuditoriaRef,0))) as FechaAlta, 
			dbo.fnAuditoriaFechaAlta(OPERFINANCIERAS.CodAuditoriaRef, 'OPERFINPZOFJO'+lower(dbo.fnAuditoriaHistAccion(OPERFINANCIERAS.CodAuditoriaRef,0))) as FechaActualizacion, --
			Case 
				when #INTERFAZINVERSION.FechaConcertacion is not NULL  then #INTERFAZINVERSION.FechaConcertacion
				when #INTERFAZINVERSION.FechaConcertacion is NULL then GETDATE()
			End FechaProceso,			
			NULL as CodTpInstrumento,
			OPERFINPZOFIJO.FechaPrecancelacion,
			null as CBUCtaAgente,
			null AS CUITAgente,
			null as NroDepositante,
			null as NroComitente
    FROM    #INTERFAZINVERSION
	INNER JOIN OPERFINANCIERAS 
		INNER JOIN #FONDOS_sInversiones ON #FONDOS_sInversiones.CodFondo = OPERFINANCIERAS.CodFondo		
        INNER JOIN TPOPERACION ON TPOPERACION.CodTpOperacion =  OPERFINANCIERAS.CodTpOperacion
        INNER JOIN MONEDAS ON MONEDAS.CodMoneda = OPERFINANCIERAS.CodMoneda
        LEFT  JOIN BANCOS ON BANCOS.CodBanco = OPERFINANCIERAS.CodBanco
			LEFT JOIN BANCOSAGCOLOCADORESREL ON BANCOSAGCOLOCADORESREL.CodBanco = BANCOS.CodBanco and BANCOSAGCOLOCADORESREL.CodAgColocador = #FONDOS_sInversiones.CodAgColocadorDep
			LEFT  JOIN BANCOSBCRA
                        ON BANCOSBCRA.CodBanco = BANCOS.CodBanco
                        AND BANCOSBCRA.CodMoneda = OPERFINANCIERAS.CodMoneda
		ON OPERFINANCIERAS.CodFondo = #INTERFAZINVERSION.CodFondo AND OPERFINANCIERAS.CodOperFinanciera = #INTERFAZINVERSION.CodOperFinanciera
		LEFT  JOIN OPERFINRELACIONES 
			INNER JOIN OPERFINANCIERAS OPERREL ON OPERFINRELACIONES.CodFondoRldo = OPERREL.CodFondo AND OPERFINRELACIONES.CodOperFinancieraRlda = OPERREL.CodOperFinanciera         
		ON OPERFINRELACIONES.CodFondo = OPERFINANCIERAS.CodFondo AND OPERFINRELACIONES.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
	INNER JOIN OPERFINPZOFIJO ON OPERFINPZOFIJO.CodOperFinanciera = OPERFINANCIERAS.CodOperFinanciera
	and OPERFINPZOFIJO.CodFondo = OPERFINANCIERAS.CodFondo 

    WHERE   OPERFINANCIERAS.CodTpOperacion = 'PF'
    UNION
    /*******************************************************************/
    ---Plazo Fijo nuevos
    /*******************************************************************/
    SELECT  'INV' AS InterfazId,
            dbo.fnAuditoriaHistAccion(PLAZOSFIJOS.CodAuditoriaRef,-1) AS Accion,
            PLAZOSFIJOS.FechaConcertacion AS FechaConcertacion,
            PLAZOSFIJOS.FechaLiquidacion AS FechaLiquidacion,
            PLAZOSFIJOS.FechaLiquidacion AS FechaContraEspecie,
            TPOPERACION.Descripcion AS CodTpOperacionId,
            ' ' AS DebitoCredito,
            CONVERT(varchar(20), PLAZOSFIJOS.NumPlazoFijo) AS NumOperacion,
            #FONDOS_sInversiones.CodInterfaz AS CodFondoId,
            ISNULL(BANCOSBCRA.CodBCRA, '') AS CodAgenteId,
            #FONDOS_sInversiones.CodInterfazDep AS CodDepositarioId,
            '' AS CodEspecieId,
            '' AS IsinCode,
            MONEDAS.CodCAFCI AS CodMonedaId,
            convert(numeric(28,10),PFCAPITAL.Importe) AS ValorNominal,
           (ISNULL(PFCAPITAL.Importe,0) + ISNULL(PFINTERES.Interes,0) - ISNULL(PFCAPITAL.Ajuste,0)) AS ImporteNeto,
            ISNULL(PLAZOSFIJOSTASA.Tasa, 0) + ISNULL(PFTASA.TasaFija, 0) + ISNULL(PLAZOSFIJOSAJUSTE.Tasa, 0) AS Tasa,
            ISNULL(PLAZOSFIJOSREL.NumPlazoFijo, '') AS NumOperacionRef,
			PLAZOSFIJOS.CodAuditoriaRef AS CodAuditoriaRef,
			#FONDOS_sInversiones.NRCNV as FondoBancoValoresId,
			'' as NumAgente,
			MONEDAS.CodCAFCI as MonedaGastoId,
			0 as ImporteGastos,
			ISNULL(PFCAPITAL.Importe,0) as ImporteBruto,
			PLAZOSFIJOS.CodCAFCI as CodCajaValoresCAFCI,
			PLAZOSFIJOS.EsTransferible as EsTransferible,
			PLAZOSFIJOS.EsPrecancelableInmediato as EsPrecancelable,
			'' as EntidadLiquidacion,
			'' as CodAgenteCustodiaId,

			ISNULL(BANCOSBCRA.CodBCRA, '') as CodInterfazDepAdicional,
			MONEDAS.CodCAFCI as CodCAFCIMonedaConc, 
			MONEDAS.CodCAFCI as CodCAFCIMonedaGas, 
			'' as CodCAFCIMercado,
			'' as AbrevChequePagare, 
			NULL as FechaVencimiento,
			NULL as CodAuditoriaOperRel,
			TPOPERACION.CodTpOperacion as CodTpOperacion,
			BANCOSAGCOLOCADORESREL.CodInterfaz as CodInterfazAgCus,
			dbo.fnAuditoriaFechaAlta(PLAZOSFIJOS.CodAuditoriaRef, 'PLAZOSFIJOS'+lower(dbo.fnAuditoriaHistAccion(PLAZOSFIJOS.CodAuditoriaRef,0))) as FechaAlta, 
			dbo.fnAuditoriaFechaAlta(PLAZOSFIJOS.CodAuditoriaRef, 'PLAZOSFIJOS'+lower(dbo.fnAuditoriaHistAccion(PLAZOSFIJOS.CodAuditoriaRef,0))) as FechaActualizacion, 
			Case 
				when #INTERFAZINVERSION.FechaConcertacion is not NULL  then #INTERFAZINVERSION.FechaConcertacion
				when #INTERFAZINVERSION.FechaConcertacion is NULL then GETDATE()
			End FechaProceso,			
			NULL as CodTpInstrumento,
			null as FechaPrecancelacion,
			null as CBUCtaAgente,
			null AS CUITAgente,
			null as NroDepositante,
			null as NroComitente
    FROM    #INTERFAZINVERSION
            INNER JOIN vwPLAZOSFIJOS PLAZOSFIJOS 
                    INNER JOIN PLAZOSFIJOS PFTASA ON PFTASA.CodFondo =  PLAZOSFIJOS.CodFondo AND PFTASA.CodPlazoFijo =  PLAZOSFIJOS.CodPlazoFijo
                    INNER JOIN TPOPERACION ON TPOPERACION.CodTpOperacion =  PLAZOSFIJOS.CodTpOperacion
					INNER JOIN #FONDOS_sInversiones ON #FONDOS_sInversiones.CodFondo = PLAZOSFIJOS.CodFondo
                    INNER JOIN MONEDAS ON MONEDAS.CodMoneda = PLAZOSFIJOS.CodMoneda
                    LEFT  JOIN BANCOS ON BANCOS.CodBanco = PLAZOSFIJOS.CodBanco
							LEFT JOIN BANCOSAGCOLOCADORESREL ON BANCOSAGCOLOCADORESREL.CodAgColocador = #FONDOS_sInversiones.CodAgColocadorDep and BANCOSAGCOLOCADORESREL.CodBanco = BANCOS.CodBanco
                            LEFT JOIN BANCOSBCRA ON BANCOSBCRA.CodBanco = BANCOS.CodBanco AND BANCOSBCRA.CodMoneda = PLAZOSFIJOS.CodMoneda
                    ON PLAZOSFIJOS.CodFondo = #INTERFAZINVERSION.CodFondo AND PLAZOSFIJOS.CodPlazoFijo = #INTERFAZINVERSION.CodPlazoFijo
            LEFT JOIN (SELECT  CodFondo, CodPlazoFijo, SUM(ISNULL(Capital,0)) AS Importe, SUM(ISNULL(Ajuste,0)) AS Ajuste
                       FROM    PLAZOSFIJOSCAPITAL GROUP BY CodFondo, CodPlazoFijo) PFCAPITAL
                    ON PFCAPITAL.CodFondo = PLAZOSFIJOS.CodFondo AND PFCAPITAL.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
            LEFT JOIN (SELECT  CodFondo, CodPlazoFijo, SUM(ISNULL(Interes,0)) AS Interes
                       FROM    PLAZOSFIJOSINTERES WHERE   EstaAnulado = 0 AND CodTpPlazoFijoInteres = 'DV'
                       GROUP BY CodFondo, CodPlazoFijo) PFINTERES
                    ON PFINTERES.CodFondo = PLAZOSFIJOS.CodFondo AND PFINTERES.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
            LEFT  JOIN PLAZOSFIJOS PLAZOSFIJOSREL ON PLAZOSFIJOSREL.CodFondo = PLAZOSFIJOS.CodFondo AND PLAZOSFIJOSREL.CodPlazoFijoRel = PLAZOSFIJOS.CodPlazoFijo
            LEFT  JOIN PLAZOSFIJOSTASA
                    ON PLAZOSFIJOSTASA.CodFondo = PLAZOSFIJOS.CodFondo
                   AND PLAZOSFIJOSTASA.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
                   AND PLAZOSFIJOSTASA.Fecha = PLAZOSFIJOS.FechaConcertacion
            LEFT  JOIN PLAZOSFIJOSAJUSTE
                    ON PLAZOSFIJOSAJUSTE.CodFondo = PLAZOSFIJOS.CodFondo
                   AND PLAZOSFIJOSAJUSTE.CodPlazoFijo = PLAZOSFIJOS.CodPlazoFijo
                   AND PLAZOSFIJOSAJUSTE.FechaConcertacion = PLAZOSFIJOS.FechaConcertacion
                   AND PLAZOSFIJOSAJUSTE.FechaInicio = PLAZOSFIJOS.FechaConcertacion
                   AND PLAZOSFIJOSAJUSTE.FechaFin >= PLAZOSFIJOS.FechaConcertacion
                   AND PLAZOSFIJOSAJUSTE.EstaAnulado = 0
    WHERE   PLAZOSFIJOS.EsOperFinPzoFijo = 0
	UNION
	--/*******************************************************************/
 --   --ChequesDiferidos - Compra
 --   /*******************************************************************/
	SELECT	'INV' AS InterfazId,
            dbo.fnAuditoriaHistAccion(CHEQUESDIFCOMPRA.CodAuditoriaRef,-1) AS Accion,
            CHEQUESDIFCOMPRA.FechaConcertacion AS FechaConcertacion,
            CHEQUESDIFCOMPRA.FechaLiquidacion AS FechaLiquidacion,
            CHEQUESDIFCOMPRA.FechaLiquidacion AS FechaContraEspecie,
            'Compra de Cheque de Pago Diferido' AS CodTpOperacionId,
            ' ' AS DebitoCredito,
            CONVERT(varchar(20), CHEQUESDIFCOMPRA.NumChequeDifCpa) AS NumOperacion,
            #FONDOS_sInversiones.CodInterfaz AS CodFondoId,
            ISNULL(BANCOSBCRA.CodBCRA, '') AS CodAgenteId,
            DEPOSITARIOS.CodInterfaz AS CodDepositarioId,
            '' AS CodEspecieId,
            '' AS IsinCode,
            MONEDAS.CodCAFCI AS CodMonedaId,
            convert(numeric(28,10),CHEQUESDIF.Importe) AS ValorNominal,
           (ISNULL(CHEQUESDIFCOMPRA.Importe,0) + ISNULL(CHEQUESDIFCOMPRA.ImporteGastos,0)) AS ImporteNeto,
            ISNULL(CHEQUESDIFCOMPRA.Tasa, 0) AS Tasa,
            CONVERT(VARCHAR(12), CHEQUESDIF.NumChequeDif) AS NumOperacionRef,
			CHEQUESDIFCOMPRA.CodAuditoriaRef AS CodAuditoriaRef,
			#FONDOS_sInversiones.NRCNV as FondoBancoValoresId,
			AGENTES.NumeroAgente as NumAgente,
			MONEDAS.CodCAFCI as MonedaGastoId,
			CHEQUESDIFCOMPRA.ImporteGastos as ImporteGastos,
			ISNULL(CHEQUESDIFCOMPRA.Importe,0) as ImporteBruto,
			CHEQUESDIF.CodCAFCI as CodCajaValoresCAFCI,
			0 as EsTransferible,
			0 as EsPrecancelable,
			'CV' as EntidadLiquidacion,
			coalesce(AGENTESAGCOLOCADORESREL.CodInterfaz,'') as CodAgenteCustodiaId,

			NULL as CodInterfazDepAdicional, 
			MONEDAS.CodCAFCI as CodCAFCIMonedaConc,
			MONEDAS.CodCAFCI as CodCAFCIMonedaGas, 
			'' as CodCAFCIMercado,
			CHEQUESDIF.Abreviatura  as AbrevChequePagare, 
			CHEQUESDIF.FechaVencimiento as FechaVencimiento,
			NULL as CodAuditoriaOperRel, 
			'CHDC' as CodTpOperacion,
			AGENTESAGCOLOCADORESREL.CodInterfaz as CodInterfazAgCus,
			dbo.fnAuditoriaFechaAlta(CHEQUESDIFCOMPRA.CodAuditoriaRef, 'CHEQUEDIFCPA'+lower(dbo.fnAuditoriaHistAccion(CHEQUESDIFCOMPRA.CodAuditoriaRef,0))) as FechaAlta, 
			dbo.fnAuditoriaFechaAlta(CHEQUESDIFCOMPRA.CodAuditoriaRef, 'CHEQUEDIFCPA'+lower(dbo.fnAuditoriaHistAccion(CHEQUESDIFCOMPRA.CodAuditoriaRef,0))) as FechaActualizacion, 
			Case 
				when #INTERFAZINVERSION.FechaConcertacion is not NULL  then #INTERFAZINVERSION.FechaConcertacion
				when #INTERFAZINVERSION.FechaConcertacion is NULL then GETDATE()
			End FechaProceso,			
			NULL as CodTpInstrumento,
			null as FechaPrecancelacion,
			AGENTESCTASBANC.CBU as CBUCtaAgente,
			AGENTES.CUIT AS CUITAgente,
			AGENTESDEPOSITARIOS.NumDepositante as NroDepositante,
			AGENTESDEPOSITARIOSIT.NumComitente as NroComitente
	FROM	#INTERFAZINVERSION
	inner join CHEQUESDIFCOMPRA 
		inner join CHEQUESDIF 
				INNER JOIN MONEDAS ON MONEDAS.CodMoneda = CHEQUESDIF.CodMoneda
				LEFT  JOIN BANCOS ON BANCOS.CodBanco = CHEQUESDIF.CodBanco
				LEFT JOIN BANCOSBCRA ON BANCOSBCRA.CodBanco = BANCOS.CodBanco AND BANCOSBCRA.CodMoneda = CHEQUESDIF.CodMoneda
		ON CHEQUESDIF.CodChequeDif = CHEQUESDIFCOMPRA.CodChequeDif
		INNER JOIN DEPOSITARIOS ON DEPOSITARIOS.CodDepositario = CHEQUESDIFCOMPRA.CodDepositario
		INNER JOIN AGENTES 
			LEFT JOIN AGENTESDEPOSITARIOS 
				LEFT JOIN AGENTESDEPOSITARIOSIT ON AGENTESDEPOSITARIOSIT.CodAgente = AGENTESDEPOSITARIOS.CodAgente
					AND AGENTESDEPOSITARIOSIT.CodAgenteDepositario = AGENTESDEPOSITARIOS.CodAgenteDepositario
			ON AGENTESDEPOSITARIOS.CodAgente = AGENTES.CodAgente 
		
			LEFT JOIN AGENTESCTASBANC ON AGENTESCTASBANC.CodAgente = AGENTES.CodAgente 
		ON AGENTES.CodAgente = CHEQUESDIFCOMPRA.CodAgente
		INNER JOIN #FONDOS_sInversiones ON #FONDOS_sInversiones.CodFondo = CHEQUESDIFCOMPRA.CodFondo
		LEFT JOIN AGENTESAGCOLOCADORESREL ON AGENTESAGCOLOCADORESREL.CodAgente = CHEQUESDIFCOMPRA.CodAgente and AGENTESAGCOLOCADORESREL.CodAgColocador = #FONDOS_sInversiones.CodAgColocadorDep

	on CHEQUESDIFCOMPRA.CodChequeDifCpa = #INTERFAZINVERSION.CodChequeDifCpa
		AND CHEQUESDIFCOMPRA.CodFondo = #INTERFAZINVERSION.CodFondo
	WHERE #INTERFAZINVERSION.CodChequeDifVta is null 
		and coalesce(AGENTESCTASBANC.CodMoneda,CHEQUESDIF.CodMoneda) = CHEQUESDIF.CodMoneda
		and coalesce(AGENTESDEPOSITARIOSIT.CodFondo,CHEQUESDIFCOMPRA.CodFondo) = CHEQUESDIFCOMPRA.CodFondo
		AND coalesce(AGENTESDEPOSITARIOS.CodDepositario, DEPOSITARIOS.CodDepositario)  = DEPOSITARIOS.CodDepositario
	UNION
	/*******************************************************************/
    --ChequesDiferidos - Venta
    /*******************************************************************/
	SELECT	'INV' AS InterfazId,
            dbo.fnAuditoriaHistAccion(CHEQUESDIFVENTA.CodAuditoriaRef,-1) AS Accion,
            CHEQUESDIFVENTA.FechaConcertacion AS FechaConcertacion,
            CHEQUESDIFVENTA.FechaLiquidacion AS FechaLiquidacion,
            CHEQUESDIFVENTA.FechaLiquidacion AS FechaContraEspecie,
            'Venta de Cheque de Pago Diferido' AS CodTpOperacionId,
            ' ' AS DebitoCredito,
            CONVERT(varchar(20), CHEQUESDIFVENTA.NumChequeDifVta) AS NumOperacion,
            #FONDOS_sInversiones.CodInterfaz AS CodFondoId,
            ISNULL(BANCOSBCRA.CodBCRA, '') AS CodAgenteId,
            DEPOSITARIOS.CodInterfaz AS CodDepositarioId,
            '' AS CodEspecieId,
            '' AS IsinCode,
            MONEDAS.CodCAFCI AS CodMonedaId,
            convert(numeric(28,10),CHEQUESDIF.Importe) AS ValorNominal,
           (ISNULL(CHEQUESDIFVENTA.Importe,0) - ISNULL(CHEQUESDIFVENTA.ImporteGastos,0)) AS ImporteNeto,
            ISNULL(CHEQUESDIFVENTA.Tasa, 0) AS Tasa,
            CONVERT(VARCHAR(12), CHEQUESDIF.NumChequeDif) AS NumOperacionRef,
			CHEQUESDIFVENTA.CodAuditoriaRef AS CodAuditoriaRef,
			#FONDOS_sInversiones.NRCNV as FondoBancoValoresId,
			AGENTES.NumeroAgente as NumAgente,
			MONEDAS.CodCAFCI as MonedaGastoId,
			CHEQUESDIFVENTA.ImporteGastos as ImporteGastos,
			ISNULL(CHEQUESDIFVENTA.Importe,0) as ImporteBruto,
			CHEQUESDIF.CodCAFCI as CodCajaValoresCAFCI,
			0 as EsTransferible,
			0 as EsPrecancelable,
			'' as EntidadLiquidacion,
			coalesce(AGENTESAGCOLOCADORESREL.CodInterfaz,'') as CodAgenteCustodiaId,

			NULL as CodInterfazDepAdicional, 
			MONEDAS.CodCAFCI as CodCAFCIMonedaConc, 
			MONEDAS.CodCAFCI  as CodCAFCIMonedaGas, 
			'' as CodCAFCIMercado,
			CHEQUESDIF.Abreviatura  as AbrevChequePagare, 
			CHEQUESDIF.FechaVencimiento as FechaVencimiento,
			NULL as CodAuditoriaOperRel, 
			'CHDV' as CodTpOperacion,
			AGENTESAGCOLOCADORESREL.CodInterfaz as CodInterfazAgCus,
			dbo.fnAuditoriaFechaAlta(CHEQUESDIFVENTA.CodAuditoriaRef, 'CHEQUEDIFVTA'+lower(dbo.fnAuditoriaHistAccion(CHEQUESDIFVENTA.CodAuditoriaRef,0))) as FechaAlta, 
			dbo.fnAuditoriaFechaAlta(CHEQUESDIFVENTA.CodAuditoriaRef, 'CHEQUEDIFVTA'+lower(dbo.fnAuditoriaHistAccion(CHEQUESDIFVENTA.CodAuditoriaRef,0))) as FechaActualizacion, 
			Case 
				when #INTERFAZINVERSION.FechaConcertacion is not NULL  then #INTERFAZINVERSION.FechaConcertacion
				when #INTERFAZINVERSION.FechaConcertacion is NULL then GETDATE()
			End FechaProceso,
			NULL as CodTpInstrumento,
			null as FechaPrecancelacion,
			null as CBUCtaAgente,
			null AS CUITAgente,
			AGENTESDEPOSITARIOS.NumDepositante as NroDepositante,
			AGENTESDEPOSITARIOSIT.NumComitente as NroComitente
	FROM	#INTERFAZINVERSION
			INNER JOIN CHEQUESDIFVENTA
				INNER JOIN CHEQUESDIFCOMPRA 
					INNER JOIN DEPOSITARIOS ON DEPOSITARIOS.CodDepositario= CHEQUESDIFCOMPRA.CodDepositario
					INNER JOIN AGENTES 
						LEFT JOIN AGENTESDEPOSITARIOS 
							LEFT JOIN AGENTESDEPOSITARIOSIT ON AGENTESDEPOSITARIOSIT.CodAgente = AGENTESDEPOSITARIOS.CodAgente
								AND AGENTESDEPOSITARIOSIT.CodAgenteDepositario = AGENTESDEPOSITARIOS.CodAgenteDepositario
						ON AGENTESDEPOSITARIOS.CodAgente = AGENTES.CodAgente 
					ON AGENTES.CodAgente = CHEQUESDIFCOMPRA.CodAgente
					ON CHEQUESDIFCOMPRA.CodFondo =  CHEQUESDIFVENTA.CodFondo
					AND CHEQUESDIFCOMPRA.CodChequeDifCpa =  CHEQUESDIFVENTA.CodChequeDifCpa
				ON CHEQUESDIFVENTA.CodChequeDifVta = #INTERFAZINVERSION.CodChequeDifVta
				AND CHEQUESDIFVENTA.CodFondo = #INTERFAZINVERSION.CodFondo
			inner join CHEQUESDIF ON CHEQUESDIF.CodChequeDif = CHEQUESDIFCOMPRA.CodChequeDif
			INNER JOIN MONEDAS ON MONEDAS.CodMoneda = CHEQUESDIF.CodMoneda
			LEFT  JOIN BANCOS ON BANCOS.CodBanco = CHEQUESDIF.CodBanco
			LEFT JOIN BANCOSBCRA ON BANCOSBCRA.CodBanco = BANCOS.CodBanco AND BANCOSBCRA.CodMoneda = CHEQUESDIF.CodMoneda
			INNER JOIN #FONDOS_sInversiones ON #FONDOS_sInversiones.CodFondo = CHEQUESDIFVENTA.CodFondo
			LEFT JOIN AGENTESAGCOLOCADORESREL ON AGENTESAGCOLOCADORESREL.CodAgente = AGENTES.CodAgente and AGENTESAGCOLOCADORESREL.CodAgColocador = #FONDOS_sInversiones.CodAgColocadorDep
	WHERE not #INTERFAZINVERSION.CodChequeDifVta is null 
		and coalesce(AGENTESDEPOSITARIOSIT.CodFondo,CHEQUESDIFVENTA.CodFondo) = CHEQUESDIFVENTA.CodFondo
		AND coalesce(AGENTESDEPOSITARIOS.CodDepositario, DEPOSITARIOS.CodDepositario)  = DEPOSITARIOS.CodDepositario
GO



DECLARE     @FechaDesde							Fecha='2021-09-01'
DECLARE     @FechaHasta							Fecha='2021-09-02'
DECLARE 	@IDFondo							CodigoInterfaz=NULL
DECLARE     @IDTipoValorCuotaParte				CodigoInterfaz=NULL
DECLARE 	@TimeStamp							TimeStamp=NULL
DECLARE 	@NumeroCuotapartista				DescripcionLarga=NULL
DECLARE 	@CodInterfazCuotapartista			DescripcionLarga=NULL
DECLARE 	@NumeroAgColocadores				DescripcionLarga=NULL
DECLARE 	@CodInterfazAgColocadores			DescripcionLarga=NULL
DECLARE 	@CodInterfazCuotapartistaSetting	DescripcionExtraLarga = '9309,9433,9434,9438,9457,9470,9497,9504,9508,2239,9597, 9605,9618, 9697,9738, 9761,9777,'


CREATE TABLE #CUOTAPARTISTAS_TMP
(
    CodCuotapartista NUMERIC(15),
    CodTpCuotapartista NUMERIC(15)
)


--	Filtro de Setting de Agente y de Cuotapartista vienen en @NumeroAgColocadores y @@CodInterfazCuotapartistaSetting
--	Son todos los cuotapartistas de ese agente mas los cuotapartistas específicos

--	IDCuotapartista o Num Cuotapartista: @CodInterfazCuotapartista o @NumeroCuotapartista Es el filtro del Request y debería filtrar la consulta final siempre y cuando esté en el universo antes filtrado.

DECLARE @CodCuotapartistaRequest numeric(15)=NULL

IF (@NumeroCuotapartista ='-1')
		SELECT @NumeroCuotapartista=NULL


IF (@CodInterfazCuotapartistaSetting IS NULL AND @NumeroAgColocadores IS NULL) 
		BEGIN
    INSERT INTO #CUOTAPARTISTAS_TMP
    SELECT CodCuotapartista, CodTpCuotapartista
    FROM CUOTAPARTISTAS
END
	ELSE
	BEGIN

    --Meto todos los Cuotapartistas del Agente Colocador
    IF (@NumeroAgColocadores IS NOT NULL)
		BEGIN
        INSERT INTO #CUOTAPARTISTAS_TMP
        SELECT CodCuotapartista, CodTpCuotapartista
        FROM CUOTAPARTISTAS
            INNER JOIN AGCOLOCADORES ON CUOTAPARTISTAS.CodAgColocadorOfCta=AGCOLOCADORES.CodAgColocador
        WHERE  AGCOLOCADORES.NumAgColocador IN (SELECT CAST(Valor AS numeric(15))
        FROM fn_Split(@NumeroAgColocadores, ','))
    END

    --Meto todos los Cuotapartistas del setting que no existan
    IF (@CodInterfazCuotapartistaSetting IS NOT NULL)
		BEGIN
        INSERT INTO #CUOTAPARTISTAS_TMP
        SELECT CodCuotapartista, CodTpCuotapartista
        FROM CUOTAPARTISTAS
        WHERE  CUOTAPARTISTAS.CodInterfaz IN (SELECT CAST(Valor AS varchar(30))
            FROM fn_Split(@CodInterfazCuotapartistaSetting, ','))
            AND CodCuotapartista NOT IN (SELECT CodCuotapartista
            FROM #CUOTAPARTISTAS_TMP)
    END
END

--Si me viene el IDCuotapartista por request, busco el NumCuotapartista
IF (@CodInterfazCuotapartista IS NOT NULL)
	BEGIN
    SELECT @CodCuotapartistaRequest= CodCuotapartista
    FROM CUOTAPARTISTAS
    WHERE  CUOTAPARTISTAS.CodInterfaz IN (SELECT CAST(Valor AS varchar(30))
    FROM fn_Split(@CodInterfazCuotapartista, ','))

    IF @CodCuotapartistaRequest IS NULL
				SELECT @CodCuotapartistaRequest=-404
END

IF (@NumeroCuotapartista IS NOT NULL)
	BEGIN
    SELECT @CodCuotapartistaRequest= CodCuotapartista
    FROM CUOTAPARTISTAS
    WHERE  CUOTAPARTISTAS.NumCuotapartista IN (SELECT CAST(Valor AS varchar(30))
    FROM fn_Split(@NumeroCuotapartista, ','))

    IF @CodCuotapartistaRequest IS NULL
			SELECT @CodCuotapartistaRequest=-404
END

IF @CodCuotapartistaRequest IS NOT NULL
	BEGIN
    --Busco el CPT pero no lo encontro, elimino todos
    IF @CodCuotapartistaRequest=-404
		BEGIN
        DELETE #CUOTAPARTISTAS_TMP
    END
		ELSE
		--Lo encontró entonces elimino todos menos este
		BEGIN
        DELETE #CUOTAPARTISTAS_TMP
			WHERE CodCuotapartista NOT IN (@CodCuotapartistaRequest)
    END
END



DECLARE @CodFondo CodigoMedio = NULL
IF @IDFondo IS NOT NULL 
		SET @CodFondo = (SELECT CodFondo
FROM FONDOSREAL
WHERE UPPER(CodInterfaz) = UPPER(@IDFondo))


CREATE TABLE #TEMP_LIQ
(
    CodLiquidacion NUMERIC(15),
    ID NUMERIC(9),
    IDTIPO VARCHAR(2),
    CodInterfaz NUMERIC(15),
    LiquidacionNumero NUMERIC(15),
    LiquidacionNumeroAdicional NUMERIC(15),
    LiquidacionNumeroReferencia NUMERIC(15),
    FechaConcertacion Date,
    FechaLiquidacion Date,
    FechaFraccion Date,
    CodCuotapartista NUMERIC(15),
    CodFondo NUMERIC(5),
    CodAgColocador NUMERIC(5),
    CodSucursal NUMERIC(5),
    CodTpValorCp NUMERIC(3),
    CodCondicionIngEgr NUMERIC(5),
    CodTpLiquidacion VARCHAR(2),
    CodMoneda NUMERIC(5),
    CodCuotapartistaCtaOrden NUMERIC(15),
    OficialCuentaID VARCHAR(30),
    OficialCuentaDescripcion VARCHAR(100),
    CanalVentaID VARCHAR(15),
    CanalVentaDescripcion VARCHAR(200),
    VCPValor DECIMAL(19, 10),
    FondoIDRelacionado VARCHAR(15),
    FondoNumeroRelacionado NUMERIC(6),
    FondoNombreRelacionado VARCHAR(80),
    TipoVCPIDRelacionado VARCHAR(15),
    TipoVCPAbreviaturaRelacionado VARCHAR(30),
    TipoVCPDescripcionRelacionado VARCHAR(80),
    CuotapartistaIDRelacionado VARCHAR(15),
    CuotapartistaNumeroRelacionado NUMERIC(15),
    CuotapartistaNombreRelacionado VARCHAR(50),
    TipoCuotapartistaID VARCHAR(15),
    LiquidacionSolicitud NUMERIC(15),
    Importe DECIMAL(21, 2),
    ImporteGasto DECIMAL(21, 2),
    SOLSUCImporte DECIMAL(21, 2),
    Cuotapartes DECIMAL(22, 8),
    SolCodInterfaz VARCHAR(30),
    SOLSUCCodMoneda NUMERIC(5),
    MONREEXPCodInterfaz VARCHAR(15),
    MONREEXPSimbolo VARCHAR(6),
    MONREEXPDescripcion VARCHAR(80),
    [TimeStamp] BIGINT
)

INSERT INTO #TEMP_LIQ
SELECT
    LIQUIDACIONES.CodLiquidacion			
			, SOLRESC.CodSolResc AS ID	
			, LIQUIDACIONES.CodTpLiquidacion AS IDTIPO 
			, LIQUIDACIONES.CodInterfaz
			, LIQUIDACIONES.NumLiquidacion AS LiquidacionNumero
			, LIQUIDACIONES.NumLiquidacionAdicional AS LiquidacionNumeroAdicional
			, LIQUIDACIONES.NumReferencia AS LiquidacionNumeroReferencia
			, LIQUIDACIONES.FechaConcertacion
			, LIQUIDACIONES.FechaLiquidacion
			, LIQUIDACIONES.FechaFraccion
			, LIQUIDACIONES.CodCuotapartista
			, LIQUIDACIONES.CodFondo
			, LIQUIDACIONES.CodAgColocador
			, LIQUIDACIONES.CodSucursal
			, LIQUIDACIONES.CodTpValorCp
			, LIQUIDACIONES.CodCondicionIngEgr
			, LIQUIDACIONES.CodTpLiquidacion
			, LIQUIDACIONES.CodMoneda
			, LIQUIDACIONES.CodCuotapartistaCtaOrden
			, OFICIALESCTA.CodInterfaz AS OficialCuentaID
			, OFICIALESCTA.Nombre + '' + OFICIALESCTA.Apellido AS OficialCuentaDescripcion
			, CANALESVTA.CodInterfaz AS CanalVentaID
			, CANALESVTA.Descripcion AS CanalVentaDescripcion
			, VALORESCP.ValorCuotaparte AS VCPValor
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, TPCUOTAPARTISTA.CodInterfaz
			, SOLRESC.NumSolicitud
			, LIQUIDACIONES.Importe
			, LIQUIDACIONES.ImporteGasto
			, NULL
			, LIQUIDACIONES.CantCuotapartes
			, SOLRESC.CodInterfaz
			, SOLRESC.CodMoneda
			, MONREEXP.CodInterfaz
			, MONREEXP.Simbolo
			, MONREEXP.Descripcion
			, CAST (LIQUIDACIONES.TimeStamp AS BIGINT)
FROM LIQUIDACIONES
    inner JOIN SOLRESC ON SOLRESC.CodFondo = LIQUIDACIONES.CodFondo
        AND SOLRESC.CodAgColocador = LIQUIDACIONES.CodAgColocador
        AND SOLRESC.CodSucursal = LIQUIDACIONES.CodSucursal
        AND SOLRESC.CodSolResc = LIQUIDACIONES.CodSolResc
        AND SOLRESC.EstaAnulado = 0
    INNER JOIN #CUOTAPARTISTAS_TMP ON #CUOTAPARTISTAS_TMP.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
    LEFT JOIN VALORESCPREEXP ON VALORESCPREEXP.CodFondo = LIQUIDACIONES.CodFondo
        AND VALORESCPREEXP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
        AND VALORESCPREEXP.Fecha = LIQUIDACIONES.FechaConcertacion
        AND VALORESCPREEXP.CodMoneda = SOLRESC.CodMoneda
    LEFT JOIN MONEDAS MONREEXP ON MONREEXP.CodMoneda = VALORESCPREEXP.CodMoneda
    LEFT JOIN TPCUOTAPARTISTA ON #CUOTAPARTISTAS_TMP.CodTpCuotapartista = TPCUOTAPARTISTA.CodTpCuotapartista
    LEFT JOIN OFICIALESCTA ON OFICIALESCTA.CodAgColocador = LIQUIDACIONES.CodAgColocador
        AND OFICIALESCTA.CodSucursal = LIQUIDACIONES.CodSucursal
        AND LIQUIDACIONES.CodOficialCta = OFICIALESCTA.CodOficialCta
    LEFT JOIN CANALESVTA ON CANALESVTA.CodCanalVta = LIQUIDACIONES.CodCanalVta
    LEFT JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo
        AND VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
        AND datediff(d, VALORESCP.Fecha, LIQUIDACIONES.FechaConcertacion) = 0
WHERE LIQUIDACIONES.CodTpLiquidacion = 'RE'
    AND LIQUIDACIONES.EstaAnulado = 0
    AND (@CodFondo IS NULL OR LIQUIDACIONES.CodFondo = @CodFondo)
    AND (@TimeStamp IS NULL OR LIQUIDACIONES.TimeStamp > @TimeStamp)
    AND ((@FechaDesde IS NULL AND @FechaHasta IS NULL) OR LIQUIDACIONES.FechaConcertacion >= @FechaDesde AND LIQUIDACIONES.FechaConcertacion <= @FechaHasta)


INSERT INTO #TEMP_LIQ
SELECT
    LIQUIDACIONES.CodLiquidacion			
			, SOLSUSC.CodSolSusc AS ID	
			, LIQUIDACIONES.CodTpLiquidacion AS IDTIPO 
			, LIQUIDACIONES.CodInterfaz
			, LIQUIDACIONES.NumLiquidacion AS LiquidacionNumero
			, LIQUIDACIONES.NumLiquidacionAdicional AS LiquidacionNumeroAdicional
			, LIQUIDACIONES.NumReferencia AS LiquidacionNumeroReferencia
			, LIQUIDACIONES.FechaConcertacion
			, LIQUIDACIONES.FechaLiquidacion
			, LIQUIDACIONES.FechaFraccion
			, LIQUIDACIONES.CodCuotapartista
			, LIQUIDACIONES.CodFondo
			, LIQUIDACIONES.CodAgColocador
			, LIQUIDACIONES.CodSucursal
			, LIQUIDACIONES.CodTpValorCp
			, LIQUIDACIONES.CodCondicionIngEgr
			, LIQUIDACIONES.CodTpLiquidacion
			, LIQUIDACIONES.CodMoneda
			, LIQUIDACIONES.CodCuotapartistaCtaOrden
			, OFICIALESCTA.CodInterfaz AS OficialCuentaID
			, OFICIALESCTA.Nombre + '' + OFICIALESCTA.Apellido AS OficialCuentaDescripcion
			, CANALESVTA.CodInterfaz AS CanalVentaID
			, CANALESVTA.Descripcion AS CanalVentaDescripcion
			, VALORESCP.ValorCuotaparte AS VCPValor
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, TPCUOTAPARTISTA.CodInterfaz
			, SOLSUSC.NumSolicitud
			, LIQUIDACIONES.Importe
			, LIQUIDACIONES.ImporteGasto
			, SOLSUSC.Importe
			, LIQUIDACIONES.CantCuotapartes
			, SOLSUSC.CodInterfaz
			, SOLSUSC.CodMoneda
			, MONREEXP.CodInterfaz
			, MONREEXP.Simbolo
			, MONREEXP.Descripcion
			, CAST (LIQUIDACIONES.TimeStamp AS BIGINT)
FROM LIQUIDACIONES
    inner JOIN SOLSUSC ON SOLSUSC.CodFondo = LIQUIDACIONES.CodFondo
        AND SOLSUSC.CodAgColocador = LIQUIDACIONES.CodAgColocador
        AND SOLSUSC.CodSucursal = LIQUIDACIONES.CodSucursal
        AND SOLSUSC.CodSolSusc = LIQUIDACIONES.CodSolSusc
        AND SOLSUSC.EstaAnulado = 0
    INNER JOIN #CUOTAPARTISTAS_TMP ON #CUOTAPARTISTAS_TMP.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
    LEFT JOIN VALORESCPREEXP ON VALORESCPREEXP.CodFondo = LIQUIDACIONES.CodFondo
        AND VALORESCPREEXP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
        AND VALORESCPREEXP.Fecha = LIQUIDACIONES.FechaConcertacion
        AND VALORESCPREEXP.CodMoneda = SOLSUSC.CodMoneda
    LEFT JOIN MONEDAS MONREEXP ON MONREEXP.CodMoneda = VALORESCPREEXP.CodMoneda
    LEFT JOIN TPCUOTAPARTISTA ON #CUOTAPARTISTAS_TMP.CodTpCuotapartista = TPCUOTAPARTISTA.CodTpCuotapartista
    LEFT JOIN OFICIALESCTA ON OFICIALESCTA.CodAgColocador = LIQUIDACIONES.CodAgColocador
        AND OFICIALESCTA.CodSucursal = LIQUIDACIONES.CodSucursal
        AND LIQUIDACIONES.CodOficialCta = OFICIALESCTA.CodOficialCta
    LEFT JOIN CANALESVTA ON CANALESVTA.CodCanalVta = LIQUIDACIONES.CodCanalVta
    LEFT JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo
        AND VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
        AND datediff(d, VALORESCP.Fecha, LIQUIDACIONES.FechaConcertacion) = 0
WHERE LIQUIDACIONES.CodTpLiquidacion = 'SU'
    AND LIQUIDACIONES.EstaAnulado = 0
    AND (@CodFondo IS NULL OR LIQUIDACIONES.CodFondo = @CodFondo)
    AND (@TimeStamp IS NULL OR LIQUIDACIONES.TimeStamp > @TimeStamp)
    AND ((@FechaDesde IS NULL AND @FechaHasta IS NULL) OR LIQUIDACIONES.FechaConcertacion >= @FechaDesde AND LIQUIDACIONES.FechaConcertacion <= @FechaHasta)

INSERT INTO #TEMP_LIQ
SELECT
    LIQUIDACIONES.CodLiquidacion			
			, SOLTRANSFERENCIA.CodSolTransferencia AS ID	
			, LIQUIDACIONES.CodTpLiquidacion AS IDTIPO 
			, LIQUIDACIONES.CodInterfaz
			, LIQUIDACIONES.NumLiquidacion AS LiquidacionNumero
			, LIQUIDACIONES.NumLiquidacionAdicional AS LiquidacionNumeroAdicional
			, LIQUIDACIONES.NumReferencia AS LiquidacionNumeroReferencia
			, LIQUIDACIONES.FechaConcertacion
			, LIQUIDACIONES.FechaLiquidacion
			, LIQUIDACIONES.FechaFraccion
			, LIQUIDACIONES.CodCuotapartista
			, LIQUIDACIONES.CodFondo
			, LIQUIDACIONES.CodAgColocador
			, LIQUIDACIONES.CodSucursal
			, LIQUIDACIONES.CodTpValorCp
			, LIQUIDACIONES.CodCondicionIngEgr
			, LIQUIDACIONES.CodTpLiquidacion
			, LIQUIDACIONES.CodMoneda
			, LIQUIDACIONES.CodCuotapartistaCtaOrden
			, OFICIALESCTA.CodInterfaz AS OficialCuentaID
			, OFICIALESCTA.Nombre + '' + OFICIALESCTA.Apellido AS OficialCuentaDescripcion
			, CANALESVTA.CodInterfaz AS CanalVentaID
			, CANALESVTA.Descripcion AS CanalVentaDescripcion
			, VALORESCP.ValorCuotaparte AS VCPValor
			, FDOTRANSF.CodInterfaz AS FondoIDRelacionado
			, FDOTRANSF.NumFondo AS FondoNumeroRelacionado
			, FDOTRANSF.Nombre AS FondoNombreRelacionado
			, TPVCPTRANSF.CodInterfaz AS TipoVCPIDRelacionado
			, TPVCPTRANSF.Abreviatura AS TipoVCPAbreviaturaRelacionado
			, TPVCPTRANSF.Descripcion AS TipoVCPDescripcionRelacionado
			, CPTTRANSF.CodInterfaz AS CuotapartistaIDRelacionado
			, CPTTRANSF.NumCuotapartista AS CuotapartistaNumeroRelacionado
			, CPTTRANSF.Nombre AS CuotapartistaNombreRelacionado
			, TPCUOTAPARTISTA.CodInterfaz
			, SOLTRANSFERENCIA.NumSolicitud
			, LIQUIDACIONES.Importe
			, LIQUIDACIONES.ImporteGasto
			, NULL
			, LIQUIDACIONES.CantCuotapartes
			, SOLTRANSFERENCIA.CodInterfaz
			, FDOTRANSF.CodMoneda
			, NULL
			, NULL
			, NULL
			, CAST (LIQUIDACIONES.TimeStamp AS BIGINT)
FROM LIQUIDACIONES
    inner JOIN SOLTRANSFERENCIA ON SOLTRANSFERENCIA.CodFondo = LIQUIDACIONES.CodFondo
        AND SOLTRANSFERENCIA.CodAgColocador = LIQUIDACIONES.CodAgColocador
        AND SOLTRANSFERENCIA.CodSucursal = LIQUIDACIONES.CodSucursal
        AND SOLTRANSFERENCIA.CodSolTransferencia = LIQUIDACIONES.CodSolTransferencia
        AND SOLTRANSFERENCIA.EstaAnulado = 0
    INNER JOIN #CUOTAPARTISTAS_TMP ON #CUOTAPARTISTAS_TMP.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
    LEFT JOIN TPCUOTAPARTISTA ON #CUOTAPARTISTAS_TMP.CodTpCuotapartista = TPCUOTAPARTISTA.CodTpCuotapartista
    LEFT JOIN OFICIALESCTA ON OFICIALESCTA.CodAgColocador = LIQUIDACIONES.CodAgColocador
        AND OFICIALESCTA.CodSucursal = LIQUIDACIONES.CodSucursal
        AND LIQUIDACIONES.CodOficialCta = OFICIALESCTA.CodOficialCta
    LEFT JOIN CANALESVTA ON CANALESVTA.CodCanalVta = LIQUIDACIONES.CodCanalVta
    LEFT JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo
        AND VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
        AND datediff(d, VALORESCP.Fecha, LIQUIDACIONES.FechaConcertacion) = 0
    INNER JOIN FONDOSREAL FDOTRANSF ON FDOTRANSF.CodFondo = LIQUIDACIONES.CodFondo
    INNER JOIN TPVALORESCP TPVCPTRANSF ON TPVCPTRANSF.CodFondo = LIQUIDACIONES.CodFondo
        AND TPVCPTRANSF.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
    LEFT JOIN CUOTAPARTISTAS CPTTRANSF ON CPTTRANSF.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
WHERE LIQUIDACIONES.CodTpLiquidacion = 'TR'
    AND LIQUIDACIONES.EstaAnulado = 0
    AND (@CodFondo IS NULL OR LIQUIDACIONES.CodFondo = @CodFondo)
    AND (@TimeStamp IS NULL OR LIQUIDACIONES.TimeStamp > @TimeStamp)
    AND ((@FechaDesde IS NULL AND @FechaHasta IS NULL) OR LIQUIDACIONES.FechaConcertacion >= @FechaDesde AND LIQUIDACIONES.FechaConcertacion <= @FechaHasta)

IF(@CodInterfazCuotapartistaSetting IS NOT NULL) 
		BEGIN

    DELETE #TEMP_LIQ
			WHERE SolCodInterfaz NOT LIKE '%ACSA%'

END


if (@FechaDesde IS NULL AND @FechaHasta IS NULL) begin
    set rowcount 10
end

SELECT
    #TEMP_LIQ.CodLiquidacion
		, #TEMP_LIQ.ID
		, #TEMP_LIQ.IDTIPO
		, CUOTAPARTISTAS.CodInterfaz      AS CuotapartistaID
		, CUOTAPARTISTAS.NumCuotapartista AS CuotapartistaNumero
		, CUOTAPARTISTAS.NumCustodia      AS CuotapartistaNumeroCustodia
		, CUOTAPARTISTAS.Nombre           AS CuotapartistaNombre
		, #TEMP_LIQ.TipoCuotapartistaID
		, AGCOLOCADORES.CodAgColocador	 AS CodAgColocador
		, AGCOLOCADORES.CodInterfaz       AS AgenteColocadorID
		, AGCOLOCADORES.NumAgColocador    AS AgenteColocadorNumero
		, AGCOLOCADORES.Descripcion       AS AgenteColocadorDescripcion
		, SUCURSALES.CodInterfaz          AS SucursalID
		, SUCURSALES.NumSucursal          AS SucursalNumero
		, SUCURSALES.Descripcion          AS SucursalDescripcion
		, FONDOS.CodInterfaz              AS FondoID
		, FONDOS.NumFondo                 AS FondoNumero
		, FONDOS.Nombre                   AS FondoNombre
		, TPVALORESCP.CodInterfaz		 AS TipoVCPID
		, TPVALORESCP.Abreviatura		 AS TipoVCPAbreviatura
		, TPVALORESCP.Descripcion		 AS TipoVCPDescripcion
		, CONDICIONESINGEGR.CodInterfaz	 AS CondicionIngresoEgresoID
		, CONDICIONESINGEGR.Descripcion	 AS CondicionIngresoEgresoDescripcion
		, #TEMP_LIQ.OficialCuentaID
		, #TEMP_LIQ.OficialCuentaDescripcion
		, #TEMP_LIQ.CanalVentaID
		, #TEMP_LIQ.CanalVentaDescripcion
		, TPLIQUIDACION.CodInterfaz		 AS LiquidacionTipoID
		, TPLIQUIDACION.Descripcion		 AS LiquidacionTipo
		, #TEMP_LIQ.LiquidacionNumero
		, #TEMP_LIQ.LiquidacionNumeroAdicional
		, #TEMP_LIQ.LiquidacionNumeroReferencia
		, #TEMP_LIQ.LiquidacionSolicitud
		, #TEMP_LIQ.FechaConcertacion
		, #TEMP_LIQ.FechaLiquidacion
		, #TEMP_LIQ.FechaFraccion
		, MONEDAS.CodInterfaz			 AS MonedaID
		, MONEDAS.Simbolo				 AS MonedaSimbolo
		, MONEDAS.Descripcion			 AS MonedaDescripcion
		, CASE TPLIQUIDACION.SignoPositivo WHEN -1 THEN #TEMP_LIQ.Importe - ISNULL(#TEMP_LIQ.ImporteGasto, 0) ELSE #TEMP_LIQ.Importe END AS ImporteNeto
		, CASE TPLIQUIDACION.SignoPositivo WHEN -1 THEN #TEMP_LIQ.Importe ELSE #TEMP_LIQ.Importe + ISNULL(#TEMP_LIQ.ImporteGasto, 0) END AS ImporteBruto
		, CASE WHEN #TEMP_LIQ.CodTpLiquidacion = 'SU' THEN 
			#TEMP_LIQ.SOLSUCImporte 
		 ELSE 
			(#TEMP_LIQ.Importe - ISNULL(#TEMP_LIQ.ImporteGasto, 0))
		 END AS ImporteSolicitud
		, CASE TPLIQUIDACION.CodTpLiquidacion WHEN 'SU' THEN ISNULL(#TEMP_LIQ.SOLSUCImporte, 0) - (ISNULL(#TEMP_LIQ.Importe, 0) - ISNULL(#TEMP_LIQ.ImporteGasto, 0)) END AS Fraccion
		, ISNULL(#TEMP_LIQ.ImporteGasto, 0) AS Gastos
		, #TEMP_LIQ.Cuotapartes
		, #TEMP_LIQ.VCPValor
		, CASE WHEN COALESCE(#TEMP_LIQ.SOLSUCCodMoneda, FONDOS.CodMoneda) <> FONDOS.CodMoneda THEN #TEMP_LIQ.MONREEXPCodInterfaz END AS TpVCPReexID
		, CASE WHEN COALESCE(#TEMP_LIQ.SOLSUCCodMoneda, FONDOS.CodMoneda) <> FONDOS.CodMoneda THEN #TEMP_LIQ.MONREEXPSimbolo END AS TpVCPReexSimbolo
		, CASE WHEN COALESCE(#TEMP_LIQ.SOLSUCCodMoneda, FONDOS.CodMoneda) <> FONDOS.CodMoneda THEN #TEMP_LIQ.MONREEXPDescripcion END AS TpVCPReexDescripcion
		, #TEMP_LIQ.FondoIDRelacionado
		, #TEMP_LIQ.FondoNumeroRelacionado
		, #TEMP_LIQ.FondoNombreRelacionado
		, #TEMP_LIQ.TipoVCPIDRelacionado
		, #TEMP_LIQ.TipoVCPAbreviaturaRelacionado
		, #TEMP_LIQ.TipoVCPDescripcionRelacionado
		, #TEMP_LIQ.CuotapartistaIDRelacionado
		, #TEMP_LIQ.CuotapartistaNumeroRelacionado
		, #TEMP_LIQ.CuotapartistaNombreRelacionado
		, CPTCTAORDEN.CodInterfaz		 AS CuotapartistaCuentaOrdenID
		, CPTCTAORDEN.NumCuotapartista	 AS CuotapartistaCuentaOrdenNumero
		, CPTCTAORDEN.Nombre				 AS CuotapartistaCuentaOrdenNombre
		, CAST(#TEMP_LIQ.TimeStamp AS TimeStamp) AS [TimeStamp]
		, #TEMP_LIQ.SolCodInterfaz
		, TPVALORESCP.CodCAFCI			 AS TipoVCPIDCafci
		, CASE WHEN MONEDAS.CodInterfazAdicional NOT IN ('ARS','USD') THEN CASE WHEN MONEDAS.CodISO NOT IN ('ARS','USD') THEN MONEDAS.CodCAFCI ELSE MONEDAS.CodISO END ELSE MONEDAS.CodInterfazAdicional END  AS MonedaIDAdicional
--NO REQUERIDOS
--,#TEMP_LIQ.CodInterfaz
--,#TEMP_LIQ.CodCuotapartista
--,#TEMP_LIQ.CodFondo
--,#TEMP_LIQ.CodSucursal
--,#TEMP_LIQ.CodTpValorCp
--,#TEMP_LIQ.CodCondicionIngEgr
--,#TEMP_LIQ.CodTpLiquidacion
--,#TEMP_LIQ.CodMoneda
--,#TEMP_LIQ.CodCuotapartistaCtaOrden
--,#TEMP_LIQ.Importe
--,#TEMP_LIQ.SOLSUCImporte
FROM #TEMP_LIQ
    INNER JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista = #TEMP_LIQ.CodCuotapartista
    INNER JOIN FONDOSREAL FONDOS ON FONDOS.CodFondo = #TEMP_LIQ.CodFondo
    INNER JOIN AGCOLOCADORES ON  AGCOLOCADORES.CodAgColocador = #TEMP_LIQ.CodAgColocador
    INNER JOIN SUCURSALES ON SUCURSALES.CodAgColocador  = #TEMP_LIQ.CodAgColocador
        AND SUCURSALES.CodSucursal = #TEMP_LIQ.CodSucursal
    INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = #TEMP_LIQ.CodFondo
        AND TPVALORESCP.CodTpValorCp = #TEMP_LIQ.CodTpValorCp
    INNER JOIN CONDICIONESINGEGR ON CONDICIONESINGEGR.CodFondo = #TEMP_LIQ.CodFondo
        AND CONDICIONESINGEGR.CodCondicionIngEgr = #TEMP_LIQ.CodCondicionIngEgr
    INNER JOIN TPLIQUIDACION ON TPLIQUIDACION.CodTpLiquidacion = #TEMP_LIQ.CodTpLiquidacion COLLATE SQL_Latin1_General_CP1_CS_AS
    INNER JOIN MONEDAS ON MONEDAS.CodMoneda = #TEMP_LIQ.CodMoneda
    LEFT JOIN CUOTAPARTISTAS CPTCTAORDEN ON CPTCTAORDEN.CodCuotapartista = #TEMP_LIQ.CodCuotapartistaCtaOrden
WHERE (@IDTipoValorCuotaParte IS NULL OR TPVALORESCP.CodInterfaz = @IDTipoValorCuotaParte)
    AND (@CodCuotapartistaRequest  IS NULL OR #TEMP_LIQ.CodCuotapartista  = @CodCuotapartistaRequest)
ORDER BY FechaConcertacion desc, CodLiquidacion desc

set rowcount 0

DROP TABLE #CUOTAPARTISTAS_TMP
DROP TABLE #TEMP_LIQ
GO


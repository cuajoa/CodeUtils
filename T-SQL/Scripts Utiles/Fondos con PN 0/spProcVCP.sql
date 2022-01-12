EXEC sp_CreateProcedure 'dbo.spProcVCP'
GO 

ALTER PROCEDURE dbo.spProcVCP
    @CodFondo         CodigoMedio = NULL,
    @FechaProceso     Fecha = NULL,
    @ErrorDescripcion TextoCorto = NULL OUTPUT
WITH ENCRYPTION
AS
    SET NOCOUNT ON 

    DECLARE @ImporteIVA               Importe
    DECLARE @CodTpCuotaparte          CodigoTextoMedio
    DECLARE @CodMonedaFdo           CodigoMedio
    DECLARE @Retorno				Integer

    SELECT @CodTpCuotaparte = CodTpCuotaparte, @CodMonedaFdo = CodMoneda
    FROM FONDOS
    WHERE CodFondo = @CodFondo

    -------------- 
    exec spProcVCP_Calculo @CodFondo, @CodMonedaFdo, @CodTpCuotaparte, @FechaProceso
    --------------  
  
    DELETE #PROC_GENVCP
    WHERE ValorCuotaparte / ABS(ValorCuotaparte) = -1
      AND CodFondo = @CodFondo 

    -- CALCULO LAS CUOTAPARTES A DEVOLVER
    UPDATE #COMISIONESMNT_GENVCP 
        SET CantCuotaparteDev = (ImporteDevCom + ImporteDevIVA + ImporteDevImpCom) / #PROC_GENVCP.ValorCuotaparte
    FROM #PROC_GENVCP
    INNER JOIN #COMISIONESMNT_GENVCP ON #COMISIONESMNT_GENVCP.CodFondo = #PROC_GENVCP.CodFondo 
                                    AND #COMISIONESMNT_GENVCP.CodTpValorCp = #PROC_GENVCP.CodTpValorCp
    WHERE #PROC_GENVCP.CodFondo = @CodFondo
		
    INSERT #PROVISIONES_GENVCP (CodFondo ,CodTpValorCp ,Tipo ,Importe ,ImporteMinimo ,ValorCuotaparte ,CantCuotapartes)
    SELECT #COMISIONESMNT_GENVCP.CodFondo, #COMISIONESMNT_GENVCP.CodTpValorCp, 'VCPLIQ', 0.00, 0.00,
           CONVERT(NUMERIC(22,10),(PatrimonioNeto + SUM(ImporteDevCom + ImporteDevIVA + ImporteDevImpCom)))
           / CONVERT(NUMERIC(22,10),(CuotapartesCirculacion + SUM(CantCuotaparteDev)))
           ,NULL
    FROM #COMISIONESMNT_GENVCP
    INNER JOIN #PROC_GENVCP ON #PROC_GENVCP.CodFondo = #COMISIONESMNT_GENVCP.CodFondo AND #PROC_GENVCP.CodTpValorCp = #COMISIONESMNT_GENVCP.CodTpValorCp
    WHERE #COMISIONESMNT_GENVCP.CodFondo = @CodFondo
    GROUP BY #COMISIONESMNT_GENVCP.CodFondo, #COMISIONESMNT_GENVCP.CodTpValorCp, #PROC_GENVCP.PatrimonioNeto, #PROC_GENVCP.CuotapartesCirculacion

    INSERT #PROVISIONES_GENVCP (CodFondo, CodTpValorCp, Tipo, CantCuotapartes)
    SELECT @CodFondo, CodTpValorCp, 'DCCC', SUM(CantCuotaparteDev)
    FROM #COMISIONESMNT_GENVCP
    WHERE CodFondo = @CodFondo
    GROUP BY CodFondo ,CodTpValorCp 
    
    exec spProcVCP_Reexpresion @CodFondo, @FechaProceso
	
	exec spProcVCP_MovLiqGlobales @CodFondo, @CodMonedaFdo

    UPDATE #PROVISIONES_GENVCP 
		SET ValorCuotaparte = dbo.fnRedondeoVCP(CodFondo, ValorCuotaparte)
    WHERE CodFondo = @CodFondo 
      AND Tipo = 'VCPLIQ'    
   
    DECLARE @NombreCorto AbreviaturaLarga
    IF EXISTS (SELECT * FROM #MOVLIQGLOBALES_GENVCP WHERE (CantidadCuotapartes is null OR Importe IS NULL) and CodFondo = @CodFondo)
    BEGIN
        SELECT @NombreCorto = NombreCorto from FONDOS WHERE CodFondo = @CodFondo 
        SELECT @ErrorDescripcion = 'No se pueden calcular las liquidaciones globales del fondo \b''' +  @NombreCorto + ''' \b0. '
        SELECT @Retorno = 0
    END
    ELSE
    BEGIN
        SELECT @Retorno = -1
	END
	
    RETURN @Retorno
	SET NOCOUNT OFF
GO


EXEC sp_CreateProcedure 'dbo.spProcVCP_Reexpresion'
GO 

ALTER PROCEDURE dbo.spProcVCP_Reexpresion
    @CodFondo     CodigoMedio = NULL,
    @FechaProceso Fecha = NULL
WITH ENCRYPTION
AS

    SET NOCOUNT ON

    DECLARE @Coeficiente Precio
    DECLARE @CodMoneda CodigoMedio
    DECLARE @ValorCuotaparte Precio
    DECLARE @ValorCuotaparteAnt  Precio
    DECLARE @CodTpValorCp CodigoCorto
    DECLARE @CodFondoMon CodigoLargo
	DECLARE @EsAnticipado Boolean
	DECLARE @FechaCotizacion Fecha
	
	SELECT @EsAnticipado = (CASE WHEN GeneraVCPAnticip = -1 AND TieneVCPAnticip = 0 THEN -1 
								WHEN GeneraVCPAnticip = 0 AND TieneVCPAnticip = 0 THEN 0
								WHEN GeneraVCPAnticip = -1 AND TieneVCPAnticip = -1 THEN 0 END)
	FROM #VALORCP_FONDOS
	WHERE CodFondo = @CodFondo
	
	IF @EsAnticipado = 0
	BEGIN
		set @FechaCotizacion = @FechaProceso
	END
	ELSE
	begin
		select @FechaCotizacion = FechaUltVCP
		from #VALORCP_FONDOS
		WHERE CodFondo = @CodFondo
	end
		
    DELETE #PROC_GENVCPREEXP
    WHERE CodFondo = @CodFondo

    INSERT #PROC_GENVCPREEXP
        (CodFondoMon, CodFondo, CodTpValorCp, CodMoneda, TpValorCp, ValorCuotaparteOrig, FechaAnterior)
    SELECT FONDOSMON.CodFondoMon, FONDOSMON.CodFondo, FONDOSMON.CodTpValorCp, FONDOSMON.CodMoneda
        ,dbo.fnReexpresionDescripcion(@CodFondo, FONDOSMON.CodTpValorCp, FONDOSMON.CodFondoMon)
        ,#PROC_GENVCP.ValorCuotaparte  , #PROC_GENVCP.FechaAnterior
    FROM FONDOSMON 
    INNER JOIN #PROC_GENVCP ON #PROC_GENVCP.CodFondo = FONDOSMON.CodFondo
        AND #PROC_GENVCP.CodTpValorCp = FONDOSMON.CodTpValorCp
    WHERE FONDOSMON.CodFondo = @CodFondo 
        And  FONDOSMON.FechaDesde <= @FechaProceso and (FONDOSMON.FechaHasta >= @FechaProceso or FONDOSMON.FechaHasta IS NULL)
        AND FONDOSMON.EstaAnulado = 0

    UPDATE #PROC_GENVCPREEXP 
        SET ValorCuotaparteAnt = VALORESCPREEXP.ValorCuotaparte 
    FROM #PROC_GENVCPREEXP
    INNER JOIN VALORESCPREEXP ON #PROC_GENVCPREEXP.CodFondo = VALORESCPREEXP.CodFondo  
		AND #PROC_GENVCPREEXP.CodTpValorCp = VALORESCPREEXP.CodTpValorCp    
		AND #PROC_GENVCPREEXP.CodFondoMon = VALORESCPREEXP.CodFondoMon    
		AND #PROC_GENVCPREEXP.CodMoneda = VALORESCPREEXP.CodMoneda    
		AND VALORESCPREEXP.Fecha = #PROC_GENVCPREEXP.FechaAnterior
    WHERE #PROC_GENVCPREEXP.CodFondo = @CodFondo

    DECLARE cursor_mon  CURSOR FOR 
        SELECT DISTINCT CodMoneda FROM #PROC_GENVCPREEXP WHERE CodFondo = @CodFondo

    open cursor_mon

    FETCH NEXT FROM cursor_mon INTO @CodMoneda

    WHILE @@FETCH_STATUS = 0 
    BEGIN

        exec spXCalcularFactorConvReexp @CodFondo, @CodMoneda, @FechaCotizacion , @Coeficiente OUTPUT
		
        UPDATE #PROC_GENVCPREEXP
            SET FactorConversion = @Coeficiente
        WHERE @CodMoneda = CodMoneda and CodFondo = @CodFondo

        FETCH NEXT FROM cursor_mon INTO @CodMoneda

    END
    
    close cursor_mon
    deallocate cursor_mon


    UPDATE #PROC_GENVCPREEXP
        SET ValorCuotaparte = ValorCuotaparteOrig * FactorConversion
    WHERE CodFondo = @CodFondo

    DECLARE cursor_vcp CURSOR FOR 
        select CodTpValorCp, CodMoneda, CodFondoMon, ValorCuotaparte, ValorCuotaparteAnt
        FROM #PROC_GENVCPREEXP
        WHERE CodFondo = @CodFondo
            AND NOT ValorCuotaparte IS NULL

    open cursor_vcp

    FETCH NEXT FROM cursor_vcp INTO @CodTpValorCp, @CodMoneda, @CodFondoMon, @ValorCuotaparte, @ValorCuotaparteAnt

    WHILE @@FETCH_STATUS = 0 
    BEGIN

        EXEC spXRedondeoVCP @CodFondo, @ValorCuotaparte, @ValorCuotaparte OUTPUT

        UPDATE #PROC_GENVCPREEXP
            SET ValorCuotaparte = @ValorCuotaparte,
                ValorCuotaparteVar =  dbo.fnCalcularVariacion (@ValorCuotaparte ,  @ValorCuotaparteAnt, -1) 
        WHERE @CodMoneda = CodMoneda and CodFondo = @CodFondo
            and @CodTpValorCp = CodTpValorCp and @CodFondoMon = CodFondoMon

        FETCH NEXT FROM cursor_vcp INTO @CodTpValorCp, @CodMoneda, @CodFondoMon, @ValorCuotaparte, @ValorCuotaparteAnt

    END
    
    UPDATE #PROC_GENVCPREEXP
		SET TNA = dbo.fnCalcularTNA( @FechaProceso,  FechaAnterior, ValorCuotaparteVar) 
    WHERE CodFondo = @CodFondo    
        
    
    close cursor_vcp
    deallocate cursor_vcp

    UPDATE #VALORCP_FONDOS
        SET Observacion = 'Falta ingresar la cotización para reexpresar el fondo a ' + MONEDAS.Descripcion + '.'
            ,TieneError = -1
    from #VALORCP_FONDOS
    INNER JOIN #PROC_GENVCPREEXP 
        INNER JOIN MONEDAS on MONEDAS.CodMoneda = #PROC_GENVCPREEXP.CodMoneda 
    ON #PROC_GENVCPREEXP.CodFondo = #VALORCP_FONDOS.CodFondo
    where #VALORCP_FONDOS.CodFondo =  @CodFondo and TieneError = 0
        AND #PROC_GENVCPREEXP.FactorConversion IS NULL

    SET NOCOUNT OFF
    
GO



EXEC sp_CreateProcedure 'dbo.spProcVCP_MovLiqGlobales'
GO 

ALTER PROCEDURE dbo.spProcVCP_MovLiqGlobales
    @CodFondo         CodigoMedio = NULL,
    @CodMonedaFdo     CodigoMedio = NULL
WITH ENCRYPTION
AS
    SET NOCOUNT ON 
	
    UPDATE #MOVLIQGLOBALES_GENVCP
        set Importe = ABS(CantidadCuotapartes) * #PROC_GENVCP.ValorCuotaparte
            ,CantidadCuotapartes  = ABS(CantidadCuotapartes) * -1
            ,FactConvMovFdo = 1
    FROM #MOVLIQGLOBALES_GENVCP
    INNER JOIN #PROC_GENVCP ON #MOVLIQGLOBALES_GENVCP.CodFondo = #PROC_GENVCP.CodFondo
        AND #MOVLIQGLOBALES_GENVCP.CodTpValorCp = #PROC_GENVCP.CodTpValorCp
    WHERE #MOVLIQGLOBALES_GENVCP.CodTpMovLiqGlobal in ( 'RE') 
        AND #MOVLIQGLOBALES_GENVCP.CodFondo = @CodFondo
        and #MOVLIQGLOBALES_GENVCP.CodMoneda = @CodMonedaFdo

    UPDATE #MOVLIQGLOBALES_GENVCP
        set Importe = ABS(CantidadCuotapartes) * #PROC_GENVCPREEXP.ValorCuotaparte
            ,CantidadCuotapartes  = ABS(CantidadCuotapartes) * -1
            ,FactConvMovFdo = 1/ #PROC_GENVCPREEXP.FactorConversion
    FROM #MOVLIQGLOBALES_GENVCP
    INNER JOIN #PROC_GENVCPREEXP ON #MOVLIQGLOBALES_GENVCP.CodFondo = #PROC_GENVCPREEXP.CodFondo
        AND #MOVLIQGLOBALES_GENVCP.CodTpValorCp = #PROC_GENVCPREEXP.CodTpValorCp
        AND #MOVLIQGLOBALES_GENVCP.CodMoneda = #PROC_GENVCPREEXP.CodMoneda
    WHERE #MOVLIQGLOBALES_GENVCP.CodTpMovLiqGlobal in ( 'RE') 
        AND #MOVLIQGLOBALES_GENVCP.CodFondo = @CodFondo
        and #MOVLIQGLOBALES_GENVCP.CodMoneda <> @CodMonedaFdo

    DECLARE @ADJRNU  CantidadCuotapartes 

    SELECT @ADJRNU = dbo.fnParamFdoADJRNU(@CodFondo)

	IF @ADJRNU <> 0 
	BEGIN

        UPDATE #MOVLIQGLOBALES_GENVCP
            set CantidadCuotapartes = ROUND((#MOVLIQGLOBALES_GENVCP.Importe / #PROC_GENVCP.ValorCuotaparte) / @ADJRNU,0) * @ADJRNU
                ,FactConvMovFdo = 1
        FROM #MOVLIQGLOBALES_GENVCP
        INNER JOIN #PROC_GENVCP ON #MOVLIQGLOBALES_GENVCP.CodFondo = #PROC_GENVCP.CodFondo
            AND #MOVLIQGLOBALES_GENVCP.CodTpValorCp = #PROC_GENVCP.CodTpValorCp
        WHERE #MOVLIQGLOBALES_GENVCP.CodTpMovLiqGlobal in ( 'SU', 'SUINV') 
            AND #MOVLIQGLOBALES_GENVCP.CodFondo = @CodFondo
            and #MOVLIQGLOBALES_GENVCP.CodMoneda = @CodMonedaFdo

        UPDATE #MOVLIQGLOBALES_GENVCP
            set CantidadCuotapartes = ROUND((#MOVLIQGLOBALES_GENVCP.Importe / #PROC_GENVCPREEXP.ValorCuotaparte) / @ADJRNU,0) * @ADJRNU
                ,FactConvMovFdo = convert(float, 1) / convert(float, #PROC_GENVCPREEXP.FactorConversion)
        FROM #MOVLIQGLOBALES_GENVCP
        INNER JOIN #PROC_GENVCPREEXP ON #MOVLIQGLOBALES_GENVCP.CodFondo = #PROC_GENVCPREEXP.CodFondo
            AND #MOVLIQGLOBALES_GENVCP.CodTpValorCp = #PROC_GENVCPREEXP.CodTpValorCp
            AND #MOVLIQGLOBALES_GENVCP.CodMoneda = #PROC_GENVCPREEXP.CodMoneda
        WHERE #MOVLIQGLOBALES_GENVCP.CodTpMovLiqGlobal in ( 'SU', 'SUINV') 
            AND #MOVLIQGLOBALES_GENVCP.CodFondo = @CodFondo
            and #MOVLIQGLOBALES_GENVCP.CodMoneda <> @CodMonedaFdo

    END 
    ELSE
    BEGIN
        UPDATE #MOVLIQGLOBALES_GENVCP
            set CantidadCuotapartes = ROUND((#MOVLIQGLOBALES_GENVCP.Importe / #PROC_GENVCP.ValorCuotaparte),0) 
                ,FactConvMovFdo = 1
        FROM #MOVLIQGLOBALES_GENVCP
        INNER JOIN #PROC_GENVCP ON #MOVLIQGLOBALES_GENVCP.CodFondo = #PROC_GENVCP.CodFondo
            AND #MOVLIQGLOBALES_GENVCP.CodTpValorCp = #PROC_GENVCP.CodTpValorCp
        WHERE #MOVLIQGLOBALES_GENVCP.CodTpMovLiqGlobal in ( 'SU', 'SUINV') 
            AND #MOVLIQGLOBALES_GENVCP.CodFondo = @CodFondo
            and #MOVLIQGLOBALES_GENVCP.CodMoneda = @CodMonedaFdo

        UPDATE #MOVLIQGLOBALES_GENVCP
            set CantidadCuotapartes = ROUND(((#MOVLIQGLOBALES_GENVCP.Importe / convert(float, #PROC_GENVCPREEXP.FactorConversion)) / #PROC_GENVCPREEXP.ValorCuotaparte),0)
                ,FactConvMovFdo = convert(float, 1) / convert(float, #PROC_GENVCPREEXP.FactorConversion)
        FROM #MOVLIQGLOBALES_GENVCP
        INNER JOIN #PROC_GENVCPREEXP ON #MOVLIQGLOBALES_GENVCP.CodFondo = #PROC_GENVCPREEXP.CodFondo
            AND #MOVLIQGLOBALES_GENVCP.CodTpValorCp = #PROC_GENVCPREEXP.CodTpValorCp
            AND #MOVLIQGLOBALES_GENVCP.CodMoneda = #PROC_GENVCPREEXP.CodMoneda
        WHERE #MOVLIQGLOBALES_GENVCP.CodTpMovLiqGlobal in ( 'SU', 'SUINV') 
            AND #MOVLIQGLOBALES_GENVCP.CodFondo = @CodFondo
            and #MOVLIQGLOBALES_GENVCP.CodMoneda <> @CodMonedaFdo
    END

	UPDATE #MOVLIQGLOBALES_GENVCP
		set Fraccion = Importe - (#MOVLIQGLOBALES_GENVCP.CantidadCuotapartes * #PROC_GENVCP.ValorCuotaparte) 
	FROM #MOVLIQGLOBALES_GENVCP
	INNER JOIN #PROC_GENVCP ON #MOVLIQGLOBALES_GENVCP.CodFondo = #PROC_GENVCP.CodFondo
		AND #MOVLIQGLOBALES_GENVCP.CodTpValorCp = #PROC_GENVCP.CodTpValorCp
	WHERE #MOVLIQGLOBALES_GENVCP.CodTpMovLiqGlobal in ( 'SU', 'SUINV') 
        AND #MOVLIQGLOBALES_GENVCP.CodFondo = @CodFondo
        and #MOVLIQGLOBALES_GENVCP.CodMoneda = @CodMonedaFdo

	UPDATE #MOVLIQGLOBALES_GENVCP
		set Fraccion = Importe - (#MOVLIQGLOBALES_GENVCP.CantidadCuotapartes * #PROC_GENVCPREEXP.ValorCuotaparte) 
	FROM #MOVLIQGLOBALES_GENVCP
        INNER JOIN #PROC_GENVCPREEXP ON #MOVLIQGLOBALES_GENVCP.CodFondo = #PROC_GENVCPREEXP.CodFondo
            AND #MOVLIQGLOBALES_GENVCP.CodTpValorCp = #PROC_GENVCPREEXP.CodTpValorCp
            AND #MOVLIQGLOBALES_GENVCP.CodMoneda = #PROC_GENVCPREEXP.CodMoneda
	WHERE #MOVLIQGLOBALES_GENVCP.CodTpMovLiqGlobal in ( 'SU', 'SUINV') 
        AND #MOVLIQGLOBALES_GENVCP.CodFondo = @CodFondo
        and #MOVLIQGLOBALES_GENVCP.CodMoneda <> @CodMonedaFdo

	UPDATE #MOVLIQGLOBALES_GENVCP
		set Fraccion = 0
	where Fraccion is null


    SET NOCOUNT OFF
    
GO



EXEC sp_CreateProcedure 'dbo.spProcVCP_Calculo'
GO 

ALTER PROCEDURE dbo.spProcVCP_Calculo
    @CodFondo         CodigoMedio = NULL,
    @CodMonedaFdo     CodigoMedio = NULL,
    @CodTpCuotaparte  CodigoTextoMedio = NULL,
    @FechaProceso     Fecha = NULL
WITH ENCRYPTION
AS
    SET NOCOUNT ON 
      
    DECLARE @CodTpValorCp             CodigoCorto
    DECLARE @VCP                      Numeric(28,16)      
	DECLARE @CantidadCuotapartes      CantidadCuotapartes 
	DECLARE @Patrimonio               Importe             
	DECLARE @PatrimonioNetoOperativo  Importe
	DECLARE @PatrimonioNetoContable   Importe
    DECLARE @ValorCuotaparteAnt		  Precio
	DECLARE @Variacion				  Precio
    DECLARE @FactorDiario             Precio	
	DECLARE @CantidadCuotapartesTotal CantidadCuotapartes 
	DECLARE @PatrimonioTotal          Importe             
	DECLARE @FechaAnt			      Fecha
	DECLARE @VARPAT					  Boolean
    
    SELECT @CodTpValorCp = 0, @VCP = 0.00000000, @CantidadCuotapartes = 0.00000000, @Patrimonio = 0.00000000
	
	select @VARPAT = ValorParametro
	from PARAMETROS 
	WHERE CodParametro = 'VARPAT'
	
    DELETE #PROC_GENVCP
    WHERE ValorCuotaparte / abs(ValorCuotaparte) = -1
      and CodFondo = @CodFondo 

    UPDATE #PROC_GENVCP 
		SET FechaAnterior = (SELECT MAX(Fecha) FROM VALORESCP VALORESCP2
                                             WHERE VALORESCP2.CodFondo = @CodFondo 
                                               AND VALORESCP2.CodTpValorCp = #PROC_GENVCP.CodTpValorCp 
                                               AND VALORESCP2.Fecha < @FechaProceso)
    WHERE CodFondo = @CodFondo

    UPDATE #PROC_GENVCP 
		SET ValorCuotaparteAnt = (SELECT ValorCuotaparte FROM VALORESCP 
					WHERE #PROC_GENVCP.CodFondo = VALORESCP.CodFondo  
						AND #PROC_GENVCP.CodTpValorCp = VALORESCP.CodTpValorCp    
						AND VALORESCP.Fecha = #PROC_GENVCP.FechaAnterior)
    WHERE CodFondo = @CodFondo
        
    WHILE EXISTS (SELECT CodFondo FROM #PROC_GENVCP 
            WHERE #PROC_GENVCP.ValorCuotaparte IS NULL 
              AND #PROC_GENVCP.CodFondo = @CodFondo) 
	BEGIN
		
        SELECT @Patrimonio = PatrimonioNeto, @CantidadCuotapartes = CuotapartesCirculacion, 
               @CodTpValorCp = CodTpValorCp, @ValorCuotaparteAnt = ValorCuotaparteAnt,
               @Variacion = VarPatrimonial
        FROM #PROC_GENVCP
        WHERE #PROC_GENVCP.ValorCuotaparte IS NULL 
          AND #PROC_GENVCP.CodFondo = @CodFondo        
        ORDER BY FactorDiario DESC
        
        IF @CantidadCuotapartes > 0 AND NOT (@CodTpCuotaparte = 'MONMAR') AND @Patrimonio > 0
        BEGIN
            SELECT @VCP = @Patrimonio / @CantidadCuotapartes
        END
        ELSE BEGIN
			IF @CodTpCuotaparte = 'MLON' 
			BEGIN
				SELECT @FactorDiario = FactorDiario 
				FROM #PROC_GENVCP
				WHERE #PROC_GENVCP.CodTpValorCp = @CodTpValorCp and CodFondo = @CodFondo
     
				IF @FactorDiario = 1 
				BEGIN
					SELECT @CantidadCuotapartesTotal = SUM(CuotapartesCirculacion * FactorDiario),
						   @PatrimonioTotal = SUM(PatrimonioNeto)
					FROM #PROC_GENVCP
					WHERE CodFondo = @CodFondo

					SELECT @VCP = @PatrimonioTotal / @CantidadCuotapartesTotal

                END
                ELSE 
                BEGIN

					SELECT @VCP = CONVERT(Numeric(28,16), @FactorDiario * ValorCuotaparte)
        			FROM #PROC_GENVCP
					WHERE FactorDiario = 1 AND CodFondo = @CodFondo 
        
					if @VCP = 0 
					begin
						SELECT @CantidadCuotapartesTotal = SUM(CuotapartesCirculacion * FactorDiario),
						   @PatrimonioTotal = SUM(PatrimonioNeto)
						FROM #PROC_GENVCP
						WHERE CodFondo = @CodFondo
						
						SET @VCP = @PatrimonioTotal / @CantidadCuotapartesTotal		
					end
                END
            END
            ELSE 
            BEGIN
				SELECT @FechaAnt = MAX(Fecha)
				FROM VALORESCP 
				WHERE CodFondo = @CodFondo AND CodTpValorCp = @CodTpValorCp 
				
				IF @FechaAnt IS NULL
				BEGIN
                    SELECT @VCP = ValorCpInicial
                    FROM TPVALORESCP 
                    WHERE CodFondo = @CodFondo AND CodTpValorCp = @CodTpValorCp 

				END
				ELSE
				BEGIN
                    IF @CodTpCuotaparte = 'MONMAR' 
                    BEGIN
                    
					    SELECT @Variacion = dbo.fnCalcularVariacion (@Patrimonio , PatrimonioNeto, -1)
                        FROM VALORESCP 
                        WHERE CodFondo = @CodFondo AND CodTpValorCp = @CodTpValorCp and @FechaAnt = Fecha
    			
                        SET @VCP = @ValorCuotaparteAnt * (1 + @Variacion / 100)
                    END
                    ELSE 
                    BEGIN
								
                        SELECT @VCP = ValorCuotaparte
                        FROM VALORESCP 
                        WHERE CodFondo = @CodFondo AND CodTpValorCp = @CodTpValorCp and Fecha = @FechaAnt
                        
                        IF @VARPAT = -1
                        BEGIN
							SELECT @VCP = @VCP * (1 + @Variacion / 100)
                        END
                        
                    END
				
				END
				
            END

            IF @CantidadCuotapartes = 0.00000000 AND @FechaProceso = dbo.fnTraerFechaInicioTpVCP(@CodFondo, @CodTpValorCp )
            BEGIN
                SET @VCP = dbo.fnTraerValorCpInicialTpVCP(@CodFondo, @CodTpValorCp )
                SET @Patrimonio = 0
            END
        END


        UPDATE #PROC_GENVCP 
            SET ValorCuotaparte = dbo.fnRedondeoVCP(@CodFondo, @VCP) 
                ,PatrimonioNeto = coalesce(@Patrimonio,0)
                ,CuotapartesCirculacion = coalesce(CuotapartesCirculacion,0)
                ,PatrimonioNetoProv = coalesce(PatrimonioNetoProv,0)
        WHERE CodFondo = @CodFondo AND CodTpValorCp = @CodTpValorCp

        SELECT @CodTpValorCp = @CodTpValorCp + 1
    END

	declare @ADJRNU Boolean
	declare @ADJRAR Boolean
	select @ADJRNU = dbo.fnParamFdoADJRNU(@CodFondo)
	select @ADJRAR = dbo.fnParamFdoADJRAR(@CodFondo)

	IF @ADJRNU <> 0 
	BEGIN

		UPDATE #PROC_GENVCP
			SET CuotapartesCirculacionDiv = ROUND(((ImporteDiv / ValorCuotaparte) / @ADJRNU),0,1)     * @ADJRNU
		where not COALESCE(ImporteDiv,0) = 0
	END
    ELSE 
	BEGIN
		UPDATE #PROC_GENVCP
			SET CuotapartesCirculacionDiv = ImporteDiv / ValorCuotaparte
		where not COALESCE(ImporteDiv,0) = 0
	END
    
    UPDATE #PROC_GENVCP
		SET ValorCuotaparteVar = dbo.fnCalcularVariacion(ValorCuotaparte ,  ValorCuotaparteAnt, -1) 
    WHERE CodFondo = @CodFondo

    UPDATE #PROC_GENVCP
		SET TIR = dbo.fnCalcularTIR( @FechaProceso,  FechaAnterior, ValorCuotaparteVar) 
    WHERE CodFondo = @CodFondo    

    UPDATE #PROC_GENVCP
		SET TNA = dbo.fnCalcularTNA( @FechaProceso,  FechaAnterior, TIR) 
    WHERE CodFondo = @CodFondo    
    
    select @PatrimonioNetoOperativo = SUM(PatrimonioNeto) 
    from #PROC_GENVCP 
    WHERE CodFondo = @CodFondo 

    SELECT @PatrimonioNetoContable = SUM(Importe)
    FROM #VCPIT_GENVCP    
    WHERE CodFondo = @CodFondo AND RubroID in ('PA', 'AC')
        
    update #VALORCP_FONDOS
	    set PatrimonioNetoContable = @PatrimonioNetoContable
	        ,PatrimonioNetoOperativo = @PatrimonioNetoOperativo
	WHERE CodFondo = @CodFondo
	
    update #VALORCP_FONDOS
	    set Diferencia = @PatrimonioNetoOperativo - @PatrimonioNetoContable 
	        ,MaximaDiferencia = dbo.fnParametroMDIFI()
	WHERE CodFondo = @CodFondo	
	
	
	if dbo.fnParametroMDIFH() = -1
	BEGIN
	    IF dbo.fnParametroMDIFI() < ABS(@PatrimonioNetoOperativo - @PatrimonioNetoContable)
	    BEGIN 
	        UPDATE #VALORCP_FONDOS
	            Set Observacion = COALESCE(Observacion, '') + ' \\ Existe una diferencia entre el PN Contable-Operativo de ' + MONEDAS.Simbolo + ' '+ ltrim(rtrim(CONVERT(VARCHAR(45),(ABS(@PatrimonioNetoOperativo - @PatrimonioNetoContable))))) + '. El Máximo Configurado es de ' + MONEDAS.Simbolo  + ' ' + LTRIM(RTRIM(convert(Varchar(45), dbo.fnParametroMDIFI()))) + '. '
                    ,Warning = -1
            from  #VALORCP_FONDOS   
            inner join MONEDAS ON MONEDAS.CodMoneda = #VALORCP_FONDOS.CodMoneda 
	        WHERE CodFondo = @CodFondo
	    END
	END
	SET NOCOUNT OFF
    
GO


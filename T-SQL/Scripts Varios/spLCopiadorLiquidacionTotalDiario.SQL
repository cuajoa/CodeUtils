EXEC sp_CreateProcedure 'dbo.spLCopiadorLiquidacionTotalDiario' 
GO 

ALTER PROCEDURE dbo.spLCopiadorLiquidacionTotalDiario
	@CodFondo  CodigoMedio,
	@Fecha     Fecha,
	@Copiador  CodigoTextoCorto = 'SU'
WITH ENCRYPTION
AS
    DECLARE @CantidadFilas numeric(20)

    IF @Copiador = 'SU' BEGIN
        SELECT @CantidadFilas = COUNT(*) 
    	FROM LIQUIDACIONES 
        INNER JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo
            AND VALORESCP.Fecha = COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)
            AND VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
        WHERE LIQUIDACIONES.CodFondo = @CodFondo
            AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
            AND LIQUIDACIONES.EstaAnulado = 0
            AND LIQUIDACIONES.CodTpLiquidacion in ('SM','SU', 'SR', 'BS','PC')

    END
    ELSE BEGIN
        SELECT @CantidadFilas = COUNT(*)         
        FROM LIQUIDACIONES 
        INNER JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo
            AND VALORESCP.Fecha = COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)
            AND VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
        WHERE LIQUIDACIONES.CodFondo=@CodFondo
            AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
            AND LIQUIDACIONES.EstaAnulado = 0
            AND LIQUIDACIONES.CodTpLiquidacion in ('RM','RE', 'RR', 'BR','NC')

    END

       
    IF @Copiador = 'SU' BEGIN     
        IF @CantidadFilas <> 0 BEGIN
            SELECT ' ' AS 'blanco| '
                ,'Total Diario ' + (CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN	
                                        TPVALORESCP.Descripcion
                                    ELSE
            		''
                                    END) AS 'TotalDiario| '       
                ,SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS '[NUM]MontoSuscripto| '
                ,SUM(COALESCE(LIQUIDACIONES.ImporteGasto,0)) AS '[NUM]ImporteGasto| '
                ,SUM(COALESCE(ABS(LIQUIDACIONES.CantCuotapartes),0)) AS '[NUM]CantCuotapartes| '
                ,SUM(COALESCE(LIQUIDACIONES.Fraccion,0)) AS '[NUM]Fraccion| '
                ,' ' AS 'blanco2| '                  
                ,' ' AS 'blanco3| ' 
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo 
                AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp        
                AND LIQUIDACIONES.CodTpLiquidacion IN ('SU','SM', 'SR','PC')
                AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
                AND LIQUIDACIONES.EstaAnulado = 0
            WHERE TPVALORESCP.CodFondo = @CodFondo
			and TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte
            UNION ALL
            SELECT ' ' AS 'blanco| '
                ,'Total Diario Mov. de Baja ' + (CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN	
                                        TPVALORESCP.Descripcion
                                    ELSE
            		''
                                    END) AS 'TotalDiario| '       
                ,SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS '[NUM]MontoSuscripto| '
                ,SUM(COALESCE(LIQUIDACIONES.ImporteGasto,0)) AS '[NUM]ImporteGasto| '
                ,SUM(COALESCE(ABS(LIQUIDACIONES.CantCuotapartes),0)) AS '[NUM]CantCuotapartes| '
                ,SUM(COALESCE(LIQUIDACIONES.Fraccion,0)) AS '[NUM]Fraccion| '
                ,' ' AS 'blanco2| '                  
                ,' ' AS 'blanco3| '                  
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo 
                AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp        
                AND LIQUIDACIONES.CodTpLiquidacion IN ('BS')
                AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
                AND LIQUIDACIONES.EstaAnulado = 0
            WHERE TPVALORESCP.CodFondo = @CodFondo AND FONDOS.CodTpCuotaparte IN ('MVPGLO')
			and TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte
            ORDER BY 'TotalDiario| '

        END
        ELSE BEGIN
            SELECT ' '   AS 'blanco| '
                ,'Total Diario ' + 
                (CASE WHEN CodTpCuotaparte <> 'UN' THEN  	
                    TPVALORESCP.Descripcion
                ELSE
            	    ''
                END)  AS 'TotalDiario| '       
                ,0 		AS '[NUM]MontoSuscripto| '
                ,0      AS '[NUM]ImporteGasto| '
                ,0		AS '[NUM]CantCuotapartes| '
                ,0 		AS '[NUM]Fraccion| '         
                ,' ' AS 'blanco2| '                          
                ,' ' AS 'blanco3| '                          
            FROM TPVALORESCP
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo 
            WHERE TPVALORESCP.CodFondo = @CodFondo 
			and TPVALORESCP.FechaInicio <= @Fecha
            ORDER BY TPVALORESCP.Descripcion
        END
    END
    ELSE BEGIN
        IF @CantidadFilas <> 0 BEGIN
            
            SELECT ' ' AS 'blanco| '
                ,'Total Diario ' + 
                ( CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN	
                    TPVALORESCP.Descripcion
                ELSE
                    ''
                END) AS 'TotalDiario| '       
                ,SUM(COALESCE(ABS(LIQUIDACIONES.CantCuotapartes),0)) AS '[NUM]CantCuotapartes| '
                ,SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS '[NUM]Importe| '
                ,' ' AS 'blanco2| '                  
                ,SUM(COALESCE(ImporteGasto+ImporteGastoCD,0)) AS '[NUM]Comision| '
                ,' ' AS 'blanco3| '                  
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo        
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo AND	
                TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp AND    
                LIQUIDACIONES.EstaAnulado = 0 AND    
                LIQUIDACIONES.CodTpLiquidacion IN ('RE','RM', 'RR','NC')
                AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
            WHERE TPVALORESCP.CodFondo = @CodFondo
			and TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte, FONDOS.EsAbierto
            UNION ALL
            SELECT ' ' AS 'blanco| '
                ,'Total Diario Mov. de Baja' + 
                ( CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN	
                    TPVALORESCP.Descripcion
                ELSE
                    ''
                END) AS 'TotalDiario| '       
                ,SUM(COALESCE(ABS(LIQUIDACIONES.CantCuotapartes),0)) AS '[NUM]CantCuotapartes| '
                ,SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS '[NUM]Importe| '
                ,' ' AS 'blanco2| '                  
                ,SUM(COALESCE(ImporteGasto+ImporteGastoCD,0)) AS '[NUM]Comision| '
                ,' ' AS 'blanco3| '                  
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo        
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo AND	
                TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp AND    
                LIQUIDACIONES.EstaAnulado = 0 AND    
                LIQUIDACIONES.CodTpLiquidacion IN ('BR')
                AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
            WHERE TPVALORESCP.CodFondo = @CodFondo AND FONDOS.CodTpCuotaparte IN ('MVPGLO')
			and TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte, FONDOS.EsAbierto
            ORDER BY 'TotalDiario| '
            
        END
        ELSE BEGIN
            SELECT ' ' 		AS 'blanco| '
                ,'Total Diario ' + 
                (CASE WHEN CodTpCuotaparte <> 'UN' THEN  	
		            TPVALORESCP.Descripcion
                ELSE
				    ''
                 END)  AS 'TotalDiario| '       
                ,0 AS '[NUM]CantCuotapartes| '
                ,0 AS '[NUM]Importe| '
                ,' ' AS 'blanco2| '                  
                ,0 AS '[NUM]Comision| '
                ,' ' AS 'blanco3| '                  
            FROM TPVALORESCP
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo 
            WHERE TPVALORESCP.CodFondo = @CodFondo 
			and TPVALORESCP.FechaInicio <= @Fecha
            ORDER BY TPVALORESCP.Descripcion
        END
    END	          

    RETURN @@ROWCOUNT

GO

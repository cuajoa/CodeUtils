EXEC sp_CreateProcedure 'dbo.spLCopiadorLiquidacionTotalDiarioNET' 
GO 

ALTER PROCEDURE dbo.spLCopiadorLiquidacionTotalDiarioNET
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
            SELECT --' ' AS 'blanco| ',
                (CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN	
															TPVALORESCP.Descripcion
													ELSE
														''
													END) AS 'TotalDiario'       
                ,SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS 'MontoSuscripto'
                ,SUM(COALESCE(LIQUIDACIONES.ImporteGasto,0)) AS 'ImporteGasto'
                ,SUM(COALESCE(ABS(LIQUIDACIONES.CantCuotapartes),0)) AS 'CantidadCuotaPartes'
                ,SUM(COALESCE(LIQUIDACIONES.Fraccion,0)) AS 'Fraccion'
                --,' ' AS 'blanco2| '                  
                --,' ' AS 'blanco3| ' 
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo 
                AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp        
                AND LIQUIDACIONES.CodTpLiquidacion IN ('SU','SM', 'SR','PC')
                AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
                AND LIQUIDACIONES.EstaAnulado = 0
            WHERE TPVALORESCP.CodFondo = @CodFondo
			AND TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte
            UNION ALL
            SELECT --' ' AS 'blanco| ',
				(CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN	
                    TPVALORESCP.Descripcion
                ELSE
            		''
                END) AS 'TotalDiario'       
                ,SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS 'MontoSuscripto'
                ,SUM(COALESCE(LIQUIDACIONES.ImporteGasto,0)) AS 'ImporteGasto'
                ,SUM(COALESCE(ABS(LIQUIDACIONES.CantCuotapartes),0)) AS 'CantidadCuotaPartes'
                ,SUM(COALESCE(LIQUIDACIONES.Fraccion,0)) AS 'Fraccion'
                --,' ' AS 'blanco2| '                  
                --,' ' AS 'blanco3| '                  
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo 
                AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp        
                AND LIQUIDACIONES.CodTpLiquidacion IN ('BS')
                AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
                AND LIQUIDACIONES.EstaAnulado = 0
            WHERE TPVALORESCP.CodFondo = @CodFondo AND FONDOS.CodTpCuotaparte IN ('MVPGLO')
			AND TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte
            ORDER BY 'TotalDiario'

        END
        ELSE BEGIN
            SELECT --' '   AS 'blanco| ',
                (CASE WHEN CodTpCuotaparte <> 'UN' THEN  	
                    TPVALORESCP.Descripcion
                ELSE
            	    ''
                END)  AS 'TotalDiario'       
                ,0 		AS 'MontoSuscripto'
                ,0      AS 'ImporteGasto'
                ,0		AS 'CantidadCuotaPartes'
                ,0 		AS 'Fraccion'         
                --,' ' AS 'blanco2| '                          
                --,' ' AS 'blanco3| '                          
            FROM TPVALORESCP
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo 
            WHERE TPVALORESCP.CodFondo = @CodFondo 
			AND TPVALORESCP.FechaInicio <= @Fecha
            ORDER BY TPVALORESCP.Descripcion
        END
    END
    ELSE BEGIN
        IF @CantidadFilas <> 0 BEGIN
            
            SELECT --' ' AS 'blanco| ',
                ( CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN	
                    TPVALORESCP.Descripcion
				ELSE
					''
				END) AS 'TotalDiario'       
                ,SUM(COALESCE(ABS(LIQUIDACIONES.CantCuotapartes),0)) AS 'CantidadCuotaPartes'
                ,SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS 'Importe'
                --,' ' AS 'blanco2| '                  
                ,SUM(COALESCE(ImporteGasto+ImporteGastoCD,0)) AS 'Comision'
                --,' ' AS 'blanco3| '                  
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo        
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo AND	
                TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp AND    
                LIQUIDACIONES.EstaAnulado = 0 AND    
                LIQUIDACIONES.CodTpLiquidacion IN ('RE','RM', 'RR','NC')
                AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
            WHERE TPVALORESCP.CodFondo = @CodFondo
			AND TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte, FONDOS.EsAbierto
            UNION ALL
            SELECT --' ' AS 'blanco| ',
                ( CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN	
                    TPVALORESCP.Descripcion
                ELSE
                    ''
                END) AS 'TotalDiario'       
                ,SUM(COALESCE(ABS(LIQUIDACIONES.CantCuotapartes),0)) AS 'CantidadCuotaPartes'
                ,SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS 'Importe'
                --,' ' AS 'blanco2| '                  
                ,SUM(COALESCE(ImporteGasto+ImporteGastoCD,0)) AS 'Comision'
                --,' ' AS 'blanco3| '                  
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo        
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo AND	
                TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp AND    
                LIQUIDACIONES.EstaAnulado = 0 AND    
                LIQUIDACIONES.CodTpLiquidacion IN ('BR')
                AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = @Fecha
            WHERE TPVALORESCP.CodFondo = @CodFondo AND FONDOS.CodTpCuotaparte IN ('MVPGLO')
			AND TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte, FONDOS.EsAbierto
            ORDER BY 'TotalDiario'
            
        END
        ELSE BEGIN
            SELECT --' ' 		AS 'blanco| ',                
                (CASE WHEN CodTpCuotaparte <> 'UN' THEN  	
		            TPVALORESCP.Descripcion
                ELSE
				    ''
                 END)  AS 'TotalDiario'       
                ,0 AS 'CantidadCuotaPartes'
                ,0 AS 'Importe'
                --,' ' AS 'blanco2| '                  
                ,0 AS 'Comision'
                --,' ' AS 'blanco3| '                  
            FROM TPVALORESCP
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo 
            WHERE TPVALORESCP.CodFondo = @CodFondo 
			AND TPVALORESCP.FechaInicio <= @Fecha
            ORDER BY TPVALORESCP.Descripcion
        END
    END	          

    RETURN @@ROWCOUNT

GO

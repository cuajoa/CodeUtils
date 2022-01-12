EXEC sp_CreateProcedure 'dbo.spLCopiadorLiquidacionTotalMesNET'
GO 

ALTER PROCEDURE dbo.spLCopiadorLiquidacionTotalMesNET
    @CodFondo  CodigoMedio,
    @Fecha     Fecha,
    @Copiador  CodigoTextoCorto = 'SU'
WITH ENCRYPTION
AS

    DECLARE @CantidadFilas numeric(20)

    IF @Copiador = 'SU' BEGIN
        SELECT @CantidadFilas = COUNT(*)
        FROM LIQUIDACIONES 
        WHERE LIQUIDACIONES.CodFondo = @CodFondo 
            AND DATEPART(mm, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(mm, @Fecha) 
            AND DATEPART(yy, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(yy, @Fecha) 
            AND LIQUIDACIONES.EstaAnulado = 0 
            AND LIQUIDACIONES.CodTpLiquidacion IN ('SU','SM','SR', 'BS','PC')

    END
    ELSE BEGIN
        SELECT @CantidadFilas = COUNT(*)
        FROM LIQUIDACIONES 
        WHERE LIQUIDACIONES.CodFondo=@CodFondo 
            AND DATEPART(mm, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(mm, @Fecha) 
            AND DATEPART(yy, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(yy, @Fecha) 
            AND LIQUIDACIONES.EstaAnulado = 0 
            AND LIQUIDACIONES.CodTpLiquidacion IN ('RM','RE','RR', 'BR','NC')
    END

    IF @Copiador = 'SU' BEGIN     
        IF @CantidadFilas <> 0 BEGIN 
            SELECT --' ' AS 'blanco| ',
                (CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN TPVALORESCP.Descripcion ELSE '' END) AS 'TotalMensual',
                SUM(COALESCE(LIQUIDACIONES.Importe,0))  AS 'MontoSuscripto',
                SUM(COALESCE(LIQUIDACIONES.ImporteGasto,0))    AS 'ImporteGasto',
                SUM(COALESCE(LIQUIDACIONES.CantCuotapartes,0))    AS 'CantidadCuotapartes',
                SUM(COALESCE(LIQUIDACIONES.Fraccion,0))     AS 'Fraccion'--,
                --' ' AS 'blanco2| '
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo 
                AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
                AND DATEPART(mm, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(mm, @Fecha) 
                AND DATEPART(yy, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(yy, @Fecha) 
                AND LIQUIDACIONES.EstaAnulado = 0 
                AND LIQUIDACIONES.CodTpLiquidacion IN ('SM','SU','SR','PC')
            WHERE TPVALORESCP.CodFondo = @CodFondo 
			AND TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte,FONDOS.EsAbierto
            UNION all
            SELECT --' ' AS 'blanco| ',
                (CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN TPVALORESCP.Descripcion ELSE '' END) AS 'TotalMensual',
                SUM(COALESCE(LIQUIDACIONES.Importe,0))  AS 'MontoSuscripto',
                SUM(COALESCE(LIQUIDACIONES.ImporteGasto,0))    AS 'ImporteGasto',
                SUM(COALESCE(ABS(LIQUIDACIONES.CantCuotapartes),0))    AS 'CantidadCuotapartes',
                SUM(COALESCE(LIQUIDACIONES.Fraccion,0))     AS 'Fraccion'--,
                --' ' AS 'blanco2| '
            FROM TPVALORESCP 
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo
            LEFT JOIN LIQUIDACIONES ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo 
                AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
                AND DATEPART(mm, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(mm, @Fecha) 
                AND DATEPART(yy, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(yy, @Fecha) 
                AND LIQUIDACIONES.EstaAnulado = 0 
                AND LIQUIDACIONES.CodTpLiquidacion IN ('BS') 
            WHERE TPVALORESCP.CodFondo = @CodFondo  AND FONDOS.CodTpCuotaparte IN ('MVPGLO')
			AND TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte,FONDOS.EsAbierto
            ORDER BY 'TotalMensual'


        END
        ELSE BEGIN
            SELECT --' ' AS 'blanco| ',
                   (CASE WHEN CodTpCuotaparte <> 'UN' THEN TPVALORESCP.Descripcion ELSE '' END) AS 'TotalMensual',
                   0 AS 'MontoSuscripto',
                   0 AS 'ImporteGasto',
                   0 AS 'CantidadCuotapartes',
                   0 AS 'Fraccion'
                   --,' ' AS 'blanco2| '
            FROM TPVALORESCP
            INNER JOIN FONDOS ON FONDOS.CodFondo = TPVALORESCP.CodFondo 
            WHERE TPVALORESCP.CodFondo = @CodFondo 
			AND TPVALORESCP.FechaInicio <= @Fecha
            ORDER BY TPVALORESCP.Descripcion
        END
    END
    ELSE BEGIN
        IF @CantidadFilas <>0 BEGIN 
            SELECT --' ' AS 'blanco| ',
                   (CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN TPVALORESCP.Descripcion else '' END) AS 'TotalMensual',
                   SUM(ABS(COALESCE(LIQUIDACIONES.CantCuotapartes,0))) AS 'CantidadCuotapartes',
                   SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS 'Importe',
                   --' ' AS 'blanco2| ',
                   SUM(COALESCE(ImporteGasto+ImporteGastoCD,0)) AS 'Comision'--,
                   --' ' AS 'blanco3| '
            FROM TPVALORESCP
            INNER JOIN FONDOS ON TPVALORESCP.CodFondo = FONDOS.CodFondo
            LEFT JOIN LIQUIDACIONES 
                INNER JOIN VALORESCP on LIQUIDACIONES.CodFondo = VALORESCP.CodFondo
                    AND LIQUIDACIONES.CodTpValorCp = VALORESCP.CodTpValorCp
                    AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = VALORESCP.Fecha
            ON LIQUIDACIONES.CodFondo = TPVALORESCP.CodFondo
                AND LIQUIDACIONES.CodTpValorCp = TPVALORESCP.CodTpValorCp
                AND DATEPART(mm, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(mm, @Fecha) 
                AND DATEPART(yy, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(yy, @Fecha) 
                AND LIQUIDACIONES.EstaAnulado = 0 
                AND LIQUIDACIONES.CodTpLiquidacion IN ('RM','RE','RR','NC')
            WHERE TPVALORESCP.CodFondo = @CodFondo 
			AND TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte,FONDOS.EsAbierto
            UNION ALL
            SELECT --' ' AS 'blanco| ',
                   (CASE WHEN FONDOS.CodTpCuotaparte <> 'UN' THEN TPVALORESCP.Descripcion else '' END) AS 'TotalMensual',
                   SUM(ABS(COALESCE(LIQUIDACIONES.CantCuotapartes,0))) AS 'CantidadCuotapartes',
                   SUM(COALESCE(LIQUIDACIONES.Importe,0)) AS 'Importe',
                   --' ' AS 'blanco2| ',
                   SUM(COALESCE(ImporteGasto+ImporteGastoCD,0)) AS 'Comision'
                   --,' ' AS 'blanco3| '
            FROM TPVALORESCP
            INNER JOIN FONDOS ON TPVALORESCP.CodFondo = FONDOS.CodFondo
            LEFT JOIN LIQUIDACIONES 
                INNER JOIN VALORESCP on LIQUIDACIONES.CodFondo = VALORESCP.CodFondo
                    AND LIQUIDACIONES.CodTpValorCp = VALORESCP.CodTpValorCp
                    AND COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion) = VALORESCP.Fecha
            ON LIQUIDACIONES.CodFondo = TPVALORESCP.CodFondo
                AND LIQUIDACIONES.CodTpValorCp = TPVALORESCP.CodTpValorCp
                AND DATEPART(mm, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(mm, @Fecha) 
                AND DATEPART(yy, COALESCE(LIQUIDACIONES.FechaIngreso, LIQUIDACIONES.FechaConcertacion)) = DATEPART(yy, @Fecha) 
                AND LIQUIDACIONES.EstaAnulado = 0 
                AND LIQUIDACIONES.CodTpLiquidacion IN ('BR')
            WHERE TPVALORESCP.CodFondo = @CodFondo  AND FONDOS.CodTpCuotaparte IN ('MVPGLO')
			AND TPVALORESCP.FechaInicio <= @Fecha
            GROUP BY TPVALORESCP.Descripcion, FONDOS.CodTpCuotaparte,FONDOS.EsAbierto
            ORDER BY 'TotalMensual'
        END
        ELSE BEGIN
            SELECT --' ' AS 'blanco| ',
                   (CASE WHEN CodTpCuotaparte <> 'UN' THEN TPVALORESCP.Descripcion ELSE '' END) AS 'TotalMensual',
                   0 AS 'CantidadCuotapartes',
                   0 AS 'Importe',
                   --' ' AS 'blanco2| ',
                   0 AS 'Comision'
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

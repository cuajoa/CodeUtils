DECLARE @Fecha smalldatetime = '20210202'
DECLARE @NumCuotapartista numeric(15)=97221

SELECT  FONDOS.CodInterfaz AS FondoID, FONDOS.NumFondo AS FondoNumero, FONDOS.Nombre AS FondoNombre, 
        TPVALORESCP.CodInterfaz  AS TipoVCPID, TPVALORESCP.Abreviatura AS TipoVCPAbreviatura, TPVALORESCP.Descripcion AS TipoVCPDescripcion, 
                        CUOTAPARTISTAS.CodInterfaz AS CuotapartistaID, CUOTAPARTISTAS.NumCuotapartista AS CuotapartistaNumero, CUOTAPARTISTAS.Nombre AS CuotapartistaNombre, 
                        SUM(LIQUIDACIONES.CantCuotapartes) AS CuotapartesTotales, ISNULL(BLOQUEOS.CuotapartesBloqueadas, 0) AS CuotapartesBloqueadas, SUM(LIQUIDACIONES.CantCuotapartes) * VALORESCP.ValorCuotaparte AS CuotapartesValuadas, 
                        VALORESCP.ValorCuotaparte AS UltimoVCPValor, MAX(VALORESCP.Fecha) AS UltimoVCPFecha,CONDICIONESINGEGR.CodInterfaz as 'IDCondicionIngEgr', 
                        MONEDASLIQ.CodInterfaz AS IDMoneda, MONEDASLIQ.Descripcion as MonedaDescripcion, MONEDASLIQ.Simbolo as MonedaSimbolo 
        FROM    LIQUIDACIONES 
                    INNER JOIN CUOTAPARTISTAS ON LIQUIDACIONES.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista 
                       INNER JOIN FONDOSREAL FONDOS ON FONDOS.CodFondo = LIQUIDACIONES.CodFondo
                       INNER JOIN FONDOSPARAM on FONDOS.CodFondo = FONDOSPARAM.CodFondo AND FONDOSPARAM.CodParametroFdo ='NRCNV'
                      INNER JOIN MONEDAS ON MONEDAS.CodMoneda = FONDOS.CodMoneda 
                      INNER JOIN MONEDAS MONEDASLIQ ON MONEDASLIQ.CodMoneda = LIQUIDACIONES.CodMoneda 
                      INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo And TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp  
                       INNER JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo And VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp 
                      AND VALORESCP.Fecha = (SELECT MAX(Fecha) FROM VALORESCP VAL2MAX WHERE VAL2MAX.CodFondo = VALORESCP.CodFondo 
                 								And VAL2MAX.CodTpValorCp = VALORESCP.CodTpValorCp And VAL2MAX.Fecha <= @Fecha)  
                 	INNER JOIN CONDICIONESINGEGR on LIQUIDACIONES.CodFondo=CONDICIONESINGEGR.CodFondo  And LIQUIDACIONES.CodCondicionIngEgr =  CONDICIONESINGEGR.CodCondicionIngEgr
                    LEFT  JOIN(SELECT  CPTBLOQUEOS.CodFondo, CPTBLOQUEOS.CodTpValorCp, CPTBLOQUEOS.CodCuotapartista, SUM(CPTBLOQUEOS.CantidadCuotapartes) AS CuotapartesBloqueadas  
                              From CPTBLOQUEOS Where CPTBLOQUEOS.FechaBloqueo <= DateAdd(Day, DateDiff(Day, 0, @Fecha), 0)
                             Group By CPTBLOQUEOS.CodFondo, CPTBLOQUEOS.CodTpValorCp, CPTBLOQUEOS.CodCuotapartista) AS BLOQUEOS  
                        On BLOQUEOS.CodFondo = LIQUIDACIONES.CodFondo And BLOQUEOS.CodTpValorCp = LIQUIDACIONES.CodTpValorCp And BLOQUEOS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista  
                 		INNER JOIN AGCOLOCADORES  ON LIQUIDACIONES.CodAgColocador = AGCOLOCADORES.CodAgColocador 
                        LEFT JOIN OFICIALESCTA ON OFICIALESCTA.CodAgColocador = AGCOLOCADORES.CodAgColocador    
                 			AND CUOTAPARTISTAS.CodOficialCta = OFICIALESCTA.CodOficialCta 
                 			AND OFICIALESCTA.CodOficialCta = LIQUIDACIONES.CodOficialCta 
                 			AND OFICIALESCTA.CodAgColocador = CUOTAPARTISTAS.CodAgColocadorOfCta  
                 			AND AGCOLOCADORES.CodAgColocador = CUOTAPARTISTAS.CodAgColocador 
        WHERE NumCuotapartista=@NumCuotapartista
         AND	LIQUIDACIONES.EstaAnulado = 0 AND LIQUIDACIONES.FechaConcertacion <= @Fecha 
         AND FONDOS.EstaAnulado = 0 
         AND CONDICIONESINGEGR.EstaAnulado = 0 
        GROUP BY   FONDOS.CodInterfaz, FONDOS.NumFondo, FONDOS.Nombre, 
                    TPVALORESCP.CodInterfaz , TPVALORESCP.Abreviatura, TPVALORESCP.Descripcion, 
                    CUOTAPARTISTAS.CodInterfaz, CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.Nombre, 
                    BLOQUEOS.CuotapartesBloqueadas, VALORESCP.ValorCuotaparte, VALORESCP.Fecha,CONDICIONESINGEGR.CodInterfaz, MONEDASLIQ.CodInterfaz, MONEDASLIQ.Descripcion, MONEDASLIQ.Simbolo 
        HAVING  SUM(LIQUIDACIONES.CantCuotapartes) > 0 
        ORDER BY FONDOS.NumFondo, TPVALORESCP.Abreviatura, CUOTAPARTISTAS.NumCuotapartista, VALORESCP.Fecha
SELECT  LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, --LIQUIDACIONES.CodMoneda 'MonLiq',FONDOS.CodMoneda 'MonFdo', LIQUIDACIONES.CodCondicionIngEgr,
		FONDOS.CodInterfaz AS FondoID, FONDOS.NumFondo AS FondoNumero, FONDOS.Nombre AS FondoNombre, 		
        TPVALORESCP.CodInterfaz AS TipoVCPID, TPVALORESCP.Abreviatura AS TipoVCPAbreviatura, TPVALORESCP.Descripcion AS TipoVCPDescripcion,  
        CUOTAPARTISTAS.CodInterfaz AS CuotapartistaID, CUOTAPARTISTAS.NumCuotapartista AS CuotapartistaNumero, CUOTAPARTISTAS.Nombre AS CuotapartistaNombre,  
		SUM(LIQUIDACIONES.CantCuotapartes) AS CuotapartesTotales, ISNULL(BLOQUEOS.CuotapartesBloqueadas, 0) AS CuotapartesBloqueadas, 
		
		CASE WHEN VALORESCPREEXP.ValorCuotaparte IS NULL THEN SUM(LIQUIDACIONES.CantCuotapartes) * VALORESCP.ValorCuotaparte ELSE SUM(LIQUIDACIONES.CantCuotapartes) * (VALORESCPREEXP.ValorCuotaparte * VALORESCPREEXP.FactConvReexpFdo) END AS CuotapartesValuadas,  
        
		VALORESCP.ValorCuotaparte AS UltimoVCPValor, MAX(VALORESCP.Fecha) AS UltimoVCPFecha,CONDICIONESINGEGR.CodInterfaz as 'IDCondicionIngEgr',  
        --MONEDASLIQ.CodInterfaz AS IDMoneda, MONEDASLIQ.Descripcion as MonedaDescripcion, MONEDASLIQ.Simbolo as MonedaSimbolo 
		MONEDASFDO.CodInterfaz AS IDMoneda, MONEDASFDO.Descripcion as MonedaDescripcion, MONEDASFDO.Simbolo as MonedaSimbolo 
FROM    LIQUIDACIONES  
    INNER JOIN CUOTAPARTISTAS ON LIQUIDACIONES.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista  
        INNER JOIN FONDOSREAL FONDOS ON FONDOS.CodFondo = LIQUIDACIONES.CodFondo 
        INNER JOIN FONDOSPARAM on FONDOS.CodFondo = FONDOSPARAM.CodFondo AND FONDOSPARAM.CodParametroFdo ='NRCNV' 
        INNER JOIN MONEDAS MONEDASFDO ON MONEDASFDO.CodMoneda = FONDOS.CodMoneda 
        INNER JOIN MONEDAS MONEDASLIQ ON MONEDASLIQ.CodMoneda = LIQUIDACIONES.CodMoneda  
        LEFT JOIN TPVALORESCP ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo And TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp   
        INNER JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo And VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp  
								AND VALORESCP.Fecha = (SELECT MAX(Fecha) FROM VALORESCP VAL2MAX WHERE VAL2MAX.CodFondo = VALORESCP.CodFondo  
														And VAL2MAX.CodTpValorCp = VALORESCP.CodTpValorCp And VAL2MAX.Fecha <= GetDate())  
		LEFT JOIN FONDOSMON
			ON FONDOSMON.CodFondo = FONDOS.CodFondo
			and FONDOSMON.CodTpValorCp = VALORESCP.CodTpValorCp
			and FONDOSMON.CodMoneda = LIQUIDACIONES.CodMoneda
			AND FONDOSMON.EsValorRef = -1 
			AND FONDOSMON.FechaDesde = (SELECT MAX(FONMON.FechaDesde)
										FROM FONDOSMON FONMON
										WHERE FONMON.CodFondo = FONDOSMON.CodFondo
											AND FONMON.CodTpValorCp = FONDOSMON.CodTpValorCp
											AND FONMON.CodMoneda = FONDOSMON.CodMoneda
											AND FONMON.FechaDesde <= LIQUIDACIONES.FechaConcertacion
										)
		left join VALORESCPREEXP 
			ON VALORESCPREEXP.CodFondoMon = FONDOSMON.CodFondoMon
			and VALORESCPREEXP.CodFondo = FONDOSMON.CodFondo
			and VALORESCPREEXP.CodTpValorCp = FONDOSMON.CodTpValorCp
			and VALORESCPREEXP.CodMoneda = FONDOSMON.CodMoneda
			and VALORESCPREEXP.Fecha = LIQUIDACIONES.FechaConcertacion	
											 
    left JOIN CONDICIONESINGEGR on LIQUIDACIONES.CodFondo=CONDICIONESINGEGR.CodFondo  And LIQUIDACIONES.CodCondicionIngEgr =  CONDICIONESINGEGR.CodCondicionIngEgr 
        LEFT  JOIN(SELECT  CPTBLOQUEOS.CodFondo, CPTBLOQUEOS.CodTpValorCp, CPTBLOQUEOS.CodCuotapartista, SUM(CPTBLOQUEOS.CantidadCuotapartes) AS CuotapartesBloqueadas   
                    From CPTBLOQUEOS Where CPTBLOQUEOS.FechaBloqueo <= DateAdd(Day, DateDiff(Day, 0, GetDate()), 0) 
                    Group By CPTBLOQUEOS.CodFondo, CPTBLOQUEOS.CodTpValorCp, CPTBLOQUEOS.CodCuotapartista) AS BLOQUEOS   
                On BLOQUEOS.CodFondo = LIQUIDACIONES.CodFondo And BLOQUEOS.CodTpValorCp = LIQUIDACIONES.CodTpValorCp And BLOQUEOS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista   
    INNER JOIN AGCOLOCADORES  ON LIQUIDACIONES.CodAgColocador = AGCOLOCADORES.CodAgColocador  
        LEFT JOIN OFICIALESCTA ON OFICIALESCTA.CodAgColocador = AGCOLOCADORES.CodAgColocador     
     	AND CUOTAPARTISTAS.CodOficialCta = OFICIALESCTA.CodOficialCta  
     	AND OFICIALESCTA.CodOficialCta = LIQUIDACIONES.CodOficialCta  
     	AND OFICIALESCTA.CodAgColocador = CUOTAPARTISTAS.CodAgColocadorOfCta   
     	AND AGCOLOCADORES.CodAgColocador = CUOTAPARTISTAS.CodAgColocador 
WHERE	LIQUIDACIONES.EstaAnulado = 0 AND LIQUIDACIONES.FechaConcertacion <= GetDate() --AND NumCuotapartista = 117
GROUP BY   LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, --LIQUIDACIONES.CodMoneda, FONDOS.CodMoneda, LIQUIDACIONES.CodCondicionIngEgr,
			FONDOS.CodInterfaz , FONDOS.NumFondo, FONDOS.Nombre,  
                TPVALORESCP.CodInterfaz , TPVALORESCP.Abreviatura, TPVALORESCP.Descripcion,  
                CUOTAPARTISTAS.CodInterfaz, CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.Nombre,  
                BLOQUEOS.CuotapartesBloqueadas, VALORESCP.ValorCuotaparte, VALORESCPREEXP.ValorCuotaparte, VALORESCPREEXP.FactConvReexpFdo, VALORESCP.Fecha,CONDICIONESINGEGR.CodInterfaz, 
                --MONEDASLIQ.CodInterfaz, MONEDASLIQ.Descripcion, MONEDASLIQ.Simbolo 
				MONEDASFDO.CodInterfaz, MONEDASFDO.Descripcion, MONEDASFDO.Simbolo 
HAVING  SUM(LIQUIDACIONES.CantCuotapartes) > 0 
ORDER BY FONDOS.NumFondo, TPVALORESCP.Abreviatura, CUOTAPARTISTAS.NumCuotapartista, VALORESCP.Fecha


--Select * From CONDICIONESINGEGR where CodCondicionIngEgr = 2
--Select * From CONDINGEGRMON where CodFondo = 2 and CodCondicionIngEgr = 2
--Select * From LIQUIDACIONES where CodFondo = 2 and CodTpValorCp = 3 and CodCuotapartista = 58
--Select * From FONDOSMON where CodFondo = 2 and CodTpValorCp = 3
--Select * From VALORESCPREEXP where CodFondo = 2 and CodTpValorCp = 3
--Select * From MONEDAS
--sELECT * From FONDOSREAL where CodFondo = 2
DECLARE   @TipoSolicitud  CodigoTextoLargo ='SU'
DECLARE   @NumeroDeFondo NumeroCorto = NULL
DECLARE   @IDTipoValorCuotaParte CodigoInterfazLargo = NULL
DECLARE   @IDCuotapartista  CodigoInterfaz = NULL
	

	
	DECLARE @Fecha Fecha
	SET @Fecha = CONVERT(smalldatetime,convert(varchar(20), GETDATE(),112))
	
	--DECLARE @CodCuotapartista numeric(10)
	--SELECT @CodCuotapartista=CodCuotapartista 
	--FROM CUOTAPARTISTAS 
	--WHERE CodInterfaz=@IDCuotapartista

	SELECT FONDOSPARAM.*
		INTO #FONDOSPARAM 
		FROM FONDOSPARAM  		   
			INNER JOIN FONDOSREAL ON FONDOSPARAM.CodFondo = FONDOSREAL.CodFondo AND (@NumeroDeFondo IS NULL OR FONDOSREAL.NumFondo=@NumeroDeFondo )
		WHERE FONDOSPARAM.CodParametroFdo IN ('ADJRNU','PLARES')

	SELECT 
		FR.CodInterfaz AS FondoID
		,FR.NumFondo AS FondoNumero
		,FR.NombreAbreviado AS FondoNombreAbr
		,FR.Nombre AS FondoNombre 
		,TVP.CodInterfaz AS TipoVCPID
		,TVP.Descripcion as TipoVCPDescripcion
		,TVP.Abreviatura as TipoVCPAbreviatura
		,ISNULL(MON.CodInterfaz,MONFDO.CodInterfaz)	 AS MonedaID
		,ISNULL(MON.Simbolo,MONFDO.Simbolo) AS MonedaSimbolo
		,ISNULL(MON.Descripcion,MONFDO.Descripcion) AS MonedaDescripcion
		,CONVERT(VARCHAR(20), HCE.HoraInicio, 108) HoraInicio
		,CONVERT(VARCHAR(20),  HCE.HoraCierre, 108)  HoraCierre
		,(SELECT CONVERT(INT,FP.ValorNumero) FROM #FONDOSPARAM FP WHERE FP.CodFondo = FR.CodFondo AND FP.CodParametroFdo ='PLARES') AS PlazoLiquidacionFondo
		,(SELECT FP.ValorNumero FROM #FONDOSPARAM FP WHERE FP.CodFondo = FR.CodFondo AND FP.CodParametroFdo ='ADJRNU') AS PrecisionFondo
		,CIN.AplicaPersonaFisica
		,CIN.AplicaPersonaJuridica
		,CIN.CodInterfaz AS CondicionIngresoEgresoID   
		,CIN.Descripcion AS CondicionIngresoEgresoDesc
		,CASE WHEN @TipoSolicitud = 'SU' THEN CASE WHEN (CIN.SuscripcionMinima = 0) THEN NULL ELSE CIN.SuscripcionMinima END ELSE CASE WHEN (CIN.RescateMinimo = 0) THEN NULL ELSE CIN.RescateMinimo END  END AS MontoMinimo
		,CASE WHEN @TipoSolicitud = 'SU' THEN CASE WHEN (CIN.SuscripcionMaxima = -1) THEN NULL ELSE CIN.SuscripcionMaxima END ELSE CASE WHEN (CIN.RescateMaximo = -1) THEN NULL ELSE CIN.RescateMaximo END  END AS MontoMaximo
		,NULL AS 'MontoMaximoAutorizacion'
		,CTA.NumeroCuenta  NumeroCuentaFondo
		,CTA.CBU CBUFondo			   
		, CASE when FP.ValorNumero = 0  THEN 'SI' ELSE 'NO' END  DebitaInmediato
		,TPPERFILES.Descripcion AS TpRiesgoDescripcion
		,TPPERFILES.NivelRiesgo AS TpRiesgoNivelRiesgo
		,TPPERFILES.CodInterfaz AS TpRiesgoCodInterfaz
		,(CASE WHEN COUNT(CPTBLOQUEOSTOT.CodFondo) > 0 THEN -1 ELSE 0 END) AS EstaInhibido
		,CTA.EsCtaDepositaria
		,AFECTACIONESCTABANC.CodTpAfectacionBanc
	FROM FONDOSREAL FR 
		LEFT JOIN FDOHORASTOPECANALEXT HCE ON FR.CodFondo = HCE.CodFondo AND HCE.CodTpSolicitud= @TipoSolicitud AND HCE.EstaAnulado = 0
		INNER JOIN TPVALORESCP TVP ON TVP.CodFondo = FR.CodFondo      
		INNER JOIN CONDICIONESINGEGR CIN ON CIN.CodFondo = FR.CodFondo    
		INNER JOIN CONDINGEGRTPVALORESCP CINTP ON CIN.CodFondo = CINTP.CodFondo AND CIN.CodCondicionIngEgr = CINTP.CodCondicionIngEgr AND CINTP.CodTpValorCp = TVP.CodTpValorCp  AND EsDefault=-1
		INNER JOIN CONDINGEGRMON CIEMON ON FR. CodFondo = CIEMON.CodFondo AND CIN.CodCondicionIngEgr = CIEMON.CodCondicionIngEgr 
			AND DATEDIFF(d,CIEMON.FechaVigencia, getDate()) > 0
		LEFT JOIN MONEDAS MON  ON MON.CodMoneda = CIEMON.CodMoneda 
		LEFT JOIN MONEDAS MONFDO  ON MONFDO.CodMoneda = FR.CodMoneda 
		LEFT JOIN CTASBANCARIAS CTA ON FR.CodFondo = CTA.CodFondo AND (CTA.EsCtaDepositaria = -1 AND CTA.EstaAnulado = 0)
		LEFT JOIN AFECTACIONESCTABANC ON CTA.CodFondo = AFECTACIONESCTABANC.CodFondo
			AND  CTA.CodCtaBancaria = AFECTACIONESCTABANC.CodCtaBancaria
			AND MON.CodMoneda = AFECTACIONESCTABANC.CodMoneda AND AFECTACIONESCTABANC.CodTpAfectacionBanc IN ('LIQSUS','CVDIVISAS') AND AFECTACIONESCTABANC.EstaAnulado = 0
		LEFT JOIN #FONDOSPARAM FP ON FP.CodFondo = FR.CodFondo AND ValorNumero= 0
		LEFT JOIN TPPERFILFDO ON TPPERFILFDO.CodFondo = FR.CodFondo AND TPPERFILFDO.EstaAnulado = 0
		LEFT JOIN TPPERFILES ON TPPERFILES.CodTpPerfil = TPPERFILFDO.CodTpPerfil AND TPPERFILES.EstaAnulado = 0
		LEFT JOIN CPTBLOQUEOSTOT ON CPTBLOQUEOSTOT.CodFondo = FR.CodFondo 
								
									AND CPTBLOQUEOSTOT.FechaBloqueo <= @Fecha
									AND (CPTBLOQUEOSTOT.FechaDesbloqueo > @Fecha OR CPTBLOQUEOSTOT.FechaDesbloqueo IS NULL)
	WHERE  (@NumeroDeFondo IS NULL OR  FR.NumFondo =  @NumeroDeFondo)  AND (@IDTipoValorCuotaParte IS NULL OR TVP.CodInterfaz = @IDTipoValorCuotaParte)
		AND CIN.EstaAnulado = 0	AND FR.EstaAnulado = 0 AND CINTP.EstaAnulado = 0
	GROUP BY FR.NumFondo,FR.NombreAbreviado,FR.Nombre,FR.CodInterfaz,FR.CodFondo,MON.CodMoneda,MON.Descripcion	    	  
		,TVP.Descripcion,TVP.Abreviatura,TVP.CodInterfaz ,TVP.CodTpValorCp 
		,CIN.AplicaPersonaFisica,CIN.AplicaPersonaJuridica,CIN.Descripcion,CIN.CodInterfaz	,CTA.NumeroCuenta  
		,CTA.CBU, CIN.RescateMinimo,CIN.SuscripcionMinima,CIN.RescateMaximo ,CIN.SuscripcionMaxima,CTA.CodMoneda
		,MON.CodInterfaz,MON.Simbolo,MONFDO.CodInterfaz,MONFDO.Simbolo,MONFDO.Descripcion, HCE.HoraInicio, HCE.HoraCierre, FP.ValorNumero
		,TPPERFILES.Descripcion,TPPERFILES.NivelRiesgo,TPPERFILES.CodInterfaz
		,CTA.EsCtaDepositaria
		,AFECTACIONESCTABANC.CodTpAfectacionBanc

	DROP TABLE #FONDOSPARAM
DECLARE @CodTpSolicitud  CodigoTextoLargo = 'SU'
DECLARE @NumFondo NumeroCorto = 1
DECLARE @IDTipoValorCuotaParte CodigoInterfazLargo 
DECLARE @IDCuotapartista  CodigoInterfaz = 530


DECLARE  @codParametroSolicitud CodigoTextoMedio

	   	     SELECT @codParametroSolicitud = CASE CodTpSolicitud  WHEN  'SU'  THEN 'HTACSO' WHEN 'RE' THEN 'HTACSR' END
	       FROM TPSOLICITUD 
	      WHERE CodTpSolicitud = @CodTpSolicitud  	 


    	 SELECT FONDOSPARAM.*
    	   INTO #FONDOSPARAM 
           FROM FONDOSPARAM  		   
     INNER JOIN FONDOSREAL ON FONDOSPARAM.CodFondo = FONDOSREAL.CodFondo AND (@NumFondo IS NULL OR FONDOSREAL.NumFondo=@NumFondo )
          WHERE FONDOSPARAM.CodParametroFdo IN (@codParametroSolicitud ,'ADJRNU','PLARES')
    		     
         SELECT 
	    	    FR.CodInterfaz AS FondoID
		 	   ,FR.NumFondo AS FondoNumero
	    	   ,FR.NombreAbreviado AS FondoNombreAbr
	    	   ,FR.Nombre AS FondoNombre 
	    	   ,TVP.CodInterfaz AS TipoVCPID
			   ,TVP.Descripcion as TipoVCPDescripcion
	    	   ,TVP.Abreviatura as TipoVCPAbreviatura
	    	   ,MON.CodInterfaz	 AS MonedaID
			   ,MON.Simbolo AS MonedaSimbolo
			   ,MON.Descripcion AS MonedaDescripcion
			   ,CONVERT(VARCHAR(20), HCE.HoraInicio, 108) HoraInicio
			   ,CONVERT(VARCHAR(20),  HCE.HoraCierre, 108)  HoraCierre
	    	   ,(SELECT CONVERT(INT,FP.ValorNumero) FROM #FONDOSPARAM FP WHERE FP.CodFondo = FR.CodFondo AND FP.CodParametroFdo ='PLARES') AS PlazoLiquidacionFondo
	    	   ,(SELECT FP.ValorNumero FROM #FONDOSPARAM FP WHERE FP.CodFondo = FR.CodFondo AND FP.CodParametroFdo ='ADJRNU') AS PrecisionFondo
	    	   ,CIN.AplicaPersonaFisica
	    	   ,CIN.AplicaPersonaJuridica
	    	   ,CASE @CodTpSolicitud WHEN 'SU' THEN CIN.RescateMinimo WHEN 'RE' THEN CIN.SuscripcionMinima END AS MontoMinimo
	    	   ,CASE @CodTpSolicitud WHEN 'SU' THEN CIN.RescateMaximo WHEN 'RE' THEN CIN.SuscripcionMaxima END AS MontoMaximo
	    	   ,CIN.Descripcion AS DescripcionCondicionIngresoEgreso	   		   
			   , CASE FP.CodFondo  WHEN null THEN 0 ELSE 1 END  DebitaInmediato
			   FROM FONDOSREAL FR 
			     INNER JOIN FDOHORASTOPECANALEXT HCE ON FR.CodFondo = HCE.CodFondo AND HCE.CodTpSolicitud= @CodTpSolicitud AND HCE.EstaAnulado = 0
				 INNER JOIN MONEDAS MON ON MON.CodMoneda = FR.CodMoneda 
				 INNER JOIN FONDOSCPT FCP ON FCP.CodFondo = FR.CodFondo
				 INNER JOIN CUOTAPARTISTAS CPT ON CPT.CodCuotapartista = FCP.CodCuotapartista AND CPT.CodInterfaz = @IDCuotapartista
				 INNER JOIN TPVALORESCP TVP ON TVP.CodFondo = FR.CodFondo AND (@IDTipoValorCuotaParte IS NULL OR TVP.CodInterfaz = @IDTipoValorCuotaParte)     
				 INNER JOIN CONDICIONESINGEGR CIN ON CIN.CodFondo = FR.CodFondo    
				  LEFT JOIN #FONDOSPARAM FP ON FP.CodFondo = FR.CodFondo AND ValorNumero= 0
          WHERE (CPT.EsPersonaFisica = -1 AND CIN.AplicaPersonaFisica = -1) OR (CPT.EsPersonaFisica = 0 AND CIN.AplicaPersonaJuridica = -1)	AND (@NumFondo IS NULL OR  FR.NumFondo =  @NumFondo)	  
		  GROUP BY FR.NumFondo,FR.NombreAbreviado,FR.Nombre,FR.CodInterfaz,FR.CodFondo,MON.CodMoneda,MON.Descripcion	    	  
				,TVP.Descripcion,TVP.Abreviatura,TVP.CodInterfaz ,TVP.CodTpValorCp 
				,CIN.AplicaPersonaFisica,CIN.AplicaPersonaJuridica,CIN.Descripcion,CIN.CodInterfaz,
				 CIN.RescateMinimo,CIN.SuscripcionMinima,CIN.RescateMaximo ,CIN.SuscripcionMaxima
				,MON.CodInterfaz,MON.Simbolo, HCE.HoraInicio, HCE.HoraCierre 
	   --ORDER BY CPT.CodInterfaz

   DROP TABLE #FONDOSPARAM

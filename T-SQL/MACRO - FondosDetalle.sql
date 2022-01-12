  DECLARE @NumeroDeFondo  NumeroCorto = 1
  
     SELECT VCP.CodFondo,
              MAX(VCP.Fecha) Fecha 
         INTO dbo.#CotizacionesCP
         FROM VALORESCP VCP
   INNER JOIN FONDOSREAL F ON VCP.CodFondo = F.CodFondo
       WHERE (@NumeroDeFondo IS NULL OR F.NumFondo = @NumeroDeFondo)
     GROUP BY VCP.CodFondo

		select 
				F.NumFondo as FondoNumero
				,F.Nombre as FondoNombre
				,TPVALOR.CodInterfaz AS TipoVCPID
			    ,TPVALOR.Descripcion as TipoVCPDescripcion
	    	    ,TPVALOR.Abreviatura as TipoVCPAbreviatura
				,M.CodCAFCI MonedaID, 
				M.Simbolo as MonedaSimbolo, 
				M.Descripcion as MonedaDescripcion,
				CASE WHEN F.EsAbierto = -1 THEN 'Abierto' ELSE 'Cerrado' END TipoDeFondo,	
               CASE
                 WHEN (DATEDIFF(DAY, TPVALOR.FechaInicio, GETDATE()) >= 0) THEN 'Operativo'
                 ELSE 'No Operativo'
               END EstadoFondo,
               CI.SuscripcionMinima AS 'MontoMinimoSucripcion',
               CI.RescateMinimo AS 'MontoMinimoRescate',
               CTAB.NumeroCuenta AS 'DescCBUCtaBancaria',
               CTAB.CBU AS 'DescCBUCtaBancaria',
               CTAB.CodInterfaz AS 'IDCtaBancaria',
               CONVERT(INT,FP.ValorNumero) AS 'DESCPlazoLiquidacion',
               CI.Descripcion AS 'DESCCondicionIngEgr',
               CI.CodInterfaz AS 'IDCondicionIngEgr',
               TPFONDO.CodTpFondo AS 'CODTpFondo',
               TPFONDO.Descripcion AS 'DESCTpFondo',
			   CI.RescateMaximo AS 'MontoMaximoRescate',
			   CI.SuscripcionMaxima AS 'MontoMaximoSuscripcion',
			   NULL AS 'MontoMaximoAutorizacion' 	      
          FROM FONDOSREAL F
     INNER JOIN TPVALORESCP TPVALOR ON F.CodFondo = TPVALOR.CodFondo
     LEFT JOIN MONEDAS M ON M.CodMoneda = F.CodMoneda
     LEFT JOIN #CotizacionesCP CCP ON F.CodFondo = CCP.CodFondo
    --AGREGUE JOIN
     LEFT JOIN FONDOSPARAM FP ON F.CodFondo = FP.CodFondo AND FP.CodParametroFdo = 'PLARES'
     LEFT JOIN CONDICIONESINGEGR CI ON F.CodFondo = CI.CodFondo AND CI.EstaAnulado = 0
     LEFT JOIN CTASBANCARIAS CTAB ON F.CodFondo = CTAB.CodFondo AND (CTAB.EsCtaDepositaria = -1 AND CTAB.EstaAnulado = 0)
	 INNER JOIN AFECTACIONESCTABANC ON CTAB.CodFondo = AFECTACIONESCTABANC.CodFondo
		 AND  CTAB.CodCtaBancaria = AFECTACIONESCTABANC.CodCtaBancaria
		 AND CTAB.CodMoneda = AFECTACIONESCTABANC.CodMoneda AND AFECTACIONESCTABANC.CodTpAfectacionBanc = 'SOLSUS'
     LEFT JOIN TPFONDO TPFONDO ON F.CodTpFondo = TPFONDO.CodTpFondo
        WHERE (@NumeroDeFondo IS NULL OR F.NumFondo = @NumeroDeFondo)
           AND F.EstaAnulado = 0
      GROUP BY F.NumFondo,M.CodCAFCI,F.Nombre,M.Simbolo,M.Descripcion,F.EsAbierto,F.CodInterfaz,M.CodInterfaz,
	  TPVALOR.CodInterfaz, TPVALOR.Descripcion, TPVALOR.Abreviatura,
               CASE
                 WHEN (DATEDIFF(DAY, TPVALOR.FechaInicio, GETDATE()) >= 0) THEN 'Operativo'
                 ELSE 'No Operativo'
               END,
               CI.SuscripcionMinima,
               FP.ValorNumero,
               TPVALOR.Descripcion,
               TPVALOR.CodTpValorCp,
               CI.Descripcion,
               CI.CodInterfaz,
               TPFONDO.Descripcion,
               TPVALOR.CodInterfaz,
               TPFONDO.CodTpFondo,
               F.CodFondo,
               CI.RescateMinimo,
               TPVALOR.Abreviatura,
               CTAB.CBU,
               CTAB.CodInterfaz,
			   CI.RescateMaximo,
			   CI.SuscripcionMaxima,
			   CTAB.NumeroCuenta

DROP TABLE #CotizacionesCP

SELECT 
		FONDOSPARAM.ValorNumero,
		CUOTAPARTISTAS.NumCuotapartista AS NumCuotapartista,
		CUOTAPARTISTAS.Nombre AS Nombre,
		FONDOSREAL.NumFondo AS NumFondo,
		FONDOSREAL.CodFondo AS CodFondo,
		TPVALORESCP.Abreviatura as Abreviatura,
		'0101' [CentroCostoSucursal], --CPTCTASBANCARIAS.NumSucursal AS CentroCostoSucursal,
		LIQUIDACIONES.Importe AS Importe,
		LIQUIDACIONES.FechaLiquidacion AS Fecha,
		LIQUIDACIONES.TimeStamp AS [Time],
		LIQUIDACIONES.CodAuditoriaRef AS CodAuditoriaRef,
		LIQUIDACIONES.CodLiquidacion,

		--ORIGEN - DEBITO - FONDO
		'0101' [CuentaBancariaSucursal],
		TPCTAFDO.CodInterfaz as CuentaBancariaTipo,
		CTASBANCARIAS.NumeroCuenta as CuentaBancariaNumero,
		MONEDAS.CodInterfaz AS CuentaBancariaMoneda,

		--DESTINO - CREDITO - CPT
		'0' + LTRIM(CPTCTASBANCARIAS.NumSucursal) AS CuentaFondoSucursal ,
		TPCTABANCARIA.CodInterfaz AS CuentaFondoTipo ,
		CPTCTASBANCARIAS.NumeroCuenta AS CuentaFondoNumero ,
		MONEDAS.CodInterfaz AS CuentaFondoMoneda,

		CASE WHEN PERSONAS.CUIL IS NULL AND PERSONAS.CUIT IS NULL THEN
				(SELECT TOP 1 CodInterfaz FROM TPDOCIDENTIDAD WHERE CodDocIdentidad = 'DNI')
			WHEN PERSONAS.CUIL IS NULL THEN
				(SELECT TOP 1 CodInterfaz FROM TPDOCIDENTIDAD WHERE CodDocIdentidad = 'CUIT')
			ELSE
				(SELECT TOP 1 CodInterfaz FROM TPDOCIDENTIDAD WHERE CodDocIdentidad = 'CUIL')
			END TpDocumento,
		CASE WHEN PERSONAS.CUIL IS NULL AND PERSONAS.CUIT IS NULL THEN
				PERSONAS.NumDocumento
			WHEN PERSONAS.CUIL IS NOT NULL THEN
				PERSONAS.CUIL
			ELSE
				PERSONAS.CUIT
		END NumDocumento
	FROM LIQUIDACIONES 
		INNER JOIN SOLRESC ON SOLRESC.CodSolResc = LIQUIDACIONES.CodSolResc AND SOLRESC.EstaAnulado = 0
		INNER JOIN CUOTAPARTISTAS ON LIQUIDACIONES.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
		INNER JOIN CPTCTASBANCARIAS ON  CPTCTASBANCARIAS.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista AND CPTCTASBANCARIAS.CodMoneda = LIQUIDACIONES.CodMoneda
		INNER JOIN TPCTABANCARIA ON CPTCTASBANCARIAS.CodTpCtaBancaria = TPCTABANCARIA.CodTpCtaBancaria
		INNER JOIN MONEDAS on MONEDAS.CodMoneda = LIQUIDACIONES.CodMoneda
		INNER JOIN CTASBANCARIAS ON CTASBANCARIAS.CodFondo = LIQUIDACIONES.CodFondo AND CTASBANCARIAS.CodMoneda = LIQUIDACIONES.CodMoneda
		LEFT JOIN TPCTABANCARIA TPCTAFDO ON CTASBANCARIAS.CodTpCtaBancaria = TPCTAFDO.CodTpCtaBancaria
		INNER JOIN FONDOSREAL ON FONDOSREAL.CodFondo = LIQUIDACIONES.CodFondo
		INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
		INNER JOIN AFECTACIONESCTABANC ON AFECTACIONESCTABANC.CodCtaBancaria = CTASBANCARIAS.CodCtaBancaria AND AFECTACIONESCTABANC.CodFondo = CTASBANCARIAS.CodFondo
		AND AFECTACIONESCTABANC.CodMoneda = CTASBANCARIAS.CodMoneda
		INNER JOIN CONDOMINIOS ON CUOTAPARTISTAS.CodCuotapartista=CONDOMINIOS.CodCuotapartista AND CONDOMINIOS.EstaAnulado = 0
		INNER JOIN PERSONAS ON PERSONAS.CodPersona=CONDOMINIOS.CodPersona
		INNER JOIN FONDOSPARAM ON FONDOSPARAM.CodFondo = SOLRESC.CodFondo AND CodParametroFdo = 'PLARES' AND ValorNumero <> 0
		INNER JOIN FORMASPAGO ON FORMASPAGO.CodFormaPago = SOLRESC.CodFormaPago
	WHERE LIQUIDACIONES.CodTpLiquidacion='RE' 
		AND LIQUIDACIONES.FechaLiquidacion IN ('20201016','20201022','20201103')
		AND LIQUIDACIONES.EstaAnulado = 0 
		AND CPTCTASBANCARIAS.EstaAnulado = 0  
		AND AFECTACIONESCTABANC.CodTpAfectacionBanc = 'LIQRES'
		AND FORMASPAGO.CodTpFormaPago = 'CB' --AND SOLRESC.CodTpOrigenSol = 'VF'
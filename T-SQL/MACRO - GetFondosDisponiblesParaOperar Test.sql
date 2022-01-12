   
DECLARE @NumFondo NumeroCorto = 1
DECLARE @IDTipoValorCuotaParte CodigoInterfaz  = '14444'
DECLARE @IDCuotapartista  CodigoInterfaz = '1248'
DECLARE @Fecha Fecha = '20070403'
   
   DECLARE @CodCuotapartista numeric(10)
   
   SELECT @CodCuotapartista=CodCuotapartista 
   FROM CUOTAPARTISTAS 
   WHERE CodInterfaz=@IDCuotapartista

   
   IF (@Fecha IS NULL)
		SELECT @Fecha=GETDATE()

   SELECT     FONDOSREAL.CodInterfaz AS FondoID
		 	,FONDOSREAL.NumFondo AS FondoNumero
	    	,FONDOSREAL.NombreAbreviado AS FondoNombreAbr
	    	,FONDOSREAL.Nombre AS FondoNombre 
	    	,TPVALORESCP.CodInterfaz AS TipoVCPID
			,TPVALORESCP.Descripcion as TipoVCPDescripcion
	    	,TPVALORESCP.Abreviatura as TipoVCPAbreviatura
			,MONEDAS.CodInterfaz  AS MonedaID
			,MONEDAS.Simbolo AS MonedaSimbolo
			,MONEDAS.Descripcion AS MonedaDescripcion
     	    ,SUM(LIQUIDACIONES.CantCuotapartes) AS CantCuotapartes
     	    ,SUM(LIQUIDACIONES.Importe) AS Importe
     		,CONDICIONESINGEGR.CodInterfaz as CondicionIngresoEgresoID
     		,CONDICIONESINGEGR.Descripcion AS CondicionIngresoEgresoDescripcion
    FROM    LIQUIDACIONES
            INNER JOIN CONDICIONESINGEGR ON CONDICIONESINGEGR.CodFondo = LIQUIDACIONES.CodFondo AND CONDICIONESINGEGR.CodCondicionIngEgr = LIQUIDACIONES.CodCondicionIngEgr AND CONDICIONESINGEGR.EstaAnulado = 0
            INNER JOIN FONDOSREAL ON FONDOSREAL.CodFondo = LIQUIDACIONES.CodFondo
			INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo AND  TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp 
            INNER JOIN MONEDAS ON LIQUIDACIONES.CodMoneda = MONEDAS.CodMoneda
    WHERE   FONDOSREAL.NumFondo = @NumFondo
			AND (@IDTipoValorCuotaParte IS NULL OR TPVALORESCP.CodInterfaz = @IDTipoValorCuotaParte)
			AND LIQUIDACIONES.EstaAnulado = 0
			AND LIQUIDACIONES.FechaLiquidacion <= @Fecha
			AND LIQUIDACIONES.CodCuotapartista = @CodCuotapartista
     GROUP BY FONDOSREAL.CodInterfaz,FONDOSREAL.NumFondo,FONDOSREAL.NombreAbreviado,FONDOSREAL.NombreAbreviado, FONDOSREAL.Nombre, MONEDAS.CodInterfaz,MONEDAS.Simbolo,
			CONDICIONESINGEGR.CodInterfaz,CONDICIONESINGEGR.Descripcion, MONEDAS.Descripcion,TPVALORESCP.Descripcion,TPVALORESCP.Abreviatura,TPVALORESCP.CodInterfaz,
			TPVALORESCP.CodTpValorCp
		--,LIQUIDACIONES.CodCuotapartista
    HAVING SUM(LIQUIDACIONES.CantCuotapartes) > 0
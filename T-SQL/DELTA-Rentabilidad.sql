
DECLARE @NumCuotapartista	NumeroLargo = 27380017453
--DECLARE @NumCuotapartista	NumeroLargo = 30702020944
DECLARE @FechaDesde         Fecha = '20201222'
DECLARE @FechaHasta         Fecha = '20201223'


--NumCuotapartista:  27380017453 => Importe : 1230.86 , Porcentaje : 99.984500
--NumCuotapartista:  30702020944 => Importe : 1973.01 , Porcentaje : 99.984700

DECLARE @CodCuotapartista numeric(10)

SELECT  @CodCuotapartista = CodCuotapartista FROM CUOTAPARTISTAS WHERE NumCuotapartista = @NumCuotapartista

DECLARE @EsFeriado INT
DECLARE @FechaNew Fecha
DECLARE @CodPais INT

SELECT  @CodPais = CodPais FROM PARAMETROSREL

/*Analizo la Fecha Desde*/
SELECT @EsFeriado = dbo.fnEsFechaFeriado(@FechaDesde, @CodPais)
IF @EsFeriado = -1
BEGIN
	EXEC sp_dfxSumarDiasHabiles @FechaDesde, -1, @FechaNew OUTPUT, @CodPais
	SELECT @FechaDesde=@FechaNew
END

/*Analizo la Fecha Hasta*/
SELECT @EsFeriado = dbo.fnEsFechaFeriado(@FechaHasta, @CodPais)
IF @EsFeriado = -1
BEGIN
	EXEC sp_dfxSumarDiasHabiles @FechaHasta, -1, @FechaNew OUTPUT, @CodPais
	SELECT @FechaHasta=@FechaNew
END

CREATE TABLE #CERTIFICADOSTMP
	(CodCertificadoTemp numeric(15) IDENTITY(1,1)
	,CodFondo	Numeric(15)
	,CodTpLiquidacion	Varchar(10) COLLATE DATABASE_DEFAULT
	,CodLiquidacion	Numeric(15)
	,CodTpValorCp	Numeric(15) NOT NULL
	,CodMoneda		Numeric(15)
	,CodCuotapartista	Numeric(15)
	,CodCondicionIngEgr	Numeric(15)
	,FechaSolicitud smalldatetime
	,NumCertificado	Numeric(15)
	,EstaCancelado	Numeric(2)
	,CantCuotapartes  Numeric (22,8)
	,Importe  Numeric (19,2)
	,VCPFinal Numeric(19,10)
	,VCPDia	  Numeric(19,10)
	,primary key (CodCertificadoTemp))


CREATE TABLE #CERTIFICADOSRESCTMP
	(CodCertificadoRescTemp numeric(15) IDENTITY(1,1)
	,CodFondo	Numeric(15) NOT NULL
	,CodTpLiquidacion	Varchar(10) COLLATE DATABASE_DEFAULT
	,CodLiquidacion	Numeric(15) NOT NULL
	,CodTpValorCp	Numeric(15) NOT NULL
	,CodMoneda		Numeric(15)
	,CodCuotapartista	Numeric(15) NOT NULL
	,CodCondicionIngEgr	Numeric(15) NOT NULL
	,FechaSolicitud 	smalldatetime
	,NumCertificado	   Numeric(15)
	,Importe  Numeric (19,2)
	,CantCuotapartes   Numeric (22,8)
	,primary key (CodCertificadoRescTemp))

CREATE TABLE #SOLICITUDES
	(CodSolicitud numeric(15) IDENTITY(1,1)
	,CodFondo	Numeric(15)
	,CodTpLiquidacion	Varchar(10) COLLATE DATABASE_DEFAULT
	,CodLiquidacion	Numeric(15)
	,CodTpValorCp	Numeric(15) NOT NULL
	,CodMoneda		Numeric(15)
	,CodCuotapartista	Numeric(15)
	,CodCondicionIngEgr	Numeric(15)
	,FechaSolicitud smalldatetime
	,CantCuotapartes  Numeric (22,8)
	,VCPFinal Numeric(19,10)
	,VCPDia	  Numeric(19,10)
    ,ImporteDia   Numeric(19,2)
    ,ImporteFinal Numeric(19,2)
    ,Resultado    Numeric(19,2)
	,primary key (CodSolicitud))

/*Verifico que a esa fecha desde tenga posicion el CPT*/
IF EXISTS (SELECT 1 
		   FROM LIQUIDACIONES 
				INNER JOIN TPLIQUIDACION ON TPLIQUIDACION.CodTpLiquidacion = LIQUIDACIONES.CodTpLiquidacion
				INNER JOIN FONDOS ON FONDOS.CodFondo = LIQUIDACIONES.CodFondo
			WHERE LIQUIDACIONES.EstaAnulado = 0
			AND LIQUIDACIONES.CodCuotapartista = @CodCuotapartista
			AND LIQUIDACIONES.FechaConcertacion < @FechaDesde ) 
BEGIN
	--Cargo la posicion del CPT a la fecha desde
	INSERT #CERTIFICADOSTMP
		(CodFondo	
		,CodTpValorCp
		,CodTpLiquidacion		
		,CodLiquidacion	
		,CodMoneda
		,CodCuotapartista	
		,CodCondicionIngEgr
		,Importe
		,NumCertificado	
		,CantCuotapartes)
		SELECT LIQUIDACIONES.CodFondo	
			  ,LIQUIDACIONES.CodTpValorCp
			  ,'SU'		
			  ,LIQUIDACIONES.CodTpValorCp
			  ,FONDOS.CodMoneda	
			  ,LIQUIDACIONES.CodCuotapartista	
			  ,LIQUIDACIONES.CodCondicionIngEgr
			  ,SUM(LIQUIDACIONES.Importe)
			  ,0
			  ,SUM(LIQUIDACIONES.CantCuotapartes)
		FROM LIQUIDACIONES 
		INNER JOIN TPLIQUIDACION ON TPLIQUIDACION.CodTpLiquidacion = LIQUIDACIONES.CodTpLiquidacion
		INNER JOIN FONDOS ON FONDOS.CodFondo = LIQUIDACIONES.CodFondo
		WHERE LIQUIDACIONES.EstaAnulado = 0
		AND LIQUIDACIONES.CodCuotapartista = @CodCuotapartista
		AND LIQUIDACIONES.FechaConcertacion < @FechaDesde 
		GROUP BY LIQUIDACIONES.CodFondo	,LIQUIDACIONES.CodTpValorCp
		 ,LIQUIDACIONES.CodCuotapartista ,LIQUIDACIONES.CodCondicionIngEgr,FONDOS.CodMoneda
		HAVING SUM(LIQUIDACIONES.CantCuotapartes)<>0

	UPDATE #CERTIFICADOSTMP
	SET
		FechaSolicitud = @FechaDesde--LIQUIDACIONES.FechaConcertacion
	FROM  LIQUIDACIONES
	INNER JOIN #CERTIFICADOSTMP ON 
				#CERTIFICADOSTMP.CodFondo = LIQUIDACIONES.CodFondo
			AND #CERTIFICADOSTMP.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
			AND #CERTIFICADOSTMP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
			AND #CERTIFICADOSTMP.CodTpLiquidacion = LIQUIDACIONES.CodTpLiquidacion
	WHERE LIQUIDACIONES.EstaAnulado = 0
	AND LIQUIDACIONES.CodCuotapartista = @CodCuotapartista
	AND LIQUIDACIONES.FechaConcertacion = (SELECT MAX(FechaConcertacion) 
										   FROM LIQUIDACIONES LIQ 
										   WHERE LIQ.CodFondo = LIQUIDACIONES.CodFondo
											AND LIQ.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
											AND LIQ.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
											AND LIQ.CodTpLiquidacion = LIQUIDACIONES.CodTpLiquidacion AND FechaConcertacion < @FechaDesde)
END
ELSE
BEGIN
	/*Busco la 1er liquidacion*/
	DECLARE @CodLiquidacion CodigoLargo

	SELECT TOP 1 @CodLiquidacion = LIQUIDACIONES.CodLiquidacion
	FROM LIQUIDACIONES
	WHERE LIQUIDACIONES.EstaAnulado = 0
	AND LIQUIDACIONES.CodCuotapartista = @CodCuotapartista
	AND LIQUIDACIONES.FechaConcertacion >= @FechaDesde 
	ORDER BY LIQUIDACIONES.CodLiquidacion

	IF @CodLiquidacion > 0
	BEGIN
		INSERT #CERTIFICADOSTMP
			(CodFondo	
			,CodTpValorCp
			,CodTpLiquidacion		
			,CodLiquidacion	
			,CodMoneda
			,CodCuotapartista	
			,CodCondicionIngEgr
			,Importe
			,NumCertificado	
			,CantCuotapartes
			,FechaSolicitud)
			SELECT LIQUIDACIONES.CodFondo	
				  ,LIQUIDACIONES.CodTpValorCp
				  ,'SU'		
				  ,LIQUIDACIONES.CodTpValorCp
				  ,FONDOS.CodMoneda	
				  ,LIQUIDACIONES.CodCuotapartista	
				  ,LIQUIDACIONES.CodCondicionIngEgr
				  ,LIQUIDACIONES.Importe
				  ,0
				  ,LIQUIDACIONES.CantCuotapartes
				  ,LIQUIDACIONES.FechaConcertacion
			FROM LIQUIDACIONES 
			INNER JOIN FONDOS ON FONDOS.CodFondo = LIQUIDACIONES.CodFondo
			WHERE LIQUIDACIONES.CodLiquidacion = @CodLiquidacion
	END
END

 --SELECT * FROM #CERTIFICADOSTMP

-- Carga todas las liquidaciones positivas (que suman tenencia)
INSERT #CERTIFICADOSTMP
	(CodFondo	
	,CodTpValorCp
	,CodTpLiquidacion	
	,CodLiquidacion	
	,CodMoneda	
	,CodCuotapartista	
	,CodCondicionIngEgr
	,FechaSolicitud	
	,NumCertificado	
	,CantCuotapartes)
	SELECT LIQUIDACIONES.CodFondo	
		  ,LIQUIDACIONES.CodTpValorCp
		  ,LIQUIDACIONES.CodTpLiquidacion	
		  ,LIQUIDACIONES.CodLiquidacion	
		  ,LIQUIDACIONES.CodMoneda	
		  ,LIQUIDACIONES.CodCuotapartista	
		  ,LIQUIDACIONES.CodCondicionIngEgr
		  ,LIQUIDACIONES.FechaConcertacion
		  ,LIQUIDACIONES.NumLiquidacion
		  ,LIQUIDACIONES.CantCuotapartes
	FROM LIQUIDACIONES 
	INNER JOIN TPLIQUIDACION ON TPLIQUIDACION.CodTpLiquidacion = LIQUIDACIONES.CodTpLiquidacion
	WHERE TPLIQUIDACION.SignoPositivo = -1 AND LIQUIDACIONES.EstaAnulado = 0
	AND LIQUIDACIONES.CodCuotapartista = @CodCuotapartista
	AND LIQUIDACIONES.FechaConcertacion BETWEEN @FechaDesde AND @FechaHasta

-- carga todas las liquidaciones negativas (que restan tenencia)
INSERT #CERTIFICADOSRESCTMP
	(CodFondo	
	,CodTpLiquidacion	
	,CodTpValorCp
	,CodLiquidacion	
	,CodCondicionIngEgr
	,CodMoneda	
	,CodCuotapartista	
	,FechaSolicitud
	,CantCuotapartes)
	SELECT LIQUIDACIONES.CodFondo	
		,LIQUIDACIONES.CodTpLiquidacion	
		,LIQUIDACIONES.CodTpValorCp
		,LIQUIDACIONES.CodLiquidacion	
		,LIQUIDACIONES.CodCondicionIngEgr
		,LIQUIDACIONES.CodMoneda	
		,LIQUIDACIONES.CodCuotapartista	
		,LIQUIDACIONES.FechaConcertacion
		,abs(LIQUIDACIONES.CantCuotapartes)
	FROM LIQUIDACIONES 
	INNER JOIN TPLIQUIDACION ON TPLIQUIDACION.CodTpLiquidacion = LIQUIDACIONES.CodTpLiquidacion
	WHERE TPLIQUIDACION.SignoPositivo = 0 AND LIQUIDACIONES.EstaAnulado = 0
	AND LIQUIDACIONES.CodCuotapartista = @CodCuotapartista
	AND LIQUIDACIONES.FechaConcertacion BETWEEN @FechaDesde AND @FechaHasta

-- SELECT * FROM #CERTIFICADOSTMP


-- GENERO UNA TABLA UNICA PARA EL CALCULO

INSERT INTO #SOLICITUDES (
     CodFondo	
	,CodTpValorCp
	,CodTpLiquidacion	
	,CodLiquidacion	
	,CodMoneda	
	,CodCuotapartista	
	,CodCondicionIngEgr
	,FechaSolicitud
	,ImporteDia
	,CantCuotapartes) (
	SELECT   CodFondo	
			,CodTpValorCp
			,CodTpLiquidacion	
			,CodLiquidacion	
			,CodMoneda	
			,CodCuotapartista	
			,CodCondicionIngEgr
			,FechaSolicitud
			,Importe
			,CantCuotapartes
	  FROM #CERTIFICADOSTMP
	UNION
	SELECT   CodFondo	
			,CodTpValorCp
			,CodTpLiquidacion	
			,CodLiquidacion	
			,CodMoneda	
			,CodCuotapartista	
			,CodCondicionIngEgr
			,FechaSolicitud
			,Importe
			,CantCuotapartes
	  FROM #CERTIFICADOSRESCTMP )

UPDATE #SOLICITUDES
   SET VCPDia   =  VDIARIO.ValorCuotaparte,
       VCPFinal =  VFINAL.ValorCuotaparte
  FROM #SOLICITUDES,
       VALORESCP VDIARIO,
       VALORESCP VFINAL
 WHERE #SOLICITUDES.CodFondo       = VDIARIO.CodFondo
   AND #SOLICITUDES.CodTpValorCp   = VDIARIO.CodTpValorCp
   AND #SOLICITUDES.FechaSolicitud = VDIARIO.Fecha 
   AND #SOLICITUDES.CodFondo       = VFINAL.CodFondo
   AND #SOLICITUDES.CodTpValorCp   = VFINAL.CodTpValorCp
   AND VFINAL.Fecha = (SELECT MAX(Fecha) 
						FROM VALORESCP VCP 
					   WHERE VCP.CodFondo       = VFINAL.CodFondo
						   AND VCP.CodTpValorCp   = VFINAL.CodTpValorCp
						   AND VCP.Fecha <= @FechaHasta)

--select * FROM #SOLICITUDES

-- Actualiza importes
UPDATE #SOLICITUDES
   SET ImporteDia   = CantCuotapartes * VCPDia,
       ImporteFinal = CantCuotapartes * VCPFinal
WHERE ImporteDia IS NOT NULL


-- Actualiza resultado
UPDATE #SOLICITUDES
   SET Resultado = ImporteFinal - ImporteDia

 SELECT * FROM #SOLICITUDES

-- SALIDA
SELECT SUM(#SOLICITUDES.Resultado) as Importe, 
	   (SUM(#SOLICITUDES.Resultado)/SUM(#SOLICITUDES.ImporteDia)) *100 as Porcentaje, 
	   MONEDAS.Simbolo
FROM #SOLICITUDES
INNER JOIN MONEDAS ON MONEDAS.CodMoneda = #SOLICITUDES.CodMoneda
GROUP BY MONEDAS.Simbolo



DROP TABLE #CERTIFICADOSTMP
DROP TABLE #CERTIFICADOSRESCTMP
DROP TABLE #SOLICITUDES

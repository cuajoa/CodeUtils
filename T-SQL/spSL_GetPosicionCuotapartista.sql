
exec sp_CreateProcedure 'dbo.spSL_GetPosicionCuotapartista'
GO

ALTER PROCEDURE dbo.spSL_GetPosicionCuotapartista	
    @Fecha					Fecha,
	@NumeroCuotapartista		DescripcionLarga,
	@CodInterfazCuotapartista	DescripcionLarga,
	@NumeroAgColocadores		DescripcionLarga, 
	@CodInterfazAgColocadores	DescripcionLarga,
	@NumeroOficialesCuenta		DescripcionLarga, 
	@CodInterfazOficialesCuenta	DescripcionLarga

WITH ENCRYPTION
AS

DECLARE @CodCli varchar(30)
SELECT @CodCli=ValorParametro FROM PARAMETROS
WHERE CodParametro='CODCLI'

	CREATE TABLE #CUOTAPARTISTAS_TMP
	(
		CodCuotapartista NUMERIC(15),
		CodTpCuotapartista NUMERIC(15),
		CodInterfaz VARCHAR(30),
		NumCuotapartista NUMERIC(15),
		Nombre VARCHAR(80),
		CodOficialCta NUMERIC(15),
		CodAgColocadorOfCta NUMERIC(15),
		CodAgColocador NUMERIC(15)
	)

	IF (@NumeroCuotapartista IS NULL) AND (@CodInterfazCuotapartista IS NULL) AND (@NumeroAgColocadores IS NULL) AND (@CodInterfazAgColocadores IS NULL)
		BEGIN
			INSERT INTO #CUOTAPARTISTAS_TMP
				SELECT CodCuotapartista, CodTpCuotapartista, CodInterfaz, NumCuotapartista, Nombre, CodOficialCta, CodAgColocadorOfCta, CodAgColocador
				FROM CUOTAPARTISTAS
		END
	ELSE
		BEGIN
			IF (@NumeroCuotapartista IS NOT NULL)
			BEGIN
				INSERT INTO #CUOTAPARTISTAS_TMP
					SELECT CodCuotapartista, CodTpCuotapartista, CodInterfaz, NumCuotapartista, Nombre, CodOficialCta, CodAgColocadorOfCta, CodAgColocador
					FROM CUOTAPARTISTAS
					WHERE  CUOTAPARTISTAS.NumCuotapartista IN (SELECT CAST(Valor AS numeric(15)) FROM fn_Split(@NumeroCuotapartista, ','))
			END

			IF (@CodInterfazCuotapartista IS NOT NULL)
			BEGIN
				INSERT INTO #CUOTAPARTISTAS_TMP
					SELECT CodCuotapartista, CodTpCuotapartista, CodInterfaz, NumCuotapartista, Nombre, CodOficialCta, CodAgColocadorOfCta, CodAgColocador
					FROM CUOTAPARTISTAS
					WHERE  CUOTAPARTISTAS.CodInterfaz IN (SELECT CAST(Valor AS varchar(30)) FROM fn_Split(@CodInterfazCuotapartista, ','))

					SELECT TOP 1 @NumeroCuotapartista = NumCuotapartista
					FROM CUOTAPARTISTAS
					WHERE  CUOTAPARTISTAS.CodInterfaz IN (SELECT CAST(Valor AS varchar(30)) FROM fn_Split(@CodInterfazCuotapartista, ','))


			END
			
			IF (@NumeroAgColocadores IS NOT NULL)
			BEGIN
				INSERT INTO #CUOTAPARTISTAS_TMP
					SELECT CodCuotapartista, CodTpCuotapartista, CUOTAPARTISTAS.CodInterfaz, NumCuotapartista, Nombre, CodOficialCta, CodAgColocadorOfCta, CUOTAPARTISTAS.CodAgColocador
					FROM CUOTAPARTISTAS
					INNER JOIN AGCOLOCADORES ON CUOTAPARTISTAS.CodAgColocadorOfCta=AGCOLOCADORES.CodAgColocador
					WHERE  AGCOLOCADORES.NumAgColocador IN (SELECT CAST(Valor AS numeric(15)) FROM fn_Split(@NumeroAgColocadores, ','))
					AND CodCuotapartista NOT IN (SELECT CodCuotapartista FROM #CUOTAPARTISTAS_TMP)
			END	
		END

	SELECT
		FONDOS.CodInterfaz  AS FondoID
		,FONDOS.NumFondo AS FondoNumero 
		,FONDOS.Nombre AS FondoNombre
		,TPVALORESCP.CodCAFCI  AS TipoVCPID
		,TPVALORESCP.Abreviatura AS TipoVCPAbreviatura
		,TPVALORESCP.Descripcion AS TipoVCPDescripcion
		,#CUOTAPARTISTAS_TMP.CodInterfaz AS CuotapartistaID
		,#CUOTAPARTISTAS_TMP.NumCuotapartista AS CuotapartistaNumero
		,#CUOTAPARTISTAS_TMP.Nombre AS CuotapartistaNombre
		,SUM(LIQUIDACIONES.CantCuotapartes) AS CuotapartesTotales
		,ISNULL(BLOQUEOS.CuotapartesBloqueadas, 0) AS CuotapartesBloqueadas
		,SUM(LIQUIDACIONES.CantCuotapartes) * VALORESCP.ValorCuotaparte AS CuotapartesValuadas
		,VALORESCP.ValorCuotaparte AS UltimoVCPValor, MAX(VALORESCP.Fecha) AS UltimoVCPFecha
		,CONDICIONESINGEGR.CodInterfaz AS 'IDCondicionIngEgr'
		,CASE WHEN (CONDICIONESINGEGR.CodInterfaz ='ACSA') THEN CONDMON.CodInterfazACSA ELSE CONDMON.CodInterfaz END AS IDMoneda
		,CONDMON.Descripcion AS MonedaDescripcion
		,CONDMON.Simbolo as MonedaSimbolo 
	FROM LIQUIDACIONES
	INNER JOIN #CUOTAPARTISTAS_TMP ON LIQUIDACIONES.CodCuotapartista = #CUOTAPARTISTAS_TMP.CodCuotapartista
	INNER JOIN FONDOSREAL FONDOS ON FONDOS.CodFondo = LIQUIDACIONES.CodFondo
	--INNER JOIN FONDOSPARAM on FONDOS.CodFondo = FONDOSPARAM.CodFondo 
	--	AND FONDOSPARAM.CodParametroFdo ='NRCNV'
	INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo
		AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
	INNER JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo 
		AND VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
		AND VALORESCP.Fecha = (SELECT MAX(Fecha) 
			FROM VALORESCP VAL2MAX 
			WHERE VAL2MAX.CodFondo = VALORESCP.CodFondo
			AND VAL2MAX.CodTpValorCp = VALORESCP.CodTpValorCp AND VAL2MAX.Fecha <= @Fecha)
	INNER JOIN CONDICIONESINGEGR ON CONDICIONESINGEGR.CodFondo = LIQUIDACIONES.CodFondo AND CONDICIONESINGEGR.CodCondicionIngEgr = LIQUIDACIONES.CodCondicionIngEgr AND CONDICIONESINGEGR.EstaAnulado = 0
	LEFT  JOIN CONDINGEGRMON
            ON CONDINGEGRMON.CodFondo = CONDICIONESINGEGR.CodFondo
            AND CONDINGEGRMON.CodCondicionIngEgr = CONDICIONESINGEGR.CodCondicionIngEgr 
            AND CONDINGEGRMON.FechaVigencia = (  SELECT  COALESCE(MAX(CONDIEM.FechaVigencia),GETDATE())
                                                FROM    CONDINGEGRMON CONDIEM
                                                WHERE   CONDIEM.CodFondo = CONDINGEGRMON.CodFondo
                                                    AND CONDIEM.CodCondicionIngEgr = CONDINGEGRMON.CodCondicionIngEgr)
    INNER JOIN MONEDAS CONDMON ON CONDINGEGRMON.CodMoneda = CONDMON.CodMoneda
	LEFT JOIN(SELECT CPTBLOQUEOS.CodFondo, CPTBLOQUEOS.CodTpValorCp, CPTBLOQUEOS.CodCuotapartista, SUM(CPTBLOQUEOS.CantidadCuotapartes) AS CuotapartesBloqueadas
			FROM CPTBLOQUEOS Where CPTBLOQUEOS.FechaBloqueo <= DateAdd(Day, DateDiff(Day, 0, @Fecha), 0)
			GROUP BY CPTBLOQUEOS.CodFondo, CPTBLOQUEOS.CodTpValorCp, CPTBLOQUEOS.CodCuotapartista) AS BLOQUEOS
		ON BLOQUEOS.CodFondo = LIQUIDACIONES.CodFondo AND BLOQUEOS.CodTpValorCp = LIQUIDACIONES.CodTpValorCp And BLOQUEOS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
	INNER JOIN AGCOLOCADORES  ON LIQUIDACIONES.CodAgColocador = AGCOLOCADORES.CodAgColocador
	LEFT JOIN OFICIALESCTA ON OFICIALESCTA.CodAgColocador = AGCOLOCADORES.CodAgColocador 
		AND #CUOTAPARTISTAS_TMP.CodOficialCta = OFICIALESCTA.CodOficialCta 
		AND OFICIALESCTA.CodOficialCta = LIQUIDACIONES.CodOficialCta 
		AND OFICIALESCTA.CodAgColocador = #CUOTAPARTISTAS_TMP.CodAgColocadorOfCta 
		AND AGCOLOCADORES.CodAgColocador = #CUOTAPARTISTAS_TMP.CodAgColocador  
	WHERE LIQUIDACIONES.EstaAnulado = 0 AND LIQUIDACIONES.FechaConcertacion <= @Fecha  
		AND FONDOS.EstaAnulado = 0 AND CONDICIONESINGEGR.EstaAnulado = 0 
		AND (@NumeroOficialesCuenta IS NULL OR OFICIALESCTA.NumOficialCta IN (SELECT CAST(Valor AS numeric(15)) FROM fn_Split(@NumeroOficialesCuenta, ',')) OR 
			@CodInterfazOficialesCuenta IS NULL OR OFICIALESCTA.CodInterfaz IN (SELECT CAST(Valor AS numeric(15)) FROM fn_Split(@CodInterfazOficialesCuenta, ',')))
		AND  #CUOTAPARTISTAS_TMP.NumCuotapartista IN (SELECT CAST(Valor AS numeric(15)) FROM fn_Split(@NumeroCuotapartista, ','))
	GROUP BY FONDOS.CodInterfaz , FONDOS.NumFondo, FONDOS.Nombre, TPVALORESCP.CodCAFCI , TPVALORESCP.Abreviatura, TPVALORESCP.Descripcion, 
		#CUOTAPARTISTAS_TMP.CodInterfaz, #CUOTAPARTISTAS_TMP.NumCuotapartista, #CUOTAPARTISTAS_TMP.Nombre, BLOQUEOS.CuotapartesBloqueadas, VALORESCP.ValorCuotaparte, 
		VALORESCP.Fecha,CONDICIONESINGEGR.CodInterfaz, CONDMON.CodInterfaz, CONDMON.Descripcion, CONDMON.Simbolo, CONDMON.CodInterfazACSA --, AGCOLOCADORES.CodAgColocador, OFICIALESCTA.CodOficialCta
	HAVING  SUM(LIQUIDACIONES.CantCuotapartes) > 0 
	ORDER BY FONDOS.NumFondo, TPVALORESCP.Abreviatura, #CUOTAPARTISTAS_TMP.NumCuotapartista, VALORESCP.Fecha

	
	DROP TABLE #CUOTAPARTISTAS_TMP
	--DROP TABLE #TEMP_LIQ

GO


DECLARE @CodCuotapartista		CodigoLargo = 555
DECLARE @CodFondo				CodigoMedio = 1
DECLARE @CodTpValorCp			CodigoCorto = 9
DECLARE @CodTpValorCpBD			CodigoCorto = NULL
DECLARE @CodCondicionIngEgr		CodigoMedio = 115
DECLARE @Importe				Importe = 500000

DECLARE @TienePosicion numeric(2)

CREATE TABLE #POSICIONCPT(
	CodCuotapartista numeric(10) NOT NULL,
	CodFondo numeric(10) NOT NULL,
	CodTpValorCp numeric(10) NOT NULL,
	CodCondicionIngEgr numeric(10) NOT NULL,
	MontoMinimo numeric(19,2) NOT NULL,
	TienePosicion smallint NOT NULL
)

--Tiene posicion en el fondo clase que envía
--SELECT @TienePosicion=CASE WHEN ISNULL(SUM(CantCuotapartes),0)>0 THEN -1 ELSE 0 END
--FROM LIQUIDACIONES
--WHERE CodCuotapartista=@CodCuotapartista AND CodFondo=@CodFondo AND CodTpValorCp=@CodTpValorCp
--GROUP BY CodCuotapartista, CodFondo, CodTpValorCp

	--Busca toda la posicion del cliente en el fondo, si tiene posicion
	INSERT INTO #POSICIONCPT(CodCuotapartista,CodFondo,CodTpValorCp,CodCondicionIngEgr,MontoMinimo,TienePosicion)
	SELECT LIQUIDACIONES.CodCuotapartista,LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCondicionIngEgr,CONDICIONESINGEGR.SuscripcionMinima, CASE WHEN ISNULL(SUM(CantCuotapartes),0)>0 THEN -1 ELSE 0 END
	FROM LIQUIDACIONES
	LEFT JOIN CONDICIONESINGEGR ON LIQUIDACIONES.CodCondicionIngEgr = CONDICIONESINGEGR.CodCondicionIngEgr AND LIQUIDACIONES.CodFondo = CONDICIONESINGEGR.CodFondo
	LEFT JOIN CONDINGEGRTPVALORESCP ON LIQUIDACIONES.CodCondicionIngEgr = CONDINGEGRTPVALORESCP.CodCondicionIngEgr AND LIQUIDACIONES.CodFondo = CONDINGEGRTPVALORESCP.CodFondo
	AND LIQUIDACIONES.CodTpValorCp = CONDINGEGRTPVALORESCP.CodTpValorCp
	WHERE CodCuotapartista=@CodCuotapartista AND CONDICIONESINGEGR.CodFondo=@CodFondo  AND CONDICIONESINGEGR.EstaAnulado=0 --AND CodTpValorCp=@CodTpValorCp
	GROUP BY CodCuotapartista, LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCondicionIngEgr, CONDICIONESINGEGR.SuscripcionMinima


	--Si no registro posicion cargo la info de los fondos
	IF (SELECT COUNT(CodCuotapartista) FROM #POSICIONCPT)=0
	BEGIN 
		INSERT INTO #POSICIONCPT(CodCuotapartista,CodFondo,CodTpValorCp,CodCondicionIngEgr,MontoMinimo,TienePosicion)
		SELECT @CodCuotapartista,CONDICIONESINGEGR.CodFondo, CONDINGEGRTPVALORESCP.CodTpValorCp, CONDICIONESINGEGR.CodCondicionIngEgr,CONDICIONESINGEGR.SuscripcionMinima,  0
		FROM CONDICIONESINGEGR 
		INNER JOIN CONDINGEGRTPVALORESCP ON CONDICIONESINGEGR.CodCondicionIngEgr = CONDINGEGRTPVALORESCP.CodCondicionIngEgr AND CONDICIONESINGEGR.CodFondo = CONDINGEGRTPVALORESCP.CodFondo
		WHERE CONDICIONESINGEGR.CodFondo=@CodFondo AND CONDICIONESINGEGR.EstaAnulado=0
	GROUP BY CONDICIONESINGEGR.CodFondo, CONDINGEGRTPVALORESCP.CodTpValorCp, CONDICIONESINGEGR.CodCondicionIngEgr,CONDICIONESINGEGR.SuscripcionMinima
	END
	
	DECLARE @CodCondicionIngEgrNueva numeric(10)=-1

	SELECT TOP 1 @CodCondicionIngEgrNueva=CodCondicionIngEgr FROM #POSICIONCPT
	WHERE TienePosicion = -1 AND MontoMinimo < @Importe
	ORDER BY MontoMinimo DESC

	IF (@CodCondicionIngEgrNueva=-1 ) 
	BEGIN 
		SELECT TOP 1 @CodCondicionIngEgrNueva=CodCondicionIngEgr FROM #POSICIONCPT
		WHERE MontoMinimo < @Importe
		ORDER BY MontoMinimo ASC
	END

	SELECT @CodCondicionIngEgrNueva

	SELECT CONDINGEGRTPVALORESCP.*
	FROM CONDINGEGRTPVALORESCP
	INNER JOIN TPVALORESCP ON CONDINGEGRTPVALORESCP.CodFondo = TPVALORESCP.CodFondo AND   CONDINGEGRTPVALORESCP.CodTpValorCp = TPVALORESCP.CodTpValorCp
	Where CodCondicionIngEgr=@CodCondicionIngEgrNueva

	DROP TABLE #POSICIONCPT

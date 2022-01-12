/*********************************************************/
/* SITER - Archivo a informar en la AFIP (Formulario 4298)*/
/*********************************************************/

EXEC sp_CreateProcedure 'dbo.spSITER_ArchivoAFIP'
GO
 
ALTER PROCEDURE dbo.spSITER_ArchivoAFIP
	
	@FechaDesde as Fecha,
	@FechaHasta as Fecha,
	@CodAgColocador as CodigoMedio,
	@NumeroSecuencia as int

WITH ENCRYPTION

AS
	
	--/* Valores de entrada --> */ 
	--DECLARE @FechaDesde as Fecha
	--DECLARE @FechaHasta as Fecha
	--DECLARE @CodAgColocador as CodigoMedio

	--SET @FechaDesde = '06/25/2006'
	--SET @FechaHasta = '04/30/2008'
	--SET @CodAgColocador = (Select CodAgColocador from AGCOLOCADORES Where NumAgColocador = 120)	--NumAgColocador
	--/* Valores de entrada <-- */ 

IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..##SITER_CuotapartistasProcesar'))
	DROP TABLE ##SITER_CuotapartistasProcesar

CREATE TABLE ##SITER_CuotapartistasProcesar
(
	ID int identity(1,1),
	CodCuotapartista numeric(10,0)
)

IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#SITER_DatosImprimir'))
	DROP TABLE #SITER_DatosImprimir

CREATE TABLE #SITER_DatosImprimir
(
	NroRegistro int identity(1,1),
	Linea	varchar(600)
)
	
	/* 1. Cargo los datos de la cabecera a informar */
	/*****************************************/
	INSERT INTO #SITER_DatosImprimir (Linea)
		EXEC dbo.spSITER_Encabezado @FechaDesde, @FechaHasta, @CodAgColocador, @NumeroSecuencia

	/* 2. Inserto lineas de detalle de Operaciones*/
	/*****************************************/
	INSERT INTO #SITER_DatosImprimir (Linea)
		EXEC dbo.spSITER_Detalle_Operaciones @FechaDesde, @FechaHasta, @CodAgColocador

	/* 3. Obtengo los cuotapartistas con liquidaciones y los recorro */
	/*****************************************/
	DECLARE @CodCuotapartista NUMERIC(10,0)
	DECLARE @i				CodigoMedio
	DECLARE @iCantidad		CodigoMedio

	INSERT INTO ##SITER_CuotapartistasProcesar (CodCuotapartista)
		SELECT DISTINCT LIQUIDACIONES.CodCuotapartista
		FROM LIQUIDACIONES  WITH (INDEX(XIF40LIQUIDACIONES)) 
				INNER JOIN CUOTAPARTISTAS ON LIQUIDACIONES.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
											--AND CUOTAPARTISTAS.EstaAnulado = 0
				INNER JOIN FONDOSREAL ON LIQUIDACIONES.CodFondo = FONDOSREAL.CodFondo
										AND FONDOSREAL.EstaAnulado = 0
		WHERE LIQUIDACIONES.EstaAnulado = 0
		AND LIQUIDACIONES.CodTpLiquidacion IN ('SU','TP','RE','TN')
		AND LIQUIDACIONES.FechaLiquidacion >= @FechaDesde AND LIQUIDACIONES.FechaLiquidacion <= @FechaHasta
		AND FONDOSREAL.CodAgColocadorDep = @CodAgColocador


	SET @iCantidad = isnull((SELECT COUNT(*) FROM ##SITER_CuotapartistasProcesar) ,0)
	SET @i =1

	WHILE @i <= @iCantidad
	BEGIN
		SELECT @CodCuotapartista = ##SITER_CuotapartistasProcesar.CodCuotapartista
		FROM ##SITER_CuotapartistasProcesar
		WHERE ##SITER_CuotapartistasProcesar.ID = @i

		/* 4. Inserto linea/s de detalle Referenciales */
		/*****************************************/
		INSERT INTO #SITER_DatosImprimir (Linea)
			EXEC dbo.spSITER_Detalle_Referenciales @CodCuotapartista, @FechaDesde, @FechaHasta

		SET @i = @i + 1
	END

	/* 5. Devuelvo la Info */
	/***********************/
	Select Linea
	From #SITER_DatosImprimir
	order by NroRegistro


	DROP TABLE #SITER_DatosImprimir
	DROP TABLE ##SITER_CuotapartistasProcesar
GO

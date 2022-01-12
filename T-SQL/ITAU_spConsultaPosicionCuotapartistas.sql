
--DECLARE @Fecha Fecha = NULL
--DECLARE @NumFondo NumeroCorto = NULL

--SET @Fecha = '01/18/2018'
--SET @NumFondo = 14

--EXEC dbo.spConsultaPosicionCuotapartistas @Fecha, @NumFondo
--EXEC dbo.spConsultaPosicionCuotapartistas '2017-10-01', 1

--------------------------------------------------

EXEC sp_CreateProcedure 'dbo.spConsultaPosicionCuotapartistas'
GO
ALTER PROCEDURE dbo.spConsultaPosicionCuotapartistas
    @Fecha Fecha = null,
	@NumFondo NumeroCorto  = null
WITH ENCRYPTION 
AS 
	SET NOCOUNT ON
	SET FMTONLY OFF

	/*FILTROS --> */
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#FILTRO_FONDOS'))
		DROP TABLE #FILTRO_FONDOS

	CREATE TABLE #FILTRO_FONDOS
	(CodFondo Numeric(5))

	IF @NumFondo IS NULL 
		BEGIN
			INSERT INTO #FILTRO_FONDOS(CodFondo)
				SELECT CodFondo FROM FONDOSREAL WHERE EstaAnulado = 0
		END
	ELSE
		BEGIN
			INSERT INTO #FILTRO_FONDOS(CodFondo)
				SELECT CodFondo FROM FONDOSREAL WHERE NumFondo = @NumFondo AND EstaAnulado = 0
		END
	/*<-- FILTROS*/

	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#INT_POSCPT_CPT'))
		DROP TABLE #INT_POSCPT_CPT
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#INT_POSCPT_FONDOS'))
		DROP TABLE #INT_POSCPT_FONDOS
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#INT_POSCPT_SALDO'))
		DROP TABLE #INT_POSCPT_SALDO
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#INT_POSCPT_BLOQUEADO'))
		DROP TABLE #INT_POSCPT_BLOQUEADO

	CREATE TABLE #INT_POSCPT_CPT
	(
		CodCuotapartista Numeric(10) PRIMARY KEY,
		NumCuotapartista Numeric(15) null,
		NomCuotapartista varchar(80) COLLATE DATABASE_DEFAULT null,
		EsPersonaFisica bit null,
		FechaIngreso smalldatetime null,
		Calle varchar(50) COLLATE DATABASE_DEFAULT null,
		AlturaCalle varchar(8) COLLATE DATABASE_DEFAULT null,
		Piso varchar(5) COLLATE DATABASE_DEFAULT null,
		Departamento varchar(6) COLLATE DATABASE_DEFAULT null,
		Localidad varchar(50) COLLATE DATABASE_DEFAULT null,
		CodigoPostal varchar(10) COLLATE DATABASE_DEFAULT null,
		CodCanalVta Numeric(10),
		CodSegmentoInv Numeric(10),
		CUIT Numeric(11),
		CodPais Numeric(10),
		CodProvincia Numeric(10),
		CodReferente Numeric(10),
		CodAreaPertenencia Numeric(10),
		CodCentroFisico Numeric(10),
		CodAgColocador Numeric(10),
		CodSucursal Numeric(10),
		CodOficialCta Numeric(10),
		CodZona Numeric(10),
		Pais varchar(80) COLLATE DATABASE_DEFAULT null,
		Provincia varchar(80) COLLATE DATABASE_DEFAULT null,
		SegmentoInv varchar(80) COLLATE DATABASE_DEFAULT null,
		CanalVta varchar(80) COLLATE DATABASE_DEFAULT null,
		Referente varchar(80) COLLATE DATABASE_DEFAULT null,
		AreaPertenencia varchar(80) COLLATE DATABASE_DEFAULT null,
		AreaPertenenciaInterfaz varchar(30) COLLATE DATABASE_DEFAULT null,
		CentroFisico varchar(80) COLLATE DATABASE_DEFAULT null,
		CentroFisicoInterfaz varchar(30) COLLATE DATABASE_DEFAULT null,
		Domicilio varchar(1500) COLLATE DATABASE_DEFAULT null,
		Zona varchar(80) COLLATE DATABASE_DEFAULT null,
		AgColocador varchar(80) COLLATE DATABASE_DEFAULT null,
		NumAgColocador Numeric(15),
		Sucursal varchar(80) COLLATE DATABASE_DEFAULT null,
		NumSucursal Numeric(15),
		OficialCta varchar(80) COLLATE DATABASE_DEFAULT null,
		NumOficialCta Numeric(15),
		AgColocadorOrigen varchar(80) COLLATE DATABASE_DEFAULT null,
		NumAgColocadorOrigen Numeric(15),
		SucursalOrigen varchar(80) COLLATE DATABASE_DEFAULT null,
		NumSucursalOrigen Numeric(15),
		CodAgColocadorOrigen varchar(1500) COLLATE DATABASE_DEFAULT null,
		CodSucursalOrigen Numeric(10),
	)
	CREATE TABLE #INT_POSCPT_FONDOS
	(
		CodFondo Numeric(10),
		CodMoneda Numeric(10) NULL,
		NomFondo VARCHAR(15) NULL,
		NumFondo Numeric(6) NULL,
		FondoNombre varchar(30) null,
		FondoNombreAbreviado varchar(30) null,
		Moneda varchar(80) COLLATE DATABASE_DEFAULT null,
		SimboloMoneda VARCHAR(6) NULL,
		CodTpValorCp Numeric(9)  NULL,
		TpValorCp varchar(30) COLLATE DATABASE_DEFAULT null,
		Fecha SMALLDATETIME null,
		ValorCuotaparte Numeric(19,10) null,
		CuotapartesCirculacion Numeric(22,8) null,
		PatrimonioNeto Numeric(19,2) null,
		CodInterfazFondo varchar(15) COLLATE DATABASE_DEFAULT null,
		CodInterfazMoneda varchar(30) COLLATE DATABASE_DEFAULT null,
		CodInterfazTpValorCp varchar(30) COLLATE DATABASE_DEFAULT null,
		TpValorCpAbrev varchar(10) COLLATE DATABASE_DEFAULT null
	)
	CREATE TABLE #INT_POSCPT_SALDO
	(
		CodFondo Numeric(10) NOT NULL,
		CodTpValorCp Numeric(9) NOT NULL,
		CodCondicionIngEgr Numeric(9) NOT NULL,
		CodCuotapartista Numeric(9) NOT NULL,
		CantCuotapartes Numeric(22,8) NOT null,
		Inversion Numeric(19,2) null,
		Porcentaje Numeric(12,8) NOT NULL,
		CtasBloqueadas Numeric(22,8) NULL, 
		CtasDisponibles Numeric(22,8) NULL, 
		CtasRescSinLiquidar Numeric(22,8) NULL
	)
	CREATE TABLE #INT_POSCPT_BLOQUEADO
	(
		CodFondo  Numeric(10) NOT NULL,
		CodTpValorCp  Numeric(10) NOT NULL,
		CodCuotapartista Numeric(9) NOT NULL,
		CuotapartesBloqueadas Numeric(22,8) NOT NULL
	)

	EXEC dbo.spConsultaPosicionCuotapartistas_Cpt	/*Cargo la temporal de cuotapartistas*/
	EXEC dbo.spConsultaPosicionCuotapartistas_CptFondos	 /*Cargo la temporal de Fondos indicados con sus respectivas clases */
	EXEC dbo.spConsultaPosicionCuotapartistas_BuscarVCP @Fecha	/*Actualizo el valor de VCP de los fondos y clases */
	EXEC dbo.spConsultaPosicionCuotapartistas_Saldos @Fecha /*Cargo la temporal de Saldos para los fondos y clases */
	EXEC dbo.spConsultaPosicionCuotapartistas_Bloqueados @Fecha /*Cargo la temporal de Bloqueos para los fondos y clases */

	/*RESULTADO*/
	SELECT  CONVERT(VARCHAR(8), @Fecha, 112) as FechaProceso,
			CONVERT(VARCHAR(8), #INT_POSCPT_FONDOS.Fecha, 112) as FechaPosicion,
			#INT_POSCPT_CPT.NumCuotapartista,
			#INT_POSCPT_CPT.NomCuotapartista AS DenominacionCuotapartista,
			#INT_POSCPT_CPT.CUIT AS CuotapartistaCUIT,
			#INT_POSCPT_FONDOS.CodInterfazFondo AS CodInterfazFondo,
			#INT_POSCPT_FONDOS.NumFondo AS NumFondo,
			#INT_POSCPT_FONDOS.FondoNombre AS NombreFondo,
			#INT_POSCPT_FONDOS.FondoNombreAbreviado AS NombreFondoAbreviado,
			#INT_POSCPT_FONDOS.CodInterfazMoneda AS CodInterfazMoneda,
			#INT_POSCPT_FONDOS.CodInterfazTpValorCp AS CodInterfazTpValorCp,
			#INT_POSCPT_FONDOS.TpValorCpAbrev AS TpValorCpAbrev,
			#INT_POSCPT_SALDO.CantCuotapartes AS CantCuotapartes,
			#INT_POSCPT_FONDOS.ValorCuotaparte AS ValorCuotaparte,
			#INT_POSCPT_SALDO.Inversion AS Saldo,
			CASE WHEN #INT_POSCPT_CPT.EsPersonaFisica = 1 THEN 'S' ELSE 'N' END AS EsPersonaFisica,
		 	ISNULL(#INT_POSCPT_BLOQUEADO.CuotapartesBloqueadas, 0) AS CuotapartesBloqueadas
	FROM #INT_POSCPT_SALDO 
			INNER JOIN #INT_POSCPT_CPT ON #INT_POSCPT_CPT.CodCuotapartista = #INT_POSCPT_SALDO.CodCuotapartista
			INNER JOIN #INT_POSCPT_FONDOS ON #INT_POSCPT_FONDOS.CodFondo = #INT_POSCPT_SALDO.CodFondo 
											AND #INT_POSCPT_FONDOS.CodTpValorCp = #INT_POSCPT_SALDO.CodTpValorCp
			LEFT JOIN #INT_POSCPT_BLOQUEADO ON #INT_POSCPT_BLOQUEADO.CodFondo = #INT_POSCPT_SALDO.CodFondo
				AND #INT_POSCPT_FONDOS.CodTpValorCp = #INT_POSCPT_SALDO.CodTpValorCp
				AND #INT_POSCPT_BLOQUEADO.CodCuotapartista = #INT_POSCPT_CPT.CodCuotapartista 
			
	ORDER BY #INT_POSCPT_SALDO.CodFondo,
			 #INT_POSCPT_SALDO.CodTpValorCp,
			 #INT_POSCPT_CPT.NumCuotapartista


	/*Borro temporales*/
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#FILTRO_FONDOS'))
		DROP TABLE #FILTRO_FONDOS
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#INT_POSCPT_CPT'))
		DROP TABLE #INT_POSCPT_CPT
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#INT_POSCPT_FONDOS'))
		DROP TABLE #INT_POSCPT_FONDOS
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#INT_POSCPT_SALDO'))
		DROP TABLE #INT_POSCPT_SALDO
	--IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#INT_POSCPT_CONDOMINIO'))
	--	DROP TABLE #INT_POSCPT_CONDOMINIO
	IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#INT_POSCPT_BLOQUEADO'))
		DROP TABLE #INT_POSCPT_BLOQUEADO

	SET NOCOUNT OFF
GO

EXEC sp_CreateProcedure 'dbo.spConsultaPosicionCuotapartistas_Cpt'
GO 
ALTER PROCEDURE dbo.spConsultaPosicionCuotapartistas_Cpt
  
WITH ENCRYPTION 
AS
	set nocount on 

        if exists (select * from tempdb..sysobjects where id = OBJECT_ID('tempdb..#INT_POSCPT_TITU1'))
		drop TABLE #INT_POSCPT_TITU1

		select CONDOMINIOS.CodCuotapartista, MIN(CONDOMINIOS.Orden) as Orden into #INT_POSCPT_TITU1 from CONDOMINIOS 
		inner join CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista = CONDOMINIOS.CodCuotapartista 
		where CONDOMINIOS.EstaAnulado=0
		group by CONDOMINIOS.CodCuotapartista--, CONDOMINIOS.Orden
		
    
	INSERT INTO #INT_POSCPT_CPT 
		SELECT CUOTAPARTISTAS.CodCuotapartista, CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.Nombre, CUOTAPARTISTAS.EsPersonaFisica, CUOTAPARTISTAS.FechaIngreso,  CUOTAPARTISTAS.Calle, CUOTAPARTISTAS.AlturaCalle, CUOTAPARTISTAS.Piso, 
			   CUOTAPARTISTAS.Departamento,  CUOTAPARTISTAS.Localidad,  CUOTAPARTISTAS.CodigoPostal , CUOTAPARTISTAS.CodCanalVta,  CUOTAPARTISTAS.CodSegmentoInv, 
			   CASE WHEN CUOTAPARTISTAS.EsPersonaFisica = 0 THEN
                     CPTJURIDICOS.CUIT
                ELSE
                     CASE WHEN PERSONAS.CUIT is not null Then
                          PERSONAS.CUIT
                     ELSE
                          CASE WHEN PERSONAS.CUIL is not null THEN
                               PERSONAS.CUIL
                          ELSE
                               PERSONAS.CDI
                          END
                     END
                END AS CUIT,
			   CUOTAPARTISTAS.CodPais, 
			   CUOTAPARTISTAS.CodProvincia, CUOTAPARTISTAS.CodReferente, CUOTAPARTISTAS.CodAreaPertenencia,  CUOTAPARTISTAS.CodCentroFisico ,  CUOTAPARTISTAS.CodAgColocadorOfCta, CUOTAPARTISTAS.CodSucursalOfCta, 
			   CUOTAPARTISTAS.CodOficialCta, NULL CodZona,  null Pais, null Provincia,  null SegmentoInv, null CanalVta,  null Domicilio, null Referente, null AreaPertenencia, null AreaPertenenciaInterfaz,  
			   null CentroFisico, null CentroFisicoInterfaz,  null Zona, null AgColocador, null NumAgColocador,  null Sucursal, null NumSucursal, null OficialCta, NULL NumOficialCta,  
			   AGCOLOCADORES.Descripcion AgColocadorOrigen, AGCOLOCADORES.NumAgColocador NumAgColocadorOrigen, SUCURSALES.Descripcion SucursalOrigen, SUCURSALES.NumSucursal NumSucursalOrigen,  
			   CUOTAPARTISTAS.CodAgColocador, CUOTAPARTISTAS.CodSucursal 
		FROM CUOTAPARTISTAS 
			 LEFT JOIN CPTJURIDICOS ON CPTJURIDICOS.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista 
			 Left Join #INT_POSCPT_TITU1 ON CUOTAPARTISTAS.CodCuotapartista = #INT_POSCPT_TITU1.CodCuotapartista 
			 Left Join CONDOMINIOS ON #INT_POSCPT_TITU1.CodCuotapartista = CONDOMINIOS.CodCuotapartista and #INT_POSCPT_TITU1.Orden = CONDOMINIOS.Orden
			 Left Join PERSONAS ON CONDOMINIOS.CodPersona = PERSONAS.CodPersona 
			 LEFT JOIN AGCOLOCADORES ON AGCOLOCADORES.CodAgColocador = CUOTAPARTISTAS.CodAgColocador 
			 LEFT JOIN SUCURSALES ON SUCURSALES.CodAgColocador = CUOTAPARTISTAS.CodAgColocador and SUCURSALES.CodSucursal = CUOTAPARTISTAS.CodSucursal

	set nocount off
	
GO

EXEC sp_CreateProcedure 'dbo.spConsultaPosicionCuotapartistas_CptFondos'
GO 
ALTER PROCEDURE dbo.spConsultaPosicionCuotapartistas_CptFondos
  
WITH ENCRYPTION 
AS
	set nocount on 
    
	INSERT INTO #INT_POSCPT_FONDOS 
		SELECT FONDOSREAL.CodFondo, FONDOSREAL.CodMoneda, FONDOSREAL.NombreAbreviado, FONDOSREAL.NumFondo, FONDOSREAL.NombreCorto, FONDOSREAL.NombreAbreviado,  MONEDAS.Descripcion, MONEDAS.Simbolo, TPVALORESCP.CodTpValorCp, TPVALORESCP.Abreviatura, 
			   NULL, NULL, NULL, NULL, FONDOSREAL.CodInterfaz, MONEDAS.CodInterfaz, TPVALORESCP.CodInterfaz, TPVALORESCP.Abreviatura
		FROM FONDOSREAL 
			 INNER JOIN #FILTRO_FONDOS ON (#FILTRO_FONDOS.CodFondo = FONDOSREAL.CodFondo)
			 INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = #FILTRO_FONDOS.CodFondo  
			 INNER JOIN MONEDAS ON MONEDAS.CodMoneda = FONDOSREAL.CodMoneda  
		
	set nocount off
	
GO

EXEC sp_CreateProcedure 'dbo.spConsultaPosicionCuotapartistas_BuscarVCP'
GO 
ALTER PROCEDURE dbo.spConsultaPosicionCuotapartistas_BuscarVCP
    @Fecha Fecha 
WITH ENCRYPTION 
AS
	set nocount on 
    UPDATE #INT_POSCPT_FONDOS
        SET Fecha = (SELECT MAX(Fecha) FROM CUOTAPARTES WHERE CUOTAPARTES.CodFondo = #INT_POSCPT_FONDOS.CodFondo and CUOTAPARTES.Fecha <= @Fecha)

    UPDATE #INT_POSCPT_FONDOS
        set ValorCuotaparte         = VALORESCP.ValorCuotaparte
            ,CuotapartesCirculacion = VALORESCP.CuotapartesCirculacion
            ,PatrimonioNeto         = VALORESCP.PatrimonioNeto
    FROM #INT_POSCPT_FONDOS
    INNER JOIN VALORESCP ON VALORESCP.CodFondo = #INT_POSCPT_FONDOS.CodFondo
        AND VALORESCP.CodTpValorCp = #INT_POSCPT_FONDOS.CodTpValorCp
        AND VALORESCP.Fecha = #INT_POSCPT_FONDOS.Fecha

    UPDATE  #INT_POSCPT_FONDOS
        set ValorCuotaparte = TPVALORESCP.ValorCpInicial
    FROM #INT_POSCPT_FONDOS
    INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = #INT_POSCPT_FONDOS.CodFondo
        AND TPVALORESCP.CodTpValorCp = #INT_POSCPT_FONDOS.CodTpValorCp
    INNER JOIN FONDOSREAL FONDOS ON FONDOS.CodFondo = #INT_POSCPT_FONDOS.CodFondo 
    WHERE FONDOS.CodTpFondo = 'MM'

	set nocount off
	
GO

EXEC sp_CreateProcedure 'dbo.spConsultaPosicionCuotapartistas_Saldos'
GO 
ALTER PROCEDURE dbo.spConsultaPosicionCuotapartistas_Saldos
	@Fecha Fecha 
WITH ENCRYPTION 
AS
	set nocount on 
    
	INSERT INTO #INT_POSCPT_SALDO
		SELECT LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, -1,  LIQUIDACIONES.CodCuotapartista ,Sum(CantCuotapartes), Sum(CantCuotapartes * ValorCuotaparte), 0, 0, 0, 0 
		FROM  LIQUIDACIONES 
			  inner join #INT_POSCPT_CPT ON #INT_POSCPT_CPT.CodCuotapartista = LIQUIDACIONES.CodCuotapartista  
			  INNER JOIN #INT_POSCPT_FONDOS ON #INT_POSCPT_FONDOS.CodFondo = LIQUIDACIONES.CodFondo 
												and  #INT_POSCPT_FONDOS.CodTpValorCp = LIQUIDACIONES.CodTpValorCp  
		WHERE FechaConcertacion <= @Fecha AND LIQUIDACIONES.EstaAnulado = 0
		GROUP BY LIQUIDACIONES.CodFondo, LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista, #INT_POSCPT_CPT.NumCuotapartista, #INT_POSCPT_CPT.NomCuotapartista, #INT_POSCPT_FONDOS.ValorCuotaparte 

	set nocount off
	
GO

EXEC sp_CreateProcedure 'dbo.spConsultaPosicionCuotapartistas_Bloqueados'
GO
ALTER PROCEDURE dbo.spConsultaPosicionCuotapartistas_Bloqueados
    @Fecha Fecha = null

WITH ENCRYPTION 
AS 
	set nocount on 

	INSERT INTO #INT_POSCPT_BLOQUEADO
		SELECT  
			CPTBLOQUEOS.CodFondo, 
			CPTBLOQUEOS.CodTpValorCp, 
			CPTBLOQUEOS.CodCuotapartista, 
			SUM(CPTBLOQUEOS.CantidadCuotapartes) AS CuotapartesBloqueadas
		 From CPTBLOQUEOS 
		 Where CPTBLOQUEOS.FechaBloqueo <= DateAdd(Day, DateDiff(Day, 0, @Fecha), 0)
		Group By CPTBLOQUEOS.CodFondo, CPTBLOQUEOS.CodTpValorCp, CPTBLOQUEOS.CodCuotapartista

	set nocount off 
GO
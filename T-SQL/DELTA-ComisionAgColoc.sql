--112165:DELTA-Comisiones por agente colocador-Criterio tomar suscripciones en vez de rescates
IF NOT EXISTS(SELECT 1 FROM PARAMETROS WHERE CodParametro = 'CCACR')
BEGIN
INSERT INTO PARAMETROS (CodParametro, TipoDato, TituloParametro, ValorParametro, EsOculto, CodUsuarioU, FechaU, TermU, EsAuditable, CodCheckSum, EsNueva)
VALUES ('CCACR', 'BOOL', 'Calcular Comisión Agente Colocador tomando en cuenta los Rescates', -1, -1, 1, GETDATE(), HOST_NAME(), 0, NULL, 0)
END

IF EXISTS (SELECT name FROM tempdb..sysobjects where id = object_id('tempdb..#LIQCOMISIONAGCOLOC')) 
	DROP TABLE #LIQCOMISIONAGCOLOC   
go

CREATE TABLE #LIQCOMISIONAGCOLOC
	(CodFondo Numeric(5),
    CodTpValorCp Numeric(5),
	CodAgColocador Numeric(5),
	CodTpLiquidacion Varchar(2) COLLATE DATABASE_DEFAULT,
    TpLiquidacion Varchar(30) COLLATE DATABASE_DEFAULT,
	NumLiquidacion Numeric(15),
	CodCuotapartista Numeric(15),
    NumCuotapartista Numeric(15),
	Cuotapartista Varchar(50) COLLATE DATABASE_DEFAULT,
    CantCuotapartes Numeric(28,8),
	Fecha smalldatetime,
	ImporteHSD Numeric(28,8),
	ImporteHSG Numeric(28,8),
	ImporteGSG Numeric(28,8),
	ImporteGSD Numeric(28,8),
	Importe Numeric(28,8),
	Porcentaje Numeric(28,8) NULL,
    TotalACobrarAgColoc Numeric(19,2) NULL,
    PorcentajeIncidenciaFdo Numeric(28,8) null)
GO

EXEC sp_CreateProcedure 'dbo.spCalculaPatrimonioDiarioAgColoc'
GO 
ALTER PROCEDURE dbo.spCalculaPatrimonioDiarioAgColoc
	@CodFondo CodigoMedio = null,
	@CodTpValorCp CodigoMedio = null,
	@FechaDesde Fecha = null,
	@Fecha Fecha = null,
	@CodAgColocador CodigoMedio = NULL ,
    @DiscCuotapartista Boolean = NULL,
	@ValorCuotaparteAnterior Precio = NULL,
    @CuotapartesCirculacionAnterior CantidadCuotapartes = NULL
 WITH ENCRYPTION 

AS
/*
IF EXISTS (SELECT name FROM tempdb..sysobjects where id = object_id('tempdb..#LIQCOMISIONAGCOLOC')) 
	DROP TABLE #LIQCOMISIONAGCOLOC   
|

CREATE TABLE #LIQCOMISIONAGCOLOC
	(CodFondo Numeric(5),
    CodTpValorCp Numeric(5),
	CodAgColocador Numeric(5),
	CodTpLiquidacion Varchar(2),
    TpLiquidacion Varchar(30),
	NumLiquidacion Numeric(15),
	CodCuotapartista Numeric(15),
    NumCuotapartista Numeric(15),
	Cuotapartista Varchar(50),
    CantCuotapartes Numeric(28,8),
	Fecha smalldatetime,
	ImporteHSD Numeric(28,8),
	ImporteHSG Numeric(28,8),
	ImporteGSG Numeric(28,8),
	ImporteGSD Numeric(28,8),
	Importe Numeric(28,8),
	Porcentaje Numeric(28,8) NULL,
    TotalACobrarAgColoc Numeric(19,2) NULL,
    PorcentajeIncidenciaFdo Numeric(28,8) null)

*/

	DECLARE @CodPais CodigoMedio
	DECLARE @EsFeriado Boolean
	DECLARE @FechaManipulada Fecha
	DECLARE @FechaUltVCP Fecha
	DECLARE @InsertaFeriados Boolean
	DECLARE @TomaRescates Boolean


	--Comisiona Ag. Colocadores / Of. De Cuenta en días no hábiles
	--SELECT @bParametro = convert(smallint,ValorParametro) FROM PARAMETROS WHERE CodParametro = 'COAGOF'
	--'COAGOF' = Comisiona Ag. Colocadores / Of. De Cuenta en días no hábiles
	
	IF (SELECT ValorParametro FROM PARAMETROS WHERE CodParametro = 'COAGOF') = '-1'  
	BEGIN 
		--Traigo el Pais de la Aplicacion para luego fijarme los feriados|
		SELECT @CodPais = CodPais FROM PARAMETROSREL
		--Primero resto un dia la fecha
		SELECT @FechaManipulada = @Fecha
		--Resto el dia para consultar si fue feriado
		SELECT @FechaManipulada = DATEADD(dd, -1, @FechaManipulada)

		if @FechaManipulada  >= @FechaDesde  
		begin 
			--Consulto si es feriado
			EXEC @EsFeriado = sp_dfxEsFechaFeriado @FechaManipulada, @CodPais
			SET @InsertaFeriados = @EsFeriado
			
			WHILE (@EsFeriado = -1)  BEGIN
				SELECT @FechaManipulada = DATEADD(dd, -1, @FechaManipulada)
				EXEC @EsFeriado = sp_dfxEsFechaFeriado @FechaManipulada, @CodPais
				SELECT @InsertaFeriados = -1
			END

			IF @InsertaFeriados = -1 
			BEGIN
					SELECT @FechaUltVCP = @FechaManipulada
					SELECT @FechaManipulada = DATEADD(dd, 1, @FechaManipulada)
					--Consulto si es feriado
					EXEC @EsFeriado = sp_dfxEsFechaFeriado @FechaManipulada, @CodPais
				
					WHILE @EsFeriado = -1 BEGIN
							INSERT #LIQCOMISIONAGCOLOC
    						(CodFondo 
							,CodTpValorCp 
    						,CodAgColocador
    						,CodTpLiquidacion 
							,TpLiquidacion 
    						,NumLiquidacion 
    						,CodCuotapartista 
							,NumCuotapartista 
    						,Cuotapartista 
							,CantCuotapartes 
    						,Fecha 
    						,ImporteHSD 
    						,ImporteHSG 
    						,ImporteGSG 
    						,ImporteGSD 
    						,Importe 
    						,Porcentaje 
							,TotalACobrarAgColoc
							,PorcentajeIncidenciaFdo)
						SELECT 	LIQUIDACIONES.CodFondo, 
							LIQUIDACIONES.CodTpValorCp, 
							CUOTAPARTISTAS.CodAgColocadorOfCta, 
							null,
							null,
							null,
							(CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.CodCuotapartista ELSE null END),
							(CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.NumCuotapartista ELSE null END),
							(CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.Nombre ELSE null END),
							SUM(LIQUIDACIONES.CantCuotapartes),
							@FechaManipulada,
							0,
							0,
							0,
							0,
							ROUND(SUM(LIQUIDACIONES.CantCuotapartes) * @ValorCuotaparteAnterior,2)  Importe,
							NULL,
							0,
							CONVERT(Numeric(28,10), (CONVERT(Numeric(28,10), SUM(CantCuotapartes)) / CONVERT(Numeric(28,10), @CuotapartesCirculacionAnterior ))) * 100
						FROM CUOTAPARTISTAS
							INNER JOIN FONDOSCPT ON FONDOSCPT.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista 
								AND FONDOSCPT.CodFondo = @CodFondo AND EsCargaInicial = 0
							INNER JOIN LIQUIDACIONES ON LIQUIDACIONES.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
						WHERE CUOTAPARTISTAS.CodAgColocadorOfCta = @CodAgColocador
							AND LIQUIDACIONES.CodFondo = @CodFondo
							AND LIQUIDACIONES.CodTpValorCp = @CodTpValorCp
							AND LIQUIDACIONES.EstaAnulado = 0
							AND LIQUIDACIONES.FechaConcertacion <= @FechaUltVCP
							AND @FechaUltVCP >= @FechaDesde 
							and coalesce(@CuotapartesCirculacionAnterior,0) <> 0
						GROUP BY LIQUIDACIONES.CodFondo, 
							LIQUIDACIONES.CodTpValorCp, 
							CUOTAPARTISTAS.CodAgColocadorOfCta, 
							(CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.CodCuotapartista ELSE null END),
							(CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.NumCuotapartista ELSE null END),
							(CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.Nombre ELSE null END)

					
						INSERT INTO #VALORESCITPROV_LIQCOMISIONAGCOLOC (CodFondo, CodTpValorCp, Fecha, CodTpPorcProvision, Importe)
						SELECT	CodFondo, 
								CodTpValorCp, 
								@FechaManipulada, 
								CodTpPorcProvision, 
								Importe
						FROM	#VALORESCITPROV_LIQCOMISIONAGCOLOC
						WHERE 	Fecha = @FechaUltVCP 
						AND @FechaUltVCP >= @FechaDesde
					
						SELECT @FechaManipulada = DATEADD(dd, 1, @FechaManipulada)
						EXEC @EsFeriado = sp_dfxEsFechaFeriado @FechaManipulada, @CodPais					
		        
					END -- WHILE @FechaUltVCP < @FechaManipulada BEGIN
			
				--END -- IF EXISTS (SELECT Fecha ...
		
			END -- IF @InsertaFeriados = -1
		end 

	END

	SELECT @TomaRescates = ValorParametro FROM PARAMETROS WHERE CodParametro = 'CCACR'

	DECLARE @FechaAnt smalldatetime
	SELECT @FechaAnt = @Fecha

	IF @TomaRescates = -1 
	BEGIN
		SELECT @FechaAnt = DATEADD(DD,+1,@Fecha)	
	END

	INSERT #LIQCOMISIONAGCOLOC
    	(CodFondo 
        ,CodTpValorCp 
    	,CodAgColocador
    	,CodTpLiquidacion 
        ,TpLiquidacion 
    	,NumLiquidacion 
    	,CodCuotapartista 
        ,NumCuotapartista 
    	,Cuotapartista 
        ,CantCuotapartes 
    	,Fecha 
    	,ImporteHSD 
    	,ImporteHSG 
    	,ImporteGSG 
    	,ImporteGSD 
    	,Importe 
    	,Porcentaje 
        ,TotalACobrarAgColoc
        ,PorcentajeIncidenciaFdo)
	SELECT 	LIQUIDACIONES.CodFondo, 
        LIQUIDACIONES.CodTpValorCp, 
		CUOTAPARTISTAS.CodAgColocadorOfCta, 
        null,
        null,
        null,
        (CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.CodCuotapartista ELSE null END),
        (CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.NumCuotapartista ELSE null END),
        (CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.Nombre ELSE null END),
        SUM(LIQUIDACIONES.CantCuotapartes),
		@Fecha,
        0,
        0,
        0,
        0,
        ROUND(SUM(LIQUIDACIONES.CantCuotapartes) * @ValorCuotaparteAnterior,2)  Importe,
        NULL,
        0,
        CONVERT(Numeric(28,10), (CONVERT(Numeric(28,10), SUM(CantCuotapartes)) / CONVERT(Numeric(28,10), @CuotapartesCirculacionAnterior))) * 100
	FROM CUOTAPARTISTAS
	INNER JOIN FONDOSCPT ON FONDOSCPT.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista 
        AND FONDOSCPT.CodFondo = @CodFondo AND EsCargaInicial = 0
	INNER JOIN LIQUIDACIONES ON LIQUIDACIONES.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
	WHERE CUOTAPARTISTAS.CodAgColocadorOfCta = @CodAgColocador
        AND LIQUIDACIONES.CodFondo = @CodFondo
        AND LIQUIDACIONES.CodTpValorCp = @CodTpValorCp
        AND LIQUIDACIONES.EstaAnulado = 0
	    AND LIQUIDACIONES.FechaConcertacion < @FechaAnt
		and coalesce(@CuotapartesCirculacionAnterior,0) <> 0
	GROUP BY LIQUIDACIONES.CodFondo, 
        LIQUIDACIONES.CodTpValorCp, 
		CUOTAPARTISTAS.CodAgColocadorOfCta, 
        (CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.CodCuotapartista ELSE null END),
        (CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.NumCuotapartista ELSE null END),
        (CASE WHEN @DiscCuotapartista = -1 THEN CUOTAPARTISTAS.Nombre ELSE null END)


GO

EXEC sp_CreateProcedure 'dbo.spCalculaPatrimonioDiarioAgColocPrev'
GO 
ALTER PROCEDURE dbo.spCalculaPatrimonioDiarioAgColocPrev
 WITH ENCRYPTION 
AS
	
 
	--Calculo de fechas anteriores
UPDATE #FDOAPROCESARAGCOLOC
SET FechaAnterior = (Select max(Fecha) from #FDOAPROCESARAGCOLOC AS tblAux
									where tblAux.CodFondo = #FDOAPROCESARAGCOLOC.CodFondo
									and tblAux.CodTpValorCp = #FDOAPROCESARAGCOLOC.CodTpValorCp
									and Fecha < #FDOAPROCESARAGCOLOC.Fecha)

 
 UPDATE #FDOAPROCESARAGCOLOC 
SET CuotapartesCirculacionAnterior =VALORESCP.CuotapartesCirculacion 
FROM #FDOAPROCESARAGCOLOC
 inner join  VALORESCP on VALORESCP.CodFondo = #FDOAPROCESARAGCOLOC.CodFondo 
and VALORESCP.CodTpValorCp = #FDOAPROCESARAGCOLOC.CodTpValorCp
and VALORESCP.Fecha = #FDOAPROCESARAGCOLOC.FechaAnterior

 UPDATE #FDOAPROCESARAGCOLOC 
SET ValorCuotaparteAnterior =VALORESCP.ValorCuotaparte 
FROM #FDOAPROCESARAGCOLOC
 inner join  VALORESCP on VALORESCP.CodFondo = #FDOAPROCESARAGCOLOC.CodFondo 
and VALORESCP.CodTpValorCp = #FDOAPROCESARAGCOLOC.CodTpValorCp
and VALORESCP.Fecha = #FDOAPROCESARAGCOLOC.FechaAnterior

GO

EXEC sp_CreateProcedure 'dbo.spCalculaPatrimonioDiarioAgColocPost'
GO 
ALTER PROCEDURE dbo.spCalculaPatrimonioDiarioAgColocPost
	@FechaDesde Fecha
WITH ENCRYPTION 
AS
	
  delete from #FDOAPROCESARAGCOLOC where Fecha <@FechaDesde

GO

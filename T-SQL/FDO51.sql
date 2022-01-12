begin tran
IF (select count(*) from sysobjects where name like 'CD_FONDOS_CodTpRecepcionMon_1') <> 0
    ALTER TABLE FONDOSREAL
        DROP CD_FONDOS_CodTpRecepcionMon_1
go

IF (select count(*) from sysobjects where name like 'CD_FONDOSREAL_CodTpRecepcionMon_1') = 0
    ALTER TABLE FONDOSREAL
        ADD CONSTRAINT 	CD_FONDOSREAL_CodTpRecepcionMon_1 DEFAULT 'VP' FOR CodTpRecepcionMon

GO
----v4.3.1
IF (select count(*) from sysobjects where name like 'CD_FONDOS_CodTpCotizacionRecepMon_1') <> 0
    ALTER TABLE FONDOSREAL
        DROP CD_FONDOS_CodTpCotizacionRecepMon_1

GO

IF (select count(*) from sysobjects where name like 'CD_FONDOS_CodTpCotizacionRecepMon_1') = 0
    ALTER TABLE FONDOSREAL
        ADD CONSTRAINT 	CD_FONDOS_CodTpCotizacionRecepMon_1 DEFAULT 'VP' FOR CodTpCotizacionRecepMon
----------
GO

IF (select count(*) from sysobjects where name like 'CD_FONDOS_CodTpRecepcionTit') <> 0
    ALTER TABLE FONDOSREAL
        DROP CD_FONDOS_CodTpRecepcionTit
go

IF (select count(*) from sysobjects where name like 'CD_FONDOSREAL_CodTpRecepcionTit_1') = 0
    ALTER TABLE FONDOSREAL
        ADD CONSTRAINT 	CD_FONDOSREAL_CodTpRecepcionTit_1 DEFAULT 'NR' FOR CodTpRecepcionTit

GO

IF (select count(*) from sysobjects where name like 'CD_FONDOSREAL_CodTpReintegroGastoResc_1') <> 0
    ALTER TABLE FONDOSREAL
        DROP CD_FONDOSREAL_CodTpReintegroGastoResc_1
go

IF (select count(*) from sysobjects where name like 'CD_FONDOSREAL_CodTpReintegroGastoResc_1') = 0
    ALTER TABLE FONDOSREAL
        ADD CONSTRAINT 	CD_FONDOSREAL_CodTpReintegroGastoResc_1 DEFAULT 'SINREI' FOR CodTpReintegroGastoResc

go
SET NOCOUNT ON
GO

DECLARE @CodFondo CodigoMedio
DECLARE @CodTpValorCp CodigoMedio
DECLARE @MinCodFondo CodigoMedio

DECLARE @NumFondo CodigoMedio
DECLARE @Nombre DescripcionMedia
DECLARE @NombreCorto AbreviaturaLarga
DECLARE @NombreAbreviado AbreviaturaMedia
DECLARE @CodAgColocador CodigoMedio
DECLARE @CodSociedadGte CodigoMedio
DECLARE @CodMoneda CodigoMedio
DECLARE @Fecha smalldatetime
DECLARE @CodAuditoriaRef CodigoLargo
DECLARE @CodAudRefMONEDA CodigoLargo
DECLARE @CodCondicionIngEgr CodigoMedio


-- ESTO NO SE UTILIZARA MAS!!!!!!!!
-- EL CLIENTE DEBE INDICAR EL NUMERO DE FONDO A CREAR
SELECT @NumFondo = 51

-- VALIDO QUE EL FONDO NO EXISTA
IF EXISTS (SELECT * FROM FONDOSREAL WHERE NumFondo = @NumFondo)
    BEGIN
		RAISERROR('El Número de Fondo que intenta crear ya existe en la Base de Datos.', 16, 1) 
    END
--############################
ELSE
	BEGIN
		SELECT @Nombre = 'Fondo ' + CONVERT(varchar,@NumFondo)
		SELECT @NombreCorto = 'Fondo' + CONVERT(varchar,@NumFondo)
		SELECT @NombreAbreviado = 'F' + CONVERT(varchar,@NumFondo)
		SELECT @CodAgColocador = (SELECT MIN(CodAgColocador) FROM AGCOLOCADORES WHERE EstaAnulado = 0)
		SELECT @CodSociedadGte = (SELECT MIN(CodSociedadGte) FROM SOCIEDADESGTE WHERE EstaAnulado = 0)
		
		-- LA MONEDA EN CASO DE SER PESOS SERA TOMADA DE LA APLICACION
		--set @CodAudRefMONEDA	 = 2286
		set @CodAudRefMONEDA = 0
		if @CodAudRefMONEDA = 0
			SELECT @CodMoneda = dbo.fnMonPaisAplicacion()
		else
			SELECT @CodMoneda = CodMoneda from MONEDAS where CodAuditoriaRef = @CodAudRefMONEDA  and EstaAnulado = 0
			
		if COALESCE(@CodMoneda, 0) = 0
		begin
			RAISERROR('El Código de la Moneda no puede ser Nulo o 0 (cero).', 16, 1) 
		end
		else
		begin
		
			-----------------------
			-- TABLA: FONDOSREAL --
			-----------------------
			SELECT 'Insertando Fondo ' + convert(varchar(10),@NumFondo)

			INSERT AUDITORIASREF (NomEntidad)
						  VALUES ('FDO')
			SELECT @CodAuditoriaRef =  @@IDENTITY

			declare @CodTpCosto CodigoTextoCorto

			if exists (select * from TPCOSTO where CodTpCosto = 'NB')
			begin
				set @CodTpCosto = 'NB'
			end
			else
			begin
				set @CodTpCosto = 'RT'
			end 

			INSERT FONDOSREAL (CodTpCosto,CodTpDevengamiento,CodTpManejoCert,CodTpFondo,CodTpProvision,CodTpRecepcionTit,
							   CodAgColocadorDep,CodSociedadGte,CodMoneda,Nombre,NombreCorto,NombreAbreviado,NumFondo,
							   CodTpCuotaparte,EsAbierto, CodAuditoriaRef) 
					   VALUES (@CodTpCosto,'LD','ES','MI','DI','TI',
							   @CodAgColocador,@CodSociedadGte,@CodMoneda,@Nombre,@NombreCorto,@NombreAbreviado,@NumFondo,
							   'UN',-1, @CodAuditoriaRef)


			SELECT @CodFondo = (SELECT MAX(CodFondo) FROM FONDOSREAL)
			SELECT @MinCodFondo = (SELECT MIN(CodFondo) FROM FONDOSREAL)

			INSERT AGCOLOCFONDOS (CodFondo, CodAgColocador, EstaAnulado)
			VALUES (@CodFondo, @CodAgColocador, 0)

			INSERT AGCOLOCFDONUMERACIONES (CodFondo,CodAgColocador,CodElNumerable,UltimoNumero,CodTpNumeracion)
			select @CodFondo,@CodAgColocador,CodElNumerable,0,CodTpNumeracionOmision 
			FROM ELNUMERABLES
			WHERE Asociaciones = 7

			---------------------------
			-- TABLA : TPDATOUSERFDO --
			---------------------------

			INSERT INTO AUDITORIASREF (NomEntidad) VALUES ('TPDATOUSERFDO')
			SELECT @CodAuditoriaRef = @@IDENTITY

			INSERT INTO TPDATOSUSERFDO (CodTpDato, CodFondo, LongitudChar, EnterosNumericos, DecimalesNumericos, Alineacion, ConSignoMenos, CodAuditoriaRef)
			VALUES (61, @CodFondo, NULL, 19, 6, 1, 0, @CodAuditoriaRef)

			INSERT INTO AUDITORIASHIST (CodAccion, CodAuditoriaRef, CodUsuario, Fecha, Terminal) 
			VALUES ('TPDATOUSERFDOa', @CodAuditoriaRef , 1, getdate(), host_name())

			-------------------------------
			-- TABLA : CONDICIONESINGEGR --
			-------------------------------

			SELECT 'Insertando la Condición de Ingreso/Egreso'

			INSERT AUDITORIASREF (NomEntidad)
						  VALUES ('CONDINGEGR')
			SELECT @CodAuditoriaRef =  @@IDENTITY

			INSERT CONDICIONESINGEGR (CodFondo, CodTpGtoAdquisicionSusc, CodTpGtoAdquisicionResc, CodTpComDesempeno,
									  Descripcion, DiasPermanenciaFija, EsHabilDiasPermanencia, PorcComSuscripcion, 
									  PorcComRescate, PorcComDesempeno, PorcRetornoBase, RescateMinimo, RescateMaximo, 
									  SuscripcionMinima, SuscripcionMaxima, CobraGtoBancarioSusc, CobraGtoBancarioResc, 
									  GtoBancarioSusc, GtoBancarioResc, CodInterfaz, EstaAnulado, CodAuditoriaRef, 
									  EsPermanenciaMinima, EsPermanenciaRenovable)
							  VALUES (@CodFondo, 'SC', 'SC', 'SC', 
									  'UNICO', 0, 0, 0, 
									  0, 0, 0, 0, -1, 
									  0, -1, 0, 0,
									  NULL, NULL, NULL, 0, @CodAuditoriaRef,
									  0,0)

			SELECT @CodCondicionIngEgr = @@IDENTITY

			-------------------------
			-- TABLA : TPVALORESCP --
			-------------------------

			SELECT @Fecha = CONVERT(Varchar(8), getdate(), 112)
			SELECT 'Insertando el valor de cuotaparte para el día ' + convert(varchar(20),@Fecha,107)

			INSERT AUDITORIASREF (NomEntidad)
						  VALUES ('TPVALCP')
			SELECT @CodAuditoriaRef =  @@IDENTITY
			            
			INSERT TPVALORESCP (CodFondo, Descripcion, Abreviatura, CodAuditoriaRef, ValorCpInicial, FechaInicio, PorMaxHonSocGer, PorMaxHonSocDep, PorMaxGtoSocDep, PorMaxGtoSocGer)
						VALUES (@CodFondo, 'Unico', 'U', @CodAuditoriaRef, 1, @Fecha, 0, 0, 0, 0)

			INSERT AUDITORIASHIST (CodAccion, CodUsuario, Fecha, Terminal, CodAuditoriaRef)
						   VALUES ('TPVALCPa',1,GETDATE(),Host_name(),@CodAuditoriaRef)

			SELECT @CodTpValorCp = MAX(CodTpValorCp)
			FROM TPVALORESCP
			WHERE CodFondo = @CodFondo

			INSERT CONDINGEGRTPVALORESCP (CodFondo, CodCondicionIngEgr, CodTpValorCp, EsDefault, EstaAnulado)
			VALUES (@CodFondo, @CodCondicionIngEgr, @CodTpValorCp, -1, 0)

			------------------------
			-- TABLA : FONDOSPROC --
			------------------------

			SELECT 'Insertando valores en tablas relacionadas'
			         
			INSERT FONDOSPROC (CodFondo,CodProceso,CodUserUltCorrida,FechaUltCorrida,TermUltCorrida,EstaActivo,HayQueProcesar,CodUsuarioU,FechaU,TermU)
			SELECT @CodFondo,CodProceso,NULL,NULL,NULL,0,0,NULL,NULL,NULL FROM PROCESOS

			-------------------------
			-- TABLA : REPORTESFDO --
			-------------------------

			INSERT REPORTESFDO (CodReporte,CodFondo,CodUsuarioUltimaImpresion,FechaUltImpresion,TermUltImpresion) 
			SELECT CodReporte, @CodFondo, NULL, NULL, NULL FROM REPORTESFDO WHERE CodFondo = @MinCodFondo

			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'VCP',1,'ACTIVO',-1,'AC','010000000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'VCP',2,'INVERSIONES',0,'IN','010100000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'VCP',1,'PASIVO',-1,'PA','020000000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'VCP',2,'PROVISIONES',0,'PR','020100000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',1, 'ACTIVO',-1,'AC','010000000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',2, 'ACTIVOS EN EL PAIS',-1,'AP','010100000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'DISPONIBILIDADES',-1,'01','010101000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'VALORES SECTOR PUBLICO',-1,'02','010102000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'VALORES SECTOR PRIVADO',-1,'03','010103000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'VALORES EMITIDAS EN EL PAIS POR ENTIDADES DEL EXTERIOR',-1,'04','010104000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'COLOCACIONES BANCARIAS',-1,'05','010105000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'OTROS',-1,'06','010106000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',2, 'ACTIVOS EN EL EXTERIOR',-1,'AE','010200000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'SECTOR PUBLICO',-1,'07','010201000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'SECTOR PRIVADO',-1,'08','010202000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',1, 'PASIVO',-1,'PA','020000000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',2, 'PASIVOS EN EL PAIS',-1,'PP','020100000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'EMPRESTITOS CONTRATADOS',-1,'09','020101000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'OTROS PASIVOS POR INVERSIONES',-1,'10','020102000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'COMISIONES, TRIBUTOS Y OTROS GASTOS A PAGAR',-1,'11','020103000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'OTROS PASIVOS EN EL PAIS',-1,'12','020104000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',2, 'PASIVOS EN EL EXTERIOR',-1,'PE','020200000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'EMPRESTITOS CONTRATADOS',-1,'13','020201000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'OTROS PASIVOS EN EL EXTERIOR POR INVERSIONES',-1,'14','020202000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO1',3, 'OTROS PASIVOS EN EL EXTERIOR',-1,'15','020203000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',1, 'ACTIVO',-1,'AC','010000000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',2, 'ACTIVOS EN EL PAIS',-1,'AP','010100000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'DISPONIBILIDADES',-1,'01','010101000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'VALORES SECTOR PUBLICO',-1,'02','010102000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'VALORES SECTOR PRIVADO',-1,'03','010103000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'VALORES EMITIDAS EN EL PAIS POR ENTIDADES DEL EXTERIOR',-1,'04','010104000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'COLOCACIONES BANCARIAS',-1,'05','010105000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'OTROS',-1,'06','010106000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',2, 'ACTIVOS EN EL EXTERIOR',-1,'AE','010200000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'SECTOR PUBLICO',-1,'07','010201000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'SECTOR PRIVADO',-1,'08','010202000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',1, 'PASIVO',-1,'PA','020000000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',2, 'PASIVOS EN EL PAIS',-1,'PP','020100000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'EMPRESTITOS CONTRATADOS',-1,'09','020101000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'OTROS PASIVOS POR INVERSIONES',-1,'10','020102000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'COMISIONES, TRIBUTOS Y OTROS GASTOS A PAGAR',-1,'11','020103000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'OTROS PASIVOS EN EL PAIS',-1,'12','020104000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',2, 'PASIVOS EN EL EXTERIOR',-1,'PE','020200000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'EMPRESTITOS CONTRATADOS',-1,'13','020201000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'OTROS PASIVOS EN EL EXTERIOR POR INVERSIONES',-1,'14','020202000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL)
			INSERT RUBROSRPT (CodFondo,CodReporte,Nivel,Descripcion,TieneSubrubros,RubroID,Orden,CodUsuarioI,CodUsuarioU,FechaI,FechaU,TermI,TermU) VALUES (@CodFondo,'COMPO2',3, 'OTROS PASIVOS EN EL EXTERIOR',-1,'15','020203000000000000',1,NULL,GETDATE(),NULL,HOST_NAME(),NULL) 

			INSERT TPDEVOPERACIONESFDO (CodFondo, CodOperacionDev, CodTpDevengamiento)
			SELECT DISTINCT @CodFondo, TPDEVOPERACIONES.CodOperacionDev, 'LD'
			FROM TPDEVOPERACIONES

			------------------------------
			-- TABLA : REPORTESFDOPARAM --
			------------------------------

			INSERT REPORTESFDOPARAM (CodFondo,CodReporte,CodParametroRpt,ValorParametro,CodUsuarioU,FechaU,TermU) 
			SELECT @CodFondo,CodReporte,CodParametroRpt,NULL,NULL,NULL,NULL FROM REPORTESFDOPARAM WHERE CodFondo = @MinCodFondo

			UPDATE REPORTESFDOPARAM SET ValorParametro = (SELECT CONVERT(varchar(255),PorOmision) FROM PARAMETROSRPT where PARAMETROSRPT.CodParametroRpt = REPORTESFDOPARAM.CodParametroRpt) where CodFondo = @CodFondo

			------------------------
			-- TABLA : FONDOSUSER --
			------------------------

			INSERT FONDOSUSER
				(CodFondo, CodUsuario)
			SELECT @CodFondo, CodUsuario FROM USUARIOSREL
			WHERE USUARIOSREL.CodTpUsuario='CO'

			SELECT 'Se ha insertado correctamente el Fondo ' + convert(varchar(10),@NumFondo)
		end
		
	end



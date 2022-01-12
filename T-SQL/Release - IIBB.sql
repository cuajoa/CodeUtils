GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='DATATABLEDEFINITION' AND xtype='U')
BEGIN
	CREATE TABLE dbo.DATATABLEDEFINITION
	(CodTpProvinciaInt	CodigoMedio,
	 Orden				CodigoCorto,
	 ColumnName			DescripcionCorta,
	 ColumnType				DescripcionCorta
	 PRIMARY KEY (CodTpProvinciaInt, Orden, ColumnName)
	)
END

GO

DELETE dbo.DATATABLEDEFINITION WHERE CodTpProvinciaInt = 5 --Córdoba

INSERT INTO dbo.DATATABLEDEFINITION VALUES(5, 1, 'Regimen',				'System.String')
INSERT INTO dbo.DATATABLEDEFINITION VALUES(5, 2, 'FechaPublicacion',	'System.String')
INSERT INTO dbo.DATATABLEDEFINITION VALUES(5, 3, 'FechaVigenciaDesde',	'System.String')
INSERT INTO dbo.DATATABLEDEFINITION VALUES(5, 4, 'FechaVigenciaHasta',	'System.String')
INSERT INTO dbo.DATATABLEDEFINITION VALUES(5, 5, 'CUIT',				'System.Int64')
INSERT INTO dbo.DATATABLEDEFINITION VALUES(5, 6, 'TipoContribuyente',	'System.String')
INSERT INTO dbo.DATATABLEDEFINITION VALUES(5, 7, 'CoeficienteCba',		'System.String')
INSERT INTO dbo.DATATABLEDEFINITION VALUES(5, 8, 'CUCba',				'System.Decimal')

GO

exec sp_CreateProcedure 'dbo.spPROC_PadronIIBB_CrearDataTable'
GO

ALTER PROCEDURE dbo.spPROC_PadronIIBB_CrearDataTable
@CodProvincia	CodigoMedio
WITH ENCRYPTION
AS
	DECLARE @CodTpProvinciaInt CodigoMedio
	SELECT @CodTpProvinciaInt = ISNULL(CodTpProvinciaInt,0) FROM PROVINCIAS WHERE CodProvincia = @CodProvincia
	
	SELECT  Orden, ColumnName, ColumnType FROM dbo.DATATABLEDEFINITION WHERE CodTpProvinciaInt = @CodTpProvinciaInt

GO
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='GUIDPARAMETROS' AND xtype='U')
BEGIN
	create table GUIDPARAMETROS (
		Id uniqueIdentifier default (newId()) primary key,
		Parametros TextoLargo
	)
END

GO


IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='TPPROVINCIAINT' AND xtype='U')
BEGIN
	CREATE TABLE TPPROVINCIAINT (
		CodTpProvinciaInt	CodigoMedio primary key,
		Descripcion			DescripcionMedia
	)
END

GO

IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 1)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(1,'Buenos Aires')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 2)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(2,'Catamarca')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 3)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(3,'Chaco')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 4)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(4,'Chubut')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 5)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(5,'Córdoba')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 6)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(6,'Corrientes')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 7)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(7,'Entre Ríos')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 8)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(8,'Formosa')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 9)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(9,'Jujuy')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 10)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(10,'La Pampa')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 11)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(11,'La Rioja')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 12)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(12,'Mendoza')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 13)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(13,'Misiones')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 14)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(14,'Neuquén')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 15)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(15,'Río Negro')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 16)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(16,'Salta')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 17)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(17,'San Juan')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 18)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(18,'San Luis')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 19)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(19,'Santa Cruz')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 20)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(20,'Santa Fe')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 21)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(21,'Santiago del Estero')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 22)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(22,'Tierra del Fuego')
IF NOT EXISTS(SELECT 1 FROM TPPROVINCIAINT WHERE CodTpProvinciaInt = 23)
	INSERT INTO TPPROVINCIAINT(CodTpProvinciaInt, Descripcion)
	VALUES(23,'Tucumán')

GO


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'CodTpProvinciaInt' AND TABLE_NAME = 'PROVINCIAS')
BEGIN
	ALTER TABLE PROVINCIAS
	ADD [CodTpProvinciaInt] [dbo].[CodigoMedio] NULL
		ALTER TABLE PROVINCIAS ADD CONSTRAINT CFK_PROVINCIAS_CODTPPROVINCIAINT FOREIGN KEY (CodTpProvinciaInt) REFERENCES TPPROVINCIAINT(CodTpProvinciaInt)
END

GO

IF NOT EXISTS(SELECT 1 FROM TPIMPUESTO WHERE CodTpImpuesto = 'REIIBB')
	INSERT INTO TPIMPUESTO(CodTpImpuesto, Denominacion) VALUES('REIIBB', 'Ingresos Brutos / Retenciones')

GO

IF NOT EXISTS(SELECT 1 FROM TPIMPUESTO WHERE CodTpImpuesto = 'PEIIBB')
	INSERT INTO TPIMPUESTO(CodTpImpuesto, Denominacion) VALUES('PEIIBB', 'Ingresos Brutos / Percepciones')

GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PADRONIIBB' AND xtype='U')
BEGIN
	CREATE TABLE PADRONIIBB (
		CodPadronIIBB			CodigoLargo Identity,
		CUIT					CUIT,
		CodTpImpuesto			CodigoTextoMedio,
		CodProvincia			CodigoMedio,
		FechaVigenciaDesde		Fecha,
		FechaVigenciaHasta		Fecha NULL,
		FechaPublicacion		Fecha NULL,
		TipoContribuyente		CodigoTextoCorto NULL,
		MarcaSujeto				CodigoTextoCorto NULL,
		MarcaCambioAlicuota		Boolean NULL,
		CoeficienteUnificacion	Porcentaje NULL,--CU
		CONSTRAINT [XPKPADRONIIBB] PRIMARY KEY CLUSTERED 
		(
			[CUIT] ASC,
			[CodTpImpuesto] ASC,
			[CodProvincia] ASC,
			[FechaVigenciaDesde] ASC
		)
	)
	
	ALTER TABLE PADRONIIBB ADD CONSTRAINT CFK_PADRONIIBB_TPPROVINCIA FOREIGN KEY (CodProvincia) REFERENCES TPPROVINCIAINT(CodProvincia)
	ALTER TABLE PADRONIIBB ADD CONSTRAINT CFK_TPIMPUESTOFACT_TPIMPUESTO FOREIGN KEY (CodTpImpuesto) REFERENCES TPIMPUESTO(CodTpImpuesto)
END
GO

exec sp_CreateProcedure 'dbo.sp_ProcPadronIIBB_Insert'
GO

ALTER PROCEDURE dbo.sp_ProcPadronIIBB_Insert
@PermitirSobrescribirPadron Boolean,
@CodProvincia CodigoMedio,
@Error Boolean = 0 OUTPUT 
WITH ENCRYPTION

AS

DECLARE @CodTpProvinciaInt CodigoMedio
SELECT @CodTpProvinciaInt = CodTpProvinciaInt FROM PROVINCIAS WHERE CodProvincia = @CodProvincia

DECLARE @FechaVigenciaDesde Fecha
DECLARE @FechaVigenciaHasta Fecha
DECLARE @Abortar Boolean = 0

SELECT	top 1 
		@FechaVigenciaDesde = (TRY_CONVERT(date, (SUBSTRING(FechaVigenciaDesde, 5,4) + '-' + SUBSTRING(FechaVigenciaDesde, 3,2) + '-' + SUBSTRING(FechaVigenciaDesde, 1,2)), 102)), 
		@FechaVigenciaHasta	= (TRY_CONVERT(date, (SUBSTRING(FechaVigenciaHasta, 5,4) + '-' + SUBSTRING(FechaVigenciaHasta, 3,2) + '-' + SUBSTRING(FechaVigenciaHasta, 1,2)), 102))
FROM	#IIBBTEMP

IF @PermitirSobrescribirPadron = 0 AND (SELECT COUNT(1) FROM PADRONIIBB WHERE FechaVigenciaDesde = @FechaVigenciaDesde AND FechaVigenciaHasta = @FechaVigenciaHasta AND CodTpProvinciaInt = @CodTpProvinciaInt) > 0
BEGIN
	SET @Abortar = -1
END

IF @PermitirSobrescribirPadron = -1 AND (SELECT COUNT(1) FROM PADRONIIBB WHERE FechaVigenciaDesde = @FechaVigenciaDesde AND FechaVigenciaHasta = @FechaVigenciaHasta AND CodTpProvinciaInt = @CodTpProvinciaInt) > 0
BEGIN
	DELETE FROM PADRONIIBB WHERE FechaVigenciaDesde = @FechaVigenciaDesde AND FechaVigenciaHasta = @FechaVigenciaHasta AND CodTpProvinciaInt = @CodTpProvinciaInt
END

IF @Abortar = 0
BEGIN
	INSERT INTO PADRONIIBB( 
							CUIT
							,CodTpImpuestoFact
							,CodTpProvinciaInt
							,FechaVigenciaDesde
							,FechaVigenciaHasta
							,FechaPublicacion
							,TipoContribuyente
							,MarcaSujeto
							,MarcaCambioAlicuota
							,CoeficienteUnificacion
							)
	SELECT	CUIT AS CUIT
			,CASE
				WHEN Regimen IN('R','RF') THEN 'REIIBB'
				WHEN Regimen = 'P'THEN 'PEIIBB'
			END AS CodTpImpuestoFact
			,@CodTpProvinciaInt AS CodTpProvinciaInt
			,(TRY_CONVERT(date, (SUBSTRING(FechaVigenciaDesde, 5,4) + '-' + SUBSTRING(FechaVigenciaDesde, 3,2) + '-' + SUBSTRING(FechaVigenciaDesde, 1,2)), 102)) AS FechaVigenciaDesde
			,(TRY_CONVERT(date, (SUBSTRING(FechaVigenciaHasta, 5,4) + '-' + SUBSTRING(FechaVigenciaHasta, 3,2) + '-' + SUBSTRING(FechaVigenciaHasta, 1,2)), 102)) AS FechaVigenciaHasta
			,(TRY_CONVERT(date, (SUBSTRING(FechaPublicacion, 5,4) + '-' + SUBSTRING(FechaPublicacion, 3,2) + '-' + SUBSTRING(FechaPublicacion, 1,2)), 102)) AS FechaPublicacion
			,TipoContribuyente AS TipoContribuyente
			,NULL AS MarcaSujeto
			,CASE 
				WHEN CoeficienteCba = 'S' THEN -1
				WHEN CoeficienteCba = 'N' THEN 0
				ELSE 0
			END AS MarcaCambioAlicuota
			,CUCba AS Alicuota
	FROM	#IIBBTEMP

	SELECT * FROM #IIBBTEMP
END

IF @Abortar = -1
	SET @Error = -1 

GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='CONDOMINIOSIIBB' AND xtype='U')
BEGIN
	CREATE TABLE CONDOMINIOSIIBB (
		CodCondominioIIBB		CodigoLargo Identity,
		CodComitente			CodigoLargo,
		CodCondominio			CodigoLargo,
		CodTpImpuestoFact		CodigoTextoMedio,--Regimen	CodigoTextoCorto NULL,
		CodTpProvinciaInt		CodigoMedio,
		FechaVigenciaDesde		Fecha,
		--FechaVigenciaHasta		Fecha NULL,
		Aplica					Boolean NULL,
		CoeficienteUnificado	Porcentaje NULL,
		PorcentajeExencion		Porcentaje NULL,
		FechaVencimiento		Fecha,
		CONSTRAINT [XPKCONDOMINIOSIIBB] PRIMARY KEY CLUSTERED 
		(
			[CodComitente] ASC,
			[CodCondominio] ASC,
			[CodTpImpuestoFact] ASC,
			[CodTpProvinciaInt] ASC,
			[FechaVigenciaDesde] ASC
		)
	)
	ALTER TABLE CONDOMINIOSIIBB ADD CONSTRAINT CFK_CONDOMINIOSIIBB_CODTPPROVINCIAINT FOREIGN KEY (CodTpProvinciaInt) REFERENCES TPPROVINCIAINT(CodTpProvinciaInt)
	ALTER TABLE CONDOMINIOSIIBB ADD CONSTRAINT CFK_CONDOMINIOSIIBB_CODTPIMPUESTOFACT FOREIGN KEY (CodTpImpuestoFact) REFERENCES TPIMPUESTOFACT(CodTpImpuestoFact)
END

GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='TPACTIVODIVIDENDOIIBB' AND xtype='U')
BEGIN
	CREATE TABLE TPACTIVODIVIDENDOIIBB (
		CodTpActivo			CodigoTextoLargo,
		CodTpDividendo		CodigoTextoLargo,
		CodTpImpuestoFact	CodigoTextoMedio,
		CodTpProvinciaInt	CodigoMedio,
		Aplica				Boolean NULL,
		Alicuota			Porcentaje
		,FechaVigenciaDesde  Fecha 
		CONSTRAINT [XPKTPACTIVODIVIDENDOIIBB] PRIMARY KEY CLUSTERED 
		(
			[CodTpActivo] ASC,
			[CodTpDividendo] ASC,
			[CodTpImpuestoFact] ASC,
			[CodTpProvinciaInt] ASC
		)
	)
END

GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='TPACTIVOIIBB' AND xtype='U')
BEGIN
	CREATE TABLE TPACTIVOIIBB (
		CodTpActivo			CodigoTextoLargo,
		CodTpImpuestoFact	CodigoTextoMedio,
		CodTpProvinciaInt	CodigoMedio,
		Aplica				Boolean NULL,
		Alicuota			Porcentaje,
		FechaVigenciaDesde  Fecha 
		CONSTRAINT [XPKTTPACTIVOIIBB] PRIMARY KEY CLUSTERED 
		(
			[CodTpActivo] ASC,
			[CodTpImpuestoFact] ASC,
			[CodTpProvinciaInt] ASC
		)
	)
END

GO

IF NOT EXISTS(SELECT 1 FROM TPCOMPROBANTE WHERE CodTpComprobante = 'RETIB')
	INSERT INTO TPCOMPROBANTE(CodTpComprobante, Descripcion) VALUES('RETIB', 'Retención de Ingresos Brutos')

IF NOT EXISTS(SELECT 1 FROM TPCOMPROBANTE WHERE CodTpComprobante = 'RETIBA')
	INSERT INTO TPCOMPROBANTE(CodTpComprobante, Descripcion) VALUES('RETIBA', 'Anulación Retención de Ingresos Brutos')

GO


IF NOT EXISTS(SELECT 1 FROM TPDISCRIMINACION WHERE CodTpDiscriminacion = 'PROVIN')
	INSERT INTO TPDISCRIMINACION VALUES('PROVIN', 'Provincia', 1)
IF NOT EXISTS(SELECT 1 FROM TPCTAAUTOMATICADISC WHERE CodTpDiscriminacion = 'PROVIN' AND CodTpCtaAutomatica = 'RETIIBBDEB')
	INSERT INTO TPCTAAUTOMATICADISC VALUES('PROVIN','RETIIBBDEB')

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'CodProvincia' AND TABLE_NAME = 'CTASCONTABLES')
BEGIN
	ALTER TABLE CTASCONTABLES ADD CodProvincia	CodigoMedio NULL
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PERSONASEXENCIONES' AND xtype='U')
BEGIN 
	CREATE TABLE dbo.PERSONASEXENCIONES
	(
		CodPersonaExenciones  CodigoLargo IDENTITY(1,1) CONSTRAINT XPKPERSONASEXENCIONES PRIMARY KEY
		,CodPersona CodigoLargo CONSTRAINT CFK_PERSONASEXENCIONES_PERSONAS_1 REFERENCES dbo.PERSONAS(CodPersona)
		,CodTpImpuestoFact CodigoMedio CONSTRAINT CFK_PERSONASEXENCIONES_TPIMPUESTOFACT_1 REFERENCES dbo.TPIMPUESTOFACT(CodTpImpuestoFact)
		,CodProvincia CodigoMedio CONSTRAINT CFK_PERSONASEXENCIONES_PROVINCIAS_1 REFERENCES dbo.PROVINCIAS(CodProvincia)
		,Porcentaje	Porcentaje CONSTRAINT CDF_PERSONASEXENCIONES_PORCENTAJE_1 DEFAULT 0
		,FechaVencimiento Fecha CONSTRAINT CDF_PERSONASEXENCIONES_FechaVencimiento_1 DEFAULT '19000101'
		,EstaAnulado Boolean
		,CodAuditoriaRef CodigoLargo
	)
END

GO

EXEC sp_CreateProcedure 'dbo.sp_CalculoRetencionIIBB'

GO
 
ALTER PROCEDURE dbo.sp_CalculoRetencionIIBB
@FechaProceso Fecha,
@EsDividendo Boolean

WITH ENCRYPTION
AS

--DECLARE @FechaProceso Fecha = '20200312'
--DECLARE @EsDividendo Boolean = -1

----comitente
--IF OBJECT_ID('tempdb..#COMITENTES') IS NOT NULL DROP TABLE #COMITENTES
--CREATE TABLE #COMITENTES(CodComitente numeric(10,0) NOT NULL PRIMARY KEY (CodComitente))

--INSERT INTO #COMITENTES(CodComitente) VALUES(1)

----tpactivo
--IF OBJECT_ID('tempdb..#TPACTIVO') IS NOT NULL DROP TABLE #TPACTIVO
--CREATE TABLE #TPACTIVO(CodTpActivo varchar(12) NOT NULL, CodTpDividendo varchar(12) NULL PRIMARY KEY (CodTpActivo))

--INSERT INTO #TPACTIVO(CodTpActivo, CodTpDividendo) VALUES('ACCION', 'EFECT')

SELECT	((tact.Alicuota * A.CoeficienteUnificado) * ((100 - pe.PorcentajeExencion)/100)) AS FormulaCalculoRetencion
		--,'Temporal Comitentes -->'
		--,C.*
		--,'Aplica Comitente -->'
		--,A.*
		,A.CoeficienteUnificado AS CoeficienteUnificado
		--,'Función Primer Titular -->'
		--,pt.*
		--,'Personas Exenciones -->'
		--,pe.*
		,pe.PorcentajeExencion AS PorcentajeExencion
		--,'TPACTIVOIIBB -->'
		--,tact.*
		,tact.Alicuota AS Alicuota
		,tact.CodTpImpuestoFact AS CodTpImpuestoFact
FROM	#COMITENTES C
		INNER JOIN dbo.fnCONDOMINIOSIIBB_CodComitenteAplica(GETDATE()) A ON A.CodComitente = C.CodComitente
		OUTER APPLY dbo.fnObtenerTitular(C.CodComitente, GETDATE()) pt
		INNER JOIN dbo.fnPERSONASEXENCIONES_GetExencion(GETDATE()) pe ON  pe.CodPersona = pt.CodPersona
		OUTER APPLY (SELECT Alicuota, CodTpImpuestoFact FROM dbo.fnTPACTIVOIIBB_GetAlicuota(@EsDividendo) ta WHERE ta.CodTpActivo = (SELECT CodTpActivo FROM #TPACTIVO) COLLATE DATABASE_DEFAULT AND (@EsDividendo = 0 OR ta.CodTpDividendo = (SELECT CodTpDividendo FROM #TPACTIVO) COLLATE DATABASE_DEFAULT)) AS tact
WHERE	pt.Orden = 1

GO

GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='BOLETOSMERRETENCIONIIBB' AND xtype='U')
BEGIN
	CREATE TABLE dbo.BOLETOSMERRETENCIONIIBB
	(
		CodBoletosMerRetencionIIBB	CodigoLargo IDENTITY
		,CodInstitucion				CodigoLargo
		,CodComitente				CodigoLargo
		,CodBoletoMER				CodigoLargo
		,CodCtaCorrienteCmt			CodigoLargo
		,Alicuota					Porcentaje
		,CoeficienteUnificado		Porcentaje
		,PorcentajeExencion			Porcentaje
		,CodTpImpuestoFact			CodigoTextoMedio
		PRIMARY KEY(CodInstitucion		
					,CodComitente		
					,CodBoletoMER		
					,CodCtaCorrienteCmt)
	)

ALTER TABLE BOLETOSMERRETENCIONIIBB ADD CONSTRAINT CFK_BOLETOSMERRETENCIONIIBB_1 FOREIGN KEY (CodInstitucion, CodComitente, CodBoletoMER) REFERENCES BOLETOSMER(CodInstitucion, CodComitente, CodBoletoMER)
ALTER TABLE BOLETOSMERRETENCIONIIBB ADD CONSTRAINT CFK_BOLETOSMERRETENCIONIIBB_CodCtaCorrienteCmt FOREIGN KEY (CodCtaCorrienteCmt) REFERENCES CTASCORRIENTESCMT(CodCtaCorrienteCmt)

END
GO

exec sp_CreateProcedure 'dbo.spBOLETOSMERRETENCIONIIBB_Insert'
GO 
ALTER PROCEDURE spBOLETOSMERRETENCIONIIBB_Insert
@CodInstitucion			CodigoMedio
,@CodComitente			CodigoLargo
,@CodBoletoMER			CodigoLargo
,@CodCtaCorrienteCmt	CodigoLargo
,@Alicuota				Porcentaje
,@CoeficienteUnificado	Porcentaje
,@PorcentajeExencion	Porcentaje
,@CodTpImpuestoFact		CodigoTextoMedio
WITH ENCRYPTION
AS	

INSERT INTO [dbo].[BOLETOSMERRETENCIONIIBB]
           ([CodInstitucion]
            ,[CodComitente]
            ,[CodBoletoMER]
            ,[CodCtaCorrienteCmt]
		    ,Alicuota				
			,CoeficienteUnificado	
		   	,PorcentajeExencion	
		   	,CodTpImpuestoFact		
		    )
     VALUES
           (@CodInstitucion
           ,@CodComitente		
		   ,@CodBoletoMER		
		   ,@CodCtaCorrienteCmt
		   ,@Alicuota				
		   ,@CoeficienteUnificado	
		   ,@PorcentajeExencion	
		   ,@CodTpImpuestoFact)

GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='LIQUIDACIONFDORETENCIONIIBB' AND xtype='U')
BEGIN
	CREATE TABLE dbo.LIQUIDACIONFDORETENCIONIIBB
	(
		CodLiquidacionFdoRetencionIIBB	CodigoLargo IDENTITY
		,CodLiquidacionFdo				CodigoLargo
		,CodCtaCorrienteCmt				CodigoLargo
		,Alicuota						Porcentaje
		,CoeficienteUnificado			Porcentaje
		,PorcentajeExencion				Porcentaje
		,CodTpImpuestoFact				CodigoTextoMedio
		PRIMARY KEY(CodLiquidacionFdo
					,CodCtaCorrienteCmt)
	)

ALTER TABLE LIQUIDACIONFDORETENCIONIIBB ADD CONSTRAINT CFK_LIQUIDACIONFDORETENCIONIIBB_CodLiquidacionFdo FOREIGN KEY (CodLiquidacionFdo) REFERENCES LIQUIDACIONFDO(CodLiquidacionFdo)
ALTER TABLE LIQUIDACIONFDORETENCIONIIBB ADD CONSTRAINT CFK_LIQUIDACIONFDORETENCIONIIBB_CodCtaCorrienteCmt FOREIGN KEY (CodCtaCorrienteCmt) REFERENCES CTASCORRIENTESCMT(CodCtaCorrienteCmt)
END



GO

exec sp_CreateProcedure 'dbo.spLIQUIDACIONFDORETENCIONIIBB_Insert'
GO 
ALTER PROCEDURE spLIQUIDACIONFDORETENCIONIIBB_Insert
@CodLiquidacionFdo CodigoLargo
,@CodCtaCorrienteCmt CodigoLargo
,@Alicuota				Porcentaje
,@CoeficienteUnificado	Porcentaje
,@PorcentajeExencion	Porcentaje
,@CodTpImpuestoFact		CodigoTextoMedio

WITH ENCRYPTION
AS	

INSERT INTO dbo.LIQUIDACIONFDORETENCIONIIBB
           (CodLiquidacionFdo
			,CodCtaCorrienteCmt
			,Alicuota				
			,CoeficienteUnificado	
		   	,PorcentajeExencion	
		   	,CodTpImpuestoFact	)
     VALUES
           (@CodLiquidacionFdo
           ,@CodCtaCorrienteCmt
		   ,@Alicuota				
		   ,@CoeficienteUnificado	
		   ,@PorcentajeExencion	
		   ,@CodTpImpuestoFact)

GO


EXEC sp_CreateFnTable 'dbo.fnPERSONASEXENCIONES_GetExencion'
GO
 
ALTER FUNCTION dbo.fnPERSONASEXENCIONES_GetExencion (
			@Fecha			Fecha
)

RETURNS  @TABLEPERSONASEXENCIONES TABLE (	
											CodPersona				CodigoLargo NOT NULL,
											CodProvincia			CodigoMedio NOT NULL, 
											FechaVencimiento		Fecha NOT NULL, 
											PorcentajeExencion		Porcentaje NOT NULL
											PRIMARY KEY (CodPersona,CodProvincia)
										)


WITH ENCRYPTION
AS
BEGIN
	
	INSERT INTO @TABLEPERSONASEXENCIONES(CodPersona				
										 ,CodProvincia			
										 ,FechaVencimiento		
										 ,PorcentajeExencion)
	--Obtengo el primer titular del comitente, la provincia y el procentaje de exención si es que está en PERSONASEXENCIONES
	SELECT	ISNULL(pe.CodPersona,0) AS CodPersona
			,ISNULL(pe.CodProvincia,0) AS CodProvincia
			,FechaVencimiento		
			,ISNULL(pe.Porcentaje,0) AS PorcentajeExencion
	FROM	PERSONASEXENCIONES pe
	WHERE	@Fecha <= pe.FechaVencimiento
			
	RETURN
END

GO

EXEC sp_CreateFnTable 'dbo.fnCONDOMINIOSIIBB_CodComitenteAplica'
GO
 
ALTER FUNCTION dbo.fnCONDOMINIOSIIBB_CodComitenteAplica (
    		--@CodComitente	CodigoLargo,
			@Fecha			Fecha
)

RETURNS  @TABLECOMITENTEIIBB TABLE (	
								CodComitente			CodigoLargo NOT NULL,
								CodCondominio			CodigoLargo NOT NULL,
								CodTpImpuestoFact		CodigoTextoMedio NOT NULL,
								CodProvincia			CodigoMedio NOT NULL, 
								FechaVigenciaDesde		Fecha NOT NULL, 
								Aplica					bit NULL,
								CoeficienteUnificado	Porcentaje NOT NULL,
								PorcentajeExencion		Porcentaje NOT NULL
								PRIMARY KEY (CodComitente,CodCondominio,CodTpImpuestoFact,CodProvincia,FechaVigenciaDesde)
							)

WITH ENCRYPTION
AS
BEGIN
	INSERT INTO @TABLECOMITENTEIIBB(CodComitente		
									 ,CodCondominio		
									 ,CodTpImpuestoFact	
									 ,CodProvincia		
									 ,FechaVigenciaDesde	
									 ,Aplica				
									 ,CoeficienteUnificado
									 ,PorcentajeExencion)
	SELECT CodComitente		
		   ,CodCondominio		
		   ,CodTpImpuestoFact	
		   ,CodTpProvinciaInt		
		   ,FechaVigenciaDesde	
		   ,Aplica				
		   ,CoeficienteUnificado
		   ,PorcentajeExencion	
	FROM	CONDOMINIOSIIBB
	WHERE	1 = 1
			AND CodTpImpuestoFact = 'REIIBB'
			AND @Fecha BETWEEN FechaVigenciaDesde and FechaVencimiento
			AND Aplica = -1
	RETURN
END

GO

EXEC sp_CreateFnTable 'dbo.fnTPACTIVOIIBB_GetAlicuota'
GO

ALTER FUNCTION dbo.fnTPACTIVOIIBB_GetAlicuota
	(
		@EsDividendo Boolean
	)
RETURNS @TABLEALICUOTA TABLE (	
								CodTpActivo			CodigoTextoLargo
								,CodTpImpuestoFact	CodigoTextoMedio
								,CodProvincia		CodigoMedio
								,Alicuota			Porcentaje
								,CodTpDividendo		CodigoTextoLargo NULL
								PRIMARY KEY (CodTpActivo,CodTpImpuestoFact,CodProvincia)
							)

WITH ENCRYPTION
AS
BEGIN
	INSERT INTO @TABLEALICUOTA(CodTpActivo			
							   ,CodTpImpuestoFact	
							   ,CodProvincia		
							   ,Alicuota
							   ,CodTpDividendo
							   )
	SELECT	A.CodTpActivo
			,A.CodTpImpuestoFact
			,P.CodProvincia
			,A.Alicuota
			,NULL AS CodTpDividendo
	FROM	TPACTIVOIIBB A
			INNER JOIN PROVINCIAS P ON P.CodTpProvinciaInt = A.CodTpProvinciaInt
	WHERE	1 = 1
			AND A.Aplica = -1
			AND @EsDividendo = 0
	UNION
	SELECT	A.CodTpActivo
			,A.CodTpImpuestoFact
			,P.CodProvincia
			,A.Alicuota
			,CodTpDividendo
	FROM	TPACTIVODIVIDENDOIIBB A
			INNER JOIN PROVINCIAS P ON P.CodTpProvinciaInt = A.CodTpProvinciaInt
	WHERE	1 = 1
			AND A.Aplica = -1
			AND @EsDividendo = -1

	RETURN
END			

GO

EXEC sp_CreateProcedure 'dbo.sp_CONDOMINIOSIIBB_Aplica'

GO
 
ALTER PROCEDURE dbo.sp_CONDOMINIOSIIBB_Aplica
@FechaProceso Fecha

WITH ENCRYPTION
AS

--comitente
--IF OBJECT_ID('tempdb..#COMITENTES') IS NOT NULL DROP TABLE #COMITENTES
--CREATE TABLE #COMITENTES(CodComitente numeric(10,0) NOT NULL PRIMARY KEY (CodComitente))
--INSERT INTO #COMITENTES(CodComitente) VALUES(1)

SELECT	A.CodComitente
		,A.CodCondominio
		,A.CodTpImpuestoFact
		,A.CodProvincia
		,A.FechaVigenciaDesde
		,A.Aplica
		,A.CoeficienteUnificado
		,A.PorcentajeExencion
FROM	#COMITENTES C
		INNER JOIN dbo.fnCONDOMINIOSIIBB_CodComitenteAplica(@FechaProceso) A ON A.CodComitente = C.CodComitente

GO

EXEC sp_CreateProcedure 'dbo.sp_CalculoRetencionIIBB'

GO
 
ALTER PROCEDURE dbo.sp_CalculoRetencionIIBB
@FechaProceso Fecha,
@EsDividendo Boolean

WITH ENCRYPTION
AS

--DECLARE @FechaProceso Fecha = '20200312'
--DECLARE @EsDividendo Boolean = -1

----comitente
--IF OBJECT_ID('tempdb..#COMITENTES') IS NOT NULL DROP TABLE #COMITENTES
--CREATE TABLE #COMITENTES(CodComitente numeric(10,0) NOT NULL PRIMARY KEY (CodComitente))

--INSERT INTO #COMITENTES(CodComitente) VALUES(1)

----tpactivo
--IF OBJECT_ID('tempdb..#TPACTIVO') IS NOT NULL DROP TABLE #TPACTIVO
--CREATE TABLE #TPACTIVO(CodTpActivo varchar(12) NOT NULL, CodTpDividendo varchar(12) NULL PRIMARY KEY (CodTpActivo))

--INSERT INTO #TPACTIVO(CodTpActivo, CodTpDividendo) VALUES('ACCION', 'EFECT')

SELECT	((tact.Alicuota * A.CoeficienteUnificado) * ((100 - pe.PorcentajeExencion)/100)) AS FormulaCalculoRetencion
		--,'Temporal Comitentes -->'
		--,C.*
		--,'Aplica Comitente -->'
		--,A.*
		,A.CoeficienteUnificado AS CoeficienteUnificado
		--,'Función Primer Titular -->'
		--,pt.*
		--,'Personas Exenciones -->'
		--,pe.*
		,pe.PorcentajeExencion AS PorcentajeExencion
		--,'TPACTIVOIIBB -->'
		--,tact.*
		,tact.Alicuota AS Alicuota
		,tact.CodTpImpuestoFact AS CodTpImpuestoFact
FROM	#COMITENTES C
		INNER JOIN dbo.fnCONDOMINIOSIIBB_CodComitenteAplica(GETDATE()) A ON A.CodComitente = C.CodComitente
		OUTER APPLY dbo.fnObtenerTitular(C.CodComitente, GETDATE()) pt
		INNER JOIN dbo.fnPERSONASEXENCIONES_GetExencion(GETDATE()) pe ON  pe.CodPersona = pt.CodPersona
		OUTER APPLY (SELECT Alicuota, CodTpImpuestoFact FROM dbo.fnTPACTIVOIIBB_GetAlicuota(@EsDividendo) ta WHERE ta.CodTpActivo = (SELECT CodTpActivo FROM #TPACTIVO) COLLATE DATABASE_DEFAULT AND (@EsDividendo = 0 OR ta.CodTpDividendo = (SELECT CodTpDividendo FROM #TPACTIVO) COLLATE DATABASE_DEFAULT)) AS tact
WHERE	pt.Orden = 1

GO

BEGIN TRANSACTION;
BEGIN TRY 

if exists(select * from tempdb..sysobjects where id = object_id('tempdb..#SOLRESC'))
	drop table #SOLRESC


if exists(select * from tempdb..sysobjects where id = object_id('tempdb..#SOLSUSC'))
	drop table #SOLSUSC



if exists(select * from tempdb..sysobjects where id = object_id('tempdb..#SOLICITUD'))
	drop table #SOLICITUD



CREATE TABLE #SOLRESC
(ID numeric(5,0) NOT NULL,
CodFondo	numeric(5,0)	NOT NULL,--
CodAgColocador	numeric(5,0)	NOT NULL,--
CodSucursal	numeric(5,0)	NOT NULL,--
--CodSolResc	numeric(10,0)	NOT NULL,--
CodFormaPago	numeric(5,0)	NOT NULL,--
CodTpValorCp	numeric(3,0)	NOT NULL,--
CodUserAutorizModifFecha	numeric(10,0) NULL,
CodUserAutorizExencionCondIE	numeric(10,0) NULL,
CodUserAutorizModifGastos	numeric(10,0) NULL,
CodCanalVta	numeric(5,0) NULL,
CodOficialCta	numeric(5,0)	NOT NULL,--
CodCondicionIngEgr	numeric(5,0)	NOT NULL,--
CodCuotapartista	numeric(10,0)	NOT NULL,--
NumSolicitud	numeric(15,0)	NOT NULL,--
CantCuotapartes	numeric(22,8) NULL,
PorcGastos	numeric(12,8)	NOT NULL,--
FechaConcertacion	smalldatetime	NOT NULL,--
FechaAcreditacion	smalldatetime	NOT NULL,--
Observaciones	varchar(2000) NULL,
ObsExencionCondIngEgr	varchar(2000) NULL,
ObsModifGastos	varchar(2000) NULL,
ObsModifFecha	varchar(2000) NULL,
NumReferencia	numeric(15,0) NULL,
EsTotal	smallint	NOT NULL,--
CobraComDesempeno	smallint	NOT NULL,--
PorcComDesempeno	numeric(12,8) NULL,
CodInterfaz	varchar(30) NULL,
Importe	numeric(19,2) NULL,
CodMoneda	numeric(5,0)	NOT NULL,--
CodCtaBancaria	numeric(10,0) NULL,
PorcGtoBancario	numeric(12,8) NULL,
ImporteGtoBancario	numeric(19,2) NULL,
FactorConversion	numeric(16,10) NOT NULL,--
CodUserAutorizRescAnticip	numeric(10,0) NULL,
ObsRescAnticip	varchar(2000) NULL,
EstaAnulado	smallint	NOT NULL,--
CodAuditoriaRef	numeric(10,0),--	NOT NULL,--
CodPersona	numeric(10,0) NULL,
EsAntesDeHorario	smallint	NOT NULL,--
EsArt5Bis	smallint	NOT NULL,--
Hora	smalldatetime NULL,
CodSubCuenta	numeric(5,0) NULL,
CodUserAutorizModifAgSuc	numeric(10,0) NULL,
ObsModifAgSuc	varchar(2000) NULL,
CodUsuarioIngreso	numeric(10,0)	NOT NULL,--
EsGastoManual	smallint	NOT NULL,--
CodTpOrigenSol	varchar(6)	NOT NULL,--
CodTpEstadoSol	varchar(6)	NOT NULL,--
CodUsuarioAut	numeric(10,0) NULL,
FechaAut	datetime NULL,
Reclasifica	smallint	NOT NULL,--
ImporteSol	numeric(19,2) NULL,
CodInterfazFPA	varchar(30) NULL,
CodTpLiquidacion	varchar(2) NULL,
ObsEstado	varchar(2000) NULL,
CodCuotapartistaCtaOrden	numeric(10,0) NULL,
DescripcionCtaOrden	varchar(150) NULL,
SeControlo	smallint	NOT NULL,--
CodSolModalidadCap	varchar(6) NULL)


ALTER TABLE #SOLRESC ADD  DEFAULT (0) FOR EstaAnulado


ALTER TABLE #SOLRESC ADD  DEFAULT (0) FOR EsAntesDeHorario


ALTER TABLE #SOLRESC ADD  DEFAULT (0) FOR EsArt5Bis



CREATE TABLE #SOLSUSC
(ID numeric(5,0) NOT NULL,
CodFondo	numeric(5,0) NOT NULL,
CodAgColocador	numeric(5,0) NOT NULL,
CodSucursal	numeric(5,0) NOT NULL,
--CodSolSusc	numeric(10,0) NOT NULL,
CodTpValorCp	numeric(3,0) NOT NULL,
CodUserAutorizModifFecha	numeric(10,0) NULL,
CodUserAutorizExencionCondIE	numeric(10,0) NULL,
CodUserAutorizModifGastos	numeric(10,0) NULL,
CodCanalVta	numeric(5,0) NULL,
CodOficialCta	numeric(5,0) NOT NULL,
CodCondicionIngEgr	numeric(5,0) NOT NULL,
CodMoneda	numeric(5,0) NOT NULL,
CodCuotapartista	numeric(10,0) NOT NULL,
NumSolicitud	numeric(15,0) NOT NULL,
Importe	numeric(19,2) NULL,
PorcGastos	numeric(12,8) NOT NULL,
PorcGastosAnt	numeric(12,8) NULL,
FechaConcertacion	smalldatetime  NOT NULL,
FechaAcreditacion	smalldatetime NOT NULL,
FechaPosibleRescate	smalldatetime NULL,
Observaciones	varchar(2000) NULL,
ObsExencionCondIngEgr	varchar(2000) NULL,
ObsModifGastos	varchar(2000) NULL,
ObsModifFecha	varchar(2000) NULL,
NumReferencia	numeric(15,0) NULL,
RentabilidadEsperada	numeric(12,8) NULL,
PerdidaMaxima	numeric(12,8) NULL,
FactorConversion	numeric(16,10) NULL,
CodInterfaz	varchar(30) NULL,
PorcGtoBancario	numeric(12,8) NULL,
ImporteGtoBancario	numeric(19,2) NULL,
EstaAnulado	smallint NOT NULL,
CodAuditoriaRef	numeric(10,0),-- NOT NULL,
CodPersona	numeric(10,0) NULL,
EsAntesDeHorario	smallint NOT NULL,
EsArt5Bis	smallint NOT NULL,
Hora	smalldatetime NULL,
CodSubCuenta	numeric(5,0) NULL,
CodUserAutorizModifAgSuc	numeric(10,0) NULL,
ObsModifAgSuc	varchar(2000) NULL,
CodUsuarioIngreso	numeric(10,0) NOT NULL,
CodTpOrigenSol	varchar(6) NOT NULL,
CodTpEstadoSol	varchar(6) NOT NULL,
CodUsuarioAut	numeric(10,0) NULL,
FechaAut	datetime NULL,
CodFiduciante	numeric(5,0) NULL,
ImporteImpTransf	numeric(19,2) NULL,
CodInterfazFPA	varchar(30) NULL,
CodTpLiquidacion	varchar(2) NULL,
ObsEstado	varchar(2000) NULL,
CodUltimaInstruccion	numeric(10,0) NULL,
CodCuotapartistaCtaOrden	numeric(10,0) NULL,
DescripcionCtaOrden	varchar(150) NULL,
SeControlo	smallint NOT NULL,
CodSolModalidadCap	varchar(6) NULL)



CREATE TABLE #SOLICITUD
(	ID numeric(5,0),
	FondosDesc varchar(80) COLLATE database_default, 
	TpVCPAbreviatura varchar(30) COLLATE database_default, 
	CuotapartistaNombre varchar(50) COLLATE database_default,  
	CondIngEgrDesc varchar(80) COLLATE database_default, 
	MonedaSimbolo varchar(6) COLLATE database_default, 
	AgColocadorNombre varchar(50) COLLATE database_default, 
	SucursalNombre varchar(50) COLLATE database_default, 
	OfCtaApellido varchar(50) COLLATE database_default, 
	OfCtaNombre varchar(50) COLLATE database_default, 
	CanalVtaDesc varchar(80) COLLATE database_default, 
	Importe numeric(19,2), 
	CantCuotapartes numeric(22,8), 
	EsTotal smallint, 
	FormaPagoDesc varchar(80) COLLATE database_default, 
	FormaPagoCtaBria varchar(30) COLLATE database_default, 
	CodCtaBancaria	numeric(10,0) NULL,
	FechaConcertacion smalldatetime, 
	FechaAcreditacion smalldatetime, 
	TipoSolicitud varchar(30) COLLATE database_default,
	FactorConversion numeric(16,10)
)



--REVISAR LO SIGUIENTE, SIEMPRE HAY PROBLEMAS CON EL NOMBRE DEL FONDO (DEBE IR NOMBRE COMPLETO) Y LA FORMA DE PAGO "CTA BANCARIA" (QUE DEBERIA SER "CUENTA BANCARIA") EN LOS DATOS QUE NOS MANDAN EN EL EXCEL, SE CORRIGE EN EXCEL Y LISTO
INSERT INTO #SOLICITUD (ID, FondosDesc, TpVCPAbreviatura, CuotapartistaNombre, CondIngEgrDesc, MonedaSimbolo, AgColocadorNombre, SucursalNombre, OfCtaApellido, OfCtaNombre, CanalVtaDesc, Importe, CantCuotapartes, EsTotal, FormaPagoDesc, FormaPagoCtaBria, FechaConcertacion, FechaAcreditacion, TipoSolicitud, FactorConversion) SELECT 1, 'QUINQUELA CAPITAL FCI','B','ORIGENES SEG DE RETIRO S.A. - RETIRO VOLUNT.','UNICO','u$s','QUINQUELA 2','QUINQUELA 2','QM','MANAGEMENT','OSR + M Propietaria',25000.00,NULL,0,NULL,NULL,'20220214','20220214','Suscripción',1
INSERT INTO #SOLICITUD (ID, FondosDesc, TpVCPAbreviatura, CuotapartistaNombre, CondIngEgrDesc, MonedaSimbolo, AgColocadorNombre, SucursalNombre, OfCtaApellido, OfCtaNombre, CanalVtaDesc, Importe, CantCuotapartes, EsTotal, FormaPagoDesc, FormaPagoCtaBria, FechaConcertacion, FechaAcreditacion, TipoSolicitud, FactorConversion) SELECT 2, 'QUINQUELA CAPITAL FCI','B','ORIGENES SEG DE RETIRO S.A. - RVP DOLARES','UNICO','u$s','QUINQUELA 2','QUINQUELA 2','QM','MANAGEMENT','OSR + M Propietaria',23000.00,NULL,0,NULL,NULL,'20220214','20220214','Suscripción',1
INSERT INTO #SOLICITUD (ID, FondosDesc, TpVCPAbreviatura, CuotapartistaNombre, CondIngEgrDesc, MonedaSimbolo, AgColocadorNombre, SucursalNombre, OfCtaApellido, OfCtaNombre, CanalVtaDesc, Importe, CantCuotapartes, EsTotal, FormaPagoDesc, FormaPagoCtaBria, FechaConcertacion, FechaAcreditacion, TipoSolicitud, FactorConversion) SELECT 3, 'QUINQUELA CAPITAL FCI','B','ORIGENES SEG DE RETIRO S.A. - RVP DOLARES','UNICO','u$s','QUINQUELA 2','QUINQUELA 2','QM','MANAGEMENT','OSR + M Propietaria',22000.00,NULL,0,NULL,NULL,'20220214','20220214','Suscripción',1
INSERT INTO #SOLICITUD (ID, FondosDesc, TpVCPAbreviatura, CuotapartistaNombre, CondIngEgrDesc, MonedaSimbolo, AgColocadorNombre, SucursalNombre, OfCtaApellido, OfCtaNombre, CanalVtaDesc, Importe, CantCuotapartes, EsTotal, FormaPagoDesc, FormaPagoCtaBria, FechaConcertacion, FechaAcreditacion, TipoSolicitud, FactorConversion) SELECT 4, 'QUINQUELA DEUDA ARGENTINA','A','HUMANAS BULL MARKET BROKERS S. A.','UNICO','$','BULL MARKET BROKERS S. A.','BULL MAREKTS ','ROJAS','LEONARDO','ACDI | Bull Market Broker',211000.00,NULL,0,NULL,NULL,'20220214','20220214','Suscripción',1
INSERT INTO #SOLICITUD (ID, FondosDesc, TpVCPAbreviatura, CuotapartistaNombre, CondIngEgrDesc, MonedaSimbolo, AgColocadorNombre, SucursalNombre, OfCtaApellido, OfCtaNombre, CanalVtaDesc, Importe, CantCuotapartes, EsTotal, FormaPagoDesc, FormaPagoCtaBria, FechaConcertacion, FechaAcreditacion, TipoSolicitud, FactorConversion) SELECT 5, 'QUINQUELA ACCIONES FCI','A','HUMANAS BULL MARKET BROKERS S. A.','UNICO','$','BULL MARKET BROKERS S. A.','BULL MAREKTS ','ROJAS','LEONARDO','ACDI | Bull Market Broker',5000.00,NULL,0,NULL,NULL,'20220214','20220214','Suscripción',1
INSERT INTO #SOLICITUD (ID, FondosDesc, TpVCPAbreviatura, CuotapartistaNombre, CondIngEgrDesc, MonedaSimbolo, AgColocadorNombre, SucursalNombre, OfCtaApellido, OfCtaNombre, CanalVtaDesc, Importe, CantCuotapartes, EsTotal, FormaPagoDesc, FormaPagoCtaBria, FechaConcertacion, FechaAcreditacion, TipoSolicitud, FactorConversion) SELECT 1, 'QUINQUELA DEUDA ARGENTINA','A','ISMAEL DEOLINDO MARTORELL','UNICO','$','QM Asset Management Sociedad Gerente de FCI','QM Asset Management Sociedad Gerente de FCI ','QM','MANAGEMENT',NULL,3000.00,NULL,0,'TRANSFERENCIA','845743001','20220214','20220216','Rescate',1
INSERT INTO #SOLICITUD (ID, FondosDesc, TpVCPAbreviatura, CuotapartistaNombre, CondIngEgrDesc, MonedaSimbolo, AgColocadorNombre, SucursalNombre, OfCtaApellido, OfCtaNombre, CanalVtaDesc, Importe, CantCuotapartes, EsTotal, FormaPagoDesc, FormaPagoCtaBria, FechaConcertacion, FechaAcreditacion, TipoSolicitud, FactorConversion) SELECT 2, 'QUINQUELA DEUDA ARGENTINA','A','HUMANAS BULL MARKET BROKERS S. A.','UNICO','$','BULL MARKET BROKERS S. A.','BULL MAREKTS ','ROJAS','LEONARDO','ACDI | Bull Market Broker',NULL,782.0000000000,0,'CUENTA BANCARIA','1179933','20220214','20220216','Rescate',1
INSERT INTO #SOLICITUD (ID, FondosDesc, TpVCPAbreviatura, CuotapartistaNombre, CondIngEgrDesc, MonedaSimbolo, AgColocadorNombre, SucursalNombre, OfCtaApellido, OfCtaNombre, CanalVtaDesc, Importe, CantCuotapartes, EsTotal, FormaPagoDesc, FormaPagoCtaBria, FechaConcertacion, FechaAcreditacion, TipoSolicitud, FactorConversion) SELECT 3, 'QUINQUELA ACCIONES FCI','A','HUMANAS BULL MARKET BROKERS S. A.','UNICO','$','BULL MARKET BROKERS S. A.','BULL MAREKTS ','ROJAS','LEONARDO','ACDI | Bull Market Broker',NULL,6480.6982770000,0,'CUENTA BANCARIA','1179933','20220214','20220216','Rescate',1



--Actualizo la CodCtaBancaria para el caso de que Forma de Pago sea CUENTA BANCARIA
UPDATE #SOLICITUD
SET CodCtaBancaria = ( SELECT TOP 1 CPTCTASBANCARIAS.CodCtaBancaria
						FROM CPTCTASBANCARIAS
						WHERE CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
						AND NumeroCuenta COLLATE database_default = #SOLICITUD.FormaPagoCtaBria COLLATE database_default
						AND CodMoneda = MONEDAS.CodMoneda)
FROM #SOLICITUD
LEFT JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.Nombre COLLATE database_default = #SOLICITUD.CuotapartistaNombre COLLATE database_default
						AND CUOTAPARTISTAS.NumCuotapartista > 100000
LEFT JOIN MONEDAS ON MONEDAS.Simbolo COLLATE database_default = #SOLICITUD.MonedaSimbolo COLLATE database_default
WHERE #SOLICITUD.FormaPagoDesc = 'CUENTA BANCARIA'
AND #SOLICITUD.FormaPagoCtaBria IS NOT NULL
-----------------------------------------------------------------------------------


--RESCATES---------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO #SOLRESC (ID, CodFondo, CodTpValorCp, CodCuotapartista, CodCondicionIngEgr, CodMoneda, CodAgColocador, CodSucursal, CodOficialCta, CodCanalVta, CodFormaPago, 
CodCtaBancaria, FechaConcertacion, FechaAcreditacion, Importe, CantCuotapartes, EsTotal, NumSolicitud, CodUsuarioIngreso, PorcGastos, CobraComDesempeno, FactorConversion,
EsGastoManual, CodTpOrigenSol, CodTpEstadoSol, Reclasifica, SeControlo)
SELECT #SOLICITUD.ID, FONDOS.CodFondo, TPVALORESCP.CodTpValorCp, CUOTAPARTISTAS.CodCuotapartista, CONDICIONESINGEGR.CodCondicionIngEgr, MONEDAS.CodMoneda, 
AGCOLOCADORES.CodAgColocador, SUCURSALES.CodSucursal, OFICIALESCTA.CodOficialCta, CANALESVTA.CodCanalVta, FORMASPAGO.CodFormaPago, #SOLICITUD.CodCtaBancaria,
#SOLICITUD.FechaConcertacion, #SOLICITUD.FechaAcreditacion, #SOLICITUD.Importe, #SOLICITUD.CantCuotapartes, #SOLICITUD.EsTotal, (SELECT UltimoNumero FROM FDONUMERACIONES WHERE CodFondo = FONDOS.CodFondo AND CodElNumerable = 'SOLRES'),
1, 0, 0, #SOLICITUD.FactorConversion, 0, 'VF', 'NOREQ', 0, 0
FROM #SOLICITUD
INNER JOIN FONDOS ON FONDOS.Nombre = #SOLICITUD.FondosDesc
LEFT JOIN TPVALORESCP ON TPVALORESCP.Abreviatura = #SOLICITUD.TpVCPAbreviatura
						AND TPVALORESCP.CodFondo = FONDOS.CodFondo
LEFT JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.Nombre = #SOLICITUD.CuotapartistaNombre
						AND CUOTAPARTISTAS.NumCuotapartista > 100000
LEFT JOIN CONDICIONESINGEGR ON CONDICIONESINGEGR.Descripcion = #SOLICITUD.CondIngEgrDesc
							AND CONDICIONESINGEGR.CodFondo = FONDOS.CodFondo
LEFT JOIN MONEDAS ON MONEDAS.Simbolo = #SOLICITUD.MonedaSimbolo
LEFT JOIN AGCOLOCADORES ON AGCOLOCADORES.Descripcion = #SOLICITUD.AgColocadorNombre
LEFT JOIN SUCURSALES ON SUCURSALES.Descripcion = #SOLICITUD.SucursalNombre
					AND SUCURSALES.CodAgColocador = AGCOLOCADORES.CodAgColocador
LEFT JOIN OFICIALESCTA ON OFICIALESCTA.Apellido = #SOLICITUD.OfCtaApellido
						AND OFICIALESCTA.Nombre = #SOLICITUD.OfCtaNombre
						AND OFICIALESCTA.CodSucursal = SUCURSALES.CodSucursal
LEFT JOIN CANALESVTA ON CANALESVTA.Descripcion = #SOLICITUD.CanalVtaDesc
LEFT JOIN FORMASPAGO ON FORMASPAGO.Descripcion = #SOLICITUD.FormaPagoDesc
WHERE TipoSolicitud = 'Rescate'

declare @MaxValue numeric(5)
declare @MinValue numeric(5)
declare @CodAuditoriaRef CodigoLargo
declare @iIteracion numeric(5)

select @MinValue = min(ID) from #SOLRESC
select @MaxValue = max(ID) from #SOLRESC

select @iIteracion = 1

while @iIteracion <= @MaxValue begin
	
    if exists(SELECT ID FROM #SOLRESC where ID = @iIteracion)
	begin
		--SELECT * FROM AUDITORIASREF WHERE NomEntidad LIKE '%SOLR%'
		INSERT AUDITORIASREF (NomEntidad)
		VALUES ('SOLRESC')
		SELECT @CodAuditoriaRef = @@IDENTITY

		update #SOLRESC
		set CodAuditoriaRef = @CodAuditoriaRef 
		where ID = @iIteracion and CodAuditoriaRef is null
    
		INSERT AUDITORIASHIST (CodAccion, CodUsuario, Fecha, Terminal, CodAuditoriaRef)
		VALUES ('SOLRESCa', 1, Getdate(), Host_name(), @CodAuditoriaRef)
		
	end
	
	select @iIteracion = @iIteracion + 1

end

INSERT INTO SOLRESC (CodFondo, CodTpValorCp, CodCuotapartista, CodCondicionIngEgr, CodMoneda, CodAgColocador, CodSucursal, CodOficialCta, CodCanalVta, CodFormaPago, 
CodCtaBancaria, FechaConcertacion, FechaAcreditacion, Importe, CantCuotapartes, EsTotal, NumSolicitud, CodUsuarioIngreso, PorcGastos, CobraComDesempeno, FactorConversion,
EsGastoManual, CodTpOrigenSol, CodTpEstadoSol, Reclasifica, SeControlo, EstaAnulado, EsAntesDeHorario, EsArt5Bis, CodAuditoriaRef)
SELECT CodFondo, CodTpValorCp, CodCuotapartista, CodCondicionIngEgr, CodMoneda, CodAgColocador, CodSucursal, CodOficialCta, CodCanalVta, CodFormaPago, 
CodCtaBancaria, FechaConcertacion, FechaAcreditacion, Importe, CantCuotapartes, EsTotal, NumSolicitud + ID, CodUsuarioIngreso, PorcGastos, CobraComDesempeno, FactorConversion,
EsGastoManual, CodTpOrigenSol, CodTpEstadoSol, Reclasifica, SeControlo, EstaAnulado, EsAntesDeHorario, EsArt5Bis, CodAuditoriaRef
FROM #SOLRESC

DECLARE @NumSolicitud numeric(15,0)

SELECT @NumSolicitud = MAX(SOLRESC.NumSolicitud) 
FROM SOLRESC 
INNER JOIN #SOLRESC ON #SOLRESC.CodFondo = SOLRESC.CodFondo
					AND #SOLRESC.CodAgColocador = SOLRESC.CodAgColocador
					AND #SOLRESC.CodSucursal = SOLRESC.CodSucursal
					AND #SOLRESC.CodTpValorCp = SOLRESC.CodTpValorCp
					AND #SOLRESC.NumSolicitud + #SOLRESC.ID = SOLRESC.NumSolicitud

UPDATE FDONUMERACIONES 
SET UltimoNumero = @NumSolicitud
FROM FDONUMERACIONES
INNER JOIN SOLRESC ON SOLRESC.CodFondo = FDONUMERACIONES.CodFondo 
INNER JOIN #SOLRESC ON #SOLRESC.CodFondo = SOLRESC.CodFondo
					AND #SOLRESC.CodAgColocador = SOLRESC.CodAgColocador
					AND #SOLRESC.CodSucursal = SOLRESC.CodSucursal
					AND #SOLRESC.CodTpValorCp = SOLRESC.CodTpValorCp
					AND #SOLRESC.NumSolicitud + #SOLRESC.ID = SOLRESC.NumSolicitud
WHERE CodElNumerable = 'SOLRES'

SELECT SOLRESC.*
FROM SOLRESC
INNER JOIN #SOLRESC ON #SOLRESC.CodFondo = SOLRESC.CodFondo
					AND #SOLRESC.CodAgColocador = SOLRESC.CodAgColocador
					AND #SOLRESC.CodSucursal = SOLRESC.CodSucursal
					AND #SOLRESC.CodTpValorCp = SOLRESC.CodTpValorCp
					AND #SOLRESC.NumSolicitud + #SOLRESC.ID = SOLRESC.NumSolicitud

--SELECT UltimoNumero FROM FDONUMERACIONES WHERE CodFondo = 244 AND CodElNumerable = 'SOLRES'



--SUSCRIPCIONES------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO #SOLSUSC (ID, CodFondo, CodTpValorCp, CodCuotapartista, CodCondicionIngEgr, CodMoneda, CodAgColocador, CodSucursal, CodOficialCta, CodCanalVta, 
FechaConcertacion, FechaAcreditacion, Importe, NumSolicitud, CodUsuarioIngreso, PorcGastos, FactorConversion,
CodTpOrigenSol, CodTpEstadoSol, SeControlo, EstaAnulado, EsAntesDeHorario, EsArt5Bis)
SELECT #SOLICITUD.ID, FONDOS.CodFondo, TPVALORESCP.CodTpValorCp, CUOTAPARTISTAS.CodCuotapartista, CONDICIONESINGEGR.CodCondicionIngEgr, MONEDAS.CodMoneda, 
AGCOLOCADORES.CodAgColocador, SUCURSALES.CodSucursal, OFICIALESCTA.CodOficialCta, CANALESVTA.CodCanalVta, 
#SOLICITUD.FechaConcertacion, #SOLICITUD.FechaAcreditacion, #SOLICITUD.Importe, (SELECT UltimoNumero FROM FDONUMERACIONES WHERE CodFondo = FONDOS.CodFondo AND CodElNumerable = 'SOLSUS'),
1, 0, #SOLICITUD.FactorConversion, 'VF', 'NOREQ', 0, 0, 0, 0
FROM #SOLICITUD
INNER JOIN FONDOS ON FONDOS.Nombre = #SOLICITUD.FondosDesc
LEFT JOIN TPVALORESCP ON TPVALORESCP.Abreviatura = #SOLICITUD.TpVCPAbreviatura
						AND TPVALORESCP.CodFondo = FONDOS.CodFondo
LEFT JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.Nombre = #SOLICITUD.CuotapartistaNombre
						AND CUOTAPARTISTAS.NumCuotapartista > 100000
LEFT JOIN CONDICIONESINGEGR ON CONDICIONESINGEGR.Descripcion = #SOLICITUD.CondIngEgrDesc
							AND CONDICIONESINGEGR.CodFondo = FONDOS.CodFondo
LEFT JOIN MONEDAS ON MONEDAS.Simbolo = #SOLICITUD.MonedaSimbolo
LEFT JOIN AGCOLOCADORES ON AGCOLOCADORES.Descripcion = #SOLICITUD.AgColocadorNombre
LEFT JOIN SUCURSALES ON SUCURSALES.Descripcion = #SOLICITUD.SucursalNombre
					AND SUCURSALES.CodAgColocador = AGCOLOCADORES.CodAgColocador
LEFT JOIN OFICIALESCTA ON OFICIALESCTA.Apellido = #SOLICITUD.OfCtaApellido
						AND OFICIALESCTA.Nombre = #SOLICITUD.OfCtaNombre
						AND OFICIALESCTA.CodSucursal = SUCURSALES.CodSucursal
LEFT JOIN CANALESVTA ON CANALESVTA.Descripcion = #SOLICITUD.CanalVtaDesc
WHERE TipoSolicitud = 'Suscripción'


select @MinValue = min(ID) from #SOLSUSC
select @MaxValue = max(ID) from #SOLSUSC

select @iIteracion = 1

while @iIteracion <= @MaxValue begin
	
    if exists(SELECT ID FROM #SOLSUSC where ID = @iIteracion)
	begin
		--SELECT * FROM AUDITORIASREF WHERE NomEntidad LIKE '%SOLR%'
		INSERT AUDITORIASREF (NomEntidad)
		VALUES ('SOLSUSC')
		SELECT @CodAuditoriaRef = @@IDENTITY

		update #SOLSUSC
		set CodAuditoriaRef = @CodAuditoriaRef 
		where ID = @iIteracion and CodAuditoriaRef is null
    
		INSERT AUDITORIASHIST (CodAccion, CodUsuario, Fecha, Terminal, CodAuditoriaRef)
		VALUES ('SOLSUSCa', 1, Getdate(), Host_name(), @CodAuditoriaRef)
		
	end
	
	select @iIteracion = @iIteracion + 1

end

INSERT INTO SOLSUSC(CodFondo, CodTpValorCp, CodCuotapartista, CodCondicionIngEgr, CodMoneda, CodAgColocador, CodSucursal, CodOficialCta, CodCanalVta, 
FechaConcertacion, FechaAcreditacion, Importe, NumSolicitud, CodUsuarioIngreso, PorcGastos, FactorConversion,
CodTpOrigenSol, CodTpEstadoSol, SeControlo, EstaAnulado, EsAntesDeHorario, EsArt5Bis, CodAuditoriaRef)
SELECT CodFondo, CodTpValorCp, CodCuotapartista, CodCondicionIngEgr, CodMoneda, CodAgColocador, CodSucursal, CodOficialCta, CodCanalVta, 
FechaConcertacion, FechaAcreditacion, Importe, NumSolicitud + ID, CodUsuarioIngreso, PorcGastos, FactorConversion,
CodTpOrigenSol, CodTpEstadoSol, SeControlo, EstaAnulado, EsAntesDeHorario, EsArt5Bis, CodAuditoriaRef
FROM #SOLSUSC


SELECT @NumSolicitud = MAX(SOLSUSC.NumSolicitud)
FROM SOLSUSC
INNER JOIN #SOLSUSC ON #SOLSUSC.CodFondo = SOLSUSC.CodFondo
					AND #SOLSUSC.CodAgColocador = SOLSUSC.CodAgColocador
					AND #SOLSUSC.CodSucursal = SOLSUSC.CodSucursal
					AND #SOLSUSC.CodTpValorCp = SOLSUSC.CodTpValorCp
					AND #SOLSUSC.NumSolicitud + #SOLSUSC.ID = SOLSUSC.NumSolicitud

UPDATE FDONUMERACIONES 
SET UltimoNumero = @NumSolicitud
FROM FDONUMERACIONES
INNER JOIN SOLSUSC ON SOLSUSC.CodFondo = FDONUMERACIONES.CodFondo 
INNER JOIN #SOLSUSC ON #SOLSUSC.CodFondo = SOLSUSC.CodFondo
					AND #SOLSUSC.CodAgColocador = SOLSUSC.CodAgColocador
					AND #SOLSUSC.CodSucursal = SOLSUSC.CodSucursal
					AND #SOLSUSC.CodTpValorCp = SOLSUSC.CodTpValorCp
					AND #SOLSUSC.NumSolicitud + #SOLSUSC.ID = SOLSUSC.NumSolicitud
WHERE CodElNumerable = 'SOLSUS'

----No va para las cuentas bancarias
INSERT INTO SOLITOTROS (CodFondo, CodAgColocador, CodSucursal, CodSolSusc, CodFormaPago, Comentario, Importe)
SELECT SOLSUSC.CodFondo, SOLSUSC.CodAgColocador, SOLSUSC.CodSucursal, SOLSUSC.CodSolSusc, FORMASPAGO.CodFormaPago, #SOLICITUD.FormaPagoCtaBria, SOLSUSC.Importe
FROM SOLSUSC
INNER JOIN #SOLSUSC ON #SOLSUSC.CodFondo = SOLSUSC.CodFondo
					AND #SOLSUSC.CodAgColocador = SOLSUSC.CodAgColocador
					AND #SOLSUSC.CodSucursal = SOLSUSC.CodSucursal
					AND #SOLSUSC.CodTpValorCp = SOLSUSC.CodTpValorCp
					AND #SOLSUSC.NumSolicitud + #SOLSUSC.ID = SOLSUSC.NumSolicitud
INNER JOIN #SOLICITUD ON #SOLICITUD.ID = #SOLSUSC.ID
INNER JOIN FORMASPAGO ON FORMASPAGO.Descripcion COLLATE database_default = #SOLICITUD.FormaPagoDesc COLLATE database_default
WHERE #SOLICITUD.TipoSolicitud = 'Suscripción'
AND #SOLICITUD.FormaPagoDesc <> 'CUENTA BANCARIA'

--Para las formas de Pago CUENTA BANCARIA
INSERT INTO SOLITCTASBANCARIAS (CodFondo, CodAgColocador, CodSucursal, CodSolSusc, CodCuotapartista, CodCtaBancaria, Comentario, Importe, CodFormaPago, GeneroArchivoMEP)
SELECT SOLSUSC.CodFondo, SOLSUSC.CodAgColocador, SOLSUSC.CodSucursal, SOLSUSC.CodSolSusc, SOLSUSC.CodCuotapartista, #SOLICITUD.CodCtaBancaria, 
'', SOLSUSC.Importe, FORMASPAGO.CodFormaPago, 0
FROM SOLSUSC
INNER JOIN #SOLSUSC ON #SOLSUSC.CodFondo = SOLSUSC.CodFondo
					AND #SOLSUSC.CodAgColocador = SOLSUSC.CodAgColocador
					AND #SOLSUSC.CodSucursal = SOLSUSC.CodSucursal
					AND #SOLSUSC.CodTpValorCp = SOLSUSC.CodTpValorCp
					AND #SOLSUSC.NumSolicitud + #SOLSUSC.ID = SOLSUSC.NumSolicitud
INNER JOIN #SOLICITUD ON #SOLICITUD.ID = #SOLSUSC.ID
INNER JOIN FORMASPAGO ON FORMASPAGO.Descripcion COLLATE database_default = #SOLICITUD.FormaPagoDesc COLLATE database_default
WHERE #SOLICITUD.TipoSolicitud = 'Suscripción'
AND #SOLICITUD.FormaPagoDesc = 'CUENTA BANCARIA'

SELECT SOLSUSC.*
FROM SOLSUSC
INNER JOIN #SOLSUSC ON #SOLSUSC.CodFondo = SOLSUSC.CodFondo
					AND #SOLSUSC.CodAgColocador = SOLSUSC.CodAgColocador
					AND #SOLSUSC.CodSucursal = SOLSUSC.CodSucursal
					AND #SOLSUSC.CodTpValorCp = SOLSUSC.CodTpValorCp
					AND #SOLSUSC.NumSolicitud + #SOLSUSC.ID = SOLSUSC.NumSolicitud

--SELECT UltimoNumero FROM FDONUMERACIONES WHERE CodFondo = 244 AND CodElNumerable = 'SOLSUS'



END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber  
        , ERROR_SEVERITY() AS ErrorSeverity  
        , ERROR_STATE() AS ErrorState  
        , ERROR_PROCEDURE() AS ErrorProcedure  
        , ERROR_LINE() AS ErrorLine  
        , ERROR_MESSAGE() AS ErrorMessage;

IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION;
END CATCH;

IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;  

GO

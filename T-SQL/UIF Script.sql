
CREATE TABLE #REPORTEALERTASUIF(
CodRepAlertaUIF numeric(10) NOT NULL
,CodHistLimUIF numeric(10) NOT NULL 
,CodCuotapartista numeric(10) NOT NULL 
,CodDocumentacion numeric(10) NOT NULL
,CodTpLimite varchar(20) COLLATE DATABASE_DEFAULT  NOT NULL
,CodFondo numeric(10) NOT NULL
,CodTpEstControl varchar(20) COLLATE DATABASE_DEFAULT  NOT NULL
,FechaAlerta smalldatetime NOT NULL
,NombreAlerta varchar(80) COLLATE DATABASE_DEFAULT  NOT NULL
,NombreCuotapartista varchar(80) COLLATE DATABASE_DEFAULT  NOT NULL 
,NumCuotapartista numeric(15) NOT NULL
,TipoCuentaCpt varchar(80) COLLATE DATABASE_DEFAULT NOT NULL
,ImporteSolicitud numeric(19,2) NOT NULL
,NumSolicitud numeric(15) NOT NULL
,NombreFondo varchar(80) COLLATE DATABASE_DEFAULT  NOT NULL
,EstadoControl varchar(80) COLLATE DATABASE_DEFAULT  NOT NULL
,FechaModificacion smalldatetime NOT NULL
,Observacion varchar(2000) COLLATE DATABASE_DEFAULT  NOT NULL
,NombreDocumentacion varchar(80) COLLATE DATABASE_DEFAULT  NOT NULL
,ActEsperadaCuenta numeric(19,2) NOT NULL
,ActEsperDesvioPorc numeric(22,8) NOT NULL
,TipoSolicitud varchar(80) COLLATE DATABASE_DEFAULT NOT NULL
,PatrimonioMonto numeric(19,2) NOT NULL
,PatrimonioImporte numeric(19,2) NOT NULL
,EstaSeleccionado integer NOT NULL
,PermiteSeleccionar integer NOT NULL
,Observaciones varchar(2000) COLLATE DATABASE_DEFAULT NOT NULL
,ColorEstado numeric(10) NOT NULL
,DesvioImporte numeric(19,2) NOT NULL
,DesvioPorcentaje numeric(22,8) NOT NULL
,CodTpEstAutorizacion varchar(20) COLLATE DATABASE_DEFAULT NULL
,CodUsuarioAut numeric(10) NOT NULL 
,FechaAutorizacion smalldatetime NOT NULL
,CodAuditoriaRef numeric(10) NOT NULL 
,CodTpPerfilRiesgoCpt varchar(20) COLLATE DATABASE_DEFAULT NOT NULL
,CodTpRiesgo numeric(10) NOT NULL
,FechaAlertaSolamente smalldatetime NOT NULL
)

CREATE TABLE #TMP_CUOTAPARTISTAS(
CodCuotapartista numeric(10) NOT NULL 
,Nombre varchar(80) COLLATE DATABASE_DEFAULT NOT NULL
,NumCuotapartista numeric(15) NOT NULL
,EsPesonaFisica integer NOT NULL
,FechaActualizacionPerfil smalldatetime NOT NULL
,FechaVencimientoPerfil datetime NOT NULL
)

CREATE TABLE #FDOALERTAS(
CodFondo numeric(10) NOT NULL
,NumFondo numeric(10) NOT NULL
,NombreAbreviado varchar(5) COLLATE DATABASE_DEFAULT NOT NULL
)

CREATE TABLE #ESTCRTLALERTAS(
CodTpEstControl varchar(20) COLLATE DATABASE_DEFAULT NOT NULL
,Descripcion varchar(80) COLLATE DATABASE_DEFAULT NOT NULL
)

CREATE TABLE #ALERTAS(
CodTpLimite varchar(20) COLLATE DATABASE_DEFAULT NOT NULL
,Descripcion varchar(80) COLLATE DATABASE_DEFAULT NOT NULL
)

CREATE TABLE #PERIODOS(
CodRepAlertaUIF numeric(10) NOT NULL 
,FechaPeriodo1 smalldatetime NOT NULL
,FechaPeriodo2 smalldatetime NOT NULL
,FechaPeriodo3 smalldatetime NOT NULL
)

CREATE TABLE #UIFPOSCPT(
ID numeric(10) NOT NULL
,CodFondo numeric(10) NOT NULL
,CodTpValorCp numeric(10) NOT NULL
,CodCuotapartista numeric(10) NOT NULL
,CantidadCuotapartes numeric(22,8) NOT NULL
,Cotizacion numeric(19,10) NOT NULL
,Importe numeric(19,2) NOT NULL
,FechaUltimoVCP smalldatetime NOT NULL
,ValorVCP numeric(22,8) NOT NULL
)

CREATE TABLE #TMP_RPTUIFCTRLPATACTESP(
IdTabla numeric(10) NULL
,CodCuotapartista numeric(10) NULL
,NumCuotapartista numeric(15) NOT NULL
,Nombre varchar(80) COLLATE DATABASE_DEFAULT NOT NULL
,Patrimonio_importe numeric(19,2) NOT NULL
,Patrimonio_CodMoneda numeric(10) NOT NULL
,Patrimonio_control numeric(19,2) NOT NULL
,Patrimonio_desvio_importe numeric(19,2) NOT NULL
,Patrimonio_desvio_porcentaje numeric(22,8) NOT NULL
,Patrimonio_Estado varchar(80) COLLATE DATABASE_DEFAULT NOT NULL
,ActividadEsperada_MontoEstimado numeric(19,2) NOT NULL
,ActividadEsperada_CodMoneda numeric(10) NOT NULL
,ActividadEsperada_Desvio_Importe numeric(19,2) NOT NULL
,ActividadEsperada_Desvio_Porcentaje numeric(22,8) NOT NULL
,ActividadEsperada_Estado varchar(80) COLLATE DATABASE_DEFAULT NOT NULL
) 

CREATE TABLE #UIFPOSCPT_ANIOCALED(
CodCuotapartista numeric(10) NOT NULL
,PosicionValuadaAnioCal numeric(22,8) NOT NULL
)

CREATE TABLE #UIFMovimientos(
ID numeric(10) NOT NULL
,TipoMovimiento varchar(20) COLLATE DATABASE_DEFAULT NOT NULL
,CodFondo numeric(10) NOT NULL
,CodTpValorCp numeric(10) NOT NULL
,CodMonedaMov numeric(10) NOT NULL
,CodCuotapartista numeric(10) NOT NULL
,FechaConcertacion smalldatetime NULL
,Importe numeric(19,2) NOT NULL
,CantidadCuotapartes numeric(22,8) NOT NULL
,Cotizacion numeric(19,10) NOT NULL
,FechaUltimoVCP smalldatetime NOT NULL
,ValorVCP numeric(22,8) NOT NULL
)

CREATE TABLE #TMP_CUOTAPARTISTAS_FILTRO(
CodCuotapartista numeric(10) NOT NULL 
,Nombre varchar(80) COLLATE DATABASE_DEFAULT NOT NULL
,NumCuotapartista numeric(15) NOT NULL
,EsPesonaFisica integer NOT NULL
,FechaActualizacionPerfil smalldatetime NOT NULL
,FechaVencimientoPerfil datetime NOT NULL
)


exec spINFO_RPTEALERTASUIF '2010-08-01 00:00:00','2021-08-28 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL

DROP TABLE #REPORTEALERTASUIF
DROP TABLE #TMP_CUOTAPARTISTAS
DROP TABLE #FDOALERTAS
DROP TABLE #ESTCRTLALERTAS
DROP TABLE #ALERTAS
DROP TABLE #PERIODOS
DROP TABLE #UIFPOSCPT
DROP TABLE #TMP_RPTUIFCTRLPATACTESP
DROP TABLE #UIFPOSCPT_ANIOCALED
DROP TABLE #UIFMovimientos
DROP TABLE #TMP_CUOTAPARTISTAS_FILTRO



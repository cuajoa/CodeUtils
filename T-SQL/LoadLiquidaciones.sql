CREATE TABLE #GENLIQ_FONDOS(
CodFondo numeric(10) not null
,CodMoneda numeric(10) not null
,FechaCopiadorResc smalldatetime not null
,FechaCopiadorSusc smalldatetime not null
,FechaUltValorCp smalldatetime not null 
,FechaPagoFraccion smalldatetime not null
,CodTpFondo varchar(10) not null
,CodTpRecepcionTit varchar(10) not null
,CodTpCuotaparte varchar(10) not null
,CodTpRecepcionMon varchar(10) not null
,CodTpReintegroGastoResc varchar(10) not null 
,CodTpCotizacionRecepMon varchar(10) not null 
,SePuedeLiquidar numeric(2) not null
,MANREC numeric(2) not null
,ADJRNU numeric(2) not null
,ADJRAR numeric(2) not null
,Observaciones varchar(200) null
,PLAFRA numeric(15) not null
,ADJFFO numeric(15) not null
,ADJFCP numeric(15) not null
,EsTieneDividendo numeric(15) not null
)
CREATE TABLE #GENLIQ_COTMON(
CodFondo numeric(10) not null
,ID numeric(10) identity(1,1) not null
,CodMoneda numeric(10) not null
,CodMonedaHasta numeric(10) not null
,FactorConversion numeric(19,9) not null
,Fecha smalldatetime not null
,GeneraVCPAnticip numeric(2) not null
,TieneVCPAnticip numeric(2) not null
,CodEntidad numeric(10) not null
)
CREATE TABLE #GENLIQ_SUSC(
CodFondo numeric(10) not null
,CodAgColocador numeric(10) not null
,CodSucursal numeric(10) not null
,ID numeric(10) identity(1,1) not null
,CodSolSusc numeric(10) not null
,CodSolTransferencia numeric(10) not null
,CodRecibo numeric(10) not null
,NumReferencia numeric(20) not null
,FechaAcreditacion smalldatetime not null
,FechaConcertacion smalldatetime not null
,CodCuotapartista numeric(10) not null
,CodCondicionIngEgr numeric(10) not null
,CodTpValorCp numeric(10) not null
,CodMoneda numeric(10) not null
,CodTpEstadoSol  varchar(10) not null
,CodTpLiquidacion  varchar(10) not null
,Importe numeric(19,2) not null
,CodCanalVta numeric(10) not null
,CodOficialCta numeric(10) not null
,ImporteGastos numeric(19,2) not null
,PorcGastos numeric(19,2) not null
,PorcGtoBancario numeric(19,2) not null 
,ImporteGtoBancario numeric(19,2) not null
,SePuedeLiquidar numeric(2) not null
,EsVCPSol numeric(2) not null
,ImporteNetoSusc numeric(19,2) not null
,Observaciones nvarchar(200) null
,ImporteSuscripcionFdo numeric(19,2) not null
,ImporteFraccion numeric(19,2) not null
,FactorConversion numeric(22,8) not null
,CantCuotapartes numeric(22,8) not null
,CodFondoHD numeric(10) not null
,CodTpValorCpHD  numeric(10) not null
,CodAgColocadorDesde numeric(10) not null
,CodSucursalDesde numeric(10) not null
,CodLiquidacion numeric(10) not null
,ValorCuotaparte numeric(22,8) not null
,CodTpPersona varchar(10) not null
)
CREATE TABLE #GENLIQ_RESC(
CodFondo numeric(10) not null
,CodAgColocador numeric(10) not null
,CodSucursal numeric(10) not null
,ID numeric(10) identity(1,1) not null
,CodSolSusc numeric(10) not null
,CodSolTransferencia numeric(10) not null
,CodRecibo numeric(10) not null
,NumReferencia numeric(20) not null
,FechaAcreditacion smalldatetime not null
,FechaConcertacion smalldatetime not null
,CodCuotapartista numeric(10) not null
,CodCondicionIngEgr numeric(10) not null
,CodTpValorCp numeric(10) not null
,CodMoneda numeric(10) not null
,CodTpEstadoSol  varchar(10) not null
,CodTpLiquidacion  varchar(10) not null
,Importe numeric(19,2) not null
,CodCanalVta numeric(10) not null
,CodOficialCta numeric(10) not null
,ImporteGastos numeric(19,2) not null
,PorcGastos numeric(19,2) not null
,PorcGtoBancario numeric(19,2) not null 
,ImporteGtoBancario numeric(19,2) not null
,SePuedeLiquidar numeric(2) not null
,EsVCPSol numeric(2) not null
,ImporteNetoSusc numeric(19,2) not null
,Observaciones nvarchar(200) null
,ImporteSuscripcionFdo numeric(19,2) not null
,ImporteFraccion numeric(19,2) not null
,FactorConversion numeric(22,8) not null
,CantCuotapartes numeric(22,8) not null
,CodFondoHD numeric(10) not null
,CodTpValorCpHD  numeric(10) not null
,CodAgColocadorDesde numeric(10) not null
,CodSucursalDesde numeric(10) not null
,CodLiquidacion numeric(10) not null
,ValorCuotaparte numeric(22,8) not null
,CodTpPersona varchar(10) not null
)
CREATE TABLE #GENLIQ_TRANSF()

CREATE TABLE #GENLIQ_LIQUIDACIONESSALDC()
CREATE TABLE #GENLIQ_LIQ()
CREATE TABLE #GENLIQ_CERTIFICADOSIT()

exec spPROC_Liquidaciones_BuscarFdo '2018-09-22 00:00:00',''
go
exec spPROC_Liquidaciones_BuscarSusc '2018-09-22 00:00:00'
go
exec spPROC_Liquidaciones_BuscarResc '2018-09-22 00:00:00'
go
exec spPROC_Liquidaciones_BuscarTransf '2018-09-22 00:00:00'
go
exec spPROC_Liquidaciones_BuscarCotizacion '2018-09-22 00:00:00'
go
exec spPROC_Liquidaciones_CalcPosicionCpt '2018-09-22 00:00:00'
go
exec spPROC_Liquidaciones_ValidarSusc '2018-09-22 00:00:00'
go
exec spPROC_Liquidaciones_CalcSusc '2018-09-22 00:00:00',-1
go
exec spPROC_Liquidaciones_CalcularTransferencia '2018-09-22 00:00:00'
go
exec spPROC_Liquidaciones_CalcResc '2018-09-22 00:00:00',0
go
exec spPROC_Liquidaciones_CalcSusc '2018-09-22 00:00:00',0
go
exec spPROC_Liquidaciones_CalcResc '2018-09-22 00:00:00',-1
go
exec spPROC_Liquidaciones_Resumen '2018-09-22 00:00:00'
go

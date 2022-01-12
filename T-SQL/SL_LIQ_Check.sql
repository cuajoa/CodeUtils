--En el Setting esta filtrado por
-- AGColocador 1
-- Cuotapartista Num 36016 (que pertenece al Agente colocador 2)

DECLARE     @FechaDesde							Fecha='20100720'
DECLARE     @FechaHasta							Fecha='20210721'
DECLARE 	@IDFondo							CodigoInterfaz=NULL
DECLARE     @IDTipoValorCuotaParte				CodigoInterfaz=NULL
DECLARE 	@TimeStamp							TimeStamp= NULL--'AAAAAAAJh+g='
DECLARE 	@NumeroCuotapartista				DescripcionLarga=NULL--'111,1114,1159,1216,1217,1218,1400,1401,1650,1680,1681,1682,1683,1684,1785,1940,353,3595,3656,3873,3874'
DECLARE 	@CodInterfazCuotapartista			DescripcionLarga=NULL
DECLARE 	@NumeroAgColocadores				DescripcionLarga=NULL
DECLARE 	@CodInterfazAgColocadores			DescripcionLarga=NULL
DECLARE 	@CodInterfazCuotapartistaSetting	DescripcionExtraLarga='48-00-000111/6,48-00-0001114/6,48-00-0001159/6,48-00-0001216/6,48-00-0001217/6,48-00-0001218/6,48-00-0001400/6,48-00-0001401/6,48-00-0001650/6,48-00-0001680/6,48-00-0001681/6,48-00-0001682/6,48-00-0001683/6,48-00-0001684/6,48-00-0001785/6,48-00-0001940/6,48-00-000353/6,48-00-0003595/6,48-00-0003656/6,48-00-0003873/6,48-00-0003874/6'


--Filtro Setting en Agente
--Filtro Setting en Cuotapartista
--Request vacío
--Debe traer todo lo que pertenece a AgColoc 1 y el Cpt 1
EXEC spSL_GetLiquidaciones @FechaDesde,@FechaHasta,@IDFondo,@IDTipoValorCuotaParte,@TimeStamp,@NumeroCuotapartista ,@CodInterfazCuotapartista ,@NumeroAgColocadores, @CodInterfazAgColocadores , @CodInterfazCuotapartistaSetting

----Filtro en Agente
----Filtro en IDCuotapartista 632
----Debe traer CPT 632 que pertenece a AgColoc 1
--EXEC spSL_GetLiquidaciones @FechaDesde,@FechaHasta,@IDFondo,@IDTipoValorCuotaParte,@TimeStamp,'36016','632','1', @CodInterfazAgColocadores, '1'


----Filtro en Agente
----Sin Filtro en Cuotapartista
--EXEC spSL_GetLiquidaciones  @FechaDesde,@FechaHasta,@IDFondo,@IDTipoValorCuotaParte,@TimeStamp,'36016',@CodInterfazCuotapartista,NULL,@CodInterfazAgColocadores, @CodInterfazCuotapartistaSetting

----Sin Filtro en Agente
----Filtro en Cuotapartista
--EXEC spSL_GetLiquidaciones  @FechaDesde,@FechaHasta,@IDFondo,@IDTipoValorCuotaParte,@TimeStamp,'2261',@CodInterfazCuotapartista,@NumeroAgColocadores,@CodInterfazAgColocadores, @CodInterfazCuotapartistaSetting

----Sin Filtro en Agente
----Filtro en IDCuotapartista
--EXEC spSL_GetLiquidaciones  @FechaDesde,@FechaHasta,@IDFondo,@IDTipoValorCuotaParte,@TimeStamp,@NumeroCuotapartista,'632',@NumeroAgColocadores,@CodInterfazAgColocadores, @CodInterfazCuotapartistaSetting


----Sin Filtro en Agente
----Sin Filtro en Cuotapartista
--EXEC spSL_GetLiquidaciones  @FechaDesde,@FechaHasta,@IDFondo,@IDTipoValorCuotaParte,@TimeStamp,@NumeroCuotapartista,@CodInterfazCuotapartista,@NumeroAgColocadores,@CodInterfazAgColocadores, @CodInterfazCuotapartistaSetting
--16 Bco Ciudad (Cod 17)
--44 MatbaRofex (Cod 44)

--GRANT EXECUTE ON dbo.spSL_GetPosicionCuotapartista2 TO UsuarioGenerico

DECLARE     @Fecha						Fecha='20210721'
DECLARE 	@NumeroCuotapartista		DescripcionLarga=NULL
DECLARE 	@CodInterfazCuotapartista	DescripcionLarga=NULL
DECLARE 	@NumeroAgColocadores		DescripcionLarga=NULL
DECLARE 	@CodInterfazAgColocadores	DescripcionLarga=NULL
DECLARE 	@CodInterfazCuotapartistaSetting	DescripcionExtraLarga = '48-00-000111/6,48-00-0001114/6,48-00-0001159/6,48-00-0001216/6,48-00-0001217/6,48-00-0001218/6,48-00-0001400/6,48-00-0001401/6,48-00-0001650/6,48-00-0001680/6,48-00-0001681/6,48-00-0001682/6,48-00-0001683/6,48-00-0001684/6,48-00-0001785/6,48-00-0001940/6,48-00-000353/6,48-00-0003595/6,48-00-0003656/6,48-00-0003873/6,48-00-0003874/6'

--Filtro en Agente
--Filtro en Cuotapartista
--EXEC  spSL_GetPosicionCuotapartista @Fecha,'-1',@CodInterfazCuotapartista,1,'1','50187,39457'


----Filtro en Agente
----Sin Filtro en Cuotapartista
--EXEC spSL_GetPosicionCuotapartista @Fecha,@NumeroCuotapartista,@CodInterfazCuotapartista,'1',@CodInterfazAgColocadores,@CodInterfazCuotapartistaSetting

----Sin Filtro en Agente
----Filtro en Cuotapartista
--EXEC spSL_GetPosicionCuotapartista @Fecha,'50187',@CodInterfazCuotapartista,@NumeroAgColocadores,@CodInterfazAgColocadores,@CodInterfazCuotapartistaSetting

--Sin Filtro en Agente
--Sin Filtro en Cuotapartista
EXEC spSL_GetPosicionCuotapartista @Fecha,@NumeroCuotapartista,@CodInterfazCuotapartista,@NumeroAgColocadores,@CodInterfazAgColocadores,@CodInterfazCuotapartistaSetting





INSERT AGCOLOCFONDOS
	(CodFondo
,CodAgColocador
,EstaAnulado)
SELECT FONDOS.CodFondo
,AGCOLOCADORES.CodAgColocador
,0
FROM AGCOLOCADORES, FONDOS
WHERE not CodAgColocador in( select CodAgColocador from AGCOLOCFONDOS WHERE AGCOLOCFONDOS.CodAgColocador = AGCOLOCADORES.CodAgColocador
			and AGCOLOCFONDOS.CodFondo = FONDOS.CodFondo)


INSERT SUCFONDOS
	(CodFondo
,CodAgColocador
,CodSucursal
,EstaAnulado)
SELECT FONDOS.CodFondo
,SUCURSALES.CodAgColocador
,SUCURSALES.CodSucursal
,0
FROM SUCURSALES, FONDOS
WHERE not CodSucursal in( select CodSucursal from SUCFONDOS WHERE SUCFONDOS.CodAgColocador = SUCURSALES.CodAgColocador
			and SUCFONDOS.CodFondo = FONDOS.CodFondo)

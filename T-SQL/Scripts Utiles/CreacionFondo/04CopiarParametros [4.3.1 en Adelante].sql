DECLARE @CodFondoDesde CodigoMedio
DECLARE @CodFondoHasta CodigoMedio

SELECT @CodFondoDesde = 10
SELECT @CodFondoHasta = 28

DELETE FONDOSPARAM 
WHERE FONDOSPARAM.CodFondo = @CodFondoHasta

INSERT FONDOSPARAM 
    SELECT @CodFondoHasta
    ,CodParametroFdo
    ,CodUsuarioU
    ,FechaU
    ,TermU
    ,ValorTexto
    ,ValorNumero
    ,ValorFecha
FROM FONDOSPARAM
WHERE FONDOSPARAM.CodFondo = @CodFondoDesde


UPDATE FONDOSPARAM
    SET ValorTexto = null
        ,ValorNumero = null
        ,ValorFecha = null
WHERE CodFondo = @CodFondoHasta and CodParametroFdo LIKE '%CNV%'



UPDATE FONDOSREAL 
    SET FONDOSREAL.CodTpCosto = FONDOREALDESDE.CodTpCosto
    ,FONDOSREAL.CodTpDevengamiento = FONDOREALDESDE.CodTpDevengamiento
    ,FONDOSREAL.CodTpManejoCert = FONDOREALDESDE.CodTpManejoCert
    ,FONDOSREAL.CodTpFondo = FONDOREALDESDE.CodTpFondo
    ,FONDOSREAL.CodTpProvision = FONDOREALDESDE.CodTpProvision
    ,FONDOSREAL.CodTpRecepcionTit = FONDOREALDESDE.CodTpRecepcionTit
    ,FONDOSREAL.CodAgColocadorDep = FONDOREALDESDE.CodAgColocadorDep
    ,FONDOSREAL.CodSociedadGte = FONDOREALDESDE.CodSociedadGte
    ,FONDOSREAL.CodMoneda = FONDOREALDESDE.CodMoneda
    ,FONDOSREAL.CodTpCuotaparte = FONDOREALDESDE.CodTpCuotaparte
    ,FONDOSREAL.EsAbierto = FONDOREALDESDE.EsAbierto
    ,FONDOSREAL.CodTpRecepcionMon = FONDOREALDESDE.CodTpRecepcionMon
    ,FONDOSREAL.CodTpCotizacionRecepMon = FONDOREALDESDE.CodTpCotizacionRecepMon
    ,FONDOSREAL.CodTpReintegroGastoResc = FONDOREALDESDE.CodTpReintegroGastoResc
from FONDOSREAL, FONDOSREAL FONDOREALDESDE
WHERE FONDOSREAL.CodFondo = @CodFondoHasta
    AND FONDOREALDESDE.CodFondo = @CodFondoDesde



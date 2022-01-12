SELECT FONDOSREAL.NumFondo, MONEDAS.Descripcion as MonedaFondo, VALORESCP.Fecha, 
VALORESCP.ValorCuotaparte, VALORESCP.PatrimonioNeto, 1/COTIZACIONESMON.CambioVendedor as CambioVendedor,
VALORESCP.ValorCuotaparte/COTIZACIONESMON.CambioVendedor as ValorCuotaparteARS,
VALORESCP.PatrimonioNeto/COTIZACIONESMON.CambioVendedor as PatrimonioNetoARS
FROM VALORESCP 
INNER JOIN FONDOSREAL ON FONDOSREAL.CodFondo = VALORESCP.CodFondo
INNER JOIN MONEDAS ON FONDOSREAL.CodMoneda = MONEDAS.CodMoneda
INNER JOIN COTIZACIONESMON ON VALORESCP.CodFondo=COTIZACIONESMON.CodFondo
AND VALORESCP.Fecha=COTIZACIONESMON.Fecha AND MONEDAS.CodMoneda=COTIZACIONESMON.CodMoneda
WHERE VALORESCP.Fecha> '20200101' AND FONDOSREAL.CodMoneda=2


--PERSONAS FISICAS 
SELECT CUOTAPARTISTAS.NumCuotapartista,
    PERSONAS.Apellido + ',' + PERSONAS.Nombre as ApellidoNombre ,

    NumeroCuenta, CBU
FROM dbo.CONDOMINIOS
    INNER JOIN dbo.CUOTAPARTISTAS ON dbo.CONDOMINIOS.CodCuotapartista = dbo.CUOTAPARTISTAS.CodCuotapartista
    INNER JOIN dbo.PERSONAS ON dbo.PERSONAS.CodPersona = dbo.CONDOMINIOS.CodPersona
    INNER JOIN dbo.CPTCTASBANCARIAS ON dbo.CPTCTASBANCARIAS.CodCuotapartista = dbo.CUOTAPARTISTAS.CodCuotapartista
WHERE dbo.CONDOMINIOS.EstaAnulado = 0
    AND dbo.CUOTAPARTISTAS.EstaAnulado = 0
    AND dbo.CUOTAPARTISTAS.EsPersonaFisica = 0
    AND dbo.PERSONAS.EstaAnulado = 0
    AND dbo.CPTCTASBANCARIAS.EstaAnulado = 0

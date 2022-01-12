EXEC sp_CreateProcedure 'dbo.spTenenciasFCI'
GO 
ALTER PROCEDURE dbo.spTenenciasFCI
    @FechaPosicion                Fecha = NULL
WITH ENCRYPTION
AS

-- depura corridas anteriores del proceso
DELETE FROM TENENCIAFCI WHERE FechaPosicion = @FechaPosicion

-- inserta registros
INSERT INTO TENENCIAFCI (NombreFondo, TipoValorCp, NSuc_ACargo, DescSuc_ACargo,
Oficial_Origen, Sucursal_CuotaP, PersFisica, TenenciaCantCp, TenenciaValuada,
AgenteColocador, CuotapartistaNum, CuotapartistaNom, CUIL_CUIT_CuotaPartista,
ValorCuotaparte, FechaIngreso, FechaPosicion) 
SELECT  
		FONDOS.Nombre AS NombreFondo, 
        TPVALORESCP.Abreviatura AS TipoValorCp,
        SUCACARGO.NumSucursal   AS NSuc_ACargo, 
        SUCACARGO.Descripcion AS DescSuc_ACargo, 
        OFICIALESCTA.Apellido+' '+OFICIALESCTA.Nombre AS Oficial_Origen, 
        SUC2.NumSucursal  AS Sucursal_CuotaP,              
        CASE CUOTAPARTISTAS.EsPersonaFisica WHEN -1 THEN 'SI' ELSE 'NO' END AS PersFisica,
        SUM(LIQUIDACIONES.CantCuotapartes) AS TenenciaCantCp,
        SUM(LIQUIDACIONES.CantCuotapartes) * VALORESCP.ValorCuotaparte AS TenenciaValuada,
        AGCOLOCADORES.Descripcion AS AgenteColocador,
        CUOTAPARTISTAS.NumCuotapartista AS CuotapartistaNum, 
        CUOTAPARTISTAS.Nombre AS CuotapartistaNom, 
        Isnull(PERSONAS.CUIL,0) as CUIL_CUIT_CuotaPartista,
        VALORESCP.ValorCuotaparte, 
        CONVERT(VARCHAR(10),CUOTAPARTISTAS.FechaIngreso, 120) AS FechaIngreso,
        CONVERT(VARCHAR(10),@FechaPosicion, 120)
FROM    LIQUIDACIONES
        INNER JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista 
        LEFT  JOIN CPTJURIDICOS ON CPTJURIDICOS.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
        INNER JOIN CONDOMINIOS ON CONDOMINIOS.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista AND CONDOMINIOS.EstaAnulado = 0 AND CONDOMINIOS.Orden=1 
        INNER JOIN PERSONAS ON PERSONAS.CodPersona = CONDOMINIOS.CodPersona AND PERSONAS.EstaAnulado = 0 AND  PERSONAS.CodPersona=CONDOMINIOS.CodPersona  
        LEFT  JOIN TPDOCIDENTIDAD ON TPDOCIDENTIDAD.CodTpDocIdentidad = PERSONAS.CodTpDocIdentidad
        INNER JOIN FONDOS ON FONDOS.CodFondo = LIQUIDACIONES.CodFondo AND LIQUIDACIONES.EstaAnulado = 0 
        INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
        INNER JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo AND VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp AND 
        VALORESCP.Fecha = 
        (SELECT MAX(Fecha) FROM VALORESCP VAL2MAX WHERE VAL2MAX.CodFondo = VALORESCP.CodFondo and Fecha <= @FechaPosicion)
        INNER JOIN AGCOLOCADORES ON AGCOLOCADORES.CodAgColocador = CUOTAPARTISTAS.CodAgColocadorOfCta and  (AGCOLOCADORES.NumAgColocador = 6 or AGCOLOCADORES.NumAgColocador = 7)
        INNER JOIN  SUCURSALES SUCACARGO ON SUCACARGO.CodSucursal=CUOTAPARTISTAS.CodSucursalOfCta
        INNER JOIN  SUCURSALES SUC2 ON SUC2.CodSucursal=CUOTAPARTISTAS.CodSucursal
        INNER JOIN OFICIALESCTA ON CUOTAPARTISTAS.CodAgColocadorOfCta=OFICIALESCTA.CodAgColocador AND CUOTAPARTISTAS.CodOficialCta=OFICIALESCTA.CodOficialCta
WHERE   LIQUIDACIONES.EstaAnulado = 0
    AND LIQUIDACIONES.FechaLiquidacion <= @FechaPosicion
GROUP BY 
		FONDOS.Nombre, 
        TPVALORESCP.Abreviatura,
        SUCACARGO.NumSucursal,        
        SUCACARGO.Descripcion, 
        CASE CUOTAPARTISTAS.EsPersonaFisica WHEN -1 THEN 'SI' ELSE 'NO' END,
        AGCOLOCADORES.Descripcion,
        CUOTAPARTISTAS.NumCuotapartista, 
        CUOTAPARTISTAS.Nombre, 
        Isnull(PERSONAS.CUIL,0) ,        
        VALORESCP.ValorCuotaparte,     
        CUOTAPARTISTAS.CodSucursal,
        CUOTAPARTISTAS.CodSucursalOfCta,
        OFICIALESCTA.Apellido,
        OFICIALESCTA.Nombre,
        SUC2.NumSucursal,
		VALORESCP.ValorCuotaparte, 
        CUOTAPARTISTAS.FechaIngreso
HAVING SUM(LIQUIDACIONES.CantCuotapartes) <> 0;
GO




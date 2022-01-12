
IF EXISTS(SELECT * FROM sys.objects WHERE name='spINFO_PosCpt_BuscarVCP')
BEGIN

DROP PROC spINFO_PosCpt_BuscarVCP

END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE name='PosicionCTP_Fecha')
BEGIN

DROP PROC PosicionCTP_Fecha

END
GO

-- ##SCRIPT##: vwPosicionCuotapartista.sql

EXEC dbo.sp_CreateView 'dbo.vwPosicionCuotapartista'
GO 

ALTER VIEW dbo.vwPosicionCuotapartista
WITH ENCRYPTION
AS


SELECT  FONDOSREAL.NumFondo, 
		FONDOSREAL.Nombre, 
		FONDOSREAL.NombreAbreviado, 
		FONDOSREAL.CodCAFCI,
		TPVALORESCP.CodTpValorCp as CodClase,
		TPVALORESCP.Descripcion as Clase, 
		TPVALORESCP.Abreviatura, 
		TPVALORESCP.CodCAFCI as ClaseCodCAFCI,
		CUOTAPARTISTAS.CodCuotapartista, 
		CUOTAPARTISTAS.NumCuotapartista, 
		CUOTAPARTISTAS.Nombre Cuenta,
		CUOTAPARTISTAS.CodInterfaz, 
		CUOTAPARTISTAS.CodInterfazAdicional,  
		SUM(LIQUIDACIONES.CantCuotapartes) AS CuotapartesTotales, 
		ISNULL(BLOQUEOS.CuotapartesBloqueadas, 0) AS CuotapartesBloqueadas, 
		SUM(LIQUIDACIONES.CantCuotapartes) * VALORESCP.ValorCuotaparte AS CuotapartesValuadas,  
		VALORESCP.ValorCuotaparte AS UltimoVCPValor, 
		MAX(VALORESCP.Fecha) AS UltimoVCPFecha,
		MONEDAS.Simbolo, 
		MONEDAS.Descripcion
FROM    LIQUIDACIONES  
		INNER JOIN CUOTAPARTISTAS ON LIQUIDACIONES.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista  
		INNER JOIN FONDOSREAL ON FONDOSREAL.CodFondo = LIQUIDACIONES.CodFondo 
		INNER JOIN FONDOSPARAM on FONDOSREAL.CodFondo = FONDOSPARAM.CodFondo AND FONDOSPARAM.CodParametroFdo ='NRCNV' 
		INNER JOIN MONEDAS ON MONEDAS.CodMoneda = LIQUIDACIONES.CodMoneda 
		INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo And TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp   
		INNER JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo And VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp  
		AND VALORESCP.Fecha = (SELECT MAX(Fecha) FROM VALORESCP VAL2MAX WHERE VAL2MAX.CodFondo = VALORESCP.CodFondo  
     						And VAL2MAX.CodTpValorCp = VALORESCP.CodTpValorCp And VAL2MAX.Fecha <= GETDATE())   
		LEFT  JOIN(SELECT  CPTBLOQUEOS.CodFondo, CPTBLOQUEOS.CodTpValorCp, CPTBLOQUEOS.CodCuotapartista, SUM(CPTBLOQUEOS.CantidadCuotapartes) AS CuotapartesBloqueadas   
						From CPTBLOQUEOS Where CPTBLOQUEOS.FechaBloqueo <= GETDATE() 
						Group By CPTBLOQUEOS.CodFondo, CPTBLOQUEOS.CodTpValorCp, CPTBLOQUEOS.CodCuotapartista) AS BLOQUEOS   
					On BLOQUEOS.CodFondo = LIQUIDACIONES.CodFondo And BLOQUEOS.CodTpValorCp = LIQUIDACIONES.CodTpValorCp And BLOQUEOS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista   
		AND	LIQUIDACIONES.EstaAnulado = 0 AND LIQUIDACIONES.FechaConcertacion <= GETDATE() 

--WHERE CUOTAPARTISTAS.CodCuotapartista = 18406
GROUP BY    FONDOSREAL.NumFondo, FONDOSREAL.Nombre, FONDOSREAL.NombreAbreviado, FONDOSREAL.CodCAFCI,  
			TPVALORESCP.CodTpValorCp,TPVALORESCP.Descripcion, TPVALORESCP.Abreviatura, TPVALORESCP.CodCAFCI , 
			CUOTAPARTISTAS.CodCuotapartista, CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.Nombre,
			CUOTAPARTISTAS.CodInterfaz, CUOTAPARTISTAS.CodInterfazAdicional, 
			BLOQUEOS.CuotapartesBloqueadas, VALORESCP.ValorCuotaparte, VALORESCP.Fecha,
			MONEDAS.Simbolo, MONEDAS.Descripcion
HAVING  SUM(LIQUIDACIONES.CantCuotapartes) > 0 

GO

-- ##SCRIPT##: Condominios.sql

EXEC dbo.sp_CreateView 'dbo.vwCondominios'
GO 

ALTER VIEW dbo.vwCondominios
WITH ENCRYPTION
AS

	SELECT  CodPersona,
			CodCuotapartista
	FROM CONDOMINIOS
	WHERE EstaAnulado = 0

GO
-- ##SCRIPT##: Cuotapartistas.sql

EXEC dbo.sp_CreateView 'dbo.vwCUOTAPARTISTASCUENTAS'
GO 

ALTER VIEW dbo.vwCUOTAPARTISTASCUENTAS
WITH ENCRYPTION
AS

SELECT  CUOTAPARTISTAS.CodCuotapartista, 
		CUOTAPARTISTAS.NumCuotapartista, 
		CUOTAPARTISTAS.Nombre Cuenta,
		CUOTAPARTISTAS.CodInterfaz, 
		CUOTAPARTISTAS.CodInterfazAdicional,
		CASE WHEN CUOTAPARTISTAS.EsPersonaFisica = -1 THEN 'SI' ELSE 'NO' END EsPersonaFisica,
		CUOTAPARTISTAS.FechaIngreso,
		OFICIALESCTA.Apellido + ', ' + OFICIALESCTA.Nombre As Oficial,
		AGCOLOCADORES.Descripcion As AgenteColocador,
		TPPERFILRIESGOCPT.Descripcion as PerfilCuotapartista,
        MONEDAS.Descripcion as MonedaActividadEsperada,
        MONEDAS.Simbolo as SimboloActividadEsperada,
        CPTUIF.ImporteMaxOper as ImporteMaximoOperado,
        CPTUIF.ImporteEstimAnual as ImporteEstimadoAnual
FROM CUOTAPARTISTAS
		LEFT JOIN OFICIALESCTA ON OFICIALESCTA.CodOficialCta = CUOTAPARTISTAS.CodOficialCta
		LEFT JOIN AGENTESAGCOLOCADORESREL ON AGENTESAGCOLOCADORESREL.CodAgColocador = OFICIALESCTA.CodAgColocador
		LEFT JOIN AGCOLOCADORES ON AGCOLOCADORES.CodAgColocador = CUOTAPARTISTAS.CodAgColocador
		LEFT JOIN TPPERFILRIESGOCPT ON CUOTAPARTISTAS.CodTpPerfilRiesgoCpt = TPPERFILRIESGOCPT.CodTpPerfilRiesgoCpt
        LEFT JOIN CPTUIF ON CUOTAPARTISTAS.CodCuotapartista = CPTUIF.CodCuotapartista
        LEFT JOIN MONEDAS ON MONEDAS.CodMoneda = CPTUIF.CodMonedaImporteEstim
WHERE CUOTAPARTISTAS.EstaAnulado = 0

GO
-- ##SCRIPT##: Operaciones del d�a.sql

EXEC dbo.sp_CreateView 'dbo.vwOPERACIONES'
GO 

ALTER VIEW dbo.vwOPERACIONES
WITH ENCRYPTION
AS
	SELECT LIQUIDACIONES.NumLiquidacion, 
		   TPLIQUIDACION.Descripcion As TipoOperacion,
		   CUOTAPARTISTAS.CodCuotapartista,
		   CUOTAPARTISTAS.NumCuotapartista, 
		   LIQUIDACIONES.FechaConcertacion,
		   LIQUIDACIONES.FechaLiquidacion As FechaLiquidacion,
		   LIQUIDACIONES.Importe As Monto,
		   LIQUIDACIONES.CantCuotapartes As CantCuotapartes,
		   VALORESCP.ValorCuotaparte As VCP,
		   AGCOLOCADORES.Descripcion As AgColocador,
		   OFICIALESCTA.Apellido + ', ' + OFICIALESCTA.Nombre As OficialCuenta,
		   CANALESVTA.Descripcion As CanalVenta,
		   FONDOSREAL.NumFondo, 
		   FONDOSREAL.Nombre, 
		   FONDOSREAL.NombreAbreviado, 
		   FONDOSREAL.CodCAFCI,
		   TPVALORESCP.CodTpValorCp as CodClase,
		   TPVALORESCP.Descripcion as Clase, 
		   TPVALORESCP.Abreviatura, 
		   TPVALORESCP.CodCAFCI as ClaseCodCAFCI,
		   dbo.fnTraerNroCNVFdo(FONDOSREAL.CodFondo) As CodigoCNV,
		   MONLIQ.Descripcion As MonedaLiquidacion
		   --TPORIGENSOL.Descripcion As OrigenSolicitud,
		   --TPESTADOSOL.Descripcion As EstadoSolicitud,
		  -- BANCOS.Descripcion As Banco
	FROM LIQUIDACIONES
		 LEFT JOIN FONDOSREAL  ON FONDOSREAL.CodFondo = LIQUIDACIONES.CodFondo 
		 INNER JOIN MONEDAS MONLIQ ON MONLIQ.CodMoneda = LIQUIDACIONES.CodMoneda
		 INNER JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista
		 LEFT JOIN VALORESCP ON VALORESCP.CodFondo = LIQUIDACIONES.CodFondo
								 AND VALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
								 AND VALORESCP.Fecha = LIQUIDACIONES.FechaConcertacion
		 INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo
								   AND TPVALORESCP.CodTpValorCp = LIQUIDACIONES.CodTpValorCp
		 INNER JOIN AGCOLOCADORES ON AGCOLOCADORES.CodAgColocador = LIQUIDACIONES.CodAgColocador
		 INNER JOIN TPLIQUIDACION ON TPLIQUIDACION.CodTpLiquidacion = LIQUIDACIONES.CodTpLiquidacion
		 INNER JOIN OFICIALESCTA ON OFICIALESCTA.CodOficialCta = LIQUIDACIONES.CodOficialCta AND OFICIALESCTA.CodAgColocador = LIQUIDACIONES.CodAgColocador
		 LEFT JOIN CANALESVTA ON CANALESVTA.CodCanalVta = LIQUIDACIONES.CodCanalVta
	WHERE LIQUIDACIONES.EstaAnulado = 0 

GO

-- ##SCRIPT##: Personas.sql

EXEC dbo.sp_CreateView 'dbo.vwPersonas'
GO 

ALTER VIEW dbo.vwPersonas
WITH ENCRYPTION
AS
	
	SELECT DISTINCT PERSONAS.CodPersona,
					PERSONAS.Nombre, 
				    PERSONAS.Apellido, 
					PERSONAS.PatrimonioEstim, 
					CASE WHEN CodDocIdentidad = 'DNI' THEN right('000000000'+CONVERT(VARCHAR(20),PERSONAS.NumDocumento),8) else CONVERT(VARCHAR(20),PERSONAS.NumDocumento) end As Documento, 
					PERSONAS.PromedioMensual, 
					COALESCE(ACTIVIDADES.Descripcion,'') As Actividad, 
					PERSONAS.AlturaCalle, 
					PERSONAS.EsPep, 
					PERSONAS.EstaAnulado, 
					PERSONAS.ApellidoMaterno, 
					PERSONAS.Calle, 
					PERSONAS.CelularPersonal, 
					PERSONAS.CodAuditoriaRef, 
					PERSONAS.CodInterfaz, 
					PERSONAS.CodInterfazAdicional, 
					PERSONAS.CodInterfazBanco, 
					PERSONAS.CodigoPostal, 
					CONYUGE.Apellido ConyugeApellido, 
					CONYUGE.Nombre ConyugeNombre, 
					PERSONAS.CUIT, 
					PERSONAS.Departamento, 
					COALESCE(PERSONAS.Calle, '') + COALESCE( ' '+ PERSONAS.AlturaCalle, '') + COALESCE( ' '+ PERSONAS.Piso, '') + COALESCE( ' '+ PERSONAS.Departamento, '') As Direccion, 
					PERSONAS.EMail, 
					PERSONAS.EsSujetoObligado, 
					PERJURIDICAS.Escritura, 
					COALESCE(TPESTADOCIV.Descripcion,'') EstadoCivil, 
					PERSONAS.Fax, 
				    PERJURIDICAS.FechaConstitucion, 
					PERSONAS.FechaIngreso, 
					PERSONAS.FechaNacimiento, 
					PERJURIDICAS.Folio, 
					PERJURIDICAS.GIIN, 
					PERJURIDICAS.Libro, 
					PERSONAS.Localidad, 
					PERJURIDICAS.LugarConstitucion, 
					PAISESNACIMIENTO.Descripcion As LugarNacimiento, 
					COALESCE(PAISNAC.Nacionalidad,'') As Nacionalidad, 
					PERJURIDICAS.NumInscripcion, 
					PERSONAS.CodigoIdTributaria, 
					COALESCE(PAISES.Descripcion,'') As Pais, 
					MONPATRIM.Descripcion PatrimonioMoneda, 
					PERSONAS.Perfil, 
					PERSONAS.Piso, 
					COALESCE(PROVINCIAS.Descripcion,'') AS Provincia, 
					PERSONAS.RazonSocial, 
					(CASE WHEN TPPERSONA.CodTpPersona = 'PERNAT'THEN 
						(CASE WHEN PERSONAS.EsMasculino = -1 THEN 'Masculino'ELSE 'Femenino'END) 
					ELSE NULL END) As SEXO, 
					PERSONAS.Telefono, 
					COALESCE(TPCONTRIBUYENTE.Descripcion,'') TipoContribuyente, 
					COALESCE(TPDOCIDENTIDAD.Descripcion,'') TipoDocumento, 
					TPPERSONA.Descripcion TipoPersona, 
					TPVINCULACIONPERS.Descripcion TipoVinculacionPersona, 
					PERJURIDICAS.Tomo
	FROM PERSONAS 
		LEFT JOIN TPVINCULACIONPERS ON PERSONAS.CodTpVinculacionPers = TPVINCULACIONPERS.CodTpVinculacionPers
		LEFT JOIN PAISES ON PAISES.CodPais = PERSONAS.CodPais
		LEFT JOIN STATUSFATCA ON STATUSFATCA.CodStatusFATCA = PERSONAS.CodStatusFATCA 
		LEFT JOIN PROVINCIAS ON PROVINCIAS.CodPais = PERSONAS.CodPais AND PROVINCIAS.CodProvincia = PERSONAS.CodProvincia
		LEFT JOIN TPCONTRIBUYENTE ON TPCONTRIBUYENTE.CodTpContribuyente = PERSONAS.CodTpContribuyente
		LEFT JOIN PAISES PAISNAC ON PAISNAC.CodPais = PERSONAS.CodPaisNacionalidad
		LEFT JOIN TPDOCIDENTIDAD ON TPDOCIDENTIDAD.CodTpDocIdentidad = PERSONAS.CodTpDocIdentidad 
		LEFT JOIN TPESTADOCIV ON TPESTADOCIV.CodTpEstadoCiv = PERSONAS.CodTpEstadoCiv 
		LEFT JOIN ACTIVIDADES ON ACTIVIDADES.CodActividad = PERSONAS.CodActividad
		LEFT JOIN PERSONAS CONYUGE ON CONYUGE.CodPersona = PERSONAS.CodConyuge
		LEFT JOIN MONEDAS MONPATRIM ON MONPATRIM.CodMoneda = PERSONAS.CodMonedaPatEstim
		LEFT JOIN PAISES AS PAISESNACIMIENTO ON PAISESNACIMIENTO.CodPais = PERSONAS.CodPaisNacimiento
		LEFT JOIN TPPERSONA ON TPPERSONA.CodTpPersona = PERSONAS.CodTpPersona
		LEFT JOIN CONDOMINIOS 
			INNER JOIN CUOTAPARTISTAS 
				LEFT JOIN FONDOSCPT 
					INNER JOIN FONDOSUSER ON FONDOSUSER.CodFondo = FONDOSCPT.CodFondo
				ON CUOTAPARTISTAS.CodCuotapartista = FONDOSCPT.CodCuotapartista 
			ON CUOTAPARTISTAS.CodCuotapartista = CONDOMINIOS.CodCuotapartista 
		ON CONDOMINIOS.CodPersona = PERSONAS.CodPersona
		LEFT JOIN PERJURIDICAS 
			LEFT JOIN TPPERSONASJURIDICAS ON TPPERSONASJURIDICAS.CodTpPersonaJuridica = PERJURIDICAS.CodTpPersonaJuridica
			LEFT JOIN TPCARACTER ON TPCARACTER.CodTpCaracter =  PERJURIDICAS.CodTpCaracter
		ON PERJURIDICAS.CodPersona = PERSONAS.CodPersona
	WHERE PERSONAS.EstaAnulado = 0

GO


EXEC dbo.sp_CreateView 'dbo.vwFondos'
GO 

ALTER VIEW dbo.vwFondos
WITH ENCRYPTION
AS

SELECT  FONDOSREAL.NumFondo, FONDOSREAL.Nombre, FONDOSREAL.NombreAbreviado, FONDOSREAL.CodCAFCI, 
CAST(FONDOSPARAM.ValorNumero as int) as NumeroCNV, TPPERFILES.Descripcion as PerfilFondo, 
TPVALORESCP.CodTpValorCp as CodClase, TPVALORESCP.Descripcion as Clase, TPVALORESCP.Abreviatura, 
TPVALORESCP.CodCAFCI as ClaseCodCAFCI
FROM FONDOSREAL
INNER JOIN TPVALORESCP ON FONDOSREAL.CodFondo = TPVALORESCP.CodFondo
INNER JOIN FONDOSPARAM ON FONDOSREAL.CodFondo = FONDOSPARAM.CodFondo AND CodParametroFdo = 'NRCNV'
LEFT JOIN TPPERFILFDO ON FONDOSREAL.CodFondo = TPPERFILFDO.CodFondo
LEFT JOIN TPPERFILES ON TPPERFILES.CodTpPerfil = TPPERFILFDO.CodTpPerfil


GO

EXEC dbo.sp_CreateView 'dbo.vwValoresCP'
GO 

ALTER VIEW dbo.vwValoresCP
WITH ENCRYPTION
AS

SELECT FONDOSREAL.NumFondo, 
		FONDOSREAL.Nombre, 
		FONDOSREAL.NombreAbreviado, 
		FONDOSREAL.CodCAFCI,
		TPVALORESCP.CodTpValorCp as CodClase,
		TPVALORESCP.Descripcion as Clase, 
		TPVALORESCP.Abreviatura, 
		TPVALORESCP.CodCAFCI as ClaseCodCAFCI,
VALORESCP.Fecha, VALORESCP.ValorCuotaparte,
VALORESCP.PatrimonioNeto, VALORESCP.TNA, VALORESCP.TIR, VALORESCP.CuotapartesCirculacion,VALORESCP.Variacion
FROM VALORESCP
INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = TPVALORESCP.CodFondo AND TPVALORESCP.CodTpValorCp = VALORESCP.CodTpValorCp
INNER JOIN FONDOSREAL ON FONDOSREAL.CodFondo = VALORESCP.CodFondo

GO
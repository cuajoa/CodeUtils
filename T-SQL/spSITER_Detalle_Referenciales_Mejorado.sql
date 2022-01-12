/*******************************************/
/***** SITER - DETALLE - REFERENCIALES *****/
/*******************************************/

EXEC sp_CreateProcedure 'dbo.spSITER_Detalle_Referenciales'
GO
 
ALTER PROCEDURE dbo.spSITER_Detalle_Referenciales
	
	@CodCuotapartista As CodigoLargo,
	@FechaDesde as Fecha,
	@FechaHasta as Fecha

WITH ENCRYPTION

AS

/* FILTRO DE ENTRADA --> */
--DECLARE @CodCuotapartista As CodigoLargo
--DECLARE @NumCuotapartista As NumeroLargo

--SET @NumCuotapartista = 174	--696
--SET @CodCuotapartista = (SELECT CodCuotapartista FROM CUOTAPARTISTAS WHERE NumCuotapartista = @NumCuotapartista)
--SELECT * FROM CUOTAPARTISTAS WHERE CodCuotapartista = @CodCuotapartista
/* FILTRO DE ENTRADA <-- */

IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#SITER_DETALLE_AUX'))
	DROP TABLE #SITER_DETALLE_AUX

IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#SITER_DETALLE_CONDOMINIOS'))
	DROP TABLE #SITER_DETALLE_CONDOMINIOS
	
CREATE TABLE #SITER_DETALLE_AUX
(
	CodCuotapartista numeric(10,0) NOT NULL, 
	CodPersona numeric(10,0) NULL,
	ApellidoNombre varchar(101) COLLATE DATABASE_DEFAULT NULL, 
	CodDocumento varchar(2) COLLATE DATABASE_DEFAULT NULL, 
	NroDocumento varchar(50) COLLATE DATABASE_DEFAULT NULL,

	Calle varchar(50) COLLATE DATABASE_DEFAULT NULL,
	NumeroPuerta varchar(8) COLLATE DATABASE_DEFAULT NULL,
	Oficina varchar(5) COLLATE DATABASE_DEFAULT NULL,
	Sector varchar(5) COLLATE DATABASE_DEFAULT NULL,
	Torre varchar(6) COLLATE DATABASE_DEFAULT NULL,
	Manzana varchar(30) COLLATE DATABASE_DEFAULT NULL,
	Piso varchar(5) COLLATE DATABASE_DEFAULT NULL,
	Localidad varchar(60) COLLATE DATABASE_DEFAULT NULL,
	CodProvincia varchar(2) COLLATE DATABASE_DEFAULT NULL,
	CodigoPostal varchar(10) COLLATE DATABASE_DEFAULT NULL,
	NumCuotapartista varchar(11) COLLATE DATABASE_DEFAULT NULL,
	
	Residente numeric(1) NOT NULL,
	TpPersona numeric(1) NOT NULL, 
	--TpDocumentos varchar(2) COLLATE DATABASE_DEFAULT NULL, 
	--NroDocumentoOtros varchar(50) COLLATE DATABASE_DEFAULT NULL,
	PaisOtorgDoc varchar(50) COLLATE DATABASE_DEFAULT NULL,
	LugarNacimiento varchar(50) COLLATE DATABASE_DEFAULT NULL,
	FechaNacimiento varchar(8) COLLATE DATABASE_DEFAULT NULL, 
	TpEntidad varchar(3) COLLATE DATABASE_DEFAULT NULL, 
	DenominacionEntidad varchar(100) COLLATE DATABASE_DEFAULT NULL, 
	LugarConstitucion varchar(100) COLLATE DATABASE_DEFAULT NULL,
	FechaConstitucion varchar(8) COLLATE DATABASE_DEFAULT NULL, 
	DomicilioExterior varchar(100) COLLATE DATABASE_DEFAULT NULL,
	CiudadLocalidadExterior varchar(100) COLLATE DATABASE_DEFAULT NULL,
	ProvDptoEstadoExterior varchar(100) COLLATE DATABASE_DEFAULT NULL,
	PaisExterior varchar(50) NULL,
	NroIdentTributariaPaisResidencia varchar(50) COLLATE DATABASE_DEFAULT NULL,
	ResidenciaTributaria varchar(50) COLLATE DATABASE_DEFAULT NULL
)

CREATE TABLE #SITER_DETALLE_CONDOMINIOS
(
	ID numeric(10) identity (1,1)  not null,
	CodCuotapartista numeric(10,0) NOT NULL,
	CodPersona numeric(10,0) NOT NULL,
	CodAuditoriaRef numeric(10,0) NOT NULL,
	EstaAnulado smallint NOT NULL,
	TieneDomicilioPrincipalExt smallint NOT NULL,
	TieneDomicilioFiscalExt smallint NOT NULL
)


DECLARE @CodPersona numeric(10,0)
DECLARE @CodCuotapartistaSIT numeric(10,0)
DECLARE @TieneDomicilioPrincipalExt Boolean
DECLARE @TieneDomicilioFiscalExt Boolean
DECLARE @EsPersonaFisica Boolean
DECLARE @CodPaisAplicacion CodigoMedio

declare @i			CodigoMedio
declare @iCantidad	CodigoMedio

SELECT @CodPaisAplicacion = dbo.fnPaisAplicacion()
--SELECT @EsPersonaFisica = EsPersonaFisica FROM CUOTAPARTISTAS WHERE CodCuotapartista = @CodCuotapartista 

--/*Domicilio en el exterior*/
--IF @EsPersonaFisica = -1
--BEGIN

	INSERT INTO #SITER_DETALLE_CONDOMINIOS (CodCuotapartista,CodPersona, CodAuditoriaRef, EstaAnulado, TieneDomicilioPrincipalExt, TieneDomicilioFiscalExt)
		SELECT DISTINCT CONDOMINIOS.CodCuotapartista,
						PERSONAS.CodPersona,
						CONDOMINIOS.CodAuditoriaRef,
						CONDOMINIOS.EstaAnulado,
								--CASE WHEN P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL AND PERSONAS.NIFTIN IS NOT NULL AND PERSONAS.Calle IS NOT NULL THEN -1 ELSE 0 END As TieneDomicilioPrincipalExt,
								--CASE WHEN P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL AND PERSONASDOMICILIOFISCAL.NIFTIN IS NOT NULL AND PERSONASDOMICILIOFISCAL.Calle IS NOT NULL THEN -1 ELSE 0 END As TieneDomicilioFiscalExt
								CASE WHEN P1.CodPais <> 1 AND P1.CodPais IS NOT NULL AND PERSONAS.NIFTIN IS NOT NULL AND PERSONAS.Calle IS NOT NULL THEN -1 ELSE 0 END As TieneDomicilioPrincipalExt,
								CASE WHEN P2.CodPais <> 1 AND P2.CodPais IS NOT NULL AND PERSONASDOMICILIOFISCAL.NIFTIN IS NOT NULL AND PERSONASDOMICILIOFISCAL.Calle IS NOT NULL THEN -1 ELSE 0 END As TieneDomicilioFiscalExt
		FROM CUOTAPARTISTAS
			INNER JOIN ##SITER_CuotapartistasProcesar ON CUOTAPARTISTAS.CodCuotapartista = ##SITER_CuotapartistasProcesar.CodCuotapartista
			INNER JOIN CONDOMINIOS ON CONDOMINIOS.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
										--AND CONDOMINIOS.EstaAnulado = 0 
			INNER JOIN PERSONAS ON PERSONAS.CodPersona = CONDOMINIOS.CodPersona
									--AND PERSONAS.EstaAnulado = 0	
			LEFT JOIN PAISES P1 ON P1.CodPais = PERSONAS.CodPais
			LEFT JOIN PERSONASDOMICILIOFISCAL ON PERSONASDOMICILIOFISCAL.CodPersona = PERSONAS.CodPersona
			LEFT JOIN PAISES P2 ON P2.CodPais = PERSONASDOMICILIOFISCAL.CodPais
		WHERE EsPersonaFisica=-1 --CUOTAPARTISTAS.CodCuotapartista = @CodCuotapartista --920 --696
	
	/*Borro condominios anulados que NO se encuentren en el periodo indicado*/
	--DELETE FROM #SITER_DETALLE_CONDOMINIOS
	--WHERE #SITER_DETALLE_CONDOMINIOS.EstaAnulado = -1
	--	 AND NOT EXISTS 
	--		 (SELECT AUDITORIASHIST.CodAuditoriaRef, CONVERT(DATE, AUDITORIASHIST.Fecha, 110)
	--		 FROM AUDITORIASHIST
	--		 WHERE AUDITORIASHIST.CodAuditoriaRef = #SITER_DETALLE_CONDOMINIOS.CodAuditoriaRef
	--			   AND AUDITORIASHIST.CodAccion = 'CONDOMINIOSe'
	--			   AND CONVERT(DATE, AUDITORIASHIST.Fecha, 110) >= @FechaDesde AND CONVERT(DATE, AUDITORIASHIST.Fecha, 110) <= @FechaHasta)
	
	DELETE FROM #SITER_DETALLE_CONDOMINIOS
	WHERE #SITER_DETALLE_CONDOMINIOS.EstaAnulado = -1
		 AND EXISTS 
			 (SELECT AUDITORIASHIST.CodAuditoriaRef, CONVERT(DATE, AUDITORIASHIST.Fecha, 110)
			 FROM AUDITORIASHIST
			 WHERE AUDITORIASHIST.CodAuditoriaRef = #SITER_DETALLE_CONDOMINIOS.CodAuditoriaRef
				   AND AUDITORIASHIST.CodAccion = 'CONDOMINIOSe'
				   AND CONVERT(DATE, AUDITORIASHIST.Fecha, 110) < @FechaDesde)

	

	set @iCantidad = isnull((select count(*) from #SITER_DETALLE_CONDOMINIOS) ,0)
	set @i =1

	WHILE @i <= @iCantidad
	BEGIN
		SELECT @CodCuotapartistaSIT=#SITER_DETALLE_CONDOMINIOS.CodCuotapartista,
			   @CodPersona = #SITER_DETALLE_CONDOMINIOS.CodPersona,
			   @TieneDomicilioPrincipalExt = #SITER_DETALLE_CONDOMINIOS.TieneDomicilioPrincipalExt,
			   @TieneDomicilioFiscalExt = #SITER_DETALLE_CONDOMINIOS.TieneDomicilioFiscalExt
		FROM #SITER_DETALLE_CONDOMINIOS
		WHERE #SITER_DETALLE_CONDOMINIOS.ID = @i

		INSERT INTO #SITER_DETALLE_AUX (CodCuotapartista, CodPersona, ApellidoNombre, CodDocumento, NroDocumento, Calle, NumeroPuerta, Oficina, Sector, Torre, Manzana, Piso, Localidad, CodProvincia, CodigoPostal, 
										Residente, TpPersona, PaisOtorgDoc, LugarNacimiento, FechaNacimiento, TpEntidad, DenominacionEntidad, LugarConstitucion, FechaConstitucion,    
										DomicilioExterior, CiudadLocalidadExterior, ProvDptoEstadoExterior, PaisExterior, NroIdentTributariaPaisResidencia, 
										ResidenciaTributaria)
			SELECT @CodCuotapartistaSIT,
				   PERSONAS.CodPersona,

				   CONVERT(VARCHAR, PERSONAS.Nombre + ' ' +  PERSONAS.Apellido) As ApellidoNombre,
				   CASE WHEN NOT PERSONAS.CUIT IS NULL THEN '80'
						WHEN NOT PERSONAS.CUIL IS NULL THEN '86'
						WHEN NOT PERSONAS.CDI IS NULL THEN '87'
						WHEN PERSONAS.EsCIE = -1 THEN '88'
						ELSE '00'
				   END As CodDocumento,
				   CASE WHEN NOT PERSONAS.CUIT IS NULL THEN PERSONAS.CUIT
						WHEN NOT PERSONAS.CUIL IS NULL THEN PERSONAS.CUIL
						WHEN NOT PERSONAS.CDI IS NULL THEN PERSONAS.CDI
						WHEN PERSONAS.EsCIE = -1 THEN PERSONAS.CUIT
						ELSE '00000000000'
				   END As NroDocumento,
				   PERSONAS.Calle As Calle, 
				   PERSONAS.AlturaCalle As NumeroPuerta, 
				   ' ' As Oficina, 
				   ' ' As Sector, 
				   PERSONAS.Departamento As Torre, 
				   PERSONAS.Manzana As Manzana, 
				   PERSONAS.Piso As Piso, 
				   PERSONAS.Localidad As Localidad, 
				   LEFT(COALESCE(PROVPER.CodInterfazAFIP, ' '), 2)  As CodProvincia,
				   PERSONAS.CodigoPostal As CodigoPostal,

				   CASE WHEN ((PAPE.CodPais <> @CodPaisAplicacion AND PAPE.CodPais IS NOT NULL) OR (PADF.CodPais <> @CodPaisAplicacion AND PADF.CodPais IS NOT NULL)) THEN 0 ELSE 1 END As Residente,
				   1 As TpPersona,

				   PAPE.CodInterfazAFIP As PaisOtorgDoc,
				   PANC.CodInterfazAFIP As LugarNacimiento,
				   CASE WHEN PERSONAS.FechaNacimiento IS NULL THEN ' ' 
						--WHEN NOT PERSONAS.FechaNacimiento IS NULL AND PERSONAS.FechaNacimiento > CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),110)) THEN ' ' 
						WHEN NOT PERSONAS.FechaNacimiento IS NULL AND PERSONAS.FechaNacimiento > CONVERT(date, GETDATE()) THEN ' ' 
						ELSE CONVERT(VARCHAR, PERSONAS.FechaNacimiento, 112) /*YYYYMMDD*/
				   END As FechaNacimiento,
				   ' ' As TpEntidad,
				   ' ' As DenominacionEntidad,
				   ' ' As LugarConstitucion,
				   ' ' As FechaConstitucion,

				   CASE WHEN @TieneDomicilioPrincipalExt = -1 THEN PERSONAS.Calle + ' ' + CONVERT(VARCHAR, PERSONAS.AlturaCalle)
						WHEN @TieneDomicilioFiscalExt = -1 THEN PDF.Calle + ' ' + CONVERT(VARCHAR, PDF.AlturaCalle)
						ELSE ' ' 
				   END As DomicilioExterior,
				   CASE WHEN @TieneDomicilioPrincipalExt = -1 THEN PERSONAS.Localidad
						WHEN @TieneDomicilioFiscalExt = -1 THEN PDF.Localidad
						ELSE ' ' 
				   END As CiudadLocalidadExterior,
				   CASE WHEN @TieneDomicilioPrincipalExt = -1 THEN PROVPER.Descripcion
						WHEN @TieneDomicilioFiscalExt = -1 THEN PROVPERDOMFIS.Descripcion
						ELSE ' ' 
				   END As ProvDptoEstadoExterior,
				   
				   CASE WHEN @TieneDomicilioPrincipalExt = -1 THEN PAPE.CodInterfazAFIP
						WHEN @TieneDomicilioFiscalExt = -1 THEN PADF.CodInterfazAFIP
						ELSE ' ' 
				   END As PaisExterior,
				   
				   CASE WHEN @TieneDomicilioPrincipalExt = -1 THEN PERSONAS.NIFTIN
						WHEN @TieneDomicilioFiscalExt = -1 THEN PDF.NIFTIN
						ELSE ' '
				   END As NroIdentTributariaPaisResidencia,
				   CASE WHEN @TieneDomicilioPrincipalExt = -1 THEN PAPE.CodInterfazAFIP
						WHEN @TieneDomicilioFiscalExt = -1 THEN PADF.CodInterfazAFIP
						ELSE ' '
				   END As ResidenciaTributaria
			FROM PERSONAS 
				 LEFT JOIN (SELECT TOP 1 *
						    FROM PERSONASDOMICILIOFISCAL 
						    WHERE PERSONASDOMICILIOFISCAL.CodPais <> @CodPaisAplicacion AND PERSONASDOMICILIOFISCAL.CodPais is not null 
								  AND PERSONASDOMICILIOFISCAL.EstaAnulado = 0 
								  AND PERSONASDOMICILIOFISCAL.CodPersona = @CodPersona 
						    ORDER BY CodPersonaDomicilioFiscal) PDF ON PDF.CodPersona = PERSONAS.CodPersona
				 LEFT JOIN PAISES PAPE ON PAPE.CodPais = PERSONAS.CodPais
				 LEFT JOIN PAISES PADF ON PADF.CodPais = PDF.CodPais
				 LEFT JOIN PAISES PANC ON PANC.CodPais = PERSONAS.CodPaisNacimiento
				 LEFT JOIN PROVINCIAS PROVPER ON PROVPER.CodPais = PERSONAS.CodPais
										      AND PROVPER.CodProvincia = PERSONAS.CodProvincia
				 LEFT JOIN PROVINCIAS PROVPERDOMFIS ON PROVPERDOMFIS.CodPais = PDF.CodPais
													   AND PROVPERDOMFIS.CodProvincia = PDF.CodProvincia
			WHERE PERSONAS.CodPersona = @CodPersona


		SET @i = @i +1  --Next
	END

--END
--ELSE
--BEGIN

--PERSONAS JURIDICAS

	INSERT INTO #SITER_DETALLE_AUX (CodCuotapartista, ApellidoNombre, CodDocumento, NroDocumento, Calle, NumeroPuerta, Oficina, Sector, Torre, Manzana, Piso, Localidad, CodProvincia, CodigoPostal, 
									Residente, TpPersona, PaisOtorgDoc, LugarNacimiento, FechaNacimiento, TpEntidad, DenominacionEntidad, LugarConstitucion, FechaConstitucion, 
									DomicilioExterior, CiudadLocalidadExterior, ProvDptoEstadoExterior, PaisExterior, NroIdentTributariaPaisResidencia, 
									ResidenciaTributaria)
		SELECT CUOTAPARTISTAS.CodCuotapartista,
			   CUOTAPARTISTAS.Nombre As ApellidoNombre,
			   CASE WHEN coalesce(TPINVERSORES.EsFCI,0)=-1 THEN '91'
					WHEN NOT CPTJURIDICOS.CUIT IS NULL THEN '80'					
					ELSE '00'
			   END As CodDocumento,
			   CASE WHEN coalesce(TPINVERSORES.EsFCI,0) = -1 THEN CPTJURIDICOS.CUIT
					WHEN NOT CPTJURIDICOS.CUIT IS NULL THEN CPTJURIDICOS.CUIT					
					ELSE '00'
			   END As NroDocumento,
			   
			   CUOTAPARTISTAS.Calle As Calle,
			   CUOTAPARTISTAS.AlturaCalle AS NumeroPuerta,
			   ' ' As oficina,
			   ' ' As Sector,
			   CUOTAPARTISTAS.Departamento As Torre,
			   CUOTAPARTISTAS.Manzana As Manzana,
			   CUOTAPARTISTAS.Piso As Piso,
			   CUOTAPARTISTAS.Localidad AS Localidad,
			   PROVCPT.CodInterfazAFIP as CodProvincia,
			   CUOTAPARTISTAS.CodigoPostal As CodigoPostal,

			   CASE WHEN ((P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL) OR (P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL)) THEN 0 ELSE 1 END As Residente,
			   2 As TpPersona,
			   ' ' As PaisOtorgDoc,
			   ' ' As LugarNacimiento,
			   ' ' As FechaNacimiento,

			   CASE WHEN (P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL AND CUOTAPARTISTAS.NIFTIN IS NOT NULL AND CUOTAPARTISTAS.Calle IS NOT NULL) OR	
						 (P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL AND CPTDF.NIFTIN IS NOT NULL AND CPTDF.Calle IS NOT NULL) THEN 
							CONVERT(VARCHAR(3), TPOENTIDADSITER.CodTpoEntidadSiter)
					ELSE ' ' 
			   END As TpEntidad,
			   CASE WHEN (((P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL AND CUOTAPARTISTAS.NIFTIN IS NOT NULL AND CUOTAPARTISTAS.Calle IS NOT NULL) OR	
						 (P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL AND CPTDF.NIFTIN IS NOT NULL AND CPTDF.Calle IS NOT NULL)) AND TPOENTIDADSITER.CodTpoEntidadSiter = 99) THEN 
							CPTJURIDICOS.DenominacionEntSiter
					ELSE ' ' 
			   END As DenominacionEntidad,
			 
			   PAISESJURIDICO.CodInterfazAFIP As LugarConstitucion,
			   CASE WHEN CPTJURIDICOS.FechaConstitucion IS NULL THEN ' ' 
						--WHEN NOT CPTJURIDICOS.FechaConstitucion IS NULL AND CPTJURIDICOS.FechaConstitucion > CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),110)) THEN ' ' 
						WHEN NOT CPTJURIDICOS.FechaConstitucion IS NULL AND CPTJURIDICOS.FechaConstitucion > CONVERT(date, GETDATE()) THEN ' ' 
						ELSE CONVERT(VARCHAR, CPTJURIDICOS.FechaConstitucion, 112) /*YYYYMMDD*/
			   END As FechaConstitucion, 
			   
			   CASE WHEN P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL AND CUOTAPARTISTAS.NIFTIN IS NOT NULL AND CUOTAPARTISTAS.Calle IS NOT NULL THEN CUOTAPARTISTAS.Calle + ' ' + CONVERT(VARCHAR, CUOTAPARTISTAS.AlturaCalle)
					WHEN P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL AND CPTDF.NIFTIN IS NOT NULL AND CPTDF.Calle IS NOT NULL THEN CPTDF.Calle + ' ' + CONVERT(VARCHAR, CPTDF.AlturaCalle)
					ELSE ' ' 
			   END As DomicilioExterior,
			   CASE WHEN P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL AND CUOTAPARTISTAS.NIFTIN IS NOT NULL AND CUOTAPARTISTAS.Calle IS NOT NULL THEN CUOTAPARTISTAS.Localidad
					WHEN P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL AND CPTDF.NIFTIN IS NOT NULL AND CPTDF.Calle IS NOT NULL THEN CPTDF.Localidad
					ELSE ' ' 
			   END As CiudadLocalidadExterior,
			   CASE WHEN P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL AND CUOTAPARTISTAS.NIFTIN IS NOT NULL AND CUOTAPARTISTAS.Calle IS NOT NULL THEN PROVCPT.Descripcion
					WHEN P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL AND CPTDF.NIFTIN IS NOT NULL AND CPTDF.Calle IS NOT NULL THEN PROVCPTDOMFIS.Descripcion
					ELSE ' ' 
			   END As ProvDptoEstadoExterior,
			   CASE WHEN P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL AND CUOTAPARTISTAS.NIFTIN IS NOT NULL AND CUOTAPARTISTAS.Calle IS NOT NULL THEN P1.CodInterfazAFIP
					WHEN P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL AND CPTDF.NIFTIN IS NOT NULL AND CPTDF.Calle IS NOT NULL THEN P2.CodInterfazAFIP
					ELSE '' 
			   END As PaisExterior,
			   CASE WHEN (P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL AND CUOTAPARTISTAS.NIFTIN IS NOT NULL AND CUOTAPARTISTAS.Calle IS NOT NULL) THEN CUOTAPARTISTAS.NIFTIN
					WHEN (P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL AND CPTDF.NIFTIN IS NOT NULL AND CPTDF.Calle IS NOT NULL) THEN CPTDF.NIFTIN
					ELSE ' ' 
			   END As NroIdentTributariaPaisResidencia,
			   CASE WHEN (P1.CodPais <> @CodPaisAplicacion AND P1.CodPais IS NOT NULL AND CUOTAPARTISTAS.NIFTIN IS NOT NULL AND CUOTAPARTISTAS.Calle IS NOT NULL) THEN P1.CodInterfazAFIP
					WHEN (P2.CodPais <> @CodPaisAplicacion AND P2.CodPais IS NOT NULL AND CPTDF.NIFTIN IS NOT NULL AND CPTDF.Calle IS NOT NULL) THEN P2.CodInterfazAFIP
					ELSE ' '
			   END As ResidenciaTributaria
		FROM CUOTAPARTISTAS  
			INNER JOIN ##SITER_CuotapartistasProcesar ON CUOTAPARTISTAS.CodCuotapartista = ##SITER_CuotapartistasProcesar.CodCuotapartista
			 INNER JOIN CPTJURIDICOS ON CPTJURIDICOS.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
			 LEFT JOIN TPOENTIDADSITER ON TPOENTIDADSITER.CodTpoEntidadSiter = CPTJURIDICOS.CodTpoEntidadSiter
			 LEFT JOIN PAISES PAISESJURIDICO ON PAISESJURIDICO.CodPais = CPTJURIDICOS.CodPaisNacionalidad
			 LEFT JOIN TPINVERSORES ON TPINVERSORES.CodTpInversor = CUOTAPARTISTAS.CodTpInversor
			 LEFT JOIN PAISES P1 ON (P1.CodPais = CUOTAPARTISTAS.CodPais)
			 LEFT JOIN (SELECT TOP 1 * 
						FROM CUOTAPARTISTASDOMICILIOFISCAL 
						WHERE CUOTAPARTISTASDOMICILIOFISCAL.CodPais <> @CodPaisAplicacion AND CUOTAPARTISTASDOMICILIOFISCAL.CodPais IS NOT NULL
						--AND CUOTAPARTISTASDOMICILIOFISCAL.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista 
						AND CUOTAPARTISTASDOMICILIOFISCAL.EstaAnulado = 0
						ORDER BY CodCuotapartistaDomicilioFiscal) CPTDF ON (CUOTAPARTISTAS.CodCuotapartista = CPTDF.CodCuotapartista)
			 LEFT JOIN PAISES P2 ON (P2.CodPais = CPTDF.CodPais)
			 LEFT JOIN PROVINCIAS PROVCPT ON PROVCPT.CodPais = CUOTAPARTISTAS.CodProvincia
										      AND PROVCPT.CodProvincia = CUOTAPARTISTAS.CodProvincia
			 LEFT JOIN PROVINCIAS PROVCPTDOMFIS ON PROVCPTDOMFIS.CodPais = CPTDF.CodPais
											    AND PROVCPTDOMFIS.CodProvincia = CPTDF.CodProvincia
		WHERE CUOTAPARTISTAS.EsPersonaFisica=0
		--	 AND CUOTAPARTISTAS.CodCuotapartista = @CodCuotapartista
			 
			 

		
	/*Actualizo datos comunes del cuotapartista*/
	UPDATE #SITER_DETALLE_AUX
	SET #SITER_DETALLE_AUX.NumCuotapartista = LEFT(CUOTAPARTISTAS.NumCuotapartista,11)
	FROM #SITER_DETALLE_AUX 
		 inner join CUOTAPARTISTAS ON #SITER_DETALLE_AUX.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista		

	----	/*Resultado formateado*/
	--	SELECT '05' As TpRegistro,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',100,#SITER_DETALLE_AUX.ApellidoNombre) As ApellidoNombre,
	--			dbo.fnFormatoIntefazAFIP('NUMERICO',2,#SITER_DETALLE_AUX.CodDocumento) As CodDocumento,
	--			dbo.fnFormatoIntefazAFIP('NUMERICO',11,#SITER_DETALLE_AUX.NroDocumento) As NumDocumento,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',30,#SITER_DETALLE_AUX.Calle) As Calle,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',6,#SITER_DETALLE_AUX.NumeroPuerta) As NumeroPuerta,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5,#SITER_DETALLE_AUX.Oficina) As Oficina,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5,#SITER_DETALLE_AUX.Sector) As Sector,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5,#SITER_DETALLE_AUX.Torre) As Torre,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5,#SITER_DETALLE_AUX.Manzana) As Manzana,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5,#SITER_DETALLE_AUX.Piso) As Piso,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',60,#SITER_DETALLE_AUX.Localidad) As Localidad,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',2,#SITER_DETALLE_AUX.CodProvincia) As CodProvincia,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',10,#SITER_DETALLE_AUX.CodigoPostal) As CodigoPostal,
	--			dbo.fnFormatoIntefazAFIP('NUMERICO',11,#SITER_DETALLE_AUX.NumCuotapartista) As NumCuotapartista,
	--			dbo.fnFormatoIntefazAFIP('NUMERICO',1,#SITER_DETALLE_AUX.Residente) As Residente,
	--			dbo.fnFormatoIntefazAFIP('NUMERICO',1,#SITER_DETALLE_AUX.TpPersona) As TpPersona,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3,#SITER_DETALLE_AUX.PaisOtorgDoc) As PaisOtorgDoc,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3,#SITER_DETALLE_AUX.LugarNacimiento) As LugarNacimiento,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',8,#SITER_DETALLE_AUX.FechaNacimiento) As FechaNacimiento,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',2,#SITER_DETALLE_AUX.TpEntidad) As TpEntidad,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',20,#SITER_DETALLE_AUX.DenominacionEntidad) As DenominacionEntidad,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3,#SITER_DETALLE_AUX.LugarConstitucion) As LugarConstitucion,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',8,#SITER_DETALLE_AUX.FechaConstitucion) As FechaConstitucion,
	--			--#SITER_DETALLE_AUX.CodPersona,
	--			--PERSONAS.Nombre,
	--			--PERSONAS.CodAuditoriaRef,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',30,#SITER_DETALLE_AUX.DomicilioExterior) As DomicilioExterior,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',30,#SITER_DETALLE_AUX.CiudadLocalidadExterior) As CiudadLocalidadExterior,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',30,#SITER_DETALLE_AUX.ProvDptoEstadoExterior) As ProvDptoEstadoExterior,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3,#SITER_DETALLE_AUX.PaisExterior) As PaisExterior,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',20,#SITER_DETALLE_AUX.NroIdentTributariaPaisResidencia) As NroIdentTributariaPaisResidencia,
	--			dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3,#SITER_DETALLE_AUX.ResidenciaTributaria) As ResidenciaTributaria
		
	--	FROM #SITER_DETALLE_AUX
	--		 LEFT JOIN PERSONAS ON PERSONAS.CodPersona = #SITER_DETALLE_AUX.CodPersona 
	--	WHERE #SITER_DETALLE_AUX.CodCuotapartista = @CodCuotapartista

	--	/*resultados en una linea*/
		SELECT '05' +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',100,#SITER_DETALLE_AUX.ApellidoNombre) +
				dbo.fnFormatoIntefazAFIP('NUMERICO',2,#SITER_DETALLE_AUX.CodDocumento) +
				dbo.fnFormatoIntefazAFIP('NUMERICO',11,#SITER_DETALLE_AUX.NroDocumento) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',30, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.Calle END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',6, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.NumeroPuerta END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.Oficina END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.Sector END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.Torre END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.Manzana END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',5, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.Piso END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',60, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.Localidad END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',2, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.CodProvincia END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',10, CASE WHEN (#SITER_DETALLE_AUX.Residente = 0) THEN '' ELSE #SITER_DETALLE_AUX.CodigoPostal END) +
				dbo.fnFormatoIntefazAFIP('NUMERICO',11,#SITER_DETALLE_AUX.NumCuotapartista) +
				dbo.fnFormatoIntefazAFIP('NUMERICO',1,#SITER_DETALLE_AUX.Residente) +
				dbo.fnFormatoIntefazAFIP('NUMERICO',1,#SITER_DETALLE_AUX.TpPersona) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3, CASE WHEN (#SITER_DETALLE_AUX.Residente = 1) THEN '' ELSE #SITER_DETALLE_AUX.PaisOtorgDoc END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3, CASE WHEN (#SITER_DETALLE_AUX.Residente = 1) THEN '' ELSE #SITER_DETALLE_AUX.LugarNacimiento END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',8, CASE WHEN (#SITER_DETALLE_AUX.Residente = 1) THEN '' ELSE #SITER_DETALLE_AUX.FechaNacimiento END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',2,#SITER_DETALLE_AUX.TpEntidad) +
				--dbo.fnFormatoIntefazAFIP('ALFANUMERICO',20,#SITER_DETALLE_AUX.DenominacionEntidad) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3, CASE WHEN (#SITER_DETALLE_AUX.Residente = 1) THEN '' ELSE #SITER_DETALLE_AUX.LugarConstitucion END) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',8, CASE WHEN (#SITER_DETALLE_AUX.Residente = 1) THEN '' ELSE #SITER_DETALLE_AUX.FechaConstitucion END) +
				--#SITER_DETALLE_AUX.CodPersona,
				--PERSONAS.Nombre,
				--PERSONAS.CodAuditoriaRef,
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',50,#SITER_DETALLE_AUX.DomicilioExterior) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',30,#SITER_DETALLE_AUX.CiudadLocalidadExterior) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',30,#SITER_DETALLE_AUX.ProvDptoEstadoExterior) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3,#SITER_DETALLE_AUX.PaisExterior) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',20,#SITER_DETALLE_AUX.NroIdentTributariaPaisResidencia) +
				dbo.fnFormatoIntefazAFIP('ALFANUMERICO',3,#SITER_DETALLE_AUX.ResidenciaTributaria) As Registros
			
		FROM #SITER_DETALLE_AUX
			INNER JOIN ##SITER_CuotapartistasProcesar ON #SITER_DETALLE_AUX.CodCuotapartista = ##SITER_CuotapartistasProcesar.CodCuotapartista

			 LEFT JOIN PERSONAS ON PERSONAS.CodPersona = #SITER_DETALLE_AUX.CodPersona 
	
GO


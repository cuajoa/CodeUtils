-- ##SCRIPT##: 00vwCUOTAPARTISTASDOMICILIOFISCALMIN.sql
EXEC sp_CreateView 'dbo.vwCUOTAPARTISTASDOMICILIOFISCALMIN'
GO

ALTER VIEW dbo.vwCUOTAPARTISTASDOMICILIOFISCALMIN
WITH ENCRYPTION
AS
	SELECT CodCuotapartista, MIN(CodCuotapartistaDomicilioFiscal) as CodCuotapartistaDomicilioFiscal
	FROM CUOTAPARTISTASDOMICILIOFISCAL 
	GROUP BY CodCuotapartista

GO

-- ##SCRIPT##: dfxACuotapartistas.sql
-- 71 Cuotapartistas
SET NOCOUNT ON

DECLARE @CodEntidad CodigoMedio
SELECT @CodEntidad = 71

declare @CodModoSistema	CodigoCorto

select @CodModoSistema =  CodModoSistema from PARAMETROSREL

EXEC sp_dfxCREARTEMPORALES @CodEntidad 

-- dfxENTCOLUMNAS -----------------------------------------------------

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
                 VALUES (@CodEntidad, 'FMT_GRILLA', 'Grilla de', 25, 'CR', '''Cuotapartistas''', 0, 0, 'FMT_GRILLA', NULL)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
                 VALUES (@CodEntidad, 'CodCuotapartista', '##CODIGOCUOTAPARTISTA##', NULL, 'PK', 'CUOTAPARTISTAS.CodCuotapartista', 0, 0, NULL, 'L')
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
                 VALUES (@CodEntidad, 'CR_CodOficialCta', '##OFICIALCUENTA##', NULL, 'CR', 'OFICIALESCTA.CodOficialCta', 0, 0, NULL, 'L')
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
                 VALUES (@CodEntidad, 'CR_CodSucursalOfCta', '##SUCURSALACARGO##', NULL, 'CR', 'CUOTAPARTISTAS.CodSucursalOfCta', 0, 0, NULL, 'L')
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
                 VALUES (@CodEntidad, 'CR_CodSucursalOrigen', '##SUCURSALORIGEN##', NULL, 'CR', 'CUOTAPARTISTAS.CodSucursal', 0, 0, NULL, 'L')

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
                VALUES (@CodEntidad, 'NumCuotapartista', '##IDENTIFICADORCPT##', NULL, NULL, 'CUOTAPARTISTAS.NumCuotapartista', -1, 0, NULL, 'L', 1, -1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					VALUES (@CodEntidad, 'Nombre', '##NOMBRE##', NULL, NULL, 'CUOTAPARTISTAS.Nombre', -1, 0, NULL, 'L', 1, -1, -1)

DECLARE @Domicilio DescripcionLarga

IF @CodModoSistema <> 3
	set @Domicilio = ''
ELSE
	set @Domicilio = '##DOMICILIOENVIOINFORMACION##//'

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'Calle', @Domicilio + '##CALLE##', NULL, NULL, 'CUOTAPARTISTAS.Calle', -1, 0, 'Calle', 'L', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'AlturaCalle', @Domicilio + '##ALTURACALLE##', NULL, NULL, 'CUOTAPARTISTAS.AlturaCalle', -1, 0, NULL, 'L', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'Localidad', @Domicilio + '##LOCALIDAD##', NULL, NULL, 'CUOTAPARTISTAS.Localidad', -1, 0, NULL, 'L', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'CodigoPostal',  @Domicilio + '##CODIGOPOSTAL##', NULL, NULL, 'CUOTAPARTISTAS.CodigoPostal', -1, 0, 'CodigoPostal', 'L', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'Fax', @Domicilio + '##FAX##', NULL, NULL, 'CUOTAPARTISTAS.Fax', -1, 0, NULL, 'L', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'Departamento', @Domicilio + '##DEPARTAMENTO##', NULL, NULL, 'CUOTAPARTISTAS.Departamento', -1, 0, NULL, 'L', 1, -1)

IF @CodModoSistema = 3
BEGIN

	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
		VALUES (@CodEntidad, 'UnidadVecinal', @Domicilio + '##UNIDADVECINAL##', NULL, NULL, 'CUOTAPARTISTAS.UnidadVecinal', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
		VALUES (@CodEntidad, 'Residencia', @Domicilio + '##RESIDENCIA##', NULL, NULL, 'CUOTAPARTISTAS.Residencia', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
		VALUES (@CodEntidad, 'Urbanizacion', @Domicilio + '##URBANIZACION##', NULL, NULL, 'CUOTAPARTISTAS.Urbanizacion', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
		VALUES (@CodEntidad, 'Manzana', @Domicilio + '##MANZANA##', NULL, NULL, 'CUOTAPARTISTAS.Manzana', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
		VALUES (@CodEntidad, 'Lote', @Domicilio + '##LOTE##', NULL, NULL, 'CUOTAPARTISTAS.Lote', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple, FltEsFavorito)
		VALUES (@CodEntidad, 'Pais', @Domicilio + '##PAIS##', NULL, NULL, 'PAISES.Descripcion', -1, 0, 'Pais', 'L', 1, 13, -1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito, FltCodTpActiveX)
					 VALUES (@CodEntidad, 'Provincia', @Domicilio + '##PROVINCIA##', NULL, NULL, 'PROVINCIAS.Descripcion', -1, 0, 'Provincia', 'L', 1, -1, -1,29)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Piso', @Domicilio + '##PISO##', NULL, NULL, 'CUOTAPARTISTAS.Piso', -1, 0, NULL, 'L', 1, -1)		
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Telefono', @Domicilio + '##TELEFONO##', NULL, NULL, 'CUOTAPARTISTAS.Telefono', -1, 0, NULL, 'L', 1, -1)
		
END

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'CodAuditoriaRef', '##CODIGOAUDITORIA##', NULL, NULL, 'CUOTAPARTISTAS.CodAuditoriaRef', -1, 0, NULL, 'L', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
	VALUES (@CodEntidad, 'EstaAnulado', '##ANULADO##', NULL, 'AN', 'CUOTAPARTISTAS.EstaAnulado', -1, 0, 'EstaAnulado', 'L', 1, 0, -1)


INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple, FltEsFavorito)
	VALUES (@CodEntidad, 'AgColocador', '##ACARGO##//##AGENTECOLOCADOR##', NULL, NULL, 'AGCOLOCADORES.Descripcion', -1, 0, 'AgColocador', 'L', 1, 3, -1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
	VALUES (@CodEntidad, 'OfCta', '##ACARGO##//##OFICIALCUENTA##//##NOMBRE##', 23, NULL, 'OFICIALESCTA.Apellido + '', '' + OFICIALESCTA.Nombre', -1, 0, 'CR_CodOficialCta', 'L', 1, -1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
	VALUES (@CodEntidad, 'OfCtaNum', '##ACARGO##//##OFICIALCUENTA##//##NUMERO##', NULL, NULL, 'OFICIALESCTA.NumOficialCta', -1, 0, 'CR_CodOficialCta', 'L', 1, -1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
	VALUES (@CodEntidad, 'Sucursal', '##ACARGO##//##SUCURSAL##', NULL, NULL, 'SUCURSALES.Descripcion', -1, 0, 'CR_CodSucursalOfCta', 'L', 1, -1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
	VALUES (@CodEntidad, 'ACargoSucZona', '##ACARGO##//##SUCURSAL##//##ZONA##', NULL, NULL, 'ZONAS.Descripcion', -1, 0, 'ACargoSucZona', 'L', 1, -1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple, FltEsFavorito)
	VALUES (@CodEntidad, 'CanVta', '##CANALVENTA##', NULL, NULL, 'CANALESVTA.Descripcion', -1, 0, 'CanVta', 'L', 1, 46, -1, -1)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'Email', '##EMAIL##', NULL, NULL, 'CUOTAPARTISTAS.EMail', -1, 0, NULL, 'L', 1, -1)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'CR_AreaPertenencia', '##AREAPERTENENCIA##', NULL, 'CR', 'AREASPERTENENCIA.CodAreaPertenencia', -1, 0, NULL, 'L', 1, -1)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'AreaPertenenciaInterfaz', '##AREAPERTENENCIA##//##CODIGOINTERFAZ##', NULL, NULL, 'AREASPERTENENCIA.CodInterfaz', -1, 0, 'CR_AreaPertenencia', 'L', 1, -1)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple)
	VALUES (@CodEntidad, 'AreaPertenencia', '##AREAPERTENENCIA##//##DESCRIPCION##', NULL, NULL, 'AREASPERTENENCIA.Descripcion', -1, 0, 'CR_AreaPertenencia', 'L', 1, 109, -1)


INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'CR_CodCentroFisico', '##CENTROFISICO##', NULL, 'CR', 'CENTROSFISICOS.CodCentroFisico', -1, 0, NULL, 'L', 1, -1)

	

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'CentroFisicoInterfaz', '##CENTROFISICO##//##CODIGOINTERFAZ##', NULL, NULL, 'CENTROSFISICOS.CodInterfaz', -1, 0, 'CR_CodCentroFisico', 'L', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple, FltEsFavorito)
	VALUES (@CodEntidad, 'CentroFisico', '##CENTROFISICO##//##DESCRIPCION##', NULL, NULL, 'CENTROSFISICOS.Descripcion', -1, 0, 'CR_CodCentroFisico', 'L', 1, 108, -1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
	VALUES (@CodEntidad, 'CodInterfaz', '##CODIGOINTERFAZ##', NULL, NULL, 'CUOTAPARTISTAS.CodInterfaz', -1, 0, NULL, 'L', 1, -1, -1)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
	VALUES (@CodEntidad, 'FechaIngreso', '##FECHAINGRESO##', NULL, NULL, 'CUOTAPARTISTAS.FechaIngreso', -1, 0, 'FechaIngreso', 'C', 1, -1)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple, FltEsFavorito)
				 VALUES (@CodEntidad, 'Cat', '##CATEGORIA##', NULL, NULL, 'CATEGORIAS.Descripcion', -1, 0, 'Cat', 'L', 1, 37, -1, -1)

IF @CodModoSistema <> 3
BEGIN
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Constitucion', '##CONSTITUCION##', NULL, NULL, 'CPTJURIDICOS.LugarConstitucion', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'CUIT', '##CUIT##', NULL, NULL, 'CPTJURIDICOS.CUIT', -1, 0, NULL, 'L', 1, -1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
					 VALUES (@CodEntidad, 'Domicilio', '##DOMICILIO##', 23, NULL, 'COALESCE(CUOTAPARTISTAS.Calle + '' '','''') + COALESCE( CUOTAPARTISTAS.AlturaCalle + '' '','''')', -1, 0, NULL, 'L')

	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
                 VALUES (@CodEntidad, 'Escritura', '##ESCRITURA##', NULL, NULL, 'CPTJURIDICOS.Escritura', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
                 VALUES (@CodEntidad, 'FechaConstitucion', '##FECHACONSTITUCION##', NULL, NULL, 'CPTJURIDICOS.FechaConstitucion', -1, 0, NULL, 'C', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Folio', '##FOLIO##', NULL, NULL, 'CPTJURIDICOS.Folio', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'NumInscripcion', '##INSCRIPCION##', NULL, NULL, 'CPTJURIDICOS.NumInscripcion', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Libro', '##LIBRO##', NULL, NULL, 'CPTJURIDICOS.Libro', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'NumAseguradora', '##NUMEROASEGURADORA##', NULL, NULL, 'CUOTAPARTISTAS.NumAseguradora', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'NumCustodia', '##NUMEROCUSTODIA##', NULL, NULL, 'CUOTAPARTISTAS.NumCustodia', -1, 0, NULL, 'L', 1, -1)


	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'CptJuridFactEstim', '##FACTURACIONMENSUAL##//##MONTO##', 34, NULL, 'CPTJURIDICOS.FacturacionEstim', -1, 0, NULL, 'R', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltCodTpActiveX)
					 VALUES (@CodEntidad, 'CptJuridCodMonFactDesc', '##FACTURACIONMENSUAL##//##MONEDA##//##DESCRIPCION##', 25, NULL, 'MONFACT.Descripcion', -1, 0, NULL, 'L', 1, -1, 9)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'CptJuridCodMonFactSim', '##FACTURACIONMENSUAL##//##MONEDA##//##SIMBOLO##', 18, NULL, 'MONFACT.Simbolo', -1, 0, NULL, 'L', 1, -1)

	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'CptJuridPatEstim', '##PATRIMONIO##//##MONTO##', 34, NULL, 'CPTJURIDICOS.PatrimonioEstim', -1, 0, NULL, 'R', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltCodTpActiveX)
					 VALUES (@CodEntidad, 'CptJuridCodMonPatDesc', '##PATRIMONIO##//##MONEDA##//##DESCRIPCION##', 25, NULL, 'MONPATRIM.Descripcion', -1, 0, NULL, 'L', 1, -1, 9)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'CptJuridCodMonPatSim', '##PATRIMONIO##//##MONEDA##//##SIMBOLO##', 18, NULL, 'MONPATRIM.Simbolo', -1, 0, NULL, 'L', 1, -1)

END


INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
                 VALUES (@CodEntidad, 'ImpResumenCta', '##IMPRIMERESUMENCUENTA##', NULL, NULL, 'CUOTAPARTISTAS.ImpResumenCta', -1, 0, 'ImpResumenCta', 'L', 1, 0)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
				 VALUES (@CodEntidad, 'PersonaFisica', '##PERSONAFISICA##', NULL, NULL, 'CUOTAPARTISTAS.EsPersonaFisica', -1, 0, 'PersonaFisica', 'L', 1, 0, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'SegmentoInv', '##SEGMENTOINVERSION##', NULL, NULL, 'SEGMENTOSINV.Descripcion', -1, 0, 'SegmentoInv', 'L', 1, 44, -1, -1)

---
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
                 VALUES (@CodEntidad, 'CptJuridMontoEstim', '##ACTESPERADACTA##//##MONTO##', 34, NULL, 'CPTUIF.ImporteEstim', -1, 0, NULL, 'R', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
                 VALUES (@CodEntidad, 'CptJuridCodMonMontoDesc', '##ACTESPERADACTA##//##MONEDA##//##DESCRIPCION##', 25, NULL, 'MONMONTO.Descripcion', -1, 0, NULL, 'L', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
                 VALUES (@CodEntidad, 'CptJuridCodMonMontoSim', '##ACTESPERADACTA##//##MONEDA##//##SIMBOLO##', 18, NULL, 'MONMONTO.Simbolo', -1, 0, NULL, 'L', 1, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
                 VALUES (@CodEntidad, 'CptUIFEstimOpe', '##IMPORTEMAXSOLICITUD##', 34, NULL, 'CPTUIF.ImporteMaxOper', -1, 0, NULL, 'R', NULL, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
                 VALUES (@CodEntidad, 'CptUIFEstimAnual', '##MONTOESTIMADOOPERACIONES##', 34, NULL, 'CPTUIF.ImporteEstimAnual', -1, 0, NULL, 'R', NULL, -1)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
                 VALUES (@CodEntidad, 'FechaInicioOper', '##FECHAVIGENCIAIMPORTEOPE##', NULL, NULL, 'CPTUIF.FechaInicioOper', -1, 0, NULL, 'C')
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
                 VALUES (@CodEntidad, 'FechaInicioEstimAnual', '##FECHAVIGENCIAIMPORTEANUAL##', NULL, NULL, 'CPTUIF.FechaInicioEstimAnual', -1, 0, NULL, 'C')
---

if @CodModoSistema <> 3
Begin

	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'CptJuridCodTpCaracter', '##TPCARACTER##//##INTERFAZAFIP##', 62, NULL, 'TPCARACTER.CodInterfazAFIP', -1, 0, NULL, 'C', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltCodTpActiveX)
					 VALUES (@CodEntidad, 'CptJuridDescTpCaracter', '##TPCARACTER##//##DESCRIPCION##', 25, NULL, 'TPCARACTER.Descripcion', -1, 0, NULL, 'L', 1, 0, 319)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'CptJuridCodTpPersJurid', '##TIPOENTIDAD##//##INTERFAZAFIP##', 62, NULL, 'TPPERSONASJURIDICAS.CodInterfazAFIP', -1, 0, NULL, 'C', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltCodTpActiveX)
					 VALUES (@CodEntidad, 'CptJuridDescTpPersJurid', '##TIPOENTIDAD##//##DESCRIPCION##', 25, NULL, 'TPPERSONASJURIDICAS.Descripcion', -1, 0, NULL, 'L', 1, 0, 320)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Nacionalidad', '##NACIONALIDAD##', 25, NULL, 'PAISCPTJURIDICO.Descripcion', -1, 0, 'Nacionalidad', 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'NivelSeguridad', '##NIVELSEGURIDAD##', NULL, NULL, 'CUOTAPARTISTAS.NivelSeguridad', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'AgColocadorOrigen', '##ORIGEN##//##AGENTECOLOCADOR##', 65, NULL, 'AGCOLORIGEN.Descripcion', -1, 0, 'AgColocadorOrigen', 'L', 1, 3, -1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'SucursalOrigen', '##ORIGEN##//##SUCURSAL##', 25, NULL, 'SUCORIGEN.Descripcion', -1, 0, 'CR_CodSucursalOrigen', 'L', 1, -1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'OrigenSucZona', '##ORIGEN##//##SUCURSAL##//##ZONA##', 25, NULL, 'ZONAORIGEN.Descripcion', -1, 0, 'OrigenSucZona', 'L', 1, -1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'Pais', '##PAIS##', NULL, NULL, 'PAISES.Descripcion', -1, 0, 'Pais', 'L', 1, 13, -1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Perfil', '##PERFIL##', NULL, NULL, 'CUOTAPARTISTAS.Perfil', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Piso', '##PISO##', NULL, NULL, 'CUOTAPARTISTAS.Piso', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito, FltCodTpActiveX)
					 VALUES (@CodEntidad, 'Provincia', '##PROVINCIA##', NULL, NULL, 'PROVINCIAS.Descripcion', -1, 0, 'Provincia', 'L', 1, -1, -1,29)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltCodTpActiveX, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'Referente', '##REFERENTE##', NULL, NULL, 'REFERENTES.Descripcion', -1, 0, 'Referente', 'L', 1, 43, -1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Telefono', '##TELEFONO##', NULL, NULL, 'CUOTAPARTISTAS.Telefono', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'TpContribuyente', '##TIPOCONTRIBUYENTE##', NULL, NULL, 'TPCONTRIBUYENTE.Descripcion', -1, 0, 'TpContribuyente', 'L', 1, -1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'Tomo', '##TOMO##', NULL, NULL, 'CPTJURIDICOS.Tomo', -1, 0, NULL, 'L', 1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltCodTpActiveX, FltEsFavorito)
					 VALUES (@CodEntidad, 'SectorInv', '##SECTORINVERSION##', NULL, NULL, 'SECTORESINV.Descripcion', -1, 0, 'SectorInv', 'L', 1, -1, 166, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltCodTpActiveX, FltEsFavorito)
					 VALUES (@CodEntidad, 'PerfilRiesgo', '##PERFILRIESGO##', NULL, NULL, 'TPPERFILRIESGOCPT.Descripcion', -1, 0, 'PerfilRiesgo', 'L', 1, -1, 270, 0)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
                 VALUES (@CodEntidad, 'Observaciones', '##OBSERVACIONES##', 48, NULL, 'REPLACE(CUOTAPARTISTAS.Observaciones, CHAR(13) + CHAR(10),'' '')', -1, 0, 'Observaciones', 'L')

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltEsFavorito)
                 VALUES (@CodEntidad, 'PoseeInstrPagoPerm', '##POSEEINSTRUCCIONPAGORESCATE##', NULL, NULL, 'CUOTAPARTISTAS.PoseeInstrPagoPerm', -1, 0, 'PoseeInstrPagoPerm', 'C', 1, 0)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
                 VALUES (@CodEntidad, 'CodInterfazAdicional', '##CODIGOINTERFAZADICIONAL##', NULL, NULL, 'CUOTAPARTISTAS.CodInterfazAdicional', -1, 0, NULL, 'L', 1, -1, 0)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
                 VALUES (@CodEntidad, 'CodInterfazBanco', '##CODIGOINTERFAZBANCO##', NULL, NULL, 'CUOTAPARTISTAS.CodInterfazBanco', -1, 0, NULL, 'L', 1, -1, 0)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltEsFavorito)
                 VALUES (@CodEntidad, 'SincronizaCOBIS', '##SINCRONIZADENOMINACION##', NULL, NULL, 'CUOTAPARTISTAS.SincronizaCOBIS', -1, 0, 'SincronizaCOBIS', 'C', 1, 0)

INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
                 VALUES (@CodEntidad, 'CodigoIdTributaria', '##CODIGOIDTRIBUTARIA##', NULL, NULL, 'CPTJURIDICOS.CodigoIdTributaria', -1, 0, NULL, 'L', 1, -1, 0)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
                 VALUES (@CodEntidad, 'GIIN', '##GIIN##', NULL, NULL, 'CPTJURIDICOS.GIIN', -1, 0, NULL, 'L', 1, -1, 0)
INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito, FltCodTpActiveX)
                 VALUES (@CodEntidad, 'StatusFATCA', '##STATUSFATCATXT##', 25, NULL, 'STATUSFATCA.Descripcion', -1, 0, 'StatusFATCA', 'L', 1, -1, 0, 335)
end

IF @CodModoSistema = 1
BEGIN
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito, FltCodTpActiveX)
					 VALUES (@CodEntidad, 'StatusOCDE', '##STATUSOCDE##', 25, NULL, 'STATUSOCDE.Descripcion', -1, 0, 'StatusOCDE', 'L', 1, -1, 0, 375)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltEsFavorito, FltPermiteMultiple)
					 VALUES (@CodEntidad, 'CIE', '##CIE##', NULL, NULL, 'CPTJURIDICOS.CIE', -1, 0, NULL, 'L', 1, -1, -1)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito, FltCodTpActiveX)
					 VALUES (@CodEntidad, 'TpoEntidad', '##TPOENTIDAD##', 25, NULL, 'COALESCE(TPOENTIDAD.Descripcion,''(Sin Datos)'')', -1, 0, 'TpoEntidad', 'L', 1, -1, 0, 376)
END

if @CodModoSistema <> 3
begin
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltCodTpActiveX)
		            VALUES (@CodEntidad, 'CodTpInversor', '##TPINVERSOR##', NULL, NULL, 'TPINVERSORES.Descripcion', -1, 0, 'CodTpInversor', 'L', 1, -1, 316)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'CalleFiscal', '##DOMICILIOFISCAL##//##CALLE##', NULL, NULL, 'CUOTAPARTISTASDOMICILIOFISCAL.Calle', -1, 0, NULL, 'L', 1, -1, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'AlturaCalleFiscal', '##DOMICILIOFISCAL##//##ALTURACALLE##', NULL, NULL, 'CUOTAPARTISTASDOMICILIOFISCAL.AlturaCalle', -1, 0, NULL, 'L', 1, -1, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'PisoFiscal', '##DOMICILIOFISCAL##//##PISO##', NULL, NULL, 'CUOTAPARTISTASDOMICILIOFISCAL.Piso', -1, 0, NULL, 'L', 1, -1, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'DepartamentoFiscal', '##DOMICILIOFISCAL##//##DEPARTAMENTO##', NULL, NULL, 'CUOTAPARTISTASDOMICILIOFISCAL.Departamento', -1, 0, NULL, 'L', 1, -1, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'CodigoPostalFiscal', '##DOMICILIOFISCAL##//##CODIGOPOSTAL##', NULL, NULL, 'CUOTAPARTISTASDOMICILIOFISCAL.CodigoPostal', -1, 0, NULL, 'L', 1, -1, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'LocalidadFiscal', '##DOMICILIOFISCAL##//##LOCALIDAD##', NULL, NULL, 'CUOTAPARTISTASDOMICILIOFISCAL.Localidad', -1, 0, NULL, 'L', 1, -1, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'TelefonoFiscal', '##DOMICILIOFISCAL##//##TELEFONO##', NULL, NULL, 'CUOTAPARTISTASDOMICILIOFISCAL.Telefono', -1, 0, NULL, 'L', 1, -1, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'FaxFiscal', '##DOMICILIOFISCAL##//##FAX##', NULL, NULL, 'CUOTAPARTISTASDOMICILIOFISCAL.Fax', -1, 0, NULL, 'L', 1, -1, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'CodProvinciaFiscal', '##DOMICILIOFISCAL##//##PROVINCIA##', 25, NULL, 'PROVINCIAFISCAL.Descripcion', -1, 0, NULL, 'L', 1, -1, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito, FltCodTpActiveX )
					 VALUES (@CodEntidad, 'CodPaisFiscal', '##DOMICILIOFISCAL##//##PAIS##', 25, NULL, 'PAISFISCAL.Descripcion', -1, 0, NULL, 'L', 1, -1, 0, 13)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
					 VALUES (@CodEntidad, 'EsSujetoObligado', '##SUJETOOBLIGADO##', NULL, NULL, 'CPTJURIDICOS.EsSujetoObligado', -1, 0, 'EsSujetoObligado', 'C', 1, 0, 0)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito,FltCodTpActiveX)
					 VALUES (@CodEntidad, 'CodTpRecepEstCta', '##TPRECEPCIONESTADOCTA##', NULL, NULL, 'CUOTAPARTISTAS.CodTpRecepEstCta', -1, 0, 'CodTpRecepEstCta', 'L', 1, 0, 0, 362)
end

if @CodModoSistema = 3
Begin
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion)
						VALUES (@CodEntidad, 'CodTpTitularidad', '##TPTITULARIDAD##', NULL, 'CR', 'CUOTAPARTISTAS.CodTpTitularidad', -1, 0, 'CodTpTitularidad', 'L')
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltEsFavorito,FltCodTpActiveX)
						VALUES (@CodEntidad, 'TpTitularidad', '##TPTITULARIDAD##', NULL, NULL, 'TPTITULARIDAD.Descripcion', -1, 0, 'CodTpTitularidad', 'L', 1, 0, 361)
	INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltEsFavorito,FltCodTpActiveX)
						VALUES (@CodEntidad, 'TpRecepcionEstadoCta', '##TPRECEPCIONESTADOCTA##', NULL, NULL, 'TPRECEPCIONESTADOCTA.Descripcion', -1, 0, 'TpRecepcionEstadoCta', 'L', 1, 0, 361)

end				
--INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
--                 VALUES (@CodEntidad, 'JrAvCalle', '##ENVIOESTADOCTA##//##JRAVCALLE##', NULL, NULL, 'CUOTAPARTISTAS.JrAvCalle', -1, 0, 'JrAvCalle', 'L', 1, 0, 0)
--INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
--                 VALUES (@CodEntidad, 'CalleNro', '##ENVIOESTADOCTA##//##CALLENRO##', NULL, NULL, 'CUOTAPARTISTAS.CalleNro', -1, 0, 'CalleNro', 'L', 1, 0, 0)
--INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
--                 VALUES (@CodEntidad, 'Mz', '##ENVIOESTADOCTA##//##MZ##', NULL, NULL, 'CUOTAPARTISTAS.Mz', -1, 0, 'Mz', 'L', 1, 0, 0)
--INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
--                 VALUES (@CodEntidad, 'Lote', '##ENVIOESTADOCTA##//##LOTE##', NULL, NULL, 'CUOTAPARTISTAS.Lote', -1, 0, 'Lote', 'L', 1, 0, 0)
--INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
--                 VALUES (@CodEntidad, 'SecEtapaZona', '##ENVIOESTADOCTA##//##SECETAPAZONA##', NULL, NULL, 'CUOTAPARTISTAS.SecEtapaZona', -1, 0, 'SecEtapaZona', 'L', 1, 0, 0)
--INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
--                 VALUES (@CodEntidad, 'TelEnv', '##ENVIOESTADOCTA##//##TELENV##', NULL, NULL, 'CUOTAPARTISTAS.TelEnv', -1, 0, 'TelEnv', 'L', 1, 0, 0)
--INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
--                 VALUES (@CodEntidad, 'DeptoEnv', '##ENVIOESTADOCTA##//##DEPTOENV##', NULL, NULL, 'CUOTAPARTISTAS.DeptoEnv', -1, 0, 'DeptoEnv', 'L', 1, 0, 0)
--INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito)
--                 VALUES (@CodEntidad, 'DistritoEnv', '##ENVIOESTADOCTA##//##DISTRITOENV##', NULL, NULL, 'CUOTAPARTISTAS.DistritoEnv', -1, 0, 'DistritoEnv', 'L', 1, 0, 0)
--INSERT tmpdfxENTCOLUMNAS (CodEntidad, CodEntColumna, Descripcion, CodTpDato, CodTpColumna, Campo, EsVisible, EsGroupBy, CodEntColumnaCrt, CodTpAlineacion, FltNivel, FltPermiteMultiple, FltEsFavorito,FltCodTpActiveX)
--                 VALUES (@CodEntidad, 'CodProvinciaEnv', '##ENVIOESTADOCTA##//##CODPROVINCIAENV##', NULL, NULL, 'CUOTAPARTISTAS.CodProvinciaEnv', -1, 0, 'CodProvinciaEnv', 'L', 1, 0, 0, 29)




-- dfxENTCOLUMNASUSER -------------------------------------------------
DECLARE @Posicion DigitoTriple
SELECT @Posicion = 0

SELECT @Posicion = @Posicion + 1
INSERT tmpdfxENTCOLUMNASUSER (CodEntidad, CodUsuario, DescEntConfiguracionUser, CodEntColumna, Posicion, Ancho, EsVisible )
                     VALUES (@CodEntidad, NULL, NULL, 'NumCuotapartista', @Posicion, 20, -1)
SELECT @Posicion = @Posicion + 1
INSERT tmpdfxENTCOLUMNASUSER (CodEntidad, CodUsuario, DescEntConfiguracionUser, CodEntColumna, Posicion, Ancho, EsVisible )
                     VALUES (@CodEntidad, NULL, NULL, 'Nombre', @Posicion, 20, -1)
--SELECT @Posicion = @Posicion + 1
--INSERT tmpdfxENTCOLUMNASUSER (CodEntidad, CodUsuario, DescEntConfiguracionUser, CodEntColumna, Posicion, Ancho, EsVisible )
--                     VALUES (@CodEntidad, NULL, NULL, 'Domicilio', @Posicion, 20, -1)
--SELECT @Posicion = @Posicion + 1
--INSERT tmpdfxENTCOLUMNASUSER (CodEntidad, CodUsuario, DescEntConfiguracionUser, CodEntColumna, Posicion, Ancho, EsVisible )
--                     VALUES (@CodEntidad, NULL, NULL, 'AgColocador', @Posicion, 20, -1)
--SELECT @Posicion = @Posicion + 1
--INSERT tmpdfxENTCOLUMNASUSER (CodEntidad, CodUsuario, DescEntConfiguracionUser, CodEntColumna, Posicion, Ancho, EsVisible )
--                     VALUES (@CodEntidad, NULL, NULL, 'Sucursal', @Posicion, 20, -1)


-- dfxENTCORTESUSER ---------------------------------------------------

INSERT tmpdfxENTCORTESUSER (CodEntidad, CodUsuario, DescEntConfiguracionUser, CodEntColumna, Posicion, CodTpCorte )
                   VALUES (@CodEntidad, NULL, NULL, 'FMT_GRILLA', 1, 'CF')


DECLARE @SQL TextoLargo
SELECT @SQL = 'CUOTAPARTISTAS
LEFT JOIN TPTITULARIDAD ON TPTITULARIDAD.CodTpTitularidad=CUOTAPARTISTAS.CodTpTitularidad
LEFT JOIN SECTORESINV ON SECTORESINV.CodSectorInv=CUOTAPARTISTAS.CodSectorInv
LEFT JOIN PAISES ON PAISES.CodPais=CUOTAPARTISTAS.CodPais
INNER JOIN OFICIALESCTA ON OFICIALESCTA.CodOficialCta=CUOTAPARTISTAS.CodOficialCta
AND OFICIALESCTA.CodSucursal=CUOTAPARTISTAS.CodSucursalOfCta
AND OFICIALESCTA.CodAgColocador=CUOTAPARTISTAS.CodAgColocadorOfCta
LEFT JOIN CANALESVTA ON CANALESVTA.CodCanalVta=CUOTAPARTISTAS.CodCanalVta
LEFT JOIN SUCURSALES LEFT JOIN AGCOLOCADORES ON SUCURSALES.CodAgColocador=AGCOLOCADORES.CodAgColocador
LEFT JOIN ZONAS ON SUCURSALES.CodZona=ZONAS.CodZona
ON CUOTAPARTISTAS.CodAgColocadorOfCta=SUCURSALES.CodAgColocador
AND CUOTAPARTISTAS.CodSucursalOfCta=SUCURSALES.CodSucursal
LEFT JOIN SUCURSALES SUCORIGEN
LEFT JOIN AGCOLOCADORES AGCOLORIGEN ON SUCORIGEN.CodAgColocador=AGCOLORIGEN.CodAgColocador
LEFT JOIN ZONAS ZONAORIGEN ON SUCORIGEN.CodZona=ZONAORIGEN.CodZona
ON CUOTAPARTISTAS.CodAgColocador=SUCORIGEN.CodAgColocador
AND CUOTAPARTISTAS.CodSucursal=SUCORIGEN.CodSucursal
LEFT JOIN PROVINCIAS ON PROVINCIAS.CodProvincia=CUOTAPARTISTAS.CodProvincia
LEFT JOIN SEGMENTOSINV ON SEGMENTOSINV.CodSegmentoInv=CUOTAPARTISTAS.CodSegmentoInv
LEFT JOIN TPPERFILRIESGOCPT ON TPPERFILRIESGOCPT.CodTpPerfilRiesgoCpt=CUOTAPARTISTAS.CodTpPerfilRiesgoCpt
INNER JOIN CATEGORIAS ON CATEGORIAS.CodCategoria=CUOTAPARTISTAS.CodCategoria
LEFT JOIN FONDOSCPT INNER JOIN FONDOSUSER ON FONDOSUSER.CodFondo=FONDOSCPT.CodFondo
ON CUOTAPARTISTAS.CodCuotapartista=FONDOSCPT.CodCuotapartista
LEFT JOIN CPTJURIDICOS
LEFT JOIN TPCONTRIBUYENTE ON TPCONTRIBUYENTE.CodTpContribuyente=CPTJURIDICOS.CodTpContribuyente
LEFT JOIN PAISES AS PAISCPTJURIDICO ON PAISCPTJURIDICO.CodPais=CPTJURIDICOS.CodPaisNacionalidad
LEFT JOIN MONEDAS MONPATRIM ON MONPATRIM.CodMoneda=CPTJURIDICOS.CodMonedaPatEstim
LEFT JOIN MONEDAS MONFACT ON MONFACT.CodMoneda=CPTJURIDICOS.CodMonedaFactEstim
LEFT JOIN TPCARACTER ON TPCARACTER.CodTpCaracter=CPTJURIDICOS.CodTpCaracter
LEFT JOIN TPPERSONASJURIDICAS ON TPPERSONASJURIDICAS.CodTpPersonaJuridica=CPTJURIDICOS.CodTpPersonaJuridica
LEFT JOIN STATUSFATCA ON STATUSFATCA.CodStatusFATCA=CPTJURIDICOS.CodStatusFATCA AND STATUSFATCA.EsFATCA=-1
LEFT JOIN STATUSFATCA as STATUSOCDE ON STATUSOCDE.CodStatusFATCA=CPTJURIDICOS.CodStatusOCDE AND STATUSOCDE.EsFATCA=0
LEFT JOIN TPOENTIDAD ON TPOENTIDAD.CodTpoEntidad=CPTJURIDICOS.CodTpoEntidad
LEFT JOIN CATEGNOSIS ON CATEGNOSIS.CodCategNosis=CPTJURIDICOS.CodCategNosis
ON CUOTAPARTISTAS.CodCuotapartista=CPTJURIDICOS.CodCuotapartista
LEFT JOIN CPTUIF
LEFT JOIN MONEDAS MONMONTO ON MONMONTO.CodMoneda=CPTUIF.CodMonedaImporteEstim
ON CUOTAPARTISTAS.CodCuotapartista=CPTUIF.CodCuotapartista
LEFT JOIN TPRECEPCIONESTADOCTA ON TPRECEPCIONESTADOCTA.CodTpRecepEstCta =CUOTAPARTISTAS.CodTpRecepEstCta  
LEFT JOIN REFERENTES ON CUOTAPARTISTAS.CodReferente=REFERENTES.CodReferente
LEFT JOIN CENTROSFISICOS ON CENTROSFISICOS.CodCentroFisico=CUOTAPARTISTAS.CodCentroFisico
LEFT JOIN AREASPERTENENCIA ON AREASPERTENENCIA.CodAreaPertenencia=CUOTAPARTISTAS.CodAreaPertenencia
LEFT JOIN TPINVERSORES ON TPINVERSORES.CodTpInversor=CUOTAPARTISTAS.CodTpInversor
LEFT JOIN vwCUOTAPARTISTASDOMICILIOFISCALMIN VCDF on VCDF.CodCuotapartista=CUOTAPARTISTAS.CodCuotapartista
LEFT JOIN CUOTAPARTISTASDOMICILIOFISCAL on CUOTAPARTISTASDOMICILIOFISCAL.CodCuotapartistaDomicilioFiscal=VCDF.CodCuotapartistaDomicilioFiscal
LEFT JOIN PAISES AS PAISFISCAL ON PAISFISCAL.CodPais=CUOTAPARTISTASDOMICILIOFISCAL.CodPais
LEFT JOIN PROVINCIAS AS PROVINCIAFISCAL ON PROVINCIAFISCAL.CodProvincia=CUOTAPARTISTASDOMICILIOFISCAL.CodProvincia'

INSERT tmpdfxENTESTRUCTURAS (CodEntidad, ConDistinct, SentenciaSQL, FntColName, FntColSize, FntEncName, FntEncSize, FntEncBold, PermiteModificarCrt, PermiteModificarFn, PermiteModificarCol, PermiteModificarOrd, TieneInfo, EsImpresionHoriz)
VALUES    (@CodEntidad , -1, @SQL , NULL, NULL, NULL, NULL, NULL, -1, -1, -1, -1, 0, 0)

EXEC sp_dfxACTUALIZARGRILLAS @CodEntidad

SET NOCOUNT OFF

GO


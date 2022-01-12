IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PADRONIIBB' AND xtype='U')
BEGIN
	CREATE TABLE TPIMPUESTO (
		CodTpImpuesto  CodigoTextoMedio,
		Denominacion   DescripcionMedia,

		CONSTRAINT [XPKTPIMPUESTO] PRIMARY KEY CLUSTERED 
		(
			[CodTpImpuesto] ASC
		)

	)
END
GO

IF NOT EXISTS(SELECT 1 FROM TPIMPUESTO WHERE CodTpImpuesto = 'REIIBB')
	INSERT INTO TPIMPUESTO(CodTpImpuesto, Denominacion) VALUES('REIIBB', 'Ingresos Brutos / Retenciones')

GO

IF NOT EXISTS(SELECT 1 FROM TPIMPUESTO WHERE CodTpImpuesto = 'PEIIBB')
	INSERT INTO TPIMPUESTO(CodTpImpuesto, Denominacion) VALUES('PEIIBB', 'Ingresos Brutos / Percepciones')

GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PADRONIIBB' AND xtype='U')
BEGIN
	CREATE TABLE PADRONIIBB (
		CodPadronIIBB			CodigoLargo Identity,
		CUIT					CUIT,
		CodTpImpuesto			CodigoTextoMedio,
		CodProvincia			CodigoMedio,
		FechaVigenciaDesde		Fecha,
		FechaVigenciaHasta		Fecha NULL,
		FechaPublicacion		Fecha NULL,
		TipoContribuyente		CodigoTextoCorto NULL,
		MarcaSujeto				CodigoTextoCorto NULL,
		MarcaCambioAlicuota		Boolean NULL,
		CoeficienteUnificacion	Porcentaje NULL,--CU
		CONSTRAINT [XPKPADRONIIBB] PRIMARY KEY CLUSTERED 
		(
			[CUIT] ASC,
			[CodTpImpuesto] ASC,
			[CodProvincia] ASC,
			[FechaVigenciaDesde] ASC
		)
	)
	
	ALTER TABLE PADRONIIBB ADD CONSTRAINT CFK_PADRONIIBB_TPPROVINCIA FOREIGN KEY (CodProvincia) REFERENCES TPPROVINCIAINT(CodProvincia)
	ALTER TABLE PADRONIIBB ADD CONSTRAINT CFK_TPIMPUESTOFACT_TPIMPUESTO FOREIGN KEY (CodTpImpuesto) REFERENCES TPIMPUESTO(CodTpImpuesto)
END
GO
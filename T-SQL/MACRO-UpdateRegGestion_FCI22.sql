

INSERT INTO AUDITORIASREF(NomEntidad)
VALUES('DOCWEB')

DECLARE @CodAuditoria numeric
SELECT @CodAuditoria = SCOPE_IDENTITY()

DECLARE @CodFondo numeric(10) 

SELECT @CodFondo=CodFondo FROM FONDOSREAL
WHERE NumFondo=22


INSERT INTO DOCUMENTACIONESWEB (CodTpDocumentacionWEB, Descripcion, CodFondo, Archivo, FechaVigencia, EstaAnulado,CodAuditoriaRef)
	SELECT 'REG' As CodTpDocumentacionWEB, --Reglamento de Gestión
		   REGLGESTION.Descripcion,
		   REGLGESTION.CodFondo,
		   REGLGESTIONDATOS.Datos As Archivo,
		   REGLGESTION.FechaInicioVigencia,
		   REGLGESTION.EstaAnulado,
		   @CodAuditoria
	FROM REGLGESTION
		 INNER JOIN REGLGESTIONDATOS ON REGLGESTIONDATOS.CodFondo = REGLGESTION.CodFondo
	WHERE NOT EXISTS (SELECT 1
					  FROM DOCUMENTACIONESWEB
					  WHERE DOCUMENTACIONESWEB.CodTpDocumentacionWEB = 'REG'
					  AND DOCUMENTACIONESWEB.CodFondo = REGLGESTION.CodFondo
					  AND DOCUMENTACIONESWEB.FechaVigencia = REGLGESTION.FechaInicioVigencia)
		AND REGLGESTION.CodFondo=@CodFondo

SELECT * FROM DOCUMENTACIONESWEB
WHERE CodTpDocumentacionWEB = 'REG'


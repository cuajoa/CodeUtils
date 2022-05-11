/* Este script vincula a todos los cuotapartistas de la base de datos con un portfolio. */

DECLARE @PORTFOLIO as varchar(80)
SET @PORTFOLIO = 'NOMBRE DEL PORTFOLIO'

DECLARE @CodPortfolio as numeric(10)
SELECT @CodPortfolio = CodPortfolio FROM PORTFOLIOS WHERE UPPER(Descripcion) LIKE UPPER('%'+@PORTFOLIO+'%')

INSERT INTO AUDITORIASREF (NomEntidad)
VALUES('CPTPORTFOLIO')

DECLARE @CodAuditoriaRef as numeric(15)
SELECT @CodAuditoriaRef = SCOPE_IDENTITY() FROM AUDITORIASREF


INSERT INTO CPTPORTFOLIOS
SELECT CodCuotapartista, @CodPortfolio, @CodAuditoriaRef, 0
FROM CUOTAPARTISTAS



PORTFOLIOLIM
PORTFOLIO
CPTPORTFOLIO


--select * FROM PORTFOLIOS
--select * FROM PORTFOLIOSLIM
--select * FROM LIMITECPTSOL
--select * FROM CPTPORTFOLIOS
--WHERE EstaAnulado=0

select * FROM PORTFOLIOSLIMMON
WHERE EstaAnulado=0

begin TRAN

INSERT INTO VFondos_2.dbo.AUDITORIASREF
SELECT 'CPTPORTFOLIO'

DECLARE @CodAuditoriaRef numeric(30)
SET @CodAuditoriaRef = @@IDENTITY

INSERT INTO VFondos_2.dbo.CPTPORTFOLIOS(CodCuotapartista, CodPortfolio, CodAuditoriaRef, EstaAnulado)
SELECT CPTMEGA.CodCuotapartista, PORTFOLIOSMEGA.CodPortfolio, @CodAuditoriaRef, 0
FROM VFondos.dbo.CPTPORTFOLIOS CPTPORTQM
INNER JOIN VFondos.dbo.CUOTAPARTISTAS CPTQM ON CPTQM.CodCuotapartista=CPTPORTQM.CodCuotapartista
INNER JOIN VFondos_2.dbo.CUOTAPARTISTAS CPTMEGA ON CPTMEGA.NumCuotapartista = '100' + LTRIM(CPTQM.NumCuotapartista)

INNER JOIN VFondos.dbo.PORTFOLIOS PORTFOLIOSQM ON CPTPORTQM.CodPortfolio = PORTFOLIOSQM.CodPortfolio
INNER JOIN VFondos_2.dbo.PORTFOLIOS PORTFOLIOSMEGA ON LTRIM(PORTFOLIOSQM.Descripcion + ' - QM') = LTRIM(PORTFOLIOSMEGA.Descripcion)

WHERE CPTPORTQM.EstaAnulado=0
--commit TRAN


begin TRAN

INSERT INTO VFondos_2.dbo.AUDITORIASREF
SELECT 'PORTFOLIOLIM'

DECLARE @CodAuditoriaRef numeric(30)
SET @CodAuditoriaRef = @@IDENTITY

INSERT INTO VFondos_2.dbo.PORTFOLIOSLIM(CodPortfolio,CodFondo,CodTpValorCp,CodLimiteCptSol, EstaAnulado, CodAuditoriaRef)
select PORTFOLIOSMEGA.CodPortfolio ,FONDOSMEGA.CodFondo,CLASESMEGA.CodTpValorCp, LIMITECPTSOLMEGA.CodLimiteCptSol, PORTFOLIOSLIMQM.EstaAnulado, @CodAuditoriaRef
FROM VFondos.dbo.PORTFOLIOSLIM PORTFOLIOSLIMQM
INNER JOIN VFondos.dbo.PORTFOLIOS PORTFOLIOSQM ON PORTFOLIOSLIMQM.CodPortfolio = PORTFOLIOSQM.CodPortfolio
INNER JOIN VFondos_2.dbo.PORTFOLIOS PORTFOLIOSMEGA ON LTRIM(PORTFOLIOSQM.Descripcion + ' - QM') = LTRIM(PORTFOLIOSMEGA.Descripcion)
INNER JOIN VFondos.dbo.FONDOSREAL FONDOSQM ON PORTFOLIOSLIMQM.CodFondo = FONDOSQM.CodFondo
INNER JOIN VFondos_2.dbo.FONDOSREAL FONDOSMEGA ON FONDOSQM.Nombre = FONDOSMEGA.Nombre

INNER JOIN VFondos.dbo.TPVALORESCP CLASESQM ON PORTFOLIOSLIMQM.CodFondo = CLASESQM.CodFondo AND PORTFOLIOSLIMQM.CodTpValorCp = CLASESQM.CodTpValorCp
INNER JOIN VFondos_2.dbo.TPVALORESCP CLASESMEGA ON FONDOSMEGA.CodFondo = CLASESMEGA.CodFondo AND CLASESQM.Abreviatura = CLASESMEGA.Abreviatura

INNER JOIN VFondos.dbo.LIMITECPTSOL LIMITECPTSOLQM ON LIMITECPTSOLQM.CodLimiteCptSol = PORTFOLIOSLIMQM.CodLimiteCptSol
INNER JOIN VFondos_2.dbo.LIMITECPTSOL LIMITECPTSOLMEGA ON LTRIM(LIMITECPTSOLQM.Descripcion + ' - QM') = LTRIM(LIMITECPTSOLMEGA.Descripcion)

WHERE PORTFOLIOSLIMQM.EstaAnulado=0


--commit TRAN


select * FROM PORTFOLIOSLIMMON
WHERE EstaAnulado=0


begin TRAN

INSERT INTO VFondos_2.dbo.AUDITORIASREF
SELECT 'PORTFOLIOLIM'

DECLARE @CodAuditoriaRef numeric(30)
SET @CodAuditoriaRef = @@IDENTITY

INSERT INTO VFondos_2.dbo.PORTFOLIOSLIMMON(CodPortfolioLim, CodMoneda, CodFondo, CodCondicionIngEgr, EstaAnulado)
select PORTFOLIOSLIMMEGA.CodPortfolioLim, MONEDASMEGA.CodMoneda, FONDOSMEGA.CodFondo, CONDMEGA.CodCondicionIngEgr, 0
FROM VFondos.dbo.PORTFOLIOSLIMMON PORTLIMQM
INNER JOIN VFondos.dbo.PORTFOLIOSLIM PORTFOLIOSLIMQM ON PORTFOLIOSLIMQM.CodPortfolioLim = PORTLIMQM.CodPortfolioLim

INNER JOIN VFondos.dbo.PORTFOLIOS PORTFOLIOSQM ON PORTFOLIOSLIMQM.CodPortfolio = PORTFOLIOSQM.CodPortfolio
INNER JOIN VFondos_2.dbo.PORTFOLIOS PORTFOLIOSMEGA ON LTRIM(PORTFOLIOSQM.Descripcion + ' - QM') = LTRIM(PORTFOLIOSMEGA.Descripcion)
INNER JOIN VFondos.dbo.FONDOSREAL FONDOSQM ON PORTLIMQM.CodFondo = FONDOSQM.CodFondo
INNER JOIN VFondos_2.dbo.FONDOSREAL FONDOSMEGA ON FONDOSQM.Nombre = FONDOSMEGA.Nombre

INNER JOIN VFondos.dbo.MONEDAS MONEDASQM ON PORTLIMQM.CodMoneda = MONEDASQM.CodMoneda
INNER JOIN VFondos_2.dbo.MONEDAS MONEDASMEGA ON MONEDASMEGA.Simbolo = MONEDASQM.Simbolo

INNER JOIN VFondos.dbo.CONDICIONESINGEGR CONDQM ON PORTLIMQM.CodFondo = CONDQM.CodFondo AND PORTLIMQM.CodCondicionIngEgr = CONDQM.CodCondicionIngEgr
INNER JOIN VFondos_2.dbo.CONDICIONESINGEGR CONDMEGA ON CONDMEGA.Descripcion = CONDMEGA.Descripcion AND CONDMEGA.CodFondo = FONDOSMEGA.CodFondo

INNER JOIN VFondos.dbo.TPVALORESCP CLASESQM ON PORTFOLIOSLIMQM.CodFondo = CLASESQM.CodFondo AND PORTFOLIOSLIMQM.CodTpValorCp = CLASESQM.CodTpValorCp
INNER JOIN VFondos_2.dbo.TPVALORESCP CLASESMEGA ON FONDOSMEGA.CodFondo = CLASESMEGA.CodFondo AND CLASESQM.Abreviatura = CLASESMEGA.Abreviatura

INNER JOIN VFondos.dbo.LIMITECPTSOL LIMITECPTSOLQM ON LIMITECPTSOLQM.CodLimiteCptSol = PORTFOLIOSLIMQM.CodLimiteCptSol
INNER JOIN VFondos_2.dbo.LIMITECPTSOL LIMITECPTSOLMEGA ON LTRIM(LIMITECPTSOLQM.Descripcion + ' - QM') = LTRIM(LIMITECPTSOLMEGA.Descripcion)

INNER JOIN VFondos_2.dbo.PORTFOLIOSLIM PORTFOLIOSLIMMEGA ON PORTFOLIOSLIMMEGA.CodFondo = FONDOSMEGA.CodFondo AND PORTFOLIOSLIMMEGA.CodPortfolio = PORTFOLIOSMEGA.CodPortfolio
AND PORTFOLIOSLIMMEGA.CodTpValorCp = CLASESMEGA.CodTpValorCp

WHERE PORTLIMQM.EstaAnulado=0

--commit tran


SELECT * FROM VFondos_2.dbo.CONDICIONESINGEGR
SELECT * FROM VFondos.dbo.CONDICIONESINGEGR
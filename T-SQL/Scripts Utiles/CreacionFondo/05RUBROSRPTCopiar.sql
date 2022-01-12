DECLARE @CodFondoDesde CodigoMedio
DECLARE @CodFondoHasta CodigoMedio

SELECT @CodFondoDesde = 1
SELECT @CodFondoHasta = 3

DELETE RUBROSRPTCTASCONT
WHERE CodFondo = @CodFondoHasta and CodReporte = 'VCP'

DELETE RUBROSRPT 
WHERE CodFondo = @CodFondoHasta and CodReporte = 'VCP'

INSERT RUBROSRPT
	(CodFondo 
		,CodReporte 
		,Nivel 
		,Descripcion                                                                      
		,TieneSubrubros 
		,RubroID 
		,Orden              
		,CodUsuarioI  
		,CodUsuarioU  
		,FechaI                      
		,FechaU                      
		,TermI           
		,TermU           
		,CodInterfaz     )

SELECT 	@CodFondoHasta
		,CodReporte 
		,Nivel 
		,Descripcion                                                                      
		,TieneSubrubros 
		,RubroID 
		,Orden              
		,CodUsuarioI  
		,CodUsuarioU  
		,FechaI                      
		,FechaU                      
		,TermI           
		,TermU           
		,CodInterfaz     
	FROM RUBROSRPT
	WHERE CodFondo = @CodFondoDesde and CodReporte = 'VCP'

INSERT RUBROSRPTCTASCONT
	(CodFondo
	,CodReporte 
	,CodRubroRpt
	,CodCtaContable      
	,CodUsuarioI  
	,FechaI                      
	,TermI  )
SELECT @CodFondoHasta
	,RUBROSRPTCTASCONT.CodReporte 
	,(select CodRubroRpt
	FROM RUBROSRPT rr
	WHERE CodFondo = @CodFondoHasta and rr.Descripcion = RUBROSRPT.Descripcion and CodReporte = 'VCP')
	,RUBROSRPTCTASCONT.CodCtaContable      
	,RUBROSRPTCTASCONT.CodUsuarioI  
	,RUBROSRPTCTASCONT.FechaI                      
	,RUBROSRPTCTASCONT.TermI  
FROM RUBROSRPTCTASCONT
INNER JOIN RUBROSRPT ON RUBROSRPT.CodRubroRpt = RUBROSRPTCTASCONT.CodRubroRpt
where RUBROSRPTCTASCONT.CodFondo = @CodFondoDesde  and RUBROSRPT.CodReporte = 'VCP' and 
	RUBROSRPTCTASCONT.CodCtaContable    IN (SELECT CodCtaContable from CTASCONTABLES WHERE CodFondo = @CodFondoHasta)



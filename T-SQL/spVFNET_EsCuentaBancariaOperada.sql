exec sp_CreateProcedure 'dbo.spVFNET_EsCuentaBancariaOperada'
GO
 
ALTER PROCEDURE dbo.spVFNET_EsCuentaBancariaOperada
       @CodCuotapartista CodigoLargo = NULL ,
       @CodCptCtaBancaria CodigoLargo = NULL , --- solicitud
	   @EsUtilizada Boolean = 0 OUTPUT
WITH ENCRYPTION 
AS

	SELECT @EsUtilizada = 0

	IF EXISTS (SELECT SOLITCTASBANCARIAS.CodCuotapartista 
			FROM SOLITCTASBANCARIAS
				INNER JOIN SOLSUSC ON SOLSUSC.CodSolSusc = SOLITCTASBANCARIAS.CodSolSusc
					AND SOLSUSC.CodFondo = SOLITCTASBANCARIAS.CodFondo
					AND SOLSUSC.CodAgColocador = SOLITCTASBANCARIAS.CodAgColocador
					AND SOLSUSC.CodSucursal = SOLITCTASBANCARIAS.CodSucursal
					AND SOLITCTASBANCARIAS.CodCtaBancaria = @CodCptCtaBancaria
			WHERE SOLSUSC.CodCuotapartista = @CodCuotapartista
				AND SOLSUSC.EstaAnulado = 0
				AND SOLSUSC.CodTpEstadoSol IN ('AUT','NOREQ')
				AND NOT EXISTS (SELECT 1 FROM LIQUIDACIONES 
				                 WHERE LIQUIDACIONES.CodSolSusc = SOLSUSC.CodSolSusc
								   AND LIQUIDACIONES.EstaAnulado = 0)
							   )
			SELECT @EsUtilizada = -1
	ELSE
		IF EXISTS (SELECT CodSolResc FROM SOLRESC
			WHERE SOLRESC.CodCuotapartista = @CodCuotapartista
				AND SOLRESC.CodCtaBancaria = @CodCptCtaBancaria
				AND SOLRESC.EstaAnulado = 0
				AND SOLRESC.CodTpEstadoSol IN ('AUT','NOREQ')
				AND NOT EXISTS (SELECT 1 FROM LIQUIDACIONES 
				    WHERE LIQUIDACIONES.CodSolResc = SOLRESC.CodSolResc
					AND LIQUIDACIONES.EstaAnulado = 0)
				)
			SELECT @EsUtilizada = -1	
	
RETURN 1

GO

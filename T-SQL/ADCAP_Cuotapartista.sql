
exec sp_CreateProcedure 'dbo.spCUOTAPARTISTAS_EstructuraComercialByCodInterfaz'
GO

ALTER PROCEDURE dbo.spCUOTAPARTISTAS_EstructuraComercialByCodInterfaz
	@CodAgColocadorOfCta  CodigoMedio OUT,
	@CodSucursalOfCta	  CodigoMedio OUT,
	@CodOficialCta		  CodigoMedio OUT,
	@CodInterfaz		  CodigoInterfaz
WITH ENCRYPTION
AS
   
	SELECT  @CodAgColocadorOfCta = CodAgColocadorOfCta,
			@CodSucursalOfCta = CodSucursalOfCta,
			@CodOficialCta = CodOficialCta
	FROM CUOTAPARTISTAS
	WHERE 
	UPPER(CodInterfaz) = UPPER(@CodInterfaz)  
	AND NOT CodInterfaz  IS NULL
	
	if @CodAgColocadorOfCta is null 
		SET @CodAgColocadorOfCta = -1
	if @CodSucursalOfCta is null 
		SET @CodSucursalOfCta = -1
	if @CodOficialCta is null 
		SET @CodOficialCta = -1
GO

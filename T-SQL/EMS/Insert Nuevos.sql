exec sp_CreateProcedure 'dbo.spUSERSISTEMA_Insert'
GO

ALTER PROCEDURE dbo.spUSERSISTEMA_Insert
    @CodUserSistema		CodigoLargo OUTPUT,
	@CodUsuario			CodigoLargo,
	@CodSistema			CodigoMedio 
WITH ENCRYPTION
AS
BEGIN

	INSERT INTO USERSISTEMA ( CodUsuario, CodSistema)           
	VALUES ( @CodUsuario, @CodSistema)

	SELECT @CodUserSistema = SCOPE_IDENTITY()    


END
GO


exec sp_CreateProcedure 'dbo.spUSERDESCARGA_Insert'
GO

ALTER PROCEDURE dbo.spUSERDESCARGA_Insert
    @CodUserDescarga	CodigoLargo OUTPUT,
	@CodUsuario			CodigoLargo,
	@CodDescarga		CodigoLargo,
	@EstaAnulado		Boolean
WITH ENCRYPTION
AS
BEGIN

	INSERT INTO USERDESCARGA ( CodUsuario, CodDescarga,EstaAnulado)           
	VALUES ( @CodUsuario, @CodDescarga, @EstaAnulado)

	SELECT @CodUserDescarga = SCOPE_IDENTITY()    


END
GO
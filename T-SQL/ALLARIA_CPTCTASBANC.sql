exec sp_CreateProcedure 'dbo.spCPTCTASBANCARIAS_DatosOkByCUIT'
GO
ALTER PROCEDURE dbo.spCPTCTASBANCARIAS_DatosOkByCUIT
    @CodCuotapartista CodigoLargo,
    @CUITTitular CUIT,
    @EsIgual Boolean OUTPUT
WITH ENCRYPTION

AS
	SET @EsIgual = -1

	/*DECLARE @EsFisico Boolean

	SELECT @EsFisico = EsPersonaFisica
	FROM CUOTAPARTISTAS
	WHERE CodCuotapartista = @CodCuotapartista


	IF @EsFisico = 0
		BEGIN
			IF EXISTS (SELECT CUIT FROM CPTJURIDICOS
			WHERE CodCuotapartista = @CodCuotapartista AND CUIT=@CUITTitular)
			BEGIN
				SET @EsIgual = -1 
			END
		END
	ELSE
		BEGIN
			IF EXISTS (SELECT CUIT FROM PERSONAS
						INNER JOIN CONDOMINIOS ON PERSONAS.CodPersona = CONDOMINIOS.CodPersona
						WHERE CONDOMINIOS.CodCuotapartista = @CodCuotapartista AND CUIT=@CUITTitular)
				BEGIN
					SET @EsIgual = -1 
				END
			ELSE
			BEGIN
				IF EXISTS (SELECT CUIL FROM PERSONAS
							INNER JOIN CONDOMINIOS ON PERSONAS.CodPersona = CONDOMINIOS.CodPersona
							WHERE CONDOMINIOS.CodCuotapartista = @CodCuotapartista AND CUIL=@CUITTitular)
				BEGIN
					SET @EsIgual = -1 
				END
			END
		END*/
GO
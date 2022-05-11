
BEGIN TRANSACTION;
BEGIN TRY 


DECLARE @CodCpt1 numeric (10)
DECLARE @CodCpt2 numeric (10)

--CPT 4720
SELECT @CodCpt1=CodCuotapartista
FROM CUOTAPARTISTAS
WHERE CodAuditoriaRef=2113209

--CPT 728
SELECT @CodCpt2=CodCuotapartista
FROM CUOTAPARTISTAS
WHERE CodAuditoriaRef=966998

DECLARE @CodLiquidacion numeric(15)
DECLARE @CodSolResc numeric(15)

SELECT @CodLiquidacion=CodLiquidacion, @CodSolResc=CodSolResc
FROM LIQUIDACIONES
WHERE CodAuditoriaRef=2137756


DECLARE @CodAgColocador numeric(10)
DECLARE @CodOficialCta numeric(10)
DECLARE @CodSucursalOfCta numeric(10)

--Obtengo el nuevo CPT
SELECT @CodAgColocador=CodAgColocadorOfCta, @CodSucursalOfCta=CodSucursalOfCta, @CodOficialCta=CodOficialCta
FROM CUOTAPARTISTAS
WHERE CodCuotapartista=@CodCpt2

ALTER TABLE LIQUIDACIONES  
NOCHECK CONSTRAINT CFK_LIQUIDACIONES_SOLRESC_1;  

UPDATE LIQUIDACIONES
SET
	CodCuotapartista=@CodCpt2,
	CodAgColocador=@CodAgColocador,
	CodOficialCta=@CodOficialCta,
	CodSucursal=@CodSucursalOfCta
FROM LIQUIDACIONES
WHERE LIQUIDACIONES.CodLiquidacion=@CodLiquidacion


DECLARE @CodCtaBancaria numeric(15)

SELECT TOP 1
    @CodCtaBancaria=CodCtaBancaria
FROM CPTCTASBANCARIAS
WHERE CodCuotapartista=@CodCpt2


UPDATE SOLRESC
SET
	CodCuotapartista=@CodCpt2,
	CodAgColocador=@CodAgColocador,
	CodOficialCta=@CodOficialCta,
	CodSucursal=@CodSucursalOfCta,
	CodCtaBancaria=@CodCtaBancaria,
    NumSolicitud=1000000000070
FROM SOLRESC
WHERE SOLRESC.CodSolResc=@CodSolResc


ALTER TABLE LIQUIDACIONES  
CHECK CONSTRAINT CFK_LIQUIDACIONES_SOLRESC_1;   


END TRY
BEGIN CATCH  
    SELECT
    ERROR_NUMBER() AS ErrorNumber  
        , ERROR_SEVERITY() AS ErrorSeverity  
        , ERROR_STATE() AS ErrorState  
        , ERROR_PROCEDURE() AS ErrorProcedure  
        , ERROR_LINE() AS ErrorLine  
        , ERROR_MESSAGE() AS ErrorMessage;  

    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION;  
END CATCH;

IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;  

GO
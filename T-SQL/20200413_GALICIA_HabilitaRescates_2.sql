BEGIN TRANSACTION;  
BEGIN TRY 

DECLARE @CodFondo numeric(10)
SELECT @CodFondo=CodFondo FROM FONDOSREAL
WHERE NumFondo = 3

--consulto solicitudes de Rescate
SELECT * FROM SOLRESC
WHERE FechaConcertacion='20200413' AND CodFondo=@CodFondo
AND CodAuditoriaRef BETWEEN 19336766 AND 19353346

--Anulo todas las solicitudes de Rescate
UPDATE SOLRESC
SET
EstaAnulado=0
WHERE FechaConcertacion='20200413' AND CodFondo=@CodFondo
AND CodAuditoriaRef BETWEEN 19336766 AND 19353346


END TRY
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage;  

    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION;  
END CATCH;  

IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;  

GO

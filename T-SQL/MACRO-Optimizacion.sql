
CREATE NONCLUSTERED INDEX XIFCPTJURIDICOS
ON [dbo].[CPTJURIDICOS] ([CUIT])
GO

CREATE NONCLUSTERED INDEX XIF3PERSONAS
ON [dbo].[PERSONAS] ([CUIT])
GO

CREATE NONCLUSTERED INDEX XIF4PERSONAS
ON [dbo].[PERSONAS] ([CUIL])
GO

CREATE NONCLUSTERED INDEX XIF5PERSONAS
ON [dbo].[PERSONAS] ([NumDocumento])
GO

exec sp_CreateProcedure 'dbo.spVFHome_CuotapartistasRelTicket'
GO

ALTER PROCEDURE dbo.spVFHome_CuotapartistasRelTicket
     @CUIT                  CUIT = NULL 
WITH ENCRYPTION
AS

    SELECT  CUOTAPARTISTAS.CodCuotapartista, 
            ISNULL(CUOTAPARTISTAS.CodInterfazBanco, '') AS CodInterfazBanco, 
            CUOTAPARTISTAS.NumCuotapartista,
            CUOTAPARTISTAS.EstaAnulado
    FROM    CUOTAPARTISTAS
            INNER JOIN CPTJURIDICOS
                    ON CPTJURIDICOS.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
    WHERE CPTJURIDICOS.CUIT = @CUIT

GO

CREATE NONCLUSTERED INDEX XPK1CONDOMINIOS
ON [dbo].[CONDOMINIOS] ([EstaAnulado])
INCLUDE ([CodCuotapartista],[Orden])

GO

CREATE NONCLUSTERED INDEX XPK2CONDOMINIOS
ON [dbo].[CONDOMINIOS] ([CodPersona],[EstaAnulado])
INCLUDE ([CodCuotapartista])

GO
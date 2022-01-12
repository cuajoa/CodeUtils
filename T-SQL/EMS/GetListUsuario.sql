exec sp_CreateProcedure 'dbo.GetListUsuario'
GO
alter PROCEDURE dbo.GetListUsuario
	
WITH ENCRYPTION

AS
BEGIN

SELECT CodUsuario, UserID FROM USUARIOS
WHERE CodTpUsuario='CL' AND EstaAnulado=0
AND UserID LIKE '%@%'
Order By UserID

END 

GO
exec sp_CreateProcedure 'dbo.GetDocumentacion'
GO
alter PROCEDURE dbo.GetDocumentacion
	--@CodUsuario numeric(15)
WITH ENCRYPTION

AS
BEGIN

SELECT CodDescarga as cod, Descripcion as title, NombreArchivo as arch, FORMAT (FechaPostDesde, 'dd/MM/yyyy ') as fecha, REPLACE(ISNULL(Observaciones,''), Char(13), '<br />')  as [desc]
FROM DESCARGAS 
WHERE EstaAnulado=0 and GETDATE() BETWEEN FechaPostDesde AND ISNULL(FechaPostHasta,GETDATE())
--AND (CodUsuarioHabilitado= @CodUsuario OR CodUsuarioHabilitado IS NULL) 
AND CodTpDescarga = 2
ORDER BY FechaPostDesde DESC

END 

GO
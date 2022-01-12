exec sp_CreateProcedure 'dbo.GetDescargasByUsuario'
GO
alter PROCEDURE dbo.GetDescargasByUsuario
	@CodUsuario int
WITH ENCRYPTION

AS
BEGIN

SELECT TOP 30 CodDescarga as cod, Descripcion as title, NombreArchivo as arch, FORMAT (FechaPostDesde, 'dd/MM/yyyy ') as fecha, REPLACE(ISNULL(Observaciones,''), Char(13), '<br />')  as [desc]
FROM DESCARGAS 
WHERE EstaAnulado=0 and GETDATE() BETWEEN FechaPostDesde AND ISNULL(FechaPostHasta,GETDATE())
AND (CodUsuarioHabilitado= @CodUsuario OR CodUsuarioHabilitado IS NULL) And CodTpDescarga = 1
ORDER BY FechaPostDesde DESC

END 

GO
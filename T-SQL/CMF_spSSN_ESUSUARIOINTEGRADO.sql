EXEC sp_CreateProcedure 'dbo.spSSN_ESUSUARIOINTEGRADO'
GO

DECLARE @EsCampoPass bit

SELECT  @EsCampoPass = count(*)
from    sysobjects
        inner join syscolumns
                on syscolumns.id = sysobjects.id
where   sysobjects.name = 'USUARIOS'
    and syscolumns.name = 'TieneSegIntegrada'

DECLARE @sSql nvarchar(4000)
SELECT @sSql = ''
SELECT @sSql = @sSql + 'ALTER PROCEDURE dbo.spSSN_ESUSUARIOINTEGRADO' + char(13)
SELECT @sSql = @sSql + '    @UserID                         varchar(300)' + char(13)
SELECT @sSql = @sSql + ' WITH ENCRYPTION ' + char(13)
SELECT @sSql = @sSql + ' AS' + char(13) + char(13) --agregar
SELECT @sSql = @sSql + ' DECLARE @ControlarMayMin VARCHAR(10) '+ char(13) + char(13)

SELECT @sSql = @sSql + ' declare @DominioAD DescripcionMedia '+ char(13) + char(13)

SELECT @sSql = @sSql + ' if (select count(*) from DOMINIOSAD where EstaAnulado = 0) > 0 '+ char(13) + char(13)
SELECT @sSql = @sSql + ' begin '+ char(13) + char(13)
SELECT @sSql = @sSql + '	select top 1 @DominioAD = Descripcion from DOMINIOSAD where EstaAnulado = 0 '+ char(13) + char(13)
SELECT @sSql = @sSql + '	select @DominioAD = @DominioAD + ''/'' '+ char(13) + char(13)
SELECT @sSql = @sSql + ' end '+ char(13) + char(13)

IF EXISTS (SELECT * FROM sysobjects where name = 'PARAMETROSENT' and type = 'U')
BEGIN
    SELECT @sSql = @sSql + '     IF exists (SELECT * FROM PARAMETROSENT WHERE CodParametroEnt = ''MAYMIN'') BEGIN '+ char(13)
    SELECT @sSql = @sSql + '         SELECT  @ControlarMayMin = ValorBoolean '+ char(13)
    SELECT @sSql = @sSql + '         FROM    PARAMETROSENT '+ char(13)
    SELECT @sSql = @sSql + '         WHERE   CodParametroEnt = ''MAYMIN'' '+ char(13)
    SELECT @sSql = @sSql + '     END '+ char(13)
    SELECT @sSql = @sSql + ' '+ char(13)
END
ELSE BEGIN
    SELECT @sSql = @sSql + '     IF exists (SELECT * FROM PARAMETROS WHERE CodParametro = ''USERCS'') BEGIN '+ char(13)
    SELECT @sSql = @sSql + '         SELECT  @ControlarMayMin = ValorParametro '+ char(13)
    SELECT @sSql = @sSql + '         FROM    PARAMETROS '+ char(13)    SELECT @sSql = @sSql + '         WHERE   CodParametro = ''USERCS'' '+ char(13)
    SELECT @sSql = @sSql + '     END '+ char(13)    SELECT @sSql = @sSql + ' '+ char(13)
END

SELECT @sSql = @sSql + '     SELECT  @ControlarMayMin = ISNULL(@ControlarMayMin,0) '+ char(13) + char(13)

IF @EsCampoPass=0 BEGIN
    SELECT @sSql = @sSql + ' SELECT USUARIOS.CodUsuario, Case When EsLoginEstandar=-1 then 0 else 1 end' + char(13) 
END
ELSE BEGIN
    SELECT @sSql = @sSql + 'SELECT  USUARIOS.CodUsuario, Case When TieneSegIntegrada=-1 then 1 else 0 end' + char(13) 
END
SELECT @sSql = @sSql + '     FROM    USUARIOS' + char(13) 
SELECT @sSql = @sSql + '     WHERE   (USUARIOS.UserID = @DominioAD+@UserID and @ControlarMayMin = -1)' + char(13) 
SELECT @sSql = @sSql + '     OR (UPPER(USUARIOS.UserID) = UPPER(@DominioAD+@UserID) and @ControlarMayMin = 0)' + char(13) 

SELECT @sSql = @sSql + '         AND USUARIOS.Estado = ''A''' + char(13) 
SELECT @sSql = @sSql + '         AND USUARIOS.EstaAnulado = 0' + char(13) 

EXEC sp_executesql @sSql

GO
 
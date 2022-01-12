DECLARE @NumFondo NumeroLargo
DECLARE @CodFondo NumeroLargo
DECLARE @CantTpValorCpNuevo NumeroLargo
DECLARE @Abreviatura AbreviaturaLarga
DECLARE @Descripcion DescripcionLarga
DECLARE @Cantidad NumeroLargo
DECLARE @Encontrado Boolean
DECLARE @Fecha Fecha
DECLARE @CodAuditoriaRef CodigoLargo
DECLARE @ValorInicial Precio

--Indicar el Numero de Fondo donde se agregan las cuotapartes a Generar
SELECT @NumFondo = 1

--Indicar Cantidad de Cuotas a Generar
SELECT @CantTpValorCpNuevo = 1

SELECT @CodFondo = CodFondo
FROM FONDOS
WHERE NumFondo = @NumFondo

SELECT @Cantidad = 0
SELECT @ValorInicial = 1

WHILE @CantTpValorCpNuevo <> 0
BEGIN

    SELECT @Encontrado = 0
    WHILE @Encontrado = 0
    BEGIN

        SELECT @Descripcion = 'Clase ' + CHAR(ASCII('A') + @Cantidad)
        SELECT @Abreviatura = CHAR(ASCII('A') + @Cantidad)
    
        SELECT @Cantidad = @Cantidad + 1
        
        IF (SELECT COUNT(*) FROM TPVALORESCP WHERE Descripcion = @Descripcion and @CodFondo = CodFondo) = 0
        BEGIN
            IF (SELECT COUNT(*) FROM TPVALORESCP WHERE Abreviatura = @Abreviatura and @CodFondo = CodFondo)= 0
            BEGIN
                SELECT @Encontrado = -1
            END
        END

    END

    SELECT @Fecha = CONVERT(Varchar(8), getdate(), 112)
    SELECT 'Insertando el valor de cuotaparte para el día ' + convert(varchar(20),@Fecha,107)

    INSERT AUDITORIASREF (NomEntidad)
        VALUES ('TPVALCP')

    SELECT @CodAuditoriaRef =  @@IDENTITY
            
    INSERT TPVALORESCP (CodFondo, Descripcion, Abreviatura, CodAuditoriaRef, ValorCpInicial, FechaInicio)
        VALUES (@CodFondo, @Descripcion, @Abreviatura, @CodAuditoriaRef, @ValorInicial, @Fecha)

    INSERT AUDITORIASHIST (CodAccion, CodUsuario, Fecha, Terminal, CodAuditoriaRef)
        VALUES ('TPVALCPa',1,GETDATE(),Host_name(),@CodAuditoriaRef)

    SELECT @CantTpValorCpNuevo = @CantTpValorCpNuevo - 1

END

IF (SELECT COUNT(*) FROM FONDOSREAL WHERE CodTpCuotaparte = 'UN' and CodFondo = @CodFondo )= 1 BEGIN
	UPDATE FONDOS 
		SET CodTpCuotaparte = 'MVPAT'
	WHERE CodFondo = @CodFondo
END


DECLARE @CodFondo numeric(10) = 14
IF EXISTS (SELECT CodFondo FROM FONDOSREAL WHERE CodTpCuotaparte = 'CTRA' and CodFondo = @CodFondo) BEGIN
	UPDATE FONDOSREAL
		SET CodTpCuotaparte = 'UN'
	WHERE CodFondo = @CodFondo
END
GO
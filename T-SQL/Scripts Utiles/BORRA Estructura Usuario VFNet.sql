DECLARE @CodUsuario CodigoCorto
SELECT @CodUsuario = CodUsuario FROM USUARIOS WHERE UserID = 'B04609'


delete appENTFUNCIONESUSER WHERE CodUsuario = @CodUsuario
delete appENTCORTESUSER WHERE CodUsuario = @CodUsuario
delete appENTCOLUMNASUSER WHERE CodUsuario = @CodUsuario
delete appENTFILTROSUSER WHERE CodUsuario = @CodUsuario
delete appENTFILTROSSETUSER WHERE CodUsuario = @CodUsuario
delete appENTCONFIGURACIONUSER WHERE CodUsuario = @CodUsuario

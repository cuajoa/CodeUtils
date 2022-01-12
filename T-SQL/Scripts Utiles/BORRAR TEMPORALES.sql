DECLARE @CodEntidad CodigoCorto
SELECT @CodEntidad = 54
delete dfxENTFUNCIONESUSER WHERE CodEntidad = @CodEntidad
delete dfxENTCORTESUSER WHERE CodEntidad = @CodEntidad
delete dfxENTCOLUMNASUSER WHERE CodEntidad = @CodEntidad
delete dfxENTFILTROSUSER WHERE CodEntidad = @CodEntidad
delete dfxENTCONFIGURACIONUSER WHERE CodEntidad = @CodEntidad


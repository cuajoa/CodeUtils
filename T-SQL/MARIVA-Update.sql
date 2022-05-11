--Es el cuotapartista 56916 – Refmaster SRL
--Usuario Vgago81

DECLARE @CodUsuario numeric(10)


SELECT @CodUsuario=CodUsuario FROM USUARIOS
WHERE UserID='Vgago81'

SELECT * FROM USUARIOSCPTREL
WHERE NumCuotapartista=56916 AND CodUsuario=@CodUsuario

UPDATE USUARIOSCPTREL
SET
EsConsultivo=0
WHERE NumCuotapartista=56916 AND CodUsuario=@CodUsuario
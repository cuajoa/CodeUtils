DECLARE @NumFondo numeric(15) =3
DECLARE @Fecha smalldatetime = '20200601' 


--::::::::: NO TOCAR :::::::::--
DECLARE @CodFondo numeric(15) 

SELECT @CodFondo=CodFondo
FROM FONDOSREAL
WHERE NumFondo=@NumFondo


SELECT * FROM FONDOSPROC

UPDATE FONDOSPROC
SET
FechaUltCorrida=@Fecha
WHERE CodFondo=@CodFondo
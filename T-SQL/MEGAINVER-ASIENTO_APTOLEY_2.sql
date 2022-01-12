
SELECT * FROM ASIENTOSIT
DECLARE @CodFondo as numeric(10)

SELECT @CodFondo=CodFondo
FROM FONDOSREAL
WHERE NumFondo=15

UPDATE ASIENTOSIT
SET
Coeficiente= 1
WHERE CodFondo=@CodFondo AND NumAsiento=13601 and CodCtaContable=1004012000000000000


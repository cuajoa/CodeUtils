
Begin tran
DECLARE @CodFondo as numeric(10)

--:::::::::: RENTA FIJA USD / 12  ::::::::::
SELECT @CodFondo=CodFondo
FROM FONDOSREAL
WHERE NumFondo=12

UPDATE ASIENTOSIT
SET
Coeficiente= 0.00000001
WHERE CodFondo=@CodFondo AND NumAsiento=12904 and CodCtaContable=1001001001000000000

--:::::::::: LATAM / 16 ::::::::::
SELECT @CodFondo=CodFondo
FROM FONDOSREAL
WHERE NumFondo=16

UPDATE ASIENTOSIT
SET
Coeficiente= 0.00000001
WHERE CodFondo=@CodFondo AND NumAsiento=9383 and CodCtaContable=1001001001000000000


--:::::::::: SOVEREIGN & SUB / 22 ::::::::::
SELECT @CodFondo=CodFondo
FROM FONDOSREAL
WHERE NumFondo=22

UPDATE ASIENTOSIT
SET
Coeficiente= 0.00000001
WHERE CodFondo=@CodFondo AND NumAsiento=2940 and CodCtaContable=1001001001000000000


Commit
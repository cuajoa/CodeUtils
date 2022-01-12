DECLARE @CodFondo CodigoMedio 
set @CodFondo = 5

UPDATE CTASCONTABLES
	SET Nivel = 99
WHERE CodFondo = @CodFondo

UPDATE CTASCONTABLES
	SET Nivel = 1
WHERE CodFondo = @CodFondo and CodPadre is null

UPDATE CTASCONTABLES
	SET Nivel = 2
WHERE CodFondo = @CodFondo and CodPadre in (select CodCtaContable  
		from CTASCONTABLES CTASCONTInt where CTASCONTInt.CodFondo = CTASCONTABLES.CodFondo AND Nivel = 1)
and not CodPadre is null
		
UPDATE CTASCONTABLES
	SET Nivel = 3
WHERE CodFondo = @CodFondo and CodPadre in (select CodCtaContable  
		from CTASCONTABLES CTASCONTInt where CTASCONTInt.CodFondo = CTASCONTABLES.CodFondo AND Nivel = 2)
and not CodPadre is null
		

UPDATE CTASCONTABLES
	SET Nivel = 4
WHERE CodFondo = @CodFondo and CodPadre in (select CodCtaContable  
		from CTASCONTABLES CTASCONTInt where CTASCONTInt.CodFondo = CTASCONTABLES.CodFondo AND Nivel = 3)
and not CodPadre is null
		
UPDATE CTASCONTABLES
	SET Nivel = 5
WHERE CodFondo = @CodFondo and CodPadre in (select CodCtaContable  
		from CTASCONTABLES CTASCONTInt where CTASCONTInt.CodFondo = CTASCONTABLES.CodFondo AND Nivel = 4)
and not CodPadre is null
		
UPDATE CTASCONTABLES
	SET Nivel = 6
WHERE CodFondo = @CodFondo and CodPadre in (select CodCtaContable  
		from CTASCONTABLES CTASCONTInt where CTASCONTInt.CodFondo = CTASCONTABLES.CodFondo AND Nivel = 5)
and not CodPadre is null
		
UPDATE CTASCONTABLES
	SET Nivel = 7
WHERE CodFondo = @CodFondo and CodPadre in (select CodCtaContable  
		from CTASCONTABLES CTASCONTInt where CTASCONTInt.CodFondo = CTASCONTABLES.CodFondo AND Nivel = 6)
		and not CodPadre is null

UPDATE CTASCONTABLES
	SET Nivel = 8
WHERE CodFondo = @CodFondo and CodPadre in (select CodCtaContable  
		from CTASCONTABLES CTASCONTInt where CTASCONTInt.CodFondo = CTASCONTABLES.CodFondo AND Nivel = 7)
		and not CodPadre is null
		
		
select * from CTASCONTABLES where CodFondo = 5



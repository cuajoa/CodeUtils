DECLARE @CodFondo CodigoLargo 
select @CodFondo= CodFondo 
FROM FONDOS
WHERE NumFondo = 3
exec spGDIN_IntefazCAFCIUnificada @CodFondo,@FechaProceso='2018-07-20 00:00:00',@CodUsuario='1',@Diaria=-1,@Semanal=0,@Mensual=0

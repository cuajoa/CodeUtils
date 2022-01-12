DECLARE @CodFondo numeric(15)
DECLARE @Fecha smalldatetime = '9/15/20203'
DECLARE @NumFondo numeric(15)=34

SELECT @CodFondo=CodFondo FROM FONDOSREAL
WHERE NumFondo=@NumFondo

exec spLComposicionCartera @Fecha,  @CodFondo,  1, NULL, 0,0 --Cartera
exec spLCompCarteraInversiones  @CodFondo,@Fecha,0 --Inversiones
exec spLCompCarteraPF  @CodFondo,@Fecha, 0--PlazoFijo
exec spLCompCarteraPFX  @CodFondo,@Fecha, 'PFCER'--PlazoFijoCER
exec spLCompCarteraPFX  @CodFondo,@Fecha, 'PFTVAR'--PlazoFijoTVAR
exec spLCompCarteraPFX  @CodFondo,@Fecha, 'PFBDLR'--PlazoFijoBDLR
exec spLCompCarteraPF  @CodFondo,@Fecha, -1--PlazoFijoPrecancelable
exec spLCompCarteraPaseCau  @CodFondo,@Fecha --PasesCau
exec spLCompCarteraChequeDif  @CodFondo,@Fecha --ChequeDif
exec spLCompCarteraOtras  @CodFondo,@Fecha --OtrasInversiones
exec spLCompCarteraDisp  @CodFondo,@Fecha --Disponibilidades
exec spXDuration @CodFondo,@Fecha,null  --Duration --> Devuelve la variable "Duration"
exec spLCompCarteraVCP  @CodFondo,@Fecha, 1 --ValoresCuotaparte
exec spLCompCarteraIngEgr  @CodFondo,@Fecha --IngresosEgresos
exec spLCompCartPart  @CodFondo,@Fecha --Cuotapartistas
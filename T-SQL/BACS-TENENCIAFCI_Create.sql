
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name='TENENCIAFCI')
BEGIN
	CREATE TABLE [dbo].[TENENCIAFCI](
		[NombreFondo] [dbo].[DescripcionMedia] NOT NULL,
		[TipoValorCp] [dbo].[DescripcionCorta] NOT NULL,
		[NSuc_ACargo] [dbo].[CodigoMedio] NOT NULL,
		[DescSuc_ACargo] [dbo].[Nombre] NOT NULL,
		[Oficial_Origen] [dbo].[DescripcionMedia] NOT NULL,
		[Sucursal_CuotaP] [dbo].[CodigoMedio] NOT NULL,
		[PersFisica] [char](2) NOT NULL,
		[TenenciaCantCp] [dbo].[CantidadCuotapartes] NOT NULL,
		[TenenciaValuada] [dbo].[Importe] NOT NULL,
		[AgenteColocador] [dbo].[Nombre] NOT NULL,
		[CuotapartistaNum] [dbo].[NumeroLargo] NOT NULL,
		[CuotapartistaNom] [dbo].[Nombre] NOT NULL,
		[CUIL_CUIT_CuotaPartista] [dbo].[CUIT] NOT NULL,
		[ValorCuotaparte] [dbo].[Precio] NOT NULL,
		[FechaIngreso] [dbo].[Fecha] NOT NULL,
		[FechaPosicion] [dbo].[Fecha] NOT NULL
	) ON [PRIMARY]

END
GO


IF EXISTS (SELECT * FROM sys.columns WHERE name='TenenciaValuada' and object_id=OBJECT_ID('TENENCIAFCI') AND user_type_id=309)
BEGIN
	ALTER TABLE TENENCIAFCI 
		ALTER COLUMN TenenciaValuada Importe NOT NULL
END
UPDATE PARAMETROS
set ValorParametro = 'BANCOREGPY_69'
where CodParametro = 'CODCLI'

update PARAMETROS
SET TituloParametro = 'Id: VFBRPA01',
	ValorParametro = 'FD6769B4FD692CF8'
where PARAMETROS.CodParametro = 'IDCLI'


exec sp_CreateProcedure 'dbo.spXLicencias'
GO 
ALTER PROCEDURE dbo.spXLicencias
         @Random         DescripcionCorta = NULL
        ,@Expiracion     Checksum = NULL OUTPUT
        ,@Licencias      CodigoMedio = null OUTPUT
WITH ENCRYPTION 
AS
        
    DECLARE @Codigo  Varchar(25)
    DECLARE @Valor   NumeroLargo
    DECLARE @Fecha   Fecha
    DECLARE @CodCliente Texto

    SELECT @Valor  = 0
    SELECT @Fecha  = NULL

    EXEC spXChecksum 1 , @Random, 'EXPIRACION' , @Fecha OUTPUT , @Valor OUTPUT

    SELECT @Expiracion = @Valor
    SELECT @Licencias = 0

    SELECT @CodCliente = (SELECT RTRIM(LTRIM(ValorParametro)) FROM PARAMETROS WHERE CodParametro = 'CODCLI')

    IF @CodCliente in ('BNP_1','ABNAMBROBANKROU_2','ABNAMBROBANKARG_3','LLOYDSBANK_4','SUDAMERIS_5','ZURICH_6','CMA_7','SCHRMILDESA_8',
						'SGAM_9','INVESTIS_10','EXPRINTER_11','CREDICOOP_12','COPERNICO_13','SANTANDER_14','TORONTO_15','BNL_16','PELLEGRINI_17',
						'PROVINCIA_18','PUENTE_19','LOPEZLEON_20','ITAU_21','ITAUCARTERA_21','MBA_22','RIG_23','ATV_23', --BURPLAZA
						'BANSUD_24','CAJAMEDICOS_25','BANSUDOS_26','STANDARDBANK_27','COHEN_28','GPS_29','ALLARIA_30','SEDESA_31','TPCG_32',
						'BALANZ_33','FACIMEX_34','SMSV_35','MARIVA_36','MEGA_37','AXIS_38', 'CONSUL_39', 'RJ_40', 'GALICIA_41', 'GLOBAL_42','CIMA_43',
						'CONVEXITY_44', 'GRUPOSS_45', 'CARTVAL_46', 'BIND_47', 'SBSG_48','CAMU_49','FIRS_50','GROB_51','SANTANDERCARTERA_52', 'PERUADCAP_53',
						'LACAJA_54','MONEDA_55','SBSCARTERA_52','CMF_57','BAINTER_58','WESTERNU_52','BAF_60','LAPAMPA_61','BAFSG_62','NUEVOCHACO_63','PUENTEPAR_60','BANCOR_64','CAJCOR_65',
						'DELCAR_66', 'IEBA_67', 'NOVU_68', 'BANCOREGPY_69')
		SELECT @Licencias = -1


RETURN
GO



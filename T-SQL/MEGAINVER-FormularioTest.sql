DECLARE @WHERE numeric = 888

CREATE TABLE #FRM_LIQUIDAC    
(Numero  varchar(20) COLLATE database_default,
NumRescTxt               varchar(20) COLLATE database_default, 
Estado                   varchar(80) COLLATE database_default,    
FECHAC                   varchar(80) COLLATE database_default, 
CodCuotapartista         numeric(10),   
CUONOM                   varchar(80) COLLATE database_default, 
CUONUM                   numeric(15),   CUOTEXTNUM               varchar(15) COLLATE database_default,  
CUODOM                   varchar(300) COLLATE database_default,  
CUOCP                    varchar(8)  COLLATE database_default,   
CUOLOC                   varchar(50) COLLATE database_default, 
CUOTEL                   varchar(30) COLLATE database_default, 
CodFondo                 numeric(5),  
FONDONOM                 varchar(200) COLLATE database_default, 
NUMSOL                   numeric(18),   
NUMSUSCTXT               varchar(20) COLLATE database_default,   
CCUOTA                   numeric(22,8), 
MONSIM                   VARCHAR(6)  COLLATE database_default,  
MONSIL                   VARCHAR(6)  COLLATE database_default,   
SALCUO                   NUMERIC(22,8), 
CUOBLO                   NUMERIC(22,8),  
CUOTOT                   NUMERIC(22,8),  
PORGAS                   NUMERIC(22,2), 
VALCUO                   NUMERIC(22,8),  
IMPGRE                   NUMERIC(22,2),  
IMPMRB                   NUMERIC(22,2),    
PNOM1       varchar(200) COLLATE database_default, 
PNRODOC1        varchar(15) COLLATE database_default, 
PTPDOC1        varchar(6)  COLLATE database_default,  
PNOM2       varchar(200) COLLATE database_default,   
PNRODOC2        varchar(15) COLLATE database_default,  
PTPDOC2        varchar(6)  COLLATE database_default,   
PNOM3       varchar(200) COLLATE database_default,   
PNRODOC3        varchar(15) COLLATE database_default,    
PTPDOC3        varchar(6)  COLLATE database_default,   
FONSD                    varchar(80) COLLATE database_default, 
FONSG                    varchar(80) COLLATE database_default,  
NOMSUC                   VARCHAR(80) COLLATE database_default, 
NRCNV                    numeric(5),  
RESCNV                   varchar(10) COLLATE database_default,   
FECHAENLETRASCNV         VARCHAR(80) COLLATE database_default,  
IMPTXT                   VARCHAR(255) COLLATE database_default,  
MONDESC                  VARCHAR(80) COLLATE database_default,  
TPVCP                    VARCHAR(80) COLLATE database_default, 
NOMAC                    VARCHAR(80) COLLATE database_default,  
NOMOC                    VARCHAR(80) COLLATE database_default, 
FCOBRO                   VARCHAR(80) COLLATE database_default,
FECLIQ                   VARCHAR(80) COLLATE database_default, 
bEsFisico                  smallint,    
bEsJuridico              smallint, 
CUOCUIT                  varchar(50) COLLATE database_default,
NumFondo   numeric(5),  
bVisibleBV    smallint,  
bVisibleDB    smallint, 
bEsAgColocPte   smallint, 
bEsNotAgColocPte  smallint)      
 
 
declare @CodFondo numeric(10) 
declare @CodAgColocador numeric(10)    
declare @CodSucursal numeric(10)       
declare @CodLiquidacion numeric(18)       
declare @NumSolicitud numeric(18)    
declare @NumRescTxt varchar(20)     
declare @CodTpValorCp numeric(3)       
declare @Numero varchar(150)      
declare @FechaConcertacion smalldatetime   
declare @Retorno varchar(50)      
declare @FechaCNV smalldatetime    
declare @FechaEnLetras varchar(50)  
declare @CodCuotapartista numeric(10)    
declare @MonedaSol varchar(15)    
declare @MontoBruto numeric(22,2)    
declare @ValorCuotaparte numeric(22,8)    
declare @FactorConversion numeric(16,10) 
declare @PorcGastos numeric(8,4)    
declare @Importe numeric(22,2)     
declare @CodCondicionIngEgr      numeric(5)     

 -- BUSCO IMPORTE PARA CONVERTIR A LETRAS          
SELECT @CodFondo = LIQUIDACIONES.CodFondo,  
@CodAgColocador = LIQUIDACIONES.CodAgColocador,          
@CodSucursal = LIQUIDACIONES.CodSucursal,         
@CodLiquidacion = LIQUIDACIONES.CodLiquidacion,   
@CodTpValorCp = LIQUIDACIONES.CodTpValorCp,     
@FechaConcertacion = LIQUIDACIONES.FechaConcertacion,    
@CodCuotapartista = LIQUIDACIONES.CodCuotapartista,          
@NumSolicitud = COALESCE(SOLRESC.NumSolicitud,0),         
@NumRescTxt = replicate('0',15-len(convert(varchar(20),
SOLRESC.NumSolicitud))) + convert(varchar(20), SOLRESC.NumSolicitud),   
@MonedaSol    = MONEDAS.Simbolo,   
@FactorConversion = SOLRESC.FactorConversion,     
@PorcGastos = COALESCE(SOLRESC.PorcGastos,0.0),     
@Importe = (LIQUIDACIONES.Importe) / SOLRESC.FactorConversion,   
@CodCondicionIngEgr = LIQUIDACIONES.CodCondicionIngEgr  
FROM LIQUIDACIONES          
LEFT JOIN SOLRESC           
	INNER JOIN MONEDAS ON MONEDAS.CodMoneda = SOLRESC.CodMoneda      
				ON SOLRESC.CodFondo = LIQUIDACIONES.CodFondo                  
AND SOLRESC.CodAgColocador = LIQUIDACIONES.CodAgColocador           
AND SOLRESC.CodSucursal = LIQUIDACIONES.CodSucursal       
AND SOLRESC.CodSolResc = LIQUIDACIONES.CodSolResc   
		WHERE LIQUIDACIONES.CodLiquidacion IN (@WHERE)     
 
  -- ESCRIBO FECHA DE CONCERTACION DE LA SOLICITUD 
    EXEC spExpresionFecha 2, @FechaConcertacion, 0, @Retorno OUTPUT    

	 -- GUARDO FECHA DE CNV DEL FORMULARIO    
 SELECT @FechaCNV = ValorFecha FROM FONDOSPARAM           
 WHERE FONDOSPARAM.CodParametroFdo = 'FRCNV' AND FONDOSPARAM.CodFondo = @CodFondo   

    -- ESCRIBO FECHA DE CONCERTACION DE LA SOLICITUD   
	EXEC spExpresionFecha 2, @FechaCNV, 0, @FechaEnLetras OUTPUT
	            -----------------------------------------------------------------------------------------------------------------   -- BUSCO PERSONAS DEL CUOTAPARTISTA        
	  create table #Personas  
	             (CodPersona numeric(10)             ,
				  Nombre varchar(200)              , 
				  NumDocumento varchar(15)             , 
				  TpDocIdentidad varchar(6)             , 
				  CUIT varchar(15)             ,
				   CUIL varchar(15)      ,
				    CDI varchar(15))         
					
exec spBuscoPersonas @CodCuotapartista     

declare @Nombre varchar(200)    
declare @NumDocumento varchar(15)    
declare @TpDocIdentidad varchar(6)    
declare @CUIT varchar(15)     
declare @CUIL varchar(15)   
declare @CDI varchar(15)    
declare @PNOM1 varchar(200)     
declare @PNDI1 varchar(15)   
declare @PTPDI1 varchar(6)    
declare @PNOM2 varchar(200)           declare @PNDI2 varchar(15)          declare @PTPDI2 varchar(6)          declare @PNOM3 varchar(200)           declare @PNDI3 varchar(15)          declare @PTPDI3 varchar(6)        DECLARE PERSONAS_CURSOR CURSOR FOR       SELECT Nombre, NumDocumento, TpDocIdentidad, CUIT, CUIL, CDI      FROM #Personas        OPEN PERSONAS_CURSOR      FETCH NEXT FROM PERSONAS_CURSOR INTO @Nombre, @NumDocumento, @TpDocIdentidad, @CUIT, @CUIL, @CDI         IF @@FETCH_STATUS = 0       BEGIN     SELECT @PNOM1 = CASE WHEN @Nombre = '' THEN NULL ELSE @Nombre END           SELECT @PTPDI1 = CASE WHEN @TpDocIdentidad = '' or @NumDocumento = '' THEN NULL ELSE @TpDocIdentidad END           SELECT @PNDI1 = CASE WHEN @NumDocumento = '' THEN NULL ELSE @NumDocumento END      END      FETCH NEXT FROM PERSONAS_CURSOR INTO @Nombre, @NumDocumento, @TpDocIdentidad, @CUIT, @CUIL, @CDI         IF @@FETCH_STATUS = 0      BEGIN     SELECT @PNOM2 = CASE WHEN @Nombre = '' THEN NULL ELSE @Nombre END           SELECT @PTPDI2 = CASE WHEN @TpDocIdentidad = '' or @NumDocumento = '' THEN NULL ELSE @TpDocIdentidad END           SELECT @PNDI2 = CASE WHEN @NumDocumento = '' THEN NULL ELSE @NumDocumento END      END      FETCH NEXT FROM PERSONAS_CURSOR INTO @Nombre, @NumDocumento, @TpDocIdentidad, @CUIT, @CUIL, @CDI         IF @@FETCH_STATUS = 0      BEGIN     SELECT @PNOM3 = CASE WHEN @Nombre = '' THEN NULL ELSE @Nombre END           SELECT @PTPDI3 = CASE WHEN @TpDocIdentidad = '' or @NumDocumento = '' THEN NULL ELSE @TpDocIdentidad END           SELECT @PNDI3 = CASE WHEN @NumDocumento = '' THEN NULL ELSE @NumDocumento END      END      FETCH NEXT FROM PERSONAS_CURSOR INTO @Nombre, @NumDocumento, @TpDocIdentidad, @CUIT, @CUIL, @CDI         CLOSE PERSONAS_CURSOR      DEALLOCATE PERSONAS_CURSOR    ---------------------------------------------------------------------------------------------------------------     
DECLARE @CantCuotasTotal         NUMERIC(22,8)            SELECT @CantCuotasTotal = COALESCE(SUM(SALDO.CantCuotapartes),0)            FROM LIQUIDACIONES AS SALDO            WHERE SALDO.CodFondo = @CodFondo              AND SALDO.CodCuotapartista = @CodCuotapartista             AND SALDO.CodTpValorCp = @CodTpValorCp             AND SALDO.EstaAnulado = 0             AND SALDO.FechaConcertacion < @FechaConcertacion            SELECT @CantCuotasTotal = COALESCE(@CantCuotasTotal,0) + COALESCE(SUM(SALDO.CantCuotapartes),0)            FROM LIQUIDACIONES AS SALDO            WHERE SALDO.CodFondo = @CodFondo          AND SALDO.CodCuotapartista = @CodCuotapartista            AND SALDO.CodTpValorCp = @CodTpValorCp             AND SALDO.CodTpLiquidacion in ('RV','DV')           AND SALDO.EstaAnulado = 0          AND SALDO.FechaConcertacion = @FechaConcertacion            DECLARE @ImporteTxt varchar(255)             SELECT @CantCuotasTotal = COALESCE(@CantCuotasTotal,0) + COALESCE(SUM(SALDO.CantCuotapartes),0)            FROM LIQUIDACIONES AS SALDO            WHERE SALDO.CodFondo = @CodFondo             AND SALDO.CodCuotapartista = @CodCuotapartista          AND SALDO.CodTpValorCp = @CodTpValorCp             AND NOT SALDO.CodTpLiquidacion in ('RV','DV')              AND SALDO.CodLiquidacion <= @CodLiquidacion             AND SALDO.EstaAnulado = 0             AND SALDO.FechaConcertacion = @FechaConcertacion            EXEC spImporteALetras @Importe , -1, @ImporteTxt OUTPUT           DECLARE @CantTotalIngEgr    NUMERIC(22,8)     DECLARE @CuotasBloqueadas   NUMERIC(22,8)       SELECT @CantTotalIngEgr = COALESCE(SUM(SALDO.CantCuotapartes),0)      FROM LIQUIDACIONES AS SALDO       WHERE SALDO.CodFondo = @CodFondo       AND SALDO.CodCondicionIngEgr = @CodCondicionIngEgr       AND SALDO.CodCuotapartista = @CodCuotapartista       AND SALDO.CodTpValorCp = @CodTpValorCp    AND SALDO.EstaAnulado = 0    AND SALDO.FechaConcertacion < @FechaConcertacion       SELECT @CantTotalIngEgr = COALESCE(@CantTotalIngEgr,0) + COALESCE(SUM(SALDO.CantCuotapartes),0)      FROM LIQUIDACIONES AS SALDO       WHERE SALDO.CodFondo = @CodFondo       AND SALDO.CodCondicionIngEgr = @CodCondicionIngEgr       AND SALDO.CodCuotapartista = @CodCuotapartista       AND SALDO.CodTpValorCp = @CodTpValorCp          AND SALDO.CodTpLiquidacion in ('RV','DV')     AND SALDO.EstaAnulado = 0    AND SALDO.FechaConcertacion = @FechaConcertacion       SELECT @CantTotalIngEgr = COALESCE(@CantTotalIngEgr,0) + COALESCE(SUM(SALDO.CantCuotapartes),0)      FROM LIQUIDACIONES AS SALDO       WHERE SALDO.CodFondo = @CodFondo       AND SALDO.CodCondicionIngEgr = @CodCondicionIngEgr       AND SALDO.CodCuotapartista = @CodCuotapartista       AND SALDO.CodTpValorCp = @CodTpValorCp          AND NOT SALDO.CodTpLiquidacion in ('RV','DV')           AND SALDO.CodLiquidacion <= @CodLiquidacion    AND SALDO.EstaAnulado = 0    AND SALDO.FechaConcertacion = @FechaConcertacion       EXEC spXCantCuotapartesBloqueadas @CodFondo, @CodCuotapartista, @CodCondicionIngEgr, @FechaConcertacion,                                        @CuotasBloqueadas OUTPUT, @CantTotalIngEgr, @CodTpValorCp                                 insert #FRM_LIQUIDAC     (Numero,      NumRescTxt,      Estado,      FECHAC,        CodCuotapartista,      CUONOM,      CUONUM,      CUODOM,      CUOCP,      CUOLOC,      CUOTEL,      CodFondo,      FONDONOM,      NUMSOL,      NUMSUSCTXT,      CCUOTA,      MONSIM,      MONSIL,      SALCUO,      CUOBLO,      CUOTOT,      PORGAS,      VALCUO,      IMPGRE,      IMPMRB,      FONSD,      FONSG,      NOMSUC,      NRCNV,      RESCNV,      FECHAENLETRASCNV,      IMPTXT,      MONDESC,      TPVCP,      NOMAC,      NOMOC,      FCOBRO,      FECLIQ,      PNOM1,      PNRODOC1,      PTPDOC1,      PNOM2,      PNRODOC2,      PTPDOC2,      PNOM3,      PNRODOC3,      PTPDOC3,      bEsFisico,          bEsJuridico,      CUOCUIT,   NumFondo,   bEsAgColocPte,   bEsNotAgColocPte)         select              replicate('0',15-len(convert(varchar(20), LIQUIDACIONES.NumLiquidacion))) + convert(varchar(20), LIQUIDACIONES.NumLiquidacion)              ,@NumRescTxt              ,CASE WHEN LIQUIDACIONES.EstaAnulado = -1 THEN 'ANULADO' ELSE '' END  AS Estado              ,@Retorno as FECHAC              ,LIQUIDACIONES.CodCuotapartista              ,CUOTAPARTISTAS.Nombre              ,CUOTAPARTISTAS.NumCuotapartista               ,LTRIM(RTRIM(COALESCE(CUOTAPARTISTAS.Calle,''))) + CASE WHEN NOT CUOTAPARTISTAS.AlturaCalle IS NULL THEN ' ' + LTRIM(RTRIM(COALESCE(CUOTAPARTISTAS.AlturaCalle,''))) ELSE '' END + CASE WHEN NOT CUOTAPARTISTAS.Piso IS NULL THEN ' - PISO ' + LTRIM(RTRIM(COALESCE(CUOTAPARTISTAS.Piso,''))) ELSE '' END + CASE WHEN NOT CUOTAPARTISTAS.Departamento IS NULL THEN ' ''' + LTRIM(RTRIM(COALESCE(CUOTAPARTISTAS.Departamento,''))) + '''' ELSE '' END as CUODOM              ,CUOTAPARTISTAS.CodigoPostal              ,CUOTAPARTISTAS.Localidad              ,CUOTAPARTISTAS.Telefono              ,LIQUIDACIONES.CodFondo              ,(SELECT FONDOS.Nombre FROM FONDOSREAL FONDOS WHERE FONDOS.CodFondo = LIQUIDACIONES.CodFondo) AS FONDONOM              ,@NumSolicitud as NUMSOL              ,replicate('0',15-len(convert(varchar(20), @NumSolicitud))) + convert(varchar(20), @NumSolicitud)              ,ABS(LIQUIDACIONES.CantCuotapartes) AS CCUOTA              ,MONEFDO.Simbolo AS MONSIM              ,@MonedaSol as MONSIL              ,@CantCuotasTotal AS SALCUO              ,@CuotasBloqueadas AS CUOBLO              ,(@CantCuotasTotal - @CuotasBloqueadas)              ,@PorcGastos AS PORGAS              ,CASE WHEN FONDOS.CodTpFondo <> 'MM' THEN VALORCONCERTACION.ValorCuotaparte                    ELSE @ValorCuotaparte END as VALCUO              ,(coalesce(LIQUIDACIONES.ImporteGasto,0)) / @FactorConversion AS IMPGRE              ,(LIQUIDACIONES.Importe) / @FactorConversion AS IMPMRB       ,DEPOSITARIA.Descripcion              ,SOCIEDADESGTE.Descripcion              ,SUCURSALES.Descripcion AS NOMSUC              ,(SELECT RTRIM(CONVERT(VarChar, convert(Numeric(22,0),ValorNumero)))    FROM FONDOSPARAM    WHERE FONDOSPARAM.CodParametroFdo = 'NRCNV' AND      FONDOSPARAM.CodFondo = LIQUIDACIONES.CodFondo) AS NRCNV                ,(SELECT RTRIM(CONVERT(VarChar, ValorTexto))    FROM FONDOSPARAM    WHERE FONDOSPARAM.CodParametroFdo = 'RESCNV' AND      FONDOSPARAM.CodFondo = LIQUIDACIONES.CodFondo) AS RESCNV                ,case when isnull(@FechaEnLetras,'')='' THEN 'XX de XXXXXXXXXXXX de XXXX' ELSE @FechaEnLetras END  as FECHAENLETRASCNV              ,@ImporteTxt              ,MONEFDO.Descripcion              ,(SELECT TPVALOR.Descripcion FROM FONDOSREAL FONDOS INNER JOIN TPVALORESCP TPVALOR ON TPVALOR.CodFondo = FONDOS.CodFondo WHERE FONDOS.CodFondo = LIQUIDACIONES.CodFondo AND TPVALOR.CodTpValorCp = LIQUIDACIONES.CodTpValorCp) AS TPVCP              ,AGCOLOCRESC.Descripcion AS NOMAC              ,CASE WHEN OFICIALESCTA.NumOficialCta IS NULL                   THEN CASE WHEN OFICIALESCTA.Apellido is NULL OR LTRIM(RTRIM(OFICIALESCTA.Apellido)) = ''                             THEN COALESCE(OFICIALESCTA.Nombre, '')                             ELSE OFICIALESCTA.Apellido + ', ' + OFICIALESCTA.Nombre END                   ELSE RTRIM(LTRIM(CONVERT(VarChar(15),OFICIALESCTA.NumOficialCta))) + ' - ' +                         CASE WHEN OFICIALESCTA.Apellido is NULL OR LTRIM(RTRIM(OFICIALESCTA.Apellido)) = ''                             THEN COALESCE(OFICIALESCTA.Nombre, '')                             ELSE OFICIALESCTA.Apellido + ', ' + OFICIALESCTA.Nombre END                   END AS NOMOC    ,CASE WHEN FORMASPAGO.CodTpFormaPago = 'CB'     THEN LTRIM(RTRIM(CPTCTASBANCARIAS.Descripcion)) + ' ' + CASE WHEN CPTCTASBANCARIAS.CBU IS NULL THEN LTRIM(RTRIM(CPTCTASBANCARIAS.NumeroCuenta)) ELSE 'CBU Nº' + LTRIM(RTRIM(CPTCTASBANCARIAS.CBU)) END    ELSE FORMASPAGO.Descripcion END AS FCOBRO    ,CONVERT(varchar, DATEPART(DD, LIQUIDACIONES.FechaLiquidacion)) +'-'+    CASE     WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='1' then 'Ene'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='2' then 'Feb'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='3' then 'Mar'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='4' then 'Abr'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='5' then 'May'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='6' then 'Jun'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='7' then 'Jul'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='8' then 'Ago'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='9' then 'Sep'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='10' then 'Oct'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='11' then 'Nov'    WHEN CONVERT(varchar, DATEPART(MM, LIQUIDACIONES.FechaLiquidacion))='12' then 'Dic'    END +'-'+    RIGHT(CONVERT(VARCHAR(8), LIQUIDACIONES.FechaLiquidacion, 1),2)         ,@PNOM1        ,@PNDI1        ,@PTPDI1       ,@PNOM2        ,@PNDI2        ,@PTPDI2       ,@PNOM3        ,@PNDI3        ,@PTPDI3              ,CUOTAPARTISTAS.EsPersonaFisica   ,CASE WHEN CUOTAPARTISTAS.EsPersonaFisica = -1 THEN 0 ELSE -1 END     ,CASE WHEN CPTJURIDICOS.CUIT IS NULL OR CPTJURIDICOS.CUIT = 0 THEN REPLICATE(' ', 13)        ELSE RTRIM(SUBSTRING(CONVERT(VarChar(11),CPTJURIDICOS.CUIT), 1,2)) + '-' +           RTRIM(SUBSTRING(CONVERT(VarChar(11),CPTJURIDICOS.CUIT), 3, LEN(CONVERT(VarChar(11),CPTJURIDICOS.CUIT)) - 3)) + '-' +           RTRIM(SUBSTRING(CONVERT(VarChar(11),CPTJURIDICOS.CUIT), LEN(CONVERT(VarChar(11),CPTJURIDICOS.CUIT)),1)) END     ,FONDOS.NumFondo     ,CASE WHEN SOLRESC.CodAgColocador = 5 THEN -1 ELSE 0 END     ,CASE WHEN SOLRESC.CodAgColocador = 5 THEN 0 ELSE -1 END           from LIQUIDACIONES                LEFT JOIN VALORESCP AS VALORCONCERTACION ON VALORCONCERTACION.Fecha = LIQUIDACIONES.FechaConcertacion                                                    AND VALORCONCERTACION.CodFondo = LIQUIDACIONES.CodFondo                                                    AND VALORCONCERTACION.CodTpValorCp = LIQUIDACIONES.CodTpValorCp                 INNER JOIN FONDOSREAL FONDOS        INNER JOIN AGCOLOCADORES DEPOSITARIA ON DEPOSITARIA.CodAgColocador = FONDOS.CodAgColocadorDep       INNER JOIN SOCIEDADESGTE ON SOCIEDADESGTE.CodSociedadGte = FONDOS.CodSociedadGte                        INNER JOIN MONEDAS MONEFDO ON MONEFDO.CodMoneda = FONDOS.CodMoneda                ON FONDOS.CodFondo = LIQUIDACIONES.CodFondo                 INNER JOIN SUCURSALES ON LIQUIDACIONES.CodSucursal = SUCURSALES.CodSucursal                                      AND LIQUIDACIONES.CodAgColocador = SUCURSALES.CodAgColocador         INNER JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista = LIQUIDACIONES.CodCuotapartista                 INNER JOIN SOLRESC ON LIQUIDACIONES.CodFondo = SOLRESC.CodFondo AND LIQUIDACIONES.CodAgColocador = SOLRESC.CodAgColocador                                  AND LIQUIDACIONES.CodSucursal = SOLRESC.CodSucursal AND LIQUIDACIONES.CodSolResc = SOLRESC.CodSolResc                INNER JOIN AGCOLOCADORES AGCOLOCRESC ON AGCOLOCRESC.CodAgColocador = SOLRESC.CodAgColocador                                LEFT JOIN CPTJURIDICOS ON CPTJURIDICOS.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista                INNER JOIN OFICIALESCTA ON OFICIALESCTA.CodAgColocador = SOLRESC.CodAgColocador AND OFICIALESCTA.CodSucursal = SOLRESC.CodSucursal                                      AND OFICIALESCTA.CodOficialCta = SOLRESC.CodOficialCta                INNER JOIN FORMASPAGO ON SOLRESC.CodFormaPago = FORMASPAGO.CodFormaPago                LEFT JOIN CPTCTASBANCARIAS                      INNER JOIN TPCTABANCARIA ON CPTCTASBANCARIAS.CodTpCtaBancaria = TPCTABANCARIA.CodTpCtaBancaria                     INNER JOIN MONEDAS AS MONEDASCPTCTAS ON CPTCTASBANCARIAS.CodMoneda = MONEDASCPTCTAS.CodMoneda                ON SOLRESC.CodCuotapartista = CPTCTASBANCARIAS.CodCuotapartista AND SOLRESC.CodCtaBancaria = CPTCTASBANCARIAS.CodCtaBancaria             where LIQUIDACIONES.CodLiquidacion IN (@WHERE)       UPDATE #FRM_LIQUIDAC       SET  CUOTEXTNUM = replace(replace(convert(varchar(15),CUONUM),'.',''),',','')    update #FRM_LIQUIDAC   set bVisibleBV = case when NumFondo in  (1,2,5,9,11,12,13,15,16,17,19) then -1 else 0 end,    bVisibleDB = case when NumFondo in (3,4,6,7,8,10,14,18)  then -1 else 0 end       
	   
	  
DECLARE @DecCCtas  NUMERIC(3)   
DECLARE @DecVCCtas  NUMERIC(3)   
CREATE TABLE #FORMATOS    (     Formato  VARCHAR(30)    ,Enteros NUMERIC(3)    ,Decimales NUMERIC(3)    ,DecTxt  VARCHAR(30)    )     

SELECT  @CodFondo=CodFondo   FROM LIQUIDACIONES   WHERE LIQUIDACIONES.CodLiquidacion IN (@WHERE)       INSERT INTO #FORMATOS (Formato,Enteros,Decimales,DecTxt)   

EXEC dbo.spGetFormatos @CodFondo,'PFD_ADJRNU', ',', '.'  

--- Cantidad de Cuotas    
IF exists(SELECT * FROM #FORMATOS)  
select @DecCCtas=isnull(Decimales,0) 
from #FORMATOS   
else   
select @DecCCtas=0  
	
DELETE FROM #FORMATOS  
INSERT INTO #FORMATOS (Formato,Enteros,Decimales,DecTxt)  
	  
	EXEC dbo.spGetFormatos @CodFondo,'FDO_61', ',', '.'  

   
  

select      Numero,      Estado,        FECHAC,        CodCuotapartista,      CUONOM,    
CUONUM,   CUOTEXTNUM,      CUODOM,      CUOCP,      CUOLOC,      CUOTEL,      CodFondo,   
FONDONOM,      NUMSOL,      NUMSUSCTXT,      CCUOTA,      MONSIM,      MONSIL,   
SALCUO,      CUOBLO,      CUOTOT,      PORGAS,      VALCUO,      IMPGRE,   
IMPMRB,      FONSD,      FONSG,      NOMSUC,      NRCNV,      RESCNV,    
FECHAENLETRASCNV,       NumRescTxt,      IMPTXT ,      MONDESC,      TPVCP,  
FCOBRO,      NOMAC,      NOMOC,      FECLIQ,      PNOM1,      PNRODOC1,   
PTPDOC1,      PNOM2,      PNRODOC2,      PTPDOC2,      PNOM3,      PNRODOC3,   
PTPDOC3,      bEsFisico,         bEsJuridico,      CUOCUIT,
NumFondo,   bVisibleBV,   bVisibleDB,   bEsAgColocPte,   bEsNotAgColocPte     
from #FRM_LIQUIDAC   



DROP TABLE #FORMATOS
DROP TABLE #Personas
DROP TABLE #FRM_LIQUIDAC
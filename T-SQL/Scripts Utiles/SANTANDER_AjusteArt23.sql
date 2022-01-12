
EXEC sp_CreateProcedure 'dbo.spINFO_InterfazCNVMensual_Residencia'
GO

ALTER PROCEDURE dbo.spINFO_InterfazCNVMensual_Residencia
    @CodFondo CodigoMedio = NULL,
	@Fecha Fecha = NULL,
    @PersonasFisicasQ NumeroLargo = NULL OUTPUT,
    @PersonasFisicasMonto Importe = NULL OUTPUT,
    @PersonasJuridicasQ NumeroLargo = NULL OUTPUT,
    @PersonasJuridicasMonto Importe = NULL OUTPUT
WITH ENCRYPTION
AS

    DECLARE @FechaVCP   Fecha
    DECLARE @CodTpFondo CodigoTextoCorto

    SELECT  @FechaVCP = MAX(Fecha) FROM VALORESCP WHERE VALORESCP.CodFondo = @CodFondo AND VALORESCP.Fecha <= @Fecha
    SELECT  @CodTpFondo = CodTpFondo FROM FONDOSREAL WHERE CodFondo=@CodFondo

    CREATE TABLE #CAFCIMENSUAL_LIQ
       (CodTpValorCp numeric(5) NOT NULL,
        CodCuotapartista numeric(10) NOT NULL,
        CantCuotapartes numeric(22, 8))

    INSERT INTO #CAFCIMENSUAL_LIQ (CodTpValorCp, CodCuotapartista, CantCuotapartes)
		SELECT  CodTpValorCp, CodCuotapartista, SUM(CantCuotapartes) AS CantCuotapartes
		FROM    LIQUIDACIONES
		WHERE   CodFondo = @CodFondo AND FechaConcertacion <= @FechaVCP AND EstaAnulado = 0
		GROUP BY CodTpValorCp, CodCuotapartista
		HAVING SUM(CantCuotapartes) <> 0
		ORDER BY CodTpValorCp, CodCuotapartista
   	
   
   	SELECT		'RESIDENCIA CUOTAPARTISTAS,PAÍS',
				--'RESIDENCIA CUOTAPARTISTAS,CANTIDAD DE CUOTAPARTES POR PAÍS DE RESIDENCIA DEL CUOTAPARTISTA',
				'RESIDENCIA CUOTAPARTISTAS,CANTIDAD DE COMITENTES POR PAÍS DE RESIDENCIA DEL CUOTAPARTISTA',
				'RESIDENCIA CUOTAPARTISTAS,MONTO TOTAL POR PAÍS DE RESIDENCIA DEL CUOTAPARTISTA'
    

    IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_TIPO_PERSONA')) 
	BEGIN
        SELECT  
				@PersonasFisicasQ = ISNULL(SUM(CASE Persona WHEN 'F' THEN Cantidad ELSE 0 END), 0),
                @PersonasFisicasMonto = ISNULL(SUM(CASE Persona WHEN 'F' THEN Monto ELSE 0 END), 0),
                @PersonasJuridicasQ = ISNULL(SUM(CASE Persona WHEN 'J' THEN Cantidad ELSE 0 END), 0),
                @PersonasJuridicasMonto = ISNULL(SUM(CASE Persona WHEN 'J' THEN Monto ELSE 0 END), 0)
        FROM    
				FM_MONTO_POR_TIPO_PERSONA
        INNER JOIN CONDICIONESINGEGR ON FM_MONTO_POR_TIPO_PERSONA.Fondo = convert(numeric(5),CONDICIONESINGEGR.CodInterfaz)
				AND CONDICIONESINGEGR.CodFondo = @CodFondo
				and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
        WHERE   Fecha = @FechaVCP
    END
    ELSE 
	BEGIN
        IF @CodTpFondo='MM' 
		BEGIN
            SELECT  
						@PersonasFisicasQ = ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
						@PersonasFisicasMonto = ISNULL(SUM(CantCuotapartes * ValorCpInicial), 0)
            FROM    
						#CAFCIMENSUAL_LIQ
			INNER JOIN CUOTAPARTISTAS  ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista  AND EsPersonaFisica = -1
			INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = @CodFondo  AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp

            SELECT  
					@PersonasJuridicasQ = ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    @PersonasJuridicasMonto = ISNULL(SUM(CantCuotapartes * ValorCpInicial), 0)
            FROM    
					#CAFCIMENSUAL_LIQ
			INNER JOIN CUOTAPARTISTAS  ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista AND EsPersonaFisica = 0
			INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = @CodFondo  AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp         
        END
        ELSE 
		BEGIN
            SELECT  
					@PersonasFisicasQ = ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    @PersonasFisicasMonto = ISNULL(SUM(CantCuotapartes * ValorCuotaparte), 0)
            FROM   
					#CAFCIMENSUAL_LIQ
			INNER JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista AND EsPersonaFisica = -1
			INNER JOIN VALORESCP ON VALORESCP.CodFondo = @CodFondo  AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp  AND VALORESCP.Fecha = @FechaVCP
            
            SELECT  
					@PersonasJuridicasQ = ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    @PersonasJuridicasMonto = ISNULL(SUM(CantCuotapartes * ValorCuotaparte), 0)
            FROM   
					#CAFCIMENSUAL_LIQ
			INNER JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista AND EsPersonaFisica = 0
			INNER JOIN VALORESCP ON VALORESCP.CodFondo = @CodFondo AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp AND VALORESCP.Fecha = @FechaVCP
        END
    END
	
	-- Escribo y configuro las cabeceras

    IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_PAIS_RESIDENCIA')) BEGIN

        SELECT  ISNULL(PAISES.Descripcion, '') AS PaisNombre,
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Cantidad), 0) AS Q,
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Monto), 0) AS Monto
        FROM    FM_MONTO_POR_PAIS_RESIDENCIA
        INNER JOIN CONDICIONESINGEGR ON FM_MONTO_POR_PAIS_RESIDENCIA.Fondo = convert(numeric(5),CONDICIONESINGEGR.CodInterfaz)
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
        LEFT JOIN PAISES ON PAISES.CodPais = FM_MONTO_POR_PAIS_RESIDENCIA.PaisResidencia
        WHERE  datediff(d, FM_MONTO_POR_PAIS_RESIDENCIA.Fecha, @FechaVCP) = 0
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
        GROUP BY PAISES.Descripcion

    END
    ELSE BEGIN
        IF @CodTpFondo='MM' BEGIN
            SELECT ISNULL(PAISES.Descripcion, '') AS PaisNombre,
                    --ISNULL(SUM(CantCuotapartes), 0) AS Q,
					ISNULL(COUNT(DISTINCT #CAFCIMENSUAL_LIQ.CodCuotapartista), 0) AS Q,
                    ISNULL(SUM(ROUND(CantCuotapartes * ValorCpInicial,0)), 0) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
            GROUP BY 
                    ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais
        END
        ELSE BEGIN
            SELECT 
                    ISNULL(PAISES.Descripcion, '') AS PaisNombre,
                    --ISNULL(SUM(CantCuotapartes), 0) AS Q,
					ISNULL(COUNT(DISTINCT #CAFCIMENSUAL_LIQ.CodCuotapartista), 0) AS Q,
                    ISNULL(SUM(ROUND(CantCuotapartes * ValorCuotaparte,2)), 0.00) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP
            GROUP BY ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais        
        END
    END

GO

 /*
	ESCO - TOC2013  - Interfaz de CAFCI Mensual - DES
*/

EXEC sp_CreateProcedure 'dbo.spINFO_InterfazCNVMensual_Liq_TOC2013'
GO

ALTER PROCEDURE dbo.spINFO_InterfazCNVMensual_Liq_TOC2013
    @CodFondo CodigoMedio = NULL,
	@Fecha Fecha = NULL 
WITH ENCRYPTION
AS

    DECLARE @FechaVCP   Fecha
    DECLARE @CodTpFondo CodigoTextoCorto

    SELECT  @FechaVCP = MAX(Fecha) FROM VALORESCP WHERE VALORESCP.CodFondo = @CodFondo AND VALORESCP.Fecha <= @Fecha
    SELECT  @CodTpFondo = CodTpFondo FROM FONDOSREAL WHERE CodFondo=@CodFondo

	CREATE TABLE #CNVMENSUAL_INVERSORES_TOC2013OUT
    (
	SubTipoDescripcion varchar(80) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL ,
	CodInterfaz varchar(30) COLLATE SQL_Latin1_General_CP1_CS_AS NULL, 
	Campo_Q numeric (15) not null, 
	Campo_Monto numeric(19,2) not null
	)
	
    CREATE TABLE #CAFCIMENSUAL_LIQ
       (CodTpValorCp numeric(5) NOT NULL,
        CodCuotapartista numeric(10) NOT NULL,
        CantCuotapartes numeric(22, 8))

    INSERT INTO #CAFCIMENSUAL_LIQ (CodTpValorCp, CodCuotapartista, CantCuotapartes)
    SELECT  CodTpValorCp, CodCuotapartista, SUM(CantCuotapartes) AS CantCuotapartes
    FROM    LIQUIDACIONES
    WHERE   CodFondo = @CodFondo AND FechaConcertacion <= @FechaVCP AND EstaAnulado = 0
    GROUP BY CodTpValorCp, CodCuotapartista
    HAVING SUM(CantCuotapartes) <> 0
    ORDER BY CodTpValorCp, CodCuotapartista
   	
	
    IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_TIPO_DE_INVERSOR')) 
	BEGIN
       INSERT INTO #CNVMENSUAL_INVERSORES_TOC2013OUT 
				(SubTipoDescripcion,CodInterfaz, Campo_Q , Campo_Monto)
		SELECT isnull(Inversor,'     '), NULL, Cantidad, Monto 
		FROM FM_MONTO_POR_TIPO_DE_INVERSOR
        INNER JOIN CONDICIONESINGEGR ON convert(numeric(5),CONDICIONESINGEGR.CodInterfaz) = FM_MONTO_POR_TIPO_DE_INVERSOR.Fondo
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
        WHERE Fecha = @FechaVCP
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
		
		--*- Salida de los Resultados
		SELECT 
			COALESCE (TPINVERSORES.Descripcion, #CNVMENSUAL_INVERSORES_TOC2013OUT.SubTipoDescripcion,'     ') AS 'CodigoSubTipo', 
			sum(Campo_Q) AS Campo_Q, 
			sum(Campo_Monto) AS Campo_Monto
		FROM #CNVMENSUAL_INVERSORES_TOC2013OUT
		LEFT JOIN TPINVERSORES 
			ON #CNVMENSUAL_INVERSORES_TOC2013OUT.SubTipoDescripcion = TPINVERSORES.CodCAFCI
		GROUP BY TPINVERSORES.Descripcion, #CNVMENSUAL_INVERSORES_TOC2013OUT.SubTipoDescripcion
    END
	ELSE IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_TIPO_PERSONA')) 
	BEGIN
		 
        INSERT INTO #CNVMENSUAL_INVERSORES_TOC2013OUT 
				(SubTipoDescripcion,CodInterfaz, Campo_Q , Campo_Monto )

		SELECT 
		dbo.fnTraerCNVDescripcionDefault(CASE WHEN UPPER(FM_MONTO_POR_TIPO_PERSONA.Persona) ='F' THEN -1 ELSE 0 END) AS CodigoSubTipo, 
		NULL, 
		FM_MONTO_POR_TIPO_PERSONA.Cantidad, 
		FM_MONTO_POR_TIPO_PERSONA.Monto 
		FROM FM_MONTO_POR_TIPO_PERSONA
        INNER JOIN CONDICIONESINGEGR ON convert(numeric(5),CONDICIONESINGEGR.CodInterfaz) = FM_MONTO_POR_TIPO_PERSONA.Fondo
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
        WHERE FM_MONTO_POR_TIPO_PERSONA.Fecha = @FechaVCP
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''

		--Salida de los Resultados
		SELECT 
			COALESCE (TPINVERSORES.Descripcion , #CNVMENSUAL_INVERSORES_TOC2013OUT.SubTipoDescripcion) AS 'CodigoSubTipo', 
			sum(Campo_Q) AS Campo_Q, 
			sum(Campo_Monto) AS Campo_Monto
		FROM #CNVMENSUAL_INVERSORES_TOC2013OUT
		LEFT JOIN TPINVERSORES 
			ON #CNVMENSUAL_INVERSORES_TOC2013OUT.SubTipoDescripcion = TPINVERSORES.CodCAFCI
		GROUP BY TPINVERSORES.Descripcion, #CNVMENSUAL_INVERSORES_TOC2013OUT.SubTipoDescripcion
    END
    ELSE 
	BEGIN

			--Involucrar los que tienen configurado TIPO DE INVERSOR en el cuotapartista
            INSERT INTO #CNVMENSUAL_INVERSORES_TOC2013OUT 
				(SubTipoDescripcion,CodInterfaz, Campo_Q , Campo_Monto)
            SELECT  TPINVERSORES.Descripcion,
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
					INNER JOIN TPINVERSORES ON CUOTAPARTISTAS.CodTpInversor =TPINVERSORES.CodTpInversor
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
					INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP

			GROUP BY TPINVERSORES.Descripcion




			--Involucrar los que tienen configurado TIPO DE INVERSOR en el Segmento de Inversión (porque no lo tienen en el cuotapartista), 
            INSERT INTO #CNVMENSUAL_INVERSORES_TOC2013OUT 
				(SubTipoDescripcion,CodInterfaz, Campo_Q , Campo_Monto)
            SELECT  TPINVERSORES.Descripcion,
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
					INNER JOIN SEGMENTOSINV 
							ON CUOTAPARTISTAS.CodSegmentoInv = SEGMENTOSINV.CodSegmentoInv
						   AND CUOTAPARTISTAS.EsPersonaFisica = SEGMENTOSINV.EsPersonaFisica
					INNER JOIN TPINVERSORES 
							ON SEGMENTOSINV.CodTpInversor = TPINVERSORES.CodTpInversor
						   AND SEGMENTOSINV.EsPersonaFisica = TPINVERSORES.EsPersonaFisica
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
					INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP
			WHERE	CUOTAPARTISTAS.CodTpInversor is null
			GROUP BY TPINVERSORES.Descripcion




			--Involucrar los sin configurar al defecto segun campo EsPersonaFísica
            INSERT INTO #CNVMENSUAL_INVERSORES_TOC2013OUT 
				(SubTipoDescripcion,CodInterfaz, Campo_Q , Campo_Monto)
			SELECT  dbo.fnTraerCNVDescripcionDefault(CUOTAPARTISTAS.EsPersonaFisica),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS 
						 ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
					LEFT JOIN SEGMENTOSINV 
						 ON CUOTAPARTISTAS.CodSegmentoInv = SEGMENTOSINV.CodSegmentoInv
					LEFT JOIN TPINVERSORES 
						 ON SEGMENTOSINV.CodTpInversor = TPINVERSORES.CodTpInversor
					INNER JOIN TPVALORESCP
                         ON TPVALORESCP.CodFondo = @CodFondo
                        AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
					INNER JOIN VALORESCP
                         ON VALORESCP.CodFondo = @CodFondo
                        AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                        AND VALORESCP.Fecha = @FechaVCP

			WHERE   (
						CUOTAPARTISTAS.CodSegmentoInv is null
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND SEGMENTOSINV.CodTpInversor is null)
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND (SEGMENTOSINV.EsPersonaFisica <> CUOTAPARTISTAS.EsPersonaFisica))
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND (TPINVERSORES.EsPersonaFisica <> CUOTAPARTISTAS.EsPersonaFisica))
					)
					AND CUOTAPARTISTAS.CodTpInversor is null
			GROUP BY dbo.fnTraerCNVDescripcionDefault(CUOTAPARTISTAS.EsPersonaFisica)

			SELECT 
				SubTipoDescripcion AS CodigoSubTipo, 
				sum(Campo_Q) AS Campo_Q, 
				sum(Campo_Monto) AS Campo_Monto
			FROM #CNVMENSUAL_INVERSORES_TOC2013OUT
			GROUP BY SubTipoDescripcion
    END
GO


EXEC sp_CreateProcedure 'dbo.spINFO_InterfazCNVMensual_Residencia_TOC2013'
GO


ALTER PROCEDURE dbo.spINFO_InterfazCNVMensual_Residencia_TOC2013
    @CodFondo CodigoMedio = NULL,
	@Fecha Fecha = NULL
WITH ENCRYPTION
AS

    DECLARE @FechaVCP   Fecha
    DECLARE @CodTpFondo CodigoTextoCorto

    SELECT  @FechaVCP = MAX(Fecha) FROM VALORESCP WHERE VALORESCP.CodFondo = @CodFondo AND VALORESCP.Fecha <= @Fecha
    SELECT  @CodTpFondo = CodTpFondo FROM FONDOSREAL WHERE CodFondo=@CodFondo

    CREATE TABLE #CAFCIMENSUAL_LIQ
       (CodTpValorCp numeric(5) NOT NULL,
        CodCuotapartista numeric(10) NOT NULL,
        CantCuotapartes numeric(22, 8))

    INSERT INTO #CAFCIMENSUAL_LIQ (CodTpValorCp, CodCuotapartista, CantCuotapartes)
		SELECT  CodTpValorCp, CodCuotapartista, SUM(CantCuotapartes) AS CantCuotapartes
		FROM    LIQUIDACIONES
		WHERE   CodFondo = @CodFondo AND FechaConcertacion <= @FechaVCP AND EstaAnulado = 0
		GROUP BY CodTpValorCp, CodCuotapartista
		HAVING SUM(CantCuotapartes) <> 0
		ORDER BY CodTpValorCp, CodCuotapartista
	
	

   		SELECT		'RESIDENCIA CUOTAPARTISTAS,PAÍS',
					--'RESIDENCIA CUOTAPARTISTAS,CANTIDAD DE CUOTAPARTES POR PAÍS DE RESIDENCIA DEL CUOTAPARTISTA',
					'RESIDENCIA CUOTAPARTISTAS,CANTIDAD DE COMITENTES POR PAÍS DE RESIDENCIA DEL CUOTAPARTISTA',
					'RESIDENCIA CUOTAPARTISTAS,MONTO TOTAL POR PAÍS DE RESIDENCIA DEL CUOTAPARTISTA'
    
	-- Escribo y configuro las cabeceras
    IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_PAIS_RESIDENCIA')) BEGIN

        SELECT  ISNULL(PAISES.Descripcion, '') AS PaisNombre,
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Cantidad), 0) AS Q,
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Monto), 0) AS Monto
        FROM    FM_MONTO_POR_PAIS_RESIDENCIA
        INNER JOIN CONDICIONESINGEGR ON FM_MONTO_POR_PAIS_RESIDENCIA.Fondo = convert(numeric(5),CONDICIONESINGEGR.CodInterfaz)
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
        LEFT JOIN PAISES ON PAISES.CodPais = FM_MONTO_POR_PAIS_RESIDENCIA.PaisResidencia
        WHERE  datediff(d, FM_MONTO_POR_PAIS_RESIDENCIA.Fecha, @FechaVCP) = 0
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
        GROUP BY PAISES.Descripcion

    END
    ELSE BEGIN
        IF @CodTpFondo='MM' BEGIN
            SELECT ISNULL(PAISES.Descripcion, '') AS PaisNombre,
                    --ISNULL(SUM(CantCuotapartes), 0),
					ISNULL(COUNT(DISTINCT #CAFCIMENSUAL_LIQ.CodCuotapartista), 0) AS Q,
                    ISNULL(SUM(ROUND(CantCuotapartes * ValorCpInicial,0)), 0) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
            GROUP BY 
                    ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais
        END
        ELSE BEGIN
            SELECT 
                    ISNULL(PAISES.Descripcion, '') AS PaisNombre,
                    --ISNULL(SUM(CantCuotapartes), 0),
					ISNULL(COUNT(DISTINCT #CAFCIMENSUAL_LIQ.CodCuotapartista), 0) AS Q,
                    ISNULL(SUM(ROUND(CantCuotapartes * ValorCuotaparte,2)), 0.00) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP
            GROUP BY ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais        
        END
    END

GO




exec sp_CreateProcedure 'dbo.spGDIN_CAFCIUnificada_Tag_Inversor'
go
alter procedure dbo.spGDIN_CAFCIUnificada_Tag_Inversor
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as

	DECLARE @FechaVCP   Fecha
    DECLARE @CodTpFondo CodigoTextoCorto

    SELECT  @FechaVCP = MAX(Fecha) FROM VALORESCP WHERE VALORESCP.CodFondo = @CodFondo AND VALORESCP.Fecha <= @FechaProceso
    SELECT  @CodTpFondo = CodTpFondo FROM FONDOSREAL WHERE CodFondo=@CodFondo

    CREATE TABLE #CAFCIMENSUAL_INVERSORES_TOC2013OUT
       (
		CodigoSubTipo varchar(30) not null,
		CodInterfaz varchar(30) null, 
		Campo_Q numeric (15) not null, 
		Campo_Monto numeric(19,2) not null
		)

    CREATE TABLE #CAFCIMENSUAL_LIQ
       (CodTpValorCp numeric(5) NOT NULL,
        CodCuotapartista numeric(10) NOT NULL,
        CantCuotapartes numeric(22, 8))

	--Busco informacion básica
	
    INSERT INTO #CAFCIMENSUAL_LIQ (CodTpValorCp, CodCuotapartista, CantCuotapartes)
    SELECT  LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista, SUM(LIQUIDACIONES.CantCuotapartes) AS CantCuotapartes
    FROM    LIQUIDACIONES
    WHERE   LIQUIDACIONES.CodFondo = @CodFondo AND FechaConcertacion <= @FechaVCP AND EstaAnulado = 0
    GROUP BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista 
    HAVING SUM(LIQUIDACIONES.CantCuotapartes) <> 0
    ORDER BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista
	
	
    IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_TIPO_DE_INVERSOR')) 
	BEGIN

		
		INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
		SELECT isnull(Inversor,'     '), 
			NULL, 
			Cantidad, 
			Monto 
		FROM FM_MONTO_POR_TIPO_DE_INVERSOR
        INNER JOIN CONDICIONESINGEGR			
			ON FM_MONTO_POR_TIPO_DE_INVERSOR.Fondo = CONVERT(NUMERIC(5),CONDICIONESINGEGR.CodInterfaz)
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
        WHERE Fecha = @FechaVCP
        
    END
	ELSE IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_TIPO_PERSONA')) 
	BEGIN
		
        INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT 
				(CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
		SELECT 
		dbo.fnTraerCodCAFCIDefault(CASE WHEN UPPER(FM_MONTO_POR_TIPO_PERSONA.Persona) = 'F' THEN -1 ELSE 0 END) AS CodigoSubTipo, 
		NULL,
		FM_MONTO_POR_TIPO_PERSONA.Cantidad, 
		FM_MONTO_POR_TIPO_PERSONA.Monto 
		FROM FM_MONTO_POR_TIPO_PERSONA
			INNER JOIN CONDICIONESINGEGR 
			ON FM_MONTO_POR_TIPO_PERSONA.Fondo = CONVERT(NUMERIC(5),CONDICIONESINGEGR.CodInterfaz)            
			AND CONDICIONESINGEGR.CodFondo = @CodFondo
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
        WHERE FM_MONTO_POR_TIPO_PERSONA.Fecha = @FechaVCP
        
    END
    ELSE BEGIN
			
			--Involucrar los que tienen configurado TIPO DE INVERSOR en el cuotapartista
			INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
            SELECT  
    				isnull(TPINVERSORES.CodCAFCI,'     '),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
					INNER JOIN TPINVERSORES ON CUOTAPARTISTAS.CodTpInversor =TPINVERSORES.CodTpInversor
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP

			GROUP BY  TPINVERSORES.CodCAFCI



			--Involucrar los que tienen configurado TIPO DE INVERSOR en el Segmento de Inversión (porque no lo tienen en el cuotapartista), 
			INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
            SELECT  
    				isnull(TPINVERSORES.CodCAFCI,'     '),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
					INNER JOIN SEGMENTOSINV 
							ON CUOTAPARTISTAS.CodSegmentoInv = SEGMENTOSINV.CodSegmentoInv
						   AND CUOTAPARTISTAS.EsPersonaFisica = SEGMENTOSINV.EsPersonaFisica
					INNER JOIN TPINVERSORES 
							ON SEGMENTOSINV.CodTpInversor = TPINVERSORES.CodTpInversor
						   AND SEGMENTOSINV.EsPersonaFisica = TPINVERSORES.EsPersonaFisica
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP

			WHERE	CUOTAPARTISTAS.CodTpInversor IS NULL
			GROUP BY  TPINVERSORES.CodCAFCI
			

			--Involucrar los que NO tienen configurado TIPO DE INVERSOR, asignándoles uno por default, según el campo EsPersonaFísica
			INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
            SELECT  
    				dbo.fnTraerCodCAFCIDefault(CUOTAPARTISTAS.EsPersonaFisica),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista 
					LEFT JOIN  SEGMENTOSINV 
							ON CUOTAPARTISTAS.CodSegmentoInv = SEGMENTOSINV.CodSegmentoInv
					LEFT JOIN TPINVERSORES 
						     ON SEGMENTOSINV.CodTpInversor = TPINVERSORES.CodTpInversor
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP
			WHERE   (
						CUOTAPARTISTAS.CodSegmentoInv is null
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND SEGMENTOSINV.CodTpInversor is null)
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND (SEGMENTOSINV.EsPersonaFisica <> CUOTAPARTISTAS.EsPersonaFisica))
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND (TPINVERSORES.EsPersonaFisica <> CUOTAPARTISTAS.EsPersonaFisica))
					)
					AND CUOTAPARTISTAS.CodTpInversor is null

			GROUP BY  dbo.fnTraerCodCAFCIDefault(CUOTAPARTISTAS.EsPersonaFisica)
        
    END

	create table #TEMP_FINAL 
	(
		SubTipoCod varchar(30) collate database_default not null,
		CodInterfaz varchar(30) collate database_default null, 
		Monto numeric (19,2) not null, 
		CantInv numeric(20) not null		
	)

	insert into #TEMP_FINAL (SubTipoCod, CodInterfaz, CantInv, Monto)
    SELECT 
		CodigoSubTipo, 
		CodInterfaz, 
		sum(Campo_Q) AS Campo_Q, 
		sum(Campo_Monto) AS Campo_Monto
	FROM #CAFCIMENSUAL_INVERSORES_TOC2013OUT
	group by CodigoSubTipo, CodInterfaz
	
	
	insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
	select '<Inversores>'
	
	if (select count(*) from #TEMP_FINAL) > 0
	begin
		insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
		SELECT  
			'<Inversor>' +
			case when coalesce(convert(varchar,SubTipoCod),'') = '' then '<SubTipoCod/>' else '<SubTipoCod>' + convert(varchar,SubTipoCod) + '</SubTipoCod>' end +
			case when coalesce(convert(varchar,convert(numeric(20,2),Monto)),'') = '' then '<Monto/>' else '<Monto>'  + convert(varchar,convert(numeric(20,2),Monto)) + '</Monto>' end +			
			case when coalesce(convert(varchar,convert(numeric(20),CantInv)),'') = '' then '<CantInv/>' else '<CantInv>' + convert(varchar,convert(numeric(20),CantInv)) + '</CantInv>' end +			
			'</Inversor>'
		FROM #TEMP_FINAL
		
		insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
		SELECT  
			'<Inversor>' +
			'<SubTipoCod>TOTAL</SubTipoCod>' +
			'<Monto>' + convert(varchar,convert(numeric(20,2),SUM(COALESCE(Monto,0)))) + '</Monto>' +			
			'<CantInv>' + convert(varchar,convert(numeric(20),SUM(COALESCE(CantInv,0)))) +  '</CantInv>' +			
			'</Inversor>'
		FROM #TEMP_FINAL
		

	end
	else
	begin
		insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
		SELECT  
			'<Inversor>' +
			'<SubTipoCod/>' +
			'<Monto/>' +			
			'<CantInv/>' +			
			'</Inversor>'
	end
	
	insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
	select '</Inversores>'
	
go




exec sp_CreateProcedure 'dbo.spGDIN_CAFCIUnificada_Tag_ResidenciaInversores'
go
alter procedure dbo.spGDIN_CAFCIUnificada_Tag_ResidenciaInversores
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @FechaVCP   Fecha
    DECLARE @CodTpFondo CodigoTextoCorto

    SELECT  @FechaVCP = MAX(Fecha) FROM VALORESCP WHERE VALORESCP.CodFondo = @CodFondo AND VALORESCP.Fecha <= @FechaProceso
    SELECT  @CodTpFondo = CodTpFondo FROM FONDOSREAL WHERE CodFondo=@CodFondo

  
    CREATE TABLE #CAFCIMENSUAL_LIQ
       (CodTpValorCp numeric(5) NOT NULL,
        CodCuotapartista numeric(10) NOT NULL,
        CantCuotapartes numeric(22, 8))


	--Busco informacion básica
    INSERT INTO #CAFCIMENSUAL_LIQ (CodTpValorCp, CodCuotapartista, CantCuotapartes)
    SELECT  LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista, SUM(LIQUIDACIONES.CantCuotapartes) AS CantCuotapartes
    FROM    LIQUIDACIONES
    WHERE   LIQUIDACIONES.CodFondo = @CodFondo AND FechaConcertacion <= @FechaVCP AND EstaAnulado = 0
    GROUP BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista
    HAVING SUM(LIQUIDACIONES.CantCuotapartes) <> 0
    ORDER BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista

	create table #TEMP_FINAL 
	(
		PaisTCod varchar(1) collate database_default,
		PaisNom	varchar(30) collate database_default,
		PaisCod varchar(80) collate database_default,
		MontoPais numeric(19,2) NOT NULL,
		CCPPais numeric(22,8)
	)

	IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_PAIS_RESIDENCIA')) 
	BEGIN
		
		insert into #TEMP_FINAL(PaisTCod, PaisNom, PaisCod, CCPPais, MontoPais)
        SELECT  CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                     ELSE 'C'
                END AS PaisTCod,
                ISNULL(PAISES.Descripcion, '') AS PaisNombre,
				COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, PAISES.CodDGI, '') AS PaisCod,                
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Cuotapartes), 0) AS Q,
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Monto), 0) AS Monto
        FROM    FM_MONTO_POR_PAIS_RESIDENCIA
        INNER JOIN CONDICIONESINGEGR ON convert(numeric(5),CONDICIONESINGEGR.CodInterfaz) = FM_MONTO_POR_PAIS_RESIDENCIA.Fondo
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
        LEFT JOIN PAISES ON PAISES.CodPais = FM_MONTO_POR_PAIS_RESIDENCIA.PaisResidencia
        WHERE  datediff(d, FM_MONTO_POR_PAIS_RESIDENCIA.Fecha, @FechaVCP) = 0
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
        GROUP BY PAISES.CodCAFCI, PAISES.CodInterfaz, PAISES.CodDGI, PAISES.Descripcion

    END
    ELSE BEGIN
        IF @CodTpFondo='MM' BEGIN
			insert into #TEMP_FINAL(PaisTCod, PaisNom, PaisCod, CCPPais,MontoPais)
            SELECT  CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END AS PaisTCod,
                    ISNULL(PAISES.Descripcion, '') AS PaisNombre,
					COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, CodDGI, '') AS PaisCod,                    
                    ISNULL(SUM(CantCuotapartes), 0) AS Q,
                    ISNULL(SUM(CantCuotapartes * ValorCpInicial), 0) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
            GROUP BY CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END,
                    COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, CodDGI, ''),
                    ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais
        END
        ELSE BEGIN
			insert into #TEMP_FINAL(PaisTCod, PaisNom, PaisCod, CCPPais,MontoPais)
            SELECT  CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END AS PaisTCod,
                    ISNULL(PAISES.Descripcion, '') AS PaisNombre,
					COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, CodDGI, '') AS PaisCod,                    
                    ISNULL(SUM(CantCuotapartes), 0) AS Q,
                    ISNULL(SUM(CantCuotapartes * ValorCuotaparte), 0) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP
            GROUP BY CASE WHEN CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END,
                    COALESCE(CodCAFCI, PAISES.CodInterfaz, CodDGI, ''),
                    ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais        
        END
    END
	
	insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
	select '<ResidenciasInversores>'
	
	if (select count(*) from #TEMP_FINAL) > 0
	begin
		insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
		select	'<ResidenciaInversores>' +
				case when dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(PaisNom,''))) = '' then '<PaisNom/>' else '<PaisNom>' + dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(PaisNom,''))) + '</PaisNom>' end +
				case when convert(varchar,coalesce(PaisTCod,''))='' then '<PaisTCod/>' else '<PaisTCod>' + convert(varchar,coalesce(PaisTCod,'')) + '</PaisTCod>' end +
				case when convert(varchar,coalesce(PaisCod,'')) = '' then '<PaisCod/>' else '<PaisCod>' + convert(varchar,coalesce(PaisCod,'')) +  '</PaisCod>' end +
				'<MontoPais>' + convert(varchar,coalesce(convert(numeric(19,2),MontoPais),0)) + '</MontoPais>' +
				'<CCPPais>' + convert(varchar,coalesce(convert(numeric(22,8),CCPPais),0)) +  '</CCPPais>' +
				'</ResidenciaInversores>'
		from	#TEMP_FINAL
	end
	else
	begin
		insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
		select	'<ResidenciaInversores>' +
				'<PaisNom/>' +
				'<PaisTCod/>' +
				'<PaisCod/>' +
				'<MontoPais/>' +
				'<CCPPais/>' +
				'</ResidenciaInversores>'
	end
	
	insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
	select '</ResidenciasInversores>'
	


go




exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_Inversor'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_Inversor
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as

	DECLARE @FechaVCP   Fecha
    DECLARE @CodTpFondo CodigoTextoCorto

    SELECT  @FechaVCP = MAX(Fecha) FROM VALORESCP WHERE VALORESCP.CodFondo = @CodFondo AND VALORESCP.Fecha <= @FechaProceso
    SELECT  @CodTpFondo = CodTpFondo FROM FONDOSREAL WHERE CodFondo=@CodFondo

    CREATE TABLE #CAFCIMENSUAL_INVERSORES_TOC2013OUT
       (
		CodigoSubTipo varchar(30) not null,
		CodInterfaz varchar(30) null, 
		Campo_Q numeric (15) not null, 
		Campo_Monto numeric(19,2) not null
		)

    CREATE TABLE #CAFCIMENSUAL_LIQ
       (CodTpValorCp numeric(5) NOT NULL,
        CodCuotapartista numeric(10) NOT NULL,
        CantCuotapartes numeric(22, 8))

	--Busco informacion básica
	
    INSERT INTO #CAFCIMENSUAL_LIQ (CodTpValorCp, CodCuotapartista, CantCuotapartes)
    SELECT  LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista, SUM(LIQUIDACIONES.CantCuotapartes) AS CantCuotapartes
    FROM    LIQUIDACIONES
    WHERE   LIQUIDACIONES.CodFondo = @CodFondo AND FechaConcertacion <= @FechaVCP AND EstaAnulado = 0
    GROUP BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista 
    HAVING SUM(LIQUIDACIONES.CantCuotapartes) <> 0
    ORDER BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista
	
	
    IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_TIPO_DE_INVERSOR')) 
	BEGIN

		
		INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
		SELECT isnull(Inversor,'     '), 
			NULL, 
			Cantidad, 
			Monto 
		FROM FM_MONTO_POR_TIPO_DE_INVERSOR
        INNER JOIN CONDICIONESINGEGR			
			ON FM_MONTO_POR_TIPO_DE_INVERSOR.Fondo = CONVERT(NUMERIC(5),CONDICIONESINGEGR.CodInterfaz)
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
			and ISNUMERIC(CONDICIONESINGEGR.CodInterfaz) = 1
        WHERE Fecha = @FechaVCP
        
    END
	ELSE IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_TIPO_PERSONA')) 
	BEGIN
		
        INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT 
				(CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
		SELECT 
		dbo.fnTraerCodCAFCIDefault(CASE WHEN UPPER(FM_MONTO_POR_TIPO_PERSONA.Persona) = 'F' THEN -1 ELSE 0 END) AS CodigoSubTipo, 
		NULL,
		FM_MONTO_POR_TIPO_PERSONA.Cantidad, 
		FM_MONTO_POR_TIPO_PERSONA.Monto 
		FROM FM_MONTO_POR_TIPO_PERSONA
			INNER JOIN CONDICIONESINGEGR 
			ON FM_MONTO_POR_TIPO_PERSONA.Fondo = CONVERT(NUMERIC(5),CONDICIONESINGEGR.CodInterfaz)            
			AND CONDICIONESINGEGR.CodFondo = @CodFondo
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
			and ISNUMERIC(CONDICIONESINGEGR.CodInterfaz) = 1
        WHERE FM_MONTO_POR_TIPO_PERSONA.Fecha = @FechaVCP
        
    END
    ELSE BEGIN
			
			--Involucrar los que tienen configurado TIPO DE INVERSOR en el cuotapartista
			INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
            SELECT  
    				isnull(TPINVERSORES.CodCAFCI,'     '),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
					INNER JOIN TPINVERSORES ON CUOTAPARTISTAS.CodTpInversor =TPINVERSORES.CodTpInversor
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP

			GROUP BY  TPINVERSORES.CodCAFCI



			--Involucrar los que tienen configurado TIPO DE INVERSOR en el Segmento de Inversión (porque no lo tienen en el cuotapartista), 
			INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
            SELECT  
    				isnull(TPINVERSORES.CodCAFCI,'     '),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
					INNER JOIN SEGMENTOSINV 
							ON CUOTAPARTISTAS.CodSegmentoInv = SEGMENTOSINV.CodSegmentoInv
						   AND CUOTAPARTISTAS.EsPersonaFisica = SEGMENTOSINV.EsPersonaFisica
					INNER JOIN TPINVERSORES 
							ON SEGMENTOSINV.CodTpInversor = TPINVERSORES.CodTpInversor
						   AND SEGMENTOSINV.EsPersonaFisica = TPINVERSORES.EsPersonaFisica
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP

			WHERE	CUOTAPARTISTAS.CodTpInversor IS NULL
			GROUP BY  TPINVERSORES.CodCAFCI
			

			--Involucrar los que NO tienen configurado TIPO DE INVERSOR, asignándoles uno por default, según el campo EsPersonaFísica
			INSERT INTO #CAFCIMENSUAL_INVERSORES_TOC2013OUT (CodigoSubTipo,CodInterfaz, Campo_Q , Campo_Monto )
            SELECT  
    				dbo.fnTraerCodCAFCIDefault(CUOTAPARTISTAS.EsPersonaFisica),
					NULL,
					ISNULL(COUNT(DISTINCT CUOTAPARTISTAS.CodCuotapartista), 0),
                    ISNULL(SUM(#CAFCIMENSUAL_LIQ.CantCuotapartes * CASE WHEN @CodTpFondo='MM' THEN TPVALORESCP.ValorCpInicial ELSE VALORESCP.ValorCuotaparte END), 0)
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista 
					LEFT JOIN  SEGMENTOSINV 
							ON CUOTAPARTISTAS.CodSegmentoInv = SEGMENTOSINV.CodSegmentoInv
					LEFT JOIN TPINVERSORES 
						     ON SEGMENTOSINV.CodTpInversor = TPINVERSORES.CodTpInversor
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP
			WHERE   (
						CUOTAPARTISTAS.CodSegmentoInv is null
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND SEGMENTOSINV.CodTpInversor is null)
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND (SEGMENTOSINV.EsPersonaFisica <> CUOTAPARTISTAS.EsPersonaFisica))
						OR
						(CUOTAPARTISTAS.CodSegmentoInv is not null AND (TPINVERSORES.EsPersonaFisica <> CUOTAPARTISTAS.EsPersonaFisica))
					)
					AND CUOTAPARTISTAS.CodTpInversor is null

			GROUP BY  dbo.fnTraerCodCAFCIDefault(CUOTAPARTISTAS.EsPersonaFisica)
        
    END

	create table #TEMP_FINAL 
	(
		SubTipoCod varchar(30) collate database_default not null,
		CodInterfaz varchar(30) collate database_default null, 
		Monto numeric (19,2) not null, 
		CantInv numeric(20) not null		
	)

	insert into #TEMP_FINAL (SubTipoCod, CodInterfaz, CantInv, Monto)
    SELECT 
		CodigoSubTipo, 
		CodInterfaz, 
		sum(Campo_Q) AS Campo_Q, 
		sum(Campo_Monto) AS Campo_Monto
	FROM #CAFCIMENSUAL_INVERSORES_TOC2013OUT
	group by CodigoSubTipo, CodInterfaz
	
	
	insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
	select '<Inversores>'
	
	if (select count(*) from #TEMP_FINAL) > 0
	begin
		insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
		SELECT  
			'<Inversor>' +
			case when coalesce(convert(varchar,SubTipoCod),'') = '' then '<SubTipoCod/>' else '<SubTipoCod>' + dbo.fnSacarCaracteresEspXML(convert(varchar,SubTipoCod)) + '</SubTipoCod>' end +
			case when coalesce(convert(varchar,convert(numeric(20,2),Monto)),'') = '' then '<Monto/>' else '<Monto>'  + convert(varchar,convert(numeric(20,2),Monto)) + '</Monto>' end +			
			case when coalesce(convert(varchar,convert(numeric(20),CantInv)),'') = '' then '<CantInv/>' else '<CantInv>' + convert(varchar,convert(numeric(20),CantInv)) + '</CantInv>' end +			
			'</Inversor>'
		FROM #TEMP_FINAL
		
		insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
		SELECT  
			'<Inversor>' +
			'<SubTipoCod>TOTAL</SubTipoCod>' +
			'<Monto>' + convert(varchar,convert(numeric(20,2),SUM(COALESCE(Monto,0)))) + '</Monto>' +			
			'<CantInv>' + convert(varchar,convert(numeric(20),SUM(COALESCE(CantInv,0)))) +  '</CantInv>' +			
			'</Inversor>'
		FROM #TEMP_FINAL
		

	end
	else
	begin
		insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
		SELECT  
			'<Inversor>' +
			'<SubTipoCod/>' +
			'<Monto/>' +			
			'<CantInv/>' +			
			'</Inversor>'
	end
	
	insert into #CAFCIUNIFICADA_Tag_Inversor (CampoXml)
	select '</Inversores>'
	
go




exec sp_CreateProcedure 'dbo.spGDIN_CAFCI796_Tag_ResidenciaInversores'
go
alter procedure dbo.spGDIN_CAFCI796_Tag_ResidenciaInversores
    @CodFondo CodigoMedio,
	@FechaProceso Fecha,
	@CodUsuario CodigoMedio
with encryption 
as


	DECLARE @FechaVCP   Fecha
    DECLARE @CodTpFondo CodigoTextoCorto

    SELECT  @FechaVCP = MAX(Fecha) FROM VALORESCP WHERE VALORESCP.CodFondo = @CodFondo AND VALORESCP.Fecha <= @FechaProceso
    SELECT  @CodTpFondo = CodTpFondo FROM FONDOSREAL WHERE CodFondo=@CodFondo

  
    CREATE TABLE #CAFCIMENSUAL_LIQ
       (CodTpValorCp numeric(5) NOT NULL,
        CodCuotapartista numeric(10) NOT NULL,
        CantCuotapartes numeric(22, 8))


	--Busco informacion básica
    INSERT INTO #CAFCIMENSUAL_LIQ (CodTpValorCp, CodCuotapartista, CantCuotapartes)
    SELECT  LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista, SUM(LIQUIDACIONES.CantCuotapartes) AS CantCuotapartes
    FROM    LIQUIDACIONES
    WHERE   LIQUIDACIONES.CodFondo = @CodFondo AND FechaConcertacion <= @FechaVCP AND EstaAnulado = 0
    GROUP BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista
    HAVING SUM(LIQUIDACIONES.CantCuotapartes) <> 0
    ORDER BY LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista

	create table #TEMP_FINAL 
	(
		PaisTCod varchar(1) collate database_default,
		PaisNom	varchar(30) collate database_default,
		PaisCod varchar(80) collate database_default,
		MontoPais numeric(19,2) NOT NULL,
		CCPPais numeric(22,8)
	)

	IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.FM_MONTO_POR_PAIS_RESIDENCIA')) 
	BEGIN
		
		insert into #TEMP_FINAL(PaisTCod, PaisNom, PaisCod, CCPPais, MontoPais)
        SELECT  CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                     ELSE 'C'
                END AS PaisTCod,
                dbo.fnSacarCaracteresEspXML(ISNULL(PAISES.Descripcion, '')) AS PaisNombre,
				dbo.fnSacarCaracteresEspXML(COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, PAISES.CodDGI, '')) AS PaisCod,                
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Cuotapartes), 0) AS Q,
                ISNULL(SUM(FM_MONTO_POR_PAIS_RESIDENCIA.Monto), 0) AS Monto
        FROM    FM_MONTO_POR_PAIS_RESIDENCIA
        INNER JOIN CONDICIONESINGEGR ON FM_MONTO_POR_PAIS_RESIDENCIA.Fondo = convert(numeric(5),CONDICIONESINGEGR.CodInterfaz)
            AND CONDICIONESINGEGR.CodFondo = @CodFondo
        LEFT JOIN PAISES ON PAISES.CodPais = FM_MONTO_POR_PAIS_RESIDENCIA.PaisResidencia
        WHERE  datediff(d, FM_MONTO_POR_PAIS_RESIDENCIA.Fecha, @FechaVCP) = 0
			and coalesce(CONDICIONESINGEGR.CodInterfaz,'') <> ''
        GROUP BY PAISES.CodCAFCI, PAISES.CodInterfaz, PAISES.CodDGI, PAISES.Descripcion

    END
    ELSE BEGIN
        IF @CodTpFondo='MM' BEGIN
			insert into #TEMP_FINAL(PaisTCod, PaisNom, PaisCod, CCPPais,MontoPais)
            SELECT  CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END AS PaisTCod,
                    dbo.fnSacarCaracteresEspXML(ISNULL(PAISES.Descripcion, '')) AS PaisNombre,
					dbo.fnSacarCaracteresEspXML(COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, CodDGI, '')) AS PaisCod,                    
                    ISNULL(SUM(CantCuotapartes), 0) AS Q,
                    ISNULL(SUM(CantCuotapartes * ValorCpInicial), 0) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN TPVALORESCP
                            ON TPVALORESCP.CodFondo = @CodFondo
                           AND TPVALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
            GROUP BY CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END,
                    COALESCE(PAISES.CodCAFCI, PAISES.CodInterfaz, CodDGI, ''),
                    ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais
        END
        ELSE BEGIN
			insert into #TEMP_FINAL(PaisTCod, PaisNom, PaisCod, CCPPais,MontoPais)
            SELECT  CASE WHEN PAISES.CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END AS PaisTCod,
                    dbo.fnSacarCaracteresEspXML(ISNULL(PAISES.Descripcion, '')) AS PaisNombre,
					dbo.fnSacarCaracteresEspXML(coalesce(PAISES.CodCAFCI, PAISES.CodInterfaz, CodDGI, '')) AS PaisCod,                    
                    ISNULL(SUM(CantCuotapartes), 0) AS Q,
                    ISNULL(SUM(CantCuotapartes * ValorCuotaparte), 0) AS Monto
            FROM    #CAFCIMENSUAL_LIQ
                    INNER JOIN CUOTAPARTISTAS
                            ON CUOTAPARTISTAS.CodCuotapartista = #CAFCIMENSUAL_LIQ.CodCuotapartista
                    LEFT  JOIN PAISES
                            ON PAISES.CodPais = CUOTAPARTISTAS.CodPais
                    INNER JOIN VALORESCP
                            ON VALORESCP.CodFondo = @CodFondo
                           AND VALORESCP.CodTpValorCp = #CAFCIMENSUAL_LIQ.CodTpValorCp
                           AND VALORESCP.Fecha = @FechaVCP
            GROUP BY CASE WHEN CodCAFCI IS NULL THEN 'P'
                         ELSE 'C'
                    END,
                    COALESCE(CodCAFCI, PAISES.CodInterfaz, CodDGI, ''),
                    ISNULL(PAISES.Descripcion, ''),
                    PAISES.CodPais
            ORDER BY PAISES.CodPais        
        END
    END
	
	insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
	select '<ResidenciasInversores>'
	
	if (select count(*) from #TEMP_FINAL) > 0
	begin
		insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
		select	'<ResidenciaInversores>' +
				case when dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(PaisNom,''))) = '' then '<PaisNom/>' else '<PaisNom>' + dbo.fnSacarCaracteresEspXML(convert(varchar,coalesce(PaisNom,''))) + '</PaisNom>' end +
				case when convert(varchar,coalesce(PaisTCod,''))='' then '<PaisTCod/>' else '<PaisTCod>' + convert(varchar,coalesce(PaisTCod,'')) + '</PaisTCod>' end +
				case when convert(varchar,coalesce(PaisCod,'')) = '' then '<PaisCod/>' else '<PaisCod>' + convert(varchar,coalesce(PaisCod,'')) +  '</PaisCod>' end +
				'<MontoPais>' + convert(varchar,coalesce(convert(numeric(19,2),MontoPais),0)) + '</MontoPais>' +
				'<CCPPais>' + convert(varchar,coalesce(convert(numeric(22,8),CCPPais),0)) +  '</CCPPais>' +
				'</ResidenciaInversores>'
		from	#TEMP_FINAL
	end
	else
	begin
		insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
		select	'<ResidenciaInversores>' +
				'<PaisNom/>' +
				'<PaisTCod/>' +
				'<PaisCod/>' +
				'<MontoPais/>' +
				'<CCPPais/>' +
				'</ResidenciaInversores>'
	end
	
	insert into #CAFCIUNIFICADA_Tag_ResidenciaInversores (CampoXml)
	select '</ResidenciasInversores>'
	


go


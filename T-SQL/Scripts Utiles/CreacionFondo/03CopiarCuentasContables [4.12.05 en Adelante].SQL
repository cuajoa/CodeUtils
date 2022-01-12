if exists (select * from tempdb..sysobjects where id = object_id('tempdb..#CTASCONTABLES')) BEGIN
    DROP TABLE #CTASCONTABLES
END

alter table CTASCONTABLES nocheck constraint CFK_CTASCONTABLES_CTASCONTABLES_1
go

DECLARE @CodCtaContable CodigoCuentaContable
DECLARE @CodFondoDesde CodigoMedio
DECLARE @CodFondoHasta CodigoMedio
DECLARE @CodAuditoriaRef CodigoLargo


SELECT @CodFondoDesde = CodFondo from FONDOSREAL where NumFondo = 7629
SELECT @CodFondoHasta = CodFondo from FONDOSREAL where NumFondo = 7633 -- ,7631,7632,7633

SELECT * INTO #CTASCONTABLES
FROM CTASCONTABLES
WHERE CodFondo = @CodFondoDesde AND EstaAnulado = 0

WHILE (SELECT COUNT(*) FROM #CTASCONTABLES) > 0  BEGIN
    SELECT @CodCtaContable = CodCtaContable
    FROM #CTASCONTABLES
    ORDER BY CodPadre Desc
	
    INSERT AUDITORIASREF (NomEntidad)
    VALUES ('CTACONT')
    SELECT @CodAuditoriaRef = @@IDENTITY

    INSERT CTASCONTABLES (CodFondo, CodCtaContable, CodAgente, CodBanco, CodTpEspecie, CodTpCtaAutomatica,
                          CodTpOperacion, CodEspecie, CodSerie, Nivel, Descripcion, Alias, TieneSubrubros,
                          CodMoneda, CodTpCtaContable, AjustaInflacion, IntervieneEnCashFlow, IntervieneEnProv,
                          CodTpValorCp, EstaAnulado, CodAuditoriaRef, CodPadre)

    SELECT @CodFondoHasta, CodCtaContable, CodAgente, CodBanco, CodTpEspecie, (case when NOT CodCtaBancaria IS NULL THEN NULL ELSE CodTpCtaAutomatica END),
           CodTpOperacion, CodEspecie, CodSerie, Nivel, Descripcion, Alias, TieneSubrubros,
           (case when TieneSubrubros = -1 THEN NULL ELSE CodMoneda END), CodTpCtaContable, AjustaInflacion, IntervieneEnCashFlow, IntervieneEnProv,
           null, 0, @CodAuditoriaRef, CodPadre          
    FROM #CTASCONTABLES
    WHERE @CodCtaContable = CodCtaContable
    
    INSERT AUDITORIASHIST (CodAccion, CodUsuario, Fecha, Terminal, CodAuditoriaRef)
                   VALUES ('CTACONTa', 1, Getdate(), Host_name(), @CodAuditoriaRef)

    DELETE #CTASCONTABLES
    WHERE @CodCtaContable = CodCtaContable
END

go

alter table CTASCONTABLES check constraint CFK_CTASCONTABLES_CTASCONTABLES_1
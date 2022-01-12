--PRUEBA BH BERAMENDI

CUENTA EMPRESA: Cuotapartista: 10975  IdCobis 4988067  
CUENTA PERSONA: Cuotapartista: 1504 IdCobis 5441131


DECLARE   @CodInterfazBanco   CodigoInterfazLargo
DECLARE   @CodPersona         CodigoLargo = NULL OUTPUT
DECLARE   @EstaAnulado        Boolean = NULL OUTPUT


DECLARE @CodSistemaExtOrig  CodigoTextoCorto

SELECT  @CodPersona = PERSONAS.CodPersona,
        @EstaAnulado = PERSONAS.EstaAnulado,
        @CodSistemaExtOrig = PERSONAS.CodSistemaExtOrig
FROM    PERSONAS
WHERE   PERSONAS.CodInterfazBanco = @CodInterfazBanco
    AND PERSONAS.CodSistemaExtOrig IN ('SO')


    SELECT  CUOTAPARTISTAS.CodCuotapartista, ISNULL(CUOTAPARTISTAS.CodInterfazBanco, '') AS CodInterfazBanco, CUOTAPARTISTAS.NumCuotapartista, CUOTAPARTISTAS.EstaAnulado
    FROM    CUOTAPARTISTAS
            INNER JOIN CONDOMINIOS ON CONDOMINIOS.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista AND CONDOMINIOS.EstaAnulado = 0
            INNER JOIN PERSONAS ON PERSONAS.CodPersona = CONDOMINIOS.CodPersona AND PERSONAS.CodPersona = @CodPersona

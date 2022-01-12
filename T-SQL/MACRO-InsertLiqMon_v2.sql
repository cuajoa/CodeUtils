INSERT INTO SOLRESCLIQMON (CodFondo,CodAgColocador,CodSucursal,CodSolResc,CodTpEstadoLiqMon,NumeroCuentaCpt,NumeroCuentaFdo,
ObservacionesCtaCpt,ObservacionesCtaFdo,CodUsuarioImpactoCtaCpt,CodUsuarioImpactoCtaFdo,IdCtaCpt,IdCtaFdo,IdBloqueo)
SELECT CodFondo, CodAgColocador, CodSucursal, CodSolResc, 'LS', NULL,NULL,NULL,NULL,1,1, NULL,NULL,NULL
FROM LIQUIDACIONES
WHERE CodSolResc in (22164
,24067
,24072
,25512
,25516
,25517
,33439
,33804
,33827
,35161
,46349)

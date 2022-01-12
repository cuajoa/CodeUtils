UPDATE CUOTAPARTISTAS
SET
EsPersonaFisica = -1,
CodTpInversor=1
FROM(
SELECT CUOTAPARTISTAS.NumCuotapartista, PERSONAS.CUIT, CUOTAPARTISTAS.EsPersonaFisica
FROM CUOTAPARTISTAS
INNER JOIN CONDOMINIOS ON CUOTAPARTISTAS.CodCuotapartista = CONDOMINIOS.CodCuotapartista
INNER JOIN PERSONAS ON PERSONAS.CodPersona = CONDOMINIOS.CodPersona
WHERE NumCuotapartista IN
(5929,2339,4583,5912,4016,2653,3515,4736,5188,4452,2738,2332,5341,5276,2945,78963,53311,76263,8207
,35370,38255,4736,5341,65029,80265,2339,71250,67493,34454,46002,48124,44096,05507,73149,3515,39290
,25171,4452,5929,53416,58407,55311,2653,78968,43748,5489,74136,28400,77387,20245,12943,79025,25839
,68757,2738,25668,38968,48960,38879,53311,39521,55314,43748,43366,69092,62621,78963,62326,63295,80018
,47265,2332,38826,38826,51103,38826,3314,4583,5188,5912,78968,5276,4016,48124,2945,43366)
AND EsPersonaFisica = 0) CUENTAS
WHERE CUIT NOT IN(30714294446,30506175972)


SELECT CUOTAPARTISTAS.NumCuotapartista, PERSONAS.CodTpDocIdentidad, PERSONAS.NumDocumento, PERSONAS.CUIL, PERSONAS.CUIT, PERSONAS.CDI, PERSONAS.EsFisica, CUOTAPARTISTAS.Nombre, CUOTAPARTISTAS.EsPersonaFisica
FROM CUOTAPARTISTAS
INNER JOIN CONDOMINIOS ON CUOTAPARTISTAS.CodCuotapartista = CONDOMINIOS.CodCuotapartista
INNER JOIN PERSONAS ON PERSONAS.CodPersona = CONDOMINIOS.CodPersona
WHERE NumCuotapartista IN
(5929,2339,4583,5912,4016,2653,3515,4736,5188,4452,2738,2332,5341,5276,2945,78963,53311,76263,8207
,35370,38255,4736,5341,65029,80265,2339,71250,67493,34454,46002,48124,44096,05507,73149,3515,39290
,25171,4452,5929,53416,58407,55311,2653,78968,43748,5489,74136,28400,77387,20245,12943,79025,25839
,68757,2738,25668,38968,48960,38879,53311,39521,55314,43748,43366,69092,62621,78963,62326,63295,80018
,47265,2332,38826,38826,51103,38826,3314,4583,5188,5912,78968,5276,4016,48124,2945,43366)

INSERT FONDOSCPT
	(CodFondo
,CodCuotapartista)
SELECT FONDOS.CodFondo
,CUOTAPARTISTAS.CodCuotapartista
FROM CUOTAPARTISTAS, FONDOS
WHERE not CodCuotapartista in( select CodCuotapartista from FONDOSCPT
WHERE FONDOSCPT.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista
			and FONDOSCPT.CodFondo = FONDOS.CodFondo)
/* Select de Honorarios vigentes de los fondos */



SELECT FONDOSREAL.CodFondo, FONDOSREAL.Nombre + ' ' + TPVALORESCP.Descripcion as FondoClase,

    CASE
		WHEN PORCPROVISIONsg.CodTpPorcProvision = 'S' THEN PORCPROVISIONsg.Porcentaje
		ELSE NULL
		END AS PorcentajeHonorariosSG,
    CASE
		WHEN PORCPROVISIONsd.CodTpPorcProvision = 'A' THEN PORCPROVISIONsd.Porcentaje
		ELSE NULL
		END AS PorcentajeHonorariosSD

FROM FONDOSREAL
    INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = FONDOSREAL.CodFondo

    INNER JOIN PORCPROVISION PORCPROVISIONsg ON PORCPROVISIONsg.CodFondo = TPVALORESCP.CodFondo AND PORCPROVISIONsg.CodTpValorCp = TPVALORESCP.CodTpValorCp
        AND PORCPROVISIONsg.CodProvision = 'PHON' AND PORCPROVISIONsg.CodTpPorcProvision = 'S' AND PORCPROVISIONsg.FechaDesde 	= (SELECT MAX(PORCPROVISION.FechaDesde) as MaxDate
        FROM PORCPROVISION
        WHERE PORCPROVISION.CodTpPorcProvision = PORCPROVISIONsg.CodTpPorcProvision
            AND PORCPROVISION.CodFondo = PORCPROVISIONsg.CodFondo
            AND PORCPROVISION.CodTpValorCp =PORCPROVISIONsg.CodTpValorCp
            AND PORCPROVISION.CodProvision = PORCPROVISIONsg.CodProvision
																																)

    INNER JOIN PORCPROVISION PORCPROVISIONsd ON PORCPROVISIONsd.CodFondo = TPVALORESCP.CodFondo AND PORCPROVISIONsd.CodTpValorCp = TPVALORESCP.CodTpValorCp
        AND PORCPROVISIONsd.CodProvision = 'PHON' AND PORCPROVISIONsd.CodTpPorcProvision = 'A' AND PORCPROVISIONsd.FechaDesde = (SELECT MAX(PORCPROVISION.FechaDesde) as MaxDate
        FROM PORCPROVISION
        WHERE PORCPROVISION.CodTpPorcProvision = PORCPROVISIONsd.CodTpPorcProvision
            AND PORCPROVISION.CodFondo = PORCPROVISIONsd.CodFondo
            AND PORCPROVISION.CodTpValorCp =PORCPROVISIONsd.CodTpValorCp
            AND PORCPROVISION.CodProvision = PORCPROVISIONsd.CodProvision
																																)

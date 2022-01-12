       select SOLRESC.* ,SOLRESCLIQMON.*
       from SOLRESC    inner join CUOTAPARTISTAS on SOLRESC.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista   
          left join SOLRESCLIQMON on SOLRESC.CodSolResc = SOLRESCLIQMON.CodSolResc
      where CUOTAPARTISTAS.NumCuotapartista = 6428 AND SOLRESCLIQMON.CodSolResc IS NULL

	select LIQUIDACIONES.* ,SOLRESCLIQMON.*
       from LIQUIDACIONES    inner join CUOTAPARTISTAS on LIQUIDACIONES.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista   
          LEFT join SOLRESCLIQMON on LIQUIDACIONES.CodSolResc = SOLRESCLIQMON.CodSolResc
      where SOLRESCLIQMON.CodSolResc IS NULL

		         select SOLSUSC.* ,SOLSUSCLIQMON.*
       from SOLSUSC    inner join CUOTAPARTISTAS on SOLSUSC.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista   
          left join SOLSUSCLIQMON on SOLSUSC.CodSolSusc = SOLSUSCLIQMON.CodSolSusc
		        where CUOTAPARTISTAS.NumCuotapartista = 6428 AND SOLSUSCLIQMON.CodSolSusc IS NULL
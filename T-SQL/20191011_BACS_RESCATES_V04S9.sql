BEGIN TRAN
--commit tran
--rollback tran

/***************************/
DECLARE @VISUALIZAR_DATOS Boolean = 0	/* -1 = MUESTRA LA INFO A IMPACTAR PARA QUE LA VALIDE EL CLIENTE
										    0 = IMPACTAC LAS SOLICITUDES DE TRANSFERENCIAS EN LA BD */
/***************************/

DECLARE @Fecha Fecha = '20190918'

IF EXISTS (select * from tempdb..sysobjects where id = object_id('tempdb..#TEMPEXCEL'))
		DROP TABLE #TEMPEXCEL


CREATE TABLE #TEMPEXCEL (	
	Id numeric(10) Identity(1,1),
	CodFondo numeric(10) null,
	NumFondo numeric(10) not null,		--------------
	CodCuotapartista numeric(10) null,
	NroCuotapastista Numeric(10) not null, --------------
	TpValorCp varchar(80) COLLATE DATABASE_DEFAULT not NULL,	--------------
	CantCuotasAPasar numeric(22,8) null,  --------------
	CondicionIngEgr varchar(30)  COLLATE DATABASE_DEFAULT not NULL,
	CodCondicionIngEgr numeric(5) null,
	CodAgColocador numeric(5) null,
	CodSucursal numeric(5) null,
	CodTpValorCp varchar(3) COLLATE DATABASE_DEFAULT NULL,
	CodOficialCta numeric(5) null,
	NumSolicitud numeric(15) null,
	FechaConcertacion smalldatetime null,
	FechaAcreditacion smalldatetime null,
	--para sol suc
	CodCanalVta numeric(5) ,
	CodMoneda  numeric(5),
	Importe numeric(19,2) 
	
)

DECLARE @i					Numeric(10)
DECLARE @Total				Numeric(10)
DECLARE @CodAuditoriaRef	CodigoLargo

/*DATOS DEL EXCEL*/
---------------

INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1292,'Renta Fija $Med.Plazo- Clase A',18651.16864,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,863,'Renta Fija $Med.Plazo- Clase A',59.7793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1351,'Renta Fija $Med.Plazo- Clase A',13031.9062933333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1301,'Renta Fija $Med.Plazo- Clase A',5738.82112,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1206,'Renta Fija $Med.Plazo- Clase A',239.117546666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,567,'Renta Fija $Med.Plazo- Clase A',4005.21890666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,821,'Renta Fija $Med.Plazo- Clase A',1255.36712,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1088,'Renta Fija $Med.Plazo- Clase A',956.470186666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,983,'Renta Fija $Med.Plazo- Clase A',777.132026666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,237,'Renta Fija $Med.Plazo- Clase A',836.911413333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1327,'Renta Fija $Med.Plazo- Clase A',119.558773333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,407,'Renta Fija $Med.Plazo- Clase A',18830.5068,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,18,'Renta Fija $Med.Plazo- Clase A',478.235093333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,449,'Renta Fija $Med.Plazo- Clase A',59.7793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,606,'Renta Fija $Med.Plazo- Clase A',1315.14650666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,509,'Renta Fija $Med.Plazo- Clase A',3646.54258666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,335,'Renta Fija $Med.Plazo- Clase A',836.911413333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,116,'Renta Fija $Med.Plazo- Clase A',1733.60221333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,809,'Renta Fija $Med.Plazo- Clase A',60138.0629866667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1288,'Renta Fija $Med.Plazo- Clase A',538.01448,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1194,'Renta Fija $Med.Plazo- Clase A',9624.48125333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1104,'Renta Fija $Med.Plazo- Clase A',29650.5757866667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,607,'Renta Fija $Med.Plazo- Clase A',84288.9352,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1020,'Renta Fija $Med.Plazo- Clase A',538.01448,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,491,'Renta Fija $Med.Plazo- Clase A',3706.32197333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,666,'Renta Fija $Med.Plazo- Clase A',432922.31824,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1408,'Renta Fija $Med.Plazo- Clase A',3945.43952,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,314,'Renta Fija $Med.Plazo- Clase A',8189.77597333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,322,'Renta Fija $Med.Plazo- Clase A',7771.32026666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,348,'Renta Fija $Med.Plazo- Clase A',1434.70528,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,232,'Renta Fija $Med.Plazo- Clase A',59.7793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1144,'Renta Fija $Med.Plazo- Clase A',239.117546666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,605,'Renta Fija $Med.Plazo- Clase A',1315.14650666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1322,'Renta Fija $Med.Plazo- Clase A',1733.60221333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1122,'Renta Fija $Med.Plazo- Clase A',42383.5851466667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1181,'Renta Fija $Med.Plazo- Clase A',59.7793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,65,'Renta Fija $Med.Plazo- Clase A',59.7793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,375,'Renta Fija $Med.Plazo- Clase A',956.470186666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,763,'Renta Fija $Med.Plazo- Clase A',597.793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,185,'Renta Fija $Med.Plazo- Clase A',5380.1448,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1348,'Renta Fija $Med.Plazo- Clase A',657.573253333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,441,'Renta Fija $Med.Plazo- Clase A',3646.54258666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,430,'Renta Fija $Med.Plazo- Clase A',59.7793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,897,'Renta Fija $Med.Plazo- Clase A',59.7793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,59,'Renta Fija $Med.Plazo- Clase A',1793.3816,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,577,'Renta Fija $Med.Plazo- Clase A',3108.52810666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,265,'Renta Fija $Med.Plazo- Clase A',52785.1984266666,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1251,'Renta Fija $Med.Plazo- Clase A',28574.5468266667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,205,'Renta Fija $Med.Plazo- Clase A',1315.14650666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,393,'Renta Fija $Med.Plazo- Clase A',3646.54258666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,260,'Renta Fija $Med.Plazo- Clase A',10939.62776,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1226,'Renta Fija $Med.Plazo- Clase A',298.896933333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1212,'Renta Fija $Med.Plazo- Clase A',8010.43781333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1186,'Renta Fija $Med.Plazo- Clase A',119.558773333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1189,'Renta Fija $Med.Plazo- Clase A',1912.94037333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1244,'Renta Fija $Med.Plazo- Clase A',239.117546666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,218,'Renta Fija $Med.Plazo- Clase A',777.132026666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,190,'Renta Fija $Med.Plazo- Clase A',1494.48466666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,548,'Renta Fija $Med.Plazo- Clase A',71974.3815466667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,566,'Renta Fija $Med.Plazo- Clase A',32759.1038933333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1085,'Renta Fija $Med.Plazo- Clase A',33655.7946933333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1305,'Renta Fija $Med.Plazo- Clase A',239.117546666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1152,'Renta Fija $Med.Plazo- Clase A',33596.0153066667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1254,'Renta Fija $Med.Plazo- Clase A',2331.39608,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1361,'Renta Fija $Med.Plazo- Clase A',46149.6865066667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1171,'Renta Fija $Med.Plazo- Clase A',2271.61669333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1038,'Renta Fija $Med.Plazo- Clase A',298.896933333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,409,'Renta Fija $Med.Plazo- Clase A',896.6908,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,379,'Renta Fija $Med.Plazo- Clase A',1853.16098666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,240,'Renta Fija $Med.Plazo- Clase A',1793.3816,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,846,'Renta Fija $Med.Plazo- Clase A',4543.23338666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,847,'Renta Fija $Med.Plazo- Clase A',4603.01277333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,845,'Renta Fija $Med.Plazo- Clase A',49078.8764533333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1092,'Renta Fija $Med.Plazo- Clase A',298.896933333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,258,'Renta Fija $Med.Plazo- Clase A',298.896933333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,653,'Renta Fija $Med.Plazo- Clase A',59.7793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,134,'Renta Fija $Med.Plazo- Clase A',5679.04173333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,743,'Renta Fija $Med.Plazo- Clase A',30248.3696533333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1145,'Renta Fija $Med.Plazo- Clase A',10999.4071466667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,518,'Renta Fija $Med.Plazo- Clase A',3048.74872,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,193,'Renta Fija $Med.Plazo- Clase A',538.01448,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,151,'Renta Fija $Med.Plazo- Clase A',896.6908,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,187,'Renta Fija $Med.Plazo- Clase A',1016.24957333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,634,'Renta Fija $Med.Plazo- Clase A',298.896933333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,320,'Renta Fija $Med.Plazo- Clase A',2152.05792,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,53,'Renta Fija $Med.Plazo- Clase A',2450.95485333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,431,'Renta Fija $Med.Plazo- Clase A',3287.86626666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,571,'Renta Fija $Med.Plazo- Clase A',836.911413333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,405,'Renta Fija $Med.Plazo- Clase A',836.911413333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,368,'Renta Fija $Med.Plazo- Clase A',39394.6158133333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1295,'Renta Fija $Med.Plazo- Clase A',2271.61669333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,471,'Renta Fija $Med.Plazo- Clase A',597.793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,135,'Renta Fija $Med.Plazo- Clase A',5559.48296,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1367,'Renta Fija $Med.Plazo- Clase A',6157.27682666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1133,'Renta Fija $Med.Plazo- Clase A',11597.2010133333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,387,'Renta Fija $Med.Plazo- Clase A',59.7793866666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1237,'Renta Fija $Med.Plazo- Clase A',298.896933333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,483,'Renta Fija $Med.Plazo- Clase A',1554.26405333333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,262,'Renta Fija $Med.Plazo- Clase A',1494.48466666667,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,294,'Renta Fija $Med.Plazo- Clase A',15721.9786933333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,8225,'Renta Fija $Med.Plazo- Clase A',49437.5527733333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,10683,'Renta Fija $Med.Plazo- Clase A',21640.1379733333,'UNICO'

---------------

update #TEMPEXCEL
	set #TEMPEXCEL.CodFondo = FONDOSREAL.CodFondo
	    ,#TEMPEXCEL.CodMoneda = FONDOSREAL.CodMoneda
FROM #TEMPEXCEL
	 inner join FONDOSREAL on LTRIM(RTRIM(#TEMPEXCEL.NumFondo)) =  LTRIM(RTRIM(FONDOSREAL.NumFondo))


UPDATE #TEMPEXCEL
	SET  #TEMPEXCEL.CodCuotapartista = CUOTAPARTISTAS.CodCuotapartista,
		 #TEMPEXCEL.CodAgColocador = CUOTAPARTISTAS.CodAgColocadorOfCta,
		 #TEMPEXCEL.CodSucursal = CUOTAPARTISTAS.CodSucursalOfCta,
		 #TEMPEXCEL.CodOficialCta = CUOTAPARTISTAS.CodOficialCta,
		 #TEMPEXCEL.CodCanalVta = CUOTAPARTISTAS.CodCanalVta  --nuevo
FROM #TEMPEXCEL
	 INNER JOIN CUOTAPARTISTAS 
		INNER JOIN AGCOLOCADORES ON AGCOLOCADORES.CodAgColocador = CUOTAPARTISTAS.CodAgColocador
		INNER JOIN SUCURSALES ON SUCURSALES.CodSucursal = CUOTAPARTISTAS.CodSucursal
		INNER JOIN OFICIALESCTA ON OFICIALESCTA.CodOficialCta = CUOTAPARTISTAS.CodOficialCta
	 ON CUOTAPARTISTAS.NumCuotapartista = #TEMPEXCEL.NroCuotapastista
	
	 
UPDATE #TEMPEXCEL
	SET  #TEMPEXCEL.CodTpValorCp = TPVALORESCP.CodTpValorCp
FROM #TEMPEXCEL
	 INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = #TEMPEXCEL.CodFondo
								and TPVALORESCP.Abreviatura = #TEMPEXCEL.TpValorCp


UPDATE #TEMPEXCEL
	SET #TEMPEXCEL.CodCondicionIngEgr = CONDICIONESINGEGR.CodCondicionIngEgr
FROM #TEMPEXCEL
	 INNER JOIN CONDICIONESINGEGR ON CONDICIONESINGEGR.CodFondo = #TEMPEXCEL.CodFondo
									 and CONDICIONESINGEGR.Descripcion = #TEMPEXCEL.CondicionIngEgr
									 and CONDICIONESINGEGR.EstaAnulado = 0


UPDATE #TEMPEXCEL
SET NumSolicitud = 0,
	FechaConcertacion = @Fecha,
	FechaAcreditacion = @Fecha
	
	
	
	
--rollback

SELECT * FROM #TEMPEXCEL

IF @VISUALIZAR_DATOS = -1
BEGIN
	SELECT FONDOSREAL.NumFondo NroFondoDesde,
		   FONDOSREAL.Nombre FondoDesde,
		   FONDOSREAL.NombreAbreviado FondoAbreviaturaDesde,
		   TPVALORESCP.Abreviatura ClaseDesde,
		   CONDICIONESINGEGR.Descripcion CondicionIngEgrDesde,
		   CUOTAPARTISTAS.NumCuotapartista,
		   CUOTAPARTISTAS.Nombre Cuotapartista,
		   FH.NumFondo NroFondo,
		   FH.Nombre Fondo,
		   VC.Abreviatura Clase,
		   CONDICIONESINGEGR.Descripcion CondicionIngEgr,
		   #TEMPEXCEL.FechaConcertacion,
		   #TEMPEXCEL.FechaAcreditacion,
		   #TEMPEXCEL.Importe,
		   #TEMPEXCEL.CodMoneda,
		   #TEMPEXCEL.CodCanalVta
	FROM #TEMPEXCEL
		 inner join FONDOSREAL ON #TEMPEXCEL.CodFondo = FONDOSREAL.CodFondo
		 inner join TPVALORESCP on #TEMPEXCEL.CodFondo = TPVALORESCP.CodFondo
							       and #TEMPEXCEL.CodTpValorCp = TPVALORESCP.CodTpValorCp
		 inner join CUOTAPARTISTAS on CUOTAPARTISTAS.CodCuotapartista = #TEMPEXCEL.CodCuotapartista
		 inner join CONDICIONESINGEGR on #TEMPEXCEL.CodFondo = CONDICIONESINGEGR.CodFondo
										and #TEMPEXCEL.CodCondicionIngEgr = CONDICIONESINGEGR.CodCondicionIngEgr
		 left join FONDOSREAL FH ON #TEMPEXCEL.CodFondo = FH.CodFondo
		 LEFT JOIN TPVALORESCP VC ON #TEMPEXCEL.CodFondo = VC.CodFondo
									AND #TEMPEXCEL.CodTpValorCp = VC.CodTpValorCp



END
ELSE
BEGIN

	SET @i = 1
	SET @Total = (SELECT COUNT(*) FROM #TEMPEXCEL)

			
			/*datos de la suscripcion fijos*/
			DECLARE @CodUsuarioAuditoria  numeric(10)=1
			DECLARE @PorcGastos  numeric(12,8)=0
			DECLARE @CodInterfaz varchar(15) = null
			DECLARE @CodAccion varchar(12)='SOLRESCa'
			DECLARE @FechaConcertacion smalldatetime = @Fecha
			DECLARE @FechaAcreditacion smalldatetime = @Fecha
			
			/*variables*/
			declare @CodFondoS numeric(5,0) 
			declare @CodAgColocadorS numeric(5,0) 
			declare @CodSucursalS  numeric(5,0) 
			declare @CodSolResc numeric(10,0) 
			declare @CodCanalVtaS numeric(5,0) --ver de donde lo tomo
			declare @CodOficialCtaS numeric(5,0) 
			declare @CodCondicionIngEgr numeric(5,0) 
			declare @CodTpValorCpS numeric(5,0)
			declare @CodMonedaS  numeric(5,0) --ver de donde lo tomo
			declare @CodCuotapartistaS numeric(10)
			declare @NumSolicitud  numeric(15)
			declare @Importe numeric(19,2)--CantCuotasAPasar
			
			declare  @CodFormaPagoS  numeric(5,0)  
			declare  @CodItOtro  numeric(5,0)  

    
    select @NumSolicitud =MAX(NumSolicitud)  from SOLRESC

			
	
	WHILE (@i <= @Total) 
	BEGIN
		-- INSERT INTO AUDITORIASREF (NomEntidad) VALUES ('SOLTRANSFERENCIA')
			-- SELECT @CodAuditoriaRef = @@IDENTITY		
			
			SET @NumSolicitud = @NumSolicitud + 1
	
				SELECT					 
					  @CodAgColocadorS= #TEMPEXCEL.CodAgColocador,
					  @CodSucursalS =#TEMPEXCEL.CodSucursal,
					  @CodAgColocadorS = #TEMPEXCEL.CodAgColocador,
					  @CodSucursalS = #TEMPEXCEL.CodSucursal,					  
					  @CodFondoS = #TEMPEXCEL.CodFondo,
					  @CodCondicionIngEgr =#TEMPEXCEL.CodCondicionIngEgr,
					  @CodCuotapartistaS = #TEMPEXCEL.CodCuotapartista,
					  @CodOficialCtaS = #TEMPEXCEL.CodOficialCta,
					  --@NumSolicitud = #TEMPEXCEL.NumSolicitud,					  
					  @Importe =#TEMPEXCEL.Importe,										  
					  @CodTpValorCpS  =#TEMPEXCEL.CodTpValorCp,
                      @CodMonedaS = #TEMPEXCEL.CodMoneda,
		              @CodCanalVtaS = #TEMPEXCEL.CodCanalVta					  
				 FROM #TEMPEXCEL
			   WHERE #TEMPEXCEL.Id = @i
			   
			   SELECT @CodFormaPagoS = CodFormaPago FROM  FORMASPAGO where CodTpFormaPago = 'OT'
			   		   
			   if (@CodFormaPagoS is not null) begin 		   
			   
			   exec dbo.spESOLRESCATE @CodFondoS,@CodAgColocadorS,@CodSucursalS,@CodSolResc,@CodFormaPagoS,
			    null,null,null,null,null,1,null,null,null,null,null,null,
				@CodCanalVtaS,@CodOficialCtaS,@CodCondicionIngEgr,@CodTpValorCpS,@CodCuotapartistaS, @NumSolicitud /*@NumSolicitud*/,NULL/*@CantCuotapartes*/,
                @Importe,@PorcGastos,@FechaConcertacion,@FechaAcreditacion,/*@NumReferencia*/null,@CodUsuarioAuditoria,0,0,0,@CodInterfaz,
                @CodMonedaS,@CodUsuarioAuditoria,null,null,null,null,0,NULL,0,0,null,null,-1,'VF','NOREQ',null,null,null,0,'RE',null,
                @CodAccion,null			
				
				END
			   

		SET @i = @i + 1
	END


	COMMIT TRAN

END

GO

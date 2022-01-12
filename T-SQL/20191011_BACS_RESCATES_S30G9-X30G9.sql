BEGIN TRAN
--commit tran
--rollback tran

/***************************/
DECLARE @VISUALIZAR_DATOS Boolean = 0	/* -1 = MUESTRA LA INFO A IMPACTAR PARA QUE LA VALIDE EL CLIENTE
										    0 = IMPACTAC LAS SOLICITUDES DE TRANSFERENCIAS EN LA BD */
/***************************/

DECLARE @Fecha Fecha = '20190904'

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

INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,189,'Renta Fija $Med.Plazo- Clase A',13.8732,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,110,'Renta Fija $Med.Plazo- Clase A',10.3818,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1292,'Renta Fija $Med.Plazo- Clase A',12037.3132,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,863,'Renta Fija $Med.Plazo- Clase A',56.6258,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1351,'Renta Fija $Med.Plazo- Clase A',8434.9056,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1301,'Renta Fija $Med.Plazo- Clase A',3699.52,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1206,'Renta Fija $Med.Plazo- Clase A',168.7444,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,567,'Renta Fija $Med.Plazo- Clase A',2594.2884,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,821,'Renta Fija $Med.Plazo- Clase A',834.658,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,413,'Renta Fija $Med.Plazo- Clase A',5.7574,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1088,'Renta Fija $Med.Plazo- Clase A',633.5428,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,983,'Renta Fija $Med.Plazo- Clase A',509.817,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,237,'Renta Fija $Med.Plazo- Clase A',552.5696,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1327,'Renta Fija $Med.Plazo- Clase A',88.9966,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,407,'Renta Fija $Med.Plazo- Clase A',12155.1892,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,18,'Renta Fija $Med.Plazo- Clase A',321.3496,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,449,'Renta Fija $Med.Plazo- Clase A',64.7416,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,606,'Renta Fija $Med.Plazo- Clase A',878.636,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,509,'Renta Fija $Med.Plazo- Clase A',2382.699,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,335,'Renta Fija $Med.Plazo- Clase A',573.4256,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,116,'Renta Fija $Med.Plazo- Clase A',1125.9952,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,809,'Renta Fija $Med.Plazo- Clase A',38799.849,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,84,'Renta Fija $Med.Plazo- Clase A',10.3818,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,132,'Renta Fija $Med.Plazo- Clase A',4.6244,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1288,'Renta Fija $Med.Plazo- Clase A',351.4544,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1060,'Renta Fija $Med.Plazo- Clase A',9.2488,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,255,'Renta Fija $Med.Plazo- Clase A',10.3818,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1194,'Renta Fija $Med.Plazo- Clase A',6207.0778,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,417,'Renta Fija $Med.Plazo- Clase A',11.5148,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1104,'Renta Fija $Med.Plazo- Clase A',19123.027,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,607,'Renta Fija $Med.Plazo- Clase A',54342.4574,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1020,'Renta Fija $Med.Plazo- Clase A',381.4668,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,491,'Renta Fija $Med.Plazo- Clase A',2411.5784,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,666,'Renta Fija $Med.Plazo- Clase A',279112.5524,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1408,'Renta Fija $Med.Plazo- Clase A',2575.7908,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1315,'Renta Fija $Med.Plazo- Clase A',2.266,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1297,'Renta Fija $Med.Plazo- Clase A',5.7574,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,314,'Renta Fija $Med.Plazo- Clase A',5296.071,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,128,'Renta Fija $Med.Plazo- Clase A',1.133,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,24,'Renta Fija $Med.Plazo- Clase A',5.7574,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1355,'Renta Fija $Med.Plazo- Clase A',19.6306,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,322,'Renta Fija $Med.Plazo- Clase A',5045.2204,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,348,'Renta Fija $Med.Plazo- Clase A',936.3948,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,275,'Renta Fija $Med.Plazo- Clase A',18.4976,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,232,'Renta Fija $Med.Plazo- Clase A',42.7526,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1144,'Renta Fija $Med.Plazo- Clase A',162.987,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,605,'Renta Fija $Med.Plazo- Clase A',878.636,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1220,'Renta Fija $Med.Plazo- Clase A',19.6306,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1322,'Renta Fija $Med.Plazo- Clase A',1138.7354,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1122,'Renta Fija $Med.Plazo- Clase A',27327.8456,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1181,'Renta Fija $Med.Plazo- Clase A',41.6196,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,65,'Renta Fija $Med.Plazo- Clase A',69.366,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,375,'Renta Fija $Med.Plazo- Clase A',620.8026,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,763,'Renta Fija $Med.Plazo- Clase A',395.34,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,185,'Renta Fija $Med.Plazo- Clase A',3483.3062,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1348,'Renta Fija $Med.Plazo- Clase A',445.0754,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,441,'Renta Fija $Med.Plazo- Clase A',2356.0856,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,430,'Renta Fija $Med.Plazo- Clase A',43.8856,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,897,'Renta Fija $Med.Plazo- Clase A',38.1282,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,59,'Renta Fija $Med.Plazo- Clase A',1176.8636,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,577,'Renta Fija $Med.Plazo- Clase A',2020.8628,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,645,'Renta Fija $Med.Plazo- Clase A',4.6244,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,265,'Renta Fija $Med.Plazo- Clase A',34041.3414,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1251,'Renta Fija $Med.Plazo- Clase A',18442.1072,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,205,'Renta Fija $Med.Plazo- Clase A',883.2604,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,393,'Renta Fija $Med.Plazo- Clase A',2372.3172,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,803,'Renta Fija $Med.Plazo- Clase A',4.6244,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,260,'Renta Fija $Med.Plazo- Clase A',7057.9674,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1226,'Renta Fija $Med.Plazo- Clase A',219.6128,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1212,'Renta Fija $Med.Plazo- Clase A',5167.7208,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1186,'Renta Fija $Med.Plazo- Clase A',94.754,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1189,'Renta Fija $Med.Plazo- Clase A',1257.8368,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1244,'Renta Fija $Med.Plazo- Clase A',157.2296,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,218,'Renta Fija $Med.Plazo- Clase A',506.3256,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,190,'Renta Fija $Med.Plazo- Clase A',986.1302,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,548,'Renta Fija $Med.Plazo- Clase A',46406.987,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,566,'Renta Fija $Med.Plazo- Clase A',21148.5142,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1085,'Renta Fija $Med.Plazo- Clase A',21723.0728,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1305,'Renta Fija $Med.Plazo- Clase A',184.976,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1071,'Renta Fija $Med.Plazo- Clase A',9.2488,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1152,'Renta Fija $Med.Plazo- Clase A',21686.0776,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1254,'Renta Fija $Med.Plazo- Clase A',1514.4448,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1361,'Renta Fija $Med.Plazo- Clase A',29786.8934,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1171,'Renta Fija $Med.Plazo- Clase A',1480.941,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1038,'Renta Fija $Med.Plazo- Clase A',191.8664,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,122,'Renta Fija $Med.Plazo- Clase A',28.8794,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,984,'Renta Fija $Med.Plazo- Clase A',2.266,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,409,'Renta Fija $Med.Plazo- Clase A',588.4318,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,379,'Renta Fija $Med.Plazo- Clase A',1203.477,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,240,'Renta Fija $Med.Plazo- Clase A',1186.1124,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,846,'Renta Fija $Med.Plazo- Clase A',2942.2514,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,847,'Renta Fija $Med.Plazo- Clase A',2973.4892,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,845,'Renta Fija $Med.Plazo- Clase A',31664.3998,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1092,'Renta Fija $Med.Plazo- Clase A',205.7396,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,258,'Renta Fija $Med.Plazo- Clase A',224.2372,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,653,'Renta Fija $Med.Plazo- Clase A',61.2502,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,134,'Renta Fija $Med.Plazo- Clase A',3692.5372,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,743,'Renta Fija $Med.Plazo- Clase A',19520.7254,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1145,'Renta Fija $Med.Plazo- Clase A',7091.4712,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,518,'Renta Fija $Med.Plazo- Clase A',1974.6188,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,386,'Renta Fija $Med.Plazo- Clase A',19.6306,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,309,'Renta Fija $Med.Plazo- Clase A',24.255,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,193,'Renta Fija $Med.Plazo- Clase A',366.4606,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,151,'Renta Fija $Med.Plazo- Clase A',593.0562,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,187,'Renta Fija $Med.Plazo- Clase A',667.0466,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,634,'Renta Fija $Med.Plazo- Clase A',228.8616,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,320,'Renta Fija $Med.Plazo- Clase A',1419.6908,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,53,'Renta Fija $Med.Plazo- Clase A',1583.8108,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,431,'Renta Fija $Med.Plazo- Clase A',2131.8484,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,571,'Renta Fija $Med.Plazo- Clase A',542.1878,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,405,'Renta Fija $Med.Plazo- Clase A',564.1768,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,368,'Renta Fija $Med.Plazo- Clase A',25417.9684,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1295,'Renta Fija $Med.Plazo- Clase A',1489.0568,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,471,'Renta Fija $Med.Plazo- Clase A',397.6984,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,135,'Renta Fija $Med.Plazo- Clase A',3618.5468,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1367,'Renta Fija $Med.Plazo- Clase A',3973.4926,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,665,'Renta Fija $Med.Plazo- Clase A',11.5148,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1133,'Renta Fija $Med.Plazo- Clase A',7488.0366,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,387,'Renta Fija $Med.Plazo- Clase A',38.1282,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1237,'Renta Fija $Med.Plazo- Clase A',196.4908,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,532,'Renta Fija $Med.Plazo- Clase A',1.133,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,483,'Renta Fija $Med.Plazo- Clase A',1012.7436,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1052,'Renta Fija $Med.Plazo- Clase A',9.2488,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,262,'Renta Fija $Med.Plazo- Clase A',972.257,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,294,'Renta Fija $Med.Plazo- Clase A',10136.6848,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,8225,'Renta Fija $Med.Plazo- Clase A',31872.4978,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,10683,'Renta Fija $Med.Plazo- Clase A',13980.6942,'UNICO'

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

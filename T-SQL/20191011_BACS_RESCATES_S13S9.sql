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

INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,189,'Renta Fija $Med.Plazo- Clase A',21.0835399996822,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,110,'Renta Fija $Med.Plazo- Clase A',16.6448999997491,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,209,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1292,'Renta Fija $Med.Plazo- Clase A',17043.2679397431,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,863,'Renta Fija $Med.Plazo- Clase A',82.1148399987622,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1351,'Renta Fija $Med.Plazo- Clase A',11942.16091982,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1301,'Renta Fija $Med.Plazo- Clase A',5237.59519992105,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1206,'Renta Fija $Med.Plazo- Clase A',240.79621999637,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,567,'Renta Fija $Med.Plazo- Clase A',3672.97459994463,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,821,'Renta Fija $Med.Plazo- Clase A',1181.78789998219,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,413,'Renta Fija $Med.Plazo- Clase A',9.98693999984945,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1088,'Renta Fija $Med.Plazo- Clase A',897.714939986467,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,983,'Renta Fija $Med.Plazo- Clase A',722.38865998911,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,237,'Renta Fija $Med.Plazo- Clase A',783.41995998819,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1327,'Renta Fija $Med.Plazo- Clase A',127.610899998076,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,407,'Renta Fija $Med.Plazo- Clase A',17209.7169397406,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,18,'Renta Fija $Med.Plazo- Clase A',457.179919993108,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,449,'Renta Fija $Med.Plazo- Clase A',92.1017799986116,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,606,'Renta Fija $Med.Plazo- Clase A',1243.92885998125,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,509,'Renta Fija $Med.Plazo- Clase A',3375.58571994912,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,335,'Renta Fija $Med.Plazo- Clase A',813.380779987739,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,116,'Renta Fija $Med.Plazo- Clase A',1595.69107997595,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,809,'Renta Fija $Med.Plazo- Clase A',54930.389319172,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,84,'Renta Fija $Med.Plazo- Clase A',16.6448999997491,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,132,'Renta Fija $Med.Plazo- Clase A',7.76761999988291,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1288,'Renta Fija $Med.Plazo- Clase A',499.346999992473,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1060,'Renta Fija $Med.Plazo- Clase A',14.4255799997825,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,255,'Renta Fija $Med.Plazo- Clase A',16.6448999997491,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1194,'Renta Fija $Med.Plazo- Clase A',8788.50719986752,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,417,'Renta Fija $Med.Plazo- Clase A',18.8642199997156,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1104,'Renta Fija $Med.Plazo- Clase A',27073.4846795919,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,607,'Renta Fija $Med.Plazo- Clase A',76936.0567788402,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1020,'Renta Fija $Med.Plazo- Clase A',541.514079991837,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,491,'Renta Fija $Med.Plazo- Clase A',3415.53347994851,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,666,'Renta Fija $Med.Plazo- Clase A',395155.474294043,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1408,'Renta Fija $Med.Plazo- Clase A',3646.34275994503,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1315,'Renta Fija $Med.Plazo- Clase A',5.54829999991636,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1297,'Renta Fija $Med.Plazo- Clase A',9.98693999984945,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,314,'Renta Fija $Med.Plazo- Clase A',7500.19193988694,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,128,'Renta Fija $Med.Plazo- Clase A',3.32897999994982,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1273,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1285,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,24,'Renta Fija $Med.Plazo- Clase A',9.98693999984945,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1355,'Renta Fija $Med.Plazo- Clase A',28.8511599995651,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,322,'Renta Fija $Med.Plazo- Clase A',7142.88141989232,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,348,'Renta Fija $Med.Plazo- Clase A',1328.26301997998,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,275,'Renta Fija $Med.Plazo- Clase A',26.6318399995985,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,232,'Renta Fija $Med.Plazo- Clase A',63.2506199990465,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1144,'Renta Fija $Med.Plazo- Clase A',231.918939996504,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,605,'Renta Fija $Med.Plazo- Clase A',1243.92885998125,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1220,'Renta Fija $Med.Plazo- Clase A',28.8511599995651,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1322,'Renta Fija $Med.Plazo- Clase A',1612.33597997569,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1122,'Renta Fija $Med.Plazo- Clase A',38690.5152194168,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1181,'Renta Fija $Med.Plazo- Clase A',58.8119799991134,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,65,'Renta Fija $Med.Plazo- Clase A',98.7597399985113,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,375,'Renta Fija $Med.Plazo- Clase A',881.070039986718,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1291,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,763,'Renta Fija $Med.Plazo- Clase A',560.378299991553,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,185,'Renta Fija $Med.Plazo- Clase A',4933.54835992563,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1348,'Renta Fija $Med.Plazo- Clase A',632.506199990465,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,441,'Renta Fija $Med.Plazo- Clase A',3337.85727994968,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,430,'Renta Fija $Med.Plazo- Clase A',64.3602799990298,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1319,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,897,'Renta Fija $Med.Plazo- Clase A',54.3733399991804,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,59,'Renta Fija $Med.Plazo- Clase A',1667.81897997486,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,577,'Renta Fija $Med.Plazo- Clase A',2860.70347995688,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,645,'Renta Fija $Med.Plazo- Clase A',7.76761999988291,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,265,'Renta Fija $Med.Plazo- Clase A',48195.8627792735,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1251,'Renta Fija $Med.Plazo- Clase A',26110.2997996064,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,205,'Renta Fija $Med.Plazo- Clase A',1251.69647998113,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,393,'Renta Fija $Med.Plazo- Clase A',3358.94081994937,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,803,'Renta Fija $Med.Plazo- Clase A',7.76761999988291,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,260,'Renta Fija $Med.Plazo- Clase A',9994.70761984934,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1226,'Renta Fija $Med.Plazo- Clase A',314.033779995266,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1212,'Renta Fija $Med.Plazo- Clase A',7318.20769988968,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1186,'Renta Fija $Med.Plazo- Clase A',136.488179997943,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1189,'Renta Fija $Med.Plazo- Clase A',1781.00429997315,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1244,'Renta Fija $Med.Plazo- Clase A',223.041659996638,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1250,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,218,'Renta Fija $Med.Plazo- Clase A',717.950019989177,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1094,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,190,'Renta Fija $Med.Plazo- Clase A',1397.06193997894,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1193,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,548,'Renta Fija $Med.Plazo- Clase A',65701.8589390096,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,566,'Renta Fija $Med.Plazo- Clase A',29941.9557795486,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1085,'Renta Fija $Med.Plazo- Clase A',30755.3365595364,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1305,'Renta Fija $Med.Plazo- Clase A',262.989419996036,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1071,'Renta Fija $Med.Plazo- Clase A',14.4255799997825,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1152,'Renta Fija $Med.Plazo- Clase A',30704.2921995372,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1265,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1253,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1256,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1254,'Renta Fija $Med.Plazo- Clase A',2144.97277996767,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1225,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1361,'Renta Fija $Med.Plazo- Clase A',42171.5186393643,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1171,'Renta Fija $Med.Plazo- Clase A',2097.25739996839,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1038,'Renta Fija $Med.Plazo- Clase A',274.086019995868,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,122,'Renta Fija $Med.Plazo- Clase A',42.1670799993644,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,984,'Renta Fija $Med.Plazo- Clase A',5.54829999991636,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,409,'Renta Fija $Med.Plazo- Clase A',834.464319987421,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,379,'Renta Fija $Med.Plazo- Clase A',1705.54741997429,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,240,'Renta Fija $Med.Plazo- Clase A',1680.02523997467,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,846,'Renta Fija $Med.Plazo- Clase A',4165.6636399372,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,847,'Renta Fija $Med.Plazo- Clase A',4210.05003993654,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,845,'Renta Fija $Med.Plazo- Clase A',44830.2639993242,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1092,'Renta Fija $Med.Plazo- Clase A',292.950239995584,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,258,'Renta Fija $Med.Plazo- Clase A',319.582079995182,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,653,'Renta Fija $Med.Plazo- Clase A',87.6631399986785,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,134,'Renta Fija $Med.Plazo- Clase A',5228.71791992118,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1173,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,743,'Renta Fija $Med.Plazo- Clase A',27637.1919595834,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1145,'Renta Fija $Med.Plazo- Clase A',10041.3133398486,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1058,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,518,'Renta Fija $Med.Plazo- Clase A',2795.23353995786,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,386,'Renta Fija $Med.Plazo- Clase A',28.8511599995651,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,309,'Renta Fija $Med.Plazo- Clase A',35.5091199994647,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,193,'Renta Fija $Med.Plazo- Clase A',520.430539992155,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,151,'Renta Fija $Med.Plazo- Clase A',841.122279987321,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,187,'Renta Fija $Med.Plazo- Clase A',946.539979985731,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,634,'Renta Fija $Med.Plazo- Clase A',326.240039995082,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,320,'Renta Fija $Med.Plazo- Clase A',2010.70391996969,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,53,'Renta Fija $Med.Plazo- Clase A',2242.62285996619,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1316,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,431,'Renta Fija $Med.Plazo- Clase A',3019.38485995448,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,571,'Renta Fija $Med.Plazo- Clase A',768.994379988408,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,405,'Renta Fija $Med.Plazo- Clase A',798.955199987956,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,368,'Renta Fija $Med.Plazo- Clase A',35987.3834594575,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1295,'Renta Fija $Med.Plazo- Clase A',2108.35399996822,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,471,'Renta Fija $Med.Plazo- Clase A',564.816939991486,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,135,'Renta Fija $Med.Plazo- Clase A',5125.51953992274,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1367,'Renta Fija $Med.Plazo- Clase A',5625.97619991519,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,665,'Renta Fija $Med.Plazo- Clase A',18.8642199997156,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1133,'Renta Fija $Med.Plazo- Clase A',10601.6916398402,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,387,'Renta Fija $Med.Plazo- Clase A',54.3733399991804,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1237,'Renta Fija $Med.Plazo- Clase A',279.634319995785,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,532,'Renta Fija $Med.Plazo- Clase A',3.32897999994982,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1183,'Renta Fija $Med.Plazo- Clase A',1.10965999998327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,483,'Renta Fija $Med.Plazo- Clase A',1435.90003997835,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,1052,'Renta Fija $Med.Plazo- Clase A',14.4255799997825,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,262,'Renta Fija $Med.Plazo- Clase A',1378.19771997922,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,294,'Renta Fija $Med.Plazo- Clase A',14350.1231197837,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,8225,'Renta Fija $Med.Plazo- Clase A',45125.4335593198,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 101,10683,'Renta Fija $Med.Plazo- Clase A',19795.2247397016,'UNICO'

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

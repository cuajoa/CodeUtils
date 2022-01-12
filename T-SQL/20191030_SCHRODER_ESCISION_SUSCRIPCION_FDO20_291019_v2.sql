BEGIN TRANSACTION;  
BEGIN TRY 

	/***************************/
	DECLARE @VISUALIZAR_DATOS Boolean = 0	/* -1 = MUESTRA LA INFO A IMPACTAR PARA QUE LA VALIDE EL CLIENTE
												0 = IMPACTAC LAS SOLICITUDES DE TRANSFERENCIAS EN LA BD */
	/***************************/

	DECLARE @Fecha Fecha = '20191029'

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
	--INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,90,'A',44227.68,'CLASE A - PESOS'
	--INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,540,'A',39289.96,'CLASE A - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100046,'C',721.56,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100047,'C',687.36,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100048,'C',2155.85,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100049,'C',1535.8,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100050,'C',1170.61,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100051,'C',802.11,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100052,'C',1108.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100053,'C',1033.8,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100054,'C',1475.12,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100055,'C',799.9,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100057,'C',670.81,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100058,'C',833,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100059,'C',2970.1,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100060,'C',890.37,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100061,'C',1052.55,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100062,'C',1255.57,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100063,'C',1075.72,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100065,'C',1050.35,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100067,'C',4062.38,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100068,'C',2207.71,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100069,'C',920.16,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100070,'C',3980.73,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100072,'C',1264.39,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100073,'C',1857.96,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100074,'C',2972.3,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100075,'C',798.8,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100076,'C',1351.55,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100077,'C',1037.11,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100078,'C',1209.23,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100079,'C',15471.67,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100080,'C',1782.94,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100081,'C',3487.55,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100082,'C',1287.55,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100083,'C',1511.54,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100084,'C',1000.69,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100085,'C',830.79,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100086,'C',1256.66,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100087,'C',1861.28,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100088,'C',2458.16,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100089,'C',1102.21,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100090,'C',962.08,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100091,'C',1146.34,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100092,'C',1531.39,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100093,'C',8454.63,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100094,'C',1115.44,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100095,'C',8211.91,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100096,'C',1521.46,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100099,'C',1434.29,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100100,'C',1155.16,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100101,'C',2901.7,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100102,'C',1611.93,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100103,'C',1651.65,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100104,'C',924.58,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100105,'C',1071.31,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100106,'C',549.44,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100107,'C',1032.69,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100108,'C',2087.45,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100109,'C',988.56,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100110,'C',32550.84,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100111,'C',2661.18,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100112,'C',1679.23,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100114,'C',819.75,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100115,'C',1558.97,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100117,'C',686.25,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100118,'C',2219.85,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100119,'C',18023.61,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100121,'C',841.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100122,'C',2314.74,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100123,'C',450.15,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100124,'C',858.37,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100125,'C',3839.5,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100126,'C',967.6,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100127,'C',905.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100128,'C',1263.29,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100129,'C',2101.8,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100130,'C',1472.91,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100131,'C',7677.91,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100132,'C',1725.57,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100133,'C',1355.97,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100134,'C',1825.98,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100135,'C',1781.85,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100136,'C',1021.66,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100137,'C',846.24,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100138,'C',1870.11,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100139,'C',1212.53,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100140,'C',1475.12,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100141,'C',1002.9,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100142,'C',1193.78,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100143,'C',1074.63,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100144,'C',1480.63,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100145,'C',1680.33,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100146,'C',1172.81,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100147,'C',1616.34,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100148,'C',1201.5,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100149,'C',1561.18,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100150,'C',1578.83,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100151,'C',2504.5,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100152,'C',685.15,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100153,'C',1209.23,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100154,'C',2383.14,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100155,'C',900.3,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100158,'C',6433.38,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100159,'C',1450.84,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100160,'C',1233.5,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100161,'C',1696.88,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100162,'C',799.9,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100163,'C',14871.46,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100164,'C',2060.98,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100165,'C',919.06,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100166,'C',2277.22,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100167,'C',825.27,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100168,'C',1296.39,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100169,'C',1891.07,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100172,'C',1628.48,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100173,'C',2521.05,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100174,'C',960.98,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100175,'C',2952.44,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100176,'C',887.06,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100177,'C',4287.45,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100178,'C',1588.76,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100179,'C',1622.96,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100180,'C',1279.84,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100181,'C',2076.42,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100182,'C',1659.38,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100183,'C',1159.58,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100184,'C',1168.4,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100185,'C',2172.42,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100186,'C',975.32,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100188,'C',1165.1,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100189,'C',1168.4,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100190,'C',70.61,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100191,'C',1172.81,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100192,'C',835.2,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100193,'C',1575.52,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100194,'C',1053.66,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100195,'C',2144.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100196,'C',753.56,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100197,'C',1101.1,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100198,'C',1188.26,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100199,'C',841.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100200,'C',10721.92,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100201,'C',1192.68,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100202,'C',1363.68,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100203,'C',1232.39,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100204,'C',824.17,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100205,'C',7113.02,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100206,'C',1084.55,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100207,'C',895.88,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100208,'C',1181.64,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100209,'C',4068.99,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100210,'C',2630.28,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100212,'C',677.43,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100213,'C',943.32,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100214,'C',2763.78,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100215,'C',2678.83,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100216,'C',1639.51,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100217,'C',1438.71,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100218,'C',2361.08,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100219,'C',2292.68,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100220,'C',3328.68,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100221,'C',910.22,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100222,'C',1172.81,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100224,'C',1115.44,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100226,'C',2115.04,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100227,'C',2280.53,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100228,'C',778.93,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100229,'C',1236.81,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100230,'C',11998.46,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100231,'C',2.21,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100232,'C',1150.74,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100233,'C',1072.42,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100234,'C',2569.6,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100235,'C',2342.32,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100236,'C',1280.94,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100237,'C',805.41,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100238,'C',1080.14,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100239,'C',1012.84,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100240,'C',2425.07,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100241,'C',1108.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100242,'C',1205.92,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100243,'C',1129.79,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100244,'C',824.17,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100245,'C',1239.02,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100246,'C',2162.48,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100247,'C',17249.09,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100248,'C',2025.67,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100263,'C',927.88,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100266,'C',5810.01,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100269,'C',39243.5,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100270,'C',4232.28,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100271,'C',11451.21,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100272,'C',1532.49,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100273,'C',3816.34,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100274,'C',2216.55,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100275,'C',3185.24,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100276,'C',17993.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100277,'C',1881.14,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100278,'C',2492.37,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100279,'C',6235.89,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100280,'C',3369.5,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100281,'C',3581.33,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100282,'C',1375.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100283,'C',8039.79,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100287,'C',1944.03,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100288,'C',7512.41,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100289,'C',2474.71,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100290,'C',2698.68,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100292,'C',11055.12,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100294,'C',10970.17,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100295,'C',6046.12,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100296,'C',5312.41,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100297,'C',7119.63,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100305,'C',14841.67,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100311,'C',12200.36,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100312,'C',783.35,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100313,'C',936.71,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100315,'C',835.2,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100316,'C',754.66,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100317,'C',456.77,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100318,'C',773.41,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100320,'C',1082.34,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100322,'C',906.92,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100323,'C',996.29,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100324,'C',990.77,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100325,'C',441.33,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100326,'C',12405.58,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100329,'C',412.64,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100335,'C',364.09,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100336,'C',388.36,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100339,'C',412.64,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100340,'C',778.93,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100341,'C',307.83,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100342,'C',255.97,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100343,'C',180.94,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100344,'C',183.15,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100345,'C',184.25,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100346,'C',308.92,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100347,'C',430.29,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100348,'C',734.8,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100349,'C',834.09,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100350,'C',556.07,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100351,'C',721.56,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100352,'C',990.77,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100353,'C',634.4,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100354,'C',2984.44,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100355,'C',1287.55,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100356,'C',652.06,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100357,'C',1881.14,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100358,'C',527.38,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100359,'C',590.27,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100360,'C',2035.59,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100361,'C',482.15,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100362,'C',547.23,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100363,'C',707.22,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100364,'C',1087.86,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100365,'C',1315.15,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100366,'C',980.84,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100367,'C',807.62,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100370,'C',675.22,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100371,'C',977.53,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100372,'C',1315.15,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100373,'C',883.75,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100374,'C',940.01,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100375,'C',5041.01,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100376,'C',1564.49,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100378,'C',1136.4,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100379,'C',895.88,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100380,'C',825.27,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100381,'C',470.01,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100382,'C',404.91,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100383,'C',537.31,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100384,'C',317.75,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100385,'C',1828.17,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100386,'C',2406.31,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100387,'C',1122.06,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100388,'C',1865.69,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100389,'C',1714.54,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100390,'C',1747.64,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100391,'C',742.53,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100392,'C',1415.54,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100393,'C',1718.94,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100395,'C',1476.23,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100396,'C',1587.65,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100397,'C',780.04,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100398,'C',977.53,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100399,'C',440.22,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100400,'C',666.4,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100401,'C',524.07,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100402,'C',1329.49,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100403,'C',792.17,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100404,'C',1709.02,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100405,'C',1020.56,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100406,'C',1384.65,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100407,'C',2432.79,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100408,'C',1341.62,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100409,'C',2118.35,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100410,'C',622.27,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100411,'C',1391.26,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100412,'C',528.49,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100413,'C',8332.16,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100414,'C',612.33,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100415,'C',700.6,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100416,'C',1010.63,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100417,'C',612.33,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100418,'C',552.75,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100419,'C',1085.66,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100420,'C',618.96,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100421,'C',604.61,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100422,'C',723.77,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100423,'C',1296.39,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100424,'C',119.16,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100425,'C',795.48,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100426,'C',759.07,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100427,'C',776.72,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100428,'C',1108.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100429,'C',763.49,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100430,'C',144.53,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100431,'C',931.19,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100432,'C',1864.59,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100433,'C',1918.65,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100434,'C',711.64,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100435,'C',1167.29,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100436,'C',922.37,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100437,'C',205.21,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100438,'C',474.42,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100439,'C',824.17,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100440,'C',594.68,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100441,'C',524.07,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100442,'C',529.59,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100443,'C',553.86,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100444,'C',763.49,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100445,'C',1430.99,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100446,'C',597.99,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100447,'C',375.12,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100448,'C',1168.4,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100449,'C',750.25,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100450,'C',1197.08,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100451,'C',745.83,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100452,'C',1387.96,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100453,'C',1893.27,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100454,'C',446.84,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100455,'C',522.97,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100456,'C',679.64,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100457,'C',188.66,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100458,'C',1150.74,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100459,'C',1487.26,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100460,'C',739.22,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100461,'C',601.3,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100462,'C',453.46,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100463,'C',1021.66,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100464,'C',905.82,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100465,'C',851.75,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100466,'C',654.27,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100467,'C',656.46,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100468,'C',703.91,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100469,'C',839.61,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100470,'C',552.75,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100471,'C',2667.79,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100472,'C',1083.45,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100473,'C',675.22,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100474,'C',670.81,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100475,'C',522.97,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100476,'C',802.11,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100477,'C',1002.9,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100478,'C',311.13,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100479,'C',1753.15,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100480,'C',801,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100481,'C',1029.39,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100482,'C',1069.11,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100483,'C',1079.03,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100484,'C',1360.37,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100485,'C',1467.39,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100486,'C',981.95,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100487,'C',426.97,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100488,'C',1237.91,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100489,'C',997.39,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100490,'C',711.64,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100491,'C',803.21,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100492,'C',1027.18,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100493,'C',1167.29,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100494,'C',699.49,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100495,'C',1310.73,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100497,'C',920.16,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100498,'C',1752.06,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100499,'C',359.68,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100500,'C',689.57,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100501,'C',1378.03,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100502,'C',3137.8,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100503,'C',735.9,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100504,'C',851.75,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100505,'C',819.75,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100506,'C',519.65,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100507,'C',1097.79,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100508,'C',753.56,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100509,'C',248.25,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100510,'C',793.27,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100511,'C',723.77,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100512,'C',994.08,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100513,'C',1135.31,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100514,'C',1992.57,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100515,'C',1059.18,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100516,'C',1711.23,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100517,'C',324.37,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100518,'C',485.46,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100519,'C',1004.01,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100520,'C',276.92,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100521,'C',502.01,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100522,'C',714.94,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100523,'C',1343.83,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100524,'C',620.06,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100525,'C',415.94,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100535,'C',271.41,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100539,'C',291.28,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 20,100540,'C',305.62,'CLASE C - PESOS'

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
	
	--SELECT * FROM #TEMPEXCEL
	

	IF @VISUALIZAR_DATOS = -1
	BEGIN
		SELECT FONDOSREAL.NumFondo NroFondo,
			   FONDOSREAL.Nombre Fondo,
			   FONDOSREAL.NombreAbreviado FondoAbreviatura,
			   TPVALORESCP.Abreviatura Clase,
			   CONDICIONESINGEGR.Descripcion CondicionIngEgr,
			   CUOTAPARTISTAS.NumCuotapartista,
			   CUOTAPARTISTAS.Nombre Cuotapartista,
			   #TEMPEXCEL.FechaConcertacion,
			   #TEMPEXCEL.FechaAcreditacion,
			   #TEMPEXCEL.CantCuotasAPasar,
			   #TEMPEXCEL.CodMoneda,
			   #TEMPEXCEL.CodCanalVta
		FROM #TEMPEXCEL
			 inner join FONDOSREAL ON #TEMPEXCEL.CodFondo = FONDOSREAL.CodFondo
			 inner join TPVALORESCP on #TEMPEXCEL.CodFondo = TPVALORESCP.CodFondo
									   and #TEMPEXCEL.CodTpValorCp = TPVALORESCP.CodTpValorCp
			 inner join CUOTAPARTISTAS on CUOTAPARTISTAS.CodCuotapartista = #TEMPEXCEL.CodCuotapartista
			 inner join CONDICIONESINGEGR on #TEMPEXCEL.CodFondo = CONDICIONESINGEGR.CodFondo
											and #TEMPEXCEL.CodCondicionIngEgr = CONDICIONESINGEGR.CodCondicionIngEgr


	END
	ELSE
	BEGIN

		SET @i = 1
		SET @Total = (SELECT COUNT(*) FROM #TEMPEXCEL)

			
		/*datos de la suscripcion fijos*/
		DECLARE @CodUsuarioAuditoria  numeric(10)=1
		DECLARE @PorcGastos  numeric(12,8)=0
		DECLARE @CodInterfaz varchar(15) = null
		DECLARE @CodAccion varchar(12)='SOLSUSCa'
		DECLARE @FechaConcertacion smalldatetime 
		DECLARE @FechaAcreditacion smalldatetime
			
		/*variables*/
		declare @CodFondoS numeric(5,0) 
		declare @CodAgColocadorS numeric(5,0) 
		declare @CodSucursalS  numeric(5,0) 
		declare @CodSolSusc numeric(10,0) 
		declare @CodCanalVtaS numeric(5,0) --ver de donde lo tomo
		declare @CodOficialCtaS numeric(5,0) 
		declare @CodCondicionIngEgrS numeric(5,0) 
		declare @CodTpValorCpS numeric(5,0)
		declare @CodMonedaS  numeric(5,0) --ver de donde lo tomo
		declare @CodCuotapartistaS numeric(10)
		declare @NumSolicitud  numeric(15)
		declare @Importe numeric(19,2)--CantCuotasAPasar
			
		declare  @CodFormaPagoS  numeric(5,0)  
		declare  @CodItOtro  numeric(5,0)  

		select @NumSolicitud = MAX(NumSolicitud)  from SOLSUSC
			
	
		WHILE (@i <= @Total) 
		BEGIN

			SET @NumSolicitud = @NumSolicitud + 1
	
			SELECT					 
					@CodAgColocadorS= #TEMPEXCEL.CodAgColocador,
					@CodSucursalS =#TEMPEXCEL.CodSucursal,
					@CodFondoS = #TEMPEXCEL.CodFondo,
					@CodCondicionIngEgrS =#TEMPEXCEL.CodCondicionIngEgr,
					@CodCuotapartistaS = #TEMPEXCEL.CodCuotapartista,
					@CodOficialCtaS = #TEMPEXCEL.CodOficialCta,
					@Importe =#TEMPEXCEL.Importe,										  
					@CodTpValorCpS  =#TEMPEXCEL.CodTpValorCp,
					@CodMonedaS = #TEMPEXCEL.CodMoneda,
					@CodCanalVtaS = #TEMPEXCEL.CodCanalVta,
					@FechaConcertacion = #TEMPEXCEL.FechaConcertacion,
					@FechaAcreditacion	= #TEMPEXCEL.FechaAcreditacion	  
				FROM #TEMPEXCEL
			WHERE #TEMPEXCEL.Id = @i
			   
			   
			exec dbo.spESOLSUSCRIPCION @CodFondoS,@CodAgColocadorS,@CodSucursalS,@CodSolSusc output,null,null,null,
				null,@CodCanalVtaS,@CodOficialCtaS,@CodCondicionIngEgrS,@CodTpValorCpS,@CodMonedaS,@CodCuotapartistaS,null,@NumSolicitud,
				@CodUsuarioAuditoria,@Importe,@PorcGastos,null,@FechaConcertacion,@FechaAcreditacion,null,null,null,
				null,null,null,1,@CodInterfaz,null,null,null,null,
				null,0,0,null,0,0,NULL,null,'VF','NOREQ',null,
				null,null,null,'SU',null,@CodAccion,@CodUsuarioAuditoria,null
	

			SELECT @CodFormaPagoS = CodFormaPago FROM FORMASPAGO where CodTpFormaPago = 'OT'
			   
			   
			if (@CodFormaPagoS is not null) begin 	
			   				   			   
				exec dbo.spESOLITOTROS @CodFondoS,@CodAgColocadorS,@CodSucursalS,@CodSolSusc,@CodItOtro output,@CodFormaPagoS,null,@Importe,'SOLSUSCOTROSa',NULL

			end
			   

			SET @i = @i + 1
		
		   
		END


	END

END TRY
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage;  

    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION;  
END CATCH;  

IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;  

GO






	
								 
			
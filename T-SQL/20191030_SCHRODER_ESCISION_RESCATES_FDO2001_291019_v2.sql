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

	--INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,90,'A',2641.606225,'CLASE A - PESOS'
	--INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,540,'A',2346.688901,'CLASE A - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100046,'C',42.298471,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100047,'C',40.293874,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100048,'C',126.378169,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100049,'C',90.029841,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100050,'C',68.622349,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100051,'C',47.020249,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100052,'C',65.000173,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100053,'C',60.602495,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100054,'C',86.472778,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100055,'C',46.890755,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100057,'C',39.323765,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100058,'C',48.830972,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100059,'C',174.110271,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100060,'C',52.19416,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100061,'C',61.701366,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100062,'C',73.602383,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100063,'C',63.059956,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100065,'C',61.572603,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100067,'C',238.140336,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100068,'C',129.417988,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100069,'C',53.940501,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100070,'C',233.354176,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100072,'C',74.119628,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100073,'C',108.915491,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100074,'C',174.239033,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100075,'C',46.826374,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100076,'C',79.229157,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100077,'C',60.796371,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100078,'C',70.885934,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100079,'C',906.963335,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100080,'C',104.517814,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100081,'C',204.443344,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100082,'C',75.477487,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100083,'C',88.607601,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100084,'C',58.661547,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100085,'C',48.701478,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100086,'C',73.666765,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100087,'C',109.110098,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100088,'C',144.099836,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100089,'C',64.612422,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100090,'C',56.397962,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100091,'C',67.199377,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100092,'C',89.771584,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100093,'C',495.618454,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100094,'C',65.387923,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100095,'C',481.389469,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100096,'C',89.189227,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100099,'C',84.079698,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100100,'C',67.716622,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100101,'C',170.100344,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100102,'C',94.492631,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100103,'C',96.82133,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100104,'C',54.199489,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100105,'C',62.800968,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100106,'C',32.208907,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100107,'C',60.537382,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100108,'C',122.368243,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100109,'C',57.950427,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100110,'C',1908.160314,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100111,'C',156.000854,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100112,'C',98.438177,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100114,'C',48.054739,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100115,'C',91.388431,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100117,'C',40.228761,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100118,'C',130.12984,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100119,'C',1056.560451,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100121,'C',49.348216,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100122,'C',135.692232,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100123,'C',26.388258,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100124,'C',50.318324,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100125,'C',225.075335,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100126,'C',56.721331,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100127,'C',53.099886,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100128,'C',74.055247,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100129,'C',123.209588,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100130,'C',86.343284,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100131,'C',450.086289,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100132,'C',101.154626,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100133,'C',79.488145,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100134,'C',107.040388,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100135,'C',104.453432,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100136,'C',59.890644,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100137,'C',49.607204,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100138,'C',109.627343,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100139,'C',71.07981,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100140,'C',86.472778,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100141,'C',58.791041,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100142,'C',69.980207,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100143,'C',62.995575,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100144,'C',86.796147,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100145,'C',98.502558,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100146,'C',68.751111,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100147,'C',94.751619,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100148,'C',70.433071,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100149,'C',91.517925,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100150,'C',92.552415,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100151,'C',146.816285,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100152,'C',40.164379,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100153,'C',70.885934,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100154,'C',139.702159,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100155,'C',52.776517,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100158,'C',377.130643,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100159,'C',85.049806,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100160,'C',72.308906,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100161,'C',99.472666,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100162,'C',46.890755,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100163,'C',871.77899,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100164,'C',120.816509,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100165,'C',53.876119,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100166,'C',133.493028,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100167,'C',48.378108,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100168,'C',75.995463,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100169,'C',110.856439,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100172,'C',95.462739,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100173,'C',147.786393,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100174,'C',56.33358,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100175,'C',173.07505,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100176,'C',52.000284,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100177,'C',251.334099,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100178,'C',93.134772,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100179,'C',95.13937,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100180,'C',75.025355,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100181,'C',121.721504,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100182,'C',97.274193,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100183,'C',67.97561,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100184,'C',68.492855,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100185,'C',127.349009,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100186,'C',57.174194,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100188,'C',68.298979,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100189,'C',68.492855,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100190,'C',4.13942,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100191,'C',68.751111,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100192,'C',48.960466,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100193,'C',92.358539,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100194,'C',61.766479,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100195,'C',125.731431,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100196,'C',44.174306,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100197,'C',64.547309,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100198,'C',69.656838,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100199,'C',49.348216,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100200,'C',628.529125,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100201,'C',69.915826,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100202,'C',79.940277,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100203,'C',72.243793,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100204,'C',48.313727,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100205,'C',416.971654,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100206,'C',63.577201,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100207,'C',52.517529,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100208,'C',69.269087,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100209,'C',238.528086,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100210,'C',154.1894,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100212,'C',39.711516,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100213,'C',55.298359,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100214,'C',162.015378,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100215,'C',157.035343,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100216,'C',96.109478,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100217,'C',84.338686,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100218,'C',138.408681,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100219,'C',134.398754,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100220,'C',195.130013,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100221,'C',53.358143,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100222,'C',68.751111,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100224,'C',65.387923,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100226,'C',123.985821,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100227,'C',133.686903,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100228,'C',45.661659,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100229,'C',72.502781,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100230,'C',703.360605,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100231,'C',0.129494,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100232,'C',67.457634,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100233,'C',62.866081,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100234,'C',150.632337,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100235,'C',137.309079,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100236,'C',75.089736,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100237,'C',47.214125,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100238,'C',63.318944,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100239,'C',59.373399,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100240,'C',142.15962,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100241,'C',65.000173,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100242,'C',70.692059,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100243,'C',66.229269,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100244,'C',48.313727,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100245,'C',72.632275,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100246,'C',126.766652,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100247,'C',1011.15778,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100248,'C',118.746798,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100263,'C',54.393364,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100266,'C',340.58844,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100269,'C',2300.49005,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100270,'C',248.100406,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100271,'C',671.28046,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100272,'C',89.835966,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100273,'C',223.717476,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100274,'C',129.935964,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100275,'C',186.721677,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100276,'C',1054.81411,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100277,'C',110.274081,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100278,'C',146.105165,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100279,'C',365.553727,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100280,'C',197.523092,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100281,'C',209.940623,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100282,'C',80.652129,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100283,'C',471.299906,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100287,'C',113.960639,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100288,'C',440.384475,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100289,'C',145.069944,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100290,'C',158.199327,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100292,'C',648.061513,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100294,'C',643.081479,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100295,'C',354.428942,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100296,'C',311.418619,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100297,'C',417.359405,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100305,'C',870.032649,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100311,'C',715.19651,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100312,'C',45.920647,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100313,'C',54.910609,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100315,'C',48.960466,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100316,'C',44.238687,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100317,'C',26.776009,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100318,'C',45.33829,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100320,'C',63.447707,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100322,'C',53.164268,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100323,'C',58.403291,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100324,'C',58.079921,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100325,'C',25.871014,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100326,'C',727.22629,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100329,'C',24.189054,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100335,'C',21.343111,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100336,'C',22.766082,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100339,'C',24.189054,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100340,'C',45.661659,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100341,'C',18.045035,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100342,'C',15.005217,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100343,'C',10.606808,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100344,'C',10.736302,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100345,'C',10.800683,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100346,'C',18.109417,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100347,'C',25.224275,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100348,'C',43.074704,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100349,'C',48.895353,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100350,'C',32.597389,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100351,'C',42.298471,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100352,'C',58.079921,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100353,'C',37.188942,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100354,'C',174.950885,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100355,'C',75.477487,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100356,'C',38.224163,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100357,'C',110.274081,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100358,'C',30.91543,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100359,'C',34.601987,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100360,'C',119.328424,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100361,'C',28.264093,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100362,'C',32.079413,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100363,'C',41.457857,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100364,'C',63.771076,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100365,'C',77.095065,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100366,'C',57.497564,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100367,'C',47.343619,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100370,'C',39.582022,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100371,'C',57.303688,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100372,'C',77.095065,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100373,'C',51.806409,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100374,'C',55.104484,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100375,'C',295.508406,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100376,'C',91.711801,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100378,'C',66.617019,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100379,'C',52.517529,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100380,'C',48.378108,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100381,'C',27.552242,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100382,'C',23.73619,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100383,'C',31.497787,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100384,'C',18.626661,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100385,'C',107.16915,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100386,'C',141.060018,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100387,'C',65.776405,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100388,'C',109.368354,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100389,'C',100.507887,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100390,'C',102.448103,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100391,'C',43.527567,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100392,'C',82.980096,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100393,'C',100.766144,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100395,'C',86.537891,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100396,'C',93.069659,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100397,'C',45.726772,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100398,'C',57.303688,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100399,'C',25.805901,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100400,'C',39.064777,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100401,'C',30.721554,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100402,'C',77.93568,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100403,'C',46.437892,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100404,'C',100.184518,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100405,'C',59.826262,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100406,'C',81.169373,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100407,'C',142.612483,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100408,'C',78.6468,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100409,'C',124.179697,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100410,'C',36.477822,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100411,'C',81.557124,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100412,'C',30.980543,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100413,'C',488.439215,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100414,'C',35.895465,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100415,'C',41.070106,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100416,'C',59.243905,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100417,'C',35.895465,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100418,'C',32.402783,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100419,'C',63.642314,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100420,'C',36.283947,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100421,'C',35.442601,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100422,'C',42.427965,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100423,'C',75.995463,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100424,'C',6.985364,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100425,'C',46.631767,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100426,'C',44.497676,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100427,'C',45.532165,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100428,'C',65.000173,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100429,'C',44.756664,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100430,'C',8.472716,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100431,'C',54.587239,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100432,'C',109.303973,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100433,'C',112.473286,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100434,'C',41.716845,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100435,'C',68.427742,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100436,'C',54.069995,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100437,'C',12.02978,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100438,'C',27.81123,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100439,'C',48.313727,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100440,'C',34.860975,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100441,'C',30.721554,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100442,'C',31.044924,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100443,'C',32.467895,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100444,'C',44.756664,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100445,'C',83.885823,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100446,'C',35.05485,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100447,'C',21.989849,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100448,'C',68.492855,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100449,'C',43.980431,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100450,'C',70.174083,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100451,'C',43.721443,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100452,'C',81.363249,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100453,'C',110.985201,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100454,'C',26.194383,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100455,'C',30.657173,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100456,'C',39.84101,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100457,'C',11.059671,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100458,'C',67.457634,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100459,'C',87.184629,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100460,'C',43.333692,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100461,'C',35.248726,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100462,'C',26.582134,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100463,'C',59.890644,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100464,'C',53.099886,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100465,'C',49.930574,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100466,'C',38.353657,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100467,'C',38.48242,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100468,'C',41.263982,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100469,'C',49.218722,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100470,'C',32.402783,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100471,'C',156.388604,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100472,'C',63.51282,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100473,'C',39.582022,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100474,'C',39.323765,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100475,'C',30.657173,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100476,'C',47.020249,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100477,'C',58.791041,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100478,'C',18.238911,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100479,'C',102.771473,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100480,'C',46.955137,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100481,'C',60.343507,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100482,'C',62.672206,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100483,'C',63.253832,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100484,'C',79.746402,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100485,'C',86.019914,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100486,'C',57.562677,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100487,'C',25.029668,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100488,'C',72.567162,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100489,'C',58.467672,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100490,'C',41.716845,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100491,'C',47.084631,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100492,'C',60.214013,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100493,'C',68.427742,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100494,'C',41.004994,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100495,'C',76.836077,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100497,'C',53.940501,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100498,'C',102.707091,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100499,'C',21.084854,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100500,'C',40.423368,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100501,'C',80.781623,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100502,'C',183.940847,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100503,'C',43.139085,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100504,'C',49.930574,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100505,'C',48.054739,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100506,'C',30.462566,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100507,'C',64.353434,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100508,'C',44.174306,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100509,'C',14.552353,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100510,'C',46.502273,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100511,'C',42.427965,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100512,'C',58.273797,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100513,'C',66.552638,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100514,'C',116.806582,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100515,'C',62.089848,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100516,'C',100.314012,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100517,'C',19.015144,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100518,'C',28.457969,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100519,'C',58.856154,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100520,'C',16.233582,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100521,'C',29.428077,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100522,'C',41.91072,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100523,'C',78.776294,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100524,'C',36.348328,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100525,'C',24.382929,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100535,'C',15.910212,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100539,'C',17.074927,'CLASE C - PESOS'
	INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,CantCuotasAPasar,CondicionIngEgr) select 2001,100540,'C',17.915541,'CLASE C - PESOS'


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
				declare @CantCuotasAPasar numeric(22,8)--CantCuotasAPasar
			
				declare  @CodFormaPagoS  numeric(5,0)  
				declare  @CodItOtro  numeric(5,0)  

    
		select @NumSolicitud =MAX(NumSolicitud)  from SOLRESC

			
	
		WHILE (@i <= @Total) 
		BEGIN
			
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
					@CantCuotasAPasar =#TEMPEXCEL.CantCuotasAPasar,										  
					@CodTpValorCpS  =#TEMPEXCEL.CodTpValorCp,
					@CodMonedaS = #TEMPEXCEL.CodMoneda,
					@CodCanalVtaS = #TEMPEXCEL.CodCanalVta					  
				FROM #TEMPEXCEL
			WHERE #TEMPEXCEL.Id = @i
			   
			SELECT @CodFormaPagoS = CodFormaPago FROM  FORMASPAGO where CodTpFormaPago = 'OT'
			   		   
			if (@CodFormaPagoS is not null) begin 		   
			   
				exec dbo.spESOLRESCATE @CodFondoS,@CodAgColocadorS,@CodSucursalS,@CodSolResc,@CodFormaPagoS,
				null,null,null,null,null,1,null,null,null,null,null,null,
				@CodCanalVtaS,@CodOficialCtaS,@CodCondicionIngEgr,@CodTpValorCpS,@CodCuotapartistaS, @NumSolicitud /*@NumSolicitud*/,@CantCuotasAPasar,
				NULL /*@Importe*/,@PorcGastos,@FechaConcertacion,@FechaAcreditacion,/*@NumReferencia*/null,@CodUsuarioAuditoria,0,0,0,@CodInterfaz,
				@CodMonedaS,@CodUsuarioAuditoria,null,null,null,null,0,NULL,0,0,null,null,-1,'VF','NOREQ',null,null,null,0,'RE',null,
				@CodAccion,null			
				
			END
			   

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

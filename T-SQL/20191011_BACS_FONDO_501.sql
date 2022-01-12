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

INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9841,'Renta Fija $ Corto Plazo - A',254.07268,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8541,'Renta Fija $ Corto Plazo - A',311.495622,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4155,'Renta Fija $ Corto Plazo - A',169.390928,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7013,'Renta Fija $ Corto Plazo - A',225.818194,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2104,'Renta Fija $ Corto Plazo - A',10.513521,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3922,'Renta Fija $ Corto Plazo - A',157.830394,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5405,'Renta Fija $ Corto Plazo - A',0.782163,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1981,'Renta Fija $ Corto Plazo - A',95.26446,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6269,'Renta Fija $ Corto Plazo - A',206.470049,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5552,'Renta Fija $ Corto Plazo - A',222.298628,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3753,'Renta Fija $ Corto Plazo - A',135.886849,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6983,'Renta Fija $ Corto Plazo - A',189.726987,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4316,'Renta Fija $ Corto Plazo - A',2.528029,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7572,'Renta Fija $ Corto Plazo - A',260.217095,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3565,'Renta Fija $ Corto Plazo - A',450.93976,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1561,'Renta Fija $ Corto Plazo - A',152.564759,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5309,'Renta Fija $ Corto Plazo - A',638.01577,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1780,'Renta Fija $ Corto Plazo - A',10.485785,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4783,'Renta Fija $ Corto Plazo - A',27.244889,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2359,'Renta Fija $ Corto Plazo - A',271.795585,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4628,'Renta Fija $ Corto Plazo - A',6.029946,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4741,'Renta Fija $ Corto Plazo - A',4.238595,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7347,'Renta Fija $ Corto Plazo - A',141.114965,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10634,'Renta Fija $ Corto Plazo - C',122.633905,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6168,'Renta Fija $ Corto Plazo - A',63.480729,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6220,'Renta Fija $ Corto Plazo - A',152.580697,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8649,'Renta Fija $ Corto Plazo - C',334.322087,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8803,'Renta Fija $ Corto Plazo - A',37.762342,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5515,'Renta Fija $ Corto Plazo - A',4.331484,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7807,'Renta Fija $ Corto Plazo - A',2.504327,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6497,'Renta Fija $ Corto Plazo - A',15.788938,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3045,'Renta Fija $ Corto Plazo - A',87.211694,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6266,'Renta Fija $ Corto Plazo - A',17.481758,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2957,'Renta Fija $ Corto Plazo - A',439.373173,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2793,'Renta Fija $ Corto Plazo - A',14.041159,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7002,'Renta Fija $ Corto Plazo - A',305.283831,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10862,'Renta Fija $ Corto Plazo - A',132.234754,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3554,'Renta Fija $ Corto Plazo - A',751.830477,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4276,'Renta Fija $ Corto Plazo - A',6.912866,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6422,'Renta Fija $ Corto Plazo - A',34.301771,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6410,'Renta Fija $ Corto Plazo - A',231.970784,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4835,'Renta Fija $ Corto Plazo - A',206.440295,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5008,'Renta Fija $ Corto Plazo - A',122.645704,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6946,'Renta Fija $ Corto Plazo - A',310.569029,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6476,'Renta Fija $ Corto Plazo - A',20.136361,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1750,'Renta Fija $ Corto Plazo - A',6.950281,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8027,'Renta Fija $ Corto Plazo - A',6.014216,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3059,'Renta Fija $ Corto Plazo - A',423.514944,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5953,'Renta Fija $ Corto Plazo - C',3.361526,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9594,'Renta Fija $ Corto Plazo - C',90.760911,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7678,'Renta Fija $ Corto Plazo - A',19.302863,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7571,'Renta Fija $ Corto Plazo - A',69.542038,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7479,'Renta Fija $ Corto Plazo - A',4.244446,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3250,'Renta Fija $ Corto Plazo - A',295.540366,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10659,'Renta Fija $ Corto Plazo - A',2.549915,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7122,'Renta Fija $ Corto Plazo - A',532.988282,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1833,'Renta Fija $ Corto Plazo - A',164.998328,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2575,'Renta Fija $ Corto Plazo - A',53.808469,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1840,'Renta Fija $ Corto Plazo - A',6.051527,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7814,'Renta Fija $ Corto Plazo - A',28.143642,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10673,'Renta Fija $ Corto Plazo - A',164.052275,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4587,'Renta Fija $ Corto Plazo - A',78.479741,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3238,'Renta Fija $ Corto Plazo - C',1.60547,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2501,'Renta Fija $ Corto Plazo - A',102.212723,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6708,'Renta Fija $ Corto Plazo - A',639.777775,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8494,'Renta Fija $ Corto Plazo - A',124.288693,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5567,'Renta Fija $ Corto Plazo - A',198.427168,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8528,'Renta Fija $ Corto Plazo - A',367.07174,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3917,'Renta Fija $ Corto Plazo - A',46.711844,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10636,'Renta Fija $ Corto Plazo - A',395.28457,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1815,'Renta Fija $ Corto Plazo - A',10.505861,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10773,'Renta Fija $ Corto Plazo - A',22.943055,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5276,'Renta Fija $ Corto Plazo - A',143.747682,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5095,'Renta Fija $ Corto Plazo - A',136.625441,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10394,'Renta Fija $ Corto Plazo - C',56.298875,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3590,'Renta Fija $ Corto Plazo - A',0.815543,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7986,'Renta Fija $ Corto Plazo - A',10.50162,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7297,'Renta Fija $ Corto Plazo - A',21.953533,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6364,'Renta Fija $ Corto Plazo - A',44.991495,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7391,'Renta Fija $ Corto Plazo - A',29.897474,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4490,'Renta Fija $ Corto Plazo - A',253.132269,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10878,'Renta Fija $ Corto Plazo - A',1.656909,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2674,'Renta Fija $ Corto Plazo - A',82.870324,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3505,'Renta Fija $ Corto Plazo - A',344.926377,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8663,'Renta Fija $ Corto Plazo - A',876.257854,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2405,'Renta Fija $ Corto Plazo - A',126.030829,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5984,'Renta Fija $ Corto Plazo - A',2.55768,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9127,'Renta Fija $ Corto Plazo - A',7.878788,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7146,'Renta Fija $ Corto Plazo - A',12.21814,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5297,'Renta Fija $ Corto Plazo - C',95.199308,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5297,'Renta Fija $ Corto Plazo - C',95.199308,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4321,'Renta Fija $ Corto Plazo - A',253.231211,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4037,'Renta Fija $ Corto Plazo - A',4.398861,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4821,'Renta Fija $ Corto Plazo - A',307.005891,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4562,'Renta Fija $ Corto Plazo - C',131.433131,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7651,'Renta Fija $ Corto Plazo - A',9.573215,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1572,'Renta Fija $ Corto Plazo - C',68.670918,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6296,'Renta Fija $ Corto Plazo - A',2.603371,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10885,'Renta Fija $ Corto Plazo - A',29.88164,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5754,'Renta Fija $ Corto Plazo - A',325.516705,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1647,'Renta Fija $ Corto Plazo - A',667.060078,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3049,'Renta Fija $ Corto Plazo - A',82.779453,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8046,'Renta Fija $ Corto Plazo - A',44.094656,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3738,'Renta Fija $ Corto Plazo - A',48.366735,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6504,'Renta Fija $ Corto Plazo - C',82.015142,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4367,'Renta Fija $ Corto Plazo - A',8.789444,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10528,'Renta Fija $ Corto Plazo - A',74.869199,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7833,'Renta Fija $ Corto Plazo - A',186.140147,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2961,'Renta Fija $ Corto Plazo - C',37.015986,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5721,'Renta Fija $ Corto Plazo - A',1235.311668,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3380,'Renta Fija $ Corto Plazo - A',41.295829,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3892,'Renta Fija $ Corto Plazo - A',143.828771,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1597,'Renta Fija $ Corto Plazo - A',228.524236,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9611,'Renta Fija $ Corto Plazo - C',412.021579,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1861,'Renta Fija $ Corto Plazo - A',14.97531,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5406,'Renta Fija $ Corto Plazo - A',735.063816,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1775,'Renta Fija $ Corto Plazo - A',10.476107,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4782,'Renta Fija $ Corto Plazo - A',5.17285,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5722,'Renta Fija $ Corto Plazo - A',5.289441,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6836,'Renta Fija $ Corto Plazo - A',108.404848,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8156,'Renta Fija $ Corto Plazo - A',88.997298,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8149,'Renta Fija $ Corto Plazo - A',658.282537,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2026,'Renta Fija $ Corto Plazo - A',104.906966,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6161,'Renta Fija $ Corto Plazo - A',164.94094,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1702,'Renta Fija $ Corto Plazo - A',32.510524,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3692,'Renta Fija $ Corto Plazo - C',5.105577,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8088,'Renta Fija $ Corto Plazo - A',219.675796,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5436,'Renta Fija $ Corto Plazo - A',93.484805,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7209,'Renta Fija $ Corto Plazo - A',62.621408,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8416,'Renta Fija $ Corto Plazo - A',144.632618,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10060,'Renta Fija $ Corto Plazo - A',154.407751,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2495,'Renta Fija $ Corto Plazo - A',9.607108,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7325,'Renta Fija $ Corto Plazo - A',442.04946,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3909,'Renta Fija $ Corto Plazo - A',0.764311,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8673,'Renta Fija $ Corto Plazo - A',1.603556,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9687,'Renta Fija $ Corto Plazo - A',93.464833,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8179,'Renta Fija $ Corto Plazo - C',35.18469,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4349,'Renta Fija $ Corto Plazo - A',38.726351,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4942,'Renta Fija $ Corto Plazo - A',59.02862,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10180,'Renta Fija $ Corto Plazo - A',320.229593,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3263,'Renta Fija $ Corto Plazo - A',139.315441,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5057,'Renta Fija $ Corto Plazo - C',86.425801,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8631,'Renta Fija $ Corto Plazo - A',323.755109,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10166,'Renta Fija $ Corto Plazo - A',45.801291,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7015,'Renta Fija $ Corto Plazo - A',273.512002,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9626,'Renta Fija $ Corto Plazo - C',48.364615,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3824,'Renta Fija $ Corto Plazo - C',0.077254,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4063,'Renta Fija $ Corto Plazo - A',738.597096,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7510,'Renta Fija $ Corto Plazo - A',199.314122,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4739,'Renta Fija $ Corto Plazo - A',300.817904,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4300,'Renta Fija $ Corto Plazo - C',87.280984,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9769,'Renta Fija $ Corto Plazo - A',126.901743,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3423,'Renta Fija $ Corto Plazo - A',324.624108,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3422,'Renta Fija $ Corto Plazo - A',324.624108,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3016,'Renta Fija $ Corto Plazo - A',463.207114,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8126,'Renta Fija $ Corto Plazo - A',25.479153,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3390,'Renta Fija $ Corto Plazo - C',33.36167,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1687,'Renta Fija $ Corto Plazo - A',22.034624,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9122,'Renta Fija $ Corto Plazo - A',69.567758,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2056,'Renta Fija $ Corto Plazo - A',10.511505,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6565,'Renta Fija $ Corto Plazo - A',2.478607,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10664,'Renta Fija $ Corto Plazo - A',167.549955,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1730,'Renta Fija $ Corto Plazo - A',10.485888,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2215,'Renta Fija $ Corto Plazo - A',0.762293,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9598,'Renta Fija $ Corto Plazo - A',135.867183,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1913,'Renta Fija $ Corto Plazo - A',32.563979,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4524,'Renta Fija $ Corto Plazo - A',576.880769,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5195,'Renta Fija $ Corto Plazo - A',12.245877,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6875,'Renta Fija $ Corto Plazo - A',0.831481,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7359,'Renta Fija $ Corto Plazo - A',279.684051,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3388,'Renta Fija $ Corto Plazo - A',379.443886,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4212,'Renta Fija $ Corto Plazo - C',81.086738,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8298,'Renta Fija $ Corto Plazo - C',148.993857,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1993,'Renta Fija $ Corto Plazo - A',322.088113,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4420,'Renta Fija $ Corto Plazo - A',52.901952,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10490,'Renta Fija $ Corto Plazo - A',238.127205,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2220,'Renta Fija $ Corto Plazo - A',1093.359929,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3214,'Renta Fija $ Corto Plazo - A',6.107001,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10477,'Renta Fija $ Corto Plazo - A',87.304582,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7810,'Renta Fija $ Corto Plazo - A',0.880902,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4192,'Renta Fija $ Corto Plazo - C',0.053398,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4162,'Renta Fija $ Corto Plazo - C',145.49375,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7225,'Renta Fija $ Corto Plazo - A',126.157508,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6992,'Renta Fija $ Corto Plazo - A',6.057786,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5731,'Renta Fija $ Corto Plazo - A',5.2616,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8645,'Renta Fija $ Corto Plazo - C',13.983668,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8645,'Renta Fija $ Corto Plazo - C',13.983668,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7818,'Renta Fija $ Corto Plazo - A',77.537416,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5867,'Renta Fija $ Corto Plazo - A',385.511351,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6196,'Renta Fija $ Corto Plazo - A',68.809602,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7266,'Renta Fija $ Corto Plazo - A',289.433365,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2378,'Renta Fija $ Corto Plazo - A',496.732981,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6001,'Renta Fija $ Corto Plazo - A',75.801333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5958,'Renta Fija $ Corto Plazo - A',129.734463,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7455,'Renta Fija $ Corto Plazo - A',74.989825,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1937,'Renta Fija $ Corto Plazo - C',525.004703,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8374,'Renta Fija $ Corto Plazo - A',209.122842,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4156,'Renta Fija $ Corto Plazo - A',42.346876,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8760,'Renta Fija $ Corto Plazo - A',98.716651,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8583,'Renta Fija $ Corto Plazo - C',78.442222,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10752,'Renta Fija $ Corto Plazo - A',305.198603,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5908,'Renta Fija $ Corto Plazo - A',96.123677,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1722,'Renta Fija $ Corto Plazo - C',57.288501,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8845,'Renta Fija $ Corto Plazo - A',207.327249,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7594,'Renta Fija $ Corto Plazo - A',181.751171,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7853,'Renta Fija $ Corto Plazo - C',20.254969,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8926,'Renta Fija $ Corto Plazo - A',7125.864366,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10863,'Renta Fija $ Corto Plazo - A',560.341996,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10085,'Renta Fija $ Corto Plazo - C',1.753935,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2869,'Renta Fija $ Corto Plazo - A',481.727813,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8782,'Renta Fija $ Corto Plazo - A',87.324452,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2157,'Renta Fija $ Corto Plazo - A',32.482787,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2549,'Renta Fija $ Corto Plazo - C',52.050498,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2170,'Renta Fija $ Corto Plazo - A',88.177616,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5302,'Renta Fija $ Corto Plazo - A',87.334337,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4265,'Renta Fija $ Corto Plazo - A',204.676681,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7809,'Renta Fija $ Corto Plazo - A',59.042333,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8288,'Renta Fija $ Corto Plazo - A',193.258457,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3266,'Renta Fija $ Corto Plazo - A',30.742772,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4882,'Renta Fija $ Corto Plazo - A',7.942026,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4738,'Renta Fija $ Corto Plazo - C',408.486178,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8969,'Renta Fija $ Corto Plazo - A',46.719609,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7768,'Renta Fija $ Corto Plazo - A',37.904652,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4421,'Renta Fija $ Corto Plazo - A',48.366735,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4401,'Renta Fija $ Corto Plazo - A',47.562888,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7583,'Renta Fija $ Corto Plazo - C',6.043763,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7274,'Renta Fija $ Corto Plazo - A',134.012288,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9681,'Renta Fija $ Corto Plazo - A',371.397069,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5638,'Renta Fija $ Corto Plazo - A',89.036834,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7497,'Renta Fija $ Corto Plazo - A',104.950536,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10393,'Renta Fija $ Corto Plazo - C',375.025462,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7213,'Renta Fija $ Corto Plazo - A',349.427804,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4869,'Renta Fija $ Corto Plazo - A',22.935394,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6387,'Renta Fija $ Corto Plazo - A',4779.851872,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6617,'Renta Fija $ Corto Plazo - A',307.855326,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2520,'Renta Fija $ Corto Plazo - A',12.324742,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6090,'Renta Fija $ Corto Plazo - A',48.368856,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6133,'Renta Fija $ Corto Plazo - A',12.315063,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2314,'Renta Fija $ Corto Plazo - A',192.365859,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5871,'Renta Fija $ Corto Plazo - A',212.531564,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9717,'Renta Fija $ Corto Plazo - A',88.242769,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1643,'Renta Fija $ Corto Plazo - C',62.484845,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3269,'Renta Fija $ Corto Plazo - A',13.191827,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4933,'Renta Fija $ Corto Plazo - C',102.254173,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10760,'Renta Fija $ Corto Plazo - A',228.474919,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4187,'Renta Fija $ Corto Plazo - A',721.824383,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8221,'Renta Fija $ Corto Plazo - A',12.342698,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8513,'Renta Fija $ Corto Plazo - A',83.773113,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5926,'Renta Fija $ Corto Plazo - A',45.824993,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5078,'Renta Fija $ Corto Plazo - A',155.28855,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10056,'Renta Fija $ Corto Plazo - A',57.25512,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3279,'Renta Fija $ Corto Plazo - A',74.845191,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7362,'Renta Fija $ Corto Plazo - A',26.375786,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7108,'Renta Fija $ Corto Plazo - A',0.801726,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8778,'Renta Fija $ Corto Plazo - A',134.077543,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8093,'Renta Fija $ Corto Plazo - A',101.468488,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7559,'Renta Fija $ Corto Plazo - A',22.798728,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2695,'Renta Fija $ Corto Plazo - A',22.773215,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5985,'Renta Fija $ Corto Plazo - A',63.482747,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4851,'Renta Fija $ Corto Plazo - A',312.350702,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6808,'Renta Fija $ Corto Plazo - A',442.882958,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7432,'Renta Fija $ Corto Plazo - C',78.493454,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2640,'Renta Fija $ Corto Plazo - A',412.037517,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1942,'Renta Fija $ Corto Plazo - A',6.930717,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8163,'Renta Fija $ Corto Plazo - A',100.535842,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5797,'Renta Fija $ Corto Plazo - A',22.010922,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10857,'Renta Fija $ Corto Plazo - C',224.976932,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6820,'Renta Fija $ Corto Plazo - A',500.268486,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2331,'Renta Fija $ Corto Plazo - A',162.227134,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7251,'Renta Fija $ Corto Plazo - A',0.718723,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8931,'Renta Fija $ Corto Plazo - A',226.683465,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7007,'Renta Fija $ Corto Plazo - C',938.031844,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8853,'Renta Fija $ Corto Plazo - A',25.546426,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9908,'Renta Fija $ Corto Plazo - C',47.578723,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7926,'Renta Fija $ Corto Plazo - A',115.459816,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5896,'Renta Fija $ Corto Plazo - A',132.353259,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7017,'Renta Fija $ Corto Plazo - A',25.546323,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9694,'Renta Fija $ Corto Plazo - A',246.126516,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6101,'Renta Fija $ Corto Plazo - A',20.134343,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3454,'Renta Fija $ Corto Plazo - A',41.432392,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10446,'Renta Fija $ Corto Plazo - A',281.503242,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6097,'Renta Fija $ Corto Plazo - A',22.893634,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5365,'Renta Fija $ Corto Plazo - A',1.690802,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1632,'Renta Fija $ Corto Plazo - C',256.673827,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7787,'Renta Fija $ Corto Plazo - A',10.456134,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4230,'Renta Fija $ Corto Plazo - C',3354.127151,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6284,'Renta Fija $ Corto Plazo - A',824.165802,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6536,'Renta Fija $ Corto Plazo - A',332.566031,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2560,'Renta Fija $ Corto Plazo - C',73.069778,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6399,'Renta Fija $ Corto Plazo - A',554.126169,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3428,'Renta Fija $ Corto Plazo - A',29.82042,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7931,'Renta Fija $ Corto Plazo - A',12.315063,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2756,'Renta Fija $ Corto Plazo - A',604.48012,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8868,'Renta Fija $ Corto Plazo - A',14.924078,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6173,'Renta Fija $ Corto Plazo - A',163.200924,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7098,'Renta Fija $ Corto Plazo - A',4.276114,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7363,'Renta Fija $ Corto Plazo - A',6.174273,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4523,'Renta Fija $ Corto Plazo - A',151.656121,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7087,'Renta Fija $ Corto Plazo - A',0.712976,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1959,'Renta Fija $ Corto Plazo - A',360.04037,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8095,'Renta Fija $ Corto Plazo - A',92.518882,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8244,'Renta Fija $ Corto Plazo - A',230.242568,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7632,'Renta Fija $ Corto Plazo - A',18.497102,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6760,'Renta Fija $ Corto Plazo - A',4.396636,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5530,'Renta Fija $ Corto Plazo - A',6.934447,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7658,'Renta Fija $ Corto Plazo - A',26.350067,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4289,'Renta Fija $ Corto Plazo - A',3.456536,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7452,'Renta Fija $ Corto Plazo - A',159.623763,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5889,'Renta Fija $ Corto Plazo - A',197.625338,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10602,'Renta Fija $ Corto Plazo - A',191.494842,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4114,'Renta Fija $ Corto Plazo - A',163.108036,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8245,'Renta Fija $ Corto Plazo - A',4.369003,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1720,'Renta Fija $ Corto Plazo - A',269.077641,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2724,'Renta Fija $ Corto Plazo - C',74.057282,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5560,'Renta Fija $ Corto Plazo - A',275.261696,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9714,'Renta Fija $ Corto Plazo - A',129.686753,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6907,'Renta Fija $ Corto Plazo - A',214.425892,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4984,'Renta Fija $ Corto Plazo - C',45.809159,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5899,'Renta Fija $ Corto Plazo - A',83.699684,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8876,'Renta Fija $ Corto Plazo - A',269.101445,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5335,'Renta Fija $ Corto Plazo - C',16.745183,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5335,'Renta Fija $ Corto Plazo - C',16.745183,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6289,'Renta Fija $ Corto Plazo - A',1.593877,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4949,'Renta Fija $ Corto Plazo - C',78.41045,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4758,'Renta Fija $ Corto Plazo - A',7.934159,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10318,'Renta Fija $ Corto Plazo - A',209.095001,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7952,'Renta Fija $ Corto Plazo - A',180.8149,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6389,'Renta Fija $ Corto Plazo - A',577.944379,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3807,'Renta Fija $ Corto Plazo - C',6.989816,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7055,'Renta Fija $ Corto Plazo - A',94.411295,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9947,'Renta Fija $ Corto Plazo - A',126.927462,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4331,'Renta Fija $ Corto Plazo - A',250.479581,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2090,'Renta Fija $ Corto Plazo - A',106.739766,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10097,'Renta Fija $ Corto Plazo - A',14.866587,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6240,'Renta Fija $ Corto Plazo - A',6.924768,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2764,'Renta Fija $ Corto Plazo - A',194.978805,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5709,'Renta Fija $ Corto Plazo - A',7.03137,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7463,'Renta Fija $ Corto Plazo - A',80.261309,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6215,'Renta Fija $ Corto Plazo - A',1.753832,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8353,'Renta Fija $ Corto Plazo - A',74.914481,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7399,'Renta Fija $ Corto Plazo - A',38.69851,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5768,'Renta Fija $ Corto Plazo - A',73.083596,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6217,'Renta Fija $ Corto Plazo - C',34.31983,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5383,'Renta Fija $ Corto Plazo - A',10.584727,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6691,'Renta Fija $ Corto Plazo - A',165.78634,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7355,'Renta Fija $ Corto Plazo - A',36.036247,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5732,'Renta Fija $ Corto Plazo - A',2.642804,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3628,'Renta Fija $ Corto Plazo - A',50.120671,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8547,'Renta Fija $ Corto Plazo - A',159.671472,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8151,'Renta Fija $ Corto Plazo - A',59.959145,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3139,'Renta Fija $ Corto Plazo - A',2.452888,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3544,'Renta Fija $ Corto Plazo - A',314.037364,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6132,'Renta Fija $ Corto Plazo - A',509.077287,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8997,'Renta Fija $ Corto Plazo - A',27.230865,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6739,'Renta Fija $ Corto Plazo - A',326.49867,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6200,'Renta Fija $ Corto Plazo - A',104.081537,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8297,'Renta Fija $ Corto Plazo - A',111.098988,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4096,'Renta Fija $ Corto Plazo - A',859.488969,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4039,'Renta Fija $ Corto Plazo - A',215.322731,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3763,'Renta Fija $ Corto Plazo - A',266.434837,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4097,'Renta Fija $ Corto Plazo - A',34.398798,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4641,'Renta Fija $ Corto Plazo - A',330.008351,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7453,'Renta Fija $ Corto Plazo - A',64.418915,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5519,'Renta Fija $ Corto Plazo - A',7.880806,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1886,'Renta Fija $ Corto Plazo - A',201.111525,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5130,'Renta Fija $ Corto Plazo - A',310.51578,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2635,'Renta Fija $ Corto Plazo - A',276.970043,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10440,'Renta Fija $ Corto Plazo - A',10.436468,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6299,'Renta Fija $ Corto Plazo - A',16.743166,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4226,'Renta Fija $ Corto Plazo - A',56.334274,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5922,'Renta Fija $ Corto Plazo - A',64.252597,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10753,'Renta Fija $ Corto Plazo - A',0.782266,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8243,'Renta Fija $ Corto Plazo - C',446.420377,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3013,'Renta Fija $ Corto Plazo - A',34.25266,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8474,'Renta Fija $ Corto Plazo - A',1.718435,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2425,'Renta Fija $ Corto Plazo - A',81.936174,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8404,'Renta Fija $ Corto Plazo - A',3.48629,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5067,'Renta Fija $ Corto Plazo - A',225.000634,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6994,'Renta Fija $ Corto Plazo - A',0.764414,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5165,'Renta Fija $ Corto Plazo - A',437.595535,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2171,'Renta Fija $ Corto Plazo - A',217.854587,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6120,'Renta Fija $ Corto Plazo - A',326.385807,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5644,'Renta Fija $ Corto Plazo - A',121.70338,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2105,'Renta Fija $ Corto Plazo - A',223.225117,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8208,'Renta Fija $ Corto Plazo - A',3.47237,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5860,'Renta Fija $ Corto Plazo - A',115.45992,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7493,'Renta Fija $ Corto Plazo - A',177.281516,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5140,'Renta Fija $ Corto Plazo - A',5.240122,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2142,'Renta Fija $ Corto Plazo - A',170.232294,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1934,'Renta Fija $ Corto Plazo - A',51.029102,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2282,'Renta Fija $ Corto Plazo - A',108.487955,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5546,'Renta Fija $ Corto Plazo - A',2.561714,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8139,'Renta Fija $ Corto Plazo - A',69.666802,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4171,'Renta Fija $ Corto Plazo - A',4.222762,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10140,'Renta Fija $ Corto Plazo - A',32.46897,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9997,'Renta Fija $ Corto Plazo - A',336.101535,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5527,'Renta Fija $ Corto Plazo - A',30.715138,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7394,'Renta Fija $ Corto Plazo - A',111.027783,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9390,'Renta Fija $ Corto Plazo - A',316.782942,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9751,'Renta Fija $ Corto Plazo - A',6.89491,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10623,'Renta Fija $ Corto Plazo - A',48.354833,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5032,'Renta Fija $ Corto Plazo - A',289.413699,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5144,'Renta Fija $ Corto Plazo - A',441.138701,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6326,'Renta Fija $ Corto Plazo - A',2.644924,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8799,'Renta Fija $ Corto Plazo - A',404.948552,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4098,'Renta Fija $ Corto Plazo - A',15.818693,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4307,'Renta Fija $ Corto Plazo - A',276.158432,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6392,'Renta Fija $ Corto Plazo - A',89.931552,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6874,'Renta Fija $ Corto Plazo - A',175.606755,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3529,'Renta Fija $ Corto Plazo - A',79.368609,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5996,'Renta Fija $ Corto Plazo - A',46.733425,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7698,'Renta Fija $ Corto Plazo - A',13.154308,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3284,'Renta Fija $ Corto Plazo - A',9.607108,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2878,'Renta Fija $ Corto Plazo - A',391.691677,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10397,'Renta Fija $ Corto Plazo - A',37.9224,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1752,'Renta Fija $ Corto Plazo - A',306.081522,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2949,'Renta Fija $ Corto Plazo - A',12.18435,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6952,'Renta Fija $ Corto Plazo - A',90.763032,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6607,'Renta Fija $ Corto Plazo - A',126.985057,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6661,'Renta Fija $ Corto Plazo - A',91.752656,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3054,'Renta Fija $ Corto Plazo - A',131.472461,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2070,'Renta Fija $ Corto Plazo - C',34.382963,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7585,'Renta Fija $ Corto Plazo - A',80.221877,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5045,'Renta Fija $ Corto Plazo - A',137.56373,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10280,'Renta Fija $ Corto Plazo - A',38.655043,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10806,'Renta Fija $ Corto Plazo - A',18.485302,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4360,'Renta Fija $ Corto Plazo - A',97.055811,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10391,'Renta Fija $ Corto Plazo - A',6.154607,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4175,'Renta Fija $ Corto Plazo - A',689.183349,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8773,'Renta Fija $ Corto Plazo - A',106.698212,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3163,'Renta Fija $ Corto Plazo - A',337.918605,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6841,'Renta Fija $ Corto Plazo - A',6.130702,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9369,'Renta Fija $ Corto Plazo - A',433.25427,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4621,'Renta Fija $ Corto Plazo - A',388.235141,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4645,'Renta Fija $ Corto Plazo - A',43.231813,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7712,'Renta Fija $ Corto Plazo - A',230.256487,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5555,'Renta Fija $ Corto Plazo - A',3.391177,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2667,'Renta Fija $ Corto Plazo - A',91.661786,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7820,'Renta Fija $ Corto Plazo - A',3.397028,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4412,'Renta Fija $ Corto Plazo - A',178.14648,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7442,'Renta Fija $ Corto Plazo - A',183.424018,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7474,'Renta Fija $ Corto Plazo - C',716.523247,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9870,'Renta Fija $ Corto Plazo - A',45.815108,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4021,'Renta Fija $ Corto Plazo - C',695.361761,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8721,'Renta Fija $ Corto Plazo - A',93.510421,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3371,'Renta Fija $ Corto Plazo - A',17.639901,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2490,'Renta Fija $ Corto Plazo - A',79.245966,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6174,'Renta Fija $ Corto Plazo - A',192.373416,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6539,'Renta Fija $ Corto Plazo - A',380.303,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8646,'Renta Fija $ Corto Plazo - C',253.243217,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2542,'Renta Fija $ Corto Plazo - A',35.172994,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8313,'Renta Fija $ Corto Plazo - A',13.09107,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3330,'Renta Fija $ Corto Plazo - C',4.378888,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6635,'Renta Fija $ Corto Plazo - A',280.485778,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6553,'Renta Fija $ Corto Plazo - A',11.384435,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1982,'Renta Fija $ Corto Plazo - A',235.524243,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5432,'Renta Fija $ Corto Plazo - A',27.302276,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9637,'Renta Fija $ Corto Plazo - C',8.773403,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4365,'Renta Fija $ Corto Plazo - A',388.207404,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9993,'Renta Fija $ Corto Plazo - A',5.244054,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10021,'Renta Fija $ Corto Plazo - A',137.524091,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9762,'Renta Fija $ Corto Plazo - A',70.553652,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2973,'Renta Fija $ Corto Plazo - A',24.615798,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4768,'Renta Fija $ Corto Plazo - A',143.730137,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8065,'Renta Fija $ Corto Plazo - A',228.421566,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4756,'Renta Fija $ Corto Plazo - A',13.17801,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4948,'Renta Fija $ Corto Plazo - C',29.859956,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6450,'Renta Fija $ Corto Plazo - A',8.734074,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5859,'Renta Fija $ Corto Plazo - A',16.620523,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4809,'Renta Fija $ Corto Plazo - A',24.596235,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5845,'Renta Fija $ Corto Plazo - A',668.883201,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3817,'Renta Fija $ Corto Plazo - C',185.276894,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6664,'Renta Fija $ Corto Plazo - A',827.710985,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8363,'Renta Fija $ Corto Plazo - A',28.189127,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8714,'Renta Fija $ Corto Plazo - A',11.463611,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2216,'Renta Fija $ Corto Plazo - A',332.59175,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7528,'Renta Fija $ Corto Plazo - A',86.356408,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4209,'Renta Fija $ Corto Plazo - A',225.877807,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1949,'Renta Fija $ Corto Plazo - A',12.229939,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3435,'Renta Fija $ Corto Plazo - A',214.340767,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7664,'Renta Fija $ Corto Plazo - A',266.432922,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3754,'Renta Fija $ Corto Plazo - C',48.489482,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3754,'Renta Fija $ Corto Plazo - C',48.489482,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7888,'Renta Fija $ Corto Plazo - C',5247.586029,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6467,'Renta Fija $ Corto Plazo - A',51.155781,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,1915,'Renta Fija $ Corto Plazo - A',10.491838,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3331,'Renta Fija $ Corto Plazo - A',28.949403,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3329,'Renta Fija $ Corto Plazo - A',128.699249,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4898,'Renta Fija $ Corto Plazo - A',18.364676,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5113,'Renta Fija $ Corto Plazo - A',66.944822,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3092,'Renta Fija $ Corto Plazo - C',344.112748,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2494,'Renta Fija $ Corto Plazo - A',4.378888,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8346,'Renta Fija $ Corto Plazo - A',243.517501,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7079,'Renta Fija $ Corto Plazo - A',5.103457,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8407,'Renta Fija $ Corto Plazo - A',90.766965,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2928,'Renta Fija $ Corto Plazo - A',286.687891,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4424,'Renta Fija $ Corto Plazo - A',660.955096,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8998,'Renta Fija $ Corto Plazo - A',266.397422,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5086,'Renta Fija $ Corto Plazo - A',386.481309,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8426,'Renta Fija $ Corto Plazo - A',59.941086,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5493,'Renta Fija $ Corto Plazo - A',0.847315,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4241,'Renta Fija $ Corto Plazo - A',99.708396,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7446,'Renta Fija $ Corto Plazo - A',5.103457,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8419,'Renta Fija $ Corto Plazo - A',169.311857,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,6965,'Renta Fija $ Corto Plazo - A',298.192848,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8615,'Renta Fija $ Corto Plazo - C',96.070221,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7491,'Renta Fija $ Corto Plazo - A',3.371205,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2197,'Renta Fija $ Corto Plazo - A',34.292092,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4040,'Renta Fija $ Corto Plazo - A',84.616495,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2734,'Renta Fija $ Corto Plazo - A',11.467542,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8319,'Renta Fija $ Corto Plazo - A',80.176185,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2305,'Renta Fija $ Corto Plazo - A',35.99459,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5483,'Renta Fija $ Corto Plazo - A',361.709078,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,7922,'Renta Fija $ Corto Plazo - A',7.835217,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5735,'Renta Fija $ Corto Plazo - A',176.359268,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5127,'Renta Fija $ Corto Plazo - A',234.667044,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4251,'Renta Fija $ Corto Plazo - A',131.468528,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9395,'Renta Fija $ Corto Plazo - A',155.290671,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2348,'Renta Fija $ Corto Plazo - C',208.126958,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2029,'Renta Fija $ Corto Plazo - A',71.420634,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,4987,'Renta Fija $ Corto Plazo - A',1.577837,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9897,'Renta Fija $ Corto Plazo - C',27.276557,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,3203,'Renta Fija $ Corto Plazo - A',66.143097,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,2404,'Renta Fija $ Corto Plazo - A',426.220882,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9969,'Renta Fija $ Corto Plazo - A',22.935291,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10436,'Renta Fija $ Corto Plazo - C',229.304484,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9044,'Renta Fija $ Corto Plazo - A',7.021588,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,8542,'Renta Fija $ Corto Plazo - C',225.754957,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10317,'Renta Fija $ Corto Plazo - A',601.8235,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5513,'Renta Fija $ Corto Plazo - A',0.790031,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,10033,'Renta Fija $ Corto Plazo - A',112.007626,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,9514,'Renta Fija $ Corto Plazo - C',123.50694,'UNICO'
INSERT INTO #TEMPEXCEL(NumFondo, NroCuotapastista, TpValorCp,Importe,CondicionIngEgr) select 501,5407,'Renta Fija $ Corto Plazo - A',21.888382,'UNICO'

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

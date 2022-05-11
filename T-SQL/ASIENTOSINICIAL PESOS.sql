
if exists(select * from tempdb..sysobjects where id = object_id('tempdb..#TEMP_ASIENTOS'))
	drop table #TEMP_ASIENTOS
go

create table #TEMP_ASIENTOS
(
	IdTabla numeric(5) not null identity(1,1),
	NumFondo numeric(5) not null,
	CodCtaContable char(19) not null,
	FechaString varchar(10) Collate database_default not null,
	ImporteDebe  numeric(19,2) null,
	ImporteHaber numeric(19,2) null,
	Coeficiente numeric(16,10),
	

	CodFondo numeric(5),
	FechaConcertacion smalldatetime
)

go
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000001'  	 , 	16740228626.84	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000003'  	 , 	1500000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000006'  	 , 	50000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000008'  	 , 	2150000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000009'  	 , 	400000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000010'  	 , 	2150000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000011'  	 , 	500000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000013'  	 , 	1000000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000017'  	 , 	500000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000018'  	 , 	500000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000019'  	 , 	1300000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000020'  	 , 	450000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000021'  	 , 	50000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000022'  	 , 	300000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10101010100000024'  	 , 	240000000.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000001'  	 , 	7885630.67	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000002'  	 , 	3795313.00	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000003'  	 , 	7309.65	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000004'  	 , 	14949175.61	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000005'  	 , 	12396.62	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000006'  	 , 	21465077.38	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000007'  	 , 	3039274.96	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000008'  	 , 	527220.81	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000009'  	 , 	6.78	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000010'  	 , 	5228531.11	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000012'  	 , 	6642874.55	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000015'  	 , 	10147403.85	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000016'  	 , 	21648057.09	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000019'  	 , 	11783.36	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000020'  	 , 	5075980.62	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000022'  	 , NULL	 , 	0.23	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000024'  	 , 	2038805.47	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000026'  	 , 	536706.48	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000027'  	 , 	4591518.92	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000028'  	 , 	1745.33	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301010500000030'  	 , 	18983774.99	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'10301020300000001'  	 , 	4161365.97	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'20201010100000001'  	 , NULL	 , 	187658.37	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'20201010100000002'  	 , NULL	 , 	9383238.51	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'20201010200000001'  	 , NULL	 , 	11302.48	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'20201010200000002'  	 , NULL	 , 	1291663.10	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'20201010300000001'  	 , NULL	 , 	475386.00	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'30101010200000001'  	 , NULL	 , 	1785071265787.46	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'30101010200000002'  	 , NULL	 , 	594802905781.33	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'30101010300000001'  	 , 	1768595696389.40	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'30101010300000002'  	 , 	588091777694.26	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'30201010100000002'  	 , 	697366633.99	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'30201010100000003'  	 , 	444346720.72	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000001'  	 , NULL	 , 	147359808.22	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000003'  	 , NULL	 , 	5038003.32	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000004'  	 , NULL	 , 	28108295.60	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000005'  	 , NULL	 , 	115083166.01	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000006'  	 , NULL	 , 	147887597.21	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000007'  	 , NULL	 , 	69070674.65	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000008'  	 , NULL	 , 	34381742.38	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000009'  	 , NULL	 , 	85376559.35	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000010'  	 , NULL	 , 	230972367.44	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000011'  	 , NULL	 , 	64699212.57	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000012'  	 , NULL	 , 	20241648.17	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000013'  	 , NULL	 , 	9874667.45	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000014'  	 , NULL	 , 	148222469.56	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000015'  	 , NULL	 , 	5677512.83	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000016'  	 , NULL	 , 	266720906.75	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000017'  	 , NULL	 , 	2898032.74	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000018'  	 , NULL	 , 	2453790.47	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000019'  	 , NULL	 , 	263312167.00	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000020'  	 , NULL	 , 	113513324.34	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000021'  	 , NULL	 , 	3745539.45	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000022'  	 , NULL	 , 	579249458.92	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000023'  	 , NULL	 , 	30142688.18	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000024'  	 , NULL	 , 	24072616.58	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010000000026'  	 , NULL	 , 	91257674.09	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010101000001'  	 , NULL	 , 	2712186775.07	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'40201010103000001'  	 , NULL	 , 	950794817.00	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'50201010100000001'  	 , 	7819326.04	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'50201010100000002'  	 , 	191589567.49	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'50201010200000001'  	 , 	1410441.55	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'50201010200000002'  	 , 	34471957.95	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'50201020100000005'  	 , 	720.96	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'50201020100000011'  	 , 	12404314.93	 , NULL	 , 	 1.00000000 
	insert into #TEMP_ASIENTOS (NumFondo,FechaString,CodCtaContable,ImporteDebe,ImporteHaber, Coeficiente) 	SELECT 	'2203'	 , 	 '20220113', 	'50201020100000013'  	 , NULL	 , 	14.52	 , 	 1.00000000 




update #TEMP_ASIENTOS
SET #TEMP_ASIENTOS.FechaConcertacion = FechaString

update #TEMP_ASIENTOS
set #TEMP_ASIENTOS.CodFondo = FONDOSREAL.CodFondo
from #TEMP_ASIENTOS
	inner join FONDOSREAL
		on FONDOSREAL.NumFondo = #TEMP_ASIENTOS.NumFondo

declare @CodFondo CodigoMedio
declare @NumAsiento NumeroMedio

select top 1 @CodFondo =  CodFondo from #TEMP_ASIENTOS
select @NumAsiento = max(NumAsiento) + 1 from ASIENTOSCAB where CodFondo = @CodFondo

--ASIENTOSCAB
INSERT INTO ASIENTOSCAB (CodFondo, NumAsiento, FechaConcertacion, Leyenda, CodUsuarioI, FechaI, TermI, EstaRegMonCursoLgl, EsAjustePorInflacion)
select @CodFondo CodFondo,
	@NumAsiento NumAsiento,
	'20220113' FechaConcertacion,
	'ASIENTO INICIAL - PS' Leyenda,
	1 CodUsuarioI,
	getdate() FechaI,
	HOST_NAME() TermI,
	0 EstaRegMonCursoLgl,
	0 EsAjustePorInflacion

INSERT INTO ASIENTOSIT(CodFondo, NumAsiento, CodAsientoIt,CodCtaContable,ImporteDebe,ImporteHaber,Coeficiente,CodTpPlanCtaContable)	
select CodFondo,
@NumAsiento NumAsiento,
IdTabla CodAsientoIt,
CodCtaContable,
ImporteDebe,
ImporteHaber,
Coeficiente Coeficiente,
'ES750' CodTpPlanCtaContable
from #TEMP_ASIENTOS


--select max(NumAsiento) from ASIENTOSCAB where CodFondo=38





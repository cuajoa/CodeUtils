SELECT CUOTAPARTISTAS.Nombre, CUOTAPARTISTAS.NumCuotapartista, PERSONAS.CodInterfazBanco as PersonaBanco, 
FONDOS.NumFondo, FONDOS.Nombre, TPVALORESCP.Abreviatura, SUM(LIQUIDACIONES.CantCuotapartes) AS Posicion
FROM LIQUIDACIONES     
INNER JOIN FONDOS ON FONDOS.CodFondo = LIQUIDACIONES.CodFondo
INNER JOIN TPVALORESCP ON TPVALORESCP.CodFondo = LIQUIDACIONES.CodFondo AND TPVALORESCP.CodTpValorCp=LIQUIDACIONES.CodTpValorCp 
INNER JOIN CUOTAPARTISTAS ON CUOTAPARTISTAS.CodCuotapartista=LIQUIDACIONES.CodCuotapartista
INNER JOIN CONDOMINIOS ON CUOTAPARTISTAS.CodCuotapartista=CONDOMINIOS.CodCuotapartista 
INNER JOIN PERSONAS ON PERSONAS.CodPersona=CONDOMINIOS.CodPersona 
INNER JOIN TPDOCIDENTIDAD ON PERSONAS.CodTpDocIdentidad =TPDOCIDENTIDAD.CodTpDocIdentidad 
WHERE	LIQUIDACIONES.EstaAnulado = 0 AND LIQUIDACIONES.FechaConcertacion <= GETDATE() 

AND PERSONAS.CodInterfazBanco IN (
'0800130502404853','0800426887422','0800414809407','0800421093729','0800423248885','080065726987','0800418269190','0800416982053'
,'0800130689032245','0800130655116202','080058626023','0800411217254','0800422211337','080055247184','0800418591086','0800418146525'
,'0800421925056','0800425100409','0800411154013','080058309065','08006212902','0800133500038069','0800423091959','080054641882','0800130500017011'
,'0800130539222259','0800130500065776','0800130685849751','080054165615','0800417634158','0800420024337','080063924578','0800130500036911','0800130707350195'
,'0800130525424355','0800130500680438','0800422600604','0800130569719344','0800130568531392','0800421989773','0800130678814357','0800423326613','0800130707634401'
,'0800130504077078','0800422767911','0800420729222','0800422364906','0800130708412089','0800130708412100','0800130552821838','0800412551854','0800422103581'
,'0800418282303','0800130654438680','0800130708948167','0800420413534','0800420987323','0800130605979048','0800130707292187','0800130656742190','0800130709184810','0800130708544066'
,'0800130707793240','0800130999070880','0800416966515','0800130707974342','0800130708341645','0800130597279309','080066699490','0800428695376','0800130500786937','0800417082292'
,'0800130618951061','0800130526121569','080054147608','0800130644285584','0800130545795368','0800130507950848','0800130500658912','080054416825','080066187822','0800425431497'
,'08055536','08055584','080066267748','0800130678217294','0800133693998919','0800424633493','0800130545840754','08055524','0800130710509529','080058113896','0800412601346'
,'0800493612160','080064849300','08055550','08055542','08055540','0800130698482253','0800130999146917','0800426339813','0800130527335236','0800425608575','0800130525318377'
,'0800424016066','0800430980630','0800424496498','080064786013','0800427218117','08055603','0800411683868','0800493442142','0800422990056','0800427417061','0800431996017'
,'0800417949957','0800420718743','0800130617025767','0800130708696532','0800130566293761','0800130599821577','0800427729499','080057616244','0800494160689','0800130708849649'
,'0800130671949559','0800130707520600','0800130690250442','0800130502281662','0800418417899','0800133503850929','0800130711854440','0800130511813472','0800130709367044'
,'0800417515092','0800412162576','0800130707362819','0800416146470','0800130676357978','0800414524797','0800133604298909','0800432085421','0800432353569','0800130690275070'
,'0800130711899967','0800425520248','0800425686399','0800130678774495','0800422931511','0800130711430837','0800130687310434','0800428426610','0800130500987185','0800412427204'
,'0800425343912','0800130712062327','0800130712084088','0800130712124403','0800130712142290','0800130592838091','0800133709739889','0800435943916','0800130712162372','0800130694701589'
,'080065644318','080056906998','0800410891724','0800410142992','0800417084006','0800427681899','0800130708218681','08055669','0800133712270239','0800416303213','0805230709','0800417513719'
,'080056859018','0800429151462','0800423411786','0800425285195','0800414877188','0800416145543','0800414931863','0800130712305602','0800428383565','0800428003734','0800410890610'
,'0800430392069','0800133611979989','0800412356206','0800130708953721','0800425028412','0800426416408','0800427350020','080055088378','0800412864492','0800429654601','0800422230317'
,'0800427291423','080064457715','0800422500584','0800412090450','080056923740','0800130707442065','0800130634595623','0800424117394','0800130709993220','0800414072455','0800413570124'
,'0800424960240','0800428184756','0800429076595','0800429654894','0800130526386686','0800130673380162','0800420148956','0800417546463','0800418044127','0800421706197','0800422536237'
,'0800130676337152','0800429910821','0800130688730887','0800428693158','0800423882142','0800423531997','0800425572728','0800494227011','0800427381307','0800410921927','080058565871'
,'0800429115087','0800425795880','0800421980412','0800410038129','0800425782445','0800422536333','0800430603747','0800425229843','080064787920','0800414002397','0800414157924','0800414565238'
,'0800417665728','0800421774011','0800424492581','0800426956099','0800424493280','0800422717263','080066062719','0800130628555695','0800420668933','080069969364','0800422189207','0800424946097'
,'0800417652216','0800416982106','0800421942459','0800421982311','0800423364363','0800423734745','0800416943272','080058024290','0800425994437','0800130712105743','080058347557','0800422407153'
,'0800130661175997','0800130710172958','0800130707876758','0800130695601855','0800494078611','0800428539779','0800130708814993','0800422494837','0800418222680','080056827112','0800416829488'
,'0800417980194','0800420251565','0800130693199235','0800493332697','080058108509','0800412982590','0800130687587568','080069988029','0800414757266','0800429462704','08055676','0800422059947'
,'0800424779843','0800130705465106','0800130710416016','080056879288','0800130710444451','080058325276','0800424625452','0800425544858','0800425018058','0800429648862','080056753085','080061722002'
,'0800427119284','0800421694962','080056652410','0800130701959104','0800413088091','080056899474','0800130697322295','0800130654193203','0800428821496','0800418567510','0800429247049','0800432194295'
,'0800493710175','0800493710201','0800130707610596','0800424040312','08055221','08055649','0800424176830','0800426723745','0800130712613900','0800130688254090','0800434146472','0800420310826','0800427238632'
,'0800418073245','0800428233373','0800438199440','0800421730566','0800422819720','080057662981','080066157224','0800428514286','0800429588501','0800432851888','0800430745391','0800413103457','0800432272963'
,'080062155007','0800416763889','0800130639145448','0800427545123','080066044186','0800422054247','0800424017892','0800424628130','0800428418394','0800435357797','0800429326870','0800437754923','0800435097483'
,'0800423516890','0800430278346','0800432318289','0800417124945','0800423899529','0800426999995','0800420460222','0800417867044','0800423173980','0800423946802','0800435159457','0800418004767','0800130612929455'
,'0800423974240','0800428280609','0800427932530','0800424116331','0800423342909','0800410207449','0800431407652','0800410087007','0800430693966','0800414252007','0800429910329','080054379315','0800428620198'
,'0800425989602','0800492098875','080057611163','0800428445148','0800410548716','0800414010379','0800433672712','0800436896230','0800421455721','080065748337','0800429964656','0800422410111','0800429753784'
,'0800411563384','0800432143591','0800426281386','0800428463253','0800493247400','0800493567294','0800432627508','0800418150819','0800492544631','0800423537171','0800426986953','0800416534909','080054441559'
,'080066377981','080066232323','080061362582','0800417515166','0800420509240','0800430506225','0800420485230','0800420691022','0800413914166','0800413807909','080054211145','0800423390510','080054382411','080064145606'
,'0800432443522','0800414027992','0800424992826','0800425755609','0800430440209','0800431306440','0800417364716','0800432090760','0800130538601345','0800424030129','0800427635694','0800422054497','0800420383262'
,'0800130708813121','0800429232436','0800433461707','0800442723773','0800418821382','0800426123431','0800413685209','0800130682500855','0800421820405','080057727231','080054420185','080056625117','0800421763884'
,'0800422784303'
,'0800425983148'
,'0800426383030'
,'0800410627084'
,'0800436400122'
,'080058140969'
,'080064606871'
,'0800414267120'
,'0800418269005'
,'080063193836'
,'0800428885267'
,'0800427411722'
,'080063302393'
,'080056067432'
,'0800417918476'
,'0800435996574'
,'0800414978355'
,'0800410504299'
,'080057604856'
,'0800427767528'
,'0800418753434'
,'0800422944029'
,'0800130685376349'
,'0800422693466'
,'0800424367613'
,'0800426721295'
,'0800427355914'
,'0800426431005'
,'0800436148955'
,'0800413277024'
,'080054388497'
,'080064651901'
,'0800433040554'
,'0800421480838'
,'0800422780323'
,'0800413645902'
,'0800418028525'
,'0800417192715'
,'0800427089672'
,'0800420703096'
,'0800423672537'
,'080054346430'
,'0800417333301'
,'0800436687668'
,'0800425394362'
,'0800428106813'
,'080062895101'
,'0800422297871'
,'0800130712199969'
,'0800430984879'
,'0800492480394'
,'0800418472899'
,'0800130593093251'
,'0800423314699'
,'0800429076397'
,'0800427383988'
,'0800493314682'
,'0800432627060'
,'0800431160980'
,'0800425044553'
,'0800130712539107'
,'0800130709320676'
,'0800430444294'
,'0800428587949'
,'0800425416838'
,'0800493312615'
,'0800426553282'
,'080054538073'
,'0800430666439'
,'0800426076029'
,'080062437502'
,'0800130709512834'
,'0800436616572'
,'0800427182310'
,'0800130500315683'
,'0800422425916'
,'080062662428'
,'0800130613755124'
,'0800425938005'
,'0800427131905'
,'0800431781395'
,'080057606070'
,'0800130708615060'
,'0800414664956'
,'0800436828929'
,'0800428228390'
,'0800424966179'
,'0800423968311'
,'0800426803412'
,'0800425099776'
,'0800425855791'
,'0800422217043'
,'0800410421969'
,'080058115778'
,'0800130711346801'
,'0800418284734'
,'0800416767746'
,'0800421369490'
,'080061686566'
,'080056515640'
,'0800433551335'
,'0800423547065'
,'080066556409'
,'0800411574892'
,'080062616056'
,'0800425171293'
,'0800130708755253'
,'0800422237800'
,'0800434217159'
,'0800432219705'
,'0800417400623'
,'0800133713873409'
,'0800412792478'
,'0800414542321'
,'080062999901'
,'0800425647643'
,'0800423809543'
,'0800423549398'
,'0800434611852'
,'0800418414635'
,'0800418545110'
,'080056050208'
,'0800421704142'
,'0800427941150'
,'0800428999709'
,'080064871710'
,'0800411802308'
,'0800416225523'
,'0800418519252'
,'0800431160667'
,'0800431468655'
,'0800417744840'
,'080057851868'
,'080066389324'
,'0800423196755'
,'0800434563077'
,'0800130711058369'
,'0800416235863'
,'0800429698457'
,'0800425166190'
,'0800429191683'
,'0800428091951'
,'0800429040937'
,'0800428831219'
,'0800417257021'
,'0800130585159545'
,'0800423159600'
,'0800423966501'
,'0800437335832'
,'0800130505871398'
,'0800130607492510'
,'0800431255828'
,'0800432949144'
,'0800436727362'
,'0800433642260'
,'0800421370646'
,'0800417306758'
,'0800435459685'
,'0800421614829'
,'0800130712515194'
,'0800130711627746'
,'0800130709751731'
,'08006114557'
,'0800420137601'
,'0800420137607'
,'0800432125941'
,'0800425565943'
,'0800426876630'
,'0800417651747'
,'080054913179'
,'0800425647633'
,'0800422471104'
,'0800423834610'
,'0800414821726'
,'080066729547'
,'0800130535101902'
,'0800427933219'
,'0800428091092'
,'0800130641046074'
,'0800431604953'
,'0800425790395'
,'080054404219'
,'0800418143759'
,'0800430661967'
,'0800435993811'
,'080064491298'
,'0800413081009'
,'080064533183'
,'0800130697663858'
,'080058148651'
,'0800130709294918'
,'0800422788907'
,'0800430573702'
,'0800411733980'
,'0800432000808'
,'0800435153543'
,'0800130711550336'
,'0800420373856'
,'0800416961286'
,'0800427325614'
,'0800428914041'
,'0800431665181'
,'0800430345967'
,'0800421164345'
,'0800424770425'
,'0800130572968010'
,'0800413152153'
,'0800416013556'
,'0800411190132'
,'0800493326290'
,'0800133575160269'
,'0800436882249'
,'0800425956712'
,'0800427493649'
,'0800493322290'
,'0800426275742'
,'0800427641675'
,'0800426524975'
,'0800416469258'
,'080056796351'
,'0800130697566127'
,'0800423669551'
,'080056075513'
,'0800428564479'
,'0800130708984414'
,'0800130711594767'
,'0800430156280'
,'0800130501222530'
,'0800133708020309'
,'0800411689652'
,'080062030957'
,'0800416851191'
,'0800435545366'
,'0800432465690'
,'0800426045796'
,'0800130518796158'
,'0800410465366'
,'0800426062501'
,'0800130710072988'
,'0800420419881'
,'0800430234022'
,'0800425061835'
,'0800494032026'
,'0800418253344'
,'0800411264569'
,'0800432571979'
,'080066156472'
,'0800130708486813'
,'0800422843136'
,'0800429930738'
,'0800423994352'
,'0800428410069'
,'0800412265860'
,'0800412518827'
,'080055098369'
,'080056899187'
,'0800130563137106'
,'0800421370301'
,'0800423873065'
,'0800130711655472'
,'0800425793079'
,'080064282078'
,'0800434755289'
,'0800130632090206'
,'0800420646228'
,'0800422411446'
,'0800425251275'
,'0800435146461'
,'0800133703467909'
,'0800421862316'
,'0800428926169'
,'0800430781790'
,'0800433943552'
,'0800429128492'
,'0800431343342'
,'0800431381513'
,'0800430869993'
,'0800130501579471'
,'0800130517874910'
,'0800130694988330'
,'0800130623608677'
,'0800130693197879'
,'0800410643319'
,'0800411265279'
,'080061079860'
,'0800413062369'
,'0800413625532'
,'0800493314201'
,'0800420361380'
,'0800421480326'
,'0800423060842'
,'0800423175740'
,'0800421483843'
,'0800423724152'
,'0800423873181'
,'0800425744943'
,'0800425997669'
,'0800427056319'
,'0800428363472'
,'0800428810317'
,'0800430423134'
,'0800430973436'
,'0800431009138'
,'0800431380813'
,'0800431574685'
,'0800431828850'
,'0800431952254'
,'0800431963589'
,'0800434929981'
,'0800130698447288'
,'0800414569173'
,'080054055576'
,'080062329680'
,'0800434640123'
,'0800410814130'
,'0800412743095'
,'0800413184137'
,'0800414516081'
,'0800416246789'
,'0800416916291'
,'0800421373297'
,'0800423173105'
,'0800422354299'
,'0800424009341'
,'0800424957896'
,'0800427329844'
,'0800429119923'
,'0800429759656'
,'0800431115864'
,'0800431219409'
,'08006997870'
,'080066430597'
,'080065801966'
,'080065214478'
,'080065007610'
,'0800424917310'
,'080064118498'
,'080062273403'
,'080058246012'
,'080057122577'
,'0800425650136'
,'080056575599'
,'080061461070'
,'080056134366'
,'0800410704220'
,'080055273956'
,'080066712125'
,'0800412744354'
,'080055092173'
,'080054618603'
,'080054384317'
,'080063048004'
,'0800493162908'
,'0800438254182'
,'0800436426421'
,'0800435957997'
,'0800435575636'
,'0800435189633'
,'0800434612351'
,'0800434414649'
,'0800433472004'
,'0800433457069'
,'0800433363232'
,'0800433162030'
,'0800433752542'
,'0800432881013'
,'0800447959706'
,'0800445928853'
,'0800432629174'
,'0800432315696'
,'0800432176786'
,'080061195399'
,'0800432312252'
,'0800412268776'
,'0800432102420'
,'0800432008833'
,'0800431912426'
,'0800431852180'
,'0800431622521'
,'0800431215384'
,'0800414175888'
,'0800414297241'
,'0800431188005'
,'080062786680'
,'080056920775'
,'0800430309111'
,'0800430176096'
,'0800430108286'
,'0800429974313'
,'0800429788136'
,'0800429594744'
,'0800429403610'
,'0800429273694'
,'0800429189934'
,'0800428474527'
,'0800428571148'
,'0800428538796'
,'0800430508769'
,'080056804876'
,'0800411190981'
,'0800428327817'
,'080056264581'
,'0800427767902'
,'0800429246702'
,'0800427393991'
,'0800427282016'
,'0800426345352'
,'0800429196978'
,'080065766924'
,'0800426316323'
,'0800426279865'
,'0800426047639'
,'0800425936153'
,'0800422871024'
,'0800425660375'
,'0800425394288'
,'0800425273120'
,'0800425222207'
,'0800425131962'
,'0800493230080'
,'0800425072925'
,'0800424870900'
,'0800424653878'
,'0800424563881'
,'080054285804'
,'0800424182431'
,'0800493313484'
,'0800493134638'
,'0800493192283'
,'0800493192289'
,'0800423833362'
,'0800423567606'
,'0800422718335'
,'0800423469955'
,'0800423387990'
,'0800423302582'
,'0800495110109'
,'0800423175482'
,'0800423174173'
,'0800422906045'
,'0800422736316'
,'0800422684831'
,'0800422519158'
,'0800420173135'
,'0800421946712'
,'080064531400'
,'080062720376'
,'0800420569001'
,'0800420214029'
,'080064227854'
,'0800420200696'
,'08006288436'
,'0800420023634'
,'080054797644'
,'080069987156'
,'0800418447941'
,'080068332268'
,'0800420932112'
,'0800418000330'
,'0800418306555'
,'0800418079920'
,'0800418082069'
,'080056879906'
,'0800417867442'
,'0800417836584'
,'0800417720131'
,'0800417623823'
,'0800417521562'
,'0800418370263'
,'0800417305413'
,'0800417098142'
,'0800420419892'
,'080064409551'
,'0800416068918'
,'0800413354858'
,'0800414976049'
,'0800414260377'
,'0800414434054'
,'0800418286878'
,'0800414284092'
,'0800414012999'
,'08006261900'
,'0800413978735'
,'0800413798848'
,'0800411045207'
,'0800413120813'
,'0800413417893'
,'080051674341'
,'0800413131612'
,'0800412424444'
,'0800411978279'
,'0800428430507'
,'0800429964875'
,'080067366094'
,'0800412872365'
,'0800434131580'
,'0800436141272'
,'0800411819540'
,'0800441087579'
,'0800438332584'
,'0800411264629'
,'0800413569327'
,'0800410265050'
,'0800133714020019'
,'0800133704764249'
,'0800130714316059'
,'0800130714274720'
,'0800130714176532'
,'0800130713378506'
,'0800130712934200'
,'0800130712367799'
,'0800130710557957'
,'0800130709596388'
,'0800130708676973'
,'0800130698510273'
,'0800130615614072'
,'0800130573360938'
,'0800130516970134'
,'0800130505725774'
,'0800130551518694'
,'0800130568457451'
,'0800130576721710'
,'0800130627328822'
,'0800130708202866'
,'0800130710423241'
,'0800130710618972'
,'0800130712002367'
,'0800130712414991'
,'0800130712794905'
,'0800130712954309'
,'0800130713728302'
,'0800130714176621'
,'0800130714245313'
,'0800130714285234'
,'0800410306898'
,'0800411460545'
,'0800411735220'
,'0800411971658'
,'0800414892427'
,'0800412574229'
,'0800412815967'
,'0800413066475'
,'080063204239'
,'0800413359896'
,'0800413638011'
,'0800435900994'
,'0800413951661'
,'0800437853057'
,'080053158352'
,'0800413993556'
,'0800421530500'
,'0800414398081'
,'0800414434152'
,'0800414542025'
,'0800414682957'
,'0800418504138'
,'080054086783'
,'0800414978115'
,'0800434098401'
,'0800416778749'
,'0800416910103'
,'0800417024043'
,'0800422759206'
,'0800417838893'
,'0800418458222'
,'0800434917669'
,'0800418553271'
,'080055374624'
,'0800420112034'
,'0800421369749'
,'0800420610484'
,'0800414311379'
,'0800420688259'
,'0800423343916'
,'0800421548577'
,'0800422212702'
,'0800422363051'
,'0800422475889'
,'0800422543568'
,'0800422669727'
,'0800422815153'
,'0800422851021'
,'0800418562837'
,'0800423027827'
,'0800423159799'
,'080066437921'
,'0800424893503'
,'0800423288180'
,'0800423335434'
,'0800423485312'
,'0800423790491'
,'0800423834970'
,'0800425795877'
,'0800424493296'
,'080064421340'
,'080063906387'
,'0800424695253'
,'0800424859898'
,'0800428179582'
,'0800424996327'
,'0800425129286'
,'0800425187311'
,'0800425712575'
,'0800425971810'
,'0800426073335'
,'0800426265150'
,'0800426402220'
,'0805226887422'
,'0800426652681'
,'0800426835973'
,'0800427011402'
,'0800427344831'
,'0800427402142'
,'0800427540994'
,'0800427739387'
,'0800427790245'
,'0800428504501'
,'0800428566792'
,'0800428928023'
,'0800429309273'
,'0800429617878'
,'0800429851167'
,'0800428641356'
,'0800429979014'
,'0800430329129'
,'0800430766765'
,'0800416329021'
,'0800431000101'
,'0800431047925'
,'0800431181455'
,'0800431206812'
,'0800431303598'
,'0800431884217'
,'080066065626'
,'0800431934684'
,'0800431996196'
,'080066217835'
,'0800432044397'
,'0800432104132'
,'0800432178078'
,'0800432282351'
,'0800432397997'
,'0800432783915'
,'0800433100514'
,'0800433206286'
,'0800433428320'
,'0800433516421'
,'0800433830501'
,'0800434230516'
,'0800434769422'
,'0800435577121'
,'0800436593641'
,'0800435728125'
,'0800436729783'
,'0800437103887'
,'0800492176422'
,'0800412163823'
,'0800492823205'
,'0800493465098'
,'0800494055814'
,'080054403216'
,'0800428644433'
,'080054420191'
,'080065380289'
,'080054447519'
,'080065290646'
,'080054547547'
,'080054830804'
,'080061718196'
,'080056906627'
,'080057778214'
,'080058029288'
,'080058148844'
,'080061382459'
,'080055288470'
,'080062860291'
,'080062988012'
,'080063872685'
,'080064177680'
,'080064268353'
,'080065410961'
,'080066405714'
,'0800427767058'
,'0805229952'
,'0800494432269'
,'0800411275332'
,'0800133710989309'
,'0800410036720'
,'0800410763231'
,'0800130502704334'
,'0800130504294222'
,'0800130545889923'
,'0800433279096'
,'0800410038385'
,'0800130708838825'
)

GROUP BY LIQUIDACIONES.CodFondo,LIQUIDACIONES.CodTpValorCp, LIQUIDACIONES.CodCuotapartista, LIQUIDACIONES.CodCondicionIngEgr, LIQUIDACIONES.CodMoneda,
CUOTAPARTISTAS.Nombre, CUOTAPARTISTAS.NumCuotapartista, PERSONAS.CodInterfazBanco, 
FONDOS.NumFondo, FONDOS.Nombre, TPVALORESCP.Abreviatura
HAVING  SUM(LIQUIDACIONES.CantCuotapartes) > 0

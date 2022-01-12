
---- CAMBIAR USUARIO DE CONEXION APIS AL DE UNITRADE

---SVC_3SCUNITRADE_DESA
---@pkP1-5d
---752d8942




DELETE AGCOLOCPARAM WHERE CodParametroAgColoc in 
(
'WSAPIU', 
'WSAPIP',
'WSREI',
'WSUCAN', 
'WSSIS', 
'WSURLT',
'WSAPIG',
'WSAPIS',
'WSPCLI',
'WSPCLS',
'WSURLP',
'WSRCLI',
'WSRCLS',
'WSURLR',
'WSCCLI',
'WSCCLS',
'WSURLC'
)
go 


-- SVC_3SCVFNET_DESA y m%4Lb46D&YKN
--- API Usuario TOKEN - 
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSAPIU',8,0,NULL,'4CA892B833573972A4F949ED780F1B9956B0CBAAE717B7ED',NULL,0,1)

--- API Password Token 
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSAPIP',8,0,NULL,'9F8916CD66F71B12DD7CCC2558098F23',NULL,0,1)

--- CANTIDAD DE REINTENTOS  
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSREI',8,0,NULL,NULL,3,0,1)

---  API  Usuario Canal   -- rjadesa
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSUCAN',8,0,NULL,'84EA8FE26A37D694',NULL,0,1)

---API Sistema   --- RJA
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSSIS',8,0,NULL,'RJA',NULL,0,1)


--- API URL TOKEN ----- 49,WSURLT,8,0,NULL,https://sso-dev.hipotecario.com.ar/auth/realms/bh/protocol/openid-connect/token,NULL,0,988009
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSURLT',8,0,NULL,'https://sso-dev.hipotecario.com.ar/auth/realms/bh/protocol/openid-connect/token',NULL,0,1)


--- API TOKEN grantType 56,WSAPIG,8,0,NULL,password,NULL,0,988009
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSAPIG',8,0,NULL,'password',NULL,0,1)

--- API TOKEN scope 55,WSAPIS,8,0,NULL,RJA,NULL,0,988009
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSAPIS',8,0,NULL,'RJA',NULL,0,1)



---- PARAMETRIA PARA CADA API
---- API PERSONAS CLIENT ID 51,WSPCLI,8,0,NULL,2c3e9403,NULL,0,988009
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSPCLI',8,0,NULL,'2c3e9403',NULL,0,1)

---- API PERSONAS CLIENT SECRET  50,WSPCLS,8,0,NULL,5811bc88d34d9f2c72a60c67c6f88418,NULL,0,988009
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSPCLS',8,0,NULL,'5811bc88d34d9f2c72a60c67c6f88418',NULL,0,1)

--- URL API Personas  ----- 57,WSURLP,8,0,NULL,2AB857E407627D17876DB98D022D76C840E03A221B8C43C458E677E0C0EC9AD8C98D159E642C9EA8F87A090D553B5B94,NULL,0,988009
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSURLP',8,0,NULL,'2AB857E407627D17876DB98D022D76C840E03A221B8C43C458E677E0C0EC9AD8C98D159E642C9EA8F87A090D553B5B94',NULL,0,1)

--- API PRODUCTO - CLIENT ID  --- 68,WSRCLI,8,0,NULL,f2166bef ,NULL,0,988009
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSRCLI',8,0,NULL,'f2166bef' ,NULL,0,1)


--- API PRODUCTO - CLIENT SECRET --- 67,WSRCLS,8,0,NULL,47ae2297d67a1203f7c7cc0236b73553,NULL,0,988009
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSRCLS',8,0,NULL,'47ae2297d67a1203f7c7cc0236b73553',NULL,0,1)

--- API URL API Producto -----69,WSURLR,8,0,NULL,2AB857E407627D1715F439D2C18AC6670163D5CF7DCE63A94AABC1C6A002D63C70AB3A5ECA983C9D4B89B003950A4A27,NULL,0,988009
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSURLR',8,0,NULL,'2AB857E407627D1715F439D2C18AC6670163D5CF7DCE63A94AABC1C6A002D63C70AB3A5ECA983C9D4B89B003950A4A27',NULL,0,1)



--- API CUENTAS CLIENT ID  ---  83,WSCCLI,8,0,NULL,84a5d8b2,NULL,0,988037
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSCCLI',8,0,NULL,'84a5d8b2',NULL,0,1)

---- API CUENTAS CLIENT SECRET --- 82,WSCCLS,8,0,NULL,fec8bf4f9f3a3ca457c0874e3cd29d69,NULL,0,988036
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSCCLS',8,0,NULL,'fec8bf4f9f3a3ca457c0874e3cd29d69',NULL,0,1)

--- URL API Cuentas  ----81,WSURLC,8,0,NULL,2AB857E407627D175C46EA61092953C83A620BE9C52E3EC3E8A58CC437872A6724629D7FBBFB330076696D576CE76B0C,NULL,0,988035
INSERT INTO AGCOLOCPARAM (CodParametroAgColoc,CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef) VALUES 
('WSURLC',8,0,NULL,'2AB857E407627D175C46EA61092953C83A620BE9C52E3EC3E8A58CC437872A6724629D7FBBFB330076696D576CE76B0C',NULL,0,1)


--- INSERT DE PARAMETROS AGENTE COLOCADO 9 
INSERT INTO AGCOLOCPARAM
SELECT CodParametroAgColoc, 9 AS CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef 
FROM AGCOLOCPARAM WHERE 
CodAgColocador =8 AND 
CodParametroAgColoc in 
(
'WSAPIU', 
'WSAPIP',
'WSREI',
'WSUCAN', 
'WSSIS', 
'WSURLT',
'WSAPIG',
'WSAPIS',
'WSPCLI',
'WSPCLS',
'WSURLP',
'WSRCLI',
'WSRCLS',
'WSURLR',
'WSCCLI',
'WSCCLS',
'WSURLC'
)
go 
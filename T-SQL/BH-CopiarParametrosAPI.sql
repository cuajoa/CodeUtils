
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


--- INSERT DE PARAMETROS AGENTE COLOCADO 9 
INSERT INTO AGCOLOCPARAM
SELECT CodParametroAgColoc, CodAgColocador,ValorBoolean,ValorFecha,ValorTexto,ValorNumerico,EstaAnulado,CodAuditoriaRef 
FROM vfCli_Toronto_07_00_12..AGCOLOCPARAM 
WHERE 
CodAgColocador IN(8,9) AND 
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
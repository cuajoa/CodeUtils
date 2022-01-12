INSERT FONDOSUSER
	(CodFondo
,CodUsuario)
SELECT FONDOS.CodFondo
,USUARIOS.CodUsuario
FROM USUARIOS, FONDOS
WHERE not CodUsuario in( select CodUsuario from FONDOSUSER
WHERE FONDOSUSER.CodUsuario = USUARIOS.CodUsuario
			and FONDOSUSER.CodFondo = FONDOS.CodFondo)

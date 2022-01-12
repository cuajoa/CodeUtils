
--Le pone al usuario seleccionado la clave: sasa
UPDATE  USUARIOS 
SET     Clave = '7BF1AB1B8F7331AB5DC410E01F959D958BFD210E', 
        FechaBloqueo = NULL, 
        Estado='A', 
        CantidadLogonErroneos = 0, 
        FechaUltimoLogonErroneo = NULL 
WHERE   UserID = 'USUARIO'


--Copia el usuario de la base especificada debajo a la base donde se ejecute el Insert
USE [BASE_DE_DATOS_TEST]
GO

INSERT INTO USUARIOS(UserID,Apellido,Nombre,Clave,Estado,DebeCambiarClave,FechaUltimoCambioClave,FechaUltimoLogon,FechaUltimoLogonErroneo,CantidadLogonErroneos
,EsSupervisor,CodInterfaz,Observaciones,EstaAnulado,CodAuditoriaRef,EMail,UserIDMail,PasswordMail,CodCentralizadora,EsExterno,UserIDExterno,CodOperador,FechaIngreso
,CodUsuarioI,FechaI,TermI,CodUsuarioD,FechaD,TermD,EsLoginEstandar,FechaBloqueo,CodUsuarioU,FechaU,TermU,EsActiveDirectory,FechaConteoInactividad,EsUsuarioServicio)
SELECT UserID,Apellido,Nombre,Clave,Estado,DebeCambiarClave,FechaUltimoCambioClave,FechaUltimoLogon,FechaUltimoLogonErroneo,CantidadLogonErroneos
,EsSupervisor,CodInterfaz,Observaciones,EstaAnulado,CodAuditoriaRef,EMail,UserIDMail,PasswordMail,CodCentralizadora,EsExterno,UserIDExterno,CodOperador,FechaIngreso
,CodUsuarioI,FechaI,TermI,CodUsuarioD,FechaD,TermD,EsLoginEstandar,FechaBloqueo,CodUsuarioU,FechaU,TermU,EsActiveDirectory,FechaConteoInactividad,EsUsuarioServicio 
FROM [BASE_DE_DATOS_PROD]..USUARIOS
WHERE  UserID = 'USUARIO'

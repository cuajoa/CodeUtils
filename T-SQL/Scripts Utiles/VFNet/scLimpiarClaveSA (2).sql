/* la clave exigida será sasa, para el usuario sa */
UPDATE  USUARIOS 
SET     Clave = '7BF1AB1B8F7331AB5DC410E01F959D958BFD210E', 
        FechaBloqueo = NULL, 
        Estado='A', 
        CantidadLogonErroneos = 0, 
        FechaUltimoLogonErroneo = NULL 
WHERE   CodUsuario = 1

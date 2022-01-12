/* la clave exigida será sa, para el usuario sa */
UPDATE  USUARIOS 
SET     Clave = '3608A6D1A05ABA23EA390E5F3B48203DBB7241F7', 
        FechaBloqueo = NULL, 
        Estado='A', 
        CantidadLogonErroneos = 0, 
        FechaUltimoLogonErroneo = NULL 
WHERE   CodUsuario = 1

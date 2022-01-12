--CUOTAPARTISTAS
UPDATE CUOTAPARTISTAS
    SET Nombre = REPLICATE('X', 50)
        ,Calle = NULL
        ,AlturaCalle = NULL
        ,Piso = NULL
        ,Departamento = NULL
        ,CodigoPostal = NULL
        ,Localidad = NULL
        ,Telefono = NULL
        ,Fax = NULL
        ,EMail = NULL
        ,NumCustodia = NULL

UPDATE CPTJURIDICOS
    SET CodPaisNacionalidad = NULL
        ,CodTpContribuyente = NULL
        ,LugarConstitucion = NULL
        ,NumInscripcion = NULL
        ,Folio = NULL
        ,Libro = NULL
        ,Tomo = NULL
        ,CUIT = NULL
        ,FechaInterfEntr = NULL
        ,FechaConstitucion = NULL
        ,Escritura = NULL
        ,CodMonedaPatEstim = NULL
        ,CodMonedaFactEstim = NULL
        --,CodMonedaMontoEstim = NULL
        ,PatrimonioEstim = NULL
        ,FacturacionEstim = NULL
        --,MontoEstim = NULL

UPDATE PERSONAS
    SET Apellido = REPLICATE('X', 50)
        ,Nombre = REPLICATE('X', 50)
        ,Calle = NULL
        ,AlturaCalle = NULL
        ,Piso = NULL
        ,Departamento = NULL
        ,CodigoPostal = NULL
        ,Localidad = NULL
        ,Telefono = NULL
        ,Fax = NULL
        ,EMail = NULL
        ,CodTpDocIdentidad = NULL
        ,NumDocumento = NULL
        ,FechaNacimiento = NULL
        ,CUIT = NULL 
        ,CUIL = NULL 
        ,Firma = NULL 
        ,Foto = NULL 
        ,CDI = NULL 
        ,CodConyuge = NULL 
        ,CodMonedaPatEstim = NULL 
        ,PatrimonioEstim = NULL 

DELETE FROM CPTMAILS
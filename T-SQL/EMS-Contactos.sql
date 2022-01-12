--SELECT * FROM PERSONAS WHERE EstaAnulado=0

SELECT EMPRESAS.Descripcion as Empresa, Nombre, Apellido, ISNULL(ISNULL(PERSONAS.Calle + ' ' + PERSONAS.AlturaCalle + ' ' + PERSONAS.Piso + ' ' + PERSONAS.Departamento, EMPRESAS.Calle + ' ' + EMPRESAS.AlturaCalle + ' ' + EMPRESAS.Piso + ' ' + EMPRESAS.Departamento),'') as Calle,
ISNULL(PERSONAS.CodigoPostal,'') CodigoPostal, ISNULL(PERSONAS.Localidad,'')Localidad, ISNULL(PERSONAS.Telefono,'')Telefono, ISNULL(PERSONAS.TelefonoCelular,'') Celular,ISNULL(PERSONAS.EMail,'') Email , ISNULL(PERSONAS.Fax,'')Fax, ISNULL(PERSONAS.Observaciones,'') Observaciones
,ISNULL(PAISES.Descripcion,'') As Pais, ISNULL(PROVINCIAS.Descripcion,'') as Provincia
FROM PERSONAS
LEFT JOIN EMPRESAS ON PERSONAS.CodEmpresa=EMPRESAS.CodEmpresa
LEFT JOIN PAISES ON PERSONAS.CodPais=PAISES.CodPais
LEFT JOIN PROVINCIAS ON PERSONAS.CodPais=PROVINCIAS.CodPais AND PERSONAS.CodProvincia=PROVINCIAS.CodProvincia 
WHERE PERSONAS.EstaAnulado=0 AND EMPRESAS.EstaAnulado=0 
ORDER BY Empresa, Nombre,Apellido


SELECT EMPRESAS.Descripcion as Empresa, '', '', ISNULL(ISNULL(EMPRESAS.Calle + ' ' + EMPRESAS.AlturaCalle + ' ' + EMPRESAS.Piso + ' ' + EMPRESAS.Departamento, EMPRESAS.Calle + ' ' + EMPRESAS.AlturaCalle + ' ' + EMPRESAS.Piso + ' ' + EMPRESAS.Departamento),'') as Calle,
ISNULL(EMPRESAS.CodigoPostal,'') CodigoPostal, ISNULL(EMPRESAS.Localidad,'')Localidad, ISNULL(EMPRESAS.Telefono,'')Telefono, '', '' , ISNULL(EMPRESAS.Fax,'')Fax, ''
,ISNULL(PAISES.Descripcion,'') As Pais, ISNULL(PROVINCIAS.Descripcion,'') as Provincia
FROM EMPRESAS
LEFT JOIN PAISES ON EMPRESAS.CodPais=PAISES.CodPais
LEFT JOIN PROVINCIAS ON EMPRESAS.CodPais=PROVINCIAS.CodPais AND EMPRESAS.CodProvincia=PROVINCIAS.CodProvincia 
WHERE EMPRESAS.EstaAnulado=0 
ORDER BY Empresa
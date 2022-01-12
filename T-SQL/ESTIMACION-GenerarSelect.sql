SELECT 'USE ' + name + '
  
 EXEC sp_spaceused
 ' FROM sys.databases
Order by name

SELECT 'USE ' + name + '
 EXEC sp_spaceused N''VALORESCP''
 SELECT MIN(FechaConcertacion) as FechaConcertacionMin,  MAX(FechaConcertacion) as FechaConcertacionMax FROM SOLSUSC' FROM sys.databases
Order by name



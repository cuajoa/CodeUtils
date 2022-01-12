# RUTAS
#\\server20\VFHome\Versiones\7_00_12\Instalacion
#\\server20\VFNet\Versiones
#\\server20\VisualFondos\Versiones
#\\server20\VisualFondos\Servicios\ServiceLayer
#\\server20\VisualFondos\Servicios\ServiceLayerLINK
#\\server20\VisualFondos\Servicios\Servicio GDIN
#

# Destino --> \\server20\VisualFondos\Implementaciones

#PASOS
# Crea carpeta en destino yyyyMMdd_CLIENTE
# Copia VFondos (Por Defecto Sí)
# Copia GDIN (Por Defecto No)
# Copia SL (Por Defecto No)
# Copia VFNet (Por Defecto No)
# Copia VFHome (Por Defecto No)
# Zipea
# Copia en Descargas

# 1 - Fondos
# 2 - Fondos con GDIN
# 3 - Fondos con SL
# 4 - Fondos Completo (VF+GDIN+SL)
# 5 - SUITE (VF+GDIN+SL+HOME+VFNET)
# 6 - Fondos + Home (VF+HOME)

Write-Output "Ejecutando empaquetado de Fondos"

$PathDestination = "\\server20\VisualFondos\Implementaciones"

Get-ChildItem -Path $Origin -Recurse | Copy-Item -Destination $PathDestination -Recurse -Force -Verbose

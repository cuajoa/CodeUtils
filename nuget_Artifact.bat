REM Registra los Artifact en una máquina.
REM Requiere que tenga nuget.exe en la misma ruta

nuget.exe sources Add -Name "EscoNetArtifact" -Source "https://devops.sistemasesco.com/Fondos/_packaging/EscoNetArtifact/nuget/v3/index.json"

nuget.exe sources Add -Name "FondosArtifact" -Source "https://devops.sistemasesco.com/Fondos/_packaging/FondosArtifact/nuget/v3/index.json"

nuget.exe sources Add -Name "Infragistics" -Source "https://devops.sistemasesco.com/ESCO/_packaging/Infragistics/nuget/v3/index.json"

nuget.exe sources Add -Name "EscoLibrary" -Source "https://devops.sistemasesco.com/ESCO/_packaging/EscoLibrary/nuget/v3/index.json"

nuget.exe sources Add -Name "Esco_Feed" -Source "https://devops.sistemasesco.com/ESCO/_packaging/Esco_Feed/nuget/v3/index.json"

pause
REM Desbloquea un archivo tomado por un usuario en una máquina.
REM Ejemplo tf undo /workspace:NTBESCOBUE19_1;"Damian Ruiz" /recursive $/Fondos/VFHome/Proyecto/UserInterface/VFHome.UserInterface.vbproj

tf undo /workspace:{MACHINE_NAME};"{USER}" /recursive {PATH_COMPLETO_TFS}


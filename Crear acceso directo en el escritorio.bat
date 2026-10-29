@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\VozLimpia.lnk'); $s.TargetPath='%~dp0Abrir VozLimpia.bat'; $s.WorkingDirectory='%~dp0'; $s.WindowStyle=7; $s.Save()"
echo Listo: ya tienes "VozLimpia" en el escritorio.
pause

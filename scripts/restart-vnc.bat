@echo off
title Reiniciar Servidor VNC
color 0E

echo ========================================
echo   REINICIANDO SERVIDOR VNC
echo ========================================
echo.

REM Verificar si Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker no esta corriendo.
    pause
    exit /b 1
)

REM Verificar si el contenedor está corriendo
docker ps | findstr kali-gui-container >nul 2>&1
if errorlevel 1 (
    echo [ERROR] El contenedor kali-gui-container no esta corriendo.
    echo Ejecuta start-kali-gui.bat primero.
    pause
    exit /b 1
)

echo [1/3] Deteniendo servidor VNC...
docker exec kali-gui-container su - tuusuario -c "vncserver -kill :1" 2>nul

echo [2/3] Limpiando archivos temporales...
docker exec kali-gui-container rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1 2>nul

echo [3/3] Iniciando servidor VNC...
docker exec -it kali-gui-container su - tuusuario -c "vncserver :1 -geometry 1920x1080 -depth 24"

echo.
echo ========================================
echo   SERVIDOR VNC REINICIADO
echo ========================================
echo.
echo Conecta con VNC Viewer a: localhost:5901
echo.
pause

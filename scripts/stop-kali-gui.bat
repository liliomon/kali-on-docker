@echo off
title Detener Kali Linux
color 0C

echo ========================================
echo   DETENIENDO KALI LINUX
echo ========================================
echo.

REM Verificar si Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker no esta corriendo.
    pause
    exit /b 1
)

echo [1/2] Deteniendo servidor VNC...
docker exec kali-gui-container su - tuusuario -c "vncserver -kill :1" 2>nul
if errorlevel 1 (
    echo [AVISO] No se pudo detener VNC (puede que no estuviera corriendo)
) else (
    echo [OK] Servidor VNC detenido.
)

echo [2/2] Deteniendo contenedor...
docker stop kali-gui-container >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No se pudo detener el contenedor.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   KALI LINUX DETENIDO CORRECTAMENTE
echo ========================================
echo.
echo Para volver a iniciar, ejecuta: start-kali-gui.bat
echo.
pause

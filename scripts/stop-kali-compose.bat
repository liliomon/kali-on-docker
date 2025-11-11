@echo off
title Detener Kali Linux
color 0C

echo ========================================
echo   DETENIENDO KALI LINUX
echo ========================================
echo.

REM Cambiar al directorio del script
cd /d "%~dp0\.."

REM Verificar si Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker no esta corriendo.
    pause
    exit /b 1
)

echo [INFO] Deteniendo contenedor...
docker-compose stop

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
echo Los datos se han guardado en volumenes de Docker.
echo.
echo Para volver a iniciar:
echo   scripts\start-kali-compose.bat
echo.
echo Para eliminar completamente (incluyendo datos):
echo   docker-compose down -v
echo.
pause

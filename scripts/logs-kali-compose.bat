@echo off
title Logs de Kali Linux
color 0E

echo ========================================
echo   MOSTRANDO LOGS DE KALI LINUX
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

echo [INFO] Mostrando logs en tiempo real...
echo [INFO] Presiona Ctrl+C para salir
echo.
echo ========================================
echo.

docker-compose logs -f

pause

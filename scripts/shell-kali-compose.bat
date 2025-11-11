@echo off
title Terminal de Kali Linux
color 0B

echo ========================================
echo   CONECTANDO A TERMINAL DE KALI LINUX
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

REM Verificar si el contenedor está corriendo
docker-compose ps | findstr "Up" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] El contenedor no esta corriendo.
    echo Ejecuta start-kali-compose.bat primero.
    pause
    exit /b 1
)

echo [INFO] Conectando como usuario 'kaliuser'...
echo [INFO] Para salir, escribe: exit
echo.
echo ========================================
echo.

docker-compose exec -u kaliuser kali-gui bash

echo.
echo Desconectado de Kali Linux.
pause

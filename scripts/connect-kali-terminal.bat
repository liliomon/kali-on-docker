@echo off
title Conectar a Terminal de Kali Linux
color 0B

echo ========================================
echo   CONECTANDO A KALI LINUX TERMINAL
echo ========================================
echo.

REM Verificar si Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker no esta corriendo.
    echo Por favor, inicia Docker Desktop primero.
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

echo [INFO] Conectando como usuario 'tuusuario'...
echo [INFO] Para salir, escribe: exit
echo.
echo ========================================
echo.

docker exec -it kali-gui-container su - tuusuario

echo.
echo Desconectado de Kali Linux.
pause

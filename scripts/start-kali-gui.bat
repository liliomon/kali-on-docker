@echo off
title Iniciar Kali Linux con GUI
color 0A

echo ========================================
echo   INICIANDO KALI LINUX CON GUI
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

echo [1/3] Verificando contenedor...
docker ps -a | findstr kali-gui-container >nul 2>&1
if errorlevel 1 (
    echo [INFO] Contenedor no existe. Creando nuevo contenedor...
    docker run -d -p 5901:5901 --name kali-gui-container kali-gui:v1 tail -f /dev/null
    if errorlevel 1 (
        echo [ERROR] No se pudo crear el contenedor.
        echo Asegurate de haber creado la imagen kali-gui:v1
        pause
        exit /b 1
    )
) else (
    echo [INFO] Contenedor encontrado.
)

echo [2/3] Iniciando contenedor...
docker start kali-gui-container >nul 2>&1

echo [3/3] Iniciando servidor VNC...
docker exec -it kali-gui-container su - tuusuario -c "vncserver :1 -geometry 1920x1080 -depth 24" 2>nul

echo.
echo ========================================
echo   KALI LINUX INICIADO CORRECTAMENTE
echo ========================================
echo.
echo Conecta con VNC Viewer a: localhost:5901
echo.
echo Comandos utiles:
echo   - Para detener: ejecuta stop-kali-gui.bat
echo   - Para conectar terminal: docker exec -it kali-gui-container /bin/bash
echo.
pause

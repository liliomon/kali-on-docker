@echo off
title Detener Kali Docker Compose
color 0C

echo ========================================
echo   DETENIENDO KALI DOCKER COMPOSE
echo ========================================
echo.

REM Verificar si Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker no esta corriendo.
    pause
    exit /b 1
)

REM Verificar si existe docker-compose.yml
if not exist "docker-compose.yml" (
    echo [ERROR] No se encuentra el archivo docker-compose.yml.
    echo Asegurate de estar en el directorio correcto.
    pause
    exit /b 1
)

echo [INFO] Deteniendo servicios...
docker-compose down

if errorlevel 1 (
    echo.
    echo [ERROR] Fallo al detener los servicios.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   SERVICIOS DETENIDOS CORRECTAMENTE
echo ========================================
echo.
echo Para volver a iniciar:
echo   - Ejecuta: docker-compose-up.bat
echo.
echo Para eliminar tambien los volumenes:
echo   - Ejecuta: docker-compose down -v
echo.
pause

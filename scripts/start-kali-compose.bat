@echo off
title Iniciar Kali Linux con Docker Compose
color 0A

echo ========================================
echo   INICIANDO KALI LINUX CON DOCKER COMPOSE
echo ========================================
echo.

REM Cambiar al directorio del script
cd /d "%~dp0\.."

REM Verificar si Docker está corriendo
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker no esta corriendo.
    echo Por favor, inicia Docker Desktop primero.
    pause
    exit /b 1
)

echo [INFO] Iniciando contenedor con Docker Compose...
docker-compose up -d

if errorlevel 1 (
    echo [ERROR] No se pudo iniciar el contenedor.
    pause
    exit /b 1
)

echo.
echo [INFO] Esperando a que XRDP inicie (15 segundos)...
timeout /t 15 /nobreak >nul

echo.
echo ========================================
echo   KALI LINUX INICIADO CORRECTAMENTE
echo ========================================
echo.
echo Conecta con MobaXterm o Remote Desktop a:
echo   Host: localhost (o IP del equipo para acceso remoto)
echo   Port: 3390
echo   User: kaliuser
echo   Pass: kali123
echo.
echo IMPORTANTE: Cambia la contraseña despues de conectar:
echo   docker-compose exec kali-gui passwd kaliuser
echo.
echo Para ver logs en tiempo real:
echo   docker-compose logs -f
echo.
pause

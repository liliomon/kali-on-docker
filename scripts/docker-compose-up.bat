@echo off
title Iniciar Kali con Docker Compose
color 0A

echo ========================================
echo   INICIANDO KALI CON DOCKER COMPOSE
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

REM Verificar si existe docker-compose.yml
if not exist "docker-compose.yml" (
    echo [ERROR] No se encuentra el archivo docker-compose.yml.
    echo Asegurate de estar en el directorio correcto.
    pause
    exit /b 1
)

echo [INFO] Iniciando servicios con Docker Compose...
echo [INFO] Este proceso puede tardar varios minutos la primera vez...
echo.

docker-compose up -d --build

if errorlevel 1 (
    echo.
    echo [ERROR] Fallo al iniciar los servicios.
    echo Revisa los errores anteriores.
    pause
    exit /b 1
)

echo.
echo [INFO] Esperando a que el contenedor este listo...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo   KALI LINUX INICIADO CON EXITO
echo ========================================
echo.
echo Estado de los servicios:
docker-compose ps

echo.
echo Conecta con VNC Viewer a: localhost:5901
echo Contrasena por defecto: kali123
echo.
echo Comandos utiles:
echo   - Ver logs: docker-compose logs -f
echo   - Detener: docker-compose down
echo   - Terminal: docker-compose exec kali-gui bash
echo.
pause

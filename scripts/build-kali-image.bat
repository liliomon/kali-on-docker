@echo off
title Construir Imagen de Kali Linux
color 0D

echo ========================================
echo   CONSTRUYENDO IMAGEN KALI LINUX
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

echo [INFO] Este proceso puede tardar varios minutos...
echo.

REM Verificar si existe Dockerfile
if not exist "Dockerfile" (
    echo [ERROR] No se encuentra el archivo Dockerfile.
    echo Asegurate de estar en el directorio correcto.
    pause
    exit /b 1
)

echo [1/3] Construyendo imagen desde Dockerfile...
docker build -t kali-gui:latest .

if errorlevel 1 (
    echo.
    echo [ERROR] Fallo la construccion de la imagen.
    echo Revisa los errores anteriores.
    pause
    exit /b 1
)

echo.
echo [2/3] Verificando imagen creada...
docker images | findstr kali-gui

echo.
echo [3/3] Creando tags adicionales...
docker tag kali-gui:latest kali-gui:v1

echo.
echo ========================================
echo   IMAGEN CONSTRUIDA EXITOSAMENTE
echo ========================================
echo.
echo Imagen disponible: kali-gui:latest
echo Tag adicional: kali-gui:v1
echo.
echo Siguiente paso:
echo   - Ejecuta start-kali-gui.bat para iniciar el contenedor
echo.
pause

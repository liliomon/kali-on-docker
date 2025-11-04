# Guía Completa: Kali Linux en Docker Desktop con Windows 11

Esta guía te llevará paso a paso para instalar Docker Desktop en Windows 11, configurar Kali Linux dockerizado con un entorno gráfico liviano.

---

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Paso 1: Instalar Docker Desktop](#paso-1-instalar-docker-desktop)
3. [Paso 2: Actualizar WSL](#paso-2-actualizar-wsl)
4. [Paso 3: Descargar Kali Linux](#paso-3-descargar-kali-linux)
5. [Paso 4: Verificar la Instalación](#paso-4-verificar-la-instalación)
6. [Paso 5: Ejecutar Kali Linux](#paso-5-ejecutar-kali-linux)
7. [Paso 6: Crear Usuario Sudo](#paso-6-crear-usuario-sudo)
8. [Paso 7: Guardar Cambios con Commit](#paso-7-guardar-cambios-con-commit)
9. [Paso 8: Instalar Entorno Gráfico](#paso-8-instalar-entorno-gráfico)
10. [Solución de Problemas](#solución-de-problemas)

---

## Requisitos Previos

- Windows 11 (64-bit)
- Mínimo 8GB de RAM (recomendado 16GB)
- 20GB de espacio libre en disco
- Virtualización habilitada en BIOS/UEFI
- Conexión a Internet

---

## Paso 1: Instalar Docker Desktop

### 1.1 Verificar Virtualización

Abre **Administrador de Tareas** (Ctrl + Shift + Esc) → Pestaña **Rendimiento** → **CPU**

Verifica que "Virtualización" esté **Habilitada**. Si no lo está:
- Reinicia tu PC
- Entra al BIOS/UEFI (generalmente F2, F10, F12 o DEL al iniciar)
- Busca "Intel VT-x" o "AMD-V" y habilítalo
- Guarda y reinicia

### 1.2 Habilitar Características de Windows

Abre **PowerShell como Administrador** y ejecuta:

```powershell
# Habilitar WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Habilitar Plataforma de Máquina Virtual
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Reiniciar el sistema
Restart-Computer
```

### 1.3 Descargar e Instalar Docker Desktop

1. Ve a: https://www.docker.com/products/docker-desktop/
2. Descarga **Docker Desktop for Windows**
3. Ejecuta el instalador `Docker Desktop Installer.exe`
4. Durante la instalación:
   - ✅ Marca "Use WSL 2 instead of Hyper-V"
   - ✅ Marca "Add shortcut to desktop"
5. Haz clic en **OK** y espera a que termine
6. Reinicia tu PC cuando se solicite

### 1.4 Verificar Instalación de Docker

Abre **PowerShell** o **CMD** y ejecuta:

```bash
docker --version
docker-compose --version
```

Deberías ver algo como:
```
Docker version 24.0.x, build xxxxx
Docker Compose version v2.x.x
```

---

## Paso 2: Actualizar WSL

### 2.1 Actualizar WSL a la Última Versión

Abre **PowerShell como Administrador**:

```powershell
# Actualizar WSL
wsl --update

# Verificar versión
wsl --version
```

### 2.2 Establecer WSL 2 como Predeterminado

```powershell
wsl --set-default-version 2
```

### 2.3 Listar Distribuciones WSL (Opcional)

```powershell
wsl --list --verbose
```

---

## Paso 3: Descargar Kali Linux

### 3.1 Descargar la Imagen de Kali

Abre **PowerShell** o **CMD**:

```bash
docker pull kalilinux/kali-rolling
```

Este proceso puede tardar varios minutos dependiendo de tu conexión a Internet (la imagen pesa aproximadamente 1-2 GB).

### 3.2 Verificar la Descarga

```bash
docker images
```

Deberías ver:
```
REPOSITORY              TAG       IMAGE ID       CREATED        SIZE
kalilinux/kali-rolling  latest    xxxxxxxxxxxx   X days ago     1.XXG
```

---

## Paso 4: Verificar la Instalación

### 4.1 Verificar que Docker Está Corriendo

```bash
docker ps
```

Si no hay errores, Docker está funcionando correctamente.

### 4.2 Probar Kali Linux

```bash
docker run --rm -it kalilinux/kali-rolling /bin/bash
```

Deberías ver el prompt de Kali:
```
┌──(root㉿xxxxxxxxx)-[/]
└─#
```

Escribe `exit` para salir.

---

## Paso 5: Ejecutar Kali Linux

### 5.1 Crear y Ejecutar Contenedor con Nombre

```bash
docker run -it --name kali-container kalilinux/kali-rolling /bin/bash
```

### 5.2 Actualizar el Sistema

Dentro del contenedor, ejecuta:

```bash
# Actualizar repositorios
apt update

# Actualizar paquetes instalados
apt upgrade -y

# Instalar herramientas básicas
apt install -y sudo nano vim wget curl git
```

---

## Paso 6: Crear Usuario Sudo

### 6.1 Crear Nuevo Usuario

Dentro del contenedor de Kali:

```bash
# Crear usuario (reemplaza 'tuusuario' con el nombre que desees)
useradd -m -s /bin/bash tuusuario

# Establecer contraseña
passwd tuusuario
```

### 6.2 Agregar Usuario al Grupo Sudo

```bash
# Agregar al grupo sudo
usermod -aG sudo tuusuario

# Verificar grupos del usuario
groups tuusuario
```

### 6.3 Configurar Sudo sin Contraseña (Opcional)

```bash
# Editar archivo sudoers
echo "tuusuario ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/tuusuario
chmod 0440 /etc/sudoers.d/tuusuario
```

### 6.4 Cambiar al Nuevo Usuario

```bash
su - tuusuario
```

### 6.5 Verificar Permisos Sudo

```bash
sudo whoami
```

Debería mostrar: `root`

---

## Paso 7: Guardar Cambios con Commit

### 7.1 Salir del Contenedor

```bash
exit  # Salir del usuario
exit  # Salir del contenedor
```

### 7.2 Verificar ID del Contenedor

```bash
docker ps -a
```

Busca el `CONTAINER ID` de `kali-container`.

### 7.3 Crear Imagen Personalizada

```bash
# Hacer commit de los cambios
docker commit kali-container kali-custom:v1

# Verificar la nueva imagen
docker images
```

Deberías ver tu nueva imagen `kali-custom` con tag `v1`.

### 7.4 Ejecutar la Nueva Imagen

```bash
# Detener y eliminar el contenedor anterior
docker stop kali-container
docker rm kali-container

# Ejecutar con la nueva imagen
docker run -it --name kali-custom-container kali-custom:v1 /bin/bash
```

---

## Paso 8: Instalar Entorno Gráfico

### 8.1 Opciones de Entornos Gráficos Livianos

Recomendaciones por peso y rendimiento:

1. **XFCE** - Ligero y completo (Recomendado)
2. **LXDE** - Muy ligero
3. **Fluxbox** - Minimalista

### 8.2 Instalar XFCE (Recomendado)

Dentro del contenedor:

```bash
# Actualizar repositorios
sudo apt update

# Instalar XFCE y componentes necesarios
sudo apt install -y kali-desktop-xfce xfce4 xfce4-goodies

# Instalar servidor VNC
sudo apt install -y tigervnc-standalone-server tigervnc-common

# Instalar dbus-x11 (necesario para algunas aplicaciones)
sudo apt install -y dbus-x11
```

### 8.3 Configurar VNC Server

```bash
# Crear directorio VNC
mkdir -p ~/.vnc

# Establecer contraseña VNC
vncpasswd
```

Ingresa una contraseña (mínimo 6 caracteres) y confírmala.

### 8.4 Crear Script de Inicio VNC

```bash
# Crear archivo de inicio
nano ~/.vnc/xstartup
```

Pega el siguiente contenido:

```bash
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
```

Guarda (Ctrl+O, Enter) y sal (Ctrl+X).

```bash
# Dar permisos de ejecución
chmod +x ~/.vnc/xstartup
```

### 8.5 Iniciar VNC Server

```bash
# Iniciar servidor VNC en display :1 con resolución 1920x1080
vncserver :1 -geometry 1920x1080 -depth 24
```

### 8.6 Salir y Hacer Commit

```bash
# Salir del contenedor
exit

# Hacer commit con el entorno gráfico
docker commit kali-custom-container kali-gui:v1
```

---

## 🖥️ Conectarse al Entorno Gráfico

### Opción 1: Usar VNC Viewer (Recomendado)

#### 1. Ejecutar Contenedor con Puerto VNC

```bash
docker run -it -p 5901:5901 --name kali-gui-container kali-gui:v1 /bin/bash
```

#### 2. Dentro del Contenedor, Iniciar VNC

```bash
su - tuusuario
vncserver :1 -geometry 1920x1080 -depth 24
```

#### 3. Descargar VNC Viewer en Windows

- Descarga: https://www.realvnc.com/en/connect/download/viewer/
- Instala VNC Viewer

#### 4. Conectarse

- Abre VNC Viewer
- Conecta a: `localhost:5901`
- Ingresa la contraseña VNC que configuraste
- ¡Disfruta tu Kali Linux con interfaz gráfica!

### Opción 2: Usar X Server (Alternativa)

#### 1. Instalar VcXsrv en Windows

- Descarga: https://sourceforge.net/projects/vcxsrv/
- Instala VcXsrv

#### 2. Ejecutar XLaunch

- Busca "XLaunch" en el menú de inicio
- Selecciona "Multiple windows"
- Display number: 0
- Start no client
- ✅ Marca "Disable access control"
- Finish

#### 3. Ejecutar Contenedor con Display

```bash
docker run -it -e DISPLAY=host.docker.internal:0 --name kali-x11 kali-gui:v1 /bin/bash
```

#### 4. Dentro del Contenedor

```bash
su - tuusuario
startxfce4 &
```

---

## 📝 Scripts Útiles

### Script para Iniciar Kali con GUI

Crea un archivo `start-kali-gui.bat` en Windows:

```batch
@echo off
echo Iniciando Kali Linux con GUI...
docker start kali-gui-container
docker exec -it kali-gui-container su - tuusuario -c "vncserver :1 -geometry 1920x1080 -depth 24"
echo.
echo Kali Linux iniciado!
echo Conecta con VNC Viewer a: localhost:5901
pause
```

### Script para Detener Kali

Crea un archivo `stop-kali-gui.bat`:

```batch
@echo off
echo Deteniendo Kali Linux...
docker exec -it kali-gui-container su - tuusuario -c "vncserver -kill :1"
docker stop kali-gui-container
echo Kali Linux detenido!
pause
```

---

## Solución de Problemas

### Problema: Docker no inicia

**Solución:**
- Verifica que WSL 2 esté instalado: `wsl --version`
- Reinicia Docker Desktop
- Verifica que la virtualización esté habilitada en BIOS

### Problema: Error al descargar imagen

**Solución:**
```bash
# Limpiar caché de Docker
docker system prune -a

# Intentar nuevamente
docker pull kalilinux/kali-rolling
```

### Problema: VNC no se conecta

**Solución:**
- Verifica que el puerto esté mapeado: `docker ps`
- Verifica que VNC esté corriendo: `docker exec kali-gui-container ps aux | grep vnc`
- Reinicia el servidor VNC dentro del contenedor

### Problema: Pantalla negra en VNC

**Solución:**
```bash
# Dentro del contenedor
vncserver -kill :1
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1
vncserver :1 -geometry 1920x1080 -depth 24
```

### Problema: Contenedor se detiene al cerrar terminal

**Solución:**
```bash
# Ejecutar en modo detached
docker run -d -p 5901:5901 --name kali-gui-container kali-gui:v1 tail -f /dev/null

# Luego conectarse
docker exec -it kali-gui-container /bin/bash
```

---

## 🎯 Comandos Rápidos de Referencia

```bash
# Ver contenedores corriendo
docker ps

# Ver todos los contenedores
docker ps -a

# Iniciar contenedor
docker start kali-gui-container

# Detener contenedor
docker stop kali-gui-container

# Conectarse a contenedor corriendo
docker exec -it kali-gui-container /bin/bash

# Ver logs del contenedor
docker logs kali-gui-container

# Eliminar contenedor
docker rm kali-gui-container

# Eliminar imagen
docker rmi kali-gui:v1

# Ver uso de recursos
docker stats
```

---

## 📚 Recursos Adicionales

- [Documentación oficial de Docker](https://docs.docker.com/)
- [Kali Linux Docker Hub](https://hub.docker.com/r/kalilinux/kali-rolling)
- [Documentación de Kali Linux](https://www.kali.org/docs/)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

---

## ✅ Checklist Final

- [ ] Docker Desktop instalado y corriendo
- [ ] WSL 2 actualizado
- [ ] Imagen kalilinux/kali-rolling descargada
- [ ] Contenedor de Kali ejecutándose
- [ ] Usuario sudo creado
- [ ] Cambios guardados con commit
- [ ] Entorno gráfico XFCE instalado
- [ ] VNC Server configurado
- [ ] Conexión VNC funcionando

---

¡Felicidades! Ahora tienes Kali Linux completamente funcional con entorno gráfico en Docker Desktop en Windows 11. 🎉

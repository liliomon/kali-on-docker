# 🔧 Solución de Problemas - Kali Linux en Docker

Guía completa para resolver los problemas más comunes al usar Kali Linux en Docker Desktop con Windows 11.

---

## 📋 Índice

1. [Problemas de Instalación](#problemas-de-instalación)
2. [Problemas con Docker Desktop](#problemas-con-docker-desktop)
3. [Problemas con WSL](#problemas-con-wsl)
4. [Problemas con VNC](#problemas-con-vnc)
5. [Problemas de Red](#problemas-de-red)
6. [Problemas de Rendimiento](#problemas-de-rendimiento)
7. [Problemas con Contenedores](#problemas-con-contenedores)
8. [Errores Comunes](#errores-comunes)

---

## Problemas de Instalación

### ❌ Error: "Virtualización no habilitada"

**Síntomas:**
- Docker Desktop no inicia
- Mensaje: "Hardware assisted virtualization and data execution protection must be enabled in the BIOS"

**Solución:**

1. Reinicia tu PC y entra al BIOS/UEFI (F2, F10, F12 o DEL)
2. Busca la opción de virtualización:
   - Intel: "Intel VT-x" o "Intel Virtualization Technology"
   - AMD: "AMD-V" o "SVM Mode"
3. Habilítala y guarda cambios
4. Reinicia Windows

**Verificar en Windows:**
```powershell
# Abrir Administrador de Tareas
# Ir a Rendimiento > CPU
# Verificar que "Virtualización" esté "Habilitada"
```

---

### ❌ Error: "WSL 2 installation is incomplete"

**Síntomas:**
- Docker Desktop no inicia correctamente
- Mensaje sobre WSL 2 incompleto

**Solución:**

```powershell
# Ejecutar como Administrador

# 1. Habilitar WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 2. Habilitar Plataforma de Máquina Virtual
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 3. Reiniciar
Restart-Computer

# 4. Después del reinicio, actualizar WSL
wsl --update

# 5. Establecer WSL 2 como predeterminado
wsl --set-default-version 2
```

---

### ❌ Error: "Docker Desktop requires Windows 10 Pro/Enterprise"

**Síntomas:**
- Instalación bloqueada en Windows 11 Home

**Solución:**

Windows 11 Home **SÍ soporta** Docker Desktop con WSL 2. Si ves este error:

1. Asegúrate de tener Windows 11 actualizado:
   ```powershell
   winver
   ```
   Debe ser versión 22000 o superior

2. Actualiza Windows:
   - Configuración > Windows Update > Buscar actualizaciones

3. Reinstala Docker Desktop con la opción WSL 2

---

## Problemas con Docker Desktop

### ❌ Docker Desktop no inicia

**Síntomas:**
- Ícono de Docker en la bandeja del sistema no aparece
- Aplicación se cierra inmediatamente

**Soluciones:**

**Solución 1: Reiniciar servicios de Docker**

```powershell
# Como Administrador
net stop com.docker.service
net start com.docker.service
```

**Solución 2: Limpiar datos de Docker**

```powershell
# ADVERTENCIA: Esto eliminará todos los contenedores e imágenes

# Cerrar Docker Desktop completamente
Stop-Process -Name "Docker Desktop" -Force

# Eliminar datos
Remove-Item -Recurse -Force "$env:APPDATA\Docker"
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Docker"

# Reiniciar Docker Desktop
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
```

**Solución 3: Reinstalar Docker Desktop**

1. Desinstalar Docker Desktop desde Panel de Control
2. Eliminar carpetas residuales:
   - `C:\Program Files\Docker`
   - `%APPDATA%\Docker`
   - `%LOCALAPPDATA%\Docker`
3. Reiniciar PC
4. Descargar e instalar la última versión

---

### ❌ Error: "Docker daemon is not running"

**Síntomas:**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

**Solución:**

```powershell
# Verificar estado de Docker
docker info

# Si falla, reiniciar Docker Desktop
# Clic derecho en ícono de Docker > Restart

# O desde PowerShell
Stop-Process -Name "Docker Desktop" -Force
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
```

---

### ❌ Docker Desktop consume mucha RAM

**Síntomas:**
- Sistema lento
- Docker usa más de 4GB de RAM

**Solución:**

Crear archivo `.wslconfig` en `C:\Users\TuUsuario\`:

```ini
[wsl2]
memory=4GB
processors=2
swap=2GB
```

Reiniciar WSL:
```powershell
wsl --shutdown
```

---

## Problemas con WSL

### ❌ Error: "WslRegisterDistribution failed with error: 0x80370102"

**Síntomas:**
- WSL no puede iniciar distribuciones

**Solución:**

```powershell
# Como Administrador

# Habilitar Plataforma de Máquina Virtual
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Reiniciar
Restart-Computer

# Después del reinicio
wsl --update
wsl --set-default-version 2
```

---

### ❌ WSL no responde o está lento

**Síntomas:**
- Comandos WSL tardan mucho
- Sistema congelado

**Solución:**

```powershell
# Detener todas las instancias WSL
wsl --shutdown

# Esperar 10 segundos y reiniciar Docker Desktop
```

---

### ❌ Error: "The attempted operation is not supported for the type of object referenced"

**Síntomas:**
- Error al iniciar WSL

**Solución:**

```powershell
# Como Administrador

# Desinstalar y reinstalar WSL
wsl --unregister Ubuntu  # Si tienes Ubuntu instalado
wsl --update
wsl --install
```

---

## Problemas con VNC

### ❌ VNC no se conecta

**Síntomas:**
- VNC Viewer no puede conectar a `localhost:5901`
- Error: "Connection refused"

**Solución 1: Verificar que VNC esté corriendo**

```bash
# Dentro del contenedor
ps aux | grep vnc

# Si no está corriendo, iniciarlo
vncserver :1 -geometry 1920x1080 -depth 24
```

**Solución 2: Verificar puerto mapeado**

```bash
# En Windows
docker ps

# Debe mostrar: 0.0.0.0:5901->5901/tcp
```

Si no está mapeado:
```bash
# Detener contenedor
docker stop kali-gui-container

# Eliminar contenedor
docker rm kali-gui-container

# Crear nuevo con puerto correcto
docker run -d -p 5901:5901 --name kali-gui-container kali-gui:v1
```

**Solución 3: Verificar firewall**

```powershell
# Como Administrador
# Agregar regla de firewall para puerto 5901
New-NetFirewallRule -DisplayName "VNC Server" -Direction Inbound -LocalPort 5901 -Protocol TCP -Action Allow
```

---

### ❌ Pantalla negra en VNC

**Síntomas:**
- VNC conecta pero muestra pantalla negra
- No aparece el escritorio XFCE

**Solución:**

```bash
# Dentro del contenedor

# 1. Detener VNC
vncserver -kill :1

# 2. Limpiar archivos de bloqueo
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 3. Verificar archivo xstartup
cat ~/.vnc/xstartup

# Debe contener:
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4

# 4. Si no es correcto, recrearlo
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF

chmod +x ~/.vnc/xstartup

# 5. Reiniciar VNC
vncserver :1 -geometry 1920x1080 -depth 24
```

---

### ❌ VNC se desconecta constantemente

**Síntomas:**
- Conexión VNC se cae cada pocos minutos

**Solución:**

```bash
# Dentro del contenedor

# Editar configuración VNC
nano ~/.vnc/config

# Agregar:
IdleTimeout=0
MaxIdleTime=0

# Guardar y reiniciar VNC
vncserver -kill :1
vncserver :1 -geometry 1920x1080 -depth 24
```

---

### ❌ Error: "Authentication failed"

**Síntomas:**
- VNC pide contraseña pero la rechaza

**Solución:**

```bash
# Dentro del contenedor

# Restablecer contraseña VNC
rm ~/.vnc/passwd
vncpasswd

# Ingresar nueva contraseña (mínimo 6 caracteres)
```

---

### ❌ Resolución incorrecta en VNC

**Síntomas:**
- Pantalla muy pequeña o muy grande

**Solución:**

```bash
# Detener VNC
vncserver -kill :1

# Iniciar con resolución específica
vncserver :1 -geometry 1920x1080 -depth 24

# Otras resoluciones comunes:
# 1280x720
# 1366x768
# 1600x900
# 2560x1440
```

---

## Problemas de Red

### ❌ No hay conexión a Internet en el contenedor

**Síntomas:**
```bash
apt update
# Error: Could not resolve 'deb.debian.org'
```

**Solución 1: Verificar DNS**

```bash
# Dentro del contenedor
cat /etc/resolv.conf

# Debe contener algo como:
nameserver 8.8.8.8
```

Si está vacío:
```bash
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf
```

**Solución 2: Reiniciar red de Docker**

```bash
# En Windows
docker network ls
docker network inspect bridge

# Reiniciar Docker Desktop
```

**Solución 3: Configurar DNS en Docker Desktop**

1. Abrir Docker Desktop
2. Settings > Docker Engine
3. Agregar:
```json
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}
```
4. Apply & Restart

---

### ❌ No se puede acceder a localhost desde el contenedor

**Síntomas:**
- No puedes acceder a servicios de Windows desde Kali

**Solución:**

Usa `host.docker.internal` en lugar de `localhost`:

```bash
# Ejemplo: acceder a servidor web en Windows
curl http://host.docker.internal:8080
```

---

## Problemas de Rendimiento

### ❌ Contenedor muy lento

**Síntomas:**
- Comandos tardan mucho
- GUI se congela

**Solución 1: Aumentar recursos**

Editar `.wslconfig` en `C:\Users\TuUsuario\`:

```ini
[wsl2]
memory=8GB
processors=4
swap=4GB
```

```powershell
wsl --shutdown
```

**Solución 2: Limpiar Docker**

```bash
# Eliminar contenedores detenidos
docker container prune

# Eliminar imágenes sin usar
docker image prune

# Limpiar todo
docker system prune -a
```

**Solución 3: Optimizar disco**

```powershell
# Como Administrador

# Ubicar disco virtual WSL
# Generalmente en: C:\Users\TuUsuario\AppData\Local\Docker\wsl\data\ext4.vhdx

# Detener WSL
wsl --shutdown

# Optimizar disco (reemplaza la ruta)
Optimize-VHD -Path "C:\Users\TuUsuario\AppData\Local\Docker\wsl\data\ext4.vhdx" -Mode Full
```

---

### ❌ Alto uso de CPU

**Síntomas:**
- Ventilador a máxima velocidad
- CPU al 100%

**Solución:**

```bash
# Ver procesos que consumen CPU
docker stats

# Dentro del contenedor
top

# Matar proceso problemático
kill -9 PID
```

---

## Problemas con Contenedores

### ❌ Error: "Container already exists"

**Síntomas:**
```
Error response from daemon: Conflict. The container name "/kali-gui-container" is already in use
```

**Solución:**

```bash
# Ver contenedores existentes
docker ps -a

# Eliminar contenedor existente
docker rm kali-gui-container

# O forzar eliminación si está corriendo
docker rm -f kali-gui-container

# Crear nuevo contenedor
docker run -d -p 5901:5901 --name kali-gui-container kali-gui:v1
```

---

### ❌ Contenedor se detiene inmediatamente

**Síntomas:**
- Contenedor inicia pero se detiene al instante

**Solución:**

```bash
# Ver logs del contenedor
docker logs kali-gui-container

# Ejecutar con comando que mantiene vivo el contenedor
docker run -d --name kali-gui-container kali-gui:v1 tail -f /dev/null

# O usar docker-compose con restart policy
```

---

### ❌ Error: "No space left on device"

**Síntomas:**
```
Error: No space left on device
```

**Solución:**

```bash
# Ver uso de espacio
docker system df

# Limpiar imágenes sin usar
docker image prune -a

# Limpiar todo
docker system prune -a --volumes

# Verificar espacio en disco de Windows
```

---

### ❌ Cambios se pierden al reiniciar contenedor

**Síntomas:**
- Archivos creados desaparecen
- Configuraciones se resetean

**Solución:**

```bash
# Hacer commit de cambios
docker commit kali-gui-container kali-custom:v1

# Usar la nueva imagen
docker run -d -p 5901:5901 --name kali-new kali-custom:v1

# O usar volúmenes para persistencia
docker run -d -p 5901:5901 -v kali-data:/home/kaliuser --name kali-persistent kali-gui:v1
```

---

## Errores Comunes

### ❌ Error: "permission denied"

**Solución:**

```bash
# Dentro del contenedor, usar sudo
sudo comando

# O cambiar permisos
sudo chmod +x archivo
sudo chown usuario:usuario archivo
```

---

### ❌ Error: "command not found"

**Solución:**

```bash
# Actualizar e instalar paquete
sudo apt update
sudo apt install nombre-paquete

# Verificar PATH
echo $PATH

# Buscar comando
which comando
whereis comando
```

---

### ❌ Error: "Unable to locate package"

**Solución:**

```bash
# Actualizar repositorios
sudo apt update

# Si persiste, agregar repositorios de Kali
echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" | sudo tee /etc/apt/sources.list
sudo apt update
```

---

### ❌ Error: "E: Could not get lock /var/lib/dpkg/lock"

**Solución:**

```bash
# Esperar a que termine otro proceso apt
# O forzar eliminación de lock
sudo rm /var/lib/dpkg/lock
sudo rm /var/lib/dpkg/lock-frontend
sudo dpkg --configure -a
sudo apt update
```

---

## 🆘 Solución de Último Recurso

Si nada funciona:

### Resetear Todo

```powershell
# Como Administrador

# 1. Detener Docker
Stop-Process -Name "Docker Desktop" -Force

# 2. Detener WSL
wsl --shutdown

# 3. Limpiar Docker
docker system prune -a --volumes

# 4. Reiniciar servicios
net stop com.docker.service
net start com.docker.service

# 5. Reiniciar Docker Desktop
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# 6. Reiniciar PC
Restart-Computer
```

---

## 📞 Obtener Ayuda

Si el problema persiste:

1. **Ver logs de Docker:**
   ```bash
   docker logs kali-gui-container
   ```

2. **Ver logs de Docker Desktop:**
   - Clic derecho en ícono de Docker
   - Troubleshoot > Get Support
   - View Logs

3. **Información del sistema:**
   ```powershell
   docker version
   docker info
   wsl --version
   systeminfo
   ```

4. **Comunidad:**
   - [Docker Forums](https://forums.docker.com/)
   - [Kali Linux Forums](https://forums.kali.org/)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/docker)

---

## ✅ Checklist de Diagnóstico

Antes de buscar ayuda, verifica:

- [ ] Virtualización habilitada en BIOS
- [ ] WSL 2 instalado y actualizado
- [ ] Docker Desktop corriendo
- [ ] Contenedor iniciado: `docker ps`
- [ ] Puertos mapeados correctamente
- [ ] VNC server corriendo en contenedor
- [ ] Firewall no bloquea puerto 5901
- [ ] Suficiente espacio en disco
- [ ] Suficiente RAM disponible

---

**¡La mayoría de problemas se resuelven con un simple reinicio de Docker Desktop o WSL!** 🔄

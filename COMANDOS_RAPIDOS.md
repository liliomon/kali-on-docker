# 🚀 Comandos Rápidos - Kali Linux en Docker

Referencia rápida de comandos más utilizados para trabajar con Kali Linux en Docker.

---

## 📋 Índice

1. [Instalación Inicial](#instalación-inicial)
2. [Gestión de Contenedores](#gestión-de-contenedores)
3. [Servidor VNC](#servidor-vnc)
4. [Gestión de Usuarios](#gestión-de-usuarios)
5. [Actualización y Paquetes](#actualización-y-paquetes)
6. [Docker Compose](#docker-compose)
7. [Troubleshooting](#troubleshooting)

---

## Instalación Inicial

### Habilitar WSL y Virtualización (PowerShell como Admin)

```powershell
# Habilitar WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Habilitar Plataforma de Máquina Virtual
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Actualizar WSL
wsl --update

# Establecer WSL 2 como predeterminado
wsl --set-default-version 2

# Reiniciar
Restart-Computer
```

### Descargar Kali Linux

```bash
# Descargar imagen oficial
docker pull kalilinux/kali-rolling

# Verificar descarga
docker images
```

---

## Gestión de Contenedores

### Crear y Ejecutar

```bash
# Ejecutar Kali interactivo (temporal)
docker run --rm -it kalilinux/kali-rolling /bin/bash

# Crear contenedor con nombre
docker run -it --name kali-container kalilinux/kali-rolling /bin/bash

# Crear con puerto VNC mapeado
docker run -d -p 5901:5901 --name kali-gui-container kali-gui:v1

# Ejecutar en segundo plano
docker run -d --name kali-bg kali-gui:v1 tail -f /dev/null
```

### Iniciar/Detener/Reiniciar

```bash
# Iniciar contenedor detenido
docker start kali-gui-container

# Detener contenedor
docker stop kali-gui-container

# Reiniciar contenedor
docker restart kali-gui-container

# Pausar contenedor
docker pause kali-gui-container

# Reanudar contenedor pausado
docker unpause kali-gui-container
```

### Conectar a Contenedor

```bash
# Conectar a contenedor corriendo
docker exec -it kali-gui-container /bin/bash

# Conectar como usuario específico
docker exec -it -u kaliuser kali-gui-container /bin/bash

# Ejecutar comando sin entrar
docker exec kali-gui-container ls -la /home
```

### Ver Información

```bash
# Listar contenedores corriendo
docker ps

# Listar todos los contenedores
docker ps -a

# Ver logs del contenedor
docker logs kali-gui-container

# Ver logs en tiempo real
docker logs -f kali-gui-container

# Ver estadísticas de recursos
docker stats kali-gui-container

# Inspeccionar contenedor
docker inspect kali-gui-container

# Ver procesos en contenedor
docker top kali-gui-container
```

### Eliminar Contenedores

```bash
# Eliminar contenedor detenido
docker rm kali-gui-container

# Forzar eliminación de contenedor corriendo
docker rm -f kali-gui-container

# Eliminar todos los contenedores detenidos
docker container prune

# Eliminar todos los contenedores (¡CUIDADO!)
docker rm -f $(docker ps -aq)
```

---

## Servidor VNC

### Iniciar VNC

```bash
# Dentro del contenedor
vncserver :1 -geometry 1920x1080 -depth 24

# Otras resoluciones comunes
vncserver :1 -geometry 1280x720 -depth 24
vncserver :1 -geometry 1366x768 -depth 24
vncserver :1 -geometry 2560x1440 -depth 24

# Con localhost deshabilitado (acceso remoto)
vncserver :1 -geometry 1920x1080 -depth 24 -localhost no
```

### Detener VNC

```bash
# Detener display :1
vncserver -kill :1

# Detener todos los displays
vncserver -kill :*
```

### Configurar VNC

```bash
# Establecer contraseña VNC
vncpasswd

# Ver contraseña actual (encriptada)
cat ~/.vnc/passwd

# Editar configuración de inicio
nano ~/.vnc/xstartup
```

### Reiniciar VNC (Solución de Problemas)

```bash
# Detener VNC
vncserver -kill :1

# Limpiar archivos de bloqueo
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# Reiniciar VNC
vncserver :1 -geometry 1920x1080 -depth 24
```

### Desde Windows (fuera del contenedor)

```bash
# Iniciar VNC en contenedor
docker exec kali-gui-container su - kaliuser -c "vncserver :1 -geometry 1920x1080 -depth 24"

# Detener VNC en contenedor
docker exec kali-gui-container su - kaliuser -c "vncserver -kill :1"

# Reiniciar VNC
docker exec kali-gui-container su - kaliuser -c "vncserver -kill :1 && vncserver :1 -geometry 1920x1080 -depth 24"
```

---

## Gestión de Usuarios

### Crear Usuario

```bash
# Crear usuario con directorio home
useradd -m -s /bin/bash nombre_usuario

# Establecer contraseña
passwd nombre_usuario

# Crear usuario con UID específico
useradd -m -u 1001 -s /bin/bash nombre_usuario
```

### Agregar a Sudo

```bash
# Agregar al grupo sudo
usermod -aG sudo nombre_usuario

# Verificar grupos
groups nombre_usuario

# Sudo sin contraseña
echo "nombre_usuario ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nombre_usuario
chmod 0440 /etc/sudoers.d/nombre_usuario
```

### Cambiar Usuario

```bash
# Cambiar a otro usuario
su - nombre_usuario

# Cambiar a root
su -

# Ejecutar comando como otro usuario
su - nombre_usuario -c "comando"
```

### Modificar Usuario

```bash
# Cambiar shell
usermod -s /bin/zsh nombre_usuario

# Cambiar directorio home
usermod -d /home/nuevo_home nombre_usuario

# Cambiar nombre de usuario
usermod -l nuevo_nombre viejo_nombre

# Bloquear usuario
usermod -L nombre_usuario

# Desbloquear usuario
usermod -U nombre_usuario
```

### Eliminar Usuario

```bash
# Eliminar usuario (mantener home)
userdel nombre_usuario

# Eliminar usuario y su home
userdel -r nombre_usuario
```

---

## Actualización y Paquetes

### Actualizar Sistema

```bash
# Actualizar lista de paquetes
apt update

# Actualizar paquetes instalados
apt upgrade -y

# Actualización completa (incluye dependencias)
apt full-upgrade -y

# Actualizar todo (update + upgrade)
apt update && apt upgrade -y
```

### Instalar Paquetes

```bash
# Instalar paquete
apt install nombre_paquete

# Instalar múltiples paquetes
apt install paquete1 paquete2 paquete3

# Instalar sin confirmación
apt install -y nombre_paquete

# Reinstalar paquete
apt install --reinstall nombre_paquete
```

### Buscar y Ver Paquetes

```bash
# Buscar paquete
apt search nombre_paquete

# Ver información de paquete
apt show nombre_paquete

# Listar paquetes instalados
apt list --installed

# Ver archivos de un paquete
dpkg -L nombre_paquete
```

### Eliminar Paquetes

```bash
# Eliminar paquete
apt remove nombre_paquete

# Eliminar paquete y configuración
apt purge nombre_paquete

# Eliminar dependencias no usadas
apt autoremove

# Limpiar caché de paquetes
apt clean
apt autoclean
```

### Herramientas de Kali Comunes

```bash
# Instalar metasploit
apt install -y metasploit-framework

# Instalar herramientas de red
apt install -y nmap wireshark tcpdump netcat

# Instalar herramientas web
apt install -y burpsuite sqlmap nikto

# Instalar herramientas de password
apt install -y john hydra hashcat

# Instalar todas las herramientas de Kali (¡GRANDE!)
apt install -y kali-linux-large
```

---

## Docker Compose

### Comandos Básicos

```bash
# Iniciar servicios
docker-compose up

# Iniciar en segundo plano
docker-compose up -d

# Construir y iniciar
docker-compose up --build

# Detener servicios
docker-compose down

# Detener y eliminar volúmenes
docker-compose down -v
```

### Ver Estado

```bash
# Ver servicios corriendo
docker-compose ps

# Ver logs
docker-compose logs

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de servicio específico
docker-compose logs kali-gui
```

### Ejecutar Comandos

```bash
# Ejecutar comando en servicio
docker-compose exec kali-gui bash

# Ejecutar como usuario específico
docker-compose exec -u kaliuser kali-gui bash

# Ejecutar comando sin entrar
docker-compose exec kali-gui ls -la
```

### Gestión de Servicios

```bash
# Reiniciar servicios
docker-compose restart

# Reiniciar servicio específico
docker-compose restart kali-gui

# Pausar servicios
docker-compose pause

# Reanudar servicios
docker-compose unpause

# Detener servicios sin eliminar
docker-compose stop

# Iniciar servicios detenidos
docker-compose start
```

### Construcción

```bash
# Construir imágenes
docker-compose build

# Construir sin caché
docker-compose build --no-cache

# Construir servicio específico
docker-compose build kali-gui

# Forzar reconstrucción
docker-compose up --build --force-recreate
```

---

## Troubleshooting

### Limpiar Docker

```bash
# Eliminar contenedores detenidos
docker container prune

# Eliminar imágenes sin usar
docker image prune

# Eliminar volúmenes sin usar
docker volume prune

# Eliminar redes sin usar
docker network prune

# Limpiar todo (¡CUIDADO!)
docker system prune -a

# Limpiar todo incluyendo volúmenes
docker system prune -a --volumes
```

### Ver Uso de Espacio

```bash
# Ver uso de disco de Docker
docker system df

# Ver uso detallado
docker system df -v
```

### Problemas de Red

```bash
# Listar redes
docker network ls

# Inspeccionar red
docker network inspect bridge

# Crear red personalizada
docker network create mi-red

# Conectar contenedor a red
docker network connect mi-red kali-gui-container

# Desconectar de red
docker network disconnect mi-red kali-gui-container
```

### Problemas de Permisos

```bash
# Dentro del contenedor, cambiar propietario
chown -R kaliuser:kaliuser /home/kaliuser

# Cambiar permisos
chmod 755 /home/kaliuser

# Arreglar permisos VNC
chmod 600 ~/.vnc/passwd
chmod +x ~/.vnc/xstartup
```

### Reiniciar Docker Desktop

```powershell
# En PowerShell (Windows)
# Detener Docker Desktop
Stop-Process -Name "Docker Desktop" -Force

# Iniciar Docker Desktop
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
```

### Exportar/Importar Contenedores

```bash
# Exportar contenedor a archivo tar
docker export kali-gui-container > kali-backup.tar

# Importar desde archivo tar
docker import kali-backup.tar kali-restored:latest

# Guardar imagen
docker save kali-gui:v1 > kali-image.tar

# Cargar imagen
docker load < kali-image.tar
```

### Commit de Cambios

```bash
# Guardar cambios del contenedor como nueva imagen
docker commit kali-gui-container kali-custom:v1

# Con mensaje y autor
docker commit -m "Agregado entorno gráfico" -a "Tu Nombre" kali-gui-container kali-custom:v1

# Ver historial de imagen
docker history kali-custom:v1
```

---

## 🔗 Conexiones Útiles

### VNC Viewer
- **Dirección:** `localhost:5901`
- **Contraseña por defecto:** `kali123`

### Puertos Comunes
- **5901:** VNC Server
- **22:** SSH (si está configurado)
- **80:** HTTP (si hay servidor web)
- **443:** HTTPS

---

## 📝 Notas Importantes

1. **Siempre actualiza** antes de instalar nuevos paquetes:
   ```bash
   apt update && apt upgrade -y
   ```

2. **Guarda cambios importantes** con commit:
   ```bash
   docker commit contenedor imagen:tag
   ```

3. **Usa volúmenes** para datos persistentes:
   ```bash
   docker run -v /ruta/host:/ruta/contenedor imagen
   ```

4. **Limpia regularmente** para liberar espacio:
   ```bash
   docker system prune
   ```

---

**¡Guarda este archivo como referencia rápida!** 📌

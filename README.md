# 🐉 Kali Linux en Docker Desktop - Windows 11

Proyecto completo para ejecutar Kali Linux con entorno gráfico XFCE en Docker Desktop sobre Windows 11.

## 📁 Estructura del Proyecto

```
kali-on-docker/
├── GUIA_INSTALACION_KALI_DOCKER.md  # Guía completa paso a paso
├── Dockerfile                        # Imagen personalizada de Kali
├── docker-compose.yml                # Configuración Docker Compose
├── docker-entrypoint.sh              # Script de inicio del contenedor
├── README.md                         # Este archivo
└── scripts/
    ├── start-kali-gui.bat           # Iniciar Kali con GUI
    ├── stop-kali-gui.bat            # Detener Kali
    ├── connect-kali-terminal.bat    # Conectar a terminal
    └── restart-vnc.bat              # Reiniciar servidor VNC
```

## 🚀 Inicio Rápido

### Opción 1: Usar Imagen Pre-construida (Método Manual)

Sigue la guía completa en: **[GUIA_INSTALACION_KALI_DOCKER.md](GUIA_INSTALACION_KALI_DOCKER.md)**

### Opción 2: Usar Docker Compose (Método Automatizado)

#### Requisitos Previos
- Docker Desktop instalado y corriendo
- WSL 2 actualizado

#### Pasos

1. **Construir y ejecutar el contenedor:**

```bash
docker-compose up -d --build
```

2. **Verificar que está corriendo:**

```bash
docker-compose ps
```

3. **Conectar con VNC Viewer:**
   - Dirección: `localhost:5901`
   - Contraseña por defecto: `kali123`

4. **Conectar a la terminal:**

```bash
docker-compose exec kali-gui /bin/bash
```

5. **Detener el contenedor:**

```bash
docker-compose down
```

## 🖥️ Uso de Scripts de Windows

### Iniciar Kali Linux con GUI

```cmd
scripts\start-kali-gui.bat
```

### Detener Kali Linux

```cmd
scripts\stop-kali-gui.bat
```

### Conectar a Terminal

```cmd
scripts\connect-kali-terminal.bat
```

### Reiniciar Servidor VNC

```cmd
scripts\restart-vnc.bat
```

## 🔧 Configuración

### Usuario por Defecto

- **Usuario:** `kaliuser`
- **Contraseña VNC:** `kali123` (cambiar con `vncpasswd`)
- **Privilegios:** sudo sin contraseña

### Puertos Expuestos

- **5901:** Servidor VNC

### Resolución de Pantalla

Por defecto: **1920x1080**

Para cambiar, edita el archivo `docker-entrypoint.sh`:

```bash
vncserver :1 -geometry 1280x720 -depth 24 -localhost no
```

## 📦 Personalización del Dockerfile

### Cambiar Nombre de Usuario

Edita `docker-compose.yml`:

```yaml
args:
  USERNAME: tu_usuario
  USER_UID: 1000
  USER_GID: 1000
```

### Instalar Herramientas Adicionales

Edita el `Dockerfile` y agrega:

```dockerfile
RUN apt-get update && \
    apt-get install -y \
    metasploit-framework \
    nmap \
    wireshark \
    burpsuite \
    && apt-get clean
```

## 🔍 Comandos Útiles

### Docker Compose

```bash
# Iniciar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose down

# Reconstruir imagen
docker-compose build --no-cache

# Ejecutar comando en contenedor
docker-compose exec kali-gui bash
```

### Docker Directo

```bash
# Construir imagen
docker build -t kali-gui:latest .

# Ejecutar contenedor
docker run -d -p 5901:5901 --name kali-gui-container kali-gui:latest

# Ver contenedores corriendo
docker ps

# Conectar a contenedor
docker exec -it kali-gui-container bash

# Ver logs
docker logs kali-gui-container

# Detener contenedor
docker stop kali-gui-container

# Eliminar contenedor
docker rm kali-gui-container
```

## 🛠️ Solución de Problemas

### VNC no se conecta

```bash
# Reiniciar servidor VNC
docker exec kali-gui-container su - kaliuser -c "vncserver -kill :1"
docker exec kali-gui-container su - kaliuser -c "vncserver :1 -geometry 1920x1080 -depth 24"
```

### Pantalla negra en VNC

```bash
# Limpiar archivos de bloqueo
docker exec kali-gui-container rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1
docker restart kali-gui-container
```

### Contenedor no inicia

```bash
# Ver logs de error
docker logs kali-gui-container

# Reconstruir imagen
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 📚 Recursos

- [Guía Completa de Instalación](GUIA_INSTALACION_KALI_DOCKER.md)
- [Documentación de Docker](https://docs.docker.com/)
- [Kali Linux Docker Hub](https://hub.docker.com/r/kalilinux/kali-rolling)
- [Documentación de Kali Linux](https://www.kali.org/docs/)

## 🔐 Seguridad

### Cambiar Contraseña VNC

Dentro del contenedor:

```bash
vncpasswd
```

### Cambiar Contraseña de Usuario

```bash
sudo passwd kaliuser
```

### Deshabilitar Sudo sin Contraseña

```bash
sudo rm /etc/sudoers.d/kaliuser
```

## 📝 Notas

- El contenedor usa **WSL 2** como backend
- Los datos se persisten en volúmenes Docker
- El servidor VNC escucha en todas las interfaces (`-localhost no`)
- Para producción, considera usar autenticación adicional

## 🤝 Contribuciones

Si encuentras algún problema o tienes sugerencias, siéntete libre de:
1. Reportar issues
2. Proponer mejoras
3. Compartir tu configuración

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

---


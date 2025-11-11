# 🐉 Kali Linux con Interfaz Gráfica - Docker Compose

Guía rápida para levantar Kali Linux con interfaz gráfica XFCE usando Docker Compose.

---

## 📋 Requisitos Previos

- Docker Desktop instalado y corriendo
- Mínimo 8GB RAM (recomendado 16GB)
- 20GB espacio libre en disco
- Conexión a Internet

---

## 🚀 Inicio Rápido

### 1. Clonar o Descargar el Proyecto

```bash
# Si tienes el repositorio
git clone <url-repositorio>
cd kali-on-docker

# O simplemente descarga el archivo docker-compose-team.yml
```

### 2. Crear Directorios de Datos (Opcional)

```bash
# Crear directorios para persistencia local
mkdir -p data/home data/root data/tools
```

### 3. Iniciar Kali Linux

```bash
# Usar el archivo docker-compose-team.yml
docker-compose -f docker-compose-team.yml up -d

# O renombrar a docker-compose.yml y usar:
docker-compose up -d
```

**⏱️ Primera vez:** La instalación toma 5-10 minutos (descarga imagen, instala paquetes, configura GUI).

### 4. Ver Progreso de Instalación

```bash
# Ver logs en tiempo real
docker-compose -f docker-compose-team.yml logs -f

# Espera hasta ver: "=== Instalación completada ==="
```

### 5. Conectar con RDP

**Desde el mismo equipo:**
- Host: `localhost`
- Puerto: `3390`
- Usuario: `kaliuser`
- Contraseña: `kali123`

**Desde otro equipo en la red:**
- Host: `IP_DEL_SERVIDOR` (ejemplo: 192.168.1.50)
- Puerto: `3390`
- Usuario: `kaliuser`
- Contraseña: `kali123`

---

## 🖥️ Clientes RDP Recomendados

### Windows
- **Remote Desktop Connection** (mstsc) - Incluido en Windows
- **MobaXterm** - https://mobaxterm.mobatek.net/download.html

### Linux
- **Remmina** - `sudo apt install remmina`
- **FreeRDP** - `xfreerdp /v:IP:3390 /u:kaliuser`

### macOS
- **Microsoft Remote Desktop** - App Store

### Android/iOS
- **Microsoft Remote Desktop** - Play Store / App Store

---

## 📝 Comandos Útiles

### Gestión del Contenedor

```bash
# Iniciar
docker-compose -f docker-compose-team.yml up -d

# Detener (mantiene datos)
docker-compose -f docker-compose-team.yml stop

# Reiniciar
docker-compose -f docker-compose-team.yml restart

# Ver estado
docker-compose -f docker-compose-team.yml ps

# Ver logs
docker-compose -f docker-compose-team.yml logs -f

# Detener y eliminar (mantiene volúmenes)
docker-compose -f docker-compose-team.yml down

# Eliminar TODO incluyendo datos
docker-compose -f docker-compose-team.yml down -v
```

### Acceder a la Terminal

```bash
# Como usuario kaliuser
docker-compose -f docker-compose-team.yml exec -u kaliuser kali-linux bash

# Como root
docker-compose -f docker-compose-team.yml exec kali-linux bash
```

### Ejecutar Comandos

```bash
# Actualizar sistema
docker-compose -f docker-compose-team.yml exec kali-linux apt update

# Instalar herramientas
docker-compose -f docker-compose-team.yml exec kali-linux apt install -y nmap metasploit-framework

# Ver procesos
docker-compose -f docker-compose-team.yml exec kali-linux ps aux
```

---

## 🔐 Seguridad

### Cambiar Contraseña (IMPORTANTE)

```bash
# Cambiar contraseña del usuario kaliuser
docker-compose -f docker-compose-team.yml exec kali-linux passwd kaliuser

# O desde dentro del contenedor después de conectar por RDP
passwd
```

### Configurar Firewall (Acceso Remoto)

**Windows (PowerShell como Admin):**
```powershell
# Permitir puerto 3390
New-NetFirewallRule -DisplayName "Kali RDP" -Direction Inbound -LocalPort 3390 -Protocol TCP -Action Allow

# Limitar a IP específica (más seguro)
New-NetFirewallRule -DisplayName "Kali RDP Restricted" -Direction Inbound -LocalPort 3390 -Protocol TCP -Action Allow -RemoteAddress 192.168.1.100
```

**Linux (ufw):**
```bash
# Permitir puerto 3390
sudo ufw allow 3390/tcp

# Limitar a IP específica
sudo ufw allow from 192.168.1.100 to any port 3390
```

---

## 🛠️ Personalización

### Cambiar Puerto

Edita `docker-compose-team.yml`:

```yaml
ports:
  - "3391:3390"  # Usar puerto 3391 en lugar de 3390
```

### Cambiar Usuario y Contraseña

Edita la sección `command` en `docker-compose-team.yml`:

```yaml
useradd -m -s /bin/bash miusuario &&
echo 'miusuario:mipassword' | chpasswd &&
```

### Limitar Recursos

Edita la sección `deploy` en `docker-compose-team.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '2'      # Máximo 2 CPUs
      memory: 4G     # Máximo 4GB RAM
```

### Agregar Carpeta Compartida

Edita la sección `volumes` en `docker-compose-team.yml`:

```yaml
volumes:
  - ./compartido:/compartido  # Carpeta compartida con el host
```

---

## 🔧 Solución de Problemas

### Error: "port is already allocated"

```bash
# Ver qué contenedor usa el puerto
docker ps -a | grep 3390

# Detener y eliminar el contenedor
docker stop NOMBRE_CONTENEDOR
docker rm NOMBRE_CONTENEDOR

# Reiniciar
docker-compose -f docker-compose-team.yml up -d
```

### Error: "Connection refused"

```bash
# Verificar que XRDP está corriendo
docker-compose -f docker-compose-team.yml exec kali-linux ps aux | grep xrdp

# Reiniciar servicios XRDP
docker-compose -f docker-compose-team.yml exec kali-linux bash -c "
  pkill xrdp
  pkill xrdp-sesman
  /usr/sbin/xrdp-sesman
  sleep 2
  /usr/sbin/xrdp
"
```

### Pantalla Negra al Conectar

```bash
# Verificar configuración XFCE
docker-compose -f docker-compose-team.yml exec -u kaliuser kali-linux cat ~/.xsession

# Debe mostrar: startxfce4

# Si no existe, recrear
docker-compose -f docker-compose-team.yml exec -u kaliuser kali-linux bash -c "
  echo 'startxfce4' > ~/.xsession
  chmod +x ~/.xsession
"

# Reiniciar contenedor
docker-compose -f docker-compose-team.yml restart
```

### Contenedor No Inicia

```bash
# Ver logs de error
docker-compose -f docker-compose-team.yml logs

# Reconstruir desde cero
docker-compose -f docker-compose-team.yml down -v
docker-compose -f docker-compose-team.yml up -d
```

---

## 📦 Instalar Herramientas de Pentesting

### Herramientas Básicas

```bash
# Conectar al contenedor
docker-compose -f docker-compose-team.yml exec -u kaliuser kali-linux bash

# Actualizar
sudo apt update

# Instalar herramientas comunes
sudo apt install -y nmap metasploit-framework wpscan hydra john burpsuite nikto sqlmap wireshark
```

### Metapaquetes de Kali

```bash
# Top 10 herramientas
sudo apt install -y kali-tools-top10

# Herramientas web
sudo apt install -y kali-tools-web

# Herramientas de passwords
sudo apt install -y kali-tools-passwords

# Todas las herramientas (¡GRANDE! ~15GB)
sudo apt install -y kali-linux-large
```

### Wordlists

```bash
# Instalar wordlists
sudo apt install -y wordlists

# Descomprimir rockyou.txt
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
```

---

## 🌐 Acceso Remoto desde Internet

### 1. Configurar Port Forwarding en el Router

- Puerto externo: `3390`
- Puerto interno: `3390`
- IP interna: `192.168.1.X` (IP del servidor)

### 2. Obtener IP Pública

```bash
# Desde el servidor
curl ifconfig.me
```

### 3. Conectar desde Internet

- Host: `TU_IP_PUBLICA`
- Puerto: `3390`
- Usuario: `kaliuser`
- Contraseña: `kali123`

**⚠️ IMPORTANTE:** Cambia la contraseña antes de exponer a Internet.

---

## 📊 Monitoreo

### Ver Uso de Recursos

```bash
# Estadísticas en tiempo real
docker stats kali-linux-gui

# Uso de disco
docker system df
```

### Ver Usuarios Conectados

```bash
# Ver quién está conectado
docker-compose -f docker-compose-team.yml exec kali-linux who

# Ver sesiones activas
docker-compose -f docker-compose-team.yml exec kali-linux w
```

---

## 🔄 Actualización

### Actualizar Sistema Operativo

```bash
# Dentro del contenedor
sudo apt update && sudo apt upgrade -y
```

### Actualizar Imagen Base

```bash
# Detener contenedor
docker-compose -f docker-compose-team.yml down

# Descargar nueva imagen
docker pull kalilinux/kali-rolling

# Reiniciar
docker-compose -f docker-compose-team.yml up -d
```

---

## 💾 Backup y Restauración

### Hacer Backup

```bash
# Backup de volúmenes
docker run --rm -v kali-home:/data -v $(pwd):/backup alpine tar czf /backup/kali-home-backup.tar.gz /data

# Backup del contenedor completo
docker commit kali-linux-gui kali-backup:$(date +%Y%m%d)
docker save kali-backup:$(date +%Y%m%d) | gzip > kali-backup-$(date +%Y%m%d).tar.gz
```

### Restaurar Backup

```bash
# Restaurar imagen
docker load < kali-backup-20241106.tar.gz

# Usar imagen restaurada
docker run -d -p 3390:3390 --name kali-restored kali-backup:20241106
```

---

## 📚 Recursos Adicionales

- [Documentación de Kali Linux](https://www.kali.org/docs/)
- [Kali Docker Hub](https://hub.docker.com/r/kalilinux/kali-rolling)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [XRDP Documentation](http://xrdp.org/)

---

## ✅ Checklist de Instalación

- [ ] Docker Desktop instalado y corriendo
- [ ] Archivo `docker-compose-team.yml` descargado
- [ ] Ejecutado `docker-compose up -d`
- [ ] Esperado 5-10 minutos para instalación
- [ ] Verificado logs: `docker-compose logs -f`
- [ ] Conectado con RDP a `localhost:3390`
- [ ] Cambiado contraseña por seguridad
- [ ] Configurado firewall si es acceso remoto

---

## 🆘 Soporte

Si tienes problemas:

1. Revisa los logs: `docker-compose -f docker-compose-team.yml logs -f`
2. Verifica el estado: `docker-compose -f docker-compose-team.yml ps`
3. Consulta la sección "Solución de Problemas"
4. Reinicia el contenedor: `docker-compose -f docker-compose-team.yml restart`

---

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

---

**¡Disfruta tu Kali Linux con interfaz gráfica en Docker!** 🎉

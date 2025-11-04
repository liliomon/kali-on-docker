# 📋 Resumen Ejecutivo - Kali Linux en Docker

Guía rápida de 5 minutos para poner en marcha Kali Linux con entorno gráfico en Windows 11.

---

## 🎯 Objetivo

Ejecutar Kali Linux con interfaz gráfica XFCE en Docker Desktop sobre Windows 11, sin usar root y con persistencia de datos.

---

## ⚡ Instalación Rápida (Método Automatizado)

### Paso 1: Requisitos Previos (5 minutos)

```powershell
# Ejecutar PowerShell como Administrador

# Habilitar WSL y Virtualización
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Reiniciar PC
Restart-Computer
```

Después del reinicio:

```powershell
# Actualizar WSL
wsl --update
wsl --set-default-version 2
```

### Paso 2: Instalar Docker Desktop (10 minutos)

1. Descargar: https://www.docker.com/products/docker-desktop/
2. Instalar con opción "Use WSL 2"
3. Reiniciar PC
4. Verificar: `docker --version`

### Paso 3: Ejecutar Kali (2 minutos)

**Opción A: Con Docker Compose (Recomendado)**

```bash
# En el directorio del proyecto
docker-compose up -d --build
```

**Opción B: Con Scripts de Windows**

```cmd
# Doble clic en:
scripts\docker-compose-up.bat
```

### Paso 4: Conectar (1 minuto)

1. Descargar VNC Viewer: https://www.realvnc.com/en/connect/download/viewer/
2. Conectar a: `localhost:5901`
3. Contraseña: `kali123`

**¡Listo! Ya tienes Kali Linux corriendo con GUI** 🎉

---

## 📊 Comparación de Métodos

| Método | Tiempo | Dificultad | Personalización | Recomendado Para |
|--------|--------|------------|-----------------|------------------|
| **Docker Compose** | 15 min | Fácil | Media | Principiantes |
| **Manual con Scripts** | 30 min | Media | Alta | Usuarios intermedios |
| **Manual Completo** | 60 min | Alta | Muy Alta | Usuarios avanzados |

---

## 🗂️ Estructura del Proyecto

```
kali-on-docker/
├── 📄 GUIA_INSTALACION_KALI_DOCKER.md  ← Guía completa paso a paso
├── 📄 README.md                         ← Documentación principal
├── 📄 COMANDOS_RAPIDOS.md               ← Referencia de comandos
├── 📄 TROUBLESHOOTING.md                ← Solución de problemas
├── 📄 RESUMEN_EJECUTIVO.md              ← Este archivo
├── 🐳 Dockerfile                        ← Imagen personalizada
├── 🐳 docker-compose.yml                ← Configuración automatizada
├── 📜 docker-entrypoint.sh              ← Script de inicio
└── 📁 scripts/
    ├── build-kali-image.bat            ← Construir imagen
    ├── docker-compose-up.bat           ← Iniciar con Compose
    ├── docker-compose-down.bat         ← Detener Compose
    ├── start-kali-gui.bat              ← Iniciar Kali
    ├── stop-kali-gui.bat               ← Detener Kali
    ├── connect-kali-terminal.bat       ← Conectar terminal
    └── restart-vnc.bat                 ← Reiniciar VNC
```

---

## 🚀 Comandos Esenciales

### Iniciar Kali

```bash
# Con Docker Compose
docker-compose up -d

# O con script
scripts\docker-compose-up.bat
```

### Detener Kali

```bash
# Con Docker Compose
docker-compose down

# O con script
scripts\docker-compose-down.bat
```

### Conectar a Terminal

```bash
# Desde Windows
docker-compose exec kali-gui bash

# O con script
scripts\connect-kali-terminal.bat
```

### Ver Logs

```bash
docker-compose logs -f
```

---

## 🔧 Configuración Predeterminada

| Parámetro | Valor |
|-----------|-------|
| **Usuario** | kaliuser |
| **Contraseña VNC** | kali123 |
| **Puerto VNC** | 5901 |
| **Resolución** | 1920x1080 |
| **Entorno Gráfico** | XFCE |
| **Privilegios** | sudo sin contraseña |

---

## 📝 Tareas Post-Instalación

### 1. Cambiar Contraseña VNC

```bash
# Dentro del contenedor
vncpasswd
```

### 2. Actualizar Sistema

```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Instalar Herramientas Adicionales

```bash
# Herramientas de red
sudo apt install -y nmap wireshark tcpdump

# Metasploit
sudo apt install -y metasploit-framework

# Burp Suite
sudo apt install -y burpsuite
```

### 4. Configurar Persistencia

Los datos ya persisten automáticamente en volúmenes Docker:
- `kali-home`: Directorio home del usuario
- `kali-root`: Directorio root

---

## ⚠️ Problemas Comunes y Soluciones Rápidas

### Docker no inicia
```powershell
# Reiniciar servicios
net stop com.docker.service
net start com.docker.service
```

### VNC no conecta
```bash
# Reiniciar VNC
docker exec kali-gui-container su - kaliuser -c "vncserver -kill :1"
docker exec kali-gui-container su - kaliuser -c "vncserver :1 -geometry 1920x1080 -depth 24"
```

### Pantalla negra en VNC
```bash
# Limpiar y reiniciar
docker exec kali-gui-container rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1
docker restart kali-gui-container
```

### Sistema lento
Editar `C:\Users\TuUsuario\.wslconfig`:
```ini
[wsl2]
memory=8GB
processors=4
```

Luego: `wsl --shutdown`

---

## 📚 Documentación Completa

Para información detallada, consulta:

1. **[GUIA_INSTALACION_KALI_DOCKER.md](GUIA_INSTALACION_KALI_DOCKER.md)**
   - Instalación paso a paso completa
   - Configuración detallada
   - Múltiples métodos de instalación

2. **[COMANDOS_RAPIDOS.md](COMANDOS_RAPIDOS.md)**
   - Referencia de comandos Docker
   - Comandos de gestión de contenedores
   - Comandos VNC y sistema

3. **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)**
   - Solución de problemas detallada
   - Errores comunes y soluciones
   - Diagnóstico avanzado

4. **[README.md](README.md)**
   - Documentación del proyecto
   - Personalización avanzada
   - Recursos adicionales

---

## 🎓 Flujo de Trabajo Recomendado

### Para Principiantes

1. ✅ Instalar Docker Desktop
2. ✅ Ejecutar `docker-compose up -d --build`
3. ✅ Conectar con VNC Viewer
4. ✅ Cambiar contraseña VNC
5. ✅ Actualizar sistema
6. ✅ Instalar herramientas necesarias

### Para Usuarios Avanzados

1. ✅ Revisar y personalizar `Dockerfile`
2. ✅ Modificar `docker-compose.yml` según necesidades
3. ✅ Construir imagen personalizada
4. ✅ Configurar volúmenes adicionales
5. ✅ Implementar scripts de automatización
6. ✅ Configurar backups automáticos

---

## 💡 Tips y Mejores Prácticas

### Rendimiento

- Asigna al menos 4GB de RAM a WSL
- Usa SSD para mejor rendimiento
- Limpia Docker regularmente: `docker system prune`

### Seguridad

- Cambia la contraseña VNC por defecto
- No expongas puertos innecesarios
- Mantén el sistema actualizado
- Usa usuarios no-root

### Productividad

- Usa scripts de Windows para tareas comunes
- Configura aliases en bash
- Mantén backups de tu configuración
- Documenta tus cambios

### Persistencia

- Usa volúmenes Docker para datos importantes
- Haz commits de cambios significativos
- Exporta contenedores antes de cambios mayores

---

## 🔗 Enlaces Útiles

- **Docker Desktop**: https://www.docker.com/products/docker-desktop/
- **VNC Viewer**: https://www.realvnc.com/en/connect/download/viewer/
- **Kali Linux**: https://www.kali.org/
- **Docker Hub - Kali**: https://hub.docker.com/r/kalilinux/kali-rolling
- **WSL Documentation**: https://docs.microsoft.com/en-us/windows/wsl/

---

## ✅ Checklist de Verificación

Antes de empezar, asegúrate de tener:

- [ ] Windows 11 (64-bit)
- [ ] Mínimo 8GB RAM (recomendado 16GB)
- [ ] 20GB espacio libre en disco
- [ ] Virtualización habilitada en BIOS
- [ ] Conexión a Internet estable
- [ ] Permisos de administrador

Después de la instalación, verifica:

- [ ] Docker Desktop corriendo
- [ ] WSL 2 actualizado
- [ ] Contenedor iniciado: `docker ps`
- [ ] VNC conecta correctamente
- [ ] Internet funciona en contenedor
- [ ] Usuario sudo configurado
- [ ] Entorno gráfico funcional

---

## 🎯 Próximos Pasos

Una vez que tengas Kali funcionando:

1. **Explora el entorno**
   - Familiarízate con XFCE
   - Prueba las aplicaciones preinstaladas

2. **Personaliza tu setup**
   - Instala tus herramientas favoritas
   - Configura tu entorno de trabajo

3. **Aprende Docker**
   - Experimenta con comandos Docker
   - Crea tus propias imágenes

4. **Practica seguridad**
   - Usa Kali para aprender pentesting
   - Configura laboratorios de práctica

---

## 📞 Soporte

Si necesitas ayuda:

1. Consulta [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Revisa los logs: `docker logs kali-gui-container`
3. Busca en la documentación oficial
4. Pregunta en foros de la comunidad

---

**¡Disfruta tu Kali Linux en Docker!** 🐉🐳

*Tiempo total estimado: 15-30 minutos*

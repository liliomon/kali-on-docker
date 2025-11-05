# Guía Completa: Kali Linux en Docker Desktop con Windows 11

Esta guía te llevará paso a paso para instalar Docker Desktop en Windows 11, configurar Kali Linux dockerizado con un entorno gráfico liviano usando XRDP.

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
9. [Paso 8: Instalar Entorno Gráfico con XRDP](#paso-8-instalar-entorno-gráfico-con-xrdp)
10. [Conectarse con RDP](#conectarse-con-rdp)
11. [Solución de Problemas XRDP](#solución-de-problemas-xrdp)
12. [Comandos Rápidos](#comandos-rápidos)

---

## Requisitos Previos

- Windows 11 (64-bit)
- Mínimo 16GB de RAM (recomendado 24 a 32GB)
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

### [OPCIONAL EN CASO DE ERROR] 1.2 Habilitar Características de Windows

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
4. Haz clic en **OK** y espera a que termine
5. Reinicia tu PC cuando se solicite

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

## [IMPORTANTE EN CASO DE ERROR] Paso 2: Actualizar WSL

### 2.1 Actualizar WSL a la Última Versión

Abre **PowerShell como Administrador**:

```powershell
# Actualizar WSL
wsl --update

# Verificar versión
wsl --version
```

---

## Paso 3: Descargar Kali Linux

### 3.1 Descargar la Imagen de Kali

Abre **PowerShell** o **CMD** y usa el siguiente comando:

```bash
docker pull kalilinux/kali-rolling
```

También puedes revisar: https://docs.docker.com/desktop/setup/install/windows-install

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

### 6.3 Cambiar al Nuevo Usuario

```bash
su - tuusuario
```

### 6.4 Verificar Permisos Sudo

```bash
sudo whoami
```

Debería mostrar: `root`

---

## Paso 7 [Y MUY IMPORTANTE]: Guardar Cambios con Commit

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
# Detener y eliminar un contenedor
docker stop [NOMBRE-CONTENEDOR]
docker rm [NOMBRE-CONTENEDOR]

# Ejemplo
docker stop kali-container
docker rm kali-container

# Ejecutar con la nueva imagen
docker run -it --name kali-custom-container kali-custom:v1 /bin/bash
```

---

## Paso 8: Instalar Entorno Gráfico con XRDP

### 8.1 Ejecutar Contenedor con Puerto XRDP

Primero, ejecuta el contenedor con el puerto 3390 mapeado:

```bash
docker run -p 3390:3390 --expose=3390 --tty --interactive --name kali-gui-v5 kali-gui:latest /bin/bash
```

### 8.2 Instalar XRDP y Entorno Gráfico

Dentro del contenedor:

```bash
# Actualizar repositorios
sudo apt update

# Instalar XRDP y componentes necesarios
sudo apt install -y xrdp xorgxrdp

# Instalar entorno gráfico XFCE (ligero y estable)
sudo apt install -y kali-desktop-xfce xfce4 xfce4-goodies

# Instalar D-Bus (necesario para evitar errores)
sudo apt install -y dbus-x11
```

### 8.3 Configurar XRDP

```bash
# Configurar XRDP para usar puerto 3390
sudo sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini

# Configurar sesión XFCE
echo "startxfce4" > ~/.xsession
chmod +x ~/.xsession

# Configurar startwm.sh para XFCE
sudo bash -c 'cat > /etc/xrdp/startwm.sh << EOF
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF'

sudo chmod +x /etc/xrdp/startwm.sh
```

### 8.4 Iniciar Servicios XRDP

```bash
# Crear directorios necesarios
sudo mkdir -p /var/run/xrdp
sudo mkdir -p /var/log/xrdp

# Iniciar xrdp-sesman primero (MUY IMPORTANTE EL ORDEN)
sudo /usr/sbin/xrdp-sesman

# Esperar 2 segundos
sleep 2

# Iniciar XRDP
sudo /usr/sbin/xrdp

# Verificar que están corriendo
ps aux | grep xrdp
netstat -tuln | grep 3390
```

### 8.5 Salir y Hacer Commit

```bash
# Salir del contenedor
exit

# Hacer commit con el entorno gráfico y XRDP configurado
docker commit kali-gui-v5 kali-gui:v1
```

---

## 🖥️ Conectarse al Entorno Gráfico con RDP

### Opción 1: Usar Remote Desktop Connection (Windows)

1. **Abrir Conexión a Escritorio Remoto:**
   - Presiona `Win + R`
   - Escribe: `mstsc`
   - Presiona Enter

2. **Configurar Conexión:**
   - En "Computer": `localhost:3390`
   - Haz clic en "Connect"

3. **Iniciar Sesión:**
   - Usuario: `tuusuario` (el que creaste)
   - Contraseña: la que configuraste
   - Haz clic en "OK"

### Opción 2: Iniciar Contenedor Existente

Si ya tienes el contenedor creado:

```bash
# Iniciar contenedor
docker start kali-gui-v5

# Conectarse al contenedor
docker exec -it kali-gui-v5 /bin/bash

# Dentro del contenedor, iniciar servicios XRDP
sudo /usr/sbin/xrdp-sesman
sleep 2
sudo /usr/sbin/xrdp

# Verificar
ps aux | grep xrdp
```

Luego conecta con Remote Desktop a `localhost:3390`

---

## 🛠️ Paso 9: Instalar Herramientas de Pentesting

### 9.1 Actualizar Sistema Antes de Instalar

```bash
# Dentro del contenedor
sudo apt update && sudo apt upgrade -y
```

### 9.2 Herramientas de Reconocimiento y Escaneo de Red

#### Nmap - Escáner de puertos y redes

```bash
# Instalar Nmap
sudo apt install -y nmap

# Verificar instalación
nmap --version

# Ejemplos de uso:
# Escaneo básico
nmap 192.168.1.1

# Escaneo de puertos específicos
nmap -p 80,443 192.168.1.1

# Escaneo completo con detección de OS
nmap -A 192.168.1.1

# Escaneo rápido de red
nmap -sn 192.168.1.0/24
```

#### Netdiscover - Descubrimiento de hosts

```bash
# Instalar Netdiscover
sudo apt install -y netdiscover

# Uso básico
sudo netdiscover -i eth0
sudo netdiscover -r 192.168.1.0/24
```

#### Masscan - Escáner de puertos ultra rápido

```bash
# Instalar Masscan
sudo apt install -y masscan

# Ejemplo de uso
sudo masscan -p80,443 192.168.1.0/24 --rate=1000
```

### 9.3 Herramientas de Análisis de Vulnerabilidades Web

#### WPScan - Escáner de vulnerabilidades WordPress

```bash
# Instalar WPScan
sudo apt install -y wpscan

# Actualizar base de datos
wpscan --update

# Verificar instalación
wpscan --version

# Ejemplos de uso:
# Escaneo básico
wpscan --url http://ejemplo.com

# Enumerar plugins vulnerables
wpscan --url http://ejemplo.com --enumerate vp

# Enumerar usuarios
wpscan --url http://ejemplo.com --enumerate u

# Escaneo completo
wpscan --url http://ejemplo.com --enumerate ap,at,cb,dbe
```

#### Nikto - Escáner de vulnerabilidades web

```bash
# Instalar Nikto
sudo apt install -y nikto

# Ejemplos de uso:
nikto -h http://ejemplo.com
nikto -h http://ejemplo.com -p 80,443
```

#### Dirb - Buscador de directorios web

```bash
# Instalar Dirb
sudo apt install -y dirb

# Uso básico
dirb http://ejemplo.com
dirb http://ejemplo.com /usr/share/dirb/wordlists/common.txt
```

#### Gobuster - Buscador de directorios y DNS

```bash
# Instalar Gobuster
sudo apt install -y gobuster

# Buscar directorios
gobuster dir -u http://ejemplo.com -w /usr/share/wordlists/dirb/common.txt

# Buscar subdominios
gobuster dns -d ejemplo.com -w /usr/share/wordlists/dnsmap.txt
```

#### SQLMap - Herramienta de inyección SQL

```bash
# Instalar SQLMap
sudo apt install -y sqlmap

# Ejemplo de uso
sqlmap -u "http://ejemplo.com/page.php?id=1" --dbs
```

### 9.4 Burp Suite - Proxy de interceptación web

```bash
# Instalar Burp Suite Community Edition
sudo apt install -y burpsuite

# Iniciar Burp Suite
burpsuite &

# Nota: Burp Suite requiere entorno gráfico (XFCE/RDP)
```

### 9.5 Herramientas de Cracking de Contraseñas

#### Hydra - Cracker de contraseñas por fuerza bruta

```bash
# Instalar Hydra
sudo apt install -y hydra

# Verificar instalación
hydra -h

# Ejemplos de uso:
# SSH brute force
hydra -l usuario -P /usr/share/wordlists/rockyou.txt ssh://192.168.1.1

# FTP brute force
hydra -l admin -P passwords.txt ftp://192.168.1.1

# HTTP POST form
hydra -l admin -P passwords.txt 192.168.1.1 http-post-form "/login:user=^USER^&pass=^PASS^:F=incorrect"
```

#### John the Ripper - Cracker de hashes

```bash
# Instalar John the Ripper
sudo apt install -y john

# Verificar instalación
john --version

# Ejemplos de uso:
# Crackear archivo de contraseñas
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt

# Mostrar contraseñas crackeadas
john --show hashes.txt

# Crackear con reglas
john --wordlist=/usr/share/wordlists/rockyou.txt --rules hashes.txt
```

#### Hashcat - Cracker de hashes avanzado

```bash
# Instalar Hashcat
sudo apt install -y hashcat

# Ejemplo de uso
hashcat -m 0 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt
```

#### Crunch - Generador de wordlists

```bash
# Instalar Crunch
sudo apt install -y crunch

# Generar wordlist de 4 a 6 caracteres
crunch 4 6 -o wordlist.txt

# Generar con caracteres específicos
crunch 8 8 -t @@@@%%%% -o passwords.txt
```

### 9.6 Metasploit Framework - Framework de explotación

```bash
# Instalar Metasploit Framework
sudo apt install -y metasploit-framework

# Instalar PostgreSQL (base de datos para Metasploit)
sudo apt install -y postgresql

# Iniciar servicio PostgreSQL
sudo service postgresql start

# Inicializar base de datos de Metasploit
sudo msfdb init

# Verificar instalación
msfconsole --version

# Iniciar Metasploit
msfconsole

# Comandos básicos dentro de msfconsole:
# search exploit_name
# use exploit/windows/smb/ms17_010_eternalblue
# show options
# set RHOSTS 192.168.1.1
# exploit
```

### 9.7 Herramientas de Análisis de Red

#### Wireshark - Analizador de protocolos de red

```bash
# Instalar Wireshark
sudo apt install -y wireshark

# Configurar permisos (seleccionar "Yes" cuando pregunte)
sudo dpkg-reconfigure wireshark-common
sudo usermod -aG wireshark $USER

# Iniciar Wireshark (requiere GUI)
wireshark &
```

#### tcpdump - Captura de paquetes por línea de comandos

```bash
# Instalar tcpdump
sudo apt install -y tcpdump

# Capturar tráfico
sudo tcpdump -i eth0

# Guardar captura
sudo tcpdump -i eth0 -w captura.pcap

# Filtrar por puerto
sudo tcpdump -i eth0 port 80
```

#### Netcat - Herramienta de red multiuso

```bash
# Instalar Netcat
sudo apt install -y netcat-traditional

# Escuchar en puerto
nc -lvp 4444

# Conectar a puerto
nc 192.168.1.1 4444

# Transferir archivo
nc -lvp 4444 > archivo_recibido
nc 192.168.1.1 4444 < archivo_enviar
```

### 9.8 Herramientas de Explotación y Post-Explotación

#### Searchsploit - Búsqueda de exploits

```bash
# Instalar Exploit Database
sudo apt install -y exploitdb

# Buscar exploits
searchsploit apache
searchsploit -t windows smb

# Ver exploit
searchsploit -x exploits/windows/remote/42315.py
```

#### Mimikatz (vía Wine para Windows)

```bash
# Instalar Wine
sudo apt install -y wine wine32 wine64

# Descargar Mimikatz manualmente desde GitHub
# https://github.com/gentilkiwi/mimikatz
```

### 9.9 Herramientas de Ingeniería Social

#### Social Engineering Toolkit (SET)

```bash
# Instalar SET
sudo apt install -y set

# Iniciar SET
sudo setoolkit
```

### 9.10 Herramientas Adicionales Importantes

#### Aircrack-ng - Suite de auditoría WiFi

```bash
# Instalar Aircrack-ng
sudo apt install -y aircrack-ng

# Nota: Requiere adaptador WiFi compatible con modo monitor
```

#### Enum4linux - Enumeración de información SMB

```bash
# Instalar Enum4linux
sudo apt install -y enum4linux

# Uso básico
enum4linux -a 192.168.1.1
```

#### Responder - Envenenamiento LLMNR/NBT-NS

```bash
# Instalar Responder
sudo apt install -y responder

# Uso básico
sudo responder -I eth0
```

#### Impacket - Colección de scripts Python para protocolos de red

```bash
# Instalar Impacket
sudo apt install -y python3-impacket

# Ejemplos de herramientas incluidas:
# psexec.py, smbexec.py, wmiexec.py, secretsdump.py
```

### 9.11 Instalar Wordlists Comunes

```bash
# Instalar colección de wordlists
sudo apt install -y wordlists

# Descomprimir rockyou.txt (wordlist más popular)
sudo gunzip /usr/share/wordlists/rockyou.txt.gz

# Ubicaciones de wordlists:
# /usr/share/wordlists/
# /usr/share/wordlists/dirb/
# /usr/share/wordlists/dirbuster/
# /usr/share/wordlists/metasploit/
# /usr/share/wordlists/wfuzz/
```

### 9.12 Instalar Todas las Herramientas de Kali (Opcional)

**ADVERTENCIA:** Esto instalará TODAS las herramientas de Kali Linux (más de 600 herramientas) y ocupará mucho espacio (varios GB).

```bash
# Instalar metapaquete completo de Kali
sudo apt install -y kali-linux-large

# O instalar por categorías:
# Herramientas top 10
sudo apt install -y kali-tools-top10

# Herramientas de información gathering
sudo apt install -y kali-tools-information-gathering

# Herramientas de análisis de vulnerabilidades
sudo apt install -y kali-tools-vulnerability

# Herramientas de explotación
sudo apt install -y kali-tools-exploitation

# Herramientas de cracking de contraseñas
sudo apt install -y kali-tools-passwords

# Herramientas de análisis web
sudo apt install -y kali-tools-web

# Herramientas de sniffing y spoofing
sudo apt install -y kali-tools-sniffing-spoofing

# Herramientas wireless
sudo apt install -y kali-tools-wireless
```

### 9.13 Verificar Instalación de Herramientas

```bash
# Crear script de verificación
cat > ~/verificar_herramientas.sh << 'EOF'
#!/bin/bash
echo "=== Verificando Herramientas Instaladas ==="
echo ""

herramientas=("nmap" "wpscan" "hydra" "john" "msfconsole" "nikto" "dirb" "gobuster" "sqlmap" "burpsuite" "wireshark" "netcat" "searchsploit" "aircrack-ng")

for tool in "${herramientas[@]}"; do
    if command -v $tool &> /dev/null; then
        echo "✓ $tool - INSTALADO"
    else
        echo "✗ $tool - NO INSTALADO"
    fi
done
EOF

chmod +x ~/verificar_herramientas.sh
~/verificar_herramientas.sh
```

### 9.14 Guardar Cambios con Commit

Después de instalar todas las herramientas:

```bash
# Salir del contenedor
exit

# Hacer commit con las herramientas instaladas
docker commit kali-gui-v5 kali-gui-tools:v1

# Verificar nueva imagen
docker images
```

---

## 🔧 Solución de Problemas XRDP

### Problema 1: "error connecting to sesman on 127.0.0.1:3350"

**Causa:** El servicio xrdp-sesman no está corriendo o no puede conectarse.

**Solución:**

```bash
# Dentro del contenedor
# 1. Detener todos los procesos XRDP
sudo pkill xrdp
sudo pkill xrdp-sesman

# 2. Limpiar archivos de bloqueo y logs
sudo rm -rf /var/run/xrdp*
sudo rm -rf /var/log/xrdp/*

# 3. Crear directorios necesarios
sudo mkdir -p /var/run/xrdp
sudo mkdir -p /var/log/xrdp

# 4. Iniciar xrdp-sesman PRIMERO (muy importante el orden)
sudo /usr/sbin/xrdp-sesman

# 5. Esperar 3 segundos
sleep 3

# 6. Iniciar XRDP
sudo /usr/sbin/xrdp

# 7. Verificar que ambos están corriendo
ps aux | grep xrdp
netstat -tuln | grep 3390
```

---

### Problema 2: "Connection refused" o no se puede conectar

**Causa:** El puerto no está mapeado correctamente o el firewall bloquea la conexión.

**Solución:**

```bash
# Verificar que el contenedor tiene el puerto mapeado
docker ps

# Debe mostrar: 0.0.0.0:3390->3390/tcp

# Si no está mapeado, recrear el contenedor:
docker stop kali-gui-v5
docker rm kali-gui-v5
docker run -p 3390:3390 --expose=3390 --tty --interactive --name kali-gui-v5 kali-gui:latest /bin/bash
```

**Verificar firewall de Windows (PowerShell como Admin):**

```powershell
New-NetFirewallRule -DisplayName "XRDP Kali" -Direction Inbound -LocalPort 3390 -Protocol TCP -Action Allow
```

---

### Problema 3: Pantalla negra o sesión no inicia

**Causa:** Configuración incorrecta de la sesión XFCE.

**Solución:**

```bash
# Dentro del contenedor
# 1. Verificar archivo .xsession
cat ~/.xsession
# Debe contener: startxfce4

# 2. Si no existe o está mal, recrearlo
echo "startxfce4" > ~/.xsession
chmod +x ~/.xsession

# 3. Verificar startwm.sh
sudo cat /etc/xrdp/startwm.sh

# 4. Si está mal, recrearlo
sudo bash -c 'cat > /etc/xrdp/startwm.sh << EOF
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF'

sudo chmod +x /etc/xrdp/startwm.sh

# 5. Reiniciar servicios XRDP
sudo pkill xrdp
sudo pkill xrdp-sesman
sudo /usr/sbin/xrdp-sesman
sleep 2
sudo /usr/sbin/xrdp
```

---

### Problema 4: "Authentication failed" o credenciales incorrectas

**Causa:** Usuario o contraseña incorrectos.

**Solución:**

```bash
# Dentro del contenedor
# Verificar que el usuario existe
id tuusuario

# Cambiar contraseña del usuario
sudo passwd tuusuario

# Verificar que el usuario tiene permisos sudo
groups tuusuario

# Si no está en sudo, agregarlo
sudo usermod -aG sudo tuusuario
```

---

### Problema 5: XRDP se detiene después de conectar

**Causa:** Servicios no configurados para persistir.

**Solución - Crear script de inicio automático:**

```bash
# Crear script de inicio automático
sudo bash -c 'cat > /usr/local/bin/start-xrdp.sh << EOF
#!/bin/bash
mkdir -p /var/run/xrdp
mkdir -p /var/log/xrdp
/usr/sbin/xrdp-sesman
sleep 2
/usr/sbin/xrdp
EOF'

sudo chmod +x /usr/local/bin/start-xrdp.sh

# Ejecutar el script cada vez que inicies el contenedor
sudo /usr/local/bin/start-xrdp.sh
```

---

### Problema 6: Error "Could not acquire name on session bus"

**Causa:** Problemas con D-Bus.

**Solución:**

```bash
# Instalar y configurar D-Bus
sudo apt install -y dbus-x11

# Agregar al .xsession
cat > ~/.xsession << 'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_RUNTIME_DIR=/tmp/runtime-$(whoami)
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR
exec startxfce4
EOF

chmod +x ~/.xsession

# Reiniciar XRDP
sudo pkill xrdp
sudo pkill xrdp-sesman
sudo /usr/sbin/xrdp-sesman
sleep 2
sudo /usr/sbin/xrdp
```

---

### Problema 7: Contenedor se detiene al cerrar la terminal

**Causa:** Contenedor no está en modo detached.

**Solución:**

```bash
# Ejecutar contenedor en modo detached
docker run -d -p 3390:3390 --expose=3390 --name kali-gui-v5 kali-gui:latest tail -f /dev/null

# Luego conectarse para configurar
docker exec -it kali-gui-v5 /bin/bash

# Iniciar servicios XRDP
sudo /usr/sbin/xrdp-sesman
sleep 2
sudo /usr/sbin/xrdp
```

---

### Problema 8: Error "Failed to start session"

**Causa:** Permisos incorrectos o falta de paquetes.

**Solución:**

```bash
# Verificar e instalar paquetes necesarios
sudo apt update
sudo apt install -y xfce4-session xfce4-terminal

# Verificar permisos del usuario
sudo chown -R tuusuario:tuusuario /home/tuusuario

# Recrear configuración XFCE
rm -rf ~/.config/xfce4
rm -rf ~/.cache/sessions

# Reiniciar XRDP
sudo pkill xrdp
sudo pkill xrdp-sesman
sudo /usr/sbin/xrdp-sesman
sleep 2
sudo /usr/sbin/xrdp
```

---

## 🎯 Comandos Rápidos de Referencia

### Gestión de Contenedores

```bash
# Ver contenedores corriendo
docker ps

# Ver todos los contenedores
docker ps -a

# Iniciar contenedor
docker start kali-gui-v5

# Detener contenedor
docker stop kali-gui-v5

# Reiniciar contenedor
docker restart kali-gui-v5

# Conectarse a contenedor corriendo
docker exec -it kali-gui-v5 /bin/bash

# Conectarse como usuario específico
docker exec -it -u tuusuario kali-gui-v5 /bin/bash

# Ver logs del contenedor
docker logs kali-gui-v5

# Ver logs en tiempo real
docker logs -f kali-gui-v5

# Eliminar contenedor
docker rm kali-gui-v5

# Forzar eliminación de contenedor corriendo
docker rm -f kali-gui-v5
```

### Gestión de Imágenes

```bash
# Ver imágenes
docker images

# Eliminar imagen
docker rmi kali-gui:v1

# Hacer commit de cambios
docker commit kali-gui-v5 kali-gui:v2

# Ver historial de imagen
docker history kali-gui:v1

# Etiquetar imagen
docker tag kali-gui:v1 kali-gui:latest
```

### Comandos XRDP Dentro del Contenedor

```bash
# Iniciar servicios XRDP
sudo /usr/sbin/xrdp-sesman && sleep 2 && sudo /usr/sbin/xrdp

# Detener servicios XRDP
sudo pkill xrdp && sudo pkill xrdp-sesman

# Reiniciar servicios XRDP
sudo pkill xrdp && sudo pkill xrdp-sesman && sudo /usr/sbin/xrdp-sesman && sleep 2 && sudo /usr/sbin/xrdp

# Verificar estado de XRDP
ps aux | grep xrdp

# Verificar puerto XRDP
netstat -tuln | grep 3390

# Ver logs de XRDP
sudo tail -f /var/log/xrdp/xrdp.log
sudo tail -f /var/log/xrdp/xrdp-sesman.log
```

### Comandos de Diagnóstico

```bash
# Ver uso de recursos del contenedor
docker stats kali-gui-v5

# Inspeccionar contenedor
docker inspect kali-gui-v5

# Ver procesos en contenedor
docker top kali-gui-v5

# Verificar red del contenedor
docker network inspect bridge

# Ver puertos mapeados
docker port kali-gui-v5
```

### Limpieza y Mantenimiento

```bash
# Limpiar contenedores detenidos
docker container prune

# Limpiar imágenes sin usar
docker image prune

# Limpiar todo (contenedores, imágenes, redes, volúmenes)
docker system prune -a

# Ver uso de espacio de Docker
docker system df
```

### Scripts Útiles para Windows

**Crear archivo `start-kali-rdp.bat`:**

```batch
@echo off
echo Iniciando Kali Linux con RDP...
docker start kali-gui-v5
timeout /t 3
docker exec -d kali-gui-v5 /usr/sbin/xrdp-sesman
timeout /t 2
docker exec -d kali-gui-v5 /usr/sbin/xrdp
echo.
echo Kali Linux iniciado!
echo Conecta con Remote Desktop a: localhost:3390
pause
```

**Crear archivo `stop-kali-rdp.bat`:**

```batch
@echo off
echo Deteniendo Kali Linux...
docker exec kali-gui-v5 pkill xrdp
docker exec kali-gui-v5 pkill xrdp-sesman
docker stop kali-gui-v5
echo Kali Linux detenido!
pause
```

**Crear archivo `restart-xrdp.bat`:**

```batch
@echo off
echo Reiniciando servicios XRDP...
docker exec kali-gui-v5 pkill xrdp
docker exec kali-gui-v5 pkill xrdp-sesman
timeout /t 2
docker exec -d kali-gui-v5 /usr/sbin/xrdp-sesman
timeout /t 2
docker exec -d kali-gui-v5 /usr/sbin/xrdp
echo Servicios XRDP reiniciados!
pause
```

---

## 📚 Recursos Adicionales

- [Documentación oficial de Docker](https://docs.docker.com/)
- [Kali Linux Docker Hub](https://hub.docker.com/r/kalilinux/kali-rolling)
- [Documentación de Kali Linux](https://www.kali.org/docs/)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [XRDP Documentation](http://xrdp.org/)

---

## ✅ Checklist Final

- [ ] Docker Desktop instalado y corriendo
- [ ] WSL 2 actualizado
- [ ] Imagen kalilinux/kali-rolling descargada
- [ ] Contenedor de Kali ejecutándose
- [ ] Usuario sudo creado
- [ ] Cambios guardados con commit
- [ ] Entorno gráfico XFCE instalado
- [ ] XRDP configurado en puerto 3390
- [ ] Conexión RDP funcionando
- [ ] Scripts de inicio creados

---


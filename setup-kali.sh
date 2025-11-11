#!/bin/bash
set -e

echo "=== Iniciando instalación de Kali Linux con GUI ==="

# Actualizar sistema
apt update && apt upgrade -y

# Instalar paquetes esenciales
apt install -y sudo nano vim wget curl git net-tools iputils-ping

# Instalar XRDP y componentes gráficos
apt install -y xrdp xorgxrdp
apt install -y kali-desktop-xfce xfce4 xfce4-goodies
apt install -y dbus-x11

# Crear usuario con privilegios sudo (solo si no existe)
if ! id kaliuser &>/dev/null; then
  useradd -m -s /bin/bash kaliuser
  echo 'kaliuser:kali123' | chpasswd
  usermod -aG sudo kaliuser
  echo 'kaliuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/kaliuser
  chmod 0440 /etc/sudoers.d/kaliuser
  echo "Usuario kaliuser creado"
else
  echo "Usuario kaliuser ya existe"
fi

# Configurar XRDP en puerto 3390
sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini

# Configurar sesión XFCE para el usuario
su - kaliuser -c 'echo "startxfce4" > ~/.xsession && chmod +x ~/.xsession'

# Configurar script de inicio de XRDP
cat > /etc/xrdp/startwm.sh << 'EOFXRDP'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_RUNTIME_DIR=/tmp/runtime-$(whoami)
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR
exec startxfce4
EOFXRDP

chmod +x /etc/xrdp/startwm.sh

# Crear directorios necesarios
mkdir -p /var/run/xrdp /var/log/xrdp

# Ocultar mensaje de Kali
touch /root/.hushlogin
su - kaliuser -c 'touch ~/.hushlogin'

echo "=== Iniciando servicios XRDP ==="
/usr/sbin/xrdp-sesman
sleep 3
/usr/sbin/xrdp

# Verificar servicios
ps aux | grep xrdp
netstat -tuln | grep 3390

echo "=== Instalación completada ==="
echo "Conecta con RDP a: localhost:3390"
echo "Usuario: kaliuser"
echo "Contraseña: kali123"

# Mantener contenedor corriendo
tail -f /dev/null

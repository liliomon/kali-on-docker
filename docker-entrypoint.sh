#!/bin/bash
# Script de entrada para el contenedor Kali Linux

echo "=========================================="
echo "  Iniciando Kali Linux con GUI"
echo "=========================================="
echo ""

# Verificar si existe contraseña VNC
if [ ! -f ~/.vnc/passwd ]; then
    echo "[INFO] Configurando contraseña VNC por defecto..."
    echo "[INFO] Contraseña: kali123"
    echo "kali123" | vncpasswd -f > ~/.vnc/passwd
    chmod 600 ~/.vnc/passwd
fi

# Limpiar archivos de bloqueo anteriores
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null

# Iniciar servidor VNC
echo "[INFO] Iniciando servidor VNC en display :1..."
vncserver :1 -geometry 1920x1080 -depth 24 -localhost no

echo ""
echo "=========================================="
echo "  Kali Linux GUI Iniciado"
echo "=========================================="
echo ""
echo "Conecta con VNC Viewer a:"
echo "  - Desde Windows: localhost:5901"
echo "  - Contraseña por defecto: kali123"
echo ""
echo "Para cambiar la contraseña VNC:"
echo "  vncpasswd"
echo ""
echo "Para detener el servidor VNC:"
echo "  vncserver -kill :1"
echo ""
echo "=========================================="

# Mantener el contenedor corriendo
tail -f /dev/null

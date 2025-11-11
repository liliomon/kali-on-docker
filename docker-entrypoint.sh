#!/bin/bash

echo "=== Iniciando Kali Linux con GUI ==="

# Iniciar servicios XRDP
echo "Iniciando servicios XRDP..."
/usr/sbin/xrdp-sesman
sleep 2
/usr/sbin/xrdp

# Verificar servicios
if pgrep -x "xrdp" > /dev/null && pgrep -x "xrdp-sesman" > /dev/null; then
    echo "=== Servicios XRDP iniciados correctamente ==="
    echo "Conecta con RDP a: localhost:3390"
    echo "Usuario: kaliuser"
    echo "Contraseña: kali123"
else
    echo "ERROR: No se pudieron iniciar los servicios XRDP"
fi

# Mantener contenedor corriendo
tail -f /dev/null

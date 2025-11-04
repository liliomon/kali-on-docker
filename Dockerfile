# Dockerfile para Kali Linux con Entorno Gráfico XFCE
# Basado en kalilinux/kali-rolling

FROM kalilinux/kali-rolling

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar sistema e instalar paquetes básicos
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    sudo \
    nano \
    vim \
    wget \
    curl \
    git \
    net-tools \
    iputils-ping \
    dbus-x11 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar entorno gráfico XFCE
RUN apt-get update && \
    apt-get install -y \
    kali-desktop-xfce \
    xfce4 \
    xfce4-goodies \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar servidor VNC
RUN apt-get update && \
    apt-get install -y \
    tigervnc-standalone-server \
    tigervnc-common \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario no-root con privilegios sudo
ARG USERNAME=kaliuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Cambiar al usuario creado
USER $USERNAME
WORKDIR /home/$USERNAME

# Crear directorio VNC y configurar
RUN mkdir -p ~/.vnc

# Crear script de inicio para VNC
RUN echo '#!/bin/sh' > ~/.vnc/xstartup && \
    echo 'unset SESSION_MANAGER' >> ~/.vnc/xstartup && \
    echo 'unset DBUS_SESSION_BUS_ADDRESS' >> ~/.vnc/xstartup && \
    echo 'exec startxfce4' >> ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Exponer puerto VNC
EXPOSE 5901

# Script de inicio
COPY --chown=$USERNAME:$USERNAME docker-entrypoint.sh /home/$USERNAME/
RUN chmod +x /home/$USERNAME/docker-entrypoint.sh

# Comando por defecto
CMD ["/home/kaliuser/docker-entrypoint.sh"]

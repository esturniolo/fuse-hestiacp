#!/bin/bash

# Verificar si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ser ejecutado como root" 1>&2
   exit 1
fi

# 1. Crear el usuario 'eas' con /bin/bash como shell predeterminado
if id "eas" &>/dev/null; then
    echo "El usuario 'eas' ya existe."
else
    useradd -m -s /bin/bash eas
    echo "Usuario 'eas' creado con Bash como shell predeterminado."

    # Copiar archivos de configuración estándar a /home/eas
    cp /etc/skel/.bashrc /home/eas/
    cp /etc/skel/.profile /home/eas/
    chown eas:eas /home/eas/.bashrc /home/eas/.profile

    # Configurar un prompt colorido para 'eas' y actualizar el alias 'll'
    echo 'export PS1="\[\e[01;92m\]\u@\h\[\e[00m\]:\[\e[01;95m\]\w\[\e[00m\] \$ "' >> /home/eas/.bashrc
    echo 'alias ll="ls -hlF"' >> /home/eas/.bashrc

    chown eas:eas /home/eas/.bashrc
    echo "Prompt personalizado y alias 'll' configurados para 'eas'."
fi

# Configurar un prompt personalizado para 'root'
echo 'export PS1="\[\e[01;91m\]\u@\h\[\e[00m\]:\[\e[01;93m\]\w\[\e[00m\] # "' >> /root/.bashrc

# 2. Crear archivo en /etc/sudoers.d/ para 'eas'
echo "eas ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/eas
chmod 0440 /etc/sudoers.d/eas
echo "Permisos de sudo configurados para 'eas'."

# 3. Copiar el directorio .ssh a /home/eas y cambiar la propiedad
if [ -d "/root/.ssh" ]; then
    cp -r /root/.ssh /home/eas/
    chown -R eas:eas /home/eas/.ssh
    echo "Directorio .ssh copiado y permisos cambiados."
else
    echo "El directorio /root/.ssh no existe."
fi

# 4. Modificar /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 43812/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
echo "Configuración de SSH modificada."

# 5. Reiniciar el servicio SSH para aplicar los cambios
systemctl restart sshd
echo "Servicio SSH reiniciado."

# 6. Cambiar el hostname a "hestia-cp"
hostnamectl set-hostname "hestia-cp"
echo "Hostname cambiado a 'hestia-cp'."


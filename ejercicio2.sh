#!/bin/bash

# Solicitar al usuario que ingrese el nombre del nuevo usuario y del nuevo grupo
read -p "Ingrese el nombre del nuevo usuario: " usuarioN
read -p "Ingrese el nombre del nuevo grupo: " grupoN

# ¿Ya existe el usuario?
if id "$usuarioN" &>/dev/null; then
    echo "El usuario '$usuarioN' ya existe."
else
    # Crear el usuario
    sudo useradd -m "$usuarioN"
    echo "Nuevo usuario '$usuarioN' creado correctamente."
fi

# ¿Ya existe el grupo?
if grep -q "^$grupoN:" /etc/group; then
    echo "El grupo '$grupoN' ya existe."
else
    # Crear el grupo
    sudo groupadd "$grupoN"
    echo "Nuevo grupo '$grupoN' creado correctamente."
fi

# Agregar tu usuario al grupo
sudo usermod -aG "$grupoN" "$(whoami)"
# Agregar el nuevo usuario al grupo
sudo usermod -aG "$grupoN" "$usuarioN"

# Asignar permisos de ejecución del script ejercicio1.sh a miembros del nuevo grupo
# El nuevo grupo es propietario del script
sudo chown :"$grupoN" ejercicio1.sh
sudo chmod 750 ejercicio1.sh
echo "Permisos de ejecución asignados correctamente."

#!/bin/bash

# Verifica si se proporcionó un archivo como argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 <archivo>"
    exit 1
fi

archivo=$1

# Si el archivo no se encuentra, envía un mensaje de error y sale
if [ ! -e "$archivo" ]; then
    echo "Error: el archivo $archivo no ha sido encontrado."
    exit 1
fi

# Obtener permisos del archivo
permisos=$(stat -c "%A" "$archivo")

# Definir la función para leer e interpretar los permisos
get_permissions_verbose() {
    local permisos=$1
    usuario=${permisos:1:3}
    grupos=${permisos:4:3}
    others=${permisos:7:3}

    # Imprimir permisos del usuario
    echo "Permisos para usuario: $usuario"
    # Detallar permisos del usuario
    case $usuario in
        "rwx")
            echo "El usuario tiene permiso de lectura, escritura y ejecución."
            ;;
        "rw-")
            echo "El usuario tiene permisos de lectura y escritura."
            ;;
        "r--")
            echo "El usuario tiene permiso de lectura."
            ;;
        *)
            echo "El usuario no tiene permisos."
            ;;
    esac

    # Imprimir permisos de grupos
    echo "Permisos para grupo: $grupos"
    # Detallar permisos de grupos
    case $grupos in
        "rwx")
            echo "El grupo tiene permisos de lectura, escritura y ejecución."
            ;;
        "rw-")
            echo "El grupo tiene permisos de lectura y escritura."
            ;;
        "r--")
            echo "El grupo tiene permiso de lectura."
            ;;
        *)
            echo "El grupo no tiene permisos."
            ;;
    esac

    # Imprimir permisos de otros
    echo "Permisos para otros: $others"
    # Detallar permisos de otros
    case $others in
        "rwx")
            echo "Otros tienen permiso de lectura, escritura y ejecución."
            ;;
        "rw-")
            echo "Otros tienen permisos de lectura y escritura."
            ;;
        "r--")
            echo "Otros tienen permiso de lectura."
            ;;
        *)
            echo "Otros no tienen permisos."
            ;;
    esac
}

# Llamar a la función pasando los permisos como argumento
get_permissions_verbose "$permisos"



# Llamar a la funcion dandole de argumento la variable permisos
get_permissions_verbose "$permisos"

#!/bin/bash
# lectura del archivo
read -p  "ingrese el nombre del archivo: " archivo

# Si el archivo no se encuentra enviar mensaje de error y salir
# Si el archivo existe obtener permisos 

if [ ! -e "$archivo"  ]; then
	echo "Error, el archivo no ha sido encontrado"
	exit 1
fi

# Leer permisos / obtenerlos

permisos=$(stat -c "%A" "$archivo")

# Creacion de la funcion para lectura e interpretacion de permisos

get_permissions_verbose(){

	local permisos=$1
	
	# Extraer permisos
	usuario=${permisos:1:3}
	grupos=${permisos:4:3}
	others=${permisos:7:3}

	# Imprimir permisos de usuario
	echo  "Permisos para usuario: $usuario"
	
	# Detallar permisos
	if [ "$usuario" == "rwx" ]; then
		echo "Usuario tiene permiso de lectura, escritura y ejecicion"
	elif [ "$usuario" == "rw-" ]; then
		echo "El usuario tiene permisos de lectura y escritura"
	elif [ "$usurario" == "r--" ]; then
		echo "El usuario tiene permiso de lectura"
	else
		echo "El usuario no tiene permisos"
	fi

	# Imprimir permisos de grupos
	echo "Permisos para grupo: $grupos"

	# Detallar permisos
	if [ "$grupos" == "rwx" ]; then
		echo "El grupo tiene permisos de lectura, escritura y ejecucion"
	elif [ "$rgupo" == "rw-" ]; then
		echo "El grupo tiene permisos de lectura y escritura"
	elif [ "$grupos" == "r--" ]; then
		echo "El grupo tiene permisos de lectura"
	else
		echo "El grupo no tiene permisos"
	fi
	# Imprimir permisos de otros
	echo "Permisos para otros: $others"

	#detallar permisos

	if [ "$others" == "rwx" ]; then
		echo "Otros tienen permiso de lectura, escritura y ejecucion"
	elif [ "$others" == "rw-" ]; then
		echo "otros tienen permiso de lectura y escritura"
	elif [ "$others" == "r--" ]; then
		echo "Otros tienen permiso de lectura"
	else
		echo "otros no tienen permisos"
	fi

	echo ""

}


# Llamar a la funcion dandole de argumento la variable permisos
get_permissions_verbose "$permisos"

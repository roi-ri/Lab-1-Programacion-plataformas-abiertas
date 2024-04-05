#!/bin/bash

# Función para imprimir el menú de ayuda
print_help() {
    echo "Uso: $0 [-h] [-m MODE] [-d DATE] LOG_FILE"
    echo "  -h: Imprimir este menú de ayuda"
    echo "  -m: Modo de funcionamiento del informe (opciones: servidor_web, base_de_datos, proceso_batch, aplicación, monitoreo)"
    echo "  -d: Especifica la fecha en el formato año-mes-día (ejemplo: 2024-03-08)"
    exit 0
}

# Función para generar el informe
generate_report() {
    if [[ -n $mode && -n $date ]]; then
        echo "Generando informe para el modo '$mode' en la fecha '$date':"
        grep "Fecha: $date" "$log_file" | grep "Modo: $mode" | cut -d ' ' -f 2,4-
    elif [[ -n $mode && -z $date ]]; then
        echo "Generando informe para el modo '$mode' en todas las fechas:"
        grep "Modo: $mode" "$log_file" | cut -d ' ' -f 2,4-
    elif [[ -z $mode && -n $date ]]; then
        echo "Generando informe para todas las actividades en la fecha '$date':"
        grep "Fecha: $date" "$log_file" | cut -d ' ' -f 2,4-
    else
        echo "Por favor, especifique al menos una opción. Ejecute '$0 -h' para obtener ayuda."
        exit 1
    fi
}

# Manejo de argumentos
while getopts ":hm:d:" opt; do
    case ${opt} in
        h )
            print_help
            ;;
        m )
            mode=$OPTARG
            ;;
        d )
            date=$OPTARG
            ;;
        \? )
            echo "Opción inválida: -$OPTARG" 1>&2
            print_help
            ;;
        : )
            echo "La opción -$OPTARG requiere un argumento." 1>&2
            print_help
            ;;
    esac
done
shift $((OPTIND -1))

# Verificar si se proporcionó un archivo de registro
if [ -z "$1" ]; then
    echo "Debe especificar un archivo de log. Ejecute '$0 -h' para obtener ayuda."
    exit 1
fi

log_file=$1

# Verificar si el archivo de registro existe
if [ ! -f "$log_file" ]; then
    echo "El archivo de log especificado '$log_file' no existe."
    exit 1
fi

# Generar el informe
generate_report


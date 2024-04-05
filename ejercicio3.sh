#!/bin/bash

# Función para imprimir el menú de ayuda
print_help() {
    echo "Uso: $0 [-h] [-m MODE] [-d DATE]"
    echo "  -h: Imprimir este menú de ayuda"
    echo "  -m: Modo de funcionamiento del informe (opciones: servidor_web, base_de_datos, proceso_batch, aplicación, monitoreo)"
    echo "  -d: Especifica la fecha en el formato año-mes-día (ejemplo: 2024-03-08)"
    exit 0
}

# Función para generar el informe
generate_report() {
    local mode=$1
    local date=$2
    local output_file="reporte_${mode}_${date}.txt"

    if [[ -n $mode && -n $date ]]; then
        echo "Generando informe para el modo '$mode' en la fecha '$date':"
        grep "$date.*ERROR.*\[$mode\]" "log/log_$date.log" | while read -r line; do
            time=$(echo "$line" | cut -d ' ' -f 2)
            description=$(echo "$line" | cut -d ' ' -f 6-)
            echo "Fecha: $date"
            echo "    Hora del Error: $time"
            echo "    Descripción del Error: $description"
        done > "$output_file"
    elif [[ -n $mode && -z $date ]]; then
        echo "Generando informe para el modo '$mode' en todas las fechas:"
        grep "ERROR.*\[$mode\]" "log/"log*.log | while read -r line; do
            date=$(echo "$line" | cut -d ' ' -f 1)
            time=$(echo "$line" | cut -d ' ' -f 2)
            description=$(echo "$line" | cut -d ' ' -f 6-)
            echo "Fecha: $date"
            echo "    Hora del Error: $time"
            echo "    Descripción del Error: $description"
        done > "$output_file"
    elif [[ -z $mode && -n $date ]]; then
        echo "Generando informe para todas las actividades en la fecha '$date':"
        grep "$date.*ERROR" "log/log_$date.log" | while read -r line; do
            mode=$(echo "$line" | cut -d '[' -f 2 | cut -d ']' -f 1)
            time=$(echo "$line" | cut -d ' ' -f 2)
            description=$(echo "$line" | cut -d ' ' -f 6-)
            echo "Fecha: $date"
            echo "    Modo: $mode"
            echo "    Hora del Error: $time"
            echo "    Descripción del Error: $description"
        done > "$output_file"
    else
        echo "Por favor, especifique al menos una opción. Ejecute '$0 -h' para obtener ayuda."
        exit 1
    fi

    echo "Informe generado y guardado en: $output_file"
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

# Si no se especifica una fecha o un modo, imprimir ayuda y salir
if [ -z "$mode" ] && [ -z "$date" ]; then
    print_help
fi

# Si se especifica una fecha pero no un modo, establecer el modo como vacío
if [ -n "$date" ] && [ -z "$mode" ]; then
    mode=""
fi

# Verificar si existe al menos un archivo de registro para la fecha proporcionada
if [ -n "$date" ] && [ ! -f "log/log_$date.log" ]; then
    echo "No se encontró ningún archivo de log para la fecha '$date'."
    exit 1
fi

# Generar el informe
generate_report "$mode" "$date"

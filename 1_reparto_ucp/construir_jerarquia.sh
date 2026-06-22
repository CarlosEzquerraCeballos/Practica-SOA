#!/bin/bash

# obtiene argumentos especificados como "nombre=valor"
getargs() {
    for arg
    do
        IFS== splitargs=($arg)
        var=${splitargs[0]}
        values=${splitargs[1]}
        test $values || continue
        eval $var='$values'
    done
}

test $(id -u) = 0 || { echo "Ejecuta $0 con sudo" >&2; exit 1; }

# se asegura de que esté todo compilado
make clean &> /dev/null; make &> /dev/null

# los parámetros se indican como nombre=valor (si no se especifican
# usa los valores por defecto):
#         - weight: corresponde directamente a "cpu.weight"
#         - maxload: indica porcentaje máximo de uso del equipo;
#                    a partir de ese valor se calcula "cpu.max"
#         - cpus: corresponde directamente a "cpuset.cpus"
#         - maxpids: corresponde directamente a "pids.max"
#
# Por ejemplo:
#     ./construir_jerarquia weight=50 maxload=60 cpus=1,3 maxpids=32

getargs $@

test $weight && echo "se ha especificado un valor de 'weight': $weight" || echo "no se ha especificado 'weight': usará el valor por defecto 100" 
test $maxload && echo "se ha especificado un valor de 'maxload': $maxload" || echo "no se ha especificado 'maxload': no habrá límite en el uso de los procesadores"
test $cpus && echo "se ha especificado un valor de 'cpus': $cpus" || echo "no se ha especificado 'cpus': se usarán todos los procesadores"
test $maxpids && echo "se ha especificado un valor de 'maxpids': $maxpids" || echo "no se ha especificado 'maxpids': no habrá límite en el número de procesos en el grupo"

# Planificación de la empresa

# Planificación de las sucursales

# Planificación de los departamentos


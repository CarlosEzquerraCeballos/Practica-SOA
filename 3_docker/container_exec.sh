#!/bin/bash

test $# -ge 2 || { echo "Uso: $0 container_id cmd args..." >&2; exit 1; }

CID=$1
shift 1

PID=$(./get_container_pid.sh $CID)
CGROUP=$(cat /proc/$PID/cgroup | sed 's/^..*:://')

# TODO: incluir el propio script ($$) en el cgroup del contenedor

# TODO: usar nsenter para ejecutar el mandato asociándolo con todos los espacios
# de nombres del contenedor

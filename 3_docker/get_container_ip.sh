#!/bin/bash

test $# -eq 1 || { echo "Uso: $0 container_id" >&2; exit 1; }

# imprime el PID del primer proceso del contenedor pero en el
# espacio de nombres de PID por defecto
docker inspect -f '{{ .NetworkSettings.IPAddress }}' $1

#!/bin/bash
test $# -eq 1 || { echo "uso: $0 nombre_contenedor"; exit 1; }
set -x
docker run --rm -it --name $1 ubuntu

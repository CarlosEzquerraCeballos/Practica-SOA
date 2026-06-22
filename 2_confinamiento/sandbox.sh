#!/bin/bash

# Ejecuta el troyano de forma confinada

test $(id -u) = 0 &&{ echo "No ejecutes $0 con sudo" >&2; exit 1; }

test $# -ge 4 || { echo "Uso: $0 imagenSO_dir test_dir resultado_dir ./programa args..." >&2; exit 1; }

# se asegura de que todo esté compilado
make clean &> /dev/null; make &> /dev/null

# se asegura de que están permitidos los espacios de nombres de usuario
echo 0 | sudo tee /proc/sys/kernel/apparmor_restrict_unprivileged_userns &> /dev/null

# los tres directorios implicados en la ejecución confinada
export SO_DIR=$1
export TEST_DIR=$2
export RESULTADO_DIR=$3
shift 3

echo "Arranque el script 'catcher.sh' en otra ventana"
echo "Una vez arrancado, pulse 'enter' para continuar"
read 

# la ejecución del programa estará envuelta en un "unshare"
unshare  << EOF
$@ # ejecuta el programa
EOF

# comprueba qué ha quedado en la capa superior del overlay FS (resultado)
printf "\nCONTENIDO DEL DIRECTORIO $RESULTADO_DIR DESPUÉS DE LA PRUEBA\n"
find $RESULTADO_DIR


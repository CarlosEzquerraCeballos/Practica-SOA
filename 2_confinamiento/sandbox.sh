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
#   -r  : mapea el usuario actual como root dentro del nuevo userns (no requiere privilegios)
#   -m  : namespace de montaje (aísla el sistema de ficheros: necesario para el overlay/chroot)
#   -i  : namespace de IPC (bloquea la filtración por cola de mensajes System V)
#   -n  : namespace de red (bloquea la filtración por el socket al puerto del atacante)
unshare -r -m -i -n << EOF
# crea los directorios de trabajo del overlay dentro del directorio resultado
mkdir -p $RESULTADO_DIR/upper $RESULTADO_DIR/work

# monta un overlay sobre /mnt: capa inferior (solo lectura) = SO + test;
# capa superior (escritura) = resultado/upper. Así no se modifican ni los
# ficheros del SO ni los de la práctica: todo cambio va a la capa superior.
mount -t overlay overlay \\
    -o lowerdir=$TEST_DIR:$SO_DIR,upperdir=$RESULTADO_DIR/upper,workdir=$RESULTADO_DIR/work \\
    /mnt

# ejecuta el programa con chroot sobre el overlay, dándole solo la visibilidad
# de los recursos del sistema de corrección (ni /tmp ni /home reales del equipo)
chroot /mnt $@
EOF

# comprueba qué ha quedado en la capa superior del overlay FS (resultado)
printf "\nCONTENIDO DEL DIRECTORIO $RESULTADO_DIR DESPUÉS DE LA PRUEBA\n"
find $RESULTADO_DIR


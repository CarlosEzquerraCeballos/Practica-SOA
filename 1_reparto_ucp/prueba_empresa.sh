#!/bin/bash
test $(id -u) = 0 || { echo "Ejecuta $0 con sudo" >&2; exit 1; }
test $# -eq 0 && echo "$0 no ha recibido un argumento: lanza un 'acaparador' en el cgroup de la empresa" || echo "$0 ha recibido un argumento (cualquier valor): lanza un 'acaparador' en el cgroup de la empresa y otro en el 'cgroup' actual"
./acaparador 2> /sys/fs/cgroup/empresa/cgroup.procs &
test $# -eq 0 || ./acaparador 2> /dev/null &
wait

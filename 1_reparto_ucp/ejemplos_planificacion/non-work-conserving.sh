#!/bin/bash

test $(id -u) = 0 || { echo "Ejecuta $0 con sudo" >&2; exit 1; }
make &> /dev/null

# crea el grupo
mkdir /sys/fs/cgroup/nwc

# muestra peso y límite
cat /sys/fs/cgroup/nwc/cpu.weight
cat /sys/fs/cgroup/nwc/cpu.max

# prueba proceso ejecutando solo en el primer procesador antes de fijar el límite
taskset 1 ./acaparador 2>/sys/fs/cgroup/nwc/cgroup.procs

# cambia el límite al 50% de un procesador
echo 50000 > /sys/fs/cgroup/nwc/cpu.max

# prueba proceso ejecutando solo en el primer procesador después de fijar el límite
taskset 1 ./acaparador 2>/sys/fs/cgroup/nwc/cgroup.procs

# destruye el grupo
rmdir /sys/fs/cgroup/nwc

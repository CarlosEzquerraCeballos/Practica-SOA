#!/bin/bash

test $(id -u) = 0 || { echo "Ejecuta $0 con sudo" >&2; exit 1; }
make &> /dev/null

# crea todos los grupos
mkdir /sys/fs/cgroup/prof
mkdir /sys/fs/cgroup/alum
mkdir /sys/fs/cgroup/alum/master
mkdir /sys/fs/cgroup/alum/grado


# especifica los pesos de cada grupo del nivel superior
echo 75 >  /sys/fs/cgroup/prof/cpu.weight
echo 150 > /sys/fs/cgroup/alum/cpu.weight

# habilita el reparto de procesador en el nivel inferior
echo "+cpu" >  /sys/fs/cgroup/alum/cgroup.subtree_control

# especifica los pesos de cada grupo del nivel inferior
echo 150 > /sys/fs/cgroup/alum/master/cpu.weight
echo 50 > /sys/fs/cgroup/alum/grado/cpu.weight

# procesos de profesores ejecutando solo en el primer procesador
taskset 1 ./acaparador 2>/sys/fs/cgroup/prof/cgroup.procs &

# procesos de alumnos de grado ejecutando solo en el primer procesador
taskset 1 ./acaparador 2>/sys/fs/cgroup/alum/grado/cgroup.procs &

# procesos de alumnos de máster ejecutando solo en el primer procesador
taskset 1 ./acaparador 2>/sys/fs/cgroup/alum/master/cgroup.procs &

wait # espera que finalicen todos

# destruye los grupos
rmdir /sys/fs/cgroup/alum/master
rmdir /sys/fs/cgroup/alum/grado
rmdir /sys/fs/cgroup/alum
rmdir /sys/fs/cgroup/prof

#!/bin/bash
test $(id -u) = 0 || { echo "se debe ejecutar con sudo"; exit 1; }

mkdir /sys/fs/cgroup/grupo

echo "0,2" >/sys/fs/cgroup/grupo/cpuset.cpus

./acaparador 2>/sys/fs/cgroup/grupo/cgroup.procs

rmdir /sys/fs/cgroup/grupo

#!/bin/bash
test $(id -u) = 0 || { echo "se debe ejecutar con sudo"; exit 1; }

echo mkdir /sys/fs/cgroup/relojes
mkdir /sys/fs/cgroup/relojes

echo mkdir /sys/fs/cgroup/relojes/digitales
mkdir /sys/fs/cgroup/relojes/digitales

echo "xclock -update 1 &"
xclock -update 1 & # reloj analógico

echo "echo $! >/sys/fs/cgroup/relojes/cgroup.procs"
echo $! >/sys/fs/cgroup/relojes/cgroup.procs

echo "xclock -d -update 1 &"
xclock -d -update 1 & # reloj digital

echo "echo $! >/sys/fs/cgroup/relojes/digitales/cgroup.procs"
echo $! >/sys/fs/cgroup/relojes/digitales/cgroup.procs

echo "xclock -d -utime -update 1 &"
xclock -d -utime -update 1 & # reloj digital en segundos

echo "echo $! >/sys/fs/cgroup/relojes/digitales/cgroup.procs"
echo $! >/sys/fs/cgroup/relojes/digitales/cgroup.procs

echo "pulsa para congelarlos"
read v

echo "echo 1 > /sys/fs/cgroup/relojes/cgroup.freeze"
echo 1 > /sys/fs/cgroup/relojes/cgroup.freeze


echo "pulsa para descongelarlos"
read v
echo "echo 0 > /sys/fs/cgroup/relojes/cgroup.freeze"
echo 0 > /sys/fs/cgroup/relojes/cgroup.freeze


echo "pulsa para matarlos"
read v
echo "echo 1 > /sys/fs/cgroup/relojes/cgroup.kill"
echo 1 > /sys/fs/cgroup/relojes/cgroup.kill

wait

echo "rmdir /sys/fs/cgroup/relojes/digitales"
rmdir /sys/fs/cgroup/relojes/digitales
echo "rmdir /sys/fs/cgroup/relojes"
rmdir /sys/fs/cgroup/relojes

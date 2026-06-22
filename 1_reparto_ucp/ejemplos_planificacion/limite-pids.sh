#!/bin/bash
test $(id -u) = 0 || { echo "se debe ejecutar con sudo"; exit 1; }

mkdir /sys/fs/cgroup/PID_limitados

echo $$ >/sys/fs/cgroup/PID_limitados/cgroup.procs
echo 4 >/sys/fs/cgroup/PID_limitados/pids.max

for i in $(seq 1 6)
do
	echo Proceso $i
	sleep 5 &
done

wait
rmdir /sys/fs/cgroup/PID_limitados

#!/bin/bash
test $(id -u) = 0 || { echo "Ejecuta $0 con sudo" >&2; exit 1; }

./acaparador 2> /sys/fs/cgroup/empresa/suc1/cgroup.procs &
./acaparador 2> /sys/fs/cgroup/empresa/suc2/cgroup.procs &
wait

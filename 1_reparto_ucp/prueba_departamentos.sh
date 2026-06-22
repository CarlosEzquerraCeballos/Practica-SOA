#!/bin/bash
test $(id -u) = 0 || { echo "Ejecuta $0 con sudo" >&2; exit 1; }

./acaparador 2> /sys/fs/cgroup/empresa/suc1/depA/cgroup.procs &
./acaparador 2> /sys/fs/cgroup/empresa/suc1/depB/cgroup.procs &
./acaparador 2> /sys/fs/cgroup/empresa/suc2/depA/cgroup.procs &
./acaparador 2> /sys/fs/cgroup/empresa/suc2/depB/cgroup.procs &
wait

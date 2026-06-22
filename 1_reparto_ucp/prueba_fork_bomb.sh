#!/bin/bash
test $(id -u) = 0 || { echo "Ejecuta $0 con sudo" >&2; exit 1; }
./fork_bomb 2> /sys/fs/cgroup/empresa/cgroup.procs

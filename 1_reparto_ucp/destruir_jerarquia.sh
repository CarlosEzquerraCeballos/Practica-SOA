#!/bin/bash

test $(id -u) = 0 || { echo "Ejecuta $0 con sudo" >&2; exit 1; }

# elimina todos los grupos creados
rmdir /sys/fs/cgroup/empresa/suc1/depA 2>/dev/null
rmdir /sys/fs/cgroup/empresa/suc1/depB 2>/dev/null
rmdir /sys/fs/cgroup/empresa/suc2/depA 2>/dev/null
rmdir /sys/fs/cgroup/empresa/suc2/depB 2>/dev/null
rmdir /sys/fs/cgroup/empresa/suc1 2>/dev/null
rmdir /sys/fs/cgroup/empresa/suc2 2>/dev/null
rmdir /sys/fs/cgroup/empresa 2>/dev/null

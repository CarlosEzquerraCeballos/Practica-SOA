#!/bin/bash

test $# -eq 1 || { echo "Uso: $0 container_id" >&2; exit 1; }

cat /proc/$(./get_container_pid.sh $1)/cgroup
sudo nsenter -t $(./get_container_pid.sh $1) -m cat /proc/1/cgroup
sudo nsenter -t $(./get_container_pid.sh $1) -C -m cat /proc/1/cgroup
docker exec web_server cat /proc/1/cgroup

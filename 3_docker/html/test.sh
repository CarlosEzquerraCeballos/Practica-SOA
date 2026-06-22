#!/bin/bash

echo "Espacios de nombres"
lsns -p $$

echo
echo "cgroup"
cat /proc/$$/cgroup

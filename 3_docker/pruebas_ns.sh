#!/bin/bash

pausa() {
    printf "\npulse return para continuar\n"
    read v
}

echo "hostname y cat /etc/hosts con namespace u"
sudo nsenter -t $(./get_container_pid.sh web_server) -u sh -c "hostname; echo; cat /etc/hosts"
pausa
echo "hostname y cat /etc/hosts con namespace m"
sudo nsenter -t $(./get_container_pid.sh web_server) -m sh -c "hostname; echo; cat /etc/hosts"
pausa
echo "hostname y cat /etc/hosts con namespaces m y u"
sudo nsenter -t $(./get_container_pid.sh web_server) -m -u sh -c "hostname; echo; cat /etc/hosts"
pausa
echo "hostname -I e ip a con namespace n"
sudo nsenter -t $(./get_container_pid.sh web_server)  -n sh -c "hostname -I; echo; ip a"
pausa
echo "hostname -I e ip a con namespace m"
sudo nsenter -t $(./get_container_pid.sh web_server)  -m sh -c "hostname -I; echo; ip a"
pausa
echo "hostname -I e ip a con namespaces m y n"
sudo nsenter -t $(./get_container_pid.sh web_server)  -m -n sh -c "hostname -I; echo; ip a"

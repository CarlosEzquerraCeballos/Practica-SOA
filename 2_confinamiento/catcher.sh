#!/bin/bash

# recoge la información filtrada por el troyano

test $(id -u) = 0 &&{ echo "No ejecutes $0 con sudo" >&2; exit 1; }

# se asegura de que todo esté compilado
make clean &> /dev/null; make &> /dev/null

# crea la cuenta del atacante
sudo useradd -m -s /bin/bash atacante &> /dev/null
sudo passwd -d atacante &> /dev/null

# pasa a ejecutar en el contexto del atacante
su atacante << EOF
# elimina procesos de ejecuciones previas
pkill lee_cola_IPC &> /dev/null; pkill tail &> /dev/null; pkill nc &> /dev/null

# atacante prepara fichero en /tmp para recibir filtraciones
rm -f /tmp/canal
touch /tmp/canal
chmod o+w /tmp/canal

# atacante prepara fichero en su cuenta para recibir filtraciones
chmod o+x /home/atacante
rm -f /home/atacante/canal
touch /home/atacante/canal
chmod o+w /home/atacante/canal

# a la espera de filtraciones
nc -l -k -p 6666 2>/dev/null & 
./lee_cola_IPC &
tail -F /tmp/canal 2>/dev/null &
tail -F /home/atacante/canal 2>/dev/null &

echo "A la escucha de filtraciones; pulse 'enter' para terminar: "
read v < /dev/tty
jobs -p 2>/dev/null | xargs kill -9 &>/dev/null
EOF

# destruyo la cuenta del atacante
sudo userdel -r atacante &> /dev/null

#!/bin/bash

# en este script puede usar sudo

# creo un grupo para compartir el fichero entre los dos usuarios
sudo groupadd -f proyecto

# añado los dos usuarios al grupo
sudo usermod -aG proyecto usuario1
sudo usermod -aG proyecto usuario2

# asigno el grupo al fichero hola1
sudo chgrp proyecto ~/hola1

# permisos: dueño rw, grupo solo lectura, otros nada
chmod 640 ~/hola1

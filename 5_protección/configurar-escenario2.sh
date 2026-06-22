#!/bin/bash

# en este script no puede usar sudo

# debe incluir el mandato setfacl correspondiente

# usuario1: lectura y escritura
setfacl -m u:usuario1:rw ~/hola2

# usuario2: solo lectura
setfacl -m u:usuario2:r ~/hola2


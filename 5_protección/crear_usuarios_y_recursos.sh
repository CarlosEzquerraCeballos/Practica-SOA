#!/bin/bash

for U in usuario1 usuario2
do
	sudo useradd -m -s /bin/bash $U &> /dev/null
	sudo passwd -d $U &> /dev/null
done

rm -f ~/hola[12]
chmod o+x ~
echo "hola1" > ~/hola1
echo "hola2" > ~/hola2
chmod 600  ~/hola1
chmod 600  ~/hola2

#!/bin/bash

for U in usuario1 usuario2
do
	userdel -r $U &> /dev/null
done

rm -f ~/hola[12]
chmod o-x ~

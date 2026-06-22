#!/bin/bash
test $(id -u) = 0 || { echo "Ejecuta $0 con sudo" >&2; exit 1; }
 ./destruir_jerarquia.sh # por si ya existiera

echo "arranque 'systemd-cgtop empresa' en otra ventana; una vez hecho, pulse return para arrancar el primer experimento"
read V
echo experimento 1
 ./construir_jerarquia.sh
 ./prueba_empresa.sh
 ./destruir_jerarquia.sh 
echo "final del experimento; pulse return para arrancar el siguiente y Crtl-C para terminar"
read V
echo experimento 2
 ./construir_jerarquia.sh
 ./prueba_empresa.sh 1
 ./destruir_jerarquia.sh 
echo "final del experimento; pulse return para arrancar el siguiente y Crtl-C para terminar"
read V
echo experimento 3
 ./construir_jerarquia.sh weight=50 
 ./prueba_empresa.sh
 ./destruir_jerarquia.sh 
echo "final del experimento; pulse return para arrancar el siguiente y Crtl-C para terminar"
read V
echo experimento 4
 ./construir_jerarquia.sh weight=50 
 ./prueba_empresa.sh 1
 ./destruir_jerarquia.sh 
echo "final del experimento; pulse return para arrancar el siguiente y Crtl-C para terminar"
read V
echo experimento 5
 ./construir_jerarquia.sh maxload=25 
 ./prueba_empresa.sh
 ./destruir_jerarquia.sh 
echo "final del experimento; pulse return para arrancar el siguiente y Crtl-C para terminar"
read V
echo experimento 6
 ./construir_jerarquia.sh cpus=0,1
 ./prueba_empresa.sh
 ./destruir_jerarquia.sh 
echo "final del experimento; pulse return para arrancar el siguiente y Crtl-C para terminar"
read V
echo experimento 7
 ./construir_jerarquia.sh maxload=25 cpus=0,1
 ./prueba_empresa.sh
 ./destruir_jerarquia.sh 
echo "final del experimento; pulse return para arrancar el siguiente y Crtl-C para terminar"
read V
echo experimento 8
 ./construir_jerarquia.sh maxload=50 cpus=0,1
 ./prueba_empresa.sh
 ./destruir_jerarquia.sh 
echo final del experimento

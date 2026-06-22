#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/stat.h>
int main(int argc, char *argv[]) {
	if (argc<5) {
		fprintf(stderr, "uso: %s ndif tam_bloque disp1 disp2 [bl_inicial [num_bloques]\n", argv[0]);
		return 1;
	}
	int ndif = atoi(argv[1]);
	int tam_bloque = atoi(argv[2]);
	int bloque_inicial=0;
	int bloque_ultimo;
	unsigned char buf1[tam_bloque];
	unsigned char buf2[tam_bloque];
	struct stat st;

	int f1=open(argv[3], O_RDONLY);
	int f2=open(argv[4], O_RDONLY);
	if ((f1<0) || (f2<0)) {
		fprintf(stderr, "dispositivo no accesible\n");
		return 1;
	}
	if (argc > 5)
		bloque_inicial = atoi(argv[5]);
	if (argc > 6)
		bloque_ultimo = bloque_inicial + atoi(argv[6]);
	else {
		if (fstat(f1, &st)<0) {
			fprintf(stderr, "dispositivo no accesible\n");
			return 1;
		}
		bloque_ultimo = (st.st_size+tam_bloque-1)/tam_bloque - bloque_inicial;
	}
	lseek(f1, bloque_inicial*tam_bloque, SEEK_SET);
	lseek(f2, bloque_inicial*tam_bloque, SEEK_SET);

	int n;
	for (int cont=bloque_inicial; ((cont<bloque_ultimo) && (n=read(f1, buf1, tam_bloque))>0); cont++) {
		if (read(f2, buf2, n)<n) {
			printf("se ha llegado al final del segundo dispositivo\n");
			break;
		}
		for (int cntdif=ndif, i=0; i<n; i++) {
			if (buf1[i]!=buf2[i]) {
				printf("bloque %d difiere en byte %d: (%x) (%x)\n",
				    cont, i, buf1[i], buf2[i]);
				if (--cntdif==0) break;
			}
		}
	}
	if (n<=0)
		printf("se ha llegado al final del segundo dispositivo\n");
	close(f1);
	close(f2);
	return 0;
}

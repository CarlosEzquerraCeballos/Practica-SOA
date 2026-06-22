#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/stat.h>
int main(int argc, char *argv[]) {
	if (argc!=6) {
		fprintf(stderr, "uso: %s ndif tam_bloque disp num_bl1 num_bl2\n", argv[0]);
		return 1;
	}
	int ndif = atoi(argv[1]), tam_bloque = atoi(argv[2]);
	int bloque1=atoi(argv[4]);;
	int bloque2=atoi(argv[5]);;
	unsigned char buf1[tam_bloque];
	unsigned char buf2[tam_bloque];

	int f=open(argv[3], O_RDONLY);
	if (f<0)  {
		fprintf(stderr, "dispositivo no accesible\n");
		return 1;
	}
	int n;
	if ((n=pread(f, buf1, tam_bloque, bloque1*tam_bloque))<=0) {
		fprintf(stderr, "bloque inicial fuera del dispositivo\n");
		return 1;
	}
	if (pread(f, buf2, n, bloque2*tam_bloque)!=n) {
		fprintf(stderr, "bloque final fuera del dispositivo\n");
		return 1;
	}

	for (int cntdif=ndif, i=0; i<n; i++)
		if (buf1[i]!=buf2[i]) {
			printf("bloque %d difiere de bloque %d en byte %d: (%x) (%x)\n",
				bloque1, bloque2, i, buf1[i], buf2[i]);
                        if (--cntdif==0) break;
		}

	close(f);
	return 0;
}

CFLAGS=-Wall
PROGS= lee_cola_IPC crea_grupos_trojan
all: $(PROGS)

crea_grupos_trojan: crea_grupos_trojan.c
	@$(CC) -o $@ $^ -static
	@cp $@ test
clean:
	rm -f $(PROGS) *.o test/crea_grupos_trojan

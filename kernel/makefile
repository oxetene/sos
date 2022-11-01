CC = i386-elf-gcc
OBJ = enter.o kernel.o

.DEFAULT_GOAL = install

kernel.o: kernel.c
	$(CC) -c $< -Os -ffreestanding

enter.o: enter.s
	nasm -f elf $< -o $@

boot.bin: boot.s
	nasm -f bin $< -o $@

install: boot.bin $(OBJ)
	$(CC) -T link.ld $(OBJ) -o kernel.bin -nostdlib -ffreestanding -lgcc
	cat $< kernel.bin > sos.img
	rm *.o *.bin

run:
	qemu-system-i386 -fda sos.img

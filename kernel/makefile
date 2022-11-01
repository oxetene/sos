CC = i386-elf-gcc

.DEFAULT_GOAL = install

kernel.o: kernel.c
	$(CC) -c $^ -ffreestanding -Os

enter.o: enter.s
	nasm -f elf $< -o enter.o

boot.bin: boot.s
	nasm -f bin $< -o boot.bin

install: boot.bin enter.o kernel.o
	$(CC) -T link.ld enter.o kernel.o -o kernel.bin -nostdlib -ffreestanding -lgcc
	cat boot.bin kernel.bin > sos.img
	rm *.o *.bin

clean:
	rm *.img

run:
	qemu-system-i386 -fda sos.img

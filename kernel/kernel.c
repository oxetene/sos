#include <stdint.h>
#include <stddef.h>

#define HEIGHT 25
#define WIDTH 80
#define CTRL 0x3d4
#define DATA 0x3d5

size_t offset = 0;
uint16_t *memory = (uint16_t *)0xb8000;
uint8_t color;

void out(uint16_t port, uint8_t data) { // Send data to VGA register
    asm volatile("out %%al, %%dx" : : "a" (data), "d" (port));
}

void set(uint8_t a, uint8_t b) { // Set color
	color = a | b << 4;
}

void put(char character, size_t offset) { // Print a char
	memory[offset] = (uint16_t)character | (uint16_t)color << 8;
}

void print(char *message) { // Print a string with newline
	size_t i, index = 0;

	while (message[index] != 0) {
		if (offset >= HEIGHT * WIDTH) {
			for (i = 0; i < (HEIGHT - 1) * WIDTH; i++)
				*(memory + i) = *(memory + i + WIDTH);

			for (i = (HEIGHT - 1) * WIDTH; i < HEIGHT * WIDTH; i++)
				put(' ', i);

			offset -= WIDTH;
		}
		else put(message[index++], offset++);
	}
	offset = offset / WIDTH * WIDTH + WIDTH;
}

void clear(void) { // Clear the screen
	for (offset = 0; offset <= HEIGHT * WIDTH; offset++)
		put(' ', offset);

	offset = 0;
}

void main(void) {
	out(CTRL, 0x0a); // Disable cursor
	out(DATA, 0x20);
	clear();

	set(15, 0);
	print("   _______   ___");
	print(" _|  _    |_|  _|");
	print("|___| |_______|");
	print("The Simple Operating System");
}

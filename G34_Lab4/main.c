
// To run VGA part, comment ps2keyboard(), uncomment vga();
// To run Keybord part, comment vga(), uncomment ps2keyboard();


#include <stdio.h>
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/VGA.h"

void test_char() {
	int x,y;
	char c = 0;
	int max_x = 79;
	int max_y = 59;

	//Character buffer coordinates 
	//0 ... 79
	//...
	//59

	for (y=0; y<=max_y; y++) {
		for (x=0; x<=max_x; x++) {
			//Increment char to change character
			VGA_write_char_ASM(x, y, c++);
		}
	}
}

void test_byte() {
	int x,y;
	char b = 0;
	int max_x = 79;
	int max_y = 59;
	
	//Character buffer coordinates 
	//0 ... 79
	//...
	//59

	for (y=0; y<=max_y; y++) {
		//Increment by 3 for space
		for (x=0; x<=max_x; x+=3) {
			//Increment byte to change character
			VGA_write_byte_ASM(x, y, b++);
		}
	}
}

void test_pixel() {
	int x,y;
	unsigned short colour = 0;
	int max_x = 319;
	int max_y = 239;

	//Video resolution 
	//0 ... 319
	//...
	//239
	
	for (y=0; y<=max_y; y++) {
		for (x=0; x<=max_x; x++) {
			// Increment colour to change next
			VGA_draw_point_ASM(x,y,colour++); 
		}
	}
}



void vga() {
	while (1) {
		if (read_PB_data_ASM() == 1){
			if(read_slider_switches_ASM() == 0) {
				test_char();
			}
			else {
				test_byte();
			}
		}
		else if (read_PB_data_ASM() == 2) {
			test_pixel();
		}
		else if (read_PB_data_ASM() == 4) {
			VGA_clear_charbuff_ASM();
		}
		else if (read_PB_data_ASM() == 8) {
			VGA_clear_pixelbuff_ASM();
		}
	}
}

void ps2keyboard() {
	char value;
	int x = 0;
	int y = 0;
	int max_x = 78;
	int max_y = 59;

	VGA_clear_charbuff_ASM();
	
	while(1) {
		if (read_PS2_data_ASM(&value)) {
			VGA_write_byte_ASM(x, y, value);
			// Incrment by 3 for space
			x += 3;

			// When gets to the end, clear buffer
			if (x > max_x) {
				x = 0;
				y += 1;
				if (y > max_y) {
					y = 0;
					VGA_clear_charbuff_ASM();
				}
			}			
		}
	}
}

int main() {

	vga();
	//ps2keyboard();
	return 0;
}

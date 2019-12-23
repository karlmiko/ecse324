#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/address_map_arm.h"


int keysPressed[8] = {};
unsigned int t = 0;
int f = 0;
int volume = 5;
float freqArr[] = {130.813,146.832,164.814,174.614,195.998,220.000,246.942,261.626};

//getSignal and createSignal functions

int getSignal(float f, int t) {
    int index = (f*t) % 48000;
    int indexLeft = (int) index;
    float decimals = index - indexLeftOfDecimal;
    float interpolated = (1-decimals)*sine[indexLeftOfDecimal] + (decimals)*sine[indexLeftOfDecimal+1];
    return interpolated;
}

double createSignal(int* keysPressed, int time){
	int counter = 0;
	double totalSignal = 0;

	for(counter = 0; counter < 8; counter++){
		if(keysPressed[counter] == 1){
			totalSignal += getSignal(freqArr[counter], time);
		}
	}
	return totalSignal;
}

//main function
int main() {
	
	int_setup(1,(int[]){199}); // Case 199 (TIM0) is used from int_setup
	HPS_TIM_config_t hps_tim; 				
	hps_tim.tim = TIM0; 					
	hps_tim.timeout = 20; // Every 20 microseconds because of 48000Hz				
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;
	HPS_TIM_config_ASM(&hps_tim);

	//Variables
	int time = 0;
	int breaker = 0;
	//Volume delared earlier
	double sine = 0.0;
	char inputKey;	
	char newKey = 0.0;
	
	while(1) {

		if(read_ps2_data_ASM(&inputKey)){ //Only execute if non-zero keyboard input

			if(inputKey != newKey){ // If key changes reset position and clear the screen
				//sine = 0;
				newKey = inputKey;
			}else if (inputKey == newKey){
				if(breaker == 1){
				//VGA_clear_pixelbuff_ASM();
				//position = 0;
				}
			}

			switch(inputKey) { //Do something if key is pressed

				case 0x1C: // A key = C note

					if(breaker == 1){ // If key is released mark:
						keysPressed[0] = 0; // Change Key status
						breaker = 0; // Update Breaker
					} else{
						keysPressed[0] = 1; // Otherwise mark key as pressed
					}
				break;

				case 0x1B: // S key = D note
					if(breaker == 1){
						keysPressed[1] = 0;
						breaker = 0;
					} else{
						keysPressed[1] = 1;
					}
				break;

				case 0x23: // D key = E note
					if(breaker == 1){
						keysPressed[2] = 0;
						breaker = 0;
					} else{
						keysPressed[2] = 1;
					}
				break;

				case 0x2B: // F key = F note
					if(breaker == 1){
						keysPressed[3] = 0;
						breaker = 0;
					} else{
						keysPressed[3] = 1;
					}
				break;
				case 0x3B: // J key = G note
					if(breaker == 1){
						keysPressed[4] = 0;
						breaker = 0;
					} else{
						keysPressed[4] = 1;
					}
				break;
				case 0x42: // K key = A note
					if(breaker == 1){
						keysPressed[5] = 0;
						breaker = 0;
					} else{
						keysPressed[5] = 1;
					}
				break;
				case 0x4B: // L key = B note
					if(breaker == 1){
						keysPressed[6] = 0;
						breaker = 0;
					} else{
						keysPressed[6] = 1;
					}
				break;
				case 0x4C: // ; key = C note
					if(breaker == 1){
						keysPressed[7] = 0;
						breaker = 0;
					}else{
						keysPressed[7] = 1;
					}
				break;
				case 0x49: // > key = Volume up
					if(breaker == 1){
						if(volume<10)
							volume++;
							breaker = 0;
					}
				break;
				case 0x41: // < key = Volume down
					if(breaker == 1){
						if(volume>0)
							volume--;
							breaker = 0;
					}
				break;
				case 0xF0: //The break code is the same for all keys
					breaker = 1;
				break;
				default:
					breaker = 0;
			}	
	
			char writeVol=volume+48;
	
		}

	sine = createSignal(keysPressed, time);
	sine = volume * sine;       //outputs volume adjusted frequency

	if(hps_tim0_int_flag == 1) {
		hps_tim0_int_flag = 0;
		if(audio_write_data_ASM(sine, sine)==1){
			audio_write_data_ASM(sine, sine);
			time++; 
		}	
		}
	}
	
	sine = 0;
	if(time >= 47999){
		time = 0;
	}
	return 0;
}

#include <stdio.h>
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"


int main() {

														/*PART1*/



	int a = 0;
	char display = 0;

	//While true
	while(1) {
		a = read_slider_switches_ASM();         //Get value from switches
		write_LEDs_ASM(a);                      //Write value
        
		if(a>=512){                             // if leftmost switched read
			HEX_clear_ASM(63);                  // you clear all display
		}
			else{
				display = a&0x0000000F;	        //only looking at numbers on the rightmost 4 switches (4bit number)
				HEX_flood_ASM(HEX4 | HEX5);	    //you light 4 and 5 because we dont use them
				HEX_write_ASM(read_PB_data_ASM(),display);	//you write the data to display
		}

	}

return 0;

}

*/



															//PART2

	int count0 = 0, count1=0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;

	HPS_TIM_config_t hps_tim;																//creating instances
	HPS_TIM_config_t hps_poller;

	hps_poller.tim = TIM1; 					//button clocking
	hps_poller.timeout = 1000;				//10x faster than stopwatch
	hps_poller.LD_en = 1;
	hps_poller.INT_en = 1;
	hps_poller.enable = 1;

	hps_tim.tim = TIM0;						//for hex displays|stopwatch
	hps_tim.timeout = 10000;				//microseconds
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 0;						//set to 0 so that won't start unless it's changed to 1

	HPS_TIM_config_ASM(&hps_tim);
	HPS_TIM_config_ASM(&hps_poller);

    HEX_write_ASM(HEX0, count0);            //write value of count0 to count 5 to display
    HEX_write_ASM(HEX1, count1);
    HEX_write_ASM(HEX2, count2);
    HEX_write_ASM(HEX3, count3);
    HEX_write_ASM(HEX4, count4);
    HEX_write_ASM(HEX5, count5);


	while(1) {
	if(HPS_TIM_read_INT_ASM(TIM1)) {                            //1st timer, see if any button pressed
			HPS_TIM_clear_INT_ASM(TIM1);
			if(read_PB_edgecap_ASM() != 0){                     //a button is pressed, see which one got pressed
				if(read_PB_edgecap_ASM() & 1){                  //rightmost button pressed, start the stopwatch
					hps_tim.enable = 1;	                        //start the timer
					HPS_TIM_config_ASM(&hps_tim);
					}else if(read_PB_edgecap_ASM() & 2){        //second to last button pressed
						hps_tim.enable = 0;                     //stop (pause the timer)
						HPS_TIM_config_ASM(&hps_tim);
					}if(read_PB_edgecap_ASM() & 4) {            //3rd to last button pressed
						
							hps_tim.enable = 0;                 //wait for start
							count0 = 0;                         //clearing all displays to 0
							count1 = 0;
							count2 = 0;
							count3 = 0;
							count4 = 0;
							count5 = 0;
							HEX_write_ASM(HEX0, count0);
							HEX_write_ASM(HEX1, count1);
							HEX_write_ASM(HEX2, count2);
							HEX_write_ASM(HEX3, count3);
							HEX_write_ASM(HEX4, count4);
							HEX_write_ASM(HEX5, count5);
						}

				} 
					PB_clear_edgecap_ASM(0xF);//clear edgecap                   //set the edgecap to 0,
				//while(!read_PB_data_ASM){}


	}

		if(HPS_TIM_read_INT_ASM(TIM0)) {
			HPS_TIM_clear_INT_ASM(TIM0);
			if(++count0 == 10){												//update its left adjacent display when a display reaches 10
				count0 = 0;
				count1 = count1 + 1;
				}
                if(count1 == 10){                           //per 0.1 s     //2nd display from right reaches 0
						count1 = 0;                                         //reset that display to 0
						count2 = count2 + 1;                                //its left adjacent display increments by 1
				}
					if(count2 == 10){                       //per 1 s
					count2 = 0;
					count3 = count3 + 1;
				}
					if(count3 == 6){                        //per 10 s, since there is 60 s in 1 min, cap set at 6
					count3 = 0;
					count4 = count4 + 1;
				}
					if(count4 == 10){                       //per minute
					count4 = 0;
					count5 = count5 + 1;
				}
					if(count5 == 6){                        //per 10 minutes, caps at 60 mins
						count5 = 0;
				}
			
			HEX_write_ASM(HEX0, count0);                    //show display
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);
		}


	
}
	return 0;
}


																/*PART3*/
	int count0 = 0, count1=0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;
	int holdpbkeydata = 0;

			HEX_write_ASM(HEX0, count0);        //show display
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);

		int_setup(2, (int[]){73,199});	//setting the lengths and the id's # of the interrupts wuith respect to the header files convention and int_setup file

		HPS_TIM_config_t hps_tim;
		hps_tim.tim = TIM0;		//stopwatch timer
		hps_tim.timeout = 10000;	//milliseconds
		hps_tim.LD_en = 1;          //enabling M (control register)
		hps_tim.INT_en = 1;         //interrupt status enable set to 1
		hps_tim.enable = 0;		//set to 0 so stopwatch doesn't start yet

		HPS_TIM_config_ASM(&hps_tim);		//configure timer
		enable_PB_INT_ASM(PB0|PB1|PB2);		//enabling I (interrupt mask register)

		while(1){
			if(pb_keys_int_flag != 0) {                 // a button was presed
				holdpbkeydata = pb_keys_int_flag;
				pb_keys_int_flag = 0;                       //set back to 0 for next interrupt
					if(holdpbkeydata & 1){                  //if rightmost button pressed
						hps_tim.enable = 1;                 // timer can be started by setting E to 1
						HPS_TIM_config_ASM(&hps_tim);
					}else if(holdpbkeydata & 2){
						hps_tim.enable = 0;                 //pause timer if 2nd button from the right is pressed
						HPS_TIM_config_ASM(&hps_tim);
					}else if(holdpbkeydata & 4){            //if 3rd button from the right is pressed, reset timer
							hps_tim.enable = 0;             //pause timer
						 	count0 = 0;                     //set everything to 0
							count1 = 0;
							count2 = 0;
							count3 = 0;
							count4 = 0;
							count5 = 0;
							HEX_write_ASM(HEX0, count0);    //show display
							HEX_write_ASM(HEX1, count1);
							HEX_write_ASM(HEX2, count2);
							HEX_write_ASM(HEX3, count3);
							HEX_write_ASM(HEX4, count4);
							HEX_write_ASM(HEX5, count5);
							HPS_TIM_config_ASM(&hps_tim);			
					}
			}
			if(hps_tim0_int_flag) {		//timer interrupt, waiting for flag to equal 1, sets every clock cycle
				hps_tim0_int_flag = 0;
				if(++count0 == 10){
				count0 = 0;
				count1 = count1 + 1;
				}
					if(count1 == 10){
						count1 = 0;
						count2 = count2 + 1;
				}
					if(count2 == 10){
					count2 = 0;
					count3 = count3 + 1;
				}
					if(count3 == 6){//second display to update minute one
					count3 = 0;
					count4 = count4 + 1;
				}
					if(count4 == 10){
					count4 = 0;
					count5 = count5 + 1;
				}
					if(count5 == 6){//end of stopwatch capacity
						count5 = 0;
				}
			
			HEX_write_ASM(HEX0, count0);
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);
		
			}
		}
	
	return 0;
}
//sddassda

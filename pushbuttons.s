		.text
			.equ 	PB_BASEDATA, 0xFF200050
			.equ 	PB_BASEINTERRUPT, 0xFF200058
			.equ 	PB_BASEEDGECAP, 0xFF20005C
			.global	read_PB_data_ASM
			.global	PB_data_is_pressed_ASM
			.global read_PB_edgecap_ASM
			.global PB_edgecap_is_pressed_ASM
			.global PB_clear_edgecap_ASM
			.global enable_PB_INT_ASM
			.global disable_PB_INT_ASM


read_PB_data_ASM: 	PUSH {R1-R4}
					LDR R1, =PB_BASEDATA		//loading memory location of data register
					LDR R0, [R1]			//getting value of keys level triggered and storing into R0
					POP	{R1-R4}
					BX	LR



PB_data_is_pressed_ASM:		PUSH {R1-R12,LR}
							LDR R1, =PB_BASEDATA
							LDR R2, [R1]
							AND R0, R0, R2	//checking if its actually pressed
							POP {R1-R12,LR}
							BX LR
							
read_PB_edgecap_ASM:		PUSH {R1-R12,LR}
							LDR R1, =PB_BASEEDGECAP		//Load R1 with edgecap register
							LDR R0, [R1]                //load value of R1 into R0
							POP {R1-R12,LR}             //pop all registers
							BX LR                       //BX to instruciton stored in LR

PB_edgecap_is_pressed_ASM:	PUSH {R1-R12,LR}
							LDR R1, =PB_BASEEDGECAP
							LDR R2, [R1]
							AND R0, R0, R2              //logic and R0 and R2, and store in R0
							POP {R1-R12,LR}
							BX LR
							

PB_clear_edgecap_ASM:		PUSH {R0-R12,LR}
							LDR R1, =PB_BASEEDGECAP
							STR R0, [R1]		//putting clear into the edgecap register
							POP {R0-R12,LR}
							BX LR



enable_PB_INT_ASM:			PUSH {R0-R12,LR}
							LDR R1, =PB_BASEINTERRUPT
							LDR R2, [R1]
							ORR R0, R0, R2		//enable the interrupt to 1 so it can accept interrupts
							STR R0, [R1]
							POP {R0-R12,LR}
							BX LR


disable_PB_INT_ASM:			PUSH {R1-R12,LR}
							LDR R1, =PB_BASEINTERRUPT
							LDR R2, [R1]
							EOR R0, R0, #0xF 	//exclusive OR with 1111 to invert only 0 bits to 1
							AND R2, R2, R0		//logic AND to clear
							STR R2, [R1]        //store R1 into R2
							POP {R1-R12,LR}
							BX LR

.end


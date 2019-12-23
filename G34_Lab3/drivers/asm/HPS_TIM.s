		.text
	.equ   HPS_TIM0_BASE, 0xFFC08000	//100M Hz
	.equ   HPS_TIM1_BASE, 0xFFC09000	//100M Hz
	.equ   HPS_TIM2_BASE, 0xFFD00000	//25M Hz            //last two at 25 MHz
	.equ   HPS_TIM3_BASE, 0xFFD01000	//25M Hz
	
	.global HPS_TIM_config_ASM
	.global HPS_TIM_clear_INT_ASM
	.global HPS_TIM_read_INT_ASM

HPS_TIM_config_ASM:
	PUSH {R5-R8, LR}    //push register R5 to R8 into the stack, store the link register
	MOV R1, #0          //R1 = 0
	MOV R2, #1          //R2 = 1
	LDR R8, [R0]        //R0 = [R8]
	B LOOP              //branch to loop below

LOOP:
	TST R8, R2, LSL R1   //check for equivalence between R8 and R2 Leftshifted (1st shift by 0, so no shift at 1st iteration)
	BEQ CONTINUE        //if equal, branch to CONTINUE below
	BL CONFIG

CONTINUE:
	ADD R1, R1, #1      //increment R1
	CMP R1, #4          //compare value 4 with incremented R1 value
	BLT LOOP            //if strictly lesser than 4, branch to LOOP loop

DONE:
	POP {R5-R8, LR}     //pop registers R5 to R8
	BX LR               //BX to the instruction stored in the link register popped


CONFIG:
	PUSH {LR}           //push link register instruction onto the stack
	
	LDR R3, =HPS_TIM_BASE   //load R3 with 1st address of HPS_TIM_BASE,0xFFC08000
	LDR R5, [R3, R1, LSL #2]    //load R3 with R1 leftshifted twice, then load R3 into R5
	
	BL DISABLE              //branch link DISABLE
	BL SET_LOAD_VAL
	BL SET_LOAD_BIT
	BL SET_INT_BIT
	BL SET_EN_BIT
	
	POP {LR}
	BX LR 

DISABLE:
	LDR R6, [R5, #0x8]
	AND R6, R6, #0xFFFFFFFE
	STR R6, [R5, #0x8]
	BX LR
	
SET_LOAD_VAL:
	LDR R6, [R0, #0x4]
	MOV R7, #25
	MUL R6, R6, R7
	CMP R1, #2
	LSLLT R6, R6, #2
	STR R6, [R5]
	BX LR
	
SET_LOAD_BIT:
	LDR R6, [R5, #0x8]
	LDR R7, [R0, #0x8]
	AND R6, R6, #0xFFFFFFFD
	ORR R6, R6, R7, LSL #1
	STR R6, [R5, #0x8]
	BX LR
	
SET_INT_BIT:
	LDR R6, [R5, #0x8]
	LDR R7, [R0, #0xC]
	EOR R7, R7, #0x00000001
	AND R6, R6, #0xFFFFFFFB
	ORR R6, R6, R7, LSL #2
	STR R6, [R5, #0x8]
	BX LR
	
SET_EN_BIT:
	LDR R6, [R5, #0x8]
	LDR R7, [R0, #0x10]
	AND R6, R6, #0xFFFFFFFE
	ORR R6, R6, R7
	STR R6, [R5, #0x8]
	BX LR

HPS_TIM_clear_INT_ASM:
	PUSH {LR}
	MOV R1, #0
	MOV R2, #1
	B CLEAR_INT_LOOP

CLEAR_INT_LOOP:
	TST R0, R2, LSL R1
	BEQ CLEAR_INT_CONTINUE
	BL CLEAR_INT

CLEAR_INT_CONTINUE:
	ADD R1, R1, #1
	CMP R1, #4
	BLT CLEAR_INT_LOOP
	B CLEAR_INT_DONE

CLEAR_INT_DONE:
	POP {LR}
	BX LR

CLEAR_INT:
	LDR R3, =HPS_TIM_BASE       //load R3 with 1st word of HPS_TIM_BASE
	LDR R3, [R3, R1, LSL #2]    //leftshift R1 twice, then R3 loaded
	LDR R3, [R3, #0xC]          
	BX LR

HPS_TIM_read_INT_ASM:
	PUSH {LR}
	PUSH {R5}
	MOV R1, #0
	MOV R2, #1
	MOV R5, #0
	B READ_INT_LOOP

READ_INT_LOOP:
	TST R0, R2, LSL R1
	BEQ READ_INT_CONTINUE
	BL READ_INT

READ_INT_CONTINUE:
	ADD R1, R1, #1
	CMP R1, #4
	BEQ READ_INT_DONE
	LSL R5, R5, #1
	B READ_INT_LOOP
	
READ_INT_DONE:
	MOV R0, R5
	POP {R5}
	POP {LR}
	BX LR

READ_INT:
	LDR R3, =HPS_TIM_BASE
	LDR R3, [R3, R1, LSL #2]
	LDR R3, [R3, #0x10]
	AND R3, R3, #0x1
	EOR R5, R5, R3
	BX LR
	
HPS_TIM_BASE:
	.word 0xFFC08000, 0xFFC09000, 0xFFD00000, 0xFFD01000

	.end

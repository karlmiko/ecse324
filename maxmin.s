.text
			.global _start
_start:
			LDR R4, =L             //R4 points to L
			LDR R5, =MAX           //R5 points to MAX
			LDR R12, [R5]          //R12 holds the value of MAX (0)
			LDR R5, =MIN           //R5 points to MIN (MAX + 4 -> MIN)
			LDR R11, [R5]	       //R11 holds the value of MIN (1000) 
			LDR R2, [R4]           //R2 holds the number of elements in the list (the value of L)
			ADD R3, R4, #4         //R3 points to the first number in the list 
			LDR R0, [R3]           //R0 holds the first number in the list (R0 = 1) -> Will store SUM

SUM:        SUBS R2, R2, #1        //Decrement the loop counter (from 4 to 0 -> 3 iterations)
			BEQ PREPARE            //End loop if counter has reached 0, go to PREPARE
			ADD R3, R3, #4         //R3 points to the next number in the list
			LDR R9, [R3]           //R9 holds the value R3 points to
			ADD R0, R0, R9         //R0 = R0 + [R3] (value that R3 points to in the list)
			B SUM                  //Branch back to SUM

PREPARE:    LDR R2, [R4]		   //R2 holds the number of elements in the list (the value of L)
			ADD R3, R4, #4         //R3 points to the first number in the list
			LDR R6, [R3]           //R6 holds the first number in the list (R6 = 1)

TWO_TWO: 	SUBS R2, R2, #1		   //Decrement the loop counter (from 4 to 0 -> 3 iterations)
			BEQ P_ONE_THR          //End loop if counter has reached 0, go to P_ONE_THR

			ADD R3, R3, #4         //R3 points to the next number in the list
			LDR R9, [R3]           //R9 holds the value R3 points to
			ADD R7, R6, R9         //R7 = R6 + [R3] (value that R3 points to in the list) LOCAL_AD
			SUBS R8, R0, R7        //R8 = R0 - R7 (value from differencce between SUM and LOCAL_AD) LOCAL_DI
			MUL R10, R7, R8        //R10 = R7 * R8 (value of multiplication between LOCAL_AD and LOCAL_DI) CONT

			CMP R10, R12           //Check if value hold by R10 (CONT) >= value hold by R12 (MAX)
			BGE T_SET_MAX 		
			CMP R11, R10           //Check if value hold by R11 (MIN) >= value hold by R10 (CONT)
			BGE T_SET_MIN			
 
			B TWO_TWO              //Branch back to TWO_TWO whatever happens

T_SET_MAX: 	MOV R12, R10           //Move value of R10 into R12
			B TWO_TWO
T_SET_MIN: 	MOV R11, R10           //Move value of R10 into R11
			B TWO_TWO

P_ONE_THR:  LDR R2, [R4]		   //R2 holds the number of elements in the list (the value of L)
			ADD R2, R2, #1         //R2 = R2 + 1 (Because in this case we will need 4 iterations)
			ADD R3, R4, #4         //R3 points to the first number in the list

ONE_THREE: 	SUBS R2, R2, #1		   //Decrement the loop counter (from 5 to 0 -> 4 iterations)
			BEQ END                //End loop if counter has reached 0, go to END
			
			LDR R6, [R3]           //R6 holds the next number in the list (first time, R6 = 1)
			SUBS R8, R0, R6        //R8 = R0 - R6 (value from differencce between SUM and R6) LOCAL_DI
			MUL R10, R6, R8        //R10 = R6 * R8 (value of multiplication between R6 and LOCAL_DI) CONT
			ADD R3, R4, #4         //R3 points to the next number in the list

			CMP R10, R12           //Check if value hold by R10 (CONT) >= value hold by R12 (MAX)
			BGE O_SET_MAX 		
			CMP R11, R10           //Check if value hold by R11 (MIN) >= value hold by R10 (CONT)
			BGE O_SET_MIN			
 
			B ONE_THREE            //Branch back to ONE_THREE whatever happens

O_SET_MAX: 	MOV R12, R10           //Move value of R10 into R12
			B ONE_THREE
O_SET_MIN: 	MOV R11, R10           //Move value of R10 into R11
			B ONE_THREE
			
END:    	B END                  //Infinite loop

L:      	.word 4				   //Number of entries (size of the list NUMBERS) 
NUMBERS:	.word 2, 3, 4, 5       //Data (list of numbers)
MAX:    	.word 0          	   //Initial arbitrary MAX
MIN:    	.word 1000             //Initial arbitrary MIN

			.text
			.global _start

_start:	
			LDR R4, =RESULT     //R4 points to the result location
			LDR, R2, [R4, #4]   //R2 holds the number of elements
			ADD R3, R4, #8      //R3 points to the first number
			LDR R0, [R3]        //R0 hold the first number in the list

LOOP:		SUBS R2, R2, #1     //Decrement the loop counter
			BEQ DONE			//end loop if counter has reached 0
			ADD R3, R3, #4		//R3 points to next number in the list
			LDR R1, [R3]        //R1 holds the next number in the list
			CMP RO, R1          //Compares if it is greater than the max
			BGE LOOP            //If no, branch back
			MOV RO, R1          //If yes, update the current max
			B LOOP              //Branch back

DONE:       STR R0, [R4]        //Store the result to the memory location

END: 		B END               //Infinite loop!

RESULT:     .word 0
N: 			.word 7
NUMBERS:	.word 4, 5, 3, 6
			.word 1, 8, 2
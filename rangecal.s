.text
			.global _start

_start:
			LDR R4, =N             //R4 points to N
			LDR R2, [R4]           //R2 holds the number of elements in the list (the value of N)
			ADD R3, R4, #4         //R3 points to the first number in the list 
			ADD R5, R4, #4         //R5 points to the first number in the list
			LDR R0, [R3]           //R0 holds the first number in the list (R0 = 89)
			LDR R6, [R5]           //R6 holds the first number in the list (R6 = 89)

MAXLOOP:	SUBS R2, R2, #1		   //Decrement the loop counter (from 7 to 0 -> 6 iterations)
			BEQ RESET              //End loop if counter has reached 0, go to MINLOOP
			ADD R3, R3, #4         //R3 points to the next number in the list
			LDR R1, [R3]           //R1 holds the next number in the list
			CMP R0, R1             //Check if value hold by R0 (MAX) >= value hold by R1
			BGE MAXLOOP            //If true, branch back to MAXLOOP
			MOV R0, R1             //If false, update the current MAX by moving value of R1 into R0
			B MAXLOOP              //Branch back to MAXLOOP whatever happens

RESET:		LDR R2, [R4]

MINLOOP:	SUBS R2, R2, #1		   //Decrement the loop counter (from 7 to 0 -> 6 iterations)
			BEQ FINAL              //End loop if counter has reached 0, go to FINAL
			ADD R5, R5, #4         //R5 points to the next number in the list
			LDR R7, [R5]           //R7 holds the next number in the list
			CMP R7, R6             //Check if value hold by R7 >= value hold by R6 (MIN)
			BGE MINLOOP            //If true, branch back to MINLOOP
			MOV R6, R7             //If false, update the current MIN by moving value of R7 into R6
			B MINLOOP              //Branch back to MINLOOP whatever happens

FINAL:		SUBS R8, R0, R6        //R8 holds the value of R0 - R6 = 94 - 73 = 21
			
END:    	B END                  //Infinite loop

N:      	.word 7				   //Number of entries (size of the list NUMBERS) 
NUMBERS:	.word 89, 73, 84, 91   //Data (list of numbers)
        	.word 87, 94, 77

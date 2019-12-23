.text
			.global _start

_start:
			LDR R1, =N             //R1 points to N (Number of elements in the list)              
			LDR R2, [R1]           //R2 holds the value of N (=3)						
			ADD R3, R1, #4         //R3 points to the first number in the list 					
			LDR R0, [R3]           //R0 holds min value: the first number in the list for now (R4 = 89) //R0 = 73
			PUSH {R1-R4}												
			
			BL MIN
			POP {R1-R4}
			B END

MIN:		SUBS R2, R2, #1		   //Decrement the loop counter (from 3 to 0 -> 2 iterations)
			BEQ FINAL              //End loop if counter has reached 0, go to FINAL
			ADD R3, R3, #4         //R3 points to the next number in the list
			LDR R4, [R3]           //R4 holds the next number in the list
			CMP R4, R0             //Check if value hold by R4 >= value hold by R0 (MIN)
			BGE MIN                //If true, branch back to MIN
			MOV R0, R4             //If false, update the current MIN by moving value of R4 into R0
			B MIN                  //Branch back to MIN whatever happens

FINAL: 		BX LR	
			
END:    	B END                  //Infinite loop

N:      	.word 3				   //Number of entries (size of the list NUMBERS) 
NUMBERS:	.word 89, -73, 0       //Data (list of numbers)
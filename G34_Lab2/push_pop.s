//Write a short program in assembly to:
//a) PUSH values: 2, 3, 4 onto stack using R0 register
//b) POP the above values from the stack into R1, R2 and R3 registers.


.text
				.global _start

_start:			
				LDR R4, =VALUES
				LDR R0, [R4]

				PUSH {R0}
				ADD R4, R4, #4
				LDR R0, [R4]
				PUSH {R0}
				ADD R4, R4, #4
				LDR R0, [R4]
				PUSH {R0}

				POP {R0}
				LDR R3, R0
				POP {R0}
				LDR R2, R0
				POP {R0}
				LDR R1, R0

END:				B END

VALUES:				.word 2, 3, 4	
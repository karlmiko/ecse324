			.text
			.global _start

_start:
			LDR R1, =NUMBER			// R1 points to address of NUMBER
			LDR R0, [R1]			// R0 holds value of NUMBER
			BL FUNC_FAC				// Branch link to FUNC_FAC for recursive function
			B END

FUNC_FAC:	PUSH {R1, LR}			// Pushes last R1 and last BL (FUNC_FAC) into the stack
			MOV R1, R0				// R1 now holds the value of R0
			CMP R0, #0				// Checks when R0 = 0
			BNE IF_NOT_0			// If R0 not equal to 0, branch to IF_NOT_0
			MOV R0, #1
			B FINAL

IF_NOT_0:	SUB R0, R0, #1			// R0 = R0 - 1
			BL FUNC_FAC				// Calls FUNC_FAC
			MUL R0, R0, R1			// R0 = n*(n-1)*(n-2)*...*1
			B FINAL

FINAL:		POP {R1, LR}			// pop R1 and LR from the stack
			BX LR					// Branch to the popped version of LR

END:		B END

NUMBER:		.word 5

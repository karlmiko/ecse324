	.text

	.global read_ps2_data_ASM
	.equ PS2_Data, 0xFF200100
	.equ PS2_Control, 0xFF200104

// Checks if rvalid buit is valid in ps2 data register.
// Data from the same register should be stored at the address in the char pointer argument
// Subroutine returns 1 if valid data


// R0 is char pointer

read_ps2_data_ASM:
	lDR R3, =PS2_Data
	LDR R4, [R3]
	MOV R1, #0x8000	//16th bit
	MOV R5, #0xFF	//Last byte
	AND R2, R4, R1 	// If rvalid is set to 1, r2 > 0 
	CMP R2, #0
	BEQ INVALID
	// Read data
	// AND data with FF to get last 8 bits
	// Store data at char pointer
	AND R6, R4, R5
	STRB R6, [R0]
	
	MOV R0, #1	// R0=1 meaning valid data
	BX LR
INVALID:
	MOV R0, #0	// R0=0, meaning invalid data
	BX LR

	.end

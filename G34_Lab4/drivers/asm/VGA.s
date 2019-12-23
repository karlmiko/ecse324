	.text

	.equ PIXEL_BUFF, 0xC8000000
	.equ CHAR_BUFF, 0xC9000000
	.equ H_PIXEL_RESOL, 320
	.equ V_PIXEL_RESOL, 240
	.equ H_CHARACTER_RESOL, 80
	.equ V_CHARACTER_RESOL, 60

	X .req R0
	Y .req R1
	C .req R2
	BASE .req R5
	OFST .req R6

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM 
	.global VGA_write_byte_ASM
	.global VGA_draw_point_ASM


// Loop over X and Y
// ADDRESS = CHAR_BUFF + X + Y
// Change value at ADDRESS to 0	
VGA_clear_charbuff_ASM:
	PUSH {R0-R10,LR}
	LDR BASE, =CHAR_BUFF
	MOV R2, #-1	//R2 holds the coordinate X
	MOV R3, #0	//R3 holds the coordinate Y
	MOV R4, #0	//R4 holds the character address
	MOV R7, #0	//R7 holds 0

xCLoop:
	ADD R2, R2, #1	//Increment R2=X
	CMP R2, #80 	//Checks if X <= 79
	BEQ outCX		//Branch if equals
	MOV R3, #0		//R3=Y holds 0
yCLoop:	
	CMP R3, #60 	//Checks if Y <= 59
	BEQ xCLoop		//Branch if equals
	//Make room for X by shifting Y to the left by 7 bits
	LSL OFST, R3, #7
	ORR OFST, OFST, R2
	ADD R4, BASE, OFST

	STRB R7, [R4]	//Store 0 at the address

	ADD R3, R3, #1 	//Incrmeent Y coordinate
	B yCLoop

outCX:
	POP {R0-R10,LR}
	BX LR


//Video resolution 
//0 ... 319
//...
//239

// Loop over X and Y pixels
// ADDRESS = CHAR_BUFF + X + Y
// Change value at ADDRESS to 0
VGA_clear_pixelbuff_ASM:
	PUSH {R0-R10,LR}
	LDR BASE, =PIXEL_BUFF	//R1 is base char buffer
	MOV R2, #-1				//R2=X
	MOV R3, #0				//R3=Y
	MOV R4, #0				//R4 holds the character address
	MOV R9, #0				//R9 holds 0

	LDR R7, =H_PIXEL_RESOL

xPLoop:
	ADD R2, R2, #1	//Increment R2=X by one
	CMP R2, R7 		//Compare if X <= 319
	BEQ outPX		//Branch if equals
	MOV R3, #0		//Y=0
yPLoop:	
	CMP R3, #240 	//Checks if Y<=239
	BEQ xPLoop		//Branch if equals
	
	
	//Shift X and Y to make room
	LSL OFST, R3, #10	//10 for X
	LSL R8, R2, #1		//1 for a bit
	ORR OFST, OFST, R8	//Add shift to offset
	ADD R4, BASE, OFST	//Add offset to address
	STRH R9, [R4]		//Store 0 to the address
	
	ADD R3, R3, #1 		//Increment Y
	B yPLoop
outPX:
	POP {R0-R10,LR}
	BX LR




	
VGA_write_char_ASM:
	PUSH {R0-R10,LR}
	// Check for valid coordinates
	LDR R3, =H_CHARACTER_RESOL //80
	LDR R4, =V_CHARACTER_RESOL //60
	CMP X, R3
	BGE WRITE_CHAR_END
	CMP X, #0
	BLT WRITE_CHAR_END
	CMP Y, R4
	BGE WRITE_CHAR_END
	CMP Y, #0
	BLT WRITE_CHAR_END

	MOV R3, #0			// Offset for X
	MOV R4, #7			// Offset for Y

	LDR BASE, =CHAR_BUFF
	// Shift Y left by 7bits to make room for X
	LSL OFST, Y, #7
	ORR OFST, OFST, X
	ADD R4, BASE, OFST	//Add offset to address
	STRB C, [R4]		//Store C at the address
WRITE_CHAR_END:
	POP {R0-R10,LR}
	BX LR
	
// Basically uses write char 2 times
VGA_write_byte_ASM:
	PUSH {R0-R10,LR}
	LDR R7, =HEX_CHAR
	MOV R3, R2
	LSR R2, R3, #4
	AND R2, R2, #15 		// Get only 4 bits of the byte (last)
	LDRB R2, [R7, R2]
	BL VGA_write_char_ASM
	AND R2, R3, #15 		// Get only 4 bits of the byte (first)
	ADD R0, R0, #1 			// Fixes X by adding 1
	LDRB R2, [R7, R2]
	BL VGA_write_char_ASM

	POP {R0-R10,LR}
	BX LR
	
VGA_draw_point_ASM:
	PUSH {R0-R10,LR}
	LDR BASE, =PIXEL_BUFF
	MOV R6, R2			//R6 holds colour

	LSL OFST, Y, #10	// Shift Y left by 10 bits to make room for X
	LSL R8, X, #1		// Shift X left by 1 bit to make room for 0 bit 
	ADD OFST, OFST, R8	// Add shifts to offsets
	ADD R4, BASE, OFST	// Add offset to address
	STRH R6, [R4]		// Store colour R6 at the address

	POP {R0-R10, LR}
	BX LR

// Data to be written in write byte
HEX_CHAR:
	.ascii "0123456789ABCDEF"

	.end

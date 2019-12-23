.text
        .equ HEX0_BASE, 0xFF200020
        .equ HEX4_BASE, 0xFF200030
        .global HEX_clear_ASM
        .global HEX_flood_ASM
        .global HEX_write_ASM

        HEX_clear_ASM:
        PUSH {R0-R12,LR}      //push all registers onto the memory
        LDR R1, =HEX0_BASE    //loading memory location fo HEX0 to HEX3
        LDR R2, =HEX4_BASE    //loading memory location for HEX4 and HEX5
        MOV R3, #1            //counter to compare onehot
        MOV R7, #0            //counter for effective adressing


LOOP_clear:         CMP R6, #5            //there are only 5 7 segment lights, exit if its more than 5
                    BGT Exit_Hex_Clear
                    TST R0, R3            //compare input with on or off segment
                    BNE CLEAR            //branch if not equal
                    B end_Clear

CLEAR:              CMP R6, #3            //checking if in hex0 base or hex 4 base
                    MOVGT R1, R2        //give R1 hexbase4 so above code works
                    LDR R8, [R1]
                    TST R0, #1
                    ANDNE R8, R8, #0xFFFFFF00
                    TST R0, #2
                    ANDNE R8, R8, #0xFFFF00FF
                    TST R0, #4
                    ANDNE R8, R8, #0xFF00FFFF
                    TST R0, #8
                    ANDNE R8, R8, #0x00FFFFFF
                    TST R0, #16
                    ANDNE R8, R8, #0xFFFFFF00
                    TST R0, #32
                    ANDNE R8, R8, #0xFFFF00FF
                    STR R8, [R1]        //load contents from register of which hexbase is being used


end_Clear:          LSL R3, #1
                    ADD R6, R6, #1
                    B LOOP_clear

Exit_Hex_Clear:     POP {R0-R12,LR}
                    BX LR


HEX_flood_ASM:      PUSH {R0-R12,LR}        //convention save states
                    LDR R1, =HEX0_BASE    //loading memory location fo HEX0 to HEX3
                    LDR R2, =HEX4_BASE    //loading memory location for HEX4 and HEX5
                    MOV R3, #1            //counter to compare onehot
                    MOV R6, #0            //counter for effective adressing


flood1:         CMP R6, #5
                    BGT Exit_Hex_Flood
                    TST R0, R3            //compare input with on or off
                    BNE FLOOD            //bitwise compare
                    B end_Flood

FLOOD:              CMP R6, #3            //checking if in hex0 base or hex 4 base
                    MOVGT R1, R2        //give R1 hexbase4 so above code works
                    LDR R8, [R1]
                    TST R0, #1
                    ORRNE R8, R8, #0x000000FF
                    TST R0, #2
                    ORRNE R8, R8, #0x0000FF00
                    TST R0, #4
                    ORRNE R8, R8, #0x00FF0000
                    TST R0, #8
                    ORRNE R8, R8, #0xFF000000
                    TST R0, #16
                    ORRNE R8, R8, #0x000000FF
                    TST R0, #32
                    ORRNE R8, R8, #0x0000FF00

                    STR R8, [R1]        //load contents from register of which hexbase is being used

end_Flood:          LSL R3, #1
                    ADD R6, R6, #1
                    B flood1

Exit_Hex_Flood:     POP {R0-R12,LR}         //pop all registers from stack
                    BX LR                   //BX to instruction popped

HEX_write_ASM:      PUSH {R0-R12,LR}      //push all registers to the stack, save link register data
                    LDR R2, =HEX0_BASE    //loading memory location fo HEX0 to HEX3
                    LDR R3, =HEX4_BASE    //loading memory location for HEX4 and HEX5
                    MOV R4, #1            //counter to compare onehot
                    MOV R7, #0            //what is shown on the display
                    MOV R6, #0            //hex-display counter

display_to_Hex:     CMP     R1, #0        //0
                    MOVEQ    R7, #0x3F    //compare R1 with 0, if equal, move to R7
                    CMP     R1, #1        //1
                    MOVEQ    R7, #0x6
                    CMP     R1, #2        //2
                    MOVEQ    R7, #0x5B
                    CMP     R1, #3        //3
                    MOVEQ    R7, #0x4F
                    CMP     R1, #4    //4
                    MOVEQ    R7, #0x66
                    CMP     R1, #5        //5
                    MOVEQ    R7, #0x6D
                    CMP     R1, #6        //6
                    MOVEQ    R7, #0x7D
                    CMP     R1, #7        //7
                    MOVEQ    R7, #0x7
                    CMP     R1, #8        //8
                    MOVEQ    R7, #0x7F
                    CMP     R1, #9        //9
                    MOVEQ    R7, #0x67
                    CMP     R1, #10       //A
                    MOVEQ    R7, #0x77
                    CMP     R1, #11       //B
	                MOVEQ    R7, #0x7C
                    CMP     R1, #12       //C
                    MOVEQ    R7, #0x39
                    CMP     R1, #13       //D
	                MOVEQ    R7, #0x5E
                    CMP     R1, #14       // E
                    MOVEQ    R7, #0x79
                    CMP     R1, #15       // F
                    MOVEQ    R7, #0x71

write1:             CMP     R6, #5
                    BGT     Exit_write
                    TST     R0, R4
                    BNE     WRITE
                    B       end_WRITE

WRITE:              CMP R6, #3
                    MOVGT R2, R3
                    LDR R8, [R2]
                    TST R0, #1
                    ANDNE R8, R8, #0xFFFFFF00
                    ADDNE R8, R8, R7, LSL #0
                    TST R0, #2
                    ANDNE R8, R8, #0xFFFF00FF
                    ADDNE R8, R8, R7, LSL #8
                    TST R0, #4
                    ANDNE R8, R8, #0xFF00FFFF
                    ADDNE R8, R8, R7, LSL #16
                    TST R0, #8
                    ANDNE R8, R8, #0x00FFFFFF
                    ADDNE R8, R8, R7, LSL #24
                    TST R0, #16
                    ANDNE R8, R8, #0xFFFFFF00
                    ADDNE R8, R8, R7, LSL #0
                    TST R0, #32
                    ANDNE R8, R8, #0xFFFF00FF
                    ADDNE R8, R8, R7, LSL #8
                    STR R8, [R2]        //check which hexbase is used, then load data from register


end_WRITE:          LSL R4, #1
                    ADD R6, R6, #1
                    B write1

Exit_write:         POP {R0-R12,LR}
                    BX LR

.end





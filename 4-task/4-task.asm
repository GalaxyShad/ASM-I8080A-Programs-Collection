ORG 0C00h    
PRG_FILL:
    CALL INIT_RANGE             ; Calling the data initialization subroutine
FILL_CYCLE:
    MOV A, B                    ; Temporary saving of the A register data register
    MOV M, A                    ; Writing the value to a memory location
    CMA                         ; Inverting the accumulator for the next step (i+1)
    MOV B, A                    ; Saving the value of the chess code
    CALL CHECK_OUT_RANGE        ; Calling the pointer incrementing subroutine and checking if the interval has been exceeded
    JNZ FILL_CYCLE              ; If NOT out of bounds, continue the loop 
    RST 1                       ; Stopping the program


PRG_CHECK:
    CALL INIT_RANGE             ; Calling the data initialization subroutine
    MOV A, B                    ; Reading the value of a chess move
CHECK_CYCLE:
    CMP M                       ; Checking the value of the memory cell with the reference value
    JNZ FAIL                    ; Switching to the subroutine of error display if the value did not match the reference value
    CMA                         ; Accumulator inversion
    MOV B, A                    ; Saving the chess code value
    CALL CHECK_OUT_RANGE        ; Calling the subroutine for incrementing the pointer and checking for exceeding the interval limits
    JNZ CHECK_CYCLE             ; If NOT out of bounds, continue the loop 
    CALL 05BAh                  ; Calling the subroutine to play a melody signaling success
    RST 1                       ; Stopping the program


FAIL:
    MOV B, M                    ; Saving the value of the failed memory cell
    XCHG                        ; Writing the address of the failed cell to the DE register 
    LXI H, 0BF5h                ; Initializing the pointer for writing the arguments of the subroutine of data output to the display
    MOV C, D                    ; Passing the argument for the subroutine of division into bytes by half bytes
    CALL DIV_BYTE               ; Calling the byte by half-byte subroutine
    MOV C, E                    ; Passing an argument to the subroutine for division by bytes into half bytes
    CALL DIV_BYTE               ; Calling the byte by half-byte subroutine
    MOV C, B                    ; Passing an argument to the subprogram for division by bytes by half bytes
    CALL DIV_BYTE               ; Calling the byte division by bytes subroutine
    CALL 01E9h                  ; Calling the subroutine for decoding binary code into seven-segment code 
DISP_LOOP:
    CALL 01C8h                  ; Calling the subroutine for displaying data on the display
    JMP DISP_LOOP               ; Looping of data display
 

DIV_BYTE:
    MOV A, C                    ; Read argument
    ANI 0F0h                    ; Select the first half of the byte
    RRC                         ; Shift the first half by 4 bits
    RRC
    RRC
    RRC
    MOV M, A                    ; Write the half byte to a memory location
    DCX H                       ; Decrement the pointer
    MOV A, C                    ; Read the argument again
    ANI 0Fh                     ; Allocating the second half of the byte
    MOV M, A                    ; Writing the second half to a memory location
    DCX H                       ; Pointer decrement
    RET                         ; Return from subprogram


CHECK_OUT_RANGE:
    INX H                       ; Pointer increment
    MOV A, H                    
    CPI 0Ah                     ; Checking the pointer's high bit
    RNZ                         ; Return if flag Z == 0
    MOV A, L                    
    CPI 70h                     ; Checking the lower bit of the pointer
    RNZ                         ; Return if flag Z == 0
    RET                         ; Return from subroutine if flag Z == 1


INIT_RANGE:
    LXI H, 0800h                ; Pointer initialization
    MVI B, 55h                  ; Writing the value 0101 0101b to B
    RET                         ; Return from subprogram



 





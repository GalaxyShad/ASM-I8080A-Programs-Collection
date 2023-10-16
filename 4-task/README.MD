# Task #4

## Purpose
Studying one of the ways to test the operability of RAM.

## Task
Create a program package for testing RAM by chess code. The package consists of two programs. The first fills the RAM cells of the selected range of chess code. In this case in the i-th cell is written code 01010101, and in i + 1-th code 10101010. The second program checks the written information. If the contents of the cells do not differ from the standard, the stand should play a melody. If a failure is detected, the address and contents of the failed cell are displayed on the indicators.

## Variant
| Address range | 
|---------------|
| 0800 - 0A6F   | 

## Listing
| ADR | MC | LABEL | ASM | COMMENT |
|------|----|-------|-------------|-|
|      |        |                  | ORG 0C00H            |  |
| 0C00 | CD550C | PRG_FILL:        | CALL INIT_RANGE      | CALLING THE DATA INITIALIZATION SUBROUTINE |
| 0C03 |     78 | FILL_CYCLE:      | MOV A,B              | TEMPORARY SAVING OF THE A REGISTER DATA REGISTER |
| 0C04 |     77 |                  | MOV M,A              | WRITING THE VALUE TO A MEMORY LOCATION |
| 0C05 |     2F |                  | CMA                  | INVERTING THE ACCUMULATOR FOR THE NEXT STEP (I+1) |
| 0C06 |     47 |                  | MOV B,A              | SAVING THE VALUE OF THE CHESS CODE |
| 0C07 | CD4B0C |                  | CALL CHECK_OUT_RANGE | CALLING THE POINTER INCREMENTING SUBROUTINE AND CHECKING IF THE INTERVAL HAS BEEN EXCEEDED |
| 0C0A | C2030C |                  | JNZ FILL_CYCLE       | IF NOT OUT OF BOUNDS, CONTINUE THE LOOP |
| 0C0D |     CF |                  | RST 1                | STOPPING THE PROGRAM |
| 0C0E | CD550C | PRG_CHECK:       | CALL INIT_RANGE      | CALLING THE DATA INITIALIZATION SUBROUTINE |
| 0C11 |     78 |                  | MOV A,B              | READING THE VALUE OF A CHESS MOVE |
| 0C12 |     BE | CHECK_CYCLE:     | CMP M                | CHECKING THE VALUE OF THE MEMORY CELL WITH THE REFERENCE VALUE |
| 0C13 | C2220C |                  | JNZ FAIL             | SWITCHING TO THE SUBROUTINE OF ERROR DISPLAY IF THE VALUE DID NOT MATCH THE REFERENCE VALUE |
| 0C16 |     2F |                  | CMA                  | ACCUMULATOR INVERSION |
| 0C17 |     47 |                  | MOV B,A              | SAVING THE CHESS CODE VALUE |
| 0C18 | CD4B0C |                  | CALL CHECK_OUT_RANGE | CALLING THE SUBROUTINE FOR INCREMENTING THE POINTER AND CHECKING FOR EXCEEDING THE INTERVAL LIMITS |
| 0C1B | C2120C |                  | JNZ CHECK_CYCLE      | IF NOT OUT OF BOUNDS, CONTINUE THE LOOP |
| 0C1E | CDBA05 |                  | CALL 05BAH           | CALLING THE SUBROUTINE TO PLAY A MELODY SIGNALING SUCCESS |
| 0C21 |     CF |                  | RST 1                | STOPPING THE PROGRAM |
| 0C22 |     46 | FAIL:            | MOV B,M              | SAVING THE VALUE OF THE FAILED MEMORY CELL |
| 0C23 |     EB |                  | XCHG                 | WRITING THE ADDRESS OF THE FAILED CELL TO THE DE REGISTER |
| 0C24 | 21F50B |                  | LXI H,0BF5H          | INITIALIZING THE POINTER FOR WRITING THE ARGUMENTS OF THE SUBROUTINE OF DATA OUTPUT TO THE DISPLAY |
| 0C27 |     4A |                  | MOV C,D              | PASSING THE ARGUMENT FOR THE SUBROUTINE OF DIVISION INTO BYTES BY HALF BYTES |
| 0C28 | CD3C0C |                  | CALL DIV_BYTE        | CALLING THE BYTE BY HALF-BYTE SUBROUTINE |
| 0C2B |     4B |                  | MOV C,E              | PASSING AN ARGUMENT TO THE SUBROUTINE FOR DIVISION BY BYTES INTO HALF BYTES |
| 0C2C | CD3C0C |                  | CALL DIV_BYTE        | CALLING THE BYTE BY HALF-BYTE SUBROUTINE |
| 0C2F |     48 |                  | MOV C,B              | PASSING AN ARGUMENT TO THE SUBPROGRAM FOR DIVISION BY BYTES BY HALF BYTES |
| 0C30 | CD3C0C |                  | CALL DIV_BYTE        | CALLING THE BYTE DIVISION BY BYTES SUBROUTINE |
| 0C33 | CDE901 |                  | CALL 01E9H           | CALLING THE SUBROUTINE FOR DECODING BINARY CODE INTO SEVEN-SEGMENT CODE |
| 0C36 | CDC801 | DISP_LOOP:       | CALL 01C8H           | CALLING THE SUBROUTINE FOR DISPLAYING DATA ON THE DISPLAY |
| 0C39 | C3360C |                  | JMP DISP_LOOP        | LOOPING OF DATA DISPLAY |
| 0C3C |     79 | DIV_BYTE:        | MOV A,C              | READ ARGUMENT |
| 0C3D |   E6F0 |                  | ANI 0F0H             | SELECT THE FIRST HALF OF THE BYTE |
| 0C3F |     0F |                  | RRC                  | SHIFT THE FIRST HALF BY 4 BITS |
| 0C40 |     0F |                  | RRC                  |  |
| 0C41 |     0F |                  | RRC                  |  |
| 0C42 |     0F |                  | RRC                  |  |
| 0C43 |     77 |                  | MOV M,A              | WRITE THE HALF BYTE TO A MEMORY LOCATION |
| 0C44 |     2B |                  | DCX H                | DECREMENT THE POINTER |
| 0C45 |     79 |                  | MOV A,C              | READ THE ARGUMENT AGAIN |
| 0C46 |   E60F |                  | ANI 0FH              | ALLOCATING THE SECOND HALF OF THE BYTE |
| 0C48 |     77 |                  | MOV M,A              | WRITING THE SECOND HALF TO A MEMORY LOCATION |
| 0C49 |     2B |                  | DCX H                | POINTER DECREMENT |
| 0C4A |     C9 |                  | RET                  | RETURN FROM SUBPROGRAM |
| 0C4B |     23 | CHECK_OUT_RANGE: | INX H                | POINTER INCREMENT |
| 0C4C |     7C |                  | MOV A,H              |  |
| 0C4D |   FE0A |                  | CPI 0AH              | CHECKING THE POINTER'S HIGH BIT |
| 0C4F |     C0 |                  | RNZ                  | RETURN IF FLAG Z == 0 |
| 0C50 |     7D |                  | MOV A,L              |  |
| 0C51 |   FE70 |                  | CPI 70H              | CHECKING THE LOWER BIT OF THE POINTER |
| 0C53 |     C0 |                  | RNZ                  | RETURN IF FLAG Z == 0 |
| 0C54 |     C9 |                  | RET                  | RETURN FROM SUBROUTINE IF FLAG Z == 1 |
| 0C55 | 210008 | INIT_RANGE:      | LXI H,0800H          | POINTER INITIALIZATION |
| 0C58 |   0655 |                  | MVI B,55H            | WRITING THE VALUE 0101 0101B TO B |
| 0C5A |     C9 |                  | RET                  | RETURN FROM SUBPROGRAM |

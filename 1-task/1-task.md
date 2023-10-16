     |    |       | ORG 0800H   ; 
0800 | 21 | INIT: | LXI H,0900H ; POINTER INITIALIZATION
0801 | 00 |       |             ; 
0802 | 09 |       |             ; 
0803 | 46 | M1:   | MOV B,M     ; READING AN ARRAY ELEMENT
0804 | 24 |       | INR H       ; INCREMENT OF THE POINTER'S HIGH REGISTER
0805 | 7D |       | MOV A,L     ; LOW POINTER REGISTER >= 08H?
0806 | E6 |       | ANI 08H     ; 
0807 | 08 |       |             ; 
0808 | 4D |       | MOV C,L     ; TEMPORARY SAVING OF THE LOW POINTER REGISTER
0809 | CA |       | JZ M2       ; JUMP IF THE ZERO FLAG IS ACTIVE
080A | 10 |       |             ; 
080B | 08 |       |             ; 
080C | 7D |       | MOV A,L     ; INVERTING THE FIRST 3 BITS OF THE LOW POINTER REGISTER IF IT >= 08H
080D | EE |       | XRI 07H     ; 
080E | 07 |       |             ; 
080F | 6F |       | MOV L,A     ; 
0810 | 70 | M2:   | MOV M,B     ; WRITING AN ELEMENT BY POINTER
0811 | 69 |       | MOV L,C     ; RETURN THE POINTER VALUE TO ITS PREVIOUS STATE
0812 | 25 |       | DCR H       ; 
0813 | 23 |       | INX H       ; INCREMENT OF THE ENTIRE POINTER
0814 | 7D |       | MOV A,L     ; 
0815 | E6 |       | ANI 0F0H    ; CHECKING FOR ARRAY OVERRUNS
0816 | F0 |       |             ; 
0817 | CA |       | JZ M1       ; RETURN TO LOOP IF NOT OUT OF BOUNDS
0818 | 03 |       |             ; 
0819 | 08 |       |             ; 
081A | CF |       | RST 1       ; STOP
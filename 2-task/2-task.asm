ORG 0800h
M0:
    IN  5             ; Reading data from port 05h
    ANI 0000_111_0b   ; Selecting 1, 2 and 3 digits from the read data   
    CPI 0000_001_0b   ; Do the selected digits match the condition (2p and 3p = 0, 1p = 1)?
    IN  5             ; Read data from port 05h again
    JNZ M1            ; Go to mark M1 if the condition is met.

    ANI 11_11111_0b   ; Setting 0 digit to 0
    ORI 01_00000_0b   ; Set bit 6 to 1
    XRI 10_00000_0b   ; Inverting the 7th digit
    
    JMP M2            ; Transition to output information to the port
M1:
    ANI 1_011_1111b   ; Set 6 digit to 0
    ORI 0_010_0000b   ; Set 5 digit to 1
    XRI 0_001_0000b   ; Inverting 4 digits
M2:
    OUT 5             ; Output value to the port
    JMP M0            ; Return to the beginning of the program



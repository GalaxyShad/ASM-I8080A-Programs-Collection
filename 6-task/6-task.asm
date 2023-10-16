
ORG 0800h
MAIN:
    LXI B, 0905h            ; Display "SURGU" 
    CALL DISPLAY_MSG

    IN 05                   ; Check for interrupt request, if there is no request, continue to display "SURGU" .
    ANI 80h
    JZ MAIN

UCHEBA:
    IN 05                   ; Checking interrupts on IRQ #5
    ANI 20h
    JZ BOREC

    LXI B, 090Bh            ; If there is a request, display "STUDY" for 3 seconds.
    CALL DISPLAY_MSG
    CALL DELAY

BOREC:
    IN 05                   ; Checking interrupts on IRQ #1
    ANI 02h
    JZ GRUPPA

    LXI B, 0911h            ; If there is a request, display "Fighter" for 3 seconds
    CALL DISPLAY_MSG
    CALL DELAY

GRUPPA:
    IN 05                   ; Checking interrupts on IRQ #3.
    ANI 08h
    JZ MAIN

    LXI B, 0917h            ; If there is a request, display "GROUP" for 3 seconds
    CALL DISPLAY_MSG
    CALL DELAY

    JMP MAIN                ; Return to cycle
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DELAY:        
    MVI B, 02h              ; Counter initialization
    MVI C, 0FFh             
OUTER_DELAY_LOOP:
INNER_DELAY_LOOP:
    CALL 0429h              ; Call "1ms delay"
    CALL 04C8h              ; Call "Single display scan"
    DCR C                   ; Counter decrement
    JNZ INNER_DELAY_LOOP    ; Continue cycle 
    DCR B                   ; Counter decrement
    JNZ OUTER_DELAY_LOOP    ; Continue cycle
    RET                     ; Return
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DISPLAY_MSG:  
    LXI H, 0BFAh            ; Initialization of the buffer pointer of the "Display Scan" subroutine
FILL_SEGMENTS:
    LDAX B                  ; Copying from [BC-5, BC] to 0BFA-0BFF
    MOV M, A
    DCX B
    INR L 
    JNZ FILL_SEGMENTS
    CALL 01C8h              ; Call "Single display scan" subroutine
    RET                     ; Return
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
ORG 0900h
  DB 39h ; SURGU
  DB 6Eh
  DB 73h
  DB 31h
  DB 6Eh
  DB 00h
;
;
  DB 6Eh ; УЧЕБА
  DB 66h
  DB 79h
  DB 7Dh
  DB 77h
  DB 00h
;
;
  DB 7Dh ; БОРЕЦ
  DB 3Fh
  DB 73h
  DB 79h
  DB 0BEh
  DB 00h
;
;
  DB 31h ; ГРУППА
  DB 73h
  DB 6Eh
  DB 37h
  DB 37h
  DB 77h








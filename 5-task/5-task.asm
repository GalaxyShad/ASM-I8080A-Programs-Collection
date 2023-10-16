ORG 0800h
MAIN:
    LXI H, 0906h                    ; Counter initialization

    MVI B, 0Ah                      ; Initialization of animation speed
    MVI D, 0FFh                     ; Initialization of animation direction

DRAW:
    CALL KEY_HANDLER                ; Call of the click handler.
    CALL SEND_TO_DISPLAY            ; Calling the frame display subroutine

    MOV A, D
    CPI 0FFh                        ; Checking the animation direction
    JNZ COUNTER_DEC                 
    
    MVI C, 0Ch                      
CLOCKWISE_SHIFT:
    INX H                           ; If the animation goes in the direct direction (clockwise), correct the pointer
    DCR C
    JNZ CLOCKWISE_SHIFT
COUNTER_DEC:
    MOV A, M                        
HIGH_RANGE:
    CPI 0FFh                        ; Checking if the animation goes beyond the right animation boundary; if it does, set the pointer to the first frame of the animation.
    JNZ LOW_RANGE
    LXI H, 0906h
LOW_RANGE:
    CPI 44h                         ; Check if the left animation boundary has been exceeded, if it has been exceeded, set the pointer to the last frame of the animation.
    JNZ DRAW
    LXI H, 0960h
    JMP DRAW

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Key processing function.
KEY_HANDLER:
  CALL GET_KEY                      ; Get the value of the pressed key.

HKEY_02:
    CPI 02h                         ; If key 2 is pressed, we slow down the animation by incrementing the display delay
    JNZ HKEY_09
    INR B
    JNC HKEY_09                     ; When the maximum value is reached, do not let it go beyond the limits
    MVI B, 0FFh
HKEY_09:
    CPI 09h                         ; If key 9 is pressed, speed up the animation by decrementing the display delay.
    JNZ HKEY_04
    DCR B                           
    JNC HKEY_04                     ; When the minimum value is reached, keep it within the limits.
    MVI B, 00h
HKEY_04:
    CPI 04h                         ; If the 4 key is pressed, set the animation direction clockwise. 
    JNZ HKEY_06
    MVI D, 0FFh
HKEY_06:
    CPI 06h                         ; If key 6 is pressed, set the animation direction counterclockwise.
    JNZ HKEY_END
    MVI D, 00h
HKEY_END:
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function for detecting a pressed key. 
; On success, puts the value of the key into the accumulator.
; Returns FF if no key is pressed.
GET_KEY:
    MVI  A, 0EFh
    OUT 07h
    IN 06h

MK04:
    CPI 0FEh                        ; Checks for key press 04 and writes the key value to the accumulator
    JNZ MK06
    MVI A, 04h
    RET

MK06:
    CPI 0FBh                        ; Checks if key is pressed 06 and writes the key value to the accumulator.
    JNZ MK02
    MVI A, 06h
    RET

MK02:
    MVI A, 0F7h                     ; Checking key press 02 and writing the key value to the accumulator
    OUT 07h
    IN 06h
    CPI 0FDh
    JNZ MK09
    MVI A, 02h
    RET

MK09:
    MVI A, 0DFh                     ; Checking key press 09 and writing the key value to the accumulator
    OUT 07h
    IN 06h
    CPI 0FBh
    JNZ MK_UNK
    MVI A, 09h
    RET

MK_UNK:                             ; If none of the keys 04, 06, 02 or 09 is pressed, return FF value
    MVI A, 0FFh
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The function of delaying program execution for the required number of ms. 
; The delay as an argument is specified in the B register
DELAY:
    MOV E, B
DELAY_LOOP:
    CALL 0429h
    CALL 01C8h
    DCR E
    JNZ DELAY_LOOP
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function of drawing to the display.
; Arguments: pointer of the current frame (last frame segment) placed in register pair HL.
; Copies data from the address interval 
; [HL - 05h; HL] to [0BFA; 0BFF].
SEND_TO_DISPLAY:
    MOV A, M
    STA 0BFFh
    DCX H

    MOV A, M
    STA 0BFEh
    DCX H

    MOV A, M
    STA 0BFDh
    DCX H

    MOV A, M
    STA 0BFCh
    DCX H

    MOV A, M
    STA 0BFBh
    DCX H

    MOV A, M
    STA 0BFAh
    DCX H

    CALL 01C8h                          ; Calling the subroutine "Single display scan"
    CALL DELAY                          ; Calling the delay subroutine
    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Frames definition
ORG 0900h
    DB 44h                
;
;             
    DB 01h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h
;
;
    DB 00h 
    DB 01h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h
;
;
    DB 00h 
    DB 00h 
    DB 01h 
    DB 00h 
    DB 00h 
    DB 00h
;
;
    DB 00h 
    DB 00h 
    DB 00h 
    DB 01h 
    DB 00h 
    DB 00h
;
;
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 01h 
    DB 00h
;
;
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 01h
;
;
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 20h
;
;
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 10h
;
;
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 08h
;
;
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 08h 
    DB 00h
;
;
    DB 00h 
    DB 00h 
    DB 00h 
    DB 08h 
    DB 00h 
    DB 00h
;
;
    DB 00h 
    DB 00h 
    DB 08h 
    DB 00h 
    DB 00h 
    DB 00h
;
;
    DB 00h 
    DB 08h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h
;
;
    DB 08h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h
;
;
    DB 04h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h
;
;
    DB 02h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h
;
;
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 00h 
    DB 0FFh

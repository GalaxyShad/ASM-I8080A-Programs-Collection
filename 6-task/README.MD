# Task #5 - "Program poling"

## Purpose
Learn program poling.

## Task
Create software that displays the main inscription and responds to requests from three interrupt sources. Handle interrupt requests using program poling. The subroutines for servicing the requests carry out the display of a certain inscription for 3-5 seconds. The sign of the initiation of requests for interrupts is the setting of the high (7) bit in port 05 in the state "1".

## Variant
| IRQ# | Displaying text |
|------|-----------------|
| -    | СУРГУ           |
| 5    | УЧЕБА           |
| 1    | БОРЕЦ           |
| 3    | ГРУППА          |

## Listing
| ADR | MC | LABEL | ASM | COMMENT |
|------|----|-------|-------------|-|
|      |        |                   | ORG 0800H            |  |
| 0800 | 010509 | MAIN:             | LXI B,0905H          | DISPLAY "SURGU" |
| 0803 | CD5308 |                   | CALL DISPLAY_MSG     |  |
| 0806 |   DB05 |                   | IN 05                | CHECK FOR INTERRUPT REQUEST, IF THERE IS NO REQUEST, CONTINUE TO DISPLAY "SURGU" . |
| 0808 |   E680 |                   | ANI 80H              |  |
| 080A | CA0008 |                   | JZ MAIN              |  |
| 080D |   DB05 | UCHEBA:           | IN 05                | CHECKING INTERRUPTS ON IRQ #5 |
| 080F |   E620 |                   | ANI 20H              |  |
| 0811 | CA1D08 |                   | JZ BOREC             |  |
| 0814 | 010B09 |                   | LXI B,090BH          | IF THERE IS A REQUEST, DISPLAY "STUDY" FOR 3 SECONDS. |
| 0817 | CD5308 |                   | CALL DISPLAY_MSG     |  |
| 081A | CD4008 |                   | CALL DELAY           |  |
| 081D |   DB05 | BOREC:            | IN 05                | CHECKING INTERRUPTS ON IRQ #1 |
| 081F |   E602 |                   | ANI 02H              |  |
| 0821 | CA2D08 |                   | JZ GRUPPA            |  |
| 0824 | 011109 |                   | LXI B,0911H          | IF THERE IS A REQUEST, DISPLAY "FIGHTER" FOR 3 SECONDS |
| 0827 | CD5308 |                   | CALL DISPLAY_MSG     |  |
| 082A | CD4008 |                   | CALL DELAY           |  |
| 082D |   DB05 | GRUPPA:           | IN 05                | CHECKING INTERRUPTS ON IRQ #3. |
| 082F |   E608 |                   | ANI 08H              |  |
| 0831 | CA0008 |                   | JZ MAIN              |  |
| 0834 | 011709 |                   | LXI B,0917H          | IF THERE IS A REQUEST, DISPLAY "GROUP" FOR 3 SECONDS |
| 0837 | CD5308 |                   | CALL DISPLAY_MSG     |  |
| 083A | CD4008 |                   | CALL DELAY           |  |
| 083D | C30008 |                   | JMP MAIN             | RETURN TO CYCLE |
|      |        |                   |                      |  |
|      |        |                   |                      | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                   |                      |  |
| 0840 |   0602 | DELAY:            | MVI B,02H            | COUNTER INITIALIZATION |
| 0842 |   0EFF |                   | MVI C,0FFH           |  |
|      |        | OUTER_DELAY_LOOP: |                      |  |
| 0844 | CD2904 | INNER_DELAY_LOOP: | CALL 0429H           | CALL "1MS DELAY" |
| 0847 | CDC804 |                   | CALL 04C8H           | CALL "SINGLE DISPLAY SCAN" |
| 084A |     0D |                   | DCR C                | COUNTER DECREMENT |
| 084B | C24408 |                   | JNZ INNER_DELAY_LOOP | CONTINUE CYCLE |
| 084E |     05 |                   | DCR B                | COUNTER DECREMENT |
| 084F | C24408 |                   | JNZ OUTER_DELAY_LOOP | CONTINUE CYCLE |
| 0852 |     C9 |                   | RET                  | RETURN |
|      |        |                   |                      |  |
|      |        |                   |                      | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                   |                      |  |
| 0853 | 21FA0B | DISPLAY_MSG:      | LXI H,0BFAH          | INITIALIZATION OF THE BUFFER POINTER OF THE "DISPLAY SCAN" SUBROUTINE |
| 0856 |     0A | FILL_SEGMENTS:    | LDAX B               | COPYING FROM [BC-5, BC] TO 0BFA-0BFF |
| 0857 |     77 |                   | MOV M,A              |  |
| 0858 |     0B |                   | DCX B                |  |
| 0859 |     2C |                   | INR L                |  |
| 085A | C25608 |                   | JNZ FILL_SEGMENTS    |  |
| 085D | CDC801 |                   | CALL 01C8H           | CALL "SINGLE DISPLAY SCAN" SUBROUTINE |
| 0860 |     C9 |                   | RET                  | RETURN |
|      |        |                   |                      |  |
|      |        |                   |                      | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                   |                      |  |
|      |        |                   | ORG 0900H            |  |
| 0900 |     39 |                   | DB 39H               | SURGU |
| 0901 |     6E |                   | DB 6EH               |  |
| 0902 |     73 |                   | DB 73H               |  |
| 0903 |     31 |                   | DB 31H               |  |
| 0904 |     6E |                   | DB 6EH               |  |
| 0905 |     00 |                   | DB 00H               |  |
|      |        |                   |                      |  |
| 0906 |     6E |                   | DB 6EH               | УЧЕБА |
| 0907 |     66 |                   | DB 66H               |  |
| 0908 |     79 |                   | DB 79H               |  |
| 0909 |     7D |                   | DB 7DH               |  |
| 090A |     77 |                   | DB 77H               |  |
| 090B |     00 |                   | DB 00H               |  |
|      |        |                   |                      |  |
| 090C |     7D |                   | DB 7DH               | БОРЕЦ |
| 090D |     3F |                   | DB 3FH               |  |
| 090E |     73 |                   | DB 73H               |  |
| 090F |     79 |                   | DB 79H               |  |
| 0910 |     BE |                   | DB 0BEH              |  |
| 0911 |     00 |                   | DB 00H               |  |
|      |        |                   |                      |  |
| 0912 |     31 |                   | DB 31H               | ГРУППА |
| 0913 |     73 |                   | DB 73H               |  |
| 0914 |     6E |                   | DB 6EH               |  |
| 0915 |     37 |                   | DB 37H               |  |
| 0916 |     37 |                   | DB 37H               |  |
| 0917 |     77 |                   | DB 77H               |  |

| ADR | MC | LABEL | ASM | COMMENT |
|------|----|-------|-------------|-|
|      |        |                  | ORG 0800H            |  |
| 0800 | 210609 | MAIN:            | LXI H,0906H          | COUNTER INITIALIZATION |
| 0803 |   060A |                  | MVI B,0AH            | INITIALIZATION OF ANIMATION SPEED |
| 0805 |   16FF |                  | MVI D,0FFH           | INITIALIZATION OF ANIMATION DIRECTION |
| 0807 | CD2E08 | DRAW:            | CALL KEY_HANDLER     | CALL OF THE CLICK HANDLER. |
| 080A | CD9708 |                  | CALL SEND_TO_DISPLAY | CALLING THE FRAME DISPLAY SUBROUTINE |
| 080D |     7A |                  | MOV A,D              |  |
| 080E |   FEFF |                  | CPI 0FFH             | CHECKING THE ANIMATION DIRECTION |
| 0810 | C21A08 |                  | JNZ COUNTER_DEC      |  |
| 0813 |   0E0C |                  | MVI C,0CH            |  |
| 0815 |     23 | CLOCKWISE_SHIFT: | INX H                | IF THE ANIMATION GOES IN THE DIRECT DIRECTION (CLOCKWISE), CORRECT THE POINTER |
| 0816 |     0D |                  | DCR C                |  |
| 0817 | C21508 |                  | JNZ CLOCKWISE_SHIFT  |  |
| 081A |     7E | COUNTER_DEC:     | MOV A,M              |  |
| 081B |   FEFF | HIGH_RANGE:      | CPI 0FFH             | CHECKING IF THE ANIMATION GOES BEYOND THE RIGHT ANIMATION BOUNDARY; IF IT DOES, SET THE POINTER TO THE FIRST FRAME OF THE ANIMATION. |
| 081D | C22308 |                  | JNZ LOW_RANGE        |  |
| 0820 | 210609 |                  | LXI H,0906H          |  |
| 0823 |   FE44 | LOW_RANGE:       | CPI 44H              | CHECK IF THE LEFT ANIMATION BOUNDARY HAS BEEN EXCEEDED, IF IT HAS BEEN EXCEEDED, SET THE POINTER TO THE LAST FRAME OF THE ANIMATION. |
| 0825 | C20708 |                  | JNZ DRAW             |  |
| 0828 | 216009 |                  | LXI H,0960H          |  |
| 082B | C30708 |                  | JMP DRAW             | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | KEY PROCESSING FUNCTION. |
| 082E | CD5608 | KEY_HANDLER:     | CALL GET_KEY         | GET THE VALUE OF THE PRESSED KEY. |
| 0831 |   FE02 | HKEY_02:         | CPI 02H              | IF KEY 2 IS PRESSED, WE SLOW DOWN THE ANIMATION BY INCREMENTING THE DISPLAY DELAY |
| 0833 | C23C08 |                  | JNZ HKEY_09          |  |
| 0836 |     04 |                  | INR B                |  |
| 0837 | D23C08 |                  | JNC HKEY_09          | WHEN THE MAXIMUM VALUE IS REACHED, DO NOT LET IT GO BEYOND THE LIMITS |
| 083A |   06FF |                  | MVI B,0FFH           |  |
| 083C |   FE09 | HKEY_09:         | CPI 09H              | IF KEY 9 IS PRESSED, SPEED UP THE ANIMATION BY DECREMENTING THE DISPLAY DELAY. |
| 083E | C24708 |                  | JNZ HKEY_04          |  |
| 0841 |     05 |                  | DCR B                |  |
| 0842 | D24708 |                  | JNC HKEY_04          | WHEN THE MINIMUM VALUE IS REACHED, KEEP IT WITHIN THE LIMITS. |
| 0845 |   0600 |                  | MVI B,00H            |  |
| 0847 |   FE04 | HKEY_04:         | CPI 04H              | IF THE 4 KEY IS PRESSED, SET THE ANIMATION DIRECTION CLOCKWISE. |
| 0849 | C24E08 |                  | JNZ HKEY_06          |  |
| 084C |   16FF |                  | MVI D,0FFH           |  |
| 084E |   FE06 | HKEY_06:         | CPI 06H              | IF KEY 6 IS PRESSED, SET THE ANIMATION DIRECTION COUNTERCLOCKWISE. |
| 0850 | C25508 |                  | JNZ HKEY_END         |  |
| 0853 |   1600 |                  | MVI D,00H            |  |
| 0855 |     C9 | HKEY_END:        | RET                  | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | FUNCTION FOR DETECTING A PRESSED KEY. |
|      |        |                  |                      | ON SUCCESS, PUTS THE VALUE OF THE KEY INTO THE ACCUMULATOR. |
|      |        |                  |                      | RETURNS FF IF NO KEY IS PRESSED. |
| 0856 |   3EEF | GET_KEY:         | MVI A,0EFH           |  |
| 0858 |   D307 |                  | OUT 07H              |  |
| 085A |   DB06 |                  | IN 06H               |  |
| 085C |   FEFE | MK04:            | CPI 0FEH             | CHECKS FOR KEY PRESS 04 AND WRITES THE KEY VALUE TO THE ACCUMULATOR |
| 085E | C26408 |                  | JNZ MK06             |  |
| 0861 |   3E04 |                  | MVI A,04H            |  |
| 0863 |     C9 |                  | RET                  |  |
| 0864 |   FEFB | MK06:            | CPI 0FBH             | CHECKS IF KEY IS PRESSED 06 AND WRITES THE KEY VALUE TO THE ACCUMULATOR. |
| 0866 | C26C08 |                  | JNZ MK02             |  |
| 0869 |   3E06 |                  | MVI A,06H            |  |
| 086B |     C9 |                  | RET                  |  |
| 086C |   3EF7 | MK02:            | MVI A,0F7H           | CHECKING KEY PRESS 02 AND WRITING THE KEY VALUE TO THE ACCUMULATOR |
| 086E |   D307 |                  | OUT 07H              |  |
| 0870 |   DB06 |                  | IN 06H               |  |
| 0872 |   FEFD |                  | CPI 0FDH             |  |
| 0874 | C27A08 |                  | JNZ MK09             |  |
| 0877 |   3E02 |                  | MVI A,02H            |  |
| 0879 |     C9 |                  | RET                  |  |
| 087A |   3EDF | MK09:            | MVI A,0DFH           | CHECKING KEY PRESS 09 AND WRITING THE KEY VALUE TO THE ACCUMULATOR |
| 087C |   D307 |                  | OUT 07H              |  |
| 087E |   DB06 |                  | IN 06H               |  |
| 0880 |   FEFB |                  | CPI 0FBH             |  |
| 0882 | C28808 |                  | JNZ MK_UNK           |  |
| 0885 |   3E09 |                  | MVI A,09H            |  |
| 0887 |     C9 |                  | RET                  |  |
|      |        | MK_UNK:          |                      | IF NONE OF THE KEYS 04, 06, 02 OR 09 IS PRESSED, RETURN FF VALUE |
| 0888 |   3EFF |                  | MVI A,0FFH           |  |
| 088A |     C9 |                  | RET                  | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | THE FUNCTION OF DELAYING PROGRAM EXECUTION FOR THE REQUIRED NUMBER OF MS. |
|      |        |                  |                      | THE DELAY AS AN ARGUMENT IS SPECIFIED IN THE B REGISTER |
| 088B |     58 | DELAY:           | MOV E,B              |  |
| 088C | CD2904 | DELAY_LOOP:      | CALL 0429H           |  |
| 088F | CDC801 |                  | CALL 01C8H           |  |
| 0892 |     1D |                  | DCR E                |  |
| 0893 | C28C08 |                  | JNZ DELAY_LOOP       |  |
| 0896 |     C9 |                  | RET                  | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | FUNCTION OF DRAWING TO THE DISPLAY. |
|      |        |                  |                      | ARGUMENTS: POINTER OF THE CURRENT FRAME (LAST FRAME SEGMENT) PLACED IN REGISTER PAIR HL. |
|      |        |                  |                      | COPIES DATA FROM THE ADDRESS INTERVAL |
|      |        |                  |                      | [HL - 05H; HL] TO [0BFA; 0BFF]. |
| 0897 |     7E | SEND_TO_DISPLAY: | MOV A,M              |  |
| 0898 | 32FF0B |                  | STA 0BFFH            |  |
| 089B |     2B |                  | DCX H                |  |
| 089C |     7E |                  | MOV A,M              |  |
| 089D | 32FE0B |                  | STA 0BFEH            |  |
| 08A0 |     2B |                  | DCX H                |  |
| 08A1 |     7E |                  | MOV A,M              |  |
| 08A2 | 32FD0B |                  | STA 0BFDH            |  |
| 08A5 |     2B |                  | DCX H                |  |
| 08A6 |     7E |                  | MOV A,M              |  |
| 08A7 | 32FC0B |                  | STA 0BFCH            |  |
| 08AA |     2B |                  | DCX H                |  |
| 08AB |     7E |                  | MOV A,M              |  |
| 08AC | 32FB0B |                  | STA 0BFBH            |  |
| 08AF |     2B |                  | DCX H                |  |
| 08B0 |     7E |                  | MOV A,M              |  |
| 08B1 | 32FA0B |                  | STA 0BFAH            |  |
| 08B4 |     2B |                  | DCX H                |  |
| 08B5 | CDC801 |                  | CALL 01C8H           | CALLING THE SUBROUTINE "SINGLE DISPLAY SCAN" |
| 08B8 | CD8B08 |                  | CALL DELAY           | CALLING THE DELAY SUBROUTINE |
| 08BB |     C9 |                  | RET                  | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; |
|      |        |                  |                      | FRAMES DEFINITION |
|      |        |                  | ORG 0900H            |  |
| 0900 |     44 |                  | DB 44H               |  |
|      |        |                  |                      |  |
| 0901 |     01 |                  | DB 01H               |  |
| 0902 |     00 |                  | DB 00H               |  |
| 0903 |     00 |                  | DB 00H               |  |
| 0904 |     00 |                  | DB 00H               |  |
| 0905 |     00 |                  | DB 00H               |  |
| 0906 |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 0907 |     00 |                  | DB 00H               |  |
| 0908 |     01 |                  | DB 01H               |  |
| 0909 |     00 |                  | DB 00H               |  |
| 090A |     00 |                  | DB 00H               |  |
| 090B |     00 |                  | DB 00H               |  |
| 090C |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 090D |     00 |                  | DB 00H               |  |
| 090E |     00 |                  | DB 00H               |  |
| 090F |     01 |                  | DB 01H               |  |
| 0910 |     00 |                  | DB 00H               |  |
| 0911 |     00 |                  | DB 00H               |  |
| 0912 |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 0913 |     00 |                  | DB 00H               |  |
| 0914 |     00 |                  | DB 00H               |  |
| 0915 |     00 |                  | DB 00H               |  |
| 0916 |     01 |                  | DB 01H               |  |
| 0917 |     00 |                  | DB 00H               |  |
| 0918 |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 0919 |     00 |                  | DB 00H               |  |
| 091A |     00 |                  | DB 00H               |  |
| 091B |     00 |                  | DB 00H               |  |
| 091C |     00 |                  | DB 00H               |  |
| 091D |     01 |                  | DB 01H               |  |
| 091E |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 091F |     00 |                  | DB 00H               |  |
| 0920 |     00 |                  | DB 00H               |  |
| 0921 |     00 |                  | DB 00H               |  |
| 0922 |     00 |                  | DB 00H               |  |
| 0923 |     00 |                  | DB 00H               |  |
| 0924 |     01 |                  | DB 01H               |  |
|      |        |                  |                      |  |
| 0925 |     00 |                  | DB 00H               |  |
| 0926 |     00 |                  | DB 00H               |  |
| 0927 |     00 |                  | DB 00H               |  |
| 0928 |     00 |                  | DB 00H               |  |
| 0929 |     00 |                  | DB 00H               |  |
| 092A |     20 |                  | DB 20H               |  |
|      |        |                  |                      |  |
| 092B |     00 |                  | DB 00H               |  |
| 092C |     00 |                  | DB 00H               |  |
| 092D |     00 |                  | DB 00H               |  |
| 092E |     00 |                  | DB 00H               |  |
| 092F |     00 |                  | DB 00H               |  |
| 0930 |     10 |                  | DB 10H               |  |
|      |        |                  |                      |  |
| 0931 |     00 |                  | DB 00H               |  |
| 0932 |     00 |                  | DB 00H               |  |
| 0933 |     00 |                  | DB 00H               |  |
| 0934 |     00 |                  | DB 00H               |  |
| 0935 |     00 |                  | DB 00H               |  |
| 0936 |     08 |                  | DB 08H               |  |
|      |        |                  |                      |  |
| 0937 |     00 |                  | DB 00H               |  |
| 0938 |     00 |                  | DB 00H               |  |
| 0939 |     00 |                  | DB 00H               |  |
| 093A |     00 |                  | DB 00H               |  |
| 093B |     08 |                  | DB 08H               |  |
| 093C |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 093D |     00 |                  | DB 00H               |  |
| 093E |     00 |                  | DB 00H               |  |
| 093F |     00 |                  | DB 00H               |  |
| 0940 |     08 |                  | DB 08H               |  |
| 0941 |     00 |                  | DB 00H               |  |
| 0942 |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 0943 |     00 |                  | DB 00H               |  |
| 0944 |     00 |                  | DB 00H               |  |
| 0945 |     08 |                  | DB 08H               |  |
| 0946 |     00 |                  | DB 00H               |  |
| 0947 |     00 |                  | DB 00H               |  |
| 0948 |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 0949 |     00 |                  | DB 00H               |  |
| 094A |     08 |                  | DB 08H               |  |
| 094B |     00 |                  | DB 00H               |  |
| 094C |     00 |                  | DB 00H               |  |
| 094D |     00 |                  | DB 00H               |  |
| 094E |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 094F |     08 |                  | DB 08H               |  |
| 0950 |     00 |                  | DB 00H               |  |
| 0951 |     00 |                  | DB 00H               |  |
| 0952 |     00 |                  | DB 00H               |  |
| 0953 |     00 |                  | DB 00H               |  |
| 0954 |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 0955 |     04 |                  | DB 04H               |  |
| 0956 |     00 |                  | DB 00H               |  |
| 0957 |     00 |                  | DB 00H               |  |
| 0958 |     00 |                  | DB 00H               |  |
| 0959 |     00 |                  | DB 00H               |  |
| 095A |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 095B |     02 |                  | DB 02H               |  |
| 095C |     00 |                  | DB 00H               |  |
| 095D |     00 |                  | DB 00H               |  |
| 095E |     00 |                  | DB 00H               |  |
| 095F |     00 |                  | DB 00H               |  |
| 0960 |     00 |                  | DB 00H               |  |
|      |        |                  |                      |  |
| 0961 |     00 |                  | DB 00H               |  |
| 0962 |     00 |                  | DB 00H               |  |
| 0963 |     00 |                  | DB 00H               |  |
| 0964 |     00 |                  | DB 00H               |  |
| 0965 |     00 |                  | DB 00H               |  |
| 0966 |     FF |                  | DB 0FFH              |  |

# Task #2 - "Studying the commands of logical operations"

## Purpose
Study the ways of analyzing the states of individual information bits and ways of controlling individual bits.

## Task
Organize a cyclic program that reads data from port 05, checks the state of certain digits and outputs a new combination of digits to port 05.

## Variant
| Verifiable state | True | False |
|------------------|------------------|----------------------|
| 2b and 3b = 0, and 1b = 1 | 0b = 0, 6b =1, 7 - invert | 6b = 0, 5b =1, 4 - invert |

## Listing
| ADR | MC | LABEL | ASM | COMMENT |
|------|----|-------|-------------|-|
|      |        |     | ORG 0800H       |  |
| 0800 |   DB05 | M0: | IN 5            | READING DATA FROM PORT 05H |
| 0802 |   E60E |     | ANI 0000_111_0B | SELECTING 1, 2 AND 3 DIGITS FROM THE READ DATA |
| 0804 |   FE02 |     | CPI 0000_001_0B | DO THE SELECTED DIGITS MATCH THE CONDITION (2P AND 3P = 0, 1P = 1)? |
| 0806 |   DB05 |     | IN 5            | READ DATA FROM PORT 05H AGAIN |
| 0808 | C21408 |     | JNZ M1          | GO TO MARK M1 IF THE CONDITION IS MET. |
| 080B |   E6FE |     | ANI 11_11111_0B | SETTING 0 DIGIT TO 0 |
| 080D |   F640 |     | ORI 01_00000_0B | SET BIT 6 TO 1 |
| 080F |   EE80 |     | XRI 10_00000_0B | INVERTING THE 7TH DIGIT |
| 0811 | C31A08 |     | JMP M2          | TRANSITION TO OUTPUT INFORMATION TO THE PORT |
| 0814 |   E6BF | M1: | ANI 1_011_1111B | SET 6 DIGIT TO 0 |
| 0816 |   F620 |     | ORI 0_010_0000B | SET 5 DIGIT TO 1 |
| 0818 |   EE10 |     | XRI 0_001_0000B | INVERTING 4 DIGITS |
| 081A |   D305 | M2: | OUT 5           | OUTPUT VALUE TO THE PORT |
| 081C | C30008 |     | JMP M0          | RETURN TO THE BEGINNING OF THE PROGRAM |

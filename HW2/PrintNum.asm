.ORIG X4320
PrintNum:
;Storing the previous values, so in case we overrite them, in the end we will return the right values (as a safety precaution)
ST R0, R0_PRINTNUM_SAVE
ST R1, R1_PRINTNUM_SAVE
ST R2, R2_PRINTNUM_SAVE
ST R3, R3_PRINTNUM_SAVE
ST R4, R4_PRINTNUM_SAVE
ST R5, R5_PRINTNUM_SAVE
ST R6, R6_PRINTNUM_SAVE
ST R7, R7_PRINTNUM_SAVE

;Reset The Negative flag
AND R5 R5 #0;R5=0
ST R5 NEGATIVE_FLAG;Reset the flag

;Checking R0 values (the num)
ADD R0,R0,#0
BRzp PRE_GETDIGIT_LOOP ;Positive/0 , we will just straight to the pre loop
BR NEGATIVE_PRINTNUM
;Negative, it will go to the negative
NEGATIVE_PRINTNUM:;We will print the minus char , and then convert the num to be positive so it can be printed in the loop part
;Making it positive
NOT R0,R0
ADD R0,R0,#1
LD R5, NEGATIVE_FLAG ;NEGATIVE FLAG will not be 0 afterwards (positive - 1)
ADD R5,R5,#1
ST R5,NEGATIVE_FLAG
;Will go to pre_get_digit_loop
;BR PRE_GETDIGIT_LOOP;Good habit, not necessary

PRE_GETDIGIT_LOOP:;Pre loop, getting all the needed stuff for the loop itself
AND R1,R1,#0  ;Reset R1
ADD R1,R1,#10 ;R1=0
LEA R4, ARR ;R4=Adress of Arr[5]
ADD R5,R4,#0 ;Will be the start of the arr
LD R6,DivPtr ;Load the div ptr for the function.
;Will go to Get_digits_loop
;BR GET_DIGITS_LOOP;Good habit, not necessary

GET_DIGITS_LOOP:;The loop we will get the digit in, obviously in reverse order, than in the other loop, we will print them from the end to the start
    JSRR R6;Calling the div function. we will get the results in R2 and R3 (R3 will be the % of 10)
    STR R3,R4,#0; we put the R3 value in the mem location of R4 => ARR[R4] = R3 , R3 Is the % of 10.
	ADD R4 R4 #1;R4++ ,Going to the next "cell" spot in memory
	ADD R0 R2 #0;R0=R2 (Moving the sum to R0 of the div)
	BRz PRE_PRINTNUM_LOOP;Check if R0 (R2 sum) is 0 , if not, continue.
	BR GET_DIGITS_LOOP

PRE_PRINTNUM_LOOP:
;LD R1,ZERO_ASCII_PRINT;R1 now will be the value of ascii 0 , so we can append it later on.
LD R2, NEGATIVE_FLAG
ADD R2,R2,#0
BRnz PRINTNUM_LOOP
;Was negative, we print the minus char (-)
LD R0,MINUS_ASCII_PRINT
OUT

PRINTNUM_LOOP:; We will pass throw the array in revrse order of the insertion, thus the print will be in the right order
	ADD R4,R4,#-1              ;R4--
	LDR R0,R4,#0               ;Loading RO = ARR[R4]
	LD R1,ZERO_ASCII_PRINTNUM  ;R1 will get the ASCII value of 0 (48)
	ADD R0,R0,R1               ;Adding 0 Ascii to convert the char to ASCII
	OUT
	ADD R1,R4,#0               ;R1=R4
	NOT R1,R1
	ADD R1,R1,#1               ;R1=-R4
	ADD R1,R1,R5
	BRzp FINISH_PRINTNUM  ;we have reached to the start of the array,so we finished
	BR PRINTNUM_LOOP;Didn't finish yet, keep going

FINISH_PRINTNUM:

;Loading back the values to the registers
LD R0, R0_PRINTNUM_SAVE
LD R1, R1_PRINTNUM_SAVE
LD R2, R2_PRINTNUM_SAVE
LD R3, R3_PRINTNUM_SAVE
LD R4, R4_PRINTNUM_SAVE
LD R5, R5_PRINTNUM_SAVE
LD R6, R6_PRINTNUM_SAVE
LD R7, R7_PRINTNUM_SAVE


RET

R0_PRINTNUM_SAVE .fill #0
R1_PRINTNUM_SAVE .fill #0
R2_PRINTNUM_SAVE .fill #0
R3_PRINTNUM_SAVE .fill #0
R4_PRINTNUM_SAVE .fill #0
R5_PRINTNUM_SAVE .fill #0
R6_PRINTNUM_SAVE .fill #0
R7_PRINTNUM_SAVE .fill #0

MINUS_ASCII_PRINT .fill #45
ZERO_ASCII_PRINTNUM .fill #48
NEGATIVE_FLAG .fill #0

ARR .blkw #5 ;An array in the size of 5.

DivPtr .FILL X4064 ; Pointer to the Div Subroutine

.END
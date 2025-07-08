.ORIG X40C8
Exp:
;Storing the previous values, so in case we overrite them, in the end we will return the right values (as a safety precaution)
ST R0, R0_EXP_SAVE
ST R1, R1_EXP_SAVE
ST R3, R3_EXP_SAVE
ST R4, R4_EXP_SAVE
ST R7, R7_EXP_SAVE

;Initilalizing values
AND R2,R2,#0
;R3 Will serve as the counter of the pow.
AND R3,R3,#0

;Loading the address of Mul subroutine to the R4 register
LD R4, Mul_PTR


;First, we will check if we have edge cases (R0 is 0 and R1 is zero or negative or one of them is negative).

;Checking if R0<0
ADD R0,R0,#0
BRn ILLEGAL_INPUT ;If negative, we know its illegal already

;Checking  if R1<0 (if so, its illegal input)
ADD R1,R1,#0
BRn ILLEGAL_INPUT

;Checking if R1=0
ADD R1,R1,#0
BRz Check_R0 ;In case R1=0, we will need to do further checks on R0

;Checking if R1=1 (if so, R2=R0^1=R0)
ADD R3,R1,#-1
BRz R1_IS_1
BR LEGAL ;Heading to the loop

;R1 is 0, but we need to check the values of R0, if 0 - illegal , else the R2 sum is 1 (R0^0=1)
Check_R0:
    	ADD R0,R0,#0
	BRz ILLEGAL_INPUT
    	BR R1_IS_0

R1_IS_0:
   ;IF R1 is 0 , it means the R2 will be 1 (R0^0=1) - R0 is negative if we got here.
	ADD R2,R2,#1
   	BR FINISH_EXP 

;IF R1 is 1, it means the R2 will be R0, (R0^1=R0).
R1_IS_1:
	ADD R2,R0,#0
	BR FINISH_EXP
;In case one of the registers is negative we will have to set the R2 value as -1
ILLEGAL_INPUT:
    	ADD R2,R2,#-1
    	BR FINISH_EXP

LEGAL:
;If we got here, it means the input is valid (and we didn't have any edge cases earlier).
	;Reseting R3
	AND R3,R3,#0
	;R1 is positive bigger than 1, we will have to use a loop. - R3 will serve as the counter
	ADD R3,R3,R1
	;Setting an initial value for R1 of R0 (for the calculation later, since we saved R1 value counter as R3
	ADD R1,R0,#0

EXP_LOOP:
	ADD R3,R3,#-1	; Decrement of the POW counter
	BRnz FINISH_EXP ; In case 0/negative we finished the loop.
	JSRR R4			; 	;"Calling" the mul subroutine (since in here its not illegal input/edge cases) (R0*R1)
	ADD R1,R2,#0	; puting the result of mul in R1 from R2
	BR EXP_LOOP



FINISH_EXP:

LD R0, R0_EXP_SAVE
LD R1, R1_EXP_SAVE
LD R3, R3_EXP_SAVE
LD R4, R4_EXP_SAVE
LD R7, R7_EXP_SAVE

RET

Mul_PTR .FILL x4000
R0_EXP_SAVE .fill #0
R1_EXP_SAVE .fill #0
R3_EXP_SAVE .fill #0
R4_EXP_SAVE .fill #0
R7_EXP_SAVE .FILL #0



.END
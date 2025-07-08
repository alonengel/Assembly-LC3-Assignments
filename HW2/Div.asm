.ORIG X4064
Div:
ST R0, R0_DIV_SAVE 
ST R1, R1_DIV_SAVE 
ST R4, R4_DIV_SAVE 
ST R5, R5_DIV_SAVE 
ST R7, R7_DIV_SAVE 

;reseting values of R2,R3,R4 AND R5 registers
AND R2,R2,#0
AND R3,R3,#0
;R4 will be represent a flag which will be 1 in case negative, or 0 in case postive (or double negative).
AND R4,R4,#0
;R5 will be the sum of the R1+R2 (to check if there is a reminder in the loop).
AND R5,R5,#0

;Checking if R1 is 0 (since its illegal and no point in checking later again).
ADD R1,R1,#0
BRz DIV_BY_ZERO

;Checking if R0 is positive or negative/0
ADD R0,R0,#0
;if positve, we will continue to the R1 register, if not, we will not to check if 0 or negative, and based on that we will do our actions.
BRp CHECK_R1
ADD R0,R0,#0
;If 0, we will exit from the subroutine (R2 and R3 is 0, so the value will be 0).
BRz FINISH_DIV

;Negative R0 - we will convert to the positve , and in the end, after calculation , we will convert back the sum to negative
NOT R4,R4
NOT R0,R0
ADD R0,R0,#1

;Checking of R1 now (we already checked 0 , so postive or negative)
CHECK_R1:
ADD R1,R1,#0
;If negative we will go to the loop, else, we check if zero or positve, if positive we will convert it to negative so we can do the calculation
BRn NEGATIVE_R1
;Postive - since we checked for 0 earlier
;Positive, we will convert to negative before the loop
NOT R1,R1
ADD R1,R1,#1
BR PRE_LOOP_DIV


NEGATIVE_R1:
;Negative, we will update R4 (so we can update after the calculation to negative or not.
NOT R4,R4

PRE_LOOP_DIV:
	;Check if we got to the point where the reminder is bigger than the current value of the divisor (pre loop, in case .)
	;This will be for the first time. (example 5/7)
	ADD R5,R0,R1	
	;While still postive/0, we will continue to the loop
	BRzp LOOP_DIV
	;if negative, we only got a reminder and we finished.
	ADD R3,R0,#0
	BR FINISH_DIV

LOOP_DIV:
	
	ADD R0,R0,R1
	ADD R2,R2,#1	


	;Check if we got to the point where the reminder is bigger than the current value of the divisor (if not we will continue in the loop.)
	ADD R5,R0,R1	
	;While still postive, we will continue to use the loop
	BRzp LOOP_DIV
	;Not positive, we will set R3 as the reminder
	ADD R3,R0,#0
	
	
	
END_LOOP_DIV:
;Checking if the number was negative in the start
ADD R4,R4,#0
BRz FINISH_DIV
;the number was negative in the start, we need to convert to negative the result
NOT R2,R2
ADD R2,R2,#1	
BR FINISH_DIV

DIV_BY_ZERO:
	ADD R2,R2,#-1
	ADD R3,R3,#-1

FINISH_DIV:

LD R0, R0_DIV_SAVE 
LD R1, R1_DIV_SAVE 
LD R4, R4_DIV_SAVE 
LD R5, R5_DIV_SAVE 
LD R7, R7_DIV_SAVE

RET
R0_DIV_SAVE .fill #0
R1_DIV_SAVE .fill #0
R4_DIV_SAVE .fill #0
R5_DIV_SAVE .fill #0
R7_DIV_SAVE .fill #0

.END
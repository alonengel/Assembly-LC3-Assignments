.ORIG X4000
Mul:
;Storing the previous values, so in case we overrite them, in the end we will return the right values (as a safety precaution)
ST R0, R0_MUL_SAVE 
ST R1, R1_MUL_SAVE 
ST R3, R3_MUL_SAVE 
ST R7, R7_MUL_SAVE 

;reseting values of R2 and R3 registers
AND R2,R2,#0
;R3 will be represent a flag which will be 1 in case negative, or 0 in case postive (or double negative).
AND R3,R3,#0

;Checking if R0 is positive or negative/0
ADD R0,R0,#0

;if positve, we will continue to the R1 register, if not, we will not to check if 0 or negative, and based on that we will do our actions.
BRp CHECK_R1

ADD R0,R0,#0
;If 0, we will exit from the subroutine (R2 is 0, so the value will be 0).
BRz FINISH

;Negative R0 - we will convert to the positve , and in the end, after calculation , we will convert back to negative
NOT R3,R3
NOT R0,R0
ADD R0,R0,#1


CHECK_R1:
ADD R1,R1,#0
;If positive we will go to the loop
BRp LOOP
;Negative or 0
ADD R1,R1,#0
BRz FINISH

;Negative R1
NOT R3,R3
NOT R1,R1
ADD R1,R1,#1

LOOP:		
	ADD R2,R2,R1
	ADD R0,R0,#-1
	;R0 is the counter, now he is postive, so in case we get to 0, we finished the mul.
	BRnz END_LOOP
	BR LOOP

END_LOOP:	
;Check if we need to convert the sum to negtaive
ADD R3,R3,#0
BRz FINISH
;R3 Flag showed that the sum needs to be negative, we will convert to negative
NOT R2,R2
ADD R2,R2,#1

	
FINISH:


;Loading back the values to the registers
LD R0, R0_MUL_SAVE 
LD R1, R1_MUL_SAVE 
LD R3, R3_MUL_SAVE 
LD R7, R7_MUL_SAVE 

RET

R0_MUL_SAVE .fill #0
R1_MUL_SAVE .fill #0
R3_MUL_SAVE .fill #0
R7_MUL_SAVE .fill #0
	

.END
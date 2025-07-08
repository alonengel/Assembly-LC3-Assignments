.ORIG X412C
CheckSquareRoot:

ST R0, R0_SQUARE_SAVE 
ST R1, R1_SQUARE_SAVE 
ST R3, R3_SQUARE_SAVE 
ST R4, R4_SQUARE_SAVE
ST R5, R5_SQUARE_SAVE
ST R7, R7_SQUARE_SAVE 	
;Initiliazing the values
AND R1,R1,#0 
AND R2,R2,#0 
AND R3,R3,#0 ;Will help us with calculation in the loop (difference between current and the val - if 0, we got a square).
AND R4,R4,#0 ;Will Keep the original R0


LD R5,Mul_PTR ;R5 Will be the ptr to our MUL subroutine

;Note - We can assume R0>=0

;Checking if R0=0
ADD R0,R0,#0
BRz FOUND_SQUARE
;Checking if R0=1
ADD R3,R0,#-1
BRz FOUND_SQUARE


ADD R4,R0,#0 ;Saving the R0 value, so we can use the MUL function (The original number will always be >=1)

ADD R1,R1,#1 ;Strating the loop from the 1, and we will stop once its R0/Bigger.

BR LOOP ;I know its afterwards, its just a good habit
	
LOOP:	
	ADD R0,R1,#0 ; Setting the value of R1 in R0.
	JSRR R5 ; Call Mul(R0,R1)
	;Making R4=>-R4 for the calculation (with the help of R3)
	NOT R3,R4
	ADD R3,R3,#1
	
	ADD R3,R3,R2 ; Current Sum - Original Number (If = 0, we found a square).
	BRz FOUND_SQUARE
	;Not found a square
	ADD R3,R3,#0 
	BRp NOT_FOUND ;If the sum of R2 is already bigger than the original number, we stop, since there is no point to continue.
	
    	ADD R1, R1, #1 ;Increment loop index since we need to continue
	BR LOOP



;We found a Perfect Square in our loop
FOUND_SQUARE: 
	AND R2,R2,#0 ;Reseting in case we were in the loop, since R2 might still have value.
	ADD R2,R2,#1
	BR FINISH

NOT_FOUND: ;We haven't found any square number before, so we exit
	AND R2,R2,#0
	BR FINISH

FINISH:

LD R0, R0_SQUARE_SAVE
LD R1, R1_SQUARE_SAVE
LD R3, R3_SQUARE_SAVE
LD R4, R4_SQUARE_SAVE
LD R5, R5_SQUARE_SAVE
LD R7, R7_SQUARE_SAVE


RET
Mul_PTR .FILL x4000	
R0_SQUARE_SAVE .fill #0
R1_SQUARE_SAVE .fill #0
R3_SQUARE_SAVE .fill #0
R4_SQUARE_SAVE .fill #0
R5_SQUARE_SAVE .fill #0
R7_SQUARE_SAVE .fILL #0
.END
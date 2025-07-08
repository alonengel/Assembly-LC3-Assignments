.ORIG X4190
CheckRightTriangle:

;Storing the previous values, so in case we overrite them, in the end we will return the right values (as a safety precaution)
ST R0, R0_TRIANGLE_SAVE 
ST R1, R1_TRIANGLE_SAVE 
ST R2, R2_TRIANGLE_SAVE 
ST R4, R4_TRIANGLE_SAVE
ST R5, R5_TRIANGLE_SAVE
ST R6, R6_TRIANGLE_SAVE
ST R7, R7_TRIANGLE_SAVE

;Initilizing Values
AND R3,R3,#0 ;Will serve for calculation and then for PTR to the mul func	
AND R4,R4,#0 ;Will represent The bigger num
AND R5,R5,#0 ;Smaller num1 (Also will later will serve as the sum for the calculation)
AND R6,R6,#0 ;Smaller num2




;Checking if R0 is 0/Negative (Illegal Input)
ADD R0,R0,#0
BRnz ILLEGAL_INPUT

;Checking if R1 is 0/Negative (Illegal Input)
ADD R1,R1,#0
BRnz ILLEGAL_INPUT

;Checking if R2 is 0/Negative (Illegal Input)
ADD R2,R2,#0
BRnz ILLEGAL_INPUT



;We will find who is the biggest number of them.
;First we will compare between R0 AND R1 and then compare between the bigger of them with R2
NOT R3,R0
ADD R3,R3,#1
ADD R3,R3,R1 ;-R0+R1 <0 => R0 Bigger
BRn R0_BIGGER_THAN_R1
;R1 is bigger Or equal, but it doesn't matter in our case
BR R1_BIGGER_THAN_R0 


R0_BIGGER_THAN_R1: ;R0>R1 , R4 will host the bigger num between them, and R5 the smaller between them
ADD R4,R4,R0
ADD R5,R5,R1
BR CHECK_R0_R2
			
R1_BIGGER_THAN_R0: ;R1>R0 , R4 will host the bigger num between them, and R5 the smaller between them
ADD R4,R4,R1
ADD R5,R5,R0
BR CHECK_R1_R2

CHECK_R0_R2: ;After R1 is smaller than R0, we check who is bigger between them (R0,R2)
NOT R3,R0
ADD R3,R3,#1
ADD R3,R3,R2 ;-R0+R2 <0 => R0 Bigger
BRn R0_BIGGER_THAN_R2
BR R2_BIGGER_THAN_R0

CHECK_R1_R2: ;After R0 is smaller than R1, we check who is bigger between them (R1,R2)
NOT R3,R1
ADD R3,R3,#1
ADD R3,R3,R2 ;-R1+R2 <0 => R1 Bigger
BRn R1_BIGGER_THAN_R2
BR R2_BIGGER_THAN_R1


;Second Calculation, R0 is the biggest
R0_BIGGER_THAN_R2:
ADD R6,R6,R2
BR CALCULATION

;Second Calculation, R2 is the biggest
R2_BIGGER_THAN_R0:
ADD R6,R6,R0
ADD R4,R2,#0
BR CALCULATION

;Second Calculation, R1 is the biggest
R1_BIGGER_THAN_R2:
ADD R6,R6,R2
BR CALCULATION

;Second Calculation, R2 is the biggest 
R2_BIGGER_THAN_R1:
ADD R6,R6,R1
ADD R4,R2,#0
BR CALCULATION

CALCULATION:
	LD R3, Mul_PTR ;Loading the value of the mul func to R7
	
	;Clear R3 (temp register for computation)
	;AND R3, R3, #0

	;Compute R5^2 (a^2)
    	ADD R0, R5, #0      ; Load R5 (smaller side 1) into R0
    	ADD R1, R5, #0      ; Load R5 into R1
    	JSRR R3             ; Call Mul, result in R2 (a^2)
	AND R5,R5,#0
	ADD R5,R2,#0

	; Compute R6^2 (b^2)
    	ADD R0, R6, #0      ; Load R6 (smaller side 2) into R0
    	ADD R1, R6, #0      ; Load R6 into R1
    	JSRR R3             ; Call Mul, result in R2 (b^2)

	ADD R5,R5,R2

	;Compute R4^2 (c^2)
    	ADD R0, R4, #0      ; Load R4 (largest side) into R0
    	ADD R1, R4, #0      ; Load R4 into R1
    	JSRR R3             ; Call Mul, result in R2 (c^2)
    	ADD R3, R2, #0      ; Store c^2 in R3

	    	
	;Subtract (c^2) from R5 - who currently holds (a^2)+(b^2)
    	NOT R2, R2          ; Compute -c^2
    	ADD R2, R2, #1
    	ADD R5, R5, R2      ; R5 = a^2+b^2-c^2
    	; Check if R5 == 0
    	BRz VALID_TRIANGLE  ; If zero, it is a valid right triangle
    	BR INVALID_TRIANGLE ; Otherwise, it is not
	
ILLEGAL_INPUT:
AND R3,R3,#0
ADD R3,R3,#-1	
BR FINISH


VALID_TRIANGLE:  ;Valid Triangle , we will set R3=1
AND R3,R3,#0
ADD R3,R3,#1
BR FINISH

INVALID_TRIANGLE: ;Invalid Triangle , we will set R3=0
AND R3,R3,#0
BR FINISH

FINISH:

;Loading back the values to the registers
LD R0, R0_TRIANGLE_SAVE 
LD R1, R1_TRIANGLE_SAVE 
LD R2, R2_TRIANGLE_SAVE 
LD R4, R4_TRIANGLE_SAVE 
LD R5, R5_TRIANGLE_SAVE 
LD R6, R6_TRIANGLE_SAVE 
LD R7, R7_TRIANGLE_SAVE 
RET

Mul_PTR .FILL x4000
R0_TRIANGLE_SAVE .fill #0
R1_TRIANGLE_SAVE .fill #0
R2_TRIANGLE_SAVE .fill #0
R4_TRIANGLE_SAVE .fill #0
R5_TRIANGLE_SAVE .fill #0
R6_TRIANGLE_SAVE .fill #0
R7_TRIANGLE_SAVE .fill #0
.END
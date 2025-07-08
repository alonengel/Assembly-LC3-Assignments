.ORIG X3000
main:

;Getting The First Numbers - First time getNum
LD R6, GetNumPtr  ; R6 = The address of NumPtr
JSRR R6
ADD R0,R2,#0 ;R0 will be the first number - and will get the inserted number

;Getting The Second Number - Second time getNum
JSRR R6
ADD R1,R2,#0 ;R1 will be the second number - and will get the inserted number

;Calculator - using the r0 and r1 we got before.
LD R6, CalculatorPtr 
JSRR R6

HALT

GetNumPtr .FILL X41F4 ; Pointer to the getNum Subroutine
;PrintNumPtr .FILL X4320 ; Pointer to the PrintNum Subroutine
CalculatorPtr .FILL X4384 ; Pointer to the Calculator Subroutine

.END



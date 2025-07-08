.ORIG X4384
Calculator:
;Storing the previous values, so in case we overrite them, in the end we will return the right values (as a safety precaution)
ST R0, R0_CALCULATOR_SAVE
ST R1, R1_CALCULATOR_SAVE
ST R2, R2_CALCULATOR_SAVE
ST R3, R3_CALCULATOR_SAVE
ST R4, R4_CALCULATOR_SAVE
ST R5, R5_CALCULATOR_SAVE
ST R6, R6_CALCULATOR_SAVE
ST R7, R7_CALCULATOR_SAVE

;Storing the numbers for later (since we will override r0).
ST R0, NUM1
ST R1, NUM2
LEA R0,ENTER_OP    ; Prints "Enter an arithmetic operation: "
PUTS
GETC ;Getting the input from the user and then echoing it (with out)
OUT
ST R0,SIGN_INPUT ;Storing the Sign use for later use.

CHECK_OP:
;MUL - *
LD R1 MUL_ASCII_CALC
ADD R1,R1,R0
BRz MUL_OP
;SUM - +
LD R1 PLUS_ASCII_CALC
ADD R1,R1,R0
BRz SUM_OP
;SUB - -
LD R1 MINUS_ASCII_CALC
ADD R1,R1,R0
BRz SUB_OP
;DIV - /
LD R1 DIV_ASCII_CALC
ADD R1,R1,R0
BRz DIV_OP
;EXP - ^
LD R1 EXP_ASCII_CALC
ADD R1,R1,R0
BRz EXP_OP

SUM_OP:
;Loading the nums
LD R0, NUM1
LD R1, NUM2
ADD R2,R0,R1;R2=R0+R1 (NUM1+NUM2)
ST R2, RESULT ;RESULT = R2
BR PRINT_RESULT

SUB_OP:
;Loading the nums
LD R0, NUM1
LD R1, NUM2
;NUM2=> -NUM2 (R1=>-R1)
NOT R1,R1
ADD R1,R1,#1
ADD R2,R0,R1 ;R2= R0+-R1 (NUM1-NUM2)
ST R2, RESULT ;RESULT = R2
BR PRINT_RESULT

MUL_OP:
;Loading the nums
LD R0, NUM1
LD R1, NUM2
;Loading the ptr to the MUL subroutine
LD R6, MUL_PTR
JSRR R6
ST R2, RESULT ;RESULT = R2
BR PRINT_RESULT


DIV_OP:
;Loading the nums
LD R0, NUM1
LD R1, NUM2
;Loading the ptr to the DIV subroutine
LD R6, DIV_PTR
JSRR R6
ST R2, RESULT ;RESULT = R2
BR PRINT_RESULT

EXP_OP:
;Loading the nums
LD R0, NUM1
LD R1, NUM2
;Loading the ptr to the EXP subroutine
LD R6, EXP_PTR
JSRR R6
ST R2, RESULT ;RESULT = R2
BR PRINT_RESULT


PRINT_RESULT:

;Print New Line
AND R0,R0,#0
ADD R0,R0,#10          
OUT

LD R6,PRINTNUM_PTR ;Loading the ptr to the printnum subroutine
;First Num Print
LD R0, NUM1 ;R0=NUM1
JSRR R6

;Sign Print
LD R0, SIGN_INPUT
OUT

;Second Num Print
LD R0,NUM2 ;R0=NUM2
JSRR R6

;Print Equal (=)
LD R0,EQUAL_SIGN_CALC
OUT

;Print Res
LD R0,RESULT
JSRR R6

;Print New Line
AND R0,R0,#0
ADD R0,R0,#10          
OUT


;Loading back the values to the registers
LD R0, R0_CALCULATOR_SAVE
LD R1, R1_CALCULATOR_SAVE
LD R2, R2_CALCULATOR_SAVE
LD R3, R3_CALCULATOR_SAVE
LD R4, R4_CALCULATOR_SAVE
LD R5, R5_CALCULATOR_SAVE
LD R6, R6_CALCULATOR_SAVE
LD R7, R7_CALCULATOR_SAVE


RET

R0_CALCULATOR_SAVE .fill #0
R1_CALCULATOR_SAVE .fill #0
R2_CALCULATOR_SAVE .fill #0
R3_CALCULATOR_SAVE .fill #0
R4_CALCULATOR_SAVE .fill #0
R5_CALCULATOR_SAVE .fill #0
R6_CALCULATOR_SAVE .fill #0
R7_CALCULATOR_SAVE .fill #0

;The ascii of the operations (but in minus for the comparsion)
;* - 42
;+ - 43
;- - 45
;/ - 47
;^ - 94
MUL_ASCII_CALC .fill #-42
PLUS_ASCII_CALC .fill #-43
MINUS_ASCII_CALC .fill #-45
DIV_ASCII_CALC .fill #-47
EXP_ASCII_CALC .fill #-94
;The ASCII val of equal
;= - 61
EQUAL_SIGN_CALC .fill #61

NUM1 .fill #0
NUM2 .fill #0
SIGN_INPUT .fill #0
RESULT .fill #0

ENTER_OP .STRINGZ "Enter an arithmetic operation: "

MUL_PTR .FILL X4000 ; Pointer to the Mul Subroutine
DIV_PTR .FILL X4064 ; Pointer to the Div Subroutine
EXP_PTR .FILL X40C8 ;Pointer to the EXP Subroutine
PRINTNUM_PTR .FILL X4320 ; Pointer to the PrintNum Subroutine

.END
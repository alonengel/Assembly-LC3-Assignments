.ORIG X41F4
GetNum:
;Storing the previous values, so in case we overrite them, in the end we will return the right values (as a safety precaution)
ST R0, R0_GETNUM_SAVE
ST R1, R1_GETNUM_SAVE
ST R3, R3_GETNUM_SAVE
ST R4, R4_GETNUM_SAVE
ST R5, R5_GETNUM_SAVE
ST R6, R6_GETNUM_SAVE
ST R7, R7_GETNUM_SAVE


;First Message
LEA R0,ENTER_NUM_MSG    ; Print "Enter an integer number: "
PUTS

INIT_FIRST_CHAR:
	AND R0,R0,#0
	AND R1,R1,#0
	AND R2,R2,#0;Will serve as the current sum
	AND R3,R3,#0;Will serve as a helper (for temp some and loading ASCIIS)
	AND R4,R4,#0;Temp for not digit
	AND R5,R5,#0 ;R5=0
	AND R6,R6,#0;Temp for overflow
	;Flags and counter Reset (to 0) if positive , it means the flags are activated
	ST R5,GETNUM_NEGATIVE_FLAG
	ST R5,GETNUM_OVERFLOW_FLAG
	ST R5,GETNUM_NOT_DIGIT_FLAG
	ST R5,GETNUM_DIGIT_AMOUNT

FIRST_CHAR:
	GETC; gets a digit as input
	OUT;We print the inserted char.
	;Check if IsMinus
	LD R3, MINUS_ASCII
	ADD R1,R0,R3 ;Minus the minus in ASCII
	BRz FIRST_CHAR_IS_MINUS
    	;Check if digit
    	JSR CHECK_IF_DIGIT
 	LD R4,GETNUM_NOT_DIGIT_FLAG
    	BRp NOT_DIGIT
    	;Digit, we will add it to the sum after converting from Ascii
    	LD R1, ZERO_ASCII
    	ADD R2,R0,R1; R2 = R0 but converted from ASCII
    	BR MAIN_LOOP_GETNUM

NOT_DIGIT:
    	;We will continue to the loop.
    	BR MAIN_LOOP_GETNUM

FIRST_CHAR_IS_MINUS: ;Turning the minus flag "on"
    	AND R5,R5,#0
    	ADD R5,R5,#1
    	ST R5, GETNUM_NEGATIVE_FLAG
    	BR MAIN_LOOP_GETNUM

MAIN_LOOP_GETNUM: ;Main loop - after the first char was inserted
    	GETC; gets a digit as input
    	OUT;We print the inserted char.
    	ADD R1,R0,#-10 ; check if R0 is equal to Enter or not
    	BRz PRE_FINISH_GETNUM ;ENTER
    	;Check if Char
    	JSR CHECK_IF_DIGIT
   	LD R4,GETNUM_NOT_DIGIT_FLAG
   	BRp NOT_DIGIT ;we have not a digit, we will continue to get numbers and loop the loop till we press enter.
    	JSR MUL_BY_TEN
    	LD R1, ZERO_ASCII
    	ADD R0,R0,R1 ;Converting from ASCII
    	ADD R2,R2,R0;Adding the char to it.
    	BR MAIN_LOOP_GETNUM



PRINT_ERR_NOT_NUMERIC:
    	LEA R0, NOT_NUM_MSG
    	PUTS
    	BR INIT_FIRST_CHAR
PRINT_ERR_OVERFLOW:
    	LEA R0, OVERFLOW_MSG
    	PUTS
    	BR INIT_FIRST_CHAR

PRE_FINISH_GETNUM:
    	;Check if we entered digits before enter (bad: - enter )
    	LD R6,GETNUM_DIGIT_AMOUNT
    	BRnz PRINT_ERR_NOT_NUMERIC
    	;Check if there is illegal digit
    	LD R6,GETNUM_NOT_DIGIT_FLAG
    	BRp PRINT_ERR_NOT_NUMERIC

    	;Check for overflow in mul
    	LD R6,GETNUM_OVERFLOW_FLAG
    	BRp PRINT_ERR_OVERFLOW

    	;Check for if the number is negative or not.
    	LD R6, GETNUM_NEGATIVE_FLAG
    	BRp FINISH_GETNUM_NEGATIVE ;If the flag is positive, the num is negative.
    	BR FINISH_GETNUM_POSITIVE;Positve , flag is not positve.



FINISH_GETNUM_POSITIVE:
	;Positive
	;We will check versus 32767 (basically minus him, if its possitve , (it means the item is bigger which is overflow)
	LD R3, MAX_POSSIBLE_VAL
	NOT R3,R3
	ADD R3,R3,#1
	ADD R1,R2,R3
	BRp PRINT_ERR_OVERFLOW
	BR FINISH_NUM
	
FINISH_GETNUM_NEGATIVE:
	;Check if negative (-32768 be checked here), other overflow of mul, will be in the mul by 10, and will be caught before hand
	;MINUS , we also check overflow in that case
	;Convert to minus now, after we finished adding digits to the num
	NOT R2,R2
	ADD R2,R2,#1
	;Check if overflow
	;We will check versus -32768 (basically plus him, if its negative , it means the item is smaller (more negative).
	LD R3, MIN_POSSIBLE_VAL
	NOT R3,R3
	ADD R3,R3,#1
	ADD R1,R2,R3
	BRn PRINT_ERR_OVERFLOW
	BR FINISH_NUM

FINISH_NUM:

	;Loading back the values to the registers
	LD R0, R0_GETNUM_SAVE
	LD R1, R1_GETNUM_SAVE
	LD R3, R3_GETNUM_SAVE
	LD R4, R4_GETNUM_SAVE
	LD R5, R5_GETNUM_SAVE
	LD R6, R6_GETNUM_SAVE
	LD R7, R7_GETNUM_SAVE

RET
R0_GETNUM_SAVE .fill #0
R1_GETNUM_SAVE .fill #0
R3_GETNUM_SAVE .fill #0
R4_GETNUM_SAVE .fill #0
R5_GETNUM_SAVE .fill #0
R6_GETNUM_SAVE .fill #0
R7_GETNUM_SAVE .fill #0
ENTER_NUM_MSG .STRINGZ "Enter an integer number: "
NOT_NUM_MSG .STRINGZ "Error! You did not enter a number. Please enter again: "
OVERFLOW_MSG .STRINGZ "Error! Number overflowed! Please enter again: "

;Obviously in minus so its easier to use the add. (minus the real value).
MINUS_ASCII .fill #-45
ZERO_ASCII .fill #-48
;Flags and Counters
GETNUM_DIGIT_AMOUNT .fill #0
GETNUM_NOT_DIGIT_FLAG .fill #0
GETNUM_NEGATIVE_FLAG .fill #0
GETNUM_OVERFLOW_FLAG .fill #0 ;Will represent a flag for overflow in case in the mul by 10, we get an overflow for number

MIN_POSSIBLE_VAL .fill x8000 ; -32768 in decimal (-2^15)
MAX_POSSIBLE_VAL .fill x7FFF ; 32767 in decimal (2^15 -1)

;Check if digit Subroutine, if it is, we will update GETNUM_NOT_DIGIT_FLAG flag(so it will be positvie).
; Input: R0
; Output; null, will update the GETNUM_NOT_DIGIT_FLAG flag(so it will be positvie) , also if it is a digit, we will update the counter of GETNUM_DIGIT_AMOUNT
CHECK_IF_DIGIT:
ST R1,R1_GETNUM_CHECK_IF_DIGIT
ST R3,R3_GETNUM_CHECK_IF_DIGIT
ST R7,R7_GETNUM_CHECK_IF_DIGIT

;Check if smaller than 0
LD R3, ZERO_ASCII_DIGIT
ADD R1,R0, R3 ;Minus 0 in ASCII
BRn FOUND_NOT_DIGIT ;If smaller, it means the ascci is much smaller than 0
;Check if bigger than 9.
LD R3, NINE_ASCII
ADD R1,R0, R3 ;Minus 9 in ASCII
BRp FOUND_NOT_DIGIT ;If bigger, it means the ascci is much bigger than 9
BR FOUND_DIGIT ;It is a digit!
FOUND_DIGIT:
LD R3,GETNUM_DIGIT_AMOUNT
ADD R3,R3,#1 ;R3=R3+1
ST R3, GETNUM_DIGIT_AMOUNT
BR END_CHECK_IF_NOT_DIGIT
FOUND_NOT_DIGIT:
AND R3,R3,#0;R3 Reset
ADD R3,R3,#1;R3=R3+1 (R3=1)
ST R3,GETNUM_NOT_DIGIT_FLAG;GETNUM_NOT_DIGIT_FLAG=R3 (which in this case will always be positive if we got here)

END_CHECK_IF_NOT_DIGIT:
LD R1,R1_GETNUM_CHECK_IF_DIGIT
LD R3,R3_GETNUM_CHECK_IF_DIGIT
LD R7,R7_GETNUM_CHECK_IF_DIGIT

RET
;Retore the saved registers we just used
ZERO_ASCII_DIGIT .fill #-48
NINE_ASCII .fill #-57
R1_GETNUM_CHECK_IF_DIGIT .fill #0
R3_GETNUM_CHECK_IF_DIGIT .fill #0
R7_GETNUM_CHECK_IF_DIGIT .fill #0


; CHECK_OVERFLOW subroutine
; Input: R2 - number
; Output: Output: R4 (flag indicating overflow condition)

CHECK_OVERFLOW:
    ST R6, R6_GETNUM_OVERFLOW
    ST R7, R7_GETNUM_OVERFLOW
    ;in our partial sum calcaultion, its always positive, so we check if it switched to negative, if so, its an overflow!
    ADD R2,R2,#0
    BRn OVERFLOW_FOUND ;If negative, we have a problem, it switched
    BR END_OVERFLOW_CHECK


    OVERFLOW_FOUND:
    AND R6,R6,#0
    ADD R6,R6,#1
    ST R6, GETNUM_OVERFLOW_FLAG
    BR END_OVERFLOW_CHECK
    END_OVERFLOW_CHECK:
    LD R6,R6_GETNUM_OVERFLOW
    LD R7,R7_GETNUM_OVERFLOW
RET

R6_GETNUM_OVERFLOW .fill #0
R7_GETNUM_OVERFLOW .fill #0

; MUL_BY_TEN subroutine
; Input: R2 (the number to be multiplied by 10)
; Output: R2=R2*10 (Will be the result of original R2*10 / sum in case we got flags and its not relevant), we will update the overflow flag as well, using the CHECK_OVERFLOW subroutine
MUL_BY_TEN:

	ST R1, R1_GETNUM_MULBYTEN; Save R1
	ST R3, R3_GETNUM_MULBYTEN; Save R3
	ST R6, R6_GETNUM_MULBYTEN; Save R3
	ST R7, R7_GETNUM_MULBYTEN; Save R7
    ;Check if R2=0, if so, not point in looping 10 times, since 0*something = 0, so the result is instantly 0.
	ADD R2, R2, #0
    BRz MUL_BY_TEN_LOOP_END
    ;Not 0.
	AND R1,R1,#0;Reset R1 (R1=0)
	ADD R1,R1,R2;R1=R2 (Loading R2 into R1)
	;R3 will be the counter of the loop
	AND R3, R3, #0;R3=0 (Reset of R3)
	ADD R3, R3, #9; Set R3 to 9

	MUL_BY_TEN_LOOP:
		ADD R2,R2,R1		    ; R2=R2+R1

		JSR CHECK_OVERFLOW		; For every R2=R2+R1, we need to check if there was an overflow in the calculation
		LD  R6, GETNUM_OVERFLOW_FLAG; if there is an overflow, there is no point in continuing , and we exit the func (the real "sum" will not matter).
		BRp MUL_BY_TEN_LOOP_END

		ADD R3, R3, #-1 		; R3-- (minus 1 of the counter).
		BRp MUL_BY_TEN_LOOP		; while R3>0 , we will keep going

	MUL_BY_TEN_LOOP_END:
		; Restore saved registers
		LD R1, R1_GETNUM_MULBYTEN
		LD R3, R3_GETNUM_MULBYTEN
		LD R6, R6_GETNUM_MULBYTEN
		LD R7, R7_GETNUM_MULBYTEN


RET

R1_GETNUM_MULBYTEN .fill #0
R3_GETNUM_MULBYTEN .fill #0
R6_GETNUM_MULBYTEN .fill #0
R7_GETNUM_MULBYTEN .fill #0

.END
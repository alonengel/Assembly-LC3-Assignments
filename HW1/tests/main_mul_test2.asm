.ORIG x3000

; ---------- Test program for integer multiplication ---------- 
LEA R0, TEST_1
PUTS
LD R0, Test_Num1	; R0 = Test_Num1
LD R1, Test_Num2	; R1 = Test_Num2
LD R3, MulFuncPtr	; R3 = The address of Mul
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res1	; R1 = Test_Res

; At this point R1 holds (-1) * correct answer
; While R2 holds the result that the function returned

ADD R2, R2, R1		; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TESTING2
RES_GOOD:
	LEA R0, TEST_CORRECT_STR
	PUTS
TESTING2:
LEA R0, TEST_2
PUTS
LD R0, Test_Num3	; R0 = Test_Num1
LD R1, Test_Num4	; R1 = Test_Num2
LD R3, MulFuncPtr	; R3 = The address of Mul
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res2	; R1 = Test_Res

; At this point R1 holds (-1) * correct answer
; While R2 holds the result that the function returned

ADD R2, R2, R1		; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD2		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD2:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TESTING3
RES_GOOD2:
	LEA R0, TEST_CORRECT_STR
	PUTS
LEA R0, TEST_3
PUTS
TESTING3:
LD R0, Test_Num5	; R0 = Test_Num1
LD R1, Test_Num6	; R1 = Test_Num2
LD R3, MulFuncPtr	; R3 = The address of Mul
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res3		; R1 = Test_Res

; At this point R1 holds (-1) * correct answer
; While R2 holds the result that the function returned

ADD R2, R2, R1		; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD3		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD3:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TESTING4
RES_GOOD3:
	LEA R0, TEST_CORRECT_STR
	PUTS
LEA R0, TEST_4
PUTS
TESTING4:
LD R0, Test_Num7	; R0 = Test_Num1
LD R1, Test_Num8	; R1 = Test_Num2
LD R3, MulFuncPtr	; R3 = The address of Mul
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res4	; R1 = Test_Res

; At this point R1 holds (-1) * correct answer
; While R2 holds the result that the function returned

ADD R2, R2, R1		; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD4		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD4:
	LEA R0, TEST_ERR_STR
	PUTS
	BR DONE
RES_GOOD4:
	LEA R0, TEST_CORRECT_STR
	PUTS
DONE:	HALT 		; Program is done and will now exit

TEST_1 .STRINGZ "TEST1\n"
TEST_2 .STRINGZ "TEST2\n"
TEST_3 .STRINGZ "TEST3\n"
TEST_4 .STRINGZ "TEST4\n"
TEST_ERR_STR .STRINGZ "Result is wrong\n"
TEST_CORRECT_STR .STRINGZ "Result is correct\n"
Test_Num1 .FILL #6
Test_Num2 .FILL #70
Test_Res1 .FILL #-420 ; (-1)*6*70
Test_Num3 .FILL #8
Test_Num4 .FILL #-8
Test_Res2 .FILL #64
Test_Num5 .FILL #-12
Test_Num6 .FILL #9
Test_Res3 .FILL #108
Test_Num7 .FILL #-13
Test_Num8 .FILL #-11
Test_Res4 .FILL #-143
MulFuncPtr .FILL X4000 ; Pointer to Mul subroutine: R2 <-- R0 * R1

.END
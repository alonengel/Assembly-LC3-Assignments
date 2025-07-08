.ORIG x3000
;Edited to fullful The Square Check - by Alon Engel
; ---------- Test program for integer Square ---------- 
LD R0, Test_Num1_1	; R0 = Test_Num1
LD R3, SquareFuncPtr  ; R3 = The address of Square
JSRR R3			; R2 = Square(R0)
LD R1, Test_Res1		; R1 = Test_Res

NOT R1,R1
ADD R1,R1,#1


ADD R2,R2,R1 ;R2-R1 = 0 (1-1=0)
BRz RES_GOOD1		; If R2 was 1 then jump to Res_Good else continue to Res_Bad
RES_BAD1:
	LEA R0, TEST_ERR_STR
	PUTS
	BR DONE
RES_GOOD1:
	LEA R0, TEST_CORRECT_STR
	PUTS

LD R0, Test_Num2_1	; R0 = Test_Num1
LD R3, SquareFuncPtr  ; R3 = The address of Square
JSRR R3			; R2 = Square(R0)
LD R1, Test_Res2		; R1 = Test_Res

NOT R1,R1
ADD R1,R1,#1

ADD R2,R2,R1 ;R2-R1 = 0 (0+0=0)
BRz RES_GOOD2		; If R2 was 1 then jump to Res_Good else continue to Res_Bad
RES_BAD2:
	LEA R0, TEST_ERR_STR
	PUTS
	BR DONE
RES_GOOD2:
	LEA R0, TEST_CORRECT_STR
	PUTS

LD R0, Test_Num3_1	; R0 = Test_Num1

LD R3, SquareFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res3		; R1 = Test_Res

ADD R2, R2, R1		; R2 = R2 + R1=0, (0+0)
BRz RES_GOOD3		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD3:
	LEA R0, TEST_ERR_STR
	PUTS
	BR DONE
RES_GOOD3:
	LEA R0, TEST_CORRECT_STR
	PUTS

LD R0, Test_Num4_1	; R0 = Test_Num1
LD R3, SquareFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res4		; R1 = Test_Res

NOT R1,R1
ADD R1,R1,#1

ADD R2,R2,R1
BRz RES_GOOD4		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD4:
	LEA R0, TEST_ERR_STR
	PUTS
	BR DONE
RES_GOOD4:
	LEA R0, TEST_CORRECT_STR
	PUTS

LD R0, Test_Num5_1	; R0 = Test_Num1
LD R3, SquareFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res5		; R1 = Test_Res

ADD R2, R2, #0 ; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD5		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD5:
	LEA R0, TEST_ERR_STR
	PUTS
	BR DONE
RES_GOOD5:
	LEA R0, TEST_CORRECT_STR
	PUTS

LD R0, Test_Num6_1	; R0 = Test_Num1

LD R3, SquareFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res6		; R1 = Test_Res

ADD R2, R2, #-1		; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD6		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD6:
	LEA R0, TEST_ERR_STR
	PUTS
	BR DONE
RES_GOOD6:
	LEA R0, TEST_CORRECT_STR
	PUTS


LD R0, Test_Num7_1	; R0 = Test_Num1

LD R3, SquareFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res7		; R1 = Test_Res

ADD R2, R2, #0		; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD7		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD7:
	LEA R0, TEST_ERR_STR
	PUTS
	BR DONE
RES_GOOD7:
	LEA R0, TEST_CORRECT_STR
	PUTS


LD R0, Test_Num8_1	; R0 = Test_Num1

LD R3, SquareFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res8		; R1 = Test_Res

ADD R2, R2, #-1		; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD8		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD8:
	LEA R0, TEST_ERR_STR
	PUTS
	BR DONE
RES_GOOD8:
	LEA R0, TEST_CORRECT_STR
	PUTS
	
DONE:	HALT 		; Program is done and will now exit

TEST_ERR_STR .STRINGZ "Result is wrong\n"
TEST_CORRECT_STR .STRINGZ "Result is correct\n"
Test_Num1_1 .FILL #0
Test_Res1 .FILL #1 ; 0*0=0

Test_Num2_1 .FILL #1
Test_Res2 .FILL #1 ; 1*1=1
 
Test_Num3_1 .FILL #2
Test_Res3 .FILL #0 ; 

Test_Num4_1 .FILL #9
Test_Res4 .FILL #1; 3*3=9

Test_Num5_1 .FILL #12
Test_Res5 .FILL #0 ; 

Test_Num6_1 .FILL #36
Test_Res6 .FILL #1 ; 6*6=36 

Test_Num7_1 .FILL #143
Test_Res7 .FILL #0 ; 

Test_Num8_1 .FILL #144
Test_Res8 .FILL #1 ; 12*12=144


SquareFuncPtr .FILL X412C ; Pointer to Square subroutine

.END
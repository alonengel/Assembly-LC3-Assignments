.ORIG x3000
;Edited to fullful The Square Check - by Alon Engel
; ---------- Test program for integer Square ---------- 
LD R0, Test_Num1_1	; R0 = Test_Num1
LD R1, Test_Num1_2	; R1 = Test_Num2
LD R2, Test_Num1_3	; R2 = Test_Num3
LD R3, TriangleFuncPtr  ; R3 = The address of Square
JSRR R3			; R2 = Square(R0)
LD R1, Test_Res1		; R1 = Test_Res




ADD R3,R3,#1 ;(-1+1=0)
BRz RES_GOOD1		; If R2 was 1 then jump to Res_Good else continue to Res_Bad
RES_BAD1:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TEST2
RES_GOOD1:
	LEA R0, TEST_CORRECT_STR
	PUTS

TEST2:
LD R0, Test_Num2_1	; R0 = Test_Num1
LD R1, Test_Num2_2	; R1 = Test_Num2
LD R2, Test_Num2_3	; R2 = Test_Num3
LD R3, TriangleFuncPtr  ; R3 = The address of Square
JSRR R3			; R2 = Square(R0)
LD R1, Test_Res2		; R1 = Test_Res

ADD R3,R3,#1 ;-1+1=0
BRz RES_GOOD2		; If R2 was 1 then jump to Res_Good else continue to Res_Bad
RES_BAD2:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TEST3
RES_GOOD2:
	LEA R0, TEST_CORRECT_STR
	PUTS
TEST3:
LD R0, Test_Num3_1	; R0 = Test_Num1
LD R1, Test_Num3_2	; R1 = Test_Num2
LD R2, Test_Num3_3	; R2 = Test_Num3

LD R3, TriangleFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res3		; R1 = Test_Res

ADD R3, R3, #-1		; (1+-1=0)
BRz RES_GOOD3		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD3:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TEST4
RES_GOOD3:
	LEA R0, TEST_CORRECT_STR
	PUTS
TEST4:
LD R0, Test_Num4_1	; R0 = Test_Num1
LD R1, Test_Num4_2	; R1 = Test_Num2
LD R2, Test_Num4_3	; R2 = Test_Num3
LD R3, TriangleFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res4		; R1 = Test_Res


ADD R3,R3,#0 ;0+0=0
BRz RES_GOOD4		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD4:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TEST5
RES_GOOD4:
	LEA R0, TEST_CORRECT_STR
	PUTS
TEST5:
LD R0, Test_Num5_1	; R0 = Test_Num1
LD R1, Test_Num5_2	; R0 = Test_Num2
LD R2, Test_Num5_3	; R0 = Test_Num3
LD R3, TriangleFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res5		; R1 = Test_Res

ADD R3, R3, #0 ; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD5		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD5:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TEST6
RES_GOOD5:
	LEA R0, TEST_CORRECT_STR
	PUTS
TEST6:
LD R0, Test_Num6_1	; R0 = Test_Num1
LD R1, Test_Num6_2	; R1 = Test_Num2
LD R2, Test_Num6_3	; R2 = Test_Num3
LD R3, TriangleFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res6		; R1 = Test_Res

ADD R3, R3, #-1		; R2 = R2 + R1, and remember that R1 is (-1) * The answer!
BRz RES_GOOD6		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD6:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TEST7
RES_GOOD6:
	LEA R0, TEST_CORRECT_STR
	PUTS
TEST7:
LD R0, Test_Num7_1	; R0 = Test_Num1
LD R1, Test_Num7_2	; R1 = Test_Num2
LD R2, Test_Num7_3	; R2 = Test_Num3

LD R3, TriangleFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res7		; R1 = Test_Res

ADD R3, R3, #-1		
BRz RES_GOOD7		; If R2 = 0 then jump to Res_Good else continue to Res_Bad
RES_BAD7:
	LEA R0, TEST_ERR_STR
	PUTS
	BR TEST8
RES_GOOD7:
	LEA R0, TEST_CORRECT_STR
	PUTS

TEST8:
LD R0, Test_Num8_1	; R0 = Test_Num1
LD R1, Test_Num8_2	; R1 = Test_Num2
LD R2, Test_Num8_3	; R2 = Test_Num3

LD R3, TriangleFuncPtr  ; R3 = The address of SquareFuncPtr  
JSRR R3			; R2 = Mul(R0, R1)
LD R1, Test_Res8		; R1 = Test_Res

ADD R3, R3, #-1		
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
Test_Num1_2 .FILL #1
Test_Num1_3 .FILL #2
Test_Res1 .FILL #-1 ; 

Test_Num2_1 .FILL #5
Test_Num2_2 .FILL #-1
Test_Num2_3 .FILL #7
Test_Res2 .FILL #1 ; 
 
Test_Num3_1 .FILL #3
Test_Num3_2 .FILL #4
Test_Num3_3 .FILL #5
Test_Res3 .FILL #1 ; 

Test_Num4_1 .FILL #5
Test_Num4_2 .FILL #3
Test_Num4_3 .FILL #2
Test_Res4 .FILL #0; 

Test_Num5_1 .FILL #11
Test_Num5_2 .FILL #10
Test_Num5_3 .FILL #12
Test_Res5 .FILL #0 ; 

Test_Num6_1 .FILL #29
Test_Num6_2 .FILL #20
Test_Num6_3 .FILL #21
Test_Res6 .FILL #1 ; 

Test_Num7_1 .FILL #21
Test_Num7_2 .FILL #29
Test_Num7_3 .FILL #20
Test_Res7 .FILL #1 ; 

Test_Num8_1 .FILL #21
Test_Num8_2 .FILL #20
Test_Num8_3 .FILL #29
Test_Res8 .FILL #1 ; 


TriangleFuncPtr .FILL X4190 ; Pointer to Triangle subroutine

.END
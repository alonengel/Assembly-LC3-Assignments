.ORIG x3000
main:



; Course Student Amount -----------------------------------------------
; Print input prompt for courses student num
LEA R0, ENTER_NUMSTUDENT_MSG
PUTS
;We recive the number of students for each course
LEA R4, INPUT_ARR  ; R4 = address of INPUT_ARR
JSR INPUT_NUM


;Storing Course Sizes & reciving student grades
;Course 1 Students Num
LDR R2,R4,#0
ST R2,COURSE1SIZE
;Course 2 Students Num
LDR R2,R4,#1
ST R2,COURSE2SIZE
;Course 3 Students Num
LDR R2,R4,#2
ST R2,COURSE3SIZE



; Grades input--------------------------------------------------------

;Print input promot for course1
LEA R0,ENTER_COURSE1_MSG
PUTS
;Print Space
AND R0,R0,#0
ADD R0,R0,#10
OUT

;Inputing the students grades in course1
;R1= Pointer to the Stack
;R2= Course Students Size
LD R1, Course1DataPtr
LD R2, COURSE1SIZE
JSR GetStudentGrades



;Print input promot for course2
LEA R0,ENTER_COURSE2_MSG
PUTS
;Print Space
AND R0,R0,#0
ADD R0,R0,#10
OUT

;Inputing the students grades in course2
;R1= Pointer to the Stack
;R2= Course Students Size
LD R1, Course2DataPtr
LD R2, COURSE2SIZE
JSR GetStudentGrades


;Print input promot for course3
LEA R0,ENTER_COURSE3_MSG
PUTS
;Print Space
AND R0,R0,#0
ADD R0,R0,#10
OUT

;Inputing the students grades in course3
;R1= Pointer to the Stack
;R2= Course Students Size
LD R1, Course3DataPtr
LD R2, COURSE3SIZE
JSR GetStudentGrades

;Calculate Average ----------------------------------------
;Calculate Average For Course1
LD R1, Course1DataPtr
LD R2, COURSE1SIZE
JSR AverageCalculator


;Calculate Average For Course2
LD R1, Course2DataPtr
LD R2, COURSE2SIZE
JSR AverageCalculator


;Calculate Average For Course3
LD R1, Course3DataPtr
LD R2, COURSE3SIZE
JSR AverageCalculator

;-------------- Calculate Best 6 Students ----------------

;Course 1
LD R0, Top6Course1Ptr
LD R1, Course1DataPtr
LD R2, COURSE1SIZE
JSR BestStudent

;Print for test
;LD R1, Top6Course1Ptr
;JSR PRINT_TOP_6

;Course 2
LD R0, Top6Course2Ptr
LD R1, Course2DataPtr
LD R2, COURSE2SIZE
JSR BestStudent



;Course 3
LD R0, Top6Course3Ptr
LD R1, Course3DataPtr
LD R2, COURSE3SIZE
JSR BestStudent



;Combined:
LD R1,Course1DataPtr
LD R2,Course2DataPtr
LD R3,Course3DataPtr
LD R4, COURSE1SIZE
LD R5, COURSE2SIZE
LD R6, COURSE3SIZE
JSR Combine_Students





;-------------- Calculate Failed Students ----------------

;Will be our counter for failed students
AND R4,R4,#0

;Calculate Failed Students For Course1
LD R1, Course1DataPtr
LD R2, COURSE1SIZE
JSR CountFailedStudents
ADD R4,R4,R3

;Calculate Failed Students For Course2
LD R1, Course2DataPtr
LD R2, COURSE2SIZE
JSR CountFailedStudents
ADD R4,R4,R3

;Calculate Failed Students For Course3
LD R1, Course3DataPtr
LD R2, COURSE3SIZE
JSR CountFailedStudents
ADD R4,R4,R3

LEA R0, FAIL_PROMOT
PUTS

AND R0,R0,#0
ADD R0,R0,R4
JSR PrintNum

;---------------------------------------------------------



HALT
RET

INPUT_ARR .blkw #4 ;An array in the size of 4
COURSE1SIZE .fill #0
COURSE2SIZE .fill #0
COURSE3SIZE .fill #0

Top6CombinedPtr .FILL CombinedCoursesTop6
Course1DataPtr .FILL Course1Data
Course2DataPtr .FILL Course2Data
Course3DataPtr .FILL Course3Data
CombinedCoursesDataPtr .fill CombinedCoursesData

Top6Course1Ptr .FILL Course1Top6
Top6Course2Ptr .FILL Course2Top6
Top6Course3Ptr .FILL Course3Top6


;Promots
ENTER_NUMSTUDENT_MSG .STRINGZ "Enter the number of students in each course: "
ENTER_COURSE1_MSG .STRINGZ "Enter the student grades in course 1:"
ENTER_COURSE2_MSG .STRINGZ "Enter the student grades in course 2:"
ENTER_COURSE3_MSG .STRINGZ "Enter the student grades in course 3:"
;PRINT_PROMOT .STRINGZ "Print Time! "
FAIL_PROMOT .STRINGZ "Number of FAILED students is: "
STACK_ADDRESS .fill xBFFF



Course1Top6 .BLKW 6
Course2Top6 .BLKW 6
Course3Top6 .BLKW 6
CombinedCoursesTop6 .blkw 6

Course1Data  .BLKW 70
Course2Data  .BLKW 70
Course3Data  .BLKW 70


INPUT_NUM:
    ;Input:
    ;R4 = The array starting address
    ; Store registers
    ST R0, R0_GETNUM_SAVE
    ST R1, R1_GETNUM_SAVE
    ST R2, R2_GETNUM_SAVE
    ST R3, R3_GETNUM_SAVE
    ST R4, R4_GETNUM_SAVE
    ST R5, R5_GETNUM_SAVE
    ST R6, R6_GETNUM_SAVE
    ST R7, R7_GETNUM_SAVE

    AND R5, R5, #0  ; Reset number accumlator

INPUT_LOOP:
    GETC  ; Read character from keyboard
    OUT   ; Print character for debugging

    ADD R1, R0, #-10   ; Check if ENTER was pressed
    BRz ENTER_CHECK

    LD R1, SPACE_ASCII  ; Check if space was pressed
    ADD R1, R1, R0
    BRz SPACE_CHECK

    ; If not ENTER or SPACE, must be digit
    BR DIGIT_CHECK

ENTER_CHECK:
    ADD R5, R5, #0
    BRz FINISH_GET_STUDENT_NUM ; If nothing in R6, exit

    STR R5, R4, #0  ; Store last number
    ADD R4, R4, #1  ; Move to next slot

    AND R5, R5, #0  ; Reset number accumulator

    BR FINISH_GET_STUDENT_NUM

SPACE_CHECK:
    ADD R5, R5, #0
    BRz INPUT_LOOP  ; Ignore extra spaces

    STR R5, R4, #0  ; Store completed number
    ADD R4, R4, #1  ; Move to next slot

    AND R5, R5, #0  ; Reset number accumulator

    BR INPUT_LOOP

DIGIT_CHECK:
    ADD R5, R5, #0
    BRp MUL_BY_10  ; If a number is in R6, multiply by 10

    LD R1, ZERO_ASCII
    ADD R0, R0, R1  ; Convert from ASCII
    ADD R5, R5, R0  ; Store digit

    BR INPUT_LOOP

MUL_BY_10:
    ADD R1, R5, R5  ; R1=2*R6
    ADD R5, R5, R5  ; R6=2*R6
    ADD R5, R5, R5  ; R6=4*R6
    ADD R5, R5, R5  ; R6=8*R6
    ADD R5, R5, R1  ; R6=(8*R6+2*R6)=10*R6

    LD R1, ZERO_ASCII
    ADD R0, R0, R1  ; Convert from ASCII
    ADD R5, R5, R0  ; Store digit

    BR INPUT_LOOP

FINISH_GET_STUDENT_NUM:
    ; Restore registers
    LD R0, R0_GETNUM_SAVE
    LD R1, R1_GETNUM_SAVE
    LD R2, R2_GETNUM_SAVE
    LD R3, R3_GETNUM_SAVE
    LD R4, R4_GETNUM_SAVE
    LD R5, R5_GETNUM_SAVE
    LD R6, R6_GETNUM_SAVE
    LD R7, R7_GETNUM_SAVE

    RET

R0_GETNUM_SAVE .fill #0
R1_GETNUM_SAVE .fill #0
R2_GETNUM_SAVE .fill #0
R3_GETNUM_SAVE .fill #0
R4_GETNUM_SAVE .fill #0
R5_GETNUM_SAVE .fill #0
R6_GETNUM_SAVE .fill #0
R7_GETNUM_SAVE .fill #0
SPACE_ASCII .fill #-32
ZERO_ASCII .fill #-48




;1

GetStudentGrades:
    ; Store registers
    ST R0, R0_GET_GRADES_SAVE
    ST R1, R1_GET_GRADES_SAVE
    ST R2, R2_GET_GRADES_SAVE
    ST R3, R3_GET_GRADES_SAVE
    ST R4, R4_GET_GRADES_SAVE
    ST R5, R5_GET_GRADES_SAVE
    ST R6, R6_GET_GRADES_SAVE
    ST R7, R7_GET_GRADES_SAVE


LOOP_GRADES_INPUT:
        ADD R2,R2,#0
        BRz FINISH_GET
        LEA R4, TEMP_ARR  ; R4 = address of INPUT_ARR
        ;We recive the students Grades
        JSR INPUT_NUM
        AND R5,R5,#0
        ;reciving student grades
        ;LEA R4, TEMP_ARR
        ;HW1
        LDR R3,R4,#0
        STR R3,R1,#0
        ;Reset The Cell in the temp array
        STR R5, R4, #0

        ;HW2
        LDR R3,R4,#1
        STR R3,R1,#1
        ;Reset The Cell in the temp array
        STR R5, R4, #1
        ;HW3
        LDR R3,R4,#2
        STR R3,R1,#2
        ;Reset The Cell in the temp array
        STR R5, R4, #2

        ;middle_test
        LDR R3,R4,#3
        STR R3,R1,#3
        ;Reset The Cell in the temp array
        STR R5, R4, #3

        ;Average - Reset for now
        STR R5, R4, #4

        ;Additional SpaceFor
        ;Prev
        ;Next
        ADD R1,R1,#7
        ;Update Counter
        ADD R2,R2,#-1
        BR LOOP_GRADES_INPUT

FINISH_GET:
    ; Restore registers
    LD R0, R0_GET_GRADES_SAVE
    LD R1, R1_GET_GRADES_SAVE
    LD R2, R2_GET_GRADES_SAVE
    LD R3, R3_GET_GRADES_SAVE
    LD R4, R4_GET_GRADES_SAVE
    LD R5, R5_GET_GRADES_SAVE
    LD R6, R6_GET_GRADES_SAVE
    LD R7, R7_GET_GRADES_SAVE


RET
R0_GET_GRADES_SAVE .fill #0
R1_GET_GRADES_SAVE .fill #0
R2_GET_GRADES_SAVE .fill #0
R3_GET_GRADES_SAVE .fill #0
R4_GET_GRADES_SAVE .fill #0
R5_GET_GRADES_SAVE .fill #0
R6_GET_GRADES_SAVE .fill #0
R7_GET_GRADES_SAVE .fill #0
;Temp Array for the input
TEMP_ARR .FILL #0
         .FILL #0
         .FILL #0
         .FILL #0





;2

AverageCalculator:
;Input - R1- Array , R2 - Student Amount

ST R0, R0_AVERAGE_CALC_SAVE
ST R1, R1_AVERAGE_CALC_SAVE
ST R2, R2_AVERAGE_CALC_SAVE
ST R3, R3_AVERAGE_CALC_SAVE
ST R4, R4_AVERAGE_CALC_SAVE
ST R5, R5_AVERAGE_CALC_SAVE
ST R6, R6_AVERAGE_CALC_SAVE
ST R7, R7_AVERAGE_CALC_SAVE


;R4 Array
;R5 SIZE (for loop)
;R6 SUM

;Saving the Array in R4 (since r1 gets overwritten).
AND R4,R4,#0
ADD R4,R4,R1
;Saving the Size in R5 (since r2 gets overwritten).
AND R5,R5,#0
ADD R5,R5,R2


;We will get the sum of each
LOOP_CALCULATE_AVERAGE:

ADD R5,R5,#0
BRz END_AVERAGE_CALC

AND R6,R6,#0 ;Reset- will represent the sum
;Recive Address in
;HW1+HW2+HW3+HW4 / 4
;HW1
LDR R3,R4,#0
ADD R6,R6,R3

;HW2
LDR R3,R4,#1
ADD R6,R6,R3

;HW3
LDR R3,R4,#2
ADD R6,R6,R3

;Middle_test
LDR R3,R4,#3
ADD R6,R6,R3

;Dividing
AND R0,R0,#0
ADD R0,R0,R6

AND R1,R1,#0
ADD R1,R1,#4
JSR Div

;Storing Average
STR R2,R4,#4


ADD R4,R4,#7
ADD R5,R5,#-1


BR LOOP_CALCULATE_AVERAGE

END_AVERAGE_CALC:
    LD R0, R0_AVERAGE_CALC_SAVE
    LD R1, R1_AVERAGE_CALC_SAVE
    LD R2, R2_AVERAGE_CALC_SAVE
    LD R3, R3_AVERAGE_CALC_SAVE
    LD R4, R4_AVERAGE_CALC_SAVE
    LD R5, R5_AVERAGE_CALC_SAVE
    LD R6, R6_AVERAGE_CALC_SAVE
    LD R7, R7_AVERAGE_CALC_SAVE

RET

R0_AVERAGE_CALC_SAVE .fill #0
R1_AVERAGE_CALC_SAVE .fill #0
R2_AVERAGE_CALC_SAVE .fill #0
R3_AVERAGE_CALC_SAVE .fill #0
R4_AVERAGE_CALC_SAVE .fill #0
R5_AVERAGE_CALC_SAVE .fill #0
R6_AVERAGE_CALC_SAVE .fill #0
R7_AVERAGE_CALC_SAVE .fill #0


;3
MaxInList:
;Input R3 - the Arr Starting Address
;Input R4 - Student Size number
;Output R5 - the address of the max num in the list.
ST R0, R0_MAX_IN_LIST_SAVE
ST R1, R1_MAX_IN_LIST_SAVE
ST R2, R2_MAX_IN_LIST_SAVE
ST R3, R3_MAX_IN_LIST_SAVE
ST R4, R4_MAX_IN_LIST_SAVE
ST R6, R6_MAX_IN_LIST_SAVE
ST R7, R7_MAX_IN_LIST_SAVE


;R0 - Temp Max - will be the first item
LDR R0, R3, #4
;R5 maxLocation - default will be the first student average (it will be overwritten if there will be max, if not, all 0).
ADD R5,R3,#0

MAX_IN_LIST_CHECK_LOOP:
ADD R4,R4,#0
BRz FINISH_MAX_IN_LIST

;R1=-R0 (for comparing).
AND R1,R1,#0
ADD R1,R1,R0
NOT R1,R1
ADD R1,R1,#1

;Loading the average of the current Student.
LDR R2,R3,#4
;R1=-R1+R2 (if positve, r2 is bigger).
ADD R1,R1,R2
BRnz NOT_FOUND_NEW_MAX_IN_LIST
;If we are here, it means we got a new max.
;NEW Max Location
ADD R5,R3,#0
ADD R0,R2,#0

NOT_FOUND_NEW_MAX_IN_LIST:

ADD R4,R4,#-1
ADD R3,R3,#7

BR MAX_IN_LIST_CHECK_LOOP

FINISH_MAX_IN_LIST:

LD R0, R0_MAX_IN_LIST_SAVE
LD R1, R1_MAX_IN_LIST_SAVE
LD R2, R2_MAX_IN_LIST_SAVE
LD R3, R3_MAX_IN_LIST_SAVE
LD R4, R4_MAX_IN_LIST_SAVE
LD R6, R6_MAX_IN_LIST_SAVE
LD R7, R7_MAX_IN_LIST_SAVE



RET

R0_MAX_IN_LIST_SAVE .fill #0
R1_MAX_IN_LIST_SAVE .fill #0
R2_MAX_IN_LIST_SAVE .fill #0
R3_MAX_IN_LIST_SAVE .fill #0
R4_MAX_IN_LIST_SAVE .fill #0
R6_MAX_IN_LIST_SAVE .fill #0
R7_MAX_IN_LIST_SAVE .fill #0

;4
MaxSort:
;Input - R1- Array , R2 - Student Amount
ST R0, R0_MAX_SORT_SAVE
ST R1, R1_MAX_SORT_SAVE
ST R2, R2_MAX_SORT_SAVE
ST R3, R3_MAX_SORT_SAVE
ST R4, R4_MAX_SORT_SAVE
ST R5, R5_MAX_SORT_SAVE
ST R6, R6_MAX_SORT_SAVE
ST R7, R7_MAX_SORT_SAVE

;LOOP description:
;Save CurrentAddress
;Call MaxInList
;Switch between current and the max (swap)
;Advance in the Array

MAX_SORT_SEARCH_LOOP:

ADD R2,R2,#0
BRz END_MAX_SORT

;Getting the max item address
;for Each loop the address will be overwritten. (for both size and currentAddress)
ADD R3,R1,#0
ADD R4,R2,#0

AND R5,R5,#0

JSR MaxInList
;Output R5 - the address of the max num in the list.

LEA R0, TEMP_MAX_SORT_SAVE  ; R0 = address of TEMP_MAX_SORT_SAVE


        ;reciving student grades
        ;LEA R4, TEMP_ARR
        ;HW1
        LDR R6,R5,#0
        STR R6,R0,#0
        ;HW2
        LDR R6,R5,#1
        STR R6,R0,#1
        ;HW3
        LDR R6,R5,#2
        STR R6,R0,#2
        ;middle_test
        LDR R6,R5,#3
        STR R6,R0,#3
        ;Average
        LDR R6,R5,#4
        STR R6,R0,#4

        ;Store CurrentCell in the maxAddress
        ;HW1
        LDR R6,R3,#0
        STR R6,R5,#0
        ;HW2
        LDR R6,R3,#1
        STR R6,R5,#1
        ;HW3
        LDR R6,R3,#2
        STR R6,R5,#2
        ;MiddleTerm
        LDR R6,R3,#3
        STR R6,R5,#3
        ;Average
        LDR R6,R3,#4
        STR R6,R5,#4

        ;Store max current value in the current cell.
        ;HW1
        LDR R6,R0,#0
        STR R6,R3,#0
        ;HW2
        LDR R6,R0,#1
        STR R6,R3,#1
        ;HW3
        LDR R6,R0,#2
        STR R6,R3,#2
        ;MiddleTerm
        LDR R6,R0,#3
        STR R6,R3,#3
        ;Average
        LDR R6,R0,#4
        STR R6,R3,#4

        ;Reset cells in temp array afterwards
        AND R6,R6,#0
        STR R6,R0,#0
        STR R6,R0,#1
        STR R6,R0,#2
        STR R6,R0,#3
        STR R6,R0,#4



;Advancing the array
ADD R1,R1,#7
;Smaller Size
ADD R2,R2,#-1

BR MAX_SORT_SEARCH_LOOP
;Out of loop, we finished.



END_MAX_SORT:

LD R0, R0_MAX_SORT_SAVE
LD R1, R1_MAX_SORT_SAVE
LD R2, R2_MAX_SORT_SAVE
LD R3, R3_MAX_SORT_SAVE
LD R4, R4_MAX_SORT_SAVE
LD R5, R5_MAX_SORT_SAVE
LD R6, R6_MAX_SORT_SAVE
LD R7, R7_MAX_SORT_SAVE


RET
R0_MAX_SORT_SAVE .fill #0
R1_MAX_SORT_SAVE .fill #0
R2_MAX_SORT_SAVE .fill #0
R3_MAX_SORT_SAVE .fill #0
R4_MAX_SORT_SAVE .fill #0
R5_MAX_SORT_SAVE .fill #0
R6_MAX_SORT_SAVE .fill #0
R7_MAX_SORT_SAVE .fill #0
TEMP_MAX_SORT_SAVE .FILL #0
                    .FILL #0
                    .FILL #0
                    .FILL #0
                    .FILL #0




;5
BestStudent:
;Input
;R0 - array with len of 6.
;R1 - student array address
;R2 - student size.
ST R0, R0_BEST_STUDENT_SAVE
ST R1, R1_BEST_STUDENT_SAVE
ST R2, R2_BEST_STUDENT_SAVE
ST R3, R3_BEST_STUDENT_SAVE
ST R4, R4_BEST_STUDENT_SAVE
ST R5, R5_BEST_STUDENT_SAVE
ST R6, R6_BEST_STUDENT_SAVE
ST R7, R7_BEST_STUDENT_SAVE

;Resetting the R0 array (the 6 one)
AND R4,R4,#0
;Reset and set R6, will be our counter for the entered nums to R6
AND R6,R6,#0
ADD R6,R6,#6

STR R4,R0,#0
STR R4,R0,#1
STR R4,R0,#2
STR R4,R0,#3
STR R4,R0,#4
STR R4,R0,#5

;Will sort the student array before we use the best student.
;it needs R1 - Student Array and R2 - Student size (as we get).
JSR MaxSort

;Storing the currentPosition (max num, in the 6 len array).
LDR R3,R1,#4
STR R3,R0,#0
ADD R4,R3,#0
;R4 will represent the current cell so once we check the next cell, we compare it with him.

;Taking the first cell, we will compare to it.
;Also we will advance the arrays and update the length.
ADD R0,R0,#1
ADD R2,R2,#-1
ADD R1,R1,#7

;We know at least 2 students are in each course.

BEST_STUDENT_LOOP:
ADD R2,R2,#0
BRz END_BEST_STUDENT

;Check if current is equal to the prev max, if yes we ignore

LDR R3,R1,#4
ADD R5,R3,#0
NOT R5,R5
ADD R5,R5,#1
ADD R5,R5,R4
;If equal, we advance without storing, if not, we store.
BRz ADVANCE_BEST_STUDENT

;Not equal.
STR R3,R0,#0
ADD R4,R3,#0
ADD R0,R0,#1
ADD R6,R6,#-1
BRz END_BEST_STUDENT

ADVANCE_BEST_STUDENT:
;Advancing the array
ADD R2,R2,#-1
ADD R1,R1,#7

BR BEST_STUDENT_LOOP


END_BEST_STUDENT:

LD R0, R0_BEST_STUDENT_SAVE
LD R1, R1_BEST_STUDENT_SAVE
LD R2, R2_BEST_STUDENT_SAVE
LD R3, R3_BEST_STUDENT_SAVE
LD R4, R4_BEST_STUDENT_SAVE
LD R5, R5_BEST_STUDENT_SAVE
LD R6, R6_BEST_STUDENT_SAVE
LD R7, R7_BEST_STUDENT_SAVE

RET
R0_BEST_STUDENT_SAVE .fill #0
R1_BEST_STUDENT_SAVE .fill #0
R2_BEST_STUDENT_SAVE .fill #0
R3_BEST_STUDENT_SAVE .fill #0
R4_BEST_STUDENT_SAVE .fill #0
R5_BEST_STUDENT_SAVE .fill #0
R6_BEST_STUDENT_SAVE .fill #0
R7_BEST_STUDENT_SAVE .fill #0




PRINT_TOP_6:
;Input R1- the array to print

ST R0, R0_PRINT_TOP_6_SAVE
ST R1, R1_PRINT_TOP_6_SAVE
ST R2, R2_PRINT_TOP_6_SAVE
ST R3, R3_PRINT_TOP_6_SAVE
ST R4, R4_PRINT_TOP_6_SAVE
ST R5, R5_PRINT_TOP_6_SAVE
ST R6, R6_PRINT_TOP_6_SAVE
ST R7, R7_PRINT_TOP_6_SAVE

;R6 will be our counter
AND R6,R6,#0
ADD R6,R6,#6
LD R2, SPACE_PRINT_TOP_6
PRINT_TOP_6_LOOP:

ADD R6,R6,#0
BRz FINISH_PRINT_TOP_6

;Print Num
LDR R0, R1, #0
JSR PrintNum


;Advance array pointer (R1) & decrement loop (R6)
ADD R1,R1,#1
ADD R6,R6,#-1
BRz PRINT_TOP_6_LOOP
;Print Space (when not last)
AND R0,R0,#0
ADD R0,R0,R2
OUT

BR PRINT_TOP_6_LOOP
FINISH_PRINT_TOP_6:


LD R0, R0_PRINT_TOP_6_SAVE
LD R1, R1_PRINT_TOP_6_SAVE
LD R2, R2_PRINT_TOP_6_SAVE
LD R3, R3_PRINT_TOP_6_SAVE
LD R4, R4_PRINT_TOP_6_SAVE
LD R5, R5_PRINT_TOP_6_SAVE
LD R6, R6_PRINT_TOP_6_SAVE
LD R7, R7_PRINT_TOP_6_SAVE

RET

R0_PRINT_TOP_6_SAVE .fill #0
R1_PRINT_TOP_6_SAVE .fill #0
R2_PRINT_TOP_6_SAVE .fill #0
R3_PRINT_TOP_6_SAVE .fill #0
R4_PRINT_TOP_6_SAVE .fill #0
R5_PRINT_TOP_6_SAVE .fill #0
R6_PRINT_TOP_6_SAVE .fill #0
R7_PRINT_TOP_6_SAVE .fill #0
SPACE_PRINT_TOP_6 .fill #32

;6
CountFailedStudents:
;Input - R1- Array , R2 - Student Amount
;Output - R3- the number of failed students in a course.
;R1 Array
;R2 SIZE (for loop)
;R3 COUNT Failures
ST R0, R0_CHECK_FAILED_SAVE
ST R1, R1_CHECK_FAILED_SAVE
ST R2, R2_CHECK_FAILED_SAVE
ST R4, R4_CHECK_FAILED_SAVE
ST R5, R5_CHECK_FAILED_SAVE
ST R6, R6_CHECK_FAILED_SAVE
ST R7, R7_CHECK_FAILED_SAVE


AND R3,R3,#0 ;Reset- will represent the sum


;We will get the sum of each
LOOP_FAILED_STUDENTS_CHECK:

ADD R2,R2,#0
BRz END_FAILED_STUDENTS_COUNT

;Loading  Average
LDR R4,R1,#4

LD R5, MINUS_55
ADD R0,R4,R5
;Check R5 if bigger >55 or not
BRzp CONTINUE_FAILURE_CHECK


FAILURE_FOUND:
;We got someone that has an average of below 55
ADD R3,R3,#1

CONTINUE_FAILURE_CHECK:

ADD R1,R1,#7
ADD R2,R2,#-1


BR LOOP_FAILED_STUDENTS_CHECK

END_FAILED_STUDENTS_COUNT:
    LD R0, R0_CHECK_FAILED_SAVE
    LD R1, R1_CHECK_FAILED_SAVE
    LD R2, R2_CHECK_FAILED_SAVE
    LD R4, R4_CHECK_FAILED_SAVE
    LD R5, R5_CHECK_FAILED_SAVE
    LD R6, R6_CHECK_FAILED_SAVE
    LD R7, R7_CHECK_FAILED_SAVE

RET

R0_CHECK_FAILED_SAVE .fill #0
R1_CHECK_FAILED_SAVE .fill #0
R2_CHECK_FAILED_SAVE .fill #0
R4_CHECK_FAILED_SAVE .fill #0
R5_CHECK_FAILED_SAVE .fill #0
R6_CHECK_FAILED_SAVE .fill #0
R7_CHECK_FAILED_SAVE .fill #0
MINUS_55 .fill #-55

;Reuse of div and printnum from hw2 (with no negative in printnum, since we don't need).

PrintNum:
;Storing the previous values, so in case we overrite them, in the end we will return the right values (as a safety precaution)
ST R0, R0_PRINTNUM_SAVE
ST R1, R1_PRINTNUM_SAVE
ST R2, R2_PRINTNUM_SAVE
ST R3, R3_PRINTNUM_SAVE
ST R4, R4_PRINTNUM_SAVE
ST R5, R5_PRINTNUM_SAVE
ST R6, R6_PRINTNUM_SAVE
ST R7, R7_PRINTNUM_SAVE

;Reset The R5
AND R5 R5 #0;R5=0


PRE_GETDIGIT_LOOP:;Pre loop, getting all the needed stuff for the loop itself
AND R1,R1,#0  ;Reset R1
ADD R1,R1,#10 ;R1=0
LEA R4, ARR_PRINTNUM ;R4=Adress of Arr[5]
ADD R5,R4,#0 ;Will be the start of the arr
;Will go to Get_digits_loop
;BR GET_DIGITS_LOOP;Good habit, not necessary

GET_DIGITS_LOOP:;The loop we will get the digit in, obviously in reverse order, than in the other loop, we will print them from the end to the start
    JSR Div;Calling the div function. we will get the results in R2 and R3 (R3 will be the % of 10)
    STR R3,R4,#0; we put the R3 value in the mem location of R4 => ARR[R4] = R3 , R3 Is the % of 10.
	ADD R4 R4 #1;R4++ ,Going to the next "cell" spot in memory
	ADD R0 R2 #0;R0=R2 (Moving the sum to R0 of the div)
	BRz PRINTNUM_LOOP;Check if R0 (R2 sum) is 0 , if not, continue.
	BR GET_DIGITS_LOOP



PRINTNUM_LOOP:; We will pass throw the array in revrse order of the insertion, thus the print will be in the right order
	ADD R4,R4,#-1              ;R4--
	LDR R0,R4,#0               ;Loading RO = ARR[R4]
	LD R1,ZERO_ASCII_PRINTNUM  ;R1 will get the ASCII value of 0 (48)
	ADD R0,R0,R1               ;Adding 0 Ascii to convert the char to ASCII
	OUT
	ADD R1,R4,#0               ;R1=R4
	NOT R1,R1
	ADD R1,R1,#1               ;R1=-R4
	ADD R1,R1,R5
	BRzp FINISH_PRINTNUM  ;we have reached to the start of the array,so we finished
	BR PRINTNUM_LOOP;Didn't finish yet, keep going

FINISH_PRINTNUM:

;Loading back the values to the registers
LD R0, R0_PRINTNUM_SAVE
LD R1, R1_PRINTNUM_SAVE
LD R2, R2_PRINTNUM_SAVE
LD R3, R3_PRINTNUM_SAVE
LD R4, R4_PRINTNUM_SAVE
LD R5, R5_PRINTNUM_SAVE
LD R6, R6_PRINTNUM_SAVE
LD R7, R7_PRINTNUM_SAVE


RET

R0_PRINTNUM_SAVE .fill #0
R1_PRINTNUM_SAVE .fill #0
R2_PRINTNUM_SAVE .fill #0
R3_PRINTNUM_SAVE .fill #0
R4_PRINTNUM_SAVE .fill #0
R5_PRINTNUM_SAVE .fill #0
R6_PRINTNUM_SAVE .fill #0
R7_PRINTNUM_SAVE .fill #0
ZERO_ASCII_PRINTNUM .fill #48

ARR_PRINTNUM .blkw #5 ;An array in the size of 5.


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


Combine_Students:
;Input R1 - course1 students
;Input R2 - course2 stduents
;Input R3 - course3 students
;Input R4 - course 1 size
;Input R5 - course 2 size
;Input R5 - course 3 size

ST R0, R0_COMBINE_STUDENT_SAVE
ST R1, R1_COMBINE_STUDENT_SAVE
ST R2, R2_COMBINE_STUDENT_SAVE
ST R3, R3_COMBINE_STUDENT_SAVE
ST R4, R4_COMBINE_STUDENT_SAVE
ST R5, R5_COMBINE_STUDENT_SAVE
ST R6, R6_COMBINE_STUDENT_SAVE
ST R7, R7_COMBINE_STUDENT_SAVE

;We store the courses size so we can work with them later (and use the registers for something else).
;ST R0, TOP6ADDRESS
ST R4, COURSE_1_SIZE
ST R5, COURSE_2_SIZE
ST R6, COURSE_3_SIZE


LEA R4,CombinedCoursesData
LD R5, COURSE_1_SIZE
LOOP_COMBINE_COURSE1:

ADD R5,R5,#0
BRz END_LOOP_COMBINE_COURSE1


;HW1+HW2+HW3+HW4+Average
;HW1
LDR R6,R1,#0
STR R6,R4,#0
;HW2
LDR R6,R1,#1
STR R6,R4,#1

;HW3
LDR R6,R1,#2
STR R6,R4,#2

;Middle_test
LDR R6,R1,#3
STR R6,R4,#3

;Average
LDR R6,R1,#4
STR R6,R4,#4

;Advancing the array.
ADD R5,R5,#-1
ADD R4,R4,#7
ADD R1,R1,#7
BR LOOP_COMBINE_COURSE1

END_LOOP_COMBINE_COURSE1:


LD R5, COURSE_2_SIZE
LOOP_COMBINE_COURSE2:

ADD R5,R5,#0
BRz END_LOOP_COMBINE_COURSE2


;HW1+HW2+HW3+HW4+Average
;HW1
LDR R6,R2,#0
STR R6,R4,#0
;HW2
LDR R6,R2,#1
STR R6,R4,#1

;HW3
LDR R6,R2,#2
STR R6,R4,#2

;Middle_test
LDR R6,R2,#3
STR R6,R4,#3

;Average
LDR R6,R2,#4
STR R6,R4,#4

;Advancing the array.
ADD R5,R5,#-1
ADD R4,R4,#7
ADD R2,R2,#7
BR LOOP_COMBINE_COURSE2

END_LOOP_COMBINE_COURSE2:


LD R5, COURSE_3_SIZE
LOOP_COMBINE_COURSE3:

ADD R5,R5,#0
BRz END_LOOP_COMBINE_COURSE3


;HW1+HW2+HW3+HW4+Average
;HW1
LDR R6,R3,#0
STR R6,R4,#0
;HW2
LDR R6,R3,#1
STR R6,R4,#1

;HW3
LDR R6,R3,#2
STR R6,R4,#2

;Middle_test
LDR R6,R3,#3
STR R6,R4,#3

;Average
LDR R6,R3,#4
STR R6,R4,#4

;Advancing the array.
ADD R5,R5,#-1
ADD R4,R4,#7
ADD R3,R3,#7
BR LOOP_COMBINE_COURSE3

END_LOOP_COMBINE_COURSE3:

LD R0, TOP6ADDRESS
LEA R1, CombinedCoursesData
;Getting the size of the array for the best student
AND R2,R2,#0
LD R5, COURSE_1_SIZE
ADD R2,R2,R5
LD R5, COURSE_2_SIZE
ADD R2,R2,R5
LD R5, COURSE_3_SIZE
ADD R2,R2,R5
JSR BestStudent

;Print the promot
LEA R0,TOP_6_PROMOT
PUTS

LD R1,TOP6ADDRESS
JSR PRINT_TOP_6

;Print new line
AND R0,R0,#0
ADD R0,R0,#10
OUT



LD R0, R0_COMBINE_STUDENT_SAVE
LD R1, R1_COMBINE_STUDENT_SAVE
LD R2, R2_COMBINE_STUDENT_SAVE
LD R3, R3_COMBINE_STUDENT_SAVE
LD R4, R4_COMBINE_STUDENT_SAVE
LD R5, R5_COMBINE_STUDENT_SAVE
LD R6, R6_COMBINE_STUDENT_SAVE
LD R7, R7_COMBINE_STUDENT_SAVE

RET

R0_COMBINE_STUDENT_SAVE .fill #0
R1_COMBINE_STUDENT_SAVE .fill #0
R2_COMBINE_STUDENT_SAVE .fill #0
R3_COMBINE_STUDENT_SAVE .fill #0
R4_COMBINE_STUDENT_SAVE .fill #0
R5_COMBINE_STUDENT_SAVE .fill #0
R6_COMBINE_STUDENT_SAVE .fill #0
R7_COMBINE_STUDENT_SAVE .fill #0
COURSE_1_SIZE .fill #0
COURSE_2_SIZE .fill #0
COURSE_3_SIZE .fill #0
TOP_6_PROMOT .STRINGZ "The six highest scores are: "
TOP6ADDRESS .BLKW 6
CombinedCoursesData .BLKW 210

.END

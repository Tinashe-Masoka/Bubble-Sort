.global Sort
.global printf
.global cr
.extern value
.extern getstring
.syntax unified

.text
Sort:

/* Push all the necessary registers onto the stack to preserve the state */
PUSH {R14}       /* Save the Link Register (return address) */
PUSH {R0}        /* Save R0 */
PUSH {R1}        /* Save R1 */
PUSH {R2}        /* Save R2 */
PUSH {R3}        /* Save R3 */
PUSH {R4}        /* Save R4 */
PUSH {R5}        /* Save R5 */
PUSH {R6}        /* Save R6 */

/* Load the number of elements to sort from the stack (32 bytes offset) */
LDR R5, [R13,#32] /* Number of entries */

/* Initialize variables */
MOV R4, #0       /* Counter R4 for the loop */
SUB R5, #1       /* Adjust the number of elements for zero-indexing */
MOV R6, #0       /* R6 used as a flag for checking if any swaps occurred */
MOV R1, R0       /* R1 points to the start of the array */

/* Start of the sorting loop */
sorting:
CMP R4, R5       /* Compare counter with number of elements */
BEQ check        /* If counter == number of elements, go to check */

LDR R2, [R1]     /* Load current element into R2 */
LDR R3, [R1,#4]! /* Load next element into R3, increment R1 by 4 */
CMP R2, R3       /* Compare the two elements */
BGT swap         /* If current element > next element, branch to swap */

/* Increment the loop counter and continue sorting */
ADD R4, #1
B sorting

/* Swap the two elements */
swap:
STR R2, [R1]     /* Store the larger element at the higher index */
STR R3, [R1,#-4] /* Store the smaller element at the lower index */
ADD R4, #1       /* Increment the loop counter */
MOV R6, #1       /* Set the flag to indicate a swap occurred */
B sorting        /* Continue sorting */

/* Check if any swaps occurred in the previous pass */
check:
CMP R6, #0       /* Compare the swap flag */
MOV R6, #0       /* Reset the swap flag */
MOV R1, R0       /* Reset the pointer to the start of the array */
MOV R4, #0       /* Reset the loop counter */
BNE sorting      /* If a swap occurred, repeat sorting */

/* Restore the saved registers from the stack */
POP {R6}         /* Restore R6 */
POP {R5}         /* Restore R5 */
POP {R4}         /* Restore R4 */
POP {R3}         /* Restore R3 */
POP {R2}         /* Restore R2 */
POP {R1}         /* Restore R1 */
POP {R0}         /* Restore R0 */
POP {PC}         /* Return to the calling function (pop the Program Counter) */

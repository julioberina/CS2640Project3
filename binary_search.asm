# Who:  Julio Berina
# What: binary_search.asm
# Why:  Perform binary search on a sorted integer array
# When: 11/7/18
# How:  Sort array after inputs, recursively do binary search

.data
array:         .space  200    # 50 integers max
intprompt:     .asciiz "How many integers?  "
intsearch:     .asciiz "\nSearch for which integer?  "
blank:         .asciiz " "
terpri:        .asciiz "\n"

.text
.globl main


main:	# program entry
     la $a0, intprompt

     li $s0, 0     # User input
     li $s1, 50    # max

     li $v0, 4
     syscall

     li $v0, 5
     syscall

     move $s0, $v0

     # Input validation
     # Must be 0 < input <= 50

     slt $t0, $zero, $s0
     beq $t0, 0, exit
     slt $t0, $s1, $s0
     beq $t0, 1, exit

     li $t1, 0     # number of bytes away from base address
     li $t2, 0
     li $t3, 0
     li $t4, 0
     li $t5, 0

getinputs:
     la $s2, array

     li $v0, 5
     syscall

     move $t4, $v0     # t4 stores integer input

check:    # check if current < array element
     beq $t2, $t1, arrayload
     lw $t3, 0($s2)
     slt $t0, $t4, $t3
     bne $t0, $zero, swap
     addi $t2, $t2, 1
     addi $s2, $s2, 4
     j check

swap:     # swap current value with array element
     lw $t5, 0($s2)
     sw $t4, 0($s2)
     li $t4, 0
     move $t4, $t5
     addi $t2, $t2, 1
     addi $s2, $s2, 4
     j check

arrayload:
     sw $t4, 0($s2)
     addi $s2, $s2, 4
     addi $t1, $t1, 1
     li $t2, 0
     bne $t1, $s0, getinputs

readyarray:
     addi $t2, $s2, -4
     li $t5, 0
     la $a0, terpri
     li $v0, 4
     syscall
     la $s2, array

printarray:
     lw $a0, 0($s2)
     li $v0, 1
     syscall
     la $a0, blank
     li $v0, 4
     syscall
     addi $s2, $s2, 4
     addi $t5, $t5, 1
     bne $t5, $s0, printarray

finditem:
     la $a0, intsearch
     li $v0, 4
     syscall

     li $v0, 5
     syscall
     move $s3, $v0

     li $t0, 0
     la $t1, array   # t1 = base address, $t2 already set to last item address
     li $t5, 1       # Defaults to 1, which means value found, 0 not found

     jal bsearch

     move $a0, $t5
     li $v0, 1
     syscall

     j finditem

binarysearch:
     li $t7, 4
     subu $sp, $sp, $t7
     sw $ra, 4($sp)

     subu $t0, $t2, $t1
     bne $t0, 0, search

     move $t4, $t1
     lw $t0, 0($t4)           # Load the item
     beq $s3, $t0, return     # Found
     li $t5, 0                # Set t5 to 0 if item is not found
     j return

search:
     sra $t0, $t0, 3
     sll $t0, $t0, 2
     addu $t4, $t1, $t0
     lw $t0, 0($t4)
     beq $s3, $t0, return
     slt $t6, $s3, $t0
     li $t7, 1
     beq $t6, $t7, look_left    # Keep searching to the left

look_right:
     addiu $t1, $t4, 4
     jal binarysearch     # Recursive call to binary search
     j return             # Finished, return back to caller

look_left:
     move $t2, $t4        # Keep searching to the left
     jal binarysearch     # Recursive call to binary search

return:
     lw $ra, 4($sp)       # Obtain back return address from stack pointer
     addiu $sp, $sp, 4    # Release 4 bytes on stack

     j $ra                # Return to caller

exit:
     li $v0, 10
     syscall

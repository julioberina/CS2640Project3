# Who:  Julio Berina
# What: binary_search.asm
# Why:  Perform binary search on a sorted integer array
# When: 11/7/18
# How:  Sort array after inputs, recursively do binary search

.data
array:         .space  200    # 50 integers max
intprompt:     .asciiz "How many integers?  "
intsearch:     .asciiz "Search for which integer?  "
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

exit:
     li $v0, 10          # terminate the program
     syscall

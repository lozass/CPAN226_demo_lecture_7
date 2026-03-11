# MIPS32 assembly (MARS/SPIM syscall convention)
# Computes -2 + 1024 and prints the numeric result.

.data
newline: .asciiz "\n"

.text
.globl main

main:
    li   $t0, -2           # t0 = -2
    li   $t1, 1024         # t1 = 1024
    addu $t2, $t0, $t1     # t2 = 1022

    # print integer in $t2
    move $a0, $t2
    li   $v0, 1            # print_int
    syscall

    # print newline
    la   $a0, newline
    li   $v0, 4            # print_string
    syscall

    # exit
    li   $v0, 10
    syscall

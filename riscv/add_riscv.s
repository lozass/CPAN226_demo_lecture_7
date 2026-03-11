# RISC-V (RV32) assembly for RARS
# Computes -2 + 1024 and prints the numeric result.

.text
.globl main

main:
    li a0, -2           # a0 = -2
    li t0, 1024         # t0 = 1024
    add a0, a0, t0      # a0 = 1022

    # print integer in a0
    li a7, 1            # print integer (RARS syscall)
    ecall

    # print newline
    li a0, 10           # '\n'
    li a7, 11           # print character
    ecall

    # exit
    li a7, 10
    ecall

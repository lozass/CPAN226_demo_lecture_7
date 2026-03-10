.syntax unified
.cpu cortex-m3
.thumb

.ifndef DEBUG_BUILD
.equ DEBUG_BUILD, 0
.endif

.equ SYS_WRITE0, 0x04
.equ SYS_EXIT, 0x18

.section .isr_vector, "a", %progbits
.word _estack
.word Reset_Handler + 1

.section .rodata, "a", %progbits
divisors:
    .word 1000, 100, 10, 1

.bss
.align 2
outbuf:
    .space 16

.text

.thumb_func
.global Reset_Handler
.type Reset_Handler, %function

.extern _estack
.global main
.type main, %function

Reset_Handler:
    bl main

.if DEBUG_BUILD
    b halt
.else
    bl semihost_exit
.endif

halt:
    b halt

.thumb_func
main:
    push {lr}
    movs r0, #2
    rsbs r0, r0, #0      @ r0 = -2
    movw r1, #1024       @ r1 = 1024
    adds r0, r0, r1      @ r0 = 1022
    bl print_int
    movs r0, #0
    pop {pc}

.thumb_func
print_int:
    push {r1-r7, lr}

    ldr r1, =outbuf
    movs r6, #0          @ started flag

    cmp r0, #0
    bge print_digits

    movs r2, #'-'
    strb r2, [r1], #1
    rsbs r0, r0, #0

print_digits:
    ldr r4, =divisors
    movs r5, #4

next_divisor:
    ldr r3, [r4], #4
    movs r2, #'0'

count_digit:
    cmp r0, r3
    blt digit_ready
    subs r0, r0, r3
    adds r2, r2, #1
    b count_digit

digit_ready:
    cmp r6, #0
    bne store_digit
    cmp r2, #'0'
    bne mark_started
    cmp r5, #1
    beq store_digit
    b skip_digit

mark_started:
    movs r6, #1

store_digit:
    strb r2, [r1], #1

skip_digit:
    subs r5, r5, #1
    bne next_divisor

    movs r2, #'\n'
    strb r2, [r1], #1
    movs r2, #0
    strb r2, [r1]

    movs r0, #SYS_WRITE0
    ldr r1, =outbuf
    bkpt 0xAB

    pop {r1-r7, pc}

.thumb_func
semihost_exit:
    ldr r1, =0x20026
    movs r0, #SYS_EXIT
    bkpt 0xAB
    bx lr

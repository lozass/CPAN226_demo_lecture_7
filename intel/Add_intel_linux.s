# x86-64 Intel-syntax GNU assembler (Linux)
# Computes -2 + 1024 and prints 1022 with a newline using syscalls.

.intel_syntax noprefix
.global _start

.section .bss
buf: .space 32

.section .text
_start:
    mov eax, -2
    mov ecx, 1024
    add eax, ecx                    # EAX = 1022

    lea rdi, [rip + buf + 31]
    mov byte ptr [rdi], 0x0A        # trailing newline
    mov ecx, 1                      # output length starts at newline
    xor r10d, r10d                  # sign flag

    test eax, eax
    jns convert_digits
    neg eax
    mov r10b, 1

convert_digits:
    mov r11d, 10

convert_loop:
    xor edx, edx
    div r11d                        # EDX:EAX / 10
    dec rdi
    add dl, '0'
    mov byte ptr [rdi], dl
    inc ecx
    test eax, eax
    jnz convert_loop

    test r10b, r10b
    jz write_out
    dec rdi
    mov byte ptr [rdi], '-'
    inc ecx

write_out:
    # write(1, rdi, ecx)
    mov rsi, rdi                    # buf
    mov edx, ecx                    # count
    mov eax, 1                      # SYS_write
    mov edi, 1                      # fd = stdout
    syscall

    # exit(0)
    mov eax, 60                     # SYS_exit
    xor edi, edi
    syscall

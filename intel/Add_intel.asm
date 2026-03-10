# Intel-syntax x64 assembly (GNU assembler)
# Prints using WriteConsoleA (kernel32) directly - no C runtime needed.

.intel_syntax noprefix
.global main
.extern GetStdHandle
.extern WriteConsoleA

.data
buf:     .space 16
buf_ptr: .quad 0
buf_len: .long 0
written: .long 0

.text
main:
    sub rsp, 40                     # 32 shadow + 8 alignment

    mov eax, -2
    mov ecx, 1024
    add eax, ecx                    # EAX = 1022

    lea rdi, [rip + buf + 15]
    mov BYTE PTR [rdi], 0x0A        # trailing newline
    mov ecx, 1                      # output length starts at the newline
    xor r10d, r10d                  # sign flag

    test eax, eax
    jns convert_digits
    neg eax
    mov r10b, 1

convert_digits:
    mov r11d, 10

convert_loop:
    xor edx, edx
    div r11d                        # unsigned divide EDX:EAX by 10
    dec rdi
    add dl, '0'
    mov BYTE PTR [rdi], dl
    inc ecx
    test eax, eax
    jnz convert_loop

    test r10b, r10b
    jz have_output
    dec rdi
    mov BYTE PTR [rdi], '-'
    inc ecx

have_output:
    mov QWORD PTR [rip + buf_ptr], rdi
    mov DWORD PTR [rip + buf_len], ecx

    # --- GetStdHandle(STD_OUTPUT_HANDLE = -11) ---
    mov ecx, -11                    # STD_OUTPUT_HANDLE
    call GetStdHandle               # RAX = stdout console handle

    # --- WriteConsoleA(handle, buf, len, &written, NULL) ---
    mov rcx, rax                    # arg1: console handle
    mov rdx, QWORD PTR [rip + buf_ptr]
    mov r8d, DWORD PTR [rip + buf_len]
    lea r9, [rip + written]         # arg4: pointer to chars-written count
    mov QWORD PTR [rsp + 32], 0     # arg5: NULL (reserved)
    call WriteConsoleA

    add rsp, 40

    xor eax, eax                    # return 0
    ret
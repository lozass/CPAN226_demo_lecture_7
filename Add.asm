# Intel-syntax x64 assembly (GNU assembler)
# Prints using WriteConsoleA (kernel32) directly - no C runtime needed.

.intel_syntax noprefix
.global main
.extern GetStdHandle
.extern WriteConsoleA

.data
buf:     .byte '?', 0x0A       # digit placeholder + newline (filled at runtime)
written: .long 0

.text
main:
    mov eax, -2
    mov ebx, 1024
    add eax, ebx                    # EAX = 1022

    # Convert single digit to ASCII: 8 + '0' (48) = '8' (56)
    add al, '0'
    mov BYTE PTR [rip + buf], al    # store ASCII digit into buf

    # --- GetStdHandle(STD_OUTPUT_HANDLE = -11) ---
    sub rsp, 40                     # 32 shadow + 8 alignment
    mov ecx, -11                    # STD_OUTPUT_HANDLE
    call GetStdHandle               # RAX = stdout console handle
    add rsp, 40

    # --- WriteConsoleA(handle, buf, 2, &written, NULL) ---
    sub rsp, 40                     # 32 shadow + 8 for 5th arg on stack
    mov rcx, rax                    # arg1: console handle
    lea rdx, [rip + buf]            # arg2: pointer to "8\n"
    mov r8d, 2                      # arg3: number of chars to write
    lea r9, [rip + written]         # arg4: pointer to chars-written count
    mov QWORD PTR [rsp + 32], 0     # arg5: NULL (reserved)
    call WriteConsoleA
    add rsp, 40

    xor eax, eax                    # return 0
    ret
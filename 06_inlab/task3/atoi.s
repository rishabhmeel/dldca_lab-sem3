section .bss
    buf: resb 256

section .text
    global _start

; my_atoi(const char* buf{rdi}, size_t len{rsi}) -> uint64_t{rax}
my_atoi:
    ; TODO
    push rbx
    xor rbx, rbx

.forstr:
    test rsi, rsi
    jz .done

    movzx rcx, byte [rdi]
    sub rcx, '0'

    cmp rcx, 9
    ja .done

    imul rbx, rbx, 10
    add rbx, rcx

    inc rdi
    dec rsi
    jmp .forstr

.done:
    mov rax, rbx
    pop rbx
    ret

_start:
    ; TODO: read a line from stdin into buf, call my_atoi, exit with the result

    mov rax,0
    mov rdi,0
    lea rsi,[buf]
    mov rdx,256
    syscall

    mov rsi,rax
    lea rdi,[buf]
    call my_atoi

    mov rdi,rax

    mov rax, 60

    syscall

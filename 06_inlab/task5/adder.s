extern printf
extern exit

section .rodata
    fmt: db "sum = %ld", 10, 0

section .bss
    inbuf: resb 256

section .text
    global _start

; my_atoi(const char* buf{rdi}, size_t len{rsi}) -> uint64_t{rax}
my_atoi:
    ; TODO: copy from Task 3
    push rbx
    xor rcx,rcx
    xor rbx,rbx
    .forstr:
    movzx rcx, byte [rdi]
    cmp rcx,10
    je .done
    sub rcx,'0'
    imul rbx,rbx,10
    add rbx,rcx
    dec rsi
    inc rdi
    cmp rsi,1
    jne .forstr
    mov rax,rbx
.done:
    pop rbx
    ret

_start:
    ; TODO: read two numbers from stdin, add them, then
    ;       printf("sum = %ld\n", sum). exit(0).
    and rsp,-16

    xor rax,rax
    xor rdi,rdi
    lea rsi, [inbuf]
    mov rdx,256
    syscall
    
    lea rdi,[inbuf]
    mov rsi,rax
    call my_atoi

    mov rbx,rax

    xor rax,rax
    xor rdi,rdi
    lea rsi, [inbuf]
    mov rdx,256
    syscall
    
    lea rdi,[inbuf]
    mov rsi,rax
    call my_atoi

    add rbx,rax

    xor rax,rax
    
    lea rdi, [fmt]
    mov rsi,rbx
    call printf

    xor edi, edi
    call exit

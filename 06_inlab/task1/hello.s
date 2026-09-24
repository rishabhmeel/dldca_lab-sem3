section .data
    greeting: db "Hello "
    greeting_len equ $ - greeting
    buf: times 512 db 0

section .text
    global _start

_start:
    ; TODO: read a line from stdin (fd 0), then print "Hello " followed by the
    ;       bytes you read to stdout (fd 1) using a SINGLE write syscall. Exit 0.
    xor rax,rax
    xor rdi,rdi
    lea rsi, [buf]
    mov rdx, 512
    syscall

    mov rdx,rax
    add rdx,6
    mov rax,1
    mov rdi,1
    lea rsi, [greeting]
    syscall
    

    mov rax, 60
    xor edi, edi
    syscall

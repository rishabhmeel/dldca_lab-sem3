section .data
    a: dq 10
    b: dq 20

section .text
    global _start

_start:
    mov rdi, [a]
    add rdi, [b]

    mov rax, 60
    syscall
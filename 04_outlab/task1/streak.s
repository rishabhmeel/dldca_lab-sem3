section .data
    values:
        dq 4, 4, 4, 7, 7, 2, 2, 2, 2, 9, 9, 1, 7, 7, 7
    .end:
    n equ (values.end - values)/8

    ;; longest run of consecutive equal values is 4 by default

section .text
    global _start

_start:
;   find the length of the longest run of consecutive equal values in
;   `values`, and exit with that length
    xor rcx,rcx
    mov rsi,1
    xor rdi,rdi
    inc rcx
.forbegin:
    mov rax, qword [values + rcx*8 -8]
    mov rbx, qword [values +rcx*8]
    cmp rax,rbx
    jne .else
    inc rsi
    jmp .endt
.else:
    cmp rdi, rsi
    cmovl rdi,rsi
    mov rsi,1
.endt:
    inc rcx
    cmp rcx, n
    jne .forbegin
    cmp rdi,rsi
    cmovl rdi,rsi

    mov rax, 60
    syscall

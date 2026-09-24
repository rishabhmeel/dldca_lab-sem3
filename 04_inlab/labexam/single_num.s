section .data
    array: 
        dd 3, 6, 1, 42, 8, 1, 3, 6, 8
    .end:
    array_len equ (array.end - array)/4

section .text
    global _start


_start:
    xor rdi, rdi
    xor rcx, rcx
.forbegin:
    mov eax, dword [array +4*rcx]
    xor edi, eax
    inc rcx
    cmp rcx, array_len
    jl .forbegin
.forend:

    mov eax, 60
    syscall
    
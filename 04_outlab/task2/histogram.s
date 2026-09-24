section .data
    text:
        db "mississippi"
    .end:
    text_len equ (text.end - text)

    counts: times 26 dd 0

    ;; the most common letter's count is 4 by default

section .text
    global _start

_start:
;   build a histogram of letter counts into `counts` (counts[c - 'a']
;   for each byte c in `text`), then exit with the highest count found
;   in `counts`
    xor rcx,rcx

    .wordloop:
        movzx rax, byte [text + rcx]
        sub rax, 'a'
        lea rbx, [counts + 4*rax]
        inc dword [rbx]
        inc rcx
        cmp rcx, text_len
        jl .wordloop


    xor rcx, rcx
    xor rdi, rdi
    .countloop:
        movzx rax, dword [counts+4*rcx]
        cmp rdi, rax
        cmovl rdi,rax
        inc rcx
        cmp rcx, 26
        jl .countloop


    mov rax, 60
    syscall

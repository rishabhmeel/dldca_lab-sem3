section .text
    global _start

; div_by_10(uint64_t n{rdi}) -> uint64_t{rax}
div_by_10:
    ; TODO
    mov rax,rdi
    shr rax,1
    mov rcx,5
    div rcx
    mov rdi,rax
    ret

_start:
    ; TODO: call div_by_10(250), exit with the result

    mov rdi,250

    call div_by_10

    mov rax, 60
    syscall

section .text
    global _start

; div_by_10(uint64_t n{rdi}) -> uint64_t{rax}
div_by_10:
    ; TODO
<<<<<<< HEAD
    mov rax,rdi
    shr rax,1
    mov rcx,5
    div rcx
    mov rdi,rax
=======

>>>>>>> main
    ret

_start:
    ; TODO: call div_by_10(250), exit with the result

<<<<<<< HEAD
    mov rdi,250

    call div_by_10

    mov rax, 60
=======
    mov rax, 60
    xor edi, edi
>>>>>>> main
    syscall

extern printf
extern exit

section .data
    fmt: db "gcd = %ld", 10, 0

section .bss
    buf: resb 256 ; so much excess space!

section .text
    global _start

; my_strtol_10(const char* str{rdi}, char** str_end{rsi}) -> rax
; write the address of the first character you do not read in [rsi]
my_strtol_10:
    dec rdi ;makes loop cleaner
    xor rax,rax
    push rbx
.loop:
    inc rdi
    movzx rbx, byte [rdi]
    sub rbx, '0'
    cmp rbx, 9
    ja .end
    lea rax, [rax + 4*rax]
    lea rax, [rbx + 2*rax]
    jmp .loop
    
.end:
    mov [rsi],rdi
    pop rbx

    ret

; gcd(int64_t a{rdi}, int64_t b{rsi}) -> rax
gcd:
    mov rax,rdi
    mov rcx,rsi
.recurse:
    xor rdx,rdx
    div rcx
    cmp rdx,0
    je .done
    mov rax,rcx
    mov rcx,rdx
    jmp .recurse
.done:
    mov rax,rcx    
    ret

_start:
    and rsp, -16
;   Read "A B" (space-separated) from stdin in ONE read syscall, parse both
;   numbers with my_strtol_10 (skipping the separator through strtol),
;   and printf("gcd = %ld\n", gcd(A, B)).

    lea rsi,[rel buf]
    mov rax,0
    mov rdi, 0
    mov rdx,256
    syscall

    mov rdi,rsi
    lea rsi,[buf+rax]
    call my_strtol_10

    mov rbx, rax
    mov rdi,[rsi]
    inc rdi
    call my_strtol_10

    mov rdi, rbx
    mov rsi, rax
    call gcd

    lea rdi, [rel fmt]
    mov rsi, rax
    call printf
    


    xor edi, edi
    call exit

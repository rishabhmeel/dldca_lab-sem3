extern printf
extern exit
extern scanf

section .rodata
    infmt: db "%ld %ld", 0
    outfmt: db "gcd = %ld", 10, 0

section .bss
    val_a: resq 1
    val_b: resq 1

section .text
    global _start

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
;   Read two numbers with scanf("%ld %ld", &a, &b), and
;   printf("gcd = %ld\n", gcd(a, b)).

    lea rdi, [infmt]
    lea rsi, [val_a]
    lea rdx, [val_b]
    xor rax,rax
    call scanf
    
    mov rdi,[val_a]
    mov rsi,[val_b]
    call gcd
    
    lea rdi, [outfmt]
    mov rsi, rax
    call printf

    xor edi, edi
    call exit

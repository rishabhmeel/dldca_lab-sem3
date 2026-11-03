section .rodata
    error_msg: db "There should be 3 command line arguments!",10
    .end: db 0 ; null terminator for the TA's mental peace
    error_msg_len equ (error_msg.end-error_msg)

section .text
    global _start

; my_strlen(const char* str{rdi}) -> rax (not counting the null terminator)
my_strlen:
    xor rax, rax
.loop:
    cmp byte [rdi+rax], 0
    je .done
    inc rax
    jmp .loop
.done:
    ret

; my_atoi(const char* str{rdi}) -> rax (handles an optional leading '-')
c

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
;   check argc at [rsp] if it is 3, if not print error_msg and exit.
;   argv[1] is at [rsp+16], argv[2] is at [rsp+24] (argc is at [rsp]).
;   Print argv[1] as-is (using my_strlen + a direct write syscall), then
;   exit with gcd(atoi(argv[1]), atoi(argv[2])).
    
    mov rbx,[rsp]
    cmp rbx,3
    je .else
    mov rax,1
    mov rdi,1
    lea rsi,[error_msg]
    mov rdx, error_msg_len
    syscall
    jmp .donef
.else:
    mov rdi,[rsp+16]
    call my_atoi
    mov r9, rax
    mov rdi,[rsp+24]
    call my_atoi
    mov rsi,rax
    mov rax,r9
    mov rdi,rax
    call gcd


    mov rdi,rax

.donef:
    mov rax, 60
    syscall
